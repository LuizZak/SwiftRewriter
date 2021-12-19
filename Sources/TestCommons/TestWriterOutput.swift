import WriterTargetOutput
import SwiftRewriterLib
import Utils

public class TestMultiInputProvider: InputSourcesProvider {
    public var inputs: [InputSource]
    
    public init(inputs: [InputSource]) {
        self.inputs = inputs
    }
    
    public func sources() -> [InputSource] {
        return inputs
    }
}

public class TestFileOutput: FileOutput {
    public var path: String
    public var buffer: String = ""
    
    public init(path: String) {
        self.path = path
    }
    
    public func close() {
        buffer += "\n// End of file \(path)"
    }
    
    public func outputTarget() -> RewriterOutputTarget {
        let target = StringRewriterOutput()
        
        target.onChangeBuffer = { value in
            self.buffer = value
        }
        
        return target
    }
}

public class TestWriterOutput: WriterOutput {
    let mutex = Mutex()
    public var outputs: [TestFileOutput] = []

    public init() {
        
    }
    
    public func createFile(path: String) -> FileOutput {
        let output = TestFileOutput(path: path)
        mutex.locking {
            outputs.append(output)
        }
        return output
    }
}
