import SwiftAST
import KnownType
import ObjcParser

public final class ExpressionTypeResolver: SyntaxNodeRewriter {
    private var nearestScopeCache: [ObjectIdentifier: CodeScopeNode] = [:]
    
    /// In case the expression type resolver is resolving a function context,
    /// this stack is prepared with the expected return types for the current
    /// functions.
    ///
    /// The stack is incremented and decremented as the expression resolver
    /// traverses into block expressions.
    private var contextFunctionReturnTypeStack: [SwiftType?]
    
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
    
    public init(typeSystem: TypeSystem,
                intrinsicVariables: DefinitionsSource) {
        
        self.typeSystem = typeSystem
        self.intrinsicVariables = intrinsicVariables
        contextFunctionReturnTypeStack = []
        super.init()
    }
    
    public init(typeSystem: TypeSystem,
                contextFunctionReturnType: SwiftType) {
        
        self.typeSystem = typeSystem
        self.intrinsicVariables = EmptyCodeScope()
        contextFunctionReturnTypeStack = [contextFunctionReturnType]
        super.init()
    }
    
    public init(typeSystem: TypeSystem,
                intrinsicVariables: DefinitionsSource,
                contextFunctionReturnType: SwiftType) {
        
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
        
        // TODO: Move this responsibility to `TypeSystem`?
        
        let iteratorType: SwiftType
        
        switch stmt.exp.resolvedType {
        case .nominal(.generic("Array", let elements))? where elements.count == 1:
            iteratorType = elements[0]
            
        case .array(let element)?:
            iteratorType = element
            
        // Sub-types of `NSArray` iterate as .any
        case .nominal(.typeName(let typeName))?
            where typeSystem.isType(typeName, subtypeOf: "NSArray"):
            iteratorType = .any
            
        case .nominal(.generic("Range", let elements))? where elements.count == 1,
             .nominal(.generic("ClosedRange", let elements))? where elements.count == 1:
            iteratorType = elements[0]
            
        default:
            iteratorType = .errorType
        }
        
        collectInPattern(
            stmt.pattern,
            type: iteratorType,
            location: .forLoop(stmt, .`self`),
            to: stmt.body
        )
        
        _=super.visitFor(stmt)
        
        return stmt
    }
    
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        if let pattern = stmt.pattern {
            let result = super.visitIf(stmt)
            
            collectInPattern(
                pattern,
                type: stmt.exp.resolvedType ?? .errorType,
                location: .ifLet(stmt, .`self`),
                to: stmt.body
            )
            
            return result
        }
        
        stmt.exp.expectedType = .bool
        
        return super.visitIf(stmt)
    }
    
    public override func visitWhile(_ stmt: WhileStatement) -> Statement {
        stmt.exp.expectedType = .bool
        
        return super.visitWhile(stmt)
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
        location: LocalCodeDefinition.DefinitionLocation,
        to scope: CodeScope
    ) {
        
        switch pattern {
        case .identifier(let ident):
            scope.recordDefinition(
                .forLocalIdentifier(
                    ident,
                    type: type,
                    isConstant: true,
                    location: location
                ),
                overwrite: true
            )
        default:
            // Other (more complex) patterns are not (yet) supported!
            break
        }
    }

    // MARK: - Expression Resolving

    public override func visitExpression(_ exp: Expression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        return super.visitExpression(exp)
    }
    
    public override func visitParens(_ exp: ParensExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
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
            exp.isReadOnlyUsage = isReadOnlyContext(exp)
            exp.resolvedType = definition.type
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
        if case let .block(ret, params, _)? = (exp.expectedType?.deepUnwrapped).map(expandAliases),
            params.count == exp.parameters.count {
            
            for (i, expectedType) in zip(0..<exp.parameters.count, params) {
                let param = exp.parameters[i]
                guard param.type.isNullabilityUnspecified else { continue }
                guard param.type.deepUnwrapped == expectedType.deepUnwrapped else { continue }
                
                exp.parameters[i].type = expectedType
            }
            
            if blockReturnType.isNullabilityUnspecified &&
                blockReturnType.deepUnwrapped == ret.deepUnwrapped {
                
                blockReturnType = ret
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
    
    /// Returns `true` if a given expression is being used in a read-only context.
    private func isReadOnlyContext(_ expression: Expression) -> Bool {
        if let assignment = expression.parentExpression?.asAssignment {
            return expression !== assignment.lhs
        }
        // Unary '&' is interpreted as 'address-of', which is a mutable operation.
        if let unary = expression.parentExpression?.asUnary {
            return unary.op != .bitwiseAnd
        }
        if let postfix = expression.parentExpression?.asPostfix {
            let root = postfix.topPostfixExpression
            
            // If at any point we find a function call, the original value cannot
            // be mutated due to any change on the returned value, so we just
            // assume it's never written.
            let chain = PostfixChainInverter.invert(expression: root)
            if let call = chain.first(where: { $0.postfix is FunctionCallPostfix }),
                let member = call.postfixExpression?.exp.asPostfix?.member {
                
                // Skip checking mutating methods on reference types, since those
                // don't mutate variables.
                if let type = chain.first?.expression?.resolvedType,
                    !typeSystem.isScalarType(type) {
                    
                    return true
                }
                
                if let method = member.memberDefinition as? KnownMethod {
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
    
    func searchIdentifierDefinition(_ exp: IdentifierExpression) -> CodeDefinition? {
        // Visit identifier's type from current context
        if let definition = nearestScope(for: exp)?.firstDefinition(named: exp.identifier) {
            return definition
        }
        
        // Look into intrinsics first, since they always take precedence
        if let intrinsic = intrinsicVariables.firstDefinition(named: exp.identifier) {
            return intrinsic
        }
        
        // Check type system for a metatype with the identifier name
        if typeSystem.nominalTypeExists(exp.identifier) {
            return CodeDefinition.forType(named: exp.identifier)
        }
        
        return nil
    }
    
    func searchFunctionDefinitions(matching identifier: FunctionIdentifier,
                                   _ exp: IdentifierExpression) -> [CodeDefinition] {
        
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
            
            func resolveArgTypes() {
                exp.op = sub.replacingArguments(
                    sub.subExpressions.map(typeResolver.visitExpression)
                )
            }
            
            let subTypes = sub.arguments.map(\.expression.resolvedType)
            // Propagate error type
            if sub.arguments.any(\.expression.isErrorTyped) {
                return exp.makeErrorTyped()
            }

            // Array<T> / Dictionary<T> resolving
            switch typeResolver.expandAliases(in: expType) {
            case .nominal(.generic("Array", let params)) where Array(params).count == 1:
                resolveArgTypes()
                
                // Can only subscript arrays with integers!
                if exp.op.subExpressions[0].resolvedType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = Array(params)[0]
                
            case .nominal(.generic("Dictionary", let params)) where Array(params).count == 2:
                exp.resolvedType = .optional(Array(params)[1])
                
            case .array(let element):
                resolveArgTypes()
                
                if exp.op.subExpressions[0].resolvedType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = element
                
            case let .dictionary(key, value):
                resolveArgTypes()
                
                if exp.op.subExpressions[0].resolvedType != key {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = .optional(value)

            default:
                
                let subscriptDecl =
                    typeSystem
                        .subscription(withParameterLabels: [nil],
                                      invocationTypeHints: subTypes,
                                      static: expType.isMetatype,
                                      in: expType)
                
                if let subscriptDecl = subscriptDecl {
                    exp.resolvedType = subscriptDecl.returnType
                    matchParameterTypes(parameters: subscriptDecl.parameters, callArguments: sub.arguments)
                    
                    resolveArgTypes()
                } else {
                    exp.makeErrorTyped()
                }
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
            
            if let property = typeSystem.property(named: member.name,
                                                  static: innerType.isMetatype,
                                                  includeOptional: true,
                                                  in: innerType) {
                
                member.memberDefinition = property
                exp.resolvedType = property.storage.type
                exp.op.returnType = exp.resolvedType
                
                break
            } else if let field = typeSystem.field(named: member.name,
                                                   static: innerType.isMetatype,
                                                   in: innerType) {
                
                member.memberDefinition = field
                exp.resolvedType = field.storage.type
                exp.op.returnType = exp.resolvedType
                
                break
            } else if innerType.isMetatype {
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
    
    func handleFunctionCall(postfix: PostfixExpression,
                            functionCall: FunctionCallPostfix) -> Expression {
        
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
                        .block(returnType: expectedType,
                               parameters: argTypes,
                               attributes: [])
                }
            }
        }
        
        let arguments = functionCall.arguments
        
        // Parameterless type constructor on type metadata (i.e. `MyClass.init()`)
        if let target = postfix.exp.asPostfix?.exp.asIdentifier,
            postfix.exp.asPostfix?.op == .member("init") && arguments.isEmpty {
            
            guard let metatype = extractMetatype(from: target) else {
                return postfix.makeErrorTyped()
            }
            guard let ctor = typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature =
                .block(returnType: metatype,
                       parameters: ctor.parameters.map(\.type),
                       attributes: [])
            
            matchParameterTypes(parameters: ctor.parameters, callArguments: functionCall.arguments)
            
            return postfix
        }
        // Direct type constructor `MyClass([params])`
        if let metatype = extractMetatype(from: postfix.exp) {
            guard let ctor = typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature =
                .block(returnType: metatype,
                       parameters: ctor.parameters.map(\.type),
                       attributes: [])
            
            matchParameterTypes(parameters: ctor.parameters, callArguments: functionCall.arguments)
            
            return postfix
        }
        // Selector invocation
        if let target = postfix.exp.asPostfix?.exp, let member = postfix.exp.asPostfix?.member {
            guard let type = target.resolvedType else {
                return postfix.makeErrorTyped()
            }
            guard let method = method(isStatic: type.isMetatype,
                                      memberName: member.name,
                                      arguments: arguments,
                                      in: type) else {
                return postfix.makeErrorTyped()
            }
            
            let signature = method.signature
            
            member.memberDefinition = method
            member.returnType = signature.swiftClosureType
            
            postfix.exp.resolvedType = signature.swiftClosureType
            postfix.resolvedType = signature.returnType
            
            functionCall.returnType = signature.returnType
            functionCall.callableSignature = signature.swiftClosureType
            
            if method.optional {
                member.returnType = member.returnType?.asOptional
                postfix.exp.resolvedType = postfix.exp.resolvedType?.asOptional
                postfix.resolvedType = postfix.resolvedType?.asOptional
            }
            
            matchParameterTypes(parameters: signature.parameters, callArguments: functionCall.arguments)
            
            return postfix
        }
        // Local closure/global function type
        if let target = postfix.exp.asIdentifier {
            
            let identifier =
                FunctionIdentifier(name: target.identifier,
                                   argumentLabels: arguments.map(\.label))
            
            let definitions =
                typeResolver.searchFunctionDefinitions(matching: identifier, target)
            let signatures = definitions.compactMap(\.asFunctionSignature)
            
            functionCall = functionCall.replacingArguments(
                functionCall.subExpressions.map(typeResolver.visitExpression)
            )
            
            let bestMatch =
                findBestMatch(signatures, matching: functionCall.arguments)?.swiftClosureType
                    ?? postfix.exp.resolvedType
            
            if let type = bestMatch,
                case let .block(ret, args, _) = type.deepUnwrapped {
                
                let type = type
                
                postfix.resolvedType = type.wrappingOther(ret)
                functionCall.returnType = postfix.resolvedType
                functionCall.callableSignature = type
                
                matchParameterTypes(types: args, callArguments: functionCall.arguments)
            }
        }
        
        return postfix
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
    
    func findBestMatch(_ functions: [FunctionSignature],
                       matching arguments: [FunctionArgument]) -> FunctionSignature? {
        
        let argTypes = arguments.asOverloadResolverArguments
        
        if let index =
            typeSystem
                .overloadResolver()
                .findBestOverload(inSignatures: functions,
                                  arguments: argTypes) {
            
            return functions[index]
        }
        
        return nil
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
