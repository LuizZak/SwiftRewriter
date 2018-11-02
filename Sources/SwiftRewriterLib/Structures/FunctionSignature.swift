import SwiftAST

/// Signature for a function intention
public struct FunctionSignature: Hashable {
    private var _asIdentifier: FunctionIdentifier = FunctionIdentifier(name: "", parameterNames: [])
    private var _asSelector: SelectorSignature = SelectorSignature(isStatic: false, keywords: [])
    
    public var isMutating: Bool {
        didSet {
            _recreateAliases()
        }
    }
    public var isStatic: Bool {
        didSet {
            _recreateAliases()
        }
    }
    public var name: String {
        didSet {
            _recreateAliases()
        }
    }
    public var returnType: SwiftType {
        didSet {
            _recreateAliases()
        }
    }
    public var parameters: [ParameterSignature] {
        didSet {
            _recreateAliases()
        }
    }
    
    public var asIdentifier: FunctionIdentifier {
        return _asIdentifier
    }
    
    /// The cannonical selector signature for this function signature.
    public var asSelector: SelectorSignature {
        return _asSelector
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
        
        _asIdentifier = FunctionIdentifier(name: name, parameterNames: parameters.map { $0.label })
        _asSelector = SelectorSignature(isStatic: isStatic, keywords: [name] + parameters.map { $0.label })
        self.isStatic = isStatic
        self.name = name
        self.returnType = returnType
        self.parameters = parameters
        self.isMutating = isMutating
    }
    
    private mutating func _recreateAliases() {
        _asIdentifier = FunctionIdentifier(name: name, parameterNames: parameters.map { $0.label })
        _asSelector = SelectorSignature(isStatic: isStatic, keywords: [name] + parameters.map { $0.label })
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
    /// foo:bar:baz::
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
        if !parameters.contains(where: { $0.hasDefaultValue }) {
            return [asSelector]
        }
        
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

extension FunctionSignature: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try isMutating = container.decode(Bool.self, forKey: .isMutating)
        try isStatic = container.decode(Bool.self, forKey: .isStatic)
        try name = container.decode(String.self, forKey: .name)
        try returnType = container.decode(SwiftType.self, forKey: .returnType)
        try parameters = container.decode([ParameterSignature].self, forKey: .parameters)
        
        _recreateAliases()
    }
    
    public enum CodingKeys: String, CodingKey {
        case isMutating
        case isStatic
        case name
        case returnType
        case parameters
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
