// Generated from JavaScriptParser.g4 by ANTLR 4.9.3
import Antlr4

open class JavaScriptParser: JavaScriptParserBase {

	public class State {
        public let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
        
        internal var _decisionToDFA: [DFA<ParserATNConfig>]
        internal let _sharedContextCache: PredictionContextCache = PredictionContextCache()
        let atnConfigPool = ParserATNConfigPool()
        
        public init() {
            var decisionToDFA = [DFA<ParserATNConfig>]()
            let length = _ATN.getNumberOfDecisions()
            for i in 0..<length {
                decisionToDFA.append(DFA(_ATN.getDecisionState(i)!, i))
            }
            _decisionToDFA = decisionToDFA
        }
    }
    
    public var _ATN: ATN {
        return state._ATN
    }
    internal var _decisionToDFA: [DFA<ParserATNConfig>] {
        return state._decisionToDFA
    }
    internal var _sharedContextCache: PredictionContextCache {
        return state._sharedContextCache
    }
    
    public var state: State

	public
	enum Tokens: Int {
		case EOF = -1, HashBangLine = 1, MultiLineComment = 2, SingleLineComment = 3, 
                 RegularExpressionLiteral = 4, OpenBracket = 5, CloseBracket = 6, 
                 OpenParen = 7, CloseParen = 8, OpenBrace = 9, TemplateCloseBrace = 10, 
                 CloseBrace = 11, SemiColon = 12, Comma = 13, Assign = 14, 
                 QuestionMark = 15, Colon = 16, Ellipsis = 17, Dot = 18, 
                 PlusPlus = 19, MinusMinus = 20, Plus = 21, Minus = 22, 
                 BitNot = 23, Not = 24, Multiply = 25, Divide = 26, Modulus = 27, 
                 Power = 28, NullCoalesce = 29, Hashtag = 30, RightShiftArithmetic = 31, 
                 LeftShiftArithmetic = 32, RightShiftLogical = 33, LessThan = 34, 
                 MoreThan = 35, LessThanEquals = 36, GreaterThanEquals = 37, 
                 Equals_ = 38, NotEquals = 39, IdentityEquals = 40, IdentityNotEquals = 41, 
                 BitAnd = 42, BitXOr = 43, BitOr = 44, And = 45, Or = 46, 
                 MultiplyAssign = 47, DivideAssign = 48, ModulusAssign = 49, 
                 PlusAssign = 50, MinusAssign = 51, LeftShiftArithmeticAssign = 52, 
                 RightShiftArithmeticAssign = 53, RightShiftLogicalAssign = 54, 
                 BitAndAssign = 55, BitXorAssign = 56, BitOrAssign = 57, 
                 PowerAssign = 58, ARROW = 59, NullLiteral = 60, BooleanLiteral = 61, 
                 DecimalLiteral = 62, HexIntegerLiteral = 63, OctalIntegerLiteral = 64, 
                 OctalIntegerLiteral2 = 65, BinaryIntegerLiteral = 66, BigHexIntegerLiteral = 67, 
                 BigOctalIntegerLiteral = 68, BigBinaryIntegerLiteral = 69, 
                 BigDecimalIntegerLiteral = 70, Break = 71, Do = 72, Instanceof = 73, 
                 Typeof = 74, Case = 75, Else = 76, New = 77, Var = 78, 
                 Catch = 79, Finally = 80, Return = 81, Void = 82, Continue = 83, 
                 For = 84, Switch = 85, While = 86, Debugger = 87, Function_ = 88, 
                 This = 89, With = 90, Default = 91, If = 92, Throw = 93, 
                 Delete = 94, In = 95, Try = 96, As = 97, From = 98, Class = 99, 
                 Enum = 100, Extends = 101, Super = 102, Const = 103, Export = 104, 
                 Import = 105, Async = 106, Await = 107, Implements = 108, 
                 StrictLet = 109, NonStrictLet = 110, Private = 111, Public = 112, 
                 Interface = 113, Package = 114, Protected = 115, Static = 116, 
                 Yield = 117, Identifier = 118, StringLiteral = 119, BackTick = 120, 
                 WhiteSpaces = 121, LineTerminator = 122, HtmlComment = 123, 
                 CDataComment = 124, UnexpectedCharacter = 125, TemplateStringStartExpression = 126, 
                 TemplateStringAtom = 127
	}

	public
	static let RULE_program = 0, RULE_sourceElement = 1, RULE_statement = 2, 
            RULE_block = 3, RULE_statementList = 4, RULE_importStatement = 5, 
            RULE_importFromBlock = 6, RULE_moduleItems = 7, RULE_importDefault = 8, 
            RULE_importNamespace = 9, RULE_importFrom = 10, RULE_aliasName = 11, 
            RULE_exportStatement = 12, RULE_exportFromBlock = 13, RULE_declaration = 14, 
            RULE_variableStatement = 15, RULE_variableDeclarationList = 16, 
            RULE_variableDeclaration = 17, RULE_emptyStatement_ = 18, RULE_expressionStatement = 19, 
            RULE_ifStatement = 20, RULE_iterationStatement = 21, RULE_varModifier = 22, 
            RULE_continueStatement = 23, RULE_breakStatement = 24, RULE_returnStatement = 25, 
            RULE_yieldStatement = 26, RULE_withStatement = 27, RULE_switchStatement = 28, 
            RULE_caseBlock = 29, RULE_caseClauses = 30, RULE_caseClause = 31, 
            RULE_defaultClause = 32, RULE_labelledStatement = 33, RULE_throwStatement = 34, 
            RULE_tryStatement = 35, RULE_catchProduction = 36, RULE_finallyProduction = 37, 
            RULE_debuggerStatement = 38, RULE_functionDeclaration = 39, 
            RULE_classDeclaration = 40, RULE_classTail = 41, RULE_classElement = 42, 
            RULE_methodDefinition = 43, RULE_formalParameterList = 44, RULE_formalParameterArg = 45, 
            RULE_lastFormalParameterArg = 46, RULE_functionBody = 47, RULE_sourceElements = 48, 
            RULE_arrayLiteral = 49, RULE_elementList = 50, RULE_arrayElement = 51, 
            RULE_propertyAssignment = 52, RULE_propertyName = 53, RULE_arguments = 54, 
            RULE_argument = 55, RULE_expressionSequence = 56, RULE_singleExpression = 57, 
            RULE_assignable = 58, RULE_objectLiteral = 59, RULE_anonymousFunction = 60, 
            RULE_arrowFunctionParameters = 61, RULE_arrowFunctionBody = 62, 
            RULE_assignmentOperator = 63, RULE_literal = 64, RULE_templateStringLiteral = 65, 
            RULE_templateStringAtom = 66, RULE_numericLiteral = 67, RULE_bigintLiteral = 68, 
            RULE_getter = 69, RULE_setter = 70, RULE_identifierName = 71, 
            RULE_identifier = 72, RULE_reservedWord = 73, RULE_keyword = 74, 
            RULE_let_ = 75, RULE_eos = 76

	public
	static let ruleNames: [String] = [
		"program", "sourceElement", "statement", "block", "statementList", "importStatement", 
		"importFromBlock", "moduleItems", "importDefault", "importNamespace", 
		"importFrom", "aliasName", "exportStatement", "exportFromBlock", "declaration", 
		"variableStatement", "variableDeclarationList", "variableDeclaration", 
		"emptyStatement_", "expressionStatement", "ifStatement", "iterationStatement", 
		"varModifier", "continueStatement", "breakStatement", "returnStatement", 
		"yieldStatement", "withStatement", "switchStatement", "caseBlock", "caseClauses", 
		"caseClause", "defaultClause", "labelledStatement", "throwStatement", 
		"tryStatement", "catchProduction", "finallyProduction", "debuggerStatement", 
		"functionDeclaration", "classDeclaration", "classTail", "classElement", 
		"methodDefinition", "formalParameterList", "formalParameterArg", "lastFormalParameterArg", 
		"functionBody", "sourceElements", "arrayLiteral", "elementList", "arrayElement", 
		"propertyAssignment", "propertyName", "arguments", "argument", "expressionSequence", 
		"singleExpression", "assignable", "objectLiteral", "anonymousFunction", 
		"arrowFunctionParameters", "arrowFunctionBody", "assignmentOperator", 
		"literal", "templateStringLiteral", "templateStringAtom", "numericLiteral", 
		"bigintLiteral", "getter", "setter", "identifierName", "identifier", "reservedWord", 
		"keyword", "let_", "eos"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, nil, nil, nil, nil, "'['", "']'", "'('", "')'", "'{'", nil, "'}'", 
		"';'", "','", "'='", "'?'", "':'", "'...'", "'.'", "'++'", "'--'", "'+'", 
		"'-'", "'~'", "'!'", "'*'", "'/'", "'%'", "'**'", "'??'", "'#'", "'>>'", 
		"'<<'", "'>>>'", "'<'", "'>'", "'<='", "'>='", "'=='", "'!='", "'==='", 
		"'!=='", "'&'", "'^'", "'|'", "'&&'", "'||'", "'*='", "'/='", "'%='", 
		"'+='", "'-='", "'<<='", "'>>='", "'>>>='", "'&='", "'^='", "'|='", "'**='", 
		"'=>'", "'null'", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "'break'", 
		"'do'", "'instanceof'", "'typeof'", "'case'", "'else'", "'new'", "'var'", 
		"'catch'", "'finally'", "'return'", "'void'", "'continue'", "'for'", "'switch'", 
		"'while'", "'debugger'", "'function'", "'this'", "'with'", "'default'", 
		"'if'", "'throw'", "'delete'", "'in'", "'try'", "'as'", "'from'", "'class'", 
		"'enum'", "'extends'", "'super'", "'const'", "'export'", "'import'", "'async'", 
		"'await'", "'implements'", nil, nil, "'private'", "'public'", "'interface'", 
		"'package'", "'protected'", "'static'", "'yield'", nil, nil, nil, nil, 
		nil, nil, nil, nil, "'${'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, "HashBangLine", "MultiLineComment", "SingleLineComment", "RegularExpressionLiteral", 
		"OpenBracket", "CloseBracket", "OpenParen", "CloseParen", "OpenBrace", 
		"TemplateCloseBrace", "CloseBrace", "SemiColon", "Comma", "Assign", "QuestionMark", 
		"Colon", "Ellipsis", "Dot", "PlusPlus", "MinusMinus", "Plus", "Minus", 
		"BitNot", "Not", "Multiply", "Divide", "Modulus", "Power", "NullCoalesce", 
		"Hashtag", "RightShiftArithmetic", "LeftShiftArithmetic", "RightShiftLogical", 
		"LessThan", "MoreThan", "LessThanEquals", "GreaterThanEquals", "Equals_", 
		"NotEquals", "IdentityEquals", "IdentityNotEquals", "BitAnd", "BitXOr", 
		"BitOr", "And", "Or", "MultiplyAssign", "DivideAssign", "ModulusAssign", 
		"PlusAssign", "MinusAssign", "LeftShiftArithmeticAssign", "RightShiftArithmeticAssign", 
		"RightShiftLogicalAssign", "BitAndAssign", "BitXorAssign", "BitOrAssign", 
		"PowerAssign", "ARROW", "NullLiteral", "BooleanLiteral", "DecimalLiteral", 
		"HexIntegerLiteral", "OctalIntegerLiteral", "OctalIntegerLiteral2", "BinaryIntegerLiteral", 
		"BigHexIntegerLiteral", "BigOctalIntegerLiteral", "BigBinaryIntegerLiteral", 
		"BigDecimalIntegerLiteral", "Break", "Do", "Instanceof", "Typeof", "Case", 
		"Else", "New", "Var", "Catch", "Finally", "Return", "Void", "Continue", 
		"For", "Switch", "While", "Debugger", "Function_", "This", "With", "Default", 
		"If", "Throw", "Delete", "In", "Try", "As", "From", "Class", "Enum", "Extends", 
		"Super", "Const", "Export", "Import", "Async", "Await", "Implements", 
		"StrictLet", "NonStrictLet", "Private", "Public", "Interface", "Package", 
		"Protected", "Static", "Yield", "Identifier", "StringLiteral", "BackTick", 
		"WhiteSpaces", "LineTerminator", "HtmlComment", "CDataComment", "UnexpectedCharacter", 
		"TemplateStringStartExpression", "TemplateStringAtom"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	override open
	func getGrammarFileName() -> String { return "JavaScriptParser.g4" }

	override open
	func getRuleNames() -> [String] { return JavaScriptParser.ruleNames }

	override open
	func getSerializedATN() -> String { return JavaScriptParser._serializedATN }

	override open
	func getATN() -> ATN { return _ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return JavaScriptParser.VOCABULARY
	}

	override public convenience
    init(_ input: TokenStream) throws {
        try self.init(input, State())
    }
    
    public
    init(_ input: TokenStream, _ state: State) throws {
        self.state = state
	    RuntimeMetaData.checkVersion("4.9.3", RuntimeMetaData.VERSION)
		try super.init(input)
        _interp = ParserATNSimulator(self,
                                     _ATN,
                                     _decisionToDFA,
                                     _sharedContextCache,
                                     atnConfigPool: state.atnConfigPool)
	}


	public class ProgramContext: ParserRuleContext {
			open
			func EOF() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.EOF.rawValue, 0)
			}
			open
			func HashBangLine() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.HashBangLine.rawValue, 0)
			}
			open
			func sourceElements() -> SourceElementsContext? {
				return getRuleContext(SourceElementsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_program
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterProgram(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitProgram(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitProgram(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitProgram(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func program() throws -> ProgramContext {
		let _localctx: ProgramContext = ProgramContext(_ctx, getState())
		try enterRule(_localctx, 0, JavaScriptParser.RULE_program)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(155)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,0,_ctx)) {
		 	case 1:
		 		setState(154)
		 		try match(JavaScriptParser.Tokens.HashBangLine.rawValue)

		 		break
		 	default: break
		 	}
		 	setState(158)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,1,_ctx)) {
		 	case 1:
		 		setState(157)
		 		try sourceElements()

		 		break
		 	default: break
		 	}
		 	setState(160)
		 	try match(JavaScriptParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SourceElementContext: ParserRuleContext {
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_sourceElement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterSourceElement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitSourceElement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitSourceElement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitSourceElement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func sourceElement() throws -> SourceElementContext {
		let _localctx: SourceElementContext = SourceElementContext(_ctx, getState())
		try enterRule(_localctx, 2, JavaScriptParser.RULE_sourceElement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(162)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StatementContext: ParserRuleContext {
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func variableStatement() -> VariableStatementContext? {
				return getRuleContext(VariableStatementContext.self, 0)
			}
			open
			func importStatement() -> ImportStatementContext? {
				return getRuleContext(ImportStatementContext.self, 0)
			}
			open
			func exportStatement() -> ExportStatementContext? {
				return getRuleContext(ExportStatementContext.self, 0)
			}
			open
			func emptyStatement_() -> EmptyStatement_Context? {
				return getRuleContext(EmptyStatement_Context.self, 0)
			}
			open
			func classDeclaration() -> ClassDeclarationContext? {
				return getRuleContext(ClassDeclarationContext.self, 0)
			}
			open
			func expressionStatement() -> ExpressionStatementContext? {
				return getRuleContext(ExpressionStatementContext.self, 0)
			}
			open
			func ifStatement() -> IfStatementContext? {
				return getRuleContext(IfStatementContext.self, 0)
			}
			open
			func iterationStatement() -> IterationStatementContext? {
				return getRuleContext(IterationStatementContext.self, 0)
			}
			open
			func continueStatement() -> ContinueStatementContext? {
				return getRuleContext(ContinueStatementContext.self, 0)
			}
			open
			func breakStatement() -> BreakStatementContext? {
				return getRuleContext(BreakStatementContext.self, 0)
			}
			open
			func returnStatement() -> ReturnStatementContext? {
				return getRuleContext(ReturnStatementContext.self, 0)
			}
			open
			func yieldStatement() -> YieldStatementContext? {
				return getRuleContext(YieldStatementContext.self, 0)
			}
			open
			func withStatement() -> WithStatementContext? {
				return getRuleContext(WithStatementContext.self, 0)
			}
			open
			func labelledStatement() -> LabelledStatementContext? {
				return getRuleContext(LabelledStatementContext.self, 0)
			}
			open
			func switchStatement() -> SwitchStatementContext? {
				return getRuleContext(SwitchStatementContext.self, 0)
			}
			open
			func throwStatement() -> ThrowStatementContext? {
				return getRuleContext(ThrowStatementContext.self, 0)
			}
			open
			func tryStatement() -> TryStatementContext? {
				return getRuleContext(TryStatementContext.self, 0)
			}
			open
			func debuggerStatement() -> DebuggerStatementContext? {
				return getRuleContext(DebuggerStatementContext.self, 0)
			}
			open
			func functionDeclaration() -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_statement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func statement() throws -> StatementContext {
		let _localctx: StatementContext = StatementContext(_ctx, getState())
		try enterRule(_localctx, 4, JavaScriptParser.RULE_statement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(184)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,2, _ctx)) {
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
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BlockContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func statementList() -> StatementListContext? {
				return getRuleContext(StatementListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_block
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBlock(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func block() throws -> BlockContext {
		let _localctx: BlockContext = BlockContext(_ctx, getState())
		try enterRule(_localctx, 6, JavaScriptParser.RULE_block)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(186)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(188)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,3,_ctx)) {
		 	case 1:
		 		setState(187)
		 		try statementList()

		 		break
		 	default: break
		 	}
		 	setState(190)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StatementListContext: ParserRuleContext {
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_statementList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterStatementList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitStatementList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitStatementList(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitStatementList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func statementList() throws -> StatementListContext {
		let _localctx: StatementListContext = StatementListContext(_ctx, getState())
		try enterRule(_localctx, 8, JavaScriptParser.RULE_statementList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(193); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(192)
		 			try statement()


		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(195); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,4,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImportStatementContext: ParserRuleContext {
			open
			func Import() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
			}
			open
			func importFromBlock() -> ImportFromBlockContext? {
				return getRuleContext(ImportFromBlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_importStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importStatement() throws -> ImportStatementContext {
		let _localctx: ImportStatementContext = ImportStatementContext(_ctx, getState())
		try enterRule(_localctx, 10, JavaScriptParser.RULE_importStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(197)
		 	try match(JavaScriptParser.Tokens.Import.rawValue)
		 	setState(198)
		 	try importFromBlock()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImportFromBlockContext: ParserRuleContext {
			open
			func importFrom() -> ImportFromContext? {
				return getRuleContext(ImportFromContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func importNamespace() -> ImportNamespaceContext? {
				return getRuleContext(ImportNamespaceContext.self, 0)
			}
			open
			func moduleItems() -> ModuleItemsContext? {
				return getRuleContext(ModuleItemsContext.self, 0)
			}
			open
			func importDefault() -> ImportDefaultContext? {
				return getRuleContext(ImportDefaultContext.self, 0)
			}
			open
			func StringLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_importFromBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportFromBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportFromBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportFromBlock(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportFromBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importFromBlock() throws -> ImportFromBlockContext {
		let _localctx: ImportFromBlockContext = ImportFromBlockContext(_ctx, getState())
		try enterRule(_localctx, 12, JavaScriptParser.RULE_importFromBlock)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(212)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .OpenBrace:fallthrough
		 	case .Multiply:fallthrough
		 	case .NullLiteral:fallthrough
		 	case .BooleanLiteral:fallthrough
		 	case .Break:fallthrough
		 	case .Do:fallthrough
		 	case .Instanceof:fallthrough
		 	case .Typeof:fallthrough
		 	case .Case:fallthrough
		 	case .Else:fallthrough
		 	case .New:fallthrough
		 	case .Var:fallthrough
		 	case .Catch:fallthrough
		 	case .Finally:fallthrough
		 	case .Return:fallthrough
		 	case .Void:fallthrough
		 	case .Continue:fallthrough
		 	case .For:fallthrough
		 	case .Switch:fallthrough
		 	case .While:fallthrough
		 	case .Debugger:fallthrough
		 	case .Function_:fallthrough
		 	case .This:fallthrough
		 	case .With:fallthrough
		 	case .Default:fallthrough
		 	case .If:fallthrough
		 	case .Throw:fallthrough
		 	case .Delete:fallthrough
		 	case .In:fallthrough
		 	case .Try:fallthrough
		 	case .As:fallthrough
		 	case .From:fallthrough
		 	case .Class:fallthrough
		 	case .Enum:fallthrough
		 	case .Extends:fallthrough
		 	case .Super:fallthrough
		 	case .Const:fallthrough
		 	case .Export:fallthrough
		 	case .Import:fallthrough
		 	case .Async:fallthrough
		 	case .Await:fallthrough
		 	case .Implements:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Private:fallthrough
		 	case .Public:fallthrough
		 	case .Interface:fallthrough
		 	case .Package:fallthrough
		 	case .Protected:fallthrough
		 	case .Static:fallthrough
		 	case .Yield:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(201)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,5,_ctx)) {
		 		case 1:
		 			setState(200)
		 			try importDefault()

		 			break
		 		default: break
		 		}
		 		setState(205)
		 		try _errHandler.sync(self)
		 		switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .Multiply:fallthrough
		 		case .NullLiteral:fallthrough
		 		case .BooleanLiteral:fallthrough
		 		case .Break:fallthrough
		 		case .Do:fallthrough
		 		case .Instanceof:fallthrough
		 		case .Typeof:fallthrough
		 		case .Case:fallthrough
		 		case .Else:fallthrough
		 		case .New:fallthrough
		 		case .Var:fallthrough
		 		case .Catch:fallthrough
		 		case .Finally:fallthrough
		 		case .Return:fallthrough
		 		case .Void:fallthrough
		 		case .Continue:fallthrough
		 		case .For:fallthrough
		 		case .Switch:fallthrough
		 		case .While:fallthrough
		 		case .Debugger:fallthrough
		 		case .Function_:fallthrough
		 		case .This:fallthrough
		 		case .With:fallthrough
		 		case .Default:fallthrough
		 		case .If:fallthrough
		 		case .Throw:fallthrough
		 		case .Delete:fallthrough
		 		case .In:fallthrough
		 		case .Try:fallthrough
		 		case .As:fallthrough
		 		case .From:fallthrough
		 		case .Class:fallthrough
		 		case .Enum:fallthrough
		 		case .Extends:fallthrough
		 		case .Super:fallthrough
		 		case .Const:fallthrough
		 		case .Export:fallthrough
		 		case .Import:fallthrough
		 		case .Async:fallthrough
		 		case .Await:fallthrough
		 		case .Implements:fallthrough
		 		case .StrictLet:fallthrough
		 		case .NonStrictLet:fallthrough
		 		case .Private:fallthrough
		 		case .Public:fallthrough
		 		case .Interface:fallthrough
		 		case .Package:fallthrough
		 		case .Protected:fallthrough
		 		case .Static:fallthrough
		 		case .Yield:fallthrough
		 		case .Identifier:
		 			setState(203)
		 			try importNamespace()

		 			break

		 		case .OpenBrace:
		 			setState(204)
		 			try moduleItems()

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
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
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ModuleItemsContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func aliasName() -> [AliasNameContext] {
				return getRuleContexts(AliasNameContext.self)
			}
			open
			func aliasName(_ i: Int) -> AliasNameContext? {
				return getRuleContext(AliasNameContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_moduleItems
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterModuleItems(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitModuleItems(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitModuleItems(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitModuleItems(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func moduleItems() throws -> ModuleItemsContext {
		let _localctx: ModuleItemsContext = ModuleItemsContext(_ctx, getState())
		try enterRule(_localctx, 14, JavaScriptParser.RULE_moduleItems)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(214)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(220)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(215)
		 			try aliasName()
		 			setState(216)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)

		 	 
		 		}
		 		setState(222)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,8,_ctx)
		 	}
		 	setState(227)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.NullLiteral.rawValue,JavaScriptParser.Tokens.BooleanLiteral.rawValue,JavaScriptParser.Tokens.Break.rawValue,JavaScriptParser.Tokens.Do.rawValue,JavaScriptParser.Tokens.Instanceof.rawValue,JavaScriptParser.Tokens.Typeof.rawValue,JavaScriptParser.Tokens.Case.rawValue,JavaScriptParser.Tokens.Else.rawValue,JavaScriptParser.Tokens.New.rawValue,JavaScriptParser.Tokens.Var.rawValue,JavaScriptParser.Tokens.Catch.rawValue,JavaScriptParser.Tokens.Finally.rawValue,JavaScriptParser.Tokens.Return.rawValue,JavaScriptParser.Tokens.Void.rawValue,JavaScriptParser.Tokens.Continue.rawValue,JavaScriptParser.Tokens.For.rawValue,JavaScriptParser.Tokens.Switch.rawValue,JavaScriptParser.Tokens.While.rawValue,JavaScriptParser.Tokens.Debugger.rawValue,JavaScriptParser.Tokens.Function_.rawValue,JavaScriptParser.Tokens.This.rawValue,JavaScriptParser.Tokens.With.rawValue,JavaScriptParser.Tokens.Default.rawValue,JavaScriptParser.Tokens.If.rawValue,JavaScriptParser.Tokens.Throw.rawValue,JavaScriptParser.Tokens.Delete.rawValue,JavaScriptParser.Tokens.In.rawValue,JavaScriptParser.Tokens.Try.rawValue,JavaScriptParser.Tokens.As.rawValue,JavaScriptParser.Tokens.From.rawValue,JavaScriptParser.Tokens.Class.rawValue,JavaScriptParser.Tokens.Enum.rawValue,JavaScriptParser.Tokens.Extends.rawValue,JavaScriptParser.Tokens.Super.rawValue,JavaScriptParser.Tokens.Const.rawValue,JavaScriptParser.Tokens.Export.rawValue,JavaScriptParser.Tokens.Import.rawValue,JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.Await.rawValue,JavaScriptParser.Tokens.Implements.rawValue,JavaScriptParser.Tokens.StrictLet.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Private.rawValue,JavaScriptParser.Tokens.Public.rawValue,JavaScriptParser.Tokens.Interface.rawValue,JavaScriptParser.Tokens.Package.rawValue,JavaScriptParser.Tokens.Protected.rawValue,JavaScriptParser.Tokens.Static.rawValue,JavaScriptParser.Tokens.Yield.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 60)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(223)
		 		try aliasName()
		 		setState(225)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(224)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)

		 		}


		 	}

		 	setState(229)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImportDefaultContext: ParserRuleContext {
			open
			func aliasName() -> AliasNameContext? {
				return getRuleContext(AliasNameContext.self, 0)
			}
			open
			func Comma() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_importDefault
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportDefault(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportDefault(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportDefault(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportDefault(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importDefault() throws -> ImportDefaultContext {
		let _localctx: ImportDefaultContext = ImportDefaultContext(_ctx, getState())
		try enterRule(_localctx, 16, JavaScriptParser.RULE_importDefault)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(231)
		 	try aliasName()
		 	setState(232)
		 	try match(JavaScriptParser.Tokens.Comma.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImportNamespaceContext: ParserRuleContext {
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func identifierName() -> [IdentifierNameContext] {
				return getRuleContexts(IdentifierNameContext.self)
			}
			open
			func identifierName(_ i: Int) -> IdentifierNameContext? {
				return getRuleContext(IdentifierNameContext.self, i)
			}
			open
			func As() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.As.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_importNamespace
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportNamespace(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportNamespace(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportNamespace(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportNamespace(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importNamespace() throws -> ImportNamespaceContext {
		let _localctx: ImportNamespaceContext = ImportNamespaceContext(_ctx, getState())
		try enterRule(_localctx, 18, JavaScriptParser.RULE_importNamespace)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(236)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Multiply:
		 		setState(234)
		 		try match(JavaScriptParser.Tokens.Multiply.rawValue)

		 		break
		 	case .NullLiteral:fallthrough
		 	case .BooleanLiteral:fallthrough
		 	case .Break:fallthrough
		 	case .Do:fallthrough
		 	case .Instanceof:fallthrough
		 	case .Typeof:fallthrough
		 	case .Case:fallthrough
		 	case .Else:fallthrough
		 	case .New:fallthrough
		 	case .Var:fallthrough
		 	case .Catch:fallthrough
		 	case .Finally:fallthrough
		 	case .Return:fallthrough
		 	case .Void:fallthrough
		 	case .Continue:fallthrough
		 	case .For:fallthrough
		 	case .Switch:fallthrough
		 	case .While:fallthrough
		 	case .Debugger:fallthrough
		 	case .Function_:fallthrough
		 	case .This:fallthrough
		 	case .With:fallthrough
		 	case .Default:fallthrough
		 	case .If:fallthrough
		 	case .Throw:fallthrough
		 	case .Delete:fallthrough
		 	case .In:fallthrough
		 	case .Try:fallthrough
		 	case .As:fallthrough
		 	case .From:fallthrough
		 	case .Class:fallthrough
		 	case .Enum:fallthrough
		 	case .Extends:fallthrough
		 	case .Super:fallthrough
		 	case .Const:fallthrough
		 	case .Export:fallthrough
		 	case .Import:fallthrough
		 	case .Async:fallthrough
		 	case .Await:fallthrough
		 	case .Implements:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Private:fallthrough
		 	case .Public:fallthrough
		 	case .Interface:fallthrough
		 	case .Package:fallthrough
		 	case .Protected:fallthrough
		 	case .Static:fallthrough
		 	case .Yield:fallthrough
		 	case .Identifier:
		 		setState(235)
		 		try identifierName()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		 	setState(240)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.As.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(238)
		 		try match(JavaScriptParser.Tokens.As.rawValue)
		 		setState(239)
		 		try identifierName()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImportFromContext: ParserRuleContext {
			open
			func From() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.From.rawValue, 0)
			}
			open
			func StringLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_importFrom
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportFrom(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportFrom(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportFrom(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportFrom(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importFrom() throws -> ImportFromContext {
		let _localctx: ImportFromContext = ImportFromContext(_ctx, getState())
		try enterRule(_localctx, 20, JavaScriptParser.RULE_importFrom)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(242)
		 	try match(JavaScriptParser.Tokens.From.rawValue)
		 	setState(243)
		 	try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AliasNameContext: ParserRuleContext {
			open
			func identifierName() -> [IdentifierNameContext] {
				return getRuleContexts(IdentifierNameContext.self)
			}
			open
			func identifierName(_ i: Int) -> IdentifierNameContext? {
				return getRuleContext(IdentifierNameContext.self, i)
			}
			open
			func As() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.As.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_aliasName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAliasName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAliasName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAliasName(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAliasName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func aliasName() throws -> AliasNameContext {
		let _localctx: AliasNameContext = AliasNameContext(_ctx, getState())
		try enterRule(_localctx, 22, JavaScriptParser.RULE_aliasName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(245)
		 	try identifierName()
		 	setState(248)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.As.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(246)
		 		try match(JavaScriptParser.Tokens.As.rawValue)
		 		setState(247)
		 		try identifierName()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExportStatementContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_exportStatement
		}
	}
	public class ExportDefaultDeclarationContext: ExportStatementContext {
			open
			func Export() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
			}
			open
			func Default() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}

		public
		init(_ ctx: ExportStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterExportDefaultDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitExportDefaultDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitExportDefaultDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitExportDefaultDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ExportDeclarationContext: ExportStatementContext {
			open
			func Export() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func exportFromBlock() -> ExportFromBlockContext? {
				return getRuleContext(ExportFromBlockContext.self, 0)
			}
			open
			func declaration() -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, 0)
			}

		public
		init(_ ctx: ExportStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterExportDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitExportDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitExportDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitExportDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func exportStatement() throws -> ExportStatementContext {
		var _localctx: ExportStatementContext = ExportStatementContext(_ctx, getState())
		try enterRule(_localctx, 24, JavaScriptParser.RULE_exportStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(262)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,15, _ctx)) {
		 	case 1:
		 		_localctx =  ExportDeclarationContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(250)
		 		try match(JavaScriptParser.Tokens.Export.rawValue)
		 		setState(253)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,14, _ctx)) {
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
		 		_localctx =  ExportDefaultDeclarationContext(_localctx);
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
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExportFromBlockContext: ParserRuleContext {
			open
			func importNamespace() -> ImportNamespaceContext? {
				return getRuleContext(ImportNamespaceContext.self, 0)
			}
			open
			func importFrom() -> ImportFromContext? {
				return getRuleContext(ImportFromContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func moduleItems() -> ModuleItemsContext? {
				return getRuleContext(ModuleItemsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_exportFromBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterExportFromBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitExportFromBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitExportFromBlock(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitExportFromBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func exportFromBlock() throws -> ExportFromBlockContext {
		let _localctx: ExportFromBlockContext = ExportFromBlockContext(_ctx, getState())
		try enterRule(_localctx, 26, JavaScriptParser.RULE_exportFromBlock)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(274)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Multiply:fallthrough
		 	case .NullLiteral:fallthrough
		 	case .BooleanLiteral:fallthrough
		 	case .Break:fallthrough
		 	case .Do:fallthrough
		 	case .Instanceof:fallthrough
		 	case .Typeof:fallthrough
		 	case .Case:fallthrough
		 	case .Else:fallthrough
		 	case .New:fallthrough
		 	case .Var:fallthrough
		 	case .Catch:fallthrough
		 	case .Finally:fallthrough
		 	case .Return:fallthrough
		 	case .Void:fallthrough
		 	case .Continue:fallthrough
		 	case .For:fallthrough
		 	case .Switch:fallthrough
		 	case .While:fallthrough
		 	case .Debugger:fallthrough
		 	case .Function_:fallthrough
		 	case .This:fallthrough
		 	case .With:fallthrough
		 	case .Default:fallthrough
		 	case .If:fallthrough
		 	case .Throw:fallthrough
		 	case .Delete:fallthrough
		 	case .In:fallthrough
		 	case .Try:fallthrough
		 	case .As:fallthrough
		 	case .From:fallthrough
		 	case .Class:fallthrough
		 	case .Enum:fallthrough
		 	case .Extends:fallthrough
		 	case .Super:fallthrough
		 	case .Const:fallthrough
		 	case .Export:fallthrough
		 	case .Import:fallthrough
		 	case .Async:fallthrough
		 	case .Await:fallthrough
		 	case .Implements:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Private:fallthrough
		 	case .Public:fallthrough
		 	case .Interface:fallthrough
		 	case .Package:fallthrough
		 	case .Protected:fallthrough
		 	case .Static:fallthrough
		 	case .Yield:fallthrough
		 	case .Identifier:
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
		 		switch (try getInterpreter().adaptivePredict(_input,16,_ctx)) {
		 		case 1:
		 			setState(269)
		 			try importFrom()

		 			break
		 		default: break
		 		}
		 		setState(272)
		 		try eos()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DeclarationContext: ParserRuleContext {
			open
			func variableStatement() -> VariableStatementContext? {
				return getRuleContext(VariableStatementContext.self, 0)
			}
			open
			func classDeclaration() -> ClassDeclarationContext? {
				return getRuleContext(ClassDeclarationContext.self, 0)
			}
			open
			func functionDeclaration() -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_declaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declaration() throws -> DeclarationContext {
		let _localctx: DeclarationContext = DeclarationContext(_ctx, getState())
		try enterRule(_localctx, 28, JavaScriptParser.RULE_declaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(279)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Var:fallthrough
		 	case .Const:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(276)
		 		try variableStatement()

		 		break

		 	case .Class:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(277)
		 		try classDeclaration()

		 		break
		 	case .Function_:fallthrough
		 	case .Async:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(278)
		 		try functionDeclaration()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VariableStatementContext: ParserRuleContext {
			open
			func variableDeclarationList() -> VariableDeclarationListContext? {
				return getRuleContext(VariableDeclarationListContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_variableStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterVariableStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitVariableStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitVariableStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitVariableStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func variableStatement() throws -> VariableStatementContext {
		let _localctx: VariableStatementContext = VariableStatementContext(_ctx, getState())
		try enterRule(_localctx, 30, JavaScriptParser.RULE_variableStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(281)
		 	try variableDeclarationList()
		 	setState(282)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VariableDeclarationListContext: ParserRuleContext {
			open
			func varModifier() -> VarModifierContext? {
				return getRuleContext(VarModifierContext.self, 0)
			}
			open
			func variableDeclaration() -> [VariableDeclarationContext] {
				return getRuleContexts(VariableDeclarationContext.self)
			}
			open
			func variableDeclaration(_ i: Int) -> VariableDeclarationContext? {
				return getRuleContext(VariableDeclarationContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_variableDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterVariableDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitVariableDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitVariableDeclarationList(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitVariableDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func variableDeclarationList() throws -> VariableDeclarationListContext {
		let _localctx: VariableDeclarationListContext = VariableDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 32, JavaScriptParser.RULE_variableDeclarationList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(284)
		 	try varModifier()
		 	setState(285)
		 	try variableDeclaration()
		 	setState(290)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,19,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(286)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)
		 			setState(287)
		 			try variableDeclaration()

		 	 
		 		}
		 		setState(292)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,19,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VariableDeclarationContext: ParserRuleContext {
			open
			func assignable() -> AssignableContext? {
				return getRuleContext(AssignableContext.self, 0)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_variableDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterVariableDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitVariableDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitVariableDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitVariableDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func variableDeclaration() throws -> VariableDeclarationContext {
		let _localctx: VariableDeclarationContext = VariableDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 34, JavaScriptParser.RULE_variableDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(293)
		 	try assignable()
		 	setState(296)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,20,_ctx)) {
		 	case 1:
		 		setState(294)
		 		try match(JavaScriptParser.Tokens.Assign.rawValue)
		 		setState(295)
		 		try singleExpression(0)

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EmptyStatement_Context: ParserRuleContext {
			open
			func SemiColon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_emptyStatement_
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterEmptyStatement_(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitEmptyStatement_(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitEmptyStatement_(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitEmptyStatement_(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func emptyStatement_() throws -> EmptyStatement_Context {
		let _localctx: EmptyStatement_Context = EmptyStatement_Context(_ctx, getState())
		try enterRule(_localctx, 36, JavaScriptParser.RULE_emptyStatement_)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(298)
		 	try match(JavaScriptParser.Tokens.SemiColon.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExpressionStatementContext: ParserRuleContext {
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_expressionStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterExpressionStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitExpressionStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitExpressionStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitExpressionStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func expressionStatement() throws -> ExpressionStatementContext {
		let _localctx: ExpressionStatementContext = ExpressionStatementContext(_ctx, getState())
		try enterRule(_localctx, 38, JavaScriptParser.RULE_expressionStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(300)
		 	if (!(try self.notOpenBraceAndNotFunction())) {
		 	    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notOpenBraceAndNotFunction()"))
		 	}
		 	setState(301)
		 	try expressionSequence()
		 	setState(302)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IfStatementContext: ParserRuleContext {
			open
			func If() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.If.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> [StatementContext] {
				return getRuleContexts(StatementContext.self)
			}
			open
			func statement(_ i: Int) -> StatementContext? {
				return getRuleContext(StatementContext.self, i)
			}
			open
			func Else() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Else.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_ifStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterIfStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitIfStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitIfStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitIfStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func ifStatement() throws -> IfStatementContext {
		let _localctx: IfStatementContext = IfStatementContext(_ctx, getState())
		try enterRule(_localctx, 40, JavaScriptParser.RULE_ifStatement)
		defer {
	    		try! exitRule()
	    }
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
		 	switch (try getInterpreter().adaptivePredict(_input,21,_ctx)) {
		 	case 1:
		 		setState(309)
		 		try match(JavaScriptParser.Tokens.Else.rawValue)
		 		setState(310)
		 		try statement()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IterationStatementContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_iterationStatement
		}
	}
	public class DoStatementContext: IterationStatementContext {
			open
			func Do() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Do.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func While() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}

		public
		init(_ ctx: IterationStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterDoStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitDoStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitDoStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitDoStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class WhileStatementContext: IterationStatementContext {
			open
			func While() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}

		public
		init(_ ctx: IterationStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterWhileStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitWhileStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitWhileStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitWhileStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ForStatementContext: IterationStatementContext {
			open
			func For() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func SemiColon() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.SemiColon.rawValue)
			}
			open
			func SemiColon(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, i)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func expressionSequence() -> [ExpressionSequenceContext] {
				return getRuleContexts(ExpressionSequenceContext.self)
			}
			open
			func expressionSequence(_ i: Int) -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, i)
			}
			open
			func variableDeclarationList() -> VariableDeclarationListContext? {
				return getRuleContext(VariableDeclarationListContext.self, 0)
			}

		public
		init(_ ctx: IterationStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterForStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitForStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitForStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitForStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ForInStatementContext: IterationStatementContext {
			open
			func For() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func In() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.In.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func variableDeclarationList() -> VariableDeclarationListContext? {
				return getRuleContext(VariableDeclarationListContext.self, 0)
			}

		public
		init(_ ctx: IterationStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterForInStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitForInStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitForInStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitForInStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ForOfStatementContext: IterationStatementContext {
			open
			func For() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func variableDeclarationList() -> VariableDeclarationListContext? {
				return getRuleContext(VariableDeclarationListContext.self, 0)
			}
			open
			func Await() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
			}

		public
		init(_ ctx: IterationStatementContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterForOfStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitForOfStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitForOfStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitForOfStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func iterationStatement() throws -> IterationStatementContext {
		var _localctx: IterationStatementContext = IterationStatementContext(_ctx, getState())
		try enterRule(_localctx, 42, JavaScriptParser.RULE_iterationStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(369)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,28, _ctx)) {
		 	case 1:
		 		_localctx =  DoStatementContext(_localctx);
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
		 		_localctx =  WhileStatementContext(_localctx);
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
		 		_localctx =  ForStatementContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(327)
		 		try match(JavaScriptParser.Tokens.For.rawValue)
		 		setState(328)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(331)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,22,_ctx)) {
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
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue,JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenParen.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.PlusPlus.rawValue,JavaScriptParser.Tokens.MinusMinus.rawValue,JavaScriptParser.Tokens.Plus.rawValue,JavaScriptParser.Tokens.Minus.rawValue,JavaScriptParser.Tokens.BitNot.rawValue,JavaScriptParser.Tokens.Not.rawValue,JavaScriptParser.Tokens.NullLiteral.rawValue,JavaScriptParser.Tokens.BooleanLiteral.rawValue,JavaScriptParser.Tokens.DecimalLiteral.rawValue,JavaScriptParser.Tokens.HexIntegerLiteral.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue,JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue,JavaScriptParser.Tokens.Typeof.rawValue,JavaScriptParser.Tokens.New.rawValue,JavaScriptParser.Tokens.Void.rawValue,JavaScriptParser.Tokens.Function_.rawValue,JavaScriptParser.Tokens.This.rawValue,JavaScriptParser.Tokens.Delete.rawValue,JavaScriptParser.Tokens.Class.rawValue,JavaScriptParser.Tokens.Super.rawValue,JavaScriptParser.Tokens.Import.rawValue,JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.Await.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Yield.rawValue,JavaScriptParser.Tokens.Identifier.rawValue,JavaScriptParser.Tokens.StringLiteral.rawValue,JavaScriptParser.Tokens.BackTick.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 64)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(334)
		 			try expressionSequence()

		 		}

		 		setState(337)
		 		try match(JavaScriptParser.Tokens.SemiColon.rawValue)
		 		setState(339)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue,JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenParen.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.PlusPlus.rawValue,JavaScriptParser.Tokens.MinusMinus.rawValue,JavaScriptParser.Tokens.Plus.rawValue,JavaScriptParser.Tokens.Minus.rawValue,JavaScriptParser.Tokens.BitNot.rawValue,JavaScriptParser.Tokens.Not.rawValue,JavaScriptParser.Tokens.NullLiteral.rawValue,JavaScriptParser.Tokens.BooleanLiteral.rawValue,JavaScriptParser.Tokens.DecimalLiteral.rawValue,JavaScriptParser.Tokens.HexIntegerLiteral.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue,JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue,JavaScriptParser.Tokens.Typeof.rawValue,JavaScriptParser.Tokens.New.rawValue,JavaScriptParser.Tokens.Void.rawValue,JavaScriptParser.Tokens.Function_.rawValue,JavaScriptParser.Tokens.This.rawValue,JavaScriptParser.Tokens.Delete.rawValue,JavaScriptParser.Tokens.Class.rawValue,JavaScriptParser.Tokens.Super.rawValue,JavaScriptParser.Tokens.Import.rawValue,JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.Await.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Yield.rawValue,JavaScriptParser.Tokens.Identifier.rawValue,JavaScriptParser.Tokens.StringLiteral.rawValue,JavaScriptParser.Tokens.BackTick.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 64)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(338)
		 			try expressionSequence()

		 		}

		 		setState(341)
		 		try match(JavaScriptParser.Tokens.CloseParen.rawValue)
		 		setState(342)
		 		try statement()

		 		break
		 	case 4:
		 		_localctx =  ForInStatementContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(343)
		 		try match(JavaScriptParser.Tokens.For.rawValue)
		 		setState(344)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(347)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,25, _ctx)) {
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
		 		_localctx =  ForOfStatementContext(_localctx);
		 		try enterOuterAlt(_localctx, 5)
		 		setState(354)
		 		try match(JavaScriptParser.Tokens.For.rawValue)
		 		setState(356)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Await.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(355)
		 			try match(JavaScriptParser.Tokens.Await.rawValue)

		 		}

		 		setState(358)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(361)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,27, _ctx)) {
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
		 		if (!(try self.p("of"))) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.p(\"of\")"))
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
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VarModifierContext: ParserRuleContext {
			open
			func Var() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Var.rawValue, 0)
			}
			open
			func let_() -> Let_Context? {
				return getRuleContext(Let_Context.self, 0)
			}
			open
			func Const() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Const.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_varModifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterVarModifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitVarModifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitVarModifier(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitVarModifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func varModifier() throws -> VarModifierContext {
		let _localctx: VarModifierContext = VarModifierContext(_ctx, getState())
		try enterRule(_localctx, 44, JavaScriptParser.RULE_varModifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(374)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Var:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(371)
		 		try match(JavaScriptParser.Tokens.Var.rawValue)

		 		break
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(372)
		 		try let_()

		 		break

		 	case .Const:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(373)
		 		try match(JavaScriptParser.Tokens.Const.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ContinueStatementContext: ParserRuleContext {
			open
			func Continue() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Continue.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_continueStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterContinueStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitContinueStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitContinueStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitContinueStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func continueStatement() throws -> ContinueStatementContext {
		let _localctx: ContinueStatementContext = ContinueStatementContext(_ctx, getState())
		try enterRule(_localctx, 46, JavaScriptParser.RULE_continueStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(376)
		 	try match(JavaScriptParser.Tokens.Continue.rawValue)
		 	setState(379)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,30,_ctx)) {
		 	case 1:
		 		setState(377)
		 		if (!(try self.notLineTerminator())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
		 		}
		 		setState(378)
		 		try identifier()

		 		break
		 	default: break
		 	}
		 	setState(381)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BreakStatementContext: ParserRuleContext {
			open
			func Break() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Break.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_breakStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBreakStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBreakStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBreakStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBreakStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func breakStatement() throws -> BreakStatementContext {
		let _localctx: BreakStatementContext = BreakStatementContext(_ctx, getState())
		try enterRule(_localctx, 48, JavaScriptParser.RULE_breakStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(383)
		 	try match(JavaScriptParser.Tokens.Break.rawValue)
		 	setState(386)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,31,_ctx)) {
		 	case 1:
		 		setState(384)
		 		if (!(try self.notLineTerminator())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
		 		}
		 		setState(385)
		 		try identifier()

		 		break
		 	default: break
		 	}
		 	setState(388)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReturnStatementContext: ParserRuleContext {
			open
			func Return() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Return.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_returnStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterReturnStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitReturnStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitReturnStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitReturnStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func returnStatement() throws -> ReturnStatementContext {
		let _localctx: ReturnStatementContext = ReturnStatementContext(_ctx, getState())
		try enterRule(_localctx, 50, JavaScriptParser.RULE_returnStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(390)
		 	try match(JavaScriptParser.Tokens.Return.rawValue)
		 	setState(393)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,32,_ctx)) {
		 	case 1:
		 		setState(391)
		 		if (!(try self.notLineTerminator())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
		 		}
		 		setState(392)
		 		try expressionSequence()

		 		break
		 	default: break
		 	}
		 	setState(395)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class YieldStatementContext: ParserRuleContext {
			open
			func Yield() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Yield.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_yieldStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterYieldStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitYieldStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitYieldStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitYieldStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func yieldStatement() throws -> YieldStatementContext {
		let _localctx: YieldStatementContext = YieldStatementContext(_ctx, getState())
		try enterRule(_localctx, 52, JavaScriptParser.RULE_yieldStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(397)
		 	try match(JavaScriptParser.Tokens.Yield.rawValue)
		 	setState(400)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,33,_ctx)) {
		 	case 1:
		 		setState(398)
		 		if (!(try self.notLineTerminator())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
		 		}
		 		setState(399)
		 		try expressionSequence()

		 		break
		 	default: break
		 	}
		 	setState(402)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class WithStatementContext: ParserRuleContext {
			open
			func With() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.With.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_withStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterWithStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitWithStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitWithStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitWithStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func withStatement() throws -> WithStatementContext {
		let _localctx: WithStatementContext = WithStatementContext(_ctx, getState())
		try enterRule(_localctx, 54, JavaScriptParser.RULE_withStatement)
		defer {
	    		try! exitRule()
	    }
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

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SwitchStatementContext: ParserRuleContext {
			open
			func Switch() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Switch.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func caseBlock() -> CaseBlockContext? {
				return getRuleContext(CaseBlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_switchStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterSwitchStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitSwitchStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitSwitchStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitSwitchStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func switchStatement() throws -> SwitchStatementContext {
		let _localctx: SwitchStatementContext = SwitchStatementContext(_ctx, getState())
		try enterRule(_localctx, 56, JavaScriptParser.RULE_switchStatement)
		defer {
	    		try! exitRule()
	    }
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

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CaseBlockContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func caseClauses() -> [CaseClausesContext] {
				return getRuleContexts(CaseClausesContext.self)
			}
			open
			func caseClauses(_ i: Int) -> CaseClausesContext? {
				return getRuleContext(CaseClausesContext.self, i)
			}
			open
			func defaultClause() -> DefaultClauseContext? {
				return getRuleContext(DefaultClauseContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_caseBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterCaseBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitCaseBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitCaseBlock(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitCaseBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func caseBlock() throws -> CaseBlockContext {
		let _localctx: CaseBlockContext = CaseBlockContext(_ctx, getState())
		try enterRule(_localctx, 58, JavaScriptParser.RULE_caseBlock)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(416)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(418)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Case.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(417)
		 		try caseClauses()

		 	}

		 	setState(424)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Default.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(420)
		 		try defaultClause()
		 		setState(422)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Case.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(421)
		 			try caseClauses()

		 		}


		 	}

		 	setState(426)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CaseClausesContext: ParserRuleContext {
			open
			func caseClause() -> [CaseClauseContext] {
				return getRuleContexts(CaseClauseContext.self)
			}
			open
			func caseClause(_ i: Int) -> CaseClauseContext? {
				return getRuleContext(CaseClauseContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_caseClauses
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterCaseClauses(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitCaseClauses(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitCaseClauses(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitCaseClauses(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func caseClauses() throws -> CaseClausesContext {
		let _localctx: CaseClausesContext = CaseClausesContext(_ctx, getState())
		try enterRule(_localctx, 60, JavaScriptParser.RULE_caseClauses)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(429) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(428)
		 		try caseClause()


		 		setState(431); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Case.rawValue
		 	      return testSet
		 	 }())

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CaseClauseContext: ParserRuleContext {
			open
			func Case() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Case.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}
			open
			func statementList() -> StatementListContext? {
				return getRuleContext(StatementListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_caseClause
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterCaseClause(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitCaseClause(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitCaseClause(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitCaseClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func caseClause() throws -> CaseClauseContext {
		let _localctx: CaseClauseContext = CaseClauseContext(_ctx, getState())
		try enterRule(_localctx, 62, JavaScriptParser.RULE_caseClause)
		defer {
	    		try! exitRule()
	    }
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
		 	switch (try getInterpreter().adaptivePredict(_input,38,_ctx)) {
		 	case 1:
		 		setState(436)
		 		try statementList()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DefaultClauseContext: ParserRuleContext {
			open
			func Default() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}
			open
			func statementList() -> StatementListContext? {
				return getRuleContext(StatementListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_defaultClause
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterDefaultClause(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitDefaultClause(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitDefaultClause(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitDefaultClause(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func defaultClause() throws -> DefaultClauseContext {
		let _localctx: DefaultClauseContext = DefaultClauseContext(_ctx, getState())
		try enterRule(_localctx, 64, JavaScriptParser.RULE_defaultClause)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(439)
		 	try match(JavaScriptParser.Tokens.Default.rawValue)
		 	setState(440)
		 	try match(JavaScriptParser.Tokens.Colon.rawValue)
		 	setState(442)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,39,_ctx)) {
		 	case 1:
		 		setState(441)
		 		try statementList()

		 		break
		 	default: break
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LabelledStatementContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_labelledStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLabelledStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLabelledStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLabelledStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLabelledStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func labelledStatement() throws -> LabelledStatementContext {
		let _localctx: LabelledStatementContext = LabelledStatementContext(_ctx, getState())
		try enterRule(_localctx, 66, JavaScriptParser.RULE_labelledStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(444)
		 	try identifier()
		 	setState(445)
		 	try match(JavaScriptParser.Tokens.Colon.rawValue)
		 	setState(446)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ThrowStatementContext: ParserRuleContext {
			open
			func Throw() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Throw.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_throwStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterThrowStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitThrowStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitThrowStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitThrowStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func throwStatement() throws -> ThrowStatementContext {
		let _localctx: ThrowStatementContext = ThrowStatementContext(_ctx, getState())
		try enterRule(_localctx, 68, JavaScriptParser.RULE_throwStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(448)
		 	try match(JavaScriptParser.Tokens.Throw.rawValue)
		 	setState(449)
		 	if (!(try self.notLineTerminator())) {
		 	    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
		 	}
		 	setState(450)
		 	try expressionSequence()
		 	setState(451)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TryStatementContext: ParserRuleContext {
			open
			func Try() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Try.rawValue, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func catchProduction() -> CatchProductionContext? {
				return getRuleContext(CatchProductionContext.self, 0)
			}
			open
			func finallyProduction() -> FinallyProductionContext? {
				return getRuleContext(FinallyProductionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_tryStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTryStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTryStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTryStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTryStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func tryStatement() throws -> TryStatementContext {
		let _localctx: TryStatementContext = TryStatementContext(_ctx, getState())
		try enterRule(_localctx, 70, JavaScriptParser.RULE_tryStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(453)
		 	try match(JavaScriptParser.Tokens.Try.rawValue)
		 	setState(454)
		 	try block()
		 	setState(460)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Catch:
		 		setState(455)
		 		try catchProduction()
		 		setState(457)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,40,_ctx)) {
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
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CatchProductionContext: ParserRuleContext {
			open
			func Catch() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Catch.rawValue, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func assignable() -> AssignableContext? {
				return getRuleContext(AssignableContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_catchProduction
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterCatchProduction(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitCatchProduction(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitCatchProduction(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitCatchProduction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func catchProduction() throws -> CatchProductionContext {
		let _localctx: CatchProductionContext = CatchProductionContext(_ctx, getState())
		try enterRule(_localctx, 72, JavaScriptParser.RULE_catchProduction)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(462)
		 	try match(JavaScriptParser.Tokens.Catch.rawValue)
		 	setState(468)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.OpenParen.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(463)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(465)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = _la == JavaScriptParser.Tokens.OpenBracket.rawValue || _la == JavaScriptParser.Tokens.OpenBrace.rawValue
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(464)
		 			try assignable()

		 		}

		 		setState(467)
		 		try match(JavaScriptParser.Tokens.CloseParen.rawValue)

		 	}

		 	setState(470)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FinallyProductionContext: ParserRuleContext {
			open
			func Finally() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Finally.rawValue, 0)
			}
			open
			func block() -> BlockContext? {
				return getRuleContext(BlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_finallyProduction
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFinallyProduction(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFinallyProduction(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFinallyProduction(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFinallyProduction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func finallyProduction() throws -> FinallyProductionContext {
		let _localctx: FinallyProductionContext = FinallyProductionContext(_ctx, getState())
		try enterRule(_localctx, 74, JavaScriptParser.RULE_finallyProduction)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(472)
		 	try match(JavaScriptParser.Tokens.Finally.rawValue)
		 	setState(473)
		 	try block()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DebuggerStatementContext: ParserRuleContext {
			open
			func Debugger() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Debugger.rawValue, 0)
			}
			open
			func eos() -> EosContext? {
				return getRuleContext(EosContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_debuggerStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterDebuggerStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitDebuggerStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitDebuggerStatement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitDebuggerStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func debuggerStatement() throws -> DebuggerStatementContext {
		let _localctx: DebuggerStatementContext = DebuggerStatementContext(_ctx, getState())
		try enterRule(_localctx, 76, JavaScriptParser.RULE_debuggerStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(475)
		 	try match(JavaScriptParser.Tokens.Debugger.rawValue)
		 	setState(476)
		 	try eos()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionDeclarationContext: ParserRuleContext {
			open
			func Function_() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func formalParameterList() -> FormalParameterListContext? {
				return getRuleContext(FormalParameterListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_functionDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFunctionDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFunctionDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFunctionDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFunctionDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionDeclaration() throws -> FunctionDeclarationContext {
		let _localctx: FunctionDeclarationContext = FunctionDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 78, JavaScriptParser.RULE_functionDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(479)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Async.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(478)
		 		try match(JavaScriptParser.Tokens.Async.rawValue)

		 	}

		 	setState(481)
		 	try match(JavaScriptParser.Tokens.Function_.rawValue)
		 	setState(483)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Multiply.rawValue
		 	      return testSet
		 	 }()) {
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
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 106)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(487)
		 		try formalParameterList()

		 	}

		 	setState(490)
		 	try match(JavaScriptParser.Tokens.CloseParen.rawValue)
		 	setState(491)
		 	try functionBody()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassDeclarationContext: ParserRuleContext {
			open
			func Class() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func classTail() -> ClassTailContext? {
				return getRuleContext(ClassTailContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_classDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterClassDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitClassDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitClassDeclaration(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitClassDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classDeclaration() throws -> ClassDeclarationContext {
		let _localctx: ClassDeclarationContext = ClassDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 80, JavaScriptParser.RULE_classDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(493)
		 	try match(JavaScriptParser.Tokens.Class.rawValue)
		 	setState(494)
		 	try identifier()
		 	setState(495)
		 	try classTail()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassTailContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func Extends() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Extends.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func classElement() -> [ClassElementContext] {
				return getRuleContexts(ClassElementContext.self)
			}
			open
			func classElement(_ i: Int) -> ClassElementContext? {
				return getRuleContext(ClassElementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_classTail
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterClassTail(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitClassTail(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitClassTail(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitClassTail(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classTail() throws -> ClassTailContext {
		let _localctx: ClassTailContext = ClassTailContext(_ctx, getState())
		try enterRule(_localctx, 82, JavaScriptParser.RULE_classTail)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(499)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Extends.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(497)
		 		try match(JavaScriptParser.Tokens.Extends.rawValue)
		 		setState(498)
		 		try singleExpression(0)

		 	}

		 	setState(501)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(505)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,48,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(502)
		 			try classElement()

		 	 
		 		}
		 		setState(507)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,48,_ctx)
		 	}
		 	setState(508)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassElementContext: ParserRuleContext {
			open
			func methodDefinition() -> MethodDefinitionContext? {
				return getRuleContext(MethodDefinitionContext.self, 0)
			}
			open
			func assignable() -> AssignableContext? {
				return getRuleContext(AssignableContext.self, 0)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
			}
			open
			func objectLiteral() -> ObjectLiteralContext? {
				return getRuleContext(ObjectLiteralContext.self, 0)
			}
			open
			func SemiColon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
			}
			open
			func Static() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Static.rawValue)
			}
			open
			func Static(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Static.rawValue, i)
			}
			open
			func identifier() -> [IdentifierContext] {
				return getRuleContexts(IdentifierContext.self)
			}
			open
			func identifier(_ i: Int) -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, i)
			}
			open
			func Async() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Async.rawValue)
			}
			open
			func Async(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, i)
			}
			open
			func emptyStatement_() -> EmptyStatement_Context? {
				return getRuleContext(EmptyStatement_Context.self, 0)
			}
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func Hashtag() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_classElement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterClassElement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitClassElement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitClassElement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitClassElement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classElement() throws -> ClassElementContext {
		let _localctx: ClassElementContext = ClassElementContext(_ctx, getState())
		try enterRule(_localctx, 84, JavaScriptParser.RULE_classElement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(535)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,53, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(516)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,50,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(514)
		 				try _errHandler.sync(self)
		 				switch(try getInterpreter().adaptivePredict(_input,49, _ctx)) {
		 				case 1:
		 					setState(510)
		 					try match(JavaScriptParser.Tokens.Static.rawValue)

		 					break
		 				case 2:
		 					setState(511)
		 					if (!(try self.n("static"))) {
		 					    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.n(\"static\")"))
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
		 			_alt = try getInterpreter().adaptivePredict(_input,50,_ctx)
		 		}
		 		setState(525)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,51, _ctx)) {
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
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Hashtag.rawValue
		 		      return testSet
		 		 }()) {
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
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class MethodDefinitionContext: ParserRuleContext {
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func Hashtag() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
			}
			open
			func formalParameterList() -> FormalParameterListContext? {
				return getRuleContext(FormalParameterListContext.self, 0)
			}
			open
			func getter() -> GetterContext? {
				return getRuleContext(GetterContext.self, 0)
			}
			open
			func setter() -> SetterContext? {
				return getRuleContext(SetterContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_methodDefinition
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterMethodDefinition(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitMethodDefinition(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitMethodDefinition(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitMethodDefinition(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func methodDefinition() throws -> MethodDefinitionContext {
		let _localctx: MethodDefinitionContext = MethodDefinitionContext(_ctx, getState())
		try enterRule(_localctx, 86, JavaScriptParser.RULE_methodDefinition)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(576)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,62, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(538)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Multiply.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(537)
		 			try match(JavaScriptParser.Tokens.Multiply.rawValue)

		 		}

		 		setState(541)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Hashtag.rawValue
		 		      return testSet
		 		 }()) {
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
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
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
		 		switch (try getInterpreter().adaptivePredict(_input,57,_ctx)) {
		 		case 1:
		 			setState(551)
		 			try match(JavaScriptParser.Tokens.Multiply.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(555)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,58,_ctx)) {
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
		 		switch (try getInterpreter().adaptivePredict(_input,59,_ctx)) {
		 		case 1:
		 			setState(562)
		 			try match(JavaScriptParser.Tokens.Multiply.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(566)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,60,_ctx)) {
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
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
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
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FormalParameterListContext: ParserRuleContext {
			open
			func formalParameterArg() -> [FormalParameterArgContext] {
				return getRuleContexts(FormalParameterArgContext.self)
			}
			open
			func formalParameterArg(_ i: Int) -> FormalParameterArgContext? {
				return getRuleContext(FormalParameterArgContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
			open
			func lastFormalParameterArg() -> LastFormalParameterArgContext? {
				return getRuleContext(LastFormalParameterArgContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_formalParameterList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFormalParameterList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFormalParameterList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFormalParameterList(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFormalParameterList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func formalParameterList() throws -> FormalParameterListContext {
		let _localctx: FormalParameterListContext = FormalParameterListContext(_ctx, getState())
		try enterRule(_localctx, 88, JavaScriptParser.RULE_formalParameterList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(591)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .OpenBracket:fallthrough
		 	case .OpenBrace:fallthrough
		 	case .Async:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(578)
		 		try formalParameterArg()
		 		setState(583)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,63,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(579)
		 				try match(JavaScriptParser.Tokens.Comma.rawValue)
		 				setState(580)
		 				try formalParameterArg()

		 		 
		 			}
		 			setState(585)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,63,_ctx)
		 		}
		 		setState(588)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 		      return testSet
		 		 }()) {
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
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FormalParameterArgContext: ParserRuleContext {
			open
			func assignable() -> AssignableContext? {
				return getRuleContext(AssignableContext.self, 0)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_formalParameterArg
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFormalParameterArg(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFormalParameterArg(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFormalParameterArg(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFormalParameterArg(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func formalParameterArg() throws -> FormalParameterArgContext {
		let _localctx: FormalParameterArgContext = FormalParameterArgContext(_ctx, getState())
		try enterRule(_localctx, 90, JavaScriptParser.RULE_formalParameterArg)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(593)
		 	try assignable()
		 	setState(596)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Assign.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(594)
		 		try match(JavaScriptParser.Tokens.Assign.rawValue)
		 		setState(595)
		 		try singleExpression(0)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LastFormalParameterArgContext: ParserRuleContext {
			open
			func Ellipsis() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_lastFormalParameterArg
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLastFormalParameterArg(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLastFormalParameterArg(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLastFormalParameterArg(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLastFormalParameterArg(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func lastFormalParameterArg() throws -> LastFormalParameterArgContext {
		let _localctx: LastFormalParameterArgContext = LastFormalParameterArgContext(_ctx, getState())
		try enterRule(_localctx, 92, JavaScriptParser.RULE_lastFormalParameterArg)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(598)
		 	try match(JavaScriptParser.Tokens.Ellipsis.rawValue)
		 	setState(599)
		 	try singleExpression(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionBodyContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func sourceElements() -> SourceElementsContext? {
				return getRuleContext(SourceElementsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_functionBody
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFunctionBody(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFunctionBody(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFunctionBody(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFunctionBody(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionBody() throws -> FunctionBodyContext {
		let _localctx: FunctionBodyContext = FunctionBodyContext(_ctx, getState())
		try enterRule(_localctx, 94, JavaScriptParser.RULE_functionBody)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(601)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(603)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,67,_ctx)) {
		 	case 1:
		 		setState(602)
		 		try sourceElements()

		 		break
		 	default: break
		 	}
		 	setState(605)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SourceElementsContext: ParserRuleContext {
			open
			func sourceElement() -> [SourceElementContext] {
				return getRuleContexts(SourceElementContext.self)
			}
			open
			func sourceElement(_ i: Int) -> SourceElementContext? {
				return getRuleContext(SourceElementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_sourceElements
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterSourceElements(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitSourceElements(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitSourceElements(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitSourceElements(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func sourceElements() throws -> SourceElementsContext {
		let _localctx: SourceElementsContext = SourceElementsContext(_ctx, getState())
		try enterRule(_localctx, 96, JavaScriptParser.RULE_sourceElements)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(608); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(607)
		 			try sourceElement()


		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(610); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,68,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrayLiteralContext: ParserRuleContext {
			open
			func OpenBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
			}
			open
			func elementList() -> ElementListContext? {
				return getRuleContext(ElementListContext.self, 0)
			}
			open
			func CloseBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_arrayLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrayLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrayLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrayLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrayLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrayLiteral() throws -> ArrayLiteralContext {
		let _localctx: ArrayLiteralContext = ArrayLiteralContext(_ctx, getState())
		try enterRule(_localctx, 98, JavaScriptParser.RULE_arrayLiteral)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(612)
		 	try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
		 	setState(613)
		 	try elementList()
		 	setState(614)
		 	try match(JavaScriptParser.Tokens.CloseBracket.rawValue)


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ElementListContext: ParserRuleContext {
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
			open
			func arrayElement() -> [ArrayElementContext] {
				return getRuleContexts(ArrayElementContext.self)
			}
			open
			func arrayElement(_ i: Int) -> ArrayElementContext? {
				return getRuleContext(ArrayElementContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_elementList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterElementList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitElementList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitElementList(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitElementList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func elementList() throws -> ElementListContext {
		let _localctx: ElementListContext = ElementListContext(_ctx, getState())
		try enterRule(_localctx, 100, JavaScriptParser.RULE_elementList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(619)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,69,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(616)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)

		 	 
		 		}
		 		setState(621)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,69,_ctx)
		 	}
		 	setState(623)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue,JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenParen.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue,JavaScriptParser.Tokens.PlusPlus.rawValue,JavaScriptParser.Tokens.MinusMinus.rawValue,JavaScriptParser.Tokens.Plus.rawValue,JavaScriptParser.Tokens.Minus.rawValue,JavaScriptParser.Tokens.BitNot.rawValue,JavaScriptParser.Tokens.Not.rawValue,JavaScriptParser.Tokens.NullLiteral.rawValue,JavaScriptParser.Tokens.BooleanLiteral.rawValue,JavaScriptParser.Tokens.DecimalLiteral.rawValue,JavaScriptParser.Tokens.HexIntegerLiteral.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue,JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue,JavaScriptParser.Tokens.Typeof.rawValue,JavaScriptParser.Tokens.New.rawValue,JavaScriptParser.Tokens.Void.rawValue,JavaScriptParser.Tokens.Function_.rawValue,JavaScriptParser.Tokens.This.rawValue,JavaScriptParser.Tokens.Delete.rawValue,JavaScriptParser.Tokens.Class.rawValue,JavaScriptParser.Tokens.Super.rawValue,JavaScriptParser.Tokens.Import.rawValue,JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.Await.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Yield.rawValue,JavaScriptParser.Tokens.Identifier.rawValue,JavaScriptParser.Tokens.StringLiteral.rawValue,JavaScriptParser.Tokens.BackTick.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 64)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(622)
		 		try arrayElement()

		 	}

		 	setState(633)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,72,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(626) 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			repeat {
		 				setState(625)
		 				try match(JavaScriptParser.Tokens.Comma.rawValue)


		 				setState(628); 
		 				try _errHandler.sync(self)
		 				_la = try _input.LA(1)
		 			} while (//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 			      return testSet
		 			 }())
		 			setState(630)
		 			try arrayElement()

		 	 
		 		}
		 		setState(635)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,72,_ctx)
		 	}
		 	setState(639)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(636)
		 		try match(JavaScriptParser.Tokens.Comma.rawValue)


		 		setState(641)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrayElementContext: ParserRuleContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func Ellipsis() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_arrayElement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrayElement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrayElement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrayElement(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrayElement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrayElement() throws -> ArrayElementContext {
		let _localctx: ArrayElementContext = ArrayElementContext(_ctx, getState())
		try enterRule(_localctx, 102, JavaScriptParser.RULE_arrayElement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(643)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Ellipsis.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(642)
		 		try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

		 	}

		 	setState(645)
		 	try singleExpression(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PropertyAssignmentContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_propertyAssignment
		}
	}
	public class PropertyExpressionAssignmentContext: PropertyAssignmentContext {
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPropertyExpressionAssignment(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPropertyExpressionAssignment(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPropertyExpressionAssignment(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPropertyExpressionAssignment(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ComputedPropertyExpressionAssignmentContext: PropertyAssignmentContext {
			open
			func OpenBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
			}
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func CloseBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterComputedPropertyExpressionAssignment(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitComputedPropertyExpressionAssignment(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitComputedPropertyExpressionAssignment(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitComputedPropertyExpressionAssignment(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PropertyShorthandContext: PropertyAssignmentContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func Ellipsis() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPropertyShorthand(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPropertyShorthand(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPropertyShorthand(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPropertyShorthand(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PropertySetterContext: PropertyAssignmentContext {
			open
			func setter() -> SetterContext? {
				return getRuleContext(SetterContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func formalParameterArg() -> FormalParameterArgContext? {
				return getRuleContext(FormalParameterArgContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPropertySetter(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPropertySetter(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPropertySetter(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPropertySetter(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PropertyGetterContext: PropertyAssignmentContext {
			open
			func getter() -> GetterContext? {
				return getRuleContext(GetterContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPropertyGetter(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPropertyGetter(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPropertyGetter(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPropertyGetter(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FunctionPropertyContext: PropertyAssignmentContext {
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func formalParameterList() -> FormalParameterListContext? {
				return getRuleContext(FormalParameterListContext.self, 0)
			}

		public
		init(_ ctx: PropertyAssignmentContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFunctionProperty(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFunctionProperty(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFunctionProperty(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFunctionProperty(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyAssignment() throws -> PropertyAssignmentContext {
		var _localctx: PropertyAssignmentContext = PropertyAssignmentContext(_ctx, getState())
		try enterRule(_localctx, 104, JavaScriptParser.RULE_propertyAssignment)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(686)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,79, _ctx)) {
		 	case 1:
		 		_localctx =  PropertyExpressionAssignmentContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(647)
		 		try propertyName()
		 		setState(648)
		 		try match(JavaScriptParser.Tokens.Colon.rawValue)
		 		setState(649)
		 		try singleExpression(0)

		 		break
		 	case 2:
		 		_localctx =  ComputedPropertyExpressionAssignmentContext(_localctx);
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
		 		_localctx =  FunctionPropertyContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(658)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,75,_ctx)) {
		 		case 1:
		 			setState(657)
		 			try match(JavaScriptParser.Tokens.Async.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(661)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Multiply.rawValue
		 		      return testSet
		 		 }()) {
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
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(665)
		 			try formalParameterList()

		 		}

		 		setState(668)
		 		try match(JavaScriptParser.Tokens.CloseParen.rawValue)
		 		setState(669)
		 		try functionBody()

		 		break
		 	case 4:
		 		_localctx =  PropertyGetterContext(_localctx);
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
		 		_localctx =  PropertySetterContext(_localctx);
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
		 		_localctx =  PropertyShorthandContext(_localctx);
		 		try enterOuterAlt(_localctx, 6)
		 		setState(683)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Ellipsis.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(682)
		 			try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

		 		}

		 		setState(685)
		 		try singleExpression(0)

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PropertyNameContext: ParserRuleContext {
			open
			func identifierName() -> IdentifierNameContext? {
				return getRuleContext(IdentifierNameContext.self, 0)
			}
			open
			func StringLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
			}
			open
			func numericLiteral() -> NumericLiteralContext? {
				return getRuleContext(NumericLiteralContext.self, 0)
			}
			open
			func OpenBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func CloseBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_propertyName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPropertyName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPropertyName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPropertyName(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPropertyName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyName() throws -> PropertyNameContext {
		let _localctx: PropertyNameContext = PropertyNameContext(_ctx, getState())
		try enterRule(_localctx, 106, JavaScriptParser.RULE_propertyName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(695)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NullLiteral:fallthrough
		 	case .BooleanLiteral:fallthrough
		 	case .Break:fallthrough
		 	case .Do:fallthrough
		 	case .Instanceof:fallthrough
		 	case .Typeof:fallthrough
		 	case .Case:fallthrough
		 	case .Else:fallthrough
		 	case .New:fallthrough
		 	case .Var:fallthrough
		 	case .Catch:fallthrough
		 	case .Finally:fallthrough
		 	case .Return:fallthrough
		 	case .Void:fallthrough
		 	case .Continue:fallthrough
		 	case .For:fallthrough
		 	case .Switch:fallthrough
		 	case .While:fallthrough
		 	case .Debugger:fallthrough
		 	case .Function_:fallthrough
		 	case .This:fallthrough
		 	case .With:fallthrough
		 	case .Default:fallthrough
		 	case .If:fallthrough
		 	case .Throw:fallthrough
		 	case .Delete:fallthrough
		 	case .In:fallthrough
		 	case .Try:fallthrough
		 	case .As:fallthrough
		 	case .From:fallthrough
		 	case .Class:fallthrough
		 	case .Enum:fallthrough
		 	case .Extends:fallthrough
		 	case .Super:fallthrough
		 	case .Const:fallthrough
		 	case .Export:fallthrough
		 	case .Import:fallthrough
		 	case .Async:fallthrough
		 	case .Await:fallthrough
		 	case .Implements:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Private:fallthrough
		 	case .Public:fallthrough
		 	case .Interface:fallthrough
		 	case .Package:fallthrough
		 	case .Protected:fallthrough
		 	case .Static:fallthrough
		 	case .Yield:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(688)
		 		try identifierName()

		 		break

		 	case .StringLiteral:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(689)
		 		try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

		 		break
		 	case .DecimalLiteral:fallthrough
		 	case .HexIntegerLiteral:fallthrough
		 	case .OctalIntegerLiteral:fallthrough
		 	case .OctalIntegerLiteral2:fallthrough
		 	case .BinaryIntegerLiteral:
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
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArgumentsContext: ParserRuleContext {
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func argument() -> [ArgumentContext] {
				return getRuleContexts(ArgumentContext.self)
			}
			open
			func argument(_ i: Int) -> ArgumentContext? {
				return getRuleContext(ArgumentContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_arguments
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArguments(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArguments(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArguments(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArguments(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arguments() throws -> ArgumentsContext {
		let _localctx: ArgumentsContext = ArgumentsContext(_ctx, getState())
		try enterRule(_localctx, 108, JavaScriptParser.RULE_arguments)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(697)
		 	try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 	setState(709)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue,JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenParen.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue,JavaScriptParser.Tokens.PlusPlus.rawValue,JavaScriptParser.Tokens.MinusMinus.rawValue,JavaScriptParser.Tokens.Plus.rawValue,JavaScriptParser.Tokens.Minus.rawValue,JavaScriptParser.Tokens.BitNot.rawValue,JavaScriptParser.Tokens.Not.rawValue,JavaScriptParser.Tokens.NullLiteral.rawValue,JavaScriptParser.Tokens.BooleanLiteral.rawValue,JavaScriptParser.Tokens.DecimalLiteral.rawValue,JavaScriptParser.Tokens.HexIntegerLiteral.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue,JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue,JavaScriptParser.Tokens.Typeof.rawValue,JavaScriptParser.Tokens.New.rawValue,JavaScriptParser.Tokens.Void.rawValue,JavaScriptParser.Tokens.Function_.rawValue,JavaScriptParser.Tokens.This.rawValue,JavaScriptParser.Tokens.Delete.rawValue,JavaScriptParser.Tokens.Class.rawValue,JavaScriptParser.Tokens.Super.rawValue,JavaScriptParser.Tokens.Import.rawValue,JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.Await.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Yield.rawValue,JavaScriptParser.Tokens.Identifier.rawValue,JavaScriptParser.Tokens.StringLiteral.rawValue,JavaScriptParser.Tokens.BackTick.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 64)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(698)
		 		try argument()
		 		setState(703)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,81,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(699)
		 				try match(JavaScriptParser.Tokens.Comma.rawValue)
		 				setState(700)
		 				try argument()

		 		 
		 			}
		 			setState(705)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,81,_ctx)
		 		}
		 		setState(707)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(706)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)

		 		}


		 	}

		 	setState(711)
		 	try match(JavaScriptParser.Tokens.CloseParen.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArgumentContext: ParserRuleContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func Ellipsis() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Ellipsis.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_argument
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArgument(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArgument(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArgument(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArgument(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func argument() throws -> ArgumentContext {
		let _localctx: ArgumentContext = ArgumentContext(_ctx, getState())
		try enterRule(_localctx, 110, JavaScriptParser.RULE_argument)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(714)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.Ellipsis.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(713)
		 		try match(JavaScriptParser.Tokens.Ellipsis.rawValue)

		 	}

		 	setState(718)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,85, _ctx)) {
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

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ExpressionSequenceContext: ParserRuleContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_expressionSequence
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterExpressionSequence(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitExpressionSequence(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitExpressionSequence(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitExpressionSequence(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func expressionSequence() throws -> ExpressionSequenceContext {
		let _localctx: ExpressionSequenceContext = ExpressionSequenceContext(_ctx, getState())
		try enterRule(_localctx, 112, JavaScriptParser.RULE_expressionSequence)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(720)
		 	try singleExpression(0)
		 	setState(725)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,86,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(721)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)
		 			setState(722)
		 			try singleExpression(0)

		 	 
		 		}
		 		setState(727)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,86,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	public class SingleExpressionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_singleExpression
		}
	}
	public class TemplateStringExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func templateStringLiteral() -> TemplateStringLiteralContext? {
				return getRuleContext(TemplateStringLiteralContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTemplateStringExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTemplateStringExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTemplateStringExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTemplateStringExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class TernaryExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func QuestionMark() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.QuestionMark.rawValue, 0)
			}
			open
			func Colon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Colon.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTernaryExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTernaryExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTernaryExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTernaryExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LogicalAndExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func And() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.And.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLogicalAndExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLogicalAndExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLogicalAndExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLogicalAndExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PowerExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Power() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Power.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPowerExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPowerExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPowerExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPowerExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PreIncrementExpressionContext: SingleExpressionContext {
			open
			func PlusPlus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.PlusPlus.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPreIncrementExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPreIncrementExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPreIncrementExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPreIncrementExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ObjectLiteralExpressionContext: SingleExpressionContext {
			open
			func objectLiteral() -> ObjectLiteralContext? {
				return getRuleContext(ObjectLiteralContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterObjectLiteralExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitObjectLiteralExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitObjectLiteralExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitObjectLiteralExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MetaExpressionContext: SingleExpressionContext {
			open
			func New() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
			}
			open
			func Dot() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Dot.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterMetaExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitMetaExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitMetaExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitMetaExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func In() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.In.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterInExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitInExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitInExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitInExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LogicalOrExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Or() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Or.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLogicalOrExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLogicalOrExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLogicalOrExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLogicalOrExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NotExpressionContext: SingleExpressionContext {
			open
			func Not() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Not.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterNotExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitNotExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitNotExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitNotExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PreDecreaseExpressionContext: SingleExpressionContext {
			open
			func MinusMinus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.MinusMinus.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPreDecreaseExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPreDecreaseExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPreDecreaseExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPreDecreaseExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ArgumentsExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func arguments() -> ArgumentsContext? {
				return getRuleContext(ArgumentsContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArgumentsExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArgumentsExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArgumentsExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArgumentsExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AwaitExpressionContext: SingleExpressionContext {
			open
			func Await() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAwaitExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAwaitExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAwaitExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAwaitExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ThisExpressionContext: SingleExpressionContext {
			open
			func This() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.This.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterThisExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitThisExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitThisExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitThisExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FunctionExpressionContext: SingleExpressionContext {
			open
			func anonymousFunction() -> AnonymousFunctionContext? {
				return getRuleContext(AnonymousFunctionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFunctionExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFunctionExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFunctionExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFunctionExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class UnaryMinusExpressionContext: SingleExpressionContext {
			open
			func Minus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Minus.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterUnaryMinusExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitUnaryMinusExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitUnaryMinusExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitUnaryMinusExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AssignmentExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Assign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Assign.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAssignmentExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAssignmentExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAssignmentExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAssignmentExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PostDecreaseExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func MinusMinus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.MinusMinus.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPostDecreaseExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPostDecreaseExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPostDecreaseExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPostDecreaseExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class TypeofExpressionContext: SingleExpressionContext {
			open
			func Typeof() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Typeof.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTypeofExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTypeofExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTypeofExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTypeofExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class InstanceofExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Instanceof() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Instanceof.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterInstanceofExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitInstanceofExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitInstanceofExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitInstanceofExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class UnaryPlusExpressionContext: SingleExpressionContext {
			open
			func Plus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Plus.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterUnaryPlusExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitUnaryPlusExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitUnaryPlusExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitUnaryPlusExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class DeleteExpressionContext: SingleExpressionContext {
			open
			func Delete() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Delete.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterDeleteExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitDeleteExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitDeleteExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitDeleteExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ImportExpressionContext: SingleExpressionContext {
			open
			func Import() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterImportExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitImportExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitImportExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitImportExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class EqualityExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Equals_() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Equals_.rawValue, 0)
			}
			open
			func NotEquals() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NotEquals.rawValue, 0)
			}
			open
			func IdentityEquals() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.IdentityEquals.rawValue, 0)
			}
			open
			func IdentityNotEquals() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.IdentityNotEquals.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterEqualityExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitEqualityExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitEqualityExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitEqualityExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BitXOrExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func BitXOr() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitXOr.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBitXOrExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBitXOrExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBitXOrExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBitXOrExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class SuperExpressionContext: SingleExpressionContext {
			open
			func Super() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Super.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterSuperExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitSuperExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitSuperExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitSuperExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MultiplicativeExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func Divide() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Divide.rawValue, 0)
			}
			open
			func Modulus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Modulus.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterMultiplicativeExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitMultiplicativeExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitMultiplicativeExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitMultiplicativeExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BitShiftExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func LeftShiftArithmetic() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.LeftShiftArithmetic.rawValue, 0)
			}
			open
			func RightShiftArithmetic() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.RightShiftArithmetic.rawValue, 0)
			}
			open
			func RightShiftLogical() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.RightShiftLogical.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBitShiftExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBitShiftExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBitShiftExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBitShiftExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ParenthesizedExpressionContext: SingleExpressionContext {
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterParenthesizedExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitParenthesizedExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitParenthesizedExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitParenthesizedExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AdditiveExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func Plus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Plus.rawValue, 0)
			}
			open
			func Minus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Minus.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAdditiveExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAdditiveExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAdditiveExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAdditiveExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class RelationalExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func LessThan() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.LessThan.rawValue, 0)
			}
			open
			func MoreThan() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.MoreThan.rawValue, 0)
			}
			open
			func LessThanEquals() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.LessThanEquals.rawValue, 0)
			}
			open
			func GreaterThanEquals() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.GreaterThanEquals.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterRelationalExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitRelationalExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitRelationalExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitRelationalExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class PostIncrementExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func PlusPlus() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.PlusPlus.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterPostIncrementExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitPostIncrementExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitPostIncrementExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitPostIncrementExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class YieldExpressionContext: SingleExpressionContext {
			open
			func yieldStatement() -> YieldStatementContext? {
				return getRuleContext(YieldStatementContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterYieldExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitYieldExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitYieldExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitYieldExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BitNotExpressionContext: SingleExpressionContext {
			open
			func BitNot() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitNot.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBitNotExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBitNotExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBitNotExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBitNotExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class NewExpressionContext: SingleExpressionContext {
			open
			func New() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func arguments() -> ArgumentsContext? {
				return getRuleContext(ArgumentsContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterNewExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitNewExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitNewExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitNewExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class LiteralExpressionContext: SingleExpressionContext {
			open
			func literal() -> LiteralContext? {
				return getRuleContext(LiteralContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLiteralExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLiteralExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLiteralExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLiteralExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ArrayLiteralExpressionContext: SingleExpressionContext {
			open
			func arrayLiteral() -> ArrayLiteralContext? {
				return getRuleContext(ArrayLiteralContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrayLiteralExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrayLiteralExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrayLiteralExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrayLiteralExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MemberDotExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func Dot() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Dot.rawValue, 0)
			}
			open
			func identifierName() -> IdentifierNameContext? {
				return getRuleContext(IdentifierNameContext.self, 0)
			}
			open
			func QuestionMark() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.QuestionMark.rawValue, 0)
			}
			open
			func Hashtag() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Hashtag.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterMemberDotExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitMemberDotExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitMemberDotExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitMemberDotExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ClassExpressionContext: SingleExpressionContext {
			open
			func Class() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
			}
			open
			func classTail() -> ClassTailContext? {
				return getRuleContext(ClassTailContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterClassExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitClassExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitClassExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitClassExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class MemberIndexExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func OpenBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBracket.rawValue, 0)
			}
			open
			func expressionSequence() -> ExpressionSequenceContext? {
				return getRuleContext(ExpressionSequenceContext.self, 0)
			}
			open
			func CloseBracket() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBracket.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterMemberIndexExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitMemberIndexExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitMemberIndexExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitMemberIndexExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class IdentifierExpressionContext: SingleExpressionContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterIdentifierExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitIdentifierExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitIdentifierExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitIdentifierExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BitAndExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func BitAnd() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitAnd.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBitAndExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBitAndExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBitAndExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBitAndExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class BitOrExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func BitOr() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitOr.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBitOrExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBitOrExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBitOrExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBitOrExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class AssignmentOperatorExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func assignmentOperator() -> AssignmentOperatorContext? {
				return getRuleContext(AssignmentOperatorContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAssignmentOperatorExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAssignmentOperatorExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAssignmentOperatorExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAssignmentOperatorExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class VoidExpressionContext: SingleExpressionContext {
			open
			func Void() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Void.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterVoidExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitVoidExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitVoidExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitVoidExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class CoalesceExpressionContext: SingleExpressionContext {
			open
			func singleExpression() -> [SingleExpressionContext] {
				return getRuleContexts(SingleExpressionContext.self)
			}
			open
			func singleExpression(_ i: Int) -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, i)
			}
			open
			func NullCoalesce() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NullCoalesce.rawValue, 0)
			}

		public
		init(_ ctx: SingleExpressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterCoalesceExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitCoalesceExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitCoalesceExpression(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitCoalesceExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func singleExpression( ) throws -> SingleExpressionContext   {
		return try singleExpression(0)
	}
	@discardableResult
	private func singleExpression(_ _p: Int) throws -> SingleExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: SingleExpressionContext = SingleExpressionContext(_ctx, _parentState)
		let _startState: Int = 114
		try enterRecursionRule(_localctx, 114, JavaScriptParser.RULE_singleExpression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(780)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,88, _ctx)) {
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
				if (//closure
				 { () -> Bool in
				      let testSet: Bool = {  () -> Bool in
				   let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
				    return  Utils.testBitLeftShiftArray(testArray, 106)
				}()
				      return testSet
				 }()) {
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
			setState(863)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,92,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					setState(861)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,91, _ctx)) {
					case 1:
						_localctx = PowerExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(782)
						if (!(precpred(_ctx, 27))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 27)"))
						}
						setState(783)
						try match(JavaScriptParser.Tokens.Power.rawValue)
						setState(784)
						try singleExpression(27)

						break
					case 2:
						_localctx = MultiplicativeExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(785)
						if (!(precpred(_ctx, 26))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 26)"))
						}
						setState(786)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, JavaScriptParser.Tokens.Multiply.rawValue,JavaScriptParser.Tokens.Divide.rawValue,JavaScriptParser.Tokens.Modulus.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(787)
						try singleExpression(27)

						break
					case 3:
						_localctx = AdditiveExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(788)
						if (!(precpred(_ctx, 25))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 25)"))
						}
						setState(789)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == JavaScriptParser.Tokens.Plus.rawValue || _la == JavaScriptParser.Tokens.Minus.rawValue
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(790)
						try singleExpression(26)

						break
					case 4:
						_localctx = CoalesceExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(791)
						if (!(precpred(_ctx, 24))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 24)"))
						}
						setState(792)
						try match(JavaScriptParser.Tokens.NullCoalesce.rawValue)
						setState(793)
						try singleExpression(25)

						break
					case 5:
						_localctx = BitShiftExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(794)
						if (!(precpred(_ctx, 23))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 23)"))
						}
						setState(795)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, JavaScriptParser.Tokens.RightShiftArithmetic.rawValue,JavaScriptParser.Tokens.LeftShiftArithmetic.rawValue,JavaScriptParser.Tokens.RightShiftLogical.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(796)
						try singleExpression(24)

						break
					case 6:
						_localctx = RelationalExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(797)
						if (!(precpred(_ctx, 22))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 22)"))
						}
						setState(798)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, JavaScriptParser.Tokens.LessThan.rawValue,JavaScriptParser.Tokens.MoreThan.rawValue,JavaScriptParser.Tokens.LessThanEquals.rawValue,JavaScriptParser.Tokens.GreaterThanEquals.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(799)
						try singleExpression(23)

						break
					case 7:
						_localctx = InstanceofExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(800)
						if (!(precpred(_ctx, 21))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 21)"))
						}
						setState(801)
						try match(JavaScriptParser.Tokens.Instanceof.rawValue)
						setState(802)
						try singleExpression(22)

						break
					case 8:
						_localctx = InExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(803)
						if (!(precpred(_ctx, 20))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 20)"))
						}
						setState(804)
						try match(JavaScriptParser.Tokens.In.rawValue)
						setState(805)
						try singleExpression(21)

						break
					case 9:
						_localctx = EqualityExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(806)
						if (!(precpred(_ctx, 19))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 19)"))
						}
						setState(807)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, JavaScriptParser.Tokens.Equals_.rawValue,JavaScriptParser.Tokens.NotEquals.rawValue,JavaScriptParser.Tokens.IdentityEquals.rawValue,JavaScriptParser.Tokens.IdentityNotEquals.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
						try _errHandler.recoverInline(self)
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(808)
						try singleExpression(20)

						break
					case 10:
						_localctx = BitAndExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(809)
						if (!(precpred(_ctx, 18))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 18)"))
						}
						setState(810)
						try match(JavaScriptParser.Tokens.BitAnd.rawValue)
						setState(811)
						try singleExpression(19)

						break
					case 11:
						_localctx = BitXOrExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(812)
						if (!(precpred(_ctx, 17))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 17)"))
						}
						setState(813)
						try match(JavaScriptParser.Tokens.BitXOr.rawValue)
						setState(814)
						try singleExpression(18)

						break
					case 12:
						_localctx = BitOrExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(815)
						if (!(precpred(_ctx, 16))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 16)"))
						}
						setState(816)
						try match(JavaScriptParser.Tokens.BitOr.rawValue)
						setState(817)
						try singleExpression(17)

						break
					case 13:
						_localctx = LogicalAndExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(818)
						if (!(precpred(_ctx, 15))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 15)"))
						}
						setState(819)
						try match(JavaScriptParser.Tokens.And.rawValue)
						setState(820)
						try singleExpression(16)

						break
					case 14:
						_localctx = LogicalOrExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(821)
						if (!(precpred(_ctx, 14))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 14)"))
						}
						setState(822)
						try match(JavaScriptParser.Tokens.Or.rawValue)
						setState(823)
						try singleExpression(15)

						break
					case 15:
						_localctx = TernaryExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(824)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(825)
						try match(JavaScriptParser.Tokens.QuestionMark.rawValue)
						setState(826)
						try singleExpression(0)
						setState(827)
						try match(JavaScriptParser.Tokens.Colon.rawValue)
						setState(828)
						try singleExpression(14)

						break
					case 16:
						_localctx = AssignmentExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(830)
						if (!(precpred(_ctx, 12))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 12)"))
						}
						setState(831)
						try match(JavaScriptParser.Tokens.Assign.rawValue)
						setState(832)
						try singleExpression(12)

						break
					case 17:
						_localctx = AssignmentOperatorExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(833)
						if (!(precpred(_ctx, 11))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 11)"))
						}
						setState(834)
						try assignmentOperator()
						setState(835)
						try singleExpression(11)

						break
					case 18:
						_localctx = MemberIndexExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(837)
						if (!(precpred(_ctx, 45))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 45)"))
						}
						setState(838)
						try match(JavaScriptParser.Tokens.OpenBracket.rawValue)
						setState(839)
						try expressionSequence()
						setState(840)
						try match(JavaScriptParser.Tokens.CloseBracket.rawValue)

						break
					case 19:
						_localctx = MemberDotExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(842)
						if (!(precpred(_ctx, 44))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 44)"))
						}
						setState(844)
						try _errHandler.sync(self)
						_la = try _input.LA(1)
						if (//closure
						 { () -> Bool in
						      let testSet: Bool = _la == JavaScriptParser.Tokens.QuestionMark.rawValue
						      return testSet
						 }()) {
							setState(843)
							try match(JavaScriptParser.Tokens.QuestionMark.rawValue)

						}

						setState(846)
						try match(JavaScriptParser.Tokens.Dot.rawValue)
						setState(848)
						try _errHandler.sync(self)
						_la = try _input.LA(1)
						if (//closure
						 { () -> Bool in
						      let testSet: Bool = _la == JavaScriptParser.Tokens.Hashtag.rawValue
						      return testSet
						 }()) {
							setState(847)
							try match(JavaScriptParser.Tokens.Hashtag.rawValue)

						}

						setState(850)
						try identifierName()

						break
					case 20:
						_localctx = ArgumentsExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(851)
						if (!(precpred(_ctx, 41))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 41)"))
						}
						setState(852)
						try arguments()

						break
					case 21:
						_localctx = PostIncrementExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(853)
						if (!(precpred(_ctx, 39))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 39)"))
						}
						setState(854)
						if (!(try self.notLineTerminator())) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
						}
						setState(855)
						try match(JavaScriptParser.Tokens.PlusPlus.rawValue)

						break
					case 22:
						_localctx = PostDecreaseExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(856)
						if (!(precpred(_ctx, 38))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 38)"))
						}
						setState(857)
						if (!(try self.notLineTerminator())) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.notLineTerminator()"))
						}
						setState(858)
						try match(JavaScriptParser.Tokens.MinusMinus.rawValue)

						break
					case 23:
						_localctx = TemplateStringExpressionContext(  SingleExpressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, JavaScriptParser.RULE_singleExpression)
						setState(859)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(860)
						try templateStringLiteral()

						break
					default: break
					}
			 
				}
				setState(865)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,92,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class AssignableContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func arrayLiteral() -> ArrayLiteralContext? {
				return getRuleContext(ArrayLiteralContext.self, 0)
			}
			open
			func objectLiteral() -> ObjectLiteralContext? {
				return getRuleContext(ObjectLiteralContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_assignable
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAssignable(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAssignable(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAssignable(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAssignable(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func assignable() throws -> AssignableContext {
		let _localctx: AssignableContext = AssignableContext(_ctx, getState())
		try enterRule(_localctx, 116, JavaScriptParser.RULE_assignable)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(869)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Async:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(866)
		 		try identifier()

		 		break

		 	case .OpenBracket:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(867)
		 		try arrayLiteral()

		 		break

		 	case .OpenBrace:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(868)
		 		try objectLiteral()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ObjectLiteralContext: ParserRuleContext {
			open
			func OpenBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenBrace.rawValue, 0)
			}
			open
			func CloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseBrace.rawValue, 0)
			}
			open
			func propertyAssignment() -> [PropertyAssignmentContext] {
				return getRuleContexts(PropertyAssignmentContext.self)
			}
			open
			func propertyAssignment(_ i: Int) -> PropertyAssignmentContext? {
				return getRuleContext(PropertyAssignmentContext.self, i)
			}
			open
			func Comma() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.Comma.rawValue)
			}
			open
			func Comma(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Comma.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_objectLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterObjectLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitObjectLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitObjectLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitObjectLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func objectLiteral() throws -> ObjectLiteralContext {
		let _localctx: ObjectLiteralContext = ObjectLiteralContext(_ctx, getState())
		try enterRule(_localctx, 118, JavaScriptParser.RULE_objectLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(871)
		 	try match(JavaScriptParser.Tokens.OpenBrace.rawValue)
		 	setState(883)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,96,_ctx)) {
		 	case 1:
		 		setState(872)
		 		try propertyAssignment()
		 		setState(877)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,94,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(873)
		 				try match(JavaScriptParser.Tokens.Comma.rawValue)
		 				setState(874)
		 				try propertyAssignment()

		 		 
		 			}
		 			setState(879)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,94,_ctx)
		 		}
		 		setState(881)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Comma.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(880)
		 			try match(JavaScriptParser.Tokens.Comma.rawValue)

		 		}


		 		break
		 	default: break
		 	}
		 	setState(885)
		 	try match(JavaScriptParser.Tokens.CloseBrace.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AnonymousFunctionContext: ParserRuleContext {
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_anonymousFunction
		}
	}
	public class AnonymousFunctionDeclContext: AnonymousFunctionContext {
			open
			func Function_() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}
			open
			func Multiply() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Multiply.rawValue, 0)
			}
			open
			func formalParameterList() -> FormalParameterListContext? {
				return getRuleContext(FormalParameterListContext.self, 0)
			}

		public
		init(_ ctx: AnonymousFunctionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAnonymousFunctionDecl(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAnonymousFunctionDecl(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAnonymousFunctionDecl(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAnonymousFunctionDecl(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class ArrowFunctionContext: AnonymousFunctionContext {
			open
			func arrowFunctionParameters() -> ArrowFunctionParametersContext? {
				return getRuleContext(ArrowFunctionParametersContext.self, 0)
			}
			open
			func ARROW() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.ARROW.rawValue, 0)
			}
			open
			func arrowFunctionBody() -> ArrowFunctionBodyContext? {
				return getRuleContext(ArrowFunctionBodyContext.self, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}

		public
		init(_ ctx: AnonymousFunctionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrowFunction(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrowFunction(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrowFunction(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrowFunction(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public class FunctionDeclContext: AnonymousFunctionContext {
			open
			func functionDeclaration() -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, 0)
			}

		public
		init(_ ctx: AnonymousFunctionContext) {
			super.init()
			copyFrom(ctx)
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterFunctionDecl(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitFunctionDecl(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitFunctionDecl(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitFunctionDecl(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func anonymousFunction() throws -> AnonymousFunctionContext {
		var _localctx: AnonymousFunctionContext = AnonymousFunctionContext(_ctx, getState())
		try enterRule(_localctx, 120, JavaScriptParser.RULE_anonymousFunction)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(908)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,101, _ctx)) {
		 	case 1:
		 		_localctx =  FunctionDeclContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(887)
		 		try functionDeclaration()

		 		break
		 	case 2:
		 		_localctx =  AnonymousFunctionDeclContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(889)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Async.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(888)
		 			try match(JavaScriptParser.Tokens.Async.rawValue)

		 		}

		 		setState(891)
		 		try match(JavaScriptParser.Tokens.Function_.rawValue)
		 		setState(893)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == JavaScriptParser.Tokens.Multiply.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(892)
		 			try match(JavaScriptParser.Tokens.Multiply.rawValue)

		 		}

		 		setState(895)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(897)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(896)
		 			try formalParameterList()

		 		}

		 		setState(899)
		 		try match(JavaScriptParser.Tokens.CloseParen.rawValue)
		 		setState(900)
		 		try functionBody()

		 		break
		 	case 3:
		 		_localctx =  ArrowFunctionContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(902)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,100,_ctx)) {
		 		case 1:
		 			setState(901)
		 			try match(JavaScriptParser.Tokens.Async.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(904)
		 		try arrowFunctionParameters()
		 		setState(905)
		 		try match(JavaScriptParser.Tokens.ARROW.rawValue)
		 		setState(906)
		 		try arrowFunctionBody()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrowFunctionParametersContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func OpenParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OpenParen.rawValue, 0)
			}
			open
			func CloseParen() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.CloseParen.rawValue, 0)
			}
			open
			func formalParameterList() -> FormalParameterListContext? {
				return getRuleContext(FormalParameterListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_arrowFunctionParameters
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrowFunctionParameters(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrowFunctionParameters(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrowFunctionParameters(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrowFunctionParameters(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrowFunctionParameters() throws -> ArrowFunctionParametersContext {
		let _localctx: ArrowFunctionParametersContext = ArrowFunctionParametersContext(_ctx, getState())
		try enterRule(_localctx, 122, JavaScriptParser.RULE_arrowFunctionParameters)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(916)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Async:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Identifier:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(910)
		 		try identifier()

		 		break

		 	case .OpenParen:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(911)
		 		try match(JavaScriptParser.Tokens.OpenParen.rawValue)
		 		setState(913)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, JavaScriptParser.Tokens.OpenBracket.rawValue,JavaScriptParser.Tokens.OpenBrace.rawValue,JavaScriptParser.Tokens.Ellipsis.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 106)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(912)
		 			try formalParameterList()

		 		}

		 		setState(915)
		 		try match(JavaScriptParser.Tokens.CloseParen.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrowFunctionBodyContext: ParserRuleContext {
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func functionBody() -> FunctionBodyContext? {
				return getRuleContext(FunctionBodyContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_arrowFunctionBody
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterArrowFunctionBody(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitArrowFunctionBody(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitArrowFunctionBody(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitArrowFunctionBody(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrowFunctionBody() throws -> ArrowFunctionBodyContext {
		let _localctx: ArrowFunctionBodyContext = ArrowFunctionBodyContext(_ctx, getState())
		try enterRule(_localctx, 124, JavaScriptParser.RULE_arrowFunctionBody)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(920)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,104, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(918)
		 		try singleExpression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(919)
		 		try functionBody()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AssignmentOperatorContext: ParserRuleContext {
			open
			func MultiplyAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.MultiplyAssign.rawValue, 0)
			}
			open
			func DivideAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.DivideAssign.rawValue, 0)
			}
			open
			func ModulusAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.ModulusAssign.rawValue, 0)
			}
			open
			func PlusAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.PlusAssign.rawValue, 0)
			}
			open
			func MinusAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.MinusAssign.rawValue, 0)
			}
			open
			func LeftShiftArithmeticAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.LeftShiftArithmeticAssign.rawValue, 0)
			}
			open
			func RightShiftArithmeticAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.RightShiftArithmeticAssign.rawValue, 0)
			}
			open
			func RightShiftLogicalAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.RightShiftLogicalAssign.rawValue, 0)
			}
			open
			func BitAndAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitAndAssign.rawValue, 0)
			}
			open
			func BitXorAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitXorAssign.rawValue, 0)
			}
			open
			func BitOrAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BitOrAssign.rawValue, 0)
			}
			open
			func PowerAssign() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.PowerAssign.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_assignmentOperator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterAssignmentOperator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitAssignmentOperator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitAssignmentOperator(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitAssignmentOperator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func assignmentOperator() throws -> AssignmentOperatorContext {
		let _localctx: AssignmentOperatorContext = AssignmentOperatorContext(_ctx, getState())
		try enterRule(_localctx, 126, JavaScriptParser.RULE_assignmentOperator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(922)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.MultiplyAssign.rawValue,JavaScriptParser.Tokens.DivideAssign.rawValue,JavaScriptParser.Tokens.ModulusAssign.rawValue,JavaScriptParser.Tokens.PlusAssign.rawValue,JavaScriptParser.Tokens.MinusAssign.rawValue,JavaScriptParser.Tokens.LeftShiftArithmeticAssign.rawValue,JavaScriptParser.Tokens.RightShiftArithmeticAssign.rawValue,JavaScriptParser.Tokens.RightShiftLogicalAssign.rawValue,JavaScriptParser.Tokens.BitAndAssign.rawValue,JavaScriptParser.Tokens.BitXorAssign.rawValue,JavaScriptParser.Tokens.BitOrAssign.rawValue,JavaScriptParser.Tokens.PowerAssign.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class LiteralContext: ParserRuleContext {
			open
			func NullLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NullLiteral.rawValue, 0)
			}
			open
			func BooleanLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BooleanLiteral.rawValue, 0)
			}
			open
			func StringLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.StringLiteral.rawValue, 0)
			}
			open
			func templateStringLiteral() -> TemplateStringLiteralContext? {
				return getRuleContext(TemplateStringLiteralContext.self, 0)
			}
			open
			func RegularExpressionLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue, 0)
			}
			open
			func numericLiteral() -> NumericLiteralContext? {
				return getRuleContext(NumericLiteralContext.self, 0)
			}
			open
			func bigintLiteral() -> BigintLiteralContext? {
				return getRuleContext(BigintLiteralContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_literal
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func literal() throws -> LiteralContext {
		let _localctx: LiteralContext = LiteralContext(_ctx, getState())
		try enterRule(_localctx, 128, JavaScriptParser.RULE_literal)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(931)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .NullLiteral:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(924)
		 		try match(JavaScriptParser.Tokens.NullLiteral.rawValue)

		 		break

		 	case .BooleanLiteral:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(925)
		 		try match(JavaScriptParser.Tokens.BooleanLiteral.rawValue)

		 		break

		 	case .StringLiteral:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(926)
		 		try match(JavaScriptParser.Tokens.StringLiteral.rawValue)

		 		break

		 	case .BackTick:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(927)
		 		try templateStringLiteral()

		 		break

		 	case .RegularExpressionLiteral:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(928)
		 		try match(JavaScriptParser.Tokens.RegularExpressionLiteral.rawValue)

		 		break
		 	case .DecimalLiteral:fallthrough
		 	case .HexIntegerLiteral:fallthrough
		 	case .OctalIntegerLiteral:fallthrough
		 	case .OctalIntegerLiteral2:fallthrough
		 	case .BinaryIntegerLiteral:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(929)
		 		try numericLiteral()

		 		break
		 	case .BigHexIntegerLiteral:fallthrough
		 	case .BigOctalIntegerLiteral:fallthrough
		 	case .BigBinaryIntegerLiteral:fallthrough
		 	case .BigDecimalIntegerLiteral:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(930)
		 		try bigintLiteral()

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TemplateStringLiteralContext: ParserRuleContext {
			open
			func BackTick() -> [TerminalNode] {
				return getTokens(JavaScriptParser.Tokens.BackTick.rawValue)
			}
			open
			func BackTick(_ i:Int) -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BackTick.rawValue, i)
			}
			open
			func templateStringAtom() -> [TemplateStringAtomContext] {
				return getRuleContexts(TemplateStringAtomContext.self)
			}
			open
			func templateStringAtom(_ i: Int) -> TemplateStringAtomContext? {
				return getRuleContext(TemplateStringAtomContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_templateStringLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTemplateStringLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTemplateStringLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTemplateStringLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTemplateStringLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func templateStringLiteral() throws -> TemplateStringLiteralContext {
		let _localctx: TemplateStringLiteralContext = TemplateStringLiteralContext(_ctx, getState())
		try enterRule(_localctx, 130, JavaScriptParser.RULE_templateStringLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(933)
		 	try match(JavaScriptParser.Tokens.BackTick.rawValue)
		 	setState(937)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue || _la == JavaScriptParser.Tokens.TemplateStringAtom.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(934)
		 		try templateStringAtom()


		 		setState(939)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(940)
		 	try match(JavaScriptParser.Tokens.BackTick.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TemplateStringAtomContext: ParserRuleContext {
			open
			func TemplateStringAtom() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.TemplateStringAtom.rawValue, 0)
			}
			open
			func TemplateStringStartExpression() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue, 0)
			}
			open
			func singleExpression() -> SingleExpressionContext? {
				return getRuleContext(SingleExpressionContext.self, 0)
			}
			open
			func TemplateCloseBrace() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.TemplateCloseBrace.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_templateStringAtom
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterTemplateStringAtom(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitTemplateStringAtom(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitTemplateStringAtom(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitTemplateStringAtom(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func templateStringAtom() throws -> TemplateStringAtomContext {
		let _localctx: TemplateStringAtomContext = TemplateStringAtomContext(_ctx, getState())
		try enterRule(_localctx, 132, JavaScriptParser.RULE_templateStringAtom)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(947)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .TemplateStringAtom:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(942)
		 		try match(JavaScriptParser.Tokens.TemplateStringAtom.rawValue)

		 		break

		 	case .TemplateStringStartExpression:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(943)
		 		try match(JavaScriptParser.Tokens.TemplateStringStartExpression.rawValue)
		 		setState(944)
		 		try singleExpression(0)
		 		setState(945)
		 		try match(JavaScriptParser.Tokens.TemplateCloseBrace.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class NumericLiteralContext: ParserRuleContext {
			open
			func DecimalLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.DecimalLiteral.rawValue, 0)
			}
			open
			func HexIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.HexIntegerLiteral.rawValue, 0)
			}
			open
			func OctalIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue, 0)
			}
			open
			func OctalIntegerLiteral2() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue, 0)
			}
			open
			func BinaryIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_numericLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterNumericLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitNumericLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitNumericLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitNumericLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func numericLiteral() throws -> NumericLiteralContext {
		let _localctx: NumericLiteralContext = NumericLiteralContext(_ctx, getState())
		try enterRule(_localctx, 134, JavaScriptParser.RULE_numericLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(949)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.DecimalLiteral.rawValue,JavaScriptParser.Tokens.HexIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.OctalIntegerLiteral2.rawValue,JavaScriptParser.Tokens.BinaryIntegerLiteral.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 62)
		 	}()
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BigintLiteralContext: ParserRuleContext {
			open
			func BigDecimalIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue, 0)
			}
			open
			func BigHexIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue, 0)
			}
			open
			func BigOctalIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue, 0)
			}
			open
			func BigBinaryIntegerLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_bigintLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterBigintLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitBigintLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitBigintLiteral(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitBigintLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func bigintLiteral() throws -> BigintLiteralContext {
		let _localctx: BigintLiteralContext = BigintLiteralContext(_ctx, getState())
		try enterRule(_localctx, 136, JavaScriptParser.RULE_bigintLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(951)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.BigHexIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigOctalIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigBinaryIntegerLiteral.rawValue,JavaScriptParser.Tokens.BigDecimalIntegerLiteral.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 67)
		 	}()
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class GetterContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_getter
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterGetter(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitGetter(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitGetter(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitGetter(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func getter() throws -> GetterContext {
		let _localctx: GetterContext = GetterContext(_ctx, getState())
		try enterRule(_localctx, 138, JavaScriptParser.RULE_getter)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(953)
		 	if (!(try self.n("get"))) {
		 	    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.n(\"get\")"))
		 	}
		 	setState(954)
		 	try identifier()
		 	setState(955)
		 	try propertyName()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SetterContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func propertyName() -> PropertyNameContext? {
				return getRuleContext(PropertyNameContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_setter
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterSetter(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitSetter(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitSetter(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitSetter(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func setter() throws -> SetterContext {
		let _localctx: SetterContext = SetterContext(_ctx, getState())
		try enterRule(_localctx, 140, JavaScriptParser.RULE_setter)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(957)
		 	if (!(try self.n("set"))) {
		 	    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.n(\"set\")"))
		 	}
		 	setState(958)
		 	try identifier()
		 	setState(959)
		 	try propertyName()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IdentifierNameContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func reservedWord() -> ReservedWordContext? {
				return getRuleContext(ReservedWordContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_identifierName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterIdentifierName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitIdentifierName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitIdentifierName(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitIdentifierName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func identifierName() throws -> IdentifierNameContext {
		let _localctx: IdentifierNameContext = IdentifierNameContext(_ctx, getState())
		try enterRule(_localctx, 142, JavaScriptParser.RULE_identifierName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(963)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,108, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(961)
		 		try identifier()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(962)
		 		try reservedWord()

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IdentifierContext: ParserRuleContext {
			open
			func Identifier() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Identifier.rawValue, 0)
			}
			open
			func NonStrictLet() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NonStrictLet.rawValue, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_identifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterIdentifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitIdentifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitIdentifier(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitIdentifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func identifier() throws -> IdentifierContext {
		let _localctx: IdentifierContext = IdentifierContext(_ctx, getState())
		try enterRule(_localctx, 144, JavaScriptParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(965)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, JavaScriptParser.Tokens.Async.rawValue,JavaScriptParser.Tokens.NonStrictLet.rawValue,JavaScriptParser.Tokens.Identifier.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 106)
		 	}()
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReservedWordContext: ParserRuleContext {
			open
			func keyword() -> KeywordContext? {
				return getRuleContext(KeywordContext.self, 0)
			}
			open
			func NullLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NullLiteral.rawValue, 0)
			}
			open
			func BooleanLiteral() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.BooleanLiteral.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_reservedWord
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterReservedWord(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitReservedWord(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitReservedWord(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitReservedWord(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func reservedWord() throws -> ReservedWordContext {
		let _localctx: ReservedWordContext = ReservedWordContext(_ctx, getState())
		try enterRule(_localctx, 146, JavaScriptParser.RULE_reservedWord)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(970)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Break:fallthrough
		 	case .Do:fallthrough
		 	case .Instanceof:fallthrough
		 	case .Typeof:fallthrough
		 	case .Case:fallthrough
		 	case .Else:fallthrough
		 	case .New:fallthrough
		 	case .Var:fallthrough
		 	case .Catch:fallthrough
		 	case .Finally:fallthrough
		 	case .Return:fallthrough
		 	case .Void:fallthrough
		 	case .Continue:fallthrough
		 	case .For:fallthrough
		 	case .Switch:fallthrough
		 	case .While:fallthrough
		 	case .Debugger:fallthrough
		 	case .Function_:fallthrough
		 	case .This:fallthrough
		 	case .With:fallthrough
		 	case .Default:fallthrough
		 	case .If:fallthrough
		 	case .Throw:fallthrough
		 	case .Delete:fallthrough
		 	case .In:fallthrough
		 	case .Try:fallthrough
		 	case .As:fallthrough
		 	case .From:fallthrough
		 	case .Class:fallthrough
		 	case .Enum:fallthrough
		 	case .Extends:fallthrough
		 	case .Super:fallthrough
		 	case .Const:fallthrough
		 	case .Export:fallthrough
		 	case .Import:fallthrough
		 	case .Async:fallthrough
		 	case .Await:fallthrough
		 	case .Implements:fallthrough
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:fallthrough
		 	case .Private:fallthrough
		 	case .Public:fallthrough
		 	case .Interface:fallthrough
		 	case .Package:fallthrough
		 	case .Protected:fallthrough
		 	case .Static:fallthrough
		 	case .Yield:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(967)
		 		try keyword()

		 		break

		 	case .NullLiteral:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(968)
		 		try match(JavaScriptParser.Tokens.NullLiteral.rawValue)

		 		break

		 	case .BooleanLiteral:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(969)
		 		try match(JavaScriptParser.Tokens.BooleanLiteral.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class KeywordContext: ParserRuleContext {
			open
			func Break() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Break.rawValue, 0)
			}
			open
			func Do() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Do.rawValue, 0)
			}
			open
			func Instanceof() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Instanceof.rawValue, 0)
			}
			open
			func Typeof() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Typeof.rawValue, 0)
			}
			open
			func Case() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Case.rawValue, 0)
			}
			open
			func Else() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Else.rawValue, 0)
			}
			open
			func New() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.New.rawValue, 0)
			}
			open
			func Var() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Var.rawValue, 0)
			}
			open
			func Catch() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Catch.rawValue, 0)
			}
			open
			func Finally() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Finally.rawValue, 0)
			}
			open
			func Return() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Return.rawValue, 0)
			}
			open
			func Void() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Void.rawValue, 0)
			}
			open
			func Continue() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Continue.rawValue, 0)
			}
			open
			func For() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.For.rawValue, 0)
			}
			open
			func Switch() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Switch.rawValue, 0)
			}
			open
			func While() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.While.rawValue, 0)
			}
			open
			func Debugger() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Debugger.rawValue, 0)
			}
			open
			func Function_() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Function_.rawValue, 0)
			}
			open
			func This() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.This.rawValue, 0)
			}
			open
			func With() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.With.rawValue, 0)
			}
			open
			func Default() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Default.rawValue, 0)
			}
			open
			func If() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.If.rawValue, 0)
			}
			open
			func Throw() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Throw.rawValue, 0)
			}
			open
			func Delete() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Delete.rawValue, 0)
			}
			open
			func In() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.In.rawValue, 0)
			}
			open
			func Try() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Try.rawValue, 0)
			}
			open
			func Class() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Class.rawValue, 0)
			}
			open
			func Enum() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Enum.rawValue, 0)
			}
			open
			func Extends() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Extends.rawValue, 0)
			}
			open
			func Super() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Super.rawValue, 0)
			}
			open
			func Const() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Const.rawValue, 0)
			}
			open
			func Export() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Export.rawValue, 0)
			}
			open
			func Import() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Import.rawValue, 0)
			}
			open
			func Implements() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Implements.rawValue, 0)
			}
			open
			func let_() -> Let_Context? {
				return getRuleContext(Let_Context.self, 0)
			}
			open
			func Private() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Private.rawValue, 0)
			}
			open
			func Public() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Public.rawValue, 0)
			}
			open
			func Interface() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Interface.rawValue, 0)
			}
			open
			func Package() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Package.rawValue, 0)
			}
			open
			func Protected() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Protected.rawValue, 0)
			}
			open
			func Static() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Static.rawValue, 0)
			}
			open
			func Yield() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Yield.rawValue, 0)
			}
			open
			func Async() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Async.rawValue, 0)
			}
			open
			func Await() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.Await.rawValue, 0)
			}
			open
			func From() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.From.rawValue, 0)
			}
			open
			func As() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.As.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_keyword
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterKeyword(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitKeyword(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitKeyword(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitKeyword(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func keyword() throws -> KeywordContext {
		let _localctx: KeywordContext = KeywordContext(_ctx, getState())
		try enterRule(_localctx, 148, JavaScriptParser.RULE_keyword)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1018)
		 	try _errHandler.sync(self)
		 	switch (JavaScriptParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .Break:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(972)
		 		try match(JavaScriptParser.Tokens.Break.rawValue)

		 		break

		 	case .Do:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(973)
		 		try match(JavaScriptParser.Tokens.Do.rawValue)

		 		break

		 	case .Instanceof:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(974)
		 		try match(JavaScriptParser.Tokens.Instanceof.rawValue)

		 		break

		 	case .Typeof:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(975)
		 		try match(JavaScriptParser.Tokens.Typeof.rawValue)

		 		break

		 	case .Case:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(976)
		 		try match(JavaScriptParser.Tokens.Case.rawValue)

		 		break

		 	case .Else:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(977)
		 		try match(JavaScriptParser.Tokens.Else.rawValue)

		 		break

		 	case .New:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(978)
		 		try match(JavaScriptParser.Tokens.New.rawValue)

		 		break

		 	case .Var:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(979)
		 		try match(JavaScriptParser.Tokens.Var.rawValue)

		 		break

		 	case .Catch:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(980)
		 		try match(JavaScriptParser.Tokens.Catch.rawValue)

		 		break

		 	case .Finally:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(981)
		 		try match(JavaScriptParser.Tokens.Finally.rawValue)

		 		break

		 	case .Return:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(982)
		 		try match(JavaScriptParser.Tokens.Return.rawValue)

		 		break

		 	case .Void:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(983)
		 		try match(JavaScriptParser.Tokens.Void.rawValue)

		 		break

		 	case .Continue:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(984)
		 		try match(JavaScriptParser.Tokens.Continue.rawValue)

		 		break

		 	case .For:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(985)
		 		try match(JavaScriptParser.Tokens.For.rawValue)

		 		break

		 	case .Switch:
		 		try enterOuterAlt(_localctx, 15)
		 		setState(986)
		 		try match(JavaScriptParser.Tokens.Switch.rawValue)

		 		break

		 	case .While:
		 		try enterOuterAlt(_localctx, 16)
		 		setState(987)
		 		try match(JavaScriptParser.Tokens.While.rawValue)

		 		break

		 	case .Debugger:
		 		try enterOuterAlt(_localctx, 17)
		 		setState(988)
		 		try match(JavaScriptParser.Tokens.Debugger.rawValue)

		 		break

		 	case .Function_:
		 		try enterOuterAlt(_localctx, 18)
		 		setState(989)
		 		try match(JavaScriptParser.Tokens.Function_.rawValue)

		 		break

		 	case .This:
		 		try enterOuterAlt(_localctx, 19)
		 		setState(990)
		 		try match(JavaScriptParser.Tokens.This.rawValue)

		 		break

		 	case .With:
		 		try enterOuterAlt(_localctx, 20)
		 		setState(991)
		 		try match(JavaScriptParser.Tokens.With.rawValue)

		 		break

		 	case .Default:
		 		try enterOuterAlt(_localctx, 21)
		 		setState(992)
		 		try match(JavaScriptParser.Tokens.Default.rawValue)

		 		break

		 	case .If:
		 		try enterOuterAlt(_localctx, 22)
		 		setState(993)
		 		try match(JavaScriptParser.Tokens.If.rawValue)

		 		break

		 	case .Throw:
		 		try enterOuterAlt(_localctx, 23)
		 		setState(994)
		 		try match(JavaScriptParser.Tokens.Throw.rawValue)

		 		break

		 	case .Delete:
		 		try enterOuterAlt(_localctx, 24)
		 		setState(995)
		 		try match(JavaScriptParser.Tokens.Delete.rawValue)

		 		break

		 	case .In:
		 		try enterOuterAlt(_localctx, 25)
		 		setState(996)
		 		try match(JavaScriptParser.Tokens.In.rawValue)

		 		break

		 	case .Try:
		 		try enterOuterAlt(_localctx, 26)
		 		setState(997)
		 		try match(JavaScriptParser.Tokens.Try.rawValue)

		 		break

		 	case .Class:
		 		try enterOuterAlt(_localctx, 27)
		 		setState(998)
		 		try match(JavaScriptParser.Tokens.Class.rawValue)

		 		break

		 	case .Enum:
		 		try enterOuterAlt(_localctx, 28)
		 		setState(999)
		 		try match(JavaScriptParser.Tokens.Enum.rawValue)

		 		break

		 	case .Extends:
		 		try enterOuterAlt(_localctx, 29)
		 		setState(1000)
		 		try match(JavaScriptParser.Tokens.Extends.rawValue)

		 		break

		 	case .Super:
		 		try enterOuterAlt(_localctx, 30)
		 		setState(1001)
		 		try match(JavaScriptParser.Tokens.Super.rawValue)

		 		break

		 	case .Const:
		 		try enterOuterAlt(_localctx, 31)
		 		setState(1002)
		 		try match(JavaScriptParser.Tokens.Const.rawValue)

		 		break

		 	case .Export:
		 		try enterOuterAlt(_localctx, 32)
		 		setState(1003)
		 		try match(JavaScriptParser.Tokens.Export.rawValue)

		 		break

		 	case .Import:
		 		try enterOuterAlt(_localctx, 33)
		 		setState(1004)
		 		try match(JavaScriptParser.Tokens.Import.rawValue)

		 		break

		 	case .Implements:
		 		try enterOuterAlt(_localctx, 34)
		 		setState(1005)
		 		try match(JavaScriptParser.Tokens.Implements.rawValue)

		 		break
		 	case .StrictLet:fallthrough
		 	case .NonStrictLet:
		 		try enterOuterAlt(_localctx, 35)
		 		setState(1006)
		 		try let_()

		 		break

		 	case .Private:
		 		try enterOuterAlt(_localctx, 36)
		 		setState(1007)
		 		try match(JavaScriptParser.Tokens.Private.rawValue)

		 		break

		 	case .Public:
		 		try enterOuterAlt(_localctx, 37)
		 		setState(1008)
		 		try match(JavaScriptParser.Tokens.Public.rawValue)

		 		break

		 	case .Interface:
		 		try enterOuterAlt(_localctx, 38)
		 		setState(1009)
		 		try match(JavaScriptParser.Tokens.Interface.rawValue)

		 		break

		 	case .Package:
		 		try enterOuterAlt(_localctx, 39)
		 		setState(1010)
		 		try match(JavaScriptParser.Tokens.Package.rawValue)

		 		break

		 	case .Protected:
		 		try enterOuterAlt(_localctx, 40)
		 		setState(1011)
		 		try match(JavaScriptParser.Tokens.Protected.rawValue)

		 		break

		 	case .Static:
		 		try enterOuterAlt(_localctx, 41)
		 		setState(1012)
		 		try match(JavaScriptParser.Tokens.Static.rawValue)

		 		break

		 	case .Yield:
		 		try enterOuterAlt(_localctx, 42)
		 		setState(1013)
		 		try match(JavaScriptParser.Tokens.Yield.rawValue)

		 		break

		 	case .Async:
		 		try enterOuterAlt(_localctx, 43)
		 		setState(1014)
		 		try match(JavaScriptParser.Tokens.Async.rawValue)

		 		break

		 	case .Await:
		 		try enterOuterAlt(_localctx, 44)
		 		setState(1015)
		 		try match(JavaScriptParser.Tokens.Await.rawValue)

		 		break

		 	case .From:
		 		try enterOuterAlt(_localctx, 45)
		 		setState(1016)
		 		try match(JavaScriptParser.Tokens.From.rawValue)

		 		break

		 	case .As:
		 		try enterOuterAlt(_localctx, 46)
		 		setState(1017)
		 		try match(JavaScriptParser.Tokens.As.rawValue)

		 		break
		 	default:
		 		throw ANTLRException.recognition(e: NoViableAltException(self))
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class Let_Context: ParserRuleContext {
			open
			func NonStrictLet() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.NonStrictLet.rawValue, 0)
			}
			open
			func StrictLet() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.StrictLet.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_let_
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterLet_(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitLet_(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitLet_(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitLet_(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func let_() throws -> Let_Context {
		let _localctx: Let_Context = Let_Context(_ctx, getState())
		try enterRule(_localctx, 150, JavaScriptParser.RULE_let_)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1020)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == JavaScriptParser.Tokens.StrictLet.rawValue || _la == JavaScriptParser.Tokens.NonStrictLet.rawValue
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EosContext: ParserRuleContext {
			open
			func SemiColon() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.SemiColon.rawValue, 0)
			}
			open
			func EOF() -> TerminalNode? {
				return getToken(JavaScriptParser.Tokens.EOF.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return JavaScriptParser.RULE_eos
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.enterEos(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? JavaScriptParserListener {
				listener.exitEos(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? JavaScriptParserVisitor {
			    return visitor.visitEos(self)
			}
			else if let visitor = visitor as? JavaScriptParserBaseVisitor {
			    return visitor.visitEos(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func eos() throws -> EosContext {
		let _localctx: EosContext = EosContext(_ctx, getState())
		try enterRule(_localctx, 152, JavaScriptParser.RULE_eos)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1026)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,111, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1022)
		 		try match(JavaScriptParser.Tokens.SemiColon.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1023)
		 		try match(JavaScriptParser.Tokens.EOF.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1024)
		 		if (!(try self.lineTerminatorAhead())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.lineTerminatorAhead()"))
		 		}

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1025)
		 		if (!(try self.closeBrace())) {
		 		    throw ANTLRException.recognition(e:FailedPredicateException(self, "self.closeBrace()"))
		 		}

		 		break
		 	default: break
		 	}
		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  19:
			return try expressionStatement_sempred(_localctx?.castdown(ExpressionStatementContext.self), predIndex)
		case  21:
			return try iterationStatement_sempred(_localctx?.castdown(IterationStatementContext.self), predIndex)
		case  23:
			return try continueStatement_sempred(_localctx?.castdown(ContinueStatementContext.self), predIndex)
		case  24:
			return try breakStatement_sempred(_localctx?.castdown(BreakStatementContext.self), predIndex)
		case  25:
			return try returnStatement_sempred(_localctx?.castdown(ReturnStatementContext.self), predIndex)
		case  26:
			return try yieldStatement_sempred(_localctx?.castdown(YieldStatementContext.self), predIndex)
		case  34:
			return try throwStatement_sempred(_localctx?.castdown(ThrowStatementContext.self), predIndex)
		case  42:
			return try classElement_sempred(_localctx?.castdown(ClassElementContext.self), predIndex)
		case  57:
			return try singleExpression_sempred(_localctx?.castdown(SingleExpressionContext.self), predIndex)
		case  69:
			return try getter_sempred(_localctx?.castdown(GetterContext.self), predIndex)
		case  70:
			return try setter_sempred(_localctx?.castdown(SetterContext.self), predIndex)
		case  76:
			return try eos_sempred(_localctx?.castdown(EosContext.self), predIndex)
	    default: return true
		}
	}
	private func expressionStatement_sempred(_ _localctx: ExpressionStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return try self.notOpenBraceAndNotFunction()
		    default: return true
		}
	}
	private func iterationStatement_sempred(_ _localctx: IterationStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 1:return try self.p("of")
		    default: return true
		}
	}
	private func continueStatement_sempred(_ _localctx: ContinueStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 2:return try self.notLineTerminator()
		    default: return true
		}
	}
	private func breakStatement_sempred(_ _localctx: BreakStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 3:return try self.notLineTerminator()
		    default: return true
		}
	}
	private func returnStatement_sempred(_ _localctx: ReturnStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 4:return try self.notLineTerminator()
		    default: return true
		}
	}
	private func yieldStatement_sempred(_ _localctx: YieldStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 5:return try self.notLineTerminator()
		    default: return true
		}
	}
	private func throwStatement_sempred(_ _localctx: ThrowStatementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 6:return try self.notLineTerminator()
		    default: return true
		}
	}
	private func classElement_sempred(_ _localctx: ClassElementContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 7:return try self.n("static")
		    default: return true
		}
	}
	private func singleExpression_sempred(_ _localctx: SingleExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 8:return precpred(_ctx, 27)
		    case 9:return precpred(_ctx, 26)
		    case 10:return precpred(_ctx, 25)
		    case 11:return precpred(_ctx, 24)
		    case 12:return precpred(_ctx, 23)
		    case 13:return precpred(_ctx, 22)
		    case 14:return precpred(_ctx, 21)
		    case 15:return precpred(_ctx, 20)
		    case 16:return precpred(_ctx, 19)
		    case 17:return precpred(_ctx, 18)
		    case 18:return precpred(_ctx, 17)
		    case 19:return precpred(_ctx, 16)
		    case 20:return precpred(_ctx, 15)
		    case 21:return precpred(_ctx, 14)
		    case 22:return precpred(_ctx, 13)
		    case 23:return precpred(_ctx, 12)
		    case 24:return precpred(_ctx, 11)
		    case 25:return precpred(_ctx, 45)
		    case 26:return precpred(_ctx, 44)
		    case 27:return precpred(_ctx, 41)
		    case 28:return precpred(_ctx, 39)
		    case 29:return try self.notLineTerminator()
		    case 30:return precpred(_ctx, 38)
		    case 31:return try self.notLineTerminator()
		    case 32:return precpred(_ctx, 9)
		    default: return true
		}
	}
	private func getter_sempred(_ _localctx: GetterContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 33:return try self.n("get")
		    default: return true
		}
	}
	private func setter_sempred(_ _localctx: SetterContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 34:return try self.n("set")
		    default: return true
		}
	}
	private func eos_sempred(_ _localctx: EosContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 35:return try self.lineTerminatorAhead()
		    case 36:return try self.closeBrace()
		    default: return true
		}
	}


	public
	static let _serializedATN = JavaScriptParserATN().jsonString
}
