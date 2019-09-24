import MiniLexer

extension Lexer {
    /// Lexes a token with the following grammar:
    ///
    /// ```
    /// type_qualifier
    ///         : 'extern' | 'static' | 'const' | 'volatile' | 'unsigned' | 'signed'
    ///         | '_Nonnull' | '_Nullable' | 'nonnull' | 'nullable' | 'null_unspecified'
    ///         | 'null_resettable' | '__weak' | '__strong' | '__kindof' | '__block'
    ///         | '__unused';
    /// ```
    @inlinable
    public func lexTypeQualifier() throws -> Substring {
        try consumeString { lexer in
            if !lexer.advanceIf(equals: "extern") &&
                !lexer.advanceIf(equals: "static") &&
                !lexer.advanceIf(equals: "const") &&
                !lexer.advanceIf(equals: "volatile") &&
                !lexer.advanceIf(equals: "signed") &&
                !lexer.advanceIf(equals: "unsigned") &&
                !lexer.advanceIf(equals: "_Nonnull") &&
                !lexer.advanceIf(equals: "_Nullable") &&
                !lexer.advanceIf(equals: "nonnull") &&
                !lexer.advanceIf(equals: "nullable") &&
                !lexer.advanceIf(equals: "null_unspecified") &&
                !lexer.advanceIf(equals: "null_resettable") &&
                !lexer.advanceIf(equals: "__weak") &&
                !lexer.advanceIf(equals: "__strong") &&
                !lexer.advanceIf(equals: "__kindof") &&
                !lexer.advanceIf(equals: "__block") &&
                !lexer.advanceIf(equals: "__unused") {
                throw syntaxError("Expected type qualifier")
            }
        }
    }
    
    /// Lexes an identifier token with the following grammar:
    ///
    /// ```
    /// ident:
    ///   LETTER (LETTER | 0-9)*
    /// ```
    @inlinable
    public func lexIdentifier() throws -> Substring {
        try consumeString { lexer in
            try lexer.advance(validatingCurrent: Lexer.isIdentifierLetter)
            
            lexer.advance(while: { Lexer.isIdentifierLetter($0) || Lexer.isDigit($0) })
        }
    }
    
    /// Returns whether a given string represents a type qualifier.
    ///
    /// ```
    /// type_qualifier
    ///         : 'extern' | 'static' | 'const' | 'volatile' | 'unsigned' | 'signed'
    ///         | '_Nonnull' | '_Nullable' | 'nonnull' | 'nullable' | 'null_unspecified'
    ///         | 'null_resettable' | '__weak' | '__strong' | '__kindof' | '__block'
    ///         | '__unused';
    /// ```
    public static func isTypeQualifier(_ string: String) -> Bool {
        _typeQualifiers.contains(string)
    }
    
    /// Returns true if the character is an identifier letter character.
    ///
    /// ```
    /// LETTER:
    ///   [$_a-zA-Z]
    /// ```
    @inlinable
    public static func isIdentifierLetter(_ atom: Atom) -> Bool {
        Lexer.isLetter(atom) || atom == "_" || atom == "$"
    }
    
    private static let _typeQualifiers = [
        "extern", "static", "const", "volatile", "unsigned", "signed", "_Nonnull",
        "_Nullable", "nonnull", "nullable", "null_unspecified", "null_resettable",
        "__weak", "__strong", "__kindof", "__block", "__unused"
    ]
}
