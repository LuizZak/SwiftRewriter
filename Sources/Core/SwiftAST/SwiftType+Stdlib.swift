public extension SwiftType {
    /// Swift's `Void` type.
    static let void = SwiftType.tuple(.empty)

    /// Swift's stdlib `Int` type.
    static let int = SwiftType.typeName("Int")
    
    /// Swift's stdlib `UInt` type.
    static let uint = SwiftType.typeName("UInt")

    /// Swift's stdlib `String` type.
    static let string = SwiftType.typeName("String")
    
    /// Swift's stdlib `Bool` type.
    static let bool = SwiftType.typeName("Bool")
    
    /// Swift's stdlib `Float` type.
    static let float = SwiftType.typeName("Float")
    
    /// Swift's stdlib `Double` type.
    static let double = SwiftType.typeName("Double")
    
    /// CoreGraphics' `CGFloat` type.
    static let cgFloat = SwiftType.typeName("CGFloat")
    
    /// Swift's stdlib `Any` type.
    static let any = SwiftType.typeName("Any")
    
    /// Swift's stdlib `AnyObject` type.
    static let anyObject = SwiftType.typeName("AnyObject")
    
    /// Objective-C's generic Selector type.
    static let selector = SwiftType.typeName("Selector")
    
    /// Foundation's `NSArray` type.
    static let nsArray = SwiftType.typeName("NSArray")

    /// Foundation's `NSDictionary` type.
    static let nsDictionary = SwiftType.typeName("NSDictionary")
    
    /// A special type name to use to represent the `instancetype` type from
    /// Objective-C.
    static let instancetype = SwiftType.typeName("__instancetype")

    /// The standard Swift error protocol type definition.
    static let swiftError = SwiftType.typeName("Error")
    
    /// A special type used in place of definitions with improper typing.
    ///
    /// - note: This is *not* the equivalent to Swift's `Error` protocol type.
    /// For that type, use `SwiftType.swiftError`.
    static let errorType = SwiftType.typeName("<<error type>>")

    /// Creates an open range type with the given operand.
    ///
    /// Equivalent to `Range<Operand>` in Swift.
    static func openRange(_ operand: SwiftType) -> SwiftType {
        .nominal(.generic("Range", parameters: .one(operand)))
    }
    
    /// Creates a closed range type with the given operand.
    ///
    /// Equivalent to `ClosedRange<Operand>` in Swift.
    static func closedRange(_ operand: SwiftType) -> SwiftType {
        .nominal(.generic("ClosedRange", parameters: .one(operand)))
    }
}
