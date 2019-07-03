/// A class for iterating over Statement and Expression trees.
public final class SyntaxNodeIterator: IteratorProtocol {
    private var queue: [SyntaxNode] = []
    
    /// If `true`, iteration inspects statements within block expressions
    var inspectBlocks: Bool
    
    public init(expression: Expression, inspectBlocks: Bool) {
        self.inspectBlocks = inspectBlocks
        self.queue = [expression]
    }
    
    public init(statement: Statement, inspectBlocks: Bool) {
        self.inspectBlocks = inspectBlocks
        self.queue = [statement]
    }
    
    public init(node: SyntaxNode, inspectBlocks: Bool) {
        self.inspectBlocks = inspectBlocks
        self.queue = [node]
    }
    
    public func next() -> SyntaxNode? {
        if queue.isEmpty {
            return nil
        }
        
        let next = queue.removeFirst()
        
        switch next {
        case let exp as Expression:
            enqueue(contentsOf: exp.subExpressions)
            
            if inspectBlocks, let block = exp as? BlockLiteralExpression {
                enqueue(block.body)
            }
            
        case let statement as Statement:
            
            switch statement {
            case let stmt as ExpressionsStatement:
                enqueue(contentsOf: stmt.expressions)
                
            case let stmt as IfStatement:
                enqueue(stmt.exp)
                enqueue(stmt.body)
                if let elseBody = stmt.elseBody {
                    enqueue(elseBody)
                }
                
            case let stmt as CompoundStatement:
                enqueue(contentsOf: stmt)
                
            case let stmt as ReturnStatement:
                if let exp = stmt.exp {
                    enqueue(exp)
                }
                
            case let stmt as DeferStatement:
                enqueue(stmt.body)
                
            case let stmt as DoStatement:
                enqueue(stmt.body)
                
            case let stmt as ForStatement:
                enqueue(pattern: stmt.pattern)
                enqueue(stmt.exp)
                enqueue(stmt.body)
                
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
                enqueue(stmt.body)
                
            default:
                break
            }
        default:
            break
        }
        
        return next
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
    
    private func enqueue(switchCase: SwitchCase) {
        switchCase.patterns.forEach(enqueue)
        
        enqueue(contentsOf: switchCase.statements)
    }
    
    private func enqueue(_ syntaxNode: SyntaxNode) {
        queue.append(syntaxNode)
    }
    
    private func enqueue<S: Sequence>(contentsOf seq: S) where S.Element: SyntaxNode {
        queue.append(contentsOf: seq.map { $0 })
    }
}

public final class SyntaxNodeSequence: Sequence {
    private var node: SyntaxNode
    private var inspectBlocks: Bool
    
    public init(node: SyntaxNode, inspectBlocks: Bool) {
        self.node = node
        self.inspectBlocks = inspectBlocks
    }
    
    public func makeIterator() -> SyntaxNodeIterator {
        SyntaxNodeIterator(node: node, inspectBlocks: inspectBlocks)
    }
}
