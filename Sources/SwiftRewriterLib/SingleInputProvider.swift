import ObjcParser

/// A class that stands both as an input provider and as a input to a single
/// input of a static code string.
public class SingleInputProvider: InputSourcesProvider, InputSource {
    public var code: String
    public var isPrimary: Bool
    public var fileName: String
    
    public init(code: String, isPrimary: Bool, fileName: String) {
        self.code = code
        self.isPrimary = isPrimary
        self.fileName = fileName
    }
    
    public func sources() -> [InputSource] {
        return [self]
    }
    
    public func sourcePath() -> String {
        return fileName
    }
    
    public func loadSource() throws -> CodeSource {
        return StringCodeSource(source: code, fileName: sourcePath())
    }
}
