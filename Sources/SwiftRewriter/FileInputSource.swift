import Foundation
import SwiftRewriterLib
import GrammarModels
import ObjcParser

public class FileInputProvider: InputSourcesProvider {
    var files: [String]
    
    public init(files: [String]) {
        self.files = files
    }
    
    public init(files: [URL]) {
        self.files = files.map { $0.absoluteURL.relativePath }
    }
    
    public func sources() -> [InputSource] {
        return files.map {
            FileInputSource(file: $0)
        }
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
    private var _source: StringCodeSource
    
    public var filePath: String
    public var fileContents: String {
        return _source.source
    }
    
    public init(filePath: String, fileContents: String) {
        self.filePath = filePath
        
        _source = StringCodeSource(source: fileContents)
    }
    
    public func fetchSource() -> String {
        return _source.source
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.Index {
        return _source.stringIndex(forCharOffset: offset)
    }
    
    public func isEqual(to other: Source) -> Bool {
        guard let other = other as? FileCodeSource else {
            return false
        }
        
        return other.filePath == filePath
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        return _source.lineNumber(at: index)
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        return _source.columnNumber(at: index)
    }
}
