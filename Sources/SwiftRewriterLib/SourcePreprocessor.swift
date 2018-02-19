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
    func preprocess(source: String) -> String
}
