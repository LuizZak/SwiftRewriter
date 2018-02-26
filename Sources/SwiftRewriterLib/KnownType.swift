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
    
    // MARK: Member searching methods
    
    /// Gets a constructor matching a given argument label set
    func constructor(withArgumentLabels labels: [String]) -> KnownConstructor?
    
    /// Searches for a method with a given Objective-C equivalent selector
    func method(withObjcSelector selector: FunctionSignature) -> KnownMethod?
    
    /// Gets a protocol conformance to a given protocol name
    func conformance(toProtocolName name: String) -> KnownProtocolConformance?
    
    /// Gets a property with a given name
    func property(named name: String) -> KnownProperty?
}

/// Defines the known supertype of a `KnownType`
///
/// - knownType: A concrete known type reference
/// - typeName: The supertype that is referenced by a loose type name
public enum KnownSupertype: KnownSupertypeConvertible {
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
    
    public var asKnownSupertype: KnownSupertype {
        return self
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
    public var asKnownSupertype: KnownSupertype {
        return .knownType(self)
    }
    
    public func constructor(withArgumentLabels labels: [String]) -> KnownConstructor? {
        return
            firstInInheritanceChain { type in
                return type.knownConstructors.first { ctor in
                    ctor.parameters.map { $0.label }.elementsEqual(labels)
                }
            }
    }
    
    public func method(withObjcSelector selector: FunctionSignature) -> KnownMethod? {
        return
            firstInInheritanceChain { type in
                return
                    type.knownMethods.first { method in
                        method.signature.matchesAsSelector(selector)
                    }
            }
    }
    
    public func conformance(toProtocolName name: String) -> KnownProtocolConformance? {
        return
            firstInInheritanceChain { type in
                return knownProtocolConformances.first { $0.protocolName == name }
            }
    }
    
    public func property(named name: String) -> KnownProperty? {
        return
            firstInInheritanceChain { type in
                return
                    knownProperties.first { property in
                        property.name == name
                    }
            }
    }
    
    /// Looks through the inheritance chain of this known type, returning the first
    /// known type that returns a non-nil result to a block query.
    ///
    /// Returns nil, if all types returned nil.
    private func firstInInheritanceChain<T>(where block: (KnownType) -> T?) -> T? {
        let result = block(self)
        if let result = result {
            return result
        }
        
        return supertype?.asKnownType?.firstInInheritanceChain(where: block)
    }
}

/// Describes a known type constructor
public protocol KnownConstructor {
    /// Gets the parameters for this constructor
    var parameters: [ParameterSignature] { get }
}

/// Describes a known member of a type
public protocol KnownMember {
    /// The owner type for this known member
    var ownerType: KnownType? { get }
}

/// Describes a known method to the transpiler
public protocol KnownMethod: KnownMember {
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
public protocol KnownProperty: KnownMember {
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
