import GrammarModels
import ObjcParser

/// Protocol for pre-parsing source transformers.
/// Source preprocessors take in raw text describing each file and have the opportunity
/// to change the text before it's fed to the parser.
public protocol SourcePreprocessor {
    /// Preprocesses a source file before parsing.
    ///
    /// - Parameter source: Raw text to process.
    /// - Returns: Return of pre-transformation. The transformation must always
    /// generate a parseable code.
    func preprocess(source: String, context: PreprocessingContext) -> String
}

/// Context for a preprocessor
public protocol PreprocessingContext {
    /// The original source file path
    var filePath: String { get }
}

internal struct _PreprocessingContext: PreprocessingContext {
    var filePath: String
}
