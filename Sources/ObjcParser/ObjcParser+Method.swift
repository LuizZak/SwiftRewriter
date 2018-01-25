import GrammarModels
import MiniLexer

public extension ObjcParser {
    
    /// Parses an Objective-c class/instance method declaration
    ///
    /// ```
    /// method_declaration:
    ///    ('+' | '-') method_definition ';'
    ///
    /// method_definition:
    ///    method_type? method_selector
    /// ```
    func parseMethodDeclaration() throws {
        let method = MethodDefinition(returnType: .placeholder, methodSelector: .placeholder)
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
        } else {
            diagnostics.error("Expected \(TokenType.semicolon) after method declaration", location: location())
        }
    }
    
    /// Parses an Objective-c method selector definition
    ///
    /// ```
    /// method_selector:
    ///    selector |(keyword_declarator+ (parameter_list)? )
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
            if lexer.tokenType(.semicolon) {
                kind = 0
            } else if lexer.tokenType(.colon) {
                kind = 1
            } else {
                kind = 2
                
                diagnostics.error(
                    "Expected \(TokenType.colon) or \(TokenType.semicolon) after method declaration",
                    location: location())
            }
            
            bk.backtrack()
            
            if kind == 0 {
                let node = try parseIdentifierNode()
                context.addChildNode(node)
            } else if kind == 1 {
                try parseKeywordDeclaratorList()
            }
        } else {
            try parseKeywordDeclaratorList()
        }
    }

    func parseKeywordDeclaratorList() throws {
        do {
            while !lexer.tokenType(.semicolon) {
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
        let node = KeywordDeclarator(selector: nil, identifier: nil)
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        if lexer.tokenType(.identifier) {
            node.selector = try parseIdentifierNode()
        }
        
        try parseTokenNode(.colon)
        
        if lexer.tokenType(.openParens) {
            try parseMethodType()
        }
        
        node.identifier = try parseIdentifierNode()
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
        let methodType = MethodType(type: .placeholder)
        context.pushContext(node: methodType)
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
        
        methodType.type = .valid(try parseTypeNameNode())
        
        if !lexer.tokenType(.closeParens) {
            diagnostics.error("Expected \(TokenType.closeParens) after signature method", location: location())
        }
        
        try parseTokenNode(.closeParens)
    }
    
    /// ```
    /// nullability_specifier:
    ///    'nullable' | 'nonnull' | 'null_unspecified'
    /// ```
    private func parseNullabilitySpecifier() throws {
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
