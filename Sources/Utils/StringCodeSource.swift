public struct StringCodeSource: CodeSource {
    private var _lineOffsets: [Range<String.Index>] = []
    private var _indices: [String.Index]
    
    public var filePath: String = ""
    public var source: String
    
    public var sourceRange: Range<String.UnicodeScalarView.Index> {
        source.unicodeScalars.startIndex..<source.unicodeScalars.endIndex
    }

    public init(source: String, fileName: String = "") {
        self.source = source
        self.filePath = fileName
        
        _indices = Array(source.unicodeScalars.indices)
        _lineOffsets = source.lineRanges(includeLineBreak: true)
    }
    
    public func fetchSource() -> String {
        source
    }
    
    public func stringIndex(forCharOffset offset: Int) -> String.UnicodeScalarView.Index {
        if offset == _indices.count {
            return source.endIndex
        }

        return _indices[offset]
    }
    
    public func charOffset(forStringIndex index: String.UnicodeScalarView.Index) -> Int {
        if index == source.endIndex {
            return _indices.count
        }

        return _indices.firstIndex(of: index) ?? 0
    }
    
    public func utf8Index(forCharOffset offset: Int) -> Int {
        guard let offsetIndex = source.unicodeScalars.index(source.startIndex, offsetBy: offset, limitedBy: source.endIndex) else {
            return source.count - 1
        }

        let distance = source.utf8.distance(from: source.startIndex, to: offsetIndex)
        return distance
    }
    
    public func isEqual(to other: Source) -> Bool {
        filePath == other.filePath
    }
    
    public func lineNumber(at index: String.UnicodeScalarView.Index) -> Int {
        if index == source.endIndex {
            return _lineOffsets.count
        }

        guard let intIndex = _lineOffsets.enumerated().first(where: { $0.element.contains(index) })?.offset else {
            return 0
        }
        
        return intIndex + 1
    }
    
    public func columnNumber(at index: String.UnicodeScalarView.Index) -> Int {
        if index == source.endIndex, let last = _lineOffsets.last {
            return source.distance(from: last.lowerBound, to: index) + 1
        }

        guard let offset = _lineOffsets.first(where: { $0.contains(index) }) else {
            return 0
        }

        return source.distance(from: offset.lowerBound, to: index) + 1
    }

    public func substring(inCharRange range: Range<Int>) -> Substring? {
        guard range.lowerBound >= 0 && range.lowerBound < _indices.count else {
            return nil
        }
        guard range.upperBound >= 0 && range.upperBound <= _indices.count else {
            return nil
        }

        let start = stringIndex(forCharOffset: range.lowerBound)
        let end = stringIndex(forCharOffset: range.upperBound)

        return source[start..<end]
    }
    
    public func sourceSubstring(_ range: SourceRange) -> Substring? {
        range.substring(in: source)
    }
}
