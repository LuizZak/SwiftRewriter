import Foundation
import SwiftAST

/// A serializer for KnownType definitions
public final class KnownTypeSerializer {
    /// Serializes the public interface of a given known type.
    ///
    /// Body of methods are not serialized along with the method signatures.
    public static func serialize(type: KnownType) throws -> Data {
        let builder = KnownTypeBuilder(from: type)
        return try builder.encode()
    }
    
    /// Deserializes a public type information present on a given data stream.
    public static func deserialize(from data: Data) throws -> KnownType {
        var builder = KnownTypeBuilder(typeName: "")
        try builder.decode(from: data)
        return builder.build()
    }
}

extension KnownTypeReference: Codable {
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            var next = try KnownTypeReference.typeName(container.decode(String.self))
            while !container.isAtEnd {
                next = try KnownTypeReference.nested(base: next, typeName: container.decode(String.self))
            }
            
            self = next
            
            return
        }
        
        let container = try decoder.singleValueContainer()
        
        self = try .typeName(container.decode(String.self))
    }
    
    public func encode(to encoder: Encoder) throws {
        switch self {
        case .typeName(let name):
            if encoder.codingPath.isEmpty {
                var container = encoder.unkeyedContainer()
                
                for name in asNestedTypeNames {
                    try container.encode(name)
                }
            } else {
                var container = encoder.singleValueContainer()
                
                try container.encode(name)
            }
            
        case .nested:
            var container = encoder.unkeyedContainer()
            
            for name in asNestedTypeNames {
                try container.encode(name)
            }
        }
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encodeKnownType(_ type: KnownType, forKey key: Key) throws {
        let builder = KnownTypeBuilder(from: type)
        
        try self.encode(builder.type, forKey: key)
    }
    
    mutating func encodeKnownTypes(_ types: [KnownType], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for type in types {
            try nested.encodeKnownType(type)
        }
    }
}

extension KeyedDecodingContainerProtocol {
    func decodeKnownType(forKey key: Key) throws -> KnownType {
        return try decode(BuildingKnownType.self, forKey: key)
    }
    
    func decodeKnownTypes(forKey key: Key) throws -> [KnownType] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var types: [KnownType] = []
        
        while !nested.isAtEnd {
            types.append(try nested.decodeKnownType())
        }
        
        return types
    }
}

public extension UnkeyedDecodingContainer {
    mutating func decodeKnownType() throws -> KnownType {
        let container = try self.decode(BuildingKnownType.self)
        
        return container
    }
}

public extension UnkeyedEncodingContainer {
    mutating func encodeKnownType(_ type: KnownType) throws {
        let container = KnownTypeBuilder(from: type)
        
        try self.encode(container.type)
    }
}
