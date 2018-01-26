import SwiftRewriterLib

public class StdoutWriterOutput: WriterOutput, FileOutput {
    var buffer: String = ""
    
    public func createFile(path: String) -> FileOutput {
        return self
    }
    
    public func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()
        
        target.onChangeBuffer = { contents in
            self.buffer = contents
        }
        
        return target
    }
    
    public func close() {
        print(buffer)
    }
}
