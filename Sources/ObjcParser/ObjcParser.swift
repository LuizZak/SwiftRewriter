import Foundation
import MiniLexer
import GrammarModels

public class ObjcParser {
    let lexer: Lexer
    let context: NodeCreationContext
    
    internal var currentToken: Token = Token(type: .eof, string: "", location: .invalid)
    
    public let diagnostics: Diagnostics
    
    /// The root global context note after parsing.
    public var rootNode: GlobalContextNode
    
    public init(string: String) {
        lexer = Lexer(input: string)
        context = NodeCreationContext()
        diagnostics = Diagnostics()
        rootNode = GlobalContextNode()
        
        readCurrentToken()
    }
    
    public convenience init(filePath: String, encoding: String.Encoding = .utf8) throws {
        let text = try String(contentsOfFile: filePath, encoding: encoding)
        self.init(string: text)
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
    
    func parseObjcType() throws -> TypeNameNode.ObjcType {
        // Here we simplify the grammar for types as:
        // TypeName: IDENTIFIER ('<' TypeName '>')? '*'?
        
        var type: TypeNameNode.ObjcType
        
        let typeName = String(try lexer.lexIdentifier())
        
        // '<' : Generic type specifier
        if lexer.withTemporaryIndex(changes: { lexer.skipWhitespace(); return lexer.safeIsNextChar(equalTo: "<") }) {
            lexer.skipWhitespace()
            
            if typeName == "id" {
                let types = _parseCommaSeparatedList(braces: "<", ">", itemParser: lexer.lexIdentifier)
                type = .id(protocols: types.map { String($0) })
            } else {
                let types = _parseCommaSeparatedList(braces: "<", ">", itemParser: parseObjcType)
                type = .generic(typeName, parameters: types)
            }
        } else {
            if typeName == "id" {
                type = .id(protocols: [])
            } else {
                type = .struct(typeName)
            }
        }
        
        // '*' : Pointer
        if lexer.withTemporaryIndex(changes: { lexer.skipWhitespace(); return lexer.safeIsNextChar(equalTo: "*") }) {
            lexer.skipWhitespace()
            try lexer.advance()
            type = .pointer(type)
        }
        
        return type
    }
    
    func parseTypeNameNode(onMissing message: String = "Expected type name") throws -> TypeNameNode {
        lexer.skipWhitespace()
        
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
        lexer.skipWhitespace()
        
        let identRange = startRange()
        do {
            let ident = try lexer.rewindOnFailure { try lexer.lexIdentifier() }
            
            return Identifier(name: String(ident), location: identRange.makeRange())
        } catch {
            diagnostics.error(message, location: location())
            throw error
        }
    }
    
    func parseKeyword(_ keyword: String, onMissing message: String? = nil) throws {
        let range = startRange()
        
        if !lexer.advanceIf(equals: keyword) {
            throw LexerError.syntaxError(message ?? "Expected \(keyword)")
        }
        
        let node = Keyword(name: keyword, location: range.makeRange())
        
        context.addChildNode(node)
    }
    
    func parseTokenNode(_ token: String, onMissing message: String? = nil, addToContext: Bool = true) throws {
        let range = startRange()
        
        if !lexer.advanceIf(equals: token) {
            throw LexerError.syntaxError(message ?? "Expected \(token)")
        }
        
        if addToContext {
            let node = TokenNode(token: token, location: range.makeRange())
            
            context.addChildNode(node)
        }
    }
    
    func startRange() -> RangeMarker {
        return RangeMarker(lexer: lexer)
    }
    
    /// Creates and returns a backtracking point which can be activated to rewind
    /// the lexer to the point at which this method was called.
    func backtracker() -> Backtrack {
        return Backtrack(parser: self)
    }
    
    /// Current lexer's location as a `SourceLocation`.
    func location() -> SourceLocation {
        return .location(lexer.inputIndex)
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
    internal func _parseCommaSeparatedList<T>(braces openBrace: Lexer.Atom, _ closeBrace: Lexer.Atom, addTokensToContext: Bool = true, itemParser: () throws -> T) -> [T] {
        do {
            try parseTokenNode(openBrace.description, addToContext: addTokensToContext)
        } catch {
            diagnostics.error("Expected \(openBrace) to open list", location: location())
        }
        
        var expectsItem = true
        var items: [T] = []
        while !lexer.isEof() {
            expectsItem = false
            
            lexer.skipWhitespace()
            
            // Item
            do {
                let item = try itemParser()
                items.append(item)
            } catch {
                lexer.advance(until: { $0 == "," || $0 == closeBrace })
            }
            
            lexer.skipWhitespace()
            
            // Comma separator / close brace
            lexer.skipWhitespace()
            do {
                if lexer.safeIsNextChar(equalTo: ",") {
                    try parseTokenNode(",", addToContext: addTokensToContext)
                    expectsItem = true
                } else if lexer.safeIsNextChar(equalTo: closeBrace) {
                    break
                } else {
                    // Should match either comma or closing brace!
                    throw LexerError.genericParseError
                }
            } catch {
                // Panic!
                diagnostics.error("Expected ',' or '\(closeBrace)' after an item", location: location())
                lexer.skipWhitespace()
            }
        }
        
        // Closed list after comma
        if expectsItem {
            diagnostics.error("Expected item after comma", location: location())
            // Panic and end list here
            lexer.skipWhitespace()
        }
        
        do {
            try parseTokenNode(closeBrace.description, addToContext: addTokensToContext)
        } catch {
            diagnostics.error("Expected \(closeBrace) to close list", location: location())
        }
        
        return items
    }
    
    struct RangeMarker {
        let lexer: Lexer
        let index: Lexer.Index
        
        init(lexer: Lexer) {
            self.lexer = lexer
            self.index = lexer.inputIndex
        }
        
        func makeSubstring() -> Substring {
            return lexer.inputString[rawRange()]
        }
        
        func makeRange() -> SourceRange {
            return .valid(rawRange())
        }
        
        func makeLocation() -> SourceLocation {
            return .range(rawRange())
        }
        
        private func rawRange() -> Range<Lexer.Index> {
            return index..<lexer.inputIndex
        }
    }
    
    class Backtrack {
        let parser: ObjcParser
        let index: Lexer.Index
        private var activated = false
        
        init(parser: ObjcParser) {
            self.parser = parser
            self.index = parser.lexer.inputIndex
        }
        
        func backtrack() {
            guard !activated else {
                return
            }
            
            parser.lexer.inputIndex = index
            
            activated = true
        }
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
