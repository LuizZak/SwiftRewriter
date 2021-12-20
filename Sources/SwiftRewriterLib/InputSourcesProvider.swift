import ObjcGrammarModels
import ObjcParser

/// Protocol to implement in order to feed input files to a `ObjectiveC2SwiftRewriter` instance.
public protocol InputSourcesProvider {
    func sources() -> [InputSource]
}

/// An array-backed input sources provider
public struct ArrayInputSourcesProvider: InputSourcesProvider {
    public var inputs: [InputSource]

    public init(inputs: [InputSource] = []) {
        self.inputs = inputs
    }

    public func sources() -> [InputSource] {
        inputs
    }
}

/// Represents an input source code.
public protocol InputSource {
    /// Whether this is a primary input source.
    /// Secondary sources are used to read related Objective-C code but do not
    /// contribute with an output file directly, and is used in cases like
    /// following `#import` declarations.
    var isPrimary: Bool { get }
    
    /// Requests the path name for this input source.
    func sourcePath() -> String
    
    /// Asks the receiver to return its target's contents.
    func loadSource() throws -> CodeSource
}
