import GrammarModels

public extension ObjcParser {
    
    func parsePropertyNode() throws {
        let prop = PropertyDefinition(type: .placeholder, identifier: .placeholder)
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
        prop.type = try asNodeRef(try parseTypeNameNode())
        
        // Name
        prop.identifier = try asNodeRef(try parseIdentifierNode())
        
        // ;
        try parseTokenNode(.semicolon, onMissing: "Expected \(TokenType.semicolon) to end property declaration")
        
        prop.location = range.makeLocation()
    }
    
    func parsePropertyModifiersListNode() throws {
        func parsePropertyModifier() throws {
            do {
                let range = startRange()
                let token = try lexer.consume(tokenType: .identifier)
                
                let node =
                    PropertyModifier(name: token.string, location: range.makeLocation())
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
