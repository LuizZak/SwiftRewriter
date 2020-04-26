import Foundation
import ObjcParser

public struct DiskInputFile: Equatable {
    public var url: URL

    /// Whether this file is a primary file for conversion.
    /// If `false`, indicates that this file should be parsed but not be present
    /// in the final transpilation step.
    public var isPrimary: Bool

    public init(url: URL, isPrimary: Bool) {
        self.url = url
        self.isPrimary = isPrimary
    }
}

extension DiskInputFile: InputSource {
    public func sourcePath() -> String {
        url.path
    }
    
    public func loadSource() throws -> CodeSource {
        let source = try String(contentsOf: url)
        
        return StringCodeSource(source: source, fileName: url.path)
    }
}
