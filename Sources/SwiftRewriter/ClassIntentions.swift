/// An intention to generate a Swift class type
public class ClassGenerationIntention: TypeGenerationIntention {
    public func addProperty(_ intention: PropertyGenerationIntention) {
        self.properties.append(intention)
    }
    
    public func addMethod(_ intention: MethodGenerationIntention) {
        self.methods.append(intention)
    }
}
