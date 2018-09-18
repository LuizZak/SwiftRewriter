import SwiftAST

public struct ParameterSignature: Equatable, Codable {
    public var label: String?
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.label = name
        self.name = name
        self.type = type
    }
    
    public init(label: String?, name: String, type: SwiftType) {
        self.label = label
        self.name = name
        self.type = type
    }
}
