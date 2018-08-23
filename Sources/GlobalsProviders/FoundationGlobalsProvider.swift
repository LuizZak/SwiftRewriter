import SwiftAST
import SwiftRewriterLib
import Commons

public class FoundationGlobalsProvider: GlobalsProvider {
    private static var provider = InnerFoundationGlobalsProvider()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        return CollectionKnownTypeProvider(knownTypes: FoundationGlobalsProvider.provider.types)
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
        createNSDateFormatter()
        createNSDate()
    }
    
    func createNSArray() {
        let type = FoundationCompoundTypes.nsArray.create()
        types.append(type)
    }
    
    func createNSMutableArray() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        types.append(type)
    }
    
    func createNSCalendar() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        types.append(type)
    }
    
    func createNSDateFormatter() {
        let type = FoundationCompoundTypes.nsDateFormatter.create()
        types.append(type)
    }
    
    func createNSDate() {
        let type = FoundationCompoundTypes.nsDate.create()
        types.append(type)
    }
    
}
