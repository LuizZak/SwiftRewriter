import GrammarModels

/// An intention to conform a class to a protocol
public class ProtocolInheritanceIntention: FromSourceIntention, KnownProtocolConformance {
    public var protocolName: String
    
    public init(protocolName: String, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.protocolName = protocolName
        
        super.init(accessLevel: accessLevel, source: source)
    }
}
