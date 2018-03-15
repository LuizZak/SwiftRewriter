import SwiftAST

/// A wrapper for querying the type system context for specific type knowledges
public protocol TypeSystem {
    /// Returns an expression representing the default value for a given Swift type.
    /// Returns nil, in case no default values are known
    func defaultValue(for type: SwiftType) -> Expression?
    
    /// Returns `true` if `type` represents a numerical type (int, float, CGFloat, etc.).
    func isNumeric(_ type: SwiftType) -> Bool
    
    /// Returns `true` is an integer (signed or unsigned) type.
    func isInteger(_ type: SwiftType) -> Bool
    
    /// Returns `true` if a type is known to exists with a given name.
    func typeExists(_ name: String) -> Bool
    
    /// Returns all known types that match a specified type
    func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType]
    
    /// Returns a known type for a given SwiftType, if present.
    func findType(for swiftType: SwiftType) -> KnownType?
    
    /// Gets a known type with a given name from this type system.
    func knownTypeWithName(_ name: String) -> KnownType?
    
    /// Returns a composition of a set of types as a single known type.
    /// Returns nil, if any of the types is unknown, or the list is empty.
    func composeTypeWithKnownTypes(_ typeNames: [String]) -> KnownType?
    
    /// Returns `true` if a given type is considered a class instance type.
    /// Class instance types are considered to be any type that is either a Swift
    /// or Objective-C class/protocol, or a subclass implementer of one of them.
    func isClassInstanceType(_ typeName: String) -> Bool
    
    /// Returns `true` if a given type is considered a class instance type.
    /// Class instance types are considered to be any type that is either a Swift
    /// or Objective-C class/protocol, or a subclass implementer of one of them.
    func isClassInstanceType(_ type: SwiftType) -> Bool
    
    /// Returns `true` if a given type is a known scalar type.
    func isScalarType(_ type: SwiftType) -> Bool
    
    /// Returns `true` if a type represented by a given type name is a subtype of
    /// another type.
    func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool
    
    /// Gets the supertype of a given type on this type system.
    ///
    /// - Parameter type: A known type with available supertype information.
    /// - Returns: The supertype of the given type.
    func supertype(of type: KnownType) -> KnownType?
    
    // MARK: Member searching methods - KnownType
    
    /// Gets a constructor matching a given argument label set on a given known type.
    func constructor(withArgumentLabels labels: [String], in type: KnownType) -> KnownConstructor?
    
    /// Gets a protocol conformance to a given protocol name on a given known type.
    func conformance(toProtocolName name: String, in type: KnownType) -> KnownProtocolConformance?
    
    /// Searches for a method with a given Objective-C equivalent selector, also
    /// specifying whether to include optional methods (from optional protocol
    /// methods that where not implemented by a concrete class).
    func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool,
                includeOptional: Bool, in type: KnownType) -> KnownMethod?
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    func property(named name: String, static isStatic: Bool, includeOptional: Bool,
                  in type: KnownType) -> KnownProperty?
    
    /// Gets an instance field with a given name on a given known type.
    func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty?
    
    // MARK: Member searching methods - SwiftType
    
    /// Gets a constructor matching a given argument label set on a given known type.
    func constructor(withArgumentLabels labels: [String], in type: SwiftType) -> KnownConstructor?
    
    /// Gets a protocol conformance to a given protocol name on a given known type.
    func conformance(toProtocolName name: String, in type: SwiftType) -> KnownProtocolConformance?
    
    /// Searches for a method with a given Objective-C equivalent selector, also
    /// specifying whether to include optional methods (from optional protocol
    /// methods that where not implemented by a concrete class).
    func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool,
                includeOptional: Bool, in type: SwiftType) -> KnownMethod?
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    func property(named name: String, static isStatic: Bool, includeOptional: Bool,
                  in type: SwiftType) -> KnownProperty?
    
    /// Gets an instance field with a given name on a given known type.
    func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty?
}
