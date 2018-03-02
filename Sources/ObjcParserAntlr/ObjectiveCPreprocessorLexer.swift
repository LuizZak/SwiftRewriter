// Generated from /Users/luizsilva/Desktop/grammars-v4-master/objc/two-step-processing/ObjectiveCPreprocessorLexer.g4 by ANTLR 4.7
import Antlr4

open class ObjectiveCPreprocessorLexer: Lexer {
	internal static var _decisionToDFA: [DFA] = {
          var decisionToDFA = [DFA]()
          let length = ObjectiveCPreprocessorLexer._ATN.getNumberOfDecisions()
          for i in 0..<length {
          	    decisionToDFA.append(DFA(ObjectiveCPreprocessorLexer._ATN.getDecisionState(i)!, i))
          }
           return decisionToDFA
     }()

	internal static let _sharedContextCache:PredictionContextCache = PredictionContextCache()
	public static let SHARP=1, CODE=2, IMPORT=3, INCLUDE=4, PRAGMA=5, DEFINE=6, 
                   DEFINED=7, IF=8, ELIF=9, ELSE=10, UNDEF=11, IFDEF=12, 
                   IFNDEF=13, ENDIF=14, TRUE=15, FALSE=16, ERROR=17, WARNING=18, 
                   BANG=19, LPAREN=20, RPAREN=21, EQUAL=22, NOTEQUAL=23, 
                   AND=24, OR=25, LT=26, GT=27, LE=28, GE=29, DIRECTIVE_WHITESPACES=30, 
                   DIRECTIVE_STRING=31, CONDITIONAL_SYMBOL=32, DECIMAL_LITERAL=33, 
                   FLOAT=34, NEW_LINE=35, DIRECITVE_COMMENT=36, DIRECITVE_LINE_COMMENT=37, 
                   DIRECITVE_NEW_LINE=38, DIRECITVE_TEXT_NEW_LINE=39, TEXT=40, 
                   SLASH=41
	public static let COMMENTS_CHANNEL=2
	public static let DIRECTIVE_MODE=1, DIRECTIVE_DEFINE=2, DIRECTIVE_TEXT=3
	public static let channelNames: [String] = [
		"DEFAULT_TOKEN_CHANNEL", "HIDDEN", "COMMENTS_CHANNEL"
	]

	public static let modeNames: [String] = [
		"DEFAULT_MODE", "DIRECTIVE_MODE", "DIRECTIVE_DEFINE", "DIRECTIVE_TEXT"
	]

	public static let ruleNames: [String] = [
		"SHARP", "COMMENT", "LINE_COMMENT", "SLASH", "CHARACTER_LITERAL", "QUOTE_STRING", 
		"STRING", "CODE", "IMPORT", "INCLUDE", "PRAGMA", "DEFINE", "DEFINED", 
		"IF", "ELIF", "ELSE", "UNDEF", "IFDEF", "IFNDEF", "ENDIF", "TRUE", "FALSE", 
		"ERROR", "WARNING", "BANG", "LPAREN", "RPAREN", "EQUAL", "NOTEQUAL", "AND", 
		"OR", "LT", "GT", "LE", "GE", "DIRECTIVE_WHITESPACES", "DIRECTIVE_STRING", 
		"CONDITIONAL_SYMBOL", "DECIMAL_LITERAL", "FLOAT", "NEW_LINE", "DIRECITVE_COMMENT", 
		"DIRECITVE_LINE_COMMENT", "DIRECITVE_NEW_LINE", "DIRECTIVE_DEFINE_CONDITIONAL_SYMBOL", 
		"DIRECITVE_TEXT_NEW_LINE", "BACK_SLASH_ESCAPE", "TEXT_NEW_LINE", "DIRECTIVE_COMMENT", 
		"DIRECTIVE_LINE_COMMENT", "DIRECTIVE_SLASH", "TEXT", "EscapeSequence", 
		"OctalEscape", "UnicodeEscape", "HexDigit", "StringFragment", "LETTER", 
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", 
		"O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
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

    open override func getVocabulary() -> Vocabulary {
        return ObjectiveCPreprocessorLexer.VOCABULARY
    }

	public required init(_ input: CharStream) {
	    RuntimeMetaData.checkVersion("4.7", RuntimeMetaData.VERSION)
		super.init(input)
		_interp = LexerATNSimulator(self, ObjectiveCPreprocessorLexer._ATN, ObjectiveCPreprocessorLexer._decisionToDFA, ObjectiveCPreprocessorLexer._sharedContextCache)
	}

	override
	open func getGrammarFileName() -> String { return "ObjectiveCPreprocessorLexer.g4" }

    override
	open func getRuleNames() -> [String] { return ObjectiveCPreprocessorLexer.ruleNames }

	override
	open func getSerializedATN() -> String { return ObjectiveCPreprocessorLexer._serializedATN }

	override
	open func getChannelNames() -> [String] { return ObjectiveCPreprocessorLexer.channelNames }

	override
	open func getModeNames() -> [String] { return ObjectiveCPreprocessorLexer.modeNames }

	override
	open func getATN() -> ATN { return ObjectiveCPreprocessorLexer._ATN }

    public static let _serializedATN: String = ObjectiveCPreprocessorLexerATN().jsonString
	public static let _ATN: ATN = ATNDeserializer().deserializeFromJson(_serializedATN)
}
