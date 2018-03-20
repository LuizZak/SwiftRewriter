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
