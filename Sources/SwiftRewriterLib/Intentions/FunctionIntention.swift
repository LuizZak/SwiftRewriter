/// Defines a protocol for function-generating intentions
public protocol FunctionIntention: Intention {
    var parameters: [ParameterSignature] { get }
    
    var functionBody: FunctionBodyIntention? { get }
}
