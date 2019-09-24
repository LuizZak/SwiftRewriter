import SwiftAST

/// Defines a protocol for a value storage intention.
public protocol ValueStorageIntention: IntentionProtocol {
    var name: String { get }
    var storage: ValueStorage { get }
    var initialValue: Expression? { get }
}

public extension ValueStorageIntention {
    var type: SwiftType {
        storage.type
    }
    
    var ownership: Ownership {
        storage.ownership
    }
    
    var isConstant: Bool {
        storage.isConstant
    }
}

/// Defines a value storage intention that can be mutated at any point.
public protocol MutableValueStorageIntention: ValueStorageIntention {
    var name: String { get set }
    var storage: ValueStorage { get set }
    var initialValue: Expression? { get set }
}
