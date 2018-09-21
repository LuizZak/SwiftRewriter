import SwiftAST

/// Signature for a function intention
public struct FunctionSignature: Equatable, Codable {
    public var isMutating: Bool
    public var isStatic: Bool
    public var name: String
    public var returnType: SwiftType
    public var parameters: [ParameterSignature]
    
    public var asIdentifier: FunctionIdentifier {
        return FunctionIdentifier(name: name, parameterNames: parameters.map { $0.label })
    }
    
    /// The cannonical selector signature for this function signature.
    public var asSelector: SelectorSignature {
        return
            SelectorSignature(
                isStatic: isStatic,
                keywords: [name] + parameters.map { $0.label }
            )
    }
    
    // TODO: Support suplying type attributes for function signatures
    /// Returns a `SwiftType.block`-equivalent type for this function signature
    public var swiftClosureType: SwiftType {
        return .swiftBlock(returnType: returnType,
                           parameters: parameters.map { $0.type })
    }
    
    public var droppingNullability: FunctionSignature {
        let parameters = self.parameters.map {
            ParameterSignature(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
        }
        
        return FunctionSignature(name: name,
                                 parameters: parameters,
                                 returnType: returnType.deepUnwrapped,
                                 isStatic: isStatic,
                                 isMutating: isMutating)
    }
    
    public init(name: String,
                parameters: [ParameterSignature] = [],
                returnType: SwiftType = .void,
                isStatic: Bool = false,
                isMutating: Bool = false) {
        
        self.isStatic = isStatic
        self.name = name
        self.returnType = returnType
        self.parameters = parameters
        self.isMutating = isMutating
    }
    
    /// Returns a set of possible selector signature variations for this function
    /// signature when permutating over default argument type variations.
    ///
    /// e.g.: Given the following signature:
    ///
    /// ```
    /// foo(bar: Int, baz: Int = default, _ zaz: Int = default)
    /// ```
    ///
    /// permutated selector signature set returned by this method would be:
    ///
    /// ```
    /// foo:bar:
    /// foo:bar:baz:
    /// foo:bar::
    /// foo:bar:baz:
    /// ```
    ///
    /// or the Swift equivalent signature:
    ///
    /// ```
    /// foo(bar:)
    /// foo(bar:baz:)
    /// foo(bar:_:)
    /// foo(bar:baz:_:)
    /// ```
    public func possibleSelectorSignatures() -> Set<SelectorSignature> {
        let defaultArgIndices =
            parameters.enumerated()
                .filter { $0.element.hasDefaultValue }
                .map { $0.offset }
        
        if defaultArgIndices.count == 0 {
            return [asSelector]
        }
        
        // Use a simple counter which increments sequentially, and use the bit
        // representation of the counter to produce the permutations.
        // Each bit represents the nth parameter with a default value, with 1
        // being _with_ the parameter, and 0 being _without_ it.
        let combinations = 1 << defaultArgIndices.count
        
        var set: Set<SelectorSignature> = []
        
        for i in 0..<combinations {
            var keywords: [String?] = [name]
            var nextDefaultArgIndex = 0
            
            for param in parameters {
                if !param.hasDefaultValue {
                    keywords.append(param.label)
                    continue
                }
                
                // Check if bit is set
                if (i >> nextDefaultArgIndex) & 1 == 1 {
                    keywords.append(param.label)
                }
                
                nextDefaultArgIndex += 1
            }
            
            set.insert(SelectorSignature(isStatic: isStatic, keywords: keywords))
        }
        
        return set
    }
    
    /// Returns `true` iff `self` and `other` match using Swift signature matching
    /// rules.
    ///
    /// Along with label names, argument and return types are also checked for
    /// equality, effectively allowing 'overloads' of functions to be described.
    ///
    /// No alias checking is performed, so parameters/returns with different type
    /// names will always differ.
    public func matchesAsSwiftFunction(_ other: FunctionSignature) -> Bool {
        if name != other.name {
            return false
        }
        if returnType != other.returnType {
            return false
        }
        if parameters.count != other.parameters.count {
            return false
        }
        
        for (p1, p2) in zip(parameters, other.parameters) {
            if p1.label != p2.label {
                return false
            }
            if p1.type != p2.type {
                return false
            }
        }
        
        return true
    }
    
    /// Returns `true` iff `self` and `other` match using Objective-C signature
    /// matching rules.
    public func matchesAsSelector(_ other: FunctionSignature) -> Bool {
        return asSelector == other.asSelector
    }
    
    /// Returns `true` iff `self` and `other` match using C signature matching
    /// rules.
    ///
    /// In C, function signatures match if they have the same name, and the same
    /// number of parameters.
    public func matchesAsCFunction(_ other: FunctionSignature) -> Bool {
        return name == other.name && parameters.count == other.parameters.count
    }
}

public extension Sequence where Element == ParameterSignature {
    
    public func argumentLabels() -> [String?] {
        return map { $0.label }
    }
}

public extension FunctionSignature {
    public init(isStatic: Bool = false, signatureString: String) throws {
        self = try FunctionSignatureParser.parseSignature(from: signatureString)
        self.isStatic = isStatic
    }
}

public extension Array where Element == ParameterSignature {
    public init(parsingParameters parametersString: String) throws {
        self = try FunctionSignatureParser.parseParameters(from: parametersString)
    }
}
