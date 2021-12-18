import GrammarModels
import Utils

public struct StringCodeSource: CodeSource {
    private var _lineOffsets: [Range<String.Index>] = []
    private var _indices: [String.Index]
    
    public var filePath: String = ""
    public var source: String
    
    public init(source: String, fileName: String = "") {
        self.source = source
        self.filePath = fileName
        
        _indices = Array(source.indices)
        _lineOffsets = source.lineRanges()
    }
    
    public func fetchSource() -> String {
        source
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.Index {
        _indices[offset]
    }
    
    public func charOffset(forStringIndex index: String.Index) -> Int {
        _indices.firstIndex(of: index) ?? 0
    }
    
    public func utf8Index(forCharOffset offset: Int) -> Int {
        offset
    }
    
    public func isEqual(to other: Source) -> Bool {
        filePath == other.filePath
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        guard let intIndex = _lineOffsets.enumerated().first(where: { $0.element.contains(index) })?.offset else {
            return 0
        }
        
        return intIndex + 1
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        guard let offsets = _lineOffsets.first(where: { $0.contains(index) }) else {
            return 0
        }
        
        return source.distance(from: offsets.lowerBound, to: index) + 1
    }
}
