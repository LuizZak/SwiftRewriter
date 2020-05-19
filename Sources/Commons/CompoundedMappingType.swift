import SwiftAST
import KnownType

/// Represents a type that, as well as having a full type signature, describes
/// information for converting invocations and implementations of methods on
/// implementers and expression call sites.
public class CompoundedMappingType {
    /// Set of alternative names this class can be referenced as, but which are
    /// not the primary, canonical name.
    public let nonCanonicalNames: [String]
    
    public let transformations: [PostfixTransformation]
    
    var knownType: KnownType
    
    public var semantics: Set<Semantic>
    
    public init(knownType: KnownType,
                transformations: [PostfixTransformation],
                semantics: Set<Semantic> = [],
                aliases: [String] = []) {
        
        self.knownType = knownType
        self.transformations = transformations
        self.semantics = semantics
        self.nonCanonicalNames = aliases
    }
    
    public func withTransformations(_ transformations: [PostfixTransformation]) -> CompoundedMappingType {
        return CompoundedMappingType(knownType: knownType,
                                     transformations: transformations,
                                     semantics: semantics,
                                     aliases: nonCanonicalNames)
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
    public var nestedTypes: [KnownType] {
        knownType.nestedTypes
    }
    public var parentType: KnownTypeReference? {
        knownType.parentType
    }
}
