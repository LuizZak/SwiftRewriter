/// An intention to generate a class extension from an existing class
public final class ClassExtensionGenerationIntention: BaseClassIntention {
    /// Original Objective-C category name that originated this category.
    public var categoryName: String?
    
    public override var isExtension: Bool {
        return true
    }
}
