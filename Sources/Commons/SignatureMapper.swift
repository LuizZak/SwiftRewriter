import SwiftAST
import SwiftRewriterLib

/// Provides simple signature mapping support by alowing rewriting the signature
/// keywords of a method signature or invocation
public class SignatureMapper {
    let from: SelectorSignature
    let to: SelectorSignature
    
    /// Creates a new `SignatureConversion` instance with a given source and target
    /// signatures to convert.
    ///
    /// Count of keywords on both signatures must match (i.e. cannot change the
    /// number of arguments of a method)
    ///
    /// - precondition: `from.count == to.count`
    /// - precondition: `from.count > 0`
    public init(from: SelectorSignature, to: SelectorSignature) {
        precondition(from.keywords.count == to.keywords.count, "from.keywords.count == to.keywords.count")
        precondition(!from.keywords.isEmpty, "!from.keywords.isEmpty")
        
        self.from = from
        self.to = to
    }
    
    public func canApply(to signature: FunctionSignature) -> Bool {
        return signature.asSelector == from
    }
    
    public func apply(to signature: inout FunctionSignature) -> Bool {
        guard signature.asSelector == from else {
            return false
        }
        
        signature.name = to.keywords[0] ?? "__"
        
        for i in 0..<to.keywords.count - 1 {
            signature.parameters[i].label = to.keywords[i + 1] ?? "_"
        }
        
        return true
    }
}

public struct SignatureMapperBuilder {
    private var mappings: [SignatureMapper] = []
    
    public func map(from: SelectorSignature, to: SelectorSignature) -> SignatureMapperBuilder {
        var new = clone()
        new.mappings.append(SignatureMapper(from: from, to: to))
        
        return new
    }
    
    public func map(signature: SignatureMapper) -> SignatureMapperBuilder {
        var new = clone()
        new.mappings.append(signature)
        
        return new
    }
    
    public func mapKeywords(from fromKeywords: [String?], to toKeywords: [String?],
                            isStatic: Bool = false) -> SignatureMapperBuilder {
        var new = clone()
        
        let signFrom = SelectorSignature(isStatic: isStatic, keywords: fromKeywords)
        let signTo = SelectorSignature(isStatic: isStatic, keywords: toKeywords)
        
        new.mappings.append(SignatureMapper(from: signFrom, to: signTo))
        
        return new
    }
    
    public func build() -> [SignatureMapper] {
        return mappings
    }
    
    private func clone() -> SignatureMapperBuilder {
        return self
    }
}
