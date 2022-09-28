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
        case HASINCLUDE = 19
        case BANG = 20
        case LPAREN = 21
        case RPAREN = 22
        case EQUAL = 23
        case NOTEQUAL = 24
        case AND = 25
        case OR = 26
        case LT = 27
        case GT = 28
        case LE = 29
        case GE = 30
        case DIRECTIVE_WHITESPACES = 31
        case DIRECTIVE_STRING = 32
        case DIRECTIVE_PATH = 33
        case CONDITIONAL_SYMBOL = 34
        case DECIMAL_LITERAL = 35
        case FLOAT = 36
        case NEW_LINE = 37
        case DIRECITVE_COMMENT = 38
        case DIRECITVE_LINE_COMMENT = 39
        case DIRECITVE_NEW_LINE = 40
        case DIRECITVE_TEXT_NEW_LINE = 41
        case TEXT = 42
        case SLASH = 43
    }

    public static let RULE_objectiveCDocument = 0, RULE_text = 1, RULE_code = 2, RULE_directive = 3,
        RULE_directive_text = 4, RULE_path_directive = 5, RULE_preprocessor_expression = 6

    public static let ruleNames: [String] = [
        "objectiveCDocument", "text", "code", "directive", "directive_text", "path_directive",
        "preprocessor_expression",
    ]

    private static let _LITERAL_NAMES: [String?] = [
        nil, "'#'", nil, nil, nil, "'pragma'", nil, "'defined'", "'if'", "'elif'", "'else'",
        "'undef'", "'ifdef'", "'ifndef'", "'endif'", nil, nil, "'error'", "'warning'",
        "'__has_include'", "'!'", "'('", "')'", "'=='", "'!='", "'&&'", "'||'", "'<'", "'>'",
        "'<='", "'>='",
    ]
    private static let _SYMBOLIC_NAMES: [String?] = [
        nil, "SHARP", "CODE", "IMPORT", "INCLUDE", "PRAGMA", "DEFINE", "DEFINED", "IF", "ELIF",
        "ELSE", "UNDEF", "IFDEF", "IFNDEF", "ENDIF", "TRUE", "FALSE", "ERROR", "WARNING",
        "HASINCLUDE", "BANG", "LPAREN", "RPAREN", "EQUAL", "NOTEQUAL", "AND", "OR", "LT", "GT",
        "LE", "GE", "DIRECTIVE_WHITESPACES", "DIRECTIVE_STRING", "DIRECTIVE_PATH",
        "CONDITIONAL_SYMBOL", "DECIMAL_LITERAL", "FLOAT", "NEW_LINE", "DIRECITVE_COMMENT",
        "DIRECITVE_LINE_COMMENT", "DIRECITVE_NEW_LINE", "DIRECITVE_TEXT_NEW_LINE", "TEXT", "SLASH",
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
            setState(17)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue
                || _la == ObjectiveCPreprocessorParser.Tokens.CODE.rawValue
            {
                setState(14)
                try text()

                setState(19)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(20)
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
            setState(27)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .CODE:
                try enterOuterAlt(_localctx, 1)
                setState(22)
                try code()

                break

            case .SHARP:
                try enterOuterAlt(_localctx, 2)
                setState(23)
                try match(ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue)
                setState(24)
                try directive()
                setState(25)
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
            setState(30)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(29)
                    try match(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(32)
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
            setState(59)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .IMPORT, .INCLUDE:
                _localctx = PreprocessorImportContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(34)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCPreprocessorParser.Tokens.IMPORT.rawValue
                    || _la == ObjectiveCPreprocessorParser.Tokens.INCLUDE.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(35)
                try directive_text()

                break

            case .IF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(36)
                try match(ObjectiveCPreprocessorParser.Tokens.IF.rawValue)
                setState(37)
                try preprocessor_expression(0)

                break

            case .ELIF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 3)
                setState(38)
                try match(ObjectiveCPreprocessorParser.Tokens.ELIF.rawValue)
                setState(39)
                try preprocessor_expression(0)

                break

            case .ELSE:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 4)
                setState(40)
                try match(ObjectiveCPreprocessorParser.Tokens.ELSE.rawValue)

                break

            case .ENDIF:
                _localctx = PreprocessorConditionalContext(_localctx)
                try enterOuterAlt(_localctx, 5)
                setState(41)
                try match(ObjectiveCPreprocessorParser.Tokens.ENDIF.rawValue)

                break

            case .IFDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 6)
                setState(42)
                try match(ObjectiveCPreprocessorParser.Tokens.IFDEF.rawValue)
                setState(43)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .IFNDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 7)
                setState(44)
                try match(ObjectiveCPreprocessorParser.Tokens.IFNDEF.rawValue)
                setState(45)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .UNDEF:
                _localctx = PreprocessorDefContext(_localctx)
                try enterOuterAlt(_localctx, 8)
                setState(46)
                try match(ObjectiveCPreprocessorParser.Tokens.UNDEF.rawValue)
                setState(47)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                break

            case .PRAGMA:
                _localctx = PreprocessorPragmaContext(_localctx)
                try enterOuterAlt(_localctx, 9)
                setState(48)
                try match(ObjectiveCPreprocessorParser.Tokens.PRAGMA.rawValue)
                setState(49)
                try directive_text()

                break

            case .ERROR:
                _localctx = PreprocessorErrorContext(_localctx)
                try enterOuterAlt(_localctx, 10)
                setState(50)
                try match(ObjectiveCPreprocessorParser.Tokens.ERROR.rawValue)
                setState(51)
                try directive_text()

                break

            case .WARNING:
                _localctx = PreprocessorWarningContext(_localctx)
                try enterOuterAlt(_localctx, 11)
                setState(52)
                try match(ObjectiveCPreprocessorParser.Tokens.WARNING.rawValue)
                setState(53)
                try directive_text()

                break

            case .DEFINE:
                _localctx = PreprocessorDefineContext(_localctx)
                try enterOuterAlt(_localctx, 12)
                setState(54)
                try match(ObjectiveCPreprocessorParser.Tokens.DEFINE.rawValue)
                setState(55)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                setState(57)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue {
                    setState(56)
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
            setState(62)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(61)
                try match(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue)

                setState(64)
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

    public class Path_directiveContext: ParserRuleContext {
        open func DIRECTIVE_STRING() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue, 0)
        }
        open func DIRECTIVE_PATH() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_PATH.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCPreprocessorParser.RULE_path_directive
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.enterPath_directive(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCPreprocessorParserListener {
                listener.exitPath_directive(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCPreprocessorParserVisitor {
                return visitor.visitPath_directive(self)
            } else if let visitor = visitor as? ObjectiveCPreprocessorParserBaseVisitor {
                return visitor.visitPath_directive(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func path_directive() throws -> Path_directiveContext {
        var _localctx: Path_directiveContext
        _localctx = Path_directiveContext(_ctx, getState())
        try enterRule(_localctx, 10, ObjectiveCPreprocessorParser.RULE_path_directive)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(66)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue
                || _la == ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_PATH.rawValue)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }

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
        open func HASINCLUDE() -> TerminalNode? {
            return getToken(ObjectiveCPreprocessorParser.Tokens.HASINCLUDE.rawValue, 0)
        }
        open func path_directive() -> Path_directiveContext? {
            return getRuleContext(Path_directiveContext.self, 0)
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
        let _startState: Int = 12
        try enterRecursionRule(
            _localctx, 12, ObjectiveCPreprocessorParser.RULE_preprocessor_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(98)
            try _errHandler.sync(self)
            switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx

                setState(69)
                try match(ObjectiveCPreprocessorParser.Tokens.TRUE.rawValue)

                break

            case .FALSE:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(70)
                try match(ObjectiveCPreprocessorParser.Tokens.FALSE.rawValue)

                break

            case .DECIMAL_LITERAL:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(71)
                try match(ObjectiveCPreprocessorParser.Tokens.DECIMAL_LITERAL.rawValue)

                break

            case .DIRECTIVE_STRING:
                _localctx = PreprocessorConstantContext(_localctx)
                _ctx = _localctx
                setState(72)
                try match(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue)

                break

            case .CONDITIONAL_SYMBOL:
                _localctx = PreprocessorConditionalSymbolContext(_localctx)
                _ctx = _localctx
                setState(73)
                try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                setState(78)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 6, _ctx) {
                case 1:
                    setState(74)
                    try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                    setState(75)
                    try preprocessor_expression(0)
                    setState(76)
                    try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                    break
                default: break
                }

                break

            case .LPAREN:
                _localctx = PreprocessorParenthesisContext(_localctx)
                _ctx = _localctx
                setState(80)
                try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                setState(81)
                try preprocessor_expression(0)
                setState(82)
                try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                break

            case .BANG:
                _localctx = PreprocessorNotContext(_localctx)
                _ctx = _localctx
                setState(84)
                try match(ObjectiveCPreprocessorParser.Tokens.BANG.rawValue)
                setState(85)
                try preprocessor_expression(7)

                break

            case .DEFINED:
                _localctx = PreprocessorDefinedContext(_localctx)
                _ctx = _localctx
                setState(86)
                try match(ObjectiveCPreprocessorParser.Tokens.DEFINED.rawValue)
                setState(91)
                try _errHandler.sync(self)
                switch ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))! {
                case .CONDITIONAL_SYMBOL:
                    setState(87)
                    try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

                    break

                case .LPAREN:
                    setState(88)
                    try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                    setState(89)
                    try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
                    setState(90)
                    try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break

            case .HASINCLUDE:
                _localctx = PreprocessorConditionalSymbolContext(_localctx)
                _ctx = _localctx
                setState(93)
                try match(ObjectiveCPreprocessorParser.Tokens.HASINCLUDE.rawValue)
                setState(94)
                try match(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue)
                setState(95)
                try path_directive()
                setState(96)
                try match(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue)

                break
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
            _ctx!.stop = try _input.LT(-1)
            setState(114)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 10, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(112)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 9, _ctx) {
                    case 1:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(100)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(101)
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
                        setState(102)
                        try preprocessor_expression(7)

                        break
                    case 2:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(103)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(104)
                        try {
                            let assignmentValue = try match(
                                ObjectiveCPreprocessorParser.Tokens.AND.rawValue)
                            _localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
                        }()

                        setState(105)
                        try preprocessor_expression(6)

                        break
                    case 3:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(106)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(107)
                        try {
                            let assignmentValue = try match(
                                ObjectiveCPreprocessorParser.Tokens.OR.rawValue)
                            _localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
                        }()

                        setState(108)
                        try preprocessor_expression(5)

                        break
                    case 4:
                        _localctx = PreprocessorBinaryContext(
                            Preprocessor_expressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState,
                            ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
                        setState(109)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(110)
                        _localctx.castdown(PreprocessorBinaryContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_013_265_920) != 0)
                        {
                            _localctx.castdown(PreprocessorBinaryContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(111)
                        try preprocessor_expression(4)

                        break
                    default: break
                    }
                }
                setState(116)
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
        case 6:
            return try preprocessor_expression_sempred(
                _localctx?.castdown(Preprocessor_expressionContext.self), predIndex)
        default: return true
        }
    }
    private func preprocessor_expression_sempred(
        _ _localctx: Preprocessor_expressionContext!, _ predIndex: Int
    ) throws -> Bool {
        switch predIndex {
        case 0: return precpred(_ctx, 6)
        case 1: return precpred(_ctx, 5)
        case 2: return precpred(_ctx, 4)
        case 3: return precpred(_ctx, 3)
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 43, 118, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2, 6,
        7, 6, 1, 0, 5, 0, 16, 8, 0, 10, 0, 12, 0, 19, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 3, 1, 28, 8, 1, 1, 2, 4, 2, 31, 8, 2, 11, 2, 12, 2, 32, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1,
        3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3,
        1, 3, 1, 3, 3, 3, 58, 8, 3, 3, 3, 60, 8, 3, 1, 4, 4, 4, 63, 8, 4, 11, 4, 12, 4, 64, 1, 5, 1,
        5, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 3, 6, 79, 8, 6, 1, 6, 1, 6,
        1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 3, 6, 92, 8, 6, 1, 6, 1, 6, 1, 6, 1,
        6, 1, 6, 3, 6, 99, 8, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6,
        1, 6, 5, 6, 113, 8, 6, 10, 6, 12, 6, 116, 9, 6, 1, 6, 0, 1, 12, 7, 0, 2, 4, 6, 8, 10, 12, 0,
        5, 1, 1, 37, 37, 1, 0, 3, 4, 1, 0, 32, 33, 1, 0, 23, 24, 1, 0, 27, 30, 140, 0, 17, 1, 0, 0,
        0, 2, 27, 1, 0, 0, 0, 4, 30, 1, 0, 0, 0, 6, 59, 1, 0, 0, 0, 8, 62, 1, 0, 0, 0, 10, 66, 1, 0,
        0, 0, 12, 98, 1, 0, 0, 0, 14, 16, 3, 2, 1, 0, 15, 14, 1, 0, 0, 0, 16, 19, 1, 0, 0, 0, 17,
        15, 1, 0, 0, 0, 17, 18, 1, 0, 0, 0, 18, 20, 1, 0, 0, 0, 19, 17, 1, 0, 0, 0, 20, 21, 5, 0, 0,
        1, 21, 1, 1, 0, 0, 0, 22, 28, 3, 4, 2, 0, 23, 24, 5, 1, 0, 0, 24, 25, 3, 6, 3, 0, 25, 26, 7,
        0, 0, 0, 26, 28, 1, 0, 0, 0, 27, 22, 1, 0, 0, 0, 27, 23, 1, 0, 0, 0, 28, 3, 1, 0, 0, 0, 29,
        31, 5, 2, 0, 0, 30, 29, 1, 0, 0, 0, 31, 32, 1, 0, 0, 0, 32, 30, 1, 0, 0, 0, 32, 33, 1, 0, 0,
        0, 33, 5, 1, 0, 0, 0, 34, 35, 7, 1, 0, 0, 35, 60, 3, 8, 4, 0, 36, 37, 5, 8, 0, 0, 37, 60, 3,
        12, 6, 0, 38, 39, 5, 9, 0, 0, 39, 60, 3, 12, 6, 0, 40, 60, 5, 10, 0, 0, 41, 60, 5, 14, 0, 0,
        42, 43, 5, 12, 0, 0, 43, 60, 5, 34, 0, 0, 44, 45, 5, 13, 0, 0, 45, 60, 5, 34, 0, 0, 46, 47,
        5, 11, 0, 0, 47, 60, 5, 34, 0, 0, 48, 49, 5, 5, 0, 0, 49, 60, 3, 8, 4, 0, 50, 51, 5, 17, 0,
        0, 51, 60, 3, 8, 4, 0, 52, 53, 5, 18, 0, 0, 53, 60, 3, 8, 4, 0, 54, 55, 5, 6, 0, 0, 55, 57,
        5, 34, 0, 0, 56, 58, 3, 8, 4, 0, 57, 56, 1, 0, 0, 0, 57, 58, 1, 0, 0, 0, 58, 60, 1, 0, 0, 0,
        59, 34, 1, 0, 0, 0, 59, 36, 1, 0, 0, 0, 59, 38, 1, 0, 0, 0, 59, 40, 1, 0, 0, 0, 59, 41, 1,
        0, 0, 0, 59, 42, 1, 0, 0, 0, 59, 44, 1, 0, 0, 0, 59, 46, 1, 0, 0, 0, 59, 48, 1, 0, 0, 0, 59,
        50, 1, 0, 0, 0, 59, 52, 1, 0, 0, 0, 59, 54, 1, 0, 0, 0, 60, 7, 1, 0, 0, 0, 61, 63, 5, 42, 0,
        0, 62, 61, 1, 0, 0, 0, 63, 64, 1, 0, 0, 0, 64, 62, 1, 0, 0, 0, 64, 65, 1, 0, 0, 0, 65, 9, 1,
        0, 0, 0, 66, 67, 7, 2, 0, 0, 67, 11, 1, 0, 0, 0, 68, 69, 6, 6, -1, 0, 69, 99, 5, 15, 0, 0,
        70, 99, 5, 16, 0, 0, 71, 99, 5, 35, 0, 0, 72, 99, 5, 32, 0, 0, 73, 78, 5, 34, 0, 0, 74, 75,
        5, 21, 0, 0, 75, 76, 3, 12, 6, 0, 76, 77, 5, 22, 0, 0, 77, 79, 1, 0, 0, 0, 78, 74, 1, 0, 0,
        0, 78, 79, 1, 0, 0, 0, 79, 99, 1, 0, 0, 0, 80, 81, 5, 21, 0, 0, 81, 82, 3, 12, 6, 0, 82, 83,
        5, 22, 0, 0, 83, 99, 1, 0, 0, 0, 84, 85, 5, 20, 0, 0, 85, 99, 3, 12, 6, 7, 86, 91, 5, 7, 0,
        0, 87, 92, 5, 34, 0, 0, 88, 89, 5, 21, 0, 0, 89, 90, 5, 34, 0, 0, 90, 92, 5, 22, 0, 0, 91,
        87, 1, 0, 0, 0, 91, 88, 1, 0, 0, 0, 92, 99, 1, 0, 0, 0, 93, 94, 5, 19, 0, 0, 94, 95, 5, 21,
        0, 0, 95, 96, 3, 10, 5, 0, 96, 97, 5, 22, 0, 0, 97, 99, 1, 0, 0, 0, 98, 68, 1, 0, 0, 0, 98,
        70, 1, 0, 0, 0, 98, 71, 1, 0, 0, 0, 98, 72, 1, 0, 0, 0, 98, 73, 1, 0, 0, 0, 98, 80, 1, 0, 0,
        0, 98, 84, 1, 0, 0, 0, 98, 86, 1, 0, 0, 0, 98, 93, 1, 0, 0, 0, 99, 114, 1, 0, 0, 0, 100,
        101, 10, 6, 0, 0, 101, 102, 7, 3, 0, 0, 102, 113, 3, 12, 6, 7, 103, 104, 10, 5, 0, 0, 104,
        105, 5, 25, 0, 0, 105, 113, 3, 12, 6, 6, 106, 107, 10, 4, 0, 0, 107, 108, 5, 26, 0, 0, 108,
        113, 3, 12, 6, 5, 109, 110, 10, 3, 0, 0, 110, 111, 7, 4, 0, 0, 111, 113, 3, 12, 6, 4, 112,
        100, 1, 0, 0, 0, 112, 103, 1, 0, 0, 0, 112, 106, 1, 0, 0, 0, 112, 109, 1, 0, 0, 0, 113, 116,
        1, 0, 0, 0, 114, 112, 1, 0, 0, 0, 114, 115, 1, 0, 0, 0, 115, 13, 1, 0, 0, 0, 116, 114, 1, 0,
        0, 0, 11, 17, 27, 32, 57, 59, 64, 78, 91, 98, 112, 114,
    ]
}
