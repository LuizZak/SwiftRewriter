import Foundation
import SwiftRewriterLib
import WriterTargetOutput

class FileDiskWriterOutput: WriterOutput {
    func createFile(path: String) throws -> FileOutput {
        return try FileOutputImpl(path: path)
    }
}

class FileOutputImpl: FileOutput {
    let path: String
    let file: FileOutputTarget
    
    init(path: String) throws {
        let url = URL(fileURLWithPath: path)
        
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil)
        }
        
        // Open output stream
        let handle = try FileHandle(forWritingTo: url)
        
        handle.truncateFile(atOffset: 0)
        
        self.path = path
        file = FileOutputTarget(fileHandle: handle)
    }
    
    func close() {
        file.close()
    }
    
    func outputTarget() -> RewriterOutputTarget {
        return file
    }
}

class FileOutputTarget: RewriterOutputTarget {
    private var identDepth: Int = 0
    private var settings: RewriterOutputSettings
    var fileHandle: FileHandle
    var buffer: String = ""
    
    var colorize: Bool = true
    
    public init(fileHandle: FileHandle, settings: RewriterOutputSettings = .defaults) {
        self.fileHandle = fileHandle
        self.settings = settings
    }
    
    func close() {
        if let data = buffer.data(using: .utf8) {
            fileHandle.write(data)
        }
        
        fileHandle.closeFile()
    }
    
    func writeBufferFile(_ buffer: String) {
        self.buffer += buffer
    }
    
    public func output(line: String, style: TextStyle) {
        outputIdentation()
        writeBufferFile(line)
        outputLineFeed()
    }
    
    public func outputIdentation() {
        writeBufferFile(identString())
    }
    
    public func outputLineFeed() {
        writeBufferFile("\n")
    }
    
    public func outputInline(_ content: String, style: TextStyle) {
        writeBufferFile(content)
    }
    
    public func increaseIdentation() {
        identDepth += 1
    }
    
    public func decreaseIdentation() {
        identDepth -= 1
    }
    
    public func onAfterOutput() {
        
    }
    
    private func identString() -> String {
        switch settings.tabStyle {
        case .spaces(let sp):
            return String(repeating: " ", count: sp * identDepth)
        case .tabs:
            return String(repeating: "\t", count: identDepth)
        }
    }
}
