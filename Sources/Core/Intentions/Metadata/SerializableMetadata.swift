/// A container for serializable metadata entries.
public struct SerializableMetadata: Codable {
    public typealias Key = String
    public typealias Value = SerializableMetadataEntry

    private var _entries: [Key: Value]

    /// Initializes an empty metadata object.
    public init() {
        _entries = [:]
    }

    /// Attempts to fetch a metadata entry for a given key from this metadata
    /// container.
    ///
    /// Returns `nil` if the key is non-existant.
    public func getEntry(forKey key: Key) -> Value? {
        _entries[key]
    }

    /// Attempts to fetch a value with a given type for a given key from this
    /// metadata container.
    ///
    /// Returns `nil` if the key is non-existant or the associated value for the
    /// key is not `T`.
    public func getValue<T>(forKey key: Key) -> T? {
        getEntry(forKey: key)?.value as? T
    }

    /// Returns `true` if the given key is contained within this metadata object.
    public func hasKey(_ key: Key) -> Bool {
        _entries[key] != nil
    }

    /// Updates an entry for a given key.
    public mutating func updateEntry(_ entry: Value, forKey key: Key) {
        _entries[key] = entry
    }

    /// Updates the underlying value for a metadata entry for a given key.
    public mutating func updateValue<T>(_ value: T, type: String, forKey key: Key) {
        updateEntry(.init(type: type, value: value), forKey: key)
    }

    /// Removes an entry for a given key.
    public mutating func removeValue(forKey key: Key) {
        _entries.removeValue(forKey: key)
    }
}
