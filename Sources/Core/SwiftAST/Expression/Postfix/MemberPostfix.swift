public final class MemberPostfix: Postfix {
    public let name: String
    
    public override var description: String {
        "\(super.description).\(name)"
    }
    
    public init(name: String) {
        self.name = name
        
        super.init()
    }
    
    public required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try self.init(name: container.decode(String.self, forKey: .name))
    }
    
    public override func copy() -> MemberPostfix {
        MemberPostfix(name: name).copyTypeAndMetadata(from: self)
    }
    
    public override func isEqual(to other: Postfix) -> Bool {
        switch other {
        case let rhs as MemberPostfix:
            return self == rhs
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        
        try super.encode(to: container.superEncoder())
    }
    
    public static func == (lhs: MemberPostfix, rhs: MemberPostfix) -> Bool {
        if lhs === rhs {
            return true
        }
        
        return lhs.optionalAccessKind == rhs.optionalAccessKind && lhs.name == rhs.name
    }
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
public extension Postfix {
    static func member(_ name: String) -> MemberPostfix {
        MemberPostfix(name: name)
    }
    
    @inlinable
    var asMember: MemberPostfix? {
        self as? MemberPostfix
    }

    @inlinable
    var isMember: Bool {
        asMember != nil
    }
}
// Helper casting getter extensions to postfix expression
public extension PostfixExpression {
    @inlinable
    var member: MemberPostfix? {
        op as? MemberPostfix
    }

    @inlinable
    var isMember: Bool {
        member != nil
    }
}
