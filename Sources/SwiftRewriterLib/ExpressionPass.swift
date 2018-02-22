/// Represents the base protocol for visitors of an expression tree.
/// Visitors visit nodes while performing operations on each node along the way,
/// returning the resulting value after done traversing.
public protocol ExpressionVisitor {
    associatedtype ExprResult
    
    /// Visits an expression node
    ///
    /// - Parameter expression: Expression to visit
    /// - Returns: Result of visiting this expression node
    func visitExpression(_ expression: Expression) -> ExprResult
    
    /// Visits an assignment operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this assignment operation node
    func visitAssignment(_ exp: AssignmentExpression) -> ExprResult
    
    /// Visits a binary operation node
    ///
    /// - Parameters:
    ///   - lhs: Expression's left-hand side
    ///   - op: Expression's operator
    ///   - rhs: Expression's right-hand side
    /// - Returns: Result of visiting this binary operation node
    func visitBinary(_ exp: BinaryExpression) -> ExprResult
    
    /// Visits a unary operation node
    ///
    /// - Parameters:
    ///   - op: The unary operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this unary operation node
    func visitUnary(_ exp: UnaryExpression) -> ExprResult
    
    /// Visits a prefix operation node
    ///
    /// - Parameters:
    ///   - op: The prefix operator for the expression
    ///   - exp: The operand for the expression
    /// - Returns: Result of visiting this prefix operation node
    func visitPrefix(_ exp: PrefixExpression) -> ExprResult
    
    /// Visits a postfix operation node
    ///
    /// - Parameters:
    ///   - exp: The operand for the expression
    ///   - op: The postfix operator for the expression
    /// - Returns: Result of visiting this postfix operation node
    func visitPostfix(_ exp: PostfixExpression) -> ExprResult
    
    /// Visits a constant node
    ///
    /// - Parameter constant: The constant contained within the node
    /// - Returns: Result of visiting this constant node
    func visitConstant(_ exp: ConstantExpression) -> ExprResult
    
    /// Visits a parenthesized expression node
    ///
    /// - Parameter exp: The expression contained within the parenthesis
    /// - Returns: Result of visiting this parenthesis node
    func visitParens(_ exp: ParensExpression) -> ExprResult
    
    /// Visits an identifier node
    ///
    /// - Parameter identifier: The identifier contained within the node
    /// - Returns: Result of visiting this identifier node
    func visitIdentifier(_ exp: IdentifierExpression) -> ExprResult
    
    /// Visits a type-casting expression node
    ///
    /// - Parameters:
    ///   - exp: The expression being casted
    ///   - type: The target casting type
    /// - Returns: Result of visiting this cast node
    func visitCast(_ exp: CastExpression) -> ExprResult
    
    /// Visits an array literal node
    ///
    /// - Parameter array: The list of expressions that make up the array literal
    /// - Returns: Result of visiting this array literal node
    func visitArray(_ exp: ArrayLiteralExpression) -> ExprResult
    
    /// Visits a dictionary literal node
    ///
    /// - Parameter dictionary: The list of dictionary entry pairs that make up
    /// the dictionary literal
    /// - Returns: Result of visiting this dictionary literal node
    func visitDictionary(_ exp: DictionaryLiteralExpression) -> ExprResult
    
    /// Visits a block expression
    ///
    /// - Parameters:
    ///   - parameters: Parameters for the block's invocation
    ///   - returnType: The return type of the block
    ///   - body: The block's statements body
    /// - Returns: Result of visiting this block expression node
    func visitBlock(_ exp: BlockLiteralExpression) -> ExprResult
    
    /// Visits a ternary operation node
    ///
    /// - Parameters:
    ///   - exp: The control expression
    ///   - ifTrue: The expression executed when the control expression evaluates
    /// to true
    ///   - ifFalse: The expression executed when the control expression evaluates
    /// to false
    /// - Returns: Result of visiting this ternary expression node
    func visitTernary(_ exp: TernaryExpression) -> ExprResult
    
    /// Visits an unknown expression node
    ///
    /// - Parameter context: Context for unknown expression node
    /// - Returns: Result of visiting this unknown expression node
    func visitUnknown(_ exp: UnknownExpression) -> ExprResult
}

/// Context for an `ExpressionPass` execution.
public struct ExpressionPassContext {
    public static let empty = ExpressionPassContext(knownTypes: _Source())
    
    public let knownTypes: KnownTypeSource
    
    public init(knownTypes: KnownTypeSource) {
        self.knownTypes = knownTypes
    }
    
    private struct _Source: KnownTypeSource {
        func recoverType(named name: String) -> KnownType? {
            return nil
        }
    }
}

/// A base class for expression rewriting passes.
open class ExpressionPass: ExpressionVisitor {
    public var inspectBlocks = false
    public var context: ExpressionPassContext = .empty
    
    public init() {
        
    }
    
    /// Entry point for expression pass
    public func applyPass(on expression: Expression) -> Expression {
        return expression.accept(self)
    }
    
    open func visitExpression(_ exp: Expression) -> Expression {
        return exp.accept(self)
    }
    
    open func visitAssignment(_ exp: AssignmentExpression) -> Expression {
        exp.lhs = exp.lhs.accept(self)
        exp.rhs = exp.rhs.accept(self)
        
        return exp
    }
    
    open func visitBinary(_ exp: BinaryExpression) -> Expression {
        exp.lhs = exp.lhs.accept(self)
        exp.rhs = exp.rhs.accept(self)
        
        return exp
    }
    
    open func visitUnary(_ exp: UnaryExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        
        return exp
    }
    
    open func visitPrefix(_ exp: PrefixExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        
        return exp
    }
    
    open func visitPostfix(_ exp: PostfixExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        
        switch exp.op {
        case .subscript(let inner):
            exp.op = .subscript(inner.accept(self))
        case .functionCall(arguments: let args):
            exp.op = .functionCall(arguments: args.map { arg in
                switch arg {
                case .labeled(let label, let exp):
                    return .labeled(label, exp.accept(self))
                case .unlabeled(let exp):
                    return .unlabeled(exp.accept(self))
                }
            })
        default:
            break
        }
        
        return exp
    }
    
    open func visitConstant(_ exp: ConstantExpression) -> Expression {
        return exp
    }
    
    open func visitParens(_ exp: ParensExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        
        return exp
    }
    
    open func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        return exp
    }
    
    open func visitCast(_ exp: CastExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        
        return exp
    }
    
    open func visitArray(_ exp: ArrayLiteralExpression) -> Expression {
        exp.items = exp.items.map { $0.accept(self) }
        
        return exp
    }
    
    open func visitDictionary(_ exp: DictionaryLiteralExpression) -> Expression {
        for i in 0..<exp.pairs.count {
            exp.pairs[i].key = exp.pairs[i].key.accept(self)
            exp.pairs[i].value = exp.pairs[i].value.accept(self)
        }
        
        return exp
    }
    
    open func visitTernary(_ exp: TernaryExpression) -> Expression {
        exp.exp = exp.exp.accept(self)
        exp.ifTrue = exp.ifTrue.accept(self)
        exp.ifFalse = exp.ifFalse.accept(self)
        
        return exp
    }
    
    open func visitBlock(_ exp: BlockLiteralExpression) -> Expression {
        if inspectBlocks {
            let pass = ExpStatementPass(target: self)
            exp.body.statements = exp.body.statements.map { $0.accept(pass) }
        }
        
        return exp
    }
    
    open func visitUnknown(_ exp: UnknownExpression) -> Expression {
        return exp
    }
    
    private class ExpStatementPass: StatementPass {
        var target: ExpressionPass
        
        init(target: ExpressionPass) {
            self.target = target
        }
        
        override func visitIf(_ stmt: IfStatement) -> Statement {
            stmt.exp = stmt.exp.accept(target)
            
            return super.visitIf(stmt)
        }
        
        override func visitSwitch(_ stmt: SwitchStatement) -> Statement {
            stmt.exp = stmt.exp.accept(target)
            stmt.cases = stmt.cases.map { cs in
                return SwitchCase(patterns: cs.patterns.map(recurseIntoPatterns),
                                  statements: cs.statements)
            }
            
            return super.visitSwitch(stmt)
        }
        
        override func visitWhile(_ stmt: WhileStatement) -> Statement {
            stmt.exp = stmt.exp.accept(target)
            
            return super.visitWhile(stmt)
        }
        
        override func visitFor(_ stmt: ForStatement) -> Statement {
            stmt.pattern = recurseIntoPatterns(stmt.pattern)
            stmt.exp = stmt.exp.accept(target)
            
            return super.visitFor(stmt)
        }
        
        override func visitReturn(_ stmt: ReturnStatement) -> Statement {
            stmt.exp = stmt.exp?.accept(target)
            
            return super.visitReturn(stmt)
        }
        
        override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
            stmt.expressions = stmt.expressions.map { $0.accept(target) }
            
            return super.visitExpressions(stmt)
        }
        
        override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
            stmt.decl = stmt.decl.map { v in
                var v = v
                v.initialization = v.initialization?.accept(target)
                return v
            }
            
            return super.visitVariableDeclarations(stmt)
        }
        
        private func recurseIntoPatterns(_ pattern: Pattern) -> Pattern {
            switch pattern {
            case .expression(let exp):
                return .expression(exp.accept(target))
            case .tuple(let tups):
                return .tuple(tups.map(recurseIntoPatterns))
            case .identifier:
                return pattern
            }
        }
    }
}
