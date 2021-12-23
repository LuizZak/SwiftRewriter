/// Wraps a serializable metadata object for an `Intention` instance.
public struct SerializableMetadataEntry: Codable {
    /// A unique identifier for the type of data encoded by this metadata entry.
    public var type: String

    /// Encapsulated object.
    public var value: Any

    public init(from decoder: Decoder) throws {
        guard let provider = decoder.userInfo[SerializableMetadataSerializerTypeUserInfoKey] as? SerializableMetadataSerializerType else {
            throw CodingError.providerNotFound
        }

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(String.self, forKey: .type)

        let valueContainer = try container.superDecoder(forKey: .value)
        let value = try provider.deserialize(type: type, decoder: valueContainer)

        self.type = type
        self.value = value
    }

    public init(type: String, value: Any) {
        self.type = type
        self.value = value
    }

    public func encode(to encoder: Encoder) throws {
        guard let provider = encoder.userInfo[SerializableMetadataSerializerTypeUserInfoKey] as? SerializableMetadataSerializerType else {
            throw CodingError.providerNotFound
        }

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)

        let valueContainer = container.superEncoder(forKey: .value)
        try provider.serialize(type: type, value: value, encoder: valueContainer)
    }

    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    public enum CodingError: Error {
        /// Thrown when a suitable `SerializableMetadataSerializerType` was not
        /// provided within a `Decoder.userInfo` or `Encoder.userInfo` dictionary.
        case providerNotFound
    }
}
