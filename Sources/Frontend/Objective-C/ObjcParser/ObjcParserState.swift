import class Antlr4.ANTLRInputStream
import class Antlr4.CommonTokenStream
import class Antlr4.Lexer
import class Antlr4.Parser
import ObjcParserAntlr

public struct AntlrParser<Lexer: Antlr4.Lexer, Parser: Antlr4.Parser> {
    public var lexer: Lexer
    public var parser: Parser
    public var tokens: CommonTokenStream
}

public typealias ObjectiveCParserAntlr = AntlrParser<ObjectiveCLexer, ObjectiveCParser>
public typealias ObjectiveCPreprocessorAntlr = AntlrParser<ObjectiveCPreprocessorLexer, ObjectiveCPreprocessorParser>

/// Describes a parser state for a single `ObjcParser` instance, with internal
/// fields that are used by the parser.
///
/// - Note: State instances do not support simultaneous usage across many
/// `ObjcParser` instances concurrently.
public final class ObjcParserState {
    var parserState = (lexer: ObjectiveCLexer.State(), parser: ObjectiveCParser.State())
    var preprocessorState = (lexer: ObjectiveCPreprocessorLexer.State(), parser: ObjectiveCPreprocessorParser.State())
    
    public init() {
        
    }
    
    public func makeMainParser(input: String) throws -> ObjectiveCParserAntlr {
        let input = ANTLRInputStream(input)
        let lxr = ObjectiveCLexer(input, parserState.lexer)
        let tokens = CommonTokenStream(lxr)
        let parser = try ObjectiveCParser(tokens, parserState.parser)
        
        return ObjectiveCParserAntlr(lexer: lxr, parser: parser, tokens: tokens)
    }
    
    public func makePreprocessorParser(input: String) throws -> ObjectiveCPreprocessorAntlr {
        let input = ANTLRInputStream(input)
        let lxr = ObjectiveCPreprocessorLexer(input, preprocessorState.lexer)
        let tokens = CommonTokenStream(lxr)
        let parser = try ObjectiveCPreprocessorParser(tokens, preprocessorState.parser)
        
        return ObjectiveCPreprocessorAntlr(lexer: lxr, parser: parser, tokens: tokens)
    }
}
