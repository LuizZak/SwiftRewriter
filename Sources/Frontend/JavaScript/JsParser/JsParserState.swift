import class Antlr4.ANTLRInputStream
import class Antlr4.CommonTokenStream
import class Antlr4.Lexer
import class Antlr4.Parser
import AntlrCommons
import JsParserAntlr

public typealias JavaScriptParserAntlr = AntlrParser<JavaScriptLexer, JavaScriptParser>
public typealias JavaScriptPreprocessorAntlr = AntlrParser<JavaScriptPreprocessorLexer, JavaScriptPreprocessorParser>

/// Describes a parser state for a single `JsParser` instance, with internal
/// fields that are used by the parser.
///
/// - Note: State instances do not support simultaneous usage across many
/// `JsParser` instances concurrently.
public final class JsParserState {
    var parserState = (lexer: JavaScriptLexer.State(), parser: JavaScriptParser.State())
    
    public init() {
        
    }
    
    public func makeMainParser(input: String) throws -> JavaScriptParserAntlr {
        let input = ANTLRInputStream(input)
        let lxr = JavaScriptLexer(input, parserState.lexer)
        let tokens = CommonTokenStream(lxr)
        let parser = try JavaScriptParser(tokens, parserState.parser)
        
        return JavaScriptParserAntlr(lexer: lxr, parser: parser, tokens: tokens)
    }
}
