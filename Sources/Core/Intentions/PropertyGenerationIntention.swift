import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a property, either static/instance, computed/stored
/// for a type definition.
public class PropertyGenerationIntention: MemberGenerationIntention, MutableValueStorageIntention {
    /*
    public var propertySource: ObjcPropertyDefinitionNode? {
        source as? ObjcPropertyDefinitionNode
    }
    */
    
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
        objcAttributes.contains { $0.rawString == "readonly" }
    }
    
    /// Returns `true` if the original Objective-C property is marked with a
    /// "class" attribute.
    public var isClassProperty: Bool {
        objcAttributes.contains { $0.rawString == "class" }
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
        isClassProperty
    }
    
    public var optional: Bool {
        false
    }
    
    public var isEnumCase: Bool {
        false
    }
    
    public override var memberType: SwiftType {
        type
    }
    
    public var expression: Expression? {
        initialValue
    }
    
    public var name: String
    public var storage: ValueStorage
    public var mode: Mode = .asField {
        didSet {
            oldValue.setParent(nil)
            mode.setParent(self)
        }
    }
    public var objcAttributes: [ObjcPropertyAttribute]
    
    public var initialValue: Expression?
    
    public convenience init(name: String,
                            type: SwiftType,
                            objcAttributes: [ObjcPropertyAttribute],
                            accessLevel: AccessLevel = .internal,
                            source: ASTNode? = nil) {
        
        let storage =
            ValueStorage(
                type: type,
                ownership: .strong,
                isConstant: false)
        
        self.init(name: name,
                  storage: storage,
                  objcAttributes: objcAttributes,
                  accessLevel: accessLevel,
                  source: source)
    }
    
    public init(name: String,
                storage: ValueStorage,
                objcAttributes: [ObjcPropertyAttribute],
                accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        
        self.name = name
        self.storage = storage
        self.objcAttributes = objcAttributes
        
        super.init(accessLevel: accessLevel, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        isOverride = try container.decode(Bool.self, forKey: .isOverride)
        setterAccessLevel =
            try container.decodeIfPresent(AccessLevel.self,
                                          forKey: .setterAccessLevel)
        
        name = try container.decode(String.self, forKey: .name)
        storage = try container.decode(ValueStorage.self, forKey: .storage)
        mode = try container.decode(Mode.self, forKey: .mode)
        objcAttributes = try container.decode([ObjcPropertyAttribute].self,
                                          forKey: .attributes)
        initialValue = try container.decodeIfPresent(Expression.self,
                                                     forKey: .initialValue)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(isOverride, forKey: .isOverride)
        try container.encodeIfPresent(setterAccessLevel,
                                      forKey: .setterAccessLevel)
        try container.encode(name, forKey: .name)
        try container.encode(storage, forKey: .storage)
        try container.encode(mode, forKey: .mode)
        try container.encode(objcAttributes, forKey: .attributes)
        try container.encode(initialValue, forKey: .initialValue)
        
        try super.encode(to: container.superEncoder())
    }
    
    public enum Mode: Codable {
        case asField
        case computed(FunctionBodyIntention)
        case property(get: FunctionBodyIntention, set: Setter)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let key = try container.decode(Int.self, forKey: .discriminator)
            
            switch key {
            case 0:
                self = .asField
                
            case 1:
                self = try .computed(container.decodeIntention(forKey: .payload0))
                
            case 2:
                let getter =
                    try container.decodeIntention(FunctionBodyIntention.self,
                                                  forKey: .payload0)
                
                let setter = try container.decode(Setter.self, forKey: .payload1)
                
                self = .property(get: getter, set: setter)
                
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .discriminator,
                    in: container,
                    debugDescription: "Unknown discriminator value \(key); expected either 0, 1 or 2")
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .asField:
                try container.encode(0, forKey: .discriminator)
                
            case .computed(let body):
                try container.encode(1, forKey: .discriminator)
                try container.encodeIntention(body, forKey: .payload0)
                
            case let .property(get, set):
                try container.encode(2, forKey: .discriminator)
                try container.encodeIntention(get, forKey: .payload0)
                try container.encode(set, forKey: .payload1)
            }
        }
        
        public var isField: Bool {
            switch self {
            case .asField:
                return true
            case .computed, .property:
                return false
            }
        }
        
        func setParent(_ intention: Intention?) {
            switch self {
            case .asField:
                break
            case .computed(let body):
                body.parent = intention
            case let .property(getter, setter):
                getter.parent = intention
                setter.body.parent = intention
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case discriminator
            case payload0
            case payload1
        }
    }
    
    public struct Setter: Codable {
        /// Identifier for the setter's received value
        public var valueIdentifier: String
        /// The body for the setter
        public var body: FunctionBodyIntention
        
        public init(valueIdentifier: String, body: CompoundStatement) {
            self.init(valueIdentifier: valueIdentifier,
                      body: FunctionBodyIntention(body: body))
        }
        
        public init(valueIdentifier: String, body: FunctionBodyIntention) {
            self.valueIdentifier = valueIdentifier
            self.body = body
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            valueIdentifier = try container.decode(String.self,
                                                   forKey: .valueIdentifier)
            body = try container.decodeIntention(forKey: .body)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(valueIdentifier, forKey: .valueIdentifier)
            try container.encodeIntention(body, forKey: .body)
        }
        
        private enum CodingKeys: String, CodingKey {
            case valueIdentifier
            case body
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case isOverride
        case name
        case storage
        case setterAccessLevel
        case attributes
        case mode
        case initialValue
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
