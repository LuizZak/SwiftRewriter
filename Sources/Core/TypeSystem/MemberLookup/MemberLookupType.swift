import SwiftAST
import KnownType

/// A type that supports member lookup queries for a specific type.
public protocol MemberLookupType {
    /// Requests a method with a specified function identifier and invocation
    /// type hints in the current type being looked into.
    func method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownMethod?
    
    /// Requests a property with a specified name identifier in the current
    /// type being looked into.
    /// Gets a property with a given name in the current type being looked into,
    /// also specifying whether to include optional members (from optional
    /// protocol members that where not implemented by a concrete class).
    func property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownProperty?
    
    /// Requests an instance variable with a specified name identifier in the
    /// current type being looked into.
    func field(named name: String, static isStatic: Bool) -> KnownProperty?
    
    /// Requests a subscript with a specified set of parameter labels and
    /// invocation hints in the current type being looked into.
    func subscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool
    ) -> KnownSubscript?

    /// Requests a member with a specified name identifier in the current
    /// type being looked into.
    func member(
        named name: String,
        static isStatic: Bool
    ) -> KnownMember?
}
