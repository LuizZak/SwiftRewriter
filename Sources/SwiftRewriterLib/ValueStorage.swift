import SwiftAST

/// Defines common properties for a Swift's variable/constant definition.
/// Stores information about the storage's type, ownership (strong/weak/unowned/etc.),
/// and whether it is a constant value.
public struct ValueStorage: Equatable {
    public var type: SwiftType
    public var ownership: Ownership
    public var isConstant: Bool
    
    public init(type: SwiftType, ownership: Ownership, isConstant: Bool) {
        self.type = type
        self.ownership = ownership
        self.isConstant = isConstant
    }
}
