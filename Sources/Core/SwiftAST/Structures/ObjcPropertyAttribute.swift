/// Specifies an Objective-C attribute for a property
public enum ObjcPropertyAttribute: Hashable, Codable {
    /// Standard `readonly` property attribute
    public static var readonly: ObjcPropertyAttribute = .attribute("readonly")
    
    case attribute(String)
    case setterName(String)
    case getterName(String)
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let flag = try container.decode(Int.self)
        
        switch flag {
        case 0:
            self = .attribute(try container.decode(String.self))
        case 1:
            self = .setterName(try container.decode(String.self))
        case 2:
            self = .getterName(try container.decode(String.self))
        default:
            let message = """
                Unknown PropertyAttribute flag \(flag). Maybe data was encoded \
                using a different version of SwiftRewriter?
                """
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: message)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        
        switch self {
        case .attribute(let name):
            try container.encode(0)
            try container.encode(name)
            
        case .setterName(let name):
            try container.encode(1)
            try container.encode(name)
            
        case .getterName(let name):
            try container.encode(2)
            try container.encode(name)
        }
    }
    
    public var rawString: String {
        switch self {
        case .attribute(let str), .setterName(let str), .getterName(let str):
            return str
        }
    }
}
