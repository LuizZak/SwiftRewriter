import SwiftAST
import TypeSystem

extension IncompleteKnownType {
    
    func toCompoundedKnownType(
        _ typeSystem: TypeSystem = TypeSystem.defaultTypeSystem) throws -> CompoundedMappingType {
        
        let type = complete(typeSystem: typeSystem)
        let extractor = SwiftAttributeTransformationsExtractor(type: type)
        
        do {
            let nonCanonicalNames = try extractor.nonCanonicalNames()
            let transformations = try extractor.transformations()
            let aliasedMethods = try extractor.methodAliases()
            
            return CompoundedMappingType(knownType: type,
                                         transformations: transformations,
                                         aliasedMethods: aliasedMethods,
                                         semantics: [],
                                         aliases: nonCanonicalNames)
        } catch {
            throw IncompleteTypeError(description:
                """
                Found error while parsing \
                @\(SwiftRewriterAttribute.name) \
                attribute: \(error)
                """
            )
        }
    }
}

struct IncompleteTypeError: Error {
    var description: String
}
