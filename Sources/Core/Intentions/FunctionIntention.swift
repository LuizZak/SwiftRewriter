import SwiftAST

/// Defines a protocol for function-generating intentions
public protocol FunctionIntention: IntentionProtocol {
    var functionBody: FunctionBodyIntention? { get }
}

/// Defines a protocol for function-generating intentions that contain a body
public protocol MutableFunctionIntention: FunctionIntention {
    var functionBody: FunctionBodyIntention? { get set }
}

/// Defines a protocol for function intentions that feature parameters
public protocol ParameterizedFunctionIntention: FunctionIntention {
    var parameters: [ParameterSignature] { get }
}

/// Defines a protocol for intentions that feature full function signatures
public protocol SignatureFunctionIntention: FunctionIntention {
    var signature: FunctionSignature { get }
}

/// Defines a protocol for intentions that feature full function signatures which
/// can be mutated freely
public protocol MutableSignatureFunctionIntention: SignatureFunctionIntention {
    var signature: FunctionSignature { get set }
}
