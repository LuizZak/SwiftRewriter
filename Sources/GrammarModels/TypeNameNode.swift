public class TypeNameNode: ASTNode {
    /// Full type name
    public var type: ObjcType
    
    public init(type: ObjcType, location: SourceRange = .invalid) {
        self.type = type
        
        super.init(location: location)
    }
    
    /// Specifies an objetive-c type for a property or local.
    /// For objc class pointers, they are always specified as
    /// `.pointerType(.structType("NSSomeClass"))`, like `.pointerType(.structType("NSObject"))`
    public enum ObjcType: CustomStringConvertible {
        /// Objective-c's `id` type, with optional protocol array specifiers
        case id(protocols: [String])
        
        /// A struct-type.
        /// May be any type that is not an `id`.
        case `struct`(String)
        
        /// A composed pointer, like `NSObject*` or `int*`.
        /// May be an objc class or a struct-type pointer.
        indirect case pointer(ObjcType)
        
        /// A generic objc type- e.g. `NSArray<NSNumber*>`
        indirect case generic(String, parameters: [ObjcType])
        
        /// Gets the plain string definition for this type.
        /// Always maps to valid objc type
        public var description: String {
            switch self {
            case .struct(let s):
                return s
            case let .generic(cl, parameters):
                let typeNames = parameters.map { $0.description }.joined(separator: ", ")
                
                return "\(cl)<\(typeNames)>"
            case .id(let protocols):
                if protocols.count > 0 {
                    let protocolNames = protocols.joined(separator: ", ")
                    return "id<\(protocolNames)>"
                } else {
                    return "id"
                }
            case .pointer(let type):
                return "\(type.description)*"
            }
        }
    }
}

public extension ASTNodeRef where Node == TypeNameNode {
    public var type: TypeNameNode.ObjcType? {
        switch self {
        case .valid(let node):
            return node.type
        case .invalid:
            return nil
        }
    }
}

extension TypeNameNode.ObjcType: Equatable {
    public static func ==(lhs: TypeNameNode.ObjcType, rhs: TypeNameNode.ObjcType) -> Bool {
        switch (lhs, rhs) {
        case let (.struct(l), .struct(r)):
            return l == r
        case let (.id(lhsProtocols), .id(rhsProtocols)):
            return lhsProtocols == rhsProtocols
        case let (.generic(lhsClassName, lhsParameters), .generic(rhsClassName, rhsParameters)):
            return lhsClassName == rhsClassName && lhsParameters == rhsParameters
        case let (.pointer(lhsPointer), .pointer(rhsPointer)):
            return lhsPointer == rhsPointer
        default:
            return false
        }
    }
}
