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
            try parseSuperclassNameNode()
        }
        
        // Protocol conformance list
        if lexer.tokenType(.operator(.lessThan)) {
            do {
                try parseProtocolReferenceListNode()
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
            }
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
        let node = context.pushContext(nodeType: ObjcClassInterface.IVarsList.self)
        defer {
            context.popContext()
        }
        
        try parseTokenNode(.openBrace)
        
        // TODO: Parse ivars list here
        while !lexer.isEof && !lexer.tokenType(.closeBrace) {
            lexer.skipToken()
        }
        
        try parseTokenNode(.closeBrace)
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
    public func parseProtocolReferenceListNode() throws {
        func parseProtocolName() throws {
            do {
                let identRange = startRange()
                let ident = try lexer.consume(tokenType: .identifier).string
                let node = ObjcClassInterface.ProtocolName(name: ident, location: identRange.makeLocation())
                
                context.addChildNode(node)
            } catch {
                diagnostics.error("Expected protocol name", location: location())
                throw error
            }
        }
        
        let node = ObjcClassInterface.ProtocolReferenceList()
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        _=_parseCommaSeparatedList(braces: .operator(.lessThan), .operator(.greaterThan),
                                   itemParser: parseProtocolName)
    }
    
    func parseSuperclassNameNode() throws {
        let identRange = startRange()
        let ident =
            try lexer.consume(tokenType: .identifier)
        
        let node = ObjcClassInterface.SuperclassName(name: ident.string, location: identRange.makeLocation())
        
        context.addChildNode(node)
    }
}
