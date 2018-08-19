import SwiftAST
import SwiftRewriterLib

/// Provides simple signature mapping support by alowing rewriting the signature
/// keywords of a method signature or invocation
public class SignatureMapper {
    public let from: FunctionSignature
    public let to: FunctionSignature
    
    /// Creates a new `SignatureConversion` instance with a given source and target
    /// signatures to convert.
    ///
    /// Count of parameters on both signatures must match (i.e. cannot change the
    /// number of arguments of a method)
    ///
    /// - precondition: `from.parameters.count == to.parameters.count`
    /// - precondition: `!from.parameters.isEmpty`
    public init(from: FunctionSignature, to: FunctionSignature) {
        precondition(from.parameters.count == to.parameters.count,
                     "from.parameters.count == to.parameters.count")
        
        self.from = from
        self.to = to
    }
    
    public func canApply(to signature: FunctionSignature) -> Bool {
        return signature.asSelector == from.asSelector
    }
    
    public func apply(to signature: inout FunctionSignature) -> Bool {
        guard signature.asSelector == from.asSelector else {
            return false
        }
        
        signature.name = to.name
        
        for i in 0..<to.parameters.count {
            signature.parameters[i].label = to.parameters[i].label
            
            if to.parameters[i].type != .ignoredMappingType {
                signature.parameters[i].type = to.parameters[i].type
            }
        }
        
        return true
    }
}

public struct SignatureMapperBuilder {
    private var mappings: [SignatureMapper] = []
    
    public func map(from: FunctionSignature, to: FunctionSignature) -> SignatureMapperBuilder {
        var new = clone()
        new.mappings.append(SignatureMapper(from: from, to: to))
        
        return new
    }
    
    public func map(from: SelectorSignature, to: SelectorSignature) -> SignatureMapperBuilder {
        let signatureFrom =
            FunctionSignature(
                name: from.keywords[0] ?? "__",
                parameters: from.keywords.dropFirst().map {
                    ParameterSignature(label: $0 ?? "_", name: $0 ?? "param", type: .int)
                },
                returnType: .void,
                isStatic: from.isStatic)
        
        let signatureTo =
            FunctionSignature(
                name: to.keywords[0] ?? "__",
                parameters: to.keywords.dropFirst().map {
                    ParameterSignature(label: $0 ?? "_", name: $0 ?? "param", type: .int)
                },
                returnType: .void,
                isStatic: to.isStatic)
        
        var new = clone()
        new.mappings.append(SignatureMapper(from: signatureFrom, to: signatureTo))
        
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
        
        let signatureFrom =
            FunctionSignature(
                name: fromKeywords[0] ?? "__",
                parameters: fromKeywords.dropFirst().map {
                    ParameterSignature(label: $0 ?? "_",
                                       name: $0 ?? "param",
                                       type: .ignoredMappingType)
                },
                returnType: .ignoredMappingType,
                isStatic: isStatic)
        
        let signatureTo =
            FunctionSignature(
                name: toKeywords[0] ?? "__",
                parameters: toKeywords.dropFirst().map {
                    ParameterSignature(label: $0 ?? "_",
                                       name: $0 ?? "param",
                                       type: .ignoredMappingType)
                },
                returnType: .ignoredMappingType,
                isStatic: isStatic)
        
        new.mappings.append(SignatureMapper(from: signatureFrom, to: signatureTo))
        
        return new
    }
    
    public func build() -> [SignatureMapper] {
        return mappings
    }
    
    private func clone() -> SignatureMapperBuilder {
        return self
    }
}

public extension SwiftType {
    public static var ignoredMappingType = SwiftType.typeName("__ignored type name__")
}
