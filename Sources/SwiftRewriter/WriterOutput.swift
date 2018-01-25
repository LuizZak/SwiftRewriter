/// Manages output
public protocol WriterOutput {
    /// Opens a file for outputting contents to
    func createFile(path: String) -> FileOutput
}

/// An output target that points to a file
public protocol FileOutput {
    /// Closes file and disallows further writing.
    func close()
    
    /// Requests an output target that can be used to write resulting source code
    /// to.
    func outputTarget() -> RewriterOutputTarget
}
