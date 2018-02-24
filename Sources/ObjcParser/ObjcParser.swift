import Foundation
import MiniLexer
import GrammarModels
import class Antlr4.ANTLRInputStream
import class Antlr4.CommonTokenStream
import class Antlr4.ParseTreeWalker
import ObjcParserAntlr

public class ObjcParser {
    let lexer: ObjcLexer
    let source: CodeSource
    let context: NodeCreationContext
    var tokens: CommonTokenStream?
    
    /// Whether a token has been read yet by this parser
    internal var _hasReadToken: Bool = false
    internal var currentToken: Token = Token(type: .eof, string: "", location: .invalid)
    
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
    
    public convenience init(string: String) {
        self.init(source: StringCodeSource(source: string))
    }
    
    public init(source: CodeSource) {
        self.source = source
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
    
    func withTemporaryContextNode(_ node: ASTNode, do action: () throws -> ()) rethrows {
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        try action()
    }
    
    func withTemporaryContext<T: ASTNode & InitializableNode>(nodeType: T.Type = T.self, do action: () throws -> ()) rethrows -> T {
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
        try parseNSAssumeNonnullChannel()
    }
    
    /// Main source parsing pass which takes in preprocessors while parsing
    private func parsePreprocessor() throws -> String {
        let src = source.fetchSource()
        
        let input = ANTLRInputStream(src)
        let lxr = ObjectiveCPreprocessorLexer(input)
        let tokens = CommonTokenStream(lxr)
        
        let parser = try ObjectiveCPreprocessorParser(tokens)
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
        let processed = ObjectiveCPreprocessor(commonTokenStream: tokens)
        return processed.visitObjectiveCDocument(root) ?? ""
    }
    
    private func initMainTokenStream(input: String) -> CommonTokenStream {
        if let tokens = self.tokens {
            return tokens
        }
        
        let input = ANTLRInputStream(input)
        let lxr = ObjectiveCLexer(input)
        let tokens = CommonTokenStream(lxr)
        
        self.tokens = tokens
        
        return tokens
    }
    
    private func parseMainChannel(input: String) throws {
        // Make a pass with ANTLR before traversing the parse tree and collecting
        // known constructs
        let src = source.fetchSource()
        
        let parser = try ObjectiveCParser(initMainTokenStream(input: input))
        let root = try parser.translationUnit()
        
        let listener = ObjcParserListener(sourceString: src, source: source)
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)
        
        rootNode = listener.rootNode
    }
    
    private func parsePreprocessorDirectivesChannel() throws {
        let src = source.fetchSource()
        
        let input = ANTLRInputStream(src)
        let lexer = ObjectiveCLexer(input)
        lexer.setChannel(ObjectiveCLexer.DIRECTIVE_CHANNEL)
        let tokens = CommonTokenStream(lexer)
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
    
    private func parseNSAssumeNonnullChannel() throws {
        nonnullMacroRegionsTokenRange = []
        
        let src = source.fetchSource()
        
        let input = ANTLRInputStream(src)
        let lexer = ObjectiveCLexer(input)
        lexer.setChannel(ObjectiveCLexer.IGNORED_MACROS)
        let tokens = CommonTokenStream(lexer)
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
        while lexer.tokenType(.typeQualifier) {
            let spec = lexer.nextToken().string
            specifiers.append(spec)
        }
        
        if lexer.tokenType(.id) {
            lexer.skipToken()
            
            // '<' : Protocol list
            if lexer.tokenType() == .operator(.lessThan) {
                let types =
                    _parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
                                             addTokensToContext: false,
                                             itemParser: { try lexer.consume(tokenType: .identifier) })
                type = .id(protocols: types.map { String($0.string) })
            } else {
                type = .id(protocols: [])
            }
        } else if lexer.tokenType(.identifier) {
            let typeName = try lexer.consume(tokenType: .identifier).string
            
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
        } else if lexer.tokenType(.keyword(.void)) {
            lexer.skipToken()
            type = .void
        } else {
            throw LexerError.syntaxError("Expected type name")
        }
        
        // '*' : Pointer
        if lexer.tokenType(.operator(.multiply)) {
            lexer.skipToken()
            type = .pointer(type)
        }
        
        // Type qualifier
        var qualifiers: [String] = []
        while lexer.tokenType(.typeQualifier) {
            let qual = lexer.nextToken().string
            qualifiers.append(qual)
        }
        
        if qualifiers.count > 0 {
            type = .qualified(type, qualifiers: qualifiers)
        }
        if specifiers.count > 0 {
            type = .specified(specifiers: specifiers, type)
        }
        
        return type
    }
    
    func parseTokenNode(_ tokenType: TokenType, onMissing message: String? = nil, addToContext: Bool = true) throws {
        let range = startRange()
        
        let tok = try lexer.consume(tokenType: tokenType)
        
        if addToContext {
            let node = TokenNode(token: tok, location: range.makeLocation())
            
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
    internal func _parseCommaSeparatedList<T>(braces openBrace: TokenType, _ closeBrace: TokenType, addTokensToContext: Bool = true, itemParser: () throws -> T) -> [T] {
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
                lexer.advance(until: { $0.type == .comma || $0.type == closeBrace })
            }
            
            // Comma separator / close brace
            do {
                if lexer.tokenType(.comma) {
                    try parseTokenNode(.comma, addToContext: addTokensToContext)
                    expectsItem = true
                } else if lexer.tokenType(closeBrace) {
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
