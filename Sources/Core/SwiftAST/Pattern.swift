/// A pattern for pattern-matching
public enum Pattern: Codable, Equatable {
    /// An identifier pattern
    case identifier(String)
    
    /// An expression pattern
    case expression(Expression)
    
    /// A tuple pattern
    indirect case tuple([Pattern])
    
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
            
        default:
            throw DecodingError.dataCorruptedError(
                forKey: CodingKeys.discriminator,
                in: container,
                debugDescription: "Invalid discriminator tag \(discriminator)")
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
        }
    }
    
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
    
    /// Returns a sub-pattern in this pattern on a specified pattern location.
    ///
    /// - Parameter location: Location of pattern to search
    /// - Returns: `self`, if `location == .self`, or a subpattern within.
    /// Returns `nil`, if the location is invalid within this pattern.
    func subpattern(at location: PatternLocation) -> Pattern? {
        switch (location, self) {
        case (.self, _):
            return self
            
        case let (.tuple(index, subLocation), .tuple(subpatterns)):
            if index >= subpatterns.count {
                return nil
            }
            
            return subpatterns[index].subpattern(at: subLocation)
            
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
        }
    }
}

/// Allows referencing a location within a pattern for an identifier, an
/// expression or a tuple-pattern.
///
/// - `self`: The root pattern itself
/// - tuple: The tuple within the pattern, at a given index, with a given nested
/// subpattern.
public enum PatternLocation: Hashable {
    /// The root pattern itself
    case `self`
    /// The tuple within the pattern, at a given index, with a given nested
    /// subpattern.
    indirect case tuple(index: Int, pattern: PatternLocation)
}
