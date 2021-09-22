// Generated from /Users/luizfernandosilva/Documents/Projetos/objcgrammar/ObjectiveCParser.g4 by ANTLR 4.9.1
import Antlr4

open class ObjectiveCParser: Parser {

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
		case EOF = -1, AUTO = 1, BREAK = 2, CASE = 3, CHAR = 4, CONST = 5, CONTINUE = 6, 
                 DEFAULT = 7, DO = 8, DOUBLE = 9, ELSE = 10, ENUM = 11, 
                 EXTERN = 12, FLOAT = 13, FOR = 14, GOTO = 15, IF = 16, 
                 INLINE = 17, INT = 18, LONG = 19, REGISTER = 20, RESTRICT = 21, 
                 RETURN = 22, SHORT = 23, SIGNED = 24, SIZEOF = 25, STATIC = 26, 
                 STRUCT = 27, SWITCH = 28, TYPEDEF = 29, UNION = 30, UNSIGNED = 31, 
                 VOID = 32, VOLATILE = 33, WHILE = 34, BOOL_ = 35, COMPLEX = 36, 
                 IMAGINERY = 37, TRUE = 38, FALSE = 39, BOOL = 40, Class = 41, 
                 BYCOPY = 42, BYREF = 43, ID = 44, IMP = 45, IN = 46, INOUT = 47, 
                 NIL = 48, NO = 49, NULL = 50, ONEWAY = 51, OUT = 52, PROTOCOL_ = 53, 
                 SEL = 54, SELF = 55, SUPER = 56, YES = 57, AUTORELEASEPOOL = 58, 
                 CATCH = 59, CLASS = 60, DYNAMIC = 61, ENCODE = 62, END = 63, 
                 FINALLY = 64, IMPLEMENTATION = 65, INTERFACE = 66, IMPORT = 67, 
                 PACKAGE = 68, PROTOCOL = 69, OPTIONAL = 70, PRIVATE = 71, 
                 PROPERTY = 72, PROTECTED = 73, PUBLIC = 74, REQUIRED = 75, 
                 SELECTOR = 76, SYNCHRONIZED = 77, SYNTHESIZE = 78, THROW = 79, 
                 TRY = 80, ATOMIC = 81, NONATOMIC = 82, RETAIN = 83, ATTRIBUTE = 84, 
                 AUTORELEASING_QUALIFIER = 85, BLOCK = 86, BRIDGE = 87, 
                 BRIDGE_RETAINED = 88, BRIDGE_TRANSFER = 89, COVARIANT = 90, 
                 CONTRAVARIANT = 91, DEPRECATED = 92, KINDOF = 93, STRONG_QUALIFIER = 94, 
                 TYPEOF = 95, UNSAFE_UNRETAINED_QUALIFIER = 96, UNUSED = 97, 
                 WEAK_QUALIFIER = 98, NULL_UNSPECIFIED = 99, NULLABLE = 100, 
                 NONNULL = 101, NULL_RESETTABLE = 102, NS_INLINE = 103, 
                 NS_ENUM = 104, NS_OPTIONS = 105, ASSIGN = 106, COPY = 107, 
                 GETTER = 108, SETTER = 109, STRONG = 110, READONLY = 111, 
                 READWRITE = 112, WEAK = 113, UNSAFE_UNRETAINED = 114, IB_OUTLET = 115, 
                 IB_OUTLET_COLLECTION = 116, IB_INSPECTABLE = 117, IB_DESIGNABLE = 118, 
                 NS_ASSUME_NONNULL_BEGIN = 119, NS_ASSUME_NONNULL_END = 120, 
                 EXTERN_SUFFIX = 121, IOS_SUFFIX = 122, MAC_SUFFIX = 123, 
                 TVOS_PROHIBITED = 124, IDENTIFIER = 125, LP = 126, RP = 127, 
                 LBRACE = 128, RBRACE = 129, LBRACK = 130, RBRACK = 131, 
                 SEMI = 132, COMMA = 133, DOT = 134, STRUCTACCESS = 135, 
                 AT = 136, ASSIGNMENT = 137, GT = 138, LT = 139, BANG = 140, 
                 TILDE = 141, QUESTION = 142, COLON = 143, EQUAL = 144, 
                 LE = 145, GE = 146, NOTEQUAL = 147, AND = 148, OR = 149, 
                 INC = 150, DEC = 151, ADD = 152, SUB = 153, MUL = 154, 
                 DIV = 155, BITAND = 156, BITOR = 157, BITXOR = 158, MOD = 159, 
                 ADD_ASSIGN = 160, SUB_ASSIGN = 161, MUL_ASSIGN = 162, DIV_ASSIGN = 163, 
                 AND_ASSIGN = 164, OR_ASSIGN = 165, XOR_ASSIGN = 166, MOD_ASSIGN = 167, 
                 LSHIFT_ASSIGN = 168, RSHIFT_ASSIGN = 169, ELIPSIS = 170, 
                 CHARACTER_LITERAL = 171, STRING_START = 172, HEX_LITERAL = 173, 
                 OCTAL_LITERAL = 174, BINARY_LITERAL = 175, DECIMAL_LITERAL = 176, 
                 FLOATING_POINT_LITERAL = 177, WS = 178, MULTI_COMMENT = 179, 
                 SINGLE_COMMENT = 180, BACKSLASH = 181, SHARP = 182, STRING_NEWLINE = 183, 
                 STRING_END = 184, STRING_VALUE = 185, PATH = 186, DIRECTIVE_IMPORT = 187, 
                 DIRECTIVE_INCLUDE = 188, DIRECTIVE_PRAGMA = 189, DIRECTIVE_DEFINE = 190, 
                 DIRECTIVE_DEFINED = 191, DIRECTIVE_IF = 192, DIRECTIVE_ELIF = 193, 
                 DIRECTIVE_ELSE = 194, DIRECTIVE_UNDEF = 195, DIRECTIVE_IFDEF = 196, 
                 DIRECTIVE_IFNDEF = 197, DIRECTIVE_ENDIF = 198, DIRECTIVE_TRUE = 199, 
                 DIRECTIVE_FALSE = 200, DIRECTIVE_ERROR = 201, DIRECTIVE_WARNING = 202, 
                 DIRECTIVE_HASINCLUDE = 203, DIRECTIVE_BANG = 204, DIRECTIVE_LP = 205, 
                 DIRECTIVE_RP = 206, DIRECTIVE_EQUAL = 207, DIRECTIVE_NOTEQUAL = 208, 
                 DIRECTIVE_AND = 209, DIRECTIVE_OR = 210, DIRECTIVE_LT = 211, 
                 DIRECTIVE_GT = 212, DIRECTIVE_LE = 213, DIRECTIVE_GE = 214, 
                 DIRECTIVE_STRING = 215, DIRECTIVE_ID = 216, DIRECTIVE_DECIMAL_LITERAL = 217, 
                 DIRECTIVE_FLOAT = 218, DIRECTIVE_NEWLINE = 219, DIRECTIVE_MULTI_COMMENT = 220, 
                 DIRECTIVE_SINGLE_COMMENT = 221, DIRECTIVE_BACKSLASH_NEWLINE = 222, 
                 DIRECTIVE_TEXT_NEWLINE = 223, DIRECTIVE_TEXT = 224, DIRECTIVE_PATH = 225, 
                 DIRECTIVE_PATH_STRING = 226
	}

	public
	static let RULE_translationUnit = 0, RULE_topLevelDeclaration = 1, RULE_importDeclaration = 2, 
            RULE_classInterface = 3, RULE_classInterfaceName = 4, RULE_categoryInterface = 5, 
            RULE_classImplementation = 6, RULE_classImplementatioName = 7, 
            RULE_categoryImplementation = 8, RULE_className = 9, RULE_superclassName = 10, 
            RULE_genericSuperclassName = 11, RULE_genericTypeSpecifier = 12, 
            RULE_genericSuperclassSpecifier = 13, RULE_superclassTypeSpecifierWithPrefixes = 14, 
            RULE_protocolDeclaration = 15, RULE_protocolDeclarationSection = 16, 
            RULE_protocolDeclarationList = 17, RULE_classDeclarationList = 18, 
            RULE_protocolList = 19, RULE_propertyDeclaration = 20, RULE_propertyAttributesList = 21, 
            RULE_propertyAttribute = 22, RULE_protocolName = 23, RULE_instanceVariables = 24, 
            RULE_visibilitySection = 25, RULE_accessModifier = 26, RULE_interfaceDeclarationList = 27, 
            RULE_classMethodDeclaration = 28, RULE_instanceMethodDeclaration = 29, 
            RULE_methodDeclaration = 30, RULE_implementationDefinitionList = 31, 
            RULE_classMethodDefinition = 32, RULE_instanceMethodDefinition = 33, 
            RULE_methodDefinition = 34, RULE_methodSelector = 35, RULE_keywordDeclarator = 36, 
            RULE_selector = 37, RULE_methodType = 38, RULE_propertyImplementation = 39, 
            RULE_propertySynthesizeList = 40, RULE_propertySynthesizeItem = 41, 
            RULE_blockType = 42, RULE_genericsSpecifier = 43, RULE_typeSpecifierWithPrefixes = 44, 
            RULE_dictionaryExpression = 45, RULE_dictionaryPair = 46, RULE_arrayExpression = 47, 
            RULE_boxExpression = 48, RULE_blockParameters = 49, RULE_typeVariableDeclaratorOrName = 50, 
            RULE_blockExpression = 51, RULE_messageExpression = 52, RULE_receiver = 53, 
            RULE_messageSelector = 54, RULE_keywordArgument = 55, RULE_keywordArgumentType = 56, 
            RULE_selectorExpression = 57, RULE_selectorName = 58, RULE_protocolExpression = 59, 
            RULE_encodeExpression = 60, RULE_typeVariableDeclarator = 61, 
            RULE_throwStatement = 62, RULE_tryBlock = 63, RULE_catchStatement = 64, 
            RULE_synchronizedStatement = 65, RULE_autoreleaseStatement = 66, 
            RULE_functionDeclaration = 67, RULE_functionDefinition = 68, 
            RULE_functionSignature = 69, RULE_attribute = 70, RULE_attributeName = 71, 
            RULE_attributeParameters = 72, RULE_attributeParameterList = 73, 
            RULE_attributeParameter = 74, RULE_attributeParameterAssignment = 75, 
            RULE_declaration = 76, RULE_functionPointer = 77, RULE_functionPointerParameterList = 78, 
            RULE_functionPointerParameterDeclarationList = 79, RULE_functionPointerParameterDeclaration = 80, 
            RULE_functionCallExpression = 81, RULE_enumDeclaration = 82, 
            RULE_varDeclaration = 83, RULE_typedefDeclaration = 84, RULE_typeDeclaratorList = 85, 
            RULE_declarationSpecifiers = 86, RULE_attributeSpecifier = 87, 
            RULE_initDeclaratorList = 88, RULE_initDeclarator = 89, RULE_structOrUnionSpecifier = 90, 
            RULE_fieldDeclaration = 91, RULE_specifierQualifierList = 92, 
            RULE_ibOutletQualifier = 93, RULE_arcBehaviourSpecifier = 94, 
            RULE_nullabilitySpecifier = 95, RULE_storageClassSpecifier = 96, 
            RULE_typePrefix = 97, RULE_typeQualifier = 98, RULE_protocolQualifier = 99, 
            RULE_typeSpecifier = 100, RULE_scalarTypeSpecifier = 101, RULE_typeofExpression = 102, 
            RULE_fieldDeclaratorList = 103, RULE_fieldDeclarator = 104, 
            RULE_enumSpecifier = 105, RULE_enumeratorList = 106, RULE_enumerator = 107, 
            RULE_enumeratorIdentifier = 108, RULE_directDeclarator = 109, 
            RULE_declaratorSuffix = 110, RULE_parameterList = 111, RULE_pointer = 112, 
            RULE_macro = 113, RULE_arrayInitializer = 114, RULE_structInitializer = 115, 
            RULE_structInitializerItem = 116, RULE_initializerList = 117, 
            RULE_typeName = 118, RULE_abstractDeclarator = 119, RULE_abstractDeclaratorSuffix = 120, 
            RULE_parameterDeclarationList = 121, RULE_parameterDeclaration = 122, 
            RULE_declarator = 123, RULE_statement = 124, RULE_labeledStatement = 125, 
            RULE_rangeExpression = 126, RULE_compoundStatement = 127, RULE_selectionStatement = 128, 
            RULE_switchStatement = 129, RULE_switchBlock = 130, RULE_switchSection = 131, 
            RULE_switchLabel = 132, RULE_iterationStatement = 133, RULE_whileStatement = 134, 
            RULE_doStatement = 135, RULE_forStatement = 136, RULE_forLoopInitializer = 137, 
            RULE_forInStatement = 138, RULE_jumpStatement = 139, RULE_expressions = 140, 
            RULE_expression = 141, RULE_assignmentOperator = 142, RULE_castExpression = 143, 
            RULE_initializer = 144, RULE_constantExpression = 145, RULE_unaryExpression = 146, 
            RULE_unaryOperator = 147, RULE_postfixExpression = 148, RULE_postfixExpr = 149, 
            RULE_argumentExpressionList = 150, RULE_argumentExpression = 151, 
            RULE_primaryExpression = 152, RULE_constant = 153, RULE_stringLiteral = 154, 
            RULE_identifier = 155

	public
	static let ruleNames: [String] = [
		"translationUnit", "topLevelDeclaration", "importDeclaration", "classInterface", 
		"classInterfaceName", "categoryInterface", "classImplementation", "classImplementatioName", 
		"categoryImplementation", "className", "superclassName", "genericSuperclassName", 
		"genericTypeSpecifier", "genericSuperclassSpecifier", "superclassTypeSpecifierWithPrefixes", 
		"protocolDeclaration", "protocolDeclarationSection", "protocolDeclarationList", 
		"classDeclarationList", "protocolList", "propertyDeclaration", "propertyAttributesList", 
		"propertyAttribute", "protocolName", "instanceVariables", "visibilitySection", 
		"accessModifier", "interfaceDeclarationList", "classMethodDeclaration", 
		"instanceMethodDeclaration", "methodDeclaration", "implementationDefinitionList", 
		"classMethodDefinition", "instanceMethodDefinition", "methodDefinition", 
		"methodSelector", "keywordDeclarator", "selector", "methodType", "propertyImplementation", 
		"propertySynthesizeList", "propertySynthesizeItem", "blockType", "genericsSpecifier", 
		"typeSpecifierWithPrefixes", "dictionaryExpression", "dictionaryPair", 
		"arrayExpression", "boxExpression", "blockParameters", "typeVariableDeclaratorOrName", 
		"blockExpression", "messageExpression", "receiver", "messageSelector", 
		"keywordArgument", "keywordArgumentType", "selectorExpression", "selectorName", 
		"protocolExpression", "encodeExpression", "typeVariableDeclarator", "throwStatement", 
		"tryBlock", "catchStatement", "synchronizedStatement", "autoreleaseStatement", 
		"functionDeclaration", "functionDefinition", "functionSignature", "attribute", 
		"attributeName", "attributeParameters", "attributeParameterList", "attributeParameter", 
		"attributeParameterAssignment", "declaration", "functionPointer", "functionPointerParameterList", 
		"functionPointerParameterDeclarationList", "functionPointerParameterDeclaration", 
		"functionCallExpression", "enumDeclaration", "varDeclaration", "typedefDeclaration", 
		"typeDeclaratorList", "declarationSpecifiers", "attributeSpecifier", "initDeclaratorList", 
		"initDeclarator", "structOrUnionSpecifier", "fieldDeclaration", "specifierQualifierList", 
		"ibOutletQualifier", "arcBehaviourSpecifier", "nullabilitySpecifier", 
		"storageClassSpecifier", "typePrefix", "typeQualifier", "protocolQualifier", 
		"typeSpecifier", "scalarTypeSpecifier", "typeofExpression", "fieldDeclaratorList", 
		"fieldDeclarator", "enumSpecifier", "enumeratorList", "enumerator", "enumeratorIdentifier", 
		"directDeclarator", "declaratorSuffix", "parameterList", "pointer", "macro", 
		"arrayInitializer", "structInitializer", "structInitializerItem", "initializerList", 
		"typeName", "abstractDeclarator", "abstractDeclaratorSuffix", "parameterDeclarationList", 
		"parameterDeclaration", "declarator", "statement", "labeledStatement", 
		"rangeExpression", "compoundStatement", "selectionStatement", "switchStatement", 
		"switchBlock", "switchSection", "switchLabel", "iterationStatement", "whileStatement", 
		"doStatement", "forStatement", "forLoopInitializer", "forInStatement", 
		"jumpStatement", "expressions", "expression", "assignmentOperator", "castExpression", 
		"initializer", "constantExpression", "unaryExpression", "unaryOperator", 
		"postfixExpression", "postfixExpr", "argumentExpressionList", "argumentExpression", 
		"primaryExpression", "constant", "stringLiteral", "identifier"
	]

	private static let _LITERAL_NAMES: [String?] = [
		nil, "'auto'", "'break'", "'case'", "'char'", "'const'", "'continue'", 
		"'default'", "'do'", "'double'", nil, "'enum'", "'extern'", "'float'", 
		"'for'", "'goto'", nil, "'inline'", "'int'", "'long'", "'register'", "'restrict'", 
		"'return'", "'short'", "'signed'", "'sizeof'", "'static'", "'struct'", 
		"'switch'", "'typedef'", "'union'", "'unsigned'", "'void'", "'volatile'", 
		"'while'", "'_Bool'", "'_Complex'", "'_Imaginery'", "'true'", "'false'", 
		"'BOOL'", "'Class'", "'bycopy'", "'byref'", "'id'", "'IMP'", "'in'", "'inout'", 
		"'nil'", "'NO'", "'NULL'", "'oneway'", "'out'", "'Protocol'", "'SEL'", 
		"'self'", "'super'", "'YES'", "'@autoreleasepool'", "'@catch'", "'@class'", 
		"'@dynamic'", "'@encode'", "'@end'", "'@finally'", "'@implementation'", 
		"'@interface'", "'@import'", "'@package'", "'@protocol'", "'@optional'", 
		"'@private'", "'@property'", "'@protected'", "'@public'", "'@required'", 
		"'@selector'", "'@synchronized'", "'@synthesize'", "'@throw'", "'@try'", 
		"'atomic'", "'nonatomic'", "'retain'", "'__attribute__'", "'__autoreleasing'", 
		"'__block'", "'__bridge'", "'__bridge_retained'", "'__bridge_transfer'", 
		"'__covariant'", "'__contravariant'", "'__deprecated'", "'__kindof'", 
		"'__strong'", nil, "'__unsafe_unretained'", "'__unused'", "'__weak'", 
		nil, nil, nil, "'null_resettable'", "'NS_INLINE'", "'NS_ENUM'", "'NS_OPTIONS'", 
		"'assign'", "'copy'", "'getter'", "'setter'", "'strong'", "'readonly'", 
		"'readwrite'", "'weak'", "'unsafe_unretained'", "'IBOutlet'", "'IBOutletCollection'", 
		"'IBInspectable'", "'IB_DESIGNABLE'", nil, nil, nil, nil, nil, "'__TVOS_PROHIBITED'", 
		nil, nil, nil, "'{'", "'}'", "'['", "']'", "';'", "','", "'.'", "'->'", 
		"'@'", "'='", nil, nil, nil, "'~'", "'?'", "':'", nil, nil, nil, nil, 
		nil, nil, "'++'", "'--'", "'+'", "'-'", "'*'", "'/'", "'&'", "'|'", "'^'", 
		"'%'", "'+='", "'-='", "'*='", "'/='", "'&='", "'|='", "'^='", "'%='", 
		"'<<='", "'>>='", "'...'", nil, nil, nil, nil, nil, nil, nil, nil, nil, 
		nil, "'\\'", nil, nil, nil, nil, nil, nil, nil, nil, nil, "'defined'", 
		nil, "'elif'", nil, "'undef'", "'ifdef'", "'ifndef'", "'endif'"
	]
	private static let _SYMBOLIC_NAMES: [String?] = [
		nil, "AUTO", "BREAK", "CASE", "CHAR", "CONST", "CONTINUE", "DEFAULT", 
		"DO", "DOUBLE", "ELSE", "ENUM", "EXTERN", "FLOAT", "FOR", "GOTO", "IF", 
		"INLINE", "INT", "LONG", "REGISTER", "RESTRICT", "RETURN", "SHORT", "SIGNED", 
		"SIZEOF", "STATIC", "STRUCT", "SWITCH", "TYPEDEF", "UNION", "UNSIGNED", 
		"VOID", "VOLATILE", "WHILE", "BOOL_", "COMPLEX", "IMAGINERY", "TRUE", 
		"FALSE", "BOOL", "Class", "BYCOPY", "BYREF", "ID", "IMP", "IN", "INOUT", 
		"NIL", "NO", "NULL", "ONEWAY", "OUT", "PROTOCOL_", "SEL", "SELF", "SUPER", 
		"YES", "AUTORELEASEPOOL", "CATCH", "CLASS", "DYNAMIC", "ENCODE", "END", 
		"FINALLY", "IMPLEMENTATION", "INTERFACE", "IMPORT", "PACKAGE", "PROTOCOL", 
		"OPTIONAL", "PRIVATE", "PROPERTY", "PROTECTED", "PUBLIC", "REQUIRED", 
		"SELECTOR", "SYNCHRONIZED", "SYNTHESIZE", "THROW", "TRY", "ATOMIC", "NONATOMIC", 
		"RETAIN", "ATTRIBUTE", "AUTORELEASING_QUALIFIER", "BLOCK", "BRIDGE", "BRIDGE_RETAINED", 
		"BRIDGE_TRANSFER", "COVARIANT", "CONTRAVARIANT", "DEPRECATED", "KINDOF", 
		"STRONG_QUALIFIER", "TYPEOF", "UNSAFE_UNRETAINED_QUALIFIER", "UNUSED", 
		"WEAK_QUALIFIER", "NULL_UNSPECIFIED", "NULLABLE", "NONNULL", "NULL_RESETTABLE", 
		"NS_INLINE", "NS_ENUM", "NS_OPTIONS", "ASSIGN", "COPY", "GETTER", "SETTER", 
		"STRONG", "READONLY", "READWRITE", "WEAK", "UNSAFE_UNRETAINED", "IB_OUTLET", 
		"IB_OUTLET_COLLECTION", "IB_INSPECTABLE", "IB_DESIGNABLE", "NS_ASSUME_NONNULL_BEGIN", 
		"NS_ASSUME_NONNULL_END", "EXTERN_SUFFIX", "IOS_SUFFIX", "MAC_SUFFIX", 
		"TVOS_PROHIBITED", "IDENTIFIER", "LP", "RP", "LBRACE", "RBRACE", "LBRACK", 
		"RBRACK", "SEMI", "COMMA", "DOT", "STRUCTACCESS", "AT", "ASSIGNMENT", 
		"GT", "LT", "BANG", "TILDE", "QUESTION", "COLON", "EQUAL", "LE", "GE", 
		"NOTEQUAL", "AND", "OR", "INC", "DEC", "ADD", "SUB", "MUL", "DIV", "BITAND", 
		"BITOR", "BITXOR", "MOD", "ADD_ASSIGN", "SUB_ASSIGN", "MUL_ASSIGN", "DIV_ASSIGN", 
		"AND_ASSIGN", "OR_ASSIGN", "XOR_ASSIGN", "MOD_ASSIGN", "LSHIFT_ASSIGN", 
		"RSHIFT_ASSIGN", "ELIPSIS", "CHARACTER_LITERAL", "STRING_START", "HEX_LITERAL", 
		"OCTAL_LITERAL", "BINARY_LITERAL", "DECIMAL_LITERAL", "FLOATING_POINT_LITERAL", 
		"WS", "MULTI_COMMENT", "SINGLE_COMMENT", "BACKSLASH", "SHARP", "STRING_NEWLINE", 
		"STRING_END", "STRING_VALUE", "PATH", "DIRECTIVE_IMPORT", "DIRECTIVE_INCLUDE", 
		"DIRECTIVE_PRAGMA", "DIRECTIVE_DEFINE", "DIRECTIVE_DEFINED", "DIRECTIVE_IF", 
		"DIRECTIVE_ELIF", "DIRECTIVE_ELSE", "DIRECTIVE_UNDEF", "DIRECTIVE_IFDEF", 
		"DIRECTIVE_IFNDEF", "DIRECTIVE_ENDIF", "DIRECTIVE_TRUE", "DIRECTIVE_FALSE", 
		"DIRECTIVE_ERROR", "DIRECTIVE_WARNING", "DIRECTIVE_HASINCLUDE", "DIRECTIVE_BANG", 
		"DIRECTIVE_LP", "DIRECTIVE_RP", "DIRECTIVE_EQUAL", "DIRECTIVE_NOTEQUAL", 
		"DIRECTIVE_AND", "DIRECTIVE_OR", "DIRECTIVE_LT", "DIRECTIVE_GT", "DIRECTIVE_LE", 
		"DIRECTIVE_GE", "DIRECTIVE_STRING", "DIRECTIVE_ID", "DIRECTIVE_DECIMAL_LITERAL", 
		"DIRECTIVE_FLOAT", "DIRECTIVE_NEWLINE", "DIRECTIVE_MULTI_COMMENT", "DIRECTIVE_SINGLE_COMMENT", 
		"DIRECTIVE_BACKSLASH_NEWLINE", "DIRECTIVE_TEXT_NEWLINE", "DIRECTIVE_TEXT", 
		"DIRECTIVE_PATH", "DIRECTIVE_PATH_STRING"
	]
	public
	static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

	override open
	func getGrammarFileName() -> String { return "ObjectiveCParser.g4" }

	override open
	func getRuleNames() -> [String] { return ObjectiveCParser.ruleNames }

	override open
	func getSerializedATN() -> String { return ObjectiveCParser._serializedATN }

	override open
	func getATN() -> ATN { return _ATN }


	override open
	func getVocabulary() -> Vocabulary {
	    return ObjectiveCParser.VOCABULARY
	}

	override public convenience
    init(_ input: TokenStream) throws {
        try self.init(input, State())
    }
    
    public
    init(_ input: TokenStream, _ state: State) throws {
        self.state = state
        RuntimeMetaData.checkVersion("4.9.1", RuntimeMetaData.VERSION)
        try super.init(input)
        _interp = ParserATNSimulator(self,
                                     _ATN,
                                     _decisionToDFA,
                                     _sharedContextCache,
                                     atnConfigPool: state.atnConfigPool)
    }


	public class TranslationUnitContext: ParserRuleContext {
			open
			func EOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.EOF.rawValue, 0)
			}
			open
			func topLevelDeclaration() -> [TopLevelDeclarationContext] {
				return getRuleContexts(TopLevelDeclarationContext.self)
			}
			open
			func topLevelDeclaration(_ i: Int) -> TopLevelDeclarationContext? {
				return getRuleContext(TopLevelDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_translationUnit
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTranslationUnit(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTranslationUnit(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTranslationUnit(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTranslationUnit(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func translationUnit() throws -> TranslationUnitContext {
        let _localctx: TranslationUnitContext = TranslationUnitContext(_ctx, getState())
		try enterRule(_localctx, 0, ObjectiveCParser.RULE_translationUnit)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(315)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.CLASS.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue,ObjectiveCParser.Tokens.INTERFACE.rawValue,ObjectiveCParser.Tokens.IMPORT.rawValue,ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 65)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(312)
		 		try topLevelDeclaration()


		 		setState(317)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(318)
		 	try match(ObjectiveCParser.Tokens.EOF.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TopLevelDeclarationContext: ParserRuleContext {
			open
			func importDeclaration() -> ImportDeclarationContext? {
				return getRuleContext(ImportDeclarationContext.self, 0)
			}
			open
			func functionDeclaration() -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, 0)
			}
			open
			func declaration() -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, 0)
			}
			open
			func classInterface() -> ClassInterfaceContext? {
				return getRuleContext(ClassInterfaceContext.self, 0)
			}
			open
			func classImplementation() -> ClassImplementationContext? {
				return getRuleContext(ClassImplementationContext.self, 0)
			}
			open
			func categoryInterface() -> CategoryInterfaceContext? {
				return getRuleContext(CategoryInterfaceContext.self, 0)
			}
			open
			func categoryImplementation() -> CategoryImplementationContext? {
				return getRuleContext(CategoryImplementationContext.self, 0)
			}
			open
			func protocolDeclaration() -> ProtocolDeclarationContext? {
				return getRuleContext(ProtocolDeclarationContext.self, 0)
			}
			open
			func protocolDeclarationList() -> ProtocolDeclarationListContext? {
				return getRuleContext(ProtocolDeclarationListContext.self, 0)
			}
			open
			func classDeclarationList() -> ClassDeclarationListContext? {
				return getRuleContext(ClassDeclarationListContext.self, 0)
			}
			open
			func functionDefinition() -> FunctionDefinitionContext? {
				return getRuleContext(FunctionDefinitionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_topLevelDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTopLevelDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTopLevelDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTopLevelDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTopLevelDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func topLevelDeclaration() throws -> TopLevelDeclarationContext {
		let _localctx: TopLevelDeclarationContext = TopLevelDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 2, ObjectiveCParser.RULE_topLevelDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(331)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,1, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(320)
		 		try importDeclaration()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(321)
		 		try functionDeclaration()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(322)
		 		try declaration()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(323)
		 		try classInterface()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(324)
		 		try classImplementation()

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(325)
		 		try categoryInterface()

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(326)
		 		try categoryImplementation()

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(327)
		 		try protocolDeclaration()

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(328)
		 		try protocolDeclarationList()

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(329)
		 		try classDeclarationList()

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(330)
		 		try functionDefinition()

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

	public class ImportDeclarationContext: ParserRuleContext {
			open
			func IMPORT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IMPORT.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_importDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterImportDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitImportDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitImportDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitImportDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func importDeclaration() throws -> ImportDeclarationContext {
		let _localctx: ImportDeclarationContext = ImportDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 4, ObjectiveCParser.RULE_importDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(333)
		 	try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
		 	setState(334)
		 	try identifier()
		 	setState(335)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassInterfaceContext: ParserRuleContext {
			open
			func INTERFACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INTERFACE.rawValue, 0)
			}
			open
			func classInterfaceName() -> ClassInterfaceNameContext? {
				return getRuleContext(ClassInterfaceNameContext.self, 0)
			}
			open
			func END() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
			}
			open
			func IB_DESIGNABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue, 0)
			}
			open
			func instanceVariables() -> InstanceVariablesContext? {
				return getRuleContext(InstanceVariablesContext.self, 0)
			}
			open
			func interfaceDeclarationList() -> InterfaceDeclarationListContext? {
				return getRuleContext(InterfaceDeclarationListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classInterface
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassInterface(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassInterface(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassInterface(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassInterface(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classInterface() throws -> ClassInterfaceContext {
		let _localctx: ClassInterfaceContext = ClassInterfaceContext(_ctx, getState())
		try enterRule(_localctx, 6, ObjectiveCParser.RULE_classInterface)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(338)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(337)
		 		try match(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue)

		 	}

		 	setState(340)
		 	try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
		 	setState(341)
		 	try classInterfaceName()
		 	setState(343)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(342)
		 		try instanceVariables()

		 	}

		 	setState(346)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROPERTY.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 72)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(345)
		 		try interfaceDeclarationList()

		 	}

		 	setState(348)
		 	try match(ObjectiveCParser.Tokens.END.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassInterfaceNameContext: ParserRuleContext {
			open
			func className() -> ClassNameContext? {
				return getRuleContext(ClassNameContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func superclassName() -> SuperclassNameContext? {
				return getRuleContext(SuperclassNameContext.self, 0)
			}
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func genericSuperclassName() -> GenericSuperclassNameContext? {
				return getRuleContext(GenericSuperclassNameContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classInterfaceName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassInterfaceName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassInterfaceName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassInterfaceName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassInterfaceName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classInterfaceName() throws -> ClassInterfaceNameContext {
		let _localctx: ClassInterfaceNameContext = ClassInterfaceNameContext(_ctx, getState())
		try enterRule(_localctx, 8, ObjectiveCParser.RULE_classInterfaceName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(372)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,9, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(350)
		 		try className()
		 		setState(353)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COLON.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(351)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 			setState(352)
		 			try superclassName()

		 		}

		 		setState(359)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.LT.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(355)
		 			try match(ObjectiveCParser.Tokens.LT.rawValue)
		 			setState(356)
		 			try protocolList()
		 			setState(357)
		 			try match(ObjectiveCParser.Tokens.GT.rawValue)

		 		}


		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(361)
		 		try className()
		 		setState(364)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COLON.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(362)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 			setState(363)
		 			try genericSuperclassName()

		 		}

		 		setState(370)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.LT.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(366)
		 			try match(ObjectiveCParser.Tokens.LT.rawValue)
		 			setState(367)
		 			try protocolList()
		 			setState(368)
		 			try match(ObjectiveCParser.Tokens.GT.rawValue)

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

	public class CategoryInterfaceContext: ParserRuleContext {
		open var categoryName: ClassNameContext!
			open
			func INTERFACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INTERFACE.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func END() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
			}
			open
			func className() -> ClassNameContext? {
				return getRuleContext(ClassNameContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func instanceVariables() -> InstanceVariablesContext? {
				return getRuleContext(InstanceVariablesContext.self, 0)
			}
			open
			func interfaceDeclarationList() -> InterfaceDeclarationListContext? {
				return getRuleContext(InterfaceDeclarationListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_categoryInterface
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterCategoryInterface(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitCategoryInterface(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitCategoryInterface(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitCategoryInterface(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func categoryInterface() throws -> CategoryInterfaceContext {
		let _localctx: CategoryInterfaceContext = CategoryInterfaceContext(_ctx, getState())
		try enterRule(_localctx, 10, ObjectiveCParser.RULE_categoryInterface)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(374)
		 	try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
		 	setState(375)
		 	try {
		 			let assignmentValue = try className()
		 			_localctx.castdown(CategoryInterfaceContext.self).categoryName = assignmentValue
		 	     }()

		 	setState(376)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(378)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(377)
		 		try identifier()

		 	}

		 	setState(380)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(385)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(381)
		 		try match(ObjectiveCParser.Tokens.LT.rawValue)
		 		setState(382)
		 		try protocolList()
		 		setState(383)
		 		try match(ObjectiveCParser.Tokens.GT.rawValue)

		 	}

		 	setState(388)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(387)
		 		try instanceVariables()

		 	}

		 	setState(391)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROPERTY.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 72)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(390)
		 		try interfaceDeclarationList()

		 	}

		 	setState(393)
		 	try match(ObjectiveCParser.Tokens.END.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassImplementationContext: ParserRuleContext {
			open
			func IMPLEMENTATION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue, 0)
			}
			open
			func classImplementatioName() -> ClassImplementatioNameContext? {
				return getRuleContext(ClassImplementatioNameContext.self, 0)
			}
			open
			func END() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
			}
			open
			func instanceVariables() -> InstanceVariablesContext? {
				return getRuleContext(InstanceVariablesContext.self, 0)
			}
			open
			func implementationDefinitionList() -> ImplementationDefinitionListContext? {
				return getRuleContext(ImplementationDefinitionListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classImplementation
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassImplementation(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassImplementation(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassImplementation(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassImplementation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classImplementation() throws -> ClassImplementationContext {
		let _localctx: ClassImplementationContext = ClassImplementationContext(_ctx, getState())
		try enterRule(_localctx, 12, ObjectiveCParser.RULE_classImplementation)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(395)
		 	try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
		 	setState(396)
		 	try classImplementatioName()
		 	setState(398)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(397)
		 		try instanceVariables()

		 	}

		 	setState(401)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.DYNAMIC.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SYNTHESIZE.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 78)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(400)
		 		try implementationDefinitionList()

		 	}

		 	setState(403)
		 	try match(ObjectiveCParser.Tokens.END.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassImplementatioNameContext: ParserRuleContext {
			open
			func className() -> ClassNameContext? {
				return getRuleContext(ClassNameContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func superclassName() -> SuperclassNameContext? {
				return getRuleContext(SuperclassNameContext.self, 0)
			}
			open
			func genericSuperclassName() -> GenericSuperclassNameContext? {
				return getRuleContext(GenericSuperclassNameContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classImplementatioName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassImplementatioName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassImplementatioName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassImplementatioName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassImplementatioName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classImplementatioName() throws -> ClassImplementatioNameContext {
		let _localctx: ClassImplementatioNameContext = ClassImplementatioNameContext(_ctx, getState())
		try enterRule(_localctx, 14, ObjectiveCParser.RULE_classImplementatioName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(415)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,18, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(405)
		 		try className()
		 		setState(408)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COLON.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(406)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 			setState(407)
		 			try superclassName()

		 		}


		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(410)
		 		try className()
		 		setState(413)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COLON.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(411)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 			setState(412)
		 			try genericSuperclassName()

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

	public class CategoryImplementationContext: ParserRuleContext {
		open var categoryName: ClassNameContext!
			open
			func IMPLEMENTATION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func END() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
			}
			open
			func className() -> ClassNameContext? {
				return getRuleContext(ClassNameContext.self, 0)
			}
			open
			func implementationDefinitionList() -> ImplementationDefinitionListContext? {
				return getRuleContext(ImplementationDefinitionListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_categoryImplementation
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterCategoryImplementation(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitCategoryImplementation(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitCategoryImplementation(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitCategoryImplementation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func categoryImplementation() throws -> CategoryImplementationContext {
		let _localctx: CategoryImplementationContext = CategoryImplementationContext(_ctx, getState())
		try enterRule(_localctx, 16, ObjectiveCParser.RULE_categoryImplementation)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(417)
		 	try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
		 	setState(418)
		 	try {
		 			let assignmentValue = try className()
		 			_localctx.castdown(CategoryImplementationContext.self).categoryName = assignmentValue
		 	     }()

		 	setState(419)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(420)
		 	try identifier()
		 	setState(421)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(423)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.DYNAMIC.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SYNTHESIZE.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 78)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(422)
		 		try implementationDefinitionList()

		 	}

		 	setState(425)
		 	try match(ObjectiveCParser.Tokens.END.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassNameContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func genericsSpecifier() -> GenericsSpecifierContext? {
				return getRuleContext(GenericsSpecifierContext.self, 0)
			}
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_className
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func className() throws -> ClassNameContext {
		let _localctx: ClassNameContext = ClassNameContext(_ctx, getState())
		try enterRule(_localctx, 18, ObjectiveCParser.RULE_className)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(427)
		 	try identifier()
		 	setState(433)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,20,_ctx)) {
		 	case 1:
		 		setState(428)
		 		try match(ObjectiveCParser.Tokens.LT.rawValue)
		 		setState(429)
		 		try protocolList()
		 		setState(430)
		 		try match(ObjectiveCParser.Tokens.GT.rawValue)


		 		break
		 	case 2:
		 		setState(432)
		 		try genericsSpecifier()

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

	public class SuperclassNameContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_superclassName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSuperclassName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSuperclassName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSuperclassName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSuperclassName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func superclassName() throws -> SuperclassNameContext {
		let _localctx: SuperclassNameContext = SuperclassNameContext(_ctx, getState())
		try enterRule(_localctx, 20, ObjectiveCParser.RULE_superclassName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(435)
		 	try identifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class GenericSuperclassNameContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func genericSuperclassSpecifier() -> GenericSuperclassSpecifierContext? {
				return getRuleContext(GenericSuperclassSpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_genericSuperclassName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterGenericSuperclassName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitGenericSuperclassName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitGenericSuperclassName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitGenericSuperclassName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func genericSuperclassName() throws -> GenericSuperclassNameContext {
		let _localctx: GenericSuperclassNameContext = GenericSuperclassNameContext(_ctx, getState())
		try enterRule(_localctx, 22, ObjectiveCParser.RULE_genericSuperclassName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(437)
		 	try identifier()
		 	setState(438)
		 	try genericSuperclassSpecifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class GenericTypeSpecifierContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func genericsSpecifier() -> GenericsSpecifierContext? {
				return getRuleContext(GenericsSpecifierContext.self, 0)
			}
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_genericTypeSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterGenericTypeSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitGenericTypeSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitGenericTypeSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitGenericTypeSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func genericTypeSpecifier() throws -> GenericTypeSpecifierContext {
		let _localctx: GenericTypeSpecifierContext = GenericTypeSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 24, ObjectiveCParser.RULE_genericTypeSpecifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(440)
		 	try identifier()
		 	setState(446)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,21, _ctx)) {
		 	case 1:
		 		setState(441)
		 		try match(ObjectiveCParser.Tokens.LT.rawValue)
		 		setState(442)
		 		try protocolList()
		 		setState(443)
		 		try match(ObjectiveCParser.Tokens.GT.rawValue)


		 		break
		 	case 2:
		 		setState(445)
		 		try genericsSpecifier()

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

	public class GenericSuperclassSpecifierContext: ParserRuleContext {
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func superclassTypeSpecifierWithPrefixes() -> [SuperclassTypeSpecifierWithPrefixesContext] {
				return getRuleContexts(SuperclassTypeSpecifierWithPrefixesContext.self)
			}
			open
			func superclassTypeSpecifierWithPrefixes(_ i: Int) -> SuperclassTypeSpecifierWithPrefixesContext? {
				return getRuleContext(SuperclassTypeSpecifierWithPrefixesContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_genericSuperclassSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterGenericSuperclassSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitGenericSuperclassSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitGenericSuperclassSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitGenericSuperclassSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func genericSuperclassSpecifier() throws -> GenericSuperclassSpecifierContext {
		let _localctx: GenericSuperclassSpecifierContext = GenericSuperclassSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 26, ObjectiveCParser.RULE_genericSuperclassSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(448)
		 	try match(ObjectiveCParser.Tokens.LT.rawValue)
		 	setState(457)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(449)
		 		try superclassTypeSpecifierWithPrefixes()
		 		setState(454)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(450)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(451)
		 			try superclassTypeSpecifierWithPrefixes()


		 			setState(456)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(459)
		 	try match(ObjectiveCParser.Tokens.GT.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SuperclassTypeSpecifierWithPrefixesContext: ParserRuleContext {
			open
			func typeSpecifier() -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, 0)
			}
			open
			func typePrefix() -> [TypePrefixContext] {
				return getRuleContexts(TypePrefixContext.self)
			}
			open
			func typePrefix(_ i: Int) -> TypePrefixContext? {
				return getRuleContext(TypePrefixContext.self, i)
			}
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_superclassTypeSpecifierWithPrefixes
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSuperclassTypeSpecifierWithPrefixes(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSuperclassTypeSpecifierWithPrefixes(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSuperclassTypeSpecifierWithPrefixes(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSuperclassTypeSpecifierWithPrefixes(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func superclassTypeSpecifierWithPrefixes() throws -> SuperclassTypeSpecifierWithPrefixesContext {
		let _localctx: SuperclassTypeSpecifierWithPrefixesContext = SuperclassTypeSpecifierWithPrefixesContext(_ctx, getState())
		try enterRule(_localctx, 28, ObjectiveCParser.RULE_superclassTypeSpecifierWithPrefixes)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(464)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,24,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(461)
		 			try typePrefix()

		 	 
		 		}
		 		setState(466)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,24,_ctx)
		 	}
		 	setState(467)
		 	try typeSpecifier()
		 	setState(469)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.MUL.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(468)
		 		try pointer()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ProtocolDeclarationContext: ParserRuleContext {
			open
			func PROTOCOL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
			}
			open
			func protocolName() -> ProtocolNameContext? {
				return getRuleContext(ProtocolNameContext.self, 0)
			}
			open
			func END() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
			}
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func protocolDeclarationSection() -> [ProtocolDeclarationSectionContext] {
				return getRuleContexts(ProtocolDeclarationSectionContext.self)
			}
			open
			func protocolDeclarationSection(_ i: Int) -> ProtocolDeclarationSectionContext? {
				return getRuleContext(ProtocolDeclarationSectionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolDeclaration() throws -> ProtocolDeclarationContext {
		let _localctx: ProtocolDeclarationContext = ProtocolDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 30, ObjectiveCParser.RULE_protocolDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(471)
		 	try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
		 	setState(472)
		 	try protocolName()
		 	setState(477)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(473)
		 		try match(ObjectiveCParser.Tokens.LT.rawValue)
		 		setState(474)
		 		try protocolList()
		 		setState(475)
		 		try match(ObjectiveCParser.Tokens.GT.rawValue)

		 	}

		 	setState(482)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.OPTIONAL.rawValue,ObjectiveCParser.Tokens.PROPERTY.rawValue,ObjectiveCParser.Tokens.REQUIRED.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 70)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(479)
		 		try protocolDeclarationSection()


		 		setState(484)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(485)
		 	try match(ObjectiveCParser.Tokens.END.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ProtocolDeclarationSectionContext: ParserRuleContext {
		open var modifier: Token!
			open
			func REQUIRED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.REQUIRED.rawValue, 0)
			}
			open
			func OPTIONAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OPTIONAL.rawValue, 0)
			}
			open
			func interfaceDeclarationList() -> [InterfaceDeclarationListContext] {
				return getRuleContexts(InterfaceDeclarationListContext.self)
			}
			open
			func interfaceDeclarationList(_ i: Int) -> InterfaceDeclarationListContext? {
				return getRuleContext(InterfaceDeclarationListContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolDeclarationSection
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolDeclarationSection(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolDeclarationSection(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolDeclarationSection(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolDeclarationSection(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolDeclarationSection() throws -> ProtocolDeclarationSectionContext {
		let _localctx: ProtocolDeclarationSectionContext = ProtocolDeclarationSectionContext(_ctx, getState())
		try enterRule(_localctx, 32, ObjectiveCParser.RULE_protocolDeclarationSection)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(499)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .OPTIONAL:fallthrough
		 	case .REQUIRED:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(487)
		 		_localctx.castdown(ProtocolDeclarationSectionContext.self).modifier = try _input.LT(1)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.OPTIONAL.rawValue || _la == ObjectiveCParser.Tokens.REQUIRED.rawValue
		 		      return testSet
		 		 }())) {
		 			_localctx.castdown(ProtocolDeclarationSectionContext.self).modifier = try _errHandler.recoverInline(self) as Token
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}
		 		setState(491)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,28,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(488)
		 				try interfaceDeclarationList()

		 		 
		 			}
		 			setState(493)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,28,_ctx)
		 		}

		 		break
		 	case .AUTO:fallthrough
		 	case .CHAR:fallthrough
		 	case .CONST:fallthrough
		 	case .DOUBLE:fallthrough
		 	case .ENUM:fallthrough
		 	case .EXTERN:fallthrough
		 	case .FLOAT:fallthrough
		 	case .INLINE:fallthrough
		 	case .INT:fallthrough
		 	case .LONG:fallthrough
		 	case .REGISTER:fallthrough
		 	case .RESTRICT:fallthrough
		 	case .SHORT:fallthrough
		 	case .SIGNED:fallthrough
		 	case .STATIC:fallthrough
		 	case .STRUCT:fallthrough
		 	case .TYPEDEF:fallthrough
		 	case .UNION:fallthrough
		 	case .UNSIGNED:fallthrough
		 	case .VOID:fallthrough
		 	case .VOLATILE:fallthrough
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .PROPERTY:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .ATTRIBUTE:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .STRONG_QUALIFIER:fallthrough
		 	case .TYPEOF:fallthrough
		 	case .UNSAFE_UNRETAINED_QUALIFIER:fallthrough
		 	case .UNUSED:fallthrough
		 	case .WEAK_QUALIFIER:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:fallthrough
		 	case .ADD:fallthrough
		 	case .SUB:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(495); 
		 		try _errHandler.sync(self)
		 		_alt = 1;
		 		repeat {
		 			switch (_alt) {
		 			case 1:
		 				setState(494)
		 				try interfaceDeclarationList()


		 				break
		 			default:
		 				throw ANTLRException.recognition(e: NoViableAltException(self))
		 			}
		 			setState(497); 
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,29,_ctx)
		 		} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

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

	public class ProtocolDeclarationListContext: ParserRuleContext {
			open
			func PROTOCOL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolDeclarationList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolDeclarationList() throws -> ProtocolDeclarationListContext {
		let _localctx: ProtocolDeclarationListContext = ProtocolDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 34, ObjectiveCParser.RULE_protocolDeclarationList)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(501)
		 	try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
		 	setState(502)
		 	try protocolList()
		 	setState(503)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassDeclarationListContext: ParserRuleContext {
			open
			func CLASS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CLASS.rawValue, 0)
			}
			open
			func className() -> [ClassNameContext] {
				return getRuleContexts(ClassNameContext.self)
			}
			open
			func className(_ i: Int) -> ClassNameContext? {
				return getRuleContext(ClassNameContext.self, i)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassDeclarationList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classDeclarationList() throws -> ClassDeclarationListContext {
		let _localctx: ClassDeclarationListContext = ClassDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 36, ObjectiveCParser.RULE_classDeclarationList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(505)
		 	try match(ObjectiveCParser.Tokens.CLASS.rawValue)
		 	setState(506)
		 	try className()
		 	setState(511)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(507)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(508)
		 		try className()


		 		setState(513)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(514)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ProtocolListContext: ParserRuleContext {
			open
			func protocolName() -> [ProtocolNameContext] {
				return getRuleContexts(ProtocolNameContext.self)
			}
			open
			func protocolName(_ i: Int) -> ProtocolNameContext? {
				return getRuleContext(ProtocolNameContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolList() throws -> ProtocolListContext {
		let _localctx: ProtocolListContext = ProtocolListContext(_ctx, getState())
		try enterRule(_localctx, 38, ObjectiveCParser.RULE_protocolList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(516)
		 	try protocolName()
		 	setState(521)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(517)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(518)
		 		try protocolName()


		 		setState(523)
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

	public class PropertyDeclarationContext: ParserRuleContext {
			open
			func PROPERTY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROPERTY.rawValue, 0)
			}
			open
			func fieldDeclaration() -> FieldDeclarationContext? {
				return getRuleContext(FieldDeclarationContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func propertyAttributesList() -> PropertyAttributesListContext? {
				return getRuleContext(PropertyAttributesListContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func ibOutletQualifier() -> IbOutletQualifierContext? {
				return getRuleContext(IbOutletQualifierContext.self, 0)
			}
			open
			func IB_INSPECTABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertyDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertyDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertyDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertyDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertyDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyDeclaration() throws -> PropertyDeclarationContext {
		let _localctx: PropertyDeclarationContext = PropertyDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 40, ObjectiveCParser.RULE_propertyDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(524)
		 	try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
		 	setState(529)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(525)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(526)
		 		try propertyAttributesList()
		 		setState(527)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 	}

		 	setState(532)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,34,_ctx)) {
		 	case 1:
		 		setState(531)
		 		try ibOutletQualifier()

		 		break
		 	default: break
		 	}
		 	setState(535)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,35,_ctx)) {
		 	case 1:
		 		setState(534)
		 		try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

		 		break
		 	default: break
		 	}
		 	setState(537)
		 	try fieldDeclaration()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PropertyAttributesListContext: ParserRuleContext {
			open
			func propertyAttribute() -> [PropertyAttributeContext] {
				return getRuleContexts(PropertyAttributeContext.self)
			}
			open
			func propertyAttribute(_ i: Int) -> PropertyAttributeContext? {
				return getRuleContext(PropertyAttributeContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertyAttributesList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertyAttributesList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertyAttributesList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertyAttributesList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertyAttributesList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyAttributesList() throws -> PropertyAttributesListContext {
		let _localctx: PropertyAttributesListContext = PropertyAttributesListContext(_ctx, getState())
		try enterRule(_localctx, 42, ObjectiveCParser.RULE_propertyAttributesList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(539)
		 	try propertyAttribute()
		 	setState(544)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(540)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(541)
		 		try propertyAttribute()


		 		setState(546)
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

	public class PropertyAttributeContext: ParserRuleContext {
			open
			func ATOMIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ATOMIC.rawValue, 0)
			}
			open
			func NONATOMIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NONATOMIC.rawValue, 0)
			}
			open
			func STRONG() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRONG.rawValue, 0)
			}
			open
			func WEAK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.WEAK.rawValue, 0)
			}
			open
			func RETAIN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RETAIN.rawValue, 0)
			}
			open
			func ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGN.rawValue, 0)
			}
			open
			func UNSAFE_UNRETAINED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue, 0)
			}
			open
			func COPY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COPY.rawValue, 0)
			}
			open
			func READONLY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.READONLY.rawValue, 0)
			}
			open
			func READWRITE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.READWRITE.rawValue, 0)
			}
			open
			func GETTER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GETTER.rawValue, 0)
			}
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func SETTER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SETTER.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func nullabilitySpecifier() -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertyAttribute
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertyAttribute(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertyAttribute(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertyAttribute(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertyAttribute(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyAttribute() throws -> PropertyAttributeContext {
		let _localctx: PropertyAttributeContext = PropertyAttributeContext(_ctx, getState())
		try enterRule(_localctx, 44, ObjectiveCParser.RULE_propertyAttribute)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(567)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,37, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(547)
		 		try match(ObjectiveCParser.Tokens.ATOMIC.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(548)
		 		try match(ObjectiveCParser.Tokens.NONATOMIC.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(549)
		 		try match(ObjectiveCParser.Tokens.STRONG.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(550)
		 		try match(ObjectiveCParser.Tokens.WEAK.rawValue)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(551)
		 		try match(ObjectiveCParser.Tokens.RETAIN.rawValue)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(552)
		 		try match(ObjectiveCParser.Tokens.ASSIGN.rawValue)

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(553)
		 		try match(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(554)
		 		try match(ObjectiveCParser.Tokens.COPY.rawValue)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(555)
		 		try match(ObjectiveCParser.Tokens.READONLY.rawValue)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(556)
		 		try match(ObjectiveCParser.Tokens.READWRITE.rawValue)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(557)
		 		try match(ObjectiveCParser.Tokens.GETTER.rawValue)
		 		setState(558)
		 		try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 		setState(559)
		 		try identifier()

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(560)
		 		try match(ObjectiveCParser.Tokens.SETTER.rawValue)
		 		setState(561)
		 		try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 		setState(562)
		 		try identifier()
		 		setState(563)
		 		try match(ObjectiveCParser.Tokens.COLON.rawValue)

		 		break
		 	case 13:
		 		try enterOuterAlt(_localctx, 13)
		 		setState(565)
		 		try nullabilitySpecifier()

		 		break
		 	case 14:
		 		try enterOuterAlt(_localctx, 14)
		 		setState(566)
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

	public class ProtocolNameContext: ParserRuleContext {
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func protocolList() -> ProtocolListContext? {
				return getRuleContext(ProtocolListContext.self, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func COVARIANT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
			}
			open
			func CONTRAVARIANT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolName() throws -> ProtocolNameContext {
		let _localctx: ProtocolNameContext = ProtocolNameContext(_ctx, getState())
		try enterRule(_localctx, 46, ObjectiveCParser.RULE_protocolName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(577)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .LT:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(569)
		 		try match(ObjectiveCParser.Tokens.LT.rawValue)
		 		setState(570)
		 		try protocolList()
		 		setState(571)
		 		try match(ObjectiveCParser.Tokens.GT.rawValue)

		 		break
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .UNUSED:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(574)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,38,_ctx)) {
		 		case 1:
		 			setState(573)
		 			_la = try _input.LA(1)
		 			if (!(//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == ObjectiveCParser.Tokens.COVARIANT.rawValue || _la == ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue
		 			      return testSet
		 			 }())) {
		 			try _errHandler.recoverInline(self)
		 			}
		 			else {
		 				_errHandler.reportMatch(self)
		 				try consume()
		 			}

		 			break
		 		default: break
		 		}
		 		setState(576)
		 		try identifier()

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

	public class InstanceVariablesContext: ParserRuleContext {
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func visibilitySection() -> [VisibilitySectionContext] {
				return getRuleContexts(VisibilitySectionContext.self)
			}
			open
			func visibilitySection(_ i: Int) -> VisibilitySectionContext? {
				return getRuleContext(VisibilitySectionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_instanceVariables
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInstanceVariables(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInstanceVariables(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInstanceVariables(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInstanceVariables(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func instanceVariables() throws -> InstanceVariablesContext {
		let _localctx: InstanceVariablesContext = InstanceVariablesContext(_ctx, getState())
		try enterRule(_localctx, 48, ObjectiveCParser.RULE_instanceVariables)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(579)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(583)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PACKAGE.rawValue,ObjectiveCParser.Tokens.PRIVATE.rawValue,ObjectiveCParser.Tokens.PROTECTED.rawValue,ObjectiveCParser.Tokens.PUBLIC.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 68)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(580)
		 		try visibilitySection()


		 		setState(585)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(586)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VisibilitySectionContext: ParserRuleContext {
			open
			func accessModifier() -> AccessModifierContext? {
				return getRuleContext(AccessModifierContext.self, 0)
			}
			open
			func fieldDeclaration() -> [FieldDeclarationContext] {
				return getRuleContexts(FieldDeclarationContext.self)
			}
			open
			func fieldDeclaration(_ i: Int) -> FieldDeclarationContext? {
				return getRuleContext(FieldDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_visibilitySection
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterVisibilitySection(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitVisibilitySection(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitVisibilitySection(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitVisibilitySection(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func visibilitySection() throws -> VisibilitySectionContext {
		let _localctx: VisibilitySectionContext = VisibilitySectionContext(_ctx, getState())
		try enterRule(_localctx, 50, ObjectiveCParser.RULE_visibilitySection)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(600)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .PACKAGE:fallthrough
		 	case .PRIVATE:fallthrough
		 	case .PROTECTED:fallthrough
		 	case .PUBLIC:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(588)
		 		try accessModifier()
		 		setState(592)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,41,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(589)
		 				try fieldDeclaration()

		 		 
		 			}
		 			setState(594)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,41,_ctx)
		 		}

		 		break
		 	case .AUTO:fallthrough
		 	case .CHAR:fallthrough
		 	case .CONST:fallthrough
		 	case .DOUBLE:fallthrough
		 	case .ENUM:fallthrough
		 	case .EXTERN:fallthrough
		 	case .FLOAT:fallthrough
		 	case .INLINE:fallthrough
		 	case .INT:fallthrough
		 	case .LONG:fallthrough
		 	case .REGISTER:fallthrough
		 	case .RESTRICT:fallthrough
		 	case .SHORT:fallthrough
		 	case .SIGNED:fallthrough
		 	case .STATIC:fallthrough
		 	case .STRUCT:fallthrough
		 	case .UNION:fallthrough
		 	case .UNSIGNED:fallthrough
		 	case .VOID:fallthrough
		 	case .VOLATILE:fallthrough
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .ATTRIBUTE:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .STRONG_QUALIFIER:fallthrough
		 	case .TYPEOF:fallthrough
		 	case .UNSAFE_UNRETAINED_QUALIFIER:fallthrough
		 	case .UNUSED:fallthrough
		 	case .WEAK_QUALIFIER:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(596); 
		 		try _errHandler.sync(self)
		 		_alt = 1;
		 		repeat {
		 			switch (_alt) {
		 			case 1:
		 				setState(595)
		 				try fieldDeclaration()


		 				break
		 			default:
		 				throw ANTLRException.recognition(e: NoViableAltException(self))
		 			}
		 			setState(598); 
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,42,_ctx)
		 		} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

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

	public class AccessModifierContext: ParserRuleContext {
			open
			func PRIVATE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PRIVATE.rawValue, 0)
			}
			open
			func PROTECTED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROTECTED.rawValue, 0)
			}
			open
			func PACKAGE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PACKAGE.rawValue, 0)
			}
			open
			func PUBLIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PUBLIC.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_accessModifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAccessModifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAccessModifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAccessModifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAccessModifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func accessModifier() throws -> AccessModifierContext {
		let _localctx: AccessModifierContext = AccessModifierContext(_ctx, getState())
		try enterRule(_localctx, 52, ObjectiveCParser.RULE_accessModifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(602)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PACKAGE.rawValue,ObjectiveCParser.Tokens.PRIVATE.rawValue,ObjectiveCParser.Tokens.PROTECTED.rawValue,ObjectiveCParser.Tokens.PUBLIC.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 68)
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

	public class InterfaceDeclarationListContext: ParserRuleContext {
			open
			func declaration() -> [DeclarationContext] {
				return getRuleContexts(DeclarationContext.self)
			}
			open
			func declaration(_ i: Int) -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, i)
			}
			open
			func classMethodDeclaration() -> [ClassMethodDeclarationContext] {
				return getRuleContexts(ClassMethodDeclarationContext.self)
			}
			open
			func classMethodDeclaration(_ i: Int) -> ClassMethodDeclarationContext? {
				return getRuleContext(ClassMethodDeclarationContext.self, i)
			}
			open
			func instanceMethodDeclaration() -> [InstanceMethodDeclarationContext] {
				return getRuleContexts(InstanceMethodDeclarationContext.self)
			}
			open
			func instanceMethodDeclaration(_ i: Int) -> InstanceMethodDeclarationContext? {
				return getRuleContext(InstanceMethodDeclarationContext.self, i)
			}
			open
			func propertyDeclaration() -> [PropertyDeclarationContext] {
				return getRuleContexts(PropertyDeclarationContext.self)
			}
			open
			func propertyDeclaration(_ i: Int) -> PropertyDeclarationContext? {
				return getRuleContext(PropertyDeclarationContext.self, i)
			}
			open
			func functionDeclaration() -> [FunctionDeclarationContext] {
				return getRuleContexts(FunctionDeclarationContext.self)
			}
			open
			func functionDeclaration(_ i: Int) -> FunctionDeclarationContext? {
				return getRuleContext(FunctionDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_interfaceDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInterfaceDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInterfaceDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInterfaceDeclarationList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInterfaceDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func interfaceDeclarationList() throws -> InterfaceDeclarationListContext {
		let _localctx: InterfaceDeclarationListContext = InterfaceDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 54, ObjectiveCParser.RULE_interfaceDeclarationList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(609); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(609)
		 			try _errHandler.sync(self)
		 			switch(try getInterpreter().adaptivePredict(_input,44, _ctx)) {
		 			case 1:
		 				setState(604)
		 				try declaration()

		 				break
		 			case 2:
		 				setState(605)
		 				try classMethodDeclaration()

		 				break
		 			case 3:
		 				setState(606)
		 				try instanceMethodDeclaration()

		 				break
		 			case 4:
		 				setState(607)
		 				try propertyDeclaration()

		 				break
		 			case 5:
		 				setState(608)
		 				try functionDeclaration()

		 				break
		 			default: break
		 			}

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(611); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,45,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ClassMethodDeclarationContext: ParserRuleContext {
			open
			func ADD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
			}
			open
			func methodDeclaration() -> MethodDeclarationContext? {
				return getRuleContext(MethodDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classMethodDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassMethodDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassMethodDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassMethodDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassMethodDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classMethodDeclaration() throws -> ClassMethodDeclarationContext {
		let _localctx: ClassMethodDeclarationContext = ClassMethodDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 56, ObjectiveCParser.RULE_classMethodDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(613)
		 	try match(ObjectiveCParser.Tokens.ADD.rawValue)
		 	setState(614)
		 	try methodDeclaration()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class InstanceMethodDeclarationContext: ParserRuleContext {
			open
			func SUB() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
			}
			open
			func methodDeclaration() -> MethodDeclarationContext? {
				return getRuleContext(MethodDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_instanceMethodDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInstanceMethodDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInstanceMethodDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInstanceMethodDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInstanceMethodDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func instanceMethodDeclaration() throws -> InstanceMethodDeclarationContext {
		let _localctx: InstanceMethodDeclarationContext = InstanceMethodDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 58, ObjectiveCParser.RULE_instanceMethodDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(616)
		 	try match(ObjectiveCParser.Tokens.SUB.rawValue)
		 	setState(617)
		 	try methodDeclaration()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class MethodDeclarationContext: ParserRuleContext {
			open
			func methodSelector() -> MethodSelectorContext? {
				return getRuleContext(MethodSelectorContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func methodType() -> MethodTypeContext? {
				return getRuleContext(MethodTypeContext.self, 0)
			}
			open
			func attributeSpecifier() -> [AttributeSpecifierContext] {
				return getRuleContexts(AttributeSpecifierContext.self)
			}
			open
			func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, i)
			}
			open
			func macro() -> MacroContext? {
				return getRuleContext(MacroContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_methodDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMethodDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMethodDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMethodDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMethodDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func methodDeclaration() throws -> MethodDeclarationContext {
		let _localctx: MethodDeclarationContext = MethodDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 60, ObjectiveCParser.RULE_methodDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(620)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(619)
		 		try methodType()

		 	}

		 	setState(622)
		 	try methodSelector()
		 	setState(626)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(623)
		 		try attributeSpecifier()


		 		setState(628)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(630)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(629)
		 		try macro()

		 	}

		 	setState(632)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ImplementationDefinitionListContext: ParserRuleContext {
			open
			func functionDefinition() -> [FunctionDefinitionContext] {
				return getRuleContexts(FunctionDefinitionContext.self)
			}
			open
			func functionDefinition(_ i: Int) -> FunctionDefinitionContext? {
				return getRuleContext(FunctionDefinitionContext.self, i)
			}
			open
			func declaration() -> [DeclarationContext] {
				return getRuleContexts(DeclarationContext.self)
			}
			open
			func declaration(_ i: Int) -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, i)
			}
			open
			func classMethodDefinition() -> [ClassMethodDefinitionContext] {
				return getRuleContexts(ClassMethodDefinitionContext.self)
			}
			open
			func classMethodDefinition(_ i: Int) -> ClassMethodDefinitionContext? {
				return getRuleContext(ClassMethodDefinitionContext.self, i)
			}
			open
			func instanceMethodDefinition() -> [InstanceMethodDefinitionContext] {
				return getRuleContexts(InstanceMethodDefinitionContext.self)
			}
			open
			func instanceMethodDefinition(_ i: Int) -> InstanceMethodDefinitionContext? {
				return getRuleContext(InstanceMethodDefinitionContext.self, i)
			}
			open
			func propertyImplementation() -> [PropertyImplementationContext] {
				return getRuleContexts(PropertyImplementationContext.self)
			}
			open
			func propertyImplementation(_ i: Int) -> PropertyImplementationContext? {
				return getRuleContext(PropertyImplementationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_implementationDefinitionList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterImplementationDefinitionList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitImplementationDefinitionList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitImplementationDefinitionList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitImplementationDefinitionList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func implementationDefinitionList() throws -> ImplementationDefinitionListContext {
		let _localctx: ImplementationDefinitionListContext = ImplementationDefinitionListContext(_ctx, getState())
		try enterRule(_localctx, 62, ObjectiveCParser.RULE_implementationDefinitionList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(639) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(639)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,49, _ctx)) {
		 		case 1:
		 			setState(634)
		 			try functionDefinition()

		 			break
		 		case 2:
		 			setState(635)
		 			try declaration()

		 			break
		 		case 3:
		 			setState(636)
		 			try classMethodDefinition()

		 			break
		 		case 4:
		 			setState(637)
		 			try instanceMethodDefinition()

		 			break
		 		case 5:
		 			setState(638)
		 			try propertyImplementation()

		 			break
		 		default: break
		 		}

		 		setState(641); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.DYNAMIC.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SYNTHESIZE.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 78)
		 	          }()
		 	          testSet = testSet || _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
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

	public class ClassMethodDefinitionContext: ParserRuleContext {
			open
			func ADD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
			}
			open
			func methodDefinition() -> MethodDefinitionContext? {
				return getRuleContext(MethodDefinitionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_classMethodDefinition
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterClassMethodDefinition(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitClassMethodDefinition(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitClassMethodDefinition(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitClassMethodDefinition(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func classMethodDefinition() throws -> ClassMethodDefinitionContext {
		let _localctx: ClassMethodDefinitionContext = ClassMethodDefinitionContext(_ctx, getState())
		try enterRule(_localctx, 64, ObjectiveCParser.RULE_classMethodDefinition)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(643)
		 	try match(ObjectiveCParser.Tokens.ADD.rawValue)
		 	setState(644)
		 	try methodDefinition()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class InstanceMethodDefinitionContext: ParserRuleContext {
			open
			func SUB() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
			}
			open
			func methodDefinition() -> MethodDefinitionContext? {
				return getRuleContext(MethodDefinitionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_instanceMethodDefinition
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInstanceMethodDefinition(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInstanceMethodDefinition(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInstanceMethodDefinition(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInstanceMethodDefinition(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func instanceMethodDefinition() throws -> InstanceMethodDefinitionContext {
		let _localctx: InstanceMethodDefinitionContext = InstanceMethodDefinitionContext(_ctx, getState())
		try enterRule(_localctx, 66, ObjectiveCParser.RULE_instanceMethodDefinition)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(646)
		 	try match(ObjectiveCParser.Tokens.SUB.rawValue)
		 	setState(647)
		 	try methodDefinition()

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
			func methodSelector() -> MethodSelectorContext? {
				return getRuleContext(MethodSelectorContext.self, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
			open
			func methodType() -> MethodTypeContext? {
				return getRuleContext(MethodTypeContext.self, 0)
			}
			open
			func initDeclaratorList() -> InitDeclaratorListContext? {
				return getRuleContext(InitDeclaratorListContext.self, 0)
			}
			open
			func SEMI() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.SEMI.rawValue)
			}
			open
			func SEMI(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, i)
			}
			open
			func attributeSpecifier() -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_methodDefinition
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMethodDefinition(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMethodDefinition(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMethodDefinition(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 68, ObjectiveCParser.RULE_methodDefinition)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(650)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(649)
		 		try methodType()

		 	}

		 	setState(652)
		 	try methodSelector()
		 	setState(654)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 40)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 104)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(653)
		 		try initDeclaratorList()

		 	}

		 	setState(657)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.SEMI.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(656)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 	}

		 	setState(660)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(659)
		 		try attributeSpecifier()

		 	}

		 	setState(662)
		 	try compoundStatement()
		 	setState(664)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.SEMI.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(663)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class MethodSelectorContext: ParserRuleContext {
			open
			func selector() -> SelectorContext? {
				return getRuleContext(SelectorContext.self, 0)
			}
			open
			func keywordDeclarator() -> [KeywordDeclaratorContext] {
				return getRuleContexts(KeywordDeclaratorContext.self)
			}
			open
			func keywordDeclarator(_ i: Int) -> KeywordDeclaratorContext? {
				return getRuleContext(KeywordDeclaratorContext.self, i)
			}
			open
			func COMMA() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
			}
			open
			func ELIPSIS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_methodSelector
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMethodSelector(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMethodSelector(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMethodSelector(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMethodSelector(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func methodSelector() throws -> MethodSelectorContext {
		let _localctx: MethodSelectorContext = MethodSelectorContext(_ctx, getState())
		try enterRule(_localctx, 70, ObjectiveCParser.RULE_methodSelector)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	setState(676)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,58, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(666)
		 		try selector()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(668); 
		 		try _errHandler.sync(self)
		 		_alt = 1;
		 		repeat {
		 			switch (_alt) {
		 			case 1:
		 				setState(667)
		 				try keywordDeclarator()


		 				break
		 			default:
		 				throw ANTLRException.recognition(e: NoViableAltException(self))
		 			}
		 			setState(670); 
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,56,_ctx)
		 		} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)
		 		setState(674)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(672)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(673)
		 			try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

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

	public class KeywordDeclaratorContext: ParserRuleContext {
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func selector() -> SelectorContext? {
				return getRuleContext(SelectorContext.self, 0)
			}
			open
			func methodType() -> [MethodTypeContext] {
				return getRuleContexts(MethodTypeContext.self)
			}
			open
			func methodType(_ i: Int) -> MethodTypeContext? {
				return getRuleContext(MethodTypeContext.self, i)
			}
			open
			func arcBehaviourSpecifier() -> ArcBehaviourSpecifierContext? {
				return getRuleContext(ArcBehaviourSpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_keywordDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterKeywordDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitKeywordDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitKeywordDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitKeywordDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func keywordDeclarator() throws -> KeywordDeclaratorContext {
		let _localctx: KeywordDeclaratorContext = KeywordDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 72, ObjectiveCParser.RULE_keywordDeclarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(679)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(678)
		 		try selector()

		 	}

		 	setState(681)
		 	try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 	setState(685)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(682)
		 		try methodType()


		 		setState(687)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(689)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,61,_ctx)) {
		 	case 1:
		 		setState(688)
		 		try arcBehaviourSpecifier()

		 		break
		 	default: break
		 	}
		 	setState(691)
		 	try identifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SelectorContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func RETURN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RETURN.rawValue, 0)
			}
			open
			func SWITCH() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SWITCH.rawValue, 0)
			}
			open
			func IF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IF.rawValue, 0)
			}
			open
			func ELSE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELSE.rawValue, 0)
			}
			open
			func DEFAULT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DEFAULT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_selector
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSelector(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSelector(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSelector(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSelector(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func selector() throws -> SelectorContext {
		let _localctx: SelectorContext = SelectorContext(_ctx, getState())
		try enterRule(_localctx, 74, ObjectiveCParser.RULE_selector)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(699)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .UNUSED:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(693)
		 		try identifier()

		 		break

		 	case .RETURN:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(694)
		 		try match(ObjectiveCParser.Tokens.RETURN.rawValue)

		 		break

		 	case .SWITCH:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(695)
		 		try match(ObjectiveCParser.Tokens.SWITCH.rawValue)

		 		break

		 	case .IF:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(696)
		 		try match(ObjectiveCParser.Tokens.IF.rawValue)

		 		break

		 	case .ELSE:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(697)
		 		try match(ObjectiveCParser.Tokens.ELSE.rawValue)

		 		break

		 	case .DEFAULT:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(698)
		 		try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)

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

	public class MethodTypeContext: ParserRuleContext {
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeName() -> TypeNameContext? {
				return getRuleContext(TypeNameContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_methodType
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMethodType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMethodType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMethodType(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMethodType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func methodType() throws -> MethodTypeContext {
		let _localctx: MethodTypeContext = MethodTypeContext(_ctx, getState())
		try enterRule(_localctx, 76, ObjectiveCParser.RULE_methodType)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(701)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(702)
		 	try typeName()
		 	setState(703)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PropertyImplementationContext: ParserRuleContext {
			open
			func SYNTHESIZE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue, 0)
			}
			open
			func propertySynthesizeList() -> PropertySynthesizeListContext? {
				return getRuleContext(PropertySynthesizeListContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func DYNAMIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DYNAMIC.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertyImplementation
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertyImplementation(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertyImplementation(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertyImplementation(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertyImplementation(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertyImplementation() throws -> PropertyImplementationContext {
		let _localctx: PropertyImplementationContext = PropertyImplementationContext(_ctx, getState())
		try enterRule(_localctx, 78, ObjectiveCParser.RULE_propertyImplementation)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(713)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .SYNTHESIZE:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(705)
		 		try match(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue)
		 		setState(706)
		 		try propertySynthesizeList()
		 		setState(707)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break

		 	case .DYNAMIC:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(709)
		 		try match(ObjectiveCParser.Tokens.DYNAMIC.rawValue)
		 		setState(710)
		 		try propertySynthesizeList()
		 		setState(711)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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

	public class PropertySynthesizeListContext: ParserRuleContext {
			open
			func propertySynthesizeItem() -> [PropertySynthesizeItemContext] {
				return getRuleContexts(PropertySynthesizeItemContext.self)
			}
			open
			func propertySynthesizeItem(_ i: Int) -> PropertySynthesizeItemContext? {
				return getRuleContext(PropertySynthesizeItemContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertySynthesizeList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertySynthesizeList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertySynthesizeList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertySynthesizeList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertySynthesizeList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertySynthesizeList() throws -> PropertySynthesizeListContext {
		let _localctx: PropertySynthesizeListContext = PropertySynthesizeListContext(_ctx, getState())
		try enterRule(_localctx, 80, ObjectiveCParser.RULE_propertySynthesizeList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(715)
		 	try propertySynthesizeItem()
		 	setState(720)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(716)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(717)
		 		try propertySynthesizeItem()


		 		setState(722)
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

	public class PropertySynthesizeItemContext: ParserRuleContext {
			open
			func identifier() -> [IdentifierContext] {
				return getRuleContexts(IdentifierContext.self)
			}
			open
			func identifier(_ i: Int) -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, i)
			}
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_propertySynthesizeItem
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPropertySynthesizeItem(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPropertySynthesizeItem(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPropertySynthesizeItem(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPropertySynthesizeItem(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func propertySynthesizeItem() throws -> PropertySynthesizeItemContext {
		let _localctx: PropertySynthesizeItemContext = PropertySynthesizeItemContext(_ctx, getState())
		try enterRule(_localctx, 82, ObjectiveCParser.RULE_propertySynthesizeItem)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(723)
		 	try identifier()
		 	setState(726)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(724)
		 		try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 		setState(725)
		 		try identifier()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BlockTypeContext: ParserRuleContext {
			open
			func typeSpecifier() -> [TypeSpecifierContext] {
				return getRuleContexts(TypeSpecifierContext.self)
			}
			open
			func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, i)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func BITXOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
				return getRuleContexts(NullabilitySpecifierContext.self)
			}
			open
			func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, i)
			}
			open
			func blockParameters() -> BlockParametersContext? {
				return getRuleContext(BlockParametersContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_blockType
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterBlockType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitBlockType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitBlockType(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitBlockType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func blockType() throws -> BlockTypeContext {
		let _localctx: BlockTypeContext = BlockTypeContext(_ctx, getState())
		try enterRule(_localctx, 84, ObjectiveCParser.RULE_blockType)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(729)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,66,_ctx)) {
		 	case 1:
		 		setState(728)
		 		try nullabilitySpecifier()

		 		break
		 	default: break
		 	}
		 	setState(731)
		 	try typeSpecifier()
		 	setState(733)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 99)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(732)
		 		try nullabilitySpecifier()

		 	}

		 	setState(735)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(736)
		 	try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
		 	setState(739)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,68,_ctx)) {
		 	case 1:
		 		setState(737)
		 		try nullabilitySpecifier()

		 		break
		 	case 2:
		 		setState(738)
		 		try typeSpecifier()

		 		break
		 	default: break
		 	}
		 	setState(741)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(743)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(742)
		 		try blockParameters()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class GenericsSpecifierContext: ParserRuleContext {
			open
			func LT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0)
			}
			open
			func GT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0)
			}
			open
			func typeSpecifierWithPrefixes() -> [TypeSpecifierWithPrefixesContext] {
				return getRuleContexts(TypeSpecifierWithPrefixesContext.self)
			}
			open
			func typeSpecifierWithPrefixes(_ i: Int) -> TypeSpecifierWithPrefixesContext? {
				return getRuleContext(TypeSpecifierWithPrefixesContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_genericsSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterGenericsSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitGenericsSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitGenericsSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitGenericsSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func genericsSpecifier() throws -> GenericsSpecifierContext {
		let _localctx: GenericsSpecifierContext = GenericsSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 86, ObjectiveCParser.RULE_genericsSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(745)
		 	try match(ObjectiveCParser.Tokens.LT.rawValue)
		 	setState(754)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(746)
		 		try typeSpecifierWithPrefixes()
		 		setState(751)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(747)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(748)
		 			try typeSpecifierWithPrefixes()


		 			setState(753)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(756)
		 	try match(ObjectiveCParser.Tokens.GT.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeSpecifierWithPrefixesContext: ParserRuleContext {
			open
			func typeSpecifier() -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, 0)
			}
			open
			func typePrefix() -> [TypePrefixContext] {
				return getRuleContexts(TypePrefixContext.self)
			}
			open
			func typePrefix(_ i: Int) -> TypePrefixContext? {
				return getRuleContext(TypePrefixContext.self, i)
			}
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeSpecifierWithPrefixes
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeSpecifierWithPrefixes(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeSpecifierWithPrefixes(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeSpecifierWithPrefixes(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeSpecifierWithPrefixes(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeSpecifierWithPrefixes() throws -> TypeSpecifierWithPrefixesContext {
		let _localctx: TypeSpecifierWithPrefixesContext = TypeSpecifierWithPrefixesContext(_ctx, getState())
		try enterRule(_localctx, 88, ObjectiveCParser.RULE_typeSpecifierWithPrefixes)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(761)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,72,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(758)
		 			try typePrefix()

		 	 
		 		}
		 		setState(763)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,72,_ctx)
		 	}
		 	setState(764)
		 	try typeSpecifier()
		 	setState(766)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.MUL.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(765)
		 		try pointer()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DictionaryExpressionContext: ParserRuleContext {
			open
			func AT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0)
			}
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func dictionaryPair() -> [DictionaryPairContext] {
				return getRuleContexts(DictionaryPairContext.self)
			}
			open
			func dictionaryPair(_ i: Int) -> DictionaryPairContext? {
				return getRuleContext(DictionaryPairContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_dictionaryExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDictionaryExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDictionaryExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDictionaryExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDictionaryExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func dictionaryExpression() throws -> DictionaryExpressionContext {
		let _localctx: DictionaryExpressionContext = DictionaryExpressionContext(_ctx, getState())
		try enterRule(_localctx, 90, ObjectiveCParser.RULE_dictionaryExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(768)
		 	try match(ObjectiveCParser.Tokens.AT.rawValue)
		 	setState(769)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(781)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(770)
		 		try dictionaryPair()
		 		setState(775)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,74,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(771)
		 				try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 				setState(772)
		 				try dictionaryPair()

		 		 
		 			}
		 			setState(777)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,74,_ctx)
		 		}
		 		setState(779)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(778)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(783)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DictionaryPairContext: ParserRuleContext {
			open
			func castExpression() -> CastExpressionContext? {
				return getRuleContext(CastExpressionContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_dictionaryPair
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDictionaryPair(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDictionaryPair(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDictionaryPair(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDictionaryPair(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func dictionaryPair() throws -> DictionaryPairContext {
		let _localctx: DictionaryPairContext = DictionaryPairContext(_ctx, getState())
		try enterRule(_localctx, 92, ObjectiveCParser.RULE_dictionaryPair)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(785)
		 	try castExpression()
		 	setState(786)
		 	try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 	setState(787)
		 	try expression(0)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrayExpressionContext: ParserRuleContext {
			open
			func AT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0)
			}
			open
			func LBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
			}
			open
			func RBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
			}
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
			open
			func COMMA() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_arrayExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterArrayExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitArrayExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitArrayExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitArrayExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrayExpression() throws -> ArrayExpressionContext {
		let _localctx: ArrayExpressionContext = ArrayExpressionContext(_ctx, getState())
		try enterRule(_localctx, 94, ObjectiveCParser.RULE_arrayExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(789)
		 	try match(ObjectiveCParser.Tokens.AT.rawValue)
		 	setState(790)
		 	try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 	setState(795)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(791)
		 		try expressions()
		 		setState(793)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(792)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(797)
		 	try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class BoxExpressionContext: ParserRuleContext {
			open
			func AT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_boxExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterBoxExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitBoxExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitBoxExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitBoxExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func boxExpression() throws -> BoxExpressionContext {
		let _localctx: BoxExpressionContext = BoxExpressionContext(_ctx, getState())
		try enterRule(_localctx, 96, ObjectiveCParser.RULE_boxExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(809)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,80, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(799)
		 		try match(ObjectiveCParser.Tokens.AT.rawValue)
		 		setState(800)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(801)
		 		try expression(0)
		 		setState(802)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(804)
		 		try match(ObjectiveCParser.Tokens.AT.rawValue)
		 		setState(807)
		 		try _errHandler.sync(self)
		 		switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .TRUE:fallthrough
		 		case .FALSE:fallthrough
		 		case .NIL:fallthrough
		 		case .NO:fallthrough
		 		case .NULL:fallthrough
		 		case .YES:fallthrough
		 		case .ADD:fallthrough
		 		case .SUB:fallthrough
		 		case .CHARACTER_LITERAL:fallthrough
		 		case .HEX_LITERAL:fallthrough
		 		case .OCTAL_LITERAL:fallthrough
		 		case .BINARY_LITERAL:fallthrough
		 		case .DECIMAL_LITERAL:fallthrough
		 		case .FLOATING_POINT_LITERAL:
		 			setState(805)
		 			try constant()

		 			break
		 		case .BOOL:fallthrough
		 		case .Class:fallthrough
		 		case .BYCOPY:fallthrough
		 		case .BYREF:fallthrough
		 		case .ID:fallthrough
		 		case .IMP:fallthrough
		 		case .IN:fallthrough
		 		case .INOUT:fallthrough
		 		case .ONEWAY:fallthrough
		 		case .OUT:fallthrough
		 		case .PROTOCOL_:fallthrough
		 		case .SEL:fallthrough
		 		case .SELF:fallthrough
		 		case .SUPER:fallthrough
		 		case .ATOMIC:fallthrough
		 		case .NONATOMIC:fallthrough
		 		case .RETAIN:fallthrough
		 		case .AUTORELEASING_QUALIFIER:fallthrough
		 		case .BLOCK:fallthrough
		 		case .BRIDGE_RETAINED:fallthrough
		 		case .BRIDGE_TRANSFER:fallthrough
		 		case .COVARIANT:fallthrough
		 		case .CONTRAVARIANT:fallthrough
		 		case .DEPRECATED:fallthrough
		 		case .KINDOF:fallthrough
		 		case .UNUSED:fallthrough
		 		case .NULL_UNSPECIFIED:fallthrough
		 		case .NULLABLE:fallthrough
		 		case .NONNULL:fallthrough
		 		case .NULL_RESETTABLE:fallthrough
		 		case .NS_INLINE:fallthrough
		 		case .NS_ENUM:fallthrough
		 		case .NS_OPTIONS:fallthrough
		 		case .ASSIGN:fallthrough
		 		case .COPY:fallthrough
		 		case .GETTER:fallthrough
		 		case .SETTER:fallthrough
		 		case .STRONG:fallthrough
		 		case .READONLY:fallthrough
		 		case .READWRITE:fallthrough
		 		case .WEAK:fallthrough
		 		case .UNSAFE_UNRETAINED:fallthrough
		 		case .IB_OUTLET:fallthrough
		 		case .IB_OUTLET_COLLECTION:fallthrough
		 		case .IB_INSPECTABLE:fallthrough
		 		case .IB_DESIGNABLE:fallthrough
		 		case .IDENTIFIER:
		 			setState(806)
		 			try identifier()

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
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

	public class BlockParametersContext: ParserRuleContext {
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func typeVariableDeclaratorOrName() -> [TypeVariableDeclaratorOrNameContext] {
				return getRuleContexts(TypeVariableDeclaratorOrNameContext.self)
			}
			open
			func typeVariableDeclaratorOrName(_ i: Int) -> TypeVariableDeclaratorOrNameContext? {
				return getRuleContext(TypeVariableDeclaratorOrNameContext.self, i)
			}
			open
			func VOID() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_blockParameters
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterBlockParameters(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitBlockParameters(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitBlockParameters(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitBlockParameters(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func blockParameters() throws -> BlockParametersContext {
		let _localctx: BlockParametersContext = BlockParametersContext(_ctx, getState())
		try enterRule(_localctx, 98, ObjectiveCParser.RULE_blockParameters)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(811)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(823)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(814)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,81, _ctx)) {
		 		case 1:
		 			setState(812)
		 			try typeVariableDeclaratorOrName()

		 			break
		 		case 2:
		 			setState(813)
		 			try match(ObjectiveCParser.Tokens.VOID.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(820)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(816)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(817)
		 			try typeVariableDeclaratorOrName()


		 			setState(822)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}

		 	}

		 	setState(825)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeVariableDeclaratorOrNameContext: ParserRuleContext {
			open
			func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
				return getRuleContext(TypeVariableDeclaratorContext.self, 0)
			}
			open
			func typeName() -> TypeNameContext? {
				return getRuleContext(TypeNameContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeVariableDeclaratorOrName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeVariableDeclaratorOrName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeVariableDeclaratorOrName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeVariableDeclaratorOrName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeVariableDeclaratorOrName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeVariableDeclaratorOrName() throws -> TypeVariableDeclaratorOrNameContext {
		let _localctx: TypeVariableDeclaratorOrNameContext = TypeVariableDeclaratorOrNameContext(_ctx, getState())
		try enterRule(_localctx, 100, ObjectiveCParser.RULE_typeVariableDeclaratorOrName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(829)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,84, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(827)
		 		try typeVariableDeclarator()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(828)
		 		try typeName()

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

	public class BlockExpressionContext: ParserRuleContext {
			open
			func BITXOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
			open
			func typeSpecifier() -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, 0)
			}
			open
			func nullabilitySpecifier() -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, 0)
			}
			open
			func blockParameters() -> BlockParametersContext? {
				return getRuleContext(BlockParametersContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_blockExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterBlockExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitBlockExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitBlockExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitBlockExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func blockExpression() throws -> BlockExpressionContext {
		let _localctx: BlockExpressionContext = BlockExpressionContext(_ctx, getState())
		try enterRule(_localctx, 102, ObjectiveCParser.RULE_blockExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(831)
		 	try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
		 	setState(833)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,85,_ctx)) {
		 	case 1:
		 		setState(832)
		 		try typeSpecifier()

		 		break
		 	default: break
		 	}
		 	setState(836)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 99)
		 	}()
		 	      return testSet
		 	 }()) {
		 		setState(835)
		 		try nullabilitySpecifier()

		 	}

		 	setState(839)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(838)
		 		try blockParameters()

		 	}

		 	setState(841)
		 	try compoundStatement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class MessageExpressionContext: ParserRuleContext {
			open
			func LBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
			}
			open
			func receiver() -> ReceiverContext? {
				return getRuleContext(ReceiverContext.self, 0)
			}
			open
			func messageSelector() -> MessageSelectorContext? {
				return getRuleContext(MessageSelectorContext.self, 0)
			}
			open
			func RBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_messageExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMessageExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMessageExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMessageExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMessageExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func messageExpression() throws -> MessageExpressionContext {
		let _localctx: MessageExpressionContext = MessageExpressionContext(_ctx, getState())
		try enterRule(_localctx, 104, ObjectiveCParser.RULE_messageExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(843)
		 	try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 	setState(844)
		 	try receiver()
		 	setState(845)
		 	try messageSelector()
		 	setState(846)
		 	try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ReceiverContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
				return getRuleContext(GenericTypeSpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_receiver
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterReceiver(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitReceiver(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitReceiver(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitReceiver(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func receiver() throws -> ReceiverContext {
		let _localctx: ReceiverContext = ReceiverContext(_ctx, getState())
		try enterRule(_localctx, 106, ObjectiveCParser.RULE_receiver)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(850)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,88, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(848)
		 		try expression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(849)
		 		try genericTypeSpecifier()

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

	public class MessageSelectorContext: ParserRuleContext {
			open
			func selector() -> SelectorContext? {
				return getRuleContext(SelectorContext.self, 0)
			}
			open
			func keywordArgument() -> [KeywordArgumentContext] {
				return getRuleContexts(KeywordArgumentContext.self)
			}
			open
			func keywordArgument(_ i: Int) -> KeywordArgumentContext? {
				return getRuleContext(KeywordArgumentContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_messageSelector
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMessageSelector(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMessageSelector(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMessageSelector(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMessageSelector(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func messageSelector() throws -> MessageSelectorContext {
		let _localctx: MessageSelectorContext = MessageSelectorContext(_ctx, getState())
		try enterRule(_localctx, 108, ObjectiveCParser.RULE_messageSelector)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(858)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,90, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(852)
		 		try selector()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(854) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(853)
		 			try keywordArgument()


		 			setState(856); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.COLON.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }())

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

	public class KeywordArgumentContext: ParserRuleContext {
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func keywordArgumentType() -> [KeywordArgumentTypeContext] {
				return getRuleContexts(KeywordArgumentTypeContext.self)
			}
			open
			func keywordArgumentType(_ i: Int) -> KeywordArgumentTypeContext? {
				return getRuleContext(KeywordArgumentTypeContext.self, i)
			}
			open
			func selector() -> SelectorContext? {
				return getRuleContext(SelectorContext.self, 0)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_keywordArgument
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterKeywordArgument(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitKeywordArgument(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitKeywordArgument(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitKeywordArgument(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func keywordArgument() throws -> KeywordArgumentContext {
		let _localctx: KeywordArgumentContext = KeywordArgumentContext(_ctx, getState())
		try enterRule(_localctx, 110, ObjectiveCParser.RULE_keywordArgument)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(861)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(860)
		 		try selector()

		 	}

		 	setState(863)
		 	try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 	setState(864)
		 	try keywordArgumentType()
		 	setState(869)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(865)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(866)
		 		try keywordArgumentType()


		 		setState(871)
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

	public class KeywordArgumentTypeContext: ParserRuleContext {
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
			open
			func nullabilitySpecifier() -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, 0)
			}
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func initializerList() -> InitializerListContext? {
				return getRuleContext(InitializerListContext.self, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_keywordArgumentType
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterKeywordArgumentType(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitKeywordArgumentType(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitKeywordArgumentType(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitKeywordArgumentType(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func keywordArgumentType() throws -> KeywordArgumentTypeContext {
		let _localctx: KeywordArgumentTypeContext = KeywordArgumentTypeContext(_ctx, getState())
		try enterRule(_localctx, 112, ObjectiveCParser.RULE_keywordArgumentType)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(872)
		 	try expressions()
		 	setState(874)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,93,_ctx)) {
		 	case 1:
		 		setState(873)
		 		try nullabilitySpecifier()

		 		break
		 	default: break
		 	}
		 	setState(880)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(876)
		 		try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 		setState(877)
		 		try initializerList()
		 		setState(878)
		 		try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SelectorExpressionContext: ParserRuleContext {
			open
			func SELECTOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SELECTOR.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func selectorName() -> SelectorNameContext? {
				return getRuleContext(SelectorNameContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_selectorExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSelectorExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSelectorExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSelectorExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSelectorExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func selectorExpression() throws -> SelectorExpressionContext {
		let _localctx: SelectorExpressionContext = SelectorExpressionContext(_ctx, getState())
		try enterRule(_localctx, 114, ObjectiveCParser.RULE_selectorExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(882)
		 	try match(ObjectiveCParser.Tokens.SELECTOR.rawValue)
		 	setState(883)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(884)
		 	try selectorName()
		 	setState(885)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SelectorNameContext: ParserRuleContext {
			open
			func selector() -> [SelectorContext] {
				return getRuleContexts(SelectorContext.self)
			}
			open
			func selector(_ i: Int) -> SelectorContext? {
				return getRuleContext(SelectorContext.self, i)
			}
			open
			func COLON() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COLON.rawValue)
			}
			open
			func COLON(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_selectorName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSelectorName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSelectorName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSelectorName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSelectorName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func selectorName() throws -> SelectorNameContext {
		let _localctx: SelectorNameContext = SelectorNameContext(_ctx, getState())
		try enterRule(_localctx, 116, ObjectiveCParser.RULE_selectorName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(896)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,97, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(887)
		 		try selector()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(892) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(889)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			if (//closure
		 			 { () -> Bool in
		 			      var testSet: Bool = {  () -> Bool in
		 			   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 			    return  Utils.testBitLeftShiftArray(testArray, 0)
		 			}()
		 			          testSet = testSet || {  () -> Bool in
		 			             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 			              return  Utils.testBitLeftShiftArray(testArray, 81)
		 			          }()
		 			      return testSet
		 			 }()) {
		 				setState(888)
		 				try selector()

		 			}

		 			setState(891)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)


		 			setState(894); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.COLON.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }())

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

	public class ProtocolExpressionContext: ParserRuleContext {
			open
			func PROTOCOL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func protocolName() -> ProtocolNameContext? {
				return getRuleContext(ProtocolNameContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolExpression() throws -> ProtocolExpressionContext {
		let _localctx: ProtocolExpressionContext = ProtocolExpressionContext(_ctx, getState())
		try enterRule(_localctx, 118, ObjectiveCParser.RULE_protocolExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(898)
		 	try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
		 	setState(899)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(900)
		 	try protocolName()
		 	setState(901)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EncodeExpressionContext: ParserRuleContext {
			open
			func ENCODE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ENCODE.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeName() -> TypeNameContext? {
				return getRuleContext(TypeNameContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_encodeExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEncodeExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEncodeExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEncodeExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEncodeExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func encodeExpression() throws -> EncodeExpressionContext {
		let _localctx: EncodeExpressionContext = EncodeExpressionContext(_ctx, getState())
		try enterRule(_localctx, 120, ObjectiveCParser.RULE_encodeExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(903)
		 	try match(ObjectiveCParser.Tokens.ENCODE.rawValue)
		 	setState(904)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(905)
		 	try typeName()
		 	setState(906)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeVariableDeclaratorContext: ParserRuleContext {
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeVariableDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeVariableDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeVariableDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeVariableDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeVariableDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeVariableDeclarator() throws -> TypeVariableDeclaratorContext {
		let _localctx: TypeVariableDeclaratorContext = TypeVariableDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 122, ObjectiveCParser.RULE_typeVariableDeclarator)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(908)
		 	try declarationSpecifiers()
		 	setState(909)
		 	try declarator()

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
			func THROW() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.THROW.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_throwStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterThrowStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitThrowStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitThrowStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 124, ObjectiveCParser.RULE_throwStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(918)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,98, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(911)
		 		try match(ObjectiveCParser.Tokens.THROW.rawValue)
		 		setState(912)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(913)
		 		try identifier()
		 		setState(914)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(916)
		 		try match(ObjectiveCParser.Tokens.THROW.rawValue)
		 		setState(917)
		 		try expression(0)

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

	public class TryBlockContext: ParserRuleContext {
		open var tryStatement: CompoundStatementContext!
		open var finallyStatement: CompoundStatementContext!
			open
			func TRY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TRY.rawValue, 0)
			}
			open
			func compoundStatement() -> [CompoundStatementContext] {
				return getRuleContexts(CompoundStatementContext.self)
			}
			open
			func compoundStatement(_ i: Int) -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, i)
			}
			open
			func catchStatement() -> [CatchStatementContext] {
				return getRuleContexts(CatchStatementContext.self)
			}
			open
			func catchStatement(_ i: Int) -> CatchStatementContext? {
				return getRuleContext(CatchStatementContext.self, i)
			}
			open
			func FINALLY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FINALLY.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_tryBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTryBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTryBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTryBlock(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTryBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func tryBlock() throws -> TryBlockContext {
		let _localctx: TryBlockContext = TryBlockContext(_ctx, getState())
		try enterRule(_localctx, 126, ObjectiveCParser.RULE_tryBlock)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(920)
		 	try match(ObjectiveCParser.Tokens.TRY.rawValue)
		 	setState(921)
		 	try {
		 			let assignmentValue = try compoundStatement()
		 			_localctx.castdown(TryBlockContext.self).tryStatement = assignmentValue
		 	     }()

		 	setState(925)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.CATCH.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(922)
		 		try catchStatement()


		 		setState(927)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(930)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.FINALLY.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(928)
		 		try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
		 		setState(929)
		 		try {
		 				let assignmentValue = try compoundStatement()
		 				_localctx.castdown(TryBlockContext.self).finallyStatement = assignmentValue
		 		     }()


		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CatchStatementContext: ParserRuleContext {
			open
			func CATCH() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CATCH.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
				return getRuleContext(TypeVariableDeclaratorContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_catchStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterCatchStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitCatchStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitCatchStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitCatchStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func catchStatement() throws -> CatchStatementContext {
		let _localctx: CatchStatementContext = CatchStatementContext(_ctx, getState())
		try enterRule(_localctx, 128, ObjectiveCParser.RULE_catchStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(932)
		 	try match(ObjectiveCParser.Tokens.CATCH.rawValue)
		 	setState(933)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(934)
		 	try typeVariableDeclarator()
		 	setState(935)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(936)
		 	try compoundStatement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SynchronizedStatementContext: ParserRuleContext {
			open
			func SYNCHRONIZED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_synchronizedStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSynchronizedStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSynchronizedStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSynchronizedStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSynchronizedStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func synchronizedStatement() throws -> SynchronizedStatementContext {
		let _localctx: SynchronizedStatementContext = SynchronizedStatementContext(_ctx, getState())
		try enterRule(_localctx, 130, ObjectiveCParser.RULE_synchronizedStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(938)
		 	try match(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue)
		 	setState(939)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(940)
		 	try expression(0)
		 	setState(941)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(942)
		 	try compoundStatement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AutoreleaseStatementContext: ParserRuleContext {
			open
			func AUTORELEASEPOOL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_autoreleaseStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAutoreleaseStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAutoreleaseStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAutoreleaseStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAutoreleaseStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func autoreleaseStatement() throws -> AutoreleaseStatementContext {
		let _localctx: AutoreleaseStatementContext = AutoreleaseStatementContext(_ctx, getState())
		try enterRule(_localctx, 132, ObjectiveCParser.RULE_autoreleaseStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(944)
		 	try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
		 	setState(945)
		 	try compoundStatement()

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
			func functionSignature() -> FunctionSignatureContext? {
				return getRuleContext(FunctionSignatureContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 134, ObjectiveCParser.RULE_functionDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(947)
		 	try functionSignature()
		 	setState(948)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionDefinitionContext: ParserRuleContext {
			open
			func functionSignature() -> FunctionSignatureContext? {
				return getRuleContext(FunctionSignatureContext.self, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionDefinition
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionDefinition(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionDefinition(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionDefinition(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionDefinition(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionDefinition() throws -> FunctionDefinitionContext {
		let _localctx: FunctionDefinitionContext = FunctionDefinitionContext(_ctx, getState())
		try enterRule(_localctx, 136, ObjectiveCParser.RULE_functionDefinition)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(950)
		 	try functionSignature()
		 	setState(951)
		 	try compoundStatement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionSignatureContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func attributeSpecifier() -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, 0)
			}
			open
			func parameterList() -> ParameterListContext? {
				return getRuleContext(ParameterListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionSignature
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionSignature(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionSignature(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionSignature(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionSignature(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionSignature() throws -> FunctionSignatureContext {
		let _localctx: FunctionSignatureContext = FunctionSignatureContext(_ctx, getState())
		try enterRule(_localctx, 138, ObjectiveCParser.RULE_functionSignature)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(954)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,101,_ctx)) {
		 	case 1:
		 		setState(953)
		 		try declarationSpecifiers()

		 		break
		 	default: break
		 	}
		 	setState(956)
		 	try identifier()

		 	setState(957)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(959)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(958)
		 		try parameterList()

		 	}

		 	setState(961)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		 	setState(964)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(963)
		 		try attributeSpecifier()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AttributeContext: ParserRuleContext {
			open
			func attributeName() -> AttributeNameContext? {
				return getRuleContext(AttributeNameContext.self, 0)
			}
			open
			func attributeParameters() -> AttributeParametersContext? {
				return getRuleContext(AttributeParametersContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attribute
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttribute(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttribute(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttribute(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttribute(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attribute() throws -> AttributeContext {
		let _localctx: AttributeContext = AttributeContext(_ctx, getState())
		try enterRule(_localctx, 140, ObjectiveCParser.RULE_attribute)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(966)
		 	try attributeName()
		 	setState(968)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(967)
		 		try attributeParameters()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AttributeNameContext: ParserRuleContext {
			open
			func CONST() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CONST.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeName() throws -> AttributeNameContext {
		let _localctx: AttributeNameContext = AttributeNameContext(_ctx, getState())
		try enterRule(_localctx, 142, ObjectiveCParser.RULE_attributeName)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(972)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .CONST:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(970)
		 		try match(ObjectiveCParser.Tokens.CONST.rawValue)

		 		break
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .UNUSED:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(971)
		 		try identifier()

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

	public class AttributeParametersContext: ParserRuleContext {
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func attributeParameterList() -> AttributeParameterListContext? {
				return getRuleContext(AttributeParameterListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeParameters
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeParameters(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeParameters(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeParameters(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeParameters(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeParameters() throws -> AttributeParametersContext {
		let _localctx: AttributeParametersContext = AttributeParametersContext(_ctx, getState())
		try enterRule(_localctx, 144, ObjectiveCParser.RULE_attributeParameters)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(974)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(976)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 152)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(975)
		 		try attributeParameterList()

		 	}

		 	setState(978)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AttributeParameterListContext: ParserRuleContext {
			open
			func attributeParameter() -> [AttributeParameterContext] {
				return getRuleContexts(AttributeParameterContext.self)
			}
			open
			func attributeParameter(_ i: Int) -> AttributeParameterContext? {
				return getRuleContext(AttributeParameterContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeParameterList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeParameterList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeParameterList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeParameterList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeParameterList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeParameterList() throws -> AttributeParameterListContext {
		let _localctx: AttributeParameterListContext = AttributeParameterListContext(_ctx, getState())
		try enterRule(_localctx, 146, ObjectiveCParser.RULE_attributeParameterList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(980)
		 	try attributeParameter()
		 	setState(985)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(981)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(982)
		 		try attributeParameter()


		 		setState(987)
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

	public class AttributeParameterContext: ParserRuleContext {
			open
			func attribute() -> AttributeContext? {
				return getRuleContext(AttributeContext.self, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
			open
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
			open
			func attributeParameterAssignment() -> AttributeParameterAssignmentContext? {
				return getRuleContext(AttributeParameterAssignmentContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeParameter
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeParameter(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeParameter(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeParameter(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeParameter(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeParameter() throws -> AttributeParameterContext {
		let _localctx: AttributeParameterContext = AttributeParameterContext(_ctx, getState())
		try enterRule(_localctx, 148, ObjectiveCParser.RULE_attributeParameter)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(992)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,108, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(988)
		 		try attribute()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(989)
		 		try constant()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(990)
		 		try stringLiteral()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(991)
		 		try attributeParameterAssignment()

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

	public class AttributeParameterAssignmentContext: ParserRuleContext {
			open
			func attributeName() -> [AttributeNameContext] {
				return getRuleContexts(AttributeNameContext.self)
			}
			open
			func attributeName(_ i: Int) -> AttributeNameContext? {
				return getRuleContext(AttributeNameContext.self, i)
			}
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
			open
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeParameterAssignment
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeParameterAssignment(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeParameterAssignment(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeParameterAssignment(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeParameterAssignment(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeParameterAssignment() throws -> AttributeParameterAssignmentContext {
		let _localctx: AttributeParameterAssignmentContext = AttributeParameterAssignmentContext(_ctx, getState())
		try enterRule(_localctx, 150, ObjectiveCParser.RULE_attributeParameterAssignment)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(994)
		 	try attributeName()
		 	setState(995)
		 	try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 	setState(999)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .NIL:fallthrough
		 	case .NO:fallthrough
		 	case .NULL:fallthrough
		 	case .YES:fallthrough
		 	case .ADD:fallthrough
		 	case .SUB:fallthrough
		 	case .CHARACTER_LITERAL:fallthrough
		 	case .HEX_LITERAL:fallthrough
		 	case .OCTAL_LITERAL:fallthrough
		 	case .BINARY_LITERAL:fallthrough
		 	case .DECIMAL_LITERAL:fallthrough
		 	case .FLOATING_POINT_LITERAL:
		 		setState(996)
		 		try constant()

		 		break
		 	case .CONST:fallthrough
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .UNUSED:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		setState(997)
		 		try attributeName()

		 		break

		 	case .STRING_START:
		 		setState(998)
		 		try stringLiteral()

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
			func functionCallExpression() -> FunctionCallExpressionContext? {
				return getRuleContext(FunctionCallExpressionContext.self, 0)
			}
			open
			func functionPointer() -> FunctionPointerContext? {
				return getRuleContext(FunctionPointerContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func enumDeclaration() -> EnumDeclarationContext? {
				return getRuleContext(EnumDeclarationContext.self, 0)
			}
			open
			func varDeclaration() -> VarDeclarationContext? {
				return getRuleContext(VarDeclarationContext.self, 0)
			}
			open
			func typedefDeclaration() -> TypedefDeclarationContext? {
				return getRuleContext(TypedefDeclarationContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_declaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 152, ObjectiveCParser.RULE_declaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1008)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,110, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1001)
		 		try functionCallExpression()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1002)
		 		try functionPointer()
		 		setState(1003)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1005)
		 		try enumDeclaration()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1006)
		 		try varDeclaration()

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(1007)
		 		try typedefDeclaration()

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

	public class FunctionPointerContext: ParserRuleContext {
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func LP() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.LP.rawValue)
			}
			open
			func LP(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
			}
			open
			func MUL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
			}
			open
			func RP() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.RP.rawValue)
			}
			open
			func RP(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func functionPointerParameterList() -> FunctionPointerParameterListContext? {
				return getRuleContext(FunctionPointerParameterListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionPointer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionPointer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionPointer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionPointer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionPointer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionPointer() throws -> FunctionPointerContext {
		let _localctx: FunctionPointerContext = FunctionPointerContext(_ctx, getState())
		try enterRule(_localctx, 154, ObjectiveCParser.RULE_functionPointer)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1010)
		 	try declarationSpecifiers()
		 	setState(1011)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1012)
		 	try match(ObjectiveCParser.Tokens.MUL.rawValue)
		 	setState(1014)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1013)
		 		try identifier()

		 	}

		 	setState(1016)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1017)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1019)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1018)
		 		try functionPointerParameterList()

		 	}

		 	setState(1021)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionPointerParameterListContext: ParserRuleContext {
			open
			func functionPointerParameterDeclarationList() -> FunctionPointerParameterDeclarationListContext? {
				return getRuleContext(FunctionPointerParameterDeclarationListContext.self, 0)
			}
			open
			func COMMA() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
			}
			open
			func ELIPSIS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionPointerParameterList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionPointerParameterList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionPointerParameterList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionPointerParameterList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionPointerParameterList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionPointerParameterList() throws -> FunctionPointerParameterListContext {
		let _localctx: FunctionPointerParameterListContext = FunctionPointerParameterListContext(_ctx, getState())
		try enterRule(_localctx, 156, ObjectiveCParser.RULE_functionPointerParameterList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1023)
		 	try functionPointerParameterDeclarationList()
		 	setState(1026)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1024)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1025)
		 		try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionPointerParameterDeclarationListContext: ParserRuleContext {
			open
			func functionPointerParameterDeclaration() -> [FunctionPointerParameterDeclarationContext] {
				return getRuleContexts(FunctionPointerParameterDeclarationContext.self)
			}
			open
			func functionPointerParameterDeclaration(_ i: Int) -> FunctionPointerParameterDeclarationContext? {
				return getRuleContext(FunctionPointerParameterDeclarationContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionPointerParameterDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionPointerParameterDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionPointerParameterDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionPointerParameterDeclarationList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionPointerParameterDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionPointerParameterDeclarationList() throws -> FunctionPointerParameterDeclarationListContext {
		let _localctx: FunctionPointerParameterDeclarationListContext = FunctionPointerParameterDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 158, ObjectiveCParser.RULE_functionPointerParameterDeclarationList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1028)
		 	try functionPointerParameterDeclaration()
		 	setState(1033)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,114,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(1029)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1030)
		 			try functionPointerParameterDeclaration()

		 	 
		 		}
		 		setState(1035)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,114,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FunctionPointerParameterDeclarationContext: ParserRuleContext {
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func functionPointer() -> FunctionPointerContext? {
				return getRuleContext(FunctionPointerContext.self, 0)
			}
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
			open
			func VOID() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionPointerParameterDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionPointerParameterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionPointerParameterDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionPointerParameterDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionPointerParameterDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionPointerParameterDeclaration() throws -> FunctionPointerParameterDeclarationContext {
		let _localctx: FunctionPointerParameterDeclarationContext = FunctionPointerParameterDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 160, ObjectiveCParser.RULE_functionPointerParameterDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1044)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,117, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1038)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,115, _ctx)) {
		 		case 1:
		 			setState(1036)
		 			try declarationSpecifiers()

		 			break
		 		case 2:
		 			setState(1037)
		 			try functionPointer()

		 			break
		 		default: break
		 		}
		 		setState(1041)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 40)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 104)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1040)
		 			try declarator()

		 		}


		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1043)
		 		try match(ObjectiveCParser.Tokens.VOID.rawValue)

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

	public class FunctionCallExpressionContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func directDeclarator() -> DirectDeclaratorContext? {
				return getRuleContext(DirectDeclaratorContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func attributeSpecifier() -> [AttributeSpecifierContext] {
				return getRuleContexts(AttributeSpecifierContext.self)
			}
			open
			func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_functionCallExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFunctionCallExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFunctionCallExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFunctionCallExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFunctionCallExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func functionCallExpression() throws -> FunctionCallExpressionContext {
		let _localctx: FunctionCallExpressionContext = FunctionCallExpressionContext(_ctx, getState())
		try enterRule(_localctx, 162, ObjectiveCParser.RULE_functionCallExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1047)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1046)
		 		try attributeSpecifier()

		 	}

		 	setState(1049)
		 	try identifier()
		 	setState(1051)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1050)
		 		try attributeSpecifier()

		 	}

		 	setState(1053)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1054)
		 	try directDeclarator()
		 	setState(1055)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1056)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EnumDeclarationContext: ParserRuleContext {
			open
			func enumSpecifier() -> EnumSpecifierContext? {
				return getRuleContext(EnumSpecifierContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func attributeSpecifier() -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, 0)
			}
			open
			func TYPEDEF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TYPEDEF.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_enumDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEnumDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEnumDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEnumDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEnumDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func enumDeclaration() throws -> EnumDeclarationContext {
		let _localctx: EnumDeclarationContext = EnumDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 164, ObjectiveCParser.RULE_enumDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1059)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1058)
		 		try attributeSpecifier()

		 	}

		 	setState(1062)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.TYPEDEF.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1061)
		 		try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)

		 	}

		 	setState(1064)
		 	try enumSpecifier()
		 	setState(1066)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1065)
		 		try identifier()

		 	}

		 	setState(1068)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class VarDeclarationContext: ParserRuleContext {
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func initDeclaratorList() -> InitDeclaratorListContext? {
				return getRuleContext(InitDeclaratorListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_varDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterVarDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitVarDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitVarDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitVarDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func varDeclaration() throws -> VarDeclarationContext {
		let _localctx: VarDeclarationContext = VarDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 166, ObjectiveCParser.RULE_varDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1074)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,123, _ctx)) {
		 	case 1:
		 		setState(1070)
		 		try declarationSpecifiers()
		 		setState(1071)
		 		try initDeclaratorList()

		 		break
		 	case 2:
		 		setState(1073)
		 		try declarationSpecifiers()

		 		break
		 	default: break
		 	}
		 	setState(1076)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypedefDeclarationContext: ParserRuleContext {
			open
			func TYPEDEF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TYPEDEF.rawValue, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func typeDeclaratorList() -> TypeDeclaratorListContext? {
				return getRuleContext(TypeDeclaratorListContext.self, 0)
			}
			open
			func attributeSpecifier() -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, 0)
			}
			open
			func macro() -> MacroContext? {
				return getRuleContext(MacroContext.self, 0)
			}
			open
			func functionPointer() -> FunctionPointerContext? {
				return getRuleContext(FunctionPointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typedefDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypedefDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypedefDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypedefDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypedefDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typedefDeclaration() throws -> TypedefDeclarationContext {
		let _localctx: TypedefDeclarationContext = TypedefDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 168, ObjectiveCParser.RULE_typedefDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1100)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,128, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1079)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1078)
		 			try attributeSpecifier()

		 		}

		 		setState(1081)
		 		try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
		 		setState(1086)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,125, _ctx)) {
		 		case 1:
		 			setState(1082)
		 			try declarationSpecifiers()
		 			setState(1083)
		 			try typeDeclaratorList()

		 			break
		 		case 2:
		 			setState(1085)
		 			try declarationSpecifiers()

		 			break
		 		default: break
		 		}
		 		setState(1089)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1088)
		 			try macro()

		 		}

		 		setState(1091)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1094)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1093)
		 			try attributeSpecifier()

		 		}

		 		setState(1096)
		 		try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
		 		setState(1097)
		 		try functionPointer()
		 		setState(1098)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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

	public class TypeDeclaratorListContext: ParserRuleContext {
			open
			func declarator() -> [DeclaratorContext] {
				return getRuleContexts(DeclaratorContext.self)
			}
			open
			func declarator(_ i: Int) -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeDeclaratorList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeDeclaratorList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeDeclaratorList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeDeclaratorList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeDeclaratorList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeDeclaratorList() throws -> TypeDeclaratorListContext {
		let _localctx: TypeDeclaratorListContext = TypeDeclaratorListContext(_ctx, getState())
		try enterRule(_localctx, 170, ObjectiveCParser.RULE_typeDeclaratorList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1102)
		 	try declarator()
		 	setState(1107)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1103)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1104)
		 		try declarator()


		 		setState(1109)
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

	public class DeclarationSpecifiersContext: ParserRuleContext {
			open
			func storageClassSpecifier() -> [StorageClassSpecifierContext] {
				return getRuleContexts(StorageClassSpecifierContext.self)
			}
			open
			func storageClassSpecifier(_ i: Int) -> StorageClassSpecifierContext? {
				return getRuleContext(StorageClassSpecifierContext.self, i)
			}
			open
			func attributeSpecifier() -> [AttributeSpecifierContext] {
				return getRuleContexts(AttributeSpecifierContext.self)
			}
			open
			func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, i)
			}
			open
			func arcBehaviourSpecifier() -> [ArcBehaviourSpecifierContext] {
				return getRuleContexts(ArcBehaviourSpecifierContext.self)
			}
			open
			func arcBehaviourSpecifier(_ i: Int) -> ArcBehaviourSpecifierContext? {
				return getRuleContext(ArcBehaviourSpecifierContext.self, i)
			}
			open
			func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
				return getRuleContexts(NullabilitySpecifierContext.self)
			}
			open
			func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, i)
			}
			open
			func ibOutletQualifier() -> [IbOutletQualifierContext] {
				return getRuleContexts(IbOutletQualifierContext.self)
			}
			open
			func ibOutletQualifier(_ i: Int) -> IbOutletQualifierContext? {
				return getRuleContext(IbOutletQualifierContext.self, i)
			}
			open
			func typePrefix() -> [TypePrefixContext] {
				return getRuleContexts(TypePrefixContext.self)
			}
			open
			func typePrefix(_ i: Int) -> TypePrefixContext? {
				return getRuleContext(TypePrefixContext.self, i)
			}
			open
			func typeQualifier() -> [TypeQualifierContext] {
				return getRuleContexts(TypeQualifierContext.self)
			}
			open
			func typeQualifier(_ i: Int) -> TypeQualifierContext? {
				return getRuleContext(TypeQualifierContext.self, i)
			}
			open
			func typeSpecifier() -> [TypeSpecifierContext] {
				return getRuleContexts(TypeSpecifierContext.self)
			}
			open
			func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_declarationSpecifiers
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDeclarationSpecifiers(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDeclarationSpecifiers(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDeclarationSpecifiers(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDeclarationSpecifiers(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declarationSpecifiers() throws -> DeclarationSpecifiersContext {
		let _localctx: DeclarationSpecifiersContext = DeclarationSpecifiersContext(_ctx, getState())
		try enterRule(_localctx, 172, ObjectiveCParser.RULE_declarationSpecifiers)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1118); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(1118)
		 			try _errHandler.sync(self)
		 			switch(try getInterpreter().adaptivePredict(_input,130, _ctx)) {
		 			case 1:
		 				setState(1110)
		 				try storageClassSpecifier()

		 				break
		 			case 2:
		 				setState(1111)
		 				try attributeSpecifier()

		 				break
		 			case 3:
		 				setState(1112)
		 				try arcBehaviourSpecifier()

		 				break
		 			case 4:
		 				setState(1113)
		 				try nullabilitySpecifier()

		 				break
		 			case 5:
		 				setState(1114)
		 				try ibOutletQualifier()

		 				break
		 			case 6:
		 				setState(1115)
		 				try typePrefix()

		 				break
		 			case 7:
		 				setState(1116)
		 				try typeQualifier()

		 				break
		 			case 8:
		 				setState(1117)
		 				try typeSpecifier()

		 				break
		 			default: break
		 			}

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(1120); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,131,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class AttributeSpecifierContext: ParserRuleContext {
			open
			func ATTRIBUTE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue, 0)
			}
			open
			func LP() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.LP.rawValue)
			}
			open
			func LP(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
			}
			open
			func attribute() -> [AttributeContext] {
				return getRuleContexts(AttributeContext.self)
			}
			open
			func attribute(_ i: Int) -> AttributeContext? {
				return getRuleContext(AttributeContext.self, i)
			}
			open
			func RP() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.RP.rawValue)
			}
			open
			func RP(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_attributeSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAttributeSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAttributeSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAttributeSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAttributeSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func attributeSpecifier() throws -> AttributeSpecifierContext {
		let _localctx: AttributeSpecifierContext = AttributeSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 174, ObjectiveCParser.RULE_attributeSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1122)
		 	try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
		 	setState(1123)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1124)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1125)
		 	try attribute()
		 	setState(1130)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1126)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1127)
		 		try attribute()


		 		setState(1132)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(1133)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1134)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class InitDeclaratorListContext: ParserRuleContext {
			open
			func initDeclarator() -> [InitDeclaratorContext] {
				return getRuleContexts(InitDeclaratorContext.self)
			}
			open
			func initDeclarator(_ i: Int) -> InitDeclaratorContext? {
				return getRuleContext(InitDeclaratorContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_initDeclaratorList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInitDeclaratorList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInitDeclaratorList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInitDeclaratorList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInitDeclaratorList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func initDeclaratorList() throws -> InitDeclaratorListContext {
		let _localctx: InitDeclaratorListContext = InitDeclaratorListContext(_ctx, getState())
		try enterRule(_localctx, 176, ObjectiveCParser.RULE_initDeclaratorList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1136)
		 	try initDeclarator()
		 	setState(1141)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1137)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1138)
		 		try initDeclarator()


		 		setState(1143)
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

	public class InitDeclaratorContext: ParserRuleContext {
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
			open
			func initializer() -> InitializerContext? {
				return getRuleContext(InitializerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_initDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInitDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInitDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInitDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInitDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func initDeclarator() throws -> InitDeclaratorContext {
		let _localctx: InitDeclaratorContext = InitDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 178, ObjectiveCParser.RULE_initDeclarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1144)
		 	try declarator()
		 	setState(1147)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1145)
		 		try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 		setState(1146)
		 		try initializer()

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StructOrUnionSpecifierContext: ParserRuleContext {
			open
			func STRUCT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRUCT.rawValue, 0)
			}
			open
			func UNION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNION.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func attributeSpecifier() -> [AttributeSpecifierContext] {
				return getRuleContexts(AttributeSpecifierContext.self)
			}
			open
			func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, i)
			}
			open
			func fieldDeclaration() -> [FieldDeclarationContext] {
				return getRuleContexts(FieldDeclarationContext.self)
			}
			open
			func fieldDeclaration(_ i: Int) -> FieldDeclarationContext? {
				return getRuleContext(FieldDeclarationContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_structOrUnionSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStructOrUnionSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStructOrUnionSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStructOrUnionSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitStructOrUnionSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func structOrUnionSpecifier() throws -> StructOrUnionSpecifierContext {
		let _localctx: StructOrUnionSpecifierContext = StructOrUnionSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 180, ObjectiveCParser.RULE_structOrUnionSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1149)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.STRUCT.rawValue || _la == ObjectiveCParser.Tokens.UNION.rawValue
		 	      return testSet
		 	 }())) {
		 	try _errHandler.recoverInline(self)
		 	}
		 	else {
		 		_errHandler.reportMatch(self)
		 		try consume()
		 	}
		 	setState(1153)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1150)
		 		try attributeSpecifier()


		 		setState(1155)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(1168)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,138, _ctx)) {
		 	case 1:
		 		setState(1156)
		 		try identifier()

		 		break
		 	case 2:
		 		setState(1158)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1157)
		 			try identifier()

		 		}

		 		setState(1160)
		 		try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 		setState(1162) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(1161)
		 			try fieldDeclaration()


		 			setState(1164); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }())
		 		setState(1166)
		 		try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

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

	public class FieldDeclarationContext: ParserRuleContext {
			open
			func specifierQualifierList() -> SpecifierQualifierListContext? {
				return getRuleContext(SpecifierQualifierListContext.self, 0)
			}
			open
			func fieldDeclaratorList() -> FieldDeclaratorListContext? {
				return getRuleContext(FieldDeclaratorListContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func macro() -> MacroContext? {
				return getRuleContext(MacroContext.self, 0)
			}
			open
			func functionPointer() -> FunctionPointerContext? {
				return getRuleContext(FunctionPointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_fieldDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFieldDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFieldDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFieldDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFieldDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func fieldDeclaration() throws -> FieldDeclarationContext {
		let _localctx: FieldDeclarationContext = FieldDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 182, ObjectiveCParser.RULE_fieldDeclaration)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1180)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,140, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1170)
		 		try specifierQualifierList()
		 		setState(1171)
		 		try fieldDeclaratorList()
		 		setState(1173)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1172)
		 			try macro()

		 		}

		 		setState(1175)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1177)
		 		try functionPointer()
		 		setState(1178)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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

	public class SpecifierQualifierListContext: ParserRuleContext {
			open
			func arcBehaviourSpecifier() -> [ArcBehaviourSpecifierContext] {
				return getRuleContexts(ArcBehaviourSpecifierContext.self)
			}
			open
			func arcBehaviourSpecifier(_ i: Int) -> ArcBehaviourSpecifierContext? {
				return getRuleContext(ArcBehaviourSpecifierContext.self, i)
			}
			open
			func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
				return getRuleContexts(NullabilitySpecifierContext.self)
			}
			open
			func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, i)
			}
			open
			func ibOutletQualifier() -> [IbOutletQualifierContext] {
				return getRuleContexts(IbOutletQualifierContext.self)
			}
			open
			func ibOutletQualifier(_ i: Int) -> IbOutletQualifierContext? {
				return getRuleContext(IbOutletQualifierContext.self, i)
			}
			open
			func typePrefix() -> [TypePrefixContext] {
				return getRuleContexts(TypePrefixContext.self)
			}
			open
			func typePrefix(_ i: Int) -> TypePrefixContext? {
				return getRuleContext(TypePrefixContext.self, i)
			}
			open
			func typeQualifier() -> [TypeQualifierContext] {
				return getRuleContexts(TypeQualifierContext.self)
			}
			open
			func typeQualifier(_ i: Int) -> TypeQualifierContext? {
				return getRuleContext(TypeQualifierContext.self, i)
			}
			open
			func typeSpecifier() -> [TypeSpecifierContext] {
				return getRuleContexts(TypeSpecifierContext.self)
			}
			open
			func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_specifierQualifierList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSpecifierQualifierList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSpecifierQualifierList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSpecifierQualifierList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSpecifierQualifierList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func specifierQualifierList() throws -> SpecifierQualifierListContext {
		let _localctx: SpecifierQualifierListContext = SpecifierQualifierListContext(_ctx, getState())
		try enterRule(_localctx, 184, ObjectiveCParser.RULE_specifierQualifierList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1188); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(1188)
		 			try _errHandler.sync(self)
		 			switch(try getInterpreter().adaptivePredict(_input,141, _ctx)) {
		 			case 1:
		 				setState(1182)
		 				try arcBehaviourSpecifier()

		 				break
		 			case 2:
		 				setState(1183)
		 				try nullabilitySpecifier()

		 				break
		 			case 3:
		 				setState(1184)
		 				try ibOutletQualifier()

		 				break
		 			case 4:
		 				setState(1185)
		 				try typePrefix()

		 				break
		 			case 5:
		 				setState(1186)
		 				try typeQualifier()

		 				break
		 			case 6:
		 				setState(1187)
		 				try typeSpecifier()

		 				break
		 			default: break
		 			}

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(1190); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,142,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class IbOutletQualifierContext: ParserRuleContext {
			open
			func IB_OUTLET_COLLECTION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func IB_OUTLET() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_OUTLET.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_ibOutletQualifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterIbOutletQualifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitIbOutletQualifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitIbOutletQualifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitIbOutletQualifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func ibOutletQualifier() throws -> IbOutletQualifierContext {
		let _localctx: IbOutletQualifierContext = IbOutletQualifierContext(_ctx, getState())
		try enterRule(_localctx, 186, ObjectiveCParser.RULE_ibOutletQualifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1198)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .IB_OUTLET_COLLECTION:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1192)
		 		try match(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue)
		 		setState(1193)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1194)
		 		try identifier()
		 		setState(1195)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break

		 	case .IB_OUTLET:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1197)
		 		try match(ObjectiveCParser.Tokens.IB_OUTLET.rawValue)

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

	public class ArcBehaviourSpecifierContext: ParserRuleContext {
			open
			func WEAK_QUALIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue, 0)
			}
			open
			func STRONG_QUALIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue, 0)
			}
			open
			func AUTORELEASING_QUALIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue, 0)
			}
			open
			func UNSAFE_UNRETAINED_QUALIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_arcBehaviourSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterArcBehaviourSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitArcBehaviourSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitArcBehaviourSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitArcBehaviourSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arcBehaviourSpecifier() throws -> ArcBehaviourSpecifierContext {
		let _localctx: ArcBehaviourSpecifierContext = ArcBehaviourSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 188, ObjectiveCParser.RULE_arcBehaviourSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1200)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 85)
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

	public class NullabilitySpecifierContext: ParserRuleContext {
			open
			func NULL_UNSPECIFIED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue, 0)
			}
			open
			func NULLABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULLABLE.rawValue, 0)
			}
			open
			func NONNULL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NONNULL.rawValue, 0)
			}
			open
			func NULL_RESETTABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_nullabilitySpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterNullabilitySpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitNullabilitySpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitNullabilitySpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitNullabilitySpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func nullabilitySpecifier() throws -> NullabilitySpecifierContext {
		let _localctx: NullabilitySpecifierContext = NullabilitySpecifierContext(_ctx, getState())
		try enterRule(_localctx, 190, ObjectiveCParser.RULE_nullabilitySpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1202)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 99)
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

	public class StorageClassSpecifierContext: ParserRuleContext {
			open
			func AUTO() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AUTO.rawValue, 0)
			}
			open
			func REGISTER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.REGISTER.rawValue, 0)
			}
			open
			func STATIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STATIC.rawValue, 0)
			}
			open
			func EXTERN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.EXTERN.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_storageClassSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStorageClassSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStorageClassSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStorageClassSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitStorageClassSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func storageClassSpecifier() throws -> StorageClassSpecifierContext {
		let _localctx: StorageClassSpecifierContext = StorageClassSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 192, ObjectiveCParser.RULE_storageClassSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1204)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue]
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

	public class TypePrefixContext: ParserRuleContext {
			open
			func BRIDGE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BRIDGE.rawValue, 0)
			}
			open
			func BRIDGE_TRANSFER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue, 0)
			}
			open
			func BRIDGE_RETAINED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue, 0)
			}
			open
			func BLOCK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BLOCK.rawValue, 0)
			}
			open
			func INLINE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INLINE.rawValue, 0)
			}
			open
			func NS_INLINE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_INLINE.rawValue, 0)
			}
			open
			func KINDOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typePrefix
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypePrefix(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypePrefix(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypePrefix(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypePrefix(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typePrefix() throws -> TypePrefixContext {
		let _localctx: TypePrefixContext = TypePrefixContext(_ctx, getState())
		try enterRule(_localctx, 194, ObjectiveCParser.RULE_typePrefix)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1206)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = _la == ObjectiveCParser.Tokens.INLINE.rawValue
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 86)
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

	public class TypeQualifierContext: ParserRuleContext {
			open
			func CONST() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CONST.rawValue, 0)
			}
			open
			func VOLATILE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.VOLATILE.rawValue, 0)
			}
			open
			func RESTRICT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RESTRICT.rawValue, 0)
			}
			open
			func protocolQualifier() -> ProtocolQualifierContext? {
				return getRuleContext(ProtocolQualifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeQualifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeQualifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeQualifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeQualifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeQualifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeQualifier() throws -> TypeQualifierContext {
		let _localctx: TypeQualifierContext = TypeQualifierContext(_ctx, getState())
		try enterRule(_localctx, 196, ObjectiveCParser.RULE_typeQualifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1212)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .CONST:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1208)
		 		try match(ObjectiveCParser.Tokens.CONST.rawValue)

		 		break

		 	case .VOLATILE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1209)
		 		try match(ObjectiveCParser.Tokens.VOLATILE.rawValue)

		 		break

		 	case .RESTRICT:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1210)
		 		try match(ObjectiveCParser.Tokens.RESTRICT.rawValue)

		 		break
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1211)
		 		try protocolQualifier()

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

	public class ProtocolQualifierContext: ParserRuleContext {
			open
			func IN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0)
			}
			open
			func OUT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OUT.rawValue, 0)
			}
			open
			func INOUT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INOUT.rawValue, 0)
			}
			open
			func BYCOPY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BYCOPY.rawValue, 0)
			}
			open
			func BYREF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BYREF.rawValue, 0)
			}
			open
			func ONEWAY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ONEWAY.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_protocolQualifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterProtocolQualifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitProtocolQualifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitProtocolQualifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitProtocolQualifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func protocolQualifier() throws -> ProtocolQualifierContext {
		let _localctx: ProtocolQualifierContext = ProtocolQualifierContext(_ctx, getState())
		try enterRule(_localctx, 198, ObjectiveCParser.RULE_protocolQualifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1214)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue]
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

	public class TypeSpecifierContext: ParserRuleContext {
			open
			func scalarTypeSpecifier() -> ScalarTypeSpecifierContext? {
				return getRuleContext(ScalarTypeSpecifierContext.self, 0)
			}
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
			open
			func typeofExpression() -> TypeofExpressionContext? {
				return getRuleContext(TypeofExpressionContext.self, 0)
			}
			open
			func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
				return getRuleContext(GenericTypeSpecifierContext.self, 0)
			}
			open
			func KINDOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
			}
			open
			func structOrUnionSpecifier() -> StructOrUnionSpecifierContext? {
				return getRuleContext(StructOrUnionSpecifierContext.self, 0)
			}
			open
			func enumSpecifier() -> EnumSpecifierContext? {
				return getRuleContext(EnumSpecifierContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeSpecifier() throws -> TypeSpecifierContext {
		let _localctx: TypeSpecifierContext = TypeSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 200, ObjectiveCParser.RULE_typeSpecifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1240)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,151, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1216)
		 		try scalarTypeSpecifier()
		 		setState(1218)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,145,_ctx)) {
		 		case 1:
		 			setState(1217)
		 			try pointer()

		 			break
		 		default: break
		 		}

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1220)
		 		try typeofExpression()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1222)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,146,_ctx)) {
		 		case 1:
		 			setState(1221)
		 			try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(1224)
		 		try genericTypeSpecifier()
		 		setState(1226)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,147,_ctx)) {
		 		case 1:
		 			setState(1225)
		 			try pointer()

		 			break
		 		default: break
		 		}

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1228)
		 		try structOrUnionSpecifier()
		 		setState(1230)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,148,_ctx)) {
		 		case 1:
		 			setState(1229)
		 			try pointer()

		 			break
		 		default: break
		 		}

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(1232)
		 		try enumSpecifier()

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(1234)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,149,_ctx)) {
		 		case 1:
		 			setState(1233)
		 			try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(1236)
		 		try identifier()
		 		setState(1238)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,150,_ctx)) {
		 		case 1:
		 			setState(1237)
		 			try pointer()

		 			break
		 		default: break
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

	public class ScalarTypeSpecifierContext: ParserRuleContext {
			open
			func VOID() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
			}
			open
			func CHAR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CHAR.rawValue, 0)
			}
			open
			func SHORT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SHORT.rawValue, 0)
			}
			open
			func INT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INT.rawValue, 0)
			}
			open
			func LONG() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LONG.rawValue, 0)
			}
			open
			func FLOAT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FLOAT.rawValue, 0)
			}
			open
			func DOUBLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DOUBLE.rawValue, 0)
			}
			open
			func SIGNED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SIGNED.rawValue, 0)
			}
			open
			func UNSIGNED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNSIGNED.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_scalarTypeSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterScalarTypeSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitScalarTypeSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitScalarTypeSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitScalarTypeSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func scalarTypeSpecifier() throws -> ScalarTypeSpecifierContext {
		let _localctx: ScalarTypeSpecifierContext = ScalarTypeSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 202, ObjectiveCParser.RULE_scalarTypeSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1242)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue]
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

	public class TypeofExpressionContext: ParserRuleContext {
			open
			func TYPEOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TYPEOF.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeofExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeofExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeofExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeofExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeofExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeofExpression() throws -> TypeofExpressionContext {
		let _localctx: TypeofExpressionContext = TypeofExpressionContext(_ctx, getState())
		try enterRule(_localctx, 204, ObjectiveCParser.RULE_typeofExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1244)
		 	try match(ObjectiveCParser.Tokens.TYPEOF.rawValue)

		 	setState(1245)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1246)
		 	try expression(0)
		 	setState(1247)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class FieldDeclaratorListContext: ParserRuleContext {
			open
			func fieldDeclarator() -> [FieldDeclaratorContext] {
				return getRuleContexts(FieldDeclaratorContext.self)
			}
			open
			func fieldDeclarator(_ i: Int) -> FieldDeclaratorContext? {
				return getRuleContext(FieldDeclaratorContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_fieldDeclaratorList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFieldDeclaratorList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFieldDeclaratorList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFieldDeclaratorList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFieldDeclaratorList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func fieldDeclaratorList() throws -> FieldDeclaratorListContext {
		let _localctx: FieldDeclaratorListContext = FieldDeclaratorListContext(_ctx, getState())
		try enterRule(_localctx, 206, ObjectiveCParser.RULE_fieldDeclaratorList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1249)
		 	try fieldDeclarator()
		 	setState(1254)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1250)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1251)
		 		try fieldDeclarator()


		 		setState(1256)
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

	public class FieldDeclaratorContext: ParserRuleContext {
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_fieldDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterFieldDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitFieldDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitFieldDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitFieldDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func fieldDeclarator() throws -> FieldDeclaratorContext {
		let _localctx: FieldDeclaratorContext = FieldDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 208, ObjectiveCParser.RULE_fieldDeclarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1263)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,154, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1257)
		 		try declarator()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1259)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 40)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 104)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1258)
		 			try declarator()

		 		}

		 		setState(1261)
		 		try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 		setState(1262)
		 		try constant()

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

	public class EnumSpecifierContext: ParserRuleContext {
			open
			func ENUM() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ENUM.rawValue, 0)
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
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func enumeratorList() -> EnumeratorListContext? {
				return getRuleContext(EnumeratorListContext.self, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func typeName() -> TypeNameContext? {
				return getRuleContext(TypeNameContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func COMMA() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func NS_OPTIONS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_OPTIONS.rawValue, 0)
			}
			open
			func NS_ENUM() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_ENUM.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_enumSpecifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEnumSpecifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEnumSpecifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEnumSpecifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEnumSpecifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func enumSpecifier() throws -> EnumSpecifierContext {
		let _localctx: EnumSpecifierContext = EnumSpecifierContext(_ctx, getState())
		try enterRule(_localctx, 210, ObjectiveCParser.RULE_enumSpecifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1296)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .ENUM:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1265)
		 		try match(ObjectiveCParser.Tokens.ENUM.rawValue)
		 		setState(1271)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,156,_ctx)) {
		 		case 1:
		 			setState(1267)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			if (//closure
		 			 { () -> Bool in
		 			      var testSet: Bool = {  () -> Bool in
		 			   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 			    return  Utils.testBitLeftShiftArray(testArray, 0)
		 			}()
		 			          testSet = testSet || {  () -> Bool in
		 			             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 			              return  Utils.testBitLeftShiftArray(testArray, 81)
		 			          }()
		 			      return testSet
		 			 }()) {
		 				setState(1266)
		 				try identifier()

		 			}

		 			setState(1269)
		 			try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 			setState(1270)
		 			try typeName()

		 			break
		 		default: break
		 		}
		 		setState(1284)
		 		try _errHandler.sync(self)
		 		switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .BOOL:fallthrough
		 		case .Class:fallthrough
		 		case .BYCOPY:fallthrough
		 		case .BYREF:fallthrough
		 		case .ID:fallthrough
		 		case .IMP:fallthrough
		 		case .IN:fallthrough
		 		case .INOUT:fallthrough
		 		case .ONEWAY:fallthrough
		 		case .OUT:fallthrough
		 		case .PROTOCOL_:fallthrough
		 		case .SEL:fallthrough
		 		case .SELF:fallthrough
		 		case .SUPER:fallthrough
		 		case .ATOMIC:fallthrough
		 		case .NONATOMIC:fallthrough
		 		case .RETAIN:fallthrough
		 		case .AUTORELEASING_QUALIFIER:fallthrough
		 		case .BLOCK:fallthrough
		 		case .BRIDGE_RETAINED:fallthrough
		 		case .BRIDGE_TRANSFER:fallthrough
		 		case .COVARIANT:fallthrough
		 		case .CONTRAVARIANT:fallthrough
		 		case .DEPRECATED:fallthrough
		 		case .KINDOF:fallthrough
		 		case .UNUSED:fallthrough
		 		case .NULL_UNSPECIFIED:fallthrough
		 		case .NULLABLE:fallthrough
		 		case .NONNULL:fallthrough
		 		case .NULL_RESETTABLE:fallthrough
		 		case .NS_INLINE:fallthrough
		 		case .NS_ENUM:fallthrough
		 		case .NS_OPTIONS:fallthrough
		 		case .ASSIGN:fallthrough
		 		case .COPY:fallthrough
		 		case .GETTER:fallthrough
		 		case .SETTER:fallthrough
		 		case .STRONG:fallthrough
		 		case .READONLY:fallthrough
		 		case .READWRITE:fallthrough
		 		case .WEAK:fallthrough
		 		case .UNSAFE_UNRETAINED:fallthrough
		 		case .IB_OUTLET:fallthrough
		 		case .IB_OUTLET_COLLECTION:fallthrough
		 		case .IB_INSPECTABLE:fallthrough
		 		case .IB_DESIGNABLE:fallthrough
		 		case .IDENTIFIER:
		 			setState(1273)
		 			try identifier()
		 			setState(1278)
		 			try _errHandler.sync(self)
		 			switch (try getInterpreter().adaptivePredict(_input,157,_ctx)) {
		 			case 1:
		 				setState(1274)
		 				try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 				setState(1275)
		 				try enumeratorList()
		 				setState(1276)
		 				try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		 				break
		 			default: break
		 			}

		 			break

		 		case .LBRACE:
		 			setState(1280)
		 			try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 			setState(1281)
		 			try enumeratorList()
		 			setState(1282)
		 			try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}

		 		break
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1286)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.NS_ENUM.rawValue || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue
		 		      return testSet
		 		 }())) {
		 		try _errHandler.recoverInline(self)
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}
		 		setState(1287)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1288)
		 		try typeName()
		 		setState(1289)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1290)
		 		try identifier()
		 		setState(1291)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)
		 		setState(1292)
		 		try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 		setState(1293)
		 		try enumeratorList()
		 		setState(1294)
		 		try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

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

	public class EnumeratorListContext: ParserRuleContext {
			open
			func enumerator() -> [EnumeratorContext] {
				return getRuleContexts(EnumeratorContext.self)
			}
			open
			func enumerator(_ i: Int) -> EnumeratorContext? {
				return getRuleContext(EnumeratorContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_enumeratorList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEnumeratorList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEnumeratorList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEnumeratorList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEnumeratorList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func enumeratorList() throws -> EnumeratorListContext {
		let _localctx: EnumeratorListContext = EnumeratorListContext(_ctx, getState())
		try enterRule(_localctx, 212, ObjectiveCParser.RULE_enumeratorList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1298)
		 	try enumerator()
		 	setState(1303)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,160,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(1299)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1300)
		 			try enumerator()

		 	 
		 		}
		 		setState(1305)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,160,_ctx)
		 	}
		 	setState(1307)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1306)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EnumeratorContext: ParserRuleContext {
			open
			func enumeratorIdentifier() -> EnumeratorIdentifierContext? {
				return getRuleContext(EnumeratorIdentifierContext.self, 0)
			}
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_enumerator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEnumerator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEnumerator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEnumerator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEnumerator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func enumerator() throws -> EnumeratorContext {
		let _localctx: EnumeratorContext = EnumeratorContext(_ctx, getState())
		try enterRule(_localctx, 214, ObjectiveCParser.RULE_enumerator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1309)
		 	try enumeratorIdentifier()
		 	setState(1312)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1310)
		 		try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
		 		setState(1311)
		 		try expression(0)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class EnumeratorIdentifierContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_enumeratorIdentifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterEnumeratorIdentifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitEnumeratorIdentifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitEnumeratorIdentifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitEnumeratorIdentifier(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func enumeratorIdentifier() throws -> EnumeratorIdentifierContext {
		let _localctx: EnumeratorIdentifierContext = EnumeratorIdentifierContext(_ctx, getState())
		try enterRule(_localctx, 216, ObjectiveCParser.RULE_enumeratorIdentifier)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1314)
		 	try identifier()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DirectDeclaratorContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func declaratorSuffix() -> [DeclaratorSuffixContext] {
				return getRuleContexts(DeclaratorSuffixContext.self)
			}
			open
			func declaratorSuffix(_ i: Int) -> DeclaratorSuffixContext? {
				return getRuleContext(DeclaratorSuffixContext.self, i)
			}
			open
			func attributeSpecifier() -> AttributeSpecifierContext? {
				return getRuleContext(AttributeSpecifierContext.self, 0)
			}
			open
			func BITXOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
			}
			open
			func blockParameters() -> BlockParametersContext? {
				return getRuleContext(BlockParametersContext.self, 0)
			}
			open
			func nullabilitySpecifier() -> NullabilitySpecifierContext? {
				return getRuleContext(NullabilitySpecifierContext.self, 0)
			}
			open
			func MUL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_directDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDirectDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDirectDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDirectDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDirectDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func directDeclarator() throws -> DirectDeclaratorContext {
		let _localctx: DirectDeclaratorContext = DirectDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 218, ObjectiveCParser.RULE_directDeclarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1352)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,170, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1321)
		 		try _errHandler.sync(self)
		 		switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 		case .BOOL:fallthrough
		 		case .Class:fallthrough
		 		case .BYCOPY:fallthrough
		 		case .BYREF:fallthrough
		 		case .ID:fallthrough
		 		case .IMP:fallthrough
		 		case .IN:fallthrough
		 		case .INOUT:fallthrough
		 		case .ONEWAY:fallthrough
		 		case .OUT:fallthrough
		 		case .PROTOCOL_:fallthrough
		 		case .SEL:fallthrough
		 		case .SELF:fallthrough
		 		case .SUPER:fallthrough
		 		case .ATOMIC:fallthrough
		 		case .NONATOMIC:fallthrough
		 		case .RETAIN:fallthrough
		 		case .AUTORELEASING_QUALIFIER:fallthrough
		 		case .BLOCK:fallthrough
		 		case .BRIDGE_RETAINED:fallthrough
		 		case .BRIDGE_TRANSFER:fallthrough
		 		case .COVARIANT:fallthrough
		 		case .CONTRAVARIANT:fallthrough
		 		case .DEPRECATED:fallthrough
		 		case .KINDOF:fallthrough
		 		case .UNUSED:fallthrough
		 		case .NULL_UNSPECIFIED:fallthrough
		 		case .NULLABLE:fallthrough
		 		case .NONNULL:fallthrough
		 		case .NULL_RESETTABLE:fallthrough
		 		case .NS_INLINE:fallthrough
		 		case .NS_ENUM:fallthrough
		 		case .NS_OPTIONS:fallthrough
		 		case .ASSIGN:fallthrough
		 		case .COPY:fallthrough
		 		case .GETTER:fallthrough
		 		case .SETTER:fallthrough
		 		case .STRONG:fallthrough
		 		case .READONLY:fallthrough
		 		case .READWRITE:fallthrough
		 		case .WEAK:fallthrough
		 		case .UNSAFE_UNRETAINED:fallthrough
		 		case .IB_OUTLET:fallthrough
		 		case .IB_OUTLET_COLLECTION:fallthrough
		 		case .IB_INSPECTABLE:fallthrough
		 		case .IB_DESIGNABLE:fallthrough
		 		case .IDENTIFIER:
		 			setState(1316)
		 			try identifier()

		 			break

		 		case .LP:
		 			setState(1317)
		 			try match(ObjectiveCParser.Tokens.LP.rawValue)
		 			setState(1318)
		 			try declarator()
		 			setState(1319)
		 			try match(ObjectiveCParser.Tokens.RP.rawValue)

		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(1326)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACK.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1323)
		 			try declaratorSuffix()


		 			setState(1328)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(1330)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,165,_ctx)) {
		 		case 1:
		 			setState(1329)
		 			try attributeSpecifier()

		 			break
		 		default: break
		 		}

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1332)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1333)
		 		try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
		 		setState(1335)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,166,_ctx)) {
		 		case 1:
		 			setState(1334)
		 			try nullabilitySpecifier()

		 			break
		 		default: break
		 		}
		 		setState(1338)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1337)
		 			try identifier()

		 		}

		 		setState(1340)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)
		 		setState(1341)
		 		try blockParameters()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1342)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1343)
		 		try match(ObjectiveCParser.Tokens.MUL.rawValue)
		 		setState(1345)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,168,_ctx)) {
		 		case 1:
		 			setState(1344)
		 			try nullabilitySpecifier()

		 			break
		 		default: break
		 		}
		 		setState(1348)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1347)
		 			try identifier()

		 		}

		 		setState(1350)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)
		 		setState(1351)
		 		try blockParameters()

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

	public class DeclaratorSuffixContext: ParserRuleContext {
			open
			func LBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
			}
			open
			func RBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
			}
			open
			func constantExpression() -> ConstantExpressionContext? {
				return getRuleContext(ConstantExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_declaratorSuffix
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDeclaratorSuffix(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDeclaratorSuffix(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDeclaratorSuffix(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDeclaratorSuffix(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declaratorSuffix() throws -> DeclaratorSuffixContext {
		let _localctx: DeclaratorSuffixContext = DeclaratorSuffixContext(_ctx, getState())
		try enterRule(_localctx, 220, ObjectiveCParser.RULE_declaratorSuffix)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1354)
		 	try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 	setState(1356)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 152)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1355)
		 		try constantExpression()

		 	}

		 	setState(1358)
		 	try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ParameterListContext: ParserRuleContext {
			open
			func parameterDeclarationList() -> ParameterDeclarationListContext? {
				return getRuleContext(ParameterDeclarationListContext.self, 0)
			}
			open
			func COMMA() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
			}
			open
			func ELIPSIS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_parameterList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterParameterList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitParameterList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitParameterList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitParameterList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func parameterList() throws -> ParameterListContext {
		let _localctx: ParameterListContext = ParameterListContext(_ctx, getState())
		try enterRule(_localctx, 222, ObjectiveCParser.RULE_parameterList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1360)
		 	try parameterDeclarationList()
		 	setState(1363)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1361)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1362)
		 		try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class PointerContext: ParserRuleContext {
			open
			func MUL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
			}
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_pointer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPointer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPointer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPointer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPointer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func pointer() throws -> PointerContext {
		let _localctx: PointerContext = PointerContext(_ctx, getState())
		try enterRule(_localctx, 224, ObjectiveCParser.RULE_pointer)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1365)
		 	try match(ObjectiveCParser.Tokens.MUL.rawValue)
		 	setState(1367)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,173,_ctx)) {
		 	case 1:
		 		setState(1366)
		 		try declarationSpecifiers()

		 		break
		 	default: break
		 	}
		 	setState(1370)
		 	try _errHandler.sync(self)
		 	switch (try getInterpreter().adaptivePredict(_input,174,_ctx)) {
		 	case 1:
		 		setState(1369)
		 		try pointer()

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

	public class MacroContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func primaryExpression() -> [PrimaryExpressionContext] {
				return getRuleContexts(PrimaryExpressionContext.self)
			}
			open
			func primaryExpression(_ i: Int) -> PrimaryExpressionContext? {
				return getRuleContext(PrimaryExpressionContext.self, i)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_macro
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterMacro(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitMacro(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitMacro(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitMacro(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func macro() throws -> MacroContext {
		let _localctx: MacroContext = MacroContext(_ctx, getState())
		try enterRule(_localctx, 226, ObjectiveCParser.RULE_macro)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1372)
		 	try identifier()
		 	setState(1384)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1373)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1374)
		 		try primaryExpression()
		 		setState(1379)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1375)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1376)
		 			try primaryExpression()


		 			setState(1381)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		}
		 		setState(1382)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ArrayInitializerContext: ParserRuleContext {
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_arrayInitializer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterArrayInitializer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitArrayInitializer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitArrayInitializer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitArrayInitializer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func arrayInitializer() throws -> ArrayInitializerContext {
		let _localctx: ArrayInitializerContext = ArrayInitializerContext(_ctx, getState())
		try enterRule(_localctx, 228, ObjectiveCParser.RULE_arrayInitializer)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1386)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(1398)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1387)
		 		try expression(0)
		 		setState(1392)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,177,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(1388)
		 				try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 				setState(1389)
		 				try expression(0)

		 		 
		 			}
		 			setState(1394)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,177,_ctx)
		 		}
		 		setState(1396)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1395)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(1400)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StructInitializerContext: ParserRuleContext {
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func structInitializerItem() -> [StructInitializerItemContext] {
				return getRuleContexts(StructInitializerItemContext.self)
			}
			open
			func structInitializerItem(_ i: Int) -> StructInitializerItemContext? {
				return getRuleContext(StructInitializerItemContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_structInitializer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStructInitializer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStructInitializer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStructInitializer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitStructInitializer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func structInitializer() throws -> StructInitializerContext {
		let _localctx: StructInitializerContext = StructInitializerContext(_ctx, getState())
		try enterRule(_localctx, 230, ObjectiveCParser.RULE_structInitializer)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1402)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(1414)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACE.rawValue || _la == ObjectiveCParser.Tokens.DOT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1403)
		 		try structInitializerItem()
		 		setState(1408)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,180,_ctx)
		 		while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 			if ( _alt==1 ) {
		 				setState(1404)
		 				try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 				setState(1405)
		 				try structInitializerItem()

		 		 
		 			}
		 			setState(1410)
		 			try _errHandler.sync(self)
		 			_alt = try getInterpreter().adaptivePredict(_input,180,_ctx)
		 		}
		 		setState(1412)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1411)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 		}


		 	}

		 	setState(1416)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class StructInitializerItemContext: ParserRuleContext {
			open
			func DOT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DOT.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func structInitializer() -> StructInitializerContext? {
				return getRuleContext(StructInitializerContext.self, 0)
			}
			open
			func arrayInitializer() -> ArrayInitializerContext? {
				return getRuleContext(ArrayInitializerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_structInitializerItem
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStructInitializerItem(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStructInitializerItem(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStructInitializerItem(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitStructInitializerItem(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func structInitializerItem() throws -> StructInitializerItemContext {
		let _localctx: StructInitializerItemContext = StructInitializerItemContext(_ctx, getState())
		try enterRule(_localctx, 232, ObjectiveCParser.RULE_structInitializerItem)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1422)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,183, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1418)
		 		try match(ObjectiveCParser.Tokens.DOT.rawValue)
		 		setState(1419)
		 		try expression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1420)
		 		try structInitializer()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1421)
		 		try arrayInitializer()

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

	public class InitializerListContext: ParserRuleContext {
			open
			func initializer() -> [InitializerContext] {
				return getRuleContexts(InitializerContext.self)
			}
			open
			func initializer(_ i: Int) -> InitializerContext? {
				return getRuleContext(InitializerContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_initializerList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInitializerList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInitializerList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInitializerList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInitializerList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func initializerList() throws -> InitializerListContext {
		let _localctx: InitializerListContext = InitializerListContext(_ctx, getState())
		try enterRule(_localctx, 234, ObjectiveCParser.RULE_initializerList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1424)
		 	try initializer()
		 	setState(1429)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,184,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(1425)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1426)
		 			try initializer()

		 	 
		 		}
		 		setState(1431)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,184,_ctx)
		 	}
		 	setState(1433)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1432)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class TypeNameContext: ParserRuleContext {
			open
			func specifierQualifierList() -> SpecifierQualifierListContext? {
				return getRuleContext(SpecifierQualifierListContext.self, 0)
			}
			open
			func abstractDeclarator() -> AbstractDeclaratorContext? {
				return getRuleContext(AbstractDeclaratorContext.self, 0)
			}
			open
			func blockType() -> BlockTypeContext? {
				return getRuleContext(BlockTypeContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_typeName
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterTypeName(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitTypeName(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitTypeName(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitTypeName(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func typeName() throws -> TypeNameContext {
		let _localctx: TypeNameContext = TypeNameContext(_ctx, getState())
		try enterRule(_localctx, 236, ObjectiveCParser.RULE_typeName)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1440)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,187, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1435)
		 		try specifierQualifierList()
		 		setState(1437)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 126)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(1436)
		 			try abstractDeclarator()

		 		}


		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1439)
		 		try blockType()

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

	public class AbstractDeclaratorContext: ParserRuleContext {
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
			open
			func abstractDeclarator() -> AbstractDeclaratorContext? {
				return getRuleContext(AbstractDeclaratorContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func abstractDeclaratorSuffix() -> [AbstractDeclaratorSuffixContext] {
				return getRuleContexts(AbstractDeclaratorSuffixContext.self)
			}
			open
			func abstractDeclaratorSuffix(_ i: Int) -> AbstractDeclaratorSuffixContext? {
				return getRuleContext(AbstractDeclaratorSuffixContext.self, i)
			}
			open
			func LBRACK() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.LBRACK.rawValue)
			}
			open
			func LBRACK(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, i)
			}
			open
			func RBRACK() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.RBRACK.rawValue)
			}
			open
			func RBRACK(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, i)
			}
			open
			func constantExpression() -> [ConstantExpressionContext] {
				return getRuleContexts(ConstantExpressionContext.self)
			}
			open
			func constantExpression(_ i: Int) -> ConstantExpressionContext? {
				return getRuleContext(ConstantExpressionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_abstractDeclarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAbstractDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAbstractDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAbstractDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAbstractDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func abstractDeclarator() throws -> AbstractDeclaratorContext {
		let _localctx: AbstractDeclaratorContext = AbstractDeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 238, ObjectiveCParser.RULE_abstractDeclarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1465)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .MUL:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1442)
		 		try pointer()
		 		setState(1444)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 126)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(1443)
		 			try abstractDeclarator()

		 		}


		 		break

		 	case .LP:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1446)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1448)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.MUL.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 126)
		 		}()
		 		      return testSet
		 		 }()) {
		 			setState(1447)
		 			try abstractDeclarator()

		 		}

		 		setState(1450)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)
		 		setState(1452) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(1451)
		 			try abstractDeclaratorSuffix()


		 			setState(1454); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.LP.rawValue || _la == ObjectiveCParser.Tokens.LBRACK.rawValue
		 		      return testSet
		 		 }())

		 		break

		 	case .LBRACK:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1461) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(1456)
		 			try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 			setState(1458)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			if (//closure
		 			 { () -> Bool in
		 			      var testSet: Bool = {  () -> Bool in
		 			   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue]
		 			    return  Utils.testBitLeftShiftArray(testArray, 0)
		 			}()
		 			          testSet = testSet || {  () -> Bool in
		 			             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 			              return  Utils.testBitLeftShiftArray(testArray, 81)
		 			          }()
		 			          testSet = testSet || {  () -> Bool in
		 			             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 			              return  Utils.testBitLeftShiftArray(testArray, 152)
		 			          }()
		 			      return testSet
		 			 }()) {
		 				setState(1457)
		 				try constantExpression()

		 			}

		 			setState(1460)
		 			try match(ObjectiveCParser.Tokens.RBRACK.rawValue)


		 			setState(1463); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.LBRACK.rawValue
		 		      return testSet
		 		 }())

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

	public class AbstractDeclaratorSuffixContext: ParserRuleContext {
			open
			func LBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
			}
			open
			func RBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
			}
			open
			func constantExpression() -> ConstantExpressionContext? {
				return getRuleContext(ConstantExpressionContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func parameterDeclarationList() -> ParameterDeclarationListContext? {
				return getRuleContext(ParameterDeclarationListContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_abstractDeclaratorSuffix
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAbstractDeclaratorSuffix(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAbstractDeclaratorSuffix(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAbstractDeclaratorSuffix(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitAbstractDeclaratorSuffix(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func abstractDeclaratorSuffix() throws -> AbstractDeclaratorSuffixContext {
		let _localctx: AbstractDeclaratorSuffixContext = AbstractDeclaratorSuffixContext(_ctx, getState())
		try enterRule(_localctx, 240, ObjectiveCParser.RULE_abstractDeclaratorSuffix)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1477)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .LBRACK:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1467)
		 		try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 		setState(1469)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 152)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1468)
		 			try constantExpression()

		 		}

		 		setState(1471)
		 		try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

		 		break

		 	case .LP:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1472)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1474)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 81)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1473)
		 			try parameterDeclarationList()

		 		}

		 		setState(1476)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

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

	public class ParameterDeclarationListContext: ParserRuleContext {
			open
			func parameterDeclaration() -> [ParameterDeclarationContext] {
				return getRuleContexts(ParameterDeclarationContext.self)
			}
			open
			func parameterDeclaration(_ i: Int) -> ParameterDeclarationContext? {
				return getRuleContext(ParameterDeclarationContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_parameterDeclarationList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterParameterDeclarationList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitParameterDeclarationList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitParameterDeclarationList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitParameterDeclarationList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func parameterDeclarationList() throws -> ParameterDeclarationListContext {
		let _localctx: ParameterDeclarationListContext = ParameterDeclarationListContext(_ctx, getState())
		try enterRule(_localctx, 242, ObjectiveCParser.RULE_parameterDeclarationList)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1479)
		 	try parameterDeclaration()
		 	setState(1484)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,197,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(1480)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1481)
		 			try parameterDeclaration()

		 	 
		 		}
		 		setState(1486)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,197,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ParameterDeclarationContext: ParserRuleContext {
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func declarator() -> DeclaratorContext? {
				return getRuleContext(DeclaratorContext.self, 0)
			}
			open
			func functionPointer() -> FunctionPointerContext? {
				return getRuleContext(FunctionPointerContext.self, 0)
			}
			open
			func VOID() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_parameterDeclaration
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterParameterDeclaration(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitParameterDeclaration(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitParameterDeclaration(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitParameterDeclaration(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func parameterDeclaration() throws -> ParameterDeclarationContext {
		let _localctx: ParameterDeclarationContext = ParameterDeclarationContext(_ctx, getState())
		try enterRule(_localctx, 244, ObjectiveCParser.RULE_parameterDeclaration)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1492)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,198, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1487)
		 		try declarationSpecifiers()
		 		setState(1488)
		 		try declarator()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1490)
		 		try functionPointer()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1491)
		 		try match(ObjectiveCParser.Tokens.VOID.rawValue)

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

	public class DeclaratorContext: ParserRuleContext {
			open
			func directDeclarator() -> DirectDeclaratorContext? {
				return getRuleContext(DirectDeclaratorContext.self, 0)
			}
			open
			func pointer() -> PointerContext? {
				return getRuleContext(PointerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_declarator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDeclarator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDeclarator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDeclarator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDeclarator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func declarator() throws -> DeclaratorContext {
		let _localctx: DeclaratorContext = DeclaratorContext(_ctx, getState())
		try enterRule(_localctx, 246, ObjectiveCParser.RULE_declarator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1495)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.MUL.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1494)
		 		try pointer()

		 	}

		 	setState(1497)
		 	try directDeclarator()

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
			func labeledStatement() -> LabeledStatementContext? {
				return getRuleContext(LabeledStatementContext.self, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
			open
			func selectionStatement() -> SelectionStatementContext? {
				return getRuleContext(SelectionStatementContext.self, 0)
			}
			open
			func iterationStatement() -> IterationStatementContext? {
				return getRuleContext(IterationStatementContext.self, 0)
			}
			open
			func jumpStatement() -> JumpStatementContext? {
				return getRuleContext(JumpStatementContext.self, 0)
			}
			open
			func synchronizedStatement() -> SynchronizedStatementContext? {
				return getRuleContext(SynchronizedStatementContext.self, 0)
			}
			open
			func autoreleaseStatement() -> AutoreleaseStatementContext? {
				return getRuleContext(AutoreleaseStatementContext.self, 0)
			}
			open
			func throwStatement() -> ThrowStatementContext? {
				return getRuleContext(ThrowStatementContext.self, 0)
			}
			open
			func tryBlock() -> TryBlockContext? {
				return getRuleContext(TryBlockContext.self, 0)
			}
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_statement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 248, ObjectiveCParser.RULE_statement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1537)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,207, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1499)
		 		try labeledStatement()
		 		setState(1501)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,200,_ctx)) {
		 		case 1:
		 			setState(1500)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1503)
		 		try compoundStatement()
		 		setState(1505)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,201,_ctx)) {
		 		case 1:
		 			setState(1504)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1507)
		 		try selectionStatement()
		 		setState(1509)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,202,_ctx)) {
		 		case 1:
		 			setState(1508)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1511)
		 		try iterationStatement()
		 		setState(1513)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,203,_ctx)) {
		 		case 1:
		 			setState(1512)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(1515)
		 		try jumpStatement()
		 		setState(1516)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(1518)
		 		try synchronizedStatement()
		 		setState(1520)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,204,_ctx)) {
		 		case 1:
		 			setState(1519)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(1522)
		 		try autoreleaseStatement()
		 		setState(1524)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,205,_ctx)) {
		 		case 1:
		 			setState(1523)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(1526)
		 		try throwStatement()
		 		setState(1527)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(1529)
		 		try tryBlock()
		 		setState(1531)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,206,_ctx)) {
		 		case 1:
		 			setState(1530)
		 			try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(1533)
		 		try expressions()
		 		setState(1534)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(1536)
		 		try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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

	public class LabeledStatementContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_labeledStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterLabeledStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitLabeledStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitLabeledStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitLabeledStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func labeledStatement() throws -> LabeledStatementContext {
		let _localctx: LabeledStatementContext = LabeledStatementContext(_ctx, getState())
		try enterRule(_localctx, 250, ObjectiveCParser.RULE_labeledStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1539)
		 	try identifier()
		 	setState(1540)
		 	try match(ObjectiveCParser.Tokens.COLON.rawValue)
		 	setState(1541)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class RangeExpressionContext: ParserRuleContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func ELIPSIS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_rangeExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterRangeExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitRangeExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitRangeExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitRangeExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func rangeExpression() throws -> RangeExpressionContext {
		let _localctx: RangeExpressionContext = RangeExpressionContext(_ctx, getState())
		try enterRule(_localctx, 252, ObjectiveCParser.RULE_rangeExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1543)
		 	try expression(0)
		 	setState(1546)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1544)
		 		try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
		 		setState(1545)
		 		try expression(0)

		 	}


		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class CompoundStatementContext: ParserRuleContext {
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func declaration() -> [DeclarationContext] {
				return getRuleContexts(DeclarationContext.self)
			}
			open
			func declaration(_ i: Int) -> DeclarationContext? {
				return getRuleContext(DeclarationContext.self, i)
			}
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
			return ObjectiveCParser.RULE_compoundStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterCompoundStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitCompoundStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitCompoundStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitCompoundStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func compoundStatement() throws -> CompoundStatementContext {
		let _localctx: CompoundStatementContext = CompoundStatementContext(_ctx, getState())
		try enterRule(_localctx, 254, ObjectiveCParser.RULE_compoundStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1548)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(1553)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.BREAK.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.CONTINUE.rawValue,ObjectiveCParser.Tokens.DO.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.FOR.rawValue,ObjectiveCParser.Tokens.GOTO.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.WHILE.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue,ObjectiveCParser.Tokens.THROW.rawValue,ObjectiveCParser.Tokens.TRY.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACE.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.SEMI.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1551)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,209, _ctx)) {
		 		case 1:
		 			setState(1549)
		 			try declaration()

		 			break
		 		case 2:
		 			setState(1550)
		 			try statement()

		 			break
		 		default: break
		 		}

		 		setState(1555)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(1556)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SelectionStatementContext: ParserRuleContext {
		open var ifBody: StatementContext!
		open var elseBody: StatementContext!
			open
			func IF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IF.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
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
			func ELSE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ELSE.rawValue, 0)
			}
			open
			func switchStatement() -> SwitchStatementContext? {
				return getRuleContext(SwitchStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_selectionStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSelectionStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSelectionStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSelectionStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSelectionStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func selectionStatement() throws -> SelectionStatementContext {
		let _localctx: SelectionStatementContext = SelectionStatementContext(_ctx, getState())
		try enterRule(_localctx, 256, ObjectiveCParser.RULE_selectionStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1568)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .IF:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1558)
		 		try match(ObjectiveCParser.Tokens.IF.rawValue)
		 		setState(1559)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1560)
		 		try expressions()
		 		setState(1561)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)
		 		setState(1562)
		 		try {
		 				let assignmentValue = try statement()
		 				_localctx.castdown(SelectionStatementContext.self).ifBody = assignmentValue
		 		     }()

		 		setState(1565)
		 		try _errHandler.sync(self)
		 		switch (try getInterpreter().adaptivePredict(_input,211,_ctx)) {
		 		case 1:
		 			setState(1563)
		 			try match(ObjectiveCParser.Tokens.ELSE.rawValue)
		 			setState(1564)
		 			try {
		 					let assignmentValue = try statement()
		 					_localctx.castdown(SelectionStatementContext.self).elseBody = assignmentValue
		 			     }()


		 			break
		 		default: break
		 		}

		 		break

		 	case .SWITCH:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1567)
		 		try switchStatement()

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

	public class SwitchStatementContext: ParserRuleContext {
			open
			func SWITCH() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SWITCH.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func switchBlock() -> SwitchBlockContext? {
				return getRuleContext(SwitchBlockContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_switchStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSwitchStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSwitchStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSwitchStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 258, ObjectiveCParser.RULE_switchStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1570)
		 	try match(ObjectiveCParser.Tokens.SWITCH.rawValue)
		 	setState(1571)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1572)
		 	try expression(0)
		 	setState(1573)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1574)
		 	try switchBlock()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SwitchBlockContext: ParserRuleContext {
			open
			func LBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
			}
			open
			func RBRACE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
			}
			open
			func switchSection() -> [SwitchSectionContext] {
				return getRuleContexts(SwitchSectionContext.self)
			}
			open
			func switchSection(_ i: Int) -> SwitchSectionContext? {
				return getRuleContext(SwitchSectionContext.self, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_switchBlock
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSwitchBlock(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSwitchBlock(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSwitchBlock(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSwitchBlock(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func switchBlock() throws -> SwitchBlockContext {
		let _localctx: SwitchBlockContext = SwitchBlockContext(_ctx, getState())
		try enterRule(_localctx, 260, ObjectiveCParser.RULE_switchBlock)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1576)
		 	try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
		 	setState(1580)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.CASE.rawValue || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1577)
		 		try switchSection()


		 		setState(1582)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	}
		 	setState(1583)
		 	try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class SwitchSectionContext: ParserRuleContext {
			open
			func switchLabel() -> [SwitchLabelContext] {
				return getRuleContexts(SwitchLabelContext.self)
			}
			open
			func switchLabel(_ i: Int) -> SwitchLabelContext? {
				return getRuleContext(SwitchLabelContext.self, i)
			}
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
			return ObjectiveCParser.RULE_switchSection
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSwitchSection(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSwitchSection(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSwitchSection(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSwitchSection(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func switchSection() throws -> SwitchSectionContext {
		let _localctx: SwitchSectionContext = SwitchSectionContext(_ctx, getState())
		try enterRule(_localctx, 262, ObjectiveCParser.RULE_switchSection)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1586) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(1585)
		 		try switchLabel()


		 		setState(1588); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.CASE.rawValue || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
		 	      return testSet
		 	 }())
		 	setState(1591) 
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	repeat {
		 		setState(1590)
		 		try statement()


		 		setState(1593); 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 	} while (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BREAK.rawValue,ObjectiveCParser.Tokens.CONTINUE.rawValue,ObjectiveCParser.Tokens.DO.rawValue,ObjectiveCParser.Tokens.FOR.rawValue,ObjectiveCParser.Tokens.GOTO.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.WHILE.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue,ObjectiveCParser.Tokens.THROW.rawValue,ObjectiveCParser.Tokens.TRY.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACE.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.SEMI.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
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

	public class SwitchLabelContext: ParserRuleContext {
			open
			func CASE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CASE.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
			open
			func rangeExpression() -> RangeExpressionContext? {
				return getRuleContext(RangeExpressionContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func DEFAULT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DEFAULT.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_switchLabel
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterSwitchLabel(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitSwitchLabel(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitSwitchLabel(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitSwitchLabel(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func switchLabel() throws -> SwitchLabelContext {
		let _localctx: SwitchLabelContext = SwitchLabelContext(_ctx, getState())
		try enterRule(_localctx, 264, ObjectiveCParser.RULE_switchLabel)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1607)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .CASE:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1595)
		 		try match(ObjectiveCParser.Tokens.CASE.rawValue)
		 		setState(1601)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,216, _ctx)) {
		 		case 1:
		 			setState(1596)
		 			try rangeExpression()

		 			break
		 		case 2:
		 			setState(1597)
		 			try match(ObjectiveCParser.Tokens.LP.rawValue)
		 			setState(1598)
		 			try rangeExpression()
		 			setState(1599)
		 			try match(ObjectiveCParser.Tokens.RP.rawValue)

		 			break
		 		default: break
		 		}
		 		setState(1603)
		 		try match(ObjectiveCParser.Tokens.COLON.rawValue)

		 		break

		 	case .DEFAULT:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1605)
		 		try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)
		 		setState(1606)
		 		try match(ObjectiveCParser.Tokens.COLON.rawValue)

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

	public class IterationStatementContext: ParserRuleContext {
			open
			func whileStatement() -> WhileStatementContext? {
				return getRuleContext(WhileStatementContext.self, 0)
			}
			open
			func doStatement() -> DoStatementContext? {
				return getRuleContext(DoStatementContext.self, 0)
			}
			open
			func forStatement() -> ForStatementContext? {
				return getRuleContext(ForStatementContext.self, 0)
			}
			open
			func forInStatement() -> ForInStatementContext? {
				return getRuleContext(ForInStatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_iterationStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterIterationStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitIterationStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitIterationStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitIterationStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func iterationStatement() throws -> IterationStatementContext {
		let _localctx: IterationStatementContext = IterationStatementContext(_ctx, getState())
		try enterRule(_localctx, 266, ObjectiveCParser.RULE_iterationStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1613)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,218, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1609)
		 		try whileStatement()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1610)
		 		try doStatement()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1611)
		 		try forStatement()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1612)
		 		try forInStatement()

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

	public class WhileStatementContext: ParserRuleContext {
			open
			func WHILE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.WHILE.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_whileStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterWhileStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitWhileStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitWhileStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitWhileStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func whileStatement() throws -> WhileStatementContext {
		let _localctx: WhileStatementContext = WhileStatementContext(_ctx, getState())
		try enterRule(_localctx, 268, ObjectiveCParser.RULE_whileStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1615)
		 	try match(ObjectiveCParser.Tokens.WHILE.rawValue)
		 	setState(1616)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1617)
		 	try expression(0)
		 	setState(1618)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1619)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class DoStatementContext: ParserRuleContext {
			open
			func DO() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DO.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func WHILE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.WHILE.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func SEMI() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_doStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterDoStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitDoStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitDoStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitDoStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func doStatement() throws -> DoStatementContext {
		let _localctx: DoStatementContext = DoStatementContext(_ctx, getState())
		try enterRule(_localctx, 270, ObjectiveCParser.RULE_doStatement)
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1621)
		 	try match(ObjectiveCParser.Tokens.DO.rawValue)
		 	setState(1622)
		 	try statement()
		 	setState(1623)
		 	try match(ObjectiveCParser.Tokens.WHILE.rawValue)
		 	setState(1624)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1625)
		 	try expression(0)
		 	setState(1626)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1627)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ForStatementContext: ParserRuleContext {
			open
			func FOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FOR.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func SEMI() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.SEMI.rawValue)
			}
			open
			func SEMI(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, i)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func forLoopInitializer() -> ForLoopInitializerContext? {
				return getRuleContext(ForLoopInitializerContext.self, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_forStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterForStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitForStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitForStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitForStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func forStatement() throws -> ForStatementContext {
		let _localctx: ForStatementContext = ForStatementContext(_ctx, getState())
		try enterRule(_localctx, 272, ObjectiveCParser.RULE_forStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1629)
		 	try match(ObjectiveCParser.Tokens.FOR.rawValue)
		 	setState(1630)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1632)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1631)
		 		try forLoopInitializer()

		 	}

		 	setState(1634)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)
		 	setState(1636)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1635)
		 		try expression(0)

		 	}

		 	setState(1638)
		 	try match(ObjectiveCParser.Tokens.SEMI.rawValue)
		 	setState(1640)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1639)
		 		try expressions()

		 	}

		 	setState(1642)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1643)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class ForLoopInitializerContext: ParserRuleContext {
			open
			func declarationSpecifiers() -> DeclarationSpecifiersContext? {
				return getRuleContext(DeclarationSpecifiersContext.self, 0)
			}
			open
			func initDeclaratorList() -> InitDeclaratorListContext? {
				return getRuleContext(InitDeclaratorListContext.self, 0)
			}
			open
			func expressions() -> ExpressionsContext? {
				return getRuleContext(ExpressionsContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_forLoopInitializer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterForLoopInitializer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitForLoopInitializer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitForLoopInitializer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitForLoopInitializer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func forLoopInitializer() throws -> ForLoopInitializerContext {
		let _localctx: ForLoopInitializerContext = ForLoopInitializerContext(_ctx, getState())
		try enterRule(_localctx, 274, ObjectiveCParser.RULE_forLoopInitializer)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1649)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,222, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1645)
		 		try declarationSpecifiers()
		 		setState(1646)
		 		try initDeclaratorList()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1648)
		 		try expressions()

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

	public class ForInStatementContext: ParserRuleContext {
			open
			func FOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FOR.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
				return getRuleContext(TypeVariableDeclaratorContext.self, 0)
			}
			open
			func IN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func statement() -> StatementContext? {
				return getRuleContext(StatementContext.self, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_forInStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterForInStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitForInStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitForInStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitForInStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func forInStatement() throws -> ForInStatementContext {
		let _localctx: ForInStatementContext = ForInStatementContext(_ctx, getState())
		try enterRule(_localctx, 276, ObjectiveCParser.RULE_forInStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1651)
		 	try match(ObjectiveCParser.Tokens.FOR.rawValue)
		 	setState(1652)
		 	try match(ObjectiveCParser.Tokens.LP.rawValue)
		 	setState(1653)
		 	try typeVariableDeclarator()
		 	setState(1654)
		 	try match(ObjectiveCParser.Tokens.IN.rawValue)
		 	setState(1656)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	if (//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 69)
		 	          }()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 136)
		 	          }()
		 	      return testSet
		 	 }()) {
		 		setState(1655)
		 		try expression(0)

		 	}

		 	setState(1658)
		 	try match(ObjectiveCParser.Tokens.RP.rawValue)
		 	setState(1659)
		 	try statement()

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}

	public class JumpStatementContext: ParserRuleContext {
			open
			func GOTO() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GOTO.rawValue, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func CONTINUE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CONTINUE.rawValue, 0)
			}
			open
			func BREAK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BREAK.rawValue, 0)
			}
			open
			func RETURN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RETURN.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_jumpStatement
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterJumpStatement(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitJumpStatement(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitJumpStatement(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitJumpStatement(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func jumpStatement() throws -> JumpStatementContext {
		let _localctx: JumpStatementContext = JumpStatementContext(_ctx, getState())
		try enterRule(_localctx, 278, ObjectiveCParser.RULE_jumpStatement)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1669)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .GOTO:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1661)
		 		try match(ObjectiveCParser.Tokens.GOTO.rawValue)
		 		setState(1662)
		 		try identifier()

		 		break

		 	case .CONTINUE:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1663)
		 		try match(ObjectiveCParser.Tokens.CONTINUE.rawValue)

		 		break

		 	case .BREAK:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1664)
		 		try match(ObjectiveCParser.Tokens.BREAK.rawValue)

		 		break

		 	case .RETURN:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1665)
		 		try match(ObjectiveCParser.Tokens.RETURN.rawValue)
		 		setState(1667)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 69)
		 		          }()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 136)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1666)
		 			try expression(0)

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

	public class ExpressionsContext: ParserRuleContext {
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_expressions
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterExpressions(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitExpressions(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitExpressions(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitExpressions(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func expressions() throws -> ExpressionsContext {
		let _localctx: ExpressionsContext = ExpressionsContext(_ctx, getState())
		try enterRule(_localctx, 280, ObjectiveCParser.RULE_expressions)
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1671)
		 	try expression(0)
		 	setState(1676)
		 	try _errHandler.sync(self)
		 	_alt = try getInterpreter().adaptivePredict(_input,226,_ctx)
		 	while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
		 		if ( _alt==1 ) {
		 			setState(1672)
		 			try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 			setState(1673)
		 			try expression(0)

		 	 
		 		}
		 		setState(1678)
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,226,_ctx)
		 	}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx
	}


	public class ExpressionContext: ParserRuleContext {
		open var assignmentExpression: ExpressionContext!
		open var op: Token!
		open var trueExpression: ExpressionContext!
		open var falseExpression: ExpressionContext!
			open
			func castExpression() -> CastExpressionContext? {
				return getRuleContext(CastExpressionContext.self, 0)
			}
			open
			func unaryExpression() -> UnaryExpressionContext? {
				return getRuleContext(UnaryExpressionContext.self, 0)
			}
			open
			func assignmentOperator() -> AssignmentOperatorContext? {
				return getRuleContext(AssignmentOperatorContext.self, 0)
			}
			open
			func expression() -> [ExpressionContext] {
				return getRuleContexts(ExpressionContext.self)
			}
			open
			func expression(_ i: Int) -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, i)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func compoundStatement() -> CompoundStatementContext? {
				return getRuleContext(CompoundStatementContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func MUL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
			}
			open
			func DIV() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DIV.rawValue, 0)
			}
			open
			func MOD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MOD.rawValue, 0)
			}
			open
			func ADD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
			}
			open
			func SUB() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
			}
			open
			func LT() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.LT.rawValue)
			}
			open
			func LT(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LT.rawValue, i)
			}
			open
			func GT() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.GT.rawValue)
			}
			open
			func GT(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GT.rawValue, i)
			}
			open
			func LE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LE.rawValue, 0)
			}
			open
			func GE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GE.rawValue, 0)
			}
			open
			func NOTEQUAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NOTEQUAL.rawValue, 0)
			}
			open
			func EQUAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.EQUAL.rawValue, 0)
			}
			open
			func BITAND() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITAND.rawValue, 0)
			}
			open
			func BITXOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
			}
			open
			func BITOR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITOR.rawValue, 0)
			}
			open
			func AND() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AND.rawValue, 0)
			}
			open
			func OR() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OR.rawValue, 0)
			}
			open
			func QUESTION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.QUESTION.rawValue, 0)
			}
			open
			func COLON() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_expression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func expression( ) throws -> ExpressionContext   {
		return try expression(0)
	}
	@discardableResult
	private func expression(_ _p: Int) throws -> ExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: ExpressionContext = ExpressionContext(_ctx, _parentState)
		let _startState: Int = 282
		try enterRecursionRule(_localctx, 282, ObjectiveCParser.RULE_expression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(1689)
			try _errHandler.sync(self)
			switch(try getInterpreter().adaptivePredict(_input,227, _ctx)) {
			case 1:
				setState(1680)
				try castExpression()

				break
			case 2:
				setState(1681)
				try unaryExpression()
				setState(1682)
				try assignmentOperator()
				setState(1683)
				try {
						let assignmentValue = try expression(2)
						_localctx.castdown(ExpressionContext.self).assignmentExpression = assignmentValue
				     }()


				break
			case 3:
				setState(1685)
				try match(ObjectiveCParser.Tokens.LP.rawValue)
				setState(1686)
				try compoundStatement()
				setState(1687)
				try match(ObjectiveCParser.Tokens.RP.rawValue)

				break
			default: break
			}
			_ctx!.stop = try _input.LT(-1)
			setState(1735)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,231,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					setState(1733)
					try _errHandler.sync(self)
					switch(try getInterpreter().adaptivePredict(_input,230, _ctx)) {
					case 1:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1691)
						if (!(precpred(_ctx, 13))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 13)"))
						}
						setState(1692)
						_localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.DIV.rawValue,ObjectiveCParser.Tokens.MOD.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 154)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(ExpressionContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(1693)
						try expression(14)

						break
					case 2:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1694)
						if (!(precpred(_ctx, 12))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 12)"))
						}
						setState(1695)
						_localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(ExpressionContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(1696)
						try expression(13)

						break
					case 3:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1697)
						if (!(precpred(_ctx, 11))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 11)"))
						}
						setState(1702)
						try _errHandler.sync(self)
						switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
						case .LT:
							setState(1698)
							try match(ObjectiveCParser.Tokens.LT.rawValue)
							setState(1699)
							try match(ObjectiveCParser.Tokens.LT.rawValue)

							break

						case .GT:
							setState(1700)
							try match(ObjectiveCParser.Tokens.GT.rawValue)
							setState(1701)
							try match(ObjectiveCParser.Tokens.GT.rawValue)

							break
						default:
							throw ANTLRException.recognition(e: NoViableAltException(self))
						}
						setState(1704)
						try expression(12)

						break
					case 4:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1705)
						if (!(precpred(_ctx, 10))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 10)"))
						}
						setState(1706)
						_localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.GT.rawValue,ObjectiveCParser.Tokens.LT.rawValue,ObjectiveCParser.Tokens.LE.rawValue,ObjectiveCParser.Tokens.GE.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 138)
						}()
						      return testSet
						 }())) {
							_localctx.castdown(ExpressionContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(1707)
						try expression(11)

						break
					case 5:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1708)
						if (!(precpred(_ctx, 9))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 9)"))
						}
						setState(1709)
						_localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
						_la = try _input.LA(1)
						if (!(//closure
						 { () -> Bool in
						      let testSet: Bool = _la == ObjectiveCParser.Tokens.EQUAL.rawValue || _la == ObjectiveCParser.Tokens.NOTEQUAL.rawValue
						      return testSet
						 }())) {
							_localctx.castdown(ExpressionContext.self).op = try _errHandler.recoverInline(self) as Token
						}
						else {
							_errHandler.reportMatch(self)
							try consume()
						}
						setState(1710)
						try expression(10)

						break
					case 6:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1711)
						if (!(precpred(_ctx, 8))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 8)"))
						}
						setState(1712)
						try {
								let assignmentValue = try match(ObjectiveCParser.Tokens.BITAND.rawValue)
								_localctx.castdown(ExpressionContext.self).op = assignmentValue
						     }()

						setState(1713)
						try expression(9)

						break
					case 7:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1714)
						if (!(precpred(_ctx, 7))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 7)"))
						}
						setState(1715)
						try {
								let assignmentValue = try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
								_localctx.castdown(ExpressionContext.self).op = assignmentValue
						     }()

						setState(1716)
						try expression(8)

						break
					case 8:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1717)
						if (!(precpred(_ctx, 6))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 6)"))
						}
						setState(1718)
						try {
								let assignmentValue = try match(ObjectiveCParser.Tokens.BITOR.rawValue)
								_localctx.castdown(ExpressionContext.self).op = assignmentValue
						     }()

						setState(1719)
						try expression(7)

						break
					case 9:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1720)
						if (!(precpred(_ctx, 5))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 5)"))
						}
						setState(1721)
						try {
								let assignmentValue = try match(ObjectiveCParser.Tokens.AND.rawValue)
								_localctx.castdown(ExpressionContext.self).op = assignmentValue
						     }()

						setState(1722)
						try expression(6)

						break
					case 10:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1723)
						if (!(precpred(_ctx, 4))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 4)"))
						}
						setState(1724)
						try {
								let assignmentValue = try match(ObjectiveCParser.Tokens.OR.rawValue)
								_localctx.castdown(ExpressionContext.self).op = assignmentValue
						     }()

						setState(1725)
						try expression(5)

						break
					case 11:
						_localctx = ExpressionContext(_parentctx, _parentState);
						try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_expression)
						setState(1726)
						if (!(precpred(_ctx, 3))) {
						    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 3)"))
						}
						setState(1727)
						try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
						setState(1729)
						try _errHandler.sync(self)
						_la = try _input.LA(1)
						if (//closure
						 { () -> Bool in
						      var testSet: Bool = {  () -> Bool in
						   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
						    return  Utils.testBitLeftShiftArray(testArray, 0)
						}()
						          testSet = testSet || {  () -> Bool in
						             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
						              return  Utils.testBitLeftShiftArray(testArray, 69)
						          }()
						          testSet = testSet || {  () -> Bool in
						             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
						              return  Utils.testBitLeftShiftArray(testArray, 136)
						          }()
						      return testSet
						 }()) {
							setState(1728)
							try {
									let assignmentValue = try expression(0)
									_localctx.castdown(ExpressionContext.self).trueExpression = assignmentValue
							     }()


						}

						setState(1731)
						try match(ObjectiveCParser.Tokens.COLON.rawValue)
						setState(1732)
						try {
								let assignmentValue = try expression(4)
								_localctx.castdown(ExpressionContext.self).falseExpression = assignmentValue
						     }()


						break
					default: break
					}
			 
				}
				setState(1737)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,231,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class AssignmentOperatorContext: ParserRuleContext {
			open
			func ASSIGNMENT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
			}
			open
			func MUL_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL_ASSIGN.rawValue, 0)
			}
			open
			func DIV_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DIV_ASSIGN.rawValue, 0)
			}
			open
			func MOD_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MOD_ASSIGN.rawValue, 0)
			}
			open
			func ADD_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD_ASSIGN.rawValue, 0)
			}
			open
			func SUB_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB_ASSIGN.rawValue, 0)
			}
			open
			func LSHIFT_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LSHIFT_ASSIGN.rawValue, 0)
			}
			open
			func RSHIFT_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RSHIFT_ASSIGN.rawValue, 0)
			}
			open
			func AND_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AND_ASSIGN.rawValue, 0)
			}
			open
			func XOR_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.XOR_ASSIGN.rawValue, 0)
			}
			open
			func OR_ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OR_ASSIGN.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_assignmentOperator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterAssignmentOperator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitAssignmentOperator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitAssignmentOperator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 284, ObjectiveCParser.RULE_assignmentOperator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1738)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ASSIGNMENT.rawValue,ObjectiveCParser.Tokens.ADD_ASSIGN.rawValue,ObjectiveCParser.Tokens.SUB_ASSIGN.rawValue,ObjectiveCParser.Tokens.MUL_ASSIGN.rawValue,ObjectiveCParser.Tokens.DIV_ASSIGN.rawValue,ObjectiveCParser.Tokens.AND_ASSIGN.rawValue,ObjectiveCParser.Tokens.OR_ASSIGN.rawValue,ObjectiveCParser.Tokens.XOR_ASSIGN.rawValue,ObjectiveCParser.Tokens.MOD_ASSIGN.rawValue,ObjectiveCParser.Tokens.LSHIFT_ASSIGN.rawValue,ObjectiveCParser.Tokens.RSHIFT_ASSIGN.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 137)
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

	public class CastExpressionContext: ParserRuleContext {
			open
			func unaryExpression() -> UnaryExpressionContext? {
				return getRuleContext(UnaryExpressionContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeName() -> TypeNameContext? {
				return getRuleContext(TypeNameContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func castExpression() -> CastExpressionContext? {
				return getRuleContext(CastExpressionContext.self, 0)
			}
			open
			func initializer() -> InitializerContext? {
				return getRuleContext(InitializerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_castExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterCastExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitCastExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitCastExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitCastExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func castExpression() throws -> CastExpressionContext {
		let _localctx: CastExpressionContext = CastExpressionContext(_ctx, getState())
		try enterRule(_localctx, 286, ObjectiveCParser.RULE_castExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1749)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,233, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1740)
		 		try unaryExpression()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1741)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1742)
		 		try typeName()
		 		setState(1743)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		setState(1747)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,232, _ctx)) {
		 		case 1:
		 			setState(1745)
		 			try castExpression()

		 			break
		 		case 2:
		 			setState(1746)
		 			try initializer()

		 			break
		 		default: break
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

	public class InitializerContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func arrayInitializer() -> ArrayInitializerContext? {
				return getRuleContext(ArrayInitializerContext.self, 0)
			}
			open
			func structInitializer() -> StructInitializerContext? {
				return getRuleContext(StructInitializerContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_initializer
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterInitializer(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitInitializer(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitInitializer(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitInitializer(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func initializer() throws -> InitializerContext {
		let _localctx: InitializerContext = InitializerContext(_ctx, getState())
		try enterRule(_localctx, 288, ObjectiveCParser.RULE_initializer)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1754)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,234, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1751)
		 		try expression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1752)
		 		try arrayInitializer()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1753)
		 		try structInitializer()

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

	public class ConstantExpressionContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_constantExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterConstantExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitConstantExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitConstantExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitConstantExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func constantExpression() throws -> ConstantExpressionContext {
		let _localctx: ConstantExpressionContext = ConstantExpressionContext(_ctx, getState())
		try enterRule(_localctx, 290, ObjectiveCParser.RULE_constantExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1758)
		 	try _errHandler.sync(self)
		 	switch (ObjectiveCParser.Tokens(rawValue: try _input.LA(1))!) {
		 	case .BOOL:fallthrough
		 	case .Class:fallthrough
		 	case .BYCOPY:fallthrough
		 	case .BYREF:fallthrough
		 	case .ID:fallthrough
		 	case .IMP:fallthrough
		 	case .IN:fallthrough
		 	case .INOUT:fallthrough
		 	case .ONEWAY:fallthrough
		 	case .OUT:fallthrough
		 	case .PROTOCOL_:fallthrough
		 	case .SEL:fallthrough
		 	case .SELF:fallthrough
		 	case .SUPER:fallthrough
		 	case .ATOMIC:fallthrough
		 	case .NONATOMIC:fallthrough
		 	case .RETAIN:fallthrough
		 	case .AUTORELEASING_QUALIFIER:fallthrough
		 	case .BLOCK:fallthrough
		 	case .BRIDGE_RETAINED:fallthrough
		 	case .BRIDGE_TRANSFER:fallthrough
		 	case .COVARIANT:fallthrough
		 	case .CONTRAVARIANT:fallthrough
		 	case .DEPRECATED:fallthrough
		 	case .KINDOF:fallthrough
		 	case .UNUSED:fallthrough
		 	case .NULL_UNSPECIFIED:fallthrough
		 	case .NULLABLE:fallthrough
		 	case .NONNULL:fallthrough
		 	case .NULL_RESETTABLE:fallthrough
		 	case .NS_INLINE:fallthrough
		 	case .NS_ENUM:fallthrough
		 	case .NS_OPTIONS:fallthrough
		 	case .ASSIGN:fallthrough
		 	case .COPY:fallthrough
		 	case .GETTER:fallthrough
		 	case .SETTER:fallthrough
		 	case .STRONG:fallthrough
		 	case .READONLY:fallthrough
		 	case .READWRITE:fallthrough
		 	case .WEAK:fallthrough
		 	case .UNSAFE_UNRETAINED:fallthrough
		 	case .IB_OUTLET:fallthrough
		 	case .IB_OUTLET_COLLECTION:fallthrough
		 	case .IB_INSPECTABLE:fallthrough
		 	case .IB_DESIGNABLE:fallthrough
		 	case .IDENTIFIER:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1756)
		 		try identifier()

		 		break
		 	case .TRUE:fallthrough
		 	case .FALSE:fallthrough
		 	case .NIL:fallthrough
		 	case .NO:fallthrough
		 	case .NULL:fallthrough
		 	case .YES:fallthrough
		 	case .ADD:fallthrough
		 	case .SUB:fallthrough
		 	case .CHARACTER_LITERAL:fallthrough
		 	case .HEX_LITERAL:fallthrough
		 	case .OCTAL_LITERAL:fallthrough
		 	case .BINARY_LITERAL:fallthrough
		 	case .DECIMAL_LITERAL:fallthrough
		 	case .FLOATING_POINT_LITERAL:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1757)
		 		try constant()

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

	public class UnaryExpressionContext: ParserRuleContext {
		open var op: Token!
			open
			func postfixExpression() -> PostfixExpressionContext? {
				return getRuleContext(PostfixExpressionContext.self, 0)
			}
			open
			func SIZEOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SIZEOF.rawValue, 0)
			}
			open
			func unaryExpression() -> UnaryExpressionContext? {
				return getRuleContext(UnaryExpressionContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func typeSpecifier() -> TypeSpecifierContext? {
				return getRuleContext(TypeSpecifierContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func INC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INC.rawValue, 0)
			}
			open
			func DEC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DEC.rawValue, 0)
			}
			open
			func unaryOperator() -> UnaryOperatorContext? {
				return getRuleContext(UnaryOperatorContext.self, 0)
			}
			open
			func castExpression() -> CastExpressionContext? {
				return getRuleContext(CastExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_unaryExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterUnaryExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitUnaryExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitUnaryExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitUnaryExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func unaryExpression() throws -> UnaryExpressionContext {
		let _localctx: UnaryExpressionContext = UnaryExpressionContext(_ctx, getState())
		try enterRule(_localctx, 292, ObjectiveCParser.RULE_unaryExpression)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1774)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,237, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1760)
		 		try postfixExpression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1761)
		 		try match(ObjectiveCParser.Tokens.SIZEOF.rawValue)
		 		setState(1767)
		 		try _errHandler.sync(self)
		 		switch(try getInterpreter().adaptivePredict(_input,236, _ctx)) {
		 		case 1:
		 			setState(1762)
		 			try unaryExpression()

		 			break
		 		case 2:
		 			setState(1763)
		 			try match(ObjectiveCParser.Tokens.LP.rawValue)
		 			setState(1764)
		 			try typeSpecifier()
		 			setState(1765)
		 			try match(ObjectiveCParser.Tokens.RP.rawValue)

		 			break
		 		default: break
		 		}

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1769)
		 		_localctx.castdown(UnaryExpressionContext.self).op = try _input.LT(1)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.INC.rawValue || _la == ObjectiveCParser.Tokens.DEC.rawValue
		 		      return testSet
		 		 }())) {
		 			_localctx.castdown(UnaryExpressionContext.self).op = try _errHandler.recoverInline(self) as Token
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
		 		}
		 		setState(1770)
		 		try unaryExpression()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1771)
		 		try unaryOperator()
		 		setState(1772)
		 		try castExpression()

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

	public class UnaryOperatorContext: ParserRuleContext {
			open
			func BITAND() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BITAND.rawValue, 0)
			}
			open
			func MUL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
			}
			open
			func ADD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
			}
			open
			func SUB() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
			}
			open
			func TILDE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TILDE.rawValue, 0)
			}
			open
			func BANG() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BANG.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_unaryOperator
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterUnaryOperator(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitUnaryOperator(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitUnaryOperator(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitUnaryOperator(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func unaryOperator() throws -> UnaryOperatorContext {
		let _localctx: UnaryOperatorContext = UnaryOperatorContext(_ctx, getState())
		try enterRule(_localctx, 294, ObjectiveCParser.RULE_unaryOperator)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1776)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 140)
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


	public class PostfixExpressionContext: ParserRuleContext {
			open
			func primaryExpression() -> PrimaryExpressionContext? {
				return getRuleContext(PrimaryExpressionContext.self, 0)
			}
			open
			func postfixExpr() -> [PostfixExprContext] {
				return getRuleContexts(PostfixExprContext.self)
			}
			open
			func postfixExpr(_ i: Int) -> PostfixExprContext? {
				return getRuleContext(PostfixExprContext.self, i)
			}
			open
			func postfixExpression() -> PostfixExpressionContext? {
				return getRuleContext(PostfixExpressionContext.self, 0)
			}
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func DOT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DOT.rawValue, 0)
			}
			open
			func STRUCTACCESS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRUCTACCESS.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_postfixExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPostfixExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPostfixExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPostfixExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPostfixExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}

	 public final  func postfixExpression( ) throws -> PostfixExpressionContext   {
		return try postfixExpression(0)
	}
	@discardableResult
	private func postfixExpression(_ _p: Int) throws -> PostfixExpressionContext   {
		let _parentctx: ParserRuleContext? = _ctx
		let _parentState: Int = getState()
		var _localctx: PostfixExpressionContext = PostfixExpressionContext(_ctx, _parentState)
		let _startState: Int = 296
		try enterRecursionRule(_localctx, 296, ObjectiveCParser.RULE_postfixExpression, _p)
		var _la: Int = 0
		defer {
	    		try! unrollRecursionContexts(_parentctx)
	    }
		do {
			var _alt: Int
			try enterOuterAlt(_localctx, 1)
			setState(1779)
			try primaryExpression()
			setState(1783)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,238,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					setState(1780)
					try postfixExpr()

			 
				}
				setState(1785)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,238,_ctx)
			}

			_ctx!.stop = try _input.LT(-1)
			setState(1797)
			try _errHandler.sync(self)
			_alt = try getInterpreter().adaptivePredict(_input,240,_ctx)
			while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
				if ( _alt==1 ) {
					if _parseListeners != nil {
					   try triggerExitRuleEvent()
					}
					_localctx = PostfixExpressionContext(_parentctx, _parentState);
					try pushNewRecursionContext(_localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
					setState(1786)
					if (!(precpred(_ctx, 1))) {
					    throw ANTLRException.recognition(e:FailedPredicateException(self, "precpred(_ctx, 1)"))
					}
					setState(1787)
					_la = try _input.LA(1)
					if (!(//closure
					 { () -> Bool in
					      let testSet: Bool = _la == ObjectiveCParser.Tokens.DOT.rawValue || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue
					      return testSet
					 }())) {
					try _errHandler.recoverInline(self)
					}
					else {
						_errHandler.reportMatch(self)
						try consume()
					}
					setState(1788)
					try identifier()
					setState(1792)
					try _errHandler.sync(self)
					_alt = try getInterpreter().adaptivePredict(_input,239,_ctx)
					while (_alt != 2 && _alt != ATN.INVALID_ALT_NUMBER) {
						if ( _alt==1 ) {
							setState(1789)
							try postfixExpr()

					 
						}
						setState(1794)
						try _errHandler.sync(self)
						_alt = try getInterpreter().adaptivePredict(_input,239,_ctx)
					}

			 
				}
				setState(1799)
				try _errHandler.sync(self)
				_alt = try getInterpreter().adaptivePredict(_input,240,_ctx)
			}

		}
		catch ANTLRException.recognition(let re) {
			_localctx.exception = re
			_errHandler.reportError(self, re)
			try _errHandler.recover(self, re)
		}

		return _localctx;
	}

	public class PostfixExprContext: ParserRuleContext {
		open var _RP: Token!
		open var macroArguments: [Token] = [Token]()
		open var _tset3398: Token!
		open var op: Token!
			open
			func LBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RBRACK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func RP() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.RP.rawValue)
			}
			open
			func RP(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
			}
			open
			func argumentExpressionList() -> ArgumentExpressionListContext? {
				return getRuleContext(ArgumentExpressionListContext.self, 0)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
			open
			func INC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INC.rawValue, 0)
			}
			open
			func DEC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DEC.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_postfixExpr
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPostfixExpr(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPostfixExpr(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPostfixExpr(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPostfixExpr(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func postfixExpr() throws -> PostfixExprContext {
		let _localctx: PostfixExprContext = PostfixExprContext(_ctx, getState())
		try enterRule(_localctx, 298, ObjectiveCParser.RULE_postfixExpr)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1818)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,244, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1800)
		 		try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
		 		setState(1801)
		 		try expression(0)
		 		setState(1802)
		 		try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1804)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1806)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 69)
		 		          }()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 136)
		 		          }()
		 		      return testSet
		 		 }()) {
		 			setState(1805)
		 			try argumentExpressionList()

		 		}

		 		setState(1808)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1809)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1812) 
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		repeat {
		 			setState(1812)
		 			try _errHandler.sync(self)
		 			switch(try getInterpreter().adaptivePredict(_input,242, _ctx)) {
		 			case 1:
		 				setState(1810)
		 				try match(ObjectiveCParser.Tokens.COMMA.rawValue)

		 				break
		 			case 2:
		 				setState(1811)
		 				_localctx.castdown(PostfixExprContext.self)._tset3398 = try _input.LT(1)
		 				_la = try _input.LA(1)
		 				if (_la <= 0 || (//closure
		 				 { () -> Bool in
		 				      let testSet: Bool = _la == ObjectiveCParser.Tokens.RP.rawValue
		 				      return testSet
		 				 }())) {
		 					_localctx.castdown(PostfixExprContext.self)._tset3398 = try _errHandler.recoverInline(self) as Token
		 				}
		 				else {
		 					_errHandler.reportMatch(self)
		 					try consume()
		 				}
		 				_localctx.castdown(PostfixExprContext.self).macroArguments.append(_localctx.castdown(PostfixExprContext.self)._tset3398)

		 				break
		 			default: break
		 			}

		 			setState(1814); 
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 		} while (//closure
		 		 { () -> Bool in
		 		      var testSet: Bool = {  () -> Bool in
		 		   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.AUTO.rawValue,ObjectiveCParser.Tokens.BREAK.rawValue,ObjectiveCParser.Tokens.CASE.rawValue,ObjectiveCParser.Tokens.CHAR.rawValue,ObjectiveCParser.Tokens.CONST.rawValue,ObjectiveCParser.Tokens.CONTINUE.rawValue,ObjectiveCParser.Tokens.DEFAULT.rawValue,ObjectiveCParser.Tokens.DO.rawValue,ObjectiveCParser.Tokens.DOUBLE.rawValue,ObjectiveCParser.Tokens.ELSE.rawValue,ObjectiveCParser.Tokens.ENUM.rawValue,ObjectiveCParser.Tokens.EXTERN.rawValue,ObjectiveCParser.Tokens.FLOAT.rawValue,ObjectiveCParser.Tokens.FOR.rawValue,ObjectiveCParser.Tokens.GOTO.rawValue,ObjectiveCParser.Tokens.IF.rawValue,ObjectiveCParser.Tokens.INLINE.rawValue,ObjectiveCParser.Tokens.INT.rawValue,ObjectiveCParser.Tokens.LONG.rawValue,ObjectiveCParser.Tokens.REGISTER.rawValue,ObjectiveCParser.Tokens.RESTRICT.rawValue,ObjectiveCParser.Tokens.RETURN.rawValue,ObjectiveCParser.Tokens.SHORT.rawValue,ObjectiveCParser.Tokens.SIGNED.rawValue,ObjectiveCParser.Tokens.SIZEOF.rawValue,ObjectiveCParser.Tokens.STATIC.rawValue,ObjectiveCParser.Tokens.STRUCT.rawValue,ObjectiveCParser.Tokens.SWITCH.rawValue,ObjectiveCParser.Tokens.TYPEDEF.rawValue,ObjectiveCParser.Tokens.UNION.rawValue,ObjectiveCParser.Tokens.UNSIGNED.rawValue,ObjectiveCParser.Tokens.VOID.rawValue,ObjectiveCParser.Tokens.VOLATILE.rawValue,ObjectiveCParser.Tokens.WHILE.rawValue,ObjectiveCParser.Tokens.BOOL_.rawValue,ObjectiveCParser.Tokens.COMPLEX.rawValue,ObjectiveCParser.Tokens.IMAGINERY.rawValue,ObjectiveCParser.Tokens.TRUE.rawValue,ObjectiveCParser.Tokens.FALSE.rawValue,ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.NIL.rawValue,ObjectiveCParser.Tokens.NO.rawValue,ObjectiveCParser.Tokens.NULL.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue,ObjectiveCParser.Tokens.YES.rawValue,ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue,ObjectiveCParser.Tokens.CATCH.rawValue,ObjectiveCParser.Tokens.CLASS.rawValue,ObjectiveCParser.Tokens.DYNAMIC.rawValue,ObjectiveCParser.Tokens.ENCODE.rawValue,ObjectiveCParser.Tokens.END.rawValue]
		 		    return  Utils.testBitLeftShiftArray(testArray, 0)
		 		}()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.FINALLY.rawValue,ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue,ObjectiveCParser.Tokens.INTERFACE.rawValue,ObjectiveCParser.Tokens.IMPORT.rawValue,ObjectiveCParser.Tokens.PACKAGE.rawValue,ObjectiveCParser.Tokens.PROTOCOL.rawValue,ObjectiveCParser.Tokens.OPTIONAL.rawValue,ObjectiveCParser.Tokens.PRIVATE.rawValue,ObjectiveCParser.Tokens.PROPERTY.rawValue,ObjectiveCParser.Tokens.PROTECTED.rawValue,ObjectiveCParser.Tokens.PUBLIC.rawValue,ObjectiveCParser.Tokens.REQUIRED.rawValue,ObjectiveCParser.Tokens.SELECTOR.rawValue,ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue,ObjectiveCParser.Tokens.SYNTHESIZE.rawValue,ObjectiveCParser.Tokens.THROW.rawValue,ObjectiveCParser.Tokens.TRY.rawValue,ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.ATTRIBUTE.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue,ObjectiveCParser.Tokens.TYPEOF.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.NS_ASSUME_NONNULL_BEGIN.rawValue,ObjectiveCParser.Tokens.NS_ASSUME_NONNULL_END.rawValue,ObjectiveCParser.Tokens.EXTERN_SUFFIX.rawValue,ObjectiveCParser.Tokens.IOS_SUFFIX.rawValue,ObjectiveCParser.Tokens.MAC_SUFFIX.rawValue,ObjectiveCParser.Tokens.TVOS_PROHIBITED.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue,ObjectiveCParser.Tokens.LP.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 64)
		 		          }()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.LBRACE.rawValue,ObjectiveCParser.Tokens.RBRACE.rawValue,ObjectiveCParser.Tokens.LBRACK.rawValue,ObjectiveCParser.Tokens.RBRACK.rawValue,ObjectiveCParser.Tokens.SEMI.rawValue,ObjectiveCParser.Tokens.COMMA.rawValue,ObjectiveCParser.Tokens.DOT.rawValue,ObjectiveCParser.Tokens.STRUCTACCESS.rawValue,ObjectiveCParser.Tokens.AT.rawValue,ObjectiveCParser.Tokens.ASSIGNMENT.rawValue,ObjectiveCParser.Tokens.GT.rawValue,ObjectiveCParser.Tokens.LT.rawValue,ObjectiveCParser.Tokens.BANG.rawValue,ObjectiveCParser.Tokens.TILDE.rawValue,ObjectiveCParser.Tokens.QUESTION.rawValue,ObjectiveCParser.Tokens.COLON.rawValue,ObjectiveCParser.Tokens.EQUAL.rawValue,ObjectiveCParser.Tokens.LE.rawValue,ObjectiveCParser.Tokens.GE.rawValue,ObjectiveCParser.Tokens.NOTEQUAL.rawValue,ObjectiveCParser.Tokens.AND.rawValue,ObjectiveCParser.Tokens.OR.rawValue,ObjectiveCParser.Tokens.INC.rawValue,ObjectiveCParser.Tokens.DEC.rawValue,ObjectiveCParser.Tokens.ADD.rawValue,ObjectiveCParser.Tokens.SUB.rawValue,ObjectiveCParser.Tokens.MUL.rawValue,ObjectiveCParser.Tokens.DIV.rawValue,ObjectiveCParser.Tokens.BITAND.rawValue,ObjectiveCParser.Tokens.BITOR.rawValue,ObjectiveCParser.Tokens.BITXOR.rawValue,ObjectiveCParser.Tokens.MOD.rawValue,ObjectiveCParser.Tokens.ADD_ASSIGN.rawValue,ObjectiveCParser.Tokens.SUB_ASSIGN.rawValue,ObjectiveCParser.Tokens.MUL_ASSIGN.rawValue,ObjectiveCParser.Tokens.DIV_ASSIGN.rawValue,ObjectiveCParser.Tokens.AND_ASSIGN.rawValue,ObjectiveCParser.Tokens.OR_ASSIGN.rawValue,ObjectiveCParser.Tokens.XOR_ASSIGN.rawValue,ObjectiveCParser.Tokens.MOD_ASSIGN.rawValue,ObjectiveCParser.Tokens.LSHIFT_ASSIGN.rawValue,ObjectiveCParser.Tokens.RSHIFT_ASSIGN.rawValue,ObjectiveCParser.Tokens.ELIPSIS.rawValue,ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue,ObjectiveCParser.Tokens.STRING_START.rawValue,ObjectiveCParser.Tokens.HEX_LITERAL.rawValue,ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue,ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue,ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue,ObjectiveCParser.Tokens.WS.rawValue,ObjectiveCParser.Tokens.MULTI_COMMENT.rawValue,ObjectiveCParser.Tokens.SINGLE_COMMENT.rawValue,ObjectiveCParser.Tokens.BACKSLASH.rawValue,ObjectiveCParser.Tokens.SHARP.rawValue,ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue,ObjectiveCParser.Tokens.STRING_END.rawValue,ObjectiveCParser.Tokens.STRING_VALUE.rawValue,ObjectiveCParser.Tokens.PATH.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_IMPORT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_INCLUDE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_PRAGMA.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_DEFINE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_DEFINED.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 128)
		 		          }()
		 		          testSet = testSet || {  () -> Bool in
		 		             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.DIRECTIVE_IF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_ELIF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_ELSE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_UNDEF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_IFDEF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_IFNDEF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_ENDIF.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_TRUE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_FALSE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_ERROR.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_WARNING.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_HASINCLUDE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_BANG.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_LP.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_RP.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_EQUAL.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_NOTEQUAL.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_AND.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_OR.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_LT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_GT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_LE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_GE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_STRING.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_ID.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_DECIMAL_LITERAL.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_FLOAT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_NEWLINE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_MULTI_COMMENT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_SINGLE_COMMENT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_BACKSLASH_NEWLINE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_TEXT_NEWLINE.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_TEXT.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_PATH.rawValue,ObjectiveCParser.Tokens.DIRECTIVE_PATH_STRING.rawValue]
		 		              return  Utils.testBitLeftShiftArray(testArray, 192)
		 		          }()
		 		      return testSet
		 		 }())
		 		setState(1816)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1817)
		 		_localctx.castdown(PostfixExprContext.self).op = try _input.LT(1)
		 		_la = try _input.LA(1)
		 		if (!(//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.INC.rawValue || _la == ObjectiveCParser.Tokens.DEC.rawValue
		 		      return testSet
		 		 }())) {
		 			_localctx.castdown(PostfixExprContext.self).op = try _errHandler.recoverInline(self) as Token
		 		}
		 		else {
		 			_errHandler.reportMatch(self)
		 			try consume()
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

	public class ArgumentExpressionListContext: ParserRuleContext {
			open
			func argumentExpression() -> [ArgumentExpressionContext] {
				return getRuleContexts(ArgumentExpressionContext.self)
			}
			open
			func argumentExpression(_ i: Int) -> ArgumentExpressionContext? {
				return getRuleContext(ArgumentExpressionContext.self, i)
			}
			open
			func COMMA() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
			}
			open
			func COMMA(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_argumentExpressionList
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterArgumentExpressionList(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitArgumentExpressionList(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitArgumentExpressionList(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitArgumentExpressionList(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func argumentExpressionList() throws -> ArgumentExpressionListContext {
		let _localctx: ArgumentExpressionListContext = ArgumentExpressionListContext(_ctx, getState())
		try enterRule(_localctx, 300, ObjectiveCParser.RULE_argumentExpressionList)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1820)
		 	try argumentExpression()
		 	setState(1825)
		 	try _errHandler.sync(self)
		 	_la = try _input.LA(1)
		 	while (//closure
		 	 { () -> Bool in
		 	      let testSet: Bool = _la == ObjectiveCParser.Tokens.COMMA.rawValue
		 	      return testSet
		 	 }()) {
		 		setState(1821)
		 		try match(ObjectiveCParser.Tokens.COMMA.rawValue)
		 		setState(1822)
		 		try argumentExpression()


		 		setState(1827)
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

	public class ArgumentExpressionContext: ParserRuleContext {
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
				return getRuleContext(GenericTypeSpecifierContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_argumentExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterArgumentExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitArgumentExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitArgumentExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitArgumentExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func argumentExpression() throws -> ArgumentExpressionContext {
		let _localctx: ArgumentExpressionContext = ArgumentExpressionContext(_ctx, getState())
		try enterRule(_localctx, 302, ObjectiveCParser.RULE_argumentExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1830)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,246, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1828)
		 		try expression(0)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1829)
		 		try genericTypeSpecifier()

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

	public class PrimaryExpressionContext: ParserRuleContext {
			open
			func identifier() -> IdentifierContext? {
				return getRuleContext(IdentifierContext.self, 0)
			}
			open
			func constant() -> ConstantContext? {
				return getRuleContext(ConstantContext.self, 0)
			}
			open
			func stringLiteral() -> StringLiteralContext? {
				return getRuleContext(StringLiteralContext.self, 0)
			}
			open
			func LP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0)
			}
			open
			func expression() -> ExpressionContext? {
				return getRuleContext(ExpressionContext.self, 0)
			}
			open
			func RP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0)
			}
			open
			func messageExpression() -> MessageExpressionContext? {
				return getRuleContext(MessageExpressionContext.self, 0)
			}
			open
			func selectorExpression() -> SelectorExpressionContext? {
				return getRuleContext(SelectorExpressionContext.self, 0)
			}
			open
			func protocolExpression() -> ProtocolExpressionContext? {
				return getRuleContext(ProtocolExpressionContext.self, 0)
			}
			open
			func encodeExpression() -> EncodeExpressionContext? {
				return getRuleContext(EncodeExpressionContext.self, 0)
			}
			open
			func dictionaryExpression() -> DictionaryExpressionContext? {
				return getRuleContext(DictionaryExpressionContext.self, 0)
			}
			open
			func arrayExpression() -> ArrayExpressionContext? {
				return getRuleContext(ArrayExpressionContext.self, 0)
			}
			open
			func boxExpression() -> BoxExpressionContext? {
				return getRuleContext(BoxExpressionContext.self, 0)
			}
			open
			func blockExpression() -> BlockExpressionContext? {
				return getRuleContext(BlockExpressionContext.self, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_primaryExpression
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterPrimaryExpression(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitPrimaryExpression(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitPrimaryExpression(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitPrimaryExpression(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func primaryExpression() throws -> PrimaryExpressionContext {
		let _localctx: PrimaryExpressionContext = PrimaryExpressionContext(_ctx, getState())
		try enterRule(_localctx, 304, ObjectiveCParser.RULE_primaryExpression)
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1847)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,247, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1832)
		 		try identifier()

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1833)
		 		try constant()

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1834)
		 		try stringLiteral()

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1835)
		 		try match(ObjectiveCParser.Tokens.LP.rawValue)
		 		setState(1836)
		 		try expression(0)
		 		setState(1837)
		 		try match(ObjectiveCParser.Tokens.RP.rawValue)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(1839)
		 		try messageExpression()

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(1840)
		 		try selectorExpression()

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(1841)
		 		try protocolExpression()

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(1842)
		 		try encodeExpression()

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(1843)
		 		try dictionaryExpression()

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(1844)
		 		try arrayExpression()

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(1845)
		 		try boxExpression()

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(1846)
		 		try blockExpression()

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

	public class ConstantContext: ParserRuleContext {
			open
			func HEX_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue, 0)
			}
			open
			func OCTAL_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue, 0)
			}
			open
			func BINARY_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue, 0)
			}
			open
			func DECIMAL_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue, 0)
			}
			open
			func ADD() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
			}
			open
			func SUB() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
			}
			open
			func FLOATING_POINT_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue, 0)
			}
			open
			func CHARACTER_LITERAL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue, 0)
			}
			open
			func NIL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NIL.rawValue, 0)
			}
			open
			func NULL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULL.rawValue, 0)
			}
			open
			func YES() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.YES.rawValue, 0)
			}
			open
			func NO() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NO.rawValue, 0)
			}
			open
			func TRUE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.TRUE.rawValue, 0)
			}
			open
			func FALSE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.FALSE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_constant
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterConstant(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitConstant(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitConstant(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitConstant(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func constant() throws -> ConstantContext {
		let _localctx: ConstantContext = ConstantContext(_ctx, getState())
		try enterRule(_localctx, 306, ObjectiveCParser.RULE_constant)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	setState(1867)
		 	try _errHandler.sync(self)
		 	switch(try getInterpreter().adaptivePredict(_input,250, _ctx)) {
		 	case 1:
		 		try enterOuterAlt(_localctx, 1)
		 		setState(1849)
		 		try match(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue)

		 		break
		 	case 2:
		 		try enterOuterAlt(_localctx, 2)
		 		setState(1850)
		 		try match(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue)

		 		break
		 	case 3:
		 		try enterOuterAlt(_localctx, 3)
		 		setState(1851)
		 		try match(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue)

		 		break
		 	case 4:
		 		try enterOuterAlt(_localctx, 4)
		 		setState(1853)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1852)
		 			_la = try _input.LA(1)
		 			if (!(//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 			      return testSet
		 			 }())) {
		 			try _errHandler.recoverInline(self)
		 			}
		 			else {
		 				_errHandler.reportMatch(self)
		 				try consume()
		 			}

		 		}

		 		setState(1855)
		 		try match(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue)

		 		break
		 	case 5:
		 		try enterOuterAlt(_localctx, 5)
		 		setState(1857)
		 		try _errHandler.sync(self)
		 		_la = try _input.LA(1)
		 		if (//closure
		 		 { () -> Bool in
		 		      let testSet: Bool = _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 		      return testSet
		 		 }()) {
		 			setState(1856)
		 			_la = try _input.LA(1)
		 			if (!(//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == ObjectiveCParser.Tokens.ADD.rawValue || _la == ObjectiveCParser.Tokens.SUB.rawValue
		 			      return testSet
		 			 }())) {
		 			try _errHandler.recoverInline(self)
		 			}
		 			else {
		 				_errHandler.reportMatch(self)
		 				try consume()
		 			}

		 		}

		 		setState(1859)
		 		try match(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue)

		 		break
		 	case 6:
		 		try enterOuterAlt(_localctx, 6)
		 		setState(1860)
		 		try match(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue)

		 		break
		 	case 7:
		 		try enterOuterAlt(_localctx, 7)
		 		setState(1861)
		 		try match(ObjectiveCParser.Tokens.NIL.rawValue)

		 		break
		 	case 8:
		 		try enterOuterAlt(_localctx, 8)
		 		setState(1862)
		 		try match(ObjectiveCParser.Tokens.NULL.rawValue)

		 		break
		 	case 9:
		 		try enterOuterAlt(_localctx, 9)
		 		setState(1863)
		 		try match(ObjectiveCParser.Tokens.YES.rawValue)

		 		break
		 	case 10:
		 		try enterOuterAlt(_localctx, 10)
		 		setState(1864)
		 		try match(ObjectiveCParser.Tokens.NO.rawValue)

		 		break
		 	case 11:
		 		try enterOuterAlt(_localctx, 11)
		 		setState(1865)
		 		try match(ObjectiveCParser.Tokens.TRUE.rawValue)

		 		break
		 	case 12:
		 		try enterOuterAlt(_localctx, 12)
		 		setState(1866)
		 		try match(ObjectiveCParser.Tokens.FALSE.rawValue)

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

	public class StringLiteralContext: ParserRuleContext {
			open
			func STRING_START() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.STRING_START.rawValue)
			}
			open
			func STRING_START(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRING_START.rawValue, i)
			}
			open
			func STRING_END() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.STRING_END.rawValue)
			}
			open
			func STRING_END(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRING_END.rawValue, i)
			}
			open
			func STRING_VALUE() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
			}
			open
			func STRING_VALUE(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRING_VALUE.rawValue, i)
			}
			open
			func STRING_NEWLINE() -> [TerminalNode] {
				return getTokens(ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue)
			}
			open
			func STRING_NEWLINE(_ i:Int) -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue, i)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_stringLiteral
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterStringLiteral(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitStringLiteral(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
			    return visitor.visitStringLiteral(self)
			}
			else {
			     return visitor.visitChildren(self)
			}
		}
	}
	@discardableResult
	 open func stringLiteral() throws -> StringLiteralContext {
		let _localctx: StringLiteralContext = StringLiteralContext(_ctx, getState())
		try enterRule(_localctx, 308, ObjectiveCParser.RULE_stringLiteral)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
			var _alt:Int
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1877); 
		 	try _errHandler.sync(self)
		 	_alt = 1;
		 	repeat {
		 		switch (_alt) {
		 		case 1:
		 			setState(1869)
		 			try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
		 			setState(1873)
		 			try _errHandler.sync(self)
		 			_la = try _input.LA(1)
		 			while (//closure
		 			 { () -> Bool in
		 			      let testSet: Bool = _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
		 			      return testSet
		 			 }()) {
		 				setState(1870)
		 				_la = try _input.LA(1)
		 				if (!(//closure
		 				 { () -> Bool in
		 				      let testSet: Bool = _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
		 				      return testSet
		 				 }())) {
		 				try _errHandler.recoverInline(self)
		 				}
		 				else {
		 					_errHandler.reportMatch(self)
		 					try consume()
		 				}


		 				setState(1875)
		 				try _errHandler.sync(self)
		 				_la = try _input.LA(1)
		 			}
		 			setState(1876)
		 			try match(ObjectiveCParser.Tokens.STRING_END.rawValue)


		 			break
		 		default:
		 			throw ANTLRException.recognition(e: NoViableAltException(self))
		 		}
		 		setState(1879); 
		 		try _errHandler.sync(self)
		 		_alt = try getInterpreter().adaptivePredict(_input,252,_ctx)
		 	} while (_alt != 2 && _alt !=  ATN.INVALID_ALT_NUMBER)

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
			func IDENTIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IDENTIFIER.rawValue, 0)
			}
			open
			func BOOL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BOOL.rawValue, 0)
			}
			open
			func Class() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.Class.rawValue, 0)
			}
			open
			func BYCOPY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BYCOPY.rawValue, 0)
			}
			open
			func BYREF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BYREF.rawValue, 0)
			}
			open
			func ID() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ID.rawValue, 0)
			}
			open
			func IMP() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IMP.rawValue, 0)
			}
			open
			func IN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0)
			}
			open
			func INOUT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.INOUT.rawValue, 0)
			}
			open
			func ONEWAY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ONEWAY.rawValue, 0)
			}
			open
			func OUT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.OUT.rawValue, 0)
			}
			open
			func PROTOCOL_() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.PROTOCOL_.rawValue, 0)
			}
			open
			func SEL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SEL.rawValue, 0)
			}
			open
			func SELF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SELF.rawValue, 0)
			}
			open
			func SUPER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SUPER.rawValue, 0)
			}
			open
			func ATOMIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ATOMIC.rawValue, 0)
			}
			open
			func NONATOMIC() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NONATOMIC.rawValue, 0)
			}
			open
			func RETAIN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.RETAIN.rawValue, 0)
			}
			open
			func AUTORELEASING_QUALIFIER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue, 0)
			}
			open
			func BLOCK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BLOCK.rawValue, 0)
			}
			open
			func BRIDGE_RETAINED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue, 0)
			}
			open
			func BRIDGE_TRANSFER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue, 0)
			}
			open
			func COVARIANT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
			}
			open
			func CONTRAVARIANT() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
			}
			open
			func DEPRECATED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.DEPRECATED.rawValue, 0)
			}
			open
			func KINDOF() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
			}
			open
			func UNUSED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNUSED.rawValue, 0)
			}
			open
			func NS_INLINE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_INLINE.rawValue, 0)
			}
			open
			func NS_ENUM() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_ENUM.rawValue, 0)
			}
			open
			func NS_OPTIONS() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NS_OPTIONS.rawValue, 0)
			}
			open
			func NULL_UNSPECIFIED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue, 0)
			}
			open
			func NULLABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULLABLE.rawValue, 0)
			}
			open
			func NONNULL() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NONNULL.rawValue, 0)
			}
			open
			func NULL_RESETTABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue, 0)
			}
			open
			func ASSIGN() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.ASSIGN.rawValue, 0)
			}
			open
			func COPY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.COPY.rawValue, 0)
			}
			open
			func GETTER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.GETTER.rawValue, 0)
			}
			open
			func SETTER() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.SETTER.rawValue, 0)
			}
			open
			func STRONG() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.STRONG.rawValue, 0)
			}
			open
			func READONLY() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.READONLY.rawValue, 0)
			}
			open
			func READWRITE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.READWRITE.rawValue, 0)
			}
			open
			func WEAK() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.WEAK.rawValue, 0)
			}
			open
			func UNSAFE_UNRETAINED() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue, 0)
			}
			open
			func IB_OUTLET() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_OUTLET.rawValue, 0)
			}
			open
			func IB_OUTLET_COLLECTION() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue, 0)
			}
			open
			func IB_INSPECTABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue, 0)
			}
			open
			func IB_DESIGNABLE() -> TerminalNode? {
				return getToken(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue, 0)
			}
		override open
		func getRuleIndex() -> Int {
			return ObjectiveCParser.RULE_identifier
		}
		override open
		func enterRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.enterIdentifier(self)
			}
		}
		override open
		func exitRule(_ listener: ParseTreeListener) {
			if let listener = listener as? ObjectiveCParserListener {
				listener.exitIdentifier(self)
			}
		}
		override open
		func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
			if let visitor = visitor as? ObjectiveCParserVisitor {
			    return visitor.visitIdentifier(self)
			}
			else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
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
		try enterRule(_localctx, 310, ObjectiveCParser.RULE_identifier)
		var _la: Int = 0
		defer {
	    		try! exitRule()
	    }
		do {
		 	try enterOuterAlt(_localctx, 1)
		 	setState(1881)
		 	_la = try _input.LA(1)
		 	if (!(//closure
		 	 { () -> Bool in
		 	      var testSet: Bool = {  () -> Bool in
		 	   let testArray: [Int] = [_la, ObjectiveCParser.Tokens.BOOL.rawValue,ObjectiveCParser.Tokens.Class.rawValue,ObjectiveCParser.Tokens.BYCOPY.rawValue,ObjectiveCParser.Tokens.BYREF.rawValue,ObjectiveCParser.Tokens.ID.rawValue,ObjectiveCParser.Tokens.IMP.rawValue,ObjectiveCParser.Tokens.IN.rawValue,ObjectiveCParser.Tokens.INOUT.rawValue,ObjectiveCParser.Tokens.ONEWAY.rawValue,ObjectiveCParser.Tokens.OUT.rawValue,ObjectiveCParser.Tokens.PROTOCOL_.rawValue,ObjectiveCParser.Tokens.SEL.rawValue,ObjectiveCParser.Tokens.SELF.rawValue,ObjectiveCParser.Tokens.SUPER.rawValue]
		 	    return  Utils.testBitLeftShiftArray(testArray, 0)
		 	}()
		 	          testSet = testSet || {  () -> Bool in
		 	             let testArray: [Int] = [_la, ObjectiveCParser.Tokens.ATOMIC.rawValue,ObjectiveCParser.Tokens.NONATOMIC.rawValue,ObjectiveCParser.Tokens.RETAIN.rawValue,ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue,ObjectiveCParser.Tokens.BLOCK.rawValue,ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue,ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue,ObjectiveCParser.Tokens.COVARIANT.rawValue,ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue,ObjectiveCParser.Tokens.DEPRECATED.rawValue,ObjectiveCParser.Tokens.KINDOF.rawValue,ObjectiveCParser.Tokens.UNUSED.rawValue,ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue,ObjectiveCParser.Tokens.NULLABLE.rawValue,ObjectiveCParser.Tokens.NONNULL.rawValue,ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue,ObjectiveCParser.Tokens.NS_INLINE.rawValue,ObjectiveCParser.Tokens.NS_ENUM.rawValue,ObjectiveCParser.Tokens.NS_OPTIONS.rawValue,ObjectiveCParser.Tokens.ASSIGN.rawValue,ObjectiveCParser.Tokens.COPY.rawValue,ObjectiveCParser.Tokens.GETTER.rawValue,ObjectiveCParser.Tokens.SETTER.rawValue,ObjectiveCParser.Tokens.STRONG.rawValue,ObjectiveCParser.Tokens.READONLY.rawValue,ObjectiveCParser.Tokens.READWRITE.rawValue,ObjectiveCParser.Tokens.WEAK.rawValue,ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue,ObjectiveCParser.Tokens.IB_OUTLET.rawValue,ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue,ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue,ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue,ObjectiveCParser.Tokens.IDENTIFIER.rawValue]
		 	              return  Utils.testBitLeftShiftArray(testArray, 81)
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

	override open
	func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int,  _ predIndex: Int)throws -> Bool {
		switch (ruleIndex) {
		case  141:
			return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
		case  148:
			return try postfixExpression_sempred(_localctx?.castdown(PostfixExpressionContext.self), predIndex)
	    default: return true
		}
	}
	private func expression_sempred(_ _localctx: ExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 0:return precpred(_ctx, 13)
		    case 1:return precpred(_ctx, 12)
		    case 2:return precpred(_ctx, 11)
		    case 3:return precpred(_ctx, 10)
		    case 4:return precpred(_ctx, 9)
		    case 5:return precpred(_ctx, 8)
		    case 6:return precpred(_ctx, 7)
		    case 7:return precpred(_ctx, 6)
		    case 8:return precpred(_ctx, 5)
		    case 9:return precpred(_ctx, 4)
		    case 10:return precpred(_ctx, 3)
		    default: return true
		}
	}
	private func postfixExpression_sempred(_ _localctx: PostfixExpressionContext!,  _ predIndex: Int) throws -> Bool {
		switch (predIndex) {
		    case 11:return precpred(_ctx, 1)
		    default: return true
		}
	}


	public
	static let _serializedATN = ObjectiveCParserATN().jsonString
}
