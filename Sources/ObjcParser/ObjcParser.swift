import Foundation
import MiniLexer
import GrammarModels

public class ObjcParser {
    let lexer: ObjcLexer
    let context: NodeCreationContext
    
    /// Whether a token has been read yet by this parser
    internal var _hasReadToken: Bool = false
    internal var currentToken: Token = Token(type: .eof, string: "", location: .invalid)
    
    public let diagnostics: Diagnostics
    
    /// The root global context note after parsing.
    public var rootNode: GlobalContextNode
    
    public convenience init(string: String) {
        self.init(source: StringCodeSource(source: string))
    }
    
    public init(source: CodeSource) {
        lexer = ObjcLexer(source: source)
        context = NodeCreationContext()
        diagnostics = Diagnostics()
        rootNode = GlobalContextNode()
    }
    
    public func withTemporaryContextNode(_ node: ASTNode, do action: () throws -> ()) rethrows {
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        try action()
    }
    
    public func withTemporaryContext<T: ASTNode & InitializableNode>(nodeType: T.Type = T.self, do action: () throws -> ()) rethrows -> T {
        let node = context.pushContext(nodeType: nodeType)
        defer {
            context.popContext()
        }
        
        try action()
        
        return node
    }
    
    /// Parses the entire source string
    public func parse() throws {
        context.pushContext(node: rootNode)
        defer {
            context.popContext()
        }
        
        try parseGlobalNamespace()
    }
    
    /// Parse the global namespace.
    /// Called by `parse` by default until the entire string is consumed.
    public func parseGlobalNamespace() throws {
        // TODO: Flesh out full global scope grammar here
        try parseClassInerfaceNode()
    }
    
    func parseObjcType() throws -> ObjcType {
        // Here we simplify the grammar for types as:
        // TypeName: IDENTIFIER ('<' TypeName '>')? '*'?
        
        var type: ObjcType
        
        if lexer.tokenType(.id) {
            lexer.skipToken()
            
            // '<' : Protocol list
            if lexer.tokenType() == .operator(.lessThan) {
                let types =
                    _parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
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
                    _parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan), itemParser: parseObjcType)
                type = .generic(typeName, parameters: types)
            } else {
                type = .struct(typeName)
            }
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
        
        return type
    }
    
    func parseTypeNameNode(onMissing message: String = "Expected type name") throws -> TypeNameNode {
        let range = startRange()
        do {
            return try lexer.rewindOnFailure {
                let type = try parseObjcType()
                
                return TypeNameNode(type: type, location: range.makeRange())
            }
        } catch {
            diagnostics.error(message, location: location())
            throw error
        }
    }
    
    func parseIdentifierNode(onMissing message: String = "Expected identifier") throws -> Identifier {
        let identRange = startRange()
        do {
            let ident = try lexer.rewindOnFailure { try lexer.consume(tokenType: .identifier) }
            
            return Identifier(name: ident.string, location: identRange.makeRange())
        } catch {
            diagnostics.error(message, location: location())
            throw error
        }
    }
    
    func parseKeyword(_ keyword: Keyword, onMissing message: String? = nil) throws {
        let range = startRange()
        
        _=try lexer.consume(tokenType: .keyword(keyword))
        
        let node = KeywordNode(keyword: keyword, location: range.makeRange())
        
        context.addChildNode(node)
    }
    
    func parseTokenNode(_ tokenType: TokenType, onMissing message: String? = nil, addToContext: Bool = true) throws {
        let range = startRange()
        
        let tok = try lexer.consume(tokenType: tokenType)
        
        if addToContext {
            let node = TokenNode(token: tok, location: range.makeRange())
            
            context.addChildNode(node)
        }
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

/// With a throwing, node-returning closure, encapsulate it within a do/catch
/// block and return an `ASTNodeRef.valid` with the resulting node if the
/// operation succeeds, or return `ASTNodeRef.invalid` if the operation fails.
///
/// An optional argument `onPanic` is called when the operation fails to allow the
/// caller to deal with a parsing failure plan in case the operation fails.
func asNodeRef<T: ASTNode>(_ closure: @autoclosure () throws -> T, onPanic: () throws -> () = { }) rethrows -> ASTNodeRef<T> {
    do {
        return .valid(try closure())
    } catch {
        try onPanic()
        return .invalid(InvalidNode())
    }
}
