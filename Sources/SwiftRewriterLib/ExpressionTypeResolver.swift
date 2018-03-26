import SwiftAST
import ObjcParser

public final class ExpressionTypeResolver: SyntaxNodeRewriter {
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
        self.typeSystem = DefaultTypeSystem()
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
    
    public init(typeSystem: TypeSystem, intrinsicVariables: DefinitionsSource) {
        self.typeSystem = typeSystem
        self.intrinsicVariables = intrinsicVariables
        contextFunctionReturnTypeStack = []
        super.init()
    }
    
    public init(typeSystem: TypeSystem, intrinsicVariables: DefinitionsSource,
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
        // First, clear all variable definitions found, and their usages too.
        for node in SyntaxNodeSequence(statement: statement, inspectBlocks: true) {
            if let scoped = node as? CodeScopeNode {
                scoped.removeAllDefinitions()
            }
            if let ident = node as? IdentifierExpression {
                ident.definition = nil
            }
            if let postfix = node as? PostfixExpression {
                postfix.op.returnType = nil
            }
        }
        
        // Now visit the nodes
        return visitStatement(statement)
    }
    
    /// Invocates the resolution of a given expression's type.
    public func resolveType(_ exp: Expression) -> Expression {
        return exp.accept(self)
    }
    
    // MARK: - Definition Collection
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        _=super.visitVariableDeclarations(stmt)
        
        for decl in stmt.decl {
            var type = decl.type
            
            if !typeSystem.isScalarType(decl.type), let initValueType = decl.initialization?.resolvedType {
                type = type.withSameOptionalityAs(initValueType)
                
                // Promote implicitly unwrapped optionals to full optionals
                if initValueType.isImplicitlyUnwrapped {
                    type = .optional(type.unwrapped)
                }
            }
            
            decl.initialization?.expectedType = expandAliases(in: type)
            
            let definition = CodeDefinition(variableNamed: decl.identifier,
                                            type: type,
                                            intention: nil)
            stmt.nearestScope?.recordDefinition(definition)
        }
        
        return stmt
    }
    
    public override func visitFor(_ stmt: ForStatement) -> Statement {
        _=super.visitFor(stmt)
        
        // Define loop variables
        if stmt.exp.resolvedType == nil {
            stmt.exp = resolveType(stmt.exp)
        }
        
        let iteratorType: SwiftType
        
        switch stmt.exp.resolvedType {
        case .nominal(.generic("Array", let args))? where Array(args).count == 1:
            iteratorType = Array(args)[0]
            
        // Sub-types of array iterate as .anyObject
        case .nominal(.typeName(let typeName))? where typeSystem.isType(typeName, subtypeOf: "NSArray"):
            iteratorType = .anyObject
        default:
            iteratorType = .errorType
        }
        
        collectInPattern(stmt.pattern, type: iteratorType, to: stmt.body)
        
        return stmt
    }
    
    func collectInPattern(_ pattern: Pattern, type: SwiftType, to scope: CodeScope) {
        switch pattern {
        case .identifier(let ident):
            scope.recordDefinition(CodeDefinition(variableNamed: ident, type: type, intention: nil))
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
        case .int, .hexadecimal, .octal, .binary:
            if let expected = exp.expectedType, typeSystem.category(forType: expected) == .integer {
                exp.resolvedType = expected
            } else {
                exp.resolvedType = .int
            }
        case .string:
            exp.resolvedType = .string
            
        case .float:
            if let expected = exp.expectedType, typeSystem.category(forType: expected) == .float {
                exp.resolvedType = expected
            } else {
                exp.resolvedType = .float
            }
        case .boolean:
            exp.resolvedType = .bool
        case .nil:
            exp.resolvedType = .optional(.anyObject)
            
            if let expectedType = exp.expectedType {
                switch expectedType {
                case .optional, .implicitUnwrappedOptional:
                    exp.resolvedType = exp.expectedType
                    break
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
        
        // Propagte error type
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
        
        // Propagte error type
        if exp.exp.isErrorTyped {
            return exp.makeErrorTyped()
        }
        
        let type = expandAliases(in: exp.type)
        
        // Same-type casts always succeed
        if exp.exp.resolvedType == type {
            exp.resolvedType = type
            return exp
        }
        
        exp.resolvedType = .optional(type)
        
        return exp
    }
    
    public override func visitAssignment(_ exp: AssignmentExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        exp.lhs = visitExpression(exp.lhs)
        exp.rhs.expectedType = exp.lhs.resolvedType.map(expandAliases)
        exp.rhs = visitExpression(exp.rhs)
        
        // Propagte error type
        if exp.lhs.isErrorTyped || exp.rhs.isErrorTyped {
            return exp.makeErrorTyped()
        }
        
        exp.resolvedType = exp.lhs.resolvedType
        
        return exp
    }
    
    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        exp.lhs = visitExpression(exp.lhs)
        
        switch exp.op.category {
        case .logical:
            exp.lhs.expectedType = .bool
            exp.rhs.expectedType = .bool
            
        case .nullCoalesce:
            exp.rhs.expectedType = exp.lhs.resolvedType?.deepUnwrapped
            
        default:
            break
        }
        
        exp.rhs = visitExpression(exp.rhs)
        
        // Propagte error type
        if exp.lhs.isErrorTyped || exp.rhs.isErrorTyped {
            return exp.makeErrorTyped()
        }
        
        switch exp.op.category {
        case .arithmetic where exp.lhs.resolvedType == exp.rhs.resolvedType:
            guard let type = exp.lhs.resolvedType else {
                break
            }
            if !typeSystem.isNumeric(type) {
                break
            }
            
            exp.resolvedType = exp.lhs.resolvedType
            
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
            
            switch definition {
            case .local(let def), .global(let def):
                exp.resolvedType = def.type
            case .type(let typeName):
                exp.resolvedType = .metatype(for: .typeName(typeName))
            case .member:
                break
            }
        } else {
            exp.definition = nil
            exp.resolvedType = .errorType
        }
        
        return exp
    }
    
    public override func visitTernary(_ exp: TernaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
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

    // MARK: - Postfix type resolving
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        _=super.visitPostfix(exp)
        
        let resolver = MemberInvocationResolver(typeSystem: typeSystem, typeResolver: self)
        let result = resolver.resolve(postfix: exp, op: exp.op)
        
        func hasOptional(_ exp: PostfixExpression, _ op: Postfix) -> Bool {
            if exp.resolvedType?.isOptional == true {
                return true
            }
            
            if op.hasOptionalAccess {
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
        if case let .block(ret, params)? = exp.expectedType, params.count == exp.parameters.count {
            for (i, expectedType) in zip(0..<exp.parameters.count, params) {
                let param = exp.parameters[i]
                guard param.type.isImplicitlyUnwrapped else { continue }
                guard param.type.deepUnwrapped == expectedType.deepUnwrapped else { continue }
                
                exp.parameters[i].type = expectedType
            }
            
            if blockReturnType.isImplicitlyUnwrapped &&
                blockReturnType.deepUnwrapped == ret.deepUnwrapped {
                
                blockReturnType = ret
            }
        }
        
        // Apply definitions for function parameters
        for param in exp.parameters {
            exp.recordDefinition(
                CodeDefinition(variableNamed: param.name,
                               storage: ValueStorage(type: param.type, ownership: .strong, isConstant: true),
                               intention: nil)
            )
        }
        
        // Push context of return type during expression resolving
        pushContainingFunctionReturnType(blockReturnType)
        defer {
            popContainingFunctionReturnType()
        }
        
        return super.visitBlock(exp)
    }
    
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        stmt.exp.expectedType = .bool
        
        return super.visitIf(stmt)
    }
    
    public override func visitWhile(_ stmt: WhileStatement) -> Statement {
        stmt.exp.expectedType = .bool
        
        return super.visitWhile(stmt)
    }
    
    public override func visitReturn(_ stmt: ReturnStatement) -> Statement {
        if let lastType = contextFunctionReturnTypeStack.last {
            stmt.exp?.expectedType = lastType
        }
        
        return super.visitReturn(stmt)
    }
}

extension ExpressionTypeResolver {
    func expandAliases(in type: SwiftType) -> SwiftType {
        return typeSystem.resolveAlias(in: type)
    }
    
    func searchIdentifierDefinition(_ exp: IdentifierExpression) -> IdentifierExpression.Definition? {
        // Look into intrinsics first, since they always take precedence
        if let intrinsic = intrinsicVariables.definition(named: exp.identifier) {
            return .local(intrinsic)
        }
        
        // Visit identifier's type from current context
        if let definition = exp.nearestScope?.definition(named: exp.identifier) {
            return .local(definition)
        }
        
        // Check type system for a metatype with the identifier name
        if typeSystem.typeExists(exp.identifier) {
            return .type(named: exp.identifier)
        }
        
        return nil
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
        // If this type is a function call of a member access of, postpone the
        // resolving to the parent (function call) node, since we could possibly
        // end up performing an unnecessary type lookup here.
        if op.asMember != nil,
            let parent = exp.parent as? PostfixExpression,
            parent.functionCall != nil,
            parent.exp == exp {
            return exp
        }
        
        defer {
            // Elevate an implicitly-unwrapped optional access to an optional access
            if exp.op.hasOptionalAccess, case .implicitUnwrappedOptional(let inner)? = exp.resolvedType {
                exp.resolvedType = .optional(typeResolver.expandAliases(in: inner))
            }
        }
        
        switch op {
        case let sub as SubscriptPostfix:
            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            guard let expType = exp.exp.resolvedType else {
                return exp
            }
            guard let subType = sub.expression.resolvedType else {
                return exp
            }
            // Propagate error type
            if sub.expression.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            // TODO: Resolving of subscriptions of Array/Dictionary types should
            // happen by inspecting `subscript`-able members on the KnownType.
            
            // Array<T> / Dictionary<T> resolving
            switch typeResolver.expandAliases(in: expType) {
            case .nominal(.generic("Array", let params)) where Array(params).count == 1:
                // Can only subscript arrays with integers!
                if subType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = Array(params)[0]
                
            case .nominal(.generic("Dictionary", let params)) where Array(params).count == 2:
                exp.resolvedType = .optional(Array(params)[1])
                
            // Sub-types of NSArray index as .anyObject
            case .nominal(.typeName(let typeName)) where typeResolver.typeSystem.isType(typeName, subtypeOf: "NSArray"):
                if subType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = .anyObject
                
            // Sub-types of NSDictionary index as .anyObject
            case .nominal(.typeName(let typeName)) where typeResolver.typeSystem.isType(typeName, subtypeOf: "NSDictionary"):
                exp.resolvedType = .optional(.anyObject)
                
            default:
                break
            }
            
            sub.returnType = exp.resolvedType
            
        case let fc as FunctionCallPostfix:
            return handleFunctionCall(postfix: exp, functionCall: fc)
            
        // Meta-type fetching (TypeName.self, TypeName.self.self, etc.)
        case let member as MemberPostfix where member.name == "self":
            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            exp.resolvedType = exp.exp.resolvedType
            exp.op.returnType = exp.resolvedType
            
        case let member as MemberPostfix:
            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            guard let innerType = exp.exp.resolvedType else {
                return exp.makeErrorTyped()
            }
            
            if let property = typeSystem.property(named: member.name, static: innerType.isMetatype,
                                                  includeOptional: true, in: innerType) {
                member.memberDefinition = property
                exp.resolvedType = property.storage.type
                exp.op.returnType = exp.resolvedType
            } else if let field = typeSystem.field(named: member.name, static: innerType.isMetatype,
                                                   in: innerType) {
                member.memberDefinition = field
                exp.resolvedType = field.storage.type
                exp.op.returnType = exp.resolvedType
            } else {
                return exp.makeErrorTyped()
            }
            
        default:
            break
        }
        
        return exp
    }
    
    func handleFunctionCall(postfix: PostfixExpression, functionCall: FunctionCallPostfix) -> Expression {
        let arguments = functionCall.arguments
        
        // Parameterless type constructor on type metadata (i.e. `MyClass.init()`)
        if let target = postfix.exp.asPostfix?.exp.asIdentifier,
            postfix.exp.asPostfix?.op == .member("init") && arguments.isEmpty
        {
            guard let metatype = extractMetatype(from: target) else {
                return postfix.makeErrorTyped()
            }
            guard let ctor = typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature = .block(returnType: metatype, parameters: ctor.parameters.map { $0.type })
            
            matchParameterTypes(parameters: ctor.parameters, callArguments: functionCall.arguments)
            
            return postfix
        }
        // Direct type constuctor `MyClass([params])`
        if let target = postfix.exp.asIdentifier, let metatype = extractMetatype(from: target) {
            guard let ctor = typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            functionCall.returnType = metatype
            functionCall.callableSignature = .block(returnType: metatype, parameters: ctor.parameters.map { $0.type })
            
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
            
            member.memberDefinition = method
            
            postfix.exp.resolvedType = method.signature.swiftClosureType
            postfix.resolvedType = method.signature.returnType
            
            functionCall.returnType = method.signature.returnType
            functionCall.callableSignature = method.signature.swiftClosureType
            
            matchParameterTypes(parameters: method.signature.parameters, callArguments: functionCall.arguments)
            
            return postfix
        }
        // Local closure/global function type
        if let target = postfix.exp.asIdentifier,
            let type = target.resolvedType,
            case let .block(ret, args) = type.deepUnwrapped {
            
            postfix.resolvedType = type.wrappingOther(ret)
            functionCall.returnType = postfix.resolvedType
            functionCall.callableSignature = .block(returnType: ret, parameters: args)
            
            matchParameterTypes(types: args, callArguments: functionCall.arguments)
        }
        
        return postfix
    }
    
    func matchParameterTypes(parameters: [ParameterSignature], callArguments: [FunctionArgument]) {
        matchParameterTypes(types: parameters.map { $0.type }, callArguments: callArguments)
    }
    
    func matchParameterTypes(types: [SwiftType], callArguments: [FunctionArgument]) {
        for (callArg, paramType) in zip(callArguments, types) {
            callArg.expression.expectedType = typeResolver.expandAliases(in: paramType)
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
    
    func labels(in arguments: [FunctionArgument]) -> [String] {
        return arguments.map { $0.label ?? "_" }
    }
    
    func method(isStatic: Bool, memberName: String, arguments: [FunctionArgument], in type: SwiftType) -> KnownMethod? {
        let selector
            = SelectorSignature(isStatic: isStatic,
                                keywords: [memberName] + arguments.map { $0.label })
        
        return typeSystem.method(withObjcSelector: selector, static: isStatic,
                                 includeOptional: true, in: type)
    }
}

/// Provides a facility to analyze a postfix expression in left-to-right fashion.
public final class PostfixChainInverter {
    private var expression: PostfixExpression
    
    public init(expression: PostfixExpression) {
        self.expression = expression
    }
    
    public func invert() -> [Postfix] {
        var stack: [SwiftAST.Postfix] = []
        
        var next: PostfixExpression? = expression
        var last: Expression = expression
        
        while let current = next {
            stack.append(current.op)
            
            last = current.exp
            next = current.exp.asPostfix
        }
        
        // Unwind and prepare stack
        var result: [Postfix] = []
        
        result.append(.root(last))
        
        loop:
        while let pop = stack.popLast() {
            switch pop {
            case let op as MemberPostfix:
                result.append(.member(op.name, original: op))
                
            case let op as SubscriptPostfix:
                result.append(.subscript(op.expression, original: op))
                
            case let op as FunctionCallPostfix:
                result.append(.call(op.arguments, original: op))
                
            default:
                break loop
            }
        }
        
        return result
    }
    
    public static func invert(expression: PostfixExpression) -> [Postfix] {
        let inverter = PostfixChainInverter(expression: expression)
        return inverter.invert()
    }
    
    public enum Postfix {
        case root(Expression)
        case member(String, original: MemberPostfix)
        case `subscript`(Expression, original: SubscriptPostfix)
        case call([FunctionArgument], original: FunctionCallPostfix)
        
        public var postfix: SwiftAST.Postfix? {
            switch self {
            case .root:
                return nil
            case .member(_, let original):
                return original
            case .call(_, let original):
                return original
            case .subscript(_, let original):
                return original
            }
        }
        
        public var resolvedType: SwiftType? {
            switch self {
            case .root(let exp):
                return exp.resolvedType
            default:
                return postfix?.returnType
            }
        }
    }
}
