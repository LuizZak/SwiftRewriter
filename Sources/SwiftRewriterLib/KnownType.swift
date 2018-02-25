import SwiftAST

/// Describes a known type with known properties and methods and their signatures.
public protocol KnownType: KnownSupertypeConvertible {
    /// The supertype for this known type, if any.
    var supertype: KnownSupertype? { get }
    
    /// Name for this known type
    var typeName: String { get }
    
    /// Gets an array of all known constructors for this type
    var knownConstructors: [KnownConstructor] { get }
    
    /// Gets an array of all known methods for this type
    var knownMethods: [KnownMethod] { get }
    
    /// Gets an array of all known properties for this type
    var knownProperties: [KnownProperty] { get }
    
    /// Gets an array of all known protocol conformances for this type
    var knownProtocolConformances: [KnownProtocolConformance] { get }
    
    /// Gets a constructor matching a given argument label set
    func constructor(withArgumentLabels labels: [String]) -> KnownConstructor?
}

/// Defines the known supertype of a `KnownType`
///
/// - knownType: A concrete known type reference
/// - typeName: The supertype that is referenced by a loose type name
public enum KnownSupertype {
    case knownType(KnownType)
    case typeName(String)
    
    public init(_ type: KnownSupertypeConvertible) {
        self = type.asKnownSupertype
    }
    
    public var asKnownType: KnownType? {
        switch self {
        case .knownType(let type):
            return type
        case .typeName:
            return nil
        }
    }
}

public protocol KnownSupertypeConvertible {
    var asKnownSupertype: KnownSupertype { get }
}

extension String: KnownSupertypeConvertible {
    public var asKnownSupertype: KnownSupertype {
        return .typeName(self)
    }
}

/// Default implementations
public extension KnownType {
    public var supertype: KnownSupertype? {
        return nil
    }
    
    public var asKnownSupertype: KnownSupertype {
        return .knownType(self)
    }
    
    /// Gets a constructor matching a given argument label set
    public func constructor(withArgumentLabels labels: [String]) -> KnownConstructor? {
        let constructor = knownConstructors.first {
            $0.parameters.map { $0.label }.elementsEqual(labels)
        }
        
        if let constructor = constructor {
            return constructor
        }
        
        // Search through supertype chain, if available.
        return supertype?.asKnownType?.constructor(withArgumentLabels: [])
    }
}

/// Describes a known type constructor
public protocol KnownConstructor {
    /// Gets the parameters for this constructor
    var parameters: [ParameterSignature] { get }
}

/// Describes a known method to the transpiler
public protocol KnownMethod {
    /// Gets the function signature for this method
    var signature: FunctionSignature { get }
    
    /// Gets a known body for this method
    var body: KnownMethodBody? { get }
}

/// Describes a method body that is known to the transpiler
public protocol KnownMethodBody {
    var body: CompoundStatement { get }
}

/// A known property from a type
public protocol KnownProperty {
    /// Property's name
    var name: String { get }
    
    /// Property's storage information
    var storage: ValueStorage { get }
    
    /// Property's attributes
    var attributes: [PropertyAttribute] { get }
}

/// Describes a known protocol conformance
public protocol KnownProtocolConformance {
    /// Gets the name of the protocol conformance
    var protocolName: String { get }
}
