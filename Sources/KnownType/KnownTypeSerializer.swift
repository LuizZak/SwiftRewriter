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
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(asTypeName)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = .typeName(try container.decode(String.self))
    }
}

public extension KeyedEncodingContainerProtocol {
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

public extension KeyedDecodingContainerProtocol {
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
