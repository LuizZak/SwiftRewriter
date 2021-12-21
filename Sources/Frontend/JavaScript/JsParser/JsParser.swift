import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ParseTreeWalker
import class Antlr4.ParserRuleContext
import class Antlr4.Parser
import class Antlr4.DFA
import JsParserAntlr
import AntlrCommons
import Utils
import JsGrammarModels
import GrammarModelBase

/// Main entry point for parsing JavaScript code.
public class JsParser {
    /// A state used to instance single threaded parsers.
    /// The default parser state, in case the user did not provide one on init.
    private static var _singleThreadState: JsParserState = JsParserState()

    let source: CodeSource

    var parsed: Bool = false
    
    // MARK: ANTLR parser
    var mainParser: AntlrParser<JavaScriptLexer, JavaScriptParser>?
    
    public var rootNode: JsGlobalContextNode = JsGlobalContextNode()
    
    /// Gets or sets the underlying parser state for this parser
    public var state: JsParserState
    
    public var diagnostics: Diagnostics

    public var antlrSettings: AntlrSettings = .default
    
    public convenience init(string: String, fileName: String = "") {
        self.init(source: StringCodeSource(source: string, fileName: fileName))
    }
    
    public convenience init(string: String,
                            fileName: String = "",
                            state: JsParserState) {
        
        self.init(source: StringCodeSource(source: string, fileName: fileName),
                  state: state)
    }
    
    public convenience init(source: CodeSource) {
        self.init(source: source, state: JsParser._singleThreadState)
    }
    
    public init(source: CodeSource, state: JsParserState) {
        self.source = source
        self.state = state
        antlrSettings.forceUseLLPrediction = true
        diagnostics = Diagnostics()
    }
    
    /// Parses the entire source string
    public func parse() throws {
        if parsed {
            return
        }

        // Clear previous state
        let src = source.fetchSource()
        
        let parserState = try state.makeMainParser(input: src)
        let parser = parserState.parser
        parser.removeErrorListeners()
        
        let root = try tryParse(from: parser, { try $0.program() })
        // print(root.toStringTree(parser))

        let listener = JsParserListener()
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)

        rootNode = listener.rootNode

        parsed = true
    }
    
    private func tryParse<T: ParserRuleContext, P: Parser>(from parser: P, _ operation: (P) throws -> T) throws -> T {
        
        let diag = Diagnostics()
        let errorListener = AntlrDiagnosticsErrorListener(source: source, diagnostics: diag)
        errorListener.debugDiagnostics = true
        parser.addErrorListener(
            errorListener
        )
        
        try parser.reset()
        
        var root: T
        
        if antlrSettings.forceUseLLPrediction {
            parser.getInterpreter().setPredictionMode(.LL)
            
            root = try operation(parser)
        } else {
            parser.getInterpreter().setPredictionMode(.SLL)
            
            root = try operation(parser)
            
            if !diag.errors.isEmpty {
                diag.removeAll()
                
                try parser.reset()
                parser.getInterpreter().setPredictionMode(.LL)
                
                root = try operation(parser)
            }
        }
        
        diagnostics.merge(with: diag)
        
        return root
    }
}
