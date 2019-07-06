import Utils
import MiniLexer

/// Performs pre-processing of QuickSpec test files
public class QuickSpecPreprocessor: SourcePreprocessor {
    /// Lexer rule that matches class identifiers.
    ///
    /// Reads as a formal grammar that is roughly like the one bellow:
    ///
    /// ```
    /// identifierLexer:
    ///     [a-zA-Z_] [a-zA-Z0-9_]*
    /// ```
    private let identifierLexer: GrammarRule = (.letter | "_") + (.letter | .digit | "_")*
    
    public init() {
        
    }
    
    public func preprocess(source: String, context: PreprocessingContext) -> String {
        let firstPass = preprocessSpecPair(source, specBeginName: "QuickSpecBegin", specEndName: "QuickSpecEnd")
        
        return preprocessSpecPair(firstPass, specBeginName: "SpecBegin", specEndName: "SpecEnd")
    }
    
    fileprivate func preprocessSpecPair(_ source: String, specBeginName: String, specEndName: String) -> String {
        // Find QuickSpecBegin/QuickSpecEnd pairs to preprocess
        if !source.contains(specBeginName) || !source.contains(specEndName) {
            return source
        }
        
        // Extract comment sections which will be useful to detect regions where
        // QuickSpecBegin/QuickSpecEnd are actually comments and are not to be
        // modified.
        var commentSections = source.commentSectionRanges()
        var processed = source {
            didSet {
                commentSections = processed.commentSectionRanges()
            }
        }
        
        /// Returns true if the given range is contained within comment sections
        func overlapsComments(_ range: Range<String.Index>) -> Bool {
            commentSections.contains { $0.overlaps(range) }
        }
        
        repeat {
            do {
                if let specBeginRange = processed.range(of: specBeginName), !overlapsComments(specBeginRange) {
                    // Walk back to the start of the line, making sure we're not
                    // in a comment section
                    
                    // Read name of type
                    let lexer = Lexer(input: source, index: specBeginRange.upperBound)
                    
                    try lexer.skipToNext("(")
                    try lexer.advance()
                    
                    lexer.skipWhitespace()
                    
                    let className = try identifierLexer.consume(from: lexer)
                    
                    // Consume closing parens
                    try lexer.skipToNext(")")
                    try lexer.advance()
                    
                    // Replace with proper @interface class name
                    let replace = """
                    @interface \(className) : QuickSpec
                    @end
                    @implementation \(className)
                    - (void)spec {
                    """
                    
                    processed =
                        processed
                            .replacingCharacters(in: specBeginRange.lowerBound..<lexer.inputIndex,
                                                 with: replace)
                    
                } else if let specEndRange = processed.range(of: specEndName), !overlapsComments(specEndRange) {
                    let replace = """
                    }
                    @end
                    """
                    
                    processed = processed.replacingCharacters(in: specEndRange, with: replace)
                } else {
                    break
                }
            } catch {
                return processed
            }
        } while true
        
        return processed
    }
}
