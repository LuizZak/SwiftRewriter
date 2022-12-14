import GrammarModelBase
import SwiftAST
import KnownType

/// An intention to generate a subscript declaration
public final class SubscriptGenerationIntention: MemberGenerationIntention {
    public var parameters: [ParameterSignature]
    public var returnType: SwiftType
    public var isConstant: Bool {
        switch mode {
        case .getter:
            return true
            
        case .getterAndSetter:
            return false
        }
    }
    public var mode: Mode {
        didSet {
            oldValue.setParent(nil)
            mode.setParent(self)
        }
    }

    public override var memberType: SwiftType {
        returnType
    }

    /// Returns the getter body for this subscript generation intention.
    public var getter: FunctionBodyIntention {
        mode.getter
    }
    
    /// If this subscript features a setter, returns the settings for the setter,
    /// including its body.
    public var setter: SubscriptGenerationIntention.Setter? {
        mode.setter
    }
    
    public init(
        parameters: [ParameterSignature],
        returnType: SwiftType,
        mode: Mode,
        accessLevel: AccessLevel = .internal,
        source: ASTNode? = nil
    ) {
        self.parameters = parameters
        self.returnType = returnType
        self.mode = mode
        
        super.init(accessLevel: accessLevel, source: source)
        
        mode.setParent(self)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        parameters = try container.decode([ParameterSignature].self, forKey: .parameters)
        returnType = try container.decode(SwiftType.self, forKey: .returnType)
        mode = try container.decode(Mode.self, forKey: .mode)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(parameters, forKey: .parameters)
        try container.encode(returnType, forKey: .returnType)
        try container.encode(mode, forKey: .mode)
        
        try super.encode(to: container.superEncoder())
    }

    public override func accept<T: IntentionVisitor>(_ visitor: T) -> T.Result {
        visitor.visitSubscript(self)
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
            
            valueIdentifier =
                try container.decode(
                    String.self,
                    forKey: .valueIdentifier
                )
            
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
    
    public enum Mode: Codable {
        case getter(FunctionBodyIntention)
        case getterAndSetter(get: FunctionBodyIntention, set: Setter)
        
        public var getter: FunctionBodyIntention {
            switch self {
            case .getter(let f), .getterAndSetter(let f, _):
                return f
            }
        }
        
        public var setter: Setter? {
            switch self {
            case .getterAndSetter(_, let setter):
                return setter
                
            default:
                return nil
            }
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let key = try container.decode(Int.self, forKey: .discriminator)
            
            switch key {
            case 0:
                self = try .getter(container.decodeIntention(forKey: .payload0))
                
            case 1:
                let getter =
                    try container.decodeIntention(
                        FunctionBodyIntention.self,
                        forKey: .payload0
                    )
                
                let setter =
                    try container.decode(
                        Setter.self,
                        forKey: .payload1
                    )
                
                self = .getterAndSetter(get: getter, set: setter)
                
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .discriminator,
                    in: container,
                    debugDescription: "Unknown discriminator value \(key); expected either 0 or 1")
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            switch self {
            case .getter(let body):
                try container.encode(0, forKey: .discriminator)
                try container.encodeIntention(body, forKey: .payload0)
                
            case let .getterAndSetter(get, set):
                try container.encode(1, forKey: .discriminator)
                try container.encodeIntention(get, forKey: .payload0)
                try container.encode(set, forKey: .payload1)
            }
        }
        
        func setParent(_ intention: Intention?) {
            switch self {
            case .getter(let body):
                body.parent = intention
            case let .getterAndSetter(getter, setter):
                getter.parent = intention
                setter.body.parent = intention
            }
        }

        /// Returns `true` if this `Mode` value is a `.getter` case.
        public var isGetterOnly: Bool {
            switch self {
            case .getter:
                return true
            case .getterAndSetter:
                return false
            }
        }

        /// Returns `true` if this `Mode` value is a `.getterAndSetter` case.
        public var isGetterAndSetter: Bool {
            switch self {
            case .getterAndSetter:
                return true
            case .getter:
                return false
            }
        }
        
        private enum CodingKeys: String, CodingKey {
            case discriminator
            case payload0
            case payload1
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case parameters
        case returnType
        case mode
    }
}

extension SubscriptGenerationIntention: KnownSubscript {
    public var signature: SubscriptSignature {
        .init(
            parameters: parameters,
            returnType: returnType,
            isStatic: isStatic
        )
    }
}
