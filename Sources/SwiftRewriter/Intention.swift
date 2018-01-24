/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc.
public protocol Intention {
    
}

/// An intention to create a .swift file
public class FileGenerationIntention: Intention {
    /// Gets the types to create on this file.
    private(set) var typeIntentions: [TypeGenerationIntention] = []
    
    /// Gets the global functions to create on this file.
    private(set) var globalFunctionIntentions: [FunctionGenerationIntention] = []
}

/// An intention to generate a function. Can represent either a global function,
/// or a static/instance method of a type.
public class FunctionGenerationIntention: Intention {
    
}
