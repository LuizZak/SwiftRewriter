import KnownType
import TypeSystem

public class IncompleteKnownType {
    
    private var knownTypeBuilder: KnownTypeBuilder
    
    public var typeName: String {
        knownTypeBuilder.typeName
    }
    
    public var kind: KnownTypeKind {
        knownTypeBuilder.kind
    }
    
    public var fields: [KnownProperty] {
        knownTypeBuilder.fields
    }
    
    public var properties: [KnownProperty] {
        knownTypeBuilder.properties
    }
    
    public var methods: [KnownMethod] {
        knownTypeBuilder.methods
    }
    
    public var constructors: [KnownConstructor] {
        knownTypeBuilder.constructors
    }
    
    public var attributes: [KnownAttribute] {
        knownTypeBuilder.attributes
    }
    
    public var subscripts: [KnownSubscript] {
        knownTypeBuilder.subscripts
    }
    
    public var traits: [String: TraitType] {
        knownTypeBuilder.traits
    }
    
    public var conformances: [KnownProtocolConformance] {
        knownTypeBuilder.conformances
    }
    
    public var nestedTypes: [KnownType] {
        knownTypeBuilder.nestedTypes
    }
    
    public init(typeBuilder: KnownTypeBuilder) {
        self.knownTypeBuilder = typeBuilder
    }
    
    public func modifying(with closure: (KnownTypeBuilder) -> KnownTypeBuilder) {
        knownTypeBuilder = closure(knownTypeBuilder)
    }
    
    public func complete(typeSystem: TypeSystem) -> KnownType {
        
        // We add all supertypes we find as protocol conformances since we can't
        // verify during parsing that a type is either a protocol or a class, here
        // we check for these protocol conformances to pick out which conformance
        // is actually a supertype name, thus allowing us to complete the type
        // properly.
        if knownTypeBuilder.supertype == nil {
            for conformance in knownTypeBuilder.protocolConformances {
                if typeSystem.isClassInstanceType(conformance) {
                    knownTypeBuilder = knownTypeBuilder
                        .removingConformance(to: conformance)
                        .settingSupertype(KnownTypeReference.typeName(conformance))
                    
                    break
                }
            }
        }
        
        return knownTypeBuilder.build()
    }
}
