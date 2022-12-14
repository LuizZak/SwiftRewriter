
/// Describes settings for ANTLR parsing for an `ObjcParser` instance.
public struct AntlrSettings {
    public static let `default` = AntlrSettings(forceUseLLPrediction: false)
    
    public var forceUseLLPrediction: Bool
    
    public init(forceUseLLPrediction: Bool) {
        self.forceUseLLPrediction = forceUseLLPrediction
    }
}
