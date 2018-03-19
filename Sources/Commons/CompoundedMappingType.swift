import Foundation
import SwiftAST
import SwiftRewriterLib

/// Represents a type that, as well as having a full type signature, describes
/// information for converting invocations and implementations of methods on implementers
/// and expression call sites.
open class CompoundedMappingType {
    public var signatureMappings: [SignatureMapper] = []
    
    var knownType: KnownType
    
    public init(knownType: KnownType) {
        self.knownType = knownType
        
        createSignatureMappings()
    }
    
    open func createSignatureMappings() {
        
    }
}

extension CompoundedMappingType: KnownType {
    public var origin: String {
        return knownType.origin
    }
    public var supertype: KnownSupertype? {
        return knownType.supertype
    }
    public var typeName: String {
        return knownType.typeName
    }
    public var kind: KnownTypeKind {
        return knownType.kind
    }
    public var knownTraits: [String : Any] {
        get {
            return knownType.knownTraits
        }
        set {
            knownType.knownTraits = newValue
        }
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
}
