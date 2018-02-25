import SwiftAST

/// A wrapper for querying the type system context for specific type knowledges
public protocol TypeSystem {
    /// Returns `true` if `type` represents a numerical type (int, float, CGFloat, etc.)
    func isNumeric(_ type: SwiftType) -> Bool
    
    /// Returns `true` is an integer (signed or unsigned) type
    func isInteger(_ type: SwiftType) -> Bool
    
    /// Gets a known type with a given name from this type system
    func knownTypeWithName(_ name: String) -> KnownType?
    
    /// Returns `true` if a type represented by a given type name is a subtype of
    /// another type
    func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool
}

/// Standard type system implementation
public class DefaultTypeSystem: TypeSystem {
    var types: [KnownType] = []
    
    public init() {
        registerInitialKnownTypes()
    }
    
    public func addType(_ type: KnownType) {
        types.append(type)
    }
    
    public func knownTypeWithName(_ name: String) -> KnownType? {
        return types.first { $0.typeName == name }
    }
    
    public func isType(_ typeName: String, subtypeOf supertypeName: String) -> Bool {
        guard let type = knownTypeWithName(typeName) else {
            return false
        }
        guard let supertype = knownTypeWithName(supertypeName) else {
            return false
        }
        
        var current: KnownType? = type
        while let c = current {
            if c.typeName == supertype.typeName {
                return true
            }
            
            current = c.supertype?.asKnownType
        }
        
        return false
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

extension DefaultTypeSystem {
    /// Initializes the default known types
    func registerInitialKnownTypes() {
        let nsObject =
            KnownTypeBuilder(typeName: "NSObject")
                .addingConstructor()
                .build()
        
        let nsArray =
            KnownTypeBuilder(typeName: "NSArray", supertype: nsObject)
                .build()
        
        let nsMutableArray =
            KnownTypeBuilder(typeName: "NSMutableArray", supertype: nsArray)
                .addingMethod(withSignature:
                    FunctionSignature(isStatic: false, name: "addObject",
                                      returnType: .void,
                                      parameters: [
                                        ParameterSignature(label: "_", name: "object", type: .anyObject)
                        ]))
                .build()
        
        let nsDictionary =
            KnownTypeBuilder(typeName: "NSDictionary", supertype: nsObject)
                .build()
        
        let nsMutableDictionary =
            KnownTypeBuilder(typeName: "NSMutableDictionary", supertype: nsDictionary)
                .addingMethod(withSignature:
                    FunctionSignature(isStatic: false, name: "setObject",
                                      returnType: .void,
                                      parameters: [
                                        ParameterSignature(label: "_", name: "anObject", type: .anyObject),
                                        ParameterSignature(label: "forKey", name: "aKey", type: .anyObject)
                        ]))
                .build()
        
        addType(nsObject)
        addType(nsArray)
        addType(nsMutableArray)
        addType(nsDictionary)
        addType(nsMutableDictionary)
    }
}
