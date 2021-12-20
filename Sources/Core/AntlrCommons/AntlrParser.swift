import class Antlr4.ANTLRInputStream
import class Antlr4.CommonTokenStream
import class Antlr4.Lexer
import class Antlr4.Parser

/// A tuple of lexer/parser pair.
public struct AntlrParser<Lexer: Antlr4.Lexer, Parser: Antlr4.Parser> {
    public var lexer: Lexer
    public var parser: Parser
    public var tokens: CommonTokenStream

    public init(lexer: Lexer, parser: Parser, tokens: CommonTokenStream) {
        self.lexer = lexer
        self.parser = parser
        self.tokens = tokens
    }
}
