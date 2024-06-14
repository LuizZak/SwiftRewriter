import Antlr4

open class JavaScriptLexerBase: Lexer {
    private let DEFAULT_CHANNEL: Int = 0
    private let HIDDEN_CHANNEL: Int = 1

    /**
     * Stores values of nested modes. By default mode is strict or
     * defined externally (_useStrictDefault)
     */
    private var _scopeStrictModes: [Bool] = []

    private var _lastToken: Token? = nil
    /**
     * Default value of strict mode
     * Can be defined externally by setUseStrictDefault
     */
    private var _useStrictDefault: Bool = false
    /**
     * Current value of strict mode
     * Can be defined during parsing, see StringFunctions.js and StringGlobal.js samples
     */
    private var _useStrictCurrent: Bool = false
    /**
     * Keeps track of the the current depth of nested template string backticks.
     * E.g. after the X in:
     *
     * `${a ? `${X
     *
     * _templateDepth will be 2. This variable is needed to determine if a `}` is a
     * plain CloseBrace, or one that closes an expression inside a template string.
     */
    private var _templateDepth: Int = 0

    public func isStartOfFile() -> Bool {
        return _lastToken == nil
    }

    public func getStrictDefault() -> Bool {
        return _useStrictDefault
    }

    public func setUseStrictDefault(_ value: Bool) {
        _useStrictDefault = value
        _useStrictCurrent = value
    }

    public func isStrictMode() -> Bool {
        return _useStrictCurrent
    }

    public func isInTemplateString() -> Bool {
        return self._templateDepth > 0
    }

    /**
     * Return the next token from the character stream and records this last
     * token in case it resides on the default channel. This recorded token
     * is used to determine when the lexer could possibly match a regex
     * literal. Also changes _scopeStrictModes stack if tokenize special
     * string 'use strict'
     *
     * @return the next token from the character stream.
     */
    public override func nextToken() throws -> Token {
        let next = try super.nextToken()
        
        if next.getChannel() == DEFAULT_CHANNEL {
            // Keep track of the last token on the default channel.
            self._lastToken = next
        }

        return next
    }

    func processOpenBrace() {
        _useStrictCurrent = _scopeStrictModes.last == true ? true : _useStrictDefault
        _scopeStrictModes.append(_useStrictCurrent)
    }

    func processCloseBrace() {
        _useStrictCurrent = _scopeStrictModes.popLast() ?? _useStrictDefault
    }

    func processStringLiteral() {
        guard (_lastToken == nil || _lastToken?.getType() == JavaScriptLexer.OpenBrace) else {
            return
        }

        let text = getText()
        if text == "\"use strict\"" || text == "'use strict'" {
            if !_scopeStrictModes.isEmpty {
                _scopeStrictModes.removeLast()
            }

            _useStrictCurrent = true
            _scopeStrictModes.append(_useStrictCurrent)
        }
    }

    public func increaseTemplateDepth() {
        self._templateDepth += 1
    }

    public func decreaseTemplateDepth() {
        self._templateDepth -= 1
    }

    /**
     * Returns {@code true} if the lexer can match a regex literal.
     */
    func isRegexPossible() -> Bool {
        if self._lastToken == nil {
            // No token has been produced yet: at the start of the input,
            // no division is possible, so a regex literal _is_ possible.
            return true
        }

        guard let tokenType = self._lastToken?.getType() else {
            return true
        }

        switch tokenType {
            case JavaScriptLexer.Identifier,
                 JavaScriptLexer.NullLiteral,
                 JavaScriptLexer.BooleanLiteral,
                 JavaScriptLexer.This,
                 JavaScriptLexer.CloseBracket,
                 JavaScriptLexer.CloseParen,
                 JavaScriptLexer.OctalIntegerLiteral,
                 JavaScriptLexer.DecimalLiteral,
                 JavaScriptLexer.HexIntegerLiteral,
                 JavaScriptLexer.StringLiteral,
                 JavaScriptLexer.PlusPlus,
                 JavaScriptLexer.MinusMinus:
                // After any of the tokens above, no regex literal can follow.
                return false
            default:
                // In all other cases, a regex literal _is_ possible.
                return true
        }
    }
}
