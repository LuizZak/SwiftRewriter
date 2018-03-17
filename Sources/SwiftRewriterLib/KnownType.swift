import SwiftAST

/// Describes a known type with known properties and methods and their signatures.
public protocol KnownType: KnownSupertypeConvertible {
    /// A string that specifies the origin of this known type.
    /// This should be implemented by conformes by returning an as precise as
    /// possible set of informations that can help pinpoint the origin of this
    /// type, such as a file name/line number, if the type originated from a file,
    /// etc.
    var origin: String { get }
    
    /// The supertype for this known type, if any.
    var supertype: KnownSupertype? { get }
    
    /// Name for this known type
    var typeName: String { get }
    
    /// The kind of this known type
    var kind: KnownTypeKind { get }
    
    /// Gets an array of all known constructors for this type
    var knownConstructors: [KnownConstructor] { get }
    
    /// Gets an array of all known methods for this type
    var knownMethods: [KnownMethod] { get }
    
    /// Gets an array of all known properties for this type
    var knownProperties: [KnownProperty] { get }
    
    /// Gets an array of all known instance variable fields for this type
    var knownFields: [KnownProperty] { get }
    
    /// Gets an array of all known protocol conformances for this type
    var knownProtocolConformances: [KnownProtocolConformance] { get }
}

/// The kind of a known type
public enum KnownTypeKind: String {
    /// A concrete class type
    case `class`
    /// A protocol type
    case `protocol`
    /// An enumeration type
    case `enum`
    /// A struct type
    case `struct`
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
    
    public var asTypeName: String {
        switch self {
        case .knownType(let type):
            return type.typeName
        case .typeName(let name):
            return name
        }
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
    
    /// Whether this member is a static (class) member
    var isStatic: Bool { get }

    /// Gets the type for this member.
    /// In case this is a property or field member, this is just the storage type
    /// of the variable, and if this is a method member, this is the signature
    /// of the method.
    var memberType: SwiftType { get }
}

/// Describes a known method to the transpiler
public protocol KnownMethod: KnownMember {
    /// Gets the function signature for this method
    var signature: FunctionSignature { get }
    
    /// Gets a known body for this method
    var body: KnownMethodBody? { get }
    
    /// True if this method is an optional protocol conformance method
    var optional: Bool { get }
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
    
    /// True if this method is an optional protocol conformance property
    var optional: Bool { get }
    
    /// Gets the accessors for this property
    var accessor: KnownPropertyAccessor { get }
}

/// Describes the getter/setter states of a property
public enum KnownPropertyAccessor {
    case getter
    case getterAndSetter
}

/// Describes a known protocol conformance
public protocol KnownProtocolConformance {
    /// Gets the name of the protocol conformance
    var protocolName: String { get }
}

public extension KnownMethod {
    public var isStatic: Bool {
        return signature.isStatic
    }
}

public extension KnownProperty {
    public var memberType: SwiftType {
        return storage.type
    }
}

public extension KnownMethod {
    public var memberType: SwiftType {
        return signature.swiftClosureType
    }
}
