import GrammarModels

/// An intention to generate a Swift class type
public class ClassGenerationIntention: TypeGenerationIntention {
    public func setSuperclassIntention(_ superclassName: String) {
        self.superclassName = superclassName
    }
    
    public func addProtocol(_ intention: ProtocolInheritanceIntention) {
        self.protocols.append(intention)
    }
    
    public func addProperty(_ intention: PropertyGenerationIntention) {
        self.properties.append(intention)
    }
    
    public func addMethod(_ intention: MethodGenerationIntention) {
        self.methods.append(intention)
    }
}

/// An intention to conform a class to a protocol
public class ProtocolInheritanceIntention: FromSourceIntention {
    public var protocolName: String
    
    public init(protocolName: String, scope: AccessLevel = .internal, source: ASTNode? = nil) {
        self.protocolName = protocolName
        
        super.init(scope: scope, source: source)
    }
}
