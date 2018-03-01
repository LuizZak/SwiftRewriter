import Foundation

let classes: ClassesList = {
    let decoder = JSONDecoder()
    let data = iosFrameworkClassesJson.data(using: .utf8)!
    
    return try! decoder.decode(ClassesList.self, from: data)
}()

let protocols: ProtocolsList = {
    let decoder = JSONDecoder()
    let data = iosFrameworkProtocolsJson.data(using: .utf8)!
    
    return try! decoder.decode(ProtocolsList.self, from: data)
}()

/// Exposes the type definitions located within `ios-framework-classes.json` and
/// `ios-framework-protocols.json` files.
public enum TypeDefinitions {
    public static var classesList: ClassesList {
        return classes
    }
    
    public static var protocolsList: ProtocolsList {
        return protocols
    }
}

public struct ClassesList: Codable {
    public var classes: [ClassType]
}

public struct ProtocolsList: Codable {
    public var protocols: [ProtocolType]
}

public struct ProtocolType: Codable, Equatable {
    public var protocolName: String
    public var conformances: [String]
}

public struct ClassType: Codable, Equatable {
    public var typeName: String
    public var superclass: String
    public var protocols: [String]
}
