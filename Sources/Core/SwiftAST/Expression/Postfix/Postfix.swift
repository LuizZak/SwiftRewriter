/// A postfix operation of a PostfixExpression
public class Postfix: ExpressionComponent, Codable, Equatable, CustomStringConvertible {
    /// Owning postfix expression for this postfix operator
    public internal(set) weak var postfixExpression: PostfixExpression?
    
    /// Custom metadata that can be associated with this postfix node
    public var metadata: [String: Any] = [:]
    
    /// The current postfix access kind for this postfix operand
    public var optionalAccessKind: OptionalAccessKind = .none
    
    public var description: String {
        switch optionalAccessKind {
        case .none:
            return ""
        case .safeUnwrap:
            return "?"
        case .forceUnwrap:
            return "!"
        }
    }
    
    public var subExpressions: [Expression] {
        []
    }
    
    /// Resulting type for this postfix access
    public var returnType: SwiftType?
    
    internal init() {
        
    }
    
    public required init(from decoder: Decoder) throws {
        
    }
    
    public func copy() -> Postfix {
        fatalError("Must be overridden by subclasses")
    }
    
    public func withOptionalAccess(kind: OptionalAccessKind) -> Postfix {
        optionalAccessKind = kind
        return self
    }
    
    public func isEqual(to other: Postfix) -> Bool {
        false
    }
    
    public func encode(to encoder: Encoder) throws {
        
    }
    
    public static func == (lhs: Postfix, rhs: Postfix) -> Bool {
        lhs.isEqual(to: rhs)
    }
    
    /// Describes the optional access type for a postfix operator
    ///
    /// - none: No optional accessing - the default state for a postfix access
    /// - safeUnwrap: A safe-unwrap access (i.e. `exp?.value`)
    /// - forceUnwrap: A force-unwrap access (i.e. `exp!.value`)
    public enum OptionalAccessKind {
        case none
        case safeUnwrap
        case forceUnwrap
    }
}

extension Postfix {
    @inlinable
    public func copyTypeAndMetadata(from other: Postfix) -> Self {
        self.metadata = other.metadata
        self.returnType = other.returnType
        self.optionalAccessKind = other.optionalAccessKind
        
        return self
    }
}
