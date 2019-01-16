import WriterTargetOutput

/// Manages output of a Swift Rewriter invocation by providing file targets to
/// output Swift code to.
public protocol WriterOutput {
    /// Opens a file for outputting contents to
    func createFile(path: String) throws -> FileOutput
}

/// An output target that points to a file
public protocol FileOutput {
    /// Closes file and disallows further writing.
    func close()
    
    /// Requests an output target that can be used to write resulting source code
    /// to.
    func outputTarget() -> RewriterOutputTarget
}
