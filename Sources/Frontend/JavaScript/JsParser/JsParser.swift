import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ParseTreeWalker
import class Antlr4.ParserRuleContext
import class Antlr4.Parser
import AntlrCommons
import Utils

/// Main entry point for parsing JavaScript code.
public class JsParser {
    /// A state used to instance single threaded parsers.
    /// The default parser state, in case the user did not provide one on init.
    private static var _singleThreadState: JsParserState = JsParserState()

    var parsed: Bool = false
    
    // MARK: ANTLR parser
    var mainParser: AntlrParser<JavaScriptLexer, JavaScriptParser>?
    
    /// Gets or sets the underlying parser state for this parser
    public var state: JsParserState
    
    public var diagnostics: Diagnostics

    public var antlrSettings: AntlrSettings = .default
}
