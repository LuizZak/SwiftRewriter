import GrammarModels

public extension ObjcParser {
    /// Returns true iff the current tokens indicate the start of a class category
    /// declaration.
    func isClassCategory() -> Bool {
        let bk = lexer.backtracker()
        defer {
            bk.backtrack()
        }
        
        // '@interface'
        if lexer.nextToken().type != .keyword(.atInterface) {
            return false
        }
        
        // className
        if lexer.nextToken().type != .identifier {
            return false
        }
        
        // '(' categoryName? ')'
        if lexer.nextToken().type != .openParens {
            return false
        }
        
        let tok = lexer.nextToken()
        if tok.type != .identifier && tok.type != .closeParens {
            return false
        }
        
        return true
    }
    
    /// Parses an Objective-C class category
    ///
    /// ```
    /// classInterface:
    ///    '@interface' className '(' categoryName? ')' protocolRefList? ivars? interfaceDeclList? '@end';
    ///
    /// categoryName:
    ///     identifier
    /// ```
    func parseClassCategoryNode() throws {
        // @interface Name [: SuperClass] [<ProtocolList>]
        //
        // @end
        
        let classNode: ObjcClassCategory = context.pushContext()
        defer {
            context.popContext()
        }
        
        // Consume @interface
        try parseKeyword(.atInterface, onMissing: "Expected \(Keyword.atInterface) to start class declaration")
        
        // Class name
        classNode.identifier = .valid(try parseIdentifierNode())
        
        // Category name
        try parseTokenNode(.openParens)
        
        if lexer.tokenType(.identifier) {
            classNode.categoryName = try parseIdentifierNode()
        }
        
        if lexer.tokenType(.closeParens) {
            parseAnyTokenNode()
        } else {
            diagnostics.error("Expected closing parens after category name.",
                              location: location())
        }
        
        // Protocol conformance list
        if lexer.tokenType(.operator(.lessThan)) {
            do {
                try parseProtocolReferenceList()
            } catch {
                // Panic!
            }
        }
        
        // ivar list
        if lexer.tokenType(.openBrace) {
            try parseIVarsList()
        }
        
        // Consume interface declarations
        while !lexer.tokenType(.keyword(.atEnd)) {
            if lexer.tokenType(.keyword(.atProperty)) {
                try self.parsePropertyNode()
            } else if lexer.tokenType(.operator(.add)) || lexer.tokenType(.operator(.subtract)) {
                try self.parseMethodDeclaration()
            } else {
                diagnostics.error("Expected an ivar list, @property, or method(s) declaration(s) in class", location: location())
                lexer.advance(until: { $0.type == .keyword(.atEnd) })
                break
            }
        }
        
        try self.parseKeyword(.atEnd, onMissing: "Expected \(Keyword.atEnd) to end class declaration")
    }
}
