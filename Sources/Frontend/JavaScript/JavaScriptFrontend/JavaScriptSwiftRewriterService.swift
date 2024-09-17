import SwiftRewriterLib

/// Refined protocol for JavaScript rewriter services.
public protocol JavaScriptSwiftRewriterService: SwiftRewriterService {
    /// Gets the shared parser cache.
    var parserCache: JavaScriptParserCache { get }
}
