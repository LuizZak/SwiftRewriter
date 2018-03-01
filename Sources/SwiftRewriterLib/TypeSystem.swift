import SwiftAST

/// A wrapper for querying the type system context for specific type knowledges
public protocol TypeSystem {
    /// Returns `true` if `type` represents a numerical type (int, float, CGFloat, etc.)
    func isNumeric(_ type: SwiftType) -> Bool
    
    /// Returns `true` is an integer (signed or unsigned) type
    func isInteger(_ type: SwiftType) -> Bool
    
    /// Gets a known type with a given name from this type system
    func knownTypeWithName(_ name: String) -> KnownType?
    
    /// Returns `true` if a given type is considered a class instance type.
    /// Class instance types are considered to be any type that is either a Swift
    /// or Objective-C class/protocol, or a subclass implementer of one of them.
    func isClassInstanceType(_ typeName: String) -> Bool
    
    /// Returns `true` if a type represented by a given type name is a subtype of
    /// another type
    func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool
    
    /// Gets the supertype of a given type on this type system.
    ///
    /// - Parameter type: A known type with available supertype information.
    /// - Returns: The supertype of the given type.
    func supertype(of type: KnownType) -> KnownType?
    
    // MARK: Member searching methods
    
    /// Gets a constructor matching a given argument label set
    func constructor(withArgumentLabels labels: [String], in type: KnownType) -> KnownConstructor?
    
    /// Gets a protocol conformance to a given protocol name
    func conformance(toProtocolName name: String, in type: KnownType) -> KnownProtocolConformance?
    
    /// Searches for a method with a given Objective-C equivalent selector
    func method(withObjcSelector selector: FunctionSignature, static isStatic: Bool, in type: KnownType) -> KnownMethod?
    
    /// Gets a property with a given name
    func property(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty?
    
    /// Gets an instance field with a given name
    func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty?
}
