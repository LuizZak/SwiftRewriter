import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to conform a class to a protocol
public final class ProtocolInheritanceIntention: FromSourceIntention, KnownProtocolConformance {
    public var protocolName: String
    
    public init(protocolName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.protocolName = protocolName
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.protocolName = try container.decode(String.self, forKey: .protocolName)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(protocolName, forKey: .protocolName)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitProtocolInheritance(self)
    }
    
    private enum CodingKeys: String, CodingKey {
        case protocolName
    }
}
