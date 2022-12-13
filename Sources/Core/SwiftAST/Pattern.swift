/// A pattern for pattern-matching
public enum Pattern: Codable, Equatable, ExpressionComponent {
    /// An identifier pattern
    case identifier(String)
    
    /// An expression pattern
    case expression(Expression)
    
    /// A tuple pattern
    indirect case tuple([Pattern])

    /// A wildcard pattern (or `_`).
    case wildcard
    
    /// Simplifies patterns that feature 1-item tuples (i.e. `(<item>)`) by
    /// unwrapping the inner patterns.
    public var simplified: Pattern {
        switch self {
        case .tuple(let pt) where pt.count == 1:
            return pt[0].simplified
        default:
            return self
        }
    }
    
    /// Returns a list of sub-expressions contained within this pattern.
    public var subExpressions: [Expression] {
        switch self {
        case .expression(let exp):
            return [exp]
            
        case .tuple(let tuple):
            return tuple.flatMap { $0.subExpressions }
            
        case .identifier, .wildcard:
            return []
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let discriminator = try container.decode(String.self, forKey: .discriminator)
        
        switch discriminator {
        case "identifier":
            try self = .identifier(container.decode(String.self, forKey: .payload))
            
        case "expression":
            try self = .expression(container.decodeExpression(forKey: .payload))
            
        case "tuple":
            try self = .tuple(container.decode([Pattern].self, forKey: .payload))
        
        case "wildcard":
            self = .wildcard
            
        default:
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.discriminator,
                in: container,
                debugDescription: "Invalid discriminator tag \(discriminator)"
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .identifier(let ident):
            try container.encode("identifier", forKey: .discriminator)
            try container.encode(ident, forKey: .payload)
            
        case .expression(let exp):
            try container.encode("expression", forKey: .discriminator)
            try container.encodeExpression(exp, forKey: .payload)
            
        case .tuple(let pattern):
            try container.encode("tuple", forKey: .discriminator)
            try container.encode(pattern, forKey: .payload)
        
        case .wildcard:
            try container.encode("wildcard", forKey: .discriminator)
        }
    }
    
    public static func fromExpressions(_ expr: [Expression]) -> Pattern {
        if expr.count == 1 {
            return .expression(expr[0])
        }
        
        return .tuple(expr.map { .expression($0) })
    }
    
    @inlinable
    public func copy() -> Pattern {
        switch self {
        case .identifier:
            return self
        case .expression(let exp):
            return .expression(exp.copy())
        case .tuple(let patterns):
            return .tuple(patterns.map { $0.copy() })
        case .wildcard:
            return .wildcard
        }
    }
    
    internal func setParent(_ node: SyntaxNode?) {
        switch self {
        case .expression(let exp):
            exp.parent = node
            
        case .tuple(let tuple):
            tuple.forEach { $0.setParent(node) }
            
        case .identifier, .wildcard:
            break
        }
    }
    
    internal func collect(expressions: inout [SyntaxNode]) {
        switch self {
        case .expression(let exp):
            expressions.append(exp)
            
        case .tuple(let tuple):
            tuple.forEach { $0.collect(expressions: &expressions) }
            
        case .identifier, .wildcard:
            break
        }
    }
    
    /// Returns a sub-pattern in this pattern on a specified pattern location.
    ///
    /// - Parameter location: Location of pattern to search
    /// - Returns: `self`, if `location == .self`, or a sub-pattern within.
    /// Returns `nil`, if the location is invalid within this pattern.
    func subPattern(at location: PatternLocation) -> Pattern? {
        switch (location, self) {
        case (.self, _):
            return self
            
        case let (.tuple(index, subLocation), .tuple(subPatterns)):
            if index >= subPatterns.count {
                return nil
            }
            
            return subPatterns[index].subPattern(at: subLocation)
            
        default:
            return nil
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case discriminator
        case payload
    }
}

extension Pattern: CustomStringConvertible {
    public var description: String {
        switch self.simplified {
        case .tuple(let tups):
            return "(" + tups.map(\.description).joined(separator: ", ") + ")"
        case .expression(let exp):
            return exp.description
        case .identifier(let ident):
            return ident
        case .wildcard:
            return "_"
        }
    }
}

/// Allows referencing a location within a pattern for an identifier, an
/// expression or a tuple-pattern.
///
/// - `self`: The root pattern itself
/// - tuple: The tuple within the pattern, at a given index, with a given nested
/// sub-pattern.
public enum PatternLocation: Hashable {
    /// The root pattern itself
    case `self`
    
    /// The tuple within the pattern, at a given index, with a given nested
    /// sub-pattern.
    indirect case tuple(index: Int, pattern: PatternLocation)
}
