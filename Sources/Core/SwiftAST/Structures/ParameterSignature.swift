public struct ParameterSignature: Hashable, Codable {
    public var label: String?
    public var name: String
    public var type: SwiftType
    public var isVariadic: Bool
    public var hasDefaultValue: Bool
    
    public init(name: String, type: SwiftType, isVariadic: Bool = false, hasDefaultValue: Bool = false) {
        self.label = name
        self.name = name
        self.type = type
        self.isVariadic = isVariadic
        self.hasDefaultValue = hasDefaultValue
    }
    
    public init(label: String?, name: String, type: SwiftType, isVariadic: Bool = false, hasDefaultValue: Bool = false) {
        self.label = label
        self.name = name
        self.type = type
        self.isVariadic = isVariadic
        self.hasDefaultValue = hasDefaultValue
    }
}
