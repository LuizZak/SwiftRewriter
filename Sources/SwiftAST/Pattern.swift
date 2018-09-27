/// A pattern for pattern-matching
public enum Pattern: Equatable {
    /// An identifier pattern
    case identifier(String)
    
    /// An expression pattern
    case expression(Expression)
    
    /// A tuple pattern
    indirect case tuple([Pattern])
    
    /// Simplifies patterns that feature 1-item tuples (i.e. `(<item>)`) by unwrapping
    /// the inner patterns.
    public var simplified: Pattern {
        switch self {
        case .tuple(let pt) where pt.count == 1:
            return pt[0].simplified
        default:
            return self
        }
    }
    
    public static func fromExpressions(_ expr: [Expression]) -> Pattern {
        if expr.count == 1 {
            return .expression(expr[0])
        }
        
        return .tuple(expr.map { .expression($0) })
    }
    
    public func copy() -> Pattern {
        switch self {
        case .identifier:
            return self
        case .expression(let exp):
            return .expression(exp.copy())
        case .tuple(let patterns):
            return .tuple(patterns.map { $0.copy() })
        }
    }
    
    internal func setParent(_ node: SyntaxNode?) {
        switch self {
        case .expression(let exp):
            exp.parent = node
            
        case .tuple(let tuple):
            tuple.forEach { $0.setParent(node) }
            
        case .identifier:
            break
        }
    }
    
    internal func collect(expressions: inout [SyntaxNode]) {
        switch self {
        case .expression(let exp):
            expressions.append(exp)
            
        case .tuple(let tuple):
            tuple.forEach { $0.collect(expressions: &expressions) }
            
        case .identifier:
            break
        }
    }
}

extension Pattern: CustomStringConvertible {
    public var description: String {
        switch self.simplified {
        case .tuple(let tups):
            return "(" + tups.map({ $0.description }).joined(separator: ", ") + ")"
        case .expression(let exp):
            return exp.description
        case .identifier(let ident):
            return ident
        }
    }
}
