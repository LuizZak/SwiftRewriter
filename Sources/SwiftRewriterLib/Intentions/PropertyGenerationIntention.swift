import GrammarModels
import SwiftAST

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: MemberGenerationIntention, ValueStorageIntention {
    public var propertySource: PropertyDefinition? {
        return source as? PropertyDefinition
    }
    public var synthesizeSource: PropertySynthesizeItem? {
        return source as? PropertySynthesizeItem
    }
    
    public var isOverride: Bool = false
    
    /// Returns `true` if this property requires a backing field to be created.
    /// Backing fields must be created for fully-synthesized properties, as well
    /// as properties that define a getter but are not read-only.
    public var requiresField: Bool {
        switch mode {
        case .computed where !isReadOnly, .asField:
            return true
        default:
            return false
        }
    }
    
    /// Returns `true` if the original Objective-C property is marked with a
    /// "readonly" attribute.
    ///
    /// This is not analogous to `storage.isConstant`, and references only the
    /// Objective-C property.
    public var isReadOnly: Bool {
        return attributes.contains { $0.rawString == "readonly" }
    }
    
    /// Returns `true` if the original Objective-C property is marked with a
    /// "class" attribute.
    public var isClassProperty: Bool {
        return attributes.contains { $0.rawString == "class" }
    }
    
    /// If this property features a synthesized getter, returns the body intention
    /// for the getter.
    public var getter: FunctionBodyIntention? {
        switch mode {
        case .computed(let body), .property(let body, _):
            return body
        default:
            return nil
        }
    }
    
    /// If this property features a synthesized setter, returns the settings for
    /// the setter.
    public var setter: Setter? {
        switch mode {
        case .property(_, let set):
            return set
        default:
            return nil
        }
    }
    
    /// If non-nil, specifies a different access level for the setter of this
    /// property.
    public var setterAccessLevel: AccessLevel?
    
    public override var isStatic: Bool {
        return isClassProperty
    }
    
    public var optional: Bool {
        return false
    }
    
    public var isEnumCase: Bool {
        return false
    }
    
    public override var memberType: SwiftType {
        return type
    }
    
    public var name: String
    public var storage: ValueStorage
    public var mode: Mode = .asField
    public var attributes: [PropertyAttribute]
    
    public convenience init(name: String, type: SwiftType, attributes: [PropertyAttribute],
                            accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        self.init(name: name, storage: storage, attributes: attributes,
                  accessLevel: accessLevel, source: source)
    }
    
    public init(name: String, storage: ValueStorage, attributes: [PropertyAttribute],
                accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.name = name
        self.storage = storage
        self.attributes = attributes
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public enum Mode {
        case asField
        case computed(FunctionBodyIntention)
        case property(get: FunctionBodyIntention, set: Setter)
        
        public var isField: Bool {
            switch self {
            case .asField:
                return true
            case .computed, .property:
                return false
            }
        }
    }
    
    public struct Setter {
        /// Identifier for the setter's received value
        public var valueIdentifier: String
        /// The body for the setter
        public var body: FunctionBodyIntention
        
        public init(valueIdentifier: String, body: FunctionBodyIntention) {
            self.valueIdentifier = valueIdentifier
            self.body = body
        }
    }
}

extension PropertyGenerationIntention: OverridableMemberGenerationIntention {
    
}

extension PropertyGenerationIntention: KnownProperty {
    public var accessor: KnownPropertyAccessor {
        switch mode {
        case .asField, .property:
            return .getterAndSetter
        case .computed:
            return .getter
        }
    }
}
