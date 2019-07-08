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
}

extension CompoundedMappingType: KnownType {
    public var origin: String {
        return knownType.origin
    }
    public var supertype: KnownTypeReference? {
        return knownType.supertype
    }
    public var typeName: String {
        return knownType.typeName
    }
    public var kind: KnownTypeKind {
        return knownType.kind
    }
    public var isExtension: Bool {
        return knownType.isExtension
    }
    public var knownTraits: [String : TraitType] {
        return knownType.knownTraits
    }
    public var knownConstructors: [KnownConstructor] {
        return knownType.knownConstructors
    }
    public var knownMethods: [KnownMethod] {
        return knownType.knownMethods
    }
    public var knownProperties: [KnownProperty] {
        return knownType.knownProperties
    }
    public var knownFields: [KnownProperty] {
        return knownType.knownFields
    }
    public var knownProtocolConformances: [KnownProtocolConformance] {
        return knownType.knownProtocolConformances
    }
    public var knownAttributes: [KnownAttribute] {
        return knownType.knownAttributes
    }
}
