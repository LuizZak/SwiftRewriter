import Antlr4

open class JavaScriptParserBase: Parser {
    func p(_ s: String) throws -> Bool {
        return try self.prev(s)
    }

    func prev(_ s: String) throws -> Bool {
        return try self._input.LT(-1)?.getText() == s
    }

    func n(_ s: String) throws -> Bool {
        return try self.next(s)
    }

    func next(_ s: String) throws -> Bool {
        return try self._input.LT(1)?.getText() == s
    }

    func notLineTerminator() throws -> Bool {
        return try !self.here(JavaScriptParser.Tokens.LineTerminator.rawValue)
    }

    func notOpenBraceAndNotFunction() throws -> Bool {
        let nextTokenType = try self._input.LT(1)?.getType()

        return nextTokenType != JavaScriptParser.Tokens.OpenBrace.rawValue && nextTokenType != JavaScriptParser.Tokens.Function_.rawValue
    }

    func closeBrace() throws -> Bool {
        return try self._input.LT(1)?.getType() == JavaScriptParser.Tokens.CloseBrace.rawValue
    }

    // Returns `true` iff on the current index of the parser's token stream a
    // token of the given `type` exists on the `HIDDEN` channel.
    // - param tokenType: the type of the token on the `HIDDEN` channel to check.
    // - returns: `true` iff on the current index of the parser's token stream a
    // token of the given `type` exists on the `HIDDEN` channel.
    func here(_ tokenType: Int) throws -> Bool {
        // Get the token ahead of the current index.
        let possibleIndexEosToken = try getCurrentToken().getTokenIndex() - 1
        let ahead = try _input.get(possibleIndexEosToken)

        // Check if the token resides on the HIDDEN channel and if it's of the
        // provided type.
        return (ahead.getChannel() == Lexer.HIDDEN) && (ahead.getType() == tokenType)
    }

    // Returns `true` iff on the current index of the parser's
    // token stream a token exists on the `HIDDEN` channel which
    // either is a line terminator, or is a multi line comment that
    // contains a line terminator.
    // 
    // - returns: `true` iff on the current index of the parser's
    // token stream a token exists on the `HIDDEN` channel which
    // either is a line terminator, or is a multi line comment that
    // contains a line terminator.
    func lineTerminatorAhead() throws -> Bool {
        // Get the token ahead of the current index.
        var possibleIndexEosToken: Int = try getCurrentToken().getTokenIndex() - 1
        var ahead: Token = try _input.get(possibleIndexEosToken)

        if ahead.getChannel() != Lexer.HIDDEN {
            // We're only interested in tokens on the HIDDEN channel.
            return false
        }

        if ahead.getType() == JavaScriptParser.Tokens.LineTerminator.rawValue {
            // There is definitely a line terminator ahead.
            return true
        }

        if ahead.getType() == JavaScriptParser.Tokens.WhiteSpaces.rawValue {
            // Get the token ahead of the current whitespaces.
            possibleIndexEosToken = try getCurrentToken().getTokenIndex() - 2
            ahead = try _input.get(possibleIndexEosToken)
        }

        // Get the token's text and type.
        let text = ahead.getText() ?? ""
        let tokenType = ahead.getType()

        // Check if the token is, or contains a line terminator.
        return (tokenType == JavaScriptParser.Tokens.MultiLineComment.rawValue && (text.contains("\r") || text.contains("\n")))
            || tokenType == JavaScriptParser.Tokens.LineTerminator.rawValue
    }
}
