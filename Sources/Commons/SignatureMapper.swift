import SwiftAST

/// Provides simple signature mapping support by alowing rewriting the signature
/// keywords of a method signature or invocation
public class SignatureMapper {
    public let transformer: MethodInvocationTransformerMatcher
    
    /// Creates a new `SignatureConversion` instance with a given method invocation
    /// transformer.
    public init(transformer: MethodInvocationTransformerMatcher) {
        self.transformer = transformer
    }
}
