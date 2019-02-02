import SwiftAST
import SwiftRewriterLib
import TypeSystem
import Commons

public class CompoundedMappingTypesGlobalsProvider: GlobalsProvider {
    private static var provider = InnerCompoundedMappingTypesGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        let provider =
            CollectionKnownTypeProvider(knownTypes:
                CompoundedMappingTypesGlobalsProvider.provider.types)
        
        for (nonCanon, canon) in CompoundedMappingTypesGlobalsProvider.provider.canonicalMapping {
            provider.addCanonicalMapping(nonCanonical: nonCanon, canonical: canon)
        }
        
        return provider
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases:
            CompoundedMappingTypesGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        return ArrayDefinitionsSource(definitions: [])
    }
}

/// Globals provider for `Foundation` framework
private class InnerCompoundedMappingTypesGlobalsProvider: BaseGlobalsProvider {
    override func createTypes() {
        for type in CompoundedMappingTypeList.typeList() {
            addCanonicalMappings(from: type)
            add(type)
        }
    }
}
