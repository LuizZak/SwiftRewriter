import SwiftRewriterLib

/// Refined protocol for Objective-C rewriter services.
public protocol ObjectiveCSwiftRewriterService: SwiftRewriterService {
    /// Gets the shared parser cache.
    var parserCache: ObjectiveCParserCache { get }
}
