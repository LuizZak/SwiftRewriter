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
        files.map {
            FileInputSource(file: $0, isPrimary: true)
        }
    }
}

public class FileInputSource: InputSource {
    var file: String
    public var isPrimary: Bool
    
    public init(file: String, isPrimary: Bool) {
        self.file = file
        self.isPrimary = isPrimary
    }
    
    public func sourceName() -> String {
        file
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
        _source.source
    }
    
    public init(filePath: String, fileContents: String) {
        self.filePath = filePath
        
        _source = StringCodeSource(source: fileContents)
    }
    
    public func fetchSource() -> String {
        _source.source
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.Index {
        _source.stringIndex(forCharOffset: offset)
    }
    
    public func charOffset(forStringIndex index: String.Index) -> Int {
        _source.charOffset(forStringIndex: index)
    }
    
    public func utf8Index(forCharOffset offset: Int) -> Int {
        _source.utf8Index(forCharOffset: offset)
    }
    
    public func isEqual(to other: Source) -> Bool {
        guard let other = other as? FileCodeSource else {
            return false
        }
        
        return other.filePath == filePath
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        _source.lineNumber(at: index)
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        _source.columnNumber(at: index)
    }
}
