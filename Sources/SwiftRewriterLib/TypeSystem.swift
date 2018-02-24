import SwiftAST

/// A wrapper for querying the type system context for specific type knowledges
public protocol TypeSystem {
    /// Returns `true` if `type` represents a numerical type (int, float, CGFloat, etc.)
    func isNumeric(_ type: SwiftType) -> Bool
    
    /// Returns `true` is an integer (signed or unsigned) type
    func isInteger(_ type: SwiftType) -> Bool
}

/// Standard type system implementation
public class DefaultTypeSystem: TypeSystem {
    public init() {
        
    }
    
    public func isNumeric(_ type: SwiftType) -> Bool {
        if isInteger(type) {
            return true
        }
        
        switch type {
        case .float, .double, .cgFloat:
            return true
        case .typeName("Float80"):
            return true
        default:
            return false
        }
    }
    
    public func isInteger(_ type: SwiftType) -> Bool {
        switch type {
        case .int, .uint:
            return true
        case .typeName("Int64"), .typeName("Int32"), .typeName("Int16"), .typeName("Int8"):
            return true
        case .typeName("UInt64"), .typeName("UInt32"), .typeName("UInt16"), .typeName("UInt8"):
            return true
        default:
            return false
        }
    }
}
