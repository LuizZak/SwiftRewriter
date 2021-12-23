/// A key to provide in Decoder.userInfo dictionary to store a
/// `SerializableMetadataSerializerType` object that SerializableMetadataEntry
/// objects can use to load objects.
public let SerializableMetadataSerializerTypeUserInfoKey: CodingUserInfoKey = .init(rawValue: "SerializableMetadataSerializerType")!

/// Provides an interface for serializing and deserializing attached metadata
/// from `Intention` objects.
public protocol SerializableMetadataSerializerType {
    /// Requests that a serializable object be decoded.
    func deserialize(type: String, decoder: Decoder) throws -> Any
    
    /// Requests that a serializable object be encoded.
    func serialize(type: String, value: Any, encoder: Encoder) throws
}
