/// Specifies an objetive-c type for a property or local.
/// For objc class pointers, they are always specified as pointers to type names,
/// like `.pointerType(.typeName("NSObject"))`
public enum ObjcType: Hashable, Codable, CustomStringConvertible {
    /// Objective-c's `id` type, with optional protocol array specifiers
    case id(protocols: [String] = [])
    
    /// Special 'generic'-like specifier.
    /// Closely related to `id` type.
    case instancetype
    
    /// A type-name identifier identifier.
    /// May be any type that is not an `id`.
    case typeName(String)
    
    /// A special `void` type that indicates an empty value.
    case void

    /// An anonymous struct type.
    case anonymousStruct

    /// An anonymous enum type.
    case anonymousEnum

    /// An incomplete named struct.
    case incompleteStruct(String)
    
    /// A composed pointer, like `NSObject*` or `int*`.
    /// May be an objc class or a typename pointer.
    indirect case pointer(
        ObjcType,
        qualifiers: [ObjcTypeQualifier] = [],
        nullabilitySpecifier: ObjcNullabilitySpecifier? = nil
    )
    
    /// A generic objc type- e.g. `NSArray<NSNumber*>`
    indirect case genericTypeName(
        String,
        parameters: [ObjcGenericTypeParameter]
    )
    
    /// An Objc type that has associated pointer qualifiers, such as `const int`,
    /// which is a signed integer with constant storage.
    indirect case qualified(ObjcType, qualifiers: [ObjcTypeQualifier])
    
    /// An Objc type that has associated specifiers, such as `__weak NSObject*`,
    /// which is a __weak-tagged type of a pointer to a struct NSObject.
    indirect case specified(specifiers: [ObjcTypeSpecifier], ObjcType)

    /// A nullability specifier that applies to the root of a type.
    /// Associated type must be an Objective-C object pointer type or a block
    /// type.
    indirect case nullabilitySpecified(specifier: ObjcNullabilitySpecifier, ObjcType)
    
    /// An objective-C block type.
    /// Block types may specify names, or not (in case of block literals).
    indirect case blockType(
        name: String? = nil,
        returnType: ObjcType,
        parameters: [ObjcType] = [],
        nullabilitySpecifier: ObjcNullabilitySpecifier? = nil
    )
    
    /// A C function pointer.
    /// Function pointer types may specify names, or not (in case of pointer literals).
    indirect case functionPointer(
        name: String? = nil,
        returnType: ObjcType,
        parameters: [ObjcType] = []
    )
    
    /// A fixed array type
    indirect case fixedArray(ObjcType, length: Int)
    
    /// Gets the plain string definition for this type.
    /// Always maps to valid objc type
    public var description: String {
        switch self {
        case .instancetype:
            return "instancetype"
            
        case .void:
            return "void"
            
        case .typeName(let s):
            return s
        
        case .anonymousStruct:
            return "struct"
        
        case .anonymousEnum:
            return "enum"
        
        case .incompleteStruct(let name):
            return "struct \(name)"
            
        case let .genericTypeName(cl, parameters):
            let typeNames = parameters.map(\.description).joined(separator: ", ")
            
            if !typeNames.isEmpty {
                return "\(cl)<\(typeNames)>"
            } else {
                return cl
            }
            
        case .id(let protocols):
            if !protocols.isEmpty {
                let protocolNames = protocols.joined(separator: ", ")
                return "id<\(protocolNames)>"
            } else {
                return "id"
            }
            
        case .pointer(let type, let qualifiers, let nullability):
            var result = "\(type.description)*"

            if !qualifiers.isEmpty {
                result += qualifiers.map(\.description).joined(separator: " ")
            }
            if let nullability = nullability {
                result += nullability.description
            }

            return result
            
        case let .qualified(type, qualifiers):
            return "\(qualifiers.map(\.description).joined(separator: " ")) \(type.description)"
            
        case let .specified(specifiers, type):
            return "\(specifiers.map(\.description).joined(separator: " ")) \(type.description)"
        
        case let .nullabilitySpecified(specifier, type):
            return "\(specifier) \(type)"
            
        case let .blockType(name, returnType, parameters, nullability):
            var result = "\(returnType)"
            
            result += "(^"
            if let nullability = nullability {
                result += nullability.description
            }

            if let name = name {
                result += nullability == nil ? name : " \(name)"
            }

            result += ")"
            result += "("
            result += parameters.map(\.description).joined(separator: ", ")
            result += ")"

            return result
            
        case let .functionPointer(name, returnType, parameters):
            return "\(returnType)(*\(name ?? ""))(\(parameters.map(\.description).joined(separator: ", ")))"
            
        case let .fixedArray(type, length):
            return "\(type)[\(length)]"
        }
    }
    
    /// Returns true if this is a pointer type
    public var isPointer: Bool {
        switch self {
        case .pointer, .id, .instancetype, .blockType, .functionPointer, .fixedArray:
            return true
            
        case .specified(_, let type),
            .nullabilitySpecified(_, let type),
            .qualified(let type, _):
            return type.isPointer
            
        case .anonymousEnum, .anonymousStruct, .incompleteStruct, .void, .typeName, .genericTypeName:
            return false
        }
    }

    /// Returns `ObjcType.pointer(self)`.
    public var wrapAsPointer: ObjcType {
        .pointer(self)
    }

    /// Convenience for generating a non-variant generic type.
    /// Returns `ObjcType.genericTypeName(typeName, parameters: parameters.map { ObjcGenericTypeParameter(type: $0) })`
    public static func genericTypeName(_ typeName: String, typeParameters: [ObjcType]) -> Self {
        .genericTypeName(
            typeName,
            parameters: typeParameters.map { ObjcGenericTypeParameter(type: $0) }
        )
    }
}

extension ObjcType: ExpressibleByStringLiteral {
    /// Initializes a `ObjcType.typeName()` case with the given string literal
    /// as its type.
    public init(stringLiteral value: String) {
        switch value {
        case "instancetype":
            self = .instancetype
        case "id":
            self = .id()
        case "void":
            self = .void
        case "struct":
            self = .anonymousStruct
        case "enum":
            self = .anonymousEnum
        default:
            self = .typeName(value)
        }
    }
}

/// An entry for a generic Objective-C type parameter list.
public struct ObjcGenericTypeParameter: Codable, Hashable, CustomStringConvertible {
    /// A type variance, if one was specified at declaration site.
    public var variance: ObjcGenericTypeVariance?

    /// The actual type for this generic type parameter.
    public var type: ObjcType

    public var description: String {
        if let variance {
            return "\(variance) \(type)"
        }

        return type.description
    }

    public init(variance: ObjcGenericTypeVariance? = nil, type: ObjcType) {
        self.variance = variance
        self.type = type
    }
}

/// A specifier for a generic type parameter for whether the type is covariant
/// or contravariant.
public enum ObjcGenericTypeVariance: String, Codable, Hashable, CustomStringConvertible {
    case covariant = "__covariant"
    case contravariant = "__contravariant"

    public var description: String {
        rawValue
    }
}

/// Nullability specifier for Objective-C types
public enum ObjcNullabilitySpecifier: String, Hashable, Codable, CustomStringConvertible {
    /// `_Nonnull` nullability specifier.
    ///
    /// Indicates that a declaration of a reference to an object is assumed to
    /// never be `nil` at usage sites. In Swift, types are by default nonnull
    /// unless they are specified as `Optional<T>`.
    case nonnull = "_Nonnull"

    /// `_Nullable` nullability specifier.
    ///
    /// Indicates that a declaration of a reference to an object may or may not
    /// be `nil` at the usage site. In Swift, nullable references must be
    /// pattern-bound into non-nullable references to be used properly.
    case nullable = "_Nullable"

    /// `_Null_unspecified` nullability specifier.
    ///
    /// References to a null-unspecified declaration don't guarantee nullability
    /// status and are evaluated on each usage site (in Swift, this may result in
    /// runtime errors).
    case nullUnspecified = "_Null_unspecified"

    /// `_Null_resettable` nullability specifier.
    /// Assigning `nil` to a null-resettable property indicates that the property
    /// should be reverted back to a default value.
    ///
    /// Getters marked as null-resettable should never actually return `nil`
    /// themselves.
    ///
    /// Only applicable to Objective-C @properties.
    case nullResettable = "_Null_resettable"
    
    public var description: String {
        rawValue
    }
}

/// C/Objective-C type qualifier
public enum ObjcTypeQualifier: Hashable, Codable, CustomStringConvertible {
    /// "const" C type qualifier. May be used to qualify declarations in Swift
    /// as "let".
    case const

    /// "volatile" C type qualifier.
    case volatile

    /// "restrict" C-exclusive type qualifier. Used to indicate unique aliasing
    /// of a pointer by a declaration.
    case restrict

    /// "_Atomic" C type qualifier. 
    case atomic

    /// A protocol type qualifier.
    case protocolQualifier(ObjcProtocolQualifier)

    public var description: String {
        switch self {
        case .const:
            return "const"
        case .volatile:
            return "volatile"
        case .restrict:
            return "restrict"
        case .atomic:
            return "_Atomic"
        case .protocolQualifier(let value):
            return value.description
        }
    }

    /// Returns `true` if this type qualifier value is a `const` case.
    public var isConst: Bool {
        switch self {
        case .const:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this type qualifier value is a `volatile` case.
    public var isVolatile: Bool {
        switch self {
        case .volatile:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this type qualifier value is a `restrict` case.
    public var isRestrict: Bool {
        switch self {
        case .restrict:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this type qualifier value is an `atomic` case.
    public var isAtomic: Bool {
        switch self {
        case .atomic:
            return true
        default:
            return false
        }
    }

    /// Returns `true` if this type qualifier value is a `protocolQualifier` case.
    public var isProtocolQualifier: Bool {
        switch self {
        case .protocolQualifier:
            return true
        default:
            return false
        }
    }
}

/// Objective-C type qualifier specific for protocol storage
public enum ObjcProtocolQualifier: String, Hashable, Codable, CustomStringConvertible {
    /// "in" protocol qualifier. Used to indicate that a pointer value will
    /// be sent to the receiver of a message and not be used back by the original
    /// sender's process.
    case `in`
    
    /// "out" protocol qualifier. Used to indicate that a pointer value will
    /// be passed out from the receiver of a message.
    case out

    /// "inout" protocol qualifier. Used to indicate that a pointer value will
    /// be used by both the sender and receiver of a message.
    case `inout`
    
    /// "bycopy" protocol qualifier. When used, indicates that objects crossing
    /// the message boundary should be memory-copied.
    case bycopy

    /// "byref" protocol qualifier. When used, indicates that objects crossing
    /// the message boundary should be passed by reference, with no copying of
    /// the object's memory contents, and full proxying of the messages back.
    case byref

    /// "oneway" protocol qualifier. Used to indicate that void-returning selectors
    /// don't require a synchronous await of its return of the message.
    case oneway

    public var description: String {
        rawValue
    }
}

/// Type specifier for Objective-C types
public enum ObjcTypeSpecifier: Hashable, Codable, CustomStringConvertible {
    /// Shorthand for `ObjcTypeSpecifier.arcSpecifier(.weak)`
    public static let `weak`: Self = .arcSpecifier(.weak)

    /// Shorthand for `ObjcTypeSpecifier.arcSpecifier(.strong)`
    public static let `strong`: Self = .arcSpecifier(.strong)

    /// Shorthand for `ObjcTypeSpecifier.arcSpecifier(.autoreleasing)`
    public static let `autoreleasing`: Self = .arcSpecifier(.autoreleasing)

    /// Shorthand for `ObjcTypeSpecifier.arcSpecifier(.unsafeUnretained)`
    public static let `unsafeUnretained`: Self = .arcSpecifier(.unsafeUnretained)

    /// An ARC type specifier
    case arcSpecifier(ObjcArcBehaviorSpecifier)

    public var description: String {
        switch self {
        case .arcSpecifier(let specifier):
            return specifier.description
        }
    }
}

/// Objective-C ARC behavior specifier.
/// Declarations using ARC specifiers must be of Objective-C class pointer types.
public enum ObjcArcBehaviorSpecifier: String, Hashable, Codable, CustomStringConvertible {
    /// Strong reference counting storage.
    /// It's the default storage mode if none other is specified.
    case strong

    /// Weak reference counting storage.
    /// Declarations marked with weak cannot be nonnull.
    case `weak`

    /// Autoreleasing reference counting storage.
    case autoreleasing

    /// Unsafe unretained reference counting storage.
    case unsafeUnretained

    public var description: String {
        switch self {
        case .strong:
            return "__strong"
        case .weak:
            return "__weak"
        case .autoreleasing:
            return "__autoreleasing"
        case .unsafeUnretained:
            return "__unsafe_unretained"
        }
    }
}

public extension ObjcType {
    /// Convenience property that returns `self` wrapped in a `.specified` case
    /// with a `__weak` ARC specified.
    /// Does nothing if the type is already specified as `__weak`.
    var specifiedAsWeak: ObjcType {
        switch self {
        case .specified(let specifiers, let base):
            if specifiers.contains(.arcSpecifier(.weak)) {
                return self
            }

            return .specified(specifiers: specifiers + [.arcSpecifier(.weak)], base)
        default:
            return .specified(specifiers: [.arcSpecifier(.weak)], self)
        }
    }
}

/// C/Objective-C function specifier.
public enum ObjcFunctionSpecifier: Hashable, Codable, CustomStringConvertible {
    /// "inline" C specifier.
    case inline

    /// "_Noreturn" C specifier; equivalent to "noreturn" macro.
    case noReturn

    /// __stdcall extension used by Microsoft's MSVC compiler used to call Win32
    /// APIs.
    case stdCall

    /// A __declspec(<identifier>) function specifier.
    case declspec(String)

    public var description: String {
        switch self {
        case .inline:
            return "inline"
        case .noReturn:
            return "_Noreturn"
        case .stdCall:
            return "__stdcall"
        case .declspec(let value):
            return "__declspec(\(value))"
        }
    }
}

/// An Objective-C Interface Builder outlet qualifier, used in Objective-C
/// declarations that interact with Apple's Interface Builder stack.
public enum ObjcIBOutletQualifier: Hashable, Codable, CustomStringConvertible {
    /// An `IBCollection(<identifier>)` qualifier.
    case ibCollection(String)

    /// An `IBOutlet` qualifier.
    case ibOutlet

    public var description: String {
        switch self {
        case .ibCollection(let value):
            return "IBOutletCollection(\(value))"
        case .ibOutlet:
            return "IBOutlet"
        }
    }
}

/// Returns the contained type name within a given Objective-C type, if available,
/// looking through nested `.qualified`, `.specified`, and `.nullabilitySpecified`
/// cases until a proper type name is found.
///
/// Looks through pointer and qualifier/specifiers until a root nominal type
/// `.typeName(name)` is found, returning
/// the string representation of the name, otherwise `nil` is returned.
public func typeNameIn(objcType: ObjcType) -> String? {

    switch objcType {
    case .typeName(let name):
        return name

    case .nullabilitySpecified(_, let type),
        .qualified(let type, _),
        .specified(_, let type):
        return typeNameIn(objcType: type)
    
    case .instancetype,
        .id,
        .anonymousEnum,
        .anonymousStruct,
        .incompleteStruct,
        .blockType,
        .functionPointer,
        .pointer,
        .fixedArray,
        .void,
        .genericTypeName:
        return nil
    }
}
