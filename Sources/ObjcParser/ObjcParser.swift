import Foundation
import MiniLexer
import GrammarModels
import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ANTLRInputStream
import class Antlr4.CommonTokenStream
import class Antlr4.ParseTreeWalker
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
/// - Note: States are not shareable across many `ObjcParser` instances at the same
/// time.
public class ObjcParserState {
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

public class ObjcParser {
    /// A state used to instance single threaded parsers.
    /// The default parser state, in case the user did not provide one on init.
    private static var _singleThreadState: ObjcParserState = ObjcParserState()
    
    // MARK: ANTLR parser
    var mainParser: AntlrParser<ObjectiveCLexer, ObjectiveCParser>?
    var preprocessorParser: AntlrParser<ObjectiveCPreprocessorLexer, ObjectiveCPreprocessorParser>?
    
    /// Gets or sets the underlying parser state for this parser
    public var state: ObjcParserState
    
    // MARK: Internal members
    let lexer: ObjcLexer
    let source: CodeSource
    let context: NodeCreationContext
    
    public var diagnostics: Diagnostics
    
    /// The root global context note after parsing.
    public var rootNode: GlobalContextNode
    
    // NOTE: This is mostly a hack to work around issues related to using primarily
    // ANTLR for parsing. This should be done in a smoother way later on, if possible.
    ///
    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END token pairs so that later on the
    /// rewriter can leverage this information to infer nonnull contexts.
    public var nonnullMacroRegionsTokenRange: [(start: Int, end: Int)] = []
    
    /// Preprocessor directives found on this file
    public var preprocessorDirectives: [String] = []
    
    public convenience init(string: String, fileName: String = "") {
        self.init(source: StringCodeSource(source: string, fileName: fileName))
    }
    
    public convenience init(string: String, fileName: String = "", state: ObjcParserState) {
        self.init(source: StringCodeSource(source: string, fileName: fileName), state: state)
    }
    
    public convenience init(source: CodeSource) {
        self.init(source: source, state: ObjcParser._singleThreadState)
    }
    
    public init(source: CodeSource, state: ObjcParserState) {
        self.source = source
        self.state = state
        lexer = ObjcLexer(source: source)
        context = NodeCreationContext()
        diagnostics = Diagnostics()
        rootNode = GlobalContextNode()
    }
    
    func startRange() -> RangeMarker {
        return lexer.startRange()
    }
    
    /// Creates and returns a backtracking point which can be activated to rewind
    /// the lexer to the point at which this method was called.
    func backtracker() -> Backtrack {
        return lexer.backtracker()
    }
    
    /// Current lexer's location as a `SourceLocation`.
    func location() -> SourceLocation {
        return lexer.location()
    }
    
    func withTemporaryContext<T: ASTNode & InitializableNode>(
        nodeType: T.Type = T.self, do action: () throws -> Void) rethrows -> T {
        
        let node = context.pushContext(nodeType: nodeType)
        defer {
            context.popContext()
        }
        
        try action()
        
        return node
    }
    
    /// Parses the entire source string
    public func parse() throws {
        // Clear previous state
        preprocessorDirectives = []
        
        let input = try parsePreprocessor()
        try parseMainChannel(input: input)
        try parseNSAssumeNonnullChannel(input: input)
        
        // Go around the tree setting the source for the nodes
        let visitor = AnyASTVisitor(visit: { $0.originalSource = self.source })
        let traverser = ASTTraverser(node: rootNode, visitor: visitor)
        traverser.traverse()
    }
    
    /// Main source parsing pass which takes in preprocessors while parsing
    private func parsePreprocessor() throws -> String {
        let src = source.fetchSource()
        
        let parserState = try state.makePreprocessorParser(input: src)
        let parser = parserState.parser
        preprocessorParser = parserState
        parser.addErrorListener(
            DiagnosticsErrorListener(source: source, diagnostics: diagnostics)
        )
        
        let root = try parser.objectiveCDocument()
        
        let preprocessors = ObjcPreprocessorListener.walk(root)
        
        // Extract preprocessors now
        for preprocessor in preprocessors {
            let start = src.index(src.startIndex, offsetBy: preprocessor.lowerBound)
            let end = src.index(src.startIndex, offsetBy: preprocessor.upperBound)
            let line = String(src[start..<end])
            
            preprocessorDirectives.append(line.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        // Return proper code
        let processed = ObjectiveCPreprocessor(commonTokenStream: parserState.tokens)
        return processed.visitObjectiveCDocument(root) ?? ""
    }
    
    private func parseMainChannel(input: String) throws {
        // Make a pass with ANTLR before traversing the parse tree and collecting
        // known constructs
        let src = source.fetchSource()
        
        let parserState = try mainParser ?? state.makeMainParser(input: input)
        let parser = parserState.parser
        mainParser = parserState
        parser.addErrorListener(
            DiagnosticsErrorListener(source: source, diagnostics: diagnostics)
        )
        
        try parser.reset()
        
        let root = try parser.translationUnit()
        
        let listener = ObjcParserListener(sourceString: src, source: source, state: state)
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)
        
        rootNode = listener.rootNode
    }
    
    private func parsePreprocessorDirectivesChannel() throws {
        let src = source.fetchSource()
        
        let parser = try self.state.makeMainParser(input: src)
        parser.lexer.setChannel(ObjectiveCLexer.DIRECTIVE_CHANNEL)
        defer {
            // Don't forget to reset token channel, as this state may be shared
            // with other parsers later on
            parser.lexer.setChannel(ObjectiveCLexer.DEFAULT_TOKEN_CHANNEL)
        }
        
        let tokens = parser.tokens
        try tokens.fill()
        
        let allTokens = tokens.getTokens()
        
        var lastBegin: Int?
        
        for tok in allTokens {
            let tokType = tok.getType()
            if tokType == ObjectiveCLexer.NS_ASSUME_NONNULL_BEGIN {
                lastBegin = tok.getTokenIndex()
            } else if tokType == ObjectiveCLexer.NS_ASSUME_NONNULL_END {
                
                if let lastBeginIndex = lastBegin {
                    nonnullMacroRegionsTokenRange.append((start: lastBeginIndex, end: tok.getTokenIndex()))
                    lastBegin = nil
                }
            }
        }
    }
    
    private func parseNSAssumeNonnullChannel(input: String) throws {
        nonnullMacroRegionsTokenRange = []
        
        let tokens = try state.makeMainParser(input: input).tokens
        try tokens.fill()
        
        let allTokens = tokens.getTokens()
        
        var lastBegin: Int?
        
        for tok in allTokens {
            let tokType = tok.getType()
            if tokType == ObjectiveCLexer.NS_ASSUME_NONNULL_BEGIN {
                lastBegin = tok.getTokenIndex()
            } else if tokType == ObjectiveCLexer.NS_ASSUME_NONNULL_END {
                
                if let lastBeginIndex = lastBegin {
                    nonnullMacroRegionsTokenRange.append((start: lastBeginIndex, end: tok.getTokenIndex()))
                    lastBegin = nil
                }
            }
        }
    }
    
    public func parseObjcType() throws -> ObjcType {
        // Here we simplify the grammar for types as:
        // TypeName: specifier* IDENTIFIER ('<' TypeName '>')? '*'? qualifier*
        
        var type: ObjcType
        
        var specifiers: [String] = []
        while lexer.tokenType(matches: { $0.isTypeQualifier }) {
            let spec = lexer.nextToken().value
            specifiers.append(String(spec))
        }
        
        if lexer.tokenType(is: .id) {
            lexer.skipToken()
            
            // '<' : Protocol list
            if lexer.tokenType() == .operator(.lessThan) {
                let types =
                    _parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
                                             addTokensToContext: false,
                                             itemParser: { try lexer.advance(matching: { $0.isIdentifier }) })
                type = .id(protocols: types.map { String($0.value) })
            } else {
                type = .id(protocols: [])
            }
        } else if lexer.tokenType(matches: { $0.isIdentifier }) {
            var typeName: String = String(try lexer.advance(matching: { $0.isIdentifier }).value)
            
            // 'long long' support
            if typeName == "long" && lexer.tokenType(matches: { $0.isIdentifier }) && lexer.token().value == "long" {
                typeName = String(try typeName + " " + lexer.advance(matching: { $0.isIdentifier }).value)
            }
            
            // 'signed', 'unsigned' support
            if specifiers == ["signed"] || specifiers == ["unsigned"] {
                typeName = specifiers[0] + " \(typeName)"
                specifiers.removeAll()
            }
            
            // '<' : Generic type specifier
            if lexer.tokenType() == .operator(.lessThan) {
                let types =
                    _parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
                                             addTokensToContext: false,
                                             itemParser: parseObjcType)
                type = .generic(typeName, parameters: types)
            } else if typeName == "instancetype" {
                type = .instancetype
            } else {
                type = .struct(typeName)
            }
        } else if lexer.tokenType(is: .keyword(.void)) {
            lexer.skipToken()
            type = .void
        } else {
            throw LexerError.syntaxError("Expected type name")
        }
        
        // '*' : Pointer
        if lexer.tokenType(is: .operator(.multiply)) {
            lexer.skipToken()
            type = .pointer(type)
        }
        
        // Type qualifier
        var qualifiers: [String] = []
        while lexer.tokenType(matches: { $0.isTypeQualifier }) {
            let qual = lexer.nextToken().value
            qualifiers.append(String(qual))
        }
        
        if !qualifiers.isEmpty {
            type = .qualified(type, qualifiers: qualifiers)
        }
        if !specifiers.isEmpty {
            type = .specified(specifiers: specifiers, type)
        }
        
        return type
    }
    
    func parseTokenNode(_ tokenType: TokenType,
                        onMissing message: String? = nil,
                        addToContext: Bool = true) throws {
        
        let range = startRange()
        
        let tok = try lexer.advance(over: tokenType)
        
        if addToContext {
            let token = Token(type: tok.tokenType, string: String(tok.value),
                              location: range.makeLocation())
            
            let node = TokenNode(token: token, location: range.makeLocation())
            
            context.addChildNode(node)
        }
    }
    
    /// Starts parsing a comman-separated list of items using the specified braces
    /// settings and an item-parsing closure.
    ///
    /// The method starts and ends by reading the opening and closing braces, and
    /// always expects to successfully parse at least one item.
    ///
    /// The method performs error recovery for opening/closing braces and the
    /// comma, but it is the responsibility of the `itemParser` closure to perform
    /// its own error recovery during parsing.
    ///
    /// The caller can optionally specify whether to ignore adding tokens (for
    /// opening brace/comma/closing brance tokens) to the context when parsing is
    /// performed.
    ///
    /// - Parameters:
    ///   - openBrace: Character that represents the opening brace, e.g. '(', '['
    /// or '<'.
    ///   - closeBrace: Character that represents the closing brace, e.g. ')', ']'
    /// or '>'.
    ///   - addTokensToContext: If true, when parsing tokens they are added to
    /// the current `context` as `TokenNode`s.
    ///   - itemParser: Block that is called to parse items on the list. Reporting
    /// of errors as diagnostics must be made by this closure.
    /// - Returns: An array of items returned by `itemParser` for each successful
    /// parse performed.
    internal func _parseCommaSeparatedList<T>(
        braces openBrace: TokenType, _ closeBrace: TokenType,
        addTokensToContext: Bool = true, itemParser: () throws -> T) -> [T] {
        
        do {
            try parseTokenNode(openBrace, addToContext: addTokensToContext)
        } catch {
            diagnostics.error("Expected \(openBrace) to open list", location: location())
        }
        
        var expectsItem = true
        var items: [T] = []
        while !lexer.isEof {
            expectsItem = false
            
            // Item
            do {
                let item = try itemParser()
                items.append(item)
            } catch {
                lexer.advance(until: { $0.tokenType == .comma || $0.tokenType == closeBrace })
            }
            
            // Comma separator / close brace
            do {
                if lexer.tokenType(is: .comma) {
                    try parseTokenNode(.comma, addToContext: addTokensToContext)
                    expectsItem = true
                } else if lexer.tokenType(is: closeBrace) {
                    break
                } else {
                    // Should match either comma or closing brace!
                    throw LexerError.genericParseError
                }
            } catch {
                // Panic!
                diagnostics.error("Expected \(TokenType.comma) or \(closeBrace) after an item", location: location())
            }
        }
        
        // Closed list after comma
        if expectsItem {
            diagnostics.error("Expected item after comma", location: location())
        }
        
        do {
            try parseTokenNode(closeBrace, addToContext: addTokensToContext)
        } catch {
            diagnostics.error("Expected \(closeBrace) to close list", location: location())
        }
        
        return items
    }
}

public class DiagnosticsErrorListener: BaseErrorListener {
    public let source: Source
    public let diagnostics: Diagnostics
    
    public init(source: Source, diagnostics: Diagnostics) {
        self.source = source
        self.diagnostics = diagnostics
        super.init()
    }
    
    public override func syntaxError<T>(_ recognizer: Recognizer<T>,
                                        _ offendingSymbol: AnyObject?,
                                        _ line: Int,
                                        _ charPositionInLine: Int,
                                        _ msg: String,
                                        _ e: AnyObject?) where T : ATNSimulator {
        diagnostics.error(msg, location: .invalid)
    }
}
