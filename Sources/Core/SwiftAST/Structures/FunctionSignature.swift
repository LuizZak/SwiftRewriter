/// Signature for a function intention
public struct FunctionSignature: Hashable {
    private var _asIdentifier: FunctionIdentifier = FunctionIdentifier(name: "", argumentLabels: [])
    private var _asSelector: SelectorSignature = SelectorSignature(isStatic: false, keywords: [])

    /// Traits for this function signature.
    public var traits: Traits = [] {
        didSet {
            _recreateAliases()
        }
    }

    /// Whether the function is mutating, i.e. `mutating func` in Swift.
    public var isMutating: Bool {
        get {
            traits.contains(.mutating)
        }
        set {
            if newValue {
                traits.insert(.mutating)
            } else {
                traits.remove(.mutating)
            }
        }
    }

    /// Whether the function is static, i.e. `static func` in Swift.
    public var isStatic: Bool {
        get {
            traits.contains(.static)
        }
        set {
            if newValue {
                traits.insert(.static)
            } else {
                traits.remove(.static)
            }
        }
    }

    /// Whether the function is throwing, i.e. `throws` in Swift.
    public var isThrowing: Bool {
        get {
            traits.contains(.throwing)
        }
        set {
            if newValue {
                traits.insert(.throwing)
            } else {
                traits.remove(.throwing)
            }
        }
    }

    /// The identifier for the function name.
    ///
    /// E.g.:
    ///
    /// `func aFunction(_ a: Int, b: String)`
    ///
    /// Has the name:
    ///
    /// `aFunction`
    public var name: String {
        didSet {
            _recreateAliases()
        }
    }

    /// The return type of the function signature
    public var returnType: SwiftType

    /// The list of parameters for the function
    public var parameters: [ParameterSignature] {
        didSet {
            _recreateAliases()
        }
    }
    
    /// Gets a function identifier for this function's name and parameter labels.
    public var asIdentifier: FunctionIdentifier {
        _asIdentifier
    }
    
    /// The canonical selector signature for this function signature.
    public var asSelector: SelectorSignature {
        _asSelector
    }
    
    // TODO: Support supplying type attributes for function signatures
    /// Returns a `SwiftType.block`-equivalent type for this function signature
    public var swiftClosureType: BlockSwiftType {
        .init(
            returnType: returnType,
            parameters: parameters.map(\.type)
        )
    }
    
    /// Returns a new function signature where parameters and return type have
    /// their nullability stripped off.
    public var droppingNullability: FunctionSignature {
        let parameters = self.parameters.map {
            ParameterSignature(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
        }
        
        return FunctionSignature(
            name: name,
            parameters: parameters,
            returnType: returnType.deepUnwrapped,
            isStatic: isStatic,
            isMutating: isMutating
        )
    }
    
    public init(
        name: String,
        parameters: [ParameterSignature] = [],
        returnType: SwiftType = .void,
        isStatic: Bool = false,
        isMutating: Bool = false,
        isThrowing: Bool = false
    ) {
        
        self.traits = []
        self.name = name
        self.returnType = returnType
        self.parameters = parameters

        _asIdentifier = FunctionIdentifier(name: name, parameters: parameters)
        _asSelector = SelectorSignature(isStatic: isStatic, keywords: [name] + parameters.map(\.label))

        //

        self.isStatic = isStatic
        self.isMutating = isMutating
        self.isThrowing = isThrowing
    }
    
    public init(
        name: String,
        parameters: [ParameterSignature] = [],
        returnType: SwiftType = .void,
        traits: Traits
    ) {
        
        self.traits = traits
        self.name = name
        self.returnType = returnType
        self.parameters = parameters

        _asIdentifier = FunctionIdentifier(name: name, parameters: parameters)
        _asSelector = SelectorSignature(isStatic: traits.contains(.static), keywords: [name] + parameters.map(\.label))
    }
    
    private mutating func _recreateAliases() {
        _asIdentifier = FunctionIdentifier(name: name, parameters: parameters)
        _asSelector = SelectorSignature(isStatic: isStatic, keywords: [name] + parameters.map(\.label))
    }
    
    /// Returns a set of possible selector signature variations for this function
    /// signature when permuting over default argument type variations.
    ///
    /// e.g.: Given the following signature:
    ///
    /// ```
    /// foo(bar: Int, baz: Int = default, _ zaz: Int = default)
    /// ```
    ///
    /// permuted selector signature set returned by this method would be:
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
        if !parameters.contains(where: \.hasDefaultValue) {
            return [asSelector]
        }
        
        let defaultArgIndices =
            parameters.enumerated()
                .filter(\.element.hasDefaultValue)
                .map(\.offset)
        
        if defaultArgIndices.isEmpty {
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
    
    /// Returns a set of possible function identifier signature variations for
    /// this function signature when permuting over default argument type variations.
    ///
    /// e.g.: Given the following signature:
    ///
    /// ```
    /// foo(bar: Int, baz: Int = default, _ zaz: Int = default)
    /// ```
    ///
    /// permuted identifier signature set returned by this method would be:
    ///
    /// ```
    /// foo(bar:)
    /// foo(bar:baz:)
    /// foo(bar:_:)
    /// foo(bar:baz:_:)
    /// ```
    public func possibleIdentifierSignatures() -> Set<FunctionIdentifier> {
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
        
        var set: Set<FunctionIdentifier> = []
        
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
            
            set.insert(FunctionIdentifier(name: name, argumentLabels: paramLabels))
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
        asSelector == other.asSelector
    }
    
    /// Returns `true` iff `self` and `other` match using C signature matching
    /// rules.
    ///
    /// In C, function signatures match if they have the same name, and the same
    /// number of parameters.
    public func matchesAsCFunction(_ other: FunctionSignature) -> Bool {
        name == other.name && parameters.count == other.parameters.count
    }

    /// Defines traits for a function signature.
    public struct Traits: Codable, OptionSet, Hashable, CustomStringConvertible {
        public var rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Function mutates its reference.
        public static let `mutating`: Self = Self(rawValue: 0b0000_0001)

        /// Function can throw error
        public static let throwing: Self = Self(rawValue: 0b0000_0010)

        /// Function is static
        public static let `static`: Self = Self(rawValue: 0b0000_0100)

        /// Function is async
        public static let `async`: Self = Self(rawValue: 0b0000_1000)

        public var description: String {
            var result = ""

            if contains(.mutating) {
                result += "mutating "
            }
            if contains(.throwing) {
                result += "throwing "
            }
            if contains(.static) {
                result += "static "
            }
            if contains(.async) {
                result += "async "
            }

            return result.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
}

extension FunctionSignature: Codable {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        try traits = container.decode(Traits.self, forKey: .traits)
        try name = container.decode(String.self, forKey: .name)
        try returnType = container.decode(SwiftType.self, forKey: .returnType)
        try parameters = container.decode([ParameterSignature].self, forKey: .parameters)
        
        _recreateAliases()
    }
    
    public enum CodingKeys: String, CodingKey {
        case name
        case returnType
        case parameters
        case traits
    }
}

extension FunctionSignature: CustomStringConvertible {
    public var description: String {
        var result = ""
        
        let traitDesc = traits.description
        if !traitDesc.isEmpty {
            result += traitDesc + " "
        }

        result += "func "
        result += name
        
        result += TypeFormatter.asString(parameters: parameters)

        if isThrowing {
            result += " throws"
        }
        
        if returnType != .void {
            result += " -> \(TypeFormatter.stringify(returnType))"
        }
        
        return result
    }
}

public extension Sequence where Element == ParameterSignature {
    func argumentLabels() -> [String?] {
        map(\.label)
    }
    
    func subscriptArgumentLabels() -> [String?] {
        map { $0.label == $0.name ? nil : $0.label }
    }
}

public extension FunctionSignature {
    init(isStatic: Bool = false, signatureString: String) throws {
        self = try FunctionSignatureParser.parseSignature(from: signatureString)
        self.isStatic = isStatic
    }
}

public extension Array where Element == ParameterSignature {
    init(parsingParameters parametersString: String) throws {
        self = try FunctionSignatureParser.parseParameters(from: parametersString)
    }
}
