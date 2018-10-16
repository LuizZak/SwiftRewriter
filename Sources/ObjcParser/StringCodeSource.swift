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
        _computeLineOffsets()
    }
    
    public func fetchSource() -> String {
        return source
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.Index {
        return _indices[offset]
    }
    
    public func isEqual(to other: Source) -> Bool {
        guard let strSource = other as? StringCodeSource else {
            return false
        }
        
        return source == strSource.source
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
    
    private mutating func _computeLineOffsets() {
        _lineOffsets = source.lineRanges()
    }
}
