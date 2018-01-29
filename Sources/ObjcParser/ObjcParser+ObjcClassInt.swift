import MiniLexer
import GrammarModels

extension ObjcParser {
    
    /// Parses an Objective-C class interface
    ///
    /// ```
    /// classInterface:
    ///    '@interface' className (':' superclassName)? protocolRefList? ivars? interfaceDeclList? '@end';
    /// ```
    public func parseClassInerfaceNode() throws {
        // @interface Name [: SuperClass] [<ProtocolList>]
        //
        // @end
        
        let classNode: ObjcClassInterface = context.pushContext()
        defer {
            context.popContext()
        }
        
        // Consume @interface
        try parseKeyword(.atInterface, onMissing: "Expected \(Keyword.atInterface) to start class declaration")
        
        // Class name
        classNode.identifier = .valid(try parseIdentifierNode())
        
        // Super class name
        if lexer.tokenType(.colon) {
            // Record ':'
            try parseTokenNode(.colon)
            
            // Record superclass name
            parseSuperclassName()
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
            // @property declaration
            if lexer.tokenType(.keyword(.atProperty)) {
                try self.parsePropertyNode()
                continue
            }
            
            // Method declaration
            if lexer.tokenType(.operator(.add)) || lexer.tokenType(.operator(.subtract)) {
                try self.parseMethodDeclaration()
                continue
            }
            
            // Preprocessor directives
            if lexer.tokenType(.preprocessorDirective) {
                // TODO: Preprocessor directive parsing should occur at top-level.
                parseAnyTokenNode()
                continue
            }
            
            diagnostics.error("Expected an ivar list, @property, or method(s) declaration(s) in class", location: location())
            lexer.advance(until: { $0.type == .keyword(.atEnd) })
            break
        }
        
        try self.parseKeyword(.atEnd, onMissing: "Expected \(Keyword.atEnd) to end class declaration")
    }
    
    /// Parses an ivar section from an interface or implementation's header section
    ///
    /// ```
    /// instance_variables
    ///     :   '{' struct_declaration* '}'
    ///     |   '{' visibility_specification struct_declaration+ '}'
    ///     |   '{' struct_declaration+ instance_variables '}'
    ///     |   '{' visibility_specification struct_declaration+ instance_variables '}'
    ///     ;
    ///
    /// visibility_specification
    ///     :   '@private'
    ///     |   '@protected'
    ///     |   '@package'
    ///     |   '@public'
    ///     ;
    /// ```
    public func parseIVarsList() throws {
        let node = context.pushContext(nodeType: IVarsList.self)
        defer {
            context.popContext()
        }
        
        try parseTokenNode(.openBrace)
        
        while !lexer.isEof && !lexer.tokenType(.closeBrace) {
            if lexer.tokenType(.keyword(.atPrivate)) {
                try parseKeyword(.atPrivate)
            } else if lexer.tokenType(.keyword(.atPublic)) {
                try parseKeyword(.atPublic)
            } else if lexer.tokenType(.keyword(.atProtected)) {
                try parseKeyword(.atProtected)
            } else if lexer.tokenType(.keyword(.atPackage)) {
                try parseKeyword(.atPackage)
            } else {
                try parseIVarDeclaration()
            }
        }
        
        try parseTokenNode(.closeBrace)
    }
    
    public func parseIVarDeclaration() throws {
        let node = context.pushContext(nodeType: IVarDeclaration.self)
        defer {
            context.popContext()
        }
        
        let range = startRange()
        
        // Type
        node.type = try asNodeRef(try parseTypeNameNode())
        
        // Name
        node.identifier = try asNodeRef(try parseIdentifierNode())
        
        // ;
        try parseTokenNode(.semicolon, onMissing: "Expected \(TokenType.semicolon) to end property declaration")
        
        node.location = range.makeLocation()
    }
    
    /// Parses a protocol conformance list at the current location
    /// Grammar:
    ///
    /// ```
    /// protocol_reference_list:
    ///    '<' protocol_list '>'
    ///
    /// protocol_list:
    ///    protocol_name (',' protocol_name)*
    ///
    /// protocol_name:
    ///    identifier
    /// ```
    public func parseProtocolReferenceList() throws {
        func parseProtocolName() throws {
            do {
                let identRange = startRange()
                let ident = try lexer.consume(tokenType: .identifier).string
                let node = ProtocolName(name: ident, location: identRange.makeLocation())
                
                context.addChildNode(node)
            } catch {
                diagnostics.error("Expected protocol name", location: location())
                throw error
            }
        }
        
        let node = ProtocolReferenceList()
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        _=_parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
                                   itemParser: parseProtocolName)
    }
    
    func parseSuperclassName() {
        do {
            let identRange = startRange()
            let ident = try lexer.consume(tokenType: .identifier)
            
            let node = SuperclassName(name: ident.string, location: identRange.makeLocation())
            
            context.addChildNode(node)
        } catch {
            diagnostics.error("Expected superclass name after ':'", location: location())
        }
    }
}
