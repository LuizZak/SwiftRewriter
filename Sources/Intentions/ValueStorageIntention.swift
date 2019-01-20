import SwiftAST

/// Defines a protocol for a value storage intention.
public protocol ValueStorageIntention: IntentionProtocol {
    var name: String { get }
    var storage: ValueStorage { get }
    var initialValue: Expression? { get }
}

public extension ValueStorageIntention {
    public var type: SwiftType {
        return storage.type
    }
    
    public var ownership: Ownership {
        return storage.ownership
    }
    
    public var isConstant: Bool {
        return storage.isConstant
    }
}
