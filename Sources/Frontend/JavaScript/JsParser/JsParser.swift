import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ParseTreeWalker
import class Antlr4.ParserRuleContext
import class Antlr4.Parser
import class Antlr4.DFA
import protocol Antlr4.TerminalNode
import struct Foundation.CharacterSet

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

    var parsed: Bool = false
    
    // MARK: ANTLR parser
    var mainParser: AntlrParser<JavaScriptLexer, JavaScriptParser>?

    /// Gets the source that is being parsed.
    public let source: CodeSource
    
    /// Gets the parsed global context node.
    public var rootNode: JsGlobalContextNode = JsGlobalContextNode()
    
    /// Gets or sets the underlying parser state for this parser
    public var state: JsParserState
    
    public var diagnostics: Diagnostics

    /// Contains information about all C-style comments found while parsing the
    /// input file.
    public var comments: [RawCodeComment] = []

    /// Import declarations found in file.
    public var importDirectives: [JsImportDecl] = []

    public var antlrSettings: AntlrSettings = .default
    
    public convenience init(string: String, fileName: String = "") {
        self.init(source: StringCodeSource(source: string, fileName: fileName))
    }
    
    public convenience init(
        string: String,
        fileName: String = "",
        state: JsParserState
    ) {
        
        self.init(
            source: StringCodeSource(source: string, fileName: fileName),
            state: state
        )
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
        
        parseComments(input: src)
        
        let parserState = try state.makeMainParser(input: src)
        mainParser = parserState
        let parser = parserState.parser
        parser.removeErrorListeners()
        
        let root = try tryParse(from: parser, { try $0.program() })
        
        let commentQuerier = CommentQuerier(allComments: comments)
        
        let listener = JsParserListener(
            sourceString: src,
            source: source,
            commentQuerier: commentQuerier
        )
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)

        try collectImports(root)

        rootNode = listener.rootNode

        parsed = true
    }

    private func collectImports(_ root: JavaScriptParser.ProgramContext) throws {
        let listener = JsImportDeclListener()
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)

        self.importDirectives = listener.importDecls
    }
    
    private func tryParse<T: ParserRuleContext, P: Parser>(from parser: P, _ operation: (P) throws -> T) throws -> T {
        
        let diag = Diagnostics()
        let errorListener = AntlrDiagnosticsErrorListener(source: source, diagnostics: diag)
        
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
    
    private func parseComments(input: String) {
        comments = JsParser.parseComments(input: input)
    }
    
    // MARK: - Global context-free parsing functions

    public static func parseStringContents(_ ctx: Antlr4.TerminalNode) -> String {
        let text = ctx.getText()

        return text.trimmingCharacters(in: CharacterSet(charactersIn: "\"'`"))
    }

    public static func parseComments(input: String) -> [RawCodeComment] {
        var result: [RawCodeComment] = []

        let ranges = input.cStyleCommentSectionRanges()
        
        for range in ranges {
            let start = input.asSourceLocation(range.lowerBound)
            let end = input.asSourceLocation(range.upperBound)

            let commentString = String(input[range])
            let comment = RawCodeComment(
                string: commentString,
                range: (start.utf8Offset)..<(end.utf8Offset),
                location: start,
                length: start.length(to: end)
            )
            
            result.append(comment)
        }

        return result
    }

    public static func varModifier(from ctx: JavaScriptParser.VarModifierContext) -> JsVariableDeclarationListNode.VarModifier {
        JsASTNodeFactory.makeVarModifier(from: ctx)
    }

    public static func anonymousFunction(from ctx: JavaScriptParser.AnonymousFunctionContext) -> JsAnonymousFunction? {
        var identifier: JavaScriptParser.IdentifierContext?
        var signature: JsFunctionSignature?
        var body: JsAnonymousFunction.Body?

        switch ctx {
        case let ctx as JavaScriptParser.FunctionDeclContext:
            let functionDeclaration = ctx.functionDeclaration()

            identifier = functionDeclaration?.identifier()
            signature = functionSignature(from: functionDeclaration?.formalParameterList())
            body = (functionDeclaration?.functionBody()).map(JsAnonymousFunction.Body.functionBody)
        
        case let ctx as JavaScriptParser.AnonymousFunctionDeclContext:
            signature = functionSignature(from: ctx.formalParameterList())
            body = ctx.functionBody().map(JsAnonymousFunction.Body.functionBody)

        case let ctx as JavaScriptParser.ArrowFunctionContext:
            signature = functionSignature(from: ctx.arrowFunctionParameters())
            if let singleExpression = ctx.arrowFunctionBody()?.singleExpression() {
                body = .singleExpression(singleExpression)
            } else if let functionBody = ctx.arrowFunctionBody()?.functionBody() {
                body = .functionBody(functionBody)
            }

        default:
            break
        }

        guard let signature = signature, let body = body else {
            return nil
        }

        return JsAnonymousFunction(identifier: identifier?.getText(), signature: signature, body: body)
    }

    /// Reads a function signature from a formal parameter list context.
    public static func functionSignature(from ctx: JavaScriptParser.FormalParameterListContext?) -> JsFunctionSignature {
        func _identifier(from singleExpression: JavaScriptParser.SingleExpressionContext?) -> JavaScriptParser.IdentifierContext? {
            if let result = singleExpression as? JavaScriptParser.IdentifierExpressionContext {
                return result.identifier()
            }

            return nil
        }
        func _argument(from ctx: JavaScriptParser.FormalParameterArgContext) -> JsFunctionArgument? {
            guard let identifier = ctx.assignable()?.identifier()?.getText() else {
                return nil
            }

            return .init(identifier: identifier, isVariadic: false)
        }
        func _argument(from ctx: JavaScriptParser.LastFormalParameterArgContext) -> JsFunctionArgument? {
            guard let identifier = _identifier(from: ctx.singleExpression())?.getText() else {
                return nil
            }

            return .init(identifier: identifier, isVariadic: ctx.Ellipsis() != nil)
        }

        var arguments: [JsFunctionArgument] = []

        if let ctx = ctx {
            arguments = ctx.formalParameterArg().compactMap(_argument(from:))
            
            if let last = ctx.lastFormalParameterArg(), let argument = _argument(from: last) {
                arguments.append(argument)
            }
        }

        return JsFunctionSignature(arguments: arguments)
    }

    /// Reads a function signature from an arrow function parameter context.
    public static func functionSignature(from ctx: JavaScriptParser.ArrowFunctionParametersContext?) -> JsFunctionSignature? {
        guard let ctx = ctx else {
            return nil
        }

        if let identifier = ctx.identifier() {
            return JsFunctionSignature(arguments: [
                .init(identifier: identifier.getText(), isVariadic: false)
            ])
        }
        
        return functionSignature(from: ctx.formalParameterList())
    }
}
