import SwiftAST

/// An intention to generate a property or method on a type
public class MemberGenerationIntention: FromSourceIntention {
    /// Type this member generation intention belongs to
    public internal(set) weak var type: TypeGenerationIntention?
    
    /// Returns whether this member is static (i.e. class member).
    /// Defaults to `false`, unless overriden by a subclass.
    public var isStatic: Bool { return false }
    
    public var semantics: Set<Semantic> = []
    public var annotations: [String] = []
    
    public var memberType: SwiftType {
        fatalError("Must be overriden by subtypes")
    }
}

extension MemberGenerationIntention: KnownMember {
    public var ownerType: KnownTypeReference? {
        return type?.asKnownTypeReference
    }
}
