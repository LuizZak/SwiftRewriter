/// An intention to generate a Swift class type
public final class ClassGenerationIntention: BaseClassIntention {
    public var superclassName: String?
    
    public override var isEmptyType: Bool {
        return super.isEmptyType
    }
    
    public override var supertype: KnownTypeReference? {
        if let superclassName = superclassName {
            return KnownTypeReference.typeName(superclassName)
        }
        
        return nil
    }
    
    public func setSuperclassIntention(_ superclassName: String) {
        self.superclassName = superclassName
    }
}
