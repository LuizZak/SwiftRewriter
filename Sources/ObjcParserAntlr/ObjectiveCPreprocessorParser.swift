// Generated from /Users/luizsilva/Desktop/grammars-v4-master/objc/two-step-processing/ObjectiveCPreprocessorParser.g4 by ANTLR 4.7
import Antlr4

open class ObjectiveCPreprocessorParser: Parser {
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
    
	public enum Tokens: Int {
		case EOF = -1, SHARP = 1, CODE = 2, IMPORT = 3, INCLUDE = 4, PRAGMA = 5, 
                 DEFINE = 6, DEFINED = 7, IF = 8, ELIF = 9, ELSE = 10, UNDEF = 11, 
                 IFDEF = 12, IFNDEF = 13, ENDIF = 14, TRUE = 15, FALSE = 16, 
                 ERROR = 17, WARNING = 18, BANG = 19, LPAREN = 20, RPAREN = 21, 
                 EQUAL = 22, NOTEQUAL = 23, AND = 24, OR = 25, LT = 26, 
                 GT = 27, LE = 28, GE = 29, DIRECTIVE_WHITESPACES = 30, 
                 DIRECTIVE_STRING = 31, CONDITIONAL_SYMBOL = 32, DECIMAL_LITERAL = 33, 
                 FLOAT = 34, NEW_LINE = 35, DIRECITVE_COMMENT = 36, DIRECITVE_LINE_COMMENT = 37, 
                 DIRECITVE_NEW_LINE = 38, DIRECITVE_TEXT_NEW_LINE = 39, 
                 TEXT = 40, SLASH = 41
	}
	public static let RULE_objectiveCDocument = 0, RULE_text = 1, RULE_code = 2, 
                   RULE_directive = 3, RULE_directive_text = 4, RULE_preprocessor_expression = 5
	public static let ruleNames: [String] = [
		"objectiveCDocument", "text", "code", "directive", "directive_text", "preprocessor_expression"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'#'", nil, nil, nil, "'pragma'", nil, "'defined'", "'if'", "'elif'", 
		"'else'", "'undef'", "'ifdef'", "'ifndef'", "'endif'", nil, nil, "'error'", 
		"'warning'", "'!'", "'('", "')'", "'=='", "'!='", "'&&'", "'||'", "'<'", 
		"'>'", "'<='", "'>='"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, "SHARP", "CODE", "IMPORT", "INCLUDE", "PRAGMA", "DEFINE", "DEFINED", 
		"IF", "ELIF", "ELSE", "UNDEF", "IFDEF", "IFNDEF", "ENDIF", "TRUE", "FALSE", 
		"ERROR", "WARNING", "BANG", "LPAREN", "RPAREN", "EQUAL", "NOTEQUAL", "AND", 
		"OR", "LT", "GT", "LE", "GE", "DIRECTIVE_WHITESPACES", "DIRECTIVE_STRING", 
		"CONDITIONAL_SYMBOL", "DECIMAL_LITERAL", "FLOAT", "NEW_LINE", "DIRECITVE_COMMENT", 
		"DIRECITVE_LINE_COMMENT", "DIRECITVE_NEW_LINE", "DIRECITVE_TEXT_NEW_LINE", 
		"TEXT", "SLASH"
	]
	public static let VOCABULARY: Vocabulary = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	//@Deprecated
	public let tokenNames: [String?]? = {
	    let length = _SYMBOLIC_NAMES.count
	    var tokenNames = [String?](repeating: nil, count: length)
		for i in 0..<length {
			var name = VOCABULARY.getLiteralName(i)
			if name == nil {
				name = VOCABULARY.getSymbolicName(i)
			}
			if name == nil {
				name = "<INVALID>"
			}
			tokenNames[i] = name
		}
		return tokenNames
	}()

	open func getTokenNames() -> [String?]? {
		return tokenNames
	}

	override
	open func getGrammarFileName() -> String { return "ObjectiveCPreprocessorParser.g4" }

	override
	open func getRuleNames() -> [String] { return ObjectiveCPreprocessorParser.ruleNames }

	override
	open func getSerializedATN() -> String { return ObjectiveCPreprocessorParser._serializedATN }

	override
	open func getATN() -> ATN { return _ATN }

	open override func getVocabulary() -> Vocabulary {
	    return ObjectiveCPreprocessorParser.VOCABULARY
	}

    public override convenience init(_ input: TokenStream) throws {
        try self.init(input, State())
    }
    
    public init(_ input: TokenStream, _ state: State) throws {
        self.state = state
        
        RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION)
        try super.init(input)
        _interp = ParserATNSimulator(self,
                                     _ATN,
                                     _decisionToDFA,
                                     _sharedContextCache,
                                     atnConfigPool: state.atnConfigPool)
    }
    
	open class ObjectiveCDocumentContext:ParserRuleContext {
		open func EOF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue, 0) }
		open func text() -> Array<TextContext> {
			return getRuleContexts(TextContext.self)
		}
		open func text(_ i: Int) -> TextContext? {
			return getRuleContext(TextContext.self,i)
		}
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_objectiveCDocument }
		override
		open func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterObjectiveCDocument(self)
			}
		}
		override
		open func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitObjectiveCDocument(self)
			}
		}
		override
		open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitObjectiveCDocument(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitObjectiveCDocument(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	open func objectiveCDocument() throws -> ObjectiveCDocumentContext {
		var _localctx: ObjectiveCDocumentContext = ObjectiveCDocumentContext(_ctx, getState())
		try enterRule(_localctx, 0, ObjectiveCPreprocessorParser.RULE_objectiveCDocument)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(15)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue || _la == ObjectiveCPreprocessorParser.Tokens.CODE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(12)
		 		try text()


		 		setState(17)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(18)
		 	try match(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}
	open class TextContext:ParserRuleContext {
		open func code() -> CodeContext? {
			return getRuleContext(CodeContext.self,0)
		}
		open func SHARP() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.SHARP.rawValue, 0) }
		open func directive() -> DirectiveContext? {
			return getRuleContext(DirectiveContext.self,0)
		}
		open func NEW_LINE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.NEW_LINE.rawValue, 0) }
		open func EOF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.EOF.rawValue, 0) }
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_text }
		override
		open func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterText(self)
			}
		}
		override
		open func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitText(self)
			}
		}
		override
		open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitText(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitText(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	open func text() throws -> TextContext {
		var _localctx: TextContext = TextContext(_ctx, getState())
		try enterRule(_localctx, 2, ObjectiveCPreprocessorParser.RULE_text)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(25)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))!) {
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
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.EOF.rawValue || _la == ObjectiveCPreprocessorParser.Tokens.NEW_LINE.rawValue
		 		      return testSet
		 		 }())) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}

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
	open class CodeContext:ParserRuleContext {
		open func CODE() -> Array<TerminalNode> { return getTokens(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue) }
		open func CODE(_ i:Int) -> TerminalNode?{
			return getToken(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue, i)
		}
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_code }
		override
		open func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterCode(self)
			}
		}
		override
		open func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitCode(self)
			}
		}
		override
		open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitCode(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitCode(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	open func code() throws -> CodeContext {
		var _localctx: CodeContext = CodeContext(_ctx, getState())
		try enterRule(_localctx, 4, ObjectiveCPreprocessorParser.RULE_code)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(28); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(27)
		 			try match(ObjectiveCPreprocessorParser.Tokens.CODE.rawValue)


		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(30); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,2,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}
	open class DirectiveContext:ParserRuleContext {
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_directive }
	 
		public  func copyFrom(_ ctx: DirectiveContext) {
			super.copyFrom(ctx)
		}
	}
	public  final class PreprocessorDefContext: DirectiveContext {
        public func IFDEF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.IFDEF.rawValue, 0) }
        public func CONDITIONAL_SYMBOL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0) }
        public func IFNDEF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.IFNDEF.rawValue, 0) }
        public func UNDEF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.UNDEF.rawValue, 0) }
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorDef(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorDef(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorDef(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorDef(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorErrorContext: DirectiveContext {
        public func ERROR() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.ERROR.rawValue, 0) }
        public func directive_text() -> Directive_textContext? {
			return getRuleContext(Directive_textContext.self,0)
		}
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorError(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorError(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorError(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorError(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorConditionalContext: DirectiveContext {
        public func IF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.IF.rawValue, 0) }
        public func preprocessor_expression() -> Preprocessor_expressionContext? {
			return getRuleContext(Preprocessor_expressionContext.self,0)
		}
        public func ELIF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.ELIF.rawValue, 0) }
        public func ELSE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.ELSE.rawValue, 0) }
        public func ENDIF() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.ENDIF.rawValue, 0) }
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorConditional(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorConditional(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorConditional(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorConditional(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorImportContext: DirectiveContext {
        public func directive_text() -> Directive_textContext? {
			return getRuleContext(Directive_textContext.self,0)
		}
        public func IMPORT() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.IMPORT.rawValue, 0) }
        public func INCLUDE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.INCLUDE.rawValue, 0) }
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorImport(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorImport(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorImport(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorImport(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorPragmaContext: DirectiveContext {
        public func PRAGMA() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.PRAGMA.rawValue, 0) }
        public func directive_text() -> Directive_textContext? {
			return getRuleContext(Directive_textContext.self,0)
		}
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorPragma(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorPragma(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorPragma(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorPragma(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorDefineContext: DirectiveContext {
        public func DEFINE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.DEFINE.rawValue, 0) }
        public func CONDITIONAL_SYMBOL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0) }
        public func directive_text() -> Directive_textContext? {
			return getRuleContext(Directive_textContext.self,0)
		}
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorDefine(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorDefine(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorDefine(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorDefine(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorWarningContext: DirectiveContext {
        public func WARNING() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.WARNING.rawValue, 0) }
        public func directive_text() -> Directive_textContext? {
			return getRuleContext(Directive_textContext.self,0)
		}
		public init(_ ctx: DirectiveContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorWarning(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorWarning(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorWarning(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorWarning(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	open func directive() throws -> DirectiveContext {
		var _localctx: DirectiveContext = DirectiveContext(_ctx, getState())
		try enterRule(_localctx, 6, ObjectiveCPreprocessorParser.RULE_directive)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(57)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .IMPORT:fallthrough
		 	case .INCLUDE:
		 		_localctx =  PreprocessorImportContext(_localctx);
		 		try enterOuterAlt(_localctx, 1)
		 		setState(32)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.IMPORT.rawValue || _la == ObjectiveCPreprocessorParser.Tokens.INCLUDE.rawValue
		 		      return testSet
		 		 }())) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}
		 		setState(33)
		 		try directive_text()

		 		break

		 	case .IF:
		 		_localctx =  PreprocessorConditionalContext(_localctx);
		 		try enterOuterAlt(_localctx, 2)
		 		setState(34)
		 		try match(ObjectiveCPreprocessorParser.Tokens.IF.rawValue)
		 		setState(35)
		 		try preprocessor_expression(0)

		 		break

		 	case .ELIF:
		 		_localctx =  PreprocessorConditionalContext(_localctx);
		 		try enterOuterAlt(_localctx, 3)
		 		setState(36)
		 		try match(ObjectiveCPreprocessorParser.Tokens.ELIF.rawValue)
		 		setState(37)
		 		try preprocessor_expression(0)

		 		break

		 	case .ELSE:
		 		_localctx =  PreprocessorConditionalContext(_localctx);
		 		try enterOuterAlt(_localctx, 4)
		 		setState(38)
		 		try match(ObjectiveCPreprocessorParser.Tokens.ELSE.rawValue)

		 		break

		 	case .ENDIF:
		 		_localctx =  PreprocessorConditionalContext(_localctx);
		 		try enterOuterAlt(_localctx, 5)
		 		setState(39)
		 		try match(ObjectiveCPreprocessorParser.Tokens.ENDIF.rawValue)

		 		break

		 	case .IFDEF:
		 		_localctx =  PreprocessorDefContext(_localctx);
		 		try enterOuterAlt(_localctx, 6)
		 		setState(40)
		 		try match(ObjectiveCPreprocessorParser.Tokens.IFDEF.rawValue)
		 		setState(41)
		 		try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

		 		break

		 	case .IFNDEF:
		 		_localctx =  PreprocessorDefContext(_localctx);
		 		try enterOuterAlt(_localctx, 7)
		 		setState(42)
		 		try match(ObjectiveCPreprocessorParser.Tokens.IFNDEF.rawValue)
		 		setState(43)
		 		try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

		 		break

		 	case .UNDEF:
		 		_localctx =  PreprocessorDefContext(_localctx);
		 		try enterOuterAlt(_localctx, 8)
		 		setState(44)
		 		try match(ObjectiveCPreprocessorParser.Tokens.UNDEF.rawValue)
		 		setState(45)
		 		try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)

		 		break

		 	case .PRAGMA:
		 		_localctx =  PreprocessorPragmaContext(_localctx);
		 		try enterOuterAlt(_localctx, 9)
		 		setState(46)
		 		try match(ObjectiveCPreprocessorParser.Tokens.PRAGMA.rawValue)
		 		setState(47)
		 		try directive_text()

		 		break

		 	case .ERROR:
		 		_localctx =  PreprocessorErrorContext(_localctx);
		 		try enterOuterAlt(_localctx, 10)
		 		setState(48)
		 		try match(ObjectiveCPreprocessorParser.Tokens.ERROR.rawValue)
		 		setState(49)
		 		try directive_text()

		 		break

		 	case .WARNING:
		 		_localctx =  PreprocessorWarningContext(_localctx);
		 		try enterOuterAlt(_localctx, 11)
		 		setState(50)
		 		try match(ObjectiveCPreprocessorParser.Tokens.WARNING.rawValue)
		 		setState(51)
		 		try directive_text()

		 		break

		 	case .DEFINE:
		 		_localctx =  PreprocessorDefineContext(_localctx);
		 		try enterOuterAlt(_localctx, 12)
		 		setState(52)
		 		try match(ObjectiveCPreprocessorParser.Tokens.DEFINE.rawValue)
		 		setState(53)
		 		try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
		 		setState(55)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(54)
		 			try directive_text()

		 		}


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
	open class Directive_textContext:ParserRuleContext {
		open func TEXT() -> Array<TerminalNode> { return getTokens(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue) }
		open func TEXT(_ i:Int) -> TerminalNode?{
			return getToken(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue, i)
		}
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_directive_text }
		override
		open func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterDirective_text(self)
			}
		}
		override
		open func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitDirective_text(self)
			}
		}
		override
		open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitDirective_text(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitDirective_text(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	open func directive_text() throws -> Directive_textContext {
		var _localctx: Directive_textContext = Directive_textContext(_ctx, getState())
		try enterRule(_localctx, 8, ObjectiveCPreprocessorParser.RULE_directive_text)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(60) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(59)
		 		try match(ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue)


		 		setState(62); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.TEXT.rawValue
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

	open class Preprocessor_expressionContext:ParserRuleContext {
		open override func getRuleIndex() -> Int { return ObjectiveCPreprocessorParser.RULE_preprocessor_expression }
	 
		public  func copyFrom(_ ctx: Preprocessor_expressionContext) {
			super.copyFrom(ctx)
		}
	}
	public  final class PreprocessorParenthesisContext: Preprocessor_expressionContext {
		public func LPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0) }
		public func preprocessor_expression() -> Preprocessor_expressionContext? {
			return getRuleContext(Preprocessor_expressionContext.self,0)
		}
		public func RPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0) }
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorParenthesis(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorParenthesis(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorParenthesis(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorParenthesis(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorNotContext: Preprocessor_expressionContext {
        public func BANG() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.BANG.rawValue, 0) }
        public func preprocessor_expression() -> Preprocessor_expressionContext? {
			return getRuleContext(Preprocessor_expressionContext.self,0)
		}
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorNot(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorNot(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorNot(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorNot(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorBinaryContext: Preprocessor_expressionContext {
		public var op: Token!
        public func preprocessor_expression() -> Array<Preprocessor_expressionContext> {
			return getRuleContexts(Preprocessor_expressionContext.self)
		}
        public func preprocessor_expression(_ i: Int) -> Preprocessor_expressionContext? {
			return getRuleContext(Preprocessor_expressionContext.self,i)
		}
        public func EQUAL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.EQUAL.rawValue, 0) }
        public func NOTEQUAL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.NOTEQUAL.rawValue, 0) }
        public func AND() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.AND.rawValue, 0) }
        public func OR() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.OR.rawValue, 0) }
        public func LT() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.LT.rawValue, 0) }
        public func GT() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.GT.rawValue, 0) }
        public func LE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.LE.rawValue, 0) }
        public func GE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.GE.rawValue, 0) }
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorBinary(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorBinary(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorBinary(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorBinary(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorConstantContext: Preprocessor_expressionContext {
        public func TRUE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.TRUE.rawValue, 0) }
        public func FALSE() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.FALSE.rawValue, 0) }
        public func DECIMAL_LITERAL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.DECIMAL_LITERAL.rawValue, 0) }
        public func DIRECTIVE_STRING() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue, 0) }
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorConstant(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorConstant(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorConstant(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorConstant(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorConditionalSymbolContext: Preprocessor_expressionContext {
        public func CONDITIONAL_SYMBOL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0) }
        public func LPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0) }
        public func preprocessor_expression() -> Preprocessor_expressionContext? {
			return getRuleContext(Preprocessor_expressionContext.self,0)
		}
        public func RPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0) }
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorConditionalSymbol(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorConditionalSymbol(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorConditionalSymbol(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorConditionalSymbol(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	public  final class PreprocessorDefinedContext: Preprocessor_expressionContext {
        public func DEFINED() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.DEFINED.rawValue, 0) }
        public func CONDITIONAL_SYMBOL() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue, 0) }
        public func LPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.LPAREN.rawValue, 0) }
        public func RPAREN() -> TerminalNode? { return getToken(ObjectiveCPreprocessorParser.Tokens.RPAREN.rawValue, 0) }
		public init(_ ctx: Preprocessor_expressionContext) {
			super.init()
			copyFrom(ctx)
		}
		override
		public func enterRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).enterPreprocessorDefined(self)
			}
		}
		override
		public func exitRule(_ listener: ParseTreeListener) {
			if listener is ObjectiveCPreprocessorParserListener {
			 	(listener as! ObjectiveCPreprocessorParserListener).exitPreprocessorDefined(self)
			}
		}
		override
		public func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if visitor is ObjectiveCPreprocessorParserVisitor {
			     return (visitor as! ObjectiveCPreprocessorParserVisitor<T>).visitPreprocessorDefined(self)
			}else if visitor is ObjectiveCPreprocessorParserBaseVisitor {
		    	 return (visitor as! ObjectiveCPreprocessorParserBaseVisitor<T>).visitPreprocessorDefined(self)
		    }
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	public final  func preprocessor_expression( ) throws -> Preprocessor_expressionContext   {
		return try preprocessor_expression(0)
	}
	@discardableResult
	private func preprocessor_expression(_ _p: Int) throws -> Preprocessor_expressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		var _parentState: Int = getState()
		var _localctx: Preprocessor_expressionContext = Preprocessor_expressionContext(_ctx, _parentState)
		var  _prevctx: Preprocessor_expressionContext = _localctx
		var _startState: Int = 10
		try enterRecursionRule(_localctx, 10, ObjectiveCPreprocessorParser.RULE_preprocessor_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(89)
			try _errHandler.sync(self)
			switch (ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))!) {
			case .TRUE:
				_localctx = PreprocessorConstantContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx

				setState(65)
				try match(ObjectiveCPreprocessorParser.Tokens.TRUE.rawValue)

				break

			case .FALSE:
				_localctx = PreprocessorConstantContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(66)
				try match(ObjectiveCPreprocessorParser.Tokens.FALSE.rawValue)

				break

			case .DECIMAL_LITERAL:
				_localctx = PreprocessorConstantContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(67)
				try match(ObjectiveCPreprocessorParser.Tokens.DECIMAL_LITERAL.rawValue)

				break

			case .DIRECTIVE_STRING:
				_localctx = PreprocessorConstantContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(68)
				try match(ObjectiveCPreprocessorParser.Tokens.DIRECTIVE_STRING.rawValue)

				break

			case .CONDITIONAL_SYMBOL:
				_localctx = PreprocessorConditionalSymbolContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(69)
				try match(ObjectiveCPreprocessorParser.Tokens.CONDITIONAL_SYMBOL.rawValue)
				setState(74)
				try _errHandler.sync(self)
				switch (try getInterpreter().adaptivePredict(_input,6,_ctx)) {
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
				_prevctx = _localctx
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
				_prevctx = _localctx
				setState(80)
				try match(ObjectiveCPreprocessorParser.Tokens.BANG.rawValue)
				setState(81)
				try preprocessor_expression(6)

				break

			case .DEFINED:
				_localctx = PreprocessorDefinedContext(_localctx)
				_ctx = _localctx
				_prevctx = _localctx
				setState(82)
				try match(ObjectiveCPreprocessorParser.Tokens.DEFINED.rawValue)
				setState(87)
				try _errHandler.sync(self)
				switch (ObjectiveCPreprocessorParser.Tokens(rawValue: try _input.LA(1))!) {
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
				default:
					throw ANTLRException.recognition(e: NoViableAltException(self))
				}

				break
			default:
				throw ANTLRException.recognition(e: NoViableAltException(self))
			}
			_ctx!.stop = try _input.LT(-1)
			setState(105)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,10,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_prevctx = _localctx
					setState(103)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,9, _ctx)) {
					case 1:
						_localctx = PreprocessorBinaryContext(  Preprocessor_expressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
						setState(91)
						if (!(precpred(_ctx, 5))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 5)"))
						}
						setState(92)
						_localctx.castdown(PreprocessorBinaryContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == ObjectiveCPreprocessorParser.Tokens.EQUAL.rawValue || _la == ObjectiveCPreprocessorParser.Tokens.NOTEQUAL.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(PreprocessorBinaryContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(93)
						try preprocessor_expression(6)

						break
					case 2:
						_localctx = PreprocessorBinaryContext(  Preprocessor_expressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
						setState(94)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(95)
						try {
								let assignmentValue = try match(ObjectiveCPreprocessorParser.Tokens.AND.rawValue)
								_localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
						     }()

						setState(96)
						try preprocessor_expression(5)

						break
					case 3:
						_localctx = PreprocessorBinaryContext(  Preprocessor_expressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
						setState(97)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(98)
						try {
								let assignmentValue = try match(ObjectiveCPreprocessorParser.Tokens.OR.rawValue)
								_localctx.castdown(PreprocessorBinaryContext.self).op = assignmentValue
						     }()

						setState(99)
						try preprocessor_expression(4)

						break
					case 4:
						_localctx = PreprocessorBinaryContext(  Preprocessor_expressionContext(_parentctx, _parentState))
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCPreprocessorParser.RULE_preprocessor_expression)
						setState(100)
						if (!(precpred(_ctx, 2))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 2)"))
						}
						setState(101)
						_localctx.castdown(PreprocessorBinaryContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, ObjectiveCPreprocessorParser.Tokens.LT.rawValue,ObjectiveCPreprocessorParser.Tokens.GT.rawValue,ObjectiveCPreprocessorParser.Tokens.LE.rawValue,ObjectiveCPreprocessorParser.Tokens.GE.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(PreprocessorBinaryContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
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
				_alt = try getInterpreter().adaptivePredict(_input,10,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

    override
	open func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  5:
			return try preprocessor_expression_sempred(_localctx?.castdown(Preprocessor_expressionContext.self), predIndex)
	    default: return true
		}
	}
	private func preprocessor_expression_sempred(_ _localctx: Preprocessor_expressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 5)
		    case 1:return precpred(_ctx, 4)
		    case 2:return precpred(_ctx, 3)
		    case 3:return precpred(_ctx, 2)
		    default: return true
		}
	}

    public static let _serializedATN : String = ObjectiveCPreprocessorParserATN().jsonString
}
