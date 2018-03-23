//
//  ObjcLexer.swift
//  ObjcParser
//
//  Created by Luiz Silva on 22/01/2018.
//

import MiniLexer
import GrammarModels

extension TokenType: TokenProtocol {
    public static var eofToken: TokenType {
        return .eof
    }
    
    public func length(in lexer: Lexer) -> Int {
        switch self {
        case .unknown, .eof:
            return 0
        case .at, .colon, .openBrace, .closeBrace, .openParens, .closeParens,
             .openSquareBracket, .closeSquareBracket, .comma, .period, .semicolon:
            return 1
        case .id:
            return 2
        case .ellipsis:
            return 3
        case .operator(let op):
            return op.rawValue.count
        case .floatLiteral(let str), .stringLiteral(let str), .hexLiteral(let str),
             .octalLiteral(let str), .decimalLiteral(let str), .identifier(let str),
             .typeQualifier(let str):
            return str.count
        case .keyword(let kw):
            return kw.rawValue.count
        }
    }
    
    public func advance(in lexer: Lexer) throws {
        let l = length(in: lexer)
        
        if l <= 0 {
            return
        }
        
        try lexer.advanceLength(l)
    }
    
    public var tokenString: String {
        return self.description
    }
}

public extension TokenType {
    public var isTypeQualifier: Bool {
        switch self {
        case .typeQualifier:
            return true
        default:
            return false
        }
    }
    
    public var isIdentifier: Bool {
        switch self {
        case .identifier:
            return true
        default:
            return false
        }
    }
}

public class ObjcLexer: TokenizerLexer<TokenType> {
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
