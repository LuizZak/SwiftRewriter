import Foundation
import SwiftRewriterLib
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
    private let identifierLexer: GrammarRule = (.letter | "_") .. (.letter | .digit | "_")*
    
    public init() {
        
    }
    
    public func preprocess(source: String, context: PreprocessingContext) -> String {
        // Find QuickSpecBegin/QuickSpecEnd pairs to preprocess
        if !source.contains("QuickSpecBegin") || !source.contains("QuickSpecEnd") {
            return source
        }
        
        // Extract comment sections which will be useful to detect regions where
        // QuickSpecBegin/QuickSpecEnd are actually comments and are not to be
        // modified.
        var commentSections = source.rangesOfCommentSections()
        var processed = source {
            didSet {
                commentSections = processed.rangesOfCommentSections()
            }
        }
        
        /// Returns true if the given range is contained within comment sections
        func overlapsComments(_ range: Range<String.Index>) -> Bool {
            return commentSections.contains { $0.overlaps(range) }
        }
        
        repeat {
            do {
                if let quickSpecBeginRange = processed.range(of: "QuickSpecBegin"), !overlapsComments(quickSpecBeginRange) {
                    // Walk back to the start of the line, making sure we're not
                    // in a comment section
                    
                    // Read name of type
                    let lexer = Lexer(input: source, index: quickSpecBeginRange.upperBound)
                    
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
                    
                    processed = processed.replacingCharacters(in: quickSpecBeginRange.lowerBound..<lexer.inputIndex, with: replace)
                } else if let quickSpecEndRange = processed.range(of: "QuickSpecEnd"), !overlapsComments(quickSpecEndRange) {
                    let replace = """
                    }
                    @end
                    """
                    
                    processed = processed.replacingCharacters(in: quickSpecEndRange, with: replace)
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
