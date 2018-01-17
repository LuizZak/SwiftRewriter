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
        
        lexer.skipWhitespace()
        
        // Consume @interface
        try parseKeyword("@interface", onMissing: "Expected @interface to start class declaration")
        
        // Class name
        classNode.identifier = .valid(try parseIdentifierNode())
        lexer.skipWhitespace()
        
        // Super class name
        if try lexer.peek() == ":" {
            // Record ':'
            try parseTokenNode(":")
            
            // Record superclass name
            try parseSuperclassNameNode()
            
            lexer.skipWhitespace()
        }
        
        // Protocol conformance list
        if try lexer.peek() == "<" {
            do {
                try parseProtocolReferenceListNode()
            } catch {
                // Panic!
                lexer.skipWhitespace()
            }
            
            lexer.skipWhitespace()
        }
        
        // Consume interface declarations
        _=lexer.performGreedyRounds { (lexer, _) -> Bool in
            var isEnd = false
            
            lexer.skipWhitespace()
            
            try lexer.matchFirst(withEither: { lexer in
                try self.parseKeyword("@end", onMissing: "Expected @end to end class declaration")
                
                isEnd = true
            }, { _ in
                try self.parsePropertyNode()
            })
            
            return !isEnd
        }
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
        func parseProtocolName() throws -> String {
            do {
                return String(try lexer.lexIdentifier())
            } catch {
                diagnostics.error("Expected protocol name", location: location())
                throw error
            }
        }
        
        let node = ObjcClassInterface.ProtocolReferenceList(protocols: [])
        context.pushContext(node: node)
        defer {
            context.popContext()
        }
        
        let protocols =
            try _parseCommaSeparatedList(braces: "<", ">",
                                         itemParser: parseProtocolName)
        
        node.protocols = protocols
    }
    
    func parsePropertyNode() throws {
        let prop = ObjcClassInterface.Property(type: .placeholder, identifier: .placeholder)
        context.pushContext(node: prop)
        defer {
            context.popContext()
        }
        
        // @property [(<Modifiers>)] <Type> <Name>;
        lexer.skipWhitespace()
        
        // @property
        let range = startRange()
        try parseKeyword("@property", onMissing: "Expected @property declaration")
        lexer.skipWhitespace()
        
        // Modifiers
        if lexer.safeIsNextChar(equalTo: "(") {
            try parsePropertyModifiersListNode()
            lexer.skipWhitespace()
        }
        
        // Type
        prop.type = try asNodeRef(try parseTypeNameNode(), onPanic: {
            lexer.advance(until: { Lexer.isIdentifierLetter($0) || $0 == ";" || $0 == "@" })
        })
        
        lexer.skipWhitespace()
        
        // Name
        prop.identifier = try asNodeRef(try parseIdentifierNode(), onPanic: {
            lexer.advance(until: { $0 == ";" || $0 == "@" })
        })
        
        // ;
        try parseTokenNode(";", onMissing: "Expected ';' to end property declaration")
        
        prop.location = range.makeRange()
    }
    
    func parsePropertyModifiersListNode() throws {
        func parsePropertyModifier() throws {
            let range = startRange()
            let name = try lexer.lexIdentifier()
            
            let node = ObjcClassInterface.PropertyModifier(name: String(name), location: range.makeRange())
            context.addChildNode(node)
        }
        
        let node = context.pushContext(nodeType: ObjcClassInterface.PropertyModifierList.self)
        defer {
            context.popContext()
        }
        
        try parseTokenNode("(")
        
        var expectsItem = true
        while !lexer.isEof() {
            lexer.skipWhitespace()
            
            if lexer.safeIsNextChar(equalTo: ")") {
                break
            }
            
            expectsItem = false
            
            if lexer.safeIsNextChar(equalTo: ",") {
                try parseTokenNode(",")
                expectsItem = true
                continue
            }
            
            try parsePropertyModifier()
        }
        
        // Closed list after comma
        if expectsItem {
            diagnostics.error("Expected modifier parameter after comma", location: location())
            // Panic and end list here
            lexer.skipWhitespace()
        }
        
        try parseTokenNode(")")
    }
    
    func parseSuperclassNameNode() throws {
        lexer.skipWhitespace()
        
        let identRange = startRange()
        let ident = try lexer.lexIdentifier()
        let node = ObjcClassInterface.SuperclassName(name: String(ident), location: identRange.makeRange())
        
        context.addChildNode(node)
    }
}
