// Generated from java-escape by ANTLR 4.11.1
import Antlr4

open class ObjectiveCParser: Parser {

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
        case AUTO = 1
        case BREAK = 2
        case CASE = 3
        case CHAR = 4
        case CONST = 5
        case CONTINUE = 6
        case DEFAULT = 7
        case DO = 8
        case DOUBLE = 9
        case ELSE = 10
        case ENUM = 11
        case EXTERN = 12
        case FLOAT = 13
        case FOR = 14
        case GOTO = 15
        case IF = 16
        case INLINE = 17
        case INT = 18
        case LONG = 19
        case REGISTER = 20
        case RESTRICT = 21
        case RETURN = 22
        case SHORT = 23
        case SIGNED = 24
        case SIZEOF = 25
        case STATIC = 26
        case STRUCT = 27
        case SWITCH = 28
        case TYPEDEF = 29
        case UNION = 30
        case UNSIGNED = 31
        case VOID = 32
        case VOLATILE = 33
        case WHILE = 34
        case BOOL_ = 35
        case COMPLEX = 36
        case IMAGINERY = 37
        case TRUE = 38
        case FALSE = 39
        case BOOL = 40
        case Class = 41
        case BYCOPY = 42
        case BYREF = 43
        case ID = 44
        case IMP = 45
        case IN = 46
        case INOUT = 47
        case NIL = 48
        case NO = 49
        case NULL = 50
        case ONEWAY = 51
        case OUT = 52
        case PROTOCOL_ = 53
        case SEL = 54
        case SELF = 55
        case SUPER = 56
        case YES = 57
        case AUTORELEASEPOOL = 58
        case CATCH = 59
        case CLASS = 60
        case DYNAMIC = 61
        case ENCODE = 62
        case END = 63
        case FINALLY = 64
        case IMPLEMENTATION = 65
        case INTERFACE = 66
        case IMPORT = 67
        case PACKAGE = 68
        case PROTOCOL = 69
        case OPTIONAL = 70
        case PRIVATE = 71
        case PROPERTY = 72
        case PROTECTED = 73
        case PUBLIC = 74
        case REQUIRED = 75
        case SELECTOR = 76
        case SYNCHRONIZED = 77
        case SYNTHESIZE = 78
        case THROW = 79
        case TRY = 80
        case ATOMIC = 81
        case NONATOMIC = 82
        case RETAIN = 83
        case ATTRIBUTE = 84
        case AUTORELEASING_QUALIFIER = 85
        case BLOCK = 86
        case BRIDGE = 87
        case BRIDGE_RETAINED = 88
        case BRIDGE_TRANSFER = 89
        case COVARIANT = 90
        case CONTRAVARIANT = 91
        case DEPRECATED = 92
        case KINDOF = 93
        case STRONG_QUALIFIER = 94
        case TYPEOF = 95
        case UNSAFE_UNRETAINED_QUALIFIER = 96
        case UNUSED = 97
        case WEAK_QUALIFIER = 98
        case NULL_UNSPECIFIED = 99
        case NULLABLE = 100
        case NONNULL = 101
        case NULL_RESETTABLE = 102
        case NS_INLINE = 103
        case NS_ENUM = 104
        case NS_OPTIONS = 105
        case ASSIGN = 106
        case COPY = 107
        case GETTER = 108
        case SETTER = 109
        case STRONG = 110
        case READONLY = 111
        case READWRITE = 112
        case WEAK = 113
        case UNSAFE_UNRETAINED = 114
        case IB_OUTLET = 115
        case IB_OUTLET_COLLECTION = 116
        case IB_INSPECTABLE = 117
        case IB_DESIGNABLE = 118
        case NS_ASSUME_NONNULL_BEGIN = 119
        case NS_ASSUME_NONNULL_END = 120
        case EXTERN_SUFFIX = 121
        case IOS_SUFFIX = 122
        case MAC_SUFFIX = 123
        case TVOS_PROHIBITED = 124
        case IDENTIFIER = 125
        case LP = 126
        case RP = 127
        case LBRACE = 128
        case RBRACE = 129
        case LBRACK = 130
        case RBRACK = 131
        case SEMI = 132
        case COMMA = 133
        case DOT = 134
        case STRUCTACCESS = 135
        case AT = 136
        case ASSIGNMENT = 137
        case GT = 138
        case LT = 139
        case BANG = 140
        case TILDE = 141
        case QUESTION = 142
        case COLON = 143
        case EQUAL = 144
        case LE = 145
        case GE = 146
        case NOTEQUAL = 147
        case AND = 148
        case OR = 149
        case INC = 150
        case DEC = 151
        case ADD = 152
        case SUB = 153
        case MUL = 154
        case DIV = 155
        case BITAND = 156
        case BITOR = 157
        case BITXOR = 158
        case MOD = 159
        case ADD_ASSIGN = 160
        case SUB_ASSIGN = 161
        case MUL_ASSIGN = 162
        case DIV_ASSIGN = 163
        case AND_ASSIGN = 164
        case OR_ASSIGN = 165
        case XOR_ASSIGN = 166
        case MOD_ASSIGN = 167
        case LSHIFT_ASSIGN = 168
        case RSHIFT_ASSIGN = 169
        case ELIPSIS = 170
        case CHARACTER_LITERAL = 171
        case STRING_START = 172
        case HEX_LITERAL = 173
        case OCTAL_LITERAL = 174
        case BINARY_LITERAL = 175
        case DECIMAL_LITERAL = 176
        case FLOATING_POINT_LITERAL = 177
        case WS = 178
        case MULTI_COMMENT = 179
        case SINGLE_COMMENT = 180
        case BACKSLASH = 181
        case SHARP = 182
        case STRING_NEWLINE = 183
        case STRING_END = 184
        case STRING_VALUE = 185
        case PATH = 186
        case DIRECTIVE_IMPORT = 187
        case DIRECTIVE_INCLUDE = 188
        case DIRECTIVE_PRAGMA = 189
        case DIRECTIVE_DEFINE = 190
        case DIRECTIVE_DEFINED = 191
        case DIRECTIVE_IF = 192
        case DIRECTIVE_ELIF = 193
        case DIRECTIVE_ELSE = 194
        case DIRECTIVE_UNDEF = 195
        case DIRECTIVE_IFDEF = 196
        case DIRECTIVE_IFNDEF = 197
        case DIRECTIVE_ENDIF = 198
        case DIRECTIVE_TRUE = 199
        case DIRECTIVE_FALSE = 200
        case DIRECTIVE_ERROR = 201
        case DIRECTIVE_WARNING = 202
        case DIRECTIVE_HASINCLUDE = 203
        case DIRECTIVE_BANG = 204
        case DIRECTIVE_LP = 205
        case DIRECTIVE_RP = 206
        case DIRECTIVE_EQUAL = 207
        case DIRECTIVE_NOTEQUAL = 208
        case DIRECTIVE_AND = 209
        case DIRECTIVE_OR = 210
        case DIRECTIVE_LT = 211
        case DIRECTIVE_GT = 212
        case DIRECTIVE_LE = 213
        case DIRECTIVE_GE = 214
        case DIRECTIVE_STRING = 215
        case DIRECTIVE_ID = 216
        case DIRECTIVE_DECIMAL_LITERAL = 217
        case DIRECTIVE_FLOAT = 218
        case DIRECTIVE_NEWLINE = 219
        case DIRECTIVE_MULTI_COMMENT = 220
        case DIRECTIVE_SINGLE_COMMENT = 221
        case DIRECTIVE_BACKSLASH_NEWLINE = 222
        case DIRECTIVE_TEXT_NEWLINE = 223
        case DIRECTIVE_TEXT = 224
        case DIRECTIVE_PATH = 225
        case DIRECTIVE_PATH_STRING = 226
    }

    public static let RULE_translationUnit = 0, RULE_topLevelDeclaration = 1,
        RULE_importDeclaration = 2, RULE_classInterface = 3, RULE_classInterfaceName = 4,
        RULE_categoryInterface = 5, RULE_classImplementation = 6, RULE_classImplementatioName = 7,
        RULE_categoryImplementation = 8, RULE_className = 9, RULE_superclassName = 10,
        RULE_genericSuperclassName = 11, RULE_genericTypeSpecifier = 12,
        RULE_genericSuperclassSpecifier = 13, RULE_superclassTypeSpecifierWithPrefixes = 14,
        RULE_protocolDeclaration = 15, RULE_protocolDeclarationSection = 16,
        RULE_protocolDeclarationList = 17, RULE_classDeclarationList = 18, RULE_protocolList = 19,
        RULE_propertyDeclaration = 20, RULE_propertyAttributesList = 21,
        RULE_propertyAttribute = 22, RULE_protocolName = 23, RULE_instanceVariables = 24,
        RULE_visibilitySection = 25, RULE_accessModifier = 26, RULE_interfaceDeclarationList = 27,
        RULE_classMethodDeclaration = 28, RULE_instanceMethodDeclaration = 29,
        RULE_methodDeclaration = 30, RULE_implementationDefinitionList = 31,
        RULE_classMethodDefinition = 32, RULE_instanceMethodDefinition = 33,
        RULE_methodDefinition = 34, RULE_methodSelector = 35, RULE_keywordDeclarator = 36,
        RULE_selector = 37, RULE_methodType = 38, RULE_propertyImplementation = 39,
        RULE_propertySynthesizeList = 40, RULE_propertySynthesizeItem = 41, RULE_blockType = 42,
        RULE_genericsSpecifier = 43, RULE_typeSpecifierWithPrefixes = 44,
        RULE_dictionaryExpression = 45, RULE_dictionaryPair = 46, RULE_arrayExpression = 47,
        RULE_boxExpression = 48, RULE_blockParameters = 49, RULE_typeVariableDeclaratorOrName = 50,
        RULE_blockExpression = 51, RULE_messageExpression = 52, RULE_receiver = 53,
        RULE_messageSelector = 54, RULE_keywordArgument = 55, RULE_keywordArgumentType = 56,
        RULE_selectorExpression = 57, RULE_selectorName = 58, RULE_protocolExpression = 59,
        RULE_encodeExpression = 60, RULE_typeVariableDeclarator = 61, RULE_throwStatement = 62,
        RULE_tryBlock = 63, RULE_catchStatement = 64, RULE_synchronizedStatement = 65,
        RULE_autoreleaseStatement = 66, RULE_functionDeclaration = 67, RULE_functionDefinition = 68,
        RULE_functionSignature = 69, RULE_attribute = 70, RULE_attributeName = 71,
        RULE_attributeParameters = 72, RULE_attributeParameterList = 73,
        RULE_attributeParameter = 74, RULE_attributeParameterAssignment = 75, RULE_declaration = 76,
        RULE_functionPointer = 77, RULE_functionPointerParameterList = 78,
        RULE_functionPointerParameterDeclarationList = 79,
        RULE_functionPointerParameterDeclaration = 80, RULE_functionCallExpression = 81,
        RULE_enumDeclaration = 82, RULE_varDeclaration = 83, RULE_typedefDeclaration = 84,
        RULE_typeDeclaratorList = 85, RULE_declarationSpecifiers = 86, RULE_attributeSpecifier = 87,
        RULE_initDeclaratorList = 88, RULE_initDeclarator = 89, RULE_structOrUnionSpecifier = 90,
        RULE_fieldDeclaration = 91, RULE_specifierQualifierList = 92, RULE_ibOutletQualifier = 93,
        RULE_arcBehaviourSpecifier = 94, RULE_nullabilitySpecifier = 95,
        RULE_storageClassSpecifier = 96, RULE_typePrefix = 97, RULE_typeQualifier = 98,
        RULE_protocolQualifier = 99, RULE_typeSpecifier = 100, RULE_scalarTypeSpecifier = 101,
        RULE_typeofExpression = 102, RULE_fieldDeclaratorList = 103, RULE_fieldDeclarator = 104,
        RULE_enumSpecifier = 105, RULE_enumeratorList = 106, RULE_enumerator = 107,
        RULE_enumeratorIdentifier = 108, RULE_directDeclarator = 109, RULE_declaratorSuffix = 110,
        RULE_parameterList = 111, RULE_pointer = 112, RULE_macro = 113, RULE_arrayInitializer = 114,
        RULE_structInitializer = 115, RULE_structInitializerItem = 116, RULE_initializerList = 117,
        RULE_typeName = 118, RULE_abstractDeclarator = 119, RULE_abstractDeclaratorSuffix = 120,
        RULE_parameterDeclarationList = 121, RULE_parameterDeclaration = 122, RULE_declarator = 123,
        RULE_statement = 124, RULE_labeledStatement = 125, RULE_rangeExpression = 126,
        RULE_compoundStatement = 127, RULE_selectionStatement = 128, RULE_switchStatement = 129,
        RULE_switchBlock = 130, RULE_switchSection = 131, RULE_switchLabel = 132,
        RULE_iterationStatement = 133, RULE_whileStatement = 134, RULE_doStatement = 135,
        RULE_forStatement = 136, RULE_forLoopInitializer = 137, RULE_forInStatement = 138,
        RULE_jumpStatement = 139, RULE_expressions = 140, RULE_expression = 141,
        RULE_assignmentOperator = 142, RULE_castExpression = 143, RULE_initializer = 144,
        RULE_constantExpression = 145, RULE_unaryExpression = 146, RULE_unaryOperator = 147,
        RULE_postfixExpression = 148, RULE_postfixExpr = 149, RULE_argumentExpressionList = 150,
        RULE_argumentExpression = 151, RULE_primaryExpression = 152, RULE_constant = 153,
        RULE_stringLiteral = 154, RULE_identifier = 155

    public static let ruleNames: [String] = [
        "translationUnit", "topLevelDeclaration", "importDeclaration", "classInterface",
        "classInterfaceName", "categoryInterface", "classImplementation", "classImplementatioName",
        "categoryImplementation", "className", "superclassName", "genericSuperclassName",
        "genericTypeSpecifier", "genericSuperclassSpecifier", "superclassTypeSpecifierWithPrefixes",
        "protocolDeclaration", "protocolDeclarationSection", "protocolDeclarationList",
        "classDeclarationList", "protocolList", "propertyDeclaration", "propertyAttributesList",
        "propertyAttribute", "protocolName", "instanceVariables", "visibilitySection",
        "accessModifier", "interfaceDeclarationList", "classMethodDeclaration",
        "instanceMethodDeclaration", "methodDeclaration", "implementationDefinitionList",
        "classMethodDefinition", "instanceMethodDefinition", "methodDefinition", "methodSelector",
        "keywordDeclarator", "selector", "methodType", "propertyImplementation",
        "propertySynthesizeList", "propertySynthesizeItem", "blockType", "genericsSpecifier",
        "typeSpecifierWithPrefixes", "dictionaryExpression", "dictionaryPair", "arrayExpression",
        "boxExpression", "blockParameters", "typeVariableDeclaratorOrName", "blockExpression",
        "messageExpression", "receiver", "messageSelector", "keywordArgument",
        "keywordArgumentType", "selectorExpression", "selectorName", "protocolExpression",
        "encodeExpression", "typeVariableDeclarator", "throwStatement", "tryBlock",
        "catchStatement", "synchronizedStatement", "autoreleaseStatement", "functionDeclaration",
        "functionDefinition", "functionSignature", "attribute", "attributeName",
        "attributeParameters", "attributeParameterList", "attributeParameter",
        "attributeParameterAssignment", "declaration", "functionPointer",
        "functionPointerParameterList", "functionPointerParameterDeclarationList",
        "functionPointerParameterDeclaration", "functionCallExpression", "enumDeclaration",
        "varDeclaration", "typedefDeclaration", "typeDeclaratorList", "declarationSpecifiers",
        "attributeSpecifier", "initDeclaratorList", "initDeclarator", "structOrUnionSpecifier",
        "fieldDeclaration", "specifierQualifierList", "ibOutletQualifier", "arcBehaviourSpecifier",
        "nullabilitySpecifier", "storageClassSpecifier", "typePrefix", "typeQualifier",
        "protocolQualifier", "typeSpecifier", "scalarTypeSpecifier", "typeofExpression",
        "fieldDeclaratorList", "fieldDeclarator", "enumSpecifier", "enumeratorList", "enumerator",
        "enumeratorIdentifier", "directDeclarator", "declaratorSuffix", "parameterList", "pointer",
        "macro", "arrayInitializer", "structInitializer", "structInitializerItem",
        "initializerList", "typeName", "abstractDeclarator", "abstractDeclaratorSuffix",
        "parameterDeclarationList", "parameterDeclaration", "declarator", "statement",
        "labeledStatement", "rangeExpression", "compoundStatement", "selectionStatement",
        "switchStatement", "switchBlock", "switchSection", "switchLabel", "iterationStatement",
        "whileStatement", "doStatement", "forStatement", "forLoopInitializer", "forInStatement",
        "jumpStatement", "expressions", "expression", "assignmentOperator", "castExpression",
        "initializer", "constantExpression", "unaryExpression", "unaryOperator",
        "postfixExpression", "postfixExpr", "argumentExpressionList", "argumentExpression",
        "primaryExpression", "constant", "stringLiteral", "identifier",
    ]

    private static let _LITERAL_NAMES: [String?] = [
        nil, "'auto'", "'break'", "'case'", "'char'", "'const'", "'continue'", "'default'", "'do'",
        "'double'", nil, "'enum'", "'extern'", "'float'", "'for'", "'goto'", nil, "'inline'",
        "'int'", "'long'", "'register'", "'restrict'", "'return'", "'short'", "'signed'",
        "'sizeof'", "'static'", "'struct'", "'switch'", "'typedef'", "'union'", "'unsigned'",
        "'void'", "'volatile'", "'while'", "'_Bool'", "'_Complex'", "'_Imaginery'", "'true'",
        "'false'", "'BOOL'", "'Class'", "'bycopy'", "'byref'", "'id'", "'IMP'", "'in'", "'inout'",
        "'nil'", "'NO'", "'NULL'", "'oneway'", "'out'", "'Protocol'", "'SEL'", "'self'", "'super'",
        "'YES'", "'@autoreleasepool'", "'@catch'", "'@class'", "'@dynamic'", "'@encode'", "'@end'",
        "'@finally'", "'@implementation'", "'@interface'", "'@import'", "'@package'", "'@protocol'",
        "'@optional'", "'@private'", "'@property'", "'@protected'", "'@public'", "'@required'",
        "'@selector'", "'@synchronized'", "'@synthesize'", "'@throw'", "'@try'", "'atomic'",
        "'nonatomic'", "'retain'", "'__attribute__'", "'__autoreleasing'", "'__block'",
        "'__bridge'", "'__bridge_retained'", "'__bridge_transfer'", "'__covariant'",
        "'__contravariant'", "'__deprecated'", "'__kindof'", "'__strong'", nil,
        "'__unsafe_unretained'", "'__unused'", "'__weak'", nil, nil, nil, "'null_resettable'",
        "'NS_INLINE'", "'NS_ENUM'", "'NS_OPTIONS'", "'assign'", "'copy'", "'getter'", "'setter'",
        "'strong'", "'readonly'", "'readwrite'", "'weak'", "'unsafe_unretained'", "'IBOutlet'",
        "'IBOutletCollection'", "'IBInspectable'", "'IB_DESIGNABLE'", nil, nil, nil, nil, nil,
        "'__TVOS_PROHIBITED'", nil, nil, nil, "'{'", "'}'", "'['", "']'", "';'", "','", "'.'",
        "'->'", "'@'", "'='", nil, nil, nil, "'~'", "'?'", "':'", nil, nil, nil, nil, nil, nil,
        "'++'", "'--'", "'+'", "'-'", "'*'", "'/'", "'&'", "'|'", "'^'", "'%'", "'+='", "'-='",
        "'*='", "'/='", "'&='", "'|='", "'^='", "'%='", "'<<='", "'>>='", "'...'", nil, nil, nil,
        nil, nil, nil, nil, nil, nil, nil, "'\\'", nil, nil, nil, nil, nil, nil, nil, nil, nil,
        "'defined'", nil, "'elif'", nil, "'undef'", "'ifdef'", "'ifndef'", "'endif'",
    ]
    private static let _SYMBOLIC_NAMES: [String?] = [
        nil, "AUTO", "BREAK", "CASE", "CHAR", "CONST", "CONTINUE", "DEFAULT", "DO", "DOUBLE",
        "ELSE", "ENUM", "EXTERN", "FLOAT", "FOR", "GOTO", "IF", "INLINE", "INT", "LONG", "REGISTER",
        "RESTRICT", "RETURN", "SHORT", "SIGNED", "SIZEOF", "STATIC", "STRUCT", "SWITCH", "TYPEDEF",
        "UNION", "UNSIGNED", "VOID", "VOLATILE", "WHILE", "BOOL_", "COMPLEX", "IMAGINERY", "TRUE",
        "FALSE", "BOOL", "Class", "BYCOPY", "BYREF", "ID", "IMP", "IN", "INOUT", "NIL", "NO",
        "NULL", "ONEWAY", "OUT", "PROTOCOL_", "SEL", "SELF", "SUPER", "YES", "AUTORELEASEPOOL",
        "CATCH", "CLASS", "DYNAMIC", "ENCODE", "END", "FINALLY", "IMPLEMENTATION", "INTERFACE",
        "IMPORT", "PACKAGE", "PROTOCOL", "OPTIONAL", "PRIVATE", "PROPERTY", "PROTECTED", "PUBLIC",
        "REQUIRED", "SELECTOR", "SYNCHRONIZED", "SYNTHESIZE", "THROW", "TRY", "ATOMIC", "NONATOMIC",
        "RETAIN", "ATTRIBUTE", "AUTORELEASING_QUALIFIER", "BLOCK", "BRIDGE", "BRIDGE_RETAINED",
        "BRIDGE_TRANSFER", "COVARIANT", "CONTRAVARIANT", "DEPRECATED", "KINDOF", "STRONG_QUALIFIER",
        "TYPEOF", "UNSAFE_UNRETAINED_QUALIFIER", "UNUSED", "WEAK_QUALIFIER", "NULL_UNSPECIFIED",
        "NULLABLE", "NONNULL", "NULL_RESETTABLE", "NS_INLINE", "NS_ENUM", "NS_OPTIONS", "ASSIGN",
        "COPY", "GETTER", "SETTER", "STRONG", "READONLY", "READWRITE", "WEAK", "UNSAFE_UNRETAINED",
        "IB_OUTLET", "IB_OUTLET_COLLECTION", "IB_INSPECTABLE", "IB_DESIGNABLE",
        "NS_ASSUME_NONNULL_BEGIN", "NS_ASSUME_NONNULL_END", "EXTERN_SUFFIX", "IOS_SUFFIX",
        "MAC_SUFFIX", "TVOS_PROHIBITED", "IDENTIFIER", "LP", "RP", "LBRACE", "RBRACE", "LBRACK",
        "RBRACK", "SEMI", "COMMA", "DOT", "STRUCTACCESS", "AT", "ASSIGNMENT", "GT", "LT", "BANG",
        "TILDE", "QUESTION", "COLON", "EQUAL", "LE", "GE", "NOTEQUAL", "AND", "OR", "INC", "DEC",
        "ADD", "SUB", "MUL", "DIV", "BITAND", "BITOR", "BITXOR", "MOD", "ADD_ASSIGN", "SUB_ASSIGN",
        "MUL_ASSIGN", "DIV_ASSIGN", "AND_ASSIGN", "OR_ASSIGN", "XOR_ASSIGN", "MOD_ASSIGN",
        "LSHIFT_ASSIGN", "RSHIFT_ASSIGN", "ELIPSIS", "CHARACTER_LITERAL", "STRING_START",
        "HEX_LITERAL", "OCTAL_LITERAL", "BINARY_LITERAL", "DECIMAL_LITERAL",
        "FLOATING_POINT_LITERAL", "WS", "MULTI_COMMENT", "SINGLE_COMMENT", "BACKSLASH", "SHARP",
        "STRING_NEWLINE", "STRING_END", "STRING_VALUE", "PATH", "DIRECTIVE_IMPORT",
        "DIRECTIVE_INCLUDE", "DIRECTIVE_PRAGMA", "DIRECTIVE_DEFINE", "DIRECTIVE_DEFINED",
        "DIRECTIVE_IF", "DIRECTIVE_ELIF", "DIRECTIVE_ELSE", "DIRECTIVE_UNDEF", "DIRECTIVE_IFDEF",
        "DIRECTIVE_IFNDEF", "DIRECTIVE_ENDIF", "DIRECTIVE_TRUE", "DIRECTIVE_FALSE",
        "DIRECTIVE_ERROR", "DIRECTIVE_WARNING", "DIRECTIVE_HASINCLUDE", "DIRECTIVE_BANG",
        "DIRECTIVE_LP", "DIRECTIVE_RP", "DIRECTIVE_EQUAL", "DIRECTIVE_NOTEQUAL", "DIRECTIVE_AND",
        "DIRECTIVE_OR", "DIRECTIVE_LT", "DIRECTIVE_GT", "DIRECTIVE_LE", "DIRECTIVE_GE",
        "DIRECTIVE_STRING", "DIRECTIVE_ID", "DIRECTIVE_DECIMAL_LITERAL", "DIRECTIVE_FLOAT",
        "DIRECTIVE_NEWLINE", "DIRECTIVE_MULTI_COMMENT", "DIRECTIVE_SINGLE_COMMENT",
        "DIRECTIVE_BACKSLASH_NEWLINE", "DIRECTIVE_TEXT_NEWLINE", "DIRECTIVE_TEXT", "DIRECTIVE_PATH",
        "DIRECTIVE_PATH_STRING",
    ]
    public static let VOCABULARY = Vocabulary(_LITERAL_NAMES, _SYMBOLIC_NAMES)

    override open func getGrammarFileName() -> String { return "java-escape" }

    override open func getRuleNames() -> [String] { return ObjectiveCParser.ruleNames }

    override open func getSerializedATN() -> [Int] { return ObjectiveCParser._serializedATN }

    override open func getATN() -> ATN { return _ATN }

    override open func getVocabulary() -> Vocabulary { return ObjectiveCParser.VOCABULARY }

    override public convenience init(_ input: TokenStream) throws { try self.init(input, State()) }

    public required init(_ input: TokenStream, _ state: State) throws {
        self.state = state

        RuntimeMetaData.checkVersion("4.11.1", RuntimeMetaData.VERSION)
        try super.init(input)
        _interp = ParserATNSimulator(self, _ATN, _decisionToDFA, _sharedContextCache)
    }

    public class TranslationUnitContext: ParserRuleContext {
        open func EOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EOF.rawValue, 0)
        }
        open func topLevelDeclaration() -> [TopLevelDeclarationContext] {
            return getRuleContexts(TopLevelDeclarationContext.self)
        }
        open func topLevelDeclaration(_ i: Int) -> TopLevelDeclarationContext? {
            return getRuleContext(TopLevelDeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_translationUnit }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTranslationUnit(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTranslationUnit(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTranslationUnit(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTranslationUnit(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func translationUnit() throws -> TranslationUnitContext {
        var _localctx: TranslationUnitContext
        _localctx = TranslationUnitContext(_ctx, getState())
        try enterRule(_localctx, 0, ObjectiveCParser.RULE_translationUnit)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(315)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_295_065_285_207_669_298) != 0
                || (Int64((_la - 65)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 65)) & 1_170_935_903_116_263_447) != 0
            {
                setState(312)
                try topLevelDeclaration()

                setState(317)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(318)
            try match(ObjectiveCParser.Tokens.EOF.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TopLevelDeclarationContext: ParserRuleContext {
        open func importDeclaration() -> ImportDeclarationContext? {
            return getRuleContext(ImportDeclarationContext.self, 0)
        }
        open func functionDeclaration() -> FunctionDeclarationContext? {
            return getRuleContext(FunctionDeclarationContext.self, 0)
        }
        open func declaration() -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, 0)
        }
        open func classInterface() -> ClassInterfaceContext? {
            return getRuleContext(ClassInterfaceContext.self, 0)
        }
        open func classImplementation() -> ClassImplementationContext? {
            return getRuleContext(ClassImplementationContext.self, 0)
        }
        open func categoryInterface() -> CategoryInterfaceContext? {
            return getRuleContext(CategoryInterfaceContext.self, 0)
        }
        open func categoryImplementation() -> CategoryImplementationContext? {
            return getRuleContext(CategoryImplementationContext.self, 0)
        }
        open func protocolDeclaration() -> ProtocolDeclarationContext? {
            return getRuleContext(ProtocolDeclarationContext.self, 0)
        }
        open func protocolDeclarationList() -> ProtocolDeclarationListContext? {
            return getRuleContext(ProtocolDeclarationListContext.self, 0)
        }
        open func classDeclarationList() -> ClassDeclarationListContext? {
            return getRuleContext(ClassDeclarationListContext.self, 0)
        }
        open func functionDefinition() -> FunctionDefinitionContext? {
            return getRuleContext(FunctionDefinitionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_topLevelDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTopLevelDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTopLevelDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTopLevelDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTopLevelDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func topLevelDeclaration() throws -> TopLevelDeclarationContext {
        var _localctx: TopLevelDeclarationContext
        _localctx = TopLevelDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 2, ObjectiveCParser.RULE_topLevelDeclaration)
        defer { try! exitRule() }
        do {
            setState(331)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImportDeclarationContext: ParserRuleContext {
        open func IMPORT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IMPORT.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_importDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterImportDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitImportDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitImportDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitImportDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func importDeclaration() throws -> ImportDeclarationContext {
        var _localctx: ImportDeclarationContext
        _localctx = ImportDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 4, ObjectiveCParser.RULE_importDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(333)
            try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
            setState(334)
            try identifier()
            setState(335)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassInterfaceContext: ParserRuleContext {
        open func INTERFACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INTERFACE.rawValue, 0)
        }
        open func classInterfaceName() -> ClassInterfaceNameContext? {
            return getRuleContext(ClassInterfaceNameContext.self, 0)
        }
        open func END() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
        }
        open func IB_DESIGNABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue, 0)
        }
        open func instanceVariables() -> InstanceVariablesContext? {
            return getRuleContext(InstanceVariablesContext.self, 0)
        }
        open func interfaceDeclarationList() -> InterfaceDeclarationListContext? {
            return getRuleContext(InterfaceDeclarationListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_classInterface }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassInterface(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassInterface(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassInterface(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassInterface(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classInterface() throws -> ClassInterfaceContext {
        var _localctx: ClassInterfaceContext
        _localctx = ClassInterfaceContext(_ctx, getState())
        try enterRule(_localctx, 6, ObjectiveCParser.RULE_classInterface)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(338)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue {
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
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(342)
                try instanceVariables()

            }

            setState(346)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_600_822_322) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & 9_147_936_743_095_809) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(345)
                try interfaceDeclarationList()

            }

            setState(348)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassInterfaceNameContext: ParserRuleContext {
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func superclassName() -> SuperclassNameContext? {
            return getRuleContext(SuperclassNameContext.self, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func genericSuperclassName() -> GenericSuperclassNameContext? {
            return getRuleContext(GenericSuperclassNameContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_classInterfaceName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassInterfaceName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassInterfaceName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassInterfaceName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassInterfaceName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classInterfaceName() throws -> ClassInterfaceNameContext {
        var _localctx: ClassInterfaceNameContext
        _localctx = ClassInterfaceNameContext(_ctx, getState())
        try enterRule(_localctx, 8, ObjectiveCParser.RULE_classInterfaceName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(372)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 9, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(350)
                try className()
                setState(353)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                    setState(351)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(352)
                    try superclassName()

                }

                setState(359)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
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
                if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                    setState(362)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(363)
                    try genericSuperclassName()

                }

                setState(370)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CategoryInterfaceContext: ParserRuleContext {
        open var categoryName: ClassNameContext!
        open func INTERFACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INTERFACE.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func END() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
        }
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func instanceVariables() -> InstanceVariablesContext? {
            return getRuleContext(InstanceVariablesContext.self, 0)
        }
        open func interfaceDeclarationList() -> InterfaceDeclarationListContext? {
            return getRuleContext(InterfaceDeclarationListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_categoryInterface }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterCategoryInterface(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitCategoryInterface(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitCategoryInterface(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitCategoryInterface(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func categoryInterface() throws -> CategoryInterfaceContext {
        var _localctx: CategoryInterfaceContext
        _localctx = CategoryInterfaceContext(_ctx, getState())
        try enterRule(_localctx, 10, ObjectiveCParser.RULE_categoryInterface)
        var _la: Int = 0
        defer { try! exitRule() }
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
                setState(377)
                try identifier()

            }

            setState(380)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(385)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
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
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(387)
                try instanceVariables()

            }

            setState(391)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_600_822_322) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & 9_147_936_743_095_809) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(390)
                try interfaceDeclarationList()

            }

            setState(393)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassImplementationContext: ParserRuleContext {
        open func IMPLEMENTATION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue, 0)
        }
        open func classImplementatioName() -> ClassImplementatioNameContext? {
            return getRuleContext(ClassImplementatioNameContext.self, 0)
        }
        open func END() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
        }
        open func instanceVariables() -> InstanceVariablesContext? {
            return getRuleContext(InstanceVariablesContext.self, 0)
        }
        open func implementationDefinitionList() -> ImplementationDefinitionListContext? {
            return getRuleContext(ImplementationDefinitionListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classImplementation
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassImplementation(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassImplementation(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassImplementation(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassImplementation(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classImplementation() throws -> ClassImplementationContext {
        var _localctx: ClassImplementationContext
        _localctx = ClassImplementationContext(_ctx, getState())
        try enterRule(_localctx, 12, ObjectiveCParser.RULE_classImplementation)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(395)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(396)
            try classImplementatioName()
            setState(398)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(397)
                try instanceVariables()

            }

            setState(401)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_447_986_789_814_516_274) != 0
                || (Int64((_la - 78)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 78)) & 142_936_511_610_873) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(400)
                try implementationDefinitionList()

            }

            setState(403)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassImplementatioNameContext: ParserRuleContext {
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func superclassName() -> SuperclassNameContext? {
            return getRuleContext(SuperclassNameContext.self, 0)
        }
        open func genericSuperclassName() -> GenericSuperclassNameContext? {
            return getRuleContext(GenericSuperclassNameContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classImplementatioName
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassImplementatioName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassImplementatioName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassImplementatioName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassImplementatioName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classImplementatioName() throws -> ClassImplementatioNameContext {
        var _localctx: ClassImplementatioNameContext
        _localctx = ClassImplementatioNameContext(_ctx, getState())
        try enterRule(_localctx, 14, ObjectiveCParser.RULE_classImplementatioName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(415)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 18, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(405)
                try className()
                setState(408)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COLON.rawValue {
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
                if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                    setState(411)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(412)
                    try genericSuperclassName()

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

    public class CategoryImplementationContext: ParserRuleContext {
        open var categoryName: ClassNameContext!
        open func IMPLEMENTATION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func END() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
        }
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func implementationDefinitionList() -> ImplementationDefinitionListContext? {
            return getRuleContext(ImplementationDefinitionListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_categoryImplementation
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterCategoryImplementation(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitCategoryImplementation(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitCategoryImplementation(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitCategoryImplementation(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func categoryImplementation() throws -> CategoryImplementationContext {
        var _localctx: CategoryImplementationContext
        _localctx = CategoryImplementationContext(_ctx, getState())
        try enterRule(_localctx, 16, ObjectiveCParser.RULE_categoryImplementation)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(417)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(418)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryImplementationContext.self).categoryName =
                    assignmentValue
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_447_986_789_814_516_274) != 0
                || (Int64((_la - 78)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 78)) & 142_936_511_610_873) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(422)
                try implementationDefinitionList()

            }

            setState(425)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassNameContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func genericsSpecifier() -> GenericsSpecifierContext? {
            return getRuleContext(GenericsSpecifierContext.self, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_className }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitClassName(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func className() throws -> ClassNameContext {
        var _localctx: ClassNameContext
        _localctx = ClassNameContext(_ctx, getState())
        try enterRule(_localctx, 18, ObjectiveCParser.RULE_className)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(427)
            try identifier()
            setState(433)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 20, _ctx) {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SuperclassNameContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_superclassName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSuperclassName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSuperclassName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSuperclassName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSuperclassName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func superclassName() throws -> SuperclassNameContext {
        var _localctx: SuperclassNameContext
        _localctx = SuperclassNameContext(_ctx, getState())
        try enterRule(_localctx, 20, ObjectiveCParser.RULE_superclassName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(435)
            try identifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericSuperclassNameContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func genericSuperclassSpecifier() -> GenericSuperclassSpecifierContext? {
            return getRuleContext(GenericSuperclassSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_genericSuperclassName
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericSuperclassName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericSuperclassName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericSuperclassName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericSuperclassName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericSuperclassName() throws -> GenericSuperclassNameContext {
        var _localctx: GenericSuperclassNameContext
        _localctx = GenericSuperclassNameContext(_ctx, getState())
        try enterRule(_localctx, 22, ObjectiveCParser.RULE_genericSuperclassName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(437)
            try identifier()
            setState(438)
            try genericSuperclassSpecifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericTypeSpecifierContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func genericsSpecifier() -> GenericsSpecifierContext? {
            return getRuleContext(GenericsSpecifierContext.self, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_genericTypeSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericTypeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericTypeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericTypeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericTypeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericTypeSpecifier() throws -> GenericTypeSpecifierContext {
        var _localctx: GenericTypeSpecifierContext
        _localctx = GenericTypeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 24, ObjectiveCParser.RULE_genericTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(440)
            try identifier()
            setState(446)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 21, _ctx) {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericSuperclassSpecifierContext: ParserRuleContext {
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func superclassTypeSpecifierWithPrefixes()
            -> [SuperclassTypeSpecifierWithPrefixesContext]
        { return getRuleContexts(SuperclassTypeSpecifierWithPrefixesContext.self) }
        open func superclassTypeSpecifierWithPrefixes(_ i: Int)
            -> SuperclassTypeSpecifierWithPrefixesContext?
        { return getRuleContext(SuperclassTypeSpecifierWithPrefixesContext.self, i) }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_genericSuperclassSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericSuperclassSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericSuperclassSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericSuperclassSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericSuperclassSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericSuperclassSpecifier() throws
        -> GenericSuperclassSpecifierContext
    {
        var _localctx: GenericSuperclassSpecifierContext
        _localctx = GenericSuperclassSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 26, ObjectiveCParser.RULE_genericSuperclassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(448)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(457)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_771_403_758_096) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_779_319) != 0
            {
                setState(449)
                try superclassTypeSpecifierWithPrefixes()
                setState(454)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SuperclassTypeSpecifierWithPrefixesContext: ParserRuleContext {
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func typePrefix() -> [TypePrefixContext] {
            return getRuleContexts(TypePrefixContext.self)
        }
        open func typePrefix(_ i: Int) -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, i)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_superclassTypeSpecifierWithPrefixes
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSuperclassTypeSpecifierWithPrefixes(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSuperclassTypeSpecifierWithPrefixes(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSuperclassTypeSpecifierWithPrefixes(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSuperclassTypeSpecifierWithPrefixes(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func superclassTypeSpecifierWithPrefixes() throws
        -> SuperclassTypeSpecifierWithPrefixesContext
    {
        var _localctx: SuperclassTypeSpecifierWithPrefixesContext
        _localctx = SuperclassTypeSpecifierWithPrefixesContext(_ctx, getState())
        try enterRule(_localctx, 28, ObjectiveCParser.RULE_superclassTypeSpecifierWithPrefixes)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(464)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 24, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(461)
                    try typePrefix()

                }
                setState(466)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 24, _ctx)
            }
            setState(467)
            try typeSpecifier()
            setState(469)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(468)
                try pointer()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ProtocolDeclarationContext: ParserRuleContext {
        open func PROTOCOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
        }
        open func protocolName() -> ProtocolNameContext? {
            return getRuleContext(ProtocolNameContext.self, 0)
        }
        open func END() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.END.rawValue, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func protocolDeclarationSection() -> [ProtocolDeclarationSectionContext] {
            return getRuleContexts(ProtocolDeclarationSectionContext.self)
        }
        open func protocolDeclarationSection(_ i: Int) -> ProtocolDeclarationSectionContext? {
            return getRuleContext(ProtocolDeclarationSectionContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_protocolDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolDeclaration() throws -> ProtocolDeclarationContext {
        var _localctx: ProtocolDeclarationContext
        _localctx = ProtocolDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 30, ObjectiveCParser.RULE_protocolDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(471)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(472)
            try protocolName()
            setState(477)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
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
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_600_822_322) != 0
                || (Int64((_la - 70)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 70)) & 36_591_746_972_383_269) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(479)
                try protocolDeclarationSection()

                setState(484)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(485)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ProtocolDeclarationSectionContext: ParserRuleContext {
        open var modifier: Token!
        open func REQUIRED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.REQUIRED.rawValue, 0)
        }
        open func OPTIONAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OPTIONAL.rawValue, 0)
        }
        open func interfaceDeclarationList() -> [InterfaceDeclarationListContext] {
            return getRuleContexts(InterfaceDeclarationListContext.self)
        }
        open func interfaceDeclarationList(_ i: Int) -> InterfaceDeclarationListContext? {
            return getRuleContext(InterfaceDeclarationListContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_protocolDeclarationSection
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolDeclarationSection(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolDeclarationSection(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolDeclarationSection(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolDeclarationSection(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolDeclarationSection() throws
        -> ProtocolDeclarationSectionContext
    {
        var _localctx: ProtocolDeclarationSectionContext
        _localctx = ProtocolDeclarationSectionContext(_ctx, getState())
        try enterRule(_localctx, 32, ObjectiveCParser.RULE_protocolDeclarationSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(499)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .OPTIONAL, .REQUIRED:
                try enterOuterAlt(_localctx, 1)
                setState(487)
                _localctx.castdown(ProtocolDeclarationSectionContext.self).modifier = try _input.LT(
                    1)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.OPTIONAL.rawValue
                    || _la == ObjectiveCParser.Tokens.REQUIRED.rawValue)
                {
                    _localctx.castdown(ProtocolDeclarationSectionContext.self).modifier =
                        try _errHandler.recoverInline(self) as Token
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(491)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 28, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(488)
                        try interfaceDeclarationList()

                    }
                    setState(493)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 28, _ctx)
                }

                break
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT,
                .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF, .SUPER, .PROPERTY, .ATOMIC, .NONATOMIC,
                .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE, .BRIDGE_RETAINED,
                .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF,
                .STRONG_QUALIFIER, .TYPEOF, .UNSAFE_UNRETAINED_QUALIFIER, .UNUSED, .WEAK_QUALIFIER,
                .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM,
                .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE,
                .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                .IB_DESIGNABLE, .IDENTIFIER, .ADD, .SUB:
                try enterOuterAlt(_localctx, 2)
                setState(495)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(494)
                        try interfaceDeclarationList()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(497)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 29, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

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

    public class ProtocolDeclarationListContext: ParserRuleContext {
        open func PROTOCOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
        }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_protocolDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolDeclarationList() throws -> ProtocolDeclarationListContext
    {
        var _localctx: ProtocolDeclarationListContext
        _localctx = ProtocolDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 34, ObjectiveCParser.RULE_protocolDeclarationList)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(501)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(502)
            try protocolList()
            setState(503)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassDeclarationListContext: ParserRuleContext {
        open func CLASS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CLASS.rawValue, 0)
        }
        open func className() -> [ClassNameContext] {
            return getRuleContexts(ClassNameContext.self)
        }
        open func className(_ i: Int) -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, i)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classDeclarationList() throws -> ClassDeclarationListContext {
        var _localctx: ClassDeclarationListContext
        _localctx = ClassDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 36, ObjectiveCParser.RULE_classDeclarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(505)
            try match(ObjectiveCParser.Tokens.CLASS.rawValue)
            setState(506)
            try className()
            setState(511)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ProtocolListContext: ParserRuleContext {
        open func protocolName() -> [ProtocolNameContext] {
            return getRuleContexts(ProtocolNameContext.self)
        }
        open func protocolName(_ i: Int) -> ProtocolNameContext? {
            return getRuleContext(ProtocolNameContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_protocolList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolList() throws -> ProtocolListContext {
        var _localctx: ProtocolListContext
        _localctx = ProtocolListContext(_ctx, getState())
        try enterRule(_localctx, 38, ObjectiveCParser.RULE_protocolList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(516)
            try protocolName()
            setState(521)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(517)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(518)
                try protocolName()

                setState(523)
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

    public class PropertyDeclarationContext: ParserRuleContext {
        open func PROPERTY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROPERTY.rawValue, 0)
        }
        open func fieldDeclaration() -> FieldDeclarationContext? {
            return getRuleContext(FieldDeclarationContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func propertyAttributesList() -> PropertyAttributesListContext? {
            return getRuleContext(PropertyAttributesListContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func ibOutletQualifier() -> IbOutletQualifierContext? {
            return getRuleContext(IbOutletQualifierContext.self, 0)
        }
        open func IB_INSPECTABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_propertyDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertyDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertyDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertyDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertyDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyDeclaration() throws -> PropertyDeclarationContext {
        var _localctx: PropertyDeclarationContext
        _localctx = PropertyDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 40, ObjectiveCParser.RULE_propertyDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(524)
            try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
            setState(529)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(525)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(526)
                try propertyAttributesList()
                setState(527)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

            setState(532)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 34, _ctx) {
            case 1:
                setState(531)
                try ibOutletQualifier()

                break
            default: break
            }
            setState(535)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 35, _ctx) {
            case 1:
                setState(534)
                try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

                break
            default: break
            }
            setState(537)
            try fieldDeclaration()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PropertyAttributesListContext: ParserRuleContext {
        open func propertyAttribute() -> [PropertyAttributeContext] {
            return getRuleContexts(PropertyAttributeContext.self)
        }
        open func propertyAttribute(_ i: Int) -> PropertyAttributeContext? {
            return getRuleContext(PropertyAttributeContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_propertyAttributesList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertyAttributesList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertyAttributesList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertyAttributesList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertyAttributesList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyAttributesList() throws -> PropertyAttributesListContext {
        var _localctx: PropertyAttributesListContext
        _localctx = PropertyAttributesListContext(_ctx, getState())
        try enterRule(_localctx, 42, ObjectiveCParser.RULE_propertyAttributesList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(539)
            try propertyAttribute()
            setState(544)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(540)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(541)
                try propertyAttribute()

                setState(546)
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

    public class PropertyAttributeContext: ParserRuleContext {
        open func ATOMIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATOMIC.rawValue, 0)
        }
        open func NONATOMIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NONATOMIC.rawValue, 0)
        }
        open func STRONG() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRONG.rawValue, 0)
        }
        open func WEAK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WEAK.rawValue, 0)
        }
        open func RETAIN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RETAIN.rawValue, 0)
        }
        open func ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGN.rawValue, 0)
        }
        open func UNSAFE_UNRETAINED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue, 0)
        }
        open func COPY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COPY.rawValue, 0)
        }
        open func READONLY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.READONLY.rawValue, 0)
        }
        open func READWRITE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.READWRITE.rawValue, 0)
        }
        open func GETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.GETTER.rawValue, 0)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func SETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SETTER.rawValue, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_propertyAttribute }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertyAttribute(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertyAttribute(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertyAttribute(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertyAttribute(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyAttribute() throws -> PropertyAttributeContext {
        var _localctx: PropertyAttributeContext
        _localctx = PropertyAttributeContext(_ctx, getState())
        try enterRule(_localctx, 44, ObjectiveCParser.RULE_propertyAttribute)
        defer { try! exitRule() }
        do {
            setState(567)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 37, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ProtocolNameContext: ParserRuleContext {
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func COVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
        }
        open func CONTRAVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_protocolName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolName() throws -> ProtocolNameContext {
        var _localctx: ProtocolNameContext
        _localctx = ProtocolNameContext(_ctx, getState())
        try enterRule(_localctx, 46, ObjectiveCParser.RULE_protocolName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(577)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LT:
                try enterOuterAlt(_localctx, 1)
                setState(569)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(570)
                try protocolList()
                setState(571)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .KINDOF, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE,
                .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG,
                .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(574)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 38, _ctx) {
                case 1:
                    setState(573)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.COVARIANT.rawValue
                        || _la == ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }

                    break
                default: break
                }
                setState(576)
                try identifier()

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

    public class InstanceVariablesContext: ParserRuleContext {
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func visibilitySection() -> [VisibilitySectionContext] {
            return getRuleContexts(VisibilitySectionContext.self)
        }
        open func visibilitySection(_ i: Int) -> VisibilitySectionContext? {
            return getRuleContext(VisibilitySectionContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_instanceVariables }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInstanceVariables(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInstanceVariables(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInstanceVariables(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInstanceVariables(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func instanceVariables() throws -> InstanceVariablesContext {
        var _localctx: InstanceVariablesContext
        _localctx = InstanceVariablesContext(_ctx, getState())
        try enterRule(_localctx, 48, ObjectiveCParser.RULE_instanceVariables)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(579)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(583)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                || (Int64((_la - 68)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 68)) & 146_366_987_889_533_033) != 0
            {
                setState(580)
                try visibilitySection()

                setState(585)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(586)
            try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VisibilitySectionContext: ParserRuleContext {
        open func accessModifier() -> AccessModifierContext? {
            return getRuleContext(AccessModifierContext.self, 0)
        }
        open func fieldDeclaration() -> [FieldDeclarationContext] {
            return getRuleContexts(FieldDeclarationContext.self)
        }
        open func fieldDeclaration(_ i: Int) -> FieldDeclarationContext? {
            return getRuleContext(FieldDeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_visibilitySection }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterVisibilitySection(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitVisibilitySection(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitVisibilitySection(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitVisibilitySection(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func visibilitySection() throws -> VisibilitySectionContext {
        var _localctx: VisibilitySectionContext
        _localctx = VisibilitySectionContext(_ctx, getState())
        try enterRule(_localctx, 50, ObjectiveCParser.RULE_visibilitySection)
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(600)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .PACKAGE, .PRIVATE, .PROTECTED, .PUBLIC:
                try enterOuterAlt(_localctx, 1)
                setState(588)
                try accessModifier()
                setState(592)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 41, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(589)
                        try fieldDeclaration()

                    }
                    setState(594)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 41, _ctx)
                }

                break
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .UNION, .UNSIGNED, .VOID,
                .VOLATILE, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE,
                .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF,
                .UNSAFE_UNRETAINED_QUALIFIER, .UNUSED, .WEAK_QUALIFIER, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(596)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(595)
                        try fieldDeclaration()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(598)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 42, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

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

    public class AccessModifierContext: ParserRuleContext {
        open func PRIVATE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PRIVATE.rawValue, 0)
        }
        open func PROTECTED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROTECTED.rawValue, 0)
        }
        open func PACKAGE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PACKAGE.rawValue, 0)
        }
        open func PUBLIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PUBLIC.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_accessModifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAccessModifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAccessModifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAccessModifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAccessModifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func accessModifier() throws -> AccessModifierContext {
        var _localctx: AccessModifierContext
        _localctx = AccessModifierContext(_ctx, getState())
        try enterRule(_localctx, 52, ObjectiveCParser.RULE_accessModifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(602)
            _la = try _input.LA(1)
            if !((Int64((_la - 68)) & ~0x3f) == 0 && ((Int64(1) << (_la - 68)) & 105) != 0) {
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

    public class InterfaceDeclarationListContext: ParserRuleContext {
        open func declaration() -> [DeclarationContext] {
            return getRuleContexts(DeclarationContext.self)
        }
        open func declaration(_ i: Int) -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, i)
        }
        open func classMethodDeclaration() -> [ClassMethodDeclarationContext] {
            return getRuleContexts(ClassMethodDeclarationContext.self)
        }
        open func classMethodDeclaration(_ i: Int) -> ClassMethodDeclarationContext? {
            return getRuleContext(ClassMethodDeclarationContext.self, i)
        }
        open func instanceMethodDeclaration() -> [InstanceMethodDeclarationContext] {
            return getRuleContexts(InstanceMethodDeclarationContext.self)
        }
        open func instanceMethodDeclaration(_ i: Int) -> InstanceMethodDeclarationContext? {
            return getRuleContext(InstanceMethodDeclarationContext.self, i)
        }
        open func propertyDeclaration() -> [PropertyDeclarationContext] {
            return getRuleContexts(PropertyDeclarationContext.self)
        }
        open func propertyDeclaration(_ i: Int) -> PropertyDeclarationContext? {
            return getRuleContext(PropertyDeclarationContext.self, i)
        }
        open func functionDeclaration() -> [FunctionDeclarationContext] {
            return getRuleContexts(FunctionDeclarationContext.self)
        }
        open func functionDeclaration(_ i: Int) -> FunctionDeclarationContext? {
            return getRuleContext(FunctionDeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_interfaceDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInterfaceDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInterfaceDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInterfaceDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInterfaceDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func interfaceDeclarationList() throws
        -> InterfaceDeclarationListContext
    {
        var _localctx: InterfaceDeclarationListContext
        _localctx = InterfaceDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 54, ObjectiveCParser.RULE_interfaceDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(609)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(609)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 44, _ctx) {
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(611)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 45, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassMethodDeclarationContext: ParserRuleContext {
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func methodDeclaration() -> MethodDeclarationContext? {
            return getRuleContext(MethodDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classMethodDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassMethodDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassMethodDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassMethodDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassMethodDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classMethodDeclaration() throws -> ClassMethodDeclarationContext {
        var _localctx: ClassMethodDeclarationContext
        _localctx = ClassMethodDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 56, ObjectiveCParser.RULE_classMethodDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(613)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(614)
            try methodDeclaration()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class InstanceMethodDeclarationContext: ParserRuleContext {
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        open func methodDeclaration() -> MethodDeclarationContext? {
            return getRuleContext(MethodDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_instanceMethodDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInstanceMethodDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInstanceMethodDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInstanceMethodDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInstanceMethodDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func instanceMethodDeclaration() throws
        -> InstanceMethodDeclarationContext
    {
        var _localctx: InstanceMethodDeclarationContext
        _localctx = InstanceMethodDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 58, ObjectiveCParser.RULE_instanceMethodDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(616)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(617)
            try methodDeclaration()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MethodDeclarationContext: ParserRuleContext {
        open func methodSelector() -> MethodSelectorContext? {
            return getRuleContext(MethodSelectorContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func methodType() -> MethodTypeContext? {
            return getRuleContext(MethodTypeContext.self, 0)
        }
        open func attributeSpecifier() -> [AttributeSpecifierContext] {
            return getRuleContexts(AttributeSpecifierContext.self)
        }
        open func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, i)
        }
        open func macro() -> MacroContext? { return getRuleContext(MacroContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_methodDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMethodDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMethodDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMethodDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMethodDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func methodDeclaration() throws -> MethodDeclarationContext {
        var _localctx: MethodDeclarationContext
        _localctx = MethodDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 60, ObjectiveCParser.RULE_methodDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(620)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(619)
                try methodType()

            }

            setState(622)
            try methodSelector()
            setState(626)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(623)
                try attributeSpecifier()

                setState(628)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(630)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
                setState(629)
                try macro()

            }

            setState(632)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ImplementationDefinitionListContext: ParserRuleContext {
        open func functionDefinition() -> [FunctionDefinitionContext] {
            return getRuleContexts(FunctionDefinitionContext.self)
        }
        open func functionDefinition(_ i: Int) -> FunctionDefinitionContext? {
            return getRuleContext(FunctionDefinitionContext.self, i)
        }
        open func declaration() -> [DeclarationContext] {
            return getRuleContexts(DeclarationContext.self)
        }
        open func declaration(_ i: Int) -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, i)
        }
        open func classMethodDefinition() -> [ClassMethodDefinitionContext] {
            return getRuleContexts(ClassMethodDefinitionContext.self)
        }
        open func classMethodDefinition(_ i: Int) -> ClassMethodDefinitionContext? {
            return getRuleContext(ClassMethodDefinitionContext.self, i)
        }
        open func instanceMethodDefinition() -> [InstanceMethodDefinitionContext] {
            return getRuleContexts(InstanceMethodDefinitionContext.self)
        }
        open func instanceMethodDefinition(_ i: Int) -> InstanceMethodDefinitionContext? {
            return getRuleContext(InstanceMethodDefinitionContext.self, i)
        }
        open func propertyImplementation() -> [PropertyImplementationContext] {
            return getRuleContexts(PropertyImplementationContext.self)
        }
        open func propertyImplementation(_ i: Int) -> PropertyImplementationContext? {
            return getRuleContext(PropertyImplementationContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_implementationDefinitionList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterImplementationDefinitionList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitImplementationDefinitionList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitImplementationDefinitionList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitImplementationDefinitionList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func implementationDefinitionList() throws
        -> ImplementationDefinitionListContext
    {
        var _localctx: ImplementationDefinitionListContext
        _localctx = ImplementationDefinitionListContext(_ctx, getState())
        try enterRule(_localctx, 62, ObjectiveCParser.RULE_implementationDefinitionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(639)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(639)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 49, _ctx) {
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

                setState(641)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & 2_447_986_789_814_516_274) != 0
                || (Int64((_la - 78)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 78)) & 142_936_511_610_873) != 0
                || _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassMethodDefinitionContext: ParserRuleContext {
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func methodDefinition() -> MethodDefinitionContext? {
            return getRuleContext(MethodDefinitionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classMethodDefinition
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassMethodDefinition(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassMethodDefinition(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassMethodDefinition(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassMethodDefinition(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classMethodDefinition() throws -> ClassMethodDefinitionContext {
        var _localctx: ClassMethodDefinitionContext
        _localctx = ClassMethodDefinitionContext(_ctx, getState())
        try enterRule(_localctx, 64, ObjectiveCParser.RULE_classMethodDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(643)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(644)
            try methodDefinition()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class InstanceMethodDefinitionContext: ParserRuleContext {
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        open func methodDefinition() -> MethodDefinitionContext? {
            return getRuleContext(MethodDefinitionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_instanceMethodDefinition
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInstanceMethodDefinition(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInstanceMethodDefinition(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInstanceMethodDefinition(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInstanceMethodDefinition(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func instanceMethodDefinition() throws
        -> InstanceMethodDefinitionContext
    {
        var _localctx: InstanceMethodDefinitionContext
        _localctx = InstanceMethodDefinitionContext(_ctx, getState())
        try enterRule(_localctx, 66, ObjectiveCParser.RULE_instanceMethodDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(646)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(647)
            try methodDefinition()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MethodDefinitionContext: ParserRuleContext {
        open func methodSelector() -> MethodSelectorContext? {
            return getRuleContext(MethodSelectorContext.self, 0)
        }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func methodType() -> MethodTypeContext? {
            return getRuleContext(MethodTypeContext.self, 0)
        }
        open func initDeclaratorList() -> InitDeclaratorListContext? {
            return getRuleContext(InitDeclaratorListContext.self, 0)
        }
        open func SEMI() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.SEMI.rawValue)
        }
        open func SEMI(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, i)
        }
        open func attributeSpecifier() -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_methodDefinition }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMethodDefinition(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMethodDefinition(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMethodDefinition(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMethodDefinition(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func methodDefinition() throws -> MethodDefinitionContext {
        var _localctx: MethodDefinitionContext
        _localctx = MethodDefinitionContext(_ctx, getState())
        try enterRule(_localctx, 68, ObjectiveCParser.RULE_methodDefinition)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(650)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(649)
                try methodType()

            }

            setState(652)
            try methodSelector()
            setState(654)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 40)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 40)) & -414_491_694_415_611_649) != 0
                || (Int64((_la - 104)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 104)) & 1_125_899_913_166_847) != 0
            {
                setState(653)
                try initDeclaratorList()

            }

            setState(657)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(656)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

            setState(660)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(659)
                try attributeSpecifier()

            }

            setState(662)
            try compoundStatement()
            setState(664)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(663)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MethodSelectorContext: ParserRuleContext {
        open func selector() -> SelectorContext? { return getRuleContext(SelectorContext.self, 0) }
        open func keywordDeclarator() -> [KeywordDeclaratorContext] {
            return getRuleContexts(KeywordDeclaratorContext.self)
        }
        open func keywordDeclarator(_ i: Int) -> KeywordDeclaratorContext? {
            return getRuleContext(KeywordDeclaratorContext.self, i)
        }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func ELIPSIS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_methodSelector }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMethodSelector(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMethodSelector(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMethodSelector(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMethodSelector(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func methodSelector() throws -> MethodSelectorContext {
        var _localctx: MethodSelectorContext
        _localctx = MethodSelectorContext(_ctx, getState())
        try enterRule(_localctx, 70, ObjectiveCParser.RULE_methodSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(676)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 58, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(666)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(668)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(667)
                        try keywordDeclarator()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(670)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 56, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER
                setState(674)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(672)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(673)
                    try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

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

    public class KeywordDeclaratorContext: ParserRuleContext {
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func selector() -> SelectorContext? { return getRuleContext(SelectorContext.self, 0) }
        open func methodType() -> [MethodTypeContext] {
            return getRuleContexts(MethodTypeContext.self)
        }
        open func methodType(_ i: Int) -> MethodTypeContext? {
            return getRuleContext(MethodTypeContext.self, i)
        }
        open func arcBehaviourSpecifier() -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_keywordDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterKeywordDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitKeywordDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitKeywordDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitKeywordDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func keywordDeclarator() throws -> KeywordDeclaratorContext {
        var _localctx: KeywordDeclaratorContext
        _localctx = KeywordDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 72, ObjectiveCParser.RULE_keywordDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(679)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_999_949_952) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
                setState(678)
                try selector()

            }

            setState(681)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(685)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(682)
                try methodType()

                setState(687)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(689)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 61, _ctx) {
            case 1:
                setState(688)
                try arcBehaviourSpecifier()

                break
            default: break
            }
            setState(691)
            try identifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SelectorContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func RETURN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RETURN.rawValue, 0)
        }
        open func SWITCH() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SWITCH.rawValue, 0)
        }
        open func IF() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.IF.rawValue, 0) }
        open func ELSE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELSE.rawValue, 0)
        }
        open func DEFAULT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEFAULT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_selector }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterSelector(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitSelector(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSelector(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSelector(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func selector() throws -> SelectorContext {
        var _localctx: SelectorContext
        _localctx = SelectorContext(_ctx, getState())
        try enterRule(_localctx, 74, ObjectiveCParser.RULE_selector)
        defer { try! exitRule() }
        do {
            setState(699)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .KINDOF, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE,
                .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG,
                .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MethodTypeContext: ParserRuleContext {
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_methodType }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMethodType(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMethodType(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMethodType(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMethodType(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func methodType() throws -> MethodTypeContext {
        var _localctx: MethodTypeContext
        _localctx = MethodTypeContext(_ctx, getState())
        try enterRule(_localctx, 76, ObjectiveCParser.RULE_methodType)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(701)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(702)
            try typeName()
            setState(703)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PropertyImplementationContext: ParserRuleContext {
        open func SYNTHESIZE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue, 0)
        }
        open func propertySynthesizeList() -> PropertySynthesizeListContext? {
            return getRuleContext(PropertySynthesizeListContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func DYNAMIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DYNAMIC.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_propertyImplementation
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertyImplementation(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertyImplementation(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertyImplementation(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertyImplementation(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertyImplementation() throws -> PropertyImplementationContext {
        var _localctx: PropertyImplementationContext
        _localctx = PropertyImplementationContext(_ctx, getState())
        try enterRule(_localctx, 78, ObjectiveCParser.RULE_propertyImplementation)
        defer { try! exitRule() }
        do {
            setState(713)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PropertySynthesizeListContext: ParserRuleContext {
        open func propertySynthesizeItem() -> [PropertySynthesizeItemContext] {
            return getRuleContexts(PropertySynthesizeItemContext.self)
        }
        open func propertySynthesizeItem(_ i: Int) -> PropertySynthesizeItemContext? {
            return getRuleContext(PropertySynthesizeItemContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_propertySynthesizeList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertySynthesizeList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertySynthesizeList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertySynthesizeList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertySynthesizeList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertySynthesizeList() throws -> PropertySynthesizeListContext {
        var _localctx: PropertySynthesizeListContext
        _localctx = PropertySynthesizeListContext(_ctx, getState())
        try enterRule(_localctx, 80, ObjectiveCParser.RULE_propertySynthesizeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(715)
            try propertySynthesizeItem()
            setState(720)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(716)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(717)
                try propertySynthesizeItem()

                setState(722)
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

    public class PropertySynthesizeItemContext: ParserRuleContext {
        open func identifier() -> [IdentifierContext] {
            return getRuleContexts(IdentifierContext.self)
        }
        open func identifier(_ i: Int) -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, i)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_propertySynthesizeItem
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPropertySynthesizeItem(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPropertySynthesizeItem(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPropertySynthesizeItem(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPropertySynthesizeItem(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func propertySynthesizeItem() throws -> PropertySynthesizeItemContext {
        var _localctx: PropertySynthesizeItemContext
        _localctx = PropertySynthesizeItemContext(_ctx, getState())
        try enterRule(_localctx, 82, ObjectiveCParser.RULE_propertySynthesizeItem)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(723)
            try identifier()
            setState(726)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(724)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(725)
                try identifier()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BlockTypeContext: ParserRuleContext {
        open func typeSpecifier() -> [TypeSpecifierContext] {
            return getRuleContexts(TypeSpecifierContext.self)
        }
        open func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, i)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func BITXOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
            return getRuleContexts(NullabilitySpecifierContext.self)
        }
        open func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, i)
        }
        open func blockParameters() -> BlockParametersContext? {
            return getRuleContext(BlockParametersContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_blockType }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBlockType(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitBlockType(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBlockType(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBlockType(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func blockType() throws -> BlockTypeContext {
        var _localctx: BlockTypeContext
        _localctx = BlockTypeContext(_ctx, getState())
        try enterRule(_localctx, 84, ObjectiveCParser.RULE_blockType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(729)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 66, _ctx) {
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
            if (Int64((_la - 99)) & ~0x3f) == 0 && ((Int64(1) << (_la - 99)) & 15) != 0 {
                setState(732)
                try nullabilitySpecifier()

            }

            setState(735)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(736)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(739)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 68, _ctx) {
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
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(742)
                try blockParameters()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericsSpecifierContext: ParserRuleContext {
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func typeSpecifierWithPrefixes() -> [TypeSpecifierWithPrefixesContext] {
            return getRuleContexts(TypeSpecifierWithPrefixesContext.self)
        }
        open func typeSpecifierWithPrefixes(_ i: Int) -> TypeSpecifierWithPrefixesContext? {
            return getRuleContext(TypeSpecifierWithPrefixesContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_genericsSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericsSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericsSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericsSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericsSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericsSpecifier() throws -> GenericsSpecifierContext {
        var _localctx: GenericsSpecifierContext
        _localctx = GenericsSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 86, ObjectiveCParser.RULE_genericsSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(745)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(754)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_771_403_758_096) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_779_319) != 0
            {
                setState(746)
                try typeSpecifierWithPrefixes()
                setState(751)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeSpecifierWithPrefixesContext: ParserRuleContext {
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func typePrefix() -> [TypePrefixContext] {
            return getRuleContexts(TypePrefixContext.self)
        }
        open func typePrefix(_ i: Int) -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, i)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_typeSpecifierWithPrefixes
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeSpecifierWithPrefixes(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeSpecifierWithPrefixes(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeSpecifierWithPrefixes(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeSpecifierWithPrefixes(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeSpecifierWithPrefixes() throws
        -> TypeSpecifierWithPrefixesContext
    {
        var _localctx: TypeSpecifierWithPrefixesContext
        _localctx = TypeSpecifierWithPrefixesContext(_ctx, getState())
        try enterRule(_localctx, 88, ObjectiveCParser.RULE_typeSpecifierWithPrefixes)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(761)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 72, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(758)
                    try typePrefix()

                }
                setState(763)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 72, _ctx)
            }
            setState(764)
            try typeSpecifier()
            setState(766)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(765)
                try pointer()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DictionaryExpressionContext: ParserRuleContext {
        open func AT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0) }
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func dictionaryPair() -> [DictionaryPairContext] {
            return getRuleContexts(DictionaryPairContext.self)
        }
        open func dictionaryPair(_ i: Int) -> DictionaryPairContext? {
            return getRuleContext(DictionaryPairContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_dictionaryExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDictionaryExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDictionaryExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDictionaryExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDictionaryExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func dictionaryExpression() throws -> DictionaryExpressionContext {
        var _localctx: DictionaryExpressionContext
        _localctx = DictionaryExpressionContext(_ctx, getState())
        try enterRule(_localctx, 90, ObjectiveCParser.RULE_dictionaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(768)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(769)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(781)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(770)
                try dictionaryPair()
                setState(775)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 74, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(771)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(772)
                        try dictionaryPair()

                    }
                    setState(777)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 74, _ctx)
                }
                setState(779)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(778)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(783)
            try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DictionaryPairContext: ParserRuleContext {
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_dictionaryPair }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDictionaryPair(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDictionaryPair(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDictionaryPair(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDictionaryPair(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func dictionaryPair() throws -> DictionaryPairContext {
        var _localctx: DictionaryPairContext
        _localctx = DictionaryPairContext(_ctx, getState())
        try enterRule(_localctx, 92, ObjectiveCParser.RULE_dictionaryPair)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(785)
            try castExpression()
            setState(786)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(787)
            try expression(0)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArrayExpressionContext: ParserRuleContext {
        open func AT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0) }
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_arrayExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterArrayExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitArrayExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitArrayExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitArrayExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrayExpression() throws -> ArrayExpressionContext {
        var _localctx: ArrayExpressionContext
        _localctx = ArrayExpressionContext(_ctx, getState())
        try enterRule(_localctx, 94, ObjectiveCParser.RULE_arrayExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(789)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(790)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(795)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(791)
                try expressions()
                setState(793)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(792)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(797)
            try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BoxExpressionContext: ParserRuleContext {
        open func AT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.AT.rawValue, 0) }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_boxExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBoxExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBoxExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBoxExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBoxExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func boxExpression() throws -> BoxExpressionContext {
        var _localctx: BoxExpressionContext
        _localctx = BoxExpressionContext(_ctx, getState())
        try enterRule(_localctx, 96, ObjectiveCParser.RULE_boxExpression)
        defer { try! exitRule() }
        do {
            setState(809)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 80, _ctx) {
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
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                    .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                    .FLOATING_POINT_LITERAL:
                    setState(805)
                    try constant()

                    break
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                    .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .UNUSED, .NULL_UNSPECIFIED,
                    .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS,
                    .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK,
                    .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
                    setState(806)
                    try identifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
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

    public class BlockParametersContext: ParserRuleContext {
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func typeVariableDeclaratorOrName() -> [TypeVariableDeclaratorOrNameContext] {
            return getRuleContexts(TypeVariableDeclaratorOrNameContext.self)
        }
        open func typeVariableDeclaratorOrName(_ i: Int) -> TypeVariableDeclaratorOrNameContext? {
            return getRuleContext(TypeVariableDeclaratorOrNameContext.self, i)
        }
        open func VOID() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_blockParameters }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBlockParameters(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBlockParameters(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBlockParameters(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBlockParameters(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func blockParameters() throws -> BlockParametersContext {
        var _localctx: BlockParametersContext
        _localctx = BlockParametersContext(_ctx, getState())
        try enterRule(_localctx, 98, ObjectiveCParser.RULE_blockParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(811)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(823)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_951_359) != 0
            {
                setState(814)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 81, _ctx) {
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
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeVariableDeclaratorOrNameContext: ParserRuleContext {
        open func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
            return getRuleContext(TypeVariableDeclaratorContext.self, 0)
        }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_typeVariableDeclaratorOrName
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeVariableDeclaratorOrName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeVariableDeclaratorOrName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeVariableDeclaratorOrName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeVariableDeclaratorOrName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeVariableDeclaratorOrName() throws
        -> TypeVariableDeclaratorOrNameContext
    {
        var _localctx: TypeVariableDeclaratorOrNameContext
        _localctx = TypeVariableDeclaratorOrNameContext(_ctx, getState())
        try enterRule(_localctx, 100, ObjectiveCParser.RULE_typeVariableDeclaratorOrName)
        defer { try! exitRule() }
        do {
            setState(829)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 84, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BlockExpressionContext: ParserRuleContext {
        open func BITXOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
        }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func blockParameters() -> BlockParametersContext? {
            return getRuleContext(BlockParametersContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_blockExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBlockExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBlockExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBlockExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBlockExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func blockExpression() throws -> BlockExpressionContext {
        var _localctx: BlockExpressionContext
        _localctx = BlockExpressionContext(_ctx, getState())
        try enterRule(_localctx, 102, ObjectiveCParser.RULE_blockExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(831)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(833)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 85, _ctx) {
            case 1:
                setState(832)
                try typeSpecifier()

                break
            default: break
            }
            setState(836)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 99)) & ~0x3f) == 0 && ((Int64(1) << (_la - 99)) & 15) != 0 {
                setState(835)
                try nullabilitySpecifier()

            }

            setState(839)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(838)
                try blockParameters()

            }

            setState(841)
            try compoundStatement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MessageExpressionContext: ParserRuleContext {
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func receiver() -> ReceiverContext? { return getRuleContext(ReceiverContext.self, 0) }
        open func messageSelector() -> MessageSelectorContext? {
            return getRuleContext(MessageSelectorContext.self, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_messageExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMessageExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMessageExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMessageExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMessageExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func messageExpression() throws -> MessageExpressionContext {
        var _localctx: MessageExpressionContext
        _localctx = MessageExpressionContext(_ctx, getState())
        try enterRule(_localctx, 104, ObjectiveCParser.RULE_messageExpression)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ReceiverContext: ParserRuleContext {
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
            return getRuleContext(GenericTypeSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_receiver }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterReceiver(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitReceiver(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitReceiver(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitReceiver(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func receiver() throws -> ReceiverContext {
        var _localctx: ReceiverContext
        _localctx = ReceiverContext(_ctx, getState())
        try enterRule(_localctx, 106, ObjectiveCParser.RULE_receiver)
        defer { try! exitRule() }
        do {
            setState(850)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 88, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class MessageSelectorContext: ParserRuleContext {
        open func selector() -> SelectorContext? { return getRuleContext(SelectorContext.self, 0) }
        open func keywordArgument() -> [KeywordArgumentContext] {
            return getRuleContexts(KeywordArgumentContext.self)
        }
        open func keywordArgument(_ i: Int) -> KeywordArgumentContext? {
            return getRuleContext(KeywordArgumentContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_messageSelector }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMessageSelector(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMessageSelector(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMessageSelector(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMessageSelector(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func messageSelector() throws -> MessageSelectorContext {
        var _localctx: MessageSelectorContext
        _localctx = MessageSelectorContext(_ctx, getState())
        try enterRule(_localctx, 108, ObjectiveCParser.RULE_messageSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(858)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 90, _ctx) {
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

                    setState(856)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 142_143_763_999_949_952) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 4_611_703_885_491_150_775) != 0

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

    public class KeywordArgumentContext: ParserRuleContext {
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func keywordArgumentType() -> [KeywordArgumentTypeContext] {
            return getRuleContexts(KeywordArgumentTypeContext.self)
        }
        open func keywordArgumentType(_ i: Int) -> KeywordArgumentTypeContext? {
            return getRuleContext(KeywordArgumentTypeContext.self, i)
        }
        open func selector() -> SelectorContext? { return getRuleContext(SelectorContext.self, 0) }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_keywordArgument }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterKeywordArgument(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitKeywordArgument(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitKeywordArgument(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitKeywordArgument(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func keywordArgument() throws -> KeywordArgumentContext {
        var _localctx: KeywordArgumentContext
        _localctx = KeywordArgumentContext(_ctx, getState())
        try enterRule(_localctx, 110, ObjectiveCParser.RULE_keywordArgument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(861)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_999_949_952) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
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
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(865)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(866)
                try keywordArgumentType()

                setState(871)
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

    public class KeywordArgumentTypeContext: ParserRuleContext {
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func initializerList() -> InitializerListContext? {
            return getRuleContext(InitializerListContext.self, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_keywordArgumentType
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterKeywordArgumentType(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitKeywordArgumentType(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitKeywordArgumentType(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitKeywordArgumentType(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func keywordArgumentType() throws -> KeywordArgumentTypeContext {
        var _localctx: KeywordArgumentTypeContext
        _localctx = KeywordArgumentTypeContext(_ctx, getState())
        try enterRule(_localctx, 112, ObjectiveCParser.RULE_keywordArgumentType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(872)
            try expressions()
            setState(874)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 93, _ctx) {
            case 1:
                setState(873)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(880)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(876)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(877)
                try initializerList()
                setState(878)
                try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SelectorExpressionContext: ParserRuleContext {
        open func SELECTOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SELECTOR.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func selectorName() -> SelectorNameContext? {
            return getRuleContext(SelectorNameContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_selectorExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSelectorExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSelectorExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSelectorExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSelectorExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func selectorExpression() throws -> SelectorExpressionContext {
        var _localctx: SelectorExpressionContext
        _localctx = SelectorExpressionContext(_ctx, getState())
        try enterRule(_localctx, 114, ObjectiveCParser.RULE_selectorExpression)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SelectorNameContext: ParserRuleContext {
        open func selector() -> [SelectorContext] { return getRuleContexts(SelectorContext.self) }
        open func selector(_ i: Int) -> SelectorContext? {
            return getRuleContext(SelectorContext.self, i)
        }
        open func COLON() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COLON.rawValue)
        }
        open func COLON(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_selectorName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSelectorName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSelectorName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSelectorName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSelectorName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func selectorName() throws -> SelectorNameContext {
        var _localctx: SelectorNameContext
        _localctx = SelectorNameContext(_ctx, getState())
        try enterRule(_localctx, 116, ObjectiveCParser.RULE_selectorName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(896)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 97, _ctx) {
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
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 142_143_763_999_949_952) != 0
                        || (Int64((_la - 81)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                    {
                        setState(888)
                        try selector()

                    }

                    setState(891)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)

                    setState(894)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 142_143_763_999_949_952) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 4_611_703_885_491_150_775) != 0

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

    public class ProtocolExpressionContext: ParserRuleContext {
        open func PROTOCOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROTOCOL.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func protocolName() -> ProtocolNameContext? {
            return getRuleContext(ProtocolNameContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_protocolExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolExpression() throws -> ProtocolExpressionContext {
        var _localctx: ProtocolExpressionContext
        _localctx = ProtocolExpressionContext(_ctx, getState())
        try enterRule(_localctx, 118, ObjectiveCParser.RULE_protocolExpression)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EncodeExpressionContext: ParserRuleContext {
        open func ENCODE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ENCODE.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_encodeExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEncodeExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEncodeExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEncodeExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEncodeExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func encodeExpression() throws -> EncodeExpressionContext {
        var _localctx: EncodeExpressionContext
        _localctx = EncodeExpressionContext(_ctx, getState())
        try enterRule(_localctx, 120, ObjectiveCParser.RULE_encodeExpression)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeVariableDeclaratorContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_typeVariableDeclarator
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeVariableDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeVariableDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeVariableDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeVariableDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeVariableDeclarator() throws -> TypeVariableDeclaratorContext {
        var _localctx: TypeVariableDeclaratorContext
        _localctx = TypeVariableDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 122, ObjectiveCParser.RULE_typeVariableDeclarator)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(908)
            try declarationSpecifiers()
            setState(909)
            try declarator()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ThrowStatementContext: ParserRuleContext {
        open func THROW() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.THROW.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_throwStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterThrowStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitThrowStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitThrowStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitThrowStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func throwStatement() throws -> ThrowStatementContext {
        var _localctx: ThrowStatementContext
        _localctx = ThrowStatementContext(_ctx, getState())
        try enterRule(_localctx, 124, ObjectiveCParser.RULE_throwStatement)
        defer { try! exitRule() }
        do {
            setState(918)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 98, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TryBlockContext: ParserRuleContext {
        open var tryStatement: CompoundStatementContext!
        open var finallyStatement: CompoundStatementContext!
        open func TRY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TRY.rawValue, 0)
        }
        open func compoundStatement() -> [CompoundStatementContext] {
            return getRuleContexts(CompoundStatementContext.self)
        }
        open func compoundStatement(_ i: Int) -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, i)
        }
        open func catchStatement() -> [CatchStatementContext] {
            return getRuleContexts(CatchStatementContext.self)
        }
        open func catchStatement(_ i: Int) -> CatchStatementContext? {
            return getRuleContext(CatchStatementContext.self, i)
        }
        open func FINALLY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FINALLY.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_tryBlock }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterTryBlock(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitTryBlock(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTryBlock(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTryBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func tryBlock() throws -> TryBlockContext {
        var _localctx: TryBlockContext
        _localctx = TryBlockContext(_ctx, getState())
        try enterRule(_localctx, 126, ObjectiveCParser.RULE_tryBlock)
        var _la: Int = 0
        defer { try! exitRule() }
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
            while _la == ObjectiveCParser.Tokens.CATCH.rawValue {
                setState(922)
                try catchStatement()

                setState(927)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(930)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.FINALLY.rawValue {
                setState(928)
                try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
                setState(929)
                try {
                    let assignmentValue = try compoundStatement()
                    _localctx.castdown(TryBlockContext.self).finallyStatement = assignmentValue
                }()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CatchStatementContext: ParserRuleContext {
        open func CATCH() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CATCH.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
            return getRuleContext(TypeVariableDeclaratorContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_catchStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterCatchStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitCatchStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitCatchStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitCatchStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func catchStatement() throws -> CatchStatementContext {
        var _localctx: CatchStatementContext
        _localctx = CatchStatementContext(_ctx, getState())
        try enterRule(_localctx, 128, ObjectiveCParser.RULE_catchStatement)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SynchronizedStatementContext: ParserRuleContext {
        open func SYNCHRONIZED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_synchronizedStatement
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSynchronizedStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSynchronizedStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSynchronizedStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSynchronizedStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func synchronizedStatement() throws -> SynchronizedStatementContext {
        var _localctx: SynchronizedStatementContext
        _localctx = SynchronizedStatementContext(_ctx, getState())
        try enterRule(_localctx, 130, ObjectiveCParser.RULE_synchronizedStatement)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AutoreleaseStatementContext: ParserRuleContext {
        open func AUTORELEASEPOOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue, 0)
        }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_autoreleaseStatement
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAutoreleaseStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAutoreleaseStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAutoreleaseStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAutoreleaseStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func autoreleaseStatement() throws -> AutoreleaseStatementContext {
        var _localctx: AutoreleaseStatementContext
        _localctx = AutoreleaseStatementContext(_ctx, getState())
        try enterRule(_localctx, 132, ObjectiveCParser.RULE_autoreleaseStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(944)
            try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
            setState(945)
            try compoundStatement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionDeclarationContext: ParserRuleContext {
        open func functionSignature() -> FunctionSignatureContext? {
            return getRuleContext(FunctionSignatureContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_functionDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionDeclaration() throws -> FunctionDeclarationContext {
        var _localctx: FunctionDeclarationContext
        _localctx = FunctionDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 134, ObjectiveCParser.RULE_functionDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(947)
            try functionSignature()
            setState(948)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionDefinitionContext: ParserRuleContext {
        open func functionSignature() -> FunctionSignatureContext? {
            return getRuleContext(FunctionSignatureContext.self, 0)
        }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_functionDefinition }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionDefinition(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionDefinition(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionDefinition(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionDefinition(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionDefinition() throws -> FunctionDefinitionContext {
        var _localctx: FunctionDefinitionContext
        _localctx = FunctionDefinitionContext(_ctx, getState())
        try enterRule(_localctx, 136, ObjectiveCParser.RULE_functionDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(950)
            try functionSignature()
            setState(951)
            try compoundStatement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionSignatureContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func attributeSpecifier() -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, 0)
        }
        open func parameterList() -> ParameterListContext? {
            return getRuleContext(ParameterListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_functionSignature }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionSignature(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionSignature(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionSignature(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionSignature(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionSignature() throws -> FunctionSignatureContext {
        var _localctx: FunctionSignatureContext
        _localctx = FunctionSignatureContext(_ctx, getState())
        try enterRule(_localctx, 138, ObjectiveCParser.RULE_functionSignature)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(954)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 101, _ctx) {
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_951_359) != 0
            {
                setState(958)
                try parameterList()

            }

            setState(961)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

            setState(964)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(963)
                try attributeSpecifier()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AttributeContext: ParserRuleContext {
        open func attributeName() -> AttributeNameContext? {
            return getRuleContext(AttributeNameContext.self, 0)
        }
        open func attributeParameters() -> AttributeParametersContext? {
            return getRuleContext(AttributeParametersContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_attribute }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttribute(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitAttribute(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttribute(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttribute(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attribute() throws -> AttributeContext {
        var _localctx: AttributeContext
        _localctx = AttributeContext(_ctx, getState())
        try enterRule(_localctx, 140, ObjectiveCParser.RULE_attribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(966)
            try attributeName()
            setState(968)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(967)
                try attributeParameters()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AttributeNameContext: ParserRuleContext {
        open func CONST() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONST.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_attributeName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeName() throws -> AttributeNameContext {
        var _localctx: AttributeNameContext
        _localctx = AttributeNameContext(_ctx, getState())
        try enterRule(_localctx, 142, ObjectiveCParser.RULE_attributeName)
        defer { try! exitRule() }
        do {
            setState(972)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(970)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .KINDOF, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE,
                .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG,
                .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(971)
                try identifier()

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

    public class AttributeParametersContext: ParserRuleContext {
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func attributeParameterList() -> AttributeParameterListContext? {
            return getRuleContext(AttributeParameterListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_attributeParameters
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeParameters(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeParameters(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeParameters(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeParameters(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeParameters() throws -> AttributeParametersContext {
        var _localctx: AttributeParametersContext
        _localctx = AttributeParametersContext(_ctx, getState())
        try enterRule(_localctx, 144, ObjectiveCParser.RULE_attributeParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(974)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(976)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 288_230_101_273_804_832) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                || (Int64((_la - 152)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 152)) & 66_584_579) != 0
            {
                setState(975)
                try attributeParameterList()

            }

            setState(978)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AttributeParameterListContext: ParserRuleContext {
        open func attributeParameter() -> [AttributeParameterContext] {
            return getRuleContexts(AttributeParameterContext.self)
        }
        open func attributeParameter(_ i: Int) -> AttributeParameterContext? {
            return getRuleContext(AttributeParameterContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_attributeParameterList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeParameterList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeParameterList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeParameterList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeParameterList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeParameterList() throws -> AttributeParameterListContext {
        var _localctx: AttributeParameterListContext
        _localctx = AttributeParameterListContext(_ctx, getState())
        try enterRule(_localctx, 146, ObjectiveCParser.RULE_attributeParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(980)
            try attributeParameter()
            setState(985)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(981)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(982)
                try attributeParameter()

                setState(987)
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

    public class AttributeParameterContext: ParserRuleContext {
        open func attribute() -> AttributeContext? {
            return getRuleContext(AttributeContext.self, 0)
        }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        open func stringLiteral() -> StringLiteralContext? {
            return getRuleContext(StringLiteralContext.self, 0)
        }
        open func attributeParameterAssignment() -> AttributeParameterAssignmentContext? {
            return getRuleContext(AttributeParameterAssignmentContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_attributeParameter }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeParameter(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeParameter(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeParameter(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeParameter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeParameter() throws -> AttributeParameterContext {
        var _localctx: AttributeParameterContext
        _localctx = AttributeParameterContext(_ctx, getState())
        try enterRule(_localctx, 148, ObjectiveCParser.RULE_attributeParameter)
        defer { try! exitRule() }
        do {
            setState(992)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 108, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AttributeParameterAssignmentContext: ParserRuleContext {
        open func attributeName() -> [AttributeNameContext] {
            return getRuleContexts(AttributeNameContext.self)
        }
        open func attributeName(_ i: Int) -> AttributeNameContext? {
            return getRuleContext(AttributeNameContext.self, i)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        open func stringLiteral() -> StringLiteralContext? {
            return getRuleContext(StringLiteralContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_attributeParameterAssignment
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeParameterAssignment(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeParameterAssignment(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeParameterAssignment(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeParameterAssignment(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeParameterAssignment() throws
        -> AttributeParameterAssignmentContext
    {
        var _localctx: AttributeParameterAssignmentContext
        _localctx = AttributeParameterAssignmentContext(_ctx, getState())
        try enterRule(_localctx, 150, ObjectiveCParser.RULE_attributeParameterAssignment)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(994)
            try attributeName()
            setState(995)
            try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
            setState(999)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                setState(996)
                try constant()

                break
            case .CONST, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                .CONTRAVARIANT, .DEPRECATED, .KINDOF, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE,
                .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                setState(997)
                try attributeName()

                break

            case .STRING_START:
                setState(998)
                try stringLiteral()

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
        open func functionCallExpression() -> FunctionCallExpressionContext? {
            return getRuleContext(FunctionCallExpressionContext.self, 0)
        }
        open func functionPointer() -> FunctionPointerContext? {
            return getRuleContext(FunctionPointerContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func enumDeclaration() -> EnumDeclarationContext? {
            return getRuleContext(EnumDeclarationContext.self, 0)
        }
        open func varDeclaration() -> VarDeclarationContext? {
            return getRuleContext(VarDeclarationContext.self, 0)
        }
        open func typedefDeclaration() -> TypedefDeclarationContext? {
            return getRuleContext(TypedefDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_declaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declaration() throws -> DeclarationContext {
        var _localctx: DeclarationContext
        _localctx = DeclarationContext(_ctx, getState())
        try enterRule(_localctx, 152, ObjectiveCParser.RULE_declaration)
        defer { try! exitRule() }
        do {
            setState(1008)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 110, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionPointerContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func LP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.LP.rawValue) }
        open func LP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
        }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func RP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.RP.rawValue) }
        open func RP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func functionPointerParameterList() -> FunctionPointerParameterListContext? {
            return getRuleContext(FunctionPointerParameterListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_functionPointer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionPointer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionPointer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionPointer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionPointer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionPointer() throws -> FunctionPointerContext {
        var _localctx: FunctionPointerContext
        _localctx = FunctionPointerContext(_ctx, getState())
        try enterRule(_localctx, 154, ObjectiveCParser.RULE_functionPointer)
        var _la: Int = 0
        defer { try! exitRule() }
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_951_359) != 0
            {
                setState(1018)
                try functionPointerParameterList()

            }

            setState(1021)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionPointerParameterListContext: ParserRuleContext {
        open func functionPointerParameterDeclarationList()
            -> FunctionPointerParameterDeclarationListContext?
        { return getRuleContext(FunctionPointerParameterDeclarationListContext.self, 0) }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func ELIPSIS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_functionPointerParameterList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionPointerParameterList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionPointerParameterList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionPointerParameterList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionPointerParameterList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionPointerParameterList() throws
        -> FunctionPointerParameterListContext
    {
        var _localctx: FunctionPointerParameterListContext
        _localctx = FunctionPointerParameterListContext(_ctx, getState())
        try enterRule(_localctx, 156, ObjectiveCParser.RULE_functionPointerParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1023)
            try functionPointerParameterDeclarationList()
            setState(1026)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1024)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1025)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionPointerParameterDeclarationListContext: ParserRuleContext {
        open func functionPointerParameterDeclaration()
            -> [FunctionPointerParameterDeclarationContext]
        { return getRuleContexts(FunctionPointerParameterDeclarationContext.self) }
        open func functionPointerParameterDeclaration(_ i: Int)
            -> FunctionPointerParameterDeclarationContext?
        { return getRuleContext(FunctionPointerParameterDeclarationContext.self, i) }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_functionPointerParameterDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionPointerParameterDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionPointerParameterDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionPointerParameterDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionPointerParameterDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionPointerParameterDeclarationList() throws
        -> FunctionPointerParameterDeclarationListContext
    {
        var _localctx: FunctionPointerParameterDeclarationListContext
        _localctx = FunctionPointerParameterDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 158, ObjectiveCParser.RULE_functionPointerParameterDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1028)
            try functionPointerParameterDeclaration()
            setState(1033)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 114, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1029)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1030)
                    try functionPointerParameterDeclaration()

                }
                setState(1035)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 114, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionPointerParameterDeclarationContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func functionPointer() -> FunctionPointerContext? {
            return getRuleContext(FunctionPointerContext.self, 0)
        }
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func VOID() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_functionPointerParameterDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionPointerParameterDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionPointerParameterDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionPointerParameterDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionPointerParameterDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionPointerParameterDeclaration() throws
        -> FunctionPointerParameterDeclarationContext
    {
        var _localctx: FunctionPointerParameterDeclarationContext
        _localctx = FunctionPointerParameterDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 160, ObjectiveCParser.RULE_functionPointerParameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1044)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 117, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1038)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 115, _ctx) {
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
                if (Int64((_la - 40)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 40)) & -414_491_694_415_611_649) != 0
                    || (Int64((_la - 104)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 104)) & 1_125_899_913_166_847) != 0
                {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionCallExpressionContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func directDeclarator() -> DirectDeclaratorContext? {
            return getRuleContext(DirectDeclaratorContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func attributeSpecifier() -> [AttributeSpecifierContext] {
            return getRuleContexts(AttributeSpecifierContext.self)
        }
        open func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_functionCallExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionCallExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionCallExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionCallExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionCallExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionCallExpression() throws -> FunctionCallExpressionContext {
        var _localctx: FunctionCallExpressionContext
        _localctx = FunctionCallExpressionContext(_ctx, getState())
        try enterRule(_localctx, 162, ObjectiveCParser.RULE_functionCallExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1047)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1046)
                try attributeSpecifier()

            }

            setState(1049)
            try identifier()
            setState(1051)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EnumDeclarationContext: ParserRuleContext {
        open func enumSpecifier() -> EnumSpecifierContext? {
            return getRuleContext(EnumSpecifierContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func attributeSpecifier() -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, 0)
        }
        open func TYPEDEF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEDEF.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_enumDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEnumDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEnumDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEnumDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEnumDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func enumDeclaration() throws -> EnumDeclarationContext {
        var _localctx: EnumDeclarationContext
        _localctx = EnumDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 164, ObjectiveCParser.RULE_enumDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1059)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1058)
                try attributeSpecifier()

            }

            setState(1062)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.TYPEDEF.rawValue {
                setState(1061)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)

            }

            setState(1064)
            try enumSpecifier()
            setState(1066)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
            {
                setState(1065)
                try identifier()

            }

            setState(1068)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VarDeclarationContext: ParserRuleContext {
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func initDeclaratorList() -> InitDeclaratorListContext? {
            return getRuleContext(InitDeclaratorListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_varDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterVarDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitVarDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitVarDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitVarDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func varDeclaration() throws -> VarDeclarationContext {
        var _localctx: VarDeclarationContext
        _localctx = VarDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 166, ObjectiveCParser.RULE_varDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1074)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 123, _ctx) {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypedefDeclarationContext: ParserRuleContext {
        open func TYPEDEF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEDEF.rawValue, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func typeDeclaratorList() -> TypeDeclaratorListContext? {
            return getRuleContext(TypeDeclaratorListContext.self, 0)
        }
        open func attributeSpecifier() -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, 0)
        }
        open func macro() -> MacroContext? { return getRuleContext(MacroContext.self, 0) }
        open func functionPointer() -> FunctionPointerContext? {
            return getRuleContext(FunctionPointerContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typedefDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypedefDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypedefDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypedefDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypedefDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typedefDeclaration() throws -> TypedefDeclarationContext {
        var _localctx: TypedefDeclarationContext
        _localctx = TypedefDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 168, ObjectiveCParser.RULE_typedefDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1100)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 128, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1079)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1078)
                    try attributeSpecifier()

                }

                setState(1081)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1086)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 125, _ctx) {
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
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                {
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
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeDeclaratorListContext: ParserRuleContext {
        open func declarator() -> [DeclaratorContext] {
            return getRuleContexts(DeclaratorContext.self)
        }
        open func declarator(_ i: Int) -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeDeclaratorList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeDeclaratorList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeDeclaratorList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeDeclaratorList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeDeclaratorList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeDeclaratorList() throws -> TypeDeclaratorListContext {
        var _localctx: TypeDeclaratorListContext
        _localctx = TypeDeclaratorListContext(_ctx, getState())
        try enterRule(_localctx, 170, ObjectiveCParser.RULE_typeDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1102)
            try declarator()
            setState(1107)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1103)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1104)
                try declarator()

                setState(1109)
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

    public class DeclarationSpecifiersContext: ParserRuleContext {
        open func storageClassSpecifier() -> [StorageClassSpecifierContext] {
            return getRuleContexts(StorageClassSpecifierContext.self)
        }
        open func storageClassSpecifier(_ i: Int) -> StorageClassSpecifierContext? {
            return getRuleContext(StorageClassSpecifierContext.self, i)
        }
        open func attributeSpecifier() -> [AttributeSpecifierContext] {
            return getRuleContexts(AttributeSpecifierContext.self)
        }
        open func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, i)
        }
        open func arcBehaviourSpecifier() -> [ArcBehaviourSpecifierContext] {
            return getRuleContexts(ArcBehaviourSpecifierContext.self)
        }
        open func arcBehaviourSpecifier(_ i: Int) -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, i)
        }
        open func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
            return getRuleContexts(NullabilitySpecifierContext.self)
        }
        open func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, i)
        }
        open func ibOutletQualifier() -> [IbOutletQualifierContext] {
            return getRuleContexts(IbOutletQualifierContext.self)
        }
        open func ibOutletQualifier(_ i: Int) -> IbOutletQualifierContext? {
            return getRuleContext(IbOutletQualifierContext.self, i)
        }
        open func typePrefix() -> [TypePrefixContext] {
            return getRuleContexts(TypePrefixContext.self)
        }
        open func typePrefix(_ i: Int) -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, i)
        }
        open func typeQualifier() -> [TypeQualifierContext] {
            return getRuleContexts(TypeQualifierContext.self)
        }
        open func typeQualifier(_ i: Int) -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, i)
        }
        open func typeSpecifier() -> [TypeSpecifierContext] {
            return getRuleContexts(TypeSpecifierContext.self)
        }
        open func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_declarationSpecifiers
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationSpecifiers(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationSpecifiers(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationSpecifiers(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationSpecifiers(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationSpecifiers() throws -> DeclarationSpecifiersContext {
        var _localctx: DeclarationSpecifiersContext
        _localctx = DeclarationSpecifiersContext(_ctx, getState())
        try enterRule(_localctx, 172, ObjectiveCParser.RULE_declarationSpecifiers)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1118)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1118)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 130, _ctx) {
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1120)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 131, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AttributeSpecifierContext: ParserRuleContext {
        open func ATTRIBUTE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue, 0)
        }
        open func LP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.LP.rawValue) }
        open func LP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
        }
        open func attribute() -> [AttributeContext] {
            return getRuleContexts(AttributeContext.self)
        }
        open func attribute(_ i: Int) -> AttributeContext? {
            return getRuleContext(AttributeContext.self, i)
        }
        open func RP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.RP.rawValue) }
        open func RP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_attributeSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAttributeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAttributeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAttributeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAttributeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func attributeSpecifier() throws -> AttributeSpecifierContext {
        var _localctx: AttributeSpecifierContext
        _localctx = AttributeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 174, ObjectiveCParser.RULE_attributeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
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
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class InitDeclaratorListContext: ParserRuleContext {
        open func initDeclarator() -> [InitDeclaratorContext] {
            return getRuleContexts(InitDeclaratorContext.self)
        }
        open func initDeclarator(_ i: Int) -> InitDeclaratorContext? {
            return getRuleContext(InitDeclaratorContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_initDeclaratorList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInitDeclaratorList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInitDeclaratorList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInitDeclaratorList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInitDeclaratorList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func initDeclaratorList() throws -> InitDeclaratorListContext {
        var _localctx: InitDeclaratorListContext
        _localctx = InitDeclaratorListContext(_ctx, getState())
        try enterRule(_localctx, 176, ObjectiveCParser.RULE_initDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1136)
            try initDeclarator()
            setState(1141)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1137)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1138)
                try initDeclarator()

                setState(1143)
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

    public class InitDeclaratorContext: ParserRuleContext {
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func initializer() -> InitializerContext? {
            return getRuleContext(InitializerContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_initDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInitDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInitDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInitDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInitDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func initDeclarator() throws -> InitDeclaratorContext {
        var _localctx: InitDeclaratorContext
        _localctx = InitDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 178, ObjectiveCParser.RULE_initDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1144)
            try declarator()
            setState(1147)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1145)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1146)
                try initializer()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructOrUnionSpecifierContext: ParserRuleContext {
        open func STRUCT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRUCT.rawValue, 0)
        }
        open func UNION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNION.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func attributeSpecifier() -> [AttributeSpecifierContext] {
            return getRuleContexts(AttributeSpecifierContext.self)
        }
        open func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, i)
        }
        open func fieldDeclaration() -> [FieldDeclarationContext] {
            return getRuleContexts(FieldDeclarationContext.self)
        }
        open func fieldDeclaration(_ i: Int) -> FieldDeclarationContext? {
            return getRuleContext(FieldDeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_structOrUnionSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructOrUnionSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructOrUnionSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructOrUnionSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructOrUnionSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structOrUnionSpecifier() throws -> StructOrUnionSpecifierContext {
        var _localctx: StructOrUnionSpecifierContext
        _localctx = StructOrUnionSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 180, ObjectiveCParser.RULE_structOrUnionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1149)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.STRUCT.rawValue
                || _la == ObjectiveCParser.Tokens.UNION.rawValue)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1153)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1150)
                try attributeSpecifier()

                setState(1155)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1168)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 138, _ctx) {
            case 1:
                setState(1156)
                try identifier()

                break
            case 2:
                setState(1158)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                {
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

                    setState(1164)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_951_359) != 0
                setState(1166)
                try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

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

    public class FieldDeclarationContext: ParserRuleContext {
        open func specifierQualifierList() -> SpecifierQualifierListContext? {
            return getRuleContext(SpecifierQualifierListContext.self, 0)
        }
        open func fieldDeclaratorList() -> FieldDeclaratorListContext? {
            return getRuleContext(FieldDeclaratorListContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func macro() -> MacroContext? { return getRuleContext(MacroContext.self, 0) }
        open func functionPointer() -> FunctionPointerContext? {
            return getRuleContext(FunctionPointerContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_fieldDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFieldDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFieldDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFieldDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFieldDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func fieldDeclaration() throws -> FieldDeclarationContext {
        var _localctx: FieldDeclarationContext
        _localctx = FieldDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 182, ObjectiveCParser.RULE_fieldDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1180)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 140, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1170)
                try specifierQualifierList()
                setState(1171)
                try fieldDeclaratorList()
                setState(1173)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SpecifierQualifierListContext: ParserRuleContext {
        open func arcBehaviourSpecifier() -> [ArcBehaviourSpecifierContext] {
            return getRuleContexts(ArcBehaviourSpecifierContext.self)
        }
        open func arcBehaviourSpecifier(_ i: Int) -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, i)
        }
        open func nullabilitySpecifier() -> [NullabilitySpecifierContext] {
            return getRuleContexts(NullabilitySpecifierContext.self)
        }
        open func nullabilitySpecifier(_ i: Int) -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, i)
        }
        open func ibOutletQualifier() -> [IbOutletQualifierContext] {
            return getRuleContexts(IbOutletQualifierContext.self)
        }
        open func ibOutletQualifier(_ i: Int) -> IbOutletQualifierContext? {
            return getRuleContext(IbOutletQualifierContext.self, i)
        }
        open func typePrefix() -> [TypePrefixContext] {
            return getRuleContexts(TypePrefixContext.self)
        }
        open func typePrefix(_ i: Int) -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, i)
        }
        open func typeQualifier() -> [TypeQualifierContext] {
            return getRuleContexts(TypeQualifierContext.self)
        }
        open func typeQualifier(_ i: Int) -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, i)
        }
        open func typeSpecifier() -> [TypeSpecifierContext] {
            return getRuleContexts(TypeSpecifierContext.self)
        }
        open func typeSpecifier(_ i: Int) -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_specifierQualifierList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSpecifierQualifierList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSpecifierQualifierList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSpecifierQualifierList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSpecifierQualifierList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func specifierQualifierList() throws -> SpecifierQualifierListContext {
        var _localctx: SpecifierQualifierListContext
        _localctx = SpecifierQualifierListContext(_ctx, getState())
        try enterRule(_localctx, 184, ObjectiveCParser.RULE_specifierQualifierList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1188)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1188)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 141, _ctx) {
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1190)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 142, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IbOutletQualifierContext: ParserRuleContext {
        open func IB_OUTLET_COLLECTION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func IB_OUTLET() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_OUTLET.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_ibOutletQualifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterIbOutletQualifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitIbOutletQualifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitIbOutletQualifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitIbOutletQualifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func ibOutletQualifier() throws -> IbOutletQualifierContext {
        var _localctx: IbOutletQualifierContext
        _localctx = IbOutletQualifierContext(_ctx, getState())
        try enterRule(_localctx, 186, ObjectiveCParser.RULE_ibOutletQualifier)
        defer { try! exitRule() }
        do {
            setState(1198)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArcBehaviourSpecifierContext: ParserRuleContext {
        open func WEAK_QUALIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WEAK_QUALIFIER.rawValue, 0)
        }
        open func STRONG_QUALIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRONG_QUALIFIER.rawValue, 0)
        }
        open func AUTORELEASING_QUALIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue, 0)
        }
        open func UNSAFE_UNRETAINED_QUALIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED_QUALIFIER.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_arcBehaviourSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterArcBehaviourSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitArcBehaviourSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitArcBehaviourSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitArcBehaviourSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arcBehaviourSpecifier() throws -> ArcBehaviourSpecifierContext {
        var _localctx: ArcBehaviourSpecifierContext
        _localctx = ArcBehaviourSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 188, ObjectiveCParser.RULE_arcBehaviourSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1200)
            _la = try _input.LA(1)
            if !((Int64((_la - 85)) & ~0x3f) == 0 && ((Int64(1) << (_la - 85)) & 10753) != 0) {
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

    public class NullabilitySpecifierContext: ParserRuleContext {
        open func NULL_UNSPECIFIED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue, 0)
        }
        open func NULLABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULLABLE.rawValue, 0)
        }
        open func NONNULL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NONNULL.rawValue, 0)
        }
        open func NULL_RESETTABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_nullabilitySpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterNullabilitySpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitNullabilitySpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitNullabilitySpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitNullabilitySpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func nullabilitySpecifier() throws -> NullabilitySpecifierContext {
        var _localctx: NullabilitySpecifierContext
        _localctx = NullabilitySpecifierContext(_ctx, getState())
        try enterRule(_localctx, 190, ObjectiveCParser.RULE_nullabilitySpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1202)
            _la = try _input.LA(1)
            if !((Int64((_la - 99)) & ~0x3f) == 0 && ((Int64(1) << (_la - 99)) & 15) != 0) {
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

    public class StorageClassSpecifierContext: ParserRuleContext {
        open func AUTO() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AUTO.rawValue, 0)
        }
        open func REGISTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.REGISTER.rawValue, 0)
        }
        open func STATIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STATIC.rawValue, 0)
        }
        open func EXTERN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EXTERN.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_storageClassSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStorageClassSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStorageClassSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStorageClassSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStorageClassSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func storageClassSpecifier() throws -> StorageClassSpecifierContext {
        var _localctx: StorageClassSpecifierContext
        _localctx = StorageClassSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 192, ObjectiveCParser.RULE_storageClassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1204)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 68_161_538) != 0) {
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

    public class TypePrefixContext: ParserRuleContext {
        open func BRIDGE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BRIDGE.rawValue, 0)
        }
        open func BRIDGE_TRANSFER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue, 0)
        }
        open func BRIDGE_RETAINED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue, 0)
        }
        open func BLOCK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BLOCK.rawValue, 0)
        }
        open func INLINE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INLINE.rawValue, 0)
        }
        open func NS_INLINE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_INLINE.rawValue, 0)
        }
        open func KINDOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typePrefix }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypePrefix(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypePrefix(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypePrefix(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypePrefix(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typePrefix() throws -> TypePrefixContext {
        var _localctx: TypePrefixContext
        _localctx = TypePrefixContext(_ctx, getState())
        try enterRule(_localctx, 194, ObjectiveCParser.RULE_typePrefix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1206)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.INLINE.rawValue
                || (Int64((_la - 86)) & ~0x3f) == 0 && ((Int64(1) << (_la - 86)) & 131215) != 0)
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

    public class TypeQualifierContext: ParserRuleContext {
        open func CONST() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONST.rawValue, 0)
        }
        open func VOLATILE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VOLATILE.rawValue, 0)
        }
        open func RESTRICT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RESTRICT.rawValue, 0)
        }
        open func protocolQualifier() -> ProtocolQualifierContext? {
            return getRuleContext(ProtocolQualifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeQualifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeQualifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeQualifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeQualifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeQualifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeQualifier() throws -> TypeQualifierContext {
        var _localctx: TypeQualifierContext
        _localctx = TypeQualifierContext(_ctx, getState())
        try enterRule(_localctx, 196, ObjectiveCParser.RULE_typeQualifier)
        defer { try! exitRule() }
        do {
            setState(1212)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
            case .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT:
                try enterOuterAlt(_localctx, 4)
                setState(1211)
                try protocolQualifier()

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

    public class ProtocolQualifierContext: ParserRuleContext {
        open func IN() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0) }
        open func OUT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OUT.rawValue, 0)
        }
        open func INOUT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INOUT.rawValue, 0)
        }
        open func BYCOPY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BYCOPY.rawValue, 0)
        }
        open func BYREF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BYREF.rawValue, 0)
        }
        open func ONEWAY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ONEWAY.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_protocolQualifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterProtocolQualifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitProtocolQualifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitProtocolQualifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitProtocolQualifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func protocolQualifier() throws -> ProtocolQualifierContext {
        var _localctx: ProtocolQualifierContext
        _localctx = ProtocolQualifierContext(_ctx, getState())
        try enterRule(_localctx, 198, ObjectiveCParser.RULE_protocolQualifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1214)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 6_979_699_813_122_048) != 0) {
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

    public class TypeSpecifierContext: ParserRuleContext {
        open func scalarTypeSpecifier() -> ScalarTypeSpecifierContext? {
            return getRuleContext(ScalarTypeSpecifierContext.self, 0)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        open func typeofExpression() -> TypeofExpressionContext? {
            return getRuleContext(TypeofExpressionContext.self, 0)
        }
        open func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
            return getRuleContext(GenericTypeSpecifierContext.self, 0)
        }
        open func KINDOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
        }
        open func structOrUnionSpecifier() -> StructOrUnionSpecifierContext? {
            return getRuleContext(StructOrUnionSpecifierContext.self, 0)
        }
        open func enumSpecifier() -> EnumSpecifierContext? {
            return getRuleContext(EnumSpecifierContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeSpecifier() throws -> TypeSpecifierContext {
        var _localctx: TypeSpecifierContext
        _localctx = TypeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 200, ObjectiveCParser.RULE_typeSpecifier)
        defer { try! exitRule() }
        do {
            setState(1240)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 151, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1216)
                try scalarTypeSpecifier()
                setState(1218)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 145, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 146, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 147, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 148, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 149, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 150, _ctx) {
                case 1:
                    setState(1237)
                    try pointer()

                    break
                default: break
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

    public class ScalarTypeSpecifierContext: ParserRuleContext {
        open func VOID() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
        }
        open func CHAR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CHAR.rawValue, 0)
        }
        open func SHORT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SHORT.rawValue, 0)
        }
        open func INT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INT.rawValue, 0)
        }
        open func LONG() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LONG.rawValue, 0)
        }
        open func FLOAT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FLOAT.rawValue, 0)
        }
        open func DOUBLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DOUBLE.rawValue, 0)
        }
        open func SIGNED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SIGNED.rawValue, 0)
        }
        open func UNSIGNED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNSIGNED.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_scalarTypeSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterScalarTypeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitScalarTypeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitScalarTypeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitScalarTypeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func scalarTypeSpecifier() throws -> ScalarTypeSpecifierContext {
        var _localctx: ScalarTypeSpecifierContext
        _localctx = ScalarTypeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 202, ObjectiveCParser.RULE_scalarTypeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1242)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 6_468_411_920) != 0) {
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

    public class TypeofExpressionContext: ParserRuleContext {
        open func TYPEOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEOF.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeofExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeofExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeofExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeofExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeofExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeofExpression() throws -> TypeofExpressionContext {
        var _localctx: TypeofExpressionContext
        _localctx = TypeofExpressionContext(_ctx, getState())
        try enterRule(_localctx, 204, ObjectiveCParser.RULE_typeofExpression)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FieldDeclaratorListContext: ParserRuleContext {
        open func fieldDeclarator() -> [FieldDeclaratorContext] {
            return getRuleContexts(FieldDeclaratorContext.self)
        }
        open func fieldDeclarator(_ i: Int) -> FieldDeclaratorContext? {
            return getRuleContext(FieldDeclaratorContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_fieldDeclaratorList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFieldDeclaratorList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFieldDeclaratorList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFieldDeclaratorList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFieldDeclaratorList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func fieldDeclaratorList() throws -> FieldDeclaratorListContext {
        var _localctx: FieldDeclaratorListContext
        _localctx = FieldDeclaratorListContext(_ctx, getState())
        try enterRule(_localctx, 206, ObjectiveCParser.RULE_fieldDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1249)
            try fieldDeclarator()
            setState(1254)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1250)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1251)
                try fieldDeclarator()

                setState(1256)
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

    public class FieldDeclaratorContext: ParserRuleContext {
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_fieldDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFieldDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFieldDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFieldDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFieldDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func fieldDeclarator() throws -> FieldDeclaratorContext {
        var _localctx: FieldDeclaratorContext
        _localctx = FieldDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 208, ObjectiveCParser.RULE_fieldDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1263)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 154, _ctx) {
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
                if (Int64((_la - 40)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 40)) & -414_491_694_415_611_649) != 0
                    || (Int64((_la - 104)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 104)) & 1_125_899_913_166_847) != 0
                {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EnumSpecifierContext: ParserRuleContext {
        open func ENUM() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ENUM.rawValue, 0)
        }
        open func identifier() -> [IdentifierContext] {
            return getRuleContexts(IdentifierContext.self)
        }
        open func identifier(_ i: Int) -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, i)
        }
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func enumeratorList() -> EnumeratorListContext? {
            return getRuleContext(EnumeratorListContext.self, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func NS_OPTIONS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_OPTIONS.rawValue, 0)
        }
        open func NS_ENUM() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_ENUM.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_enumSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEnumSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEnumSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEnumSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEnumSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func enumSpecifier() throws -> EnumSpecifierContext {
        var _localctx: EnumSpecifierContext
        _localctx = EnumSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 210, ObjectiveCParser.RULE_enumSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1296)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ENUM:
                try enterOuterAlt(_localctx, 1)
                setState(1265)
                try match(ObjectiveCParser.Tokens.ENUM.rawValue)
                setState(1271)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 156, _ctx) {
                case 1:
                    setState(1267)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                        || (Int64((_la - 81)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                    {
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
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                    .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .UNUSED, .NULL_UNSPECIFIED,
                    .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS,
                    .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK,
                    .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
                    setState(1273)
                    try identifier()
                    setState(1278)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 157, _ctx) {
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            case .NS_ENUM, .NS_OPTIONS:
                try enterOuterAlt(_localctx, 2)
                setState(1286)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.NS_ENUM.rawValue
                    || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EnumeratorListContext: ParserRuleContext {
        open func enumerator() -> [EnumeratorContext] {
            return getRuleContexts(EnumeratorContext.self)
        }
        open func enumerator(_ i: Int) -> EnumeratorContext? {
            return getRuleContext(EnumeratorContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_enumeratorList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEnumeratorList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEnumeratorList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEnumeratorList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEnumeratorList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func enumeratorList() throws -> EnumeratorListContext {
        var _localctx: EnumeratorListContext
        _localctx = EnumeratorListContext(_ctx, getState())
        try enterRule(_localctx, 212, ObjectiveCParser.RULE_enumeratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1298)
            try enumerator()
            setState(1303)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 160, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1299)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1300)
                    try enumerator()

                }
                setState(1305)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 160, _ctx)
            }
            setState(1307)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1306)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EnumeratorContext: ParserRuleContext {
        open func enumeratorIdentifier() -> EnumeratorIdentifierContext? {
            return getRuleContext(EnumeratorIdentifierContext.self, 0)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_enumerator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEnumerator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEnumerator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEnumerator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEnumerator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func enumerator() throws -> EnumeratorContext {
        var _localctx: EnumeratorContext
        _localctx = EnumeratorContext(_ctx, getState())
        try enterRule(_localctx, 214, ObjectiveCParser.RULE_enumerator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1309)
            try enumeratorIdentifier()
            setState(1312)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1310)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1311)
                try expression(0)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class EnumeratorIdentifierContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_enumeratorIdentifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEnumeratorIdentifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEnumeratorIdentifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEnumeratorIdentifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEnumeratorIdentifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func enumeratorIdentifier() throws -> EnumeratorIdentifierContext {
        var _localctx: EnumeratorIdentifierContext
        _localctx = EnumeratorIdentifierContext(_ctx, getState())
        try enterRule(_localctx, 216, ObjectiveCParser.RULE_enumeratorIdentifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1314)
            try identifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DirectDeclaratorContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func declaratorSuffix() -> [DeclaratorSuffixContext] {
            return getRuleContexts(DeclaratorSuffixContext.self)
        }
        open func declaratorSuffix(_ i: Int) -> DeclaratorSuffixContext? {
            return getRuleContext(DeclaratorSuffixContext.self, i)
        }
        open func attributeSpecifier() -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, 0)
        }
        open func BITXOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
        }
        open func blockParameters() -> BlockParametersContext? {
            return getRuleContext(BlockParametersContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_directDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDirectDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDirectDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDirectDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDirectDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func directDeclarator() throws -> DirectDeclaratorContext {
        var _localctx: DirectDeclaratorContext
        _localctx = DirectDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 218, ObjectiveCParser.RULE_directDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1352)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 170, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1321)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                    .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .UNUSED, .NULL_UNSPECIFIED,
                    .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS,
                    .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK,
                    .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1326)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.LBRACK.rawValue {
                    setState(1323)
                    try declaratorSuffix()

                    setState(1328)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1330)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 165, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 166, _ctx) {
                case 1:
                    setState(1334)
                    try nullabilitySpecifier()

                    break
                default: break
                }
                setState(1338)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                {
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
                switch try getInterpreter().adaptivePredict(_input, 168, _ctx) {
                case 1:
                    setState(1344)
                    try nullabilitySpecifier()

                    break
                default: break
                }
                setState(1348)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclaratorSuffixContext: ParserRuleContext {
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_declaratorSuffix }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclaratorSuffix(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclaratorSuffix(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclaratorSuffix(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclaratorSuffix(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declaratorSuffix() throws -> DeclaratorSuffixContext {
        var _localctx: DeclaratorSuffixContext
        _localctx = DeclaratorSuffixContext(_ctx, getState())
        try enterRule(_localctx, 220, ObjectiveCParser.RULE_declaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1354)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(1356)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 288_230_101_273_804_800) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                || (Int64((_la - 152)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 152)) & 65_536_003) != 0
            {
                setState(1355)
                try constantExpression()

            }

            setState(1358)
            try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ParameterListContext: ParserRuleContext {
        open func parameterDeclarationList() -> ParameterDeclarationListContext? {
            return getRuleContext(ParameterDeclarationListContext.self, 0)
        }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func ELIPSIS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_parameterList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterParameterList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitParameterList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitParameterList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitParameterList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func parameterList() throws -> ParameterListContext {
        var _localctx: ParameterListContext
        _localctx = ParameterListContext(_ctx, getState())
        try enterRule(_localctx, 222, ObjectiveCParser.RULE_parameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1360)
            try parameterDeclarationList()
            setState(1363)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1361)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1362)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PointerContext: ParserRuleContext {
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_pointer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterPointer(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitPointer(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPointer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPointer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func pointer() throws -> PointerContext {
        var _localctx: PointerContext
        _localctx = PointerContext(_ctx, getState())
        try enterRule(_localctx, 224, ObjectiveCParser.RULE_pointer)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1365)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1367)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 173, _ctx) {
            case 1:
                setState(1366)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(1370)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 174, _ctx) {
            case 1:
                setState(1369)
                try pointer()

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

    public class MacroContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func primaryExpression() -> [PrimaryExpressionContext] {
            return getRuleContexts(PrimaryExpressionContext.self)
        }
        open func primaryExpression(_ i: Int) -> PrimaryExpressionContext? {
            return getRuleContext(PrimaryExpressionContext.self, i)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_macro }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterMacro(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitMacro(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMacro(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMacro(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func macro() throws -> MacroContext {
        var _localctx: MacroContext
        _localctx = MacroContext(_ctx, getState())
        try enterRule(_localctx, 226, ObjectiveCParser.RULE_macro)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1372)
            try identifier()
            setState(1384)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1373)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1374)
                try primaryExpression()
                setState(1379)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ArrayInitializerContext: ParserRuleContext {
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func expression() -> [ExpressionContext] {
            return getRuleContexts(ExpressionContext.self)
        }
        open func expression(_ i: Int) -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_arrayInitializer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterArrayInitializer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitArrayInitializer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitArrayInitializer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitArrayInitializer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func arrayInitializer() throws -> ArrayInitializerContext {
        var _localctx: ArrayInitializerContext
        _localctx = ArrayInitializerContext(_ctx, getState())
        try enterRule(_localctx, 228, ObjectiveCParser.RULE_arrayInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1386)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1398)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1387)
                try expression(0)
                setState(1392)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 177, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1388)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1389)
                        try expression(0)

                    }
                    setState(1394)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 177, _ctx)
                }
                setState(1396)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1395)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1400)
            try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructInitializerContext: ParserRuleContext {
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func structInitializerItem() -> [StructInitializerItemContext] {
            return getRuleContexts(StructInitializerItemContext.self)
        }
        open func structInitializerItem(_ i: Int) -> StructInitializerItemContext? {
            return getRuleContext(StructInitializerItemContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_structInitializer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructInitializer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructInitializer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructInitializer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructInitializer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structInitializer() throws -> StructInitializerContext {
        var _localctx: StructInitializerContext
        _localctx = StructInitializerContext(_ctx, getState())
        try enterRule(_localctx, 230, ObjectiveCParser.RULE_structInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1402)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1414)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue
                || _la == ObjectiveCParser.Tokens.DOT.rawValue
            {
                setState(1403)
                try structInitializerItem()
                setState(1408)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 180, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1404)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1405)
                        try structInitializerItem()

                    }
                    setState(1410)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 180, _ctx)
                }
                setState(1412)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1411)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1416)
            try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructInitializerItemContext: ParserRuleContext {
        open func DOT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DOT.rawValue, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func structInitializer() -> StructInitializerContext? {
            return getRuleContext(StructInitializerContext.self, 0)
        }
        open func arrayInitializer() -> ArrayInitializerContext? {
            return getRuleContext(ArrayInitializerContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_structInitializerItem
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructInitializerItem(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructInitializerItem(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructInitializerItem(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructInitializerItem(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structInitializerItem() throws -> StructInitializerItemContext {
        var _localctx: StructInitializerItemContext
        _localctx = StructInitializerItemContext(_ctx, getState())
        try enterRule(_localctx, 232, ObjectiveCParser.RULE_structInitializerItem)
        defer { try! exitRule() }
        do {
            setState(1422)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 183, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class InitializerListContext: ParserRuleContext {
        open func initializer() -> [InitializerContext] {
            return getRuleContexts(InitializerContext.self)
        }
        open func initializer(_ i: Int) -> InitializerContext? {
            return getRuleContext(InitializerContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_initializerList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInitializerList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInitializerList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInitializerList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInitializerList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func initializerList() throws -> InitializerListContext {
        var _localctx: InitializerListContext
        _localctx = InitializerListContext(_ctx, getState())
        try enterRule(_localctx, 234, ObjectiveCParser.RULE_initializerList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1424)
            try initializer()
            setState(1429)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 184, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1425)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1426)
                    try initializer()

                }
                setState(1431)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 184, _ctx)
            }
            setState(1433)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1432)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeNameContext: ParserRuleContext {
        open func specifierQualifierList() -> SpecifierQualifierListContext? {
            return getRuleContext(SpecifierQualifierListContext.self, 0)
        }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
        }
        open func blockType() -> BlockTypeContext? {
            return getRuleContext(BlockTypeContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterTypeName(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitTypeName(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeName() throws -> TypeNameContext {
        var _localctx: TypeNameContext
        _localctx = TypeNameContext(_ctx, getState())
        try enterRule(_localctx, 236, ObjectiveCParser.RULE_typeName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1440)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 187, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1435)
                try specifierQualifierList()
                setState(1437)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 126)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 126)) & 268_435_473) != 0
                {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AbstractDeclaratorContext: ParserRuleContext {
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func abstractDeclaratorSuffix() -> [AbstractDeclaratorSuffixContext] {
            return getRuleContexts(AbstractDeclaratorSuffixContext.self)
        }
        open func abstractDeclaratorSuffix(_ i: Int) -> AbstractDeclaratorSuffixContext? {
            return getRuleContext(AbstractDeclaratorSuffixContext.self, i)
        }
        open func LBRACK() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.LBRACK.rawValue)
        }
        open func LBRACK(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, i)
        }
        open func RBRACK() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.RBRACK.rawValue)
        }
        open func RBRACK(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, i)
        }
        open func constantExpression() -> [ConstantExpressionContext] {
            return getRuleContexts(ConstantExpressionContext.self)
        }
        open func constantExpression(_ i: Int) -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_abstractDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAbstractDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAbstractDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAbstractDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAbstractDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func abstractDeclarator() throws -> AbstractDeclaratorContext {
        var _localctx: AbstractDeclaratorContext
        _localctx = AbstractDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 238, ObjectiveCParser.RULE_abstractDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1465)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .MUL:
                try enterOuterAlt(_localctx, 1)
                setState(1442)
                try pointer()
                setState(1444)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 126)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 126)) & 268_435_473) != 0
                {
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
                if (Int64((_la - 126)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 126)) & 268_435_473) != 0
                {
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

                    setState(1454)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.LBRACK.rawValue

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
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 288_230_101_273_804_800) != 0
                        || (Int64((_la - 81)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                        || (Int64((_la - 152)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 152)) & 65_536_003) != 0
                    {
                        setState(1457)
                        try constantExpression()

                    }

                    setState(1460)
                    try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                    setState(1463)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.LBRACK.rawValue

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

    public class AbstractDeclaratorSuffixContext: ParserRuleContext {
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func parameterDeclarationList() -> ParameterDeclarationListContext? {
            return getRuleContext(ParameterDeclarationListContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_abstractDeclaratorSuffix
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAbstractDeclaratorSuffix(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAbstractDeclaratorSuffix(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAbstractDeclaratorSuffix(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAbstractDeclaratorSuffix(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func abstractDeclaratorSuffix() throws
        -> AbstractDeclaratorSuffixContext
    {
        var _localctx: AbstractDeclaratorSuffixContext
        _localctx = AbstractDeclaratorSuffixContext(_ctx, getState())
        try enterRule(_localctx, 240, ObjectiveCParser.RULE_abstractDeclaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1477)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(1467)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1469)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 288_230_101_273_804_800) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0
                    || (Int64((_la - 152)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 152)) & 65_536_003) != 0
                {
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
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_780_063_951_410) != 0
                    || (Int64((_la - 81)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 81)) & 17_867_063_951_359) != 0
                {
                    setState(1473)
                    try parameterDeclarationList()

                }

                setState(1476)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

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

    public class ParameterDeclarationListContext: ParserRuleContext {
        open func parameterDeclaration() -> [ParameterDeclarationContext] {
            return getRuleContexts(ParameterDeclarationContext.self)
        }
        open func parameterDeclaration(_ i: Int) -> ParameterDeclarationContext? {
            return getRuleContext(ParameterDeclarationContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_parameterDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterParameterDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitParameterDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitParameterDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitParameterDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func parameterDeclarationList() throws
        -> ParameterDeclarationListContext
    {
        var _localctx: ParameterDeclarationListContext
        _localctx = ParameterDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 242, ObjectiveCParser.RULE_parameterDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1479)
            try parameterDeclaration()
            setState(1484)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 197, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1480)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1481)
                    try parameterDeclaration()

                }
                setState(1486)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 197, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ParameterDeclarationContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func functionPointer() -> FunctionPointerContext? {
            return getRuleContext(FunctionPointerContext.self, 0)
        }
        open func VOID() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VOID.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_parameterDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterParameterDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitParameterDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitParameterDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitParameterDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func parameterDeclaration() throws -> ParameterDeclarationContext {
        var _localctx: ParameterDeclarationContext
        _localctx = ParameterDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 244, ObjectiveCParser.RULE_parameterDeclaration)
        defer { try! exitRule() }
        do {
            setState(1492)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 198, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclaratorContext: ParserRuleContext {
        open func directDeclarator() -> DirectDeclaratorContext? {
            return getRuleContext(DirectDeclaratorContext.self, 0)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_declarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarator() throws -> DeclaratorContext {
        var _localctx: DeclaratorContext
        _localctx = DeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 246, ObjectiveCParser.RULE_declarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1495)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1494)
                try pointer()

            }

            setState(1497)
            try directDeclarator()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StatementContext: ParserRuleContext {
        open func labeledStatement() -> LabeledStatementContext? {
            return getRuleContext(LabeledStatementContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func selectionStatement() -> SelectionStatementContext? {
            return getRuleContext(SelectionStatementContext.self, 0)
        }
        open func iterationStatement() -> IterationStatementContext? {
            return getRuleContext(IterationStatementContext.self, 0)
        }
        open func jumpStatement() -> JumpStatementContext? {
            return getRuleContext(JumpStatementContext.self, 0)
        }
        open func synchronizedStatement() -> SynchronizedStatementContext? {
            return getRuleContext(SynchronizedStatementContext.self, 0)
        }
        open func autoreleaseStatement() -> AutoreleaseStatementContext? {
            return getRuleContext(AutoreleaseStatementContext.self, 0)
        }
        open func throwStatement() -> ThrowStatementContext? {
            return getRuleContext(ThrowStatementContext.self, 0)
        }
        open func tryBlock() -> TryBlockContext? { return getRuleContext(TryBlockContext.self, 0) }
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_statement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitStatement(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func statement() throws -> StatementContext {
        var _localctx: StatementContext
        _localctx = StatementContext(_ctx, getState())
        try enterRule(_localctx, 248, ObjectiveCParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(1537)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 207, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1499)
                try labeledStatement()
                setState(1501)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 200, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 201, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 202, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 203, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 204, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 205, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 206, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class LabeledStatementContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_labeledStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterLabeledStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitLabeledStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitLabeledStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitLabeledStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func labeledStatement() throws -> LabeledStatementContext {
        var _localctx: LabeledStatementContext
        _localctx = LabeledStatementContext(_ctx, getState())
        try enterRule(_localctx, 250, ObjectiveCParser.RULE_labeledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1539)
            try identifier()
            setState(1540)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(1541)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class RangeExpressionContext: ParserRuleContext {
        open func expression() -> [ExpressionContext] {
            return getRuleContexts(ExpressionContext.self)
        }
        open func expression(_ i: Int) -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, i)
        }
        open func ELIPSIS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_rangeExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterRangeExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitRangeExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitRangeExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitRangeExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func rangeExpression() throws -> RangeExpressionContext {
        var _localctx: RangeExpressionContext
        _localctx = RangeExpressionContext(_ctx, getState())
        try enterRule(_localctx, 252, ObjectiveCParser.RULE_rangeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1543)
            try expression(0)
            setState(1546)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue {
                setState(1544)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
                setState(1545)
                try expression(0)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class CompoundStatementContext: ParserRuleContext {
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func declaration() -> [DeclarationContext] {
            return getRuleContexts(DeclarationContext.self)
        }
        open func declaration(_ i: Int) -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, i)
        }
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_compoundStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterCompoundStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitCompoundStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitCompoundStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitCompoundStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func compoundStatement() throws -> CompoundStatementContext {
        var _localctx: CompoundStatementContext
        _localctx = CompoundStatementContext(_ctx, getState())
        try enterRule(_localctx, 254, ObjectiveCParser.RULE_compoundStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1548)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1553)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 5_188_146_530_212_641_654) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & -6_123_769_593_317_032_575) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1551)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 209, _ctx) {
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SelectionStatementContext: ParserRuleContext {
        open var ifBody: StatementContext!
        open var elseBody: StatementContext!
        open func IF() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.IF.rawValue, 0) }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        open func ELSE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELSE.rawValue, 0)
        }
        open func switchStatement() -> SwitchStatementContext? {
            return getRuleContext(SwitchStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_selectionStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSelectionStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSelectionStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSelectionStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSelectionStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func selectionStatement() throws -> SelectionStatementContext {
        var _localctx: SelectionStatementContext
        _localctx = SelectionStatementContext(_ctx, getState())
        try enterRule(_localctx, 256, ObjectiveCParser.RULE_selectionStatement)
        defer { try! exitRule() }
        do {
            setState(1568)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
                switch try getInterpreter().adaptivePredict(_input, 211, _ctx) {
                case 1:
                    setState(1563)
                    try match(ObjectiveCParser.Tokens.ELSE.rawValue)
                    setState(1564)
                    try {
                        let assignmentValue = try statement()
                        _localctx.castdown(SelectionStatementContext.self).elseBody =
                            assignmentValue
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SwitchStatementContext: ParserRuleContext {
        open func SWITCH() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SWITCH.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func switchBlock() -> SwitchBlockContext? {
            return getRuleContext(SwitchBlockContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_switchStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSwitchStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSwitchStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSwitchStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSwitchStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func switchStatement() throws -> SwitchStatementContext {
        var _localctx: SwitchStatementContext
        _localctx = SwitchStatementContext(_ctx, getState())
        try enterRule(_localctx, 258, ObjectiveCParser.RULE_switchStatement)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SwitchBlockContext: ParserRuleContext {
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func RBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACE.rawValue, 0)
        }
        open func switchSection() -> [SwitchSectionContext] {
            return getRuleContexts(SwitchSectionContext.self)
        }
        open func switchSection(_ i: Int) -> SwitchSectionContext? {
            return getRuleContext(SwitchSectionContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_switchBlock }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSwitchBlock(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSwitchBlock(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSwitchBlock(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSwitchBlock(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func switchBlock() throws -> SwitchBlockContext {
        var _localctx: SwitchBlockContext
        _localctx = SwitchBlockContext(_ctx, getState())
        try enterRule(_localctx, 260, ObjectiveCParser.RULE_switchBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1576)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1580)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            {
                setState(1577)
                try switchSection()

                setState(1582)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1583)
            try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SwitchSectionContext: ParserRuleContext {
        open func switchLabel() -> [SwitchLabelContext] {
            return getRuleContexts(SwitchLabelContext.self)
        }
        open func switchLabel(_ i: Int) -> SwitchLabelContext? {
            return getRuleContext(SwitchLabelContext.self, i)
        }
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_switchSection }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSwitchSection(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSwitchSection(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSwitchSection(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSwitchSection(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func switchSection() throws -> SwitchSectionContext {
        var _localctx: SwitchSectionContext
        _localctx = SwitchSectionContext(_ctx, getState())
        try enterRule(_localctx, 262, ObjectiveCParser.RULE_switchSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1586)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1585)
                try switchLabel()

                setState(1588)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            setState(1591)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1590)
                try statement()

                setState(1593)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & 5_188_146_513_339_072_836) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & -6_123_769_594_089_079_423) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class SwitchLabelContext: ParserRuleContext {
        open func CASE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CASE.rawValue, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func rangeExpression() -> RangeExpressionContext? {
            return getRuleContext(RangeExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func DEFAULT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEFAULT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_switchLabel }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterSwitchLabel(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitSwitchLabel(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitSwitchLabel(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitSwitchLabel(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func switchLabel() throws -> SwitchLabelContext {
        var _localctx: SwitchLabelContext
        _localctx = SwitchLabelContext(_ctx, getState())
        try enterRule(_localctx, 264, ObjectiveCParser.RULE_switchLabel)
        defer { try! exitRule() }
        do {
            setState(1607)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CASE:
                try enterOuterAlt(_localctx, 1)
                setState(1595)
                try match(ObjectiveCParser.Tokens.CASE.rawValue)
                setState(1601)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 216, _ctx) {
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
            }
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IterationStatementContext: ParserRuleContext {
        open func whileStatement() -> WhileStatementContext? {
            return getRuleContext(WhileStatementContext.self, 0)
        }
        open func doStatement() -> DoStatementContext? {
            return getRuleContext(DoStatementContext.self, 0)
        }
        open func forStatement() -> ForStatementContext? {
            return getRuleContext(ForStatementContext.self, 0)
        }
        open func forInStatement() -> ForInStatementContext? {
            return getRuleContext(ForInStatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_iterationStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterIterationStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitIterationStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitIterationStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitIterationStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func iterationStatement() throws -> IterationStatementContext {
        var _localctx: IterationStatementContext
        _localctx = IterationStatementContext(_ctx, getState())
        try enterRule(_localctx, 266, ObjectiveCParser.RULE_iterationStatement)
        defer { try! exitRule() }
        do {
            setState(1613)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 218, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class WhileStatementContext: ParserRuleContext {
        open func WHILE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WHILE.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_whileStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterWhileStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitWhileStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitWhileStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitWhileStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func whileStatement() throws -> WhileStatementContext {
        var _localctx: WhileStatementContext
        _localctx = WhileStatementContext(_ctx, getState())
        try enterRule(_localctx, 268, ObjectiveCParser.RULE_whileStatement)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DoStatementContext: ParserRuleContext {
        open func DO() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.DO.rawValue, 0) }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func WHILE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WHILE.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_doStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDoStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDoStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDoStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDoStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func doStatement() throws -> DoStatementContext {
        var _localctx: DoStatementContext
        _localctx = DoStatementContext(_ctx, getState())
        try enterRule(_localctx, 270, ObjectiveCParser.RULE_doStatement)
        defer { try! exitRule() }
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

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ForStatementContext: ParserRuleContext {
        open func FOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FOR.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func SEMI() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.SEMI.rawValue)
        }
        open func SEMI(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, i)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func forLoopInitializer() -> ForLoopInitializerContext? {
            return getRuleContext(ForLoopInitializerContext.self, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_forStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterForStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitForStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitForStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitForStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func forStatement() throws -> ForStatementContext {
        var _localctx: ForStatementContext
        _localctx = ForStatementContext(_ctx, getState())
        try enterRule(_localctx, 272, ObjectiveCParser.RULE_forStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1629)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1630)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1632)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_136_071_445_042) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_691_234_316_417) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1631)
                try forLoopInitializer()

            }

            setState(1634)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1636)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1635)
                try expression(0)

            }

            setState(1638)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1640)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1639)
                try expressions()

            }

            setState(1642)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1643)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ForLoopInitializerContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func initDeclaratorList() -> InitDeclaratorListContext? {
            return getRuleContext(InitDeclaratorListContext.self, 0)
        }
        open func expressions() -> ExpressionsContext? {
            return getRuleContext(ExpressionsContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_forLoopInitializer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterForLoopInitializer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitForLoopInitializer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitForLoopInitializer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitForLoopInitializer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func forLoopInitializer() throws -> ForLoopInitializerContext {
        var _localctx: ForLoopInitializerContext
        _localctx = ForLoopInitializerContext(_ctx, getState())
        try enterRule(_localctx, 274, ObjectiveCParser.RULE_forLoopInitializer)
        defer { try! exitRule() }
        do {
            setState(1649)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 222, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ForInStatementContext: ParserRuleContext {
        open func FOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FOR.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeVariableDeclarator() -> TypeVariableDeclaratorContext? {
            return getRuleContext(TypeVariableDeclaratorContext.self, 0)
        }
        open func IN() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func statement() -> StatementContext? {
            return getRuleContext(StatementContext.self, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_forInStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterForInStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitForInStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitForInStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitForInStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func forInStatement() throws -> ForInStatementContext {
        var _localctx: ForInStatementContext
        _localctx = ForInStatementContext(_ctx, getState())
        try enterRule(_localctx, 276, ObjectiveCParser.RULE_forInStatement)
        var _la: Int = 0
        defer { try! exitRule() }
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
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                || (Int64((_la - 69)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
            {
                setState(1655)
                try expression(0)

            }

            setState(1658)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1659)
            try statement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class JumpStatementContext: ParserRuleContext {
        open func GOTO() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.GOTO.rawValue, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func CONTINUE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONTINUE.rawValue, 0)
        }
        open func BREAK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BREAK.rawValue, 0)
        }
        open func RETURN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RETURN.rawValue, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_jumpStatement }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterJumpStatement(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitJumpStatement(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitJumpStatement(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitJumpStatement(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func jumpStatement() throws -> JumpStatementContext {
        var _localctx: JumpStatementContext
        _localctx = JumpStatementContext(_ctx, getState())
        try enterRule(_localctx, 278, ObjectiveCParser.RULE_jumpStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1669)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                    || (Int64((_la - 69)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                    || (Int64((_la - 136)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
                {
                    setState(1666)
                    try expression(0)

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

    public class ExpressionsContext: ParserRuleContext {
        open func expression() -> [ExpressionContext] {
            return getRuleContexts(ExpressionContext.self)
        }
        open func expression(_ i: Int) -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_expressions }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterExpressions(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitExpressions(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitExpressions(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitExpressions(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func expressions() throws -> ExpressionsContext {
        var _localctx: ExpressionsContext
        _localctx = ExpressionsContext(_ctx, getState())
        try enterRule(_localctx, 280, ObjectiveCParser.RULE_expressions)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1671)
            try expression(0)
            setState(1676)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 226, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1672)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1673)
                    try expression(0)

                }
                setState(1678)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 226, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
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
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        open func unaryExpression() -> UnaryExpressionContext? {
            return getRuleContext(UnaryExpressionContext.self, 0)
        }
        open func assignmentOperator() -> AssignmentOperatorContext? {
            return getRuleContext(AssignmentOperatorContext.self, 0)
        }
        open func expression() -> [ExpressionContext] {
            return getRuleContexts(ExpressionContext.self)
        }
        open func expression(_ i: Int) -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, i)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func DIV() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIV.rawValue, 0)
        }
        open func MOD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MOD.rawValue, 0)
        }
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        open func LT() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.LT.rawValue) }
        open func LT(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LT.rawValue, i)
        }
        open func GT() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.GT.rawValue) }
        open func GT(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.GT.rawValue, i)
        }
        open func LE() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LE.rawValue, 0) }
        open func GE() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GE.rawValue, 0) }
        open func NOTEQUAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NOTEQUAL.rawValue, 0)
        }
        open func EQUAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EQUAL.rawValue, 0)
        }
        open func BITAND() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITAND.rawValue, 0)
        }
        open func BITXOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
        }
        open func BITOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITOR.rawValue, 0)
        }
        open func AND() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AND.rawValue, 0)
        }
        open func OR() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.OR.rawValue, 0) }
        open func QUESTION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.QUESTION.rawValue, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_expression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }

    public final func expression() throws -> ExpressionContext { return try expression(0) }
    @discardableResult private func expression(_ _p: Int) throws -> ExpressionContext {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: ExpressionContext
        _localctx = ExpressionContext(_ctx, _parentState)
        let _startState: Int = 282
        try enterRecursionRule(_localctx, 282, ObjectiveCParser.RULE_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1689)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 227, _ctx) {
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
                    _localctx.castdown(ExpressionContext.self).assignmentExpression =
                        assignmentValue
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
            _alt = try getInterpreter().adaptivePredict(_input, 231, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1733)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 230, _ctx) {
                    case 1:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1691)
                        if !(precpred(_ctx, 13)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 13)"))
                        }
                        setState(1692)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64((_la - 154)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 154)) & 35) != 0)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(1693)
                        try expression(14)

                        break
                    case 2:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1694)
                        if !(precpred(_ctx, 12)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 12)"))
                        }
                        setState(1695)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.ADD.rawValue
                            || _la == ObjectiveCParser.Tokens.SUB.rawValue)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(1696)
                        try expression(13)

                        break
                    case 3:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1697)
                        if !(precpred(_ctx, 11)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 11)"))
                        }
                        setState(1702)
                        try _errHandler.sync(self)
                        switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
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
                        default: throw ANTLRException.recognition(e: NoViableAltException(self))
                        }
                        setState(1704)
                        try expression(12)

                        break
                    case 4:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1705)
                        if !(precpred(_ctx, 10)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 10)"))
                        }
                        setState(1706)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64((_la - 138)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 138)) & 387) != 0)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(1707)
                        try expression(11)

                        break
                    case 5:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1708)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(1709)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.EQUAL.rawValue
                            || _la == ObjectiveCParser.Tokens.NOTEQUAL.rawValue)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(1710)
                        try expression(10)

                        break
                    case 6:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1711)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
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
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1714)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
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
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1717)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
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
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1720)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
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
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1723)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
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
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(1726)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(1727)
                        try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
                        setState(1729)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                            || (Int64((_la - 69)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                            || (Int64((_la - 136)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
                        {
                            setState(1728)
                            try {
                                let assignmentValue = try expression(0)
                                _localctx.castdown(ExpressionContext.self).trueExpression =
                                    assignmentValue
                            }()

                        }

                        setState(1731)
                        try match(ObjectiveCParser.Tokens.COLON.rawValue)
                        setState(1732)
                        try {
                            let assignmentValue = try expression(4)
                            _localctx.castdown(ExpressionContext.self).falseExpression =
                                assignmentValue
                        }()

                        break
                    default: break
                    }
                }
                setState(1737)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 231, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AssignmentOperatorContext: ParserRuleContext {
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func MUL_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL_ASSIGN.rawValue, 0)
        }
        open func DIV_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIV_ASSIGN.rawValue, 0)
        }
        open func MOD_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MOD_ASSIGN.rawValue, 0)
        }
        open func ADD_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD_ASSIGN.rawValue, 0)
        }
        open func SUB_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB_ASSIGN.rawValue, 0)
        }
        open func LSHIFT_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LSHIFT_ASSIGN.rawValue, 0)
        }
        open func RSHIFT_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RSHIFT_ASSIGN.rawValue, 0)
        }
        open func AND_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AND_ASSIGN.rawValue, 0)
        }
        open func XOR_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.XOR_ASSIGN.rawValue, 0)
        }
        open func OR_ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OR_ASSIGN.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_assignmentOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAssignmentOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAssignmentOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAssignmentOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAssignmentOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func assignmentOperator() throws -> AssignmentOperatorContext {
        var _localctx: AssignmentOperatorContext
        _localctx = AssignmentOperatorContext(_ctx, getState())
        try enterRule(_localctx, 284, ObjectiveCParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1738)
            _la = try _input.LA(1)
            if !((Int64((_la - 137)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 137)) & 8_581_545_985) != 0)
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

    public class CastExpressionContext: ParserRuleContext {
        open func unaryExpression() -> UnaryExpressionContext? {
            return getRuleContext(UnaryExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        open func initializer() -> InitializerContext? {
            return getRuleContext(InitializerContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_castExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterCastExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitCastExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitCastExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitCastExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func castExpression() throws -> CastExpressionContext {
        var _localctx: CastExpressionContext
        _localctx = CastExpressionContext(_ctx, getState())
        try enterRule(_localctx, 286, ObjectiveCParser.RULE_castExpression)
        defer { try! exitRule() }
        do {
            setState(1749)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 233, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 232, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class InitializerContext: ParserRuleContext {
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func arrayInitializer() -> ArrayInitializerContext? {
            return getRuleContext(ArrayInitializerContext.self, 0)
        }
        open func structInitializer() -> StructInitializerContext? {
            return getRuleContext(StructInitializerContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_initializer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterInitializer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitInitializer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitInitializer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitInitializer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func initializer() throws -> InitializerContext {
        var _localctx: InitializerContext
        _localctx = InitializerContext(_ctx, getState())
        try enterRule(_localctx, 288, ObjectiveCParser.RULE_initializer)
        defer { try! exitRule() }
        do {
            setState(1754)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 234, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ConstantExpressionContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_constantExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterConstantExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitConstantExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitConstantExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitConstantExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func constantExpression() throws -> ConstantExpressionContext {
        var _localctx: ConstantExpressionContext
        _localctx = ConstantExpressionContext(_ctx, getState())
        try enterRule(_localctx, 290, ObjectiveCParser.RULE_constantExpression)
        defer { try! exitRule() }
        do {
            setState(1758)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .KINDOF, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE,
                .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG,
                .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(1756)
                try identifier()

                break
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                try enterOuterAlt(_localctx, 2)
                setState(1757)
                try constant()

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

    public class UnaryExpressionContext: ParserRuleContext {
        open var op: Token!
        open func postfixExpression() -> PostfixExpressionContext? {
            return getRuleContext(PostfixExpressionContext.self, 0)
        }
        open func SIZEOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SIZEOF.rawValue, 0)
        }
        open func unaryExpression() -> UnaryExpressionContext? {
            return getRuleContext(UnaryExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func INC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INC.rawValue, 0)
        }
        open func DEC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEC.rawValue, 0)
        }
        open func unaryOperator() -> UnaryOperatorContext? {
            return getRuleContext(UnaryOperatorContext.self, 0)
        }
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_unaryExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterUnaryExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitUnaryExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitUnaryExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitUnaryExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func unaryExpression() throws -> UnaryExpressionContext {
        var _localctx: UnaryExpressionContext
        _localctx = UnaryExpressionContext(_ctx, getState())
        try enterRule(_localctx, 292, ObjectiveCParser.RULE_unaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1774)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 237, _ctx) {
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
                switch try getInterpreter().adaptivePredict(_input, 236, _ctx) {
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
                if !(_la == ObjectiveCParser.Tokens.INC.rawValue
                    || _la == ObjectiveCParser.Tokens.DEC.rawValue)
                {
                    _localctx.castdown(UnaryExpressionContext.self).op =
                        try _errHandler.recoverInline(self) as Token
                } else {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class UnaryOperatorContext: ParserRuleContext {
        open func BITAND() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITAND.rawValue, 0)
        }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        open func TILDE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TILDE.rawValue, 0)
        }
        open func BANG() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BANG.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_unaryOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterUnaryOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitUnaryOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitUnaryOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitUnaryOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func unaryOperator() throws -> UnaryOperatorContext {
        var _localctx: UnaryOperatorContext
        _localctx = UnaryOperatorContext(_ctx, getState())
        try enterRule(_localctx, 294, ObjectiveCParser.RULE_unaryOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1776)
            _la = try _input.LA(1)
            if !((Int64((_la - 140)) & ~0x3f) == 0 && ((Int64(1) << (_la - 140)) & 94211) != 0) {
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

    public class PostfixExpressionContext: ParserRuleContext {
        open func primaryExpression() -> PrimaryExpressionContext? {
            return getRuleContext(PrimaryExpressionContext.self, 0)
        }
        open func postfixExpr() -> [PostfixExprContext] {
            return getRuleContexts(PostfixExprContext.self)
        }
        open func postfixExpr(_ i: Int) -> PostfixExprContext? {
            return getRuleContext(PostfixExprContext.self, i)
        }
        open func postfixExpression() -> PostfixExpressionContext? {
            return getRuleContext(PostfixExpressionContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func DOT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DOT.rawValue, 0)
        }
        open func STRUCTACCESS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRUCTACCESS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_postfixExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPostfixExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPostfixExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPostfixExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPostfixExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }

    public final func postfixExpression() throws -> PostfixExpressionContext {
        return try postfixExpression(0)
    }
    @discardableResult private func postfixExpression(_ _p: Int) throws -> PostfixExpressionContext
    {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: PostfixExpressionContext
        _localctx = PostfixExpressionContext(_ctx, _parentState)
        let _startState: Int = 296
        try enterRecursionRule(_localctx, 296, ObjectiveCParser.RULE_postfixExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1779)
            try primaryExpression()
            setState(1783)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 238, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1780)
                    try postfixExpr()

                }
                setState(1785)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 238, _ctx)
            }

            _ctx!.stop = try _input.LT(-1)
            setState(1797)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 240, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    _localctx = PostfixExpressionContext(_parentctx, _parentState)
                    try pushNewRecursionContext(
                        _localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
                    setState(1786)
                    if !(precpred(_ctx, 1)) {
                        throw ANTLRException.recognition(
                            e: FailedPredicateException(self, "precpred(_ctx, 1)"))
                    }
                    setState(1787)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.DOT.rawValue
                        || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }
                    setState(1788)
                    try identifier()
                    setState(1792)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 239, _ctx)
                    while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                        if _alt == 1 {
                            setState(1789)
                            try postfixExpr()

                        }
                        setState(1794)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 239, _ctx)
                    }

                }
                setState(1799)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 240, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PostfixExprContext: ParserRuleContext {
        open var _RP: Token!
        open var macroArguments: [Token] = [Token]()
        open var _tset3398: Token!
        open var op: Token!
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.RP.rawValue) }
        open func RP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
        }
        open func argumentExpressionList() -> ArgumentExpressionListContext? {
            return getRuleContext(ArgumentExpressionListContext.self, 0)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        open func INC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INC.rawValue, 0)
        }
        open func DEC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEC.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_postfixExpr }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPostfixExpr(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPostfixExpr(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPostfixExpr(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPostfixExpr(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func postfixExpr() throws -> PostfixExprContext {
        var _localctx: PostfixExprContext
        _localctx = PostfixExprContext(_ctx, getState())
        try enterRule(_localctx, 298, ObjectiveCParser.RULE_postfixExpr)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1818)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 244, _ctx) {
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
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 4_899_916_119_734_747_136) != 0
                    || (Int64((_la - 69)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 69)) & 2_523_141_690_462_269_569) != 0
                    || (Int64((_la - 136)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 136)) & 4_363_692_523_569) != 0
                {
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
                    switch try getInterpreter().adaptivePredict(_input, 242, _ctx) {
                    case 1:
                        setState(1810)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                        break
                    case 2:
                        setState(1811)
                        _localctx.castdown(PostfixExprContext.self)._tset3398 = try _input.LT(1)
                        _la = try _input.LA(1)
                        if _la <= 0 || (_la == ObjectiveCParser.Tokens.RP.rawValue) {
                            _localctx.castdown(PostfixExprContext.self)._tset3398 =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        _localctx.castdown(PostfixExprContext.self).macroArguments.append(
                            _localctx.castdown(PostfixExprContext.self)._tset3398)

                        break
                    default: break
                    }

                    setState(1814)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 64)) & 9_223_372_036_854_775_807) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0 && ((Int64(1) << (_la - 128)) & -1) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 34_359_738_367) != 0
                setState(1816)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1817)
                _localctx.castdown(PostfixExprContext.self).op = try _input.LT(1)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.INC.rawValue
                    || _la == ObjectiveCParser.Tokens.DEC.rawValue)
                {
                    _localctx.castdown(PostfixExprContext.self).op =
                        try _errHandler.recoverInline(self) as Token
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
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

    public class ArgumentExpressionListContext: ParserRuleContext {
        open func argumentExpression() -> [ArgumentExpressionContext] {
            return getRuleContexts(ArgumentExpressionContext.self)
        }
        open func argumentExpression(_ i: Int) -> ArgumentExpressionContext? {
            return getRuleContext(ArgumentExpressionContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_argumentExpressionList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterArgumentExpressionList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitArgumentExpressionList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitArgumentExpressionList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitArgumentExpressionList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func argumentExpressionList() throws -> ArgumentExpressionListContext {
        var _localctx: ArgumentExpressionListContext
        _localctx = ArgumentExpressionListContext(_ctx, getState())
        try enterRule(_localctx, 300, ObjectiveCParser.RULE_argumentExpressionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1820)
            try argumentExpression()
            setState(1825)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1821)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1822)
                try argumentExpression()

                setState(1827)
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

    public class ArgumentExpressionContext: ParserRuleContext {
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
            return getRuleContext(GenericTypeSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_argumentExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterArgumentExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitArgumentExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitArgumentExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitArgumentExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func argumentExpression() throws -> ArgumentExpressionContext {
        var _localctx: ArgumentExpressionContext
        _localctx = ArgumentExpressionContext(_ctx, getState())
        try enterRule(_localctx, 302, ObjectiveCParser.RULE_argumentExpression)
        defer { try! exitRule() }
        do {
            setState(1830)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 246, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PrimaryExpressionContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func constant() -> ConstantContext? { return getRuleContext(ConstantContext.self, 0) }
        open func stringLiteral() -> StringLiteralContext? {
            return getRuleContext(StringLiteralContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func messageExpression() -> MessageExpressionContext? {
            return getRuleContext(MessageExpressionContext.self, 0)
        }
        open func selectorExpression() -> SelectorExpressionContext? {
            return getRuleContext(SelectorExpressionContext.self, 0)
        }
        open func protocolExpression() -> ProtocolExpressionContext? {
            return getRuleContext(ProtocolExpressionContext.self, 0)
        }
        open func encodeExpression() -> EncodeExpressionContext? {
            return getRuleContext(EncodeExpressionContext.self, 0)
        }
        open func dictionaryExpression() -> DictionaryExpressionContext? {
            return getRuleContext(DictionaryExpressionContext.self, 0)
        }
        open func arrayExpression() -> ArrayExpressionContext? {
            return getRuleContext(ArrayExpressionContext.self, 0)
        }
        open func boxExpression() -> BoxExpressionContext? {
            return getRuleContext(BoxExpressionContext.self, 0)
        }
        open func blockExpression() -> BlockExpressionContext? {
            return getRuleContext(BlockExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_primaryExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPrimaryExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPrimaryExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPrimaryExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPrimaryExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func primaryExpression() throws -> PrimaryExpressionContext {
        var _localctx: PrimaryExpressionContext
        _localctx = PrimaryExpressionContext(_ctx, getState())
        try enterRule(_localctx, 304, ObjectiveCParser.RULE_primaryExpression)
        defer { try! exitRule() }
        do {
            setState(1847)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 247, _ctx) {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ConstantContext: ParserRuleContext {
        open func HEX_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue, 0)
        }
        open func OCTAL_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue, 0)
        }
        open func BINARY_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue, 0)
        }
        open func DECIMAL_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue, 0)
        }
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        open func FLOATING_POINT_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue, 0)
        }
        open func CHARACTER_LITERAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue, 0)
        }
        open func NIL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NIL.rawValue, 0)
        }
        open func NULL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULL.rawValue, 0)
        }
        open func YES() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.YES.rawValue, 0)
        }
        open func NO() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.NO.rawValue, 0) }
        open func TRUE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TRUE.rawValue, 0)
        }
        open func FALSE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FALSE.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_constant }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterConstant(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitConstant(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitConstant(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitConstant(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func constant() throws -> ConstantContext {
        var _localctx: ConstantContext
        _localctx = ConstantContext(_ctx, getState())
        try enterRule(_localctx, 306, ObjectiveCParser.RULE_constant)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1867)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 250, _ctx) {
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
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(1852)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.ADD.rawValue
                        || _la == ObjectiveCParser.Tokens.SUB.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
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
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(1856)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.ADD.rawValue
                        || _la == ObjectiveCParser.Tokens.SUB.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
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
        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StringLiteralContext: ParserRuleContext {
        open func STRING_START() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.STRING_START.rawValue)
        }
        open func STRING_START(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRING_START.rawValue, i)
        }
        open func STRING_END() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.STRING_END.rawValue)
        }
        open func STRING_END(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRING_END.rawValue, i)
        }
        open func STRING_VALUE() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
        }
        open func STRING_VALUE(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRING_VALUE.rawValue, i)
        }
        open func STRING_NEWLINE() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue)
        }
        open func STRING_NEWLINE(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_stringLiteral }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStringLiteral(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStringLiteral(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStringLiteral(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStringLiteral(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func stringLiteral() throws -> StringLiteralContext {
        var _localctx: StringLiteralContext
        _localctx = StringLiteralContext(_ctx, getState())
        try enterRule(_localctx, 308, ObjectiveCParser.RULE_stringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1877)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1869)
                    try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
                    setState(1873)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                        || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
                    {
                        setState(1870)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                            || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
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
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1879)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 252, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IdentifierContext: ParserRuleContext {
        open func IDENTIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IDENTIFIER.rawValue, 0)
        }
        open func BOOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BOOL.rawValue, 0)
        }
        open func Class() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.Class.rawValue, 0)
        }
        open func BYCOPY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BYCOPY.rawValue, 0)
        }
        open func BYREF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BYREF.rawValue, 0)
        }
        open func ID() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.ID.rawValue, 0) }
        open func IMP() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IMP.rawValue, 0)
        }
        open func IN() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.IN.rawValue, 0) }
        open func INOUT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INOUT.rawValue, 0)
        }
        open func ONEWAY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ONEWAY.rawValue, 0)
        }
        open func OUT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OUT.rawValue, 0)
        }
        open func PROTOCOL_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.PROTOCOL_.rawValue, 0)
        }
        open func SEL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEL.rawValue, 0)
        }
        open func SELF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SELF.rawValue, 0)
        }
        open func SUPER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUPER.rawValue, 0)
        }
        open func ATOMIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATOMIC.rawValue, 0)
        }
        open func NONATOMIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NONATOMIC.rawValue, 0)
        }
        open func RETAIN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RETAIN.rawValue, 0)
        }
        open func AUTORELEASING_QUALIFIER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AUTORELEASING_QUALIFIER.rawValue, 0)
        }
        open func BLOCK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BLOCK.rawValue, 0)
        }
        open func BRIDGE_RETAINED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BRIDGE_RETAINED.rawValue, 0)
        }
        open func BRIDGE_TRANSFER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BRIDGE_TRANSFER.rawValue, 0)
        }
        open func COVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
        }
        open func CONTRAVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
        }
        open func DEPRECATED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEPRECATED.rawValue, 0)
        }
        open func KINDOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.KINDOF.rawValue, 0)
        }
        open func UNUSED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNUSED.rawValue, 0)
        }
        open func NS_INLINE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_INLINE.rawValue, 0)
        }
        open func NS_ENUM() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_ENUM.rawValue, 0)
        }
        open func NS_OPTIONS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NS_OPTIONS.rawValue, 0)
        }
        open func NULL_UNSPECIFIED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULL_UNSPECIFIED.rawValue, 0)
        }
        open func NULLABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULLABLE.rawValue, 0)
        }
        open func NONNULL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NONNULL.rawValue, 0)
        }
        open func NULL_RESETTABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NULL_RESETTABLE.rawValue, 0)
        }
        open func ASSIGN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGN.rawValue, 0)
        }
        open func COPY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COPY.rawValue, 0)
        }
        open func GETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.GETTER.rawValue, 0)
        }
        open func SETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SETTER.rawValue, 0)
        }
        open func STRONG() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRONG.rawValue, 0)
        }
        open func READONLY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.READONLY.rawValue, 0)
        }
        open func READWRITE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.READWRITE.rawValue, 0)
        }
        open func WEAK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WEAK.rawValue, 0)
        }
        open func UNSAFE_UNRETAINED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue, 0)
        }
        open func IB_OUTLET() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_OUTLET.rawValue, 0)
        }
        open func IB_OUTLET_COLLECTION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue, 0)
        }
        open func IB_INSPECTABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue, 0)
        }
        open func IB_DESIGNABLE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_identifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterIdentifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitIdentifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitIdentifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitIdentifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func identifier() throws -> IdentifierContext {
        var _localctx: IdentifierContext
        _localctx = IdentifierContext(_ctx, getState())
        try enterRule(_localctx, 310, ObjectiveCParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1881)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 142_143_763_727_253_504) != 0
                || (Int64((_la - 81)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 81)) & 17_867_063_762_871) != 0)
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

    override open func sempred(_ _localctx: RuleContext?, _ ruleIndex: Int, _ predIndex: Int) throws
        -> Bool
    {
        switch ruleIndex {
        case 141:
            return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
        case 148:
            return try postfixExpression_sempred(
                _localctx?.castdown(PostfixExpressionContext.self), predIndex)
        default: return true
        }
    }
    private func expression_sempred(_ _localctx: ExpressionContext!, _ predIndex: Int) throws
        -> Bool
    {
        switch predIndex {
        case 0: return precpred(_ctx, 13)
        case 1: return precpred(_ctx, 12)
        case 2: return precpred(_ctx, 11)
        case 3: return precpred(_ctx, 10)
        case 4: return precpred(_ctx, 9)
        case 5: return precpred(_ctx, 8)
        case 6: return precpred(_ctx, 7)
        case 7: return precpred(_ctx, 6)
        case 8: return precpred(_ctx, 5)
        case 9: return precpred(_ctx, 4)
        case 10: return precpred(_ctx, 3)
        default: return true
        }
    }
    private func postfixExpression_sempred(_ _localctx: PostfixExpressionContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 11: return precpred(_ctx, 1)
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 226, 1884, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
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
        71, 2, 72, 7, 72, 2, 73, 7, 73, 2, 74, 7, 74, 2, 75, 7, 75, 2, 76, 7, 76, 2, 77, 7, 77, 2,
        78, 7, 78, 2, 79, 7, 79, 2, 80, 7, 80, 2, 81, 7, 81, 2, 82, 7, 82, 2, 83, 7, 83, 2, 84, 7,
        84, 2, 85, 7, 85, 2, 86, 7, 86, 2, 87, 7, 87, 2, 88, 7, 88, 2, 89, 7, 89, 2, 90, 7, 90, 2,
        91, 7, 91, 2, 92, 7, 92, 2, 93, 7, 93, 2, 94, 7, 94, 2, 95, 7, 95, 2, 96, 7, 96, 2, 97, 7,
        97, 2, 98, 7, 98, 2, 99, 7, 99, 2, 100, 7, 100, 2, 101, 7, 101, 2, 102, 7, 102, 2, 103, 7,
        103, 2, 104, 7, 104, 2, 105, 7, 105, 2, 106, 7, 106, 2, 107, 7, 107, 2, 108, 7, 108, 2, 109,
        7, 109, 2, 110, 7, 110, 2, 111, 7, 111, 2, 112, 7, 112, 2, 113, 7, 113, 2, 114, 7, 114, 2,
        115, 7, 115, 2, 116, 7, 116, 2, 117, 7, 117, 2, 118, 7, 118, 2, 119, 7, 119, 2, 120, 7, 120,
        2, 121, 7, 121, 2, 122, 7, 122, 2, 123, 7, 123, 2, 124, 7, 124, 2, 125, 7, 125, 2, 126, 7,
        126, 2, 127, 7, 127, 2, 128, 7, 128, 2, 129, 7, 129, 2, 130, 7, 130, 2, 131, 7, 131, 2, 132,
        7, 132, 2, 133, 7, 133, 2, 134, 7, 134, 2, 135, 7, 135, 2, 136, 7, 136, 2, 137, 7, 137, 2,
        138, 7, 138, 2, 139, 7, 139, 2, 140, 7, 140, 2, 141, 7, 141, 2, 142, 7, 142, 2, 143, 7, 143,
        2, 144, 7, 144, 2, 145, 7, 145, 2, 146, 7, 146, 2, 147, 7, 147, 2, 148, 7, 148, 2, 149, 7,
        149, 2, 150, 7, 150, 2, 151, 7, 151, 2, 152, 7, 152, 2, 153, 7, 153, 2, 154, 7, 154, 2, 155,
        7, 155, 1, 0, 5, 0, 314, 8, 0, 10, 0, 12, 0, 317, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 332, 8, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 3,
        3, 339, 8, 3, 1, 3, 1, 3, 1, 3, 3, 3, 344, 8, 3, 1, 3, 3, 3, 347, 8, 3, 1, 3, 1, 3, 1, 4, 1,
        4, 1, 4, 3, 4, 354, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 360, 8, 4, 1, 4, 1, 4, 1, 4, 3, 4,
        365, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 371, 8, 4, 3, 4, 373, 8, 4, 1, 5, 1, 5, 1, 5, 1, 5,
        3, 5, 379, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 386, 8, 5, 1, 5, 3, 5, 389, 8, 5, 1, 5,
        3, 5, 392, 8, 5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 3, 6, 399, 8, 6, 1, 6, 3, 6, 402, 8, 6, 1, 6,
        1, 6, 1, 7, 1, 7, 1, 7, 3, 7, 409, 8, 7, 1, 7, 1, 7, 1, 7, 3, 7, 414, 8, 7, 3, 7, 416, 8, 7,
        1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 3, 8, 424, 8, 8, 1, 8, 1, 8, 1, 9, 1, 9, 1, 9, 1, 9, 1,
        9, 1, 9, 3, 9, 434, 8, 9, 1, 10, 1, 10, 1, 11, 1, 11, 1, 11, 1, 12, 1, 12, 1, 12, 1, 12, 1,
        12, 1, 12, 3, 12, 447, 8, 12, 1, 13, 1, 13, 1, 13, 1, 13, 5, 13, 453, 8, 13, 10, 13, 12, 13,
        456, 9, 13, 3, 13, 458, 8, 13, 1, 13, 1, 13, 1, 14, 5, 14, 463, 8, 14, 10, 14, 12, 14, 466,
        9, 14, 1, 14, 1, 14, 3, 14, 470, 8, 14, 1, 15, 1, 15, 1, 15, 1, 15, 1, 15, 1, 15, 3, 15,
        478, 8, 15, 1, 15, 5, 15, 481, 8, 15, 10, 15, 12, 15, 484, 9, 15, 1, 15, 1, 15, 1, 16, 1,
        16, 5, 16, 490, 8, 16, 10, 16, 12, 16, 493, 9, 16, 1, 16, 4, 16, 496, 8, 16, 11, 16, 12, 16,
        497, 3, 16, 500, 8, 16, 1, 17, 1, 17, 1, 17, 1, 17, 1, 18, 1, 18, 1, 18, 1, 18, 5, 18, 510,
        8, 18, 10, 18, 12, 18, 513, 9, 18, 1, 18, 1, 18, 1, 19, 1, 19, 1, 19, 5, 19, 520, 8, 19, 10,
        19, 12, 19, 523, 9, 19, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 3, 20, 530, 8, 20, 1, 20, 3, 20,
        533, 8, 20, 1, 20, 3, 20, 536, 8, 20, 1, 20, 1, 20, 1, 21, 1, 21, 1, 21, 5, 21, 543, 8, 21,
        10, 21, 12, 21, 546, 9, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22,
        1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 3, 22, 568, 8,
        22, 1, 23, 1, 23, 1, 23, 1, 23, 1, 23, 3, 23, 575, 8, 23, 1, 23, 3, 23, 578, 8, 23, 1, 24,
        1, 24, 5, 24, 582, 8, 24, 10, 24, 12, 24, 585, 9, 24, 1, 24, 1, 24, 1, 25, 1, 25, 5, 25,
        591, 8, 25, 10, 25, 12, 25, 594, 9, 25, 1, 25, 4, 25, 597, 8, 25, 11, 25, 12, 25, 598, 3,
        25, 601, 8, 25, 1, 26, 1, 26, 1, 27, 1, 27, 1, 27, 1, 27, 1, 27, 4, 27, 610, 8, 27, 11, 27,
        12, 27, 611, 1, 28, 1, 28, 1, 28, 1, 29, 1, 29, 1, 29, 1, 30, 3, 30, 621, 8, 30, 1, 30, 1,
        30, 5, 30, 625, 8, 30, 10, 30, 12, 30, 628, 9, 30, 1, 30, 3, 30, 631, 8, 30, 1, 30, 1, 30,
        1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 4, 31, 640, 8, 31, 11, 31, 12, 31, 641, 1, 32, 1, 32, 1,
        32, 1, 33, 1, 33, 1, 33, 1, 34, 3, 34, 651, 8, 34, 1, 34, 1, 34, 3, 34, 655, 8, 34, 1, 34,
        3, 34, 658, 8, 34, 1, 34, 3, 34, 661, 8, 34, 1, 34, 1, 34, 3, 34, 665, 8, 34, 1, 35, 1, 35,
        4, 35, 669, 8, 35, 11, 35, 12, 35, 670, 1, 35, 1, 35, 3, 35, 675, 8, 35, 3, 35, 677, 8, 35,
        1, 36, 3, 36, 680, 8, 36, 1, 36, 1, 36, 5, 36, 684, 8, 36, 10, 36, 12, 36, 687, 9, 36, 1,
        36, 3, 36, 690, 8, 36, 1, 36, 1, 36, 1, 37, 1, 37, 1, 37, 1, 37, 1, 37, 1, 37, 3, 37, 700,
        8, 37, 1, 38, 1, 38, 1, 38, 1, 38, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39,
        3, 39, 714, 8, 39, 1, 40, 1, 40, 1, 40, 5, 40, 719, 8, 40, 10, 40, 12, 40, 722, 9, 40, 1,
        41, 1, 41, 1, 41, 3, 41, 727, 8, 41, 1, 42, 3, 42, 730, 8, 42, 1, 42, 1, 42, 3, 42, 734, 8,
        42, 1, 42, 1, 42, 1, 42, 1, 42, 3, 42, 740, 8, 42, 1, 42, 1, 42, 3, 42, 744, 8, 42, 1, 43,
        1, 43, 1, 43, 1, 43, 5, 43, 750, 8, 43, 10, 43, 12, 43, 753, 9, 43, 3, 43, 755, 8, 43, 1,
        43, 1, 43, 1, 44, 5, 44, 760, 8, 44, 10, 44, 12, 44, 763, 9, 44, 1, 44, 1, 44, 3, 44, 767,
        8, 44, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 5, 45, 774, 8, 45, 10, 45, 12, 45, 777, 9, 45, 1,
        45, 3, 45, 780, 8, 45, 3, 45, 782, 8, 45, 1, 45, 1, 45, 1, 46, 1, 46, 1, 46, 1, 46, 1, 47,
        1, 47, 1, 47, 1, 47, 3, 47, 794, 8, 47, 3, 47, 796, 8, 47, 1, 47, 1, 47, 1, 48, 1, 48, 1,
        48, 1, 48, 1, 48, 1, 48, 1, 48, 1, 48, 3, 48, 808, 8, 48, 3, 48, 810, 8, 48, 1, 49, 1, 49,
        1, 49, 3, 49, 815, 8, 49, 1, 49, 1, 49, 5, 49, 819, 8, 49, 10, 49, 12, 49, 822, 9, 49, 3,
        49, 824, 8, 49, 1, 49, 1, 49, 1, 50, 1, 50, 3, 50, 830, 8, 50, 1, 51, 1, 51, 3, 51, 834, 8,
        51, 1, 51, 3, 51, 837, 8, 51, 1, 51, 3, 51, 840, 8, 51, 1, 51, 1, 51, 1, 52, 1, 52, 1, 52,
        1, 52, 1, 52, 1, 53, 1, 53, 3, 53, 851, 8, 53, 1, 54, 1, 54, 4, 54, 855, 8, 54, 11, 54, 12,
        54, 856, 3, 54, 859, 8, 54, 1, 55, 3, 55, 862, 8, 55, 1, 55, 1, 55, 1, 55, 1, 55, 5, 55,
        868, 8, 55, 10, 55, 12, 55, 871, 9, 55, 1, 56, 1, 56, 3, 56, 875, 8, 56, 1, 56, 1, 56, 1,
        56, 1, 56, 3, 56, 881, 8, 56, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 58, 1, 58, 3, 58, 890,
        8, 58, 1, 58, 4, 58, 893, 8, 58, 11, 58, 12, 58, 894, 3, 58, 897, 8, 58, 1, 59, 1, 59, 1,
        59, 1, 59, 1, 59, 1, 60, 1, 60, 1, 60, 1, 60, 1, 60, 1, 61, 1, 61, 1, 61, 1, 62, 1, 62, 1,
        62, 1, 62, 1, 62, 1, 62, 1, 62, 3, 62, 919, 8, 62, 1, 63, 1, 63, 1, 63, 5, 63, 924, 8, 63,
        10, 63, 12, 63, 927, 9, 63, 1, 63, 1, 63, 3, 63, 931, 8, 63, 1, 64, 1, 64, 1, 64, 1, 64, 1,
        64, 1, 64, 1, 65, 1, 65, 1, 65, 1, 65, 1, 65, 1, 65, 1, 66, 1, 66, 1, 66, 1, 67, 1, 67, 1,
        67, 1, 68, 1, 68, 1, 68, 1, 69, 3, 69, 955, 8, 69, 1, 69, 1, 69, 1, 69, 3, 69, 960, 8, 69,
        1, 69, 1, 69, 1, 69, 3, 69, 965, 8, 69, 1, 70, 1, 70, 3, 70, 969, 8, 70, 1, 71, 1, 71, 3,
        71, 973, 8, 71, 1, 72, 1, 72, 3, 72, 977, 8, 72, 1, 72, 1, 72, 1, 73, 1, 73, 1, 73, 5, 73,
        984, 8, 73, 10, 73, 12, 73, 987, 9, 73, 1, 74, 1, 74, 1, 74, 1, 74, 3, 74, 993, 8, 74, 1,
        75, 1, 75, 1, 75, 1, 75, 1, 75, 3, 75, 1000, 8, 75, 1, 76, 1, 76, 1, 76, 1, 76, 1, 76, 1,
        76, 1, 76, 3, 76, 1009, 8, 76, 1, 77, 1, 77, 1, 77, 1, 77, 3, 77, 1015, 8, 77, 1, 77, 1, 77,
        1, 77, 3, 77, 1020, 8, 77, 1, 77, 1, 77, 1, 78, 1, 78, 1, 78, 3, 78, 1027, 8, 78, 1, 79, 1,
        79, 1, 79, 5, 79, 1032, 8, 79, 10, 79, 12, 79, 1035, 9, 79, 1, 80, 1, 80, 3, 80, 1039, 8,
        80, 1, 80, 3, 80, 1042, 8, 80, 1, 80, 3, 80, 1045, 8, 80, 1, 81, 3, 81, 1048, 8, 81, 1, 81,
        1, 81, 3, 81, 1052, 8, 81, 1, 81, 1, 81, 1, 81, 1, 81, 1, 81, 1, 82, 3, 82, 1060, 8, 82, 1,
        82, 3, 82, 1063, 8, 82, 1, 82, 1, 82, 3, 82, 1067, 8, 82, 1, 82, 1, 82, 1, 83, 1, 83, 1, 83,
        1, 83, 3, 83, 1075, 8, 83, 1, 83, 1, 83, 1, 84, 3, 84, 1080, 8, 84, 1, 84, 1, 84, 1, 84, 1,
        84, 1, 84, 3, 84, 1087, 8, 84, 1, 84, 3, 84, 1090, 8, 84, 1, 84, 1, 84, 1, 84, 3, 84, 1095,
        8, 84, 1, 84, 1, 84, 1, 84, 1, 84, 3, 84, 1101, 8, 84, 1, 85, 1, 85, 1, 85, 5, 85, 1106, 8,
        85, 10, 85, 12, 85, 1109, 9, 85, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 4,
        86, 1119, 8, 86, 11, 86, 12, 86, 1120, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 5, 87,
        1129, 8, 87, 10, 87, 12, 87, 1132, 9, 87, 1, 87, 1, 87, 1, 87, 1, 88, 1, 88, 1, 88, 5, 88,
        1140, 8, 88, 10, 88, 12, 88, 1143, 9, 88, 1, 89, 1, 89, 1, 89, 3, 89, 1148, 8, 89, 1, 90, 1,
        90, 5, 90, 1152, 8, 90, 10, 90, 12, 90, 1155, 9, 90, 1, 90, 1, 90, 3, 90, 1159, 8, 90, 1,
        90, 1, 90, 4, 90, 1163, 8, 90, 11, 90, 12, 90, 1164, 1, 90, 1, 90, 3, 90, 1169, 8, 90, 1,
        91, 1, 91, 1, 91, 3, 91, 1174, 8, 91, 1, 91, 1, 91, 1, 91, 1, 91, 1, 91, 3, 91, 1181, 8, 91,
        1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 4, 92, 1189, 8, 92, 11, 92, 12, 92, 1190, 1, 93,
        1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1199, 8, 93, 1, 94, 1, 94, 1, 95, 1, 95, 1, 96, 1,
        96, 1, 97, 1, 97, 1, 98, 1, 98, 1, 98, 1, 98, 3, 98, 1213, 8, 98, 1, 99, 1, 99, 1, 100, 1,
        100, 3, 100, 1219, 8, 100, 1, 100, 1, 100, 3, 100, 1223, 8, 100, 1, 100, 1, 100, 3, 100,
        1227, 8, 100, 1, 100, 1, 100, 3, 100, 1231, 8, 100, 1, 100, 1, 100, 3, 100, 1235, 8, 100, 1,
        100, 1, 100, 3, 100, 1239, 8, 100, 3, 100, 1241, 8, 100, 1, 101, 1, 101, 1, 102, 1, 102, 1,
        102, 1, 102, 1, 102, 1, 103, 1, 103, 1, 103, 5, 103, 1253, 8, 103, 10, 103, 12, 103, 1256,
        9, 103, 1, 104, 1, 104, 3, 104, 1260, 8, 104, 1, 104, 1, 104, 3, 104, 1264, 8, 104, 1, 105,
        1, 105, 3, 105, 1268, 8, 105, 1, 105, 1, 105, 3, 105, 1272, 8, 105, 1, 105, 1, 105, 1, 105,
        1, 105, 1, 105, 3, 105, 1279, 8, 105, 1, 105, 1, 105, 1, 105, 1, 105, 3, 105, 1285, 8, 105,
        1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 3, 105,
        1297, 8, 105, 1, 106, 1, 106, 1, 106, 5, 106, 1302, 8, 106, 10, 106, 12, 106, 1305, 9, 106,
        1, 106, 3, 106, 1308, 8, 106, 1, 107, 1, 107, 1, 107, 3, 107, 1313, 8, 107, 1, 108, 1, 108,
        1, 109, 1, 109, 1, 109, 1, 109, 1, 109, 3, 109, 1322, 8, 109, 1, 109, 5, 109, 1325, 8, 109,
        10, 109, 12, 109, 1328, 9, 109, 1, 109, 3, 109, 1331, 8, 109, 1, 109, 1, 109, 1, 109, 3,
        109, 1336, 8, 109, 1, 109, 3, 109, 1339, 8, 109, 1, 109, 1, 109, 1, 109, 1, 109, 1, 109, 3,
        109, 1346, 8, 109, 1, 109, 3, 109, 1349, 8, 109, 1, 109, 1, 109, 3, 109, 1353, 8, 109, 1,
        110, 1, 110, 3, 110, 1357, 8, 110, 1, 110, 1, 110, 1, 111, 1, 111, 1, 111, 3, 111, 1364, 8,
        111, 1, 112, 1, 112, 3, 112, 1368, 8, 112, 1, 112, 3, 112, 1371, 8, 112, 1, 113, 1, 113, 1,
        113, 1, 113, 1, 113, 5, 113, 1378, 8, 113, 10, 113, 12, 113, 1381, 9, 113, 1, 113, 1, 113,
        3, 113, 1385, 8, 113, 1, 114, 1, 114, 1, 114, 1, 114, 5, 114, 1391, 8, 114, 10, 114, 12,
        114, 1394, 9, 114, 1, 114, 3, 114, 1397, 8, 114, 3, 114, 1399, 8, 114, 1, 114, 1, 114, 1,
        115, 1, 115, 1, 115, 1, 115, 5, 115, 1407, 8, 115, 10, 115, 12, 115, 1410, 9, 115, 1, 115,
        3, 115, 1413, 8, 115, 3, 115, 1415, 8, 115, 1, 115, 1, 115, 1, 116, 1, 116, 1, 116, 1, 116,
        3, 116, 1423, 8, 116, 1, 117, 1, 117, 1, 117, 5, 117, 1428, 8, 117, 10, 117, 12, 117, 1431,
        9, 117, 1, 117, 3, 117, 1434, 8, 117, 1, 118, 1, 118, 3, 118, 1438, 8, 118, 1, 118, 3, 118,
        1441, 8, 118, 1, 119, 1, 119, 3, 119, 1445, 8, 119, 1, 119, 1, 119, 3, 119, 1449, 8, 119, 1,
        119, 1, 119, 4, 119, 1453, 8, 119, 11, 119, 12, 119, 1454, 1, 119, 1, 119, 3, 119, 1459, 8,
        119, 1, 119, 4, 119, 1462, 8, 119, 11, 119, 12, 119, 1463, 3, 119, 1466, 8, 119, 1, 120, 1,
        120, 3, 120, 1470, 8, 120, 1, 120, 1, 120, 1, 120, 3, 120, 1475, 8, 120, 1, 120, 3, 120,
        1478, 8, 120, 1, 121, 1, 121, 1, 121, 5, 121, 1483, 8, 121, 10, 121, 12, 121, 1486, 9, 121,
        1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 3, 122, 1493, 8, 122, 1, 123, 3, 123, 1496, 8, 123,
        1, 123, 1, 123, 1, 124, 1, 124, 3, 124, 1502, 8, 124, 1, 124, 1, 124, 3, 124, 1506, 8, 124,
        1, 124, 1, 124, 3, 124, 1510, 8, 124, 1, 124, 1, 124, 3, 124, 1514, 8, 124, 1, 124, 1, 124,
        1, 124, 1, 124, 1, 124, 3, 124, 1521, 8, 124, 1, 124, 1, 124, 3, 124, 1525, 8, 124, 1, 124,
        1, 124, 1, 124, 1, 124, 1, 124, 3, 124, 1532, 8, 124, 1, 124, 1, 124, 1, 124, 1, 124, 3,
        124, 1538, 8, 124, 1, 125, 1, 125, 1, 125, 1, 125, 1, 126, 1, 126, 1, 126, 3, 126, 1547, 8,
        126, 1, 127, 1, 127, 1, 127, 5, 127, 1552, 8, 127, 10, 127, 12, 127, 1555, 9, 127, 1, 127,
        1, 127, 1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 3, 128, 1566, 8, 128, 1,
        128, 3, 128, 1569, 8, 128, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 130, 1, 130,
        5, 130, 1579, 8, 130, 10, 130, 12, 130, 1582, 9, 130, 1, 130, 1, 130, 1, 131, 4, 131, 1587,
        8, 131, 11, 131, 12, 131, 1588, 1, 131, 4, 131, 1592, 8, 131, 11, 131, 12, 131, 1593, 1,
        132, 1, 132, 1, 132, 1, 132, 1, 132, 1, 132, 3, 132, 1602, 8, 132, 1, 132, 1, 132, 1, 132,
        1, 132, 3, 132, 1608, 8, 132, 1, 133, 1, 133, 1, 133, 1, 133, 3, 133, 1614, 8, 133, 1, 134,
        1, 134, 1, 134, 1, 134, 1, 134, 1, 134, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1,
        135, 1, 135, 1, 136, 1, 136, 1, 136, 3, 136, 1633, 8, 136, 1, 136, 1, 136, 3, 136, 1637, 8,
        136, 1, 136, 1, 136, 3, 136, 1641, 8, 136, 1, 136, 1, 136, 1, 136, 1, 137, 1, 137, 1, 137,
        1, 137, 3, 137, 1650, 8, 137, 1, 138, 1, 138, 1, 138, 1, 138, 1, 138, 3, 138, 1657, 8, 138,
        1, 138, 1, 138, 1, 138, 1, 139, 1, 139, 1, 139, 1, 139, 1, 139, 1, 139, 3, 139, 1668, 8,
        139, 3, 139, 1670, 8, 139, 1, 140, 1, 140, 1, 140, 5, 140, 1675, 8, 140, 10, 140, 12, 140,
        1678, 9, 140, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1,
        141, 3, 141, 1690, 8, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141,
        1, 141, 1, 141, 1, 141, 3, 141, 1703, 8, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1,
        141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141,
        1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 3, 141, 1730, 8, 141, 1,
        141, 1, 141, 5, 141, 1734, 8, 141, 10, 141, 12, 141, 1737, 9, 141, 1, 142, 1, 142, 1, 143,
        1, 143, 1, 143, 1, 143, 1, 143, 1, 143, 1, 143, 3, 143, 1748, 8, 143, 3, 143, 1750, 8, 143,
        1, 144, 1, 144, 1, 144, 3, 144, 1755, 8, 144, 1, 145, 1, 145, 3, 145, 1759, 8, 145, 1, 146,
        1, 146, 1, 146, 1, 146, 1, 146, 1, 146, 1, 146, 3, 146, 1768, 8, 146, 1, 146, 1, 146, 1,
        146, 1, 146, 1, 146, 3, 146, 1775, 8, 146, 1, 147, 1, 147, 1, 148, 1, 148, 1, 148, 5, 148,
        1782, 8, 148, 10, 148, 12, 148, 1785, 9, 148, 1, 148, 1, 148, 1, 148, 1, 148, 5, 148, 1791,
        8, 148, 10, 148, 12, 148, 1794, 9, 148, 5, 148, 1796, 8, 148, 10, 148, 12, 148, 1799, 9,
        148, 1, 149, 1, 149, 1, 149, 1, 149, 1, 149, 1, 149, 3, 149, 1807, 8, 149, 1, 149, 1, 149,
        1, 149, 1, 149, 4, 149, 1813, 8, 149, 11, 149, 12, 149, 1814, 1, 149, 1, 149, 3, 149, 1819,
        8, 149, 1, 150, 1, 150, 1, 150, 5, 150, 1824, 8, 150, 10, 150, 12, 150, 1827, 9, 150, 1,
        151, 1, 151, 3, 151, 1831, 8, 151, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152,
        1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 3, 152, 1848, 8, 152, 1,
        153, 1, 153, 1, 153, 1, 153, 3, 153, 1854, 8, 153, 1, 153, 1, 153, 3, 153, 1858, 8, 153, 1,
        153, 1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 3, 153, 1868, 8, 153, 1, 154,
        1, 154, 5, 154, 1872, 8, 154, 10, 154, 12, 154, 1875, 9, 154, 1, 154, 4, 154, 1878, 8, 154,
        11, 154, 12, 154, 1879, 1, 155, 1, 155, 1, 155, 0, 2, 282, 296, 156, 0, 2, 4, 6, 8, 10, 12,
        14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58,
        60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102,
        104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138,
        140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160, 162, 164, 166, 168, 170, 172, 174,
        176, 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210,
        212, 214, 216, 218, 220, 222, 224, 226, 228, 230, 232, 234, 236, 238, 240, 242, 244, 246,
        248, 250, 252, 254, 256, 258, 260, 262, 264, 266, 268, 270, 272, 274, 276, 278, 280, 282,
        284, 286, 288, 290, 292, 294, 296, 298, 300, 302, 304, 306, 308, 310, 0, 22, 2, 0, 70, 70,
        75, 75, 1, 0, 90, 91, 3, 0, 68, 68, 71, 71, 73, 74, 2, 0, 27, 27, 30, 30, 4, 0, 85, 85, 94,
        94, 96, 96, 98, 98, 1, 0, 99, 102, 4, 0, 1, 1, 12, 12, 20, 20, 26, 26, 4, 0, 17, 17, 86, 89,
        93, 93, 103, 103, 3, 0, 42, 43, 46, 47, 51, 52, 6, 0, 4, 4, 9, 9, 13, 13, 18, 19, 23, 24,
        31, 32, 1, 0, 104, 105, 2, 0, 154, 155, 159, 159, 1, 0, 152, 153, 2, 0, 138, 139, 145, 146,
        2, 0, 144, 144, 147, 147, 2, 0, 137, 137, 160, 169, 1, 0, 150, 151, 3, 0, 140, 141, 152,
        154, 156, 156, 1, 0, 134, 135, 1, 0, 127, 127, 2, 0, 183, 183, 185, 185, 8, 0, 40, 47, 51,
        56, 81, 83, 85, 86, 88, 93, 97, 97, 99, 118, 125, 125, 2087, 0, 315, 1, 0, 0, 0, 2, 331, 1,
        0, 0, 0, 4, 333, 1, 0, 0, 0, 6, 338, 1, 0, 0, 0, 8, 372, 1, 0, 0, 0, 10, 374, 1, 0, 0, 0,
        12, 395, 1, 0, 0, 0, 14, 415, 1, 0, 0, 0, 16, 417, 1, 0, 0, 0, 18, 427, 1, 0, 0, 0, 20, 435,
        1, 0, 0, 0, 22, 437, 1, 0, 0, 0, 24, 440, 1, 0, 0, 0, 26, 448, 1, 0, 0, 0, 28, 464, 1, 0, 0,
        0, 30, 471, 1, 0, 0, 0, 32, 499, 1, 0, 0, 0, 34, 501, 1, 0, 0, 0, 36, 505, 1, 0, 0, 0, 38,
        516, 1, 0, 0, 0, 40, 524, 1, 0, 0, 0, 42, 539, 1, 0, 0, 0, 44, 567, 1, 0, 0, 0, 46, 577, 1,
        0, 0, 0, 48, 579, 1, 0, 0, 0, 50, 600, 1, 0, 0, 0, 52, 602, 1, 0, 0, 0, 54, 609, 1, 0, 0, 0,
        56, 613, 1, 0, 0, 0, 58, 616, 1, 0, 0, 0, 60, 620, 1, 0, 0, 0, 62, 639, 1, 0, 0, 0, 64, 643,
        1, 0, 0, 0, 66, 646, 1, 0, 0, 0, 68, 650, 1, 0, 0, 0, 70, 676, 1, 0, 0, 0, 72, 679, 1, 0, 0,
        0, 74, 699, 1, 0, 0, 0, 76, 701, 1, 0, 0, 0, 78, 713, 1, 0, 0, 0, 80, 715, 1, 0, 0, 0, 82,
        723, 1, 0, 0, 0, 84, 729, 1, 0, 0, 0, 86, 745, 1, 0, 0, 0, 88, 761, 1, 0, 0, 0, 90, 768, 1,
        0, 0, 0, 92, 785, 1, 0, 0, 0, 94, 789, 1, 0, 0, 0, 96, 809, 1, 0, 0, 0, 98, 811, 1, 0, 0, 0,
        100, 829, 1, 0, 0, 0, 102, 831, 1, 0, 0, 0, 104, 843, 1, 0, 0, 0, 106, 850, 1, 0, 0, 0, 108,
        858, 1, 0, 0, 0, 110, 861, 1, 0, 0, 0, 112, 872, 1, 0, 0, 0, 114, 882, 1, 0, 0, 0, 116, 896,
        1, 0, 0, 0, 118, 898, 1, 0, 0, 0, 120, 903, 1, 0, 0, 0, 122, 908, 1, 0, 0, 0, 124, 918, 1,
        0, 0, 0, 126, 920, 1, 0, 0, 0, 128, 932, 1, 0, 0, 0, 130, 938, 1, 0, 0, 0, 132, 944, 1, 0,
        0, 0, 134, 947, 1, 0, 0, 0, 136, 950, 1, 0, 0, 0, 138, 954, 1, 0, 0, 0, 140, 966, 1, 0, 0,
        0, 142, 972, 1, 0, 0, 0, 144, 974, 1, 0, 0, 0, 146, 980, 1, 0, 0, 0, 148, 992, 1, 0, 0, 0,
        150, 994, 1, 0, 0, 0, 152, 1008, 1, 0, 0, 0, 154, 1010, 1, 0, 0, 0, 156, 1023, 1, 0, 0, 0,
        158, 1028, 1, 0, 0, 0, 160, 1044, 1, 0, 0, 0, 162, 1047, 1, 0, 0, 0, 164, 1059, 1, 0, 0, 0,
        166, 1074, 1, 0, 0, 0, 168, 1100, 1, 0, 0, 0, 170, 1102, 1, 0, 0, 0, 172, 1118, 1, 0, 0, 0,
        174, 1122, 1, 0, 0, 0, 176, 1136, 1, 0, 0, 0, 178, 1144, 1, 0, 0, 0, 180, 1149, 1, 0, 0, 0,
        182, 1180, 1, 0, 0, 0, 184, 1188, 1, 0, 0, 0, 186, 1198, 1, 0, 0, 0, 188, 1200, 1, 0, 0, 0,
        190, 1202, 1, 0, 0, 0, 192, 1204, 1, 0, 0, 0, 194, 1206, 1, 0, 0, 0, 196, 1212, 1, 0, 0, 0,
        198, 1214, 1, 0, 0, 0, 200, 1240, 1, 0, 0, 0, 202, 1242, 1, 0, 0, 0, 204, 1244, 1, 0, 0, 0,
        206, 1249, 1, 0, 0, 0, 208, 1263, 1, 0, 0, 0, 210, 1296, 1, 0, 0, 0, 212, 1298, 1, 0, 0, 0,
        214, 1309, 1, 0, 0, 0, 216, 1314, 1, 0, 0, 0, 218, 1352, 1, 0, 0, 0, 220, 1354, 1, 0, 0, 0,
        222, 1360, 1, 0, 0, 0, 224, 1365, 1, 0, 0, 0, 226, 1372, 1, 0, 0, 0, 228, 1386, 1, 0, 0, 0,
        230, 1402, 1, 0, 0, 0, 232, 1422, 1, 0, 0, 0, 234, 1424, 1, 0, 0, 0, 236, 1440, 1, 0, 0, 0,
        238, 1465, 1, 0, 0, 0, 240, 1477, 1, 0, 0, 0, 242, 1479, 1, 0, 0, 0, 244, 1492, 1, 0, 0, 0,
        246, 1495, 1, 0, 0, 0, 248, 1537, 1, 0, 0, 0, 250, 1539, 1, 0, 0, 0, 252, 1543, 1, 0, 0, 0,
        254, 1548, 1, 0, 0, 0, 256, 1568, 1, 0, 0, 0, 258, 1570, 1, 0, 0, 0, 260, 1576, 1, 0, 0, 0,
        262, 1586, 1, 0, 0, 0, 264, 1607, 1, 0, 0, 0, 266, 1613, 1, 0, 0, 0, 268, 1615, 1, 0, 0, 0,
        270, 1621, 1, 0, 0, 0, 272, 1629, 1, 0, 0, 0, 274, 1649, 1, 0, 0, 0, 276, 1651, 1, 0, 0, 0,
        278, 1669, 1, 0, 0, 0, 280, 1671, 1, 0, 0, 0, 282, 1689, 1, 0, 0, 0, 284, 1738, 1, 0, 0, 0,
        286, 1749, 1, 0, 0, 0, 288, 1754, 1, 0, 0, 0, 290, 1758, 1, 0, 0, 0, 292, 1774, 1, 0, 0, 0,
        294, 1776, 1, 0, 0, 0, 296, 1778, 1, 0, 0, 0, 298, 1818, 1, 0, 0, 0, 300, 1820, 1, 0, 0, 0,
        302, 1830, 1, 0, 0, 0, 304, 1847, 1, 0, 0, 0, 306, 1867, 1, 0, 0, 0, 308, 1877, 1, 0, 0, 0,
        310, 1881, 1, 0, 0, 0, 312, 314, 3, 2, 1, 0, 313, 312, 1, 0, 0, 0, 314, 317, 1, 0, 0, 0,
        315, 313, 1, 0, 0, 0, 315, 316, 1, 0, 0, 0, 316, 318, 1, 0, 0, 0, 317, 315, 1, 0, 0, 0, 318,
        319, 5, 0, 0, 1, 319, 1, 1, 0, 0, 0, 320, 332, 3, 4, 2, 0, 321, 332, 3, 134, 67, 0, 322,
        332, 3, 152, 76, 0, 323, 332, 3, 6, 3, 0, 324, 332, 3, 12, 6, 0, 325, 332, 3, 10, 5, 0, 326,
        332, 3, 16, 8, 0, 327, 332, 3, 30, 15, 0, 328, 332, 3, 34, 17, 0, 329, 332, 3, 36, 18, 0,
        330, 332, 3, 136, 68, 0, 331, 320, 1, 0, 0, 0, 331, 321, 1, 0, 0, 0, 331, 322, 1, 0, 0, 0,
        331, 323, 1, 0, 0, 0, 331, 324, 1, 0, 0, 0, 331, 325, 1, 0, 0, 0, 331, 326, 1, 0, 0, 0, 331,
        327, 1, 0, 0, 0, 331, 328, 1, 0, 0, 0, 331, 329, 1, 0, 0, 0, 331, 330, 1, 0, 0, 0, 332, 3,
        1, 0, 0, 0, 333, 334, 5, 67, 0, 0, 334, 335, 3, 310, 155, 0, 335, 336, 5, 132, 0, 0, 336, 5,
        1, 0, 0, 0, 337, 339, 5, 118, 0, 0, 338, 337, 1, 0, 0, 0, 338, 339, 1, 0, 0, 0, 339, 340, 1,
        0, 0, 0, 340, 341, 5, 66, 0, 0, 341, 343, 3, 8, 4, 0, 342, 344, 3, 48, 24, 0, 343, 342, 1,
        0, 0, 0, 343, 344, 1, 0, 0, 0, 344, 346, 1, 0, 0, 0, 345, 347, 3, 54, 27, 0, 346, 345, 1, 0,
        0, 0, 346, 347, 1, 0, 0, 0, 347, 348, 1, 0, 0, 0, 348, 349, 5, 63, 0, 0, 349, 7, 1, 0, 0, 0,
        350, 353, 3, 18, 9, 0, 351, 352, 5, 143, 0, 0, 352, 354, 3, 20, 10, 0, 353, 351, 1, 0, 0, 0,
        353, 354, 1, 0, 0, 0, 354, 359, 1, 0, 0, 0, 355, 356, 5, 139, 0, 0, 356, 357, 3, 38, 19, 0,
        357, 358, 5, 138, 0, 0, 358, 360, 1, 0, 0, 0, 359, 355, 1, 0, 0, 0, 359, 360, 1, 0, 0, 0,
        360, 373, 1, 0, 0, 0, 361, 364, 3, 18, 9, 0, 362, 363, 5, 143, 0, 0, 363, 365, 3, 22, 11, 0,
        364, 362, 1, 0, 0, 0, 364, 365, 1, 0, 0, 0, 365, 370, 1, 0, 0, 0, 366, 367, 5, 139, 0, 0,
        367, 368, 3, 38, 19, 0, 368, 369, 5, 138, 0, 0, 369, 371, 1, 0, 0, 0, 370, 366, 1, 0, 0, 0,
        370, 371, 1, 0, 0, 0, 371, 373, 1, 0, 0, 0, 372, 350, 1, 0, 0, 0, 372, 361, 1, 0, 0, 0, 373,
        9, 1, 0, 0, 0, 374, 375, 5, 66, 0, 0, 375, 376, 3, 18, 9, 0, 376, 378, 5, 126, 0, 0, 377,
        379, 3, 310, 155, 0, 378, 377, 1, 0, 0, 0, 378, 379, 1, 0, 0, 0, 379, 380, 1, 0, 0, 0, 380,
        385, 5, 127, 0, 0, 381, 382, 5, 139, 0, 0, 382, 383, 3, 38, 19, 0, 383, 384, 5, 138, 0, 0,
        384, 386, 1, 0, 0, 0, 385, 381, 1, 0, 0, 0, 385, 386, 1, 0, 0, 0, 386, 388, 1, 0, 0, 0, 387,
        389, 3, 48, 24, 0, 388, 387, 1, 0, 0, 0, 388, 389, 1, 0, 0, 0, 389, 391, 1, 0, 0, 0, 390,
        392, 3, 54, 27, 0, 391, 390, 1, 0, 0, 0, 391, 392, 1, 0, 0, 0, 392, 393, 1, 0, 0, 0, 393,
        394, 5, 63, 0, 0, 394, 11, 1, 0, 0, 0, 395, 396, 5, 65, 0, 0, 396, 398, 3, 14, 7, 0, 397,
        399, 3, 48, 24, 0, 398, 397, 1, 0, 0, 0, 398, 399, 1, 0, 0, 0, 399, 401, 1, 0, 0, 0, 400,
        402, 3, 62, 31, 0, 401, 400, 1, 0, 0, 0, 401, 402, 1, 0, 0, 0, 402, 403, 1, 0, 0, 0, 403,
        404, 5, 63, 0, 0, 404, 13, 1, 0, 0, 0, 405, 408, 3, 18, 9, 0, 406, 407, 5, 143, 0, 0, 407,
        409, 3, 20, 10, 0, 408, 406, 1, 0, 0, 0, 408, 409, 1, 0, 0, 0, 409, 416, 1, 0, 0, 0, 410,
        413, 3, 18, 9, 0, 411, 412, 5, 143, 0, 0, 412, 414, 3, 22, 11, 0, 413, 411, 1, 0, 0, 0, 413,
        414, 1, 0, 0, 0, 414, 416, 1, 0, 0, 0, 415, 405, 1, 0, 0, 0, 415, 410, 1, 0, 0, 0, 416, 15,
        1, 0, 0, 0, 417, 418, 5, 65, 0, 0, 418, 419, 3, 18, 9, 0, 419, 420, 5, 126, 0, 0, 420, 421,
        3, 310, 155, 0, 421, 423, 5, 127, 0, 0, 422, 424, 3, 62, 31, 0, 423, 422, 1, 0, 0, 0, 423,
        424, 1, 0, 0, 0, 424, 425, 1, 0, 0, 0, 425, 426, 5, 63, 0, 0, 426, 17, 1, 0, 0, 0, 427, 433,
        3, 310, 155, 0, 428, 429, 5, 139, 0, 0, 429, 430, 3, 38, 19, 0, 430, 431, 5, 138, 0, 0, 431,
        434, 1, 0, 0, 0, 432, 434, 3, 86, 43, 0, 433, 428, 1, 0, 0, 0, 433, 432, 1, 0, 0, 0, 433,
        434, 1, 0, 0, 0, 434, 19, 1, 0, 0, 0, 435, 436, 3, 310, 155, 0, 436, 21, 1, 0, 0, 0, 437,
        438, 3, 310, 155, 0, 438, 439, 3, 26, 13, 0, 439, 23, 1, 0, 0, 0, 440, 446, 3, 310, 155, 0,
        441, 442, 5, 139, 0, 0, 442, 443, 3, 38, 19, 0, 443, 444, 5, 138, 0, 0, 444, 447, 1, 0, 0,
        0, 445, 447, 3, 86, 43, 0, 446, 441, 1, 0, 0, 0, 446, 445, 1, 0, 0, 0, 447, 25, 1, 0, 0, 0,
        448, 457, 5, 139, 0, 0, 449, 454, 3, 28, 14, 0, 450, 451, 5, 133, 0, 0, 451, 453, 3, 28, 14,
        0, 452, 450, 1, 0, 0, 0, 453, 456, 1, 0, 0, 0, 454, 452, 1, 0, 0, 0, 454, 455, 1, 0, 0, 0,
        455, 458, 1, 0, 0, 0, 456, 454, 1, 0, 0, 0, 457, 449, 1, 0, 0, 0, 457, 458, 1, 0, 0, 0, 458,
        459, 1, 0, 0, 0, 459, 460, 5, 138, 0, 0, 460, 27, 1, 0, 0, 0, 461, 463, 3, 194, 97, 0, 462,
        461, 1, 0, 0, 0, 463, 466, 1, 0, 0, 0, 464, 462, 1, 0, 0, 0, 464, 465, 1, 0, 0, 0, 465, 467,
        1, 0, 0, 0, 466, 464, 1, 0, 0, 0, 467, 469, 3, 200, 100, 0, 468, 470, 3, 224, 112, 0, 469,
        468, 1, 0, 0, 0, 469, 470, 1, 0, 0, 0, 470, 29, 1, 0, 0, 0, 471, 472, 5, 69, 0, 0, 472, 477,
        3, 46, 23, 0, 473, 474, 5, 139, 0, 0, 474, 475, 3, 38, 19, 0, 475, 476, 5, 138, 0, 0, 476,
        478, 1, 0, 0, 0, 477, 473, 1, 0, 0, 0, 477, 478, 1, 0, 0, 0, 478, 482, 1, 0, 0, 0, 479, 481,
        3, 32, 16, 0, 480, 479, 1, 0, 0, 0, 481, 484, 1, 0, 0, 0, 482, 480, 1, 0, 0, 0, 482, 483, 1,
        0, 0, 0, 483, 485, 1, 0, 0, 0, 484, 482, 1, 0, 0, 0, 485, 486, 5, 63, 0, 0, 486, 31, 1, 0,
        0, 0, 487, 491, 7, 0, 0, 0, 488, 490, 3, 54, 27, 0, 489, 488, 1, 0, 0, 0, 490, 493, 1, 0, 0,
        0, 491, 489, 1, 0, 0, 0, 491, 492, 1, 0, 0, 0, 492, 500, 1, 0, 0, 0, 493, 491, 1, 0, 0, 0,
        494, 496, 3, 54, 27, 0, 495, 494, 1, 0, 0, 0, 496, 497, 1, 0, 0, 0, 497, 495, 1, 0, 0, 0,
        497, 498, 1, 0, 0, 0, 498, 500, 1, 0, 0, 0, 499, 487, 1, 0, 0, 0, 499, 495, 1, 0, 0, 0, 500,
        33, 1, 0, 0, 0, 501, 502, 5, 69, 0, 0, 502, 503, 3, 38, 19, 0, 503, 504, 5, 132, 0, 0, 504,
        35, 1, 0, 0, 0, 505, 506, 5, 60, 0, 0, 506, 511, 3, 18, 9, 0, 507, 508, 5, 133, 0, 0, 508,
        510, 3, 18, 9, 0, 509, 507, 1, 0, 0, 0, 510, 513, 1, 0, 0, 0, 511, 509, 1, 0, 0, 0, 511,
        512, 1, 0, 0, 0, 512, 514, 1, 0, 0, 0, 513, 511, 1, 0, 0, 0, 514, 515, 5, 132, 0, 0, 515,
        37, 1, 0, 0, 0, 516, 521, 3, 46, 23, 0, 517, 518, 5, 133, 0, 0, 518, 520, 3, 46, 23, 0, 519,
        517, 1, 0, 0, 0, 520, 523, 1, 0, 0, 0, 521, 519, 1, 0, 0, 0, 521, 522, 1, 0, 0, 0, 522, 39,
        1, 0, 0, 0, 523, 521, 1, 0, 0, 0, 524, 529, 5, 72, 0, 0, 525, 526, 5, 126, 0, 0, 526, 527,
        3, 42, 21, 0, 527, 528, 5, 127, 0, 0, 528, 530, 1, 0, 0, 0, 529, 525, 1, 0, 0, 0, 529, 530,
        1, 0, 0, 0, 530, 532, 1, 0, 0, 0, 531, 533, 3, 186, 93, 0, 532, 531, 1, 0, 0, 0, 532, 533,
        1, 0, 0, 0, 533, 535, 1, 0, 0, 0, 534, 536, 5, 117, 0, 0, 535, 534, 1, 0, 0, 0, 535, 536, 1,
        0, 0, 0, 536, 537, 1, 0, 0, 0, 537, 538, 3, 182, 91, 0, 538, 41, 1, 0, 0, 0, 539, 544, 3,
        44, 22, 0, 540, 541, 5, 133, 0, 0, 541, 543, 3, 44, 22, 0, 542, 540, 1, 0, 0, 0, 543, 546,
        1, 0, 0, 0, 544, 542, 1, 0, 0, 0, 544, 545, 1, 0, 0, 0, 545, 43, 1, 0, 0, 0, 546, 544, 1, 0,
        0, 0, 547, 568, 5, 81, 0, 0, 548, 568, 5, 82, 0, 0, 549, 568, 5, 110, 0, 0, 550, 568, 5,
        113, 0, 0, 551, 568, 5, 83, 0, 0, 552, 568, 5, 106, 0, 0, 553, 568, 5, 114, 0, 0, 554, 568,
        5, 107, 0, 0, 555, 568, 5, 111, 0, 0, 556, 568, 5, 112, 0, 0, 557, 558, 5, 108, 0, 0, 558,
        559, 5, 137, 0, 0, 559, 568, 3, 310, 155, 0, 560, 561, 5, 109, 0, 0, 561, 562, 5, 137, 0, 0,
        562, 563, 3, 310, 155, 0, 563, 564, 5, 143, 0, 0, 564, 568, 1, 0, 0, 0, 565, 568, 3, 190,
        95, 0, 566, 568, 3, 310, 155, 0, 567, 547, 1, 0, 0, 0, 567, 548, 1, 0, 0, 0, 567, 549, 1, 0,
        0, 0, 567, 550, 1, 0, 0, 0, 567, 551, 1, 0, 0, 0, 567, 552, 1, 0, 0, 0, 567, 553, 1, 0, 0,
        0, 567, 554, 1, 0, 0, 0, 567, 555, 1, 0, 0, 0, 567, 556, 1, 0, 0, 0, 567, 557, 1, 0, 0, 0,
        567, 560, 1, 0, 0, 0, 567, 565, 1, 0, 0, 0, 567, 566, 1, 0, 0, 0, 568, 45, 1, 0, 0, 0, 569,
        570, 5, 139, 0, 0, 570, 571, 3, 38, 19, 0, 571, 572, 5, 138, 0, 0, 572, 578, 1, 0, 0, 0,
        573, 575, 7, 1, 0, 0, 574, 573, 1, 0, 0, 0, 574, 575, 1, 0, 0, 0, 575, 576, 1, 0, 0, 0, 576,
        578, 3, 310, 155, 0, 577, 569, 1, 0, 0, 0, 577, 574, 1, 0, 0, 0, 578, 47, 1, 0, 0, 0, 579,
        583, 5, 128, 0, 0, 580, 582, 3, 50, 25, 0, 581, 580, 1, 0, 0, 0, 582, 585, 1, 0, 0, 0, 583,
        581, 1, 0, 0, 0, 583, 584, 1, 0, 0, 0, 584, 586, 1, 0, 0, 0, 585, 583, 1, 0, 0, 0, 586, 587,
        5, 129, 0, 0, 587, 49, 1, 0, 0, 0, 588, 592, 3, 52, 26, 0, 589, 591, 3, 182, 91, 0, 590,
        589, 1, 0, 0, 0, 591, 594, 1, 0, 0, 0, 592, 590, 1, 0, 0, 0, 592, 593, 1, 0, 0, 0, 593, 601,
        1, 0, 0, 0, 594, 592, 1, 0, 0, 0, 595, 597, 3, 182, 91, 0, 596, 595, 1, 0, 0, 0, 597, 598,
        1, 0, 0, 0, 598, 596, 1, 0, 0, 0, 598, 599, 1, 0, 0, 0, 599, 601, 1, 0, 0, 0, 600, 588, 1,
        0, 0, 0, 600, 596, 1, 0, 0, 0, 601, 51, 1, 0, 0, 0, 602, 603, 7, 2, 0, 0, 603, 53, 1, 0, 0,
        0, 604, 610, 3, 152, 76, 0, 605, 610, 3, 56, 28, 0, 606, 610, 3, 58, 29, 0, 607, 610, 3, 40,
        20, 0, 608, 610, 3, 134, 67, 0, 609, 604, 1, 0, 0, 0, 609, 605, 1, 0, 0, 0, 609, 606, 1, 0,
        0, 0, 609, 607, 1, 0, 0, 0, 609, 608, 1, 0, 0, 0, 610, 611, 1, 0, 0, 0, 611, 609, 1, 0, 0,
        0, 611, 612, 1, 0, 0, 0, 612, 55, 1, 0, 0, 0, 613, 614, 5, 152, 0, 0, 614, 615, 3, 60, 30,
        0, 615, 57, 1, 0, 0, 0, 616, 617, 5, 153, 0, 0, 617, 618, 3, 60, 30, 0, 618, 59, 1, 0, 0, 0,
        619, 621, 3, 76, 38, 0, 620, 619, 1, 0, 0, 0, 620, 621, 1, 0, 0, 0, 621, 622, 1, 0, 0, 0,
        622, 626, 3, 70, 35, 0, 623, 625, 3, 174, 87, 0, 624, 623, 1, 0, 0, 0, 625, 628, 1, 0, 0, 0,
        626, 624, 1, 0, 0, 0, 626, 627, 1, 0, 0, 0, 627, 630, 1, 0, 0, 0, 628, 626, 1, 0, 0, 0, 629,
        631, 3, 226, 113, 0, 630, 629, 1, 0, 0, 0, 630, 631, 1, 0, 0, 0, 631, 632, 1, 0, 0, 0, 632,
        633, 5, 132, 0, 0, 633, 61, 1, 0, 0, 0, 634, 640, 3, 136, 68, 0, 635, 640, 3, 152, 76, 0,
        636, 640, 3, 64, 32, 0, 637, 640, 3, 66, 33, 0, 638, 640, 3, 78, 39, 0, 639, 634, 1, 0, 0,
        0, 639, 635, 1, 0, 0, 0, 639, 636, 1, 0, 0, 0, 639, 637, 1, 0, 0, 0, 639, 638, 1, 0, 0, 0,
        640, 641, 1, 0, 0, 0, 641, 639, 1, 0, 0, 0, 641, 642, 1, 0, 0, 0, 642, 63, 1, 0, 0, 0, 643,
        644, 5, 152, 0, 0, 644, 645, 3, 68, 34, 0, 645, 65, 1, 0, 0, 0, 646, 647, 5, 153, 0, 0, 647,
        648, 3, 68, 34, 0, 648, 67, 1, 0, 0, 0, 649, 651, 3, 76, 38, 0, 650, 649, 1, 0, 0, 0, 650,
        651, 1, 0, 0, 0, 651, 652, 1, 0, 0, 0, 652, 654, 3, 70, 35, 0, 653, 655, 3, 176, 88, 0, 654,
        653, 1, 0, 0, 0, 654, 655, 1, 0, 0, 0, 655, 657, 1, 0, 0, 0, 656, 658, 5, 132, 0, 0, 657,
        656, 1, 0, 0, 0, 657, 658, 1, 0, 0, 0, 658, 660, 1, 0, 0, 0, 659, 661, 3, 174, 87, 0, 660,
        659, 1, 0, 0, 0, 660, 661, 1, 0, 0, 0, 661, 662, 1, 0, 0, 0, 662, 664, 3, 254, 127, 0, 663,
        665, 5, 132, 0, 0, 664, 663, 1, 0, 0, 0, 664, 665, 1, 0, 0, 0, 665, 69, 1, 0, 0, 0, 666,
        677, 3, 74, 37, 0, 667, 669, 3, 72, 36, 0, 668, 667, 1, 0, 0, 0, 669, 670, 1, 0, 0, 0, 670,
        668, 1, 0, 0, 0, 670, 671, 1, 0, 0, 0, 671, 674, 1, 0, 0, 0, 672, 673, 5, 133, 0, 0, 673,
        675, 5, 170, 0, 0, 674, 672, 1, 0, 0, 0, 674, 675, 1, 0, 0, 0, 675, 677, 1, 0, 0, 0, 676,
        666, 1, 0, 0, 0, 676, 668, 1, 0, 0, 0, 677, 71, 1, 0, 0, 0, 678, 680, 3, 74, 37, 0, 679,
        678, 1, 0, 0, 0, 679, 680, 1, 0, 0, 0, 680, 681, 1, 0, 0, 0, 681, 685, 5, 143, 0, 0, 682,
        684, 3, 76, 38, 0, 683, 682, 1, 0, 0, 0, 684, 687, 1, 0, 0, 0, 685, 683, 1, 0, 0, 0, 685,
        686, 1, 0, 0, 0, 686, 689, 1, 0, 0, 0, 687, 685, 1, 0, 0, 0, 688, 690, 3, 188, 94, 0, 689,
        688, 1, 0, 0, 0, 689, 690, 1, 0, 0, 0, 690, 691, 1, 0, 0, 0, 691, 692, 3, 310, 155, 0, 692,
        73, 1, 0, 0, 0, 693, 700, 3, 310, 155, 0, 694, 700, 5, 22, 0, 0, 695, 700, 5, 28, 0, 0, 696,
        700, 5, 16, 0, 0, 697, 700, 5, 10, 0, 0, 698, 700, 5, 7, 0, 0, 699, 693, 1, 0, 0, 0, 699,
        694, 1, 0, 0, 0, 699, 695, 1, 0, 0, 0, 699, 696, 1, 0, 0, 0, 699, 697, 1, 0, 0, 0, 699, 698,
        1, 0, 0, 0, 700, 75, 1, 0, 0, 0, 701, 702, 5, 126, 0, 0, 702, 703, 3, 236, 118, 0, 703, 704,
        5, 127, 0, 0, 704, 77, 1, 0, 0, 0, 705, 706, 5, 78, 0, 0, 706, 707, 3, 80, 40, 0, 707, 708,
        5, 132, 0, 0, 708, 714, 1, 0, 0, 0, 709, 710, 5, 61, 0, 0, 710, 711, 3, 80, 40, 0, 711, 712,
        5, 132, 0, 0, 712, 714, 1, 0, 0, 0, 713, 705, 1, 0, 0, 0, 713, 709, 1, 0, 0, 0, 714, 79, 1,
        0, 0, 0, 715, 720, 3, 82, 41, 0, 716, 717, 5, 133, 0, 0, 717, 719, 3, 82, 41, 0, 718, 716,
        1, 0, 0, 0, 719, 722, 1, 0, 0, 0, 720, 718, 1, 0, 0, 0, 720, 721, 1, 0, 0, 0, 721, 81, 1, 0,
        0, 0, 722, 720, 1, 0, 0, 0, 723, 726, 3, 310, 155, 0, 724, 725, 5, 137, 0, 0, 725, 727, 3,
        310, 155, 0, 726, 724, 1, 0, 0, 0, 726, 727, 1, 0, 0, 0, 727, 83, 1, 0, 0, 0, 728, 730, 3,
        190, 95, 0, 729, 728, 1, 0, 0, 0, 729, 730, 1, 0, 0, 0, 730, 731, 1, 0, 0, 0, 731, 733, 3,
        200, 100, 0, 732, 734, 3, 190, 95, 0, 733, 732, 1, 0, 0, 0, 733, 734, 1, 0, 0, 0, 734, 735,
        1, 0, 0, 0, 735, 736, 5, 126, 0, 0, 736, 739, 5, 158, 0, 0, 737, 740, 3, 190, 95, 0, 738,
        740, 3, 200, 100, 0, 739, 737, 1, 0, 0, 0, 739, 738, 1, 0, 0, 0, 739, 740, 1, 0, 0, 0, 740,
        741, 1, 0, 0, 0, 741, 743, 5, 127, 0, 0, 742, 744, 3, 98, 49, 0, 743, 742, 1, 0, 0, 0, 743,
        744, 1, 0, 0, 0, 744, 85, 1, 0, 0, 0, 745, 754, 5, 139, 0, 0, 746, 751, 3, 88, 44, 0, 747,
        748, 5, 133, 0, 0, 748, 750, 3, 88, 44, 0, 749, 747, 1, 0, 0, 0, 750, 753, 1, 0, 0, 0, 751,
        749, 1, 0, 0, 0, 751, 752, 1, 0, 0, 0, 752, 755, 1, 0, 0, 0, 753, 751, 1, 0, 0, 0, 754, 746,
        1, 0, 0, 0, 754, 755, 1, 0, 0, 0, 755, 756, 1, 0, 0, 0, 756, 757, 5, 138, 0, 0, 757, 87, 1,
        0, 0, 0, 758, 760, 3, 194, 97, 0, 759, 758, 1, 0, 0, 0, 760, 763, 1, 0, 0, 0, 761, 759, 1,
        0, 0, 0, 761, 762, 1, 0, 0, 0, 762, 764, 1, 0, 0, 0, 763, 761, 1, 0, 0, 0, 764, 766, 3, 200,
        100, 0, 765, 767, 3, 224, 112, 0, 766, 765, 1, 0, 0, 0, 766, 767, 1, 0, 0, 0, 767, 89, 1, 0,
        0, 0, 768, 769, 5, 136, 0, 0, 769, 781, 5, 128, 0, 0, 770, 775, 3, 92, 46, 0, 771, 772, 5,
        133, 0, 0, 772, 774, 3, 92, 46, 0, 773, 771, 1, 0, 0, 0, 774, 777, 1, 0, 0, 0, 775, 773, 1,
        0, 0, 0, 775, 776, 1, 0, 0, 0, 776, 779, 1, 0, 0, 0, 777, 775, 1, 0, 0, 0, 778, 780, 5, 133,
        0, 0, 779, 778, 1, 0, 0, 0, 779, 780, 1, 0, 0, 0, 780, 782, 1, 0, 0, 0, 781, 770, 1, 0, 0,
        0, 781, 782, 1, 0, 0, 0, 782, 783, 1, 0, 0, 0, 783, 784, 5, 129, 0, 0, 784, 91, 1, 0, 0, 0,
        785, 786, 3, 286, 143, 0, 786, 787, 5, 143, 0, 0, 787, 788, 3, 282, 141, 0, 788, 93, 1, 0,
        0, 0, 789, 790, 5, 136, 0, 0, 790, 795, 5, 130, 0, 0, 791, 793, 3, 280, 140, 0, 792, 794, 5,
        133, 0, 0, 793, 792, 1, 0, 0, 0, 793, 794, 1, 0, 0, 0, 794, 796, 1, 0, 0, 0, 795, 791, 1, 0,
        0, 0, 795, 796, 1, 0, 0, 0, 796, 797, 1, 0, 0, 0, 797, 798, 5, 131, 0, 0, 798, 95, 1, 0, 0,
        0, 799, 800, 5, 136, 0, 0, 800, 801, 5, 126, 0, 0, 801, 802, 3, 282, 141, 0, 802, 803, 5,
        127, 0, 0, 803, 810, 1, 0, 0, 0, 804, 807, 5, 136, 0, 0, 805, 808, 3, 306, 153, 0, 806, 808,
        3, 310, 155, 0, 807, 805, 1, 0, 0, 0, 807, 806, 1, 0, 0, 0, 808, 810, 1, 0, 0, 0, 809, 799,
        1, 0, 0, 0, 809, 804, 1, 0, 0, 0, 810, 97, 1, 0, 0, 0, 811, 823, 5, 126, 0, 0, 812, 815, 3,
        100, 50, 0, 813, 815, 5, 32, 0, 0, 814, 812, 1, 0, 0, 0, 814, 813, 1, 0, 0, 0, 815, 820, 1,
        0, 0, 0, 816, 817, 5, 133, 0, 0, 817, 819, 3, 100, 50, 0, 818, 816, 1, 0, 0, 0, 819, 822, 1,
        0, 0, 0, 820, 818, 1, 0, 0, 0, 820, 821, 1, 0, 0, 0, 821, 824, 1, 0, 0, 0, 822, 820, 1, 0,
        0, 0, 823, 814, 1, 0, 0, 0, 823, 824, 1, 0, 0, 0, 824, 825, 1, 0, 0, 0, 825, 826, 5, 127, 0,
        0, 826, 99, 1, 0, 0, 0, 827, 830, 3, 122, 61, 0, 828, 830, 3, 236, 118, 0, 829, 827, 1, 0,
        0, 0, 829, 828, 1, 0, 0, 0, 830, 101, 1, 0, 0, 0, 831, 833, 5, 158, 0, 0, 832, 834, 3, 200,
        100, 0, 833, 832, 1, 0, 0, 0, 833, 834, 1, 0, 0, 0, 834, 836, 1, 0, 0, 0, 835, 837, 3, 190,
        95, 0, 836, 835, 1, 0, 0, 0, 836, 837, 1, 0, 0, 0, 837, 839, 1, 0, 0, 0, 838, 840, 3, 98,
        49, 0, 839, 838, 1, 0, 0, 0, 839, 840, 1, 0, 0, 0, 840, 841, 1, 0, 0, 0, 841, 842, 3, 254,
        127, 0, 842, 103, 1, 0, 0, 0, 843, 844, 5, 130, 0, 0, 844, 845, 3, 106, 53, 0, 845, 846, 3,
        108, 54, 0, 846, 847, 5, 131, 0, 0, 847, 105, 1, 0, 0, 0, 848, 851, 3, 282, 141, 0, 849,
        851, 3, 24, 12, 0, 850, 848, 1, 0, 0, 0, 850, 849, 1, 0, 0, 0, 851, 107, 1, 0, 0, 0, 852,
        859, 3, 74, 37, 0, 853, 855, 3, 110, 55, 0, 854, 853, 1, 0, 0, 0, 855, 856, 1, 0, 0, 0, 856,
        854, 1, 0, 0, 0, 856, 857, 1, 0, 0, 0, 857, 859, 1, 0, 0, 0, 858, 852, 1, 0, 0, 0, 858, 854,
        1, 0, 0, 0, 859, 109, 1, 0, 0, 0, 860, 862, 3, 74, 37, 0, 861, 860, 1, 0, 0, 0, 861, 862, 1,
        0, 0, 0, 862, 863, 1, 0, 0, 0, 863, 864, 5, 143, 0, 0, 864, 869, 3, 112, 56, 0, 865, 866, 5,
        133, 0, 0, 866, 868, 3, 112, 56, 0, 867, 865, 1, 0, 0, 0, 868, 871, 1, 0, 0, 0, 869, 867, 1,
        0, 0, 0, 869, 870, 1, 0, 0, 0, 870, 111, 1, 0, 0, 0, 871, 869, 1, 0, 0, 0, 872, 874, 3, 280,
        140, 0, 873, 875, 3, 190, 95, 0, 874, 873, 1, 0, 0, 0, 874, 875, 1, 0, 0, 0, 875, 880, 1, 0,
        0, 0, 876, 877, 5, 128, 0, 0, 877, 878, 3, 234, 117, 0, 878, 879, 5, 129, 0, 0, 879, 881, 1,
        0, 0, 0, 880, 876, 1, 0, 0, 0, 880, 881, 1, 0, 0, 0, 881, 113, 1, 0, 0, 0, 882, 883, 5, 76,
        0, 0, 883, 884, 5, 126, 0, 0, 884, 885, 3, 116, 58, 0, 885, 886, 5, 127, 0, 0, 886, 115, 1,
        0, 0, 0, 887, 897, 3, 74, 37, 0, 888, 890, 3, 74, 37, 0, 889, 888, 1, 0, 0, 0, 889, 890, 1,
        0, 0, 0, 890, 891, 1, 0, 0, 0, 891, 893, 5, 143, 0, 0, 892, 889, 1, 0, 0, 0, 893, 894, 1, 0,
        0, 0, 894, 892, 1, 0, 0, 0, 894, 895, 1, 0, 0, 0, 895, 897, 1, 0, 0, 0, 896, 887, 1, 0, 0,
        0, 896, 892, 1, 0, 0, 0, 897, 117, 1, 0, 0, 0, 898, 899, 5, 69, 0, 0, 899, 900, 5, 126, 0,
        0, 900, 901, 3, 46, 23, 0, 901, 902, 5, 127, 0, 0, 902, 119, 1, 0, 0, 0, 903, 904, 5, 62, 0,
        0, 904, 905, 5, 126, 0, 0, 905, 906, 3, 236, 118, 0, 906, 907, 5, 127, 0, 0, 907, 121, 1, 0,
        0, 0, 908, 909, 3, 172, 86, 0, 909, 910, 3, 246, 123, 0, 910, 123, 1, 0, 0, 0, 911, 912, 5,
        79, 0, 0, 912, 913, 5, 126, 0, 0, 913, 914, 3, 310, 155, 0, 914, 915, 5, 127, 0, 0, 915,
        919, 1, 0, 0, 0, 916, 917, 5, 79, 0, 0, 917, 919, 3, 282, 141, 0, 918, 911, 1, 0, 0, 0, 918,
        916, 1, 0, 0, 0, 919, 125, 1, 0, 0, 0, 920, 921, 5, 80, 0, 0, 921, 925, 3, 254, 127, 0, 922,
        924, 3, 128, 64, 0, 923, 922, 1, 0, 0, 0, 924, 927, 1, 0, 0, 0, 925, 923, 1, 0, 0, 0, 925,
        926, 1, 0, 0, 0, 926, 930, 1, 0, 0, 0, 927, 925, 1, 0, 0, 0, 928, 929, 5, 64, 0, 0, 929,
        931, 3, 254, 127, 0, 930, 928, 1, 0, 0, 0, 930, 931, 1, 0, 0, 0, 931, 127, 1, 0, 0, 0, 932,
        933, 5, 59, 0, 0, 933, 934, 5, 126, 0, 0, 934, 935, 3, 122, 61, 0, 935, 936, 5, 127, 0, 0,
        936, 937, 3, 254, 127, 0, 937, 129, 1, 0, 0, 0, 938, 939, 5, 77, 0, 0, 939, 940, 5, 126, 0,
        0, 940, 941, 3, 282, 141, 0, 941, 942, 5, 127, 0, 0, 942, 943, 3, 254, 127, 0, 943, 131, 1,
        0, 0, 0, 944, 945, 5, 58, 0, 0, 945, 946, 3, 254, 127, 0, 946, 133, 1, 0, 0, 0, 947, 948, 3,
        138, 69, 0, 948, 949, 5, 132, 0, 0, 949, 135, 1, 0, 0, 0, 950, 951, 3, 138, 69, 0, 951, 952,
        3, 254, 127, 0, 952, 137, 1, 0, 0, 0, 953, 955, 3, 172, 86, 0, 954, 953, 1, 0, 0, 0, 954,
        955, 1, 0, 0, 0, 955, 956, 1, 0, 0, 0, 956, 957, 3, 310, 155, 0, 957, 959, 5, 126, 0, 0,
        958, 960, 3, 222, 111, 0, 959, 958, 1, 0, 0, 0, 959, 960, 1, 0, 0, 0, 960, 961, 1, 0, 0, 0,
        961, 962, 5, 127, 0, 0, 962, 964, 1, 0, 0, 0, 963, 965, 3, 174, 87, 0, 964, 963, 1, 0, 0, 0,
        964, 965, 1, 0, 0, 0, 965, 139, 1, 0, 0, 0, 966, 968, 3, 142, 71, 0, 967, 969, 3, 144, 72,
        0, 968, 967, 1, 0, 0, 0, 968, 969, 1, 0, 0, 0, 969, 141, 1, 0, 0, 0, 970, 973, 5, 5, 0, 0,
        971, 973, 3, 310, 155, 0, 972, 970, 1, 0, 0, 0, 972, 971, 1, 0, 0, 0, 973, 143, 1, 0, 0, 0,
        974, 976, 5, 126, 0, 0, 975, 977, 3, 146, 73, 0, 976, 975, 1, 0, 0, 0, 976, 977, 1, 0, 0, 0,
        977, 978, 1, 0, 0, 0, 978, 979, 5, 127, 0, 0, 979, 145, 1, 0, 0, 0, 980, 985, 3, 148, 74, 0,
        981, 982, 5, 133, 0, 0, 982, 984, 3, 148, 74, 0, 983, 981, 1, 0, 0, 0, 984, 987, 1, 0, 0, 0,
        985, 983, 1, 0, 0, 0, 985, 986, 1, 0, 0, 0, 986, 147, 1, 0, 0, 0, 987, 985, 1, 0, 0, 0, 988,
        993, 3, 140, 70, 0, 989, 993, 3, 306, 153, 0, 990, 993, 3, 308, 154, 0, 991, 993, 3, 150,
        75, 0, 992, 988, 1, 0, 0, 0, 992, 989, 1, 0, 0, 0, 992, 990, 1, 0, 0, 0, 992, 991, 1, 0, 0,
        0, 993, 149, 1, 0, 0, 0, 994, 995, 3, 142, 71, 0, 995, 999, 5, 137, 0, 0, 996, 1000, 3, 306,
        153, 0, 997, 1000, 3, 142, 71, 0, 998, 1000, 3, 308, 154, 0, 999, 996, 1, 0, 0, 0, 999, 997,
        1, 0, 0, 0, 999, 998, 1, 0, 0, 0, 1000, 151, 1, 0, 0, 0, 1001, 1009, 3, 162, 81, 0, 1002,
        1003, 3, 154, 77, 0, 1003, 1004, 5, 132, 0, 0, 1004, 1009, 1, 0, 0, 0, 1005, 1009, 3, 164,
        82, 0, 1006, 1009, 3, 166, 83, 0, 1007, 1009, 3, 168, 84, 0, 1008, 1001, 1, 0, 0, 0, 1008,
        1002, 1, 0, 0, 0, 1008, 1005, 1, 0, 0, 0, 1008, 1006, 1, 0, 0, 0, 1008, 1007, 1, 0, 0, 0,
        1009, 153, 1, 0, 0, 0, 1010, 1011, 3, 172, 86, 0, 1011, 1012, 5, 126, 0, 0, 1012, 1014, 5,
        154, 0, 0, 1013, 1015, 3, 310, 155, 0, 1014, 1013, 1, 0, 0, 0, 1014, 1015, 1, 0, 0, 0, 1015,
        1016, 1, 0, 0, 0, 1016, 1017, 5, 127, 0, 0, 1017, 1019, 5, 126, 0, 0, 1018, 1020, 3, 156,
        78, 0, 1019, 1018, 1, 0, 0, 0, 1019, 1020, 1, 0, 0, 0, 1020, 1021, 1, 0, 0, 0, 1021, 1022,
        5, 127, 0, 0, 1022, 155, 1, 0, 0, 0, 1023, 1026, 3, 158, 79, 0, 1024, 1025, 5, 133, 0, 0,
        1025, 1027, 5, 170, 0, 0, 1026, 1024, 1, 0, 0, 0, 1026, 1027, 1, 0, 0, 0, 1027, 157, 1, 0,
        0, 0, 1028, 1033, 3, 160, 80, 0, 1029, 1030, 5, 133, 0, 0, 1030, 1032, 3, 160, 80, 0, 1031,
        1029, 1, 0, 0, 0, 1032, 1035, 1, 0, 0, 0, 1033, 1031, 1, 0, 0, 0, 1033, 1034, 1, 0, 0, 0,
        1034, 159, 1, 0, 0, 0, 1035, 1033, 1, 0, 0, 0, 1036, 1039, 3, 172, 86, 0, 1037, 1039, 3,
        154, 77, 0, 1038, 1036, 1, 0, 0, 0, 1038, 1037, 1, 0, 0, 0, 1039, 1041, 1, 0, 0, 0, 1040,
        1042, 3, 246, 123, 0, 1041, 1040, 1, 0, 0, 0, 1041, 1042, 1, 0, 0, 0, 1042, 1045, 1, 0, 0,
        0, 1043, 1045, 5, 32, 0, 0, 1044, 1038, 1, 0, 0, 0, 1044, 1043, 1, 0, 0, 0, 1045, 161, 1, 0,
        0, 0, 1046, 1048, 3, 174, 87, 0, 1047, 1046, 1, 0, 0, 0, 1047, 1048, 1, 0, 0, 0, 1048, 1049,
        1, 0, 0, 0, 1049, 1051, 3, 310, 155, 0, 1050, 1052, 3, 174, 87, 0, 1051, 1050, 1, 0, 0, 0,
        1051, 1052, 1, 0, 0, 0, 1052, 1053, 1, 0, 0, 0, 1053, 1054, 5, 126, 0, 0, 1054, 1055, 3,
        218, 109, 0, 1055, 1056, 5, 127, 0, 0, 1056, 1057, 5, 132, 0, 0, 1057, 163, 1, 0, 0, 0,
        1058, 1060, 3, 174, 87, 0, 1059, 1058, 1, 0, 0, 0, 1059, 1060, 1, 0, 0, 0, 1060, 1062, 1, 0,
        0, 0, 1061, 1063, 5, 29, 0, 0, 1062, 1061, 1, 0, 0, 0, 1062, 1063, 1, 0, 0, 0, 1063, 1064,
        1, 0, 0, 0, 1064, 1066, 3, 210, 105, 0, 1065, 1067, 3, 310, 155, 0, 1066, 1065, 1, 0, 0, 0,
        1066, 1067, 1, 0, 0, 0, 1067, 1068, 1, 0, 0, 0, 1068, 1069, 5, 132, 0, 0, 1069, 165, 1, 0,
        0, 0, 1070, 1071, 3, 172, 86, 0, 1071, 1072, 3, 176, 88, 0, 1072, 1075, 1, 0, 0, 0, 1073,
        1075, 3, 172, 86, 0, 1074, 1070, 1, 0, 0, 0, 1074, 1073, 1, 0, 0, 0, 1075, 1076, 1, 0, 0, 0,
        1076, 1077, 5, 132, 0, 0, 1077, 167, 1, 0, 0, 0, 1078, 1080, 3, 174, 87, 0, 1079, 1078, 1,
        0, 0, 0, 1079, 1080, 1, 0, 0, 0, 1080, 1081, 1, 0, 0, 0, 1081, 1086, 5, 29, 0, 0, 1082,
        1083, 3, 172, 86, 0, 1083, 1084, 3, 170, 85, 0, 1084, 1087, 1, 0, 0, 0, 1085, 1087, 3, 172,
        86, 0, 1086, 1082, 1, 0, 0, 0, 1086, 1085, 1, 0, 0, 0, 1087, 1089, 1, 0, 0, 0, 1088, 1090,
        3, 226, 113, 0, 1089, 1088, 1, 0, 0, 0, 1089, 1090, 1, 0, 0, 0, 1090, 1091, 1, 0, 0, 0,
        1091, 1092, 5, 132, 0, 0, 1092, 1101, 1, 0, 0, 0, 1093, 1095, 3, 174, 87, 0, 1094, 1093, 1,
        0, 0, 0, 1094, 1095, 1, 0, 0, 0, 1095, 1096, 1, 0, 0, 0, 1096, 1097, 5, 29, 0, 0, 1097,
        1098, 3, 154, 77, 0, 1098, 1099, 5, 132, 0, 0, 1099, 1101, 1, 0, 0, 0, 1100, 1079, 1, 0, 0,
        0, 1100, 1094, 1, 0, 0, 0, 1101, 169, 1, 0, 0, 0, 1102, 1107, 3, 246, 123, 0, 1103, 1104, 5,
        133, 0, 0, 1104, 1106, 3, 246, 123, 0, 1105, 1103, 1, 0, 0, 0, 1106, 1109, 1, 0, 0, 0, 1107,
        1105, 1, 0, 0, 0, 1107, 1108, 1, 0, 0, 0, 1108, 171, 1, 0, 0, 0, 1109, 1107, 1, 0, 0, 0,
        1110, 1119, 3, 192, 96, 0, 1111, 1119, 3, 174, 87, 0, 1112, 1119, 3, 188, 94, 0, 1113, 1119,
        3, 190, 95, 0, 1114, 1119, 3, 186, 93, 0, 1115, 1119, 3, 194, 97, 0, 1116, 1119, 3, 196, 98,
        0, 1117, 1119, 3, 200, 100, 0, 1118, 1110, 1, 0, 0, 0, 1118, 1111, 1, 0, 0, 0, 1118, 1112,
        1, 0, 0, 0, 1118, 1113, 1, 0, 0, 0, 1118, 1114, 1, 0, 0, 0, 1118, 1115, 1, 0, 0, 0, 1118,
        1116, 1, 0, 0, 0, 1118, 1117, 1, 0, 0, 0, 1119, 1120, 1, 0, 0, 0, 1120, 1118, 1, 0, 0, 0,
        1120, 1121, 1, 0, 0, 0, 1121, 173, 1, 0, 0, 0, 1122, 1123, 5, 84, 0, 0, 1123, 1124, 5, 126,
        0, 0, 1124, 1125, 5, 126, 0, 0, 1125, 1130, 3, 140, 70, 0, 1126, 1127, 5, 133, 0, 0, 1127,
        1129, 3, 140, 70, 0, 1128, 1126, 1, 0, 0, 0, 1129, 1132, 1, 0, 0, 0, 1130, 1128, 1, 0, 0, 0,
        1130, 1131, 1, 0, 0, 0, 1131, 1133, 1, 0, 0, 0, 1132, 1130, 1, 0, 0, 0, 1133, 1134, 5, 127,
        0, 0, 1134, 1135, 5, 127, 0, 0, 1135, 175, 1, 0, 0, 0, 1136, 1141, 3, 178, 89, 0, 1137,
        1138, 5, 133, 0, 0, 1138, 1140, 3, 178, 89, 0, 1139, 1137, 1, 0, 0, 0, 1140, 1143, 1, 0, 0,
        0, 1141, 1139, 1, 0, 0, 0, 1141, 1142, 1, 0, 0, 0, 1142, 177, 1, 0, 0, 0, 1143, 1141, 1, 0,
        0, 0, 1144, 1147, 3, 246, 123, 0, 1145, 1146, 5, 137, 0, 0, 1146, 1148, 3, 288, 144, 0,
        1147, 1145, 1, 0, 0, 0, 1147, 1148, 1, 0, 0, 0, 1148, 179, 1, 0, 0, 0, 1149, 1153, 7, 3, 0,
        0, 1150, 1152, 3, 174, 87, 0, 1151, 1150, 1, 0, 0, 0, 1152, 1155, 1, 0, 0, 0, 1153, 1151, 1,
        0, 0, 0, 1153, 1154, 1, 0, 0, 0, 1154, 1168, 1, 0, 0, 0, 1155, 1153, 1, 0, 0, 0, 1156, 1169,
        3, 310, 155, 0, 1157, 1159, 3, 310, 155, 0, 1158, 1157, 1, 0, 0, 0, 1158, 1159, 1, 0, 0, 0,
        1159, 1160, 1, 0, 0, 0, 1160, 1162, 5, 128, 0, 0, 1161, 1163, 3, 182, 91, 0, 1162, 1161, 1,
        0, 0, 0, 1163, 1164, 1, 0, 0, 0, 1164, 1162, 1, 0, 0, 0, 1164, 1165, 1, 0, 0, 0, 1165, 1166,
        1, 0, 0, 0, 1166, 1167, 5, 129, 0, 0, 1167, 1169, 1, 0, 0, 0, 1168, 1156, 1, 0, 0, 0, 1168,
        1158, 1, 0, 0, 0, 1169, 181, 1, 0, 0, 0, 1170, 1171, 3, 184, 92, 0, 1171, 1173, 3, 206, 103,
        0, 1172, 1174, 3, 226, 113, 0, 1173, 1172, 1, 0, 0, 0, 1173, 1174, 1, 0, 0, 0, 1174, 1175,
        1, 0, 0, 0, 1175, 1176, 5, 132, 0, 0, 1176, 1181, 1, 0, 0, 0, 1177, 1178, 3, 154, 77, 0,
        1178, 1179, 5, 132, 0, 0, 1179, 1181, 1, 0, 0, 0, 1180, 1170, 1, 0, 0, 0, 1180, 1177, 1, 0,
        0, 0, 1181, 183, 1, 0, 0, 0, 1182, 1189, 3, 188, 94, 0, 1183, 1189, 3, 190, 95, 0, 1184,
        1189, 3, 186, 93, 0, 1185, 1189, 3, 194, 97, 0, 1186, 1189, 3, 196, 98, 0, 1187, 1189, 3,
        200, 100, 0, 1188, 1182, 1, 0, 0, 0, 1188, 1183, 1, 0, 0, 0, 1188, 1184, 1, 0, 0, 0, 1188,
        1185, 1, 0, 0, 0, 1188, 1186, 1, 0, 0, 0, 1188, 1187, 1, 0, 0, 0, 1189, 1190, 1, 0, 0, 0,
        1190, 1188, 1, 0, 0, 0, 1190, 1191, 1, 0, 0, 0, 1191, 185, 1, 0, 0, 0, 1192, 1193, 5, 116,
        0, 0, 1193, 1194, 5, 126, 0, 0, 1194, 1195, 3, 310, 155, 0, 1195, 1196, 5, 127, 0, 0, 1196,
        1199, 1, 0, 0, 0, 1197, 1199, 5, 115, 0, 0, 1198, 1192, 1, 0, 0, 0, 1198, 1197, 1, 0, 0, 0,
        1199, 187, 1, 0, 0, 0, 1200, 1201, 7, 4, 0, 0, 1201, 189, 1, 0, 0, 0, 1202, 1203, 7, 5, 0,
        0, 1203, 191, 1, 0, 0, 0, 1204, 1205, 7, 6, 0, 0, 1205, 193, 1, 0, 0, 0, 1206, 1207, 7, 7,
        0, 0, 1207, 195, 1, 0, 0, 0, 1208, 1213, 5, 5, 0, 0, 1209, 1213, 5, 33, 0, 0, 1210, 1213, 5,
        21, 0, 0, 1211, 1213, 3, 198, 99, 0, 1212, 1208, 1, 0, 0, 0, 1212, 1209, 1, 0, 0, 0, 1212,
        1210, 1, 0, 0, 0, 1212, 1211, 1, 0, 0, 0, 1213, 197, 1, 0, 0, 0, 1214, 1215, 7, 8, 0, 0,
        1215, 199, 1, 0, 0, 0, 1216, 1218, 3, 202, 101, 0, 1217, 1219, 3, 224, 112, 0, 1218, 1217,
        1, 0, 0, 0, 1218, 1219, 1, 0, 0, 0, 1219, 1241, 1, 0, 0, 0, 1220, 1241, 3, 204, 102, 0,
        1221, 1223, 5, 93, 0, 0, 1222, 1221, 1, 0, 0, 0, 1222, 1223, 1, 0, 0, 0, 1223, 1224, 1, 0,
        0, 0, 1224, 1226, 3, 24, 12, 0, 1225, 1227, 3, 224, 112, 0, 1226, 1225, 1, 0, 0, 0, 1226,
        1227, 1, 0, 0, 0, 1227, 1241, 1, 0, 0, 0, 1228, 1230, 3, 180, 90, 0, 1229, 1231, 3, 224,
        112, 0, 1230, 1229, 1, 0, 0, 0, 1230, 1231, 1, 0, 0, 0, 1231, 1241, 1, 0, 0, 0, 1232, 1241,
        3, 210, 105, 0, 1233, 1235, 5, 93, 0, 0, 1234, 1233, 1, 0, 0, 0, 1234, 1235, 1, 0, 0, 0,
        1235, 1236, 1, 0, 0, 0, 1236, 1238, 3, 310, 155, 0, 1237, 1239, 3, 224, 112, 0, 1238, 1237,
        1, 0, 0, 0, 1238, 1239, 1, 0, 0, 0, 1239, 1241, 1, 0, 0, 0, 1240, 1216, 1, 0, 0, 0, 1240,
        1220, 1, 0, 0, 0, 1240, 1222, 1, 0, 0, 0, 1240, 1228, 1, 0, 0, 0, 1240, 1232, 1, 0, 0, 0,
        1240, 1234, 1, 0, 0, 0, 1241, 201, 1, 0, 0, 0, 1242, 1243, 7, 9, 0, 0, 1243, 203, 1, 0, 0,
        0, 1244, 1245, 5, 95, 0, 0, 1245, 1246, 5, 126, 0, 0, 1246, 1247, 3, 282, 141, 0, 1247,
        1248, 5, 127, 0, 0, 1248, 205, 1, 0, 0, 0, 1249, 1254, 3, 208, 104, 0, 1250, 1251, 5, 133,
        0, 0, 1251, 1253, 3, 208, 104, 0, 1252, 1250, 1, 0, 0, 0, 1253, 1256, 1, 0, 0, 0, 1254,
        1252, 1, 0, 0, 0, 1254, 1255, 1, 0, 0, 0, 1255, 207, 1, 0, 0, 0, 1256, 1254, 1, 0, 0, 0,
        1257, 1264, 3, 246, 123, 0, 1258, 1260, 3, 246, 123, 0, 1259, 1258, 1, 0, 0, 0, 1259, 1260,
        1, 0, 0, 0, 1260, 1261, 1, 0, 0, 0, 1261, 1262, 5, 143, 0, 0, 1262, 1264, 3, 306, 153, 0,
        1263, 1257, 1, 0, 0, 0, 1263, 1259, 1, 0, 0, 0, 1264, 209, 1, 0, 0, 0, 1265, 1271, 5, 11, 0,
        0, 1266, 1268, 3, 310, 155, 0, 1267, 1266, 1, 0, 0, 0, 1267, 1268, 1, 0, 0, 0, 1268, 1269,
        1, 0, 0, 0, 1269, 1270, 5, 143, 0, 0, 1270, 1272, 3, 236, 118, 0, 1271, 1267, 1, 0, 0, 0,
        1271, 1272, 1, 0, 0, 0, 1272, 1284, 1, 0, 0, 0, 1273, 1278, 3, 310, 155, 0, 1274, 1275, 5,
        128, 0, 0, 1275, 1276, 3, 212, 106, 0, 1276, 1277, 5, 129, 0, 0, 1277, 1279, 1, 0, 0, 0,
        1278, 1274, 1, 0, 0, 0, 1278, 1279, 1, 0, 0, 0, 1279, 1285, 1, 0, 0, 0, 1280, 1281, 5, 128,
        0, 0, 1281, 1282, 3, 212, 106, 0, 1282, 1283, 5, 129, 0, 0, 1283, 1285, 1, 0, 0, 0, 1284,
        1273, 1, 0, 0, 0, 1284, 1280, 1, 0, 0, 0, 1285, 1297, 1, 0, 0, 0, 1286, 1287, 7, 10, 0, 0,
        1287, 1288, 5, 126, 0, 0, 1288, 1289, 3, 236, 118, 0, 1289, 1290, 5, 133, 0, 0, 1290, 1291,
        3, 310, 155, 0, 1291, 1292, 5, 127, 0, 0, 1292, 1293, 5, 128, 0, 0, 1293, 1294, 3, 212, 106,
        0, 1294, 1295, 5, 129, 0, 0, 1295, 1297, 1, 0, 0, 0, 1296, 1265, 1, 0, 0, 0, 1296, 1286, 1,
        0, 0, 0, 1297, 211, 1, 0, 0, 0, 1298, 1303, 3, 214, 107, 0, 1299, 1300, 5, 133, 0, 0, 1300,
        1302, 3, 214, 107, 0, 1301, 1299, 1, 0, 0, 0, 1302, 1305, 1, 0, 0, 0, 1303, 1301, 1, 0, 0,
        0, 1303, 1304, 1, 0, 0, 0, 1304, 1307, 1, 0, 0, 0, 1305, 1303, 1, 0, 0, 0, 1306, 1308, 5,
        133, 0, 0, 1307, 1306, 1, 0, 0, 0, 1307, 1308, 1, 0, 0, 0, 1308, 213, 1, 0, 0, 0, 1309,
        1312, 3, 216, 108, 0, 1310, 1311, 5, 137, 0, 0, 1311, 1313, 3, 282, 141, 0, 1312, 1310, 1,
        0, 0, 0, 1312, 1313, 1, 0, 0, 0, 1313, 215, 1, 0, 0, 0, 1314, 1315, 3, 310, 155, 0, 1315,
        217, 1, 0, 0, 0, 1316, 1322, 3, 310, 155, 0, 1317, 1318, 5, 126, 0, 0, 1318, 1319, 3, 246,
        123, 0, 1319, 1320, 5, 127, 0, 0, 1320, 1322, 1, 0, 0, 0, 1321, 1316, 1, 0, 0, 0, 1321,
        1317, 1, 0, 0, 0, 1322, 1326, 1, 0, 0, 0, 1323, 1325, 3, 220, 110, 0, 1324, 1323, 1, 0, 0,
        0, 1325, 1328, 1, 0, 0, 0, 1326, 1324, 1, 0, 0, 0, 1326, 1327, 1, 0, 0, 0, 1327, 1330, 1, 0,
        0, 0, 1328, 1326, 1, 0, 0, 0, 1329, 1331, 3, 174, 87, 0, 1330, 1329, 1, 0, 0, 0, 1330, 1331,
        1, 0, 0, 0, 1331, 1353, 1, 0, 0, 0, 1332, 1333, 5, 126, 0, 0, 1333, 1335, 5, 158, 0, 0,
        1334, 1336, 3, 190, 95, 0, 1335, 1334, 1, 0, 0, 0, 1335, 1336, 1, 0, 0, 0, 1336, 1338, 1, 0,
        0, 0, 1337, 1339, 3, 310, 155, 0, 1338, 1337, 1, 0, 0, 0, 1338, 1339, 1, 0, 0, 0, 1339,
        1340, 1, 0, 0, 0, 1340, 1341, 5, 127, 0, 0, 1341, 1353, 3, 98, 49, 0, 1342, 1343, 5, 126, 0,
        0, 1343, 1345, 5, 154, 0, 0, 1344, 1346, 3, 190, 95, 0, 1345, 1344, 1, 0, 0, 0, 1345, 1346,
        1, 0, 0, 0, 1346, 1348, 1, 0, 0, 0, 1347, 1349, 3, 310, 155, 0, 1348, 1347, 1, 0, 0, 0,
        1348, 1349, 1, 0, 0, 0, 1349, 1350, 1, 0, 0, 0, 1350, 1351, 5, 127, 0, 0, 1351, 1353, 3, 98,
        49, 0, 1352, 1321, 1, 0, 0, 0, 1352, 1332, 1, 0, 0, 0, 1352, 1342, 1, 0, 0, 0, 1353, 219, 1,
        0, 0, 0, 1354, 1356, 5, 130, 0, 0, 1355, 1357, 3, 290, 145, 0, 1356, 1355, 1, 0, 0, 0, 1356,
        1357, 1, 0, 0, 0, 1357, 1358, 1, 0, 0, 0, 1358, 1359, 5, 131, 0, 0, 1359, 221, 1, 0, 0, 0,
        1360, 1363, 3, 242, 121, 0, 1361, 1362, 5, 133, 0, 0, 1362, 1364, 5, 170, 0, 0, 1363, 1361,
        1, 0, 0, 0, 1363, 1364, 1, 0, 0, 0, 1364, 223, 1, 0, 0, 0, 1365, 1367, 5, 154, 0, 0, 1366,
        1368, 3, 172, 86, 0, 1367, 1366, 1, 0, 0, 0, 1367, 1368, 1, 0, 0, 0, 1368, 1370, 1, 0, 0, 0,
        1369, 1371, 3, 224, 112, 0, 1370, 1369, 1, 0, 0, 0, 1370, 1371, 1, 0, 0, 0, 1371, 225, 1, 0,
        0, 0, 1372, 1384, 3, 310, 155, 0, 1373, 1374, 5, 126, 0, 0, 1374, 1379, 3, 304, 152, 0,
        1375, 1376, 5, 133, 0, 0, 1376, 1378, 3, 304, 152, 0, 1377, 1375, 1, 0, 0, 0, 1378, 1381, 1,
        0, 0, 0, 1379, 1377, 1, 0, 0, 0, 1379, 1380, 1, 0, 0, 0, 1380, 1382, 1, 0, 0, 0, 1381, 1379,
        1, 0, 0, 0, 1382, 1383, 5, 127, 0, 0, 1383, 1385, 1, 0, 0, 0, 1384, 1373, 1, 0, 0, 0, 1384,
        1385, 1, 0, 0, 0, 1385, 227, 1, 0, 0, 0, 1386, 1398, 5, 128, 0, 0, 1387, 1392, 3, 282, 141,
        0, 1388, 1389, 5, 133, 0, 0, 1389, 1391, 3, 282, 141, 0, 1390, 1388, 1, 0, 0, 0, 1391, 1394,
        1, 0, 0, 0, 1392, 1390, 1, 0, 0, 0, 1392, 1393, 1, 0, 0, 0, 1393, 1396, 1, 0, 0, 0, 1394,
        1392, 1, 0, 0, 0, 1395, 1397, 5, 133, 0, 0, 1396, 1395, 1, 0, 0, 0, 1396, 1397, 1, 0, 0, 0,
        1397, 1399, 1, 0, 0, 0, 1398, 1387, 1, 0, 0, 0, 1398, 1399, 1, 0, 0, 0, 1399, 1400, 1, 0, 0,
        0, 1400, 1401, 5, 129, 0, 0, 1401, 229, 1, 0, 0, 0, 1402, 1414, 5, 128, 0, 0, 1403, 1408, 3,
        232, 116, 0, 1404, 1405, 5, 133, 0, 0, 1405, 1407, 3, 232, 116, 0, 1406, 1404, 1, 0, 0, 0,
        1407, 1410, 1, 0, 0, 0, 1408, 1406, 1, 0, 0, 0, 1408, 1409, 1, 0, 0, 0, 1409, 1412, 1, 0, 0,
        0, 1410, 1408, 1, 0, 0, 0, 1411, 1413, 5, 133, 0, 0, 1412, 1411, 1, 0, 0, 0, 1412, 1413, 1,
        0, 0, 0, 1413, 1415, 1, 0, 0, 0, 1414, 1403, 1, 0, 0, 0, 1414, 1415, 1, 0, 0, 0, 1415, 1416,
        1, 0, 0, 0, 1416, 1417, 5, 129, 0, 0, 1417, 231, 1, 0, 0, 0, 1418, 1419, 5, 134, 0, 0, 1419,
        1423, 3, 282, 141, 0, 1420, 1423, 3, 230, 115, 0, 1421, 1423, 3, 228, 114, 0, 1422, 1418, 1,
        0, 0, 0, 1422, 1420, 1, 0, 0, 0, 1422, 1421, 1, 0, 0, 0, 1423, 233, 1, 0, 0, 0, 1424, 1429,
        3, 288, 144, 0, 1425, 1426, 5, 133, 0, 0, 1426, 1428, 3, 288, 144, 0, 1427, 1425, 1, 0, 0,
        0, 1428, 1431, 1, 0, 0, 0, 1429, 1427, 1, 0, 0, 0, 1429, 1430, 1, 0, 0, 0, 1430, 1433, 1, 0,
        0, 0, 1431, 1429, 1, 0, 0, 0, 1432, 1434, 5, 133, 0, 0, 1433, 1432, 1, 0, 0, 0, 1433, 1434,
        1, 0, 0, 0, 1434, 235, 1, 0, 0, 0, 1435, 1437, 3, 184, 92, 0, 1436, 1438, 3, 238, 119, 0,
        1437, 1436, 1, 0, 0, 0, 1437, 1438, 1, 0, 0, 0, 1438, 1441, 1, 0, 0, 0, 1439, 1441, 3, 84,
        42, 0, 1440, 1435, 1, 0, 0, 0, 1440, 1439, 1, 0, 0, 0, 1441, 237, 1, 0, 0, 0, 1442, 1444, 3,
        224, 112, 0, 1443, 1445, 3, 238, 119, 0, 1444, 1443, 1, 0, 0, 0, 1444, 1445, 1, 0, 0, 0,
        1445, 1466, 1, 0, 0, 0, 1446, 1448, 5, 126, 0, 0, 1447, 1449, 3, 238, 119, 0, 1448, 1447, 1,
        0, 0, 0, 1448, 1449, 1, 0, 0, 0, 1449, 1450, 1, 0, 0, 0, 1450, 1452, 5, 127, 0, 0, 1451,
        1453, 3, 240, 120, 0, 1452, 1451, 1, 0, 0, 0, 1453, 1454, 1, 0, 0, 0, 1454, 1452, 1, 0, 0,
        0, 1454, 1455, 1, 0, 0, 0, 1455, 1466, 1, 0, 0, 0, 1456, 1458, 5, 130, 0, 0, 1457, 1459, 3,
        290, 145, 0, 1458, 1457, 1, 0, 0, 0, 1458, 1459, 1, 0, 0, 0, 1459, 1460, 1, 0, 0, 0, 1460,
        1462, 5, 131, 0, 0, 1461, 1456, 1, 0, 0, 0, 1462, 1463, 1, 0, 0, 0, 1463, 1461, 1, 0, 0, 0,
        1463, 1464, 1, 0, 0, 0, 1464, 1466, 1, 0, 0, 0, 1465, 1442, 1, 0, 0, 0, 1465, 1446, 1, 0, 0,
        0, 1465, 1461, 1, 0, 0, 0, 1466, 239, 1, 0, 0, 0, 1467, 1469, 5, 130, 0, 0, 1468, 1470, 3,
        290, 145, 0, 1469, 1468, 1, 0, 0, 0, 1469, 1470, 1, 0, 0, 0, 1470, 1471, 1, 0, 0, 0, 1471,
        1478, 5, 131, 0, 0, 1472, 1474, 5, 126, 0, 0, 1473, 1475, 3, 242, 121, 0, 1474, 1473, 1, 0,
        0, 0, 1474, 1475, 1, 0, 0, 0, 1475, 1476, 1, 0, 0, 0, 1476, 1478, 5, 127, 0, 0, 1477, 1467,
        1, 0, 0, 0, 1477, 1472, 1, 0, 0, 0, 1478, 241, 1, 0, 0, 0, 1479, 1484, 3, 244, 122, 0, 1480,
        1481, 5, 133, 0, 0, 1481, 1483, 3, 244, 122, 0, 1482, 1480, 1, 0, 0, 0, 1483, 1486, 1, 0, 0,
        0, 1484, 1482, 1, 0, 0, 0, 1484, 1485, 1, 0, 0, 0, 1485, 243, 1, 0, 0, 0, 1486, 1484, 1, 0,
        0, 0, 1487, 1488, 3, 172, 86, 0, 1488, 1489, 3, 246, 123, 0, 1489, 1493, 1, 0, 0, 0, 1490,
        1493, 3, 154, 77, 0, 1491, 1493, 5, 32, 0, 0, 1492, 1487, 1, 0, 0, 0, 1492, 1490, 1, 0, 0,
        0, 1492, 1491, 1, 0, 0, 0, 1493, 245, 1, 0, 0, 0, 1494, 1496, 3, 224, 112, 0, 1495, 1494, 1,
        0, 0, 0, 1495, 1496, 1, 0, 0, 0, 1496, 1497, 1, 0, 0, 0, 1497, 1498, 3, 218, 109, 0, 1498,
        247, 1, 0, 0, 0, 1499, 1501, 3, 250, 125, 0, 1500, 1502, 5, 132, 0, 0, 1501, 1500, 1, 0, 0,
        0, 1501, 1502, 1, 0, 0, 0, 1502, 1538, 1, 0, 0, 0, 1503, 1505, 3, 254, 127, 0, 1504, 1506,
        5, 132, 0, 0, 1505, 1504, 1, 0, 0, 0, 1505, 1506, 1, 0, 0, 0, 1506, 1538, 1, 0, 0, 0, 1507,
        1509, 3, 256, 128, 0, 1508, 1510, 5, 132, 0, 0, 1509, 1508, 1, 0, 0, 0, 1509, 1510, 1, 0, 0,
        0, 1510, 1538, 1, 0, 0, 0, 1511, 1513, 3, 266, 133, 0, 1512, 1514, 5, 132, 0, 0, 1513, 1512,
        1, 0, 0, 0, 1513, 1514, 1, 0, 0, 0, 1514, 1538, 1, 0, 0, 0, 1515, 1516, 3, 278, 139, 0,
        1516, 1517, 5, 132, 0, 0, 1517, 1538, 1, 0, 0, 0, 1518, 1520, 3, 130, 65, 0, 1519, 1521, 5,
        132, 0, 0, 1520, 1519, 1, 0, 0, 0, 1520, 1521, 1, 0, 0, 0, 1521, 1538, 1, 0, 0, 0, 1522,
        1524, 3, 132, 66, 0, 1523, 1525, 5, 132, 0, 0, 1524, 1523, 1, 0, 0, 0, 1524, 1525, 1, 0, 0,
        0, 1525, 1538, 1, 0, 0, 0, 1526, 1527, 3, 124, 62, 0, 1527, 1528, 5, 132, 0, 0, 1528, 1538,
        1, 0, 0, 0, 1529, 1531, 3, 126, 63, 0, 1530, 1532, 5, 132, 0, 0, 1531, 1530, 1, 0, 0, 0,
        1531, 1532, 1, 0, 0, 0, 1532, 1538, 1, 0, 0, 0, 1533, 1534, 3, 280, 140, 0, 1534, 1535, 5,
        132, 0, 0, 1535, 1538, 1, 0, 0, 0, 1536, 1538, 5, 132, 0, 0, 1537, 1499, 1, 0, 0, 0, 1537,
        1503, 1, 0, 0, 0, 1537, 1507, 1, 0, 0, 0, 1537, 1511, 1, 0, 0, 0, 1537, 1515, 1, 0, 0, 0,
        1537, 1518, 1, 0, 0, 0, 1537, 1522, 1, 0, 0, 0, 1537, 1526, 1, 0, 0, 0, 1537, 1529, 1, 0, 0,
        0, 1537, 1533, 1, 0, 0, 0, 1537, 1536, 1, 0, 0, 0, 1538, 249, 1, 0, 0, 0, 1539, 1540, 3,
        310, 155, 0, 1540, 1541, 5, 143, 0, 0, 1541, 1542, 3, 248, 124, 0, 1542, 251, 1, 0, 0, 0,
        1543, 1546, 3, 282, 141, 0, 1544, 1545, 5, 170, 0, 0, 1545, 1547, 3, 282, 141, 0, 1546,
        1544, 1, 0, 0, 0, 1546, 1547, 1, 0, 0, 0, 1547, 253, 1, 0, 0, 0, 1548, 1553, 5, 128, 0, 0,
        1549, 1552, 3, 152, 76, 0, 1550, 1552, 3, 248, 124, 0, 1551, 1549, 1, 0, 0, 0, 1551, 1550,
        1, 0, 0, 0, 1552, 1555, 1, 0, 0, 0, 1553, 1551, 1, 0, 0, 0, 1553, 1554, 1, 0, 0, 0, 1554,
        1556, 1, 0, 0, 0, 1555, 1553, 1, 0, 0, 0, 1556, 1557, 5, 129, 0, 0, 1557, 255, 1, 0, 0, 0,
        1558, 1559, 5, 16, 0, 0, 1559, 1560, 5, 126, 0, 0, 1560, 1561, 3, 280, 140, 0, 1561, 1562,
        5, 127, 0, 0, 1562, 1565, 3, 248, 124, 0, 1563, 1564, 5, 10, 0, 0, 1564, 1566, 3, 248, 124,
        0, 1565, 1563, 1, 0, 0, 0, 1565, 1566, 1, 0, 0, 0, 1566, 1569, 1, 0, 0, 0, 1567, 1569, 3,
        258, 129, 0, 1568, 1558, 1, 0, 0, 0, 1568, 1567, 1, 0, 0, 0, 1569, 257, 1, 0, 0, 0, 1570,
        1571, 5, 28, 0, 0, 1571, 1572, 5, 126, 0, 0, 1572, 1573, 3, 282, 141, 0, 1573, 1574, 5, 127,
        0, 0, 1574, 1575, 3, 260, 130, 0, 1575, 259, 1, 0, 0, 0, 1576, 1580, 5, 128, 0, 0, 1577,
        1579, 3, 262, 131, 0, 1578, 1577, 1, 0, 0, 0, 1579, 1582, 1, 0, 0, 0, 1580, 1578, 1, 0, 0,
        0, 1580, 1581, 1, 0, 0, 0, 1581, 1583, 1, 0, 0, 0, 1582, 1580, 1, 0, 0, 0, 1583, 1584, 5,
        129, 0, 0, 1584, 261, 1, 0, 0, 0, 1585, 1587, 3, 264, 132, 0, 1586, 1585, 1, 0, 0, 0, 1587,
        1588, 1, 0, 0, 0, 1588, 1586, 1, 0, 0, 0, 1588, 1589, 1, 0, 0, 0, 1589, 1591, 1, 0, 0, 0,
        1590, 1592, 3, 248, 124, 0, 1591, 1590, 1, 0, 0, 0, 1592, 1593, 1, 0, 0, 0, 1593, 1591, 1,
        0, 0, 0, 1593, 1594, 1, 0, 0, 0, 1594, 263, 1, 0, 0, 0, 1595, 1601, 5, 3, 0, 0, 1596, 1602,
        3, 252, 126, 0, 1597, 1598, 5, 126, 0, 0, 1598, 1599, 3, 252, 126, 0, 1599, 1600, 5, 127, 0,
        0, 1600, 1602, 1, 0, 0, 0, 1601, 1596, 1, 0, 0, 0, 1601, 1597, 1, 0, 0, 0, 1602, 1603, 1, 0,
        0, 0, 1603, 1604, 5, 143, 0, 0, 1604, 1608, 1, 0, 0, 0, 1605, 1606, 5, 7, 0, 0, 1606, 1608,
        5, 143, 0, 0, 1607, 1595, 1, 0, 0, 0, 1607, 1605, 1, 0, 0, 0, 1608, 265, 1, 0, 0, 0, 1609,
        1614, 3, 268, 134, 0, 1610, 1614, 3, 270, 135, 0, 1611, 1614, 3, 272, 136, 0, 1612, 1614, 3,
        276, 138, 0, 1613, 1609, 1, 0, 0, 0, 1613, 1610, 1, 0, 0, 0, 1613, 1611, 1, 0, 0, 0, 1613,
        1612, 1, 0, 0, 0, 1614, 267, 1, 0, 0, 0, 1615, 1616, 5, 34, 0, 0, 1616, 1617, 5, 126, 0, 0,
        1617, 1618, 3, 282, 141, 0, 1618, 1619, 5, 127, 0, 0, 1619, 1620, 3, 248, 124, 0, 1620, 269,
        1, 0, 0, 0, 1621, 1622, 5, 8, 0, 0, 1622, 1623, 3, 248, 124, 0, 1623, 1624, 5, 34, 0, 0,
        1624, 1625, 5, 126, 0, 0, 1625, 1626, 3, 282, 141, 0, 1626, 1627, 5, 127, 0, 0, 1627, 1628,
        5, 132, 0, 0, 1628, 271, 1, 0, 0, 0, 1629, 1630, 5, 14, 0, 0, 1630, 1632, 5, 126, 0, 0,
        1631, 1633, 3, 274, 137, 0, 1632, 1631, 1, 0, 0, 0, 1632, 1633, 1, 0, 0, 0, 1633, 1634, 1,
        0, 0, 0, 1634, 1636, 5, 132, 0, 0, 1635, 1637, 3, 282, 141, 0, 1636, 1635, 1, 0, 0, 0, 1636,
        1637, 1, 0, 0, 0, 1637, 1638, 1, 0, 0, 0, 1638, 1640, 5, 132, 0, 0, 1639, 1641, 3, 280, 140,
        0, 1640, 1639, 1, 0, 0, 0, 1640, 1641, 1, 0, 0, 0, 1641, 1642, 1, 0, 0, 0, 1642, 1643, 5,
        127, 0, 0, 1643, 1644, 3, 248, 124, 0, 1644, 273, 1, 0, 0, 0, 1645, 1646, 3, 172, 86, 0,
        1646, 1647, 3, 176, 88, 0, 1647, 1650, 1, 0, 0, 0, 1648, 1650, 3, 280, 140, 0, 1649, 1645,
        1, 0, 0, 0, 1649, 1648, 1, 0, 0, 0, 1650, 275, 1, 0, 0, 0, 1651, 1652, 5, 14, 0, 0, 1652,
        1653, 5, 126, 0, 0, 1653, 1654, 3, 122, 61, 0, 1654, 1656, 5, 46, 0, 0, 1655, 1657, 3, 282,
        141, 0, 1656, 1655, 1, 0, 0, 0, 1656, 1657, 1, 0, 0, 0, 1657, 1658, 1, 0, 0, 0, 1658, 1659,
        5, 127, 0, 0, 1659, 1660, 3, 248, 124, 0, 1660, 277, 1, 0, 0, 0, 1661, 1662, 5, 15, 0, 0,
        1662, 1670, 3, 310, 155, 0, 1663, 1670, 5, 6, 0, 0, 1664, 1670, 5, 2, 0, 0, 1665, 1667, 5,
        22, 0, 0, 1666, 1668, 3, 282, 141, 0, 1667, 1666, 1, 0, 0, 0, 1667, 1668, 1, 0, 0, 0, 1668,
        1670, 1, 0, 0, 0, 1669, 1661, 1, 0, 0, 0, 1669, 1663, 1, 0, 0, 0, 1669, 1664, 1, 0, 0, 0,
        1669, 1665, 1, 0, 0, 0, 1670, 279, 1, 0, 0, 0, 1671, 1676, 3, 282, 141, 0, 1672, 1673, 5,
        133, 0, 0, 1673, 1675, 3, 282, 141, 0, 1674, 1672, 1, 0, 0, 0, 1675, 1678, 1, 0, 0, 0, 1676,
        1674, 1, 0, 0, 0, 1676, 1677, 1, 0, 0, 0, 1677, 281, 1, 0, 0, 0, 1678, 1676, 1, 0, 0, 0,
        1679, 1680, 6, 141, -1, 0, 1680, 1690, 3, 286, 143, 0, 1681, 1682, 3, 292, 146, 0, 1682,
        1683, 3, 284, 142, 0, 1683, 1684, 3, 282, 141, 2, 1684, 1690, 1, 0, 0, 0, 1685, 1686, 5,
        126, 0, 0, 1686, 1687, 3, 254, 127, 0, 1687, 1688, 5, 127, 0, 0, 1688, 1690, 1, 0, 0, 0,
        1689, 1679, 1, 0, 0, 0, 1689, 1681, 1, 0, 0, 0, 1689, 1685, 1, 0, 0, 0, 1690, 1735, 1, 0, 0,
        0, 1691, 1692, 10, 13, 0, 0, 1692, 1693, 7, 11, 0, 0, 1693, 1734, 3, 282, 141, 14, 1694,
        1695, 10, 12, 0, 0, 1695, 1696, 7, 12, 0, 0, 1696, 1734, 3, 282, 141, 13, 1697, 1702, 10,
        11, 0, 0, 1698, 1699, 5, 139, 0, 0, 1699, 1703, 5, 139, 0, 0, 1700, 1701, 5, 138, 0, 0,
        1701, 1703, 5, 138, 0, 0, 1702, 1698, 1, 0, 0, 0, 1702, 1700, 1, 0, 0, 0, 1703, 1704, 1, 0,
        0, 0, 1704, 1734, 3, 282, 141, 12, 1705, 1706, 10, 10, 0, 0, 1706, 1707, 7, 13, 0, 0, 1707,
        1734, 3, 282, 141, 11, 1708, 1709, 10, 9, 0, 0, 1709, 1710, 7, 14, 0, 0, 1710, 1734, 3, 282,
        141, 10, 1711, 1712, 10, 8, 0, 0, 1712, 1713, 5, 156, 0, 0, 1713, 1734, 3, 282, 141, 9,
        1714, 1715, 10, 7, 0, 0, 1715, 1716, 5, 158, 0, 0, 1716, 1734, 3, 282, 141, 8, 1717, 1718,
        10, 6, 0, 0, 1718, 1719, 5, 157, 0, 0, 1719, 1734, 3, 282, 141, 7, 1720, 1721, 10, 5, 0, 0,
        1721, 1722, 5, 148, 0, 0, 1722, 1734, 3, 282, 141, 6, 1723, 1724, 10, 4, 0, 0, 1724, 1725,
        5, 149, 0, 0, 1725, 1734, 3, 282, 141, 5, 1726, 1727, 10, 3, 0, 0, 1727, 1729, 5, 142, 0, 0,
        1728, 1730, 3, 282, 141, 0, 1729, 1728, 1, 0, 0, 0, 1729, 1730, 1, 0, 0, 0, 1730, 1731, 1,
        0, 0, 0, 1731, 1732, 5, 143, 0, 0, 1732, 1734, 3, 282, 141, 4, 1733, 1691, 1, 0, 0, 0, 1733,
        1694, 1, 0, 0, 0, 1733, 1697, 1, 0, 0, 0, 1733, 1705, 1, 0, 0, 0, 1733, 1708, 1, 0, 0, 0,
        1733, 1711, 1, 0, 0, 0, 1733, 1714, 1, 0, 0, 0, 1733, 1717, 1, 0, 0, 0, 1733, 1720, 1, 0, 0,
        0, 1733, 1723, 1, 0, 0, 0, 1733, 1726, 1, 0, 0, 0, 1734, 1737, 1, 0, 0, 0, 1735, 1733, 1, 0,
        0, 0, 1735, 1736, 1, 0, 0, 0, 1736, 283, 1, 0, 0, 0, 1737, 1735, 1, 0, 0, 0, 1738, 1739, 7,
        15, 0, 0, 1739, 285, 1, 0, 0, 0, 1740, 1750, 3, 292, 146, 0, 1741, 1742, 5, 126, 0, 0, 1742,
        1743, 3, 236, 118, 0, 1743, 1744, 5, 127, 0, 0, 1744, 1747, 1, 0, 0, 0, 1745, 1748, 3, 286,
        143, 0, 1746, 1748, 3, 288, 144, 0, 1747, 1745, 1, 0, 0, 0, 1747, 1746, 1, 0, 0, 0, 1748,
        1750, 1, 0, 0, 0, 1749, 1740, 1, 0, 0, 0, 1749, 1741, 1, 0, 0, 0, 1750, 287, 1, 0, 0, 0,
        1751, 1755, 3, 282, 141, 0, 1752, 1755, 3, 228, 114, 0, 1753, 1755, 3, 230, 115, 0, 1754,
        1751, 1, 0, 0, 0, 1754, 1752, 1, 0, 0, 0, 1754, 1753, 1, 0, 0, 0, 1755, 289, 1, 0, 0, 0,
        1756, 1759, 3, 310, 155, 0, 1757, 1759, 3, 306, 153, 0, 1758, 1756, 1, 0, 0, 0, 1758, 1757,
        1, 0, 0, 0, 1759, 291, 1, 0, 0, 0, 1760, 1775, 3, 296, 148, 0, 1761, 1767, 5, 25, 0, 0,
        1762, 1768, 3, 292, 146, 0, 1763, 1764, 5, 126, 0, 0, 1764, 1765, 3, 200, 100, 0, 1765,
        1766, 5, 127, 0, 0, 1766, 1768, 1, 0, 0, 0, 1767, 1762, 1, 0, 0, 0, 1767, 1763, 1, 0, 0, 0,
        1768, 1775, 1, 0, 0, 0, 1769, 1770, 7, 16, 0, 0, 1770, 1775, 3, 292, 146, 0, 1771, 1772, 3,
        294, 147, 0, 1772, 1773, 3, 286, 143, 0, 1773, 1775, 1, 0, 0, 0, 1774, 1760, 1, 0, 0, 0,
        1774, 1761, 1, 0, 0, 0, 1774, 1769, 1, 0, 0, 0, 1774, 1771, 1, 0, 0, 0, 1775, 293, 1, 0, 0,
        0, 1776, 1777, 7, 17, 0, 0, 1777, 295, 1, 0, 0, 0, 1778, 1779, 6, 148, -1, 0, 1779, 1783, 3,
        304, 152, 0, 1780, 1782, 3, 298, 149, 0, 1781, 1780, 1, 0, 0, 0, 1782, 1785, 1, 0, 0, 0,
        1783, 1781, 1, 0, 0, 0, 1783, 1784, 1, 0, 0, 0, 1784, 1797, 1, 0, 0, 0, 1785, 1783, 1, 0, 0,
        0, 1786, 1787, 10, 1, 0, 0, 1787, 1788, 7, 18, 0, 0, 1788, 1792, 3, 310, 155, 0, 1789, 1791,
        3, 298, 149, 0, 1790, 1789, 1, 0, 0, 0, 1791, 1794, 1, 0, 0, 0, 1792, 1790, 1, 0, 0, 0,
        1792, 1793, 1, 0, 0, 0, 1793, 1796, 1, 0, 0, 0, 1794, 1792, 1, 0, 0, 0, 1795, 1786, 1, 0, 0,
        0, 1796, 1799, 1, 0, 0, 0, 1797, 1795, 1, 0, 0, 0, 1797, 1798, 1, 0, 0, 0, 1798, 297, 1, 0,
        0, 0, 1799, 1797, 1, 0, 0, 0, 1800, 1801, 5, 130, 0, 0, 1801, 1802, 3, 282, 141, 0, 1802,
        1803, 5, 131, 0, 0, 1803, 1819, 1, 0, 0, 0, 1804, 1806, 5, 126, 0, 0, 1805, 1807, 3, 300,
        150, 0, 1806, 1805, 1, 0, 0, 0, 1806, 1807, 1, 0, 0, 0, 1807, 1808, 1, 0, 0, 0, 1808, 1819,
        5, 127, 0, 0, 1809, 1812, 5, 126, 0, 0, 1810, 1813, 5, 133, 0, 0, 1811, 1813, 8, 19, 0, 0,
        1812, 1810, 1, 0, 0, 0, 1812, 1811, 1, 0, 0, 0, 1813, 1814, 1, 0, 0, 0, 1814, 1812, 1, 0, 0,
        0, 1814, 1815, 1, 0, 0, 0, 1815, 1816, 1, 0, 0, 0, 1816, 1819, 5, 127, 0, 0, 1817, 1819, 7,
        16, 0, 0, 1818, 1800, 1, 0, 0, 0, 1818, 1804, 1, 0, 0, 0, 1818, 1809, 1, 0, 0, 0, 1818,
        1817, 1, 0, 0, 0, 1819, 299, 1, 0, 0, 0, 1820, 1825, 3, 302, 151, 0, 1821, 1822, 5, 133, 0,
        0, 1822, 1824, 3, 302, 151, 0, 1823, 1821, 1, 0, 0, 0, 1824, 1827, 1, 0, 0, 0, 1825, 1823,
        1, 0, 0, 0, 1825, 1826, 1, 0, 0, 0, 1826, 301, 1, 0, 0, 0, 1827, 1825, 1, 0, 0, 0, 1828,
        1831, 3, 282, 141, 0, 1829, 1831, 3, 24, 12, 0, 1830, 1828, 1, 0, 0, 0, 1830, 1829, 1, 0, 0,
        0, 1831, 303, 1, 0, 0, 0, 1832, 1848, 3, 310, 155, 0, 1833, 1848, 3, 306, 153, 0, 1834,
        1848, 3, 308, 154, 0, 1835, 1836, 5, 126, 0, 0, 1836, 1837, 3, 282, 141, 0, 1837, 1838, 5,
        127, 0, 0, 1838, 1848, 1, 0, 0, 0, 1839, 1848, 3, 104, 52, 0, 1840, 1848, 3, 114, 57, 0,
        1841, 1848, 3, 118, 59, 0, 1842, 1848, 3, 120, 60, 0, 1843, 1848, 3, 90, 45, 0, 1844, 1848,
        3, 94, 47, 0, 1845, 1848, 3, 96, 48, 0, 1846, 1848, 3, 102, 51, 0, 1847, 1832, 1, 0, 0, 0,
        1847, 1833, 1, 0, 0, 0, 1847, 1834, 1, 0, 0, 0, 1847, 1835, 1, 0, 0, 0, 1847, 1839, 1, 0, 0,
        0, 1847, 1840, 1, 0, 0, 0, 1847, 1841, 1, 0, 0, 0, 1847, 1842, 1, 0, 0, 0, 1847, 1843, 1, 0,
        0, 0, 1847, 1844, 1, 0, 0, 0, 1847, 1845, 1, 0, 0, 0, 1847, 1846, 1, 0, 0, 0, 1848, 305, 1,
        0, 0, 0, 1849, 1868, 5, 173, 0, 0, 1850, 1868, 5, 174, 0, 0, 1851, 1868, 5, 175, 0, 0, 1852,
        1854, 7, 12, 0, 0, 1853, 1852, 1, 0, 0, 0, 1853, 1854, 1, 0, 0, 0, 1854, 1855, 1, 0, 0, 0,
        1855, 1868, 5, 176, 0, 0, 1856, 1858, 7, 12, 0, 0, 1857, 1856, 1, 0, 0, 0, 1857, 1858, 1, 0,
        0, 0, 1858, 1859, 1, 0, 0, 0, 1859, 1868, 5, 177, 0, 0, 1860, 1868, 5, 171, 0, 0, 1861,
        1868, 5, 48, 0, 0, 1862, 1868, 5, 50, 0, 0, 1863, 1868, 5, 57, 0, 0, 1864, 1868, 5, 49, 0,
        0, 1865, 1868, 5, 38, 0, 0, 1866, 1868, 5, 39, 0, 0, 1867, 1849, 1, 0, 0, 0, 1867, 1850, 1,
        0, 0, 0, 1867, 1851, 1, 0, 0, 0, 1867, 1853, 1, 0, 0, 0, 1867, 1857, 1, 0, 0, 0, 1867, 1860,
        1, 0, 0, 0, 1867, 1861, 1, 0, 0, 0, 1867, 1862, 1, 0, 0, 0, 1867, 1863, 1, 0, 0, 0, 1867,
        1864, 1, 0, 0, 0, 1867, 1865, 1, 0, 0, 0, 1867, 1866, 1, 0, 0, 0, 1868, 307, 1, 0, 0, 0,
        1869, 1873, 5, 172, 0, 0, 1870, 1872, 7, 20, 0, 0, 1871, 1870, 1, 0, 0, 0, 1872, 1875, 1, 0,
        0, 0, 1873, 1871, 1, 0, 0, 0, 1873, 1874, 1, 0, 0, 0, 1874, 1876, 1, 0, 0, 0, 1875, 1873, 1,
        0, 0, 0, 1876, 1878, 5, 184, 0, 0, 1877, 1869, 1, 0, 0, 0, 1878, 1879, 1, 0, 0, 0, 1879,
        1877, 1, 0, 0, 0, 1879, 1880, 1, 0, 0, 0, 1880, 309, 1, 0, 0, 0, 1881, 1882, 7, 21, 0, 0,
        1882, 311, 1, 0, 0, 0, 253, 315, 331, 338, 343, 346, 353, 359, 364, 370, 372, 378, 385, 388,
        391, 398, 401, 408, 413, 415, 423, 433, 446, 454, 457, 464, 469, 477, 482, 491, 497, 499,
        511, 521, 529, 532, 535, 544, 567, 574, 577, 583, 592, 598, 600, 609, 611, 620, 626, 630,
        639, 641, 650, 654, 657, 660, 664, 670, 674, 676, 679, 685, 689, 699, 713, 720, 726, 729,
        733, 739, 743, 751, 754, 761, 766, 775, 779, 781, 793, 795, 807, 809, 814, 820, 823, 829,
        833, 836, 839, 850, 856, 858, 861, 869, 874, 880, 889, 894, 896, 918, 925, 930, 954, 959,
        964, 968, 972, 976, 985, 992, 999, 1008, 1014, 1019, 1026, 1033, 1038, 1041, 1044, 1047,
        1051, 1059, 1062, 1066, 1074, 1079, 1086, 1089, 1094, 1100, 1107, 1118, 1120, 1130, 1141,
        1147, 1153, 1158, 1164, 1168, 1173, 1180, 1188, 1190, 1198, 1212, 1218, 1222, 1226, 1230,
        1234, 1238, 1240, 1254, 1259, 1263, 1267, 1271, 1278, 1284, 1296, 1303, 1307, 1312, 1321,
        1326, 1330, 1335, 1338, 1345, 1348, 1352, 1356, 1363, 1367, 1370, 1379, 1384, 1392, 1396,
        1398, 1408, 1412, 1414, 1422, 1429, 1433, 1437, 1440, 1444, 1448, 1454, 1458, 1463, 1465,
        1469, 1474, 1477, 1484, 1492, 1495, 1501, 1505, 1509, 1513, 1520, 1524, 1531, 1537, 1546,
        1551, 1553, 1565, 1568, 1580, 1588, 1593, 1601, 1607, 1613, 1632, 1636, 1640, 1649, 1656,
        1667, 1669, 1676, 1689, 1702, 1729, 1733, 1735, 1747, 1749, 1754, 1758, 1767, 1774, 1783,
        1792, 1797, 1806, 1812, 1814, 1818, 1825, 1830, 1847, 1853, 1857, 1867, 1873, 1879,
    ]
}
