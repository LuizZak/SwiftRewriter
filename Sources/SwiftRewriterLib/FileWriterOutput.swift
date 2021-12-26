import Foundation
import SwiftSyntax
import WriterTargetOutput

/// Writer implementation that saves output to disk.
public class FileDiskWriterOutput: WriterOutput {
    public init() {
        
    }

    public func createFile(path: String) throws -> FileOutput {
        try FileOutputImpl(path: path)
    }
}

public class FileOutputImpl: FileOutput {
    let path: String
    let file: FileOutputTarget
    
    public init(path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        if !FileManager.default.fileExists(atPath: path) {
            if !FileManager.default.createFile(atPath: path, contents: nil) {
                throw Error.cannotCreateFile(path: path)
            }
        }
        
        // Open output stream
        let handle = try FileHandle(forWritingTo: url)
        
        handle.truncateFile(atOffset: 0)
        
        self.path = path
        file = FileOutputTarget(fileHandle: handle)
    }
    
    public func close() {
        file.close()
    }
    
    public func outputTarget() -> RewriterOutputTarget {
        file
    }
    
    public enum Error: Swift.Error {
        case cannotCreateFile(path: String)
    }
}

public class FileOutputTarget: RewriterOutputTarget {
    private var indentDepth: Int = 0
    private var settings: RewriterOutputSettings
    var fileHandle: FileHandle
    var buffer: String = ""
    
    var colorize: Bool = true
    
    public init(fileHandle: FileHandle, settings: RewriterOutputSettings = .defaults) {
        self.fileHandle = fileHandle
        self.settings = settings
    }
    
    public func close() {
        if let data = buffer.data(using: .utf8) {
            fileHandle.write(data)
        }
        
        fileHandle.closeFile()
    }
    
    public func writeBufferFile(_ buffer: String) {
        self.buffer += buffer
    }

    public func outputFile(_ file: SourceFileSyntax) {
        writeBufferFile(file.description)
    }
    
    public func outputRaw(_ text: String) {
        writeBufferFile(text)
    }
    
    public func output(line: String, style: TextStyle) {
        outputIndentation()
        writeBufferFile(line)
        outputLineFeed()
    }
    
    public func outputIndentation() {
        writeBufferFile(indentString())
    }
    
    public func outputLineFeed() {
        writeBufferFile("\n")
    }
    
    public func outputInline(_ content: String, style: TextStyle) {
        writeBufferFile(content)
    }
    
    public func increaseIndentation() {
        indentDepth += 1
    }
    
    public func decreaseIndentation() {
        indentDepth -= 1
    }
    
    public func onAfterOutput() {
        
    }
    
    private func indentString() -> String {
        switch settings.tabStyle {
        case .spaces(let sp):
            return String(repeating: " ", count: sp * indentDepth)
        case .tabs:
            return String(repeating: "\t", count: indentDepth)
        }
    }
}
