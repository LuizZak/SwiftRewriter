/// A class for iterating over Statement trees.
public final class StatementIterator: IteratorProtocol {
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
    
    public func next() -> Statement? {
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
            
            return self.next()
            
        case .statement(let statement):
            if let stmt = statement.asExpressions {
                enqueue(contentsOf: stmt.expressions)
            } else if let stmt = statement.asIf {
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
                if let elBody = stmt.elseBody {
                    enqueue(contentsOf: elBody)
                }
            } else if let stmt = statement.asCompound {
                enqueue(contentsOf: stmt)
            } else if let stmt = statement.asDefer {
                enqueue(contentsOf: stmt.body)
            } else if let stmt = statement.asDoStatement {
                enqueue(contentsOf: stmt.body)
            } else if let stmt = statement.asFor {
                enqueue(pattern: stmt.pattern)
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
            } else if let stmt = statement.asReturn {
                if let exp = stmt.exp {
                    enqueue(exp)
                }
            } else if let stmt = statement.asSwitch {
                enqueue(stmt.exp)
                stmt.cases.forEach(enqueue)
                if let def = stmt.defaultCase {
                    enqueue(contentsOf: def)
                }
            } else if let stmt = statement.asVariableDeclaration {
                for decl in stmt.decl {
                    if let exp = decl.initialization {
                        enqueue(exp)
                    }
                }
            } else if let stmt = statement.asWhile {
                enqueue(stmt.exp)
                enqueue(contentsOf: stmt.body)
            }
            
            return statement
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

public final class StatementSequence: Sequence {
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
    
    public func makeIterator() -> StatementIterator {
        switch source {
        case .expression(let exp):
            return StatementIterator(expression: exp, inspectBlocks: inspectBlocks)
        case .statement(let stmt):
            return StatementIterator(statement: stmt, inspectBlocks: inspectBlocks)
        }
    }
    
    private enum ExpressionOrStatement {
        case expression(Expression)
        case statement(Statement)
    }
}
