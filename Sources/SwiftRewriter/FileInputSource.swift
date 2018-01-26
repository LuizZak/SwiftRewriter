import Foundation
import SwiftRewriterLib
import GrammarModels
import ObjcParser

public class FileInputProvider: InputSourcesProvider {
    var file: String
    
    public init(file: String) {
        self.file = file
    }
    
    public func sources() -> [InputSource] {
        return [FileInputSource(file: file)]
    }
}

public class FileInputSource: InputSource {
    var file: String
    
    public init(file: String) {
        self.file = file
    }
    
    public func sourceName() -> String {
        return file
    }
    
    public func loadSource() throws -> CodeSource {
        let contents = try String(contentsOfFile: file)
        
        return FileCodeSource(filePath: file, fileContents: contents)
    }
}

public class FileCodeSource: CodeSource {
    private var filePath: String
    public var fileContents: String
    
    public init(filePath: String, fileContents: String) {
        self.filePath = filePath
        self.fileContents = fileContents
    }
    
    public func fetchSource() -> String {
        return fileContents
    }
    
    public func isEqual(to other: Source) -> Bool {
        guard let other = other as? FileCodeSource else {
            return false
        }
        
        return other.filePath == filePath
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        let line =
            fileContents[..<index].reduce(0) {
                $0 + ($1 == "\n" ? 1 : 0)
            }
        
        return line + 1 // lines start at one
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        // Figure out start of line at the given index
        let lineStart =
            zip(fileContents[..<index], fileContents.indices)
                .reversed()
                .first { $0.0 == "\n" }?.1
        
        let lineStartOffset =
            lineStart.map(fileContents.index(after:)) ?? fileContents.startIndex
        
        return fileContents.distance(from: lineStartOffset, to: index) + 1 // columns start at one
    }
}
