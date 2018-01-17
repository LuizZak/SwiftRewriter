import MiniLexer

extension Lexer {
    /// Lexes an identifier token with the following grammar:
    ///
    /// ```
    /// ident:
    ///   LETTER (LETTER | 0-9)*
    /// ```
    @inline(__always)
    public func lexIdentifier() throws -> Substring {
        return try consumeString { lexer in
            try lexer.advance(validatingCurrent: Lexer.isIdentifierLetter)
            
            lexer.advance(while: { Lexer.isIdentifierLetter($0) || Lexer.isDigit($0) })
        }
    }
    
    /// `HEX_LITERAL : '0' ('x'|'X') HexDigit+ IntegerTypeSuffix? ;`
    public func lexHexLiteral() throws -> Substring {
        return try consumeString { lexer in
            try lexer.advance(expectingCurrent: "0")
            try lexer.advance(validatingCurrent: { $0 == "x" || $0 == "X" })
            
            lexer.advance(while: Lexer.isHexDigit)
            
            try? rewindOnFailure {
                try lexer.fragmentIntegerTypeSuffix()
            }
        }
    }
    
    /// `DECIMAL_LITERAL : ('0' | '1'..'9' '0'..'9'*) IntegerTypeSuffix? ;`
    public func lexDecimalLiteral() throws -> Substring {
        return try consumeString { lexer in
            if lexer.safeIsNextChar(equalTo: "0") {
                try lexer.advance()
                return
            }
            
            lexer.advance(while: Lexer.isDigit)
            
            try? rewindOnFailure {
                try lexer.fragmentIntegerTypeSuffix()
            }
        }
    }
    
    /// `OCTAL_LITERAL : '0' ('0'..'7')+ IntegerTypeSuffix? ;`
    public func lexOctalLiteral() throws -> Substring {
        return try consumeString { lexer in
            try lexer.advance(expectingCurrent: "0")
            
            lexer.advance(while: { $0 >= "0" && $0 <= "7" })
            
            try? rewindOnFailure {
                try lexer.fragmentIntegerTypeSuffix()
            }
        }
    }
    
    /// ```
    /// FLOATING_POINT_LITERAL
    ///     :   ('0'..'9')+ ('.' ('0'..'9')*)? Exponent? FloatTypeSuffix?
    /// 	;
    /// ```
    public func lexFloatingPointLiteral() throws -> Substring {
        return try consumeString { lexer in
            try lexer.advance(validatingCurrent: Lexer.isDigit)
            if lexer.isEof() {
                return
            }
            
            if lexer.safeIsNextChar(equalTo: ".") {
                try lexer.advance()
                try lexer.advance(validatingCurrent: Lexer.isDigit)
                lexer.advance(while: Lexer.isDigit)
            }
            
            if lexer.safeIsNextChar(equalTo: "e") || lexer.safeIsNextChar(equalTo: "E") {
                try lexer.fragmentExponent()
            }
            
            try? lexer.rewindOnFailure {
                try lexer.fragmentExponent()
            }
        }
    }
    
    /// `CHARACTER_LITERAL : '\'' ( EscapeSequence | ~('\''|'\\') ) '\''`
    public func lexFragmentLiteral() throws -> Substring {
        return try consumeString { lexer in
            try lexer.advance(expectingCurrent: "\'")
            
            if lexer.safeIsNextChar(equalTo: "\\") {
                try lexer.fragmentEscapeSequence()
            } else {
                try lexer.advance(validatingCurrent: { $0 != "\\" })
            }
            
            try lexer.advance(expectingCurrent: "\'")
        }
    }
    
    /// `STRING_LITERAL : ['L'] STRING`
    public func lexStringLiteral() throws -> Substring {
        return try consumeString { lexer in
            let p = try lexer.peek()
            if p == "L" || p == "@" {
                try lexer.advance()
            }
            
            try fragmentString()
        }
    }
    
    /// `INCLUDE : '#include' .* [\r\n]`
    public func lexInclude() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#pragma")
    }
    
    /// `PRAGMA : '#pragma' .* [\r\n]`
    public func lexPragma() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#pragma")
    }
    
    /// `COMMENT : /* .* */`
    public func lexComment() throws -> Substring {
        return try consumeString { lexer in
            try lexer.expect(match: "/*")
            
            while !lexer.isEof(offsetBy: 1) {
                if try lexer.peek() == "*" && lexer.peekForward() == "/" {
                    return
                }
                
                try lexer.advance()
            }
            
            throw LexerError.syntaxError("Expected end of comment block before end of file")
        }
    }
    
    /// `LINE_COMMENT : '//' .* [\r\n]`
    public func lexLineComment() throws -> Substring {
        return try _lexFromTokenToEndOfLine("//")
    }
    
    /// `HDEFINE : '#define' .* [\r\n]`
    public func lexHDefine() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#define")
    }
    
    /// `HIF : '#if' .* [\r\n]`
    public func lexHIf() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#if")
    }
    
    /// `HELSE : '#else' .* [\r\n]`
    public func lexHElse() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#else")
    }
    
    /// `HUNDEF : '#undef' .* [\r\n]`
    public func lexHUndef() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#undef")
    }
    
    /// `HIFNDEF : '#ifndef' .* [\r\n]`
    public func lexHIfndef() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#ifndef")
    }
    
    /// `HENDIF : '#endif' .* [\r\n]`
    public func lexHEndIf() throws -> Substring {
        return try _lexFromTokenToEndOfLine("#endif")
    }
    
    private func _lexFromTokenToEndOfLine(_ token: String) throws -> Substring {
        return try consumeString { lexer in
            try lexer.expect(match: token)
            lexer.advance(until: { $0 == "\n" || $0 == "\r" })
            
            if lexer.isEof() {
                return
            }
            
            try lexer.advance() // Skip past line feed
        }
    }
    
    /// Returns true if the character is an identifier letter character.
    ///
    /// ```
    /// LETTER:
    ///   [$_a-zA-Z]
    /// ```
    public static func isIdentifierLetter(_ atom: Atom) -> Bool {
        return Lexer.isLetter(atom) || atom == "_" || atom == "$"
    }
    
    /// Returns true if the character is a hexadecimal digit character.
    ///
    /// ```
    /// HexDigit:
    ///   [0-9a-fA-F]
    /// ```
    public static func isHexDigit(_ atom: Atom) -> Bool {
        return Lexer.isDigit(atom) || (atom >= "a" && atom <= "f") || (atom >= "A" && atom <= "F")
    }
}

// MARK: Fragment-style lexing
// Fragments don't return strings, they simply consume the input string while
// enforcing their grammatical rules
public extension Lexer {
    
    /// `HexDigit : ('0'..'9'|'a'..'f'|'A'..'F') ;`
    public func fragmentHexDigit() throws {
        try advance(validatingCurrent: Lexer.isHexDigit)
    }
    
    /// ```
    /// fragment
    /// IntegerTypeSuffix
    ///     :           ('u'|'U'|'l'|'L')
    ///     ;
    /// ```
    public func fragmentIntegerTypeSuffix() throws {
        try advance(validatingCurrent: { (atom: Atom) -> Bool in atom == "u" || atom == "U" || atom == "l" || atom == "L" })
    }
    
    /// `LETTER : '$' | 'A'..'Z' | 'a'..'z' | '_' ;`
    public func fragmentLetter() throws {
        try advance(validatingCurrent: Lexer.isIdentifierLetter)
    }
    
    /// `STRING : '"' ( EscapeSequence | ~('\\'|'"') )* '"' ;`
    public func fragmentString() throws {
        try advance(expectingCurrent: "\"")
        
        while !isEof() {
            // Escape sequence
            let p = try peek()
            if p == "\\" {
                try fragmentEscapeSequence()
            } else if p == "\"" {
                break
            }
        }
        
        try advance(expectingCurrent: "\"")
    }
    
    /// ```
    /// fragment
    /// Exponent : ('e'|'E') ('+'|'-')? ('0'..'9')+ ;
    /// ```
    public func fragmentExponent() throws {
        try advance(validatingCurrent: { $0 == "e" || $0 == "E" })
        if try peek() == "+" || peek() == "-" {
            try advance()
        }
        try advance(validatingCurrent: Lexer.isDigit)
        advance(while: Lexer.isDigit)
    }
    
    /// ```
    /// fragment
    /// FloatTypeSuffix : ('f'|'F'|'d'|'D') ;
    /// ```
    public func fragmentFloatTypeSuffix() throws {
        try advance(validatingCurrent: { (atom: Atom) -> Bool in atom == "f" || atom == "F" || atom == "d" || atom == "D" })
    }
    
    /// ```
    /// fragment
    /// EscapeSequence
    ///     :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    ///     |   OctalEscape
    ///     ;
    ///
    /// fragment
    /// OctalEscape
    ///     :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    ///     |   '\\' ('0'..'7') ('0'..'7')
    ///     |   '\\' ('0'..'7')
    ///     ;
    /// ```
    public func fragmentEscapeSequence() throws {
        try advance(expectingCurrent: "\\")
        let p = try peek()
        // \b \t \n \f \r \" \' \\
        if ["b", "t", "n", "f", "r", "\"", "\'", "\\"].contains(p) {
            try advance()
            return
        }
        
        // TODO: Parse octal strings
        throw LexerError.syntaxError("Parsing octal escape sequences in strings are not yet supported. See \(#file) line \(#line)")
    }
    
    /// `ANGLE_STRING : '<' .* '>'`
    public func fragmentAngleString() throws {
        try advance(expectingCurrent: "<")
        advance(while: { $0 != ">" })
        try advance(expectingCurrent: ">")
    }
}
