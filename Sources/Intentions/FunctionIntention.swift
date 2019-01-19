import SwiftAST

/// Defines a protocol for function-generating intentions
public protocol FunctionIntention: IntentionProtocol {
    var parameters: [ParameterSignature] { get }
    
    var functionBody: FunctionBodyIntention? { get }
}
