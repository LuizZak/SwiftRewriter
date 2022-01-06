/// A class for iterating over Statement and Expression trees in first-in-first-out
/// order (i.e. depth-first).
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
            if inspectBlocks || !(exp is BlockLiteralExpression) {
                enqueue(contentsOf: exp.children)
            }

        case let stmt as Statement:
            if inspectBlocks || !(stmt is LocalFunctionStatement) {
                enqueue(contentsOf: stmt.children)
            }
        
        case let catchBlock as CatchBlock:
            if let pattern = catchBlock.pattern {
                enqueue(pattern: pattern)
            }

            enqueue(catchBlock.body)
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
