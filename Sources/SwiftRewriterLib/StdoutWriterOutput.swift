import Foundation
import WriterTargetOutput
import Console

/// Writer implementation that prints output to `stdout`.
public class StdoutWriterOutput: WriterOutput {
    var buffer: String = ""
    var colorize: Bool
    
    /// If `true`, emits a comment at the end of each file.
    public var signalEndOfFiles: Bool = true
    
    public init(colorize: Bool = true) {
        self.colorize = colorize
    }
    
    public func createFile(path: String) -> FileOutput {
        StdFileOutput(path: path, colorize: colorize, signalEndOfFiles: signalEndOfFiles)
    }
    
    private class StdFileOutput: FileOutput {
        var buffer: String = ""
        var colorize: Bool
        var path: String
        var signalEndOfFiles: Bool
        
        init(path: String, colorize: Bool = true, signalEndOfFiles: Bool) {
            self.colorize = colorize
            self.path = path
            self.signalEndOfFiles = signalEndOfFiles
        }
        
        func close() {
            print(buffer, terminator: signalEndOfFiles ? "\n" : "")
            
            if signalEndOfFiles {
                print("// End of file \((path as NSString).lastPathComponent)")
            }
        }
        
        func outputTarget() -> RewriterOutputTarget {
            let target = TerminalStringRewriterOutput()
            target.colorize = colorize
            
            target.onChangeBuffer = { contents in
                self.buffer = contents
            }
            
            return target
        }
    }
}

public final class TerminalStringRewriterOutput: RewriterOutputTarget {
    private var identDepth: Int = 0
    private var settings: RewriterOutputSettings
    private var ignoreCallChange = false
    private(set) public var buffer: String = ""
    
    var colorize: Bool = true
    
    /// Called every time the buffer changes due to an output request
    public var onChangeBuffer: ((String) -> Void)?
    
    required public init(settings: RewriterOutputSettings = .defaults) {
        self.settings = settings
    }
    
    public func outputRaw(_ text: String) {
        buffer += text
        
        callChangeCallback()
    }
    
    public func output(line: String, style: TextStyle) {
        ignoreCallChange = true
        
        outputIndentation()
        buffer += colorize(line, forStyle: style)
        outputLineFeed()
        
        ignoreCallChange = false
        
        callChangeCallback()
    }
    
    public func outputIndentation() {
        buffer += identString()
        callChangeCallback()
    }
    
    public func outputLineFeed() {
        buffer += "\n"
        callChangeCallback()
    }
    
    public func outputInline(_ content: String, style: TextStyle) {
        buffer += colorize(content, forStyle: style)
        callChangeCallback()
    }
    
    public func increaseIndentation() {
        identDepth += 1
    }
    
    public func decreaseIndentation() {
        identDepth -= 1
    }
    
    public func onAfterOutput() {
        buffer = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        callChangeCallback()
    }
    
    private func callChangeCallback() {
        if ignoreCallChange {
            return
        }
        
        onChangeBuffer?(buffer)
    }
    
    private func identString() -> String {
        switch settings.tabStyle {
        case .spaces(let sp):
            return String(repeating: " ", count: sp * identDepth)
        case .tabs:
            return String(repeating: "\t", count: identDepth)
        }
    }
    
    private func colorize(_ string: String, forStyle style: TextStyle) -> String {
        if !colorize || style == .plain {
            return string
        }
        
        return string.terminalColorize(colorFor(style: style))
    }
    
    private func colorFor(style: TextStyle) -> ConsoleColor {
        switch style {
        case .plain:
            return .white
        case .comment:
            return .green
        case .keyword, .attribute:
            return .magenta
        case .numberLiteral:
            return .blue
        case .stringLiteral:
            return .red
        case .directive:
            return .red
        case .typeName:
            return .blue
        case .memberName:
            return .green
        }
    }
}
