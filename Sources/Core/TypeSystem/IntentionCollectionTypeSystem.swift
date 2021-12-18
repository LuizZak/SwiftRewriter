import SwiftAST
import KnownType
import Intentions

/// An extension over the default type system that enables using an intention
/// collection to search for types
public class IntentionCollectionTypeSystem: TypeSystem {
    public var intentions: IntentionCollection
    
    private var intentionsProvider: IntentionCollectionProvider
    
    public init(intentions: IntentionCollection) {
        self.intentions = intentions
        intentionsProvider = IntentionCollectionProvider(intentions: intentions,
                                                         typeSystem: nil)
        
        super.init()
        
        intentionsProvider.typeSystem = self
        
        knownTypeProviders.providers.append(intentionsProvider)
        typealiasProviders.providers.append(intentionsProvider)
    }
    
    public override func makeCache() {
        super.makeCache()
        
        var aliases: [String: SwiftType] = [:]
        var types: [String: [TypeGenerationIntention]] = [:]
        
        for file in intentions.fileIntentions() {
            for alias in file.typealiasIntentions {
                aliases[alias.name] = alias.fromType
            }
        }
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions {
                types[type.typeName, default: []].append(type)
            }
        }
        
        let compoundTypes =
            types.mapValues({
                CompoundKnownType(typeName: $0[0].typeName, types: $0)
            })
        
        intentionsProvider.cache =
            IntentionCollectionProvider.Cache(typeAliases: aliases,
                                              types: compoundTypes)
    }
    
    public override func tearDownCache() {
        super.tearDownCache()
        
        intentionsProvider.cache = nil
    }
    
    public override func isClassInstanceType(_ typeName: String) -> Bool {
        guard let aliased = typeNameIn(swiftType: resolveAlias(in: typeName)) else {
            return false
        }
        
        if let cache = intentionsProvider.cache {
            if let type = cache.types[aliased] {
                return type.kind == .class || type.kind == .protocol
            }
        } else {
            for file in intentions.fileIntentions() {
                if let type = file.typeIntentions.first(where: { $0.typeName == aliased }) {
                    return type.kind == .class || type.kind == .protocol
                }
            }
        }
        
        return super.isClassInstanceType(typeName)
    }
    
    public override func nominalTypeExists(_ name: String) -> Bool {
        if let cache = intentionsProvider.cache {
            if cache.types.keys.contains(name) {
                return true
            }
        } else {
            for file in intentions.fileIntentions() {
                if file.typeIntentions.contains(where: { $0.typeName == name }) {
                    return true
                }
            }
        }
        
        return super.nominalTypeExists(name)
    }
    
    private class IntentionCollectionProvider: TypealiasProvider, KnownTypeProvider {
        var cache: Cache?
        
        var intentions: IntentionCollection
        weak var typeSystem: TypeSystem?
        
        init(intentions: IntentionCollection, typeSystem: TypeSystem?) {
            self.intentions = intentions
            self.typeSystem = typeSystem
        }
        
        func knownType(withName name: String) -> KnownType? {
            if let cache = cache {
                if let match = cache.types[name] {
                    return match
                }
                
                return nil
            }
            
            // Search in type intentions
            var types: [KnownType] = []
            for file in intentions.fileIntentions() {
                for type in file.typeIntentions where type.typeName == name {
                    types.append(type)
                }
            }
            
            guard !types.isEmpty else {
                return nil
            }
            
            // Single type found: Avoid complex merge operations and return it as is.
            if types.count == 1 {
                return types.first
            }
            
            return CompoundKnownType(typeName: name, types: Array(types), typeSystem: typeSystem)
        }
        
        func knownTypes(ofKind kind: KnownTypeKind) -> [KnownType] {
            var types: [KnownType] = []
            
            if let cache = cache {
                for type in cache.types.values where type.kind == kind {
                    types.append(type)
                }
            } else {
                for file in intentions.fileIntentions() {
                    for type in file.typeIntentions where type.kind == kind {
                        types.append(type)
                    }
                }
            }
            
            return types
        }
        
        func canonicalName(for typeName: String) -> String? {
            nil
        }
        
        func unalias(_ typeName: String) -> SwiftType? {
            if let cache = cache {
                if let alias = cache.typeAliases[typeName] {
                    return alias
                }
            } else {
                for file in intentions.fileIntentions() {
                    for alias in file.typealiasIntentions where alias.name == typeName {
                        return alias.fromType
                    }
                }
            }
            
            return nil
        }
        
        struct Cache {
            var typeAliases: [String: SwiftType]
            var types: [String: CompoundKnownType]
        }
    }
}
