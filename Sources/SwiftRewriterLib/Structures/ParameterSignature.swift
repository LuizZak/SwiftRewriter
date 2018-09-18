import SwiftAST

public struct ParameterSignature: Equatable, Codable {
    public var label: String?
    public var name: String
    public var type: SwiftType
    public var hasDefaultValue: Bool
    
    public init(name: String, type: SwiftType, hasDefaultValue: Bool = false) {
        self.label = name
        self.name = name
        self.type = type
        self.hasDefaultValue = hasDefaultValue
    }
    
    public init(label: String?, name: String, type: SwiftType, hasDefaultValue: Bool = false) {
        self.label = label
        self.name = name
        self.type = type
        self.hasDefaultValue = hasDefaultValue
    }
}
