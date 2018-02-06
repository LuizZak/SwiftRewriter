import GrammarModels
import MiniLexer

public extension ObjcParser {
    
    /// Parses an Objective-C class/instance method declaration
    ///
    /// ```
    /// method_declaration:
    ///    ('+' | '-') method_definition (';' | method_body)
    ///
    /// method_definition:
    ///    method_type? method_selector
    /// ```
    func parseMethodDeclaration() throws {
        let method = MethodDefinition()
        context.pushContext(node: method)
        defer {
            context.popContext()
        }
        
        // ('+' | '-')
        if lexer.tokenType(.operator(.add)) {
            try parseTokenNode(.operator(.add))
        } else if lexer.tokenType(.operator(.subtract)) {
            try parseTokenNode(.operator(.subtract))
        } else {
            diagnostics.error("Expected either '-' or '+' for a method declaration",
                              location: location())
        }
        
        // method_definition:
        //    method_type? method_selector
        if lexer.tokenType(.openParens) {
            try parseMethodType()
        }
        
        try parseMethodSelector()
        
        if lexer.tokenType(.semicolon) {
            try parseTokenNode(.semicolon)
        } else if lexer.tokenType(.openBrace) {
            //method.body = try parseFunctionBody()
        } else {
            diagnostics.error("Expected \(TokenType.semicolon) or method body after method declaration", location: location())
        }
    }
    
    /// Parses a function body
    ///
    /// ```
    /// function_body:
    ///     statements
    /// ```
    func parseFunctionBody() throws -> String {
        try parseTokenNode(.openBrace)
        
        // TODO: Actually parse statements here
        let range = startRange()
        
        let innerLexer = lexer.lexer
        
        var depth = 0
        while !innerLexer.isEof() {
            if innerLexer.safeIsNextChar(equalTo: "{") {
                depth += 1
            } else if innerLexer.safeIsNextChar(equalTo: "}") {
                if depth == 0 {
                    break
                }
                
                depth -= 1
            }
            
            _=innerLexer.safeAdvance()
        }
        
        let body = range.makeString()
        
        // Force-read new token on ObjcLexer
        lexer._readToken()
        
        if depth != 0 {
            diagnostics.error("Expected \(TokenType.closeBrace) to finish method definition", location: location())
        } else {
            try parseTokenNode(.closeBrace)
        }
        
        return body
    }
    
    /// Parses an Objective-c method selector definition
    ///
    /// ```
    /// method_selector:
    ///    selector | ( keyword_declarator+ (parameter_list)? )
    ///
    /// selector:
    ///    IDENTIFIER | 'retain';
    /// ```
    func parseMethodSelector() throws {
        let methodType = MethodSelector()
        context.pushContext(node: methodType)
        defer {
            context.popContext()
        }
        
        if lexer.tokenType(.identifier) {
            // Verify single identifier (parameter-less) selector
            let bk = lexer.backtracker()
            lexer.skipToken()
            
            let kind: Int
            if lexer.tokenType(.colon) {
                kind = 0
            } else {
                kind = 1
            }
            bk.backtrack()
            
            if kind == 0 {
                try parseKeywordDeclaratorList()
            } else {
                let node = try parseIdentifierNode()
                context.addChildNode(node)
            }
        } else {
            try parseKeywordDeclaratorList()
        }
    }

    func parseKeywordDeclaratorList() throws {
        do {
            while !lexer.tokenType(.semicolon) && !lexer.tokenType(.openBrace) {
                try parseKeywordDeclarator()
            }
        } catch {
            
        }
    }
    
    /// Parses an Objective-C keyword declarator
    ///
    /// ```
    /// keyword_declarator:
    ///    selector? ':' method_type* IDENTIFIER;
    /// ```
    func parseKeywordDeclarator() throws {
        let node = KeywordDeclarator()
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        if lexer.tokenType(.identifier) {
            node.addChild(try parseIdentifierNode())
        }
        
        try parseTokenNode(.colon)
        
        if lexer.tokenType(.openParens) {
            try parseMethodType()
        }
        
        node.addChild(try parseIdentifierNode())
    }
    
    /// Parses an Objective-C method type
    ///
    /// ```
    /// method_type:
    ///    '(' nullability_specifier* objcType ')'
    ///
    /// nullability_specifier:
    ///    'nullable' | 'nonnull' | 'null_unspecified'
    /// ```
    func parseMethodType() throws {
        let methodType = context.pushContext(nodeType: MethodType.self)
        defer {
            context.popContext()
        }
        
        try parseTokenNode(.openParens)
        
        // nullability_specifier*
        outer: while lexer.tokenType(.identifier) {
            switch lexer.token().string {
            case "nullable", "nonnull", "null_unspecified":
                try parseNullabilitySpecifier()
            default:
                break outer
            }
        }
        
        let node = try parseTypeNameNode()
        context.addChildNode(node)
        
        if !lexer.tokenType(.closeParens) {
            diagnostics.error("Expected \(TokenType.closeParens) after signature method", location: location())
        }
        
        try parseTokenNode(.closeParens)
    }
    
    /// ```
    /// nullability_specifier:
    ///    'nullable' | 'nonnull' | 'null_unspecified'
    /// ```
    func parseNullabilitySpecifier() throws {
        let identRange = startRange()
        do {
            let ident = try lexer.rewindOnFailure {
                try lexer.consume(tokenType: .identifier)
            }
            
            let node =
                NullabilitySpecifier(name: ident.string,
                                     location: identRange.makeLocation())
            
            context.addChildNode(node)
        } catch {
            diagnostics.error("Expected nullabiliy specifier", location: location())
            throw error
        }
    }
}
