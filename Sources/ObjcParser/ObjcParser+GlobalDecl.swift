import MiniLexer
import GrammarModels

public extension ObjcParser {
    /// Parses a global function or variable declaration.
    ///
    /// ```
    /// global_declaration: declaration;
    /// ```
    func parseGlobalDeclaration() throws {
        try parseDeclaration()
    }
    
    /// Parses a declaration at the current location.
    ///
    /// ```
    /// declaration
    ///     : function_declaration
    ///     | variable_declaration
    ///     ;
    /// ```
    func parseDeclaration() throws {
        do {
            // Attempt to parse a function definition, fallback to a variable definition
            // if not possible.
            try lexer.rewindOnFailure {
                try parseFunctionDeclaration()
            }
        } catch {
            try lexer.rewindOnFailure {
                try parseVariableDeclaration()
            }
        }
    }
    
    /// Parses a variable declaration at the current location.
    ///
    /// ```
    /// variable_declaration : objc_type IDENTIFIER initial_expr? ';' ;
    /// ```
    func parseVariableDeclaration() throws {
        context.pushContext(nodeType: VariableDeclaration.self)
        defer {
            context.popContext()
        }
        
        context.addChildNode(try parseTypeNameNode())
        
        do {
            context.addChildNode(try parseIdentifierNode(onMissing: "Expected identifier for global definition"))
        } catch {
            // Panic until we're done
            lexer.advance(until: { $0.type == .semicolon || $0.type == .operator(.assign) })
        }
        
        if lexer.tokenType(.operator(.assign)) {
            try parseInitialExpression()
        }
        
        if lexer.tokenType(.semicolon) {
            parseAnyTokenNode()
        } else {
            diagnostics.error("Expected either \(TokenType.semicolon) after global variable definition.",
                              location: location())
        }
    }
    
    /// Parses a global initial constant initial expression at the current point.
    ///
    /// ```
    /// initial_expr:
    ///     '=' constant_expr ;
    ///
    /// constant_expr
    ///     : decimal_literal
    ///     | float_literal
    ///     | hex_literal
    ///     | octal_literal
    ///     | string_literal
    ///     ;
    /// ```
    func parseInitialExpression() throws {
        context.pushContext(nodeType: InitialExpression.self)
        defer {
            context.popContext()
        }
        
        try parseTokenNode(.operator(.assign))
        
        let range = startRange()
        
        if lexer.tokenType(.decimalLiteral) || lexer.tokenType(.stringLiteral) ||
            lexer.tokenType(.octalLiteral) || lexer.tokenType(.floatLiteral) ||
            lexer.tokenType(.hexLiteral) {
            
            parseAnyTokenNode()
            
            let node =
                ConstantExpression(expression: range.makeString(), location: range.makeLocation(),
                                   existsInSource: true)
            
            context.addChildNode(node)
        } else {
            diagnostics.error("Expected initial expression after \(Operator.assign)",
                              location: location())
        }
    }
    
    /// Parses a function declaration at the current location.
    ///
    /// ```
    /// function_declaration:
    ///     objc_type IDENTIFIER function_parameters (function_body | ';') ;
    ///
    /// function_parameters : '(' parameter_list? ')' ;
    /// ```
    func parseFunctionDeclaration() throws {
        let node = context.pushContext(nodeType: FunctionDefinition.self)
        defer {
            context.popContext()
        }
        
        context.addChildNode(try parseTypeNameNode())
        try? context.addChildNode(parseIdentifierNode(onMissing: "Expected identifier for function name"))
        
        try parseTokenNode(.openParens)
        
        if !lexer.tokenType(.closeParens) {
            try parseFunctionParameterList()
        }
        
        try parseTokenNode(.closeParens)
        
        if lexer.tokenType(.openBrace) {
            node.methodBody = try parseFunctionBody()
        } else if lexer.tokenType(.semicolon) {
            parseAnyTokenNode()
        } else {
            diagnostics.error("Expected either function body or \(TokenType.semicolon) after function definition.",
                              location: location())
        }
    }
    
    /// Parses a function parameter list at the current location.
    ///
    /// ```
    /// parameter_list : function_parameter (',' function_parameter)*  (',' '...')? ;
    /// ```
    func parseFunctionParameterList() throws {
        context.pushContext(nodeType: ParameterList.self)
        defer {
            context.popContext()
        }
        
        var afterComma: Bool
        repeat {
            afterComma = false
            
            // Variadic parameters
            if afterComma && lexer.tokenType(.ellipsis) {
                context.pushContext(nodeType: VariadicParameter.self)
                parseAnyTokenNode()
                context.popContext()
                
                if lexer.tokenType(.closeParens) {
                    break
                } else {
                    diagnostics.error("Expected end of parameters list after variadic parameter.",
                                      location: location())
                }
            } else if !afterComma && lexer.tokenType(.ellipsis) {
                diagnostics.error("Expected at least one parameter before start of variadics parameters list.",
                                  location: location())
            } else {
                try parseFunctionParameter()
            }
            
            if lexer.tokenType(.comma) {
                parseAnyTokenNode()
                afterComma = true
            }
        } while !lexer.tokenType(.closeParens)
        
        if afterComma {
            diagnostics.error("Expected function parameter after comma", location: location())
        }
    }
    
    /// Parses a function parameter at the current location.
    ///
    /// ```
    /// function_parameter : objc_type IDENTIFIER ;
    /// ```
    func parseFunctionParameter() throws {
        context.pushContext(nodeType: FunctionParameter.self)
        defer {
            context.popContext()
        }
        
        
    }
}
