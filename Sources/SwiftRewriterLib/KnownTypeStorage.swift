/// Partial protocol for a KnownTypeStorage that only provides access to types.
public protocol KnownTypeSource {
    /// Recovers a type by name on this storage
    func recoverType(named name: String) -> KnownType?
}

/// Storage for known types.
public protocol KnownTypeStorage: KnownTypeSource {
    /// Registers a new type
    func registerType(_ type: KnownType)
}

internal class KnownTypeStorageImpl: KnownTypeStorage {
    private var types: [KnownType] = []
    
    public func registerType(_ type: KnownType) {
        types.append(type)
    }
    
    func recoverType(named name: String) -> KnownType? {
        return types.first { $0.typeName == name }
    }
}
