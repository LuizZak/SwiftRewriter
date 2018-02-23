/// A class for iterating over Expression trees.
public final class ExpressionIterator: IteratorProtocol {
    private var queue: [ExpressionOrStatement] = []
    var inspectBlocks: Bool
    
    public init(expression: Expression, inspectBlocks: Bool) {
        self.inspectBlocks = inspectBlocks
        enqueue(expression)
    }
    
    public init(statement: Statement, inspectBlocks: Bool) {
        self.inspectBlocks = inspectBlocks
        enqueue(statement)
    }
    
    public func next() -> Expression? {
        if queue.isEmpty {
            return nil
        }
        
        let next = queue.removeFirst()
        
        switch next {
        case .expression(let exp):
            enqueue(contentsOf: exp.subExpressions)
            
            if inspectBlocks, let block = exp as? BlockLiteralExpression {
                enqueue(contentsOf: block.body)
            }
            
            return exp
        case .statement(let statement):
            
            switch statement {
            case let stmt as ExpressionsStatement:
                enqueue(contentsOf: stmt.expressions)
            case let stmt as IfStatement:
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
                if let elseBody = stmt.elseBody {
                    enqueue(contentsOf: elseBody)
                }
            case let stmt as CompoundStatement:
                enqueue(contentsOf: stmt)
            case let stmt as ReturnStatement:
                if let exp = stmt.exp {
                    enqueue(exp)
                }
            case let stmt as DeferStatement:
                enqueue(contentsOf: stmt.body)
            case let stmt as DoStatement:
                enqueue(contentsOf: stmt.body)
            case let stmt as ForStatement:
                enqueue(pattern: stmt.pattern)
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
            case let stmt as SwitchStatement:
                enqueue(stmt.exp)
                stmt.cases.forEach(enqueue)
                if let def = stmt.defaultCase {
                    enqueue(contentsOf: def)
                }
            case let stmt as VariableDeclarationsStatement:
                for decl in stmt.decl {
                    if let exp = decl.initialization {
                        enqueue(exp)
                    }
                }
            case let stmt as WhileStatement:
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
            default:
                break
            }
            
            // Pull next expression now
            return self.next()
        }
    }
    
    private func enqueue(switchCase: SwitchCase) {
        switchCase.patterns.forEach(enqueue)
        
        enqueue(contentsOf: switchCase.statements)
    }
    
    private func enqueue(pattern: Pattern) {
        switch pattern {
        case .expression(let exp):
            enqueue(exp)
        case .tuple(let patterns):
            patterns.forEach(enqueue)
        case .identifier:
            break
        }
    }
    
    private func enqueue(_ expression: Expression) {
        queue.append(.expression(expression))
    }
    
    private func enqueue(contentsOf expressions: [Expression]) {
        queue.append(contentsOf: expressions.map { .expression($0) })
    }
    
    private func enqueue(_ statement: Statement) {
        queue.append(.statement(statement))
    }
    
    private func enqueue(contentsOf statements: [Statement]) {
        queue.append(contentsOf: statements.map { .statement($0) })
    }
    
    private func enqueue<S: Sequence>(contentsOf statements: S) where S.Element == Statement {
        queue.append(contentsOf: statements.map { .statement($0) })
    }
    
    private enum ExpressionOrStatement {
        case expression(Expression)
        case statement(Statement)
    }
}

public final class ExpressionSequence: Sequence {
    private var source: ExpressionOrStatement
    private var inspectBlocks: Bool
    
    public init(expression: Expression, inspectBlocks: Bool) {
        self.source = .expression(expression)
        self.inspectBlocks = inspectBlocks
    }
    
    public init(statement: Statement, inspectBlocks: Bool) {
        self.source = .statement(statement)
        self.inspectBlocks = inspectBlocks
    }
    
    public func makeIterator() -> ExpressionIterator {
        switch source {
        case .expression(let exp):
            return ExpressionIterator(expression: exp, inspectBlocks: inspectBlocks)
        case .statement(let stmt):
            return ExpressionIterator(statement: stmt, inspectBlocks: inspectBlocks)
        }
    }
    
    private enum ExpressionOrStatement {
        case expression(Expression)
        case statement(Statement)
    }
}
