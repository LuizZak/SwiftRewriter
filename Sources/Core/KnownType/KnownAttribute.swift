/// Describes an attribute for a `KnownType` or one of its members.
public struct KnownAttribute: Codable, Hashable {
    public var name: String
    public var parameters: String?

    /// Specifies the kinds of declarations this attribute can decorate.
    public var declaration: Declaration
    
    /// Returns the formatted attribute string as `@<name>(<parameters>)`
    public var attributeString: String {
        if let parameters = parameters {
            return "@\(name)(\(parameters))"
        }
        
        return "@\(name)"
    }
    
    public init(
        name: String,
        parameters: String? = nil,
        declaration: Declaration = .any
    ) {

        self.name = name
        self.parameters = parameters
        self.declaration = declaration
    }

    /// Specifies the kind of declarations that can be decorated with a known
    /// attribute.
    public struct Declaration: OptionSet, Hashable, Codable {
        public var rawValue: UInt

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

public extension KnownAttribute {
    /// `@dynamicCallable` attribute for types.
    static let dynamicCallable: KnownAttribute = .init(
        name: "dynamicCallable",
        declaration: [.class, .struct, .enum]
    )

    /// `@dynamicMemberLookup` attribute for types.
    static let dynamicMemberLookup: KnownAttribute = .init(
        name: "dynamicMemberLookup",
        declaration: [.class, .struct, .enum]
    )
}

public extension KnownAttribute.Declaration {
    /// Specifies that an attribute can decorate any declaration that supports
    /// attributes.
    static let any: Self = Self(rawValue: .max)

    /// Flag used for attributes that are associated with a type member.
    static let `memberFlag`: Self = Self(rawValue: 0b1 << 32)

    /// Attribute can decorate classes.
    static let `class`: Self = Self(rawValue: 0b1 << 0)

    /// Attribute can decorate structs.
    static let `struct`: Self = Self(rawValue: 0b1 << 1)

    /// Attribute can decorate enumerators.
    static let `enum`: Self = Self(rawValue: 0b1 << 2)

    /// Attribute can decorate protocols.
    static let `protocol`: Self = Self(rawValue: 0b1 << 3)

    /// Attribute can decorate functions.
    static let function: Self = Self(rawValue: 0b1 << 4)

    /// Attribute can decorate variables.
    static let variable: Self = Self(rawValue: 0b1 << 5)

    /// Attribute can decorate subscripts.
    static let `subscript`: Self = [Self(rawValue: 0b1 << 6), memberFlag]

    /// Attribute can decorate member methods.
    static let method: Self = [Self(rawValue: 0b1 << 7), memberFlag]
    
    /// Attribute can decorate member initializers.
    static let initializer: Self = [Self(rawValue: 0b1 << 8), memberFlag]
}
