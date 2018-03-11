import SwiftAST
import ObjcParser

public final class ExpressionTypeResolver: SyntaxNodeRewriter {
    public var typeSystem: TypeSystem
    
    /// Intrinsic variables provided by the type system
    public var intrinsicVariables: DefinitionsSource
    
    /// If `true`, the expression type resolver ignores resolving expressions that
    /// already have a non-nil `resolvedType` field.
    public var ignoreResolvedExpressions: Bool = false
    
    public override init() {
        self.typeSystem = DefaultTypeSystem()
        self.intrinsicVariables = EmptyCodeScope()
        super.init()
    }
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
        self.intrinsicVariables = EmptyCodeScope()
        super.init()
    }
    
    public init(typeSystem: TypeSystem, intrinsicVariables: DefinitionsSource) {
        self.typeSystem = typeSystem
        self.intrinsicVariables = intrinsicVariables
        super.init()
    }
    
    /// Invocates the resolution of all expressions on a given statement recursively.
    public func resolveTypes(in statement: Statement) {
        // First, clear all variable definitions found, and their usages too.
        for node in SyntaxNodeSequence(statement: statement, inspectBlocks: true) {
            if let scoped = node as? CodeScopeStatement {
                scoped.removeAllDefinitions()
            }
            if let ident = node as? IdentifierExpression {
                ident.definition = nil
            }
        }
        
        // Now visit the nodes
        _=visitStatement(statement)
    }
    
    /// Invocates the resolution of a given expression's type.
    public func resolveType(_ exp: Expression) {
        _=exp.accept(self)
    }
    
    // MARK: - Definition Collection
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        _=super.visitVariableDeclarations(stmt)
        
        for decl in stmt.decl {
            var type = decl.type
            
            if let initializerOptionality = decl.initialization?.resolvedType {
                type = type.withSameOptionalityAs(initializerOptionality)
            }
            
            let definition = CodeDefinition(name: decl.identifier,
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
            resolveType(stmt.exp)
        }
        
        let iteratorType: SwiftType
        
        switch stmt.exp.resolvedType {
        case .generic("Array", let args)? where args.count == 1:
            iteratorType = args[0]
            
        // Sub-types of array iterate as .anyObject
        case .typeName(let typeName)? where typeSystem.isType(typeName, subtypeOf: "NSArray"):
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
            scope.recordDefinition(CodeDefinition(name: ident, type: type, intention: nil))
            break
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
            exp.resolvedType = .int
        case .string:
            exp.resolvedType = .string
        case .float:
            exp.resolvedType = .float
        case .boolean:
            exp.resolvedType = .bool
        case .nil:
            exp.resolvedType = .optional(.anyObject)
        case .rawConstant:
            exp.resolvedType = .any
        }
        
        return super.visitConstant(exp)
    }
    
    public override func visitUnary(_ exp: UnaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
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
        
        // Same-type casts always succeed
        if exp.exp.resolvedType == exp.type {
            exp.resolvedType = exp.type
            return exp
        }
        
        exp.resolvedType = .optional(exp.type)
        
        return exp
    }
    
    public override func visitAssignment(_ exp: AssignmentExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        _=super.visitAssignment(exp)
        
        // Propagte error type
        if exp.lhs.isErrorTyped || exp.rhs.isErrorTyped {
            return exp.makeErrorTyped()
        }
        
        exp.resolvedType = exp.lhs.resolvedType
        
        return exp
    }
    
    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        _=super.visitBinary(exp)
        
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
        
        case .nullCoallesce where exp.lhs.resolvedType?.deepUnwrapped == exp.rhs.resolvedType?.deepUnwrapped:
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
        for item in exp.items {
            if item.resolvedType != firstType {
                exp.resolvedType = .nsArray
                return exp
            }
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
}

extension ExpressionTypeResolver {
    func findTypeNamed(_ typeName: String) -> KnownType? {
        return typeSystem.knownTypeWithName(typeName)
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
        if op.asMember != nil, let parent = exp.parent as? PostfixExpression, parent.functionCall != nil {
            return exp
        }
        
        defer {
            // Elevate an implicitly-unwrapped optional access to an optional access
            if exp.op.hasOptionalAccess, case .implicitUnwrappedOptional(let inner)? = exp.resolvedType {
                exp.resolvedType = .optional(inner)
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
            switch expType {
            case .generic("Array", let params) where params.count == 1:
                // Can only subscript arrays with integers!
                if subType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = params[0]
                
            case .generic("Dictionary", let params) where params.count == 2:
                exp.resolvedType = .optional(params[1])
                
            // Sub-types of NSArray index as .anyObject
            case .typeName(let typeName) where typeResolver.typeSystem.isType(typeName, subtypeOf: "NSArray"):
                if subType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = .anyObject
                
            // Sub-types of NSDictionary index as .anyObject
            case .typeName(let typeName) where typeResolver.typeSystem.isType(typeName, subtypeOf: "NSDictionary"):
                exp.resolvedType = .optional(.anyObject)
                
            default:
                break
            }
            
        case let fc as FunctionCallPostfix:
            return handleFunctionCall(postfix: exp, functionCall: fc)
            
        // Meta-type fetching (TypeName.self, TypeName.self.self, etc.)
        case let member as MemberPostfix where member.name == "self":
            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            exp.resolvedType = exp.exp.resolvedType
            
        case let member as MemberPostfix:
            // Propagate error type
            if exp.exp.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
            guard let innerType = exp.exp.resolvedType else {
                return exp.makeErrorTyped()
            }
            
            if let property = typeSystem.property(named: member.name, static: innerType.isMetatype, in: innerType) {
                member.memberDefinition = property
                exp.resolvedType = property.storage.type
            } else if let field = typeSystem.field(named: member.name, static: innerType.isMetatype, in: innerType) {
                member.memberDefinition = field
                exp.resolvedType = field.storage.type
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
            guard typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) != nil else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            
            return postfix
        }
        // Direct type constuctor `MyClass([params])`
        if let target = postfix.exp.asIdentifier, let metatype = extractMetatype(from: target) {
            guard typeSystem.constructor(withArgumentLabels: labels(in: arguments), in: metatype) != nil else {
                return postfix.makeErrorTyped()
            }
            
            postfix.resolvedType = metatype
            
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
            
            return postfix
        }
        // Local closure/global function type
        if let target = postfix.exp.asIdentifier,
            let type = target.resolvedType,
            case .block(let ret, _) = type.deepUnwrapped {
            postfix.resolvedType = ret.withSameOptionalityAs(type)
        }
        
        return postfix
    }
    
    func findType(for type: SwiftType) -> KnownType? {
        return typeSystem.findType(for: type)
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
        // Create function signature
        let parameters =
            labels(in: arguments).map { lbl in
                ParameterSignature.init(label: lbl, name: "", type: .void)
        }
        
        let signature =
            FunctionSignature(name: memberName,
                              parameters: parameters,
                              returnType: .void,
                              isStatic: isStatic)
        
        return typeSystem.method(withObjcSelector: signature, static: isStatic, in: type)
    }
}
