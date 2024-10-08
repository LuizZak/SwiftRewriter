import SwiftAST
import KnownType

public final class ExpressionTypeResolver: SyntaxNodeRewriter {
    private var nearestScopeCache: [ObjectIdentifier: CodeScopeNode] = [:]

    /// In case the expression type resolver is resolving a function context,
    /// this stack is prepared with the expected return types for the current
    /// functions.
    ///
    /// The stack is incremented and decremented as the expression resolver
    /// traverses into block expressions.
    private var contextFunctionReturnTypeStack: [SwiftType?]

    internal var scopeContextStack: [ScopeContext] = []

    public var typeSystem: TypeSystem

    /// Intrinsic variables provided by the type system
    public var intrinsicVariables: DefinitionsSource

    /// If `true`, the expression type resolver ignores resolving expressions that
    /// already have a non-nil `resolvedType` field.
    public var ignoreResolvedExpressions: Bool = false

    public override init() {
        self.typeSystem = TypeSystem.defaultTypeSystem
        self.intrinsicVariables = EmptyCodeScope()
        contextFunctionReturnTypeStack = []
        super.init()
    }

    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
        self.intrinsicVariables = EmptyCodeScope()
        contextFunctionReturnTypeStack = []
        super.init()
    }

    public init(
        typeSystem: TypeSystem,
        intrinsicVariables: DefinitionsSource
    ) {

        self.typeSystem = typeSystem
        self.intrinsicVariables = intrinsicVariables
        contextFunctionReturnTypeStack = []
        super.init()
    }

    public init(
        typeSystem: TypeSystem,
        contextFunctionReturnType: SwiftType
    ) {

        self.typeSystem = typeSystem
        self.intrinsicVariables = EmptyCodeScope()
        contextFunctionReturnTypeStack = [contextFunctionReturnType]
        super.init()
    }

    public init(
        typeSystem: TypeSystem,
        intrinsicVariables: DefinitionsSource,
        contextFunctionReturnType: SwiftType
    ) {

        self.typeSystem = typeSystem
        self.intrinsicVariables = intrinsicVariables
        contextFunctionReturnTypeStack = [contextFunctionReturnType]
        super.init()
    }

    public func pushContainingFunctionReturnType(_ type: SwiftType) {
        contextFunctionReturnTypeStack.append(type)
    }

    public func popContainingFunctionReturnType() {
        contextFunctionReturnTypeStack.removeLast()
    }

    /// Invocates the resolution of all expressions on a given statement recursively.
    public func resolveTypes(in statement: Statement) -> Statement {
        nearestScopeCache = [:]

        // First, clear all variable definitions found, and their usages too.
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                switch node {
                case let scoped as CodeScopeNode:
                    scoped.removeLocalDefinitions()

                case let ident as IdentifierExpression:
                    ident.definition = nil

                case let postfix as PostfixExpression:
                    postfix.op.returnType = nil

                default:
                    break
                }
            }

        visitor.visitStatement(statement)

        // Now visit the nodes
        return visitStatement(statement)
    }

    /// Invocates the resolution of a given expression's type.
    public func resolveType(_ exp: Expression) -> Expression {
        exp.accept(self)
    }

    // MARK: - Definition Collection
    public override func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) -> StatementVariableDeclaration {
        var type = decl.type

        decl.initialization?.expectedType = type
        decl.initialization = decl.initialization.map(visitExpression)

        // TODO: This optionality promotion should probably be reserved to
        // expression passes only.
        if !typeSystem.isScalarType(decl.type) && decl.ownership != .weak,
            let initValueType = decl.initialization?.resolvedType {

            type = type.withSameOptionalityAs(initValueType)

            // Promote implicitly unwrapped optionals to full optionals
            if initValueType.canBeImplicitlyUnwrapped {
                type = .optional(type.unwrapped)
            }
        }

        let definition = CodeDefinition
            .forLocalIdentifier(
                decl.identifier,
                type: type,
                ownership: decl.ownership,
                isConstant: decl.isConstant,
                location: .variableDeclaration(decl)
            )

        nearestScope(for: decl)?.recordDefinition(definition, overwrite: true)

        return super.visitStatementVariableDeclaration(decl)
    }

    public override func visitCatchBlock(_ catchBlock: CatchBlock) -> CatchBlock {
        catchBlock
        .body
        .recordDefinition(
            .forCatchBlockPattern(catchBlock),
            overwrite: true
        )

        return super.visitCatchBlock(catchBlock)
    }

    public override func visitFor(_ stmt: ForStatement) -> Statement {
        // Define loop variables
        if stmt.exp.resolvedType == nil {
            stmt.exp = resolveType(stmt.exp)
        }

        let iteratorResolver = makeIteratorTypeResolver()

        // TODO: Move this responsibility to `TypeSystem`?

        let iteratorType: SwiftType

        if let type = stmt.exp.resolvedType {
            iteratorType = iteratorResolver.iterationElementType(for: type) ?? .errorType
        } else {
            iteratorType = .errorType
        }

        collectInPattern(
            stmt.pattern,
            type: iteratorType,
            locationDeriver: { .forLoop(stmt, $0) },
            context: [.declaration, .constant],
            to: stmt.body
        )

        _=super.visitFor(stmt)

        return stmt
    }

    public override func visitConditionalClauseElement(_ clause: ConditionalClauseElement) -> ConditionalClauseElement {
        if let pattern = clause.pattern {
            let result = super.visitConditionalClauseElement(clause)
            guard let scope = nearestScope(for: clause) else {
                return result
            }

            var bindingContext: PatternMatcher.PatternBindingContext = [.constant]

            // Detect optional binding contexts
            switch pattern {
            case .identifier, .valueBindingPattern(_, .identifier):
                // TODO: Refactor this context detecting hack as an explicit flag
                // TODO: in the conditional clause instead
                guard
                    scope is IfStatement ||
                    scope is WhileStatement ||
                    clause.parent?.parent is GuardStatement
                else {
                    break
                }

                bindingContext.insert(.optionalBinding)
            default:
                break
            }

            collectInPattern(
                pattern,
                type: clause.expression.resolvedType ?? .errorType,
                locationDeriver: { .conditionalClause(clause, $0) },
                context: bindingContext,
                to: scope
            )

            return result
        }

        clause.expression.expectedType = .bool

        return super.visitConditionalClauseElement(clause)
    }

    public override func visitGuard(_ stmt: GuardStatement) -> Statement {
        // Visit out of order: We first visit the guard statement, and then the
        // conditional clauses.
        _=visitCompound(stmt.elseBody)

        stmt.conditionalClauses = visitConditionalClauses(stmt.conditionalClauses)
        return stmt
    }

    public override func visitRepeatWhile(_ stmt: RepeatWhileStatement) -> Statement {
        stmt.exp.expectedType = .bool

        return super.visitRepeatWhile(stmt)
    }

    public override func visitLocalFunction(_ stmt: LocalFunctionStatement) -> Statement {
        // Apply definitions for function parameters
        stmt.function.body.recordDefinitions(
            CodeDefinition.forParameters(stmt.function.parameters),
            overwrite: true
        )

        // Apply definition for function itself before processing its contents
        // This allows for recursion to occur if the function calls itself.
        let definition = CodeDefinition.forLocalFunctionStatement(stmt)
        nearestScope(for: stmt)?.recordDefinition(definition, overwrite: true)

        // Push context of return type during expression resolving
        pushContainingFunctionReturnType(stmt.function.returnType)
        defer {
            popContainingFunctionReturnType()
        }

        return super.visitLocalFunction(stmt)
    }

    public override func visitThrow(_ stmt: ThrowStatement) -> Statement {
        stmt.exp.expectedType = "Error"

        return super.visitThrow(stmt)
    }

    public override func visitReturn(_ stmt: ReturnStatement) -> Statement {
        if let lastType = contextFunctionReturnTypeStack.last {
            stmt.exp?.expectedType = lastType
        }

        return super.visitReturn(stmt)
    }

    func collectInPattern(
        _ pattern: Pattern,
        type: SwiftType,
        locationDeriver: (PatternLocation) -> LocalCodeDefinition.DefinitionLocation,
        context: PatternMatcher.PatternBindingContext,
        to scope: CodeScope
    ) {
        let patternMatcher = makePatternMatcher()

        let bindings = patternMatcher.match(pattern: pattern, to: type, context: context)

        for binding in bindings {
            scope.recordDefinition(
                .forLocalIdentifier(
                    binding.identifier,
                    type: binding.type,
                    isConstant: binding.isConstant,
                    location: locationDeriver(binding.patternLocation)
                ),
                overwrite: true
            )
        }
    }

    // MARK: - Expression Resolving

    public override func visitExpression(_ exp: Expression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        return super.visitExpression(exp)
    }

    public override func visitParens(_ exp: ParensExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        // Propagate expected type
        exp.exp.expectedType = exp.expectedType

        _=super.visitParens(exp)

        exp.resolvedType = exp.exp.resolvedType

        return exp
    }

    public override func visitConstant(_ exp: ConstantExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        switch exp.constant {
        case .int:
            if let expected = exp.expectedType, typeSystem.category(forType: expected) == .integer {
                exp.resolvedType = expected
            } else {
                exp.resolvedType = .int
            }
        case .string:
            exp.resolvedType = .string

        case .float, .double:
            if let expected = exp.expectedType, typeSystem.category(forType: expected) == .float {
                exp.resolvedType = expected
            } else {
                exp.resolvedType = .double
            }

        case .boolean:
            exp.resolvedType = .bool

        case .nil:
            exp.resolvedType = .optional(.anyObject)

            if let expectedType = exp.expectedType {
                switch expectedType {
                case .optional,
                     .implicitUnwrappedOptional,
                     .nullabilityUnspecified:
                    exp.resolvedType = exp.expectedType

                default:
                    if !typeSystem.isScalarType(expectedType) {
                        exp.resolvedType = .optional(expectedType)
                    }
                }
            }
        case .rawConstant:
            exp.resolvedType = .any
        }

        return super.visitConstant(exp)
    }

    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        switch exp.op.category {
        case .logical:
            exp.exp.expectedType = .bool
        default:
            break
        }

        _=super.visitUnary(exp)

        // Propagate error type
        if exp.exp.isErrorTyped {
            return exp.makeErrorTyped()
        }

        guard let type = exp.exp.resolvedType else {
            return exp
        }

        switch exp.op {
        case .negate where type == .bool:
            exp.resolvedType = .bool

        case .subtract, .add:
            if typeSystem.isNumeric(type) {
                exp.resolvedType = type
            }

        case .bitwiseNot where typeSystem.isInteger(type):
            exp.resolvedType = type

        default:
            break
        }

        return exp
    }

    public override func visitCast(_ exp: CastExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitCast(exp)

        // Propagate error type
        if exp.exp.isErrorTyped {
            return exp.makeErrorTyped()
        }

        let type = exp.type

        // Same-type casts always succeed
        if let resolvedType = exp.exp.resolvedType,
            typeSystem.isType(resolvedType, assignableTo: type) {

            exp.resolvedType = type
            exp.isOptionalCast = false
            return exp
        }

        exp.resolvedType = .optional(type)
        exp.isOptionalCast = true

        return exp
    }

    public override func visitAssignment(_ exp: AssignmentExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        exp.lhs = visitExpression(exp.lhs)
        exp.rhs.expectedType = exp.lhs.resolvedType
        exp.rhs = visitExpression(exp.rhs)

        // Propagate error type
        if exp.lhs.isErrorTyped || exp.rhs.isErrorTyped {
            return exp.makeErrorTyped()
        }

        exp.resolvedType = exp.lhs.resolvedType

        return exp
    }

    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        // Preset logical operator expectations
        if exp.op.category == .logical {
            exp.lhs.expectedType = .bool
            exp.rhs.expectedType = .bool
        }

        exp.lhs = visitExpression(exp.lhs)

        switch exp.op.category {
        case .nullCoalesce:
            exp.rhs.expectedType = exp.lhs.resolvedType?.deepUnwrapped

        default:
            break
        }

        exp.rhs = visitExpression(exp.rhs)

        // Propagate error type
        if exp.lhs.isErrorTyped || exp.rhs.isErrorTyped {
            // Try to deduce some common operations before propagating the error
            // type
            switch exp.op.category {
            case .comparison:
                exp.resolvedType = .bool
                return exp
            default:
                break
            }

            return exp.makeErrorTyped()
        }

        switch exp.op.category {
        case .arithmetic:
            guard let lhsType = exp.lhs.resolvedType else {
                break
            }

            if !typeSystem.isNumeric(lhsType) {
                break
            }

            if exp.lhs.resolvedType == exp.rhs.resolvedType {
                exp.resolvedType = exp.lhs.resolvedType
            } else if let rhsType = exp.rhs.resolvedType {
                // Check coercion
                if canCoerce(exp.lhs, toType: rhsType) {
                    exp.lhs.expectedType = rhsType
                    exp.resolvedType = rhsType
                } else if canCoerce(exp.rhs, toType: lhsType) {
                    exp.rhs.expectedType = lhsType
                    exp.resolvedType = lhsType
                }
            }

        case .comparison:
            exp.resolvedType = .bool

        case .logical where exp.lhs.resolvedType == .bool && exp.rhs.resolvedType == .bool:
            exp.resolvedType = .bool

        case .bitwise where exp.op != .bitwiseNot && exp.lhs.resolvedType == exp.rhs.resolvedType:
            guard let type = exp.lhs.resolvedType else {
                break
            }

            if !typeSystem.isInteger(type) {
                break
            }

            exp.resolvedType = exp.lhs.resolvedType

        case .nullCoalesce where exp.lhs.resolvedType?.deepUnwrapped == exp.rhs.resolvedType?.deepUnwrapped:
            // Return rhs' nullability
            exp.resolvedType = exp.rhs.resolvedType

        case .range where exp.lhs.resolvedType == exp.rhs.resolvedType:
            guard let resolvedType = exp.lhs.resolvedType else {
                break
            }

            switch exp.op {
            case .openRange:
                exp.resolvedType = .openRange(resolvedType)

            case .closedRange:
                exp.resolvedType = .closedRange(resolvedType)

            default:
                break
            }

        default:
            break
        }

        return exp
    }

    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitIdentifier(exp)

        // Visit identifier's type from current context
        if let definition = searchIdentifierDefinition(exp) {
            exp.definition = definition
            exp.resolvedType = definition.type
            exp.isReadOnlyUsage = isReadOnlyContext(exp)
        } else {
            exp.definition = nil
            exp.resolvedType = .errorType
        }

        return exp
    }

    public override func visitTernary(_ exp: TernaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        exp.exp.expectedType = .bool

        _=super.visitTernary(exp)

        // Propagate error type
        if exp.ifTrue.isErrorTyped || exp.ifFalse.isErrorTyped {
            return exp.makeErrorTyped()
        }

        if exp.ifTrue.resolvedType == exp.ifFalse.resolvedType {
            exp.resolvedType = exp.ifTrue.resolvedType
        } else {
            return exp.makeErrorTyped()
        }

        return exp
    }

    public override func visitSizeOf(_ exp: SizeOfExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitSizeOf(exp)

        exp.resolvedType = .int

        return exp
    }

    // MARK: - Postfix type resolving
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        let resolver = MemberInvocationResolver(typeSystem: typeSystem, typeResolver: self)
        let result = resolver.resolve(postfix: exp, op: exp.op)

        func hasOptional(_ exp: PostfixExpression, _ op: Postfix) -> Bool {
            if exp.resolvedType?.isOptional == true {
                return true
            }

            if op.optionalAccessKind != .none {
                return true
            }

            if let post = exp.exp.asPostfix {
                return hasOptional(post, post.op)
            }

            return false
        }

        if !exp.isErrorTyped, let type = exp.resolvedType, !type.isOptional, hasOptional(exp, exp.op) {
            exp.resolvedType = .optional(type)
        }

        return result
    }

    // MARK: - Array and Dictionary literal resolving
    public override func visitArray(_ exp: ArrayLiteralExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitArray(exp)

        // Propagate error type
        if exp.items.any({ e in e.isErrorTyped }) {
            exp.makeErrorTyped()
            return exp
        }

        guard let firstType = exp.items.first?.resolvedType else {
            exp.resolvedType = .nsArray
            return exp
        }

        // Check if all items match type-wise
        for item in exp.items where item.resolvedType != firstType {
            exp.resolvedType = .nsArray
            return exp
        }

        exp.resolvedType = .array(firstType)

        return exp
    }

    public override func visitDictionary(_ exp: DictionaryLiteralExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitDictionary(exp)

        // Propagate error type
        if exp.pairs.any({ $0.key.isErrorTyped || $0.value.isErrorTyped }) {
            return exp.makeErrorTyped()
        }

        guard let first = exp.pairs.first else {
            exp.resolvedType = .nsDictionary
            return exp
        }
        guard case let (firstKey?, firstValue?) = (first.key.resolvedType, first.value.resolvedType) else {
            exp.resolvedType = .nsDictionary
            return exp
        }

        // Check if all pairs match type-wise
        for pair in exp.pairs {
            if pair.key.resolvedType != firstKey || pair.value.resolvedType != firstValue {
                exp.resolvedType = .nsDictionary
                return exp
            }
        }

        exp.resolvedType = .dictionary(key: firstKey, value: firstValue)

        return exp
    }

    public override func visitBlock(_ exp: BlockLiteralExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        var blockReturnType = exp.returnType

        // Adjust signatures of block parameters based on expected type
        if case let .block(block)? = (exp.expectedType?.deepUnwrapped).map(expandAliases),
            block.parameters.count == exp.parameters.count {

            for (i, expectedType) in zip(0..<exp.parameters.count, block.parameters) {
                let param = exp.parameters[i]
                guard param.type.isNullabilityUnspecified else { continue }
                guard param.type.deepUnwrapped == expectedType.deepUnwrapped else { continue }

                exp.parameters[i].type = expectedType
            }

            if blockReturnType.isNullabilityUnspecified &&
                blockReturnType.deepUnwrapped == block.returnType.deepUnwrapped {

                blockReturnType = block.returnType
            }

            exp.resolvedType =
                .block(
                    returnType: blockReturnType,
                    parameters: exp.parameters.map(\.type),
                    attributes: []
                )
        } else {
            exp.resolvedType =
                .block(
                    returnType: exp.returnType,
                    parameters: exp.parameters.map(\.type),
                    attributes: []
                )
        }

        // Apply definitions for function parameters
        exp.recordDefinitions(
            CodeDefinition.forParameters(exp.parameters),
            overwrite: true
        )

        // Push context of return type during expression resolving
        pushContainingFunctionReturnType(blockReturnType)
        defer {
            popContainingFunctionReturnType()
        }

        return super.visitBlock(exp)
    }

    public override func visitSelector(_ exp: SelectorExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        exp.resolvedType = .selector

        return super.visitSelector(exp)
    }

    public override func visitTry(_ exp: TryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }

        _=super.visitTry(exp)

        if exp.exp.isErrorTyped {
            return exp.makeErrorTyped()
        }

        guard let resolvedType = exp.exp.resolvedType else {
            return exp
        }

        switch exp.mode {
        case .forced, .throwable:
            exp.resolvedType = resolvedType
        case .optional:
            exp.resolvedType = .optional(resolvedType)
        }

        return exp
    }

    // MARK: - Internals

    private func canCoerce(_ exp: Expression, toType type: SwiftType) -> Bool {
        makeCoercionVerifier()
            .canCoerce(exp, toType: type)
    }

    private func makeCoercionVerifier() -> CoercionVerifier {
        CoercionVerifier(typeSystem: typeSystem)
    }

    private func makePatternMatcher() -> PatternMatcher {
        PatternMatcher(typeSystem: typeSystem)
    }

    private func makeIteratorTypeResolver() -> IteratorTypeResolver {
        IteratorTypeResolver(typeSystem: typeSystem)
    }

    /// Returns `true` if a given expression is being used in a read-only context.
    private func isReadOnlyContext(_ expression: Expression) -> Bool {
        if let assignment = expression.parentExpression?.asAssignment {
            return expression !== assignment.lhs
        }
        // Unary '&' is interpreted as 'address-of', which is a mutable operation.
        if let unary = expression.parentExpression?.asUnary {
            return unary.op != .bitwiseAnd
        }
        if let postfix = expression.parentExpression?.asPostfix, expression == postfix.exp {
            let root = postfix.topPostfixExpression

            // If at any point we find a function call, the original value cannot
            // be mutated due to any change on the returned value, so we just
            // assume it's never written.
            let chain = PostfixChainInverter.invert(expression: root)
            if
                let call = chain.first(where: { $0.postfix is FunctionCallPostfix }),
                let member = call.postfixExpression?.exp.asPostfix?.member
            {

                // Skip checking mutating methods on reference types, since those
                // don't mutate variables.
                if
                    let type = chain.first?.expression?.resolvedType,
                    !typeSystem.isScalarType(type)
                {

                    return true
                }

                if let method = member.definition as? KnownMethod {
                    return !method.signature.isMutating
                }

                return true
            }

            // Writing to a reference type at any point invalidates mutations
            // to the original value.
            let types = chain.compactMap(\.resolvedType)
            if types.contains(where: { typeSystem.isClassInstanceType($0) }) {
                return true
            }

            return isReadOnlyContext(root)
        }

        return true
    }
}

extension ExpressionTypeResolver {
    func nearestScope(for node: SyntaxNode) -> CodeScopeNode? {
        if let scope = nearestScopeCache[ObjectIdentifier(node)] {
            return scope
        }

        let scope = node.nearestScope
        nearestScopeCache[ObjectIdentifier(node)] = scope

        return scope
    }
}

extension ExpressionTypeResolver {
    func expandAliases(in type: SwiftType) -> SwiftType {
        typeSystem.resolveAlias(in: type)
    }

    // MARK: - Identifier/function lookup

    func searchIdentifierDefinition(
        _ exp: IdentifierExpression
    ) -> CodeDefinition? {

        guard hasIgnorableContext() else {
            // Fast path: No ignorable contexts
            return _fastIdentifierDefinition(exp)
        }

        let identifier = exp.identifier
        let filter: (CodeDefinition) -> Bool = { definition in
            guard !self.shouldIgnoreDefinition(definition) else {
                return false
            }

            return definition.name == identifier
        }

        // Visit identifier's type from current context
        if let definition = nearestScope(for: exp)?.firstDefinition(where: filter) {
            return definition
        }
        if let definition = nearestScope(for: exp)?.functionDefinitions(where: filter).first {
            return definition
        }

        // Look into intrinsics first, since they always take precedence
        if let intrinsic = intrinsicVariables.firstDefinition(where: filter) {
            return intrinsic
        }
        if let intrinsic = intrinsicVariables.functionDefinitions(where: filter).first {
            return intrinsic
        }

        // Check type system for a metatype with the identifier name
        if typeSystem.nominalTypeExists(identifier) {
            return CodeDefinition.forType(named: identifier)
        }

        return nil
    }

    private func _fastIdentifierDefinition(_ exp: IdentifierExpression) -> CodeDefinition? {
        let identifier = exp.identifier

        // Visit identifier's type from current context
        if let definition = nearestScope(for: exp)?.firstDefinition(named: identifier) {
            return definition
        }
        if let definition = nearestScope(for: exp)?.functionDefinitions(named: identifier).first {
            return definition
        }

        // Look into intrinsics first, since they always take precedence
        if let intrinsic = intrinsicVariables.firstDefinition(named: identifier) {
            return intrinsic
        }
        if let intrinsic = intrinsicVariables.functionDefinitions(named: identifier).first {
            return intrinsic
        }

        // Check type system for a metatype with the identifier name
        if typeSystem.nominalTypeExists(identifier) {
            return CodeDefinition.forType(named: identifier)
        }

        return nil
    }

    func searchFunctionDefinitions(
        matching identifier: FunctionIdentifier,
        _ exp: IdentifierExpression
    ) -> [CodeDefinition] {

        guard hasIgnorableContext() else {
            // Fast path: No ignorable contexts
            return _fastSearchFunctionDefinitions(identifier, exp)
        }

        let filter: (CodeDefinition) -> Bool = { definition in
            guard !self.shouldIgnoreDefinition(definition) else {
                return false
            }

            switch definition.kind {
            case .function(signature: let signature):
                return signature.asIdentifier == identifier
            default:
                return false
            }
        }

        var definitions: [CodeDefinition] = []

        if let def = nearestScope(for: exp)?.functionDefinitions(where: filter) {
            definitions.append(contentsOf: def)
        }

        let intrinsics = intrinsicVariables.functionDefinitions(where: filter)
        definitions.append(contentsOf: intrinsics)

        return definitions
    }

    private func _fastSearchFunctionDefinitions(
        _ identifier: FunctionIdentifier,
        _ exp: IdentifierExpression
    ) -> [CodeDefinition] {
        var definitions: [CodeDefinition] = []

        if let def = nearestScope(for: exp)?.functionDefinitions(matching: identifier) {
            definitions.append(contentsOf: def)
        }

        let intrinsics = intrinsicVariables.functionDefinitions(matching: identifier)
        definitions.append(contentsOf: intrinsics)

        return definitions
    }
}

/// Logic for resolving member invocations in expressions
private class MemberInvocationResolver {
    let typeSystem: TypeSystem
    let typeResolver: ExpressionTypeResolver

    init(typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver) {
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
    }

    func resolve(postfix exp: PostfixExpression, op: Postfix) -> Expression {
        defer {
            // Elevate an implicitly-unwrapped optional access to an optional access
            if exp.op.optionalAccessKind != .none {

                switch exp.resolvedType {
                case .implicitUnwrappedOptional(let inner)?,
                     .nullabilityUnspecified(let inner)?:

                    exp.resolvedType = .optional(inner)

                default:
                    break
                }
            }
        }

        switch op {
        case let sub as SubscriptPostfix:
            exp.exp = typeResolver.visitExpression(exp.exp)
            exp.op = sub

            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }

            guard let expType = exp.exp.resolvedType else {
                return exp
            }

            var subTypes = sub.arguments.map(\.expression.resolvedType)

            func resolveArgTypes() {
                exp.op = sub.replacingArguments(
                    sub.subExpressions.map(typeResolver.visitExpression)
                )

                subTypes = sub.arguments.map(\.expression.resolvedType)
            }

            // Propagate error type
            if sub.arguments.any(\.expression.isErrorTyped) {
                return exp.makeErrorTyped()
            }

            // Array<T> / Dictionary<T> resolving
            switch typeResolver.expandAliases(in: expType) {
            case .nominal(.generic("Array", let params)) where Array(params).count == 1:
                exp.op.subExpressions[0].expectedType = .int

                resolveArgTypes()

                // Can only subscript arrays with integers!
                if exp.op.subExpressions[0].resolvedType != .int {
                    return exp.makeErrorTyped()
                }

                exp.resolvedType = Array(params)[0]

            case .nominal(.generic("Dictionary", let params)) where params.count == 2:
                exp.op.subExpressions[0].expectedType = params.first

                resolveArgTypes()

                exp.resolvedType = .optional(params.last)

            case .array(let element):
                exp.op.subExpressions[0].expectedType = .int

                resolveArgTypes()

                if exp.op.subExpressions[0].resolvedType != .int {
                    return exp.makeErrorTyped()
                }

                exp.resolvedType = element

            case let .dictionary(key, value):
                exp.op.subExpressions[0].expectedType = key

                resolveArgTypes()

                if exp.op.subExpressions[0].resolvedType != key {
                    return exp.makeErrorTyped()
                }

                exp.resolvedType = .optional(value)

            default:

                resolveArgTypes()

                let subscriptDecl = typeSystem.subscription(
                    withParameterLabels: sub.arguments.map(\.label),
                    invocationTypeHints: subTypes,
                    static: expType.isMetatype,
                    in: expType
                )

                if let subscriptDecl = subscriptDecl {
                    sub.definition = subscriptDecl
                    exp.resolvedType = subscriptDecl.returnType
                    matchParameterTypes(
                        parameters: subscriptDecl.parameters,
                        callArguments: sub.arguments
                    )
                } else {
                    exp.makeErrorTyped()
                }

                resolveArgTypes()
            }

            exp.op.returnType = exp.resolvedType

        case let fc as FunctionCallPostfix:
            return handleFunctionCall(postfix: exp, functionCall: fc)

        // Meta-type fetching (TypeName.self, TypeName.self.self, etc.)
        case let member as MemberPostfix where member.name == "self":
            exp.exp = typeResolver.visitExpression(exp.exp)

            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }

            exp.resolvedType = exp.exp.resolvedType
            exp.op.returnType = exp.resolvedType

        case let member as MemberPostfix:
            exp.exp = typeResolver.visitExpression(exp.exp)

            // Propagate error type
            guard !exp.exp.isErrorTyped, let innerType = exp.exp.resolvedType else {
                return exp.makeErrorTyped()
            }

            if let property =
                typeSystem.property(
                    named: member.name,
                    static: innerType.isMetatype,
                    includeOptional: true,
                    in: innerType
                )
            {
                member.definition = property
                exp.resolvedType = property.storage.type
                exp.op.returnType = exp.resolvedType

                break
            }
            if let field =
                typeSystem.field(
                    named: member.name,
                    static: innerType.isMetatype,
                    in: innerType
                )
            {
                member.definition = field
                exp.resolvedType = field.storage.type
                exp.op.returnType = exp.resolvedType

                break
            }
            if let typeMember =
                typeSystem.member(
                    named: member.name,
                    static: innerType.isMetatype,
                    in: innerType
                )
            {
                member.definition = typeMember
                exp.resolvedType = typeMember.memberType
                exp.op.returnType = exp.resolvedType

                break
            }

            if innerType.isMetatype {
                if case .metatype(.nominal(let nominal)) = innerType,
                    typeSystem.nestedType(named: member.name, in: innerType) != nil {

                    exp.resolvedType = .metatype(for: .nested([nominal, .typeName(member.name)]))
                    exp.op.returnType = exp.resolvedType

                    break
                }
                if case .metatype(.nested(let nested)) = innerType,
                    typeSystem.nestedType(named: member.name, in: .nested(nested)) != nil {

                    exp.resolvedType = .metatype(for: .nested(nested + [.typeName(member.name)]))
                    exp.op.returnType = exp.resolvedType

                    break
                }
            }

            return exp.makeErrorTyped()

        default:
            break
        }

        return exp
    }

    func handleFunctionCall(
        postfix: PostfixExpression,
        functionCall: FunctionCallPostfix
    ) -> Expression {

        var functionCall = functionCall

        postfix.exp = typeResolver.visitExpression(postfix.exp)

        defer {
            postfix.op = functionCall.replacingArguments(
                functionCall.subExpressions.map(typeResolver.visitExpression)
            )

            if let expectedType = postfix.expectedType, let args = postfix.op.asFunctionCall?.arguments {
                let argTypes = args.compactMap(\.expression.resolvedType)

                if args.count == argTypes.count {
                    postfix.exp.expectedType =
                        .block(
                            returnType: expectedType,
                            parameters: argTypes,
                            attributes: []
                        )
                }
            }
        }

        // Parameterless type constructor on type metadata (i.e. `MyClass.init([params])`)
        if tryTypeInitializerResolution(postfix: postfix, functionCall: &functionCall) {
            return postfix
        }

        // Selector invocation
        if trySelectorCallResolution(postfix: postfix, functionCall: &functionCall) {
            return postfix
        }

        // Local closure/global function type
        if tryCallableIdentifierResolution(postfix: postfix, functionCall: &functionCall) {
            return postfix
        }

        // Callable type instance invocation
        if tryCallableTypeInvocation(postfix: postfix, functionCall: &functionCall) {
            return postfix
        }

        // Fallthrough error path
        return postfix.makeErrorTyped()
    }

    /// Attempts to resolve a function call as an initializer invocation on a
    /// metatype that contains an initializer.
    ///
    /// Returns `true` if the resolution was successful.
    func tryTypeInitializerResolution(
        postfix: PostfixExpression,
        functionCall: inout FunctionCallPostfix
    ) -> Bool {

        // TODO: Reduce duplication between the two branches bellow

        // Parameterless type constructor on type metadata (i.e. `MyClass.init([params])`)
        if
            let target = postfix.exp.asPostfix?.exp.asIdentifier,
            let initAccess = postfix.exp.asPostfix,
            initAccess.op == .member("init")
        {

            guard let metatype = extractMetatype(from: target) else {
                return false
            }
            guard let ctor = typeSystem.constructor(
                withArgumentLabels: labels(in: functionCall.arguments),
                in: metatype
            ) else {
                return false
            }

            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature = .init(
                returnType: metatype,
                parameters: ctor.parameters.map(\.type),
                attributes: []
            )
            functionCall.definition = ctor
            initAccess.op.definition = ctor

            matchParameterTypes(parameters: ctor.parameters, callArguments: functionCall.arguments)

            return true
        }

        // Direct type constructor `MyClass([params])`
        if let metatype = extractMetatype(from: postfix.exp) {
            guard let ctor = typeSystem.constructor(
                withArgumentLabels: labels(in: functionCall.arguments),
                in: metatype
            ) else {
                return false
            }

            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature = .init(
                returnType: metatype,
                parameters: ctor.parameters.map(\.type),
                attributes: []
            )
            functionCall.definition = ctor

            matchParameterTypes(parameters: ctor.parameters, callArguments: functionCall.arguments)

            return true
        }

        return false
    }

    /// Attempts to resolve a function call as a selector invocation on a member
    /// of a type.
    ///
    /// Returns `true` if the resolution was successful.
    func trySelectorCallResolution(
        postfix: PostfixExpression,
        functionCall: inout FunctionCallPostfix
    ) -> Bool {

        guard let target = postfix.exp.asPostfix?.exp, let member = postfix.exp.asPostfix?.member else {
            return false
        }
        guard let type = target.resolvedType else {
            return false
        }

        guard let method = method(
            isStatic: type.isMetatype,
            memberName: member.name,
            arguments: functionCall.arguments,
            in: type
        ) else {
            return false
        }

        let signature = method.signature

        member.definition = method
        member.returnType = .block(signature.swiftClosureType)

        postfix.exp.resolvedType = .block(signature.swiftClosureType)
        postfix.resolvedType = signature.returnType

        functionCall.returnType = signature.returnType
        functionCall.callableSignature = signature.swiftClosureType
        functionCall.definition = method

        if method.optional {
            member.returnType = member.returnType?.asOptional
            postfix.exp.resolvedType = postfix.exp.resolvedType?.asOptional
            postfix.resolvedType = postfix.resolvedType?.asOptional
        }

        matchParameterTypes(parameters: signature.parameters, callArguments: functionCall.arguments)

        return true
    }

    /// Attempts to resolve a function call as a call to a callable type, i.e a
    /// closure-typed value or a callable type instance.
    ///
    /// Returns `true` if the resolution was successful.
    func tryCallableTypeInvocation(
        postfix: PostfixExpression,
        functionCall: inout FunctionCallPostfix
    ) -> Bool {

        guard let expType = postfix.exp.resolvedType else {
            return false
        }

        // Detect callable types
        if case .block(let block) = expType {
            matchParameterTypes(types: block.parameters, callArguments: functionCall.arguments)

            functionCall = functionCall.replacingArguments(
                functionCall.subExpressions.map(typeResolver.visitExpression)
            )

            postfix.resolvedType = block.returnType

            functionCall.returnType = block.returnType
            functionCall.callableSignature = block

            return true
        }

        // Try `callAsFunction` invocation first
        if let knownType = typeSystem.findType(for: expType) {
            let callableTypeResolver = CallableTypeResolver(
                typeSystem: typeSystem,
                type: knownType
            )

            functionCall = functionCall.replacingArguments(
                functionCall.subExpressions.map(typeResolver.visitExpression)
            )

            let results = callableTypeResolver.resolveCall(functionCall.arguments)
            if !results.isEmpty {
                let result = results[0]
                let callableType = result.method.signature.swiftClosureType

                postfix.resolvedType = result.resolvedType

                postfix.exp.resolvedType = .block(callableType)
                functionCall.definition = result.method
                functionCall.returnType = result.resolvedType
                functionCall.callableSignature = callableType

                return true
            }
        }

        return false
    }

    /// Attempts to resolve a function call as a global function/local closure
    /// identifier call.
    ///
    /// Returns `true` if the resolution was successful.
    func tryCallableIdentifierResolution(
        postfix: PostfixExpression,
        functionCall: inout FunctionCallPostfix
    ) -> Bool {

        guard let target = postfix.exp.asIdentifier else {
            return false
        }

        let identifier = FunctionIdentifier(
            name: target.identifier,
            arguments: functionCall.arguments
        )

        let definitions = typeResolver.searchFunctionDefinitions(matching: identifier, target)
        let signatures = definitions.compactMap(\.asFunctionSignature)

        functionCall = functionCall.replacingArguments(
            functionCall.subExpressions.map(typeResolver.visitExpression)
        )

        let bestMatchIndex = findBestMatchIndex(
            signatures,
            matching: functionCall.arguments
        )

        let bestMatch =
            ((bestMatchIndex.map { signatures[$0] })?.swiftClosureType).map(SwiftType.block(_:))
                ?? postfix.exp.resolvedType

        // Update code definition
        if let bestMatchIndex {
            target.definition = definitions[bestMatchIndex]
        }

        guard let type = bestMatch, case let .block(blockType) = type.deepUnwrapped else {
            return false
        }

        postfix.resolvedType = type.wrappingOther(blockType.returnType)
        functionCall.returnType = postfix.resolvedType
        functionCall.callableSignature = blockType

        matchParameterTypes(
            types: blockType.parameters,
            callArguments: functionCall.arguments
        )

        return true
    }

    func matchParameterTypes(parameters: [ParameterSignature], callArguments: [FunctionArgument]) {
        matchParameterTypes(types: parameters.map(\.type), callArguments: callArguments)
    }

    func matchParameterTypes(types: [SwiftType], callArguments: [FunctionArgument]) {
        for (callArg, paramType) in zip(callArguments, types) {
            callArg.expression.expectedType = paramType
        }
    }

    func extractMetatype(from exp: Expression) -> SwiftType? {
        if case .metatype(let type)? = exp.resolvedType {
            return type
        }

        guard let target = exp.asPostfix?.exp.asIdentifier else {
            return nil
        }
        guard exp.asPostfix?.op == .member("init") else {
            return nil
        }
        guard case .metatype(let innerType)? = target.resolvedType else {
            return nil
        }

        return innerType
    }

    func labels(in arguments: [FunctionArgument]) -> [String?] {
        arguments.map(\.label)
    }

    func findBestMatch(
        _ functions: [FunctionSignature],
        matching arguments: [FunctionArgument]
    ) -> FunctionSignature? {

        if let index = findBestMatchIndex(functions, matching: arguments) {
            return functions[index]
        }

        return nil
    }

    func findBestMatchIndex(
        _ functions: [FunctionSignature],
        matching arguments: [FunctionArgument]
    ) -> Int? {

        let argTypes = arguments.asOverloadResolverArguments

        return
            typeSystem
                .overloadResolver()
                .findBestOverload(
                    inSignatures: functions,
                    arguments: argTypes
                )
    }

    func method(
        isStatic: Bool,
        memberName: String,
        arguments: [FunctionArgument],
        in type: SwiftType
    ) -> KnownMethod? {

        let identifier = FunctionIdentifier(name: memberName, argumentLabels: arguments.map(\.label))

        let types = arguments.map(\.expression.resolvedType)

        return typeSystem.method(
            withIdentifier: identifier,
            invocationTypeHints: types,
            static: isStatic,
            includeOptional: true,
            in: type
        )
    }
}
