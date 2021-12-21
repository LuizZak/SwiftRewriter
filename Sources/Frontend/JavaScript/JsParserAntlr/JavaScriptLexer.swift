// Generated from JavaScriptLexer.g4 by ANTLR 4.9.3
import Antlr4

open class JavaScriptLexer: JavaScriptLexerBase {
    public class State {
        public let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
        
        internal var _decisionToDFA: [DFALexer]
        internal let _sharedContextCache: PredictionContextCache = PredictionContextCache()
        // let atnConfigPool: LexerATNConfigPool = LexerATNConfigPool()
        
        public init() {
            var decisionToDFA = [DFALexer]()
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
    internal var _decisionToDFA: [DFALexer] {
        return state._decisionToDFA
    }
    internal var _sharedContextCache: PredictionContextCache {
        return state._sharedContextCache
    }
    
    public var state: State

	public
	static let HashBangLine=1, MultiLineComment=2, SingleLineComment=3, RegularExpressionLiteral=4, 
            OpenBracket=5, CloseBracket=6, OpenParen=7, CloseParen=8, OpenBrace=9, 
            TemplateCloseBrace=10, CloseBrace=11, SemiColon=12, Comma=13, 
            Assign=14, QuestionMark=15, Colon=16, Ellipsis=17, Dot=18, PlusPlus=19, 
            MinusMinus=20, Plus=21, Minus=22, BitNot=23, Not=24, Multiply=25, 
            Divide=26, Modulus=27, Power=28, NullCoalesce=29, Hashtag=30, 
            RightShiftArithmetic=31, LeftShiftArithmetic=32, RightShiftLogical=33, 
            LessThan=34, MoreThan=35, LessThanEquals=36, GreaterThanEquals=37, 
            Equals_=38, NotEquals=39, IdentityEquals=40, IdentityNotEquals=41, 
            BitAnd=42, BitXOr=43, BitOr=44, And=45, Or=46, MultiplyAssign=47, 
            DivideAssign=48, ModulusAssign=49, PlusAssign=50, MinusAssign=51, 
            LeftShiftArithmeticAssign=52, RightShiftArithmeticAssign=53, 
            RightShiftLogicalAssign=54, BitAndAssign=55, BitXorAssign=56, 
            BitOrAssign=57, PowerAssign=58, ARROW=59, NullLiteral=60, BooleanLiteral=61, 
            DecimalLiteral=62, HexIntegerLiteral=63, OctalIntegerLiteral=64, 
            OctalIntegerLiteral2=65, BinaryIntegerLiteral=66, BigHexIntegerLiteral=67, 
            BigOctalIntegerLiteral=68, BigBinaryIntegerLiteral=69, BigDecimalIntegerLiteral=70, 
            Break=71, Do=72, Instanceof=73, Typeof=74, Case=75, Else=76, 
            New=77, Var=78, Catch=79, Finally=80, Return=81, Void=82, Continue=83, 
            For=84, Switch=85, While=86, Debugger=87, Function_=88, This=89, 
            With=90, Default=91, If=92, Throw=93, Delete=94, In=95, Try=96, 
            As=97, From=98, Class=99, Enum=100, Extends=101, Super=102, 
            Const=103, Export=104, Import=105, Async=106, Await=107, Implements=108, 
            StrictLet=109, NonStrictLet=110, Private=111, Public=112, Interface=113, 
            Package=114, Protected=115, Static=116, Yield=117, Identifier=118, 
            StringLiteral=119, BackTick=120, WhiteSpaces=121, LineTerminator=122, 
            HtmlComment=123, CDataComment=124, UnexpectedCharacter=125, 
            TemplateStringStartExpression=126, TemplateStringAtom=127

	public
	static let ERROR=2
	public
	static let TEMPLATE=1
	public
	static let channelNames: [String] = [
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN", "ERROR"
	]

	public
	static let modeNames: [String] = [
		"DEFAULT_MODE", "TEMPLATE"
	]

	public
	static let ruleNames: [String] = [
		"HashBangLine", "MultiLineComment", "SingleLineComment", "RegularExpressionLiteral", 
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
		"BackTickInside", "TemplateStringStartExpression", "TemplateStringAtom", 
		"DoubleStringCharacter", "SingleStringCharacter", "EscapeSequence", "CharacterEscapeSequence", 
		"HexEscapeSequence", "UnicodeEscapeSequence", "ExtendedUnicodeEscapeSequence", 
		"SingleEscapeCharacter", "NonEscapeCharacter", "EscapeCharacter", "LineContinuation", 
		"HexDigit", "DecimalIntegerLiteral", "ExponentPart", "IdentifierPart", 
		"IdentifierStart", "RegularExpressionFirstChar", "RegularExpressionChar", 
		"RegularExpressionClassChar", "RegularExpressionBackslashSequence"
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
	func getVocabulary() -> Vocabulary {
		return JavaScriptLexer.VOCABULARY
	}

	public required convenience
    init(_ input: CharStream) {
        self.init(input, State())
    }

	public
	required init(_ input: CharStream, _ state: State) {
        self.state = state
        
	    RuntimeMetaData.checkVersion("4.9.3", RuntimeMetaData.VERSION)
		super.init(input)
		_interp = LexerATNSimulator(
			self,
			_ATN,
			_decisionToDFA,
			_sharedContextCache //, lexerAtnConfigPool: state.atnConfigPool
		)
	}

	override open
	func getGrammarFileName() -> String { return "JavaScriptLexer.g4" }

	override open
	func getRuleNames() -> [String] { return JavaScriptLexer.ruleNames }

	override open
	func getSerializedATN() -> String { return JavaScriptLexer._serializedATN }

	override open
	func getChannelNames() -> [String] { return JavaScriptLexer.channelNames }

	override open
	func getModeNames() -> [String] { return JavaScriptLexer.modeNames }

	override open
	func getATN() -> ATN { return _ATN }

	override open
	func action(_ _localctx: RuleContext?,  _ ruleIndex: Int, _ actionIndex: Int) throws {
		switch (ruleIndex) {
		case 8:
			OpenBrace_action((_localctx as RuleContext?), actionIndex)

		case 10:
			CloseBrace_action((_localctx as RuleContext?), actionIndex)

		case 118:
			StringLiteral_action((_localctx as RuleContext?), actionIndex)

		case 119:
			BackTick_action((_localctx as RuleContext?), actionIndex)

		case 125:
			BackTickInside_action((_localctx as RuleContext?), actionIndex)

		default: break
		}
	}
	private func OpenBrace_action(_ _localctx: RuleContext?,  _ actionIndex: Int) {
		switch (actionIndex) {
		case 0:
			self.processOpenBrace();

		 default: break
		}
	}
	private func CloseBrace_action(_ _localctx: RuleContext?,  _ actionIndex: Int) {
		switch (actionIndex) {
		case 1:
			self.processCloseBrace();

		 default: break
		}
	}
	private func StringLiteral_action(_ _localctx: RuleContext?,  _ actionIndex: Int) {
		switch (actionIndex) {
		case 2:
			self.processStringLiteral();

		 default: break
		}
	}
	private func BackTick_action(_ _localctx: RuleContext?,  _ actionIndex: Int) {
		switch (actionIndex) {
		case 3:
			self.increaseTemplateDepth();

		 default: break
		}
	}
	private func BackTickInside_action(_ _localctx: RuleContext?,  _ actionIndex: Int) {
		switch (actionIndex) {
		case 4:
			self.decreaseTemplateDepth();

		 default: break
		}
	}
	override open
	func sempred(_ _localctx: RuleContext?, _  ruleIndex: Int,_   predIndex: Int) throws -> Bool {
		switch (ruleIndex) {
		case 0:
			return try HashBangLine_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 3:
			return try RegularExpressionLiteral_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 9:
			return try TemplateCloseBrace_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 63:
			return try OctalIntegerLiteral_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 107:
			return try Implements_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 108:
			return try StrictLet_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 109:
			return try NonStrictLet_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 110:
			return try Private_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 111:
			return try Public_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 112:
			return try Interface_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 113:
			return try Package_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 114:
			return try Protected_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 115:
			return try Static_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		case 116:
			return try Yield_sempred(_localctx?.castdown(RuleContext.self), predIndex)
		default: return true
		}
	}
	private func HashBangLine_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return self.isStartOfFile()
		    default: return true
		}
	}
	private func RegularExpressionLiteral_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 1:return self.isRegexPossible()
		    default: return true
		}
	}
	private func TemplateCloseBrace_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 2:return self.isInTemplateString()
		    default: return true
		}
	}
	private func OctalIntegerLiteral_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 3:return !self.isStrictMode()
		    default: return true
		}
	}
	private func Implements_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 4:return self.isStrictMode()
		    default: return true
		}
	}
	private func StrictLet_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 5:return self.isStrictMode()
		    default: return true
		}
	}
	private func NonStrictLet_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 6:return !self.isStrictMode()
		    default: return true
		}
	}
	private func Private_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 7:return self.isStrictMode()
		    default: return true
		}
	}
	private func Public_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 8:return self.isStrictMode()
		    default: return true
		}
	}
	private func Interface_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 9:return self.isStrictMode()
		    default: return true
		}
	}
	private func Package_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 10:return self.isStrictMode()
		    default: return true
		}
	}
	private func Protected_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 11:return self.isStrictMode()
		    default: return true
		}
	}
	private func Static_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 12:return self.isStrictMode()
		    default: return true
		}
	}
	private func Yield_sempred(_ _localctx: RuleContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 13:return self.isStrictMode()
		    default: return true
		}
	}


	public
	static let _serializedATN: String = JavaScriptLexerATN().jsonString
}
