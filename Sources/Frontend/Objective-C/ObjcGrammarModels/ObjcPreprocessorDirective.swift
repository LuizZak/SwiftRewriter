import Utils
import GrammarModelBase

/// An Objective-C preprocessor from an input file
public struct ObjcPreprocessorDirective: Codable {
    public var string: String
    public var range: Range<Int>
    public var location: SourceLocation
    public var length: SourceLength
    
    public init(string: String,
                range: Range<Int>,
                location: SourceLocation,
                length: SourceLength) {
        
        self.string = string
        self.range = range
        self.location = location
        self.length = length
    }
}
