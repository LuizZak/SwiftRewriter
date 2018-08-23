import SwiftAST
import SwiftRewriterLib

/// Provides simple signature mapping support by alowing rewriting the signature
/// keywords of a method signature or invocation
public class SignatureMapper {
    public let transformer: MethodInvocationTransformerMatcher
    
    /// Creates a new `SignatureConversion` instance with a given method invocation
    /// transformer.
    public init(transformer: MethodInvocationTransformerMatcher) {
        self.transformer = transformer
    }
    
    func canApply(to signature: FunctionSignature) -> Bool {
        return signature.asIdentifier == transformer.identifier
    }
    
    func apply(to signature: inout FunctionSignature) -> Bool {
        if !canApply(to: signature) {
            return false
        }
        
        signature = transformer.transformer.rewriteSignature(signature)
        
        return true
    }
    
    public class ArgumentGenerator {
        public let argumentStrategy: ArgumentRewritingStrategy
        public let type: SwiftType
        
        public init(argumentStrategy: ArgumentRewritingStrategy, type: SwiftType) {
            self.argumentStrategy = argumentStrategy
            self.type = type
        }
    }
}
