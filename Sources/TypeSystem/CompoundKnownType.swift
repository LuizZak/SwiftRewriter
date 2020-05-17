import KnownType

/// A compound known type whose members are computed at creation time as aggregated
/// members of all types.
class CompoundKnownType: KnownType {
    private var types: [KnownType]
    
    var typeName: String
    
    var kind: KnownTypeKind
    var knownFile: KnownFile?
    var knownTraits: [String: TraitType]
    var origin: String
    var supertype: KnownTypeReference?
    var knownConstructors: [KnownConstructor]
    var knownMethods: [KnownMethod]
    var knownProperties: [KnownProperty]
    var knownFields: [KnownProperty]
    var knownSubscripts: [KnownSubscript]
    var knownProtocolConformances: [KnownProtocolConformance]
    var knownAttributes: [KnownAttribute]
    var semantics: Set<Semantic>
    
    init(typeName: String, types: [KnownType], typeSystem: TypeSystem? = nil) {
        self.typeName = typeName
        self.types = types
        
        knownTraits = types.reduce([:], { $0.merging($1.knownTraits, uniquingKeysWith: { $1 }) })
        knownConstructors = []
        knownMethods = []
        knownProperties = []
        knownFields = []
        knownSubscripts = []
        knownProtocolConformances = []
        knownAttributes = []
        semantics = []
        for type in types  {
            knownConstructors.append(contentsOf: type.knownConstructors)
            knownMethods.append(contentsOf: type.knownMethods)
            knownProperties.append(contentsOf: type.knownProperties)
            knownFields.append(contentsOf: type.knownFields)
            knownSubscripts.append(contentsOf: type.knownSubscripts)
            knownProtocolConformances.append(contentsOf: type.knownProtocolConformances)
            knownAttributes.append(contentsOf: type.knownAttributes)
            semantics.formUnion(type.semantics)
        }
        
        kind = types.first(where: { $0.kind != .extension })?.kind ?? types[0].kind
        origin = types[0].origin
        
        for type in types {
            // Search supertypes known here
            switch type.supertype {
            case .typeName(let supertypeName)?:
                supertype =
                    typeSystem?.knownTypeWithName(supertypeName).map { .knownType($0) }
                        ?? .typeName(supertypeName)
            case .knownType?:
                supertype = type.supertype
            default:
                break
            }
        }
    }
}
