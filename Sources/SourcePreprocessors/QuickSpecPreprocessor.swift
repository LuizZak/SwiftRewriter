import Utils
import RegexBuilder

/// Performs pre-processing of QuickSpec test files
public class QuickSpecPreprocessor: SourcePreprocessor {
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
        var commentSections = source.cStyleCommentSectionRanges()
        var processed = source {
            didSet {
                commentSections = processed.cStyleCommentSectionRanges()
            }
        }
        
        /// Returns true if the given range is contained within comment sections
        func overlapsComments(_ range: Range<String.Index>) -> Bool {
            commentSections.contains { $0.overlaps(range) }
        }
        
        let beginRegex = Regex {
            specBeginName
            ZeroOrMore(.whitespace)
            "("
            ZeroOrMore(.whitespace)
            Capture {
                OneOrMore(.word)
            }
            ZeroOrMore(.whitespace)
            ")"
        }

        let endRegex = Regex {
            specEndName
        }

        processed.replace(beginRegex) { match in
            if overlapsComments(match.range) {
                return String(match.output.0)
            }

            // Replace with proper @interface class name
            return """
            @interface \(match.output.1) : QuickSpec
            @end
            @implementation \(match.output.1)
            - (void)spec {
            """
        }

        processed.replace(endRegex) { match in
            if overlapsComments(match.range) {
                return String(match.output)
            }

            return """
            }
            @end
            """
        }
        
        return processed
    }
}
