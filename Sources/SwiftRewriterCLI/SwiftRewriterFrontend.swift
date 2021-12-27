import Foundation
import SwiftRewriterLib

/// Protocol for SwiftRewriter frontend implementations.
public protocol SwiftRewriterFrontend {
    /// Gets the name of this frontend.
    var name: String { get }

    /// Requests that a set of files be collected from a given directory.
    func collectFiles(from directory: URL, fileProvider: FileProvider, options: SwiftRewriterFrontendFileCollectionOptions) throws -> [DiskInputFile]

    /// Requests that a `SwiftRewriterService` be instantiated for rewriting
    /// requests.
    func makeRewriterService() -> SwiftRewriterService
}

public struct SwiftRewriterFrontendFileCollectionOptions {
    public var followImports: Bool
    public var excludePattern: String?
    public var includePattern: String?
    public var verbose: Bool

    public init(followImports: Bool, excludePattern: String? = nil, includePattern: String? = nil, verbose: Bool) {
        self.followImports = followImports
        self.excludePattern = excludePattern
        self.includePattern = includePattern
        self.verbose = verbose
    }
}
