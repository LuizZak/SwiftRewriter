import Foundation
import MiniLexer
import class Antlr4.BaseErrorListener
import class Antlr4.Recognizer
import class Antlr4.ATNSimulator
import class Antlr4.ParseTreeWalker
import class Antlr4.ParserRuleContext
import class Antlr4.Parser
import AntlrCommons
import Utils
import ObjcGrammarModels
import GrammarModelBase
import ObjcParserAntlr

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
    let context: NodeCreationContext
    
    public var diagnostics: Diagnostics

    /// The source that is being parsed.
    public let source: CodeSource
    
    /// The root global context note after parsing.
    public var rootNode: ObjcGlobalContextNode
    
    // NOTE: This is mostly a hack to work around issues related to using primarily
    // ANTLR for parsing. This should be done in a smoother way later on, if possible.
    ///
    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END token pairs so that later on the
    /// rewriter can leverage this information to infer nonnull contexts.
    public var nonnullMacroRegionsTokenRange: [(start: Int, end: Int)] = []

    /// When NS_ASSUME_NONNULL_BEGIN/END pairs are present on the source code, this
    /// array keeps the index of the BEGIN/END source location pairs so that
    /// later on the rewriter can leverage this information to infer nonnull
    /// contexts.
    ///
    /// Alternative to `nonnullMacroRegionsTokenRange`.
    public var nonnullMacroRegionsRanges: [SourceRange] = []

    /// Contains information about all C-style comments found while parsing the
    /// input file.
    public var comments: [RawCodeComment] = []
    
    /// Preprocessor directives found on this file
    public var preprocessorDirectives: [ObjcPreprocessorDirective] = []
    public var importDirectives: [ObjcImportDecl] = []
    
    public var antlrSettings: AntlrSettings = .default
    
    public convenience init(string: String, fileName: String = "") {
        self.init(source: StringCodeSource(source: string, fileName: fileName))
    }
    
    public convenience init(
        string: String,
        fileName: String = "",
        state: ObjcParserState
    ) {
        
        self.init(
            source: StringCodeSource(source: string, fileName: fileName),
            state: state
        )
    }
    
    public convenience init(source: CodeSource) {
        self.init(source: source, state: ObjcParser._singleThreadState)
    }
    
    public init(source: CodeSource, state: ObjcParserState) {
        self.source = source
        self.state = state
        context = NodeCreationContext()
        diagnostics = Diagnostics()
        rootNode = ObjcGlobalContextNode(isInNonnullContext: false)
    }
    
    func withTemporaryContext<T: ObjcInitializableNode>(
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
        
        let nonnullContextQuerier = NonnullContextQuerier(
            nonnullMacroRegionsTokenRange: nonnullMacroRegionsTokenRange,
            nonnullMacroRegionsRanges: nonnullMacroRegionsRanges
        )
        
        let commentQuerier = CommentQuerier(
            allComments: comments
        )
        
        try parseMainChannel(
            input: input,
            nonnullContextQuerier: nonnullContextQuerier,
            commentQuerier: commentQuerier
        )
        
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
            AntlrDiagnosticsErrorListener(source: source, diagnostics: diag)
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
            
            let location = SourceLocation(
                line: startLine,
                column: startColumn,
                utf8Offset: preprocessorRange.lowerBound
            )
            let length = SourceLength(
                newlines: endLine - startLine,
                columnsAtLastLine: startLine == endLine ? 0 : endColumn,
                utf8Length: preprocessorRange.count
            )
            
            let directive = ObjcPreprocessorDirective(
                string: trimmed,
                range: preprocessorRange,
                location: location,
                length: length
            )
            
            preprocessorDirectives.append(directive)
        }
        
        // Return proper code
        let processed = ObjectiveCPreprocessor(
            commonTokenStream: parserState.tokens,
            inputString: src
        )
        
        return processed.visitObjectiveCDocument(root) ?? ""
    }
    
    private func parseMainChannel(
        input: String,
        nonnullContextQuerier: NonnullContextQuerier,
        commentQuerier: CommentQuerier
    ) throws {
        
        // Make a pass with ANTLR before traversing the parse tree and collecting
        // known constructs
        let src = source.fetchSource()
        
        let parserState = try mainParser ?? state.makeMainParser(input: input)
        let parser = parserState.parser
        parser.removeErrorListeners()
        mainParser = parserState
        
        let root = try tryParse(from: parser, { try $0.translationUnit() })
        
        let listener = ObjcParserListener(
            sourceString: src,
            source: source,
            state: state,
            antlrSettings: antlrSettings,
            nonnullContextQuerier: nonnullContextQuerier,
            commentQuerier: commentQuerier
        )
        
        let walker = ParseTreeWalker()
        try walker.walk(listener, root)
        
        rootNode = listener.rootNode
    }
    
    private func parseNSAssumeNonnullChannel(input: String) throws {
        nonnullMacroRegionsTokenRange = []
        
        let tokens = try state.makeMainParser(input: input).tokens
        try tokens.fill()
        
        let allTokens = tokens.getTokens()
        
        var lastBegin: Int?
        var lastLoc: SourceLocation?
        
        for tok in allTokens {
            switch tok.getType() {
            case ObjectiveCLexer.NS_ASSUME_NONNULL_BEGIN:
                lastBegin = tok.getTokenIndex()
                lastLoc = source.sourceLocation(for: tok)
                
            case ObjectiveCLexer.NS_ASSUME_NONNULL_END:
                if let lastBeginIndex = lastBegin {
                    nonnullMacroRegionsTokenRange.append((start: lastBeginIndex, end: tok.getTokenIndex()))
                    lastBegin = nil
                }

                if let startLoc = lastLoc {
                    let endLoc = source.sourceLocation(for: tok)
                    nonnullMacroRegionsRanges.append(
                        .range(start: startLoc, end: endLoc)
                    )

                    lastLoc = nil
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
            
            let location = SourceLocation(
                line: lineStart,
                column: colStart,
                utf8Offset: utf8Offset
            )
            
            let length: SourceLength
            if lineStart == lineEnd {
                length = SourceLength(
                    newlines: 0,
                    columnsAtLastLine: colEnd - colStart,
                    utf8Length: utf8Length
                )
            } else {
                length = SourceLength(
                    newlines: lineEnd - lineStart,
                    columnsAtLastLine: colEnd - 1,
                    utf8Length: utf8Length
                )
            }
            
            let commentString = String(input[range])
            let comment = RawCodeComment(
                string: commentString,
                range: utf8Offset..<(utf8Offset + utf8Length),
                location: location,
                length: length
            )
            
            comments.append(comment)
        }
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
