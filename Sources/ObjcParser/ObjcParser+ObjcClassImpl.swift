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
    ///
    /// property_implementation
    ///     : '@synthesize' property_synthesize_list ';'
    ///     | '@dynamic' property_synthesize_list ';'
    ///     ;
    ///
    /// property_synthesize_list
    ///     : property_synthesize_item (',' property_synthesize_item)*
    ///     ;
    ///
    /// property_synthesize_item
    ///     : IDENTIFIER | IDENTIFIER '=' IDENTIFIER
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
                try self.parseMethodDeclaration()
            } else {
                diagnostics.error("Expected an ivar list, @synthesize/@dynamic, or method(s) definitions(s) in class", location: location())
                lexer.advance(until: { $0.type == .keyword(.atEnd) })
                break
            }
        }
        
        try self.parseKeyword(.atEnd, onMissing: "Expected \(Keyword.atEnd) to end class definition")
    }
}
