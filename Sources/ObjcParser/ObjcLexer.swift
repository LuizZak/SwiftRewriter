import MiniLexer
import GrammarModels

public class ObjcLexer: TokenizerLexer<FullToken<TokenType>> {
    var source: CodeSource
    
    public init(source: CodeSource) {
        self.source = source
        super.init(lexer: Lexer(input: source.fetchSource()))
    }
    
    func startRange() -> RangeMarker {
        return _RangeMarker(objcLexer: self)
    }
    
    /// Current lexer's location as a `SourceLocation`.
    func location() -> SourceLocation {
        return SourceLocation(source: source, range: locationAsRange())
    }
    
    /// Current lexer's location as a `SourceRange.location` enum case
    func locationAsRange() -> SourceRange {
        if let range = token().range {
            return .range(range)
        }
        
        return .invalid
    }
    
    private struct _RangeMarker: RangeMarker {
        let objcLexer: ObjcLexer
        let index: Lexer.Index
        
        init(objcLexer: ObjcLexer) {
            self.objcLexer = objcLexer
            self.index = _RangeMarker.lexerIndex(in: objcLexer)
        }
        
        func makeSubstring() -> Substring {
            return objcLexer.lexer.inputString[rawRange()]
        }
        
        func makeRange() -> SourceRange {
            if index == _RangeMarker.lexerIndex(in: objcLexer) {
                return .location(index)
            }
            
            return .range(rawRange())
        }
        
        func makeLocation() -> SourceLocation {
            return SourceLocation(source: objcLexer.source, range: makeRange())
        }
        
        private func rawRange() -> Range<Lexer.Index> {
            return index..<_RangeMarker.lexerIndex(in: objcLexer)
        }
        
        private static func lexerIndex(in lexer: ObjcLexer) -> Lexer.Index {
            return lexer.lexer.inputIndex
        }
    }
}

public protocol RangeMarker {
    func makeSubstring() -> Substring
    func makeString() -> String
    
    func makeLocation() -> SourceLocation
}

public extension RangeMarker {
    public func makeString() -> String {
        return String(makeSubstring())
    }
}

public protocol Backtrack: class {
    func backtrack()
}

extension TokenizerLexer.Backtrack: Backtrack {
    
}
