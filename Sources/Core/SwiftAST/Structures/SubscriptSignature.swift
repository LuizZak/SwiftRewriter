/// Signature for a subscript intention
public struct SubscriptSignature: Hashable {
    private var _asIdentifier: SubscriptIdentifier = SubscriptIdentifier(argumentLabels: [])

    /// Whether the subscript is static, i.e. `static subscript` in Swift.
    public var isStatic: Bool

    /// The return type of the subscript signature
    public var returnType: SwiftType

    /// The list of parameters for the subscript
    public var parameters: [ParameterSignature] {
        didSet {
            _recreateAliases()
        }
    }
    
    /// Gets a subscript identifier for this subscript's name and parameter labels.
    public var asIdentifier: SubscriptIdentifier {
        _asIdentifier
    }
    
    /// Returns a new subscript signature where parameters and return type have
    /// their nullability stripped off.
    public var droppingNullability: SubscriptSignature {
        let parameters = self.parameters.map {
            ParameterSignature(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
        }
        
        return SubscriptSignature(
            parameters: parameters,
            returnType: returnType.deepUnwrapped,
            isStatic: isStatic
        )
    }
    
    /// Returns a `SwiftType.block`-equivalent type for this subscript signature
    public var swiftClosureType: SwiftType {
        .swiftBlock(
            returnType: returnType,
            parameters: parameters.map(\.type)
        )
    }
    
    public init(
        parameters: [ParameterSignature] = [],
        returnType: SwiftType = .void,
        isStatic: Bool = false
    ) {
        
        self.returnType = returnType
        self.parameters = parameters
        self.isStatic = isStatic
    }
    
    private mutating func _recreateAliases() {
        _asIdentifier = SubscriptIdentifier(argumentLabels: parameters.map(\.label))
    }
    
    /// Returns a set of possible subscript identifier signature variations for
    /// this subscript signature when permuting over default argument type variations.
    ///
    /// e.g.: Given the following signature:
    ///
    /// ```
    /// subscript(bar: Int, baz: Int = default, _ zaz: Int = default)
    /// ```
    ///
    /// permuting identifier signature set returned by this method would be:
    ///
    /// ```
    /// subscript(bar:)
    /// subscript(bar:baz:)
    /// subscript(bar:_:)
    /// subscript(bar:baz:_:)
    /// ```
    public func possibleIdentifierSignatures() -> Set<SubscriptIdentifier> {
        if !parameters.contains(where: \.hasDefaultValue) {
            return [asIdentifier]
        }
        
        let defaultArgIndices =
            parameters.enumerated()
                .filter(\.element.hasDefaultValue)
                .map(\.offset)
        
        if defaultArgIndices.isEmpty {
            return [asIdentifier]
        }
        
        // Use a simple counter which increments sequentially, and use the bit
        // representation of the counter to produce the permutations.
        // Each bit represents the nth parameter with a default value, with 1
        // being _with_ the parameter, and 0 being _without_ it.
        let combinations = 1 << defaultArgIndices.count
        
        var set: Set<SubscriptIdentifier> = []
        
        for i in 0..<combinations {
            var paramLabels: [String?] = []
            var nextDefaultArgIndex = 0
            
            for param in parameters {
                if !param.hasDefaultValue {
                    paramLabels.append(param.label)
                    continue
                }
                
                // Check if bit is set
                if (i >> nextDefaultArgIndex) & 1 == 1 {
                    paramLabels.append(param.label)
                }
                
                nextDefaultArgIndex += 1
            }
            
            set.insert(SubscriptIdentifier(argumentLabels: paramLabels))
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
    public func matchesAsSwiftFunction(_ other: SubscriptSignature) -> Bool {
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
}

extension SubscriptSignature: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try returnType = container.decode(SwiftType.self, forKey: .returnType)
        try parameters = container.decode([ParameterSignature].self, forKey: .parameters)
        try isStatic = container.decode(Bool.self, forKey: .isStatic)
        
        _recreateAliases()
    }
    
    public enum CodingKeys: String, CodingKey {
        case returnType
        case parameters
        case isStatic
    }
}

extension SubscriptSignature: CustomStringConvertible {
    public var description: String {
        var result = ""
        if isStatic {
            result += "static "
        }

        result += "subscript"
        result += TypeFormatter.asString(parameters: parameters)
        
        if returnType != .void {
            result += " -> \(TypeFormatter.stringify(returnType))"
        }
        
        return result
    }
}

public extension SubscriptSignature {
    init(isStatic: Bool = false, subscriptSignature: String) throws {
        self = try FunctionSignatureParser.parseSubscriptSignature(from: subscriptSignature)
        self.isStatic = isStatic
    }
}
