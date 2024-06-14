// Generated from java-escape by ANTLR 4.11.1
import Antlr4

open class JavaScriptParser: JavaScriptParserBase {

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
        case HashBangLine = 1
        case MultiLineComment = 2
        case SingleLineComment = 3
        case RegularExpressionLiteral = 4
        case OpenBracket = 5
        case CloseBracket = 6
        case OpenParen = 7
        case CloseParen = 8
        case OpenBrace = 9
        case TemplateCloseBrace = 10
        case CloseBrace = 11
        case SemiColon = 12
        case Comma = 13
        case Assign = 14
        case QuestionMark = 15
        case QuestionMarkDot = 16
        case Colon = 17
        case Ellipsis = 18
        case Dot = 19
        case PlusPlus = 20
        case MinusMinus = 21
        case Plus = 22
        case Minus = 23
        case BitNot = 24
        case Not = 25
        case Multiply = 26
        case Divide = 27
        case Modulus = 28
        case Power = 29
        case NullCoalesce = 30
        case Hashtag = 31
        case RightShiftArithmetic = 32
        case LeftShiftArithmetic = 33
        case RightShiftLogical = 34
        case LessThan = 35
        case MoreThan = 36
        case LessThanEquals = 37
        case GreaterThanEquals = 38
        case Equals_ = 39
        case NotEquals = 40
        case IdentityEquals = 41
        case IdentityNotEquals = 42
        case BitAnd = 43
        case BitXOr = 44
        case BitOr = 45
        case And = 46
        case Or = 47
        case MultiplyAssign = 48
        case DivideAssign = 49
        case ModulusAssign = 50
        case PlusAssign = 51
        case MinusAssign = 52
        case LeftShiftArithmeticAssign = 53
        case RightShiftArithmeticAssign = 54
        case RightShiftLogicalAssign = 55
        case BitAndAssign = 56
        case BitXorAssign = 57
        case BitOrAssign = 58
        case PowerAssign = 59
        case ARROW = 60
        case NullLiteral = 61
        case BooleanLiteral = 62
        case DecimalLiteral = 63
        case HexIntegerLiteral = 64
        case OctalIntegerLiteral = 65
        case OctalIntegerLiteral2 = 66
        case BinaryIntegerLiteral = 67
        case BigHexIntegerLiteral = 68
        case BigOctalIntegerLiteral = 69
        case BigBinaryIntegerLiteral = 70
        case BigDecimalIntegerLiteral = 71
        case Break = 72
        case Do = 73
        case Instanceof = 74
        case Typeof = 75
        case Case = 76
        case Else = 77
        case New = 78
        case Var = 79
        case Catch = 80
        case Finally = 81
        case Return = 82
        case Void = 83
        case Continue = 84
        case For = 85
        case Switch = 86
        case While = 87
        case Debugger = 88
        case Function_ = 89
        case This = 90
        case With = 91
        case Default = 92
        case If = 93
        case Throw = 94
        case Delete = 95
        case In = 96
        case Try = 97
        case As = 98
        case From = 99
        case Class = 100
        case Enum = 101
        case Extends = 102
        case Super = 103
        case Const = 104
        case Export = 105
        case Import = 106
        case Async = 107
        case Await = 108
        case Yield = 109
        case Implements = 110
        case StrictLet = 111
        case NonStrictLet = 112
        case Private = 113
        case Public = 114
        case Interface = 115
        case Package = 116
        case Protected = 117
        case Static = 118
        case Identifier = 119
        case StringLiteral = 120
        case BackTick = 121
        case WhiteSpaces = 122
        case LineTerminator = 123
        case HtmlComment = 124
        case CDataComment = 125
        case UnexpectedCharacter = 126
        case TemplateStringStartExpression = 127
        case TemplateStringAtom = 128
    }

    public static let RULE_program = 0, RULE_sourceElement = 1, RULE_statement = 2, RULE_block = 3,
        RULE_statementList = 4, RULE_importStatement = 5, RULE_importFromBlock = 6,
        RULE_moduleItems = 7, RULE_importDefault = 8, RULE_importNamespace = 9,
        RULE_importFrom = 10, RULE_aliasName = 11, RULE_exportStatement = 12,
        RULE_exportFromBlock = 13, RULE_declaration = 14, RULE_variableStatement = 15,
        RULE_variableDeclarationList = 16, RULE_variableDeclaration = 17, RULE_emptyStatement_ = 18,
        RULE_expressionStatement = 19, RULE_ifStatement = 20, RULE_iterationStatement = 21,
        RULE_varModifier = 22, RULE_continueStatement = 23, RULE_breakStatement = 24,
        RULE_returnStatement = 25, RULE_yieldStatement = 26, RULE_withStatement = 27,
        RULE_switchStatement = 28, RULE_caseBlock = 29, RULE_caseClauses = 30, RULE_caseClause = 31,
        RULE_defaultClause = 32, RULE_labelledStatement = 33, RULE_throwStatement = 34,
        RULE_tryStatement = 35, RULE_catchProduction = 36, RULE_finallyProduction = 37,
        RULE_debuggerStatement = 38, RULE_functionDeclaration = 39, RULE_classDeclaration = 40,
        RULE_classTail = 41, RULE_classElement = 42, RULE_methodDefinition = 43,
        RULE_formalParameterList = 44, RULE_formalParameterArg = 45,
        RULE_lastFormalParameterArg = 46, RULE_functionBody = 47, RULE_sourceElements = 48,
        RULE_arrayLiteral = 49, RULE_elementList = 50, RULE_arrayElement = 51,
        RULE_propertyAssignment = 52, RULE_propertyName = 53, RULE_arguments = 54,
        RULE_argument = 55, RULE_expressionSequence = 56, RULE_singleExpression = 57,
        RULE_assignable = 58, RULE_objectLiteral = 59, RULE_anonymousFunction = 60,
        RULE_arrowFunctionParameters = 61, RULE_arrowFunctionBody = 62,
        RULE_assignmentOperator = 63, RULE_literal = 64, RULE_templateStringLiteral = 65,
        RULE_templateStringAtom = 66, RULE_numericLiteral = 67, RULE_bigintLiteral = 68,
        RULE_getter = 69, RULE_setter = 70, RULE_identifierName = 71, RULE_identifier = 72,
        RULE_reservedWord = 73, RULE_keyword = 74, RULE_let_ = 75, RULE_eos = 76

    public static let ruleNames: [String] = [
        "program", "sourceElement", "statement", "block", "statementList", "importStatement",
        "importFromBlock", "moduleItems", "importDefault", "importNamespace", "importFrom",
        "aliasName", "exportStatement", "exportFromBlock", "declaration", "variableStatement",
        "variableDeclarationList", "variableDeclaration", "emptyStatement_", "expressionStatement",
        "ifStatement", "iterationStatement", "varModifier", "continueStatement", "breakStatement",
        "returnStatement", "yieldStatement", "withStatement", "switchStatement", "caseBlock",
        "caseClauses", "caseClause", "defaultClause", "labelledStatement", "throwStatement",
        "tryStatement", "catchProduction", "finallyProduction", "debuggerStatement",
        "functionDeclaration", "classDeclaration", "classTail", "classElement", "methodDefinition",
        "formalParameterList", "formalParameterArg", "lastFormalParameterArg", "functionBody",
        "sourceElements", "arrayLiteral", "elementList", "arrayElement", "propertyAssignment",
        "propertyName", "arguments", "argument", "expressionSequence", "singleExpression",
        "assignable", "objectLiteral", "anonymousFunction", "arrowFunctionParameters",
        "arrowFunctionBody", "assignmentOperator", "literal", "templateStringLiteral",
        "templateStringAtom", "numericLiteral", "bigintLiteral", "getter", "setter",
        "identifierName", "identifier", "reservedWord", "keyword", "let_", "eos",
    ]

    private static let _LITERAL_NAMES: [String?] = [
        nil, nil, nil, nil, nil, "'['", "']'", "'('", "')'", "'{'", nil, "'}'", "';'", "','", "'='",
        "'?'", "'?.'", "':'", "'...'", "'.'", "'++'", "'--'", "'+'", "'-'", "'~'", "'!'", "'*'",
        "'/'", "'%'", "'**'", "'??'", "'#'", "'>>'", "'<<'", "'>>>'", "'<'", "'>'", "'<='", "'>='",
        "'=='", "'!='", "'==='", "'!=='", "'&'", "'^'", "'|'", "'&&'", "'||'", "'*='", "'/='",
        "'%='", "'+='", "'-='", "'<<='", "'>>='", "'>>>='", "'&='", "'^='", "'|='", "'**='", "'=>'",
        "'null'", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "'break'", "'do'",
        "'instanceof'", "'typeof'", "'case'", "'else'", "'new'", "'var'", "'catch'", "'finally'",
        "'return'", "'void'", "'continue'", "'for'", "'switch'", "'while'", "'debugger'",
        "'function'", "'this'", "'with'", "'default'", "'if'", "'throw'", "'delete'", "'in'",
        "'try'", "'as'", "'from'", "'class'", "'enum'", "'extends'", "'super'", "'const'",
        "'export'", "'import'", "'async'", "'await'", "'yield'", "'implements'", nil, nil,
        "'private'", "'public'", "'interface'", "'package'", "'protected'", "'static'", nil, nil,
        nil, nil, nil, nil, nil, nil, "'${'",
    ]
    private static let _SYMBOLIC_NAMES: [String?] = [
        nil, "HashBangLine", "MultiLineComment", "SingleLineComment", "RegularExpressionLiteral",
        "OpenBracket", "CloseBracket", "OpenParen", "CloseParen", "OpenBrace", "TemplateCloseBrace",
        "CloseBrace", "SemiColon", "Comma", "Assign", "QuestionMark", "QuestionMarkDot", "Colon",
        "Ellipsis", "Dot", "PlusPlus", "MinusMinus", "Plus", "Minus", "BitNot", "Not", "Multiply",
        "Divide", "Modulus", "Power", "NullCoalesce", "Hashtag", "RightShiftArithmetic",
        "LeftShiftArithmetic", "RightShiftLogical", "LessThan", "MoreThan", "LessThanEquals",
        "GreaterThanEquals", "Equals_", "NotEquals", "IdentityEquals", "IdentityNotEquals",
        "BitAnd", "BitXOr", "BitOr", "And", "Or", "MultiplyAssign", "DivideAssign", "ModulusAssign",
        "PlusAssign", "MinusAssign", "LeftShiftArithmeticAssign", "RightShiftArithmeticAssign",
        "RightShiftLogicalAssign", "BitAndAssign", "BitXorAssign", "BitOrAssign", "PowerAssign",
        "ARROW", "NullLiteral", "BooleanLiteral", "DecimalLiteral", "HexIntegerLiteral",
        "OctalIntegerLiteral", "OctalIntegerLiteral2", "BinaryIntegerLiteral",
        "BigHexIntegerLiteral", "BigOctalIntegerLiteral", "BigBinaryIntegerLiteral",
        "BigDecimalIntegerLiteral", "Break", "Do", "Instanceof", "Typeof", "Case", "Else", "New",
        "Var", "Catch", "Finally", "Return", "Void", "Continue", "For", "Switch", "While",
        "Debugger", "Function_", "This", "With", "Default", "If", "Throw", "Delete", "In", "Try",
        "As", "From", "Class", "Enum", "Extends", "Super", "Const", "Export", "Import", "Async",
        "Await", "Yield", "Implements", "StrictLet", "NonStrictLet", "Private", "Public",
        "Interface", "Package", "Protected", "Static", "Identifier", "StringLiteral", "BackTick",
        "WhiteSpaces", "LineTerminator", "HtmlComment", "CDataComment", "UnexpectedCharacter",
        "TemplateStringStartExpression", "TemplateStringAtom",
    ]
    public static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

    override open func getGrammarFileName() -> String { return "java-escape" }

    override open func getRuleNames() -> [String] { return JavaScriptParser.ruleNames }

    override open func getSerializedATN() -> [Int] { return JavaScriptParser._serializedATN }

    override open func getATN() -> ATN { return _ATN }

    override open func getVocabulary() -> Vocabulary { return JavaScriptParser.VOCABULARY }

    override public convenience init(_ input: TokenStream) throws { try self.init(input, State()) }

    public required init(_ input: TokenStream, _ state: State) throws {
        self.state = state

        RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
        try super.init(input)
        _interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
    }

    public class ProgramContext: ParserRuleContext {
        open func EOF() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.EOF.rawValue, 0)
        }
        open func HashBangLine() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.HashBangLine.rawValue, 0)
        }
        open func sourceElements() -> SourceElementsContext? {
            return getRuleContext(SourceElementsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_program }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterProgram(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitProgram(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitProgram(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitProgram(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func program() throws -> ProgramContext {
        var _localctx: ProgramContext
        _localctx = ProgramContext(_ctx, getState())
        try enterRule(_localctx, 0, JavaScriptParser.RULE_program)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(155)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 0, _ctx) {
            case 1:
                setState(154)
                try match(JavaScriptParser.Tokens.HashBangLine.rawValue)

                break
            default: break
            }
            setState(158)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
            case 1:
                setState(157)
                try sourceElements()

                break
            default: break
            }
            setState(160)
            try match(JavaScriptParser.Tokens.EOF.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SourceElementContext: ParserRuleContext {
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_sourceElement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterSourceElement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitSourceElement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitSourceElement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitSourceElement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func sourceElement() throws -> SourceElementContext {
        var _localctx: SourceElementContext
        _localctx = SourceElementContext(_ctx, getState())
        try enterRule(_localctx, 2, JavaScriptParser.RULE_sourceElement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(162)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StatementContext: ParserRuleContext {
        open func block() -> BlockContext? { return getRuleContext(BlockContext.self, 0) }
        open func variableStatement() -> VariableStatementContext? {
            return getRuleContext(VariableStatementContext.self, 0)
        }
        open func importStatement() -> ImportStatementContext? {
            return getRuleContext(ImportStatementContext.self, 0)
        }
        open func exportStatement() -> ExportStatementContext? {
            return getRuleContext(ExportStatementContext.self, 0)
        }
        open func emptyStatement_() -> EmptyStatement_Context? {
            return getRuleContext(EmptyStatement_Context.self, 0)
        }
        open func classDeclaration() -> ClassDeclarationContext? {
            return getRuleContext(ClassDeclarationContext.self, 0)
        }
        open func expressionStatement() -> ExpressionStatementContext? {
            return getRuleContext(ExpressionStatementContext.self, 0)
        }
        open func ifStatement() -> IfStatementContext? {
            return getRuleContext(IfStatementContext.self, 0)
        }
        open func iterationStatement() -> IterationStatementContext? {
            return getRuleContext(IterationStatementContext.self, 0)
        }
        open func continueStatement() -> ContinueStatementContext? {
            return getRuleContext(ContinueStatementContext.self, 0)
        }
        open func breakStatement() -> BreakStatementContext? {
            return getRuleContext(BreakStatementContext.self, 0)
        }
        open func returnStatement() -> ReturnStatementContext? {
            return getRuleContext(ReturnStatementContext.self, 0)
        }
        open func yieldStatement() -> YieldStatementContext? {
            return getRuleContext(YieldStatementContext.self, 0)
        }
        open func withStatement() -> WithStatementContext? {
            return getRuleContext(WithStatementContext.self, 0)
        }
        open func labelledStatement() -> LabelledStatementContext? {
            return getRuleContext(LabelledStatementContext.self, 0)
        }
        open func switchStatement() -> SwitchStatementContext? {
            return getRuleContext(SwitchStatementContext.self, 0)
        }
        open func throwStatement() -> ThrowStatementContext? {
            return getRuleContext(ThrowStatementContext.self, 0)
        }
        open func tryStatement() -> TryStatementContext? {
            return getRuleContext(TryStatementContext.self, 0)
        }
        open func debuggerStatement() -> DebuggerStatementContext? {
            return getRuleContext(DebuggerStatementContext.self, 0)
        }
        open func functionDeclaration() -> FunctionDeclarationContext? {
            return getRuleContext(FunctionDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_statement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitStatement(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func statement() throws -> StatementContext {
        var _localctx: StatementContext
        _localctx = StatementContext(_ctx, getState())
        try enterRule(_localctx, 4, JavaScriptParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(184)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 2, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(164)
                try block()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(165)
                try variableStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(166)
                try importStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(167)
                try exportStatement()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(168)
                try emptyStatement_()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(169)
                try classDeclaration()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(170)
                try expressionStatement()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(171)
                try ifStatement()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(172)
                try iterationStatement()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(173)
                try continueStatement()

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(174)
                try breakStatement()

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(175)
                try returnStatement()

                break
            case 13:
                try enterOuterAlt(_localctx, 13)
                setState(176)
                try yieldStatement()

                break
            case 14:
                try enterOuterAlt(_localctx, 14)
                setState(177)
                try withStatement()

                break
            case 15:
                try enterOuterAlt(_localctx, 15)
                setState(178)
                try labelledStatement()

                break
            case 16:
                try enterOuterAlt(_localctx, 16)
                setState(179)
                try switchStatement()

                break
            case 17:
                try enterOuterAlt(_localctx, 17)
                setState(180)
                try throwStatement()

                break
            case 18:
                try enterOuterAlt(_localctx, 18)
                setState(181)
                try tryStatement()

                break
            case 19:
                try enterOuterAlt(_localctx, 19)
                setState(182)
                try debuggerStatement()

                break
            case 20:
                try enterOuterAlt(_localctx, 20)
                setState(183)
                try functionDeclaration()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BlockContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func statementList() -> StatementListContext? {
            return getRuleContext(StatementListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_block }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterBlock(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitBlock(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBlock(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func block() throws -> BlockContext {
        var _localctx: BlockContext
        _localctx = BlockContext(_ctx, getState())
        try enterRule(_localctx, 6, JavaScriptParser.RULE_block)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(186)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(188)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 3, _ctx) {
            case 1:
                setState(187)
                try statementList()

                break
            default: break
            }
            setState(190)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StatementListContext: ParserRuleContext {
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_statementList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterStatementList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitStatementList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitStatementList(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitStatementList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func statementList() throws -> StatementListContext {
        var _localctx: StatementListContext
        _localctx = StatementListContext(_ctx, getState())
        try enterRule(_localctx, 8, JavaScriptParser.RULE_statementList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(193)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(192)
                    try statement()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(195)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 4, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportStatementContext: ParserRuleContext {
        open func Import() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
        }
        open func importFromBlock() -> ImportFromBlockContext? {
            return getRuleContext(ImportFromBlockContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_importStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importStatement() throws -> ImportStatementContext {
        var _localctx: ImportStatementContext
        _localctx = ImportStatementContext(_ctx, getState())
        try enterRule(_localctx, 10, JavaScriptParser.RULE_importStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(197)
            try match(JavaScriptParser.Tokens.Import.rawValue)
            setState(198)
            try importFromBlock()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportFromBlockContext: ParserRuleContext {
        open func importFrom() -> ImportFromContext? {
            return getRuleContext(ImportFromContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func importNamespace() -> ImportNamespaceContext? {
            return getRuleContext(ImportNamespaceContext.self, 0)
        }
        open func moduleItems() -> ModuleItemsContext? {
            return getRuleContext(ModuleItemsContext.self, 0)
        }
        open func importDefault() -> ImportDefaultContext? {
            return getRuleContext(ImportDefaultContext.self, 0)
        }
        open func StringLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_importFromBlock }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportFromBlock(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportFromBlock(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportFromBlock(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportFromBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importFromBlock() throws -> ImportFromBlockContext {
        var _localctx: ImportFromBlockContext
        _localctx = ImportFromBlockContext(_ctx, getState())
        try enterRule(_localctx, 12, JavaScriptParser.RULE_importFromBlock)
        defer { try! exitRule() }
        do {
            setState(212)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .OpenBrace, .Multiply, .NullLiteral, .BooleanLiteral, .Break, .Do, .Instanceof,
                .Typeof, .Case, .Else, .New, .Var, .Catch, .Finally, .Return, .Void, .Continue,
                .For, .Switch, .While, .Debugger, .Function_, .This, .With, .Default, .If, .Throw,
                .Delete, .In, .Try, .As, .From, .Class, .Enum, .Extends, .Super, .Const, .Export,
                .Import, .Async, .Await, .Yield, .Implements, .StrictLet, .NonStrictLet, .Private,
                .Public, .Interface, .Package, .Protected, .Static, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(201)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 5, _ctx) {
                case 1:
                    setState(200)
                    try importDefault()

                    break
                default: break
                }
                setState(205)
                try _errHandler.sync(self)
                switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
                case .Multiply, .NullLiteral, .BooleanLiteral, .Break, .Do, .Instanceof, .Typeof,
                    .Case, .Else, .New, .Var, .Catch, .Finally, .Return, .Void, .Continue, .For,
                    .Switch, .While, .Debugger, .Function_, .This, .With, .Default, .If, .Throw,
                    .Delete, .In, .Try, .As, .From, .Class, .Enum, .Extends, .Super, .Const,
                    .Export, .Import, .Async, .Await, .Yield, .Implements, .StrictLet,
                    .NonStrictLet, .Private, .Public, .Interface, .Package, .Protected, .Static,
                    .Identifier:
                    setState(203)
                    try importNamespace()

                    break

                case .OpenBrace:
                    setState(204)
                    try moduleItems()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(207)
                try importFrom()
                setState(208)
                try eos()

                break

            case .StringLiteral:
                try enterOuterAlt(_localctx, 2)
                setState(210)
                try match(JavaScriptParser.Tokens.StringLiteral.rawValue)
                setState(211)
                try eos()

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

    public class ModuleItemsContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func aliasName() -> [AliasNameContext] {
            return getRuleContexts(AliasNameContext.self)
        }
        open func aliasName(_ i: Int) -> AliasNameContext? {
            return getRuleContext(AliasNameContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_moduleItems }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterModuleItems(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitModuleItems(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitModuleItems(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitModuleItems(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func moduleItems() throws -> ModuleItemsContext {
        var _localctx: ModuleItemsContext
        _localctx = ModuleItemsContext(_ctx, getState())
        try enterRule(_localctx, 14, JavaScriptParser.RULE_moduleItems)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(214)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(220)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 8, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(215)
                    try aliasName()
                    setState(216)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)

                }
                setState(222)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 8, _ctx)
            }
            setState(227)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 61)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 61)) & 576_460_752_303_421_443) != 0
            {
                setState(223)
                try aliasName()
                setState(225)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Comma.rawValue {
                    setState(224)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)

                }

            }

            setState(229)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportDefaultContext: ParserRuleContext {
        open func aliasName() -> AliasNameContext? {
            return getRuleContext(AliasNameContext.self, 0)
        }
        open func Comma() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_importDefault }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportDefault(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportDefault(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportDefault(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportDefault(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importDefault() throws -> ImportDefaultContext {
        var _localctx: ImportDefaultContext
        _localctx = ImportDefaultContext(_ctx, getState())
        try enterRule(_localctx, 16, JavaScriptParser.RULE_importDefault)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(231)
            try aliasName()
            setState(232)
            try match(JavaScriptParser.Tokens.Comma.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportNamespaceContext: ParserRuleContext {
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func identifierName() -> [IdentifierNameContext] {
            return getRuleContexts(IdentifierNameContext.self)
        }
        open func identifierName(_ i: Int) -> IdentifierNameContext? {
            return getRuleContext(IdentifierNameContext.self, i)
        }
        open func As() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.As.rawValue, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_importNamespace }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportNamespace(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportNamespace(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportNamespace(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportNamespace(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importNamespace() throws -> ImportNamespaceContext {
        var _localctx: ImportNamespaceContext
        _localctx = ImportNamespaceContext(_ctx, getState())
        try enterRule(_localctx, 18, JavaScriptParser.RULE_importNamespace)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(236)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Multiply:
                setState(234)
                try match(JavaScriptParser.Tokens.Multiply.rawValue)

                break
            case .NullLiteral, .BooleanLiteral, .Break, .Do, .Instanceof, .Typeof, .Case, .Else,
                .New, .Var, .Catch, .Finally, .Return, .Void, .Continue, .For, .Switch, .While,
                .Debugger, .Function_, .This, .With, .Default, .If, .Throw, .Delete, .In, .Try, .As,
                .From, .Class, .Enum, .Extends, .Super, .Const, .Export, .Import, .Async, .Await,
                .Yield, .Implements, .StrictLet, .NonStrictLet, .Private, .Public, .Interface,
                .Package, .Protected, .Static, .Identifier:
                setState(235)
                try identifierName()

                break
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
            setState(240)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.As.rawValue {
                setState(238)
                try match(JavaScriptParser.Tokens.As.rawValue)
                setState(239)
                try identifierName()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportFromContext: ParserRuleContext {
        open func From() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.From.rawValue, 0)
        }
        open func StringLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_importFrom }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportFrom(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportFrom(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportFrom(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportFrom(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importFrom() throws -> ImportFromContext {
        var _localctx: ImportFromContext
        _localctx = ImportFromContext(_ctx, getState())
        try enterRule(_localctx, 20, JavaScriptParser.RULE_importFrom)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(242)
            try match(JavaScriptParser.Tokens.From.rawValue)
            setState(243)
            try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AliasNameContext: ParserRuleContext {
        open func identifierName() -> [IdentifierNameContext] {
            return getRuleContexts(IdentifierNameContext.self)
        }
        open func identifierName(_ i: Int) -> IdentifierNameContext? {
            return getRuleContext(IdentifierNameContext.self, i)
        }
        open func As() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.As.rawValue, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_aliasName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAliasName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitAliasName(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAliasName(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAliasName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func aliasName() throws -> AliasNameContext {
        var _localctx: AliasNameContext
        _localctx = AliasNameContext(_ctx, getState())
        try enterRule(_localctx, 22, JavaScriptParser.RULE_aliasName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(245)
            try identifierName()
            setState(248)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.As.rawValue {
                setState(246)
                try match(JavaScriptParser.Tokens.As.rawValue)
                setState(247)
                try identifierName()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ExportStatementContext: ParserRuleContext {
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_exportStatement }
    }
    public class ExportDefaultDeclarationContext: ExportStatementContext {
        open func Export() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
        }
        open func Default() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }

        public init(_ ctx: ExportStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterExportDefaultDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitExportDefaultDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitExportDefaultDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitExportDefaultDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ExportDeclarationContext: ExportStatementContext {
        open func Export() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func exportFromBlock() -> ExportFromBlockContext? {
            return getRuleContext(ExportFromBlockContext.self, 0)
        }
        open func declaration() -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, 0)
        }

        public init(_ ctx: ExportStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterExportDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitExportDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitExportDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitExportDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func exportStatement() throws -> ExportStatementContext {
        var _localctx: ExportStatementContext
        _localctx = ExportStatementContext(_ctx, getState())
        try enterRule(_localctx, 24, JavaScriptParser.RULE_exportStatement)
        defer { try! exitRule() }
        do {
            setState(262)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 15, _ctx) {
            case 1:
                _localctx = ExportDeclarationContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(250)
                try match(JavaScriptParser.Tokens.Export.rawValue)
                setState(253)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 14, _ctx) {
                case 1:
                    setState(251)
                    try exportFromBlock()

                    break
                case 2:
                    setState(252)
                    try declaration()

                    break
                default: break
                }
                setState(255)
                try eos()

                break
            case 2:
                _localctx = ExportDefaultDeclarationContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(257)
                try match(JavaScriptParser.Tokens.Export.rawValue)
                setState(258)
                try match(JavaScriptParser.Tokens.Default.rawValue)
                setState(259)
                try singleExpression(0)
                setState(260)
                try eos()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ExportFromBlockContext: ParserRuleContext {
        open func importNamespace() -> ImportNamespaceContext? {
            return getRuleContext(ImportNamespaceContext.self, 0)
        }
        open func importFrom() -> ImportFromContext? {
            return getRuleContext(ImportFromContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func moduleItems() -> ModuleItemsContext? {
            return getRuleContext(ModuleItemsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_exportFromBlock }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterExportFromBlock(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitExportFromBlock(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitExportFromBlock(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitExportFromBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func exportFromBlock() throws -> ExportFromBlockContext {
        var _localctx: ExportFromBlockContext
        _localctx = ExportFromBlockContext(_ctx, getState())
        try enterRule(_localctx, 26, JavaScriptParser.RULE_exportFromBlock)
        defer { try! exitRule() }
        do {
            setState(274)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Multiply, .NullLiteral, .BooleanLiteral, .Break, .Do, .Instanceof, .Typeof, .Case,
                .Else, .New, .Var, .Catch, .Finally, .Return, .Void, .Continue, .For, .Switch,
                .While, .Debugger, .Function_, .This, .With, .Default, .If, .Throw, .Delete, .In,
                .Try, .As, .From, .Class, .Enum, .Extends, .Super, .Const, .Export, .Import, .Async,
                .Await, .Yield, .Implements, .StrictLet, .NonStrictLet, .Private, .Public,
                .Interface, .Package, .Protected, .Static, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(264)
                try importNamespace()
                setState(265)
                try importFrom()
                setState(266)
                try eos()

                break

            case .OpenBrace:
                try enterOuterAlt(_localctx, 2)
                setState(268)
                try moduleItems()
                setState(270)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 16, _ctx) {
                case 1:
                    setState(269)
                    try importFrom()

                    break
                default: break
                }
                setState(272)
                try eos()

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

    public class DeclarationContext: ParserRuleContext {
        open func variableStatement() -> VariableStatementContext? {
            return getRuleContext(VariableStatementContext.self, 0)
        }
        open func classDeclaration() -> ClassDeclarationContext? {
            return getRuleContext(ClassDeclarationContext.self, 0)
        }
        open func functionDeclaration() -> FunctionDeclarationContext? {
            return getRuleContext(FunctionDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_declaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declaration() throws -> DeclarationContext {
        var _localctx: DeclarationContext
        _localctx = DeclarationContext(_ctx, getState())
        try enterRule(_localctx, 28, JavaScriptParser.RULE_declaration)
        defer { try! exitRule() }
        do {
            setState(279)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Var, .Const, .StrictLet, .NonStrictLet:
                try enterOuterAlt(_localctx, 1)
                setState(276)
                try variableStatement()

                break

            case .Class:
                try enterOuterAlt(_localctx, 2)
                setState(277)
                try classDeclaration()

                break
            case .Function_, .Async:
                try enterOuterAlt(_localctx, 3)
                setState(278)
                try functionDeclaration()

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

    public class VariableStatementContext: ParserRuleContext {
        open func variableDeclarationList() -> VariableDeclarationListContext? {
            return getRuleContext(VariableDeclarationListContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_variableStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterVariableStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitVariableStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitVariableStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitVariableStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func variableStatement() throws -> VariableStatementContext {
        var _localctx: VariableStatementContext
        _localctx = VariableStatementContext(_ctx, getState())
        try enterRule(_localctx, 30, JavaScriptParser.RULE_variableStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(281)
            try variableDeclarationList()
            setState(282)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VariableDeclarationListContext: ParserRuleContext {
        open func varModifier() -> VarModifierContext? {
            return getRuleContext(VarModifierContext.self, 0)
        }
        open func variableDeclaration() -> [VariableDeclarationContext] {
            return getRuleContexts(VariableDeclarationContext.self)
        }
        open func variableDeclaration(_ i: Int) -> VariableDeclarationContext? {
            return getRuleContext(VariableDeclarationContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_variableDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterVariableDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitVariableDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitVariableDeclarationList(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitVariableDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func variableDeclarationList() throws -> VariableDeclarationListContext
    {
        var _localctx: VariableDeclarationListContext
        _localctx = VariableDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 32, JavaScriptParser.RULE_variableDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(284)
            try varModifier()
            setState(285)
            try variableDeclaration()
            setState(290)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 19, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(286)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)
                    setState(287)
                    try variableDeclaration()

                }
                setState(292)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 19, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VariableDeclarationContext: ParserRuleContext {
        open func assignable() -> AssignableContext? {
            return getRuleContext(AssignableContext.self, 0)
        }
        open func Assign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_variableDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterVariableDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitVariableDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitVariableDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitVariableDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func variableDeclaration() throws -> VariableDeclarationContext {
        var _localctx: VariableDeclarationContext
        _localctx = VariableDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 34, JavaScriptParser.RULE_variableDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(293)
            try assignable()
            setState(296)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 20, _ctx) {
            case 1:
                setState(294)
                try match(JavaScriptParser.Tokens.Assign.rawValue)
                setState(295)
                try singleExpression(0)

                break
            default: break
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EmptyStatement_Context: ParserRuleContext {
        open func SemiColon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_emptyStatement_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterEmptyStatement_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitEmptyStatement_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitEmptyStatement_(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitEmptyStatement_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func emptyStatement_() throws -> EmptyStatement_Context {
        var _localctx: EmptyStatement_Context
        _localctx = EmptyStatement_Context(_ctx, getState())
        try enterRule(_localctx, 36, JavaScriptParser.RULE_emptyStatement_)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(298)
            try match(JavaScriptParser.Tokens.SemiColon.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ExpressionStatementContext: ParserRuleContext {
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_expressionStatement
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterExpressionStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitExpressionStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitExpressionStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitExpressionStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func expressionStatement() throws -> ExpressionStatementContext {
        var _localctx: ExpressionStatementContext
        _localctx = ExpressionStatementContext(_ctx, getState())
        try enterRule(_localctx, 38, JavaScriptParser.RULE_expressionStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(300)
            if !(try self.notOpenBraceAndNotFunction()) {
                throw ANTLRException.recognition(
                    e: FailedPredicateException(self, "try self.notOpenBraceAndNotFunction()"))
            }
            setState(301)
            try expressionSequence()
            setState(302)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IfStatementContext: ParserRuleContext {
        open func If() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.If.rawValue, 0) }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        open func Else() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Else.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_ifStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterIfStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitIfStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitIfStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitIfStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func ifStatement() throws -> IfStatementContext {
        var _localctx: IfStatementContext
        _localctx = IfStatementContext(_ctx, getState())
        try enterRule(_localctx, 40, JavaScriptParser.RULE_ifStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(304)
            try match(JavaScriptParser.Tokens.If.rawValue)
            setState(305)
            try match(JavaScriptParser.Tokens.OpenParen.rawValue)
            setState(306)
            try expressionSequence()
            setState(307)
            try match(JavaScriptParser.Tokens.CloseParen.rawValue)
            setState(308)
            try statement()
            setState(311)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 21, _ctx) {
            case 1:
                setState(309)
                try match(JavaScriptParser.Tokens.Else.rawValue)
                setState(310)
                try statement()

                break
            default: break
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IterationStatementContext: ParserRuleContext {
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_iterationStatement }
    }
    public class DoStatementContext: IterationStatementContext {
        open func Do() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.Do.rawValue, 0) }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func While() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }

        public init(_ ctx: IterationStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterDoStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitDoStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitDoStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitDoStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class WhileStatementContext: IterationStatementContext {
        open func While() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }

        public init(_ ctx: IterationStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterWhileStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitWhileStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitWhileStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitWhileStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ForStatementContext: IterationStatementContext {
        open func For() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func SemiColon() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.SemiColon.rawValue)
        }
        open func SemiColon(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, i)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func expressionSequence() -> [ExpressionSequenceContext] {
            return getRuleContexts(ExpressionSequenceContext.self)
        }
        open func expressionSequence(_ i: Int) -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, i)
        }
        open func variableDeclarationList() -> VariableDeclarationListContext? {
            return getRuleContext(VariableDeclarationListContext.self, 0)
        }

        public init(_ ctx: IterationStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterForStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitForStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitForStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitForStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ForInStatementContext: IterationStatementContext {
        open func For() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func In() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.In.rawValue, 0) }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func variableDeclarationList() -> VariableDeclarationListContext? {
            return getRuleContext(VariableDeclarationListContext.self, 0)
        }

        public init(_ ctx: IterationStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterForInStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitForInStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitForInStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitForInStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ForOfStatementContext: IterationStatementContext {
        open func For() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func variableDeclarationList() -> VariableDeclarationListContext? {
            return getRuleContext(VariableDeclarationListContext.self, 0)
        }
        open func Await() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
        }

        public init(_ ctx: IterationStatementContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterForOfStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitForOfStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitForOfStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitForOfStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func iterationStatement() throws -> IterationStatementContext {
        var _localctx: IterationStatementContext
        _localctx = IterationStatementContext(_ctx, getState())
        try enterRule(_localctx, 42, JavaScriptParser.RULE_iterationStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(369)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 28, _ctx) {
            case 1:
                _localctx = DoStatementContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(313)
                try match(JavaScriptParser.Tokens.Do.rawValue)
                setState(314)
                try statement()
                setState(315)
                try match(JavaScriptParser.Tokens.While.rawValue)
                setState(316)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(317)
                try expressionSequence()
                setState(318)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(319)
                try eos()

                break
            case 2:
                _localctx = WhileStatementContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(321)
                try match(JavaScriptParser.Tokens.While.rawValue)
                setState(322)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(323)
                try expressionSequence()
                setState(324)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(325)
                try statement()

                break
            case 3:
                _localctx = ForStatementContext(_localctx)
                try enterOuterAlt(_localctx, 3)
                setState(327)
                try match(JavaScriptParser.Tokens.For.rawValue)
                setState(328)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(331)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 22, _ctx) {
                case 1:
                    setState(329)
                    try expressionSequence()

                    break
                case 2:
                    setState(330)
                    try variableDeclarationList()

                    break
                default: break
                }
                setState(333)
                try match(JavaScriptParser.Tokens.SemiColon.rawValue)
                setState(335)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & -2_305_843_009_147_632_976) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 64)) & 252_549_645_531_105_535) != 0
                {
                    setState(334)
                    try expressionSequence()

                }

                setState(337)
                try match(JavaScriptParser.Tokens.SemiColon.rawValue)
                setState(339)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & -2_305_843_009_147_632_976) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 64)) & 252_549_645_531_105_535) != 0
                {
                    setState(338)
                    try expressionSequence()

                }

                setState(341)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(342)
                try statement()

                break
            case 4:
                _localctx = ForInStatementContext(_localctx)
                try enterOuterAlt(_localctx, 4)
                setState(343)
                try match(JavaScriptParser.Tokens.For.rawValue)
                setState(344)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(347)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 25, _ctx) {
                case 1:
                    setState(345)
                    try singleExpression(0)

                    break
                case 2:
                    setState(346)
                    try variableDeclarationList()

                    break
                default: break
                }
                setState(349)
                try match(JavaScriptParser.Tokens.In.rawValue)
                setState(350)
                try expressionSequence()
                setState(351)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(352)
                try statement()

                break
            case 5:
                _localctx = ForOfStatementContext(_localctx)
                try enterOuterAlt(_localctx, 5)
                setState(354)
                try match(JavaScriptParser.Tokens.For.rawValue)
                setState(356)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Await.rawValue {
                    setState(355)
                    try match(JavaScriptParser.Tokens.Await.rawValue)

                }

                setState(358)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(361)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 27, _ctx) {
                case 1:
                    setState(359)
                    try singleExpression(0)

                    break
                case 2:
                    setState(360)
                    try variableDeclarationList()

                    break
                default: break
                }
                setState(363)
                try identifier()
                setState(364)
                if !(try self.p("of")) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.p(\"of\")"))
                }
                setState(365)
                try expressionSequence()
                setState(366)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(367)
                try statement()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VarModifierContext: ParserRuleContext {
        open func Var() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Var.rawValue, 0)
        }
        open func let_() -> Let_Context? { return getRuleContext(Let_Context.self, 0) }
        open func Const() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Const.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_varModifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterVarModifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitVarModifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitVarModifier(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitVarModifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func varModifier() throws -> VarModifierContext {
        var _localctx: VarModifierContext
        _localctx = VarModifierContext(_ctx, getState())
        try enterRule(_localctx, 44, JavaScriptParser.RULE_varModifier)
        defer { try! exitRule() }
        do {
            setState(374)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Var:
                try enterOuterAlt(_localctx, 1)
                setState(371)
                try match(JavaScriptParser.Tokens.Var.rawValue)

                break
            case .StrictLet, .NonStrictLet:
                try enterOuterAlt(_localctx, 2)
                setState(372)
                try let_()

                break

            case .Const:
                try enterOuterAlt(_localctx, 3)
                setState(373)
                try match(JavaScriptParser.Tokens.Const.rawValue)

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

    public class ContinueStatementContext: ParserRuleContext {
        open func Continue() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Continue.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_continueStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterContinueStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitContinueStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitContinueStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitContinueStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func continueStatement() throws -> ContinueStatementContext {
        var _localctx: ContinueStatementContext
        _localctx = ContinueStatementContext(_ctx, getState())
        try enterRule(_localctx, 46, JavaScriptParser.RULE_continueStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(376)
            try match(JavaScriptParser.Tokens.Continue.rawValue)
            setState(379)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 30, _ctx) {
            case 1:
                setState(377)
                if !(try self.notLineTerminator()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.notLineTerminator()"))
                }
                setState(378)
                try identifier()

                break
            default: break
            }
            setState(381)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BreakStatementContext: ParserRuleContext {
        open func Break() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Break.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_breakStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBreakStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBreakStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBreakStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBreakStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func breakStatement() throws -> BreakStatementContext {
        var _localctx: BreakStatementContext
        _localctx = BreakStatementContext(_ctx, getState())
        try enterRule(_localctx, 48, JavaScriptParser.RULE_breakStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(383)
            try match(JavaScriptParser.Tokens.Break.rawValue)
            setState(386)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 31, _ctx) {
            case 1:
                setState(384)
                if !(try self.notLineTerminator()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.notLineTerminator()"))
                }
                setState(385)
                try identifier()

                break
            default: break
            }
            setState(388)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ReturnStatementContext: ParserRuleContext {
        open func Return() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Return.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_returnStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterReturnStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitReturnStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitReturnStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitReturnStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func returnStatement() throws -> ReturnStatementContext {
        var _localctx: ReturnStatementContext
        _localctx = ReturnStatementContext(_ctx, getState())
        try enterRule(_localctx, 50, JavaScriptParser.RULE_returnStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(390)
            try match(JavaScriptParser.Tokens.Return.rawValue)
            setState(393)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 32, _ctx) {
            case 1:
                setState(391)
                if !(try self.notLineTerminator()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.notLineTerminator()"))
                }
                setState(392)
                try expressionSequence()

                break
            default: break
            }
            setState(395)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class YieldStatementContext: ParserRuleContext {
        open func Yield() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Yield.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_yieldStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterYieldStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitYieldStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitYieldStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitYieldStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func yieldStatement() throws -> YieldStatementContext {
        var _localctx: YieldStatementContext
        _localctx = YieldStatementContext(_ctx, getState())
        try enterRule(_localctx, 52, JavaScriptParser.RULE_yieldStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(397)
            try match(JavaScriptParser.Tokens.Yield.rawValue)
            setState(400)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 33, _ctx) {
            case 1:
                setState(398)
                if !(try self.notLineTerminator()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.notLineTerminator()"))
                }
                setState(399)
                try expressionSequence()

                break
            default: break
            }
            setState(402)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class WithStatementContext: ParserRuleContext {
        open func With() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.With.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_withStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterWithStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitWithStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitWithStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitWithStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func withStatement() throws -> WithStatementContext {
        var _localctx: WithStatementContext
        _localctx = WithStatementContext(_ctx, getState())
        try enterRule(_localctx, 54, JavaScriptParser.RULE_withStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(404)
            try match(JavaScriptParser.Tokens.With.rawValue)
            setState(405)
            try match(JavaScriptParser.Tokens.OpenParen.rawValue)
            setState(406)
            try expressionSequence()
            setState(407)
            try match(JavaScriptParser.Tokens.CloseParen.rawValue)
            setState(408)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SwitchStatementContext: ParserRuleContext {
        open func Switch() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Switch.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func caseBlock() -> CaseBlockContext? {
            return getRuleContext(CaseBlockContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_switchStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterSwitchStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitSwitchStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitSwitchStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitSwitchStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func switchStatement() throws -> SwitchStatementContext {
        var _localctx: SwitchStatementContext
        _localctx = SwitchStatementContext(_ctx, getState())
        try enterRule(_localctx, 56, JavaScriptParser.RULE_switchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(410)
            try match(JavaScriptParser.Tokens.Switch.rawValue)
            setState(411)
            try match(JavaScriptParser.Tokens.OpenParen.rawValue)
            setState(412)
            try expressionSequence()
            setState(413)
            try match(JavaScriptParser.Tokens.CloseParen.rawValue)
            setState(414)
            try caseBlock()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CaseBlockContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func caseClauses() -> [CaseClausesContext] {
            return getRuleContexts(CaseClausesContext.self)
        }
        open func caseClauses(_ i: Int) -> CaseClausesContext? {
            return getRuleContext(CaseClausesContext.self, i)
        }
        open func defaultClause() -> DefaultClauseContext? {
            return getRuleContext(DefaultClauseContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_caseBlock }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterCaseBlock(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitCaseBlock(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitCaseBlock(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitCaseBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func caseBlock() throws -> CaseBlockContext {
        var _localctx: CaseBlockContext
        _localctx = CaseBlockContext(_ctx, getState())
        try enterRule(_localctx, 58, JavaScriptParser.RULE_caseBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(416)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(418)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Case.rawValue {
                setState(417)
                try caseClauses()

            }

            setState(424)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Default.rawValue {
                setState(420)
                try defaultClause()
                setState(422)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Case.rawValue {
                    setState(421)
                    try caseClauses()

                }

            }

            setState(426)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CaseClausesContext: ParserRuleContext {
        open func caseClause() -> [CaseClauseContext] {
            return getRuleContexts(CaseClauseContext.self)
        }
        open func caseClause(_ i: Int) -> CaseClauseContext? {
            return getRuleContext(CaseClauseContext.self, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_caseClauses }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterCaseClauses(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitCaseClauses(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitCaseClauses(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitCaseClauses(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func caseClauses() throws -> CaseClausesContext {
        var _localctx: CaseClausesContext
        _localctx = CaseClausesContext(_ctx, getState())
        try enterRule(_localctx, 60, JavaScriptParser.RULE_caseClauses)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(429)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(428)
                try caseClause()

                setState(431)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == JavaScriptParser.Tokens.Case.rawValue

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CaseClauseContext: ParserRuleContext {
        open func Case() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Case.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }
        open func statementList() -> StatementListContext? {
            return getRuleContext(StatementListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_caseClause }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterCaseClause(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitCaseClause(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitCaseClause(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitCaseClause(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func caseClause() throws -> CaseClauseContext {
        var _localctx: CaseClauseContext
        _localctx = CaseClauseContext(_ctx, getState())
        try enterRule(_localctx, 62, JavaScriptParser.RULE_caseClause)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(433)
            try match(JavaScriptParser.Tokens.Case.rawValue)
            setState(434)
            try expressionSequence()
            setState(435)
            try match(JavaScriptParser.Tokens.Colon.rawValue)
            setState(437)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 38, _ctx) {
            case 1:
                setState(436)
                try statementList()

                break
            default: break
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DefaultClauseContext: ParserRuleContext {
        open func Default() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }
        open func statementList() -> StatementListContext? {
            return getRuleContext(StatementListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_defaultClause }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterDefaultClause(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitDefaultClause(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitDefaultClause(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitDefaultClause(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func defaultClause() throws -> DefaultClauseContext {
        var _localctx: DefaultClauseContext
        _localctx = DefaultClauseContext(_ctx, getState())
        try enterRule(_localctx, 64, JavaScriptParser.RULE_defaultClause)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(439)
            try match(JavaScriptParser.Tokens.Default.rawValue)
            setState(440)
            try match(JavaScriptParser.Tokens.Colon.rawValue)
            setState(442)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 39, _ctx) {
            case 1:
                setState(441)
                try statementList()

                break
            default: break
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class LabelledStatementContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_labelledStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterLabelledStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitLabelledStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLabelledStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLabelledStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func labelledStatement() throws -> LabelledStatementContext {
        var _localctx: LabelledStatementContext
        _localctx = LabelledStatementContext(_ctx, getState())
        try enterRule(_localctx, 66, JavaScriptParser.RULE_labelledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(444)
            try identifier()
            setState(445)
            try match(JavaScriptParser.Tokens.Colon.rawValue)
            setState(446)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ThrowStatementContext: ParserRuleContext {
        open func Throw() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Throw.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_throwStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterThrowStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitThrowStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitThrowStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitThrowStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func throwStatement() throws -> ThrowStatementContext {
        var _localctx: ThrowStatementContext
        _localctx = ThrowStatementContext(_ctx, getState())
        try enterRule(_localctx, 68, JavaScriptParser.RULE_throwStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(448)
            try match(JavaScriptParser.Tokens.Throw.rawValue)
            setState(449)
            if !(try self.notLineTerminator()) {
                throw ANTLRException.recognition(
                    e: FailedPredicateException(self, "try self.notLineTerminator()"))
            }
            setState(450)
            try expressionSequence()
            setState(451)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TryStatementContext: ParserRuleContext {
        open func Try() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Try.rawValue, 0)
        }
        open func block() -> BlockContext? { return getRuleContext(BlockContext.self, 0) }
        open func catchProduction() -> CatchProductionContext? {
            return getRuleContext(CatchProductionContext.self, 0)
        }
        open func finallyProduction() -> FinallyProductionContext? {
            return getRuleContext(FinallyProductionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_tryStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTryStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTryStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTryStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTryStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func tryStatement() throws -> TryStatementContext {
        var _localctx: TryStatementContext
        _localctx = TryStatementContext(_ctx, getState())
        try enterRule(_localctx, 70, JavaScriptParser.RULE_tryStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(453)
            try match(JavaScriptParser.Tokens.Try.rawValue)
            setState(454)
            try block()
            setState(460)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Catch:
                setState(455)
                try catchProduction()
                setState(457)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 40, _ctx) {
                case 1:
                    setState(456)
                    try finallyProduction()

                    break
                default: break
                }

                break

            case .Finally:
                setState(459)
                try finallyProduction()

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

    public class CatchProductionContext: ParserRuleContext {
        open func Catch() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Catch.rawValue, 0)
        }
        open func block() -> BlockContext? { return getRuleContext(BlockContext.self, 0) }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func assignable() -> AssignableContext? {
            return getRuleContext(AssignableContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_catchProduction }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterCatchProduction(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitCatchProduction(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitCatchProduction(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitCatchProduction(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func catchProduction() throws -> CatchProductionContext {
        var _localctx: CatchProductionContext
        _localctx = CatchProductionContext(_ctx, getState())
        try enterRule(_localctx, 72, JavaScriptParser.RULE_catchProduction)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(462)
            try match(JavaScriptParser.Tokens.Catch.rawValue)
            setState(468)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.OpenParen.rawValue {
                setState(463)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(465)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.OpenBracket.rawValue
                    || _la == JavaScriptParser.Tokens.OpenBrace.rawValue
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(464)
                    try assignable()

                }

                setState(467)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)

            }

            setState(470)
            try block()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FinallyProductionContext: ParserRuleContext {
        open func Finally() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Finally.rawValue, 0)
        }
        open func block() -> BlockContext? { return getRuleContext(BlockContext.self, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_finallyProduction }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFinallyProduction(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFinallyProduction(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFinallyProduction(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFinallyProduction(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func finallyProduction() throws -> FinallyProductionContext {
        var _localctx: FinallyProductionContext
        _localctx = FinallyProductionContext(_ctx, getState())
        try enterRule(_localctx, 74, JavaScriptParser.RULE_finallyProduction)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(472)
            try match(JavaScriptParser.Tokens.Finally.rawValue)
            setState(473)
            try block()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DebuggerStatementContext: ParserRuleContext {
        open func Debugger() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Debugger.rawValue, 0)
        }
        open func eos() -> EosContext? { return getRuleContext(EosContext.self, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_debuggerStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterDebuggerStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitDebuggerStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitDebuggerStatement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitDebuggerStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func debuggerStatement() throws -> DebuggerStatementContext {
        var _localctx: DebuggerStatementContext
        _localctx = DebuggerStatementContext(_ctx, getState())
        try enterRule(_localctx, 76, JavaScriptParser.RULE_debuggerStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(475)
            try match(JavaScriptParser.Tokens.Debugger.rawValue)
            setState(476)
            try eos()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionDeclarationContext: ParserRuleContext {
        open func Function_() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func formalParameterList() -> FormalParameterListContext? {
            return getRuleContext(FormalParameterListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_functionDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFunctionDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFunctionDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFunctionDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFunctionDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionDeclaration() throws -> FunctionDeclarationContext {
        var _localctx: FunctionDeclarationContext
        _localctx = FunctionDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 78, JavaScriptParser.RULE_functionDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(479)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Async.rawValue {
                setState(478)
                try match(JavaScriptParser.Tokens.Async.rawValue)

            }

            setState(481)
            try match(JavaScriptParser.Tokens.Function_.rawValue)
            setState(483)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Multiply.rawValue {
                setState(482)
                try match(JavaScriptParser.Tokens.Multiply.rawValue)

            }

            setState(485)
            try identifier()
            setState(486)
            try match(JavaScriptParser.Tokens.OpenParen.rawValue)
            setState(488)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
            {
                setState(487)
                try formalParameterList()

            }

            setState(490)
            try match(JavaScriptParser.Tokens.CloseParen.rawValue)
            setState(491)
            try functionBody()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassDeclarationContext: ParserRuleContext {
        open func Class() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func classTail() -> ClassTailContext? {
            return getRuleContext(ClassTailContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_classDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterClassDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitClassDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitClassDeclaration(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitClassDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classDeclaration() throws -> ClassDeclarationContext {
        var _localctx: ClassDeclarationContext
        _localctx = ClassDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 80, JavaScriptParser.RULE_classDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(493)
            try match(JavaScriptParser.Tokens.Class.rawValue)
            setState(494)
            try identifier()
            setState(495)
            try classTail()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassTailContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func Extends() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Extends.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func classElement() -> [ClassElementContext] {
            return getRuleContexts(ClassElementContext.self)
        }
        open func classElement(_ i: Int) -> ClassElementContext? {
            return getRuleContext(ClassElementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_classTail }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterClassTail(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitClassTail(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitClassTail(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitClassTail(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classTail() throws -> ClassTailContext {
        var _localctx: ClassTailContext
        _localctx = ClassTailContext(_ctx, getState())
        try enterRule(_localctx, 82, JavaScriptParser.RULE_classTail)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(499)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Extends.rawValue {
                setState(497)
                try match(JavaScriptParser.Tokens.Extends.rawValue)
                setState(498)
                try singleExpression(0)

            }

            setState(501)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(505)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 48, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(502)
                    try classElement()

                }
                setState(507)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 48, _ctx)
            }
            setState(508)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassElementContext: ParserRuleContext {
        open func methodDefinition() -> MethodDefinitionContext? {
            return getRuleContext(MethodDefinitionContext.self, 0)
        }
        open func assignable() -> AssignableContext? {
            return getRuleContext(AssignableContext.self, 0)
        }
        open func Assign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
        }
        open func objectLiteral() -> ObjectLiteralContext? {
            return getRuleContext(ObjectLiteralContext.self, 0)
        }
        open func SemiColon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
        }
        open func Static() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Static.rawValue)
        }
        open func Static(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Static.rawValue, i)
        }
        open func identifier() -> [IdentifierContext] {
            return getRuleContexts(IdentifierContext.self)
        }
        open func identifier(_ i: Int) -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, i)
        }
        open func Async() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Async.rawValue)
        }
        open func Async(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, i)
        }
        open func emptyStatement_() -> EmptyStatement_Context? {
            return getRuleContext(EmptyStatement_Context.self, 0)
        }
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func Hashtag() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_classElement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterClassElement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitClassElement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitClassElement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitClassElement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classElement() throws -> ClassElementContext {
        var _localctx: ClassElementContext
        _localctx = ClassElementContext(_ctx, getState())
        try enterRule(_localctx, 84, JavaScriptParser.RULE_classElement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(535)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 53, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(516)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 50, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(514)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 49, _ctx) {
                        case 1:
                            setState(510)
                            try match(JavaScriptParser.Tokens.Static.rawValue)

                            break
                        case 2:
                            setState(511)
                            if !(try self.n("static")) {
                                throw ANTLRException.recognition(
                                    e: FailedPredicateException(self, "try self.n(\"static\")"))
                            }
                            setState(512)
                            try identifier()

                            break
                        case 3:
                            setState(513)
                            try match(JavaScriptParser.Tokens.Async.rawValue)

                            break
                        default: break
                        }
                    }
                    setState(518)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 50, _ctx)
                }
                setState(525)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 51, _ctx) {
                case 1:
                    setState(519)
                    try methodDefinition()

                    break
                case 2:
                    setState(520)
                    try assignable()
                    setState(521)
                    try match(JavaScriptParser.Tokens.Assign.rawValue)
                    setState(522)
                    try objectLiteral()
                    setState(523)
                    try match(JavaScriptParser.Tokens.SemiColon.rawValue)

                    break
                default: break
                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(527)
                try emptyStatement_()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(529)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Hashtag.rawValue {
                    setState(528)
                    try match(JavaScriptParser.Tokens.Hashtag.rawValue)

                }

                setState(531)
                try propertyName()
                setState(532)
                try match(JavaScriptParser.Tokens.Assign.rawValue)
                setState(533)
                try singleExpression(0)

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MethodDefinitionContext: ParserRuleContext {
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func Hashtag() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
        }
        open func formalParameterList() -> FormalParameterListContext? {
            return getRuleContext(FormalParameterListContext.self, 0)
        }
        open func getter() -> GetterContext? { return getRuleContext(GetterContext.self, 0) }
        open func setter() -> SetterContext? { return getRuleContext(SetterContext.self, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_methodDefinition }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterMethodDefinition(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitMethodDefinition(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitMethodDefinition(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitMethodDefinition(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func methodDefinition() throws -> MethodDefinitionContext {
        var _localctx: MethodDefinitionContext
        _localctx = MethodDefinitionContext(_ctx, getState())
        try enterRule(_localctx, 86, JavaScriptParser.RULE_methodDefinition)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(576)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 62, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(538)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Multiply.rawValue {
                    setState(537)
                    try match(JavaScriptParser.Tokens.Multiply.rawValue)

                }

                setState(541)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Hashtag.rawValue {
                    setState(540)
                    try match(JavaScriptParser.Tokens.Hashtag.rawValue)

                }

                setState(543)
                try propertyName()
                setState(544)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(546)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(545)
                    try formalParameterList()

                }

                setState(548)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(549)
                try functionBody()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(552)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 57, _ctx) {
                case 1:
                    setState(551)
                    try match(JavaScriptParser.Tokens.Multiply.rawValue)

                    break
                default: break
                }
                setState(555)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 58, _ctx) {
                case 1:
                    setState(554)
                    try match(JavaScriptParser.Tokens.Hashtag.rawValue)

                    break
                default: break
                }
                setState(557)
                try getter()
                setState(558)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(559)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(560)
                try functionBody()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(563)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 59, _ctx) {
                case 1:
                    setState(562)
                    try match(JavaScriptParser.Tokens.Multiply.rawValue)

                    break
                default: break
                }
                setState(566)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 60, _ctx) {
                case 1:
                    setState(565)
                    try match(JavaScriptParser.Tokens.Hashtag.rawValue)

                    break
                default: break
                }
                setState(568)
                try setter()
                setState(569)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(571)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(570)
                    try formalParameterList()

                }

                setState(573)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(574)
                try functionBody()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FormalParameterListContext: ParserRuleContext {
        open func formalParameterArg() -> [FormalParameterArgContext] {
            return getRuleContexts(FormalParameterArgContext.self)
        }
        open func formalParameterArg(_ i: Int) -> FormalParameterArgContext? {
            return getRuleContext(FormalParameterArgContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        open func lastFormalParameterArg() -> LastFormalParameterArgContext? {
            return getRuleContext(LastFormalParameterArgContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_formalParameterList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFormalParameterList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFormalParameterList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFormalParameterList(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFormalParameterList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func formalParameterList() throws -> FormalParameterListContext {
        var _localctx: FormalParameterListContext
        _localctx = FormalParameterListContext(_ctx, getState())
        try enterRule(_localctx, 88, JavaScriptParser.RULE_formalParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(591)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .OpenBracket, .OpenBrace, .Async, .NonStrictLet, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(578)
                try formalParameterArg()
                setState(583)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(579)
                        try match(JavaScriptParser.Tokens.Comma.rawValue)
                        setState(580)
                        try formalParameterArg()

                    }
                    setState(585)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
                }
                setState(588)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Comma.rawValue {
                    setState(586)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)
                    setState(587)
                    try lastFormalParameterArg()

                }

                break

            case .Ellipsis:
                try enterOuterAlt(_localctx, 2)
                setState(590)
                try lastFormalParameterArg()

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

    public class FormalParameterArgContext: ParserRuleContext {
        open func assignable() -> AssignableContext? {
            return getRuleContext(AssignableContext.self, 0)
        }
        open func Assign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_formalParameterArg }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFormalParameterArg(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFormalParameterArg(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFormalParameterArg(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFormalParameterArg(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func formalParameterArg() throws -> FormalParameterArgContext {
        var _localctx: FormalParameterArgContext
        _localctx = FormalParameterArgContext(_ctx, getState())
        try enterRule(_localctx, 90, JavaScriptParser.RULE_formalParameterArg)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(593)
            try assignable()
            setState(596)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Assign.rawValue {
                setState(594)
                try match(JavaScriptParser.Tokens.Assign.rawValue)
                setState(595)
                try singleExpression(0)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class LastFormalParameterArgContext: ParserRuleContext {
        open func Ellipsis() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_lastFormalParameterArg
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterLastFormalParameterArg(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitLastFormalParameterArg(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLastFormalParameterArg(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLastFormalParameterArg(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func lastFormalParameterArg() throws -> LastFormalParameterArgContext {
        var _localctx: LastFormalParameterArgContext
        _localctx = LastFormalParameterArgContext(_ctx, getState())
        try enterRule(_localctx, 92, JavaScriptParser.RULE_lastFormalParameterArg)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(598)
            try match(JavaScriptParser.Tokens.Ellipsis.rawValue)
            setState(599)
            try singleExpression(0)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionBodyContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func sourceElements() -> SourceElementsContext? {
            return getRuleContext(SourceElementsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_functionBody }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFunctionBody(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFunctionBody(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFunctionBody(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFunctionBody(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionBody() throws -> FunctionBodyContext {
        var _localctx: FunctionBodyContext
        _localctx = FunctionBodyContext(_ctx, getState())
        try enterRule(_localctx, 94, JavaScriptParser.RULE_functionBody)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(601)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(603)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 67, _ctx) {
            case 1:
                setState(602)
                try sourceElements()

                break
            default: break
            }
            setState(605)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SourceElementsContext: ParserRuleContext {
        open func sourceElement() -> [SourceElementContext] {
            return getRuleContexts(SourceElementContext.self)
        }
        open func sourceElement(_ i: Int) -> SourceElementContext? {
            return getRuleContext(SourceElementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_sourceElements }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterSourceElements(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitSourceElements(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitSourceElements(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitSourceElements(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func sourceElements() throws -> SourceElementsContext {
        var _localctx: SourceElementsContext
        _localctx = SourceElementsContext(_ctx, getState())
        try enterRule(_localctx, 96, JavaScriptParser.RULE_sourceElements)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(608)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(607)
                    try sourceElement()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(610)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 68, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArrayLiteralContext: ParserRuleContext {
        open func OpenBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
        }
        open func elementList() -> ElementListContext? {
            return getRuleContext(ElementListContext.self, 0)
        }
        open func CloseBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_arrayLiteral }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrayLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrayLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrayLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrayLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrayLiteral() throws -> ArrayLiteralContext {
        var _localctx: ArrayLiteralContext
        _localctx = ArrayLiteralContext(_ctx, getState())
        try enterRule(_localctx, 98, JavaScriptParser.RULE_arrayLiteral)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(612)
            try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
            setState(613)
            try elementList()
            setState(614)
            try match(JavaScriptParser.Tokens.CloseBracket.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ElementListContext: ParserRuleContext {
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        open func arrayElement() -> [ArrayElementContext] {
            return getRuleContexts(ArrayElementContext.self)
        }
        open func arrayElement(_ i: Int) -> ArrayElementContext? {
            return getRuleContext(ArrayElementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_elementList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterElementList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitElementList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitElementList(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitElementList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func elementList() throws -> ElementListContext {
        var _localctx: ElementListContext
        _localctx = ElementListContext(_ctx, getState())
        try enterRule(_localctx, 100, JavaScriptParser.RULE_elementList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(619)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 69, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(616)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)

                }
                setState(621)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 69, _ctx)
            }
            setState(623)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2_305_843_009_147_370_832) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & 252_549_645_531_105_535) != 0
            {
                setState(622)
                try arrayElement()

            }

            setState(633)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 72, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(626)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    repeat {
                        setState(625)
                        try match(JavaScriptParser.Tokens.Comma.rawValue)

                        setState(628)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    } while _la == JavaScriptParser.Tokens.Comma.rawValue
                    setState(630)
                    try arrayElement()

                }
                setState(635)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 72, _ctx)
            }
            setState(639)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == JavaScriptParser.Tokens.Comma.rawValue {
                setState(636)
                try match(JavaScriptParser.Tokens.Comma.rawValue)

                setState(641)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArrayElementContext: ParserRuleContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func Ellipsis() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_arrayElement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrayElement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrayElement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrayElement(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrayElement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrayElement() throws -> ArrayElementContext {
        var _localctx: ArrayElementContext
        _localctx = ArrayElementContext(_ctx, getState())
        try enterRule(_localctx, 102, JavaScriptParser.RULE_arrayElement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(643)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Ellipsis.rawValue {
                setState(642)
                try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

            }

            setState(645)
            try singleExpression(0)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PropertyAssignmentContext: ParserRuleContext {
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_propertyAssignment }
    }
    public class PropertyExpressionAssignmentContext: PropertyAssignmentContext {
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPropertyExpressionAssignment(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPropertyExpressionAssignment(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPropertyExpressionAssignment(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPropertyExpressionAssignment(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ComputedPropertyExpressionAssignmentContext: PropertyAssignmentContext {
        open func OpenBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
        }
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func CloseBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterComputedPropertyExpressionAssignment(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitComputedPropertyExpressionAssignment(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitComputedPropertyExpressionAssignment(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitComputedPropertyExpressionAssignment(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PropertyShorthandContext: PropertyAssignmentContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func Ellipsis() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPropertyShorthand(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPropertyShorthand(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPropertyShorthand(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPropertyShorthand(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PropertySetterContext: PropertyAssignmentContext {
        open func setter() -> SetterContext? { return getRuleContext(SetterContext.self, 0) }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func formalParameterArg() -> FormalParameterArgContext? {
            return getRuleContext(FormalParameterArgContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPropertySetter(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPropertySetter(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPropertySetter(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPropertySetter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PropertyGetterContext: PropertyAssignmentContext {
        open func getter() -> GetterContext? { return getRuleContext(GetterContext.self, 0) }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPropertyGetter(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPropertyGetter(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPropertyGetter(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPropertyGetter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class FunctionPropertyContext: PropertyAssignmentContext {
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func formalParameterList() -> FormalParameterListContext? {
            return getRuleContext(FormalParameterListContext.self, 0)
        }

        public init(_ ctx: PropertyAssignmentContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFunctionProperty(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFunctionProperty(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFunctionProperty(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFunctionProperty(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyAssignment() throws -> PropertyAssignmentContext {
        var _localctx: PropertyAssignmentContext
        _localctx = PropertyAssignmentContext(_ctx, getState())
        try enterRule(_localctx, 104, JavaScriptParser.RULE_propertyAssignment)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(686)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 79, _ctx) {
            case 1:
                _localctx = PropertyExpressionAssignmentContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(647)
                try propertyName()
                setState(648)
                try match(JavaScriptParser.Tokens.Colon.rawValue)
                setState(649)
                try singleExpression(0)

                break
            case 2:
                _localctx = ComputedPropertyExpressionAssignmentContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(651)
                try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
                setState(652)
                try singleExpression(0)
                setState(653)
                try match(JavaScriptParser.Tokens.CloseBracket.rawValue)
                setState(654)
                try match(JavaScriptParser.Tokens.Colon.rawValue)
                setState(655)
                try singleExpression(0)

                break
            case 3:
                _localctx = FunctionPropertyContext(_localctx)
                try enterOuterAlt(_localctx, 3)
                setState(658)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 75, _ctx) {
                case 1:
                    setState(657)
                    try match(JavaScriptParser.Tokens.Async.rawValue)

                    break
                default: break
                }
                setState(661)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Multiply.rawValue {
                    setState(660)
                    try match(JavaScriptParser.Tokens.Multiply.rawValue)

                }

                setState(663)
                try propertyName()
                setState(664)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(666)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(665)
                    try formalParameterList()

                }

                setState(668)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(669)
                try functionBody()

                break
            case 4:
                _localctx = PropertyGetterContext(_localctx)
                try enterOuterAlt(_localctx, 4)
                setState(671)
                try getter()
                setState(672)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(673)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(674)
                try functionBody()

                break
            case 5:
                _localctx = PropertySetterContext(_localctx)
                try enterOuterAlt(_localctx, 5)
                setState(676)
                try setter()
                setState(677)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(678)
                try formalParameterArg()
                setState(679)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(680)
                try functionBody()

                break
            case 6:
                _localctx = PropertyShorthandContext(_localctx)
                try enterOuterAlt(_localctx, 6)
                setState(683)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Ellipsis.rawValue {
                    setState(682)
                    try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

                }

                setState(685)
                try singleExpression(0)

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PropertyNameContext: ParserRuleContext {
        open func identifierName() -> IdentifierNameContext? {
            return getRuleContext(IdentifierNameContext.self, 0)
        }
        open func StringLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
        }
        open func numericLiteral() -> NumericLiteralContext? {
            return getRuleContext(NumericLiteralContext.self, 0)
        }
        open func OpenBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func CloseBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_propertyName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPropertyName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPropertyName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPropertyName(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPropertyName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyName() throws -> PropertyNameContext {
        var _localctx: PropertyNameContext
        _localctx = PropertyNameContext(_ctx, getState())
        try enterRule(_localctx, 106, JavaScriptParser.RULE_propertyName)
        defer { try! exitRule() }
        do {
            setState(695)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .NullLiteral, .BooleanLiteral, .Break, .Do, .Instanceof, .Typeof, .Case, .Else,
                .New, .Var, .Catch, .Finally, .Return, .Void, .Continue, .For, .Switch, .While,
                .Debugger, .Function_, .This, .With, .Default, .If, .Throw, .Delete, .In, .Try, .As,
                .From, .Class, .Enum, .Extends, .Super, .Const, .Export, .Import, .Async, .Await,
                .Yield, .Implements, .StrictLet, .NonStrictLet, .Private, .Public, .Interface,
                .Package, .Protected, .Static, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(688)
                try identifierName()

                break

            case .StringLiteral:
                try enterOuterAlt(_localctx, 2)
                setState(689)
                try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

                break
            case .DecimalLiteral, .HexIntegerLiteral, .OctalIntegerLiteral, .OctalIntegerLiteral2,
                .BinaryIntegerLiteral:
                try enterOuterAlt(_localctx, 3)
                setState(690)
                try numericLiteral()

                break

            case .OpenBracket:
                try enterOuterAlt(_localctx, 4)
                setState(691)
                try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
                setState(692)
                try singleExpression(0)
                setState(693)
                try match(JavaScriptParser.Tokens.CloseBracket.rawValue)

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

    public class ArgumentsContext: ParserRuleContext {
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func argument() -> [ArgumentContext] { return getRuleContexts(ArgumentContext.self) }
        open func argument(_ i: Int) -> ArgumentContext? {
            return getRuleContext(ArgumentContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_arguments }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArguments(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitArguments(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArguments(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArguments(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arguments() throws -> ArgumentsContext {
        var _localctx: ArgumentsContext
        _localctx = ArgumentsContext(_ctx, getState())
        try enterRule(_localctx, 108, JavaScriptParser.RULE_arguments)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(697)
            try match(JavaScriptParser.Tokens.OpenParen.rawValue)
            setState(709)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2_305_843_009_147_370_832) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & 252_549_645_531_105_535) != 0
            {
                setState(698)
                try argument()
                setState(703)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 81, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(699)
                        try match(JavaScriptParser.Tokens.Comma.rawValue)
                        setState(700)
                        try argument()

                    }
                    setState(705)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 81, _ctx)
                }
                setState(707)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Comma.rawValue {
                    setState(706)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)

                }

            }

            setState(711)
            try match(JavaScriptParser.Tokens.CloseParen.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArgumentContext: ParserRuleContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func Ellipsis() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_argument }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterArgument(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitArgument(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArgument(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArgument(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func argument() throws -> ArgumentContext {
        var _localctx: ArgumentContext
        _localctx = ArgumentContext(_ctx, getState())
        try enterRule(_localctx, 110, JavaScriptParser.RULE_argument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(714)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == JavaScriptParser.Tokens.Ellipsis.rawValue {
                setState(713)
                try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

            }

            setState(718)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 85, _ctx) {
            case 1:
                setState(716)
                try singleExpression(0)

                break
            case 2:
                setState(717)
                try identifier()

                break
            default: break
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ExpressionSequenceContext: ParserRuleContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_expressionSequence }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterExpressionSequence(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitExpressionSequence(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitExpressionSequence(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitExpressionSequence(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func expressionSequence() throws -> ExpressionSequenceContext {
        var _localctx: ExpressionSequenceContext
        _localctx = ExpressionSequenceContext(_ctx, getState())
        try enterRule(_localctx, 112, JavaScriptParser.RULE_expressionSequence)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(720)
            try singleExpression(0)
            setState(725)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 86, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(721)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)
                    setState(722)
                    try singleExpression(0)

                }
                setState(727)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 86, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SingleExpressionContext: ParserRuleContext {
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_singleExpression }
    }
    public class TemplateStringExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func templateStringLiteral() -> TemplateStringLiteralContext? {
            return getRuleContext(TemplateStringLiteralContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTemplateStringExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTemplateStringExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTemplateStringExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTemplateStringExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class TernaryExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func QuestionMark() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.QuestionMark.rawValue, 0)
        }
        open func Colon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTernaryExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTernaryExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTernaryExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTernaryExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class LogicalAndExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func And() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.And.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterLogicalAndExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitLogicalAndExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLogicalAndExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLogicalAndExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PowerExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Power() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Power.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPowerExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPowerExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPowerExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPowerExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreIncrementExpressionContext: SingleExpressionContext {
        open func PlusPlus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.PlusPlus.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPreIncrementExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPreIncrementExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPreIncrementExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPreIncrementExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ObjectLiteralExpressionContext: SingleExpressionContext {
        open func objectLiteral() -> ObjectLiteralContext? {
            return getRuleContext(ObjectLiteralContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterObjectLiteralExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitObjectLiteralExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitObjectLiteralExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitObjectLiteralExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class MetaExpressionContext: SingleExpressionContext {
        open func New() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
        }
        open func Dot() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Dot.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterMetaExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitMetaExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitMetaExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitMetaExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class InExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func In() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.In.rawValue, 0) }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterInExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitInExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitInExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitInExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class LogicalOrExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Or() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.Or.rawValue, 0) }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterLogicalOrExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitLogicalOrExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLogicalOrExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLogicalOrExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class OptionalChainExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func QuestionMarkDot() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.QuestionMarkDot.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterOptionalChainExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitOptionalChainExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitOptionalChainExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitOptionalChainExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class NotExpressionContext: SingleExpressionContext {
        open func Not() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Not.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterNotExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitNotExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitNotExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitNotExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PreDecreaseExpressionContext: SingleExpressionContext {
        open func MinusMinus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.MinusMinus.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPreDecreaseExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPreDecreaseExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPreDecreaseExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPreDecreaseExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ArgumentsExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func arguments() -> ArgumentsContext? {
            return getRuleContext(ArgumentsContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArgumentsExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArgumentsExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArgumentsExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArgumentsExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class AwaitExpressionContext: SingleExpressionContext {
        open func Await() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAwaitExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAwaitExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAwaitExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAwaitExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ThisExpressionContext: SingleExpressionContext {
        open func This() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.This.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterThisExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitThisExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitThisExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitThisExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class FunctionExpressionContext: SingleExpressionContext {
        open func anonymousFunction() -> AnonymousFunctionContext? {
            return getRuleContext(AnonymousFunctionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFunctionExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFunctionExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFunctionExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFunctionExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class UnaryMinusExpressionContext: SingleExpressionContext {
        open func Minus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Minus.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterUnaryMinusExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitUnaryMinusExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitUnaryMinusExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitUnaryMinusExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class AssignmentExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Assign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAssignmentExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAssignmentExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAssignmentExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAssignmentExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PostDecreaseExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func MinusMinus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.MinusMinus.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPostDecreaseExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPostDecreaseExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPostDecreaseExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPostDecreaseExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class TypeofExpressionContext: SingleExpressionContext {
        open func Typeof() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Typeof.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTypeofExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTypeofExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTypeofExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTypeofExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class InstanceofExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Instanceof() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Instanceof.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterInstanceofExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitInstanceofExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitInstanceofExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitInstanceofExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class UnaryPlusExpressionContext: SingleExpressionContext {
        open func Plus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Plus.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterUnaryPlusExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitUnaryPlusExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitUnaryPlusExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitUnaryPlusExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class DeleteExpressionContext: SingleExpressionContext {
        open func Delete() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Delete.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterDeleteExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitDeleteExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitDeleteExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitDeleteExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ImportExpressionContext: SingleExpressionContext {
        open func Import() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterImportExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitImportExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitImportExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitImportExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class EqualityExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Equals_() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Equals_.rawValue, 0)
        }
        open func NotEquals() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NotEquals.rawValue, 0)
        }
        open func IdentityEquals() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.IdentityEquals.rawValue, 0)
        }
        open func IdentityNotEquals() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.IdentityNotEquals.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterEqualityExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitEqualityExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitEqualityExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitEqualityExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class BitXOrExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func BitXOr() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitXOr.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBitXOrExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBitXOrExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBitXOrExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBitXOrExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class SuperExpressionContext: SingleExpressionContext {
        open func Super() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Super.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterSuperExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitSuperExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitSuperExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitSuperExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class MultiplicativeExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func Divide() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Divide.rawValue, 0)
        }
        open func Modulus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Modulus.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterMultiplicativeExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitMultiplicativeExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitMultiplicativeExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitMultiplicativeExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class BitShiftExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func LeftShiftArithmetic() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.LeftShiftArithmetic.rawValue, 0)
        }
        open func RightShiftArithmetic() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.RightShiftArithmetic.rawValue, 0)
        }
        open func RightShiftLogical() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.RightShiftLogical.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBitShiftExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBitShiftExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBitShiftExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBitShiftExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ParenthesizedExpressionContext: SingleExpressionContext {
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterParenthesizedExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitParenthesizedExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitParenthesizedExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitParenthesizedExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class AdditiveExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func Plus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Plus.rawValue, 0)
        }
        open func Minus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Minus.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAdditiveExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAdditiveExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAdditiveExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAdditiveExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class RelationalExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func LessThan() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.LessThan.rawValue, 0)
        }
        open func MoreThan() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.MoreThan.rawValue, 0)
        }
        open func LessThanEquals() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.LessThanEquals.rawValue, 0)
        }
        open func GreaterThanEquals() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.GreaterThanEquals.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterRelationalExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitRelationalExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitRelationalExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitRelationalExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class PostIncrementExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func PlusPlus() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.PlusPlus.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterPostIncrementExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitPostIncrementExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitPostIncrementExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitPostIncrementExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class YieldExpressionContext: SingleExpressionContext {
        open func yieldStatement() -> YieldStatementContext? {
            return getRuleContext(YieldStatementContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterYieldExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitYieldExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitYieldExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitYieldExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class BitNotExpressionContext: SingleExpressionContext {
        open func BitNot() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitNot.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBitNotExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBitNotExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBitNotExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBitNotExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class NewExpressionContext: SingleExpressionContext {
        open func New() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func arguments() -> ArgumentsContext? {
            return getRuleContext(ArgumentsContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterNewExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitNewExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitNewExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitNewExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class LiteralExpressionContext: SingleExpressionContext {
        open func literal() -> LiteralContext? { return getRuleContext(LiteralContext.self, 0) }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterLiteralExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitLiteralExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLiteralExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLiteralExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ArrayLiteralExpressionContext: SingleExpressionContext {
        open func arrayLiteral() -> ArrayLiteralContext? {
            return getRuleContext(ArrayLiteralContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrayLiteralExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrayLiteralExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrayLiteralExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrayLiteralExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class MemberDotExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func Dot() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Dot.rawValue, 0)
        }
        open func identifierName() -> IdentifierNameContext? {
            return getRuleContext(IdentifierNameContext.self, 0)
        }
        open func QuestionMark() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.QuestionMark.rawValue, 0)
        }
        open func Hashtag() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterMemberDotExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitMemberDotExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitMemberDotExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitMemberDotExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ClassExpressionContext: SingleExpressionContext {
        open func Class() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
        }
        open func classTail() -> ClassTailContext? {
            return getRuleContext(ClassTailContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterClassExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitClassExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitClassExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitClassExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class MemberIndexExpressionContext: SingleExpressionContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func OpenBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
        }
        open func expressionSequence() -> ExpressionSequenceContext? {
            return getRuleContext(ExpressionSequenceContext.self, 0)
        }
        open func CloseBracket() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
        }
        open func QuestionMarkDot() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.QuestionMarkDot.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterMemberIndexExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitMemberIndexExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitMemberIndexExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitMemberIndexExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class IdentifierExpressionContext: SingleExpressionContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterIdentifierExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitIdentifierExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitIdentifierExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitIdentifierExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class BitAndExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func BitAnd() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitAnd.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBitAndExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBitAndExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBitAndExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBitAndExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class BitOrExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func BitOr() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitOr.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBitOrExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBitOrExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBitOrExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBitOrExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class AssignmentOperatorExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func assignmentOperator() -> AssignmentOperatorContext? {
            return getRuleContext(AssignmentOperatorContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAssignmentOperatorExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAssignmentOperatorExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAssignmentOperatorExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAssignmentOperatorExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class VoidExpressionContext: SingleExpressionContext {
        open func Void() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Void.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterVoidExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitVoidExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitVoidExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitVoidExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class CoalesceExpressionContext: SingleExpressionContext {
        open func singleExpression() -> [SingleExpressionContext] {
            return getRuleContexts(SingleExpressionContext.self)
        }
        open func singleExpression(_ i: Int) -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, i)
        }
        open func NullCoalesce() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NullCoalesce.rawValue, 0)
        }

        public init(_ ctx: SingleExpressionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterCoalesceExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitCoalesceExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitCoalesceExpression(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitCoalesceExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }

    public final func singleExpression() throws -> SingleExpressionContext {
        return try singleExpression(0)
    }
    @discardableResult private func singleExpression(_ _p: Int) throws -> SingleExpressionContext {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: SingleExpressionContext
        _localctx = SingleExpressionContext(_ctx, _parentState)
        let _startState: Int = 114
        try enterRecursionRule(_localctx, 114, JavaScriptParser.RULE_singleExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(780)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 88, _ctx) {
            case 1:
                _localctx = FunctionExpressionContext(_localctx)
                _ctx = _localctx

                setState(729)
                try anonymousFunction()

                break
            case 2:
                _localctx = ClassExpressionContext(_localctx)
                _ctx = _localctx
                setState(730)
                try match(JavaScriptParser.Tokens.Class.rawValue)
                setState(732)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0 {
                    setState(731)
                    try identifier()

                }

                setState(734)
                try classTail()

                break
            case 3:
                _localctx = NewExpressionContext(_localctx)
                _ctx = _localctx
                setState(735)
                try match(JavaScriptParser.Tokens.New.rawValue)
                setState(736)
                try singleExpression(0)
                setState(737)
                try arguments()

                break
            case 4:
                _localctx = NewExpressionContext(_localctx)
                _ctx = _localctx
                setState(739)
                try match(JavaScriptParser.Tokens.New.rawValue)
                setState(740)
                try singleExpression(42)

                break
            case 5:
                _localctx = MetaExpressionContext(_localctx)
                _ctx = _localctx
                setState(741)
                try match(JavaScriptParser.Tokens.New.rawValue)
                setState(742)
                try match(JavaScriptParser.Tokens.Dot.rawValue)
                setState(743)
                try identifier()

                break
            case 6:
                _localctx = DeleteExpressionContext(_localctx)
                _ctx = _localctx
                setState(744)
                try match(JavaScriptParser.Tokens.Delete.rawValue)
                setState(745)
                try singleExpression(37)

                break
            case 7:
                _localctx = VoidExpressionContext(_localctx)
                _ctx = _localctx
                setState(746)
                try match(JavaScriptParser.Tokens.Void.rawValue)
                setState(747)
                try singleExpression(36)

                break
            case 8:
                _localctx = TypeofExpressionContext(_localctx)
                _ctx = _localctx
                setState(748)
                try match(JavaScriptParser.Tokens.Typeof.rawValue)
                setState(749)
                try singleExpression(35)

                break
            case 9:
                _localctx = PreIncrementExpressionContext(_localctx)
                _ctx = _localctx
                setState(750)
                try match(JavaScriptParser.Tokens.PlusPlus.rawValue)
                setState(751)
                try singleExpression(34)

                break
            case 10:
                _localctx = PreDecreaseExpressionContext(_localctx)
                _ctx = _localctx
                setState(752)
                try match(JavaScriptParser.Tokens.MinusMinus.rawValue)
                setState(753)
                try singleExpression(33)

                break
            case 11:
                _localctx = UnaryPlusExpressionContext(_localctx)
                _ctx = _localctx
                setState(754)
                try match(JavaScriptParser.Tokens.Plus.rawValue)
                setState(755)
                try singleExpression(32)

                break
            case 12:
                _localctx = UnaryMinusExpressionContext(_localctx)
                _ctx = _localctx
                setState(756)
                try match(JavaScriptParser.Tokens.Minus.rawValue)
                setState(757)
                try singleExpression(31)

                break
            case 13:
                _localctx = BitNotExpressionContext(_localctx)
                _ctx = _localctx
                setState(758)
                try match(JavaScriptParser.Tokens.BitNot.rawValue)
                setState(759)
                try singleExpression(30)

                break
            case 14:
                _localctx = NotExpressionContext(_localctx)
                _ctx = _localctx
                setState(760)
                try match(JavaScriptParser.Tokens.Not.rawValue)
                setState(761)
                try singleExpression(29)

                break
            case 15:
                _localctx = AwaitExpressionContext(_localctx)
                _ctx = _localctx
                setState(762)
                try match(JavaScriptParser.Tokens.Await.rawValue)
                setState(763)
                try singleExpression(28)

                break
            case 16:
                _localctx = ImportExpressionContext(_localctx)
                _ctx = _localctx
                setState(764)
                try match(JavaScriptParser.Tokens.Import.rawValue)
                setState(765)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(766)
                try singleExpression(0)
                setState(767)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)

                break
            case 17:
                _localctx = YieldExpressionContext(_localctx)
                _ctx = _localctx
                setState(769)
                try yieldStatement()

                break
            case 18:
                _localctx = ThisExpressionContext(_localctx)
                _ctx = _localctx
                setState(770)
                try match(JavaScriptParser.Tokens.This.rawValue)

                break
            case 19:
                _localctx = IdentifierExpressionContext(_localctx)
                _ctx = _localctx
                setState(771)
                try identifier()

                break
            case 20:
                _localctx = SuperExpressionContext(_localctx)
                _ctx = _localctx
                setState(772)
                try match(JavaScriptParser.Tokens.Super.rawValue)

                break
            case 21:
                _localctx = LiteralExpressionContext(_localctx)
                _ctx = _localctx
                setState(773)
                try literal()

                break
            case 22:
                _localctx = ArrayLiteralExpressionContext(_localctx)
                _ctx = _localctx
                setState(774)
                try arrayLiteral()

                break
            case 23:
                _localctx = ObjectLiteralExpressionContext(_localctx)
                _ctx = _localctx
                setState(775)
                try objectLiteral()

                break
            case 24:
                _localctx = ParenthesizedExpressionContext(_localctx)
                _ctx = _localctx
                setState(776)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(777)
                try expressionSequence()
                setState(778)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(869)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 93, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(867)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 92, _ctx) {
                    case 1:
                        _localctx = OptionalChainExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(782)
                        if !(precpred(_ctx, 46)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 46)"))
                        }
                        setState(783)
                        try match(JavaScriptParser.Tokens.QuestionMarkDot.rawValue)
                        setState(784)
                        try singleExpression(47)

                        break
                    case 2:
                        _localctx = PowerExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(785)
                        if !(precpred(_ctx, 27)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 27)"))
                        }
                        setState(786)
                        try match(JavaScriptParser.Tokens.Power.rawValue)
                        setState(787)
                        try singleExpression(27)

                        break
                    case 3:
                        _localctx = MultiplicativeExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(788)
                        if !(precpred(_ctx, 26)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 26)"))
                        }
                        setState(789)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 469_762_048) != 0) {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(790)
                        try singleExpression(27)

                        break
                    case 4:
                        _localctx = AdditiveExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(791)
                        if !(precpred(_ctx, 25)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 25)"))
                        }
                        setState(792)
                        _la = try _input.LA(1)
                        if !(_la == JavaScriptParser.Tokens.Plus.rawValue
                            || _la == JavaScriptParser.Tokens.Minus.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(793)
                        try singleExpression(26)

                        break
                    case 5:
                        _localctx = CoalesceExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(794)
                        if !(precpred(_ctx, 24)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 24)"))
                        }
                        setState(795)
                        try match(JavaScriptParser.Tokens.NullCoalesce.rawValue)
                        setState(796)
                        try singleExpression(25)

                        break
                    case 6:
                        _localctx = BitShiftExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(797)
                        if !(precpred(_ctx, 23)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 23)"))
                        }
                        setState(798)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 30_064_771_072) != 0)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(799)
                        try singleExpression(24)

                        break
                    case 7:
                        _localctx = RelationalExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(800)
                        if !(precpred(_ctx, 22)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 22)"))
                        }
                        setState(801)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 515_396_075_520) != 0)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(802)
                        try singleExpression(23)

                        break
                    case 8:
                        _localctx = InstanceofExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(803)
                        if !(precpred(_ctx, 21)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 21)"))
                        }
                        setState(804)
                        try match(JavaScriptParser.Tokens.Instanceof.rawValue)
                        setState(805)
                        try singleExpression(22)

                        break
                    case 9:
                        _localctx = InExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(806)
                        if !(precpred(_ctx, 20)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 20)"))
                        }
                        setState(807)
                        try match(JavaScriptParser.Tokens.In.rawValue)
                        setState(808)
                        try singleExpression(21)

                        break
                    case 10:
                        _localctx = EqualityExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(809)
                        if !(precpred(_ctx, 19)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 19)"))
                        }
                        setState(810)
                        _la = try _input.LA(1)
                        if !((Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 8_246_337_208_320) != 0)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(811)
                        try singleExpression(20)

                        break
                    case 11:
                        _localctx = BitAndExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(812)
                        if !(precpred(_ctx, 18)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 18)"))
                        }
                        setState(813)
                        try match(JavaScriptParser.Tokens.BitAnd.rawValue)
                        setState(814)
                        try singleExpression(19)

                        break
                    case 12:
                        _localctx = BitXOrExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(815)
                        if !(precpred(_ctx, 17)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 17)"))
                        }
                        setState(816)
                        try match(JavaScriptParser.Tokens.BitXOr.rawValue)
                        setState(817)
                        try singleExpression(18)

                        break
                    case 13:
                        _localctx = BitOrExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(818)
                        if !(precpred(_ctx, 16)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 16)"))
                        }
                        setState(819)
                        try match(JavaScriptParser.Tokens.BitOr.rawValue)
                        setState(820)
                        try singleExpression(17)

                        break
                    case 14:
                        _localctx = LogicalAndExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(821)
                        if !(precpred(_ctx, 15)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 15)"))
                        }
                        setState(822)
                        try match(JavaScriptParser.Tokens.And.rawValue)
                        setState(823)
                        try singleExpression(16)

                        break
                    case 15:
                        _localctx = LogicalOrExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(824)
                        if !(precpred(_ctx, 14)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 14)"))
                        }
                        setState(825)
                        try match(JavaScriptParser.Tokens.Or.rawValue)
                        setState(826)
                        try singleExpression(15)

                        break
                    case 16:
                        _localctx = TernaryExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(827)
                        if !(precpred(_ctx, 13)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 13)"))
                        }
                        setState(828)
                        try match(JavaScriptParser.Tokens.QuestionMark.rawValue)
                        setState(829)
                        try singleExpression(0)
                        setState(830)
                        try match(JavaScriptParser.Tokens.Colon.rawValue)
                        setState(831)
                        try singleExpression(14)

                        break
                    case 17:
                        _localctx = AssignmentExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(833)
                        if !(precpred(_ctx, 12)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 12)"))
                        }
                        setState(834)
                        try match(JavaScriptParser.Tokens.Assign.rawValue)
                        setState(835)
                        try singleExpression(12)

                        break
                    case 18:
                        _localctx = AssignmentOperatorExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(836)
                        if !(precpred(_ctx, 11)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 11)"))
                        }
                        setState(837)
                        try assignmentOperator()
                        setState(838)
                        try singleExpression(11)

                        break
                    case 19:
                        _localctx = MemberIndexExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(840)
                        if !(precpred(_ctx, 45)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 45)"))
                        }
                        setState(842)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if _la == JavaScriptParser.Tokens.QuestionMarkDot.rawValue {
                            setState(841)
                            try match(JavaScriptParser.Tokens.QuestionMarkDot.rawValue)

                        }

                        setState(844)
                        try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
                        setState(845)
                        try expressionSequence()
                        setState(846)
                        try match(JavaScriptParser.Tokens.CloseBracket.rawValue)

                        break
                    case 20:
                        _localctx = MemberDotExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(848)
                        if !(precpred(_ctx, 44)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 44)"))
                        }
                        setState(850)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if _la == JavaScriptParser.Tokens.QuestionMark.rawValue {
                            setState(849)
                            try match(JavaScriptParser.Tokens.QuestionMark.rawValue)

                        }

                        setState(852)
                        try match(JavaScriptParser.Tokens.Dot.rawValue)
                        setState(854)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if _la == JavaScriptParser.Tokens.Hashtag.rawValue {
                            setState(853)
                            try match(JavaScriptParser.Tokens.Hashtag.rawValue)

                        }

                        setState(856)
                        try identifierName()

                        break
                    case 21:
                        _localctx = ArgumentsExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(857)
                        if !(precpred(_ctx, 41)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 41)"))
                        }
                        setState(858)
                        try arguments()

                        break
                    case 22:
                        _localctx = PostIncrementExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(859)
                        if !(precpred(_ctx, 39)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 39)"))
                        }
                        setState(860)
                        if !(try self.notLineTerminator()) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "try self.notLineTerminator()"))
                        }
                        setState(861)
                        try match(JavaScriptParser.Tokens.PlusPlus.rawValue)

                        break
                    case 23:
                        _localctx = PostDecreaseExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(862)
                        if !(precpred(_ctx, 38)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 38)"))
                        }
                        setState(863)
                        if !(try self.notLineTerminator()) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "try self.notLineTerminator()"))
                        }
                        setState(864)
                        try match(JavaScriptParser.Tokens.MinusMinus.rawValue)

                        break
                    case 24:
                        _localctx = TemplateStringExpressionContext(
                            SingleExpressionContext(_parentctx, _parentState))
                        try pushNewRecursionContext(
                            _localctx, _startState, JavaScriptParser.RULE_singleExpression)
                        setState(865)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(866)
                        try templateStringLiteral()

                        break
                    default: break
                    }
                }
                setState(871)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 93, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AssignableContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func arrayLiteral() -> ArrayLiteralContext? {
            return getRuleContext(ArrayLiteralContext.self, 0)
        }
        open func objectLiteral() -> ObjectLiteralContext? {
            return getRuleContext(ObjectLiteralContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_assignable }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAssignable(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAssignable(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAssignable(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAssignable(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func assignable() throws -> AssignableContext {
        var _localctx: AssignableContext
        _localctx = AssignableContext(_ctx, getState())
        try enterRule(_localctx, 116, JavaScriptParser.RULE_assignable)
        defer { try! exitRule() }
        do {
            setState(875)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Async, .NonStrictLet, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(872)
                try identifier()

                break

            case .OpenBracket:
                try enterOuterAlt(_localctx, 2)
                setState(873)
                try arrayLiteral()

                break

            case .OpenBrace:
                try enterOuterAlt(_localctx, 3)
                setState(874)
                try objectLiteral()

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

    public class ObjectLiteralContext: ParserRuleContext {
        open func OpenBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
        }
        open func CloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
        }
        open func propertyAssignment() -> [PropertyAssignmentContext] {
            return getRuleContexts(PropertyAssignmentContext.self)
        }
        open func propertyAssignment(_ i: Int) -> PropertyAssignmentContext? {
            return getRuleContext(PropertyAssignmentContext.self, i)
        }
        open func Comma() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
        }
        open func Comma(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_objectLiteral }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterObjectLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitObjectLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitObjectLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitObjectLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func objectLiteral() throws -> ObjectLiteralContext {
        var _localctx: ObjectLiteralContext
        _localctx = ObjectLiteralContext(_ctx, getState())
        try enterRule(_localctx, 118, JavaScriptParser.RULE_objectLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(877)
            try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
            setState(889)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 97, _ctx) {
            case 1:
                setState(878)
                try propertyAssignment()
                setState(883)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 95, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(879)
                        try match(JavaScriptParser.Tokens.Comma.rawValue)
                        setState(880)
                        try propertyAssignment()

                    }
                    setState(885)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 95, _ctx)
                }
                setState(887)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Comma.rawValue {
                    setState(886)
                    try match(JavaScriptParser.Tokens.Comma.rawValue)

                }

                break
            default: break
            }
            setState(891)
            try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AnonymousFunctionContext: ParserRuleContext {
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_anonymousFunction }
    }
    public class AnonymousFunctionDeclContext: AnonymousFunctionContext {
        open func Function_() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }
        open func Multiply() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
        }
        open func formalParameterList() -> FormalParameterListContext? {
            return getRuleContext(FormalParameterListContext.self, 0)
        }

        public init(_ ctx: AnonymousFunctionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAnonymousFunctionDecl(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAnonymousFunctionDecl(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAnonymousFunctionDecl(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAnonymousFunctionDecl(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class ArrowFunctionContext: AnonymousFunctionContext {
        open func arrowFunctionParameters() -> ArrowFunctionParametersContext? {
            return getRuleContext(ArrowFunctionParametersContext.self, 0)
        }
        open func ARROW() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.ARROW.rawValue, 0)
        }
        open func arrowFunctionBody() -> ArrowFunctionBodyContext? {
            return getRuleContext(ArrowFunctionBodyContext.self, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }

        public init(_ ctx: AnonymousFunctionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrowFunction(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrowFunction(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrowFunction(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrowFunction(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    public class FunctionDeclContext: AnonymousFunctionContext {
        open func functionDeclaration() -> FunctionDeclarationContext? {
            return getRuleContext(FunctionDeclarationContext.self, 0)
        }

        public init(_ ctx: AnonymousFunctionContext) {
            super.init()
            copyFrom(ctx)
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterFunctionDecl(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitFunctionDecl(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitFunctionDecl(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitFunctionDecl(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func anonymousFunction() throws -> AnonymousFunctionContext {
        var _localctx: AnonymousFunctionContext
        _localctx = AnonymousFunctionContext(_ctx, getState())
        try enterRule(_localctx, 120, JavaScriptParser.RULE_anonymousFunction)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(914)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 102, _ctx) {
            case 1:
                _localctx = FunctionDeclContext(_localctx)
                try enterOuterAlt(_localctx, 1)
                setState(893)
                try functionDeclaration()

                break
            case 2:
                _localctx = AnonymousFunctionDeclContext(_localctx)
                try enterOuterAlt(_localctx, 2)
                setState(895)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Async.rawValue {
                    setState(894)
                    try match(JavaScriptParser.Tokens.Async.rawValue)

                }

                setState(897)
                try match(JavaScriptParser.Tokens.Function_.rawValue)
                setState(899)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == JavaScriptParser.Tokens.Multiply.rawValue {
                    setState(898)
                    try match(JavaScriptParser.Tokens.Multiply.rawValue)

                }

                setState(901)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(903)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(902)
                    try formalParameterList()

                }

                setState(905)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)
                setState(906)
                try functionBody()

                break
            case 3:
                _localctx = ArrowFunctionContext(_localctx)
                try enterOuterAlt(_localctx, 3)
                setState(908)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 101, _ctx) {
                case 1:
                    setState(907)
                    try match(JavaScriptParser.Tokens.Async.rawValue)

                    break
                default: break
                }
                setState(910)
                try arrowFunctionParameters()
                setState(911)
                try match(JavaScriptParser.Tokens.ARROW.rawValue)
                setState(912)
                try arrowFunctionBody()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArrowFunctionParametersContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func OpenParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
        }
        open func CloseParen() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
        }
        open func formalParameterList() -> FormalParameterListContext? {
            return getRuleContext(FormalParameterListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_arrowFunctionParameters
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrowFunctionParameters(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrowFunctionParameters(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrowFunctionParameters(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrowFunctionParameters(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrowFunctionParameters() throws -> ArrowFunctionParametersContext
    {
        var _localctx: ArrowFunctionParametersContext
        _localctx = ArrowFunctionParametersContext(_ctx, getState())
        try enterRule(_localctx, 122, JavaScriptParser.RULE_arrowFunctionParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(922)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Async, .NonStrictLet, .Identifier:
                try enterOuterAlt(_localctx, 1)
                setState(916)
                try identifier()

                break

            case .OpenParen:
                try enterOuterAlt(_localctx, 2)
                setState(917)
                try match(JavaScriptParser.Tokens.OpenParen.rawValue)
                setState(919)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 262688) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0
                {
                    setState(918)
                    try formalParameterList()

                }

                setState(921)
                try match(JavaScriptParser.Tokens.CloseParen.rawValue)

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

    public class ArrowFunctionBodyContext: ParserRuleContext {
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func functionBody() -> FunctionBodyContext? {
            return getRuleContext(FunctionBodyContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_arrowFunctionBody }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterArrowFunctionBody(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitArrowFunctionBody(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitArrowFunctionBody(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitArrowFunctionBody(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrowFunctionBody() throws -> ArrowFunctionBodyContext {
        var _localctx: ArrowFunctionBodyContext
        _localctx = ArrowFunctionBodyContext(_ctx, getState())
        try enterRule(_localctx, 124, JavaScriptParser.RULE_arrowFunctionBody)
        defer { try! exitRule() }
        do {
            setState(926)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 105, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(924)
                try singleExpression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(925)
                try functionBody()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AssignmentOperatorContext: ParserRuleContext {
        open func MultiplyAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.MultiplyAssign.rawValue, 0)
        }
        open func DivideAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.DivideAssign.rawValue, 0)
        }
        open func ModulusAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.ModulusAssign.rawValue, 0)
        }
        open func PlusAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.PlusAssign.rawValue, 0)
        }
        open func MinusAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.MinusAssign.rawValue, 0)
        }
        open func LeftShiftArithmeticAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.LeftShiftArithmeticAssign.rawValue, 0)
        }
        open func RightShiftArithmeticAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.RightShiftArithmeticAssign.rawValue, 0)
        }
        open func RightShiftLogicalAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.RightShiftLogicalAssign.rawValue, 0)
        }
        open func BitAndAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitAndAssign.rawValue, 0)
        }
        open func BitXorAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitXorAssign.rawValue, 0)
        }
        open func BitOrAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BitOrAssign.rawValue, 0)
        }
        open func PowerAssign() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.PowerAssign.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_assignmentOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterAssignmentOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitAssignmentOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitAssignmentOperator(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitAssignmentOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func assignmentOperator() throws -> AssignmentOperatorContext {
        var _localctx: AssignmentOperatorContext
        _localctx = AssignmentOperatorContext(_ctx, getState())
        try enterRule(_localctx, 126, JavaScriptParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(928)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_640_029_630_136_320) != 0)
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

    public class LiteralContext: ParserRuleContext {
        open func NullLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NullLiteral.rawValue, 0)
        }
        open func BooleanLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BooleanLiteral.rawValue, 0)
        }
        open func StringLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
        }
        open func templateStringLiteral() -> TemplateStringLiteralContext? {
            return getRuleContext(TemplateStringLiteralContext.self, 0)
        }
        open func RegularExpressionLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue, 0)
        }
        open func numericLiteral() -> NumericLiteralContext? {
            return getRuleContext(NumericLiteralContext.self, 0)
        }
        open func bigintLiteral() -> BigintLiteralContext? {
            return getRuleContext(BigintLiteralContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_literal }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterLiteral(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitLiteral(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func literal() throws -> LiteralContext {
        var _localctx: LiteralContext
        _localctx = LiteralContext(_ctx, getState())
        try enterRule(_localctx, 128, JavaScriptParser.RULE_literal)
        defer { try! exitRule() }
        do {
            setState(937)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .NullLiteral:
                try enterOuterAlt(_localctx, 1)
                setState(930)
                try match(JavaScriptParser.Tokens.NullLiteral.rawValue)

                break

            case .BooleanLiteral:
                try enterOuterAlt(_localctx, 2)
                setState(931)
                try match(JavaScriptParser.Tokens.BooleanLiteral.rawValue)

                break

            case .StringLiteral:
                try enterOuterAlt(_localctx, 3)
                setState(932)
                try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

                break

            case .BackTick:
                try enterOuterAlt(_localctx, 4)
                setState(933)
                try templateStringLiteral()

                break

            case .RegularExpressionLiteral:
                try enterOuterAlt(_localctx, 5)
                setState(934)
                try match(JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue)

                break
            case .DecimalLiteral, .HexIntegerLiteral, .OctalIntegerLiteral, .OctalIntegerLiteral2,
                .BinaryIntegerLiteral:
                try enterOuterAlt(_localctx, 6)
                setState(935)
                try numericLiteral()

                break
            case .BigHexIntegerLiteral, .BigOctalIntegerLiteral, .BigBinaryIntegerLiteral,
                .BigDecimalIntegerLiteral:
                try enterOuterAlt(_localctx, 7)
                setState(936)
                try bigintLiteral()

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

    public class TemplateStringLiteralContext: ParserRuleContext {
        open func BackTick() -> [TerminalNode] {
            return getTokens(JavaScriptParser.Tokens.BackTick.rawValue)
        }
        open func BackTick(_ i: Int) -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BackTick.rawValue, i)
        }
        open func templateStringAtom() -> [TemplateStringAtomContext] {
            return getRuleContexts(TemplateStringAtomContext.self)
        }
        open func templateStringAtom(_ i: Int) -> TemplateStringAtomContext? {
            return getRuleContext(TemplateStringAtomContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return JavaScriptParser.RULE_templateStringLiteral
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTemplateStringLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTemplateStringLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTemplateStringLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTemplateStringLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func templateStringLiteral() throws -> TemplateStringLiteralContext {
        var _localctx: TemplateStringLiteralContext
        _localctx = TemplateStringLiteralContext(_ctx, getState())
        try enterRule(_localctx, 130, JavaScriptParser.RULE_templateStringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(939)
            try match(JavaScriptParser.Tokens.BackTick.rawValue)
            setState(943)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue
                || _la == JavaScriptParser.Tokens.TemplateStringAtom.rawValue
            {
                setState(940)
                try templateStringAtom()

                setState(945)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(946)
            try match(JavaScriptParser.Tokens.BackTick.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TemplateStringAtomContext: ParserRuleContext {
        open func TemplateStringAtom() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.TemplateStringAtom.rawValue, 0)
        }
        open func TemplateStringStartExpression() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue, 0)
        }
        open func singleExpression() -> SingleExpressionContext? {
            return getRuleContext(SingleExpressionContext.self, 0)
        }
        open func TemplateCloseBrace() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.TemplateCloseBrace.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_templateStringAtom }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterTemplateStringAtom(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitTemplateStringAtom(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitTemplateStringAtom(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitTemplateStringAtom(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func templateStringAtom() throws -> TemplateStringAtomContext {
        var _localctx: TemplateStringAtomContext
        _localctx = TemplateStringAtomContext(_ctx, getState())
        try enterRule(_localctx, 132, JavaScriptParser.RULE_templateStringAtom)
        defer { try! exitRule() }
        do {
            setState(953)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .TemplateStringAtom:
                try enterOuterAlt(_localctx, 1)
                setState(948)
                try match(JavaScriptParser.Tokens.TemplateStringAtom.rawValue)

                break

            case .TemplateStringStartExpression:
                try enterOuterAlt(_localctx, 2)
                setState(949)
                try match(JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue)
                setState(950)
                try singleExpression(0)
                setState(951)
                try match(JavaScriptParser.Tokens.TemplateCloseBrace.rawValue)

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

    public class NumericLiteralContext: ParserRuleContext {
        open func DecimalLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.DecimalLiteral.rawValue, 0)
        }
        open func HexIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.HexIntegerLiteral.rawValue, 0)
        }
        open func OctalIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue, 0)
        }
        open func OctalIntegerLiteral2() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue, 0)
        }
        open func BinaryIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_numericLiteral }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterNumericLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitNumericLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitNumericLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitNumericLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func numericLiteral() throws -> NumericLiteralContext {
        var _localctx: NumericLiteralContext
        _localctx = NumericLiteralContext(_ctx, getState())
        try enterRule(_localctx, 134, JavaScriptParser.RULE_numericLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(955)
            _la = try _input.LA(1)
            if !((Int64((_la - 63)) & ~0x3f) == 0 && ((Int64(1) << (_la - 63)) & 31) != 0) {
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

    public class BigintLiteralContext: ParserRuleContext {
        open func BigDecimalIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue, 0)
        }
        open func BigHexIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue, 0)
        }
        open func BigOctalIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue, 0)
        }
        open func BigBinaryIntegerLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_bigintLiteral }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterBigintLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitBigintLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitBigintLiteral(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitBigintLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func bigintLiteral() throws -> BigintLiteralContext {
        var _localctx: BigintLiteralContext
        _localctx = BigintLiteralContext(_ctx, getState())
        try enterRule(_localctx, 136, JavaScriptParser.RULE_bigintLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(957)
            _la = try _input.LA(1)
            if !((Int64((_la - 68)) & ~0x3f) == 0 && ((Int64(1) << (_la - 68)) & 15) != 0) {
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

    public class GetterContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_getter }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterGetter(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitGetter(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitGetter(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitGetter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func getter() throws -> GetterContext {
        var _localctx: GetterContext
        _localctx = GetterContext(_ctx, getState())
        try enterRule(_localctx, 138, JavaScriptParser.RULE_getter)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(959)
            if !(try self.n("get")) {
                throw ANTLRException.recognition(
                    e: FailedPredicateException(self, "try self.n(\"get\")"))
            }
            setState(960)
            try identifier()
            setState(961)
            try propertyName()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SetterContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func propertyName() -> PropertyNameContext? {
            return getRuleContext(PropertyNameContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_setter }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterSetter(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitSetter(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitSetter(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitSetter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func setter() throws -> SetterContext {
        var _localctx: SetterContext
        _localctx = SetterContext(_ctx, getState())
        try enterRule(_localctx, 140, JavaScriptParser.RULE_setter)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(963)
            if !(try self.n("set")) {
                throw ANTLRException.recognition(
                    e: FailedPredicateException(self, "try self.n(\"set\")"))
            }
            setState(964)
            try identifier()
            setState(965)
            try propertyName()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IdentifierNameContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func reservedWord() -> ReservedWordContext? {
            return getRuleContext(ReservedWordContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_identifierName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterIdentifierName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitIdentifierName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitIdentifierName(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitIdentifierName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func identifierName() throws -> IdentifierNameContext {
        var _localctx: IdentifierNameContext
        _localctx = IdentifierNameContext(_ctx, getState())
        try enterRule(_localctx, 142, JavaScriptParser.RULE_identifierName)
        defer { try! exitRule() }
        do {
            setState(969)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 109, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(967)
                try identifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(968)
                try reservedWord()

                break
            default: break
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IdentifierContext: ParserRuleContext {
        open func Identifier() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Identifier.rawValue, 0)
        }
        open func NonStrictLet() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NonStrictLet.rawValue, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_identifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterIdentifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitIdentifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitIdentifier(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitIdentifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func identifier() throws -> IdentifierContext {
        var _localctx: IdentifierContext
        _localctx = IdentifierContext(_ctx, getState())
        try enterRule(_localctx, 144, JavaScriptParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(971)
            _la = try _input.LA(1)
            if !((Int64((_la - 107)) & ~0x3f) == 0 && ((Int64(1) << (_la - 107)) & 4129) != 0) {
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

    public class ReservedWordContext: ParserRuleContext {
        open func keyword() -> KeywordContext? { return getRuleContext(KeywordContext.self, 0) }
        open func NullLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NullLiteral.rawValue, 0)
        }
        open func BooleanLiteral() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.BooleanLiteral.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_reservedWord }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.enterReservedWord(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener {
                listener.exitReservedWord(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitReservedWord(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitReservedWord(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func reservedWord() throws -> ReservedWordContext {
        var _localctx: ReservedWordContext
        _localctx = ReservedWordContext(_ctx, getState())
        try enterRule(_localctx, 146, JavaScriptParser.RULE_reservedWord)
        defer { try! exitRule() }
        do {
            setState(976)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Break, .Do, .Instanceof, .Typeof, .Case, .Else, .New, .Var, .Catch, .Finally,
                .Return, .Void, .Continue, .For, .Switch, .While, .Debugger, .Function_, .This,
                .With, .Default, .If, .Throw, .Delete, .In, .Try, .As, .From, .Class, .Enum,
                .Extends, .Super, .Const, .Export, .Import, .Async, .Await, .Yield, .Implements,
                .StrictLet, .NonStrictLet, .Private, .Public, .Interface, .Package, .Protected,
                .Static:
                try enterOuterAlt(_localctx, 1)
                setState(973)
                try keyword()

                break

            case .NullLiteral:
                try enterOuterAlt(_localctx, 2)
                setState(974)
                try match(JavaScriptParser.Tokens.NullLiteral.rawValue)

                break

            case .BooleanLiteral:
                try enterOuterAlt(_localctx, 3)
                setState(975)
                try match(JavaScriptParser.Tokens.BooleanLiteral.rawValue)

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

    public class KeywordContext: ParserRuleContext {
        open func Break() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Break.rawValue, 0)
        }
        open func Do() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.Do.rawValue, 0) }
        open func Instanceof() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Instanceof.rawValue, 0)
        }
        open func Typeof() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Typeof.rawValue, 0)
        }
        open func Case() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Case.rawValue, 0)
        }
        open func Else() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Else.rawValue, 0)
        }
        open func New() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
        }
        open func Var() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Var.rawValue, 0)
        }
        open func Catch() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Catch.rawValue, 0)
        }
        open func Finally() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Finally.rawValue, 0)
        }
        open func Return() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Return.rawValue, 0)
        }
        open func Void() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Void.rawValue, 0)
        }
        open func Continue() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Continue.rawValue, 0)
        }
        open func For() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
        }
        open func Switch() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Switch.rawValue, 0)
        }
        open func While() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
        }
        open func Debugger() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Debugger.rawValue, 0)
        }
        open func Function_() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
        }
        open func This() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.This.rawValue, 0)
        }
        open func With() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.With.rawValue, 0)
        }
        open func Default() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
        }
        open func If() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.If.rawValue, 0) }
        open func Throw() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Throw.rawValue, 0)
        }
        open func Delete() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Delete.rawValue, 0)
        }
        open func In() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.In.rawValue, 0) }
        open func Try() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Try.rawValue, 0)
        }
        open func Class() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
        }
        open func Enum() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Enum.rawValue, 0)
        }
        open func Extends() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Extends.rawValue, 0)
        }
        open func Super() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Super.rawValue, 0)
        }
        open func Const() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Const.rawValue, 0)
        }
        open func Export() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
        }
        open func Import() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
        }
        open func Implements() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Implements.rawValue, 0)
        }
        open func let_() -> Let_Context? { return getRuleContext(Let_Context.self, 0) }
        open func Private() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Private.rawValue, 0)
        }
        open func Public() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Public.rawValue, 0)
        }
        open func Interface() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Interface.rawValue, 0)
        }
        open func Package() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Package.rawValue, 0)
        }
        open func Protected() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Protected.rawValue, 0)
        }
        open func Static() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Static.rawValue, 0)
        }
        open func Yield() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Yield.rawValue, 0)
        }
        open func Async() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
        }
        open func Await() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
        }
        open func From() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.From.rawValue, 0)
        }
        open func As() -> TerminalNode? { return getToken(JavaScriptParser.Tokens.As.rawValue, 0) }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_keyword }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterKeyword(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitKeyword(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitKeyword(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitKeyword(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func keyword() throws -> KeywordContext {
        var _localctx: KeywordContext
        _localctx = KeywordContext(_ctx, getState())
        try enterRule(_localctx, 148, JavaScriptParser.RULE_keyword)
        defer { try! exitRule() }
        do {
            setState(1024)
            try _errHandler.sync(self)
            switch JavaScriptParser.Tokens(rawValue: try _input.LA(1))! {
            case .Break:
                try enterOuterAlt(_localctx, 1)
                setState(978)
                try match(JavaScriptParser.Tokens.Break.rawValue)

                break

            case .Do:
                try enterOuterAlt(_localctx, 2)
                setState(979)
                try match(JavaScriptParser.Tokens.Do.rawValue)

                break

            case .Instanceof:
                try enterOuterAlt(_localctx, 3)
                setState(980)
                try match(JavaScriptParser.Tokens.Instanceof.rawValue)

                break

            case .Typeof:
                try enterOuterAlt(_localctx, 4)
                setState(981)
                try match(JavaScriptParser.Tokens.Typeof.rawValue)

                break

            case .Case:
                try enterOuterAlt(_localctx, 5)
                setState(982)
                try match(JavaScriptParser.Tokens.Case.rawValue)

                break

            case .Else:
                try enterOuterAlt(_localctx, 6)
                setState(983)
                try match(JavaScriptParser.Tokens.Else.rawValue)

                break

            case .New:
                try enterOuterAlt(_localctx, 7)
                setState(984)
                try match(JavaScriptParser.Tokens.New.rawValue)

                break

            case .Var:
                try enterOuterAlt(_localctx, 8)
                setState(985)
                try match(JavaScriptParser.Tokens.Var.rawValue)

                break

            case .Catch:
                try enterOuterAlt(_localctx, 9)
                setState(986)
                try match(JavaScriptParser.Tokens.Catch.rawValue)

                break

            case .Finally:
                try enterOuterAlt(_localctx, 10)
                setState(987)
                try match(JavaScriptParser.Tokens.Finally.rawValue)

                break

            case .Return:
                try enterOuterAlt(_localctx, 11)
                setState(988)
                try match(JavaScriptParser.Tokens.Return.rawValue)

                break

            case .Void:
                try enterOuterAlt(_localctx, 12)
                setState(989)
                try match(JavaScriptParser.Tokens.Void.rawValue)

                break

            case .Continue:
                try enterOuterAlt(_localctx, 13)
                setState(990)
                try match(JavaScriptParser.Tokens.Continue.rawValue)

                break

            case .For:
                try enterOuterAlt(_localctx, 14)
                setState(991)
                try match(JavaScriptParser.Tokens.For.rawValue)

                break

            case .Switch:
                try enterOuterAlt(_localctx, 15)
                setState(992)
                try match(JavaScriptParser.Tokens.Switch.rawValue)

                break

            case .While:
                try enterOuterAlt(_localctx, 16)
                setState(993)
                try match(JavaScriptParser.Tokens.While.rawValue)

                break

            case .Debugger:
                try enterOuterAlt(_localctx, 17)
                setState(994)
                try match(JavaScriptParser.Tokens.Debugger.rawValue)

                break

            case .Function_:
                try enterOuterAlt(_localctx, 18)
                setState(995)
                try match(JavaScriptParser.Tokens.Function_.rawValue)

                break

            case .This:
                try enterOuterAlt(_localctx, 19)
                setState(996)
                try match(JavaScriptParser.Tokens.This.rawValue)

                break

            case .With:
                try enterOuterAlt(_localctx, 20)
                setState(997)
                try match(JavaScriptParser.Tokens.With.rawValue)

                break

            case .Default:
                try enterOuterAlt(_localctx, 21)
                setState(998)
                try match(JavaScriptParser.Tokens.Default.rawValue)

                break

            case .If:
                try enterOuterAlt(_localctx, 22)
                setState(999)
                try match(JavaScriptParser.Tokens.If.rawValue)

                break

            case .Throw:
                try enterOuterAlt(_localctx, 23)
                setState(1000)
                try match(JavaScriptParser.Tokens.Throw.rawValue)

                break

            case .Delete:
                try enterOuterAlt(_localctx, 24)
                setState(1001)
                try match(JavaScriptParser.Tokens.Delete.rawValue)

                break

            case .In:
                try enterOuterAlt(_localctx, 25)
                setState(1002)
                try match(JavaScriptParser.Tokens.In.rawValue)

                break

            case .Try:
                try enterOuterAlt(_localctx, 26)
                setState(1003)
                try match(JavaScriptParser.Tokens.Try.rawValue)

                break

            case .Class:
                try enterOuterAlt(_localctx, 27)
                setState(1004)
                try match(JavaScriptParser.Tokens.Class.rawValue)

                break

            case .Enum:
                try enterOuterAlt(_localctx, 28)
                setState(1005)
                try match(JavaScriptParser.Tokens.Enum.rawValue)

                break

            case .Extends:
                try enterOuterAlt(_localctx, 29)
                setState(1006)
                try match(JavaScriptParser.Tokens.Extends.rawValue)

                break

            case .Super:
                try enterOuterAlt(_localctx, 30)
                setState(1007)
                try match(JavaScriptParser.Tokens.Super.rawValue)

                break

            case .Const:
                try enterOuterAlt(_localctx, 31)
                setState(1008)
                try match(JavaScriptParser.Tokens.Const.rawValue)

                break

            case .Export:
                try enterOuterAlt(_localctx, 32)
                setState(1009)
                try match(JavaScriptParser.Tokens.Export.rawValue)

                break

            case .Import:
                try enterOuterAlt(_localctx, 33)
                setState(1010)
                try match(JavaScriptParser.Tokens.Import.rawValue)

                break

            case .Implements:
                try enterOuterAlt(_localctx, 34)
                setState(1011)
                try match(JavaScriptParser.Tokens.Implements.rawValue)

                break
            case .StrictLet, .NonStrictLet:
                try enterOuterAlt(_localctx, 35)
                setState(1012)
                try let_()

                break

            case .Private:
                try enterOuterAlt(_localctx, 36)
                setState(1013)
                try match(JavaScriptParser.Tokens.Private.rawValue)

                break

            case .Public:
                try enterOuterAlt(_localctx, 37)
                setState(1014)
                try match(JavaScriptParser.Tokens.Public.rawValue)

                break

            case .Interface:
                try enterOuterAlt(_localctx, 38)
                setState(1015)
                try match(JavaScriptParser.Tokens.Interface.rawValue)

                break

            case .Package:
                try enterOuterAlt(_localctx, 39)
                setState(1016)
                try match(JavaScriptParser.Tokens.Package.rawValue)

                break

            case .Protected:
                try enterOuterAlt(_localctx, 40)
                setState(1017)
                try match(JavaScriptParser.Tokens.Protected.rawValue)

                break

            case .Static:
                try enterOuterAlt(_localctx, 41)
                setState(1018)
                try match(JavaScriptParser.Tokens.Static.rawValue)

                break

            case .Yield:
                try enterOuterAlt(_localctx, 42)
                setState(1019)
                try match(JavaScriptParser.Tokens.Yield.rawValue)

                break

            case .Async:
                try enterOuterAlt(_localctx, 43)
                setState(1020)
                try match(JavaScriptParser.Tokens.Async.rawValue)

                break

            case .Await:
                try enterOuterAlt(_localctx, 44)
                setState(1021)
                try match(JavaScriptParser.Tokens.Await.rawValue)

                break

            case .From:
                try enterOuterAlt(_localctx, 45)
                setState(1022)
                try match(JavaScriptParser.Tokens.From.rawValue)

                break

            case .As:
                try enterOuterAlt(_localctx, 46)
                setState(1023)
                try match(JavaScriptParser.Tokens.As.rawValue)

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

    public class Let_Context: ParserRuleContext {
        open func NonStrictLet() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.NonStrictLet.rawValue, 0)
        }
        open func StrictLet() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.StrictLet.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_let_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterLet_(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitLet_(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitLet_(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitLet_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func let_() throws -> Let_Context {
        var _localctx: Let_Context
        _localctx = Let_Context(_ctx, getState())
        try enterRule(_localctx, 150, JavaScriptParser.RULE_let_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1026)
            _la = try _input.LA(1)
            if !(_la == JavaScriptParser.Tokens.StrictLet.rawValue
                || _la == JavaScriptParser.Tokens.NonStrictLet.rawValue)
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

    public class EosContext: ParserRuleContext {
        open func SemiColon() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
        }
        open func EOF() -> TerminalNode? {
            return getToken(JavaScriptParser.Tokens.EOF.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return JavaScriptParser.RULE_eos }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.enterEos(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? JavaScriptParserListener { listener.exitEos(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? JavaScriptParserVisitor {
                return visitor.visitEos(self)
            } else if let visitor = visitor as? JavaScriptParserBaseVisitor {
                return visitor.visitEos(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func eos() throws -> EosContext {
        var _localctx: EosContext
        _localctx = EosContext(_ctx, getState())
        try enterRule(_localctx, 152, JavaScriptParser.RULE_eos)
        defer { try! exitRule() }
        do {
            setState(1032)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 112, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1028)
                try match(JavaScriptParser.Tokens.SemiColon.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1029)
                try match(JavaScriptParser.Tokens.EOF.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1030)
                if !(try self.lineTerminatorAhead()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.lineTerminatorAhead()"))
                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1031)
                if !(try self.closeBrace()) {
                    throw ANTLRException.recognition(
                        e: FailedPredicateException(self, "try self.closeBrace()"))
                }

                break
            default: break
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
        case 19:
            return try expressionStatement_sempred(
                _localctx?.castdown(ExpressionStatementContext.self), predIndex)
        case 21:
            return try iterationStatement_sempred(
                _localctx?.castdown(IterationStatementContext.self), predIndex)
        case 23:
            return try continueStatement_sempred(
                _localctx?.castdown(ContinueStatementContext.self), predIndex)
        case 24:
            return try breakStatement_sempred(
                _localctx?.castdown(BreakStatementContext.self), predIndex)
        case 25:
            return try returnStatement_sempred(
                _localctx?.castdown(ReturnStatementContext.self), predIndex)
        case 26:
            return try yieldStatement_sempred(
                _localctx?.castdown(YieldStatementContext.self), predIndex)
        case 34:
            return try throwStatement_sempred(
                _localctx?.castdown(ThrowStatementContext.self), predIndex)
        case 42:
            return try classElement_sempred(
                _localctx?.castdown(ClassElementContext.self), predIndex)
        case 57:
            return try singleExpression_sempred(
                _localctx?.castdown(SingleExpressionContext.self), predIndex)
        case 69: return try getter_sempred(_localctx?.castdown(GetterContext.self), predIndex)
        case 70: return try setter_sempred(_localctx?.castdown(SetterContext.self), predIndex)
        case 76: return try eos_sempred(_localctx?.castdown(EosContext.self), predIndex)
        default: return true
        }
    }
    private func expressionStatement_sempred(
        _ _localctx: ExpressionStatementContext!, _ predIndex: Int
    ) throws -> Bool {
        switch predIndex {
        case 0: return try self.notOpenBraceAndNotFunction()
        default: return true
        }
    }
    private func iterationStatement_sempred(
        _ _localctx: IterationStatementContext!, _ predIndex: Int
    ) throws -> Bool {
        switch predIndex {
        case 1: return try self.p("of")
        default: return true
        }
    }
    private func continueStatement_sempred(_ _localctx: ContinueStatementContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 2: return try self.notLineTerminator()
        default: return true
        }
    }
    private func breakStatement_sempred(_ _localctx: BreakStatementContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 3: return try self.notLineTerminator()
        default: return true
        }
    }
    private func returnStatement_sempred(_ _localctx: ReturnStatementContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 4: return try self.notLineTerminator()
        default: return true
        }
    }
    private func yieldStatement_sempred(_ _localctx: YieldStatementContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 5: return try self.notLineTerminator()
        default: return true
        }
    }
    private func throwStatement_sempred(_ _localctx: ThrowStatementContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 6: return try self.notLineTerminator()
        default: return true
        }
    }
    private func classElement_sempred(_ _localctx: ClassElementContext!, _ predIndex: Int) throws
        -> Bool
    {
        switch predIndex {
        case 7: return try self.n("static")
        default: return true
        }
    }
    private func singleExpression_sempred(_ _localctx: SingleExpressionContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 8: return precpred(_ctx, 46)
        case 9: return precpred(_ctx, 27)
        case 10: return precpred(_ctx, 26)
        case 11: return precpred(_ctx, 25)
        case 12: return precpred(_ctx, 24)
        case 13: return precpred(_ctx, 23)
        case 14: return precpred(_ctx, 22)
        case 15: return precpred(_ctx, 21)
        case 16: return precpred(_ctx, 20)
        case 17: return precpred(_ctx, 19)
        case 18: return precpred(_ctx, 18)
        case 19: return precpred(_ctx, 17)
        case 20: return precpred(_ctx, 16)
        case 21: return precpred(_ctx, 15)
        case 22: return precpred(_ctx, 14)
        case 23: return precpred(_ctx, 13)
        case 24: return precpred(_ctx, 12)
        case 25: return precpred(_ctx, 11)
        case 26: return precpred(_ctx, 45)
        case 27: return precpred(_ctx, 44)
        case 28: return precpred(_ctx, 41)
        case 29: return precpred(_ctx, 39)
        case 30: return try self.notLineTerminator()
        case 31: return precpred(_ctx, 38)
        case 32: return try self.notLineTerminator()
        case 33: return precpred(_ctx, 9)
        default: return true
        }
    }
    private func getter_sempred(_ _localctx: GetterContext!, _ predIndex: Int) throws -> Bool {
        switch predIndex {
        case 34: return try self.n("get")
        default: return true
        }
    }
    private func setter_sempred(_ _localctx: SetterContext!, _ predIndex: Int) throws -> Bool {
        switch predIndex {
        case 35: return try self.n("set")
        default: return true
        }
    }
    private func eos_sempred(_ _localctx: EosContext!, _ predIndex: Int) throws -> Bool {
        switch predIndex {
        case 36: return try self.lineTerminatorAhead()
        case 37: return try self.closeBrace()
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 128, 1035, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
        6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 2, 9, 7, 9, 2, 10, 7, 10, 2, 11, 7, 11, 2, 12, 7, 12, 2,
        13, 7, 13, 2, 14, 7, 14, 2, 15, 7, 15, 2, 16, 7, 16, 2, 17, 7, 17, 2, 18, 7, 18, 2, 19, 7,
        19, 2, 20, 7, 20, 2, 21, 7, 21, 2, 22, 7, 22, 2, 23, 7, 23, 2, 24, 7, 24, 2, 25, 7, 25, 2,
        26, 7, 26, 2, 27, 7, 27, 2, 28, 7, 28, 2, 29, 7, 29, 2, 30, 7, 30, 2, 31, 7, 31, 2, 32, 7,
        32, 2, 33, 7, 33, 2, 34, 7, 34, 2, 35, 7, 35, 2, 36, 7, 36, 2, 37, 7, 37, 2, 38, 7, 38, 2,
        39, 7, 39, 2, 40, 7, 40, 2, 41, 7, 41, 2, 42, 7, 42, 2, 43, 7, 43, 2, 44, 7, 44, 2, 45, 7,
        45, 2, 46, 7, 46, 2, 47, 7, 47, 2, 48, 7, 48, 2, 49, 7, 49, 2, 50, 7, 50, 2, 51, 7, 51, 2,
        52, 7, 52, 2, 53, 7, 53, 2, 54, 7, 54, 2, 55, 7, 55, 2, 56, 7, 56, 2, 57, 7, 57, 2, 58, 7,
        58, 2, 59, 7, 59, 2, 60, 7, 60, 2, 61, 7, 61, 2, 62, 7, 62, 2, 63, 7, 63, 2, 64, 7, 64, 2,
        65, 7, 65, 2, 66, 7, 66, 2, 67, 7, 67, 2, 68, 7, 68, 2, 69, 7, 69, 2, 70, 7, 70, 2, 71, 7,
        71, 2, 72, 7, 72, 2, 73, 7, 73, 2, 74, 7, 74, 2, 75, 7, 75, 2, 76, 7, 76, 1, 0, 3, 0, 156,
        8, 0, 1, 0, 3, 0, 159, 8, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1,
        2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 185,
        8, 2, 1, 3, 1, 3, 3, 3, 189, 8, 3, 1, 3, 1, 3, 1, 4, 4, 4, 194, 8, 4, 11, 4, 12, 4, 195, 1,
        5, 1, 5, 1, 5, 1, 6, 3, 6, 202, 8, 6, 1, 6, 1, 6, 3, 6, 206, 8, 6, 1, 6, 1, 6, 1, 6, 1, 6,
        1, 6, 3, 6, 213, 8, 6, 1, 7, 1, 7, 1, 7, 1, 7, 5, 7, 219, 8, 7, 10, 7, 12, 7, 222, 9, 7, 1,
        7, 1, 7, 3, 7, 226, 8, 7, 3, 7, 228, 8, 7, 1, 7, 1, 7, 1, 8, 1, 8, 1, 8, 1, 9, 1, 9, 3, 9,
        237, 8, 9, 1, 9, 1, 9, 3, 9, 241, 8, 9, 1, 10, 1, 10, 1, 10, 1, 11, 1, 11, 1, 11, 3, 11,
        249, 8, 11, 1, 12, 1, 12, 1, 12, 3, 12, 254, 8, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1, 12, 1,
        12, 1, 12, 3, 12, 263, 8, 12, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 1, 13, 3, 13, 271, 8, 13,
        1, 13, 1, 13, 3, 13, 275, 8, 13, 1, 14, 1, 14, 1, 14, 3, 14, 280, 8, 14, 1, 15, 1, 15, 1,
        15, 1, 16, 1, 16, 1, 16, 1, 16, 5, 16, 289, 8, 16, 10, 16, 12, 16, 292, 9, 16, 1, 17, 1, 17,
        1, 17, 3, 17, 297, 8, 17, 1, 18, 1, 18, 1, 19, 1, 19, 1, 19, 1, 19, 1, 20, 1, 20, 1, 20, 1,
        20, 1, 20, 1, 20, 1, 20, 3, 20, 312, 8, 20, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21,
        1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 3, 21, 332, 8,
        21, 1, 21, 1, 21, 3, 21, 336, 8, 21, 1, 21, 1, 21, 3, 21, 340, 8, 21, 1, 21, 1, 21, 1, 21,
        1, 21, 1, 21, 1, 21, 3, 21, 348, 8, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 3,
        21, 357, 8, 21, 1, 21, 1, 21, 1, 21, 3, 21, 362, 8, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21,
        1, 21, 3, 21, 370, 8, 21, 1, 22, 1, 22, 1, 22, 3, 22, 375, 8, 22, 1, 23, 1, 23, 1, 23, 3,
        23, 380, 8, 23, 1, 23, 1, 23, 1, 24, 1, 24, 1, 24, 3, 24, 387, 8, 24, 1, 24, 1, 24, 1, 25,
        1, 25, 1, 25, 3, 25, 394, 8, 25, 1, 25, 1, 25, 1, 26, 1, 26, 1, 26, 3, 26, 401, 8, 26, 1,
        26, 1, 26, 1, 27, 1, 27, 1, 27, 1, 27, 1, 27, 1, 27, 1, 28, 1, 28, 1, 28, 1, 28, 1, 28, 1,
        28, 1, 29, 1, 29, 3, 29, 419, 8, 29, 1, 29, 1, 29, 3, 29, 423, 8, 29, 3, 29, 425, 8, 29, 1,
        29, 1, 29, 1, 30, 4, 30, 430, 8, 30, 11, 30, 12, 30, 431, 1, 31, 1, 31, 1, 31, 1, 31, 3, 31,
        438, 8, 31, 1, 32, 1, 32, 1, 32, 3, 32, 443, 8, 32, 1, 33, 1, 33, 1, 33, 1, 33, 1, 34, 1,
        34, 1, 34, 1, 34, 1, 34, 1, 35, 1, 35, 1, 35, 1, 35, 3, 35, 458, 8, 35, 1, 35, 3, 35, 461,
        8, 35, 1, 36, 1, 36, 1, 36, 3, 36, 466, 8, 36, 1, 36, 3, 36, 469, 8, 36, 1, 36, 1, 36, 1,
        37, 1, 37, 1, 37, 1, 38, 1, 38, 1, 38, 1, 39, 3, 39, 480, 8, 39, 1, 39, 1, 39, 3, 39, 484,
        8, 39, 1, 39, 1, 39, 1, 39, 3, 39, 489, 8, 39, 1, 39, 1, 39, 1, 39, 1, 40, 1, 40, 1, 40, 1,
        40, 1, 41, 1, 41, 3, 41, 500, 8, 41, 1, 41, 1, 41, 5, 41, 504, 8, 41, 10, 41, 12, 41, 507,
        9, 41, 1, 41, 1, 41, 1, 42, 1, 42, 1, 42, 1, 42, 5, 42, 515, 8, 42, 10, 42, 12, 42, 518, 9,
        42, 1, 42, 1, 42, 1, 42, 1, 42, 1, 42, 1, 42, 3, 42, 526, 8, 42, 1, 42, 1, 42, 3, 42, 530,
        8, 42, 1, 42, 1, 42, 1, 42, 1, 42, 3, 42, 536, 8, 42, 1, 43, 3, 43, 539, 8, 43, 1, 43, 3,
        43, 542, 8, 43, 1, 43, 1, 43, 1, 43, 3, 43, 547, 8, 43, 1, 43, 1, 43, 1, 43, 1, 43, 3, 43,
        553, 8, 43, 1, 43, 3, 43, 556, 8, 43, 1, 43, 1, 43, 1, 43, 1, 43, 1, 43, 1, 43, 3, 43, 564,
        8, 43, 1, 43, 3, 43, 567, 8, 43, 1, 43, 1, 43, 1, 43, 3, 43, 572, 8, 43, 1, 43, 1, 43, 1,
        43, 3, 43, 577, 8, 43, 1, 44, 1, 44, 1, 44, 5, 44, 582, 8, 44, 10, 44, 12, 44, 585, 9, 44,
        1, 44, 1, 44, 3, 44, 589, 8, 44, 1, 44, 3, 44, 592, 8, 44, 1, 45, 1, 45, 1, 45, 3, 45, 597,
        8, 45, 1, 46, 1, 46, 1, 46, 1, 47, 1, 47, 3, 47, 604, 8, 47, 1, 47, 1, 47, 1, 48, 4, 48,
        609, 8, 48, 11, 48, 12, 48, 610, 1, 49, 1, 49, 1, 49, 1, 49, 1, 50, 5, 50, 618, 8, 50, 10,
        50, 12, 50, 621, 9, 50, 1, 50, 3, 50, 624, 8, 50, 1, 50, 4, 50, 627, 8, 50, 11, 50, 12, 50,
        628, 1, 50, 5, 50, 632, 8, 50, 10, 50, 12, 50, 635, 9, 50, 1, 50, 5, 50, 638, 8, 50, 10, 50,
        12, 50, 641, 9, 50, 1, 51, 3, 51, 644, 8, 51, 1, 51, 1, 51, 1, 52, 1, 52, 1, 52, 1, 52, 1,
        52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 3, 52, 659, 8, 52, 1, 52, 3, 52, 662, 8, 52,
        1, 52, 1, 52, 1, 52, 3, 52, 667, 8, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1,
        52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 1, 52, 3, 52, 684, 8, 52, 1, 52, 3, 52, 687,
        8, 52, 1, 53, 1, 53, 1, 53, 1, 53, 1, 53, 1, 53, 1, 53, 3, 53, 696, 8, 53, 1, 54, 1, 54, 1,
        54, 1, 54, 5, 54, 702, 8, 54, 10, 54, 12, 54, 705, 9, 54, 1, 54, 3, 54, 708, 8, 54, 3, 54,
        710, 8, 54, 1, 54, 1, 54, 1, 55, 3, 55, 715, 8, 55, 1, 55, 1, 55, 3, 55, 719, 8, 55, 1, 56,
        1, 56, 1, 56, 5, 56, 724, 8, 56, 10, 56, 12, 56, 727, 9, 56, 1, 57, 1, 57, 1, 57, 1, 57, 3,
        57, 733, 8, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57,
        1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57,
        1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57,
        1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 3, 57, 781, 8, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 3, 57, 843, 8, 57, 1, 57, 1, 57, 1, 57, 1, 57,
        1, 57, 1, 57, 3, 57, 851, 8, 57, 1, 57, 1, 57, 3, 57, 855, 8, 57, 1, 57, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 5, 57, 868, 8, 57, 10, 57, 12, 57, 871,
        9, 57, 1, 58, 1, 58, 1, 58, 3, 58, 876, 8, 58, 1, 59, 1, 59, 1, 59, 1, 59, 5, 59, 882, 8,
        59, 10, 59, 12, 59, 885, 9, 59, 1, 59, 3, 59, 888, 8, 59, 3, 59, 890, 8, 59, 1, 59, 1, 59,
        1, 60, 1, 60, 3, 60, 896, 8, 60, 1, 60, 1, 60, 3, 60, 900, 8, 60, 1, 60, 1, 60, 3, 60, 904,
        8, 60, 1, 60, 1, 60, 1, 60, 3, 60, 909, 8, 60, 1, 60, 1, 60, 1, 60, 1, 60, 3, 60, 915, 8,
        60, 1, 61, 1, 61, 1, 61, 3, 61, 920, 8, 61, 1, 61, 3, 61, 923, 8, 61, 1, 62, 1, 62, 3, 62,
        927, 8, 62, 1, 63, 1, 63, 1, 64, 1, 64, 1, 64, 1, 64, 1, 64, 1, 64, 1, 64, 3, 64, 938, 8,
        64, 1, 65, 1, 65, 5, 65, 942, 8, 65, 10, 65, 12, 65, 945, 9, 65, 1, 65, 1, 65, 1, 66, 1, 66,
        1, 66, 1, 66, 1, 66, 3, 66, 954, 8, 66, 1, 67, 1, 67, 1, 68, 1, 68, 1, 69, 1, 69, 1, 69, 1,
        69, 1, 70, 1, 70, 1, 70, 1, 70, 1, 71, 1, 71, 3, 71, 970, 8, 71, 1, 72, 1, 72, 1, 73, 1, 73,
        1, 73, 3, 73, 977, 8, 73, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1,
        74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1,
        74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1,
        74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 3, 74, 1025, 8,
        74, 1, 75, 1, 75, 1, 76, 1, 76, 1, 76, 1, 76, 3, 76, 1033, 8, 76, 1, 76, 0, 1, 114, 77, 0,
        2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48,
        50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94,
        96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128, 130, 132,
        134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 0, 10, 1, 0, 26, 28, 1, 0, 22, 23, 1, 0,
        32, 34, 1, 0, 35, 38, 1, 0, 39, 42, 1, 0, 48, 59, 1, 0, 63, 67, 1, 0, 68, 71, 3, 0, 107,
        107, 112, 112, 119, 119, 1, 0, 111, 112, 1201, 0, 155, 1, 0, 0, 0, 2, 162, 1, 0, 0, 0, 4,
        184, 1, 0, 0, 0, 6, 186, 1, 0, 0, 0, 8, 193, 1, 0, 0, 0, 10, 197, 1, 0, 0, 0, 12, 212, 1, 0,
        0, 0, 14, 214, 1, 0, 0, 0, 16, 231, 1, 0, 0, 0, 18, 236, 1, 0, 0, 0, 20, 242, 1, 0, 0, 0,
        22, 245, 1, 0, 0, 0, 24, 262, 1, 0, 0, 0, 26, 274, 1, 0, 0, 0, 28, 279, 1, 0, 0, 0, 30, 281,
        1, 0, 0, 0, 32, 284, 1, 0, 0, 0, 34, 293, 1, 0, 0, 0, 36, 298, 1, 0, 0, 0, 38, 300, 1, 0, 0,
        0, 40, 304, 1, 0, 0, 0, 42, 369, 1, 0, 0, 0, 44, 374, 1, 0, 0, 0, 46, 376, 1, 0, 0, 0, 48,
        383, 1, 0, 0, 0, 50, 390, 1, 0, 0, 0, 52, 397, 1, 0, 0, 0, 54, 404, 1, 0, 0, 0, 56, 410, 1,
        0, 0, 0, 58, 416, 1, 0, 0, 0, 60, 429, 1, 0, 0, 0, 62, 433, 1, 0, 0, 0, 64, 439, 1, 0, 0, 0,
        66, 444, 1, 0, 0, 0, 68, 448, 1, 0, 0, 0, 70, 453, 1, 0, 0, 0, 72, 462, 1, 0, 0, 0, 74, 472,
        1, 0, 0, 0, 76, 475, 1, 0, 0, 0, 78, 479, 1, 0, 0, 0, 80, 493, 1, 0, 0, 0, 82, 499, 1, 0, 0,
        0, 84, 535, 1, 0, 0, 0, 86, 576, 1, 0, 0, 0, 88, 591, 1, 0, 0, 0, 90, 593, 1, 0, 0, 0, 92,
        598, 1, 0, 0, 0, 94, 601, 1, 0, 0, 0, 96, 608, 1, 0, 0, 0, 98, 612, 1, 0, 0, 0, 100, 619, 1,
        0, 0, 0, 102, 643, 1, 0, 0, 0, 104, 686, 1, 0, 0, 0, 106, 695, 1, 0, 0, 0, 108, 697, 1, 0,
        0, 0, 110, 714, 1, 0, 0, 0, 112, 720, 1, 0, 0, 0, 114, 780, 1, 0, 0, 0, 116, 875, 1, 0, 0,
        0, 118, 877, 1, 0, 0, 0, 120, 914, 1, 0, 0, 0, 122, 922, 1, 0, 0, 0, 124, 926, 1, 0, 0, 0,
        126, 928, 1, 0, 0, 0, 128, 937, 1, 0, 0, 0, 130, 939, 1, 0, 0, 0, 132, 953, 1, 0, 0, 0, 134,
        955, 1, 0, 0, 0, 136, 957, 1, 0, 0, 0, 138, 959, 1, 0, 0, 0, 140, 963, 1, 0, 0, 0, 142, 969,
        1, 0, 0, 0, 144, 971, 1, 0, 0, 0, 146, 976, 1, 0, 0, 0, 148, 1024, 1, 0, 0, 0, 150, 1026, 1,
        0, 0, 0, 152, 1032, 1, 0, 0, 0, 154, 156, 5, 1, 0, 0, 155, 154, 1, 0, 0, 0, 155, 156, 1, 0,
        0, 0, 156, 158, 1, 0, 0, 0, 157, 159, 3, 96, 48, 0, 158, 157, 1, 0, 0, 0, 158, 159, 1, 0, 0,
        0, 159, 160, 1, 0, 0, 0, 160, 161, 5, 0, 0, 1, 161, 1, 1, 0, 0, 0, 162, 163, 3, 4, 2, 0,
        163, 3, 1, 0, 0, 0, 164, 185, 3, 6, 3, 0, 165, 185, 3, 30, 15, 0, 166, 185, 3, 10, 5, 0,
        167, 185, 3, 24, 12, 0, 168, 185, 3, 36, 18, 0, 169, 185, 3, 80, 40, 0, 170, 185, 3, 38, 19,
        0, 171, 185, 3, 40, 20, 0, 172, 185, 3, 42, 21, 0, 173, 185, 3, 46, 23, 0, 174, 185, 3, 48,
        24, 0, 175, 185, 3, 50, 25, 0, 176, 185, 3, 52, 26, 0, 177, 185, 3, 54, 27, 0, 178, 185, 3,
        66, 33, 0, 179, 185, 3, 56, 28, 0, 180, 185, 3, 68, 34, 0, 181, 185, 3, 70, 35, 0, 182, 185,
        3, 76, 38, 0, 183, 185, 3, 78, 39, 0, 184, 164, 1, 0, 0, 0, 184, 165, 1, 0, 0, 0, 184, 166,
        1, 0, 0, 0, 184, 167, 1, 0, 0, 0, 184, 168, 1, 0, 0, 0, 184, 169, 1, 0, 0, 0, 184, 170, 1,
        0, 0, 0, 184, 171, 1, 0, 0, 0, 184, 172, 1, 0, 0, 0, 184, 173, 1, 0, 0, 0, 184, 174, 1, 0,
        0, 0, 184, 175, 1, 0, 0, 0, 184, 176, 1, 0, 0, 0, 184, 177, 1, 0, 0, 0, 184, 178, 1, 0, 0,
        0, 184, 179, 1, 0, 0, 0, 184, 180, 1, 0, 0, 0, 184, 181, 1, 0, 0, 0, 184, 182, 1, 0, 0, 0,
        184, 183, 1, 0, 0, 0, 185, 5, 1, 0, 0, 0, 186, 188, 5, 9, 0, 0, 187, 189, 3, 8, 4, 0, 188,
        187, 1, 0, 0, 0, 188, 189, 1, 0, 0, 0, 189, 190, 1, 0, 0, 0, 190, 191, 5, 11, 0, 0, 191, 7,
        1, 0, 0, 0, 192, 194, 3, 4, 2, 0, 193, 192, 1, 0, 0, 0, 194, 195, 1, 0, 0, 0, 195, 193, 1,
        0, 0, 0, 195, 196, 1, 0, 0, 0, 196, 9, 1, 0, 0, 0, 197, 198, 5, 106, 0, 0, 198, 199, 3, 12,
        6, 0, 199, 11, 1, 0, 0, 0, 200, 202, 3, 16, 8, 0, 201, 200, 1, 0, 0, 0, 201, 202, 1, 0, 0,
        0, 202, 205, 1, 0, 0, 0, 203, 206, 3, 18, 9, 0, 204, 206, 3, 14, 7, 0, 205, 203, 1, 0, 0, 0,
        205, 204, 1, 0, 0, 0, 206, 207, 1, 0, 0, 0, 207, 208, 3, 20, 10, 0, 208, 209, 3, 152, 76, 0,
        209, 213, 1, 0, 0, 0, 210, 211, 5, 120, 0, 0, 211, 213, 3, 152, 76, 0, 212, 201, 1, 0, 0, 0,
        212, 210, 1, 0, 0, 0, 213, 13, 1, 0, 0, 0, 214, 220, 5, 9, 0, 0, 215, 216, 3, 22, 11, 0,
        216, 217, 5, 13, 0, 0, 217, 219, 1, 0, 0, 0, 218, 215, 1, 0, 0, 0, 219, 222, 1, 0, 0, 0,
        220, 218, 1, 0, 0, 0, 220, 221, 1, 0, 0, 0, 221, 227, 1, 0, 0, 0, 222, 220, 1, 0, 0, 0, 223,
        225, 3, 22, 11, 0, 224, 226, 5, 13, 0, 0, 225, 224, 1, 0, 0, 0, 225, 226, 1, 0, 0, 0, 226,
        228, 1, 0, 0, 0, 227, 223, 1, 0, 0, 0, 227, 228, 1, 0, 0, 0, 228, 229, 1, 0, 0, 0, 229, 230,
        5, 11, 0, 0, 230, 15, 1, 0, 0, 0, 231, 232, 3, 22, 11, 0, 232, 233, 5, 13, 0, 0, 233, 17, 1,
        0, 0, 0, 234, 237, 5, 26, 0, 0, 235, 237, 3, 142, 71, 0, 236, 234, 1, 0, 0, 0, 236, 235, 1,
        0, 0, 0, 237, 240, 1, 0, 0, 0, 238, 239, 5, 98, 0, 0, 239, 241, 3, 142, 71, 0, 240, 238, 1,
        0, 0, 0, 240, 241, 1, 0, 0, 0, 241, 19, 1, 0, 0, 0, 242, 243, 5, 99, 0, 0, 243, 244, 5, 120,
        0, 0, 244, 21, 1, 0, 0, 0, 245, 248, 3, 142, 71, 0, 246, 247, 5, 98, 0, 0, 247, 249, 3, 142,
        71, 0, 248, 246, 1, 0, 0, 0, 248, 249, 1, 0, 0, 0, 249, 23, 1, 0, 0, 0, 250, 253, 5, 105, 0,
        0, 251, 254, 3, 26, 13, 0, 252, 254, 3, 28, 14, 0, 253, 251, 1, 0, 0, 0, 253, 252, 1, 0, 0,
        0, 254, 255, 1, 0, 0, 0, 255, 256, 3, 152, 76, 0, 256, 263, 1, 0, 0, 0, 257, 258, 5, 105, 0,
        0, 258, 259, 5, 92, 0, 0, 259, 260, 3, 114, 57, 0, 260, 261, 3, 152, 76, 0, 261, 263, 1, 0,
        0, 0, 262, 250, 1, 0, 0, 0, 262, 257, 1, 0, 0, 0, 263, 25, 1, 0, 0, 0, 264, 265, 3, 18, 9,
        0, 265, 266, 3, 20, 10, 0, 266, 267, 3, 152, 76, 0, 267, 275, 1, 0, 0, 0, 268, 270, 3, 14,
        7, 0, 269, 271, 3, 20, 10, 0, 270, 269, 1, 0, 0, 0, 270, 271, 1, 0, 0, 0, 271, 272, 1, 0, 0,
        0, 272, 273, 3, 152, 76, 0, 273, 275, 1, 0, 0, 0, 274, 264, 1, 0, 0, 0, 274, 268, 1, 0, 0,
        0, 275, 27, 1, 0, 0, 0, 276, 280, 3, 30, 15, 0, 277, 280, 3, 80, 40, 0, 278, 280, 3, 78, 39,
        0, 279, 276, 1, 0, 0, 0, 279, 277, 1, 0, 0, 0, 279, 278, 1, 0, 0, 0, 280, 29, 1, 0, 0, 0,
        281, 282, 3, 32, 16, 0, 282, 283, 3, 152, 76, 0, 283, 31, 1, 0, 0, 0, 284, 285, 3, 44, 22,
        0, 285, 290, 3, 34, 17, 0, 286, 287, 5, 13, 0, 0, 287, 289, 3, 34, 17, 0, 288, 286, 1, 0, 0,
        0, 289, 292, 1, 0, 0, 0, 290, 288, 1, 0, 0, 0, 290, 291, 1, 0, 0, 0, 291, 33, 1, 0, 0, 0,
        292, 290, 1, 0, 0, 0, 293, 296, 3, 116, 58, 0, 294, 295, 5, 14, 0, 0, 295, 297, 3, 114, 57,
        0, 296, 294, 1, 0, 0, 0, 296, 297, 1, 0, 0, 0, 297, 35, 1, 0, 0, 0, 298, 299, 5, 12, 0, 0,
        299, 37, 1, 0, 0, 0, 300, 301, 4, 19, 0, 0, 301, 302, 3, 112, 56, 0, 302, 303, 3, 152, 76,
        0, 303, 39, 1, 0, 0, 0, 304, 305, 5, 93, 0, 0, 305, 306, 5, 7, 0, 0, 306, 307, 3, 112, 56,
        0, 307, 308, 5, 8, 0, 0, 308, 311, 3, 4, 2, 0, 309, 310, 5, 77, 0, 0, 310, 312, 3, 4, 2, 0,
        311, 309, 1, 0, 0, 0, 311, 312, 1, 0, 0, 0, 312, 41, 1, 0, 0, 0, 313, 314, 5, 73, 0, 0, 314,
        315, 3, 4, 2, 0, 315, 316, 5, 87, 0, 0, 316, 317, 5, 7, 0, 0, 317, 318, 3, 112, 56, 0, 318,
        319, 5, 8, 0, 0, 319, 320, 3, 152, 76, 0, 320, 370, 1, 0, 0, 0, 321, 322, 5, 87, 0, 0, 322,
        323, 5, 7, 0, 0, 323, 324, 3, 112, 56, 0, 324, 325, 5, 8, 0, 0, 325, 326, 3, 4, 2, 0, 326,
        370, 1, 0, 0, 0, 327, 328, 5, 85, 0, 0, 328, 331, 5, 7, 0, 0, 329, 332, 3, 112, 56, 0, 330,
        332, 3, 32, 16, 0, 331, 329, 1, 0, 0, 0, 331, 330, 1, 0, 0, 0, 331, 332, 1, 0, 0, 0, 332,
        333, 1, 0, 0, 0, 333, 335, 5, 12, 0, 0, 334, 336, 3, 112, 56, 0, 335, 334, 1, 0, 0, 0, 335,
        336, 1, 0, 0, 0, 336, 337, 1, 0, 0, 0, 337, 339, 5, 12, 0, 0, 338, 340, 3, 112, 56, 0, 339,
        338, 1, 0, 0, 0, 339, 340, 1, 0, 0, 0, 340, 341, 1, 0, 0, 0, 341, 342, 5, 8, 0, 0, 342, 370,
        3, 4, 2, 0, 343, 344, 5, 85, 0, 0, 344, 347, 5, 7, 0, 0, 345, 348, 3, 114, 57, 0, 346, 348,
        3, 32, 16, 0, 347, 345, 1, 0, 0, 0, 347, 346, 1, 0, 0, 0, 348, 349, 1, 0, 0, 0, 349, 350, 5,
        96, 0, 0, 350, 351, 3, 112, 56, 0, 351, 352, 5, 8, 0, 0, 352, 353, 3, 4, 2, 0, 353, 370, 1,
        0, 0, 0, 354, 356, 5, 85, 0, 0, 355, 357, 5, 108, 0, 0, 356, 355, 1, 0, 0, 0, 356, 357, 1,
        0, 0, 0, 357, 358, 1, 0, 0, 0, 358, 361, 5, 7, 0, 0, 359, 362, 3, 114, 57, 0, 360, 362, 3,
        32, 16, 0, 361, 359, 1, 0, 0, 0, 361, 360, 1, 0, 0, 0, 362, 363, 1, 0, 0, 0, 363, 364, 3,
        144, 72, 0, 364, 365, 4, 21, 1, 0, 365, 366, 3, 112, 56, 0, 366, 367, 5, 8, 0, 0, 367, 368,
        3, 4, 2, 0, 368, 370, 1, 0, 0, 0, 369, 313, 1, 0, 0, 0, 369, 321, 1, 0, 0, 0, 369, 327, 1,
        0, 0, 0, 369, 343, 1, 0, 0, 0, 369, 354, 1, 0, 0, 0, 370, 43, 1, 0, 0, 0, 371, 375, 5, 79,
        0, 0, 372, 375, 3, 150, 75, 0, 373, 375, 5, 104, 0, 0, 374, 371, 1, 0, 0, 0, 374, 372, 1, 0,
        0, 0, 374, 373, 1, 0, 0, 0, 375, 45, 1, 0, 0, 0, 376, 379, 5, 84, 0, 0, 377, 378, 4, 23, 2,
        0, 378, 380, 3, 144, 72, 0, 379, 377, 1, 0, 0, 0, 379, 380, 1, 0, 0, 0, 380, 381, 1, 0, 0,
        0, 381, 382, 3, 152, 76, 0, 382, 47, 1, 0, 0, 0, 383, 386, 5, 72, 0, 0, 384, 385, 4, 24, 3,
        0, 385, 387, 3, 144, 72, 0, 386, 384, 1, 0, 0, 0, 386, 387, 1, 0, 0, 0, 387, 388, 1, 0, 0,
        0, 388, 389, 3, 152, 76, 0, 389, 49, 1, 0, 0, 0, 390, 393, 5, 82, 0, 0, 391, 392, 4, 25, 4,
        0, 392, 394, 3, 112, 56, 0, 393, 391, 1, 0, 0, 0, 393, 394, 1, 0, 0, 0, 394, 395, 1, 0, 0,
        0, 395, 396, 3, 152, 76, 0, 396, 51, 1, 0, 0, 0, 397, 400, 5, 109, 0, 0, 398, 399, 4, 26, 5,
        0, 399, 401, 3, 112, 56, 0, 400, 398, 1, 0, 0, 0, 400, 401, 1, 0, 0, 0, 401, 402, 1, 0, 0,
        0, 402, 403, 3, 152, 76, 0, 403, 53, 1, 0, 0, 0, 404, 405, 5, 91, 0, 0, 405, 406, 5, 7, 0,
        0, 406, 407, 3, 112, 56, 0, 407, 408, 5, 8, 0, 0, 408, 409, 3, 4, 2, 0, 409, 55, 1, 0, 0, 0,
        410, 411, 5, 86, 0, 0, 411, 412, 5, 7, 0, 0, 412, 413, 3, 112, 56, 0, 413, 414, 5, 8, 0, 0,
        414, 415, 3, 58, 29, 0, 415, 57, 1, 0, 0, 0, 416, 418, 5, 9, 0, 0, 417, 419, 3, 60, 30, 0,
        418, 417, 1, 0, 0, 0, 418, 419, 1, 0, 0, 0, 419, 424, 1, 0, 0, 0, 420, 422, 3, 64, 32, 0,
        421, 423, 3, 60, 30, 0, 422, 421, 1, 0, 0, 0, 422, 423, 1, 0, 0, 0, 423, 425, 1, 0, 0, 0,
        424, 420, 1, 0, 0, 0, 424, 425, 1, 0, 0, 0, 425, 426, 1, 0, 0, 0, 426, 427, 5, 11, 0, 0,
        427, 59, 1, 0, 0, 0, 428, 430, 3, 62, 31, 0, 429, 428, 1, 0, 0, 0, 430, 431, 1, 0, 0, 0,
        431, 429, 1, 0, 0, 0, 431, 432, 1, 0, 0, 0, 432, 61, 1, 0, 0, 0, 433, 434, 5, 76, 0, 0, 434,
        435, 3, 112, 56, 0, 435, 437, 5, 17, 0, 0, 436, 438, 3, 8, 4, 0, 437, 436, 1, 0, 0, 0, 437,
        438, 1, 0, 0, 0, 438, 63, 1, 0, 0, 0, 439, 440, 5, 92, 0, 0, 440, 442, 5, 17, 0, 0, 441,
        443, 3, 8, 4, 0, 442, 441, 1, 0, 0, 0, 442, 443, 1, 0, 0, 0, 443, 65, 1, 0, 0, 0, 444, 445,
        3, 144, 72, 0, 445, 446, 5, 17, 0, 0, 446, 447, 3, 4, 2, 0, 447, 67, 1, 0, 0, 0, 448, 449,
        5, 94, 0, 0, 449, 450, 4, 34, 6, 0, 450, 451, 3, 112, 56, 0, 451, 452, 3, 152, 76, 0, 452,
        69, 1, 0, 0, 0, 453, 454, 5, 97, 0, 0, 454, 460, 3, 6, 3, 0, 455, 457, 3, 72, 36, 0, 456,
        458, 3, 74, 37, 0, 457, 456, 1, 0, 0, 0, 457, 458, 1, 0, 0, 0, 458, 461, 1, 0, 0, 0, 459,
        461, 3, 74, 37, 0, 460, 455, 1, 0, 0, 0, 460, 459, 1, 0, 0, 0, 461, 71, 1, 0, 0, 0, 462,
        468, 5, 80, 0, 0, 463, 465, 5, 7, 0, 0, 464, 466, 3, 116, 58, 0, 465, 464, 1, 0, 0, 0, 465,
        466, 1, 0, 0, 0, 466, 467, 1, 0, 0, 0, 467, 469, 5, 8, 0, 0, 468, 463, 1, 0, 0, 0, 468, 469,
        1, 0, 0, 0, 469, 470, 1, 0, 0, 0, 470, 471, 3, 6, 3, 0, 471, 73, 1, 0, 0, 0, 472, 473, 5,
        81, 0, 0, 473, 474, 3, 6, 3, 0, 474, 75, 1, 0, 0, 0, 475, 476, 5, 88, 0, 0, 476, 477, 3,
        152, 76, 0, 477, 77, 1, 0, 0, 0, 478, 480, 5, 107, 0, 0, 479, 478, 1, 0, 0, 0, 479, 480, 1,
        0, 0, 0, 480, 481, 1, 0, 0, 0, 481, 483, 5, 89, 0, 0, 482, 484, 5, 26, 0, 0, 483, 482, 1, 0,
        0, 0, 483, 484, 1, 0, 0, 0, 484, 485, 1, 0, 0, 0, 485, 486, 3, 144, 72, 0, 486, 488, 5, 7,
        0, 0, 487, 489, 3, 88, 44, 0, 488, 487, 1, 0, 0, 0, 488, 489, 1, 0, 0, 0, 489, 490, 1, 0, 0,
        0, 490, 491, 5, 8, 0, 0, 491, 492, 3, 94, 47, 0, 492, 79, 1, 0, 0, 0, 493, 494, 5, 100, 0,
        0, 494, 495, 3, 144, 72, 0, 495, 496, 3, 82, 41, 0, 496, 81, 1, 0, 0, 0, 497, 498, 5, 102,
        0, 0, 498, 500, 3, 114, 57, 0, 499, 497, 1, 0, 0, 0, 499, 500, 1, 0, 0, 0, 500, 501, 1, 0,
        0, 0, 501, 505, 5, 9, 0, 0, 502, 504, 3, 84, 42, 0, 503, 502, 1, 0, 0, 0, 504, 507, 1, 0, 0,
        0, 505, 503, 1, 0, 0, 0, 505, 506, 1, 0, 0, 0, 506, 508, 1, 0, 0, 0, 507, 505, 1, 0, 0, 0,
        508, 509, 5, 11, 0, 0, 509, 83, 1, 0, 0, 0, 510, 515, 5, 118, 0, 0, 511, 512, 4, 42, 7, 0,
        512, 515, 3, 144, 72, 0, 513, 515, 5, 107, 0, 0, 514, 510, 1, 0, 0, 0, 514, 511, 1, 0, 0, 0,
        514, 513, 1, 0, 0, 0, 515, 518, 1, 0, 0, 0, 516, 514, 1, 0, 0, 0, 516, 517, 1, 0, 0, 0, 517,
        525, 1, 0, 0, 0, 518, 516, 1, 0, 0, 0, 519, 526, 3, 86, 43, 0, 520, 521, 3, 116, 58, 0, 521,
        522, 5, 14, 0, 0, 522, 523, 3, 118, 59, 0, 523, 524, 5, 12, 0, 0, 524, 526, 1, 0, 0, 0, 525,
        519, 1, 0, 0, 0, 525, 520, 1, 0, 0, 0, 526, 536, 1, 0, 0, 0, 527, 536, 3, 36, 18, 0, 528,
        530, 5, 31, 0, 0, 529, 528, 1, 0, 0, 0, 529, 530, 1, 0, 0, 0, 530, 531, 1, 0, 0, 0, 531,
        532, 3, 106, 53, 0, 532, 533, 5, 14, 0, 0, 533, 534, 3, 114, 57, 0, 534, 536, 1, 0, 0, 0,
        535, 516, 1, 0, 0, 0, 535, 527, 1, 0, 0, 0, 535, 529, 1, 0, 0, 0, 536, 85, 1, 0, 0, 0, 537,
        539, 5, 26, 0, 0, 538, 537, 1, 0, 0, 0, 538, 539, 1, 0, 0, 0, 539, 541, 1, 0, 0, 0, 540,
        542, 5, 31, 0, 0, 541, 540, 1, 0, 0, 0, 541, 542, 1, 0, 0, 0, 542, 543, 1, 0, 0, 0, 543,
        544, 3, 106, 53, 0, 544, 546, 5, 7, 0, 0, 545, 547, 3, 88, 44, 0, 546, 545, 1, 0, 0, 0, 546,
        547, 1, 0, 0, 0, 547, 548, 1, 0, 0, 0, 548, 549, 5, 8, 0, 0, 549, 550, 3, 94, 47, 0, 550,
        577, 1, 0, 0, 0, 551, 553, 5, 26, 0, 0, 552, 551, 1, 0, 0, 0, 552, 553, 1, 0, 0, 0, 553,
        555, 1, 0, 0, 0, 554, 556, 5, 31, 0, 0, 555, 554, 1, 0, 0, 0, 555, 556, 1, 0, 0, 0, 556,
        557, 1, 0, 0, 0, 557, 558, 3, 138, 69, 0, 558, 559, 5, 7, 0, 0, 559, 560, 5, 8, 0, 0, 560,
        561, 3, 94, 47, 0, 561, 577, 1, 0, 0, 0, 562, 564, 5, 26, 0, 0, 563, 562, 1, 0, 0, 0, 563,
        564, 1, 0, 0, 0, 564, 566, 1, 0, 0, 0, 565, 567, 5, 31, 0, 0, 566, 565, 1, 0, 0, 0, 566,
        567, 1, 0, 0, 0, 567, 568, 1, 0, 0, 0, 568, 569, 3, 140, 70, 0, 569, 571, 5, 7, 0, 0, 570,
        572, 3, 88, 44, 0, 571, 570, 1, 0, 0, 0, 571, 572, 1, 0, 0, 0, 572, 573, 1, 0, 0, 0, 573,
        574, 5, 8, 0, 0, 574, 575, 3, 94, 47, 0, 575, 577, 1, 0, 0, 0, 576, 538, 1, 0, 0, 0, 576,
        552, 1, 0, 0, 0, 576, 563, 1, 0, 0, 0, 577, 87, 1, 0, 0, 0, 578, 583, 3, 90, 45, 0, 579,
        580, 5, 13, 0, 0, 580, 582, 3, 90, 45, 0, 581, 579, 1, 0, 0, 0, 582, 585, 1, 0, 0, 0, 583,
        581, 1, 0, 0, 0, 583, 584, 1, 0, 0, 0, 584, 588, 1, 0, 0, 0, 585, 583, 1, 0, 0, 0, 586, 587,
        5, 13, 0, 0, 587, 589, 3, 92, 46, 0, 588, 586, 1, 0, 0, 0, 588, 589, 1, 0, 0, 0, 589, 592,
        1, 0, 0, 0, 590, 592, 3, 92, 46, 0, 591, 578, 1, 0, 0, 0, 591, 590, 1, 0, 0, 0, 592, 89, 1,
        0, 0, 0, 593, 596, 3, 116, 58, 0, 594, 595, 5, 14, 0, 0, 595, 597, 3, 114, 57, 0, 596, 594,
        1, 0, 0, 0, 596, 597, 1, 0, 0, 0, 597, 91, 1, 0, 0, 0, 598, 599, 5, 18, 0, 0, 599, 600, 3,
        114, 57, 0, 600, 93, 1, 0, 0, 0, 601, 603, 5, 9, 0, 0, 602, 604, 3, 96, 48, 0, 603, 602, 1,
        0, 0, 0, 603, 604, 1, 0, 0, 0, 604, 605, 1, 0, 0, 0, 605, 606, 5, 11, 0, 0, 606, 95, 1, 0,
        0, 0, 607, 609, 3, 2, 1, 0, 608, 607, 1, 0, 0, 0, 609, 610, 1, 0, 0, 0, 610, 608, 1, 0, 0,
        0, 610, 611, 1, 0, 0, 0, 611, 97, 1, 0, 0, 0, 612, 613, 5, 5, 0, 0, 613, 614, 3, 100, 50, 0,
        614, 615, 5, 6, 0, 0, 615, 99, 1, 0, 0, 0, 616, 618, 5, 13, 0, 0, 617, 616, 1, 0, 0, 0, 618,
        621, 1, 0, 0, 0, 619, 617, 1, 0, 0, 0, 619, 620, 1, 0, 0, 0, 620, 623, 1, 0, 0, 0, 621, 619,
        1, 0, 0, 0, 622, 624, 3, 102, 51, 0, 623, 622, 1, 0, 0, 0, 623, 624, 1, 0, 0, 0, 624, 633,
        1, 0, 0, 0, 625, 627, 5, 13, 0, 0, 626, 625, 1, 0, 0, 0, 627, 628, 1, 0, 0, 0, 628, 626, 1,
        0, 0, 0, 628, 629, 1, 0, 0, 0, 629, 630, 1, 0, 0, 0, 630, 632, 3, 102, 51, 0, 631, 626, 1,
        0, 0, 0, 632, 635, 1, 0, 0, 0, 633, 631, 1, 0, 0, 0, 633, 634, 1, 0, 0, 0, 634, 639, 1, 0,
        0, 0, 635, 633, 1, 0, 0, 0, 636, 638, 5, 13, 0, 0, 637, 636, 1, 0, 0, 0, 638, 641, 1, 0, 0,
        0, 639, 637, 1, 0, 0, 0, 639, 640, 1, 0, 0, 0, 640, 101, 1, 0, 0, 0, 641, 639, 1, 0, 0, 0,
        642, 644, 5, 18, 0, 0, 643, 642, 1, 0, 0, 0, 643, 644, 1, 0, 0, 0, 644, 645, 1, 0, 0, 0,
        645, 646, 3, 114, 57, 0, 646, 103, 1, 0, 0, 0, 647, 648, 3, 106, 53, 0, 648, 649, 5, 17, 0,
        0, 649, 650, 3, 114, 57, 0, 650, 687, 1, 0, 0, 0, 651, 652, 5, 5, 0, 0, 652, 653, 3, 114,
        57, 0, 653, 654, 5, 6, 0, 0, 654, 655, 5, 17, 0, 0, 655, 656, 3, 114, 57, 0, 656, 687, 1, 0,
        0, 0, 657, 659, 5, 107, 0, 0, 658, 657, 1, 0, 0, 0, 658, 659, 1, 0, 0, 0, 659, 661, 1, 0, 0,
        0, 660, 662, 5, 26, 0, 0, 661, 660, 1, 0, 0, 0, 661, 662, 1, 0, 0, 0, 662, 663, 1, 0, 0, 0,
        663, 664, 3, 106, 53, 0, 664, 666, 5, 7, 0, 0, 665, 667, 3, 88, 44, 0, 666, 665, 1, 0, 0, 0,
        666, 667, 1, 0, 0, 0, 667, 668, 1, 0, 0, 0, 668, 669, 5, 8, 0, 0, 669, 670, 3, 94, 47, 0,
        670, 687, 1, 0, 0, 0, 671, 672, 3, 138, 69, 0, 672, 673, 5, 7, 0, 0, 673, 674, 5, 8, 0, 0,
        674, 675, 3, 94, 47, 0, 675, 687, 1, 0, 0, 0, 676, 677, 3, 140, 70, 0, 677, 678, 5, 7, 0, 0,
        678, 679, 3, 90, 45, 0, 679, 680, 5, 8, 0, 0, 680, 681, 3, 94, 47, 0, 681, 687, 1, 0, 0, 0,
        682, 684, 5, 18, 0, 0, 683, 682, 1, 0, 0, 0, 683, 684, 1, 0, 0, 0, 684, 685, 1, 0, 0, 0,
        685, 687, 3, 114, 57, 0, 686, 647, 1, 0, 0, 0, 686, 651, 1, 0, 0, 0, 686, 658, 1, 0, 0, 0,
        686, 671, 1, 0, 0, 0, 686, 676, 1, 0, 0, 0, 686, 683, 1, 0, 0, 0, 687, 105, 1, 0, 0, 0, 688,
        696, 3, 142, 71, 0, 689, 696, 5, 120, 0, 0, 690, 696, 3, 134, 67, 0, 691, 692, 5, 5, 0, 0,
        692, 693, 3, 114, 57, 0, 693, 694, 5, 6, 0, 0, 694, 696, 1, 0, 0, 0, 695, 688, 1, 0, 0, 0,
        695, 689, 1, 0, 0, 0, 695, 690, 1, 0, 0, 0, 695, 691, 1, 0, 0, 0, 696, 107, 1, 0, 0, 0, 697,
        709, 5, 7, 0, 0, 698, 703, 3, 110, 55, 0, 699, 700, 5, 13, 0, 0, 700, 702, 3, 110, 55, 0,
        701, 699, 1, 0, 0, 0, 702, 705, 1, 0, 0, 0, 703, 701, 1, 0, 0, 0, 703, 704, 1, 0, 0, 0, 704,
        707, 1, 0, 0, 0, 705, 703, 1, 0, 0, 0, 706, 708, 5, 13, 0, 0, 707, 706, 1, 0, 0, 0, 707,
        708, 1, 0, 0, 0, 708, 710, 1, 0, 0, 0, 709, 698, 1, 0, 0, 0, 709, 710, 1, 0, 0, 0, 710, 711,
        1, 0, 0, 0, 711, 712, 5, 8, 0, 0, 712, 109, 1, 0, 0, 0, 713, 715, 5, 18, 0, 0, 714, 713, 1,
        0, 0, 0, 714, 715, 1, 0, 0, 0, 715, 718, 1, 0, 0, 0, 716, 719, 3, 114, 57, 0, 717, 719, 3,
        144, 72, 0, 718, 716, 1, 0, 0, 0, 718, 717, 1, 0, 0, 0, 719, 111, 1, 0, 0, 0, 720, 725, 3,
        114, 57, 0, 721, 722, 5, 13, 0, 0, 722, 724, 3, 114, 57, 0, 723, 721, 1, 0, 0, 0, 724, 727,
        1, 0, 0, 0, 725, 723, 1, 0, 0, 0, 725, 726, 1, 0, 0, 0, 726, 113, 1, 0, 0, 0, 727, 725, 1,
        0, 0, 0, 728, 729, 6, 57, -1, 0, 729, 781, 3, 120, 60, 0, 730, 732, 5, 100, 0, 0, 731, 733,
        3, 144, 72, 0, 732, 731, 1, 0, 0, 0, 732, 733, 1, 0, 0, 0, 733, 734, 1, 0, 0, 0, 734, 781,
        3, 82, 41, 0, 735, 736, 5, 78, 0, 0, 736, 737, 3, 114, 57, 0, 737, 738, 3, 108, 54, 0, 738,
        781, 1, 0, 0, 0, 739, 740, 5, 78, 0, 0, 740, 781, 3, 114, 57, 42, 741, 742, 5, 78, 0, 0,
        742, 743, 5, 19, 0, 0, 743, 781, 3, 144, 72, 0, 744, 745, 5, 95, 0, 0, 745, 781, 3, 114, 57,
        37, 746, 747, 5, 83, 0, 0, 747, 781, 3, 114, 57, 36, 748, 749, 5, 75, 0, 0, 749, 781, 3,
        114, 57, 35, 750, 751, 5, 20, 0, 0, 751, 781, 3, 114, 57, 34, 752, 753, 5, 21, 0, 0, 753,
        781, 3, 114, 57, 33, 754, 755, 5, 22, 0, 0, 755, 781, 3, 114, 57, 32, 756, 757, 5, 23, 0, 0,
        757, 781, 3, 114, 57, 31, 758, 759, 5, 24, 0, 0, 759, 781, 3, 114, 57, 30, 760, 761, 5, 25,
        0, 0, 761, 781, 3, 114, 57, 29, 762, 763, 5, 108, 0, 0, 763, 781, 3, 114, 57, 28, 764, 765,
        5, 106, 0, 0, 765, 766, 5, 7, 0, 0, 766, 767, 3, 114, 57, 0, 767, 768, 5, 8, 0, 0, 768, 781,
        1, 0, 0, 0, 769, 781, 3, 52, 26, 0, 770, 781, 5, 90, 0, 0, 771, 781, 3, 144, 72, 0, 772,
        781, 5, 103, 0, 0, 773, 781, 3, 128, 64, 0, 774, 781, 3, 98, 49, 0, 775, 781, 3, 118, 59, 0,
        776, 777, 5, 7, 0, 0, 777, 778, 3, 112, 56, 0, 778, 779, 5, 8, 0, 0, 779, 781, 1, 0, 0, 0,
        780, 728, 1, 0, 0, 0, 780, 730, 1, 0, 0, 0, 780, 735, 1, 0, 0, 0, 780, 739, 1, 0, 0, 0, 780,
        741, 1, 0, 0, 0, 780, 744, 1, 0, 0, 0, 780, 746, 1, 0, 0, 0, 780, 748, 1, 0, 0, 0, 780, 750,
        1, 0, 0, 0, 780, 752, 1, 0, 0, 0, 780, 754, 1, 0, 0, 0, 780, 756, 1, 0, 0, 0, 780, 758, 1,
        0, 0, 0, 780, 760, 1, 0, 0, 0, 780, 762, 1, 0, 0, 0, 780, 764, 1, 0, 0, 0, 780, 769, 1, 0,
        0, 0, 780, 770, 1, 0, 0, 0, 780, 771, 1, 0, 0, 0, 780, 772, 1, 0, 0, 0, 780, 773, 1, 0, 0,
        0, 780, 774, 1, 0, 0, 0, 780, 775, 1, 0, 0, 0, 780, 776, 1, 0, 0, 0, 781, 869, 1, 0, 0, 0,
        782, 783, 10, 46, 0, 0, 783, 784, 5, 16, 0, 0, 784, 868, 3, 114, 57, 47, 785, 786, 10, 27,
        0, 0, 786, 787, 5, 29, 0, 0, 787, 868, 3, 114, 57, 27, 788, 789, 10, 26, 0, 0, 789, 790, 7,
        0, 0, 0, 790, 868, 3, 114, 57, 27, 791, 792, 10, 25, 0, 0, 792, 793, 7, 1, 0, 0, 793, 868,
        3, 114, 57, 26, 794, 795, 10, 24, 0, 0, 795, 796, 5, 30, 0, 0, 796, 868, 3, 114, 57, 25,
        797, 798, 10, 23, 0, 0, 798, 799, 7, 2, 0, 0, 799, 868, 3, 114, 57, 24, 800, 801, 10, 22, 0,
        0, 801, 802, 7, 3, 0, 0, 802, 868, 3, 114, 57, 23, 803, 804, 10, 21, 0, 0, 804, 805, 5, 74,
        0, 0, 805, 868, 3, 114, 57, 22, 806, 807, 10, 20, 0, 0, 807, 808, 5, 96, 0, 0, 808, 868, 3,
        114, 57, 21, 809, 810, 10, 19, 0, 0, 810, 811, 7, 4, 0, 0, 811, 868, 3, 114, 57, 20, 812,
        813, 10, 18, 0, 0, 813, 814, 5, 43, 0, 0, 814, 868, 3, 114, 57, 19, 815, 816, 10, 17, 0, 0,
        816, 817, 5, 44, 0, 0, 817, 868, 3, 114, 57, 18, 818, 819, 10, 16, 0, 0, 819, 820, 5, 45, 0,
        0, 820, 868, 3, 114, 57, 17, 821, 822, 10, 15, 0, 0, 822, 823, 5, 46, 0, 0, 823, 868, 3,
        114, 57, 16, 824, 825, 10, 14, 0, 0, 825, 826, 5, 47, 0, 0, 826, 868, 3, 114, 57, 15, 827,
        828, 10, 13, 0, 0, 828, 829, 5, 15, 0, 0, 829, 830, 3, 114, 57, 0, 830, 831, 5, 17, 0, 0,
        831, 832, 3, 114, 57, 14, 832, 868, 1, 0, 0, 0, 833, 834, 10, 12, 0, 0, 834, 835, 5, 14, 0,
        0, 835, 868, 3, 114, 57, 12, 836, 837, 10, 11, 0, 0, 837, 838, 3, 126, 63, 0, 838, 839, 3,
        114, 57, 11, 839, 868, 1, 0, 0, 0, 840, 842, 10, 45, 0, 0, 841, 843, 5, 16, 0, 0, 842, 841,
        1, 0, 0, 0, 842, 843, 1, 0, 0, 0, 843, 844, 1, 0, 0, 0, 844, 845, 5, 5, 0, 0, 845, 846, 3,
        112, 56, 0, 846, 847, 5, 6, 0, 0, 847, 868, 1, 0, 0, 0, 848, 850, 10, 44, 0, 0, 849, 851, 5,
        15, 0, 0, 850, 849, 1, 0, 0, 0, 850, 851, 1, 0, 0, 0, 851, 852, 1, 0, 0, 0, 852, 854, 5, 19,
        0, 0, 853, 855, 5, 31, 0, 0, 854, 853, 1, 0, 0, 0, 854, 855, 1, 0, 0, 0, 855, 856, 1, 0, 0,
        0, 856, 868, 3, 142, 71, 0, 857, 858, 10, 41, 0, 0, 858, 868, 3, 108, 54, 0, 859, 860, 10,
        39, 0, 0, 860, 861, 4, 57, 30, 0, 861, 868, 5, 20, 0, 0, 862, 863, 10, 38, 0, 0, 863, 864,
        4, 57, 32, 0, 864, 868, 5, 21, 0, 0, 865, 866, 10, 9, 0, 0, 866, 868, 3, 130, 65, 0, 867,
        782, 1, 0, 0, 0, 867, 785, 1, 0, 0, 0, 867, 788, 1, 0, 0, 0, 867, 791, 1, 0, 0, 0, 867, 794,
        1, 0, 0, 0, 867, 797, 1, 0, 0, 0, 867, 800, 1, 0, 0, 0, 867, 803, 1, 0, 0, 0, 867, 806, 1,
        0, 0, 0, 867, 809, 1, 0, 0, 0, 867, 812, 1, 0, 0, 0, 867, 815, 1, 0, 0, 0, 867, 818, 1, 0,
        0, 0, 867, 821, 1, 0, 0, 0, 867, 824, 1, 0, 0, 0, 867, 827, 1, 0, 0, 0, 867, 833, 1, 0, 0,
        0, 867, 836, 1, 0, 0, 0, 867, 840, 1, 0, 0, 0, 867, 848, 1, 0, 0, 0, 867, 857, 1, 0, 0, 0,
        867, 859, 1, 0, 0, 0, 867, 862, 1, 0, 0, 0, 867, 865, 1, 0, 0, 0, 868, 871, 1, 0, 0, 0, 869,
        867, 1, 0, 0, 0, 869, 870, 1, 0, 0, 0, 870, 115, 1, 0, 0, 0, 871, 869, 1, 0, 0, 0, 872, 876,
        3, 144, 72, 0, 873, 876, 3, 98, 49, 0, 874, 876, 3, 118, 59, 0, 875, 872, 1, 0, 0, 0, 875,
        873, 1, 0, 0, 0, 875, 874, 1, 0, 0, 0, 876, 117, 1, 0, 0, 0, 877, 889, 5, 9, 0, 0, 878, 883,
        3, 104, 52, 0, 879, 880, 5, 13, 0, 0, 880, 882, 3, 104, 52, 0, 881, 879, 1, 0, 0, 0, 882,
        885, 1, 0, 0, 0, 883, 881, 1, 0, 0, 0, 883, 884, 1, 0, 0, 0, 884, 887, 1, 0, 0, 0, 885, 883,
        1, 0, 0, 0, 886, 888, 5, 13, 0, 0, 887, 886, 1, 0, 0, 0, 887, 888, 1, 0, 0, 0, 888, 890, 1,
        0, 0, 0, 889, 878, 1, 0, 0, 0, 889, 890, 1, 0, 0, 0, 890, 891, 1, 0, 0, 0, 891, 892, 5, 11,
        0, 0, 892, 119, 1, 0, 0, 0, 893, 915, 3, 78, 39, 0, 894, 896, 5, 107, 0, 0, 895, 894, 1, 0,
        0, 0, 895, 896, 1, 0, 0, 0, 896, 897, 1, 0, 0, 0, 897, 899, 5, 89, 0, 0, 898, 900, 5, 26, 0,
        0, 899, 898, 1, 0, 0, 0, 899, 900, 1, 0, 0, 0, 900, 901, 1, 0, 0, 0, 901, 903, 5, 7, 0, 0,
        902, 904, 3, 88, 44, 0, 903, 902, 1, 0, 0, 0, 903, 904, 1, 0, 0, 0, 904, 905, 1, 0, 0, 0,
        905, 906, 5, 8, 0, 0, 906, 915, 3, 94, 47, 0, 907, 909, 5, 107, 0, 0, 908, 907, 1, 0, 0, 0,
        908, 909, 1, 0, 0, 0, 909, 910, 1, 0, 0, 0, 910, 911, 3, 122, 61, 0, 911, 912, 5, 60, 0, 0,
        912, 913, 3, 124, 62, 0, 913, 915, 1, 0, 0, 0, 914, 893, 1, 0, 0, 0, 914, 895, 1, 0, 0, 0,
        914, 908, 1, 0, 0, 0, 915, 121, 1, 0, 0, 0, 916, 923, 3, 144, 72, 0, 917, 919, 5, 7, 0, 0,
        918, 920, 3, 88, 44, 0, 919, 918, 1, 0, 0, 0, 919, 920, 1, 0, 0, 0, 920, 921, 1, 0, 0, 0,
        921, 923, 5, 8, 0, 0, 922, 916, 1, 0, 0, 0, 922, 917, 1, 0, 0, 0, 923, 123, 1, 0, 0, 0, 924,
        927, 3, 114, 57, 0, 925, 927, 3, 94, 47, 0, 926, 924, 1, 0, 0, 0, 926, 925, 1, 0, 0, 0, 927,
        125, 1, 0, 0, 0, 928, 929, 7, 5, 0, 0, 929, 127, 1, 0, 0, 0, 930, 938, 5, 61, 0, 0, 931,
        938, 5, 62, 0, 0, 932, 938, 5, 120, 0, 0, 933, 938, 3, 130, 65, 0, 934, 938, 5, 4, 0, 0,
        935, 938, 3, 134, 67, 0, 936, 938, 3, 136, 68, 0, 937, 930, 1, 0, 0, 0, 937, 931, 1, 0, 0,
        0, 937, 932, 1, 0, 0, 0, 937, 933, 1, 0, 0, 0, 937, 934, 1, 0, 0, 0, 937, 935, 1, 0, 0, 0,
        937, 936, 1, 0, 0, 0, 938, 129, 1, 0, 0, 0, 939, 943, 5, 121, 0, 0, 940, 942, 3, 132, 66, 0,
        941, 940, 1, 0, 0, 0, 942, 945, 1, 0, 0, 0, 943, 941, 1, 0, 0, 0, 943, 944, 1, 0, 0, 0, 944,
        946, 1, 0, 0, 0, 945, 943, 1, 0, 0, 0, 946, 947, 5, 121, 0, 0, 947, 131, 1, 0, 0, 0, 948,
        954, 5, 128, 0, 0, 949, 950, 5, 127, 0, 0, 950, 951, 3, 114, 57, 0, 951, 952, 5, 10, 0, 0,
        952, 954, 1, 0, 0, 0, 953, 948, 1, 0, 0, 0, 953, 949, 1, 0, 0, 0, 954, 133, 1, 0, 0, 0, 955,
        956, 7, 6, 0, 0, 956, 135, 1, 0, 0, 0, 957, 958, 7, 7, 0, 0, 958, 137, 1, 0, 0, 0, 959, 960,
        4, 69, 34, 0, 960, 961, 3, 144, 72, 0, 961, 962, 3, 106, 53, 0, 962, 139, 1, 0, 0, 0, 963,
        964, 4, 70, 35, 0, 964, 965, 3, 144, 72, 0, 965, 966, 3, 106, 53, 0, 966, 141, 1, 0, 0, 0,
        967, 970, 3, 144, 72, 0, 968, 970, 3, 146, 73, 0, 969, 967, 1, 0, 0, 0, 969, 968, 1, 0, 0,
        0, 970, 143, 1, 0, 0, 0, 971, 972, 7, 8, 0, 0, 972, 145, 1, 0, 0, 0, 973, 977, 3, 148, 74,
        0, 974, 977, 5, 61, 0, 0, 975, 977, 5, 62, 0, 0, 976, 973, 1, 0, 0, 0, 976, 974, 1, 0, 0, 0,
        976, 975, 1, 0, 0, 0, 977, 147, 1, 0, 0, 0, 978, 1025, 5, 72, 0, 0, 979, 1025, 5, 73, 0, 0,
        980, 1025, 5, 74, 0, 0, 981, 1025, 5, 75, 0, 0, 982, 1025, 5, 76, 0, 0, 983, 1025, 5, 77, 0,
        0, 984, 1025, 5, 78, 0, 0, 985, 1025, 5, 79, 0, 0, 986, 1025, 5, 80, 0, 0, 987, 1025, 5, 81,
        0, 0, 988, 1025, 5, 82, 0, 0, 989, 1025, 5, 83, 0, 0, 990, 1025, 5, 84, 0, 0, 991, 1025, 5,
        85, 0, 0, 992, 1025, 5, 86, 0, 0, 993, 1025, 5, 87, 0, 0, 994, 1025, 5, 88, 0, 0, 995, 1025,
        5, 89, 0, 0, 996, 1025, 5, 90, 0, 0, 997, 1025, 5, 91, 0, 0, 998, 1025, 5, 92, 0, 0, 999,
        1025, 5, 93, 0, 0, 1000, 1025, 5, 94, 0, 0, 1001, 1025, 5, 95, 0, 0, 1002, 1025, 5, 96, 0,
        0, 1003, 1025, 5, 97, 0, 0, 1004, 1025, 5, 100, 0, 0, 1005, 1025, 5, 101, 0, 0, 1006, 1025,
        5, 102, 0, 0, 1007, 1025, 5, 103, 0, 0, 1008, 1025, 5, 104, 0, 0, 1009, 1025, 5, 105, 0, 0,
        1010, 1025, 5, 106, 0, 0, 1011, 1025, 5, 110, 0, 0, 1012, 1025, 3, 150, 75, 0, 1013, 1025,
        5, 113, 0, 0, 1014, 1025, 5, 114, 0, 0, 1015, 1025, 5, 115, 0, 0, 1016, 1025, 5, 116, 0, 0,
        1017, 1025, 5, 117, 0, 0, 1018, 1025, 5, 118, 0, 0, 1019, 1025, 5, 109, 0, 0, 1020, 1025, 5,
        107, 0, 0, 1021, 1025, 5, 108, 0, 0, 1022, 1025, 5, 99, 0, 0, 1023, 1025, 5, 98, 0, 0, 1024,
        978, 1, 0, 0, 0, 1024, 979, 1, 0, 0, 0, 1024, 980, 1, 0, 0, 0, 1024, 981, 1, 0, 0, 0, 1024,
        982, 1, 0, 0, 0, 1024, 983, 1, 0, 0, 0, 1024, 984, 1, 0, 0, 0, 1024, 985, 1, 0, 0, 0, 1024,
        986, 1, 0, 0, 0, 1024, 987, 1, 0, 0, 0, 1024, 988, 1, 0, 0, 0, 1024, 989, 1, 0, 0, 0, 1024,
        990, 1, 0, 0, 0, 1024, 991, 1, 0, 0, 0, 1024, 992, 1, 0, 0, 0, 1024, 993, 1, 0, 0, 0, 1024,
        994, 1, 0, 0, 0, 1024, 995, 1, 0, 0, 0, 1024, 996, 1, 0, 0, 0, 1024, 997, 1, 0, 0, 0, 1024,
        998, 1, 0, 0, 0, 1024, 999, 1, 0, 0, 0, 1024, 1000, 1, 0, 0, 0, 1024, 1001, 1, 0, 0, 0,
        1024, 1002, 1, 0, 0, 0, 1024, 1003, 1, 0, 0, 0, 1024, 1004, 1, 0, 0, 0, 1024, 1005, 1, 0, 0,
        0, 1024, 1006, 1, 0, 0, 0, 1024, 1007, 1, 0, 0, 0, 1024, 1008, 1, 0, 0, 0, 1024, 1009, 1, 0,
        0, 0, 1024, 1010, 1, 0, 0, 0, 1024, 1011, 1, 0, 0, 0, 1024, 1012, 1, 0, 0, 0, 1024, 1013, 1,
        0, 0, 0, 1024, 1014, 1, 0, 0, 0, 1024, 1015, 1, 0, 0, 0, 1024, 1016, 1, 0, 0, 0, 1024, 1017,
        1, 0, 0, 0, 1024, 1018, 1, 0, 0, 0, 1024, 1019, 1, 0, 0, 0, 1024, 1020, 1, 0, 0, 0, 1024,
        1021, 1, 0, 0, 0, 1024, 1022, 1, 0, 0, 0, 1024, 1023, 1, 0, 0, 0, 1025, 149, 1, 0, 0, 0,
        1026, 1027, 7, 9, 0, 0, 1027, 151, 1, 0, 0, 0, 1028, 1033, 5, 12, 0, 0, 1029, 1033, 5, 0, 0,
        1, 1030, 1033, 4, 76, 36, 0, 1031, 1033, 4, 76, 37, 0, 1032, 1028, 1, 0, 0, 0, 1032, 1029,
        1, 0, 0, 0, 1032, 1030, 1, 0, 0, 0, 1032, 1031, 1, 0, 0, 0, 1033, 153, 1, 0, 0, 0, 113, 155,
        158, 184, 188, 195, 201, 205, 212, 220, 225, 227, 236, 240, 248, 253, 262, 270, 274, 279,
        290, 296, 311, 331, 335, 339, 347, 356, 361, 369, 374, 379, 386, 393, 400, 418, 422, 424,
        431, 437, 442, 457, 460, 465, 468, 479, 483, 488, 499, 505, 514, 516, 525, 529, 535, 538,
        541, 546, 552, 555, 563, 566, 571, 576, 583, 588, 591, 596, 603, 610, 619, 623, 628, 633,
        639, 643, 658, 661, 666, 683, 686, 695, 703, 707, 709, 714, 718, 725, 732, 780, 842, 850,
        854, 867, 869, 875, 883, 887, 889, 895, 899, 903, 908, 914, 919, 922, 926, 937, 943, 953,
        969, 976, 1024, 1032,
    ]
}
