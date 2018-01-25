import GrammarModels

public struct StringCodeSource: CodeSource {
    public var source: String
    
    public init(source: String) {
        self.source = source
    }
    
    public func fetchSource() -> String {
        return source
    }
    
    public func isEqual(to other: Source) -> Bool {
        guard let strSource = other as? StringCodeSource else {
            return false
        }
        
        return source == strSource.source
    }
    
    public func lineNumber(at index: String.Index) -> Int {
        let line =
            source[..<index].reduce(0) {
                $0 + ($1 == "\n" ? 1 : 0)
        }
        
        return line + 1 // lines start at one
    }
    
    public func columnNumber(at index: String.Index) -> Int {
        // Figure out start of line at the given index
        let lineStart =
            zip(source[..<index], source.indices)
                .reversed()
                .first { $0.0 == "\n" }?.1
        
        let lineStartOffset =
            lineStart.map(source.index(after:)) ?? source.startIndex
        
        return source.distance(from: lineStartOffset, to: index) + 1 // columns start at one
    }
}
