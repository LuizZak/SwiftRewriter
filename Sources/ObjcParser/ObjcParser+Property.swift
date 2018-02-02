import GrammarModels

public extension ObjcParser {
    
    func parsePropertyNode() throws {
        let prop = PropertyDefinition()
        context.pushContext(node: prop)
        defer {
            context.popContext()
        }
        
        // @property [(<Modifiers>)] <Type> <Name>;
        
        // @property
        let range = startRange()
        try parseKeyword(.atProperty, onMissing: "Expected \(Keyword.atProperty) declaration")
        
        // Modifiers
        if lexer.tokenType(.openParens) {
            try parsePropertyModifiersListNode()
        }
        
        // Type
        context.addChildNode(try parseTypeNameNode())
        
        // Name
        context.addChildNode(try parseIdentifierNode())
        
        // ;
        try parseTokenNode(.semicolon, onMissing: "Expected \(TokenType.semicolon) to end property declaration")
        
        prop.location = range.makeLocation()
    }
    
    func parsePropertyModifiersListNode() throws {
        func parsePropertyModifier() throws {
            do {
                let range = startRange()
                let node: PropertyModifier
                
                if lexer.tokenType(.keyword(.getter)) {
                    // 'getter' '=' IDENT
                    try parseAnyKeyword()
                    
                    // '='
                    try parseTokenNode(.operator(.assign))
                    
                    // IDENT
                    let id = try parseIdentifierNode()
                    
                    node = PropertyModifier(getter: id.name, location: range.makeLocation())
                } else if lexer.tokenType(.keyword(.setter)) {
                    // 'setter' '=' IDENT ':'
                    try parseAnyKeyword()
                    
                    // '='
                    try parseTokenNode(.operator(.assign))
                    
                    // IDENT
                    let id = try parseIdentifierNode()
                    
                    // ':'
                    try parseTokenNode(.colon, onMissing: "Expected a setter selector")
                    
                    node = PropertyModifier(setter: id.name, location: range.makeLocation())
                } else {
                    let token = try lexer.consume(tokenType: .identifier)
                    
                    node = PropertyModifier(name: token.string, location: range.makeLocation())
                }
                
                context.addChildNode(node)
            } catch {
                diagnostics.error("Expected a property modifier", location: location())
                throw error
            }
        }
        
        let node = context.pushContext(nodeType: PropertyModifierList.self)
        defer {
            context.popContext()
        }
        
        _=_parseCommaSeparatedList(braces: .openParens, .closeParens, itemParser: parsePropertyModifier)
    }
}
