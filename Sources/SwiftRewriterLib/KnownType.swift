import Foundation
import SwiftAST

/// Describes a known type with known properties and methods and their signatures.
public protocol KnownType: KnownTypeReferenceConvertible, SemanticalObject {
    /// A string that specifies the origin of this known type.
    /// This should be implemented by conformers by returning an as precise as
    /// possible set of informations that can help pinpoint the origin of this
    /// type, such as a file name/line number, if the type originated from a file,
    /// etc.
    var origin: String { get }
    
    /// Returns `true` if this known type represents an extension for another
    /// known type.
    var isExtension: Bool { get }
    
    /// The supertype for this known type, if any.
    var supertype: KnownTypeReference? { get }
    
    /// Name for this known type
    var typeName: String { get }
    
    /// The kind of this known type
    var kind: KnownTypeKind { get }
    
    /// Gets a set of known type traits for this type
    var knownTraits: [String: TraitType] { get set }
    
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
    
    /// Gets a known type trait from this type
    func knownTrait(_ traitName: String) -> TraitType?
    
    /// Sets a known type trait with a given value for this type
    mutating func setKnownTrait(_ traitName: String, value: TraitType)
}

/// The kind of a known type
public enum KnownTypeKind: String, Codable {
    /// A concrete class type
    case `class`
    /// A protocol type
    case `protocol`
    /// An enumeration type
    case `enum`
    /// A struct type
    case `struct`
}

/// Defines a reference to a known type.
///
/// - knownType: A concrete known type reference.
/// - typeName: The type that is referenced by a loose type name.
public enum KnownTypeReference: KnownTypeReferenceConvertible {
    case knownType(KnownType)
    case typeName(String)
    
    public var asTypeName: String {
        switch self {
        case .knownType(let type):
            return type.typeName
        case .typeName(let name):
            return name
        }
    }
    
    public var asKnownTypeReference: KnownTypeReference {
        return self
    }
}

public protocol KnownTypeReferenceConvertible {
    var asKnownTypeReference: KnownTypeReference { get }
}

extension String: KnownTypeReferenceConvertible {
    public var asKnownTypeReference: KnownTypeReference {
        return .typeName(self)
    }
}

/// Default implementations
public extension KnownType {
    public var asKnownTypeReference: KnownTypeReference {
        return .knownType(self)
    }
}

/// Describes a known type constructor
public protocol KnownConstructor: SemanticalObject {
    /// Gets the parameters for this constructor
    var parameters: [ParameterSignature] { get }
    
    /// Gets whether this initializer can fail (i.e. return nil)
    var isFailable: Bool { get }
    
    /// Gets whether this initializer is a convenience initializer
    var isConvenience: Bool { get }
}

/// Describes a known member of a type
public protocol KnownMember: SemanticalObject {
    /// The owner type for this known member
    var ownerType: KnownTypeReference? { get }
    
    /// Whether this member is a static (class) member
    var isStatic: Bool { get }

    /// Gets the type for this member.
    /// In case this is a property or field member, this is just the storage type
    /// of the variable, and if this is a method member, this is the signature of
    /// the method.
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
    
    /// `true` if this property actually represents an enumeration case.
    var isEnumCase: Bool { get }
}

/// Describes the getter/setter states of a property
public enum KnownPropertyAccessor: String, Codable {
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

public enum KnownTypeTraits {
    public static let enumRawValue = "enumRawValue"
}

public extension KnownType {
    public func knownTrait(_ traitName: String) -> TraitType? {
        return knownTraits[traitName]
    }
    
    public mutating func setKnownTrait(_ traitName: String, value: TraitType) {
        knownTraits[traitName] = value
    }
}

public enum TraitType: Equatable, Codable {
    case swiftType(SwiftType)
    case semantics([Semantic])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        switch try container.decode(Int.self, forKey: .flag) {
        case 0:
            self = .swiftType(try container.decode(SwiftType.self, forKey: .field))
            
        case 1:
            self = .semantics(try container.decode([Semantic].self, forKey: .field))
            
        default:
            let message = """
                Unknown TraitType flag. Maybe data was encoded using a \
                different version of SwiftRewriter?
                """
            throw DecodingError.dataCorruptedError(forKey: .flag, in: container,
                                                   debugDescription: message)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .swiftType(let type):
            try container.encode(0, forKey: .flag)
            try container.encode(type, forKey: .field)
            
        case .semantics(let semantics):
            try container.encode(1, forKey: .flag)
            try container.encode(semantics, forKey: .field)
        }
    }
    
    private enum CodingKeys: Int, CodingKey {
        case flag
        case field
    }
}
