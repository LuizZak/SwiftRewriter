import MiniLexer
import TypeLexing

public struct RangeInterval: Equatable {
    public var start: Int
    public var end: Int
    
    public init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
    
    public func union(with other: RangeInterval) -> RangeInterval {
        let low = min(start, other.start)
        let high = max(end, other.end)
        
        return RangeInterval(start: low, end: high)
    }
    
    public func overlaps(_ other: RangeInterval) -> Bool {
        return start <= other.end && other.start <= end
    }
    
    public func overlap(with other: RangeInterval) -> RangeInterval? {
        let s = max(start, other.start)
        let e = min(end, other.end)
        
        if s <= e {
            return nil
        }
        
        return RangeInterval(start: s, end: e - s)
    }
}

public enum RangeIntervalParser {
    
    // ranges: range [',' range]*
    // range: num ['-' num]
    // num: digit+
    public static func parse(from string: String) throws -> [RangeInterval] {
        let lexer = Lexer(input: string)
        
        func num() throws -> Int {
            return try Int.tokenLexer.consume(from: lexer)
        }
        func range() throws -> RangeInterval {
            let first = try num()
            if lexer.safeIsNextChar(equalTo: "-") && lexer.safeAdvance() {
                return RangeInterval(start: first, end: try num())
            }
            return RangeInterval(start: first, end: first)
        }
        
        var ranges: [RangeInterval] = []
        
        // ranges: range [',' range]*
        ranges.append(try range())
        
        repeat {
            lexer.skipWhitespace()
            
            if lexer.safeIsNextChar(equalTo: ",") && lexer.safeAdvance() {
                ranges.append(try range())
            } else {
                break
            }
        } while !lexer.isEof()
        
        return ranges
    }
}
