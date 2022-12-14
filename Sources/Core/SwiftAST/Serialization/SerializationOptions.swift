public struct SerializationOptions: OptionSet {
    internal static let _encodeExpressionTypes = CodingUserInfoKey(rawValue: "_encodeExpressionTypes")!
    
    /// Whether to encode current resolved types when encoding expressions
    public static let encodeExpressionTypes = SerializationOptions(rawValue: 1 << 0)
    
    public var rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
