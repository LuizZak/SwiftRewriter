import SwiftAST
import KnownType

/// Represents a type that, as well as having a full type signature, describes
/// information for converting invocations and implementations of methods on
/// implementers and expression call sites.
public class CompoundedMappingType {
    var knownType: KnownType
    
    /// Set of alternative names this class can be referenced as, but which are
    /// not the primary, canonical name.
    public let nonCanonicalNames: [String]
    
    public let transformations: [PostfixTransformation]
    
    /// Methods that are not actually part of the original known type definition,
    /// but are aliases of other methods described via `@_swiftrewriter` attributes
    /// in methods
    public let aliasedMethods: [KnownMethod]
    
    public var semantics: Set<Semantic>
    
    public init(knownType: KnownType,
                transformations: [PostfixTransformation],
                aliasedMethods: [KnownMethod],
                semantics: Set<Semantic> = [],
                aliases: [String] = []) {
        
        self.knownType = knownType
        self.transformations = transformations
        self.aliasedMethods = aliasedMethods
        self.semantics = semantics
        self.nonCanonicalNames = aliases
    }
}

extension CompoundedMappingType: KnownType {
    public var knownFile: KnownFile? {
        return knownType.knownFile
    }
    public var origin: String {
        knownType.origin
    }
    public var supertype: KnownTypeReference? {
        knownType.supertype
    }
    public var typeName: String {
        knownType.typeName
    }
    public var kind: KnownTypeKind {
        knownType.kind
    }
    public var isExtension: Bool {
        knownType.isExtension
    }
    public var knownTraits: [String : TraitType] {
        knownType.knownTraits
    }
    public var knownConstructors: [KnownConstructor] {
        knownType.knownConstructors
    }
    public var knownMethods: [KnownMethod] {
        knownType.knownMethods
    }
    public var knownProperties: [KnownProperty] {
        knownType.knownProperties
    }
    public var knownFields: [KnownProperty] {
        knownType.knownFields
    }
    public var knownSubscripts: [KnownSubscript] {
        knownType.knownSubscripts
    }
    public var knownProtocolConformances: [KnownProtocolConformance] {
        knownType.knownProtocolConformances
    }
    public var knownAttributes: [KnownAttribute] {
        knownType.knownAttributes
    }
}
