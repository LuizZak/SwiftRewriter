// Generated from java-escape by ANTLR 4.11.1
import Antlr4

open class ObjectiveCPreprocessorParser: Parser {

    public class State {
        public let _ATN: ATN = try! ATNDeserializer().deserialize(_serializedATN)
        internal var _decisionToDFA: [DFA]
        internal let _sharedContextCache: PredictionContextCache = PredictionContextCache()
        public init() {
            var decisionToDFA = [DFA]()
            let length = _ATN.getNumberOfDecisions()
            for i in 0..<length { decisionToDFA.append(DFA(_ATN.getDecisionState(i)!, i)) }
            _decisionToDFA = decisionToDFA
        }
    }

    public var _ATN: ATN { return state._ATN }

    internal var _decisionToDFA: [DFA] { return state._decisionToDFA }

    internal var _sharedContextCache: PredictionContextCache { return state._sharedContextCache }

    public var state: State

    public enum Tokens: Int {
        case EOF = -1
        case SHARP = 1
        case CODE = 2
        case IMPORT = 3
        case INCLUDE = 4
        case PRAGMA = 5
        case DEFINE = 6
        case DEFINED = 7
        case IF = 8
        case ELIF = 9
        case ELSE = 10
        case UNDEF = 11
        case IFDEF = 12
        case IFNDEF = 13
        case ENDIF = 14
        case TRUE = 15
        case FALSE = 16
        case ERROR = 17
        case WARNING = 18
        case BANG = 19
        case LPAREN = 20
        case RPAREN = 21
        case EQUAL = 22
        case NOTEQUAL = 23
        case AND = 24
        case OR = 25
        case LT = 26
        case GT = 27
        case LE = 28
        case GE = 29
        case DIRECTIVE_WHITESPACES = 30
        case DIRECTIVE_STRING = 31
        case CONDITIONAL_SYMBOL = 32
        case DECIMAL_LITERAL = 33
        case FLOAT = 34
        case NEW_LINE = 35
        case DIRECITVE_COMMENT = 36
        case DIRECITVE_LINE_COMMENT = 37
        case DIRECITVE_NEW_LINE = 38
        case DIRECITVE_TEXT_NEW_LINE = 39
        case TEXT = 40
        case SLASH = 41
    }

    public static let RULE_objectiveCDocument = 0, RULE_text = 1, RULE_code = 2, RULE_directive = 3,
        RULE_directive_text = 4, RULE_preprocessor_expression = 5

    public static let ruleNames: [String] = [
        "objectiveCDocument", "text", "code", "directive", "directive_text",
        "preprocessor_expression",
    ]

    private static let _LITERAL_NAMES: [String?] = [
        nil, "'#'", nil, nil, nil, "'pragma'", nil, "'defined'", "'if'", "'elif'", "'else'",
        "'undef'", "'ifdef'", "'ifndef'", "'endif'", nil, nil, "'error'", "'warning'", "'!'", "'('",
        "')'", "'=='", "'!='", "'&&'", "'||'", "'<'", "'>'", "'<='", "'>='",
    ]
    private static let _SYMBOLIC_NAMES: [String?] = [
        nil, "SHARP", "CODE", "IMPORT", "INCLUDE", "PRAGMA", "DEFINE", "DEFINED", "IF", "ELIF",
        "ELSE", "UNDEF", "IFDEF", "IFNDEF", "ENDIF", "TRUE", "FALSE", "ERROR", "WARNING", "BANG",
        "LPAREN", "RPAREN", "EQUAL", "NOTEQUAL", "AND", "OR", "LT", "GT", "LE", "GE",
        "DIRECTIVE_WHITESPACES", "DIRECTIVE_STRING", "CONDITIONAL_SYMBOL", "DECIMAL_LITERAL",
        "FLOAT", "NEW_LINE", "DIRECITVE_COMMENT", "DIRECITVE_LINE_COMMENT", "DIRECITVE_NEW_LINE",
        "DIRECITVE_TEXT_NEW_LINE", "TEXT", "SLASH",
    ]
    public static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

    override open func getGrammarFileName() -> String { return "java-escape" }

    override open func getRuleNames() -> [String] { return ObjectiveCPreprocessorParser.ruleNames }

    override open func getSerializedATN() -> [Int] {
        return ObjectiveCPreprocessorParser._serializedATN
    }

    override open func getATN() -> ATN { return _ATN }

    override open func getVocabulary() -> Vocabulary {
        return ObjectiveCPreprocessorParser.VOCABULARY
    }

    override public convenience init(_ input: TokenStream) throws { try self.init(input, State()) }

    public required init(_ input: TokenStream, _ state: State) throws {
        self.state = state

        RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
        try super.init(input)
        _interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
    }

    public class ObjectiveCDocumentContext: ParserRuleContext {
        open func EOF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue, 0)
        }
        open func text() -> [TextContext] { return getRuleContexts(TextContext.self) }
        open func text(_ i: Int) -> TextContext? { return getRuleContext(TextContext.self, i) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCPreprocessorParser.RULE_objectiveCDocument
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterObjectiveCDocument(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitObjectiveCDocument(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitObjectiveCDocument(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitObjectiveCDocument(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func objectiveCDocument() throws -> ObjectiveCDocumentContext {
        var _localctx: ObjectiveCDocumentContext
        _localctx = ObjectiveCDocumentContext(_ctx, getState())
        try enterRule(_localctx, 0, ObjectiveCPreprocessorParser.RULE_objectiveCDocument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(15)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue
                || _la == ObjectiveCPreprocessorParser.Tokens.CODE.rawValue
            {
                setState(12)
                try text()

                setState(17)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(18)
            try match(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TextContext: ParserRuleContext {
        open func code() -> CodeContext? { return getRuleContext(CodeContext.self, 0) }
        open func SHARP() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue, 0)
        }
        open func directive() -> DirectiveContext? {
            return getRuleContext(DirectiveContext.self, 0)
        }
        open func NEW_LINE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.NEW_LINE.rawValue, 0)
        }
        open func EOF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_text }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterText(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitText(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitText(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitText(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func text() throws -> TextContext {
        var _localctx: TextContext
        _localctx = TextContext(_ctx, getState())
        try enterRule(_localctx, 2, ObjectiveCPreprocessorParser.RULE_text)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(25)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .CODE:
                try enterOuterAlt(_localctx, 1)
                setState(20)
                try code()

                break

            case .SHARP:
                try enterOuterAlt(_localctx, 2)
                setState(21)
                try match(ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue)
                setState(22)
                try directive()
                setState(23)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCPreprocessorParser.Tokens.EOF.rawValue
                    || _la == ObjectiveCPreprocessorParser.Tokens.NEW_LINE.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }

                break
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CodeContext: ParserRuleContext {
        open func CODE() -> [TerminalNode] {
            return getTokens(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue)
        }
        open func CODE(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_code }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterCode(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitCode(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitCode(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitCode(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func code() throws -> CodeContext {
        var _localctx: CodeContext
        _localctx = CodeContext(_ctx, getState())
        try enterRule(_localctx, 4, ObjectiveCPreprocessorParser.RULE_code)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(28)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(27)
                    try match(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(30)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 2, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DirectiveContext: ParserRuleContext {
        override open func getRuleIndex() -> Int {
            return ObjectiveCPreprocessorParser.RULE_directive
        }
    }
    public class PreprocessorDefContext: DirectiveContext {
        open func IFDEF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.IFDEF.rawValue, 0)
        }
        open func CONDITIONAL_SYMBOL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0)
        }
        open func IFNDEF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.IFNDEF.rawValue, 0)
        }
        open func UNDEF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.UNDEF.rawValue, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorDef(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorDef(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorDef(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorDef(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorErrorContext: DirectiveContext {
        open func ERROR() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.ERROR.rawValue, 0)
        }
        open func directive_text() -> Directive_textContext? {
            return getRuleContext(Directive_textContext.self, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorError(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorError(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorError(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorError(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorConditionalContext: DirectiveContext {
        open func IF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.IF.rawValue, 0)
        }
        open func preprocessor_expression() -> Preprocessor_expressionContext? {
            return getRuleContext(Preprocessor_expressionContext.self, 0)
        }
        open func ELIF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.ELIF.rawValue, 0)
        }
        open func ELSE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.ELSE.rawValue, 0)
        }
        open func ENDIF() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.ENDIF.rawValue, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorConditional(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorConditional(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorConditional(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorConditional(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorImportContext: DirectiveContext {
        open func directive_text() -> Directive_textContext? {
            return getRuleContext(Directive_textContext.self, 0)
        }
        open func IMPORT() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.IMPORT.rawValue, 0)
        }
        open func INCLUDE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.INCLUDE.rawValue, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorImport(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorImport(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorImport(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorImport(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorPragmaContext: DirectiveContext {
        open func PRAGMA() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.PRAGMA.rawValue, 0)
        }
        open func directive_text() -> Directive_textContext? {
            return getRuleContext(Directive_textContext.self, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorPragma(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorPragma(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorPragma(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorPragma(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorDefineContext: DirectiveContext {
        open func DEFINE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DEFINE.rawValue, 0)
        }
        open func CONDITIONAL_SYMBOL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0)
        }
        open func directive_text() -> Directive_textContext? {
            return getRuleContext(Directive_textContext.self, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorDefine(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorDefine(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorDefine(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorDefine(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorWarningContext: DirectiveContext {
        open func WARNING() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.WARNING.rawValue, 0)
        }
        open func directive_text() -> Directive_textContext? {
            return getRuleContext(Directive_textContext.self, 0)
        }

        public init(_ ctx: DirectiveContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorWarning(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorWarning(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorWarning(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorWarning(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func directive() throws -> DirectiveContext {
        var _localctx: DirectiveContext
        _localctx = DirectiveContext(_ctx, getState())
        try enterRule(_localctx, 6, ObjectiveCPreprocessorParser.RULE_directive)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(57)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .IMPORT, .INCLUDE:
                _localctx = PreprocessorImportContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(32)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCPreprocessorParser.Tokens.IMPORT.rawValue
                    || _la == ObjectiveCPreprocessorParser.Tokens.INCLUDE.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(33)
                try directive_text()

                break

            case .IF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(34)
                try match(ObjectiveCPreprocessorParser.Tokens.IF.rawValue)
                setState(35)
                try preprocessor_expression(0)

                break

            case .ELIF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 3)
                setState(36)
                try match(ObjectiveCPreprocessorParser.Tokens.ELIF.rawValue)
                setState(37)
                try preprocessor_expression(0)

                break

            case .ELSE:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 4)
                setState(38)
                try match(ObjectiveCPreprocessorParser.Tokens.ELSE.rawValue)

                break

            case .ENDIF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 5)
                setState(39)
                try match(ObjectiveCPreprocessorParser.Tokens.ENDIF.rawValue)

                break

            case .IFDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 6)
                setState(40)
                try match(ObjectiveCPreprocessorParser.Tokens.IFDEF.rawValue)
                setState(41)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .IFNDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 7)
                setState(42)
                try match(ObjectiveCPreprocessorParser.Tokens.IFNDEF.rawValue)
                setState(43)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .UNDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 8)
                setState(44)
                try match(ObjectiveCPreprocessorParser.Tokens.UNDEF.rawValue)
                setState(45)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .PRAGMA:
                _localctx = PreprocessorPragmaContext(_localctx)
                try enterOuterAlt(_localctx, 9)
                setState(46)
                try match(ObjectiveCPreprocessorParser.Tokens.PRAGMA.rawValue)
                setState(47)
                try directive_text()

                break

            case .ERROR:
                _localctx = PreprocessorErrorContext(_localctx)
                try enterOuterAlt(_localctx, 10)
                setState(48)
                try match(ObjectiveCPreprocessorParser.Tokens.ERROR.rawValue)
                setState(49)
                try directive_text()

                break

            case .WARNING:
                _localctx = PreprocessorWarningContext(_localctx)
                try enterOuterAlt(_localctx, 11)
                setState(50)
                try match(ObjectiveCPreprocessorParser.Tokens.WARNING.rawValue)
                setState(51)
                try directive_text()

                break

            case .DEFINE:
                _localctx = PreprocessorDefineContext(_localctx)
                try enterOuterAlt(_localctx, 12)
                setState(52)
                try match(ObjectiveCPreprocessorParser.Tokens.DEFINE.rawValue)
                setState(53)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                setState(55)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue {
                    setState(54)
                    try directive_text()

                }

                break
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class Directive_textContext: ParserRuleContext {
        open func TEXT() -> [TerminalNode] {
            return getTokens(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue)
        }
        open func TEXT(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCPreprocessorParser.RULE_directive_text
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterDirective_text(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitDirective_text(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitDirective_text(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitDirective_text(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func directive_text() throws -> Directive_textContext {
        var _localctx: Directive_textContext
        _localctx = Directive_textContext(_ctx, getState())
        try enterRule(_localctx, 8, ObjectiveCPreprocessorParser.RULE_directive_text)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(60)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(59)
                try match(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue)

                setState(62)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class Preprocessor_expressionContext: ParserRuleContext {
        override open func getRuleIndex() -> Int {
            return ObjectiveCPreprocessorParser.RULE_preprocessor_expression
        }
    }
    public class PreprocessorParenthesisContext: Preprocessor_expressionContext {
        open func LPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0)
        }
        open func preprocessor_expression() -> Preprocessor_expressionContext? {
            return getRuleContext(Preprocessor_expressionContext.self, 0)
        }
        open func RPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorParenthesis(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorParenthesis(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorParenthesis(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorParenthesis(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorNotContext: Preprocessor_expressionContext {
        open func BANG() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.BANG.rawValue, 0)
        }
        open func preprocessor_expression() -> Preprocessor_expressionContext? {
            return getRuleContext(Preprocessor_expressionContext.self, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorNot(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorNot(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorNot(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorNot(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorBinaryContext: Preprocessor_expressionContext {
        public var op: Token!
        open func preprocessor_expression() -> [Preprocessor_expressionContext] {
            return getRuleContexts(Preprocessor_expressionContext.self)
        }
        open func preprocessor_expression(_ i: Int) -> Preprocessor_expressionContext? {
            return getRuleContext(Preprocessor_expressionContext.self, i)
        }
        open func EQUAL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.EQUAL.rawValue, 0)
        }
        open func NOTEQUAL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.NOTEQUAL.rawValue, 0)
        }
        open func AND() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.AND.rawValue, 0)
        }
        open func OR() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.OR.rawValue, 0)
        }
        open func LT() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.LT.rawValue, 0)
        }
        open func GT() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.GT.rawValue, 0)
        }
        open func LE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.LE.rawValue, 0)
        }
        open func GE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.GE.rawValue, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorBinary(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorBinary(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorBinary(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorBinary(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorConstantContext: Preprocessor_expressionContext {
        open func TRUE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.TRUE.rawValue, 0)
        }
        open func FALSE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.FALSE.rawValue, 0)
        }
        open func DECIMAL_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DECIMAL_LITERAL.rawValue, 0)
        }
        open func DIRECTIVE_STRING() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorConstant(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorConstant(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorConstant(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorConstant(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorConditionalSymbolContext: Preprocessor_expressionContext {
        open func CONDITIONAL_SYMBOL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0)
        }
        open func LPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0)
        }
        open func preprocessor_expression() -> Preprocessor_expressionContext? {
            return getRuleContext(Preprocessor_expressionContext.self, 0)
        }
        open func RPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorConditionalSymbol(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorConditionalSymbol(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorConditionalSymbol(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorConditionalSymbol(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreprocessorDefinedContext: Preprocessor_expressionContext {
        open func DEFINED() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DEFINED.rawValue, 0)
        }
        open func CONDITIONAL_SYMBOL() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0)
        }
        open func LPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0)
        }
        open func RPAREN() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0)
        }

        public init(_ ctx: Preprocessor_expressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPreprocessorDefined(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPreprocessorDefined(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPreprocessorDefined(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPreprocessorDefined(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }

    public final func preprocessor_expression() throws -> Preprocessor_expressionContext {
        return try preprocessor_expression(0)
    }
    @discardableResult private func preprocessor_expression(_ _p: Int) throws
        -> Preprocessor_expressionContext
    {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: Preprocessor_expressionContext
        _localctx = Preprocessor_expressionContext(_ctx, _parentState)
        let _startState: Int = 10
        try enterRecursionRule(
            _localctx, 10, ObjectiveCPreprocessorParser.RULE_preprocessor_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(89)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx

                setState(65)
                try match(ObjectiveCPreprocessorParser.Tokens.TRUE.rawValue)

                break

            case .FALSE:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(66)
                try match(ObjectiveCPreprocessorParser.Tokens.FALSE.rawValue)

                break

            case .DECIMAL_LITERAL:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(67)
                try match(ObjectiveCPreprocessorParser.Tokens.DECIMAL_LITERAL.rawValue)

                break

            case .DIRECTIVE_STRING:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(68)
                try match(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue)

                break

            case .CONDITIONAL_SYMBOL:
                _localctx = PreprocessorConditionalSymbolContext(_localctx)
                _ctx = _localctx
                setState(69)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                setState(74)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 6, _ctx) {
                case 1:
                    setState(70)
                    try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                    setState(71)
                    try preprocessor_expression(0)
                    setState(72)
                    try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                    break
                default: break
                }

                break

            case .LPAREN:
                _localctx = PreprocessorParenthesisContext(_localctx)
                _ctx = _localctx
                setState(76)
                try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                setState(77)
                try preprocessor_expression(0)
                setState(78)
                try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                break

            case .BANG:
                _localctx = PreprocessorNotContext(_localctx)
                _ctx = _localctx
                setState(80)
                try match(ObjectiveCPreprocessorParser.Tokens.BANG.rawValue)
                setState(81)
                try preprocessor_expression(6)

                break

            case .DEFINED:
                _localctx = PreprocessorDefinedContext(_localctx)
                _ctx = _localctx
                setState(82)
                try match(ObjectiveCPreprocessorParser.Tokens.DEFINED.rawValue)
                setState(87)
                try _errHandler.sync(self)
                switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
                case .CONDITIONAL_SYMBOL:
                    setState(83)
                    try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                    break

                case .LPAREN:
                    setState(84)
                    try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                    setState(85)
                    try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                    setState(86)
                    try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
            _ctx!.stop = try _input.LT(-1)
            setState(105)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 10, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(103)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 9, _ctx) {
                    case 1:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(91)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(92)
                        _localctx.castdown(PreprocessorBinaryContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCPreprocessorParser.Tokens.EQUAL.rawValue
                            || _la == ObjectiveCPreprocessorParser.Tokens.NOTEQUAL.rawValue)
                        {
                            _localctx.castdown(PreprocessorBinaryContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(93)
                        try preprocessor_expression(6)

                        break
                    case 2:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(94)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(95)
                        try {
                            let assignmentValue = try match(
                                ObjectiveCPreprocessorParser.Tokens.AND.rawValue)
                            _localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
                        }()

                        setState(96)
                        try preprocessor_expression(5)

                        break
                    case 3:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(97)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(98)
                        try {
                            let assignmentValue = try match(
                                ObjectiveCPreprocessorParser.Tokens.OR.rawValue)
                            _localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
                        }()

                        setState(99)
                        try preprocessor_expression(4)

                        break
                    case 4:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(100)
                        if !(precpred(_ctx, 2)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 2)"))
                        }
                        setState(101)
                        _localctx.castdown(PreprocessorBinaryContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_006_632_960) != 0)
                        {
                            _localctx.castdown(PreprocessorBinaryContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(102)
                        try preprocessor_expression(3)

                        break
                    default: break
                    }
                }
                setState(107)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 10, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    override open func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int, _ predIndex: Int) throws
        -> Bool
    {
        switch ruleIndex {
        case 5:
            return try preprocessor_expression_sempred(
                _localctx?.castdown(Preprocessor_expressionContext.self), predIndex)
        default: return true
        }
    }
    private func preprocessor_expression_sempred(
        _ _localctx: Preprocessor_expressionContext!, _ predIndex: Int
    ) throws -> Bool {
        switch predIndex {
        case 0: return precpred(_ctx, 5)
        case 1: return precpred(_ctx, 4)
        case 2: return precpred(_ctx, 3)
        case 3: return precpred(_ctx, 2)
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 41, 109, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 1, 0,
        5, 0, 14, 8, 0, 10, 0, 12, 0, 17, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 26,
        8, 1, 1, 2, 4, 2, 29, 8, 2, 11, 2, 12, 2, 30, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1,
        3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3,
        3, 3, 56, 8, 3, 3, 3, 58, 8, 3, 1, 4, 4, 4, 61, 8, 4, 11, 4, 12, 4, 62, 1, 5, 1, 5, 1, 5, 1,
        5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 75, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5,
        1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 88, 8, 5, 3, 5, 90, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5,
        1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 5, 5, 104, 8, 5, 10, 5, 12, 5, 107, 9, 5, 1, 5, 0,
        1, 10, 6, 0, 2, 4, 6, 8, 10, 0, 4, 1, 1, 35, 35, 1, 0, 3, 4, 1, 0, 22, 23, 1, 0, 26, 29,
        131, 0, 15, 1, 0, 0, 0, 2, 25, 1, 0, 0, 0, 4, 28, 1, 0, 0, 0, 6, 57, 1, 0, 0, 0, 8, 60, 1,
        0, 0, 0, 10, 89, 1, 0, 0, 0, 12, 14, 3, 2, 1, 0, 13, 12, 1, 0, 0, 0, 14, 17, 1, 0, 0, 0, 15,
        13, 1, 0, 0, 0, 15, 16, 1, 0, 0, 0, 16, 18, 1, 0, 0, 0, 17, 15, 1, 0, 0, 0, 18, 19, 5, 0, 0,
        1, 19, 1, 1, 0, 0, 0, 20, 26, 3, 4, 2, 0, 21, 22, 5, 1, 0, 0, 22, 23, 3, 6, 3, 0, 23, 24, 7,
        0, 0, 0, 24, 26, 1, 0, 0, 0, 25, 20, 1, 0, 0, 0, 25, 21, 1, 0, 0, 0, 26, 3, 1, 0, 0, 0, 27,
        29, 5, 2, 0, 0, 28, 27, 1, 0, 0, 0, 29, 30, 1, 0, 0, 0, 30, 28, 1, 0, 0, 0, 30, 31, 1, 0, 0,
        0, 31, 5, 1, 0, 0, 0, 32, 33, 7, 1, 0, 0, 33, 58, 3, 8, 4, 0, 34, 35, 5, 8, 0, 0, 35, 58, 3,
        10, 5, 0, 36, 37, 5, 9, 0, 0, 37, 58, 3, 10, 5, 0, 38, 58, 5, 10, 0, 0, 39, 58, 5, 14, 0, 0,
        40, 41, 5, 12, 0, 0, 41, 58, 5, 32, 0, 0, 42, 43, 5, 13, 0, 0, 43, 58, 5, 32, 0, 0, 44, 45,
        5, 11, 0, 0, 45, 58, 5, 32, 0, 0, 46, 47, 5, 5, 0, 0, 47, 58, 3, 8, 4, 0, 48, 49, 5, 17, 0,
        0, 49, 58, 3, 8, 4, 0, 50, 51, 5, 18, 0, 0, 51, 58, 3, 8, 4, 0, 52, 53, 5, 6, 0, 0, 53, 55,
        5, 32, 0, 0, 54, 56, 3, 8, 4, 0, 55, 54, 1, 0, 0, 0, 55, 56, 1, 0, 0, 0, 56, 58, 1, 0, 0, 0,
        57, 32, 1, 0, 0, 0, 57, 34, 1, 0, 0, 0, 57, 36, 1, 0, 0, 0, 57, 38, 1, 0, 0, 0, 57, 39, 1,
        0, 0, 0, 57, 40, 1, 0, 0, 0, 57, 42, 1, 0, 0, 0, 57, 44, 1, 0, 0, 0, 57, 46, 1, 0, 0, 0, 57,
        48, 1, 0, 0, 0, 57, 50, 1, 0, 0, 0, 57, 52, 1, 0, 0, 0, 58, 7, 1, 0, 0, 0, 59, 61, 5, 40, 0,
        0, 60, 59, 1, 0, 0, 0, 61, 62, 1, 0, 0, 0, 62, 60, 1, 0, 0, 0, 62, 63, 1, 0, 0, 0, 63, 9, 1,
        0, 0, 0, 64, 65, 6, 5, -1, 0, 65, 90, 5, 15, 0, 0, 66, 90, 5, 16, 0, 0, 67, 90, 5, 33, 0, 0,
        68, 90, 5, 31, 0, 0, 69, 74, 5, 32, 0, 0, 70, 71, 5, 20, 0, 0, 71, 72, 3, 10, 5, 0, 72, 73,
        5, 21, 0, 0, 73, 75, 1, 0, 0, 0, 74, 70, 1, 0, 0, 0, 74, 75, 1, 0, 0, 0, 75, 90, 1, 0, 0, 0,
        76, 77, 5, 20, 0, 0, 77, 78, 3, 10, 5, 0, 78, 79, 5, 21, 0, 0, 79, 90, 1, 0, 0, 0, 80, 81,
        5, 19, 0, 0, 81, 90, 3, 10, 5, 6, 82, 87, 5, 7, 0, 0, 83, 88, 5, 32, 0, 0, 84, 85, 5, 20, 0,
        0, 85, 86, 5, 32, 0, 0, 86, 88, 5, 21, 0, 0, 87, 83, 1, 0, 0, 0, 87, 84, 1, 0, 0, 0, 88, 90,
        1, 0, 0, 0, 89, 64, 1, 0, 0, 0, 89, 66, 1, 0, 0, 0, 89, 67, 1, 0, 0, 0, 89, 68, 1, 0, 0, 0,
        89, 69, 1, 0, 0, 0, 89, 76, 1, 0, 0, 0, 89, 80, 1, 0, 0, 0, 89, 82, 1, 0, 0, 0, 90, 105, 1,
        0, 0, 0, 91, 92, 10, 5, 0, 0, 92, 93, 7, 2, 0, 0, 93, 104, 3, 10, 5, 6, 94, 95, 10, 4, 0, 0,
        95, 96, 5, 24, 0, 0, 96, 104, 3, 10, 5, 5, 97, 98, 10, 3, 0, 0, 98, 99, 5, 25, 0, 0, 99,
        104, 3, 10, 5, 4, 100, 101, 10, 2, 0, 0, 101, 102, 7, 3, 0, 0, 102, 104, 3, 10, 5, 3, 103,
        91, 1, 0, 0, 0, 103, 94, 1, 0, 0, 0, 103, 97, 1, 0, 0, 0, 103, 100, 1, 0, 0, 0, 104, 107, 1,
        0, 0, 0, 105, 103, 1, 0, 0, 0, 105, 106, 1, 0, 0, 0, 106, 11, 1, 0, 0, 0, 107, 105, 1, 0, 0,
        0, 11, 15, 25, 30, 55, 57, 62, 74, 87, 89, 103, 105,
    ]
}
