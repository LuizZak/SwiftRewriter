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
            case .expressions(let exps):
                enqueue(contentsOf: exps)
                
            case let .if(exp, body, elBody):
                enqueue(exp)
                enqueue(contentsOf: body)
                if let elBody = elBody {
                    enqueue(contentsOf: elBody)
                }
                
            case .compound(let cpd), .defer(let cpd), .do(let cpd):
                enqueue(contentsOf: cpd)
                
            case let .for(pt, exp, body):
                enqueue(pattern: pt)
                enqueue(exp)
                enqueue(contentsOf: body)
                
            case .return(let exp):
                if let exp = exp {
                    enqueue(exp)
                }
                
            case let .switch(exp, cases, def):
                enqueue(exp)
                cases.forEach(enqueue)
                if let def = def {
                    enqueue(contentsOf: def)
                }
                
            case .variableDeclarations(let declarations):
                for decl in declarations {
                    if let exp = decl.initialization {
                        enqueue(exp)
                    }
                }
                
            case let .while(exp, body):
                enqueue(exp)
                enqueue(contentsOf: body)
                
            case .continue, .break, .semicolon, .unknown:
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
