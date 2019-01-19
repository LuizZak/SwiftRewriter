import Foundation

public final class IntentionSerializer {
    
    internal struct IntentionContainer: Codable {
        var kind: IntentionKind
        var intention: Intention
        
        init(intention: Intention) throws {
            let kind: IntentionKind
            
            switch intention {
            case is TypealiasIntention:
                kind = .typealias
                
            case is ClassGenerationIntention:
                kind = .class
                
            case is StructGenerationIntention:
                kind = .struct
                
            case is EnumGenerationIntention:
                kind = .enum
                
            case is FileGenerationIntention:
                kind = .file
                
            case is EnumCaseGenerationIntention:
                kind = .enumCase
                
            case is ProtocolPropertyGenerationIntention:
                kind = .protocolProperty
                
            case is PropertyGenerationIntention:
                kind = .property
                
            case is ProtocolMethodGenerationIntention:
                kind = .protocolMethod
                
            case is MethodGenerationIntention:
                kind = .method
                
            case is InitGenerationIntention:
                kind = .initializer
                
            case is ClassExtensionGenerationIntention:
                kind = .classExtension
                
            case is InstanceVariableGenerationIntention:
                kind = .field
                
            case is GlobalFunctionGenerationIntention:
                kind = .globalFunction
                
            case is GlobalVariableGenerationIntention:
                kind = .globalVariable
                
            case is GlobalVariableInitialValueIntention:
                kind = .globalVariableInitialValue
                
            case is FunctionBodyIntention:
                kind = .functionBody
                
            case is ProtocolInheritanceIntention:
                kind = .protocolInheritance
                
            case is ProtocolGenerationIntention:
                kind = .protocol
                
            case is PropertySynthesizationIntention:
                kind = .propertySynthesize
                
            default:
                throw Error.unknownIntentionType(type(of: intention))
            }
            
            self.kind = kind
            self.intention = intention
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: IntentionContainerKeys.self)
            
            kind = try container.decode(IntentionKind.self, forKey: .kind)
            
            switch kind {
            case .file:
                intention = try container.decode(FileGenerationIntention.self, forKey: .intention)
            
            case .class:
                intention = try container.decode(ClassGenerationIntention.self, forKey: .intention)
            
            case .enum:
                intention = try container.decode(EnumGenerationIntention.self, forKey: .intention)
            
            case .struct:
                intention = try container.decode(StructGenerationIntention.self, forKey: .intention)
            
            case .classExtension:
                intention = try container.decode(ClassExtensionGenerationIntention.self, forKey: .intention)
            
            case .initializer:
                intention = try container.decode(InitGenerationIntention.self, forKey: .intention)
                
            case .enumCase:
                intention = try container.decode(EnumCaseGenerationIntention.self, forKey: .intention)
            
            case .property:
                intention = try container.decode(PropertyGenerationIntention.self, forKey: .intention)
            
            case .method:
                intention = try container.decode(MethodGenerationIntention.self, forKey: .intention)
            
            case .field:
                intention = try container.decode(InstanceVariableGenerationIntention.self, forKey: .intention)
            
            case .globalFunction:
                intention = try container.decode(GlobalFunctionGenerationIntention.self, forKey: .intention)
            
            case .globalVariable:
                intention = try container.decode(GlobalVariableGenerationIntention.self, forKey: .intention)
                
            case .globalVariableInitialValue:
                intention = try container.decode(GlobalVariableInitialValueIntention.self, forKey: .intention)
            
            case .protocolMethod:
                intention = try container.decode(ProtocolMethodGenerationIntention.self, forKey: .intention)
            
            case .protocolProperty:
                intention = try container.decode(ProtocolPropertyGenerationIntention.self, forKey: .intention)
            
            case .protocolInheritance:
                intention = try container.decode(ProtocolInheritanceIntention.self, forKey: .intention)
            
            case .typealias:
                intention = try container.decode(TypealiasIntention.self, forKey: .intention)
                
            case .functionBody:
                intention = try container.decode(FunctionBodyIntention.self, forKey: .intention)
                
            case .protocol:
                intention = try container.decode(ProtocolGenerationIntention.self, forKey: .intention)
                
            case .propertySynthesize:
                intention = try container.decode(PropertySynthesizationIntention.self, forKey: .intention)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: IntentionContainerKeys.self)
            
            try container.encode(kind, forKey: .kind)
            try container.encode(intention, forKey: .intention)
        }
    }
    
    internal enum IntentionContainerKeys: String, CodingKey {
        case kind
        case intention
    }
    
    internal enum IntentionKind: String, Codable {
        case file
        case `class`
        case `enum`
        case `struct`
        case `protocol`
        case classExtension
        case initializer
        case property
        case propertySynthesize
        case method
        case field
        case globalFunction
        case globalVariable
        case globalVariableInitialValue
        case enumCase
        case protocolMethod
        case protocolProperty
        case protocolInheritance
        case `typealias`
        case functionBody
    }
    
    public enum Error: Swift.Error {
        case unknownIntentionType(Intention.Type)
        case unexpectedIntentionType(Intention.Type)
    }
}

public extension IntentionSerializer {
    
    public static func encode(intentions: IntentionCollection,
                              encoder: JSONEncoder) throws -> Data {
        
        return try encoder.encode(intentions)
    }
    
    public static func decodeIntentions(decoder: JSONDecoder,
                                        data: Data) throws -> IntentionCollection {
        
        return try decoder.decode(IntentionCollection.self, from: data)
    }
}
