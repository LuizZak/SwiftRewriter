import KnownType

/// A code definition derived from a `KnownMember` instance
public class KnownMemberCodeDefinition: CodeDefinition {
    public let knownMember: KnownMember
    
    init(knownMember: KnownMember, ownerType: KnownType?) {
        self.knownMember = knownMember

        switch knownMember {
        case let prop as KnownProperty:
            super.init(
                variableNamed: prop.name,
                storage: prop.storage
            )
            
        case let method as KnownMethod:
            super.init(functionSignature: method.signature)

        case let sub as KnownSubscript:
            super.init(subscriptSignature: sub.signature)
        
        case let ctor as KnownConstructor:
            guard let ownerType = ownerType?.asKnownTypeReference ?? ctor.ownerType else {
                fatalError("Attempting to create a \(KnownMemberCodeDefinition.self) from \(Swift.type(of: knownMember)) that has a nil \(KnownMember.self).ownerType")
            }

            super.init(typeInitializer: ownerType, parameters: ctor.parameters)
        
        default:
            fatalError("Attempting to create a \(KnownMemberCodeDefinition.self) from unknown \(KnownMember.self)-type \(Swift.type(of: knownMember))")
        }
    }
}

public extension CodeDefinition {
    static func forKnownMember(_ knownMember: KnownMember) -> KnownMemberCodeDefinition {
        KnownMemberCodeDefinition(knownMember: knownMember, ownerType: nil)
    }
}
