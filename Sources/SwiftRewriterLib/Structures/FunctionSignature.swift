import SwiftAST

/// Signature for a function intention
public struct FunctionSignature: Equatable, Codable {
    public var isStatic: Bool
    public var name: String
    public var returnType: SwiftType
    public var parameters: [ParameterSignature]
    
    public var asIdentifier: FunctionIdentifier {
        return FunctionIdentifier(name: name, parameterNames: parameters.map { $0.label })
    }
    
    public var asSelector: SelectorSignature {
        return
            SelectorSignature(
                isStatic: isStatic,
                keywords: [name] + parameters.map { $0.label }
            )
    }
    
    /// Returns a `SwiftType.block`-equivalent type for this function signature
    public var swiftClosureType: SwiftType {
        return .block(returnType: returnType, parameters: parameters.map { $0.type })
    }
    
    public var droppingNullability: FunctionSignature {
        let parameters = self.parameters.map {
            ParameterSignature(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
        }
        
        return FunctionSignature(name: name,
                                 parameters: parameters,
                                 returnType: returnType.deepUnwrapped,
                                 isStatic: isStatic)
    }
    
    public init(name: String,
                parameters: [ParameterSignature] = [],
                returnType: SwiftType = .void,
                isStatic: Bool = false) {
        
        self.isStatic = isStatic
        self.name = name
        self.returnType = returnType
        self.parameters = parameters
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

public struct ParameterSignature: Equatable, Codable {
    public var label: String?
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.label = name
        self.name = name
        self.type = type
    }
    
    public init(label: String?, name: String, type: SwiftType) {
        self.label = label
        self.name = name
        self.type = type
    }
}

public extension Sequence where Element == ParameterSignature {
    
    public func argumentLabels() -> [String?] {
        return map { $0.label }
    }
}

