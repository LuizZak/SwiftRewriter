import GrammarModels
import ObjcParser

/// Protocol to implement in order to feed input files to a `SwiftRewriter` instance.
public protocol InputSourcesProvider {
    func sources() -> [InputSource]
}

/// Represents an input source for Obj-c file
public protocol InputSource {
    /// Requests a unique name for this source name.
    func sourceName() -> String
    
    /// Asks the receiver to return its target's contents.
    func loadSource() throws -> CodeSource
}
