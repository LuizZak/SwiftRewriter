import WriterTargetOutput

/// A writer output target that sinks in all input and ignores data.
public class NullWriterOutput: WriterOutput {
    public init() {
        
    }
    
    /// Opens a file for outputting contents to
    public func createFile(path: String) throws -> FileOutput {
        return NullFileOutput()
    }
}

/// A file output that produces a null rewriter output target and saves no data.
public class NullFileOutput: FileOutput {
    public init() {
        
    }
    
    public func outputTarget() -> RewriterOutputTarget {
        return NullRewriterOutputTarget()
    }
    
    public func close() {
        
    }
}
