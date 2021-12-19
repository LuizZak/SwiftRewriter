import Foundation

/// Protocol for enabling Swift rewriting service from CLI
public protocol SwiftRewriterService {
    /// Performs a rewrite of the given files
    func rewrite(files: [URL]) throws

    /// Performs a rewrite of the given files
    func rewrite(files: [DiskInputFile]) throws
    
    /// Performs a rewrite of the given inputs
    func rewrite(inputs: [InputSource]) throws
}
