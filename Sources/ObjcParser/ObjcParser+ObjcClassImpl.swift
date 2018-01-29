import MiniLexer
import GrammarModels

extension ObjcParser {
    /// Parses a class implementation node.
    ///
    /// ```
    /// category_implementation:
    ///    '@implementation' class_name ( ':' superclass_name )?
    ///    instance_variables?
    ///    implementation_definition_list?
    ///    '@end';
    ///
    /// implementation_definition_list
    ///     : ( function_definition
    ///       | declaration
    ///       | method_definition
    ///       | property_implementation
    ///       )+
    ///     ;
    /// ```
    public func parseClassImplementation() throws {
        // TODO: Support property_implementation/property_synthesize_list/property_synthesize_item parsing.
        
        // @implementation Name [: SuperClass]
        //
        // @end
        
        let classNode: ObjcClassImplementation = context.pushContext()
        defer {
            context.popContext()
        }
        
        // Consume @implementation
        try parseKeyword(.atImplementation, onMissing: "Expected \(Keyword.atImplementation) to start class definition")
        
        // Class name
        classNode.identifier = .valid(try parseIdentifierNode())
        
        // Super class name
        if lexer.tokenType(.colon) {
            // Record ':'
            try parseTokenNode(.colon)
            
            // Record superclass name
            parseSuperclassNameNode()
        }
        
        // ivar list
        if lexer.tokenType(.openBrace) {
            try parseIVarsList()
        }
        
        // Consume implementation definitions
        while !lexer.tokenType(.keyword(.atEnd)) {
            if lexer.tokenType(.operator(.add)) || lexer.tokenType(.operator(.subtract)) {
                try parseMethodDeclaration()
            } else if lexer.tokenType(.keyword(.atDynamic)) || lexer.tokenType(.keyword(.atSynthesize)) {
                try parsePropertyImplementation()
            } else if lexer.tokenType(.preprocessorDirective) {
                // TODO: Preprocessor directive parsing should occur at top-level.
                parseAnyTokenNode()
            } else {
                diagnostics.error("Expected an ivar list, @synthesize/@dynamic, or method(s) definitions(s) in class", location: location())
                lexer.advance(until: { $0.type == .keyword(.atEnd) })
                break
            }
        }
        
        try self.parseKeyword(.atEnd, onMissing: "Expected \(Keyword.atEnd) to end class definition")
    }
    
    /// Parses a property implementation node
    ///
    /// ```
    /// property_implementation
    ///     : '@synthesize' property_synthesize_list ';'
    ///     | '@dynamic' property_synthesize_list ';'
    ///     ;
    /// ```
    public func parsePropertyImplementation() throws {
        context.pushContext(nodeType: PropertyImplementation.self)
        defer {
            context.popContext()
        }
        
        if !lexer.tokenType(.keyword(.atDynamic)) && !lexer.tokenType(.keyword(.atSynthesize)) {
            throw LexerError.syntaxError("Expected \(Keyword.atSynthesize) or \(Keyword.atDynamic) to start a property implementation declaration.")
        }
        
        try parseAnyKeyword()
        
        try parsePropertySynthesizeList()
    }
    
    /// Parses a property synthesize list.
    ///
    /// ```
    /// property_synthesize_list
    ///     : property_synthesize_item (',' property_synthesize_item)*
    ///     ;
    /// ```
    public func parsePropertySynthesizeList() throws {
        context.pushContext(nodeType: PropertySynthesizeList.self)
        defer {
            context.popContext()
        }
        
        var afterComma: Bool
        repeat {
            afterComma = false
            
            do {
                try parsePropertySynthesizeItem()
            } catch {
                lexer.advance(untilTokenType: .semicolon)
                break
            }
            
            if lexer.tokenType(.comma) {
                parseAnyTokenNode()
                afterComma = true
            }
        } while !lexer.tokenType(.semicolon)
        
        if afterComma {
            diagnostics.error("Expected property synthesize item after \(TokenType.comma)", location: location())
        }
        
        if lexer.tokenType(.semicolon) {
           parseAnyTokenNode()
        } else {
            diagnostics.error("Expected \(TokenType.semicolon) after synthesize list", location: location())
        }
    }
    
    /// Parses a property synthesize item.
    ///
    /// ```
    /// property_synthesize_item
    ///     : IDENTIFIER | IDENTIFIER '=' IDENTIFIER
    ///     ;
    /// ```
    public func parsePropertySynthesizeItem() throws {
        let ident = try parseIdentifierNode(onMissing: "Expected property name to synthesize.")
        
        let item = PropertySynthesizeItem(propertyName: ident)
        context.pushContext(node: item)
        defer {
            context.popContext()
        }
        
        // '=' IDENTIFIER
        guard lexer.tokenType(.operator(.assign)) else {
            return
        }
        
        parseAnyTokenNode()
        
        if let ident = try? parseIdentifierNode(onMissing: "Expected property name to synthesize.") {
            item.ivarName = ident
        }
    }
}
