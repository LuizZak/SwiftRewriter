import Foundation
import SwiftAST
import KnownType
import SwiftRewriterLib

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
