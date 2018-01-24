/// An intention to generate a class, struct or enumeration in swift.
public class TypeGenerationIntention: Intention {
    private(set) public var properties: [PropertyGenerationIntention] = []
    private(set) public var methods: [MethodGenerationIntention] = []
}

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: Intention {
    
}

/// An intention to generate a static/instance function for a type.
public class MethodGenerationIntention: Intention {
    
}
