import SwiftAST
import SwiftRewriterLib
import Commons

public class FoundationGlobalsProvider: GlobalsProvider {
    private static var provider = InnerFoundationGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        let provider =
            CollectionKnownTypeProvider(knownTypes: FoundationGlobalsProvider.provider.types)
        
        for (nonCanon, canon) in FoundationGlobalsProvider.provider.canonicalMapping {
            provider.addCanonicalMapping(nonCanonical: nonCanon, canonical: canon)
        }
        
        return provider
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases: FoundationGlobalsProvider.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        return FoundationGlobalsProvider.provider.definitions
    }
}

/// Globals provider for `Foundation` framework
private class InnerFoundationGlobalsProvider: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    override func createTypes() {
        createNSArray()
        createNSMutableArray()
        createNSCalendar()
        createNSLocale()
        createNSDateFormatter()
        createNSDate()
    }
    
    func createNSArray() {
        let type = FoundationCompoundTypes.nsArray.create()
        add(type)
    }
    
    func createNSMutableArray() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        add(type)
    }
    
    func createNSCalendar() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        add(type)
    }
    
    func createNSLocale() {
        let type = FoundationCompoundTypes.nsLocale.create()
        add(type)
    }
    
    func createNSDateFormatter() {
        let type = FoundationCompoundTypes.nsDateFormatter.create()
        add(type)
    }
    
    func createNSDate() {
        let type = FoundationCompoundTypes.nsDate.create()
        add(type)
    }
    
}
