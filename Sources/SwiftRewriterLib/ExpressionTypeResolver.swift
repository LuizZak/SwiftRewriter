import SwiftAST
import ObjcParser

public class ExpressionTypeResolver: SyntaxNodeRewriter {
    public var typeSystem: TypeSystem
    
    /// If `true`, the expression type resolver ignores resolving expressions that
    /// already have a non-nil `resolvedType` field.
    public var ignoreResolvedExpressions: Bool = false
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
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
    }
    
    /// Invocates the resolution of a given expression's type.
    public func resolveType(_ exp: Expression) {
        _=exp.accept(self)
    }
    
    // MARK: - Definition Collection
    public override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
        for decl in stmt.decl {
            let definition = CodeDefinition(name: decl.identifier, type: decl.type)
            stmt.nearestScope.recordDefinition(definition)
        }
        
        return super.visitVariableDeclarations(stmt)
    }
    
    public override func visitFor(_ stmt: ForStatement) -> Statement {
        _=super.visitFor(stmt)
        
        // Define loop variables
        collectInPattern(stmt.pattern, exp: stmt.exp, to: stmt.body)
        
        return stmt
    }
    
    func collectInPattern(_ pattern: Pattern, exp: Expression, to scope: CodeScope) {
        switch pattern {
        case .identifier(let ident):
            if exp.resolvedType == nil {
                resolveType(exp)
            }
            
            scope.recordDefinition(CodeDefinition(name: ident, type: exp.resolvedType ?? .errorType))
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
    
    public override func visitBinary(_ exp: BinaryExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        _=super.visitBinary(exp)
        
        // Propagte error type
        if exp.lhs.isErrorTyped || exp.lhs.isErrorTyped {
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
        let definition = exp.nearestScope.definition(named: exp.identifier)
        
        exp.definition = definition
        exp.resolvedType = definition?.type ?? .errorType
        
        return exp
    }

    // MARK: - Postfix type resolving
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if ignoreResolvedExpressions && exp.isTypeResolved { return exp }
        
        _=super.visitPostfix(exp)
        
        // Propagate error type
        if exp.exp.isErrorTyped {
            return exp.makeErrorTyped()
        }
        
        switch exp.op {
        case .subscript(let sub):
            guard let expType = exp.exp.resolvedType else {
                return exp
            }
            guard let subType = sub.resolvedType else {
                return exp
            }
            // Propagate error type
            if sub.isErrorTyped {
                return exp.makeErrorTyped()
            }
            
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
                
            case .nsArray:
                if subType != .int {
                    return exp.makeErrorTyped()
                }
                
                exp.resolvedType = .optional(.anyObject)
                
            case .nsDictionary:
                exp.resolvedType = .optional(.anyObject)
            default:
                break
            }
            
        // TODO: Support function calling and member lookup
        default:
            break
        }
        
        return exp
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
