import Foundation
import MiniLexer
import GrammarModels
import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ParseTreeWalker
import class Antlr4.ParserRuleContext
import class Antlr4.Parser
import ObjcParserAntlr

/// Describes settings for ANTLR parsing for an `ObjcParser` instance.
public struct AntlrSettings {
    public static let `default` = AntlrSettings(forceUseLLPrediction: false)
    
    public var forceUseLLPrediction: Bool
    
    public init(forceUseLLPrediction: Bool) {
        self.forceUseLLPrediction = forceUseLLPrediction
    }
}

public class ObjcParser {
    /// A state used to instance single threaded parsers.
    /// The default parser state, in case the user did not provide one on init.
    private static var _singleThreadState: ObjcParserState = ObjcParserState()

    var parsed: Bool = false
    
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
    
    /// Contains information about all C-style comments found while parsing the
    /// input file.
    public var comments: [ObjcComment] = []
    
    /// Preprocessor directives found on this file
    public var preprocessorDirectives: [ObjcPreprocessorDirective] = []
    public var importDirectives: [ObjcImportDecl] = []
    
    public var antlrSettings: AntlrSettings = .default
    
    public convenience init(string: String, fileName: String = "") {
        self.init(source: StringCodeSource(source: string, fileName: fileName))
    }
    
    public convenience init(string: String,
                            fileName: String = "",
                            state: ObjcParserState) {
        
        self.init(source: StringCodeSource(source: string, fileName: fileName),
                  state: state)
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
        rootNode = GlobalContextNode(isInNonnullContext: false)
    }
    
    func startRange() -> RangeMarker {
        lexer.startRange()
    }
    
    /// Creates and returns a backtracking point which can be activated to rewind
    /// the lexer to the point at which this method was called.
    func backtracker() -> Backtrack {
        lexer.backtracker()
    }
    
    /// Current lexer's location as a `SourceLocation`.
    func location() -> SourceLocation {
        lexer.location()
    }
    
    func withTemporaryContext<T: InitializableNode>(
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
        if parsed {
            return
        }

        // Clear previous state
        preprocessorDirectives = []
        
        let input = try parsePreprocessor()
        
        parseComments(input: input)
        
        try parseNSAssumeNonnullChannel(input: input)
        
        let nonnullContextQuerier =
            NonnullContextQuerier(nonnullMacroRegionsTokenRange: nonnullMacroRegionsTokenRange)
        
        let commentQuerier =
            CommentQuerier(allComments: comments)
        
        try parseMainChannel(input: input,
                             nonnullContextQuerier: nonnullContextQuerier,
                             commentQuerier: commentQuerier)
        
        // Go around the tree setting the source for the nodes and detecting
        // nodes within assume non-null ranges
        let visitor = AnyASTVisitor(visit: { $0.originalSource = self.source })
        let traverser = ASTTraverser(node: rootNode, visitor: visitor)
        traverser.traverse()

        importDirectives = ObjcParser.parseObjcImports(in: preprocessorDirectives)
        
        parsed = true
    }
    
    private func tryParse<T: ParserRuleContext, P: Parser>(from parser: P, _ operation: (P) throws -> T) throws -> T {
        
        let diag = Diagnostics()
        parser.addErrorListener(
            DiagnosticsErrorListener(source: source, diagnostics: diag)
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
    
    /// Main source parsing pass which takes in preprocessors while parsing
    private func parsePreprocessor() throws -> String {
        let src = source.fetchSource()
        
        let parserState = try state.makePreprocessorParser(input: src)
        let parser = parserState.parser
        parser.removeErrorListeners()
        preprocessorParser = parserState
        
        let root = try tryParse(from: parser, { try $0.objectiveCDocument() })
        
        let preprocessors = ObjcPreprocessorListener.walk(root)
        
        // Extract preprocessors now
        for preprocessorRange in preprocessors {
            let start = src.index(src.startIndex, offsetBy: preprocessorRange.lowerBound)
            let end = src.index(src.startIndex, offsetBy: preprocessorRange.upperBound)
            let line = String(src[start..<end])
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let startLine = src.lineNumber(at: start)
            let startColumn = src.columnOffset(at: start)
            let endLine = src.lineNumber(at: end)
            let endColumn = src.columnOffset(at: end)
            
            let location = SourceLocation(line: startLine,
                                          column: startColumn,
                                          utf8Offset: preprocessorRange.lowerBound)
            let length = SourceLength(newlines: endLine - startLine,
                                      columnsAtLastLine: startLine == endLine ? 0 : endColumn,
                                      utf8Length: preprocessorRange.count)
            
            let directive = ObjcPreprocessorDirective(string: trimmed,
                                                      range: preprocessorRange,
                                                      location: location,
                                                      length: length)
            
            preprocessorDirectives.append(directive)
        }
        
        // Return proper code
        let processed = ObjectiveCPreprocessor(commonTokenStream: parserState.tokens,
                                               inputString: src)
        
        return processed.visitObjectiveCDocument(root) ?? ""
    }
    
    private func parseMainChannel(input: String,
                                  nonnullContextQuerier: NonnullContextQuerier,
                                  commentQuerier: CommentQuerier) throws {
        
        // Make a pass with ANTLR before traversing the parse tree and collecting
        // known constructs
        let src = source.fetchSource()
        
        let parserState = try mainParser ?? state.makeMainParser(input: input)
        let parser = parserState.parser
        parser.removeErrorListeners()
        mainParser = parserState
        
        let root = try tryParse(from: parser, { try $0.translationUnit() })
        
        let listener =
            ObjcParserListener(sourceString: src,
                               source: source,
                               state: state,
                               antlrSettings: antlrSettings,
                               nonnullContextQuerier: nonnullContextQuerier,
                               commentQuerier: commentQuerier)
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)
        
        rootNode = listener.rootNode
    }
    
    private func parsePreprocessorDirectivesChannel() throws {
        let src = source.fetchSource()
        
        let parser = try state.makeMainParser(input: src)
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
            switch tok.getType() {
            case ObjectiveCLexer.NS_ASSUME_NONNULL_BEGIN:
                lastBegin = tok.getTokenIndex()
                
            case ObjectiveCLexer.NS_ASSUME_NONNULL_END:
                if let lastBeginIndex = lastBegin {
                    nonnullMacroRegionsTokenRange.append((start: lastBeginIndex, end: tok.getTokenIndex()))
                    lastBegin = nil
                }
                
            default:
                break
            }
        }
    }
    
    private func parseComments(input: String) {
        comments.removeAll()
        
        let ranges = input.cStyleCommentSectionRanges()
        
        for range in ranges {
            let lineStart = input.lineNumber(at: range.lowerBound)
            let colStart = input.columnOffset(at: range.lowerBound)
            
            let lineEnd = input.lineNumber(at: range.upperBound)
            let colEnd = input.columnOffset(at: range.upperBound)
            
            let utf8Offset = input.utf8.distance(from: input.startIndex, to: range.lowerBound)
            let utf8Length = input.utf8.distance(from: range.lowerBound, to: range.upperBound)
            
            let location = SourceLocation(line: lineStart,
                                          column: colStart,
                                          utf8Offset: utf8Offset)
            
            let length: SourceLength
            if lineStart == lineEnd {
                length = SourceLength(newlines: 0,
                                      columnsAtLastLine: colEnd - colStart,
                                      utf8Length: utf8Length)
            } else {
                length = SourceLength(newlines: lineEnd - lineStart,
                                      columnsAtLastLine: colEnd - 1,
                                      utf8Length: utf8Length)
            }
            
            let comment = ObjcComment(string: String(input[range]),
                                      range: range,
                                      location: location,
                                      length: length)
            
            comments.append(comment)
        }
    }
    
    public func parseObjcType() throws -> ObjcType {
        // Here we simplify the grammar for types as:
        // TypeName: specifier* IDENTIFIER ('<' TypeName '>')? '*'? qualifier*
        
        var type: ObjcType
        
        var specifiers: [String] = []
        while lexer.tokenType(matches: \.isTypeQualifier) {
            let spec = lexer.nextToken().value
            specifiers.append(String(spec))
        }
        
        if lexer.tokenType(is: .id) {
            lexer.skipToken()
            
            // '<' : Protocol list
            if lexer.tokenType() == .operator(.lessThan) {
                let types =
                    _parseCommaSeparatedList(
                        braces: .operator(.lessThan), .operator(.greaterThan),
                        itemParser: { try lexer.advance(matching: \.tokenType.isIdentifier) })
                
                type = .id(protocols: types.map { String($0.value) })
            } else {
                type = .id()
            }
        } else if lexer.tokenType(matches: \.isIdentifier) {
            var typeName = String(try lexer.advance(matching: \.tokenType.isIdentifier).value)
            
            // 'long long' support
            if typeName == "long" && lexer.tokenType(is: .identifier("long")) {
                typeName = try String(typeName + " " + lexer.advance(matching: \.tokenType.isIdentifier).value)
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
            throw lexer.lexer.syntaxError("Expected type name")
        }
        
        // '*' : Pointer
        if lexer.tokenType(is: .operator(.multiply)) {
            lexer.skipToken()
            type = .pointer(type)
        }
        
        // Type qualifier
        var qualifiers: [String] = []
        while lexer.tokenType(matches: \.isTypeQualifier) {
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
    
    func parseTokenNode(_ tokenType: TokenType) throws {
        try lexer.advance(overTokenType: tokenType)
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
    internal func _parseCommaSeparatedList<T>(braces openBrace: TokenType,
                                              _ closeBrace: TokenType,
                                              itemParser: () throws -> T) -> [T] {
        
        do {
            try parseTokenNode(openBrace)
        } catch {
            diagnostics.error("Expected \(openBrace) to open list",
                              origin: source.filePath,
                              location: location())
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
                    try parseTokenNode(.comma)
                    expectsItem = true
                } else if lexer.tokenType(is: closeBrace) {
                    break
                } else {
                    // Should match either comma or closing brace!
                    throw LexerError.genericParseError
                }
            } catch {
                // Panic!
                diagnostics.error("Expected \(TokenType.comma) or \(closeBrace) after an item",
                                 origin: source.filePath,
                                 location: location())
            }
        }
        
        // Closed list after comma
        if expectsItem {
            diagnostics.error("Expected item after comma",
                              origin: source.filePath,
                              location: location())
        }
        
        do {
            try parseTokenNode(closeBrace)
        } catch {
            diagnostics.error("Expected \(closeBrace) to close list",
                              origin: source.filePath,
                              location: location())
        }
        
        return items
    }

    private static func parseObjcImports(in directives: [ObjcPreprocessorDirective]) -> [ObjcImportDecl] {
        var imports: [ObjcImportDecl] = []

        for directive in directives {
            do {
                let lexer = MiniLexer.Lexer(input: directive.string)

                // "#import <[PATH]>"
                try lexer.advance(expectingCurrent: "#"); lexer.skipWhitespace()

                guard lexer.advanceIf(equals: "import") else { continue }

                lexer.skipWhitespace()

                if lexer.safeIsNextChar(equalTo: "<") {
                    // Extract "<[PATH]>" now, e.g. "<UIKit/UIKit.h>" -> "UIKit/UIKit.h"
                    try lexer.advance(expectingCurrent: "<")
                    let path = lexer.consume(until: { $0 == ">"})

                    imports.append(ObjcImportDecl(path: String(path), isSystemImport: true))
                } else {
                    // Extract "[PATH]"
                    try lexer.advance(expectingCurrent: "\"")
                    let path = lexer.consume(until: { $0 == "\""})

                    imports.append(ObjcImportDecl(path: String(path), isSystemImport: false))
                }
            } catch {
                // Ignore silently
            }
        }

        return imports
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
        
        diagnostics.error(
            msg,
            origin: source.filePath,
            location: SourceLocation(line: line, column: charPositionInLine, utf8Offset: 0))
    }
}

public struct ObjcImportDecl {
    public var path: String
    /// If `true`, indicates `#import` is of `#import <system_header>` variant,
    /// as opposed to `#import "local_file"` variant.
    public var isSystemImport: Bool
    
    public var pathComponents: [String] {
        (path as NSString).pathComponents
    }
}
