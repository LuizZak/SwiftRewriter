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
    private var buffer: String = ""

    public var path: String
    
    public init(path: String) {
        self.path = path
    }

    public func getBuffer(withFooter: Bool) -> String {
        if !withFooter {
            return buffer
        }

        return "\(buffer)\n// End of file \(path)"
    }
    
    public func close() {
        
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
    @ConcurrentValue
    public var outputs: [TestFileOutput] = []

    public init() {
        
    }
    
    public func createFile(path: String) -> FileOutput {
        let output = TestFileOutput(path: path)
        outputs.append(output)
        return output
    }
}
