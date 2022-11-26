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
        case CBOOL = 35
        case BOOL_ = 36
        case COMPLEX = 37
        case IMAGINERY = 38
        case TRUE = 39
        case FALSE = 40
        case CONSTEXPR = 41
        case BOOL = 42
        case Class = 43
        case BYCOPY = 44
        case BYREF = 45
        case ID = 46
        case IMP = 47
        case IN = 48
        case INOUT = 49
        case NIL = 50
        case NO = 51
        case NULL = 52
        case ONEWAY = 53
        case OUT = 54
        case PROTOCOL_ = 55
        case SEL = 56
        case SELF = 57
        case SUPER = 58
        case YES = 59
        case AUTORELEASEPOOL = 60
        case CATCH = 61
        case CLASS = 62
        case DYNAMIC = 63
        case ENCODE = 64
        case END = 65
        case FINALLY = 66
        case IMPLEMENTATION = 67
        case INTERFACE = 68
        case IMPORT = 69
        case PACKAGE = 70
        case PROTOCOL = 71
        case OPTIONAL = 72
        case PRIVATE = 73
        case PROPERTY = 74
        case PROTECTED = 75
        case PUBLIC = 76
        case REQUIRED = 77
        case SELECTOR = 78
        case SYNCHRONIZED = 79
        case SYNTHESIZE = 80
        case THROW = 81
        case TRY = 82
        case ATOMIC = 83
        case NONATOMIC = 84
        case RETAIN = 85
        case ATTRIBUTE = 86
        case AUTORELEASING_QUALIFIER = 87
        case BLOCK = 88
        case BRIDGE = 89
        case BRIDGE_RETAINED = 90
        case BRIDGE_TRANSFER = 91
        case COVARIANT = 92
        case CONTRAVARIANT = 93
        case DEPRECATED = 94
        case KINDOF = 95
        case STRONG_QUALIFIER = 96
        case TYPEOF = 97
        case TYPEOF__ = 98
        case UNSAFE_UNRETAINED_QUALIFIER = 99
        case UNUSED = 100
        case WEAK_QUALIFIER = 101
        case ASM = 102
        case CDECL = 103
        case CLRCALL = 104
        case STDCALL = 105
        case DECLSPEC = 106
        case FASTCALL = 107
        case THISCALL = 108
        case VECTORCALL = 109
        case INLINE__ = 110
        case EXTENSION = 111
        case M128 = 112
        case M128D = 113
        case M128I = 114
        case ATOMIC_ = 115
        case NORETURN_ = 116
        case ALIGNAS_ = 117
        case THREAD_LOCAL_ = 118
        case STATIC_ASSERT_ = 119
        case NULL_UNSPECIFIED = 120
        case NULLABLE = 121
        case NONNULL = 122
        case NULL_RESETTABLE = 123
        case NS_INLINE = 124
        case NS_ENUM = 125
        case NS_OPTIONS = 126
        case ASSIGN = 127
        case COPY = 128
        case GETTER = 129
        case SETTER = 130
        case STRONG = 131
        case READONLY = 132
        case READWRITE = 133
        case WEAK = 134
        case UNSAFE_UNRETAINED = 135
        case IB_OUTLET = 136
        case IB_OUTLET_COLLECTION = 137
        case IB_INSPECTABLE = 138
        case IB_DESIGNABLE = 139
        case NS_ASSUME_NONNULL_BEGIN = 140
        case NS_ASSUME_NONNULL_END = 141
        case EXTERN_SUFFIX = 142
        case IOS_SUFFIX = 143
        case MAC_SUFFIX = 144
        case TVOS_PROHIBITED = 145
        case IDENTIFIER = 146
        case LP = 147
        case RP = 148
        case LBRACE = 149
        case RBRACE = 150
        case LBRACK = 151
        case RBRACK = 152
        case SEMI = 153
        case COMMA = 154
        case DOT = 155
        case STRUCTACCESS = 156
        case AT = 157
        case ASSIGNMENT = 158
        case GT = 159
        case LT = 160
        case BANG = 161
        case TILDE = 162
        case QUESTION = 163
        case COLON = 164
        case EQUAL = 165
        case LE = 166
        case GE = 167
        case NOTEQUAL = 168
        case AND = 169
        case OR = 170
        case INC = 171
        case DEC = 172
        case ADD = 173
        case SUB = 174
        case MUL = 175
        case DIV = 176
        case BITAND = 177
        case BITOR = 178
        case BITXOR = 179
        case MOD = 180
        case ADD_ASSIGN = 181
        case SUB_ASSIGN = 182
        case MUL_ASSIGN = 183
        case DIV_ASSIGN = 184
        case AND_ASSIGN = 185
        case OR_ASSIGN = 186
        case XOR_ASSIGN = 187
        case MOD_ASSIGN = 188
        case LSHIFT_ASSIGN = 189
        case RSHIFT_ASSIGN = 190
        case ELIPSIS = 191
        case CHARACTER_LITERAL = 192
        case STRING_START = 193
        case HEX_LITERAL = 194
        case OCTAL_LITERAL = 195
        case BINARY_LITERAL = 196
        case DECIMAL_LITERAL = 197
        case DIGITS = 198
        case FLOATING_POINT_LITERAL = 199
        case WS = 200
        case MULTI_COMMENT = 201
        case SINGLE_COMMENT = 202
        case BACKSLASH = 203
        case SHARP = 204
        case STRING_NEWLINE = 205
        case STRING_END = 206
        case STRING_VALUE = 207
        case PATH = 208
        case DIRECTIVE_IMPORT = 209
        case DIRECTIVE_INCLUDE = 210
        case DIRECTIVE_PRAGMA = 211
        case DIRECTIVE_DEFINE = 212
        case DIRECTIVE_DEFINED = 213
        case DIRECTIVE_IF = 214
        case DIRECTIVE_ELIF = 215
        case DIRECTIVE_ELSE = 216
        case DIRECTIVE_UNDEF = 217
        case DIRECTIVE_IFDEF = 218
        case DIRECTIVE_IFNDEF = 219
        case DIRECTIVE_ENDIF = 220
        case DIRECTIVE_TRUE = 221
        case DIRECTIVE_FALSE = 222
        case DIRECTIVE_ERROR = 223
        case DIRECTIVE_WARNING = 224
        case DIRECTIVE_HASINCLUDE = 225
        case DIRECTIVE_BANG = 226
        case DIRECTIVE_LP = 227
        case DIRECTIVE_RP = 228
        case DIRECTIVE_EQUAL = 229
        case DIRECTIVE_NOTEQUAL = 230
        case DIRECTIVE_AND = 231
        case DIRECTIVE_OR = 232
        case DIRECTIVE_LT = 233
        case DIRECTIVE_GT = 234
        case DIRECTIVE_LE = 235
        case DIRECTIVE_GE = 236
        case DIRECTIVE_STRING = 237
        case DIRECTIVE_ID = 238
        case DIRECTIVE_DECIMAL_LITERAL = 239
        case DIRECTIVE_FLOAT = 240
        case DIRECTIVE_NEWLINE = 241
        case DIRECTIVE_MULTI_COMMENT = 242
        case DIRECTIVE_SINGLE_COMMENT = 243
        case DIRECTIVE_BACKSLASH_NEWLINE = 244
        case DIRECTIVE_TEXT_NEWLINE = 245
        case DIRECTIVE_TEXT = 246
        case DIRECTIVE_PATH = 247
        case DIRECTIVE_PATH_STRING = 248
    }

    public static let RULE_translationUnit = 0, RULE_topLevelDeclaration = 1,
        RULE_importDeclaration = 2, RULE_classInterface = 3, RULE_classInterfaceName = 4,
        RULE_categoryInterface = 5, RULE_classImplementation = 6, RULE_classImplementatioName = 7,
        RULE_categoryImplementation = 8, RULE_className = 9, RULE_superclassName = 10,
        RULE_genericSuperclassName = 11, RULE_genericSuperclassSpecifier = 12,
        RULE_superclassTypeSpecifierWithPrefixes = 13, RULE_protocolDeclaration = 14,
        RULE_protocolDeclarationSection = 15, RULE_protocolDeclarationList = 16,
        RULE_classDeclarationList = 17, RULE_protocolList = 18, RULE_propertyDeclaration = 19,
        RULE_propertyAttributesList = 20, RULE_propertyAttribute = 21, RULE_protocolName = 22,
        RULE_instanceVariables = 23, RULE_visibilitySection = 24, RULE_accessModifier = 25,
        RULE_interfaceDeclarationList = 26, RULE_classMethodDeclaration = 27,
        RULE_instanceMethodDeclaration = 28, RULE_methodDeclaration = 29,
        RULE_implementationDefinitionList = 30, RULE_classMethodDefinition = 31,
        RULE_instanceMethodDefinition = 32, RULE_methodDefinition = 33, RULE_methodSelector = 34,
        RULE_keywordDeclarator = 35, RULE_selector = 36, RULE_methodType = 37,
        RULE_propertyImplementation = 38, RULE_propertySynthesizeList = 39,
        RULE_propertySynthesizeItem = 40, RULE_blockType = 41, RULE_dictionaryExpression = 42,
        RULE_dictionaryPair = 43, RULE_arrayExpression = 44, RULE_boxExpression = 45,
        RULE_blockParameters = 46, RULE_typeVariableDeclaratorOrName = 47,
        RULE_blockExpression_ = 48, RULE_blockExpression = 49, RULE_messageExpression = 50,
        RULE_receiver = 51, RULE_messageSelector = 52, RULE_keywordArgument = 53,
        RULE_keywordArgumentType = 54, RULE_selectorExpression = 55, RULE_selectorName = 56,
        RULE_protocolExpression = 57, RULE_encodeExpression = 58, RULE_typeVariableDeclarator = 59,
        RULE_throwStatement = 60, RULE_tryBlock = 61, RULE_catchStatement = 62,
        RULE_synchronizedStatement = 63, RULE_autoreleaseStatement = 64,
        RULE_functionDeclaration = 65, RULE_functionDefinition = 66, RULE_functionSignature = 67,
        RULE_declarationList = 68, RULE_attribute = 69, RULE_attributeName = 70,
        RULE_attributeParameters = 71, RULE_attributeParameterList = 72,
        RULE_attributeParameter = 73, RULE_attributeParameterAssignment = 74,
        RULE_functionPointer = 75, RULE_functionPointerParameterList = 76,
        RULE_functionPointerParameterDeclarationList = 77,
        RULE_functionPointerParameterDeclaration = 78, RULE_functionCallExpression = 79,
        RULE_enumDeclaration = 80, RULE_varDeclaration_ = 81, RULE_typedefDeclaration_ = 82,
        RULE_typeDeclaratorList = 83, RULE_declarationSpecifiers_ = 84,
        RULE_declarationSpecifier__ = 85, RULE_declarationSpecifier = 86,
        RULE_declarationSpecifiers = 87, RULE_declarationSpecifiers2 = 88, RULE_declaration = 89,
        RULE_initDeclaratorList = 90, RULE_initDeclarator = 91, RULE_declarator = 92,
        RULE_directDeclarator = 93, RULE_typeName = 94, RULE_abstractDeclarator_ = 95,
        RULE_abstractDeclarator = 96, RULE_directAbstractDeclarator = 97,
        RULE_abstractDeclaratorSuffix_ = 98, RULE_parameterTypeList = 99, RULE_parameterList = 100,
        RULE_parameterDeclarationList_ = 101, RULE_parameterDeclaration = 102,
        RULE_typeQualifierList = 103, RULE_identifierList = 104, RULE_declaratorSuffix = 105,
        RULE_attributeSpecifier = 106, RULE_atomicTypeSpecifier = 107,
        RULE_structOrUnionSpecifier = 108, RULE_fieldDeclaration = 109,
        RULE_ibOutletQualifier = 110, RULE_arcBehaviourSpecifier = 111,
        RULE_nullabilitySpecifier = 112, RULE_storageClassSpecifier = 113, RULE_typePrefix = 114,
        RULE_typeQualifier = 115, RULE_functionSpecifier = 116, RULE_alignmentSpecifier = 117,
        RULE_protocolQualifier = 118, RULE_typeSpecifier_ = 119, RULE_typeSpecifier = 120,
        RULE_typedefName = 121, RULE_genericTypeSpecifier = 122, RULE_genericTypeList = 123,
        RULE_genericTypeParameter = 124, RULE_scalarTypeSpecifier = 125,
        RULE_typeofExpression = 126, RULE_fieldDeclaratorList = 127, RULE_fieldDeclarator = 128,
        RULE_enumSpecifier = 129, RULE_enumeratorList = 130, RULE_enumerator = 131,
        RULE_enumeratorIdentifier = 132, RULE_vcSpecificModifer = 133,
        RULE_gccDeclaratorExtension = 134, RULE_gccAttributeSpecifier = 135,
        RULE_gccAttributeList = 136, RULE_gccAttribute = 137, RULE_pointer_ = 138,
        RULE_pointer = 139, RULE_pointerEntry = 140, RULE_macro = 141, RULE_arrayInitializer = 142,
        RULE_structInitializer = 143, RULE_structInitializerItem = 144, RULE_initializerList = 145,
        RULE_staticAssertDeclaration = 146, RULE_statement = 147, RULE_labeledStatement = 148,
        RULE_rangeExpression = 149, RULE_compoundStatement = 150, RULE_selectionStatement = 151,
        RULE_switchStatement = 152, RULE_switchBlock = 153, RULE_switchSection = 154,
        RULE_switchLabel = 155, RULE_iterationStatement = 156, RULE_whileStatement = 157,
        RULE_doStatement = 158, RULE_forStatement = 159, RULE_forLoopInitializer = 160,
        RULE_forInStatement = 161, RULE_jumpStatement = 162, RULE_expressions = 163,
        RULE_expression = 164, RULE_assignmentExpression = 165, RULE_assignmentOperator = 166,
        RULE_castExpression = 167, RULE_initializer = 168, RULE_constantExpression = 169,
        RULE_unaryExpression = 170, RULE_unaryOperator = 171, RULE_postfixExpression = 172,
        RULE_postfixExpr = 173, RULE_argumentExpressionList = 174, RULE_argumentExpression = 175,
        RULE_primaryExpression = 176, RULE_constant = 177, RULE_stringLiteral = 178,
        RULE_identifier = 179

    public static let ruleNames: [String] = [
        "translationUnit", "topLevelDeclaration", "importDeclaration", "classInterface",
        "classInterfaceName", "categoryInterface", "classImplementation", "classImplementatioName",
        "categoryImplementation", "className", "superclassName", "genericSuperclassName",
        "genericSuperclassSpecifier", "superclassTypeSpecifierWithPrefixes", "protocolDeclaration",
        "protocolDeclarationSection", "protocolDeclarationList", "classDeclarationList",
        "protocolList", "propertyDeclaration", "propertyAttributesList", "propertyAttribute",
        "protocolName", "instanceVariables", "visibilitySection", "accessModifier",
        "interfaceDeclarationList", "classMethodDeclaration", "instanceMethodDeclaration",
        "methodDeclaration", "implementationDefinitionList", "classMethodDefinition",
        "instanceMethodDefinition", "methodDefinition", "methodSelector", "keywordDeclarator",
        "selector", "methodType", "propertyImplementation", "propertySynthesizeList",
        "propertySynthesizeItem", "blockType", "dictionaryExpression", "dictionaryPair",
        "arrayExpression", "boxExpression", "blockParameters", "typeVariableDeclaratorOrName",
        "blockExpression_", "blockExpression", "messageExpression", "receiver", "messageSelector",
        "keywordArgument", "keywordArgumentType", "selectorExpression", "selectorName",
        "protocolExpression", "encodeExpression", "typeVariableDeclarator", "throwStatement",
        "tryBlock", "catchStatement", "synchronizedStatement", "autoreleaseStatement",
        "functionDeclaration", "functionDefinition", "functionSignature", "declarationList",
        "attribute", "attributeName", "attributeParameters", "attributeParameterList",
        "attributeParameter", "attributeParameterAssignment", "functionPointer",
        "functionPointerParameterList", "functionPointerParameterDeclarationList",
        "functionPointerParameterDeclaration", "functionCallExpression", "enumDeclaration",
        "varDeclaration_", "typedefDeclaration_", "typeDeclaratorList", "declarationSpecifiers_",
        "declarationSpecifier__", "declarationSpecifier", "declarationSpecifiers",
        "declarationSpecifiers2", "declaration", "initDeclaratorList", "initDeclarator",
        "declarator", "directDeclarator", "typeName", "abstractDeclarator_", "abstractDeclarator",
        "directAbstractDeclarator", "abstractDeclaratorSuffix_", "parameterTypeList",
        "parameterList", "parameterDeclarationList_", "parameterDeclaration", "typeQualifierList",
        "identifierList", "declaratorSuffix", "attributeSpecifier", "atomicTypeSpecifier",
        "structOrUnionSpecifier", "fieldDeclaration", "ibOutletQualifier", "arcBehaviourSpecifier",
        "nullabilitySpecifier", "storageClassSpecifier", "typePrefix", "typeQualifier",
        "functionSpecifier", "alignmentSpecifier", "protocolQualifier", "typeSpecifier_",
        "typeSpecifier", "typedefName", "genericTypeSpecifier", "genericTypeList",
        "genericTypeParameter", "scalarTypeSpecifier", "typeofExpression", "fieldDeclaratorList",
        "fieldDeclarator", "enumSpecifier", "enumeratorList", "enumerator", "enumeratorIdentifier",
        "vcSpecificModifer", "gccDeclaratorExtension", "gccAttributeSpecifier", "gccAttributeList",
        "gccAttribute", "pointer_", "pointer", "pointerEntry", "macro", "arrayInitializer",
        "structInitializer", "structInitializerItem", "initializerList", "staticAssertDeclaration",
        "statement", "labeledStatement", "rangeExpression", "compoundStatement",
        "selectionStatement", "switchStatement", "switchBlock", "switchSection", "switchLabel",
        "iterationStatement", "whileStatement", "doStatement", "forStatement", "forLoopInitializer",
        "forInStatement", "jumpStatement", "expressions", "expression", "assignmentExpression",
        "assignmentOperator", "castExpression", "initializer", "constantExpression",
        "unaryExpression", "unaryOperator", "postfixExpression", "postfixExpr",
        "argumentExpressionList", "argumentExpression", "primaryExpression", "constant",
        "stringLiteral", "identifier",
    ]

    private static let _LITERAL_NAMES: [String?] = [
        nil, "'auto'", "'break'", "'case'", "'char'", "'const'", "'continue'", "'default'", "'do'",
        "'double'", nil, "'enum'", "'extern'", "'float'", "'for'", "'goto'", nil, "'inline'",
        "'int'", "'long'", "'register'", "'restrict'", "'return'", "'short'", "'signed'",
        "'sizeof'", "'static'", "'struct'", "'switch'", "'typedef'", "'union'", "'unsigned'",
        "'void'", "'volatile'", "'while'", "'bool'", "'_Bool'", "'_Complex'", "'_Imaginery'",
        "'true'", "'false'", "'constexpr'", "'BOOL'", "'Class'", "'bycopy'", "'byref'", "'id'",
        "'IMP'", "'in'", "'inout'", "'nil'", "'NO'", "'NULL'", "'oneway'", "'out'", "'Protocol'",
        "'SEL'", "'self'", "'super'", "'YES'", "'@autoreleasepool'", "'@catch'", "'@class'",
        "'@dynamic'", "'@encode'", "'@end'", "'@finally'", "'@implementation'", "'@interface'",
        "'@import'", "'@package'", "'@protocol'", "'@optional'", "'@private'", "'@property'",
        "'@protected'", "'@public'", "'@required'", "'@selector'", "'@synchronized'",
        "'@synthesize'", "'@throw'", "'@try'", "'atomic'", "'nonatomic'", "'retain'",
        "'__attribute__'", "'__autoreleasing'", "'__block'", "'__bridge'", "'__bridge_retained'",
        "'__bridge_transfer'", "'__covariant'", "'__contravariant'", "'__deprecated'", "'__kindof'",
        "'__strong'", nil, "'__typeof__'", "'__unsafe_unretained'", "'__unused'", "'__weak'",
        "'__asm'", "'__cdecl'", "'__clrcall'", "'__stdcall'", "'__declspec'", "'__fastcall'",
        "'__thiscall'", "'__vectorcall'", "'__inline__'", "'__extension__'", "'__m128'",
        "'__m128d'", "'__m128i'", "'_Atomic'", "'_Noreturn'", "'_Alignas'", nil, "'_Static_assert'",
        nil, nil, nil, "'null_resettable'", "'NS_INLINE'", "'NS_ENUM'", "'NS_OPTIONS'", "'assign'",
        "'copy'", "'getter'", "'setter'", "'strong'", "'readonly'", "'readwrite'", "'weak'",
        "'unsafe_unretained'", "'IBOutlet'", "'IBOutletCollection'", "'IBInspectable'",
        "'IB_DESIGNABLE'", nil, nil, nil, nil, nil, "'__TVOS_PROHIBITED'", nil, nil, nil, "'{'",
        "'}'", "'['", "']'", "';'", "','", "'.'", "'->'", "'@'", "'='", nil, nil, nil, "'~'", "'?'",
        "':'", nil, nil, nil, nil, nil, nil, "'++'", "'--'", "'+'", "'-'", "'*'", "'/'", "'&'",
        "'|'", "'^'", "'%'", "'+='", "'-='", "'*='", "'/='", "'&='", "'|='", "'^='", "'%='",
        "'<<='", "'>>='", "'...'", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "'\\'",
        nil, nil, nil, nil, nil, nil, nil, nil, nil, "'defined'", nil, "'elif'", nil, "'undef'",
        "'ifdef'", "'ifndef'", "'endif'",
    ]
    private static let _SYMBOLIC_NAMES: [String?] = [
        nil, "AUTO", "BREAK", "CASE", "CHAR", "CONST", "CONTINUE", "DEFAULT", "DO", "DOUBLE",
        "ELSE", "ENUM", "EXTERN", "FLOAT", "FOR", "GOTO", "IF", "INLINE", "INT", "LONG", "REGISTER",
        "RESTRICT", "RETURN", "SHORT", "SIGNED", "SIZEOF", "STATIC", "STRUCT", "SWITCH", "TYPEDEF",
        "UNION", "UNSIGNED", "VOID", "VOLATILE", "WHILE", "CBOOL", "BOOL_", "COMPLEX", "IMAGINERY",
        "TRUE", "FALSE", "CONSTEXPR", "BOOL", "Class", "BYCOPY", "BYREF", "ID", "IMP", "IN",
        "INOUT", "NIL", "NO", "NULL", "ONEWAY", "OUT", "PROTOCOL_", "SEL", "SELF", "SUPER", "YES",
        "AUTORELEASEPOOL", "CATCH", "CLASS", "DYNAMIC", "ENCODE", "END", "FINALLY",
        "IMPLEMENTATION", "INTERFACE", "IMPORT", "PACKAGE", "PROTOCOL", "OPTIONAL", "PRIVATE",
        "PROPERTY", "PROTECTED", "PUBLIC", "REQUIRED", "SELECTOR", "SYNCHRONIZED", "SYNTHESIZE",
        "THROW", "TRY", "ATOMIC", "NONATOMIC", "RETAIN", "ATTRIBUTE", "AUTORELEASING_QUALIFIER",
        "BLOCK", "BRIDGE", "BRIDGE_RETAINED", "BRIDGE_TRANSFER", "COVARIANT", "CONTRAVARIANT",
        "DEPRECATED", "KINDOF", "STRONG_QUALIFIER", "TYPEOF", "TYPEOF__",
        "UNSAFE_UNRETAINED_QUALIFIER", "UNUSED", "WEAK_QUALIFIER", "ASM", "CDECL", "CLRCALL",
        "STDCALL", "DECLSPEC", "FASTCALL", "THISCALL", "VECTORCALL", "INLINE__", "EXTENSION",
        "M128", "M128D", "M128I", "ATOMIC_", "NORETURN_", "ALIGNAS_", "THREAD_LOCAL_",
        "STATIC_ASSERT_", "NULL_UNSPECIFIED", "NULLABLE", "NONNULL", "NULL_RESETTABLE", "NS_INLINE",
        "NS_ENUM", "NS_OPTIONS", "ASSIGN", "COPY", "GETTER", "SETTER", "STRONG", "READONLY",
        "READWRITE", "WEAK", "UNSAFE_UNRETAINED", "IB_OUTLET", "IB_OUTLET_COLLECTION",
        "IB_INSPECTABLE", "IB_DESIGNABLE", "NS_ASSUME_NONNULL_BEGIN", "NS_ASSUME_NONNULL_END",
        "EXTERN_SUFFIX", "IOS_SUFFIX", "MAC_SUFFIX", "TVOS_PROHIBITED", "IDENTIFIER", "LP", "RP",
        "LBRACE", "RBRACE", "LBRACK", "RBRACK", "SEMI", "COMMA", "DOT", "STRUCTACCESS", "AT",
        "ASSIGNMENT", "GT", "LT", "BANG", "TILDE", "QUESTION", "COLON", "EQUAL", "LE", "GE",
        "NOTEQUAL", "AND", "OR", "INC", "DEC", "ADD", "SUB", "MUL", "DIV", "BITAND", "BITOR",
        "BITXOR", "MOD", "ADD_ASSIGN", "SUB_ASSIGN", "MUL_ASSIGN", "DIV_ASSIGN", "AND_ASSIGN",
        "OR_ASSIGN", "XOR_ASSIGN", "MOD_ASSIGN", "LSHIFT_ASSIGN", "RSHIFT_ASSIGN", "ELIPSIS",
        "CHARACTER_LITERAL", "STRING_START", "HEX_LITERAL", "OCTAL_LITERAL", "BINARY_LITERAL",
        "DECIMAL_LITERAL", "DIGITS", "FLOATING_POINT_LITERAL", "WS", "MULTI_COMMENT",
        "SINGLE_COMMENT", "BACKSLASH", "SHARP", "STRING_NEWLINE", "STRING_END", "STRING_VALUE",
        "PATH", "DIRECTIVE_IMPORT", "DIRECTIVE_INCLUDE", "DIRECTIVE_PRAGMA", "DIRECTIVE_DEFINE",
        "DIRECTIVE_DEFINED", "DIRECTIVE_IF", "DIRECTIVE_ELIF", "DIRECTIVE_ELSE", "DIRECTIVE_UNDEF",
        "DIRECTIVE_IFDEF", "DIRECTIVE_IFNDEF", "DIRECTIVE_ENDIF", "DIRECTIVE_TRUE",
        "DIRECTIVE_FALSE", "DIRECTIVE_ERROR", "DIRECTIVE_WARNING", "DIRECTIVE_HASINCLUDE",
        "DIRECTIVE_BANG", "DIRECTIVE_LP", "DIRECTIVE_RP", "DIRECTIVE_EQUAL", "DIRECTIVE_NOTEQUAL",
        "DIRECTIVE_AND", "DIRECTIVE_OR", "DIRECTIVE_LT", "DIRECTIVE_GT", "DIRECTIVE_LE",
        "DIRECTIVE_GE", "DIRECTIVE_STRING", "DIRECTIVE_ID", "DIRECTIVE_DECIMAL_LITERAL",
        "DIRECTIVE_FLOAT", "DIRECTIVE_NEWLINE", "DIRECTIVE_MULTI_COMMENT",
        "DIRECTIVE_SINGLE_COMMENT", "DIRECTIVE_BACKSLASH_NEWLINE", "DIRECTIVE_TEXT_NEWLINE",
        "DIRECTIVE_TEXT", "DIRECTIVE_PATH", "DIRECTIVE_PATH_STRING",
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
            setState(363)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 5_180_263_529_751_394_866) != 0
                || (Int64((_la - 67)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 67)) & -35_433_545_705) != 0
                || (Int64((_la - 131)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 131)) & 17_592_186_143_231) != 0
            {
                setState(360)
                try topLevelDeclaration()

                setState(365)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(366)
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
            setState(378)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(368)
                try importDeclaration()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(369)
                try declaration()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(370)
                try classInterface()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(371)
                try classImplementation()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(372)
                try categoryInterface()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(373)
                try categoryImplementation()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(374)
                try protocolDeclaration()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(375)
                try protocolDeclarationList()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(376)
                try classDeclarationList()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(377)
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
            setState(380)
            try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
            setState(381)
            try identifier()
            setState(382)
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
            setState(385)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue {
                setState(384)
                try match(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue)

            }

            setState(387)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(388)
            try classInterfaceName()
            setState(390)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(389)
                try instanceVariables()

            }

            setState(393)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -276_824_575) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(392)
                try interfaceDeclarationList()

            }

            setState(395)
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
        open func genericSuperclassSpecifier() -> GenericSuperclassSpecifierContext? {
            return getRuleContext(GenericSuperclassSpecifierContext.self, 0)
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
            try enterOuterAlt(_localctx, 1)
            setState(397)
            try className()
            setState(403)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(398)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(399)
                try superclassName()
                setState(401)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 5, _ctx) {
                case 1:
                    setState(400)
                    try genericSuperclassSpecifier()

                    break
                default: break
                }

            }

            setState(409)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(405)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(406)
                try protocolList()
                setState(407)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

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
            setState(411)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(412)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryInterfaceContext.self).categoryName = assignmentValue
            }()

            setState(413)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(415)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(414)
                try identifier()

            }

            setState(417)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(422)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(418)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(419)
                try protocolList()
                setState(420)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(425)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(424)
                try instanceVariables()

            }

            setState(428)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -276_824_575) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(427)
                try interfaceDeclarationList()

            }

            setState(430)
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
            setState(432)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(433)
            try classImplementatioName()
            setState(435)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(434)
                try instanceVariables()

            }

            setState(438)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_521_593) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(437)
                try implementationDefinitionList()

            }

            setState(440)
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
        open func genericSuperclassSpecifier() -> GenericSuperclassSpecifierContext? {
            return getRuleContext(GenericSuperclassSpecifierContext.self, 0)
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
            try enterOuterAlt(_localctx, 1)
            setState(442)
            try className()
            setState(448)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(443)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(444)
                try superclassName()
                setState(446)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
                    setState(445)
                    try genericSuperclassSpecifier()

                }

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
            setState(450)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(451)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryImplementationContext.self).categoryName =
                    assignmentValue
            }()

            setState(452)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(454)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(453)
                try identifier()

            }

            setState(456)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(458)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_521_593) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(457)
                try implementationDefinitionList()

            }

            setState(460)
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
        open func genericTypeList() -> GenericTypeListContext? {
            return getRuleContext(GenericTypeListContext.self, 0)
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
            setState(462)
            try identifier()
            setState(468)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 18, _ctx) {
            case 1:
                setState(463)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(464)
                try protocolList()
                setState(465)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case 2:
                setState(467)
                try genericTypeList()

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
            setState(470)
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
            setState(472)
            try identifier()
            setState(473)
            try genericSuperclassSpecifier()

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
        try enterRule(_localctx, 24, ObjectiveCParser.RULE_genericSuperclassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(475)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(484)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_303_103_687_184) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_977_896_202_249) != 0
            {
                setState(476)
                try superclassTypeSpecifierWithPrefixes()
                setState(481)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(477)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(478)
                    try superclassTypeSpecifierWithPrefixes()

                    setState(483)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(486)
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
        try enterRule(_localctx, 26, ObjectiveCParser.RULE_superclassTypeSpecifierWithPrefixes)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(491)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(488)
                    try typePrefix()

                }
                setState(493)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            }
            setState(494)
            try typeSpecifier()
            setState(496)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(495)
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
        try enterRule(_localctx, 28, ObjectiveCParser.RULE_protocolDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(498)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(499)
            try protocolName()
            setState(504)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(500)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(501)
                try protocolList()
                setState(502)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(509)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & -1_107_298_267) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 962_072_677_391) != 0
            {
                setState(506)
                try protocolDeclarationSection()

                setState(511)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(512)
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
        try enterRule(_localctx, 30, ObjectiveCParser.RULE_protocolDeclarationSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(526)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .OPTIONAL, .REQUIRED:
                try enterOuterAlt(_localctx, 1)
                setState(514)
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
                setState(518)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 25, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(515)
                        try interfaceDeclarationList()

                    }
                    setState(520)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 25, _ctx)
                }

                break
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .PROPERTY, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE,
                .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF__,
                .UNSAFE_UNRETAINED_QUALIFIER, .UNUSED, .WEAK_QUALIFIER, .CDECL, .CLRCALL, .STDCALL,
                .DECLSPEC, .FASTCALL, .THISCALL, .VECTORCALL, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .STATIC_ASSERT_,
                .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM,
                .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE,
                .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                .IB_DESIGNABLE, .IDENTIFIER, .LP, .ADD, .SUB, .MUL:
                try enterOuterAlt(_localctx, 2)
                setState(522)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(521)
                        try interfaceDeclarationList()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(524)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 26, _ctx)
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
        try enterRule(_localctx, 32, ObjectiveCParser.RULE_protocolDeclarationList)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(528)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(529)
            try protocolList()
            setState(530)
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
        try enterRule(_localctx, 34, ObjectiveCParser.RULE_classDeclarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(532)
            try match(ObjectiveCParser.Tokens.CLASS.rawValue)
            setState(533)
            try className()
            setState(538)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(534)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(535)
                try className()

                setState(540)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(541)
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
        try enterRule(_localctx, 36, ObjectiveCParser.RULE_protocolList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(543)
            try protocolName()
            setState(548)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(544)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(545)
                try protocolName()

                setState(550)
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
        try enterRule(_localctx, 38, ObjectiveCParser.RULE_propertyDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(551)
            try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
            setState(556)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(552)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(553)
                try propertyAttributesList()
                setState(554)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

            setState(559)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 31, _ctx) {
            case 1:
                setState(558)
                try ibOutletQualifier()

                break
            default: break
            }
            setState(562)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 32, _ctx) {
            case 1:
                setState(561)
                try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

                break
            default: break
            }
            setState(564)
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
        try enterRule(_localctx, 40, ObjectiveCParser.RULE_propertyAttributesList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(566)
            try propertyAttribute()
            setState(571)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(567)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(568)
                try propertyAttribute()

                setState(573)
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
        try enterRule(_localctx, 42, ObjectiveCParser.RULE_propertyAttribute)
        defer { try! exitRule() }
        do {
            setState(593)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ATOMIC:
                try enterOuterAlt(_localctx, 1)
                setState(574)
                try match(ObjectiveCParser.Tokens.ATOMIC.rawValue)

                break

            case .NONATOMIC:
                try enterOuterAlt(_localctx, 2)
                setState(575)
                try match(ObjectiveCParser.Tokens.NONATOMIC.rawValue)

                break

            case .STRONG:
                try enterOuterAlt(_localctx, 3)
                setState(576)
                try match(ObjectiveCParser.Tokens.STRONG.rawValue)

                break

            case .WEAK:
                try enterOuterAlt(_localctx, 4)
                setState(577)
                try match(ObjectiveCParser.Tokens.WEAK.rawValue)

                break

            case .RETAIN:
                try enterOuterAlt(_localctx, 5)
                setState(578)
                try match(ObjectiveCParser.Tokens.RETAIN.rawValue)

                break

            case .ASSIGN:
                try enterOuterAlt(_localctx, 6)
                setState(579)
                try match(ObjectiveCParser.Tokens.ASSIGN.rawValue)

                break

            case .UNSAFE_UNRETAINED:
                try enterOuterAlt(_localctx, 7)
                setState(580)
                try match(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue)

                break

            case .COPY:
                try enterOuterAlt(_localctx, 8)
                setState(581)
                try match(ObjectiveCParser.Tokens.COPY.rawValue)

                break

            case .READONLY:
                try enterOuterAlt(_localctx, 9)
                setState(582)
                try match(ObjectiveCParser.Tokens.READONLY.rawValue)

                break

            case .READWRITE:
                try enterOuterAlt(_localctx, 10)
                setState(583)
                try match(ObjectiveCParser.Tokens.READWRITE.rawValue)

                break

            case .GETTER:
                try enterOuterAlt(_localctx, 11)
                setState(584)
                try match(ObjectiveCParser.Tokens.GETTER.rawValue)
                setState(585)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(586)
                try identifier()

                break

            case .SETTER:
                try enterOuterAlt(_localctx, 12)
                setState(587)
                try match(ObjectiveCParser.Tokens.SETTER.rawValue)
                setState(588)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(589)
                try identifier()
                setState(590)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break
            case .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE:
                try enterOuterAlt(_localctx, 13)
                setState(592)
                try nullabilitySpecifier()

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
        try enterRule(_localctx, 44, ObjectiveCParser.RULE_protocolName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(603)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LT:
                try enterOuterAlt(_localctx, 1)
                setState(595)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(596)
                try protocolList()
                setState(597)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE,
                .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY,
                .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(600)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 35, _ctx) {
                case 1:
                    setState(599)
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
                setState(602)
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
        try enterRule(_localctx, 46, ObjectiveCParser.RULE_instanceVariables)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(605)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(609)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 70)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 70)) & -563_942_225_092_503) != 0
                || (Int64((_la - 134)) & ~0x3f) == 0 && ((Int64(1) << (_la - 134)) & 4159) != 0
            {
                setState(606)
                try visibilitySection()

                setState(611)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(612)
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
        try enterRule(_localctx, 48, ObjectiveCParser.RULE_visibilitySection)
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(626)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .PACKAGE, .PRIVATE, .PROTECTED, .PUBLIC:
                try enterOuterAlt(_localctx, 1)
                setState(614)
                try accessModifier()
                setState(618)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 38, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(615)
                        try fieldDeclaration()

                    }
                    setState(620)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 38, _ctx)
                }

                break
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF__, .UNSAFE_UNRETAINED_QUALIFIER,
                .UNUSED, .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(622)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(621)
                        try fieldDeclaration()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(624)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 39, _ctx)
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
        try enterRule(_localctx, 50, ObjectiveCParser.RULE_accessModifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(628)
            _la = try _input.LA(1)
            if !((Int64((_la - 70)) & ~0x3f) == 0 && ((Int64(1) << (_la - 70)) & 105) != 0) {
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
        try enterRule(_localctx, 52, ObjectiveCParser.RULE_interfaceDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(635)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(635)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 41, _ctx) {
                    case 1:
                        setState(630)
                        try declaration()

                        break
                    case 2:
                        setState(631)
                        try classMethodDeclaration()

                        break
                    case 3:
                        setState(632)
                        try instanceMethodDeclaration()

                        break
                    case 4:
                        setState(633)
                        try propertyDeclaration()

                        break
                    case 5:
                        setState(634)
                        try functionDeclaration()

                        break
                    default: break
                    }

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(637)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 42, _ctx)
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
        try enterRule(_localctx, 54, ObjectiveCParser.RULE_classMethodDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(639)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(640)
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
        try enterRule(_localctx, 56, ObjectiveCParser.RULE_instanceMethodDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(642)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(643)
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
        try enterRule(_localctx, 58, ObjectiveCParser.RULE_methodDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(646)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(645)
                try methodType()

            }

            setState(648)
            try methodSelector()
            setState(652)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(649)
                try attributeSpecifier()

                setState(654)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(656)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(655)
                try macro()

            }

            setState(658)
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
        try enterRule(_localctx, 60, ObjectiveCParser.RULE_implementationDefinitionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(665)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(665)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 46, _ctx) {
                case 1:
                    setState(660)
                    try functionDefinition()

                    break
                case 2:
                    setState(661)
                    try declaration()

                    break
                case 3:
                    setState(662)
                    try classMethodDefinition()

                    break
                case 4:
                    setState(663)
                    try instanceMethodDefinition()

                    break
                case 5:
                    setState(664)
                    try propertyImplementation()

                    break
                default: break
                }

                setState(667)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_521_593) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0

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
        try enterRule(_localctx, 62, ObjectiveCParser.RULE_classMethodDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(669)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(670)
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
        try enterRule(_localctx, 64, ObjectiveCParser.RULE_instanceMethodDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(672)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(673)
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
        try enterRule(_localctx, 66, ObjectiveCParser.RULE_methodDefinition)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(676)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(675)
                try methodType()

            }

            setState(678)
            try methodSelector()
            setState(680)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
                || _la == ObjectiveCParser.Tokens.MUL.rawValue
            {
                setState(679)
                try initDeclaratorList()

            }

            setState(683)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(682)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

            setState(686)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(685)
                try attributeSpecifier()

            }

            setState(688)
            try compoundStatement()
            setState(690)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(689)
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
        try enterRule(_localctx, 68, ObjectiveCParser.RULE_methodSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(702)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 55, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(692)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(694)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(693)
                        try keywordDeclarator()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(696)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 53, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER
                setState(700)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(698)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(699)
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
        try enterRule(_localctx, 70, ObjectiveCParser.RULE_keywordDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(705)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(704)
                try selector()

            }

            setState(707)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(711)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(708)
                try methodType()

                setState(713)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(715)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 58, _ctx) {
            case 1:
                setState(714)
                try arcBehaviourSpecifier()

                break
            default: break
            }
            setState(717)
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
        try enterRule(_localctx, 72, ObjectiveCParser.RULE_selector)
        defer { try! exitRule() }
        do {
            setState(725)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE,
                .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY,
                .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(719)
                try identifier()

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 2)
                setState(720)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)

                break

            case .SWITCH:
                try enterOuterAlt(_localctx, 3)
                setState(721)
                try match(ObjectiveCParser.Tokens.SWITCH.rawValue)

                break

            case .IF:
                try enterOuterAlt(_localctx, 4)
                setState(722)
                try match(ObjectiveCParser.Tokens.IF.rawValue)

                break

            case .ELSE:
                try enterOuterAlt(_localctx, 5)
                setState(723)
                try match(ObjectiveCParser.Tokens.ELSE.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 6)
                setState(724)
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
        try enterRule(_localctx, 74, ObjectiveCParser.RULE_methodType)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(727)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(728)
            try typeName()
            setState(729)
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
        try enterRule(_localctx, 76, ObjectiveCParser.RULE_propertyImplementation)
        defer { try! exitRule() }
        do {
            setState(739)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .SYNTHESIZE:
                try enterOuterAlt(_localctx, 1)
                setState(731)
                try match(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue)
                setState(732)
                try propertySynthesizeList()
                setState(733)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .DYNAMIC:
                try enterOuterAlt(_localctx, 2)
                setState(735)
                try match(ObjectiveCParser.Tokens.DYNAMIC.rawValue)
                setState(736)
                try propertySynthesizeList()
                setState(737)
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
        try enterRule(_localctx, 78, ObjectiveCParser.RULE_propertySynthesizeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(741)
            try propertySynthesizeItem()
            setState(746)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(742)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(743)
                try propertySynthesizeItem()

                setState(748)
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
        try enterRule(_localctx, 80, ObjectiveCParser.RULE_propertySynthesizeItem)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(749)
            try identifier()
            setState(752)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(750)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(751)
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
        try enterRule(_localctx, 82, ObjectiveCParser.RULE_blockType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(755)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 63, _ctx) {
            case 1:
                setState(754)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(757)
            try typeSpecifier()
            setState(759)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(758)
                try nullabilitySpecifier()

            }

            setState(761)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(762)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(765)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 65, _ctx) {
            case 1:
                setState(763)
                try nullabilitySpecifier()

                break
            case 2:
                setState(764)
                try typeSpecifier()

                break
            default: break
            }
            setState(767)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(769)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(768)
                try blockParameters()

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
        try enterRule(_localctx, 84, ObjectiveCParser.RULE_dictionaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(771)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(772)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(784)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(773)
                try dictionaryPair()
                setState(778)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 67, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(774)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(775)
                        try dictionaryPair()

                    }
                    setState(780)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 67, _ctx)
                }
                setState(782)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(781)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(786)
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
        try enterRule(_localctx, 86, ObjectiveCParser.RULE_dictionaryPair)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(788)
            try castExpression()
            setState(789)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(790)
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
        try enterRule(_localctx, 88, ObjectiveCParser.RULE_arrayExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(792)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(793)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(798)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(794)
                try expressions()
                setState(796)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(795)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(800)
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
        try enterRule(_localctx, 90, ObjectiveCParser.RULE_boxExpression)
        defer { try! exitRule() }
        do {
            setState(812)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 73, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(802)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(803)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(804)
                try expression(0)
                setState(805)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(807)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(810)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                    .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                    .FLOATING_POINT_LITERAL:
                    setState(808)
                    try constant()

                    break
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                    .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                    .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                    .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                    setState(809)
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
        open func typeVariableDeclaratorOrName() -> [TypeVariableDeclaratorOrNameContext] {
            return getRuleContexts(TypeVariableDeclaratorOrNameContext.self)
        }
        open func typeVariableDeclaratorOrName(_ i: Int) -> TypeVariableDeclaratorOrNameContext? {
            return getRuleContext(TypeVariableDeclaratorOrNameContext.self, i)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
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
        try enterRule(_localctx, 92, ObjectiveCParser.RULE_blockParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(830)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF__, .UNSAFE_UNRETAINED_QUALIFIER,
                .UNUSED, .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(814)
                try typeVariableDeclaratorOrName()

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(815)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(827)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                {
                    setState(818)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 74, _ctx) {
                    case 1:
                        setState(816)
                        try typeVariableDeclaratorOrName()

                        break
                    case 2:
                        setState(817)
                        try match(ObjectiveCParser.Tokens.VOID.rawValue)

                        break
                    default: break
                    }
                    setState(824)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                        setState(820)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(821)
                        try typeVariableDeclaratorOrName()

                        setState(826)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }

                }

                setState(829)
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
        try enterRule(_localctx, 94, ObjectiveCParser.RULE_typeVariableDeclaratorOrName)
        defer { try! exitRule() }
        do {
            setState(834)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 78, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(832)
                try typeVariableDeclarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(833)
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

    public class BlockExpression_Context: ParserRuleContext {
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
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_blockExpression_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBlockExpression_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBlockExpression_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBlockExpression_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBlockExpression_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func blockExpression_() throws -> BlockExpression_Context {
        var _localctx: BlockExpression_Context
        _localctx = BlockExpression_Context(_ctx, getState())
        try enterRule(_localctx, 96, ObjectiveCParser.RULE_blockExpression_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(836)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(838)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 79, _ctx) {
            case 1:
                setState(837)
                try typeSpecifier()

                break
            default: break
            }
            setState(841)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 80, _ctx) {
            case 1:
                setState(840)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(844)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(843)
                try blockParameters()

            }

            setState(846)
            try compoundStatement()

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
        try enterRule(_localctx, 98, ObjectiveCParser.RULE_blockExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(848)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(850)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(849)
                try blockParameters()

            }

            setState(852)
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
        try enterRule(_localctx, 100, ObjectiveCParser.RULE_messageExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(854)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(855)
            try receiver()
            setState(856)
            try messageSelector()
            setState(857)
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
        try enterRule(_localctx, 102, ObjectiveCParser.RULE_receiver)
        defer { try! exitRule() }
        do {
            setState(861)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 83, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(859)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(860)
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
        try enterRule(_localctx, 104, ObjectiveCParser.RULE_messageSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(869)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 85, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(863)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(865)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(864)
                    try keywordArgument()

                    setState(867)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    || _la == ObjectiveCParser.Tokens.COLON.rawValue

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
        try enterRule(_localctx, 106, ObjectiveCParser.RULE_keywordArgument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(872)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(871)
                try selector()

            }

            setState(874)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(875)
            try keywordArgumentType()
            setState(880)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(876)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(877)
                try keywordArgumentType()

                setState(882)
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
        try enterRule(_localctx, 108, ObjectiveCParser.RULE_keywordArgumentType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(883)
            try expressions()
            setState(885)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 88, _ctx) {
            case 1:
                setState(884)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(891)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(887)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(888)
                try initializerList()
                setState(889)
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
        try enterRule(_localctx, 110, ObjectiveCParser.RULE_selectorExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(893)
            try match(ObjectiveCParser.Tokens.SELECTOR.rawValue)
            setState(894)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(895)
            try selectorName()
            setState(896)
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
        try enterRule(_localctx, 112, ObjectiveCParser.RULE_selectorName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(907)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 92, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(898)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(903)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(900)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    {
                        setState(899)
                        try selector()

                    }

                    setState(902)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)

                    setState(905)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    || _la == ObjectiveCParser.Tokens.COLON.rawValue

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
        try enterRule(_localctx, 114, ObjectiveCParser.RULE_protocolExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(909)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(910)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(911)
            try protocolName()
            setState(912)
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
        try enterRule(_localctx, 116, ObjectiveCParser.RULE_encodeExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(914)
            try match(ObjectiveCParser.Tokens.ENCODE.rawValue)
            setState(915)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(916)
            try typeName()
            setState(917)
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
        try enterRule(_localctx, 118, ObjectiveCParser.RULE_typeVariableDeclarator)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(919)
            try declarationSpecifiers()
            setState(920)
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
        try enterRule(_localctx, 120, ObjectiveCParser.RULE_throwStatement)
        defer { try! exitRule() }
        do {
            setState(929)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 93, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(922)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(923)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(924)
                try identifier()
                setState(925)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(927)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(928)
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
        try enterRule(_localctx, 122, ObjectiveCParser.RULE_tryBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(931)
            try match(ObjectiveCParser.Tokens.TRY.rawValue)
            setState(932)
            try {
                let assignmentValue = try compoundStatement()
                _localctx.castdown(TryBlockContext.self).tryStatement = assignmentValue
            }()

            setState(936)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CATCH.rawValue {
                setState(933)
                try catchStatement()

                setState(938)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(941)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.FINALLY.rawValue {
                setState(939)
                try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
                setState(940)
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
        try enterRule(_localctx, 124, ObjectiveCParser.RULE_catchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(943)
            try match(ObjectiveCParser.Tokens.CATCH.rawValue)
            setState(944)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(945)
            try typeVariableDeclarator()
            setState(946)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(947)
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
        try enterRule(_localctx, 126, ObjectiveCParser.RULE_synchronizedStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(949)
            try match(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue)
            setState(950)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(951)
            try expression(0)
            setState(952)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(953)
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
        try enterRule(_localctx, 128, ObjectiveCParser.RULE_autoreleaseStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(955)
            try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
            setState(956)
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
        try enterRule(_localctx, 130, ObjectiveCParser.RULE_functionDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(958)
            try functionSignature()
            setState(959)
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
        try enterRule(_localctx, 132, ObjectiveCParser.RULE_functionDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(961)
            try functionSignature()
            setState(962)
            try compoundStatement()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class FunctionSignatureContext: ParserRuleContext {
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func declarationList() -> DeclarationListContext? {
            return getRuleContext(DeclarationListContext.self, 0)
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
        try enterRule(_localctx, 134, ObjectiveCParser.RULE_functionSignature)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(965)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 96, _ctx) {
            case 1:
                setState(964)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(967)
            try declarator()
            setState(969)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_848_900_046_849) != 0
            {
                setState(968)
                try declarationList()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclarationListContext: ParserRuleContext {
        open func declaration() -> [DeclarationContext] {
            return getRuleContexts(DeclarationContext.self)
        }
        open func declaration(_ i: Int) -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_declarationList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationList() throws -> DeclarationListContext {
        var _localctx: DeclarationListContext
        _localctx = DeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 136, ObjectiveCParser.RULE_declarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(972)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(971)
                try declaration()

                setState(974)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_848_900_046_849) != 0

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
        try enterRule(_localctx, 138, ObjectiveCParser.RULE_attribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(976)
            try attributeName()
            setState(978)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(977)
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
        try enterRule(_localctx, 140, ObjectiveCParser.RULE_attributeName)
        defer { try! exitRule() }
        do {
            setState(982)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(980)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE,
                .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY,
                .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(981)
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
        try enterRule(_localctx, 142, ObjectiveCParser.RULE_attributeParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(984)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(986)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_568) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 100_139_011) != 0
            {
                setState(985)
                try attributeParameterList()

            }

            setState(988)
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
        try enterRule(_localctx, 144, ObjectiveCParser.RULE_attributeParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(990)
            try attributeParameter()
            setState(995)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(991)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(992)
                try attributeParameter()

                setState(997)
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
        try enterRule(_localctx, 146, ObjectiveCParser.RULE_attributeParameter)
        defer { try! exitRule() }
        do {
            setState(1002)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 103, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(998)
                try attribute()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(999)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1000)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1001)
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
        try enterRule(_localctx, 148, ObjectiveCParser.RULE_attributeParameterAssignment)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1004)
            try attributeName()
            setState(1005)
            try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
            setState(1009)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                setState(1006)
                try constant()

                break
            case .CONST, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                setState(1007)
                try attributeName()

                break

            case .STRING_START:
                setState(1008)
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
        try enterRule(_localctx, 150, ObjectiveCParser.RULE_functionPointer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1011)
            try declarationSpecifiers()
            setState(1012)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1013)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1015)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(1014)
                try identifier()

            }

            setState(1017)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1018)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1020)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
            {
                setState(1019)
                try functionPointerParameterList()

            }

            setState(1022)
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
        try enterRule(_localctx, 152, ObjectiveCParser.RULE_functionPointerParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1024)
            try functionPointerParameterDeclarationList()
            setState(1027)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1025)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1026)
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
        try enterRule(_localctx, 154, ObjectiveCParser.RULE_functionPointerParameterDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1029)
            try functionPointerParameterDeclaration()
            setState(1034)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 108, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1030)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1031)
                    try functionPointerParameterDeclaration()

                }
                setState(1036)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 108, _ctx)
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
        try enterRule(_localctx, 156, ObjectiveCParser.RULE_functionPointerParameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1045)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 111, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1039)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 109, _ctx) {
                case 1:
                    setState(1037)
                    try declarationSpecifiers()

                    break
                case 2:
                    setState(1038)
                    try functionPointer()

                    break
                default: break
                }
                setState(1042)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1041)
                    try declarator()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1044)
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
        try enterRule(_localctx, 158, ObjectiveCParser.RULE_functionCallExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1048)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1047)
                try attributeSpecifier()

            }

            setState(1050)
            try identifier()
            setState(1052)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1051)
                try attributeSpecifier()

            }

            setState(1054)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1055)
            try directDeclarator(0)
            setState(1056)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1057)
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
        try enterRule(_localctx, 160, ObjectiveCParser.RULE_enumDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1060)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1059)
                try attributeSpecifier()

            }

            setState(1063)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.TYPEDEF.rawValue {
                setState(1062)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)

            }

            setState(1065)
            try enumSpecifier()
            setState(1067)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(1066)
                try identifier()

            }

            setState(1069)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VarDeclaration_Context: ParserRuleContext {
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func initDeclaratorList() -> InitDeclaratorListContext? {
            return getRuleContext(InitDeclaratorListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_varDeclaration_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterVarDeclaration_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitVarDeclaration_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitVarDeclaration_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitVarDeclaration_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func varDeclaration_() throws -> VarDeclaration_Context {
        var _localctx: VarDeclaration_Context
        _localctx = VarDeclaration_Context(_ctx, getState())
        try enterRule(_localctx, 162, ObjectiveCParser.RULE_varDeclaration_)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1075)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 117, _ctx) {
            case 1:
                setState(1071)
                try declarationSpecifiers()
                setState(1072)
                try initDeclaratorList()

                break
            case 2:
                setState(1074)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(1077)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypedefDeclaration_Context: ParserRuleContext {
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
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_typedefDeclaration_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypedefDeclaration_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypedefDeclaration_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypedefDeclaration_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypedefDeclaration_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typedefDeclaration_() throws -> TypedefDeclaration_Context {
        var _localctx: TypedefDeclaration_Context
        _localctx = TypedefDeclaration_Context(_ctx, getState())
        try enterRule(_localctx, 164, ObjectiveCParser.RULE_typedefDeclaration_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1101)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 122, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1080)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1079)
                    try attributeSpecifier()

                }

                setState(1082)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1087)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 119, _ctx) {
                case 1:
                    setState(1083)
                    try declarationSpecifiers()
                    setState(1084)
                    try typeDeclaratorList()

                    break
                case 2:
                    setState(1086)
                    try declarationSpecifiers()

                    break
                default: break
                }
                setState(1090)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1089)
                    try macro()

                }

                setState(1092)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1095)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1094)
                    try attributeSpecifier()

                }

                setState(1097)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1098)
                try functionPointer()
                setState(1099)
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
        try enterRule(_localctx, 166, ObjectiveCParser.RULE_typeDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1103)
            try declarator()
            setState(1108)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1104)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1105)
                try declarator()

                setState(1110)
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

    public class DeclarationSpecifiers_Context: ParserRuleContext {
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
            return ObjectiveCParser.RULE_declarationSpecifiers_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationSpecifiers_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationSpecifiers_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationSpecifiers_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationSpecifiers_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationSpecifiers_() throws -> DeclarationSpecifiers_Context {
        var _localctx: DeclarationSpecifiers_Context
        _localctx = DeclarationSpecifiers_Context(_ctx, getState())
        try enterRule(_localctx, 168, ObjectiveCParser.RULE_declarationSpecifiers_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1119)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1119)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 124, _ctx) {
                case 1:
                    setState(1111)
                    try storageClassSpecifier()

                    break
                case 2:
                    setState(1112)
                    try attributeSpecifier()

                    break
                case 3:
                    setState(1113)
                    try arcBehaviourSpecifier()

                    break
                case 4:
                    setState(1114)
                    try nullabilitySpecifier()

                    break
                case 5:
                    setState(1115)
                    try ibOutletQualifier()

                    break
                case 6:
                    setState(1116)
                    try typePrefix()

                    break
                case 7:
                    setState(1117)
                    try typeQualifier()

                    break
                case 8:
                    setState(1118)
                    try typeSpecifier()

                    break
                default: break
                }

                setState(1121)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_943_536_128_001) != 0

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclarationSpecifier__Context: ParserRuleContext {
        open func storageClassSpecifier() -> StorageClassSpecifierContext? {
            return getRuleContext(StorageClassSpecifierContext.self, 0)
        }
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func typeQualifier() -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, 0)
        }
        open func functionSpecifier() -> FunctionSpecifierContext? {
            return getRuleContext(FunctionSpecifierContext.self, 0)
        }
        open func alignmentSpecifier() -> AlignmentSpecifierContext? {
            return getRuleContext(AlignmentSpecifierContext.self, 0)
        }
        open func arcBehaviourSpecifier() -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func ibOutletQualifier() -> IbOutletQualifierContext? {
            return getRuleContext(IbOutletQualifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_declarationSpecifier__
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationSpecifier__(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationSpecifier__(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationSpecifier__(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationSpecifier__(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationSpecifier__() throws -> DeclarationSpecifier__Context {
        var _localctx: DeclarationSpecifier__Context
        _localctx = DeclarationSpecifier__Context(_ctx, getState())
        try enterRule(_localctx, 170, ObjectiveCParser.RULE_declarationSpecifier__)
        defer { try! exitRule() }
        do {
            setState(1131)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 126, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1123)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1124)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1125)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1126)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1127)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1128)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1129)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1130)
                try ibOutletQualifier()

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

    public class DeclarationSpecifierContext: ParserRuleContext {
        open func storageClassSpecifier() -> StorageClassSpecifierContext? {
            return getRuleContext(StorageClassSpecifierContext.self, 0)
        }
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func typeQualifier() -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, 0)
        }
        open func functionSpecifier() -> FunctionSpecifierContext? {
            return getRuleContext(FunctionSpecifierContext.self, 0)
        }
        open func alignmentSpecifier() -> AlignmentSpecifierContext? {
            return getRuleContext(AlignmentSpecifierContext.self, 0)
        }
        open func arcBehaviourSpecifier() -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func ibOutletQualifier() -> IbOutletQualifierContext? {
            return getRuleContext(IbOutletQualifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_declarationSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationSpecifier() throws -> DeclarationSpecifierContext {
        var _localctx: DeclarationSpecifierContext
        _localctx = DeclarationSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 172, ObjectiveCParser.RULE_declarationSpecifier)
        defer { try! exitRule() }
        do {
            setState(1141)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 127, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1133)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1134)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1135)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1136)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1137)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1138)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1139)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1140)
                try ibOutletQualifier()

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

    public class DeclarationSpecifiersContext: ParserRuleContext {
        open func typePrefix() -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, 0)
        }
        open func declarationSpecifier() -> [DeclarationSpecifierContext] {
            return getRuleContexts(DeclarationSpecifierContext.self)
        }
        open func declarationSpecifier(_ i: Int) -> DeclarationSpecifierContext? {
            return getRuleContext(DeclarationSpecifierContext.self, i)
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
        try enterRule(_localctx, 174, ObjectiveCParser.RULE_declarationSpecifiers)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1144)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 128, _ctx) {
            case 1:
                setState(1143)
                try typePrefix()

                break
            default: break
            }
            setState(1147)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1146)
                    try declarationSpecifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1149)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 129, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclarationSpecifiers2Context: ParserRuleContext {
        open func typePrefix() -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, 0)
        }
        open func declarationSpecifier() -> [DeclarationSpecifierContext] {
            return getRuleContexts(DeclarationSpecifierContext.self)
        }
        open func declarationSpecifier(_ i: Int) -> DeclarationSpecifierContext? {
            return getRuleContext(DeclarationSpecifierContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_declarationSpecifiers2
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDeclarationSpecifiers2(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDeclarationSpecifiers2(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDeclarationSpecifiers2(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDeclarationSpecifiers2(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func declarationSpecifiers2() throws -> DeclarationSpecifiers2Context {
        var _localctx: DeclarationSpecifiers2Context
        _localctx = DeclarationSpecifiers2Context(_ctx, getState())
        try enterRule(_localctx, 176, ObjectiveCParser.RULE_declarationSpecifiers2)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1152)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 130, _ctx) {
            case 1:
                setState(1151)
                try typePrefix()

                break
            default: break
            }
            setState(1155)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1154)
                try declarationSpecifier()

                setState(1157)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_527_777) != 0

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class DeclarationContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func initDeclaratorList() -> InitDeclaratorListContext? {
            return getRuleContext(InitDeclaratorListContext.self, 0)
        }
        open func staticAssertDeclaration() -> StaticAssertDeclarationContext? {
            return getRuleContext(StaticAssertDeclarationContext.self, 0)
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
        try enterRule(_localctx, 178, ObjectiveCParser.RULE_declaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1166)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF__, .UNSAFE_UNRETAINED_QUALIFIER,
                .UNUSED, .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(1159)
                try declarationSpecifiers()
                setState(1161)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1160)
                    try initDeclaratorList()

                }

                setState(1163)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .STATIC_ASSERT_:
                try enterOuterAlt(_localctx, 2)
                setState(1165)
                try staticAssertDeclaration()

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
        try enterRule(_localctx, 180, ObjectiveCParser.RULE_initDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1168)
            try initDeclarator()
            setState(1173)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1169)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1170)
                try initDeclarator()

                setState(1175)
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
        try enterRule(_localctx, 182, ObjectiveCParser.RULE_initDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1176)
            try declarator()
            setState(1179)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1177)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1178)
                try initializer()

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
        open func gccDeclaratorExtension() -> [GccDeclaratorExtensionContext] {
            return getRuleContexts(GccDeclaratorExtensionContext.self)
        }
        open func gccDeclaratorExtension(_ i: Int) -> GccDeclaratorExtensionContext? {
            return getRuleContext(GccDeclaratorExtensionContext.self, i)
        }
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
        try enterRule(_localctx, 184, ObjectiveCParser.RULE_declarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1182)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1181)
                try pointer()

            }

            setState(1184)
            try directDeclarator(0)
            setState(1188)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 137, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1185)
                    try gccDeclaratorExtension()

                }
                setState(1190)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 137, _ctx)
            }

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
        open func BITXOR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, 0)
        }
        open func blockParameters() -> BlockParametersContext? {
            return getRuleContext(BlockParametersContext.self, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func directDeclarator() -> DirectDeclaratorContext? {
            return getRuleContext(DirectDeclaratorContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func DIGITS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIGITS.rawValue, 0)
        }
        open func vcSpecificModifer() -> VcSpecificModiferContext? {
            return getRuleContext(VcSpecificModiferContext.self, 0)
        }
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func typeQualifierList() -> TypeQualifierListContext? {
            return getRuleContext(TypeQualifierListContext.self, 0)
        }
        open func primaryExpression() -> PrimaryExpressionContext? {
            return getRuleContext(PrimaryExpressionContext.self, 0)
        }
        open func STATIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STATIC.rawValue, 0)
        }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func parameterTypeList() -> ParameterTypeListContext? {
            return getRuleContext(ParameterTypeListContext.self, 0)
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

    public final func directDeclarator() throws -> DirectDeclaratorContext {
        return try directDeclarator(0)
    }
    @discardableResult private func directDeclarator(_ _p: Int) throws -> DirectDeclaratorContext {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: DirectDeclaratorContext
        _localctx = DirectDeclaratorContext(_ctx, _parentState)
        let _startState: Int = 186
        try enterRecursionRule(_localctx, 186, ObjectiveCParser.RULE_directDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1219)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 140, _ctx) {
            case 1:
                setState(1192)
                try identifier()

                break
            case 2:
                setState(1193)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1194)
                try declarator()
                setState(1195)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                setState(1197)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1198)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1200)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 138, _ctx) {
                case 1:
                    setState(1199)
                    try nullabilitySpecifier()

                    break
                default: break
                }
                setState(1203)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 42)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 42)) & -2_008_836_331_248_944_897) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 107)) & 1_657_857_368_071) != 0
                {
                    setState(1202)
                    try directDeclarator(0)

                }

                setState(1205)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1206)
                try blockParameters()

                break
            case 4:
                setState(1207)
                try identifier()
                setState(1208)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1209)
                try match(ObjectiveCParser.Tokens.DIGITS.rawValue)

                break
            case 5:
                setState(1211)
                try vcSpecificModifer()
                setState(1212)
                try identifier()

                break
            case 6:
                setState(1214)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1215)
                try vcSpecificModifer()
                setState(1216)
                try declarator()
                setState(1217)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1261)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 147, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1259)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 146, _ctx) {
                    case 1:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1221)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(1222)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1224)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 141, _ctx) {
                        case 1:
                            setState(1223)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1227)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 39)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                            || (Int64((_la - 120)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                            || (Int64((_la - 192)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 192)) & 191) != 0
                        {
                            setState(1226)
                            try primaryExpression()

                        }

                        setState(1229)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1230)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(1231)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1232)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1234)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 143, _ctx) {
                        case 1:
                            setState(1233)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1236)
                        try primaryExpression()
                        setState(1237)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1239)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(1240)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1241)
                        try typeQualifierList()
                        setState(1242)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1243)
                        try primaryExpression()
                        setState(1244)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1246)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1247)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1249)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 27_918_807_844_519_968) != 0
                            || _la == ObjectiveCParser.Tokens.ATOMIC_.rawValue
                        {
                            setState(1248)
                            try typeQualifierList()

                        }

                        setState(1251)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1252)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1253)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1254)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1256)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                        {
                            setState(1255)
                            try parameterTypeList()

                        }

                        setState(1258)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)

                        break
                    default: break
                    }
                }
                setState(1263)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 147, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class TypeNameContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
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
        try enterRule(_localctx, 188, ObjectiveCParser.RULE_typeName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1264)
            try declarationSpecifiers()
            setState(1266)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 148, _ctx) {
            case 1:
                setState(1265)
                try abstractDeclarator()

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

    public class AbstractDeclarator_Context: ParserRuleContext {
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        open func abstractDeclarator_() -> AbstractDeclarator_Context? {
            return getRuleContext(AbstractDeclarator_Context.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
        }
        open func abstractDeclaratorSuffix_() -> [AbstractDeclaratorSuffix_Context] {
            return getRuleContexts(AbstractDeclaratorSuffix_Context.self)
        }
        open func abstractDeclaratorSuffix_(_ i: Int) -> AbstractDeclaratorSuffix_Context? {
            return getRuleContext(AbstractDeclaratorSuffix_Context.self, i)
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
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_abstractDeclarator_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAbstractDeclarator_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAbstractDeclarator_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAbstractDeclarator_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAbstractDeclarator_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func abstractDeclarator_() throws -> AbstractDeclarator_Context {
        var _localctx: AbstractDeclarator_Context
        _localctx = AbstractDeclarator_Context(_ctx, getState())
        try enterRule(_localctx, 190, ObjectiveCParser.RULE_abstractDeclarator_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1291)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .MUL:
                try enterOuterAlt(_localctx, 1)
                setState(1268)
                try pointer()
                setState(1270)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 149, _ctx) {
                case 1:
                    setState(1269)
                    try abstractDeclarator_()

                    break
                default: break
                }

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1272)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1274)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1273)
                    try abstractDeclarator()

                }

                setState(1276)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1278)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1277)
                        try abstractDeclaratorSuffix_()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1280)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 151, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

                break

            case .LBRACK:
                try enterOuterAlt(_localctx, 3)
                setState(1287)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1282)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1284)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                            || (Int64((_la - 173)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                        {
                            setState(1283)
                            try constantExpression()

                        }

                        setState(1286)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1289)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 153, _ctx)
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

    public class AbstractDeclaratorContext: ParserRuleContext {
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        open func directAbstractDeclarator() -> DirectAbstractDeclaratorContext? {
            return getRuleContext(DirectAbstractDeclaratorContext.self, 0)
        }
        open func gccDeclaratorExtension() -> [GccDeclaratorExtensionContext] {
            return getRuleContexts(GccDeclaratorExtensionContext.self)
        }
        open func gccDeclaratorExtension(_ i: Int) -> GccDeclaratorExtensionContext? {
            return getRuleContext(GccDeclaratorExtensionContext.self, i)
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
        try enterRule(_localctx, 192, ObjectiveCParser.RULE_abstractDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1304)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 157, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1293)
                try pointer()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1295)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1294)
                    try pointer()

                }

                setState(1297)
                try directAbstractDeclarator(0)
                setState(1301)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 156, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1298)
                        try gccDeclaratorExtension()

                    }
                    setState(1303)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 156, _ctx)
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

    public class DirectAbstractDeclaratorContext: ParserRuleContext {
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func gccDeclaratorExtension() -> [GccDeclaratorExtensionContext] {
            return getRuleContexts(GccDeclaratorExtensionContext.self)
        }
        open func gccDeclaratorExtension(_ i: Int) -> GccDeclaratorExtensionContext? {
            return getRuleContext(GccDeclaratorExtensionContext.self, i)
        }
        open func LBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACK.rawValue, 0)
        }
        open func RBRACK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RBRACK.rawValue, 0)
        }
        open func typeQualifierList() -> TypeQualifierListContext? {
            return getRuleContext(TypeQualifierListContext.self, 0)
        }
        open func primaryExpression() -> PrimaryExpressionContext? {
            return getRuleContext(PrimaryExpressionContext.self, 0)
        }
        open func STATIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STATIC.rawValue, 0)
        }
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func parameterTypeList() -> ParameterTypeListContext? {
            return getRuleContext(ParameterTypeListContext.self, 0)
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
        open func directAbstractDeclarator() -> DirectAbstractDeclaratorContext? {
            return getRuleContext(DirectAbstractDeclaratorContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_directAbstractDeclarator
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterDirectAbstractDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitDirectAbstractDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitDirectAbstractDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitDirectAbstractDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }

    public final func directAbstractDeclarator() throws -> DirectAbstractDeclaratorContext {
        return try directAbstractDeclarator(0)
    }
    @discardableResult private func directAbstractDeclarator(_ _p: Int) throws
        -> DirectAbstractDeclaratorContext
    {
        let _parentctx: ParserRuleContext? = _ctx
        let _parentState: Int = getState()
        var _localctx: DirectAbstractDeclaratorContext
        _localctx = DirectAbstractDeclaratorContext(_ctx, _parentState)
        let _startState: Int = 194
        try enterRecursionRule(_localctx, 194, ObjectiveCParser.RULE_directAbstractDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1359)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 165, _ctx) {
            case 1:
                setState(1307)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1308)
                try abstractDeclarator()
                setState(1309)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1313)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 158, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1310)
                        try gccDeclaratorExtension()

                    }
                    setState(1315)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 158, _ctx)
                }

                break
            case 2:
                setState(1316)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1318)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 159, _ctx) {
                case 1:
                    setState(1317)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1321)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 39)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                    || (Int64((_la - 120)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 191) != 0
                {
                    setState(1320)
                    try primaryExpression()

                }

                setState(1323)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 3:
                setState(1324)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1325)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1327)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 161, _ctx) {
                case 1:
                    setState(1326)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1329)
                try primaryExpression()
                setState(1330)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 4:
                setState(1332)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1333)
                try typeQualifierList()
                setState(1334)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1335)
                try primaryExpression()
                setState(1336)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 5:
                setState(1338)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1339)
                try match(ObjectiveCParser.Tokens.MUL.rawValue)
                setState(1340)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 6:
                setState(1341)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1343)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                {
                    setState(1342)
                    try parameterTypeList()

                }

                setState(1345)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1349)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 163, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1346)
                        try gccDeclaratorExtension()

                    }
                    setState(1351)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 163, _ctx)
                }

                break
            case 7:
                setState(1352)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1353)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1355)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                    setState(1354)
                    try nullabilitySpecifier()

                }

                setState(1357)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1358)
                try blockParameters()

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1404)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 172, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1402)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 171, _ctx) {
                    case 1:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1361)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1362)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1364)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 166, _ctx) {
                        case 1:
                            setState(1363)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1367)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 39)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                            || (Int64((_la - 120)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                            || (Int64((_la - 192)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 192)) & 191) != 0
                        {
                            setState(1366)
                            try primaryExpression()

                        }

                        setState(1369)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1370)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1371)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1372)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1374)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 168, _ctx) {
                        case 1:
                            setState(1373)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1376)
                        try primaryExpression()
                        setState(1377)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1379)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(1380)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1381)
                        try typeQualifierList()
                        setState(1382)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1383)
                        try primaryExpression()
                        setState(1384)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1386)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(1387)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1388)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1389)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1390)
                        if !(precpred(_ctx, 2)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 2)"))
                        }
                        setState(1391)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1393)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                        {
                            setState(1392)
                            try parameterTypeList()

                        }

                        setState(1395)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)
                        setState(1399)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 170, _ctx)
                        while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                            if _alt == 1 {
                                setState(1396)
                                try gccDeclaratorExtension()

                            }
                            setState(1401)
                            try _errHandler.sync(self)
                            _alt = try getInterpreter().adaptivePredict(_input, 170, _ctx)
                        }

                        break
                    default: break
                    }
                }
                setState(1406)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 172, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AbstractDeclaratorSuffix_Context: ParserRuleContext {
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
        open func parameterDeclarationList_() -> ParameterDeclarationList_Context? {
            return getRuleContext(ParameterDeclarationList_Context.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_abstractDeclaratorSuffix_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAbstractDeclaratorSuffix_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAbstractDeclaratorSuffix_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAbstractDeclaratorSuffix_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAbstractDeclaratorSuffix_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func abstractDeclaratorSuffix_() throws
        -> AbstractDeclaratorSuffix_Context
    {
        var _localctx: AbstractDeclaratorSuffix_Context
        _localctx = AbstractDeclaratorSuffix_Context(_ctx, getState())
        try enterRule(_localctx, 196, ObjectiveCParser.RULE_abstractDeclaratorSuffix_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1417)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(1407)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1409)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    || (Int64((_la - 173)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                {
                    setState(1408)
                    try constantExpression()

                }

                setState(1411)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1412)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1414)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                {
                    setState(1413)
                    try parameterDeclarationList_()

                }

                setState(1416)
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

    public class ParameterTypeListContext: ParserRuleContext {
        open func parameterList() -> ParameterListContext? {
            return getRuleContext(ParameterListContext.self, 0)
        }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func ELIPSIS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ELIPSIS.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_parameterTypeList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterParameterTypeList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitParameterTypeList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitParameterTypeList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitParameterTypeList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func parameterTypeList() throws -> ParameterTypeListContext {
        var _localctx: ParameterTypeListContext
        _localctx = ParameterTypeListContext(_ctx, getState())
        try enterRule(_localctx, 198, ObjectiveCParser.RULE_parameterTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1419)
            try parameterList()
            setState(1422)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1420)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1421)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ParameterListContext: ParserRuleContext {
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
        try enterRule(_localctx, 200, ObjectiveCParser.RULE_parameterList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1424)
            try parameterDeclaration()
            setState(1429)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 177, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1425)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1426)
                    try parameterDeclaration()

                }
                setState(1431)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 177, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ParameterDeclarationList_Context: ParserRuleContext {
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
            return ObjectiveCParser.RULE_parameterDeclarationList_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterParameterDeclarationList_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitParameterDeclarationList_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitParameterDeclarationList_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitParameterDeclarationList_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func parameterDeclarationList_() throws
        -> ParameterDeclarationList_Context
    {
        var _localctx: ParameterDeclarationList_Context
        _localctx = ParameterDeclarationList_Context(_ctx, getState())
        try enterRule(_localctx, 202, ObjectiveCParser.RULE_parameterDeclarationList_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1432)
            try parameterDeclaration()
            setState(1437)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1433)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1434)
                try parameterDeclaration()

                setState(1439)
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

    public class ParameterDeclarationContext: ParserRuleContext {
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func abstractDeclarator() -> AbstractDeclaratorContext? {
            return getRuleContext(AbstractDeclaratorContext.self, 0)
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
        try enterRule(_localctx, 204, ObjectiveCParser.RULE_parameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1447)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 180, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1440)
                try declarationSpecifiers()
                setState(1441)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1443)
                try declarationSpecifiers()
                setState(1445)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1444)
                    try abstractDeclarator()

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

    public class TypeQualifierListContext: ParserRuleContext {
        open func typeQualifier() -> [TypeQualifierContext] {
            return getRuleContexts(TypeQualifierContext.self)
        }
        open func typeQualifier(_ i: Int) -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeQualifierList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeQualifierList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeQualifierList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeQualifierList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeQualifierList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeQualifierList() throws -> TypeQualifierListContext {
        var _localctx: TypeQualifierListContext
        _localctx = TypeQualifierListContext(_ctx, getState())
        try enterRule(_localctx, 206, ObjectiveCParser.RULE_typeQualifierList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1450)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1449)
                    try typeQualifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1452)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 181, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class IdentifierListContext: ParserRuleContext {
        open func identifier() -> [IdentifierContext] {
            return getRuleContexts(IdentifierContext.self)
        }
        open func identifier(_ i: Int) -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_identifierList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterIdentifierList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitIdentifierList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitIdentifierList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitIdentifierList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func identifierList() throws -> IdentifierListContext {
        var _localctx: IdentifierListContext
        _localctx = IdentifierListContext(_ctx, getState())
        try enterRule(_localctx, 208, ObjectiveCParser.RULE_identifierList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1454)
            try identifier()
            setState(1459)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1455)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1456)
                try identifier()

                setState(1461)
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
        try enterRule(_localctx, 210, ObjectiveCParser.RULE_declaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1462)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(1464)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
            {
                setState(1463)
                try constantExpression()

            }

            setState(1466)
            try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

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
        try enterRule(_localctx, 212, ObjectiveCParser.RULE_attributeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1468)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1469)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1470)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1471)
            try attribute()
            setState(1476)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1472)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1473)
                try attribute()

                setState(1478)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1479)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1480)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AtomicTypeSpecifierContext: ParserRuleContext {
        open func ATOMIC_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATOMIC_.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_atomicTypeSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAtomicTypeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAtomicTypeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAtomicTypeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAtomicTypeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func atomicTypeSpecifier() throws -> AtomicTypeSpecifierContext {
        var _localctx: AtomicTypeSpecifierContext
        _localctx = AtomicTypeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 214, ObjectiveCParser.RULE_atomicTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1482)
            try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)
            setState(1483)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1484)
            try typeName()
            setState(1485)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

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
        try enterRule(_localctx, 216, ObjectiveCParser.RULE_structOrUnionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1487)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.STRUCT.rawValue
                || _la == ObjectiveCParser.Tokens.UNION.rawValue)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1491)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1488)
                try attributeSpecifier()

                setState(1493)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1506)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 188, _ctx) {
            case 1:
                setState(1494)
                try identifier()

                break
            case 2:
                setState(1496)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1495)
                    try identifier()

                }

                setState(1498)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1500)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1499)
                    try fieldDeclaration()

                    setState(1502)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
                setState(1504)
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
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
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
        try enterRule(_localctx, 218, ObjectiveCParser.RULE_fieldDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1518)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 190, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1508)
                try declarationSpecifiers()
                setState(1509)
                try fieldDeclaratorList()
                setState(1511)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1510)
                    try macro()

                }

                setState(1513)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1515)
                try functionPointer()
                setState(1516)
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
        try enterRule(_localctx, 220, ObjectiveCParser.RULE_ibOutletQualifier)
        defer { try! exitRule() }
        do {
            setState(1526)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IB_OUTLET_COLLECTION:
                try enterOuterAlt(_localctx, 1)
                setState(1520)
                try match(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue)
                setState(1521)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1522)
                try identifier()
                setState(1523)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .IB_OUTLET:
                try enterOuterAlt(_localctx, 2)
                setState(1525)
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
        try enterRule(_localctx, 222, ObjectiveCParser.RULE_arcBehaviourSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1528)
            _la = try _input.LA(1)
            if !((Int64((_la - 87)) & ~0x3f) == 0 && ((Int64(1) << (_la - 87)) & 20993) != 0) {
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
        try enterRule(_localctx, 224, ObjectiveCParser.RULE_nullabilitySpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1530)
            _la = try _input.LA(1)
            if !((Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0) {
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
        open func CONSTEXPR() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONSTEXPR.rawValue, 0)
        }
        open func EXTERN() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EXTERN.rawValue, 0)
        }
        open func REGISTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.REGISTER.rawValue, 0)
        }
        open func STATIC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STATIC.rawValue, 0)
        }
        open func THREAD_LOCAL_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.THREAD_LOCAL_.rawValue, 0)
        }
        open func TYPEDEF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEDEF.rawValue, 0)
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
        try enterRule(_localctx, 226, ObjectiveCParser.RULE_storageClassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1532)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_199_628_288_002) != 0
                || _la == ObjectiveCParser.Tokens.THREAD_LOCAL_.rawValue)
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
        try enterRule(_localctx, 228, ObjectiveCParser.RULE_typePrefix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1534)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.INLINE.rawValue
                || (Int64((_la - 88)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 88)) & 68_719_476_879) != 0)
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
        open func ATOMIC_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATOMIC_.rawValue, 0)
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
        try enterRule(_localctx, 230, ObjectiveCParser.RULE_typeQualifier)
        defer { try! exitRule() }
        do {
            setState(1541)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(1536)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break

            case .VOLATILE:
                try enterOuterAlt(_localctx, 2)
                setState(1537)
                try match(ObjectiveCParser.Tokens.VOLATILE.rawValue)

                break

            case .RESTRICT:
                try enterOuterAlt(_localctx, 3)
                setState(1538)
                try match(ObjectiveCParser.Tokens.RESTRICT.rawValue)

                break

            case .ATOMIC_:
                try enterOuterAlt(_localctx, 4)
                setState(1539)
                try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)

                break
            case .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT:
                try enterOuterAlt(_localctx, 5)
                setState(1540)
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

    public class FunctionSpecifierContext: ParserRuleContext {
        open func INLINE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INLINE.rawValue, 0)
        }
        open func NORETURN_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NORETURN_.rawValue, 0)
        }
        open func INLINE__() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.INLINE__.rawValue, 0)
        }
        open func STDCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STDCALL.rawValue, 0)
        }
        open func gccAttributeSpecifier() -> GccAttributeSpecifierContext? {
            return getRuleContext(GccAttributeSpecifierContext.self, 0)
        }
        open func DECLSPEC() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DECLSPEC.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_functionSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterFunctionSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitFunctionSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitFunctionSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitFunctionSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func functionSpecifier() throws -> FunctionSpecifierContext {
        var _localctx: FunctionSpecifierContext
        _localctx = FunctionSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 232, ObjectiveCParser.RULE_functionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1550)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .INLINE, .STDCALL, .INLINE__, .NORETURN_:
                try enterOuterAlt(_localctx, 1)
                setState(1543)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.INLINE.rawValue
                    || (Int64((_la - 105)) & ~0x3f) == 0 && ((Int64(1) << (_la - 105)) & 2081) != 0)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }

                break

            case .ATTRIBUTE:
                try enterOuterAlt(_localctx, 2)
                setState(1544)
                try gccAttributeSpecifier()

                break

            case .DECLSPEC:
                try enterOuterAlt(_localctx, 3)
                setState(1545)
                try match(ObjectiveCParser.Tokens.DECLSPEC.rawValue)
                setState(1546)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1547)
                try identifier()
                setState(1548)
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

    public class AlignmentSpecifierContext: ParserRuleContext {
        open func ALIGNAS_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ALIGNAS_.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_alignmentSpecifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAlignmentSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAlignmentSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAlignmentSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAlignmentSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func alignmentSpecifier() throws -> AlignmentSpecifierContext {
        var _localctx: AlignmentSpecifierContext
        _localctx = AlignmentSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 234, ObjectiveCParser.RULE_alignmentSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1552)
            try match(ObjectiveCParser.Tokens.ALIGNAS_.rawValue)
            setState(1553)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1556)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 194, _ctx) {
            case 1:
                setState(1554)
                try typeName()

                break
            case 2:
                setState(1555)
                try constantExpression()

                break
            default: break
            }
            setState(1558)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

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
        try enterRule(_localctx, 236, ObjectiveCParser.RULE_protocolQualifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1560)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 27_918_799_252_488_192) != 0) {
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

    public class TypeSpecifier_Context: ParserRuleContext {
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
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typeSpecifier_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeSpecifier_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeSpecifier_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeSpecifier_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeSpecifier_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeSpecifier_() throws -> TypeSpecifier_Context {
        var _localctx: TypeSpecifier_Context
        _localctx = TypeSpecifier_Context(_ctx, getState())
        try enterRule(_localctx, 238, ObjectiveCParser.RULE_typeSpecifier_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1586)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 201, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1562)
                try scalarTypeSpecifier()
                setState(1564)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1563)
                    try pointer()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1566)
                try typeofExpression()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1568)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1567)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1570)
                try genericTypeSpecifier()
                setState(1572)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1571)
                    try pointer()

                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1574)
                try structOrUnionSpecifier()
                setState(1576)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1575)
                    try pointer()

                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1578)
                try enumSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1580)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1579)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1582)
                try identifier()
                setState(1584)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1583)
                    try pointer()

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

    public class TypeSpecifierContext: ParserRuleContext {
        open func scalarTypeSpecifier() -> ScalarTypeSpecifierContext? {
            return getRuleContext(ScalarTypeSpecifierContext.self, 0)
        }
        open func EXTENSION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EXTENSION.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func M128() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128.rawValue, 0)
        }
        open func M128D() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128D.rawValue, 0)
        }
        open func M128I() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128I.rawValue, 0)
        }
        open func genericTypeSpecifier() -> GenericTypeSpecifierContext? {
            return getRuleContext(GenericTypeSpecifierContext.self, 0)
        }
        open func atomicTypeSpecifier() -> AtomicTypeSpecifierContext? {
            return getRuleContext(AtomicTypeSpecifierContext.self, 0)
        }
        open func structOrUnionSpecifier() -> StructOrUnionSpecifierContext? {
            return getRuleContext(StructOrUnionSpecifierContext.self, 0)
        }
        open func enumSpecifier() -> EnumSpecifierContext? {
            return getRuleContext(EnumSpecifierContext.self, 0)
        }
        open func typedefName() -> TypedefNameContext? {
            return getRuleContext(TypedefNameContext.self, 0)
        }
        open func TYPEOF__() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEOF__.rawValue, 0)
        }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
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
        try enterRule(_localctx, 240, ObjectiveCParser.RULE_typeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1603)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 202, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1588)
                try scalarTypeSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1589)
                try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)
                setState(1590)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1591)
                _la = try _input.LA(1)
                if !((Int64((_la - 112)) & ~0x3f) == 0 && ((Int64(1) << (_la - 112)) & 7) != 0) {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1592)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1593)
                try genericTypeSpecifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1594)
                try atomicTypeSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1595)
                try structOrUnionSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1596)
                try enumSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1597)
                try typedefName()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1598)
                try match(ObjectiveCParser.Tokens.TYPEOF__.rawValue)
                setState(1599)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1600)
                try constantExpression()
                setState(1601)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

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

    public class TypedefNameContext: ParserRuleContext {
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_typedefName }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypedefName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypedefName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypedefName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypedefName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typedefName() throws -> TypedefNameContext {
        var _localctx: TypedefNameContext
        _localctx = TypedefNameContext(_ctx, getState())
        try enterRule(_localctx, 242, ObjectiveCParser.RULE_typedefName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1605)
            try identifier()

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
        open func genericTypeList() -> GenericTypeListContext? {
            return getRuleContext(GenericTypeListContext.self, 0)
        }
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
        try enterRule(_localctx, 244, ObjectiveCParser.RULE_genericTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1607)
            try identifier()
            setState(1608)
            try genericTypeList()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericTypeListContext: ParserRuleContext {
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func genericTypeParameter() -> [GenericTypeParameterContext] {
            return getRuleContexts(GenericTypeParameterContext.self)
        }
        open func genericTypeParameter(_ i: Int) -> GenericTypeParameterContext? {
            return getRuleContext(GenericTypeParameterContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_genericTypeList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericTypeList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericTypeList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericTypeList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericTypeList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericTypeList() throws -> GenericTypeListContext {
        var _localctx: GenericTypeListContext
        _localctx = GenericTypeListContext(_ctx, getState())
        try enterRule(_localctx, 246, ObjectiveCParser.RULE_genericTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1610)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(1619)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
            {
                setState(1611)
                try genericTypeParameter()
                setState(1616)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1612)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1613)
                    try genericTypeParameter()

                    setState(1618)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(1621)
            try match(ObjectiveCParser.Tokens.GT.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericTypeParameterContext: ParserRuleContext {
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func COVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
        }
        open func CONTRAVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_genericTypeParameter
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericTypeParameter(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericTypeParameter(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericTypeParameter(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericTypeParameter(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericTypeParameter() throws -> GenericTypeParameterContext {
        var _localctx: GenericTypeParameterContext
        _localctx = GenericTypeParameterContext(_ctx, getState())
        try enterRule(_localctx, 248, ObjectiveCParser.RULE_genericTypeParameter)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1624)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 205, _ctx) {
            case 1:
                setState(1623)
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
            setState(1626)
            try typeName()

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
        open func BOOL_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BOOL_.rawValue, 0)
        }
        open func CBOOL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CBOOL.rawValue, 0)
        }
        open func COMPLEX() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMPLEX.rawValue, 0)
        }
        open func M128() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128.rawValue, 0)
        }
        open func M128D() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128D.rawValue, 0)
        }
        open func M128I() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.M128I.rawValue, 0)
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
        try enterRule(_localctx, 250, ObjectiveCParser.RULE_scalarTypeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1628)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 246_986_580_496) != 0
                || (Int64((_la - 112)) & ~0x3f) == 0 && ((Int64(1) << (_la - 112)) & 7) != 0)
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
        try enterRule(_localctx, 252, ObjectiveCParser.RULE_typeofExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1630)
            try match(ObjectiveCParser.Tokens.TYPEOF.rawValue)

            setState(1631)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1632)
            try expression(0)
            setState(1633)
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
        try enterRule(_localctx, 254, ObjectiveCParser.RULE_fieldDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1635)
            try fieldDeclarator()
            setState(1640)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1636)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1637)
                try fieldDeclarator()

                setState(1642)
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
        try enterRule(_localctx, 256, ObjectiveCParser.RULE_fieldDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1649)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 208, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1643)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1645)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1644)
                    try declarator()

                }

                setState(1647)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1648)
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
        try enterRule(_localctx, 258, ObjectiveCParser.RULE_enumSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1682)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ENUM:
                try enterOuterAlt(_localctx, 1)
                setState(1651)
                try match(ObjectiveCParser.Tokens.ENUM.rawValue)
                setState(1657)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 210, _ctx) {
                case 1:
                    setState(1653)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    {
                        setState(1652)
                        try identifier()

                    }

                    setState(1655)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(1656)
                    try typeName()

                    break
                default: break
                }
                setState(1670)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                    .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                    .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                    .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                    setState(1659)
                    try identifier()
                    setState(1664)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 211, _ctx) {
                    case 1:
                        setState(1660)
                        try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                        setState(1661)
                        try enumeratorList()
                        setState(1662)
                        try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                        break
                    default: break
                    }

                    break

                case .LBRACE:
                    setState(1666)
                    try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                    setState(1667)
                    try enumeratorList()
                    setState(1668)
                    try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            case .NS_ENUM, .NS_OPTIONS:
                try enterOuterAlt(_localctx, 2)
                setState(1672)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.NS_ENUM.rawValue
                    || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1673)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1674)
                try typeName()
                setState(1675)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1676)
                try identifier()
                setState(1677)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1678)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1679)
                try enumeratorList()
                setState(1680)
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
        try enterRule(_localctx, 260, ObjectiveCParser.RULE_enumeratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1684)
            try enumerator()
            setState(1689)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 214, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1685)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1686)
                    try enumerator()

                }
                setState(1691)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 214, _ctx)
            }
            setState(1693)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1692)
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
        try enterRule(_localctx, 262, ObjectiveCParser.RULE_enumerator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1695)
            try enumeratorIdentifier()
            setState(1698)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1696)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1697)
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
        try enterRule(_localctx, 264, ObjectiveCParser.RULE_enumeratorIdentifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1700)
            try identifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class VcSpecificModiferContext: ParserRuleContext {
        open func CDECL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CDECL.rawValue, 0)
        }
        open func CLRCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CLRCALL.rawValue, 0)
        }
        open func STDCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STDCALL.rawValue, 0)
        }
        open func FASTCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.FASTCALL.rawValue, 0)
        }
        open func THISCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.THISCALL.rawValue, 0)
        }
        open func VECTORCALL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.VECTORCALL.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_vcSpecificModifer }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterVcSpecificModifer(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitVcSpecificModifer(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitVcSpecificModifer(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitVcSpecificModifer(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func vcSpecificModifer() throws -> VcSpecificModiferContext {
        var _localctx: VcSpecificModiferContext
        _localctx = VcSpecificModiferContext(_ctx, getState())
        try enterRule(_localctx, 266, ObjectiveCParser.RULE_vcSpecificModifer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1702)
            _la = try _input.LA(1)
            if !((Int64((_la - 103)) & ~0x3f) == 0 && ((Int64(1) << (_la - 103)) & 119) != 0) {
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

    public class GccDeclaratorExtensionContext: ParserRuleContext {
        open func ASM() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASM.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func stringLiteral() -> [StringLiteralContext] {
            return getRuleContexts(StringLiteralContext.self)
        }
        open func stringLiteral(_ i: Int) -> StringLiteralContext? {
            return getRuleContext(StringLiteralContext.self, i)
        }
        open func gccAttributeSpecifier() -> GccAttributeSpecifierContext? {
            return getRuleContext(GccAttributeSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_gccDeclaratorExtension
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGccDeclaratorExtension(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGccDeclaratorExtension(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGccDeclaratorExtension(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGccDeclaratorExtension(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func gccDeclaratorExtension() throws -> GccDeclaratorExtensionContext {
        var _localctx: GccDeclaratorExtensionContext
        _localctx = GccDeclaratorExtensionContext(_ctx, getState())
        try enterRule(_localctx, 268, ObjectiveCParser.RULE_gccDeclaratorExtension)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1714)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ASM:
                try enterOuterAlt(_localctx, 1)
                setState(1704)
                try match(ObjectiveCParser.Tokens.ASM.rawValue)
                setState(1705)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1707)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1706)
                    try stringLiteral()

                    setState(1709)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
                setState(1711)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .ATTRIBUTE:
                try enterOuterAlt(_localctx, 2)
                setState(1713)
                try gccAttributeSpecifier()

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

    public class GccAttributeSpecifierContext: ParserRuleContext {
        open func ATTRIBUTE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue, 0)
        }
        open func LP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.LP.rawValue) }
        open func LP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
        }
        open func gccAttributeList() -> GccAttributeListContext? {
            return getRuleContext(GccAttributeListContext.self, 0)
        }
        open func RP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.RP.rawValue) }
        open func RP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_gccAttributeSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGccAttributeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGccAttributeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGccAttributeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGccAttributeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func gccAttributeSpecifier() throws -> GccAttributeSpecifierContext {
        var _localctx: GccAttributeSpecifierContext
        _localctx = GccAttributeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 270, ObjectiveCParser.RULE_gccAttributeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1716)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1717)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1718)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1719)
            try gccAttributeList()
            setState(1720)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1721)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GccAttributeListContext: ParserRuleContext {
        open func gccAttribute() -> [GccAttributeContext] {
            return getRuleContexts(GccAttributeContext.self)
        }
        open func gccAttribute(_ i: Int) -> GccAttributeContext? {
            return getRuleContext(GccAttributeContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_gccAttributeList }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGccAttributeList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGccAttributeList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGccAttributeList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGccAttributeList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func gccAttributeList() throws -> GccAttributeListContext {
        var _localctx: GccAttributeListContext
        _localctx = GccAttributeListContext(_ctx, getState())
        try enterRule(_localctx, 272, ObjectiveCParser.RULE_gccAttributeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1724)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
            {
                setState(1723)
                try gccAttribute()

            }

            setState(1732)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1726)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1728)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                {
                    setState(1727)
                    try gccAttribute()

                }

                setState(1734)
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

    public class GccAttributeContext: ParserRuleContext {
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func LP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.LP.rawValue) }
        open func LP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LP.rawValue, i)
        }
        open func RP() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.RP.rawValue) }
        open func RP(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RP.rawValue, i)
        }
        open func argumentExpressionList() -> ArgumentExpressionListContext? {
            return getRuleContext(ArgumentExpressionListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_gccAttribute }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGccAttribute(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGccAttribute(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGccAttribute(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGccAttribute(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func gccAttribute() throws -> GccAttributeContext {
        var _localctx: GccAttributeContext
        _localctx = GccAttributeContext(_ctx, getState())
        try enterRule(_localctx, 274, ObjectiveCParser.RULE_gccAttribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1735)
            _la = try _input.LA(1)
            if _la <= 0
                || ((Int64((_la - 147)) & ~0x3f) == 0 && ((Int64(1) << (_la - 147)) & 131) != 0)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1741)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1736)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1738)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(1737)
                    try argumentExpressionList()

                }

                setState(1740)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class Pointer_Context: ParserRuleContext {
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func declarationSpecifiers() -> DeclarationSpecifiersContext? {
            return getRuleContext(DeclarationSpecifiersContext.self, 0)
        }
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_pointer_ }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.enterPointer_(self) }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener { listener.exitPointer_(self) }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPointer_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPointer_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func pointer_() throws -> Pointer_Context {
        var _localctx: Pointer_Context
        _localctx = Pointer_Context(_ctx, getState())
        try enterRule(_localctx, 276, ObjectiveCParser.RULE_pointer_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1743)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1745)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_523_585) != 0
            {
                setState(1744)
                try declarationSpecifiers()

            }

            setState(1748)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1747)
                try pointer()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PointerContext: ParserRuleContext {
        open func pointerEntry() -> [PointerEntryContext] {
            return getRuleContexts(PointerEntryContext.self)
        }
        open func pointerEntry(_ i: Int) -> PointerEntryContext? {
            return getRuleContext(PointerEntryContext.self, i)
        }
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
        try enterRule(_localctx, 278, ObjectiveCParser.RULE_pointer)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1751)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1750)
                    try pointerEntry()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1753)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 226, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PointerEntryContext: ParserRuleContext {
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func typeQualifierList() -> TypeQualifierListContext? {
            return getRuleContext(TypeQualifierListContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_pointerEntry }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterPointerEntry(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitPointerEntry(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitPointerEntry(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitPointerEntry(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func pointerEntry() throws -> PointerEntryContext {
        var _localctx: PointerEntryContext
        _localctx = PointerEntryContext(_ctx, getState())
        try enterRule(_localctx, 280, ObjectiveCParser.RULE_pointerEntry)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1755)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)

            setState(1757)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 227, _ctx) {
            case 1:
                setState(1756)
                try typeQualifierList()

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
        open var _RP: Token!
        open var macroArguments: [Token] = [Token]()
        open var _tset3149: Token!
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
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
        try enterRule(_localctx, 282, ObjectiveCParser.RULE_macro)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1759)
            try identifier()
            setState(1768)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1760)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1763)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1763)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 228, _ctx) {
                    case 1:
                        setState(1761)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                        break
                    case 2:
                        setState(1762)
                        _localctx.castdown(MacroContext.self)._tset3149 = try _input.LT(1)
                        _la = try _input.LA(1)
                        if _la <= 0 || (_la == ObjectiveCParser.Tokens.RP.rawValue) {
                            _localctx.castdown(MacroContext.self)._tset3149 =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        _localctx.castdown(MacroContext.self).macroArguments.append(
                            _localctx.castdown(MacroContext.self)._tset3149)

                        break
                    default: break
                    }

                    setState(1765)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -1_048_577) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                setState(1767)
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
        try enterRule(_localctx, 284, ObjectiveCParser.RULE_arrayInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1770)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1782)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1771)
                try expression(0)
                setState(1776)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 231, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1772)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1773)
                        try expression(0)

                    }
                    setState(1778)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 231, _ctx)
                }
                setState(1780)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1779)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1784)
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
        try enterRule(_localctx, 286, ObjectiveCParser.RULE_structInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1786)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1798)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue
                || _la == ObjectiveCParser.Tokens.DOT.rawValue
            {
                setState(1787)
                try structInitializerItem()
                setState(1792)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 234, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1788)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1789)
                        try structInitializerItem()

                    }
                    setState(1794)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 234, _ctx)
                }
                setState(1796)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1795)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1800)
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
        try enterRule(_localctx, 288, ObjectiveCParser.RULE_structInitializerItem)
        defer { try! exitRule() }
        do {
            setState(1806)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 237, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1802)
                try match(ObjectiveCParser.Tokens.DOT.rawValue)
                setState(1803)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1804)
                try structInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1805)
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
        try enterRule(_localctx, 290, ObjectiveCParser.RULE_initializerList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1808)
            try initializer()
            setState(1813)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 238, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1809)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1810)
                    try initializer()

                }
                setState(1815)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 238, _ctx)
            }
            setState(1817)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1816)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StaticAssertDeclarationContext: ParserRuleContext {
        open func STATIC_ASSERT_() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STATIC_ASSERT_.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
        open func COMMA() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func stringLiteral() -> [StringLiteralContext] {
            return getRuleContexts(StringLiteralContext.self)
        }
        open func stringLiteral(_ i: Int) -> StringLiteralContext? {
            return getRuleContext(StringLiteralContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_staticAssertDeclaration
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStaticAssertDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStaticAssertDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStaticAssertDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStaticAssertDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func staticAssertDeclaration() throws -> StaticAssertDeclarationContext
    {
        var _localctx: StaticAssertDeclarationContext
        _localctx = StaticAssertDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 292, ObjectiveCParser.RULE_staticAssertDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1819)
            try match(ObjectiveCParser.Tokens.STATIC_ASSERT_.rawValue)
            setState(1820)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1821)
            try constantExpression()
            setState(1822)
            try match(ObjectiveCParser.Tokens.COMMA.rawValue)
            setState(1824)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1823)
                try stringLiteral()

                setState(1826)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
            setState(1828)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1829)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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
        try enterRule(_localctx, 294, ObjectiveCParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(1869)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 248, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1831)
                try labeledStatement()
                setState(1833)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 241, _ctx) {
                case 1:
                    setState(1832)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1835)
                try compoundStatement()
                setState(1837)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 242, _ctx) {
                case 1:
                    setState(1836)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1839)
                try selectionStatement()
                setState(1841)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 243, _ctx) {
                case 1:
                    setState(1840)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1843)
                try iterationStatement()
                setState(1845)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 244, _ctx) {
                case 1:
                    setState(1844)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1847)
                try jumpStatement()
                setState(1848)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1850)
                try synchronizedStatement()
                setState(1852)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 245, _ctx) {
                case 1:
                    setState(1851)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1854)
                try autoreleaseStatement()
                setState(1856)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 246, _ctx) {
                case 1:
                    setState(1855)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1858)
                try throwStatement()
                setState(1859)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(1861)
                try tryBlock()
                setState(1863)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 247, _ctx) {
                case 1:
                    setState(1862)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(1865)
                try expressions()
                setState(1866)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(1868)
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
        try enterRule(_localctx, 296, ObjectiveCParser.RULE_labeledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1871)
            try identifier()
            setState(1872)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(1873)
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
        try enterRule(_localctx, 298, ObjectiveCParser.RULE_rangeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1875)
            try expression(0)
            setState(1878)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue {
                setState(1876)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
                setState(1877)
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
        open func statement() -> [StatementContext] {
            return getRuleContexts(StatementContext.self)
        }
        open func statement(_ i: Int) -> StatementContext? {
            return getRuleContext(StatementContext.self, i)
        }
        open func declaration() -> [DeclarationContext] {
            return getRuleContexts(DeclarationContext.self)
        }
        open func declaration(_ i: Int) -> DeclarationContext? {
            return getRuleContext(DeclarationContext.self, i)
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
        try enterRule(_localctx, 300, ObjectiveCParser.RULE_compoundStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1880)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1885)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_305_842_734_335_785_846) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -63_505_386_520_447) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 3_087_455_002_300_415) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 255) != 0
            {
                setState(1883)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 250, _ctx) {
                case 1:
                    setState(1881)
                    try statement()

                    break
                case 2:
                    setState(1882)
                    try declaration()

                    break
                default: break
                }

                setState(1887)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1888)
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
        try enterRule(_localctx, 302, ObjectiveCParser.RULE_selectionStatement)
        defer { try! exitRule() }
        do {
            setState(1900)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IF:
                try enterOuterAlt(_localctx, 1)
                setState(1890)
                try match(ObjectiveCParser.Tokens.IF.rawValue)
                setState(1891)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1892)
                try expressions()
                setState(1893)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1894)
                try {
                    let assignmentValue = try statement()
                    _localctx.castdown(SelectionStatementContext.self).ifBody = assignmentValue
                }()

                setState(1897)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 252, _ctx) {
                case 1:
                    setState(1895)
                    try match(ObjectiveCParser.Tokens.ELSE.rawValue)
                    setState(1896)
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
                setState(1899)
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
        try enterRule(_localctx, 304, ObjectiveCParser.RULE_switchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1902)
            try match(ObjectiveCParser.Tokens.SWITCH.rawValue)
            setState(1903)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1904)
            try expression(0)
            setState(1905)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1906)
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
        try enterRule(_localctx, 306, ObjectiveCParser.RULE_switchBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1908)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1912)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            {
                setState(1909)
                try switchSection()

                setState(1914)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1915)
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
        try enterRule(_localctx, 308, ObjectiveCParser.RULE_switchSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1918)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1917)
                try switchLabel()

                setState(1920)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            setState(1923)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1922)
                try statement()

                setState(1925)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & 2_305_840_277_920_792_900) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -71_916_785_737_219_967) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 3_087_455_002_300_415) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 255) != 0

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
        try enterRule(_localctx, 310, ObjectiveCParser.RULE_switchLabel)
        defer { try! exitRule() }
        do {
            setState(1939)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CASE:
                try enterOuterAlt(_localctx, 1)
                setState(1927)
                try match(ObjectiveCParser.Tokens.CASE.rawValue)
                setState(1933)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 257, _ctx) {
                case 1:
                    setState(1928)
                    try rangeExpression()

                    break
                case 2:
                    setState(1929)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(1930)
                    try rangeExpression()
                    setState(1931)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }
                setState(1935)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 2)
                setState(1937)
                try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)
                setState(1938)
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
        try enterRule(_localctx, 312, ObjectiveCParser.RULE_iterationStatement)
        defer { try! exitRule() }
        do {
            setState(1945)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 259, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1941)
                try whileStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1942)
                try doStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1943)
                try forStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1944)
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
        try enterRule(_localctx, 314, ObjectiveCParser.RULE_whileStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1947)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1948)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1949)
            try expression(0)
            setState(1950)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1951)
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
        try enterRule(_localctx, 316, ObjectiveCParser.RULE_doStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1953)
            try match(ObjectiveCParser.Tokens.DO.rawValue)
            setState(1954)
            try statement()
            setState(1955)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1956)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1957)
            try expression(0)
            setState(1958)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1959)
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
        try enterRule(_localctx, 318, ObjectiveCParser.RULE_forStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1961)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1962)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1964)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_921_212_276_324_914) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -36_092_302_405_910_399) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 3_087_454_966_648_831) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 255) != 0
            {
                setState(1963)
                try forLoopInitializer()

            }

            setState(1966)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1968)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1967)
                try expression(0)

            }

            setState(1970)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1972)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1971)
                try expressions()

            }

            setState(1974)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1975)
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
        try enterRule(_localctx, 320, ObjectiveCParser.RULE_forLoopInitializer)
        defer { try! exitRule() }
        do {
            setState(1981)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 263, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1977)
                try declarationSpecifiers()
                setState(1978)
                try initDeclaratorList()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1980)
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
        try enterRule(_localctx, 322, ObjectiveCParser.RULE_forInStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1983)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1984)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1985)
            try typeVariableDeclarator()
            setState(1986)
            try match(ObjectiveCParser.Tokens.IN.rawValue)
            setState(1988)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1987)
                try expression(0)

            }

            setState(1990)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1991)
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
        try enterRule(_localctx, 324, ObjectiveCParser.RULE_jumpStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2001)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .GOTO:
                try enterOuterAlt(_localctx, 1)
                setState(1993)
                try match(ObjectiveCParser.Tokens.GOTO.rawValue)
                setState(1994)
                try identifier()

                break

            case .CONTINUE:
                try enterOuterAlt(_localctx, 2)
                setState(1995)
                try match(ObjectiveCParser.Tokens.CONTINUE.rawValue)

                break

            case .BREAK:
                try enterOuterAlt(_localctx, 3)
                setState(1996)
                try match(ObjectiveCParser.Tokens.BREAK.rawValue)

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 4)
                setState(1997)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)
                setState(1999)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(1998)
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
        try enterRule(_localctx, 326, ObjectiveCParser.RULE_expressions)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2003)
            try expression(0)
            setState(2008)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 267, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2004)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(2005)
                    try expression(0)

                }
                setState(2010)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 267, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ExpressionContext: ParserRuleContext {
        open var op: Token!
        open var trueExpression: ExpressionContext!
        open var falseExpression: ExpressionContext!
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        open func assignmentExpression() -> AssignmentExpressionContext? {
            return getRuleContext(AssignmentExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func expression() -> [ExpressionContext] {
            return getRuleContexts(ExpressionContext.self)
        }
        open func expression(_ i: Int) -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, i)
        }
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
        let _startState: Int = 328
        try enterRecursionRule(_localctx, 328, ObjectiveCParser.RULE_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2018)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 268, _ctx) {
            case 1:
                setState(2012)
                try castExpression()

                break
            case 2:
                setState(2013)
                try assignmentExpression()

                break
            case 3:
                setState(2014)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2015)
                try compoundStatement()
                setState(2016)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(2064)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 272, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(2062)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 271, _ctx) {
                    case 1:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2020)
                        if !(precpred(_ctx, 13)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 13)"))
                        }
                        setState(2021)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64((_la - 175)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 175)) & 35) != 0)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(2022)
                        try expression(14)

                        break
                    case 2:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2023)
                        if !(precpred(_ctx, 12)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 12)"))
                        }
                        setState(2024)
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
                        setState(2025)
                        try expression(13)

                        break
                    case 3:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2026)
                        if !(precpred(_ctx, 11)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 11)"))
                        }
                        setState(2031)
                        try _errHandler.sync(self)
                        switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                        case .LT:
                            setState(2027)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)
                            setState(2028)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)

                            break

                        case .GT:
                            setState(2029)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)
                            setState(2030)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)

                            break
                        default: throw ANTLRException.recognition(e: NoViableAltException(self))
                        }
                        setState(2033)
                        try expression(12)

                        break
                    case 4:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2034)
                        if !(precpred(_ctx, 10)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 10)"))
                        }
                        setState(2035)
                        _localctx.castdown(ExpressionContext.self).op = try _input.LT(1)
                        _la = try _input.LA(1)
                        if !((Int64((_la - 159)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 159)) & 387) != 0)
                        {
                            _localctx.castdown(ExpressionContext.self).op =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        setState(2036)
                        try expression(11)

                        break
                    case 5:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2037)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(2038)
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
                        setState(2039)
                        try expression(10)

                        break
                    case 6:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2040)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(2041)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITAND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2042)
                        try expression(9)

                        break
                    case 7:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2043)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(2044)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2045)
                        try expression(8)

                        break
                    case 8:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2046)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(2047)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2048)
                        try expression(7)

                        break
                    case 9:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2049)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(2050)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.AND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2051)
                        try expression(6)

                        break
                    case 10:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2052)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(2053)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.OR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2054)
                        try expression(5)

                        break
                    case 11:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2055)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(2056)
                        try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
                        setState(2058)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                            || (Int64((_la - 90)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                        {
                            setState(2057)
                            try {
                                let assignmentValue = try expression(0)
                                _localctx.castdown(ExpressionContext.self).trueExpression =
                                    assignmentValue
                            }()

                        }

                        setState(2060)
                        try match(ObjectiveCParser.Tokens.COLON.rawValue)
                        setState(2061)
                        try {
                            let assignmentValue = try expression(4)
                            _localctx.castdown(ExpressionContext.self).falseExpression =
                                assignmentValue
                        }()

                        break
                    default: break
                    }
                }
                setState(2066)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 272, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class AssignmentExpressionContext: ParserRuleContext {
        open func unaryExpression() -> UnaryExpressionContext? {
            return getRuleContext(UnaryExpressionContext.self, 0)
        }
        open func assignmentOperator() -> AssignmentOperatorContext? {
            return getRuleContext(AssignmentOperatorContext.self, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_assignmentExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAssignmentExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAssignmentExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAssignmentExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAssignmentExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func assignmentExpression() throws -> AssignmentExpressionContext {
        var _localctx: AssignmentExpressionContext
        _localctx = AssignmentExpressionContext(_ctx, getState())
        try enterRule(_localctx, 330, ObjectiveCParser.RULE_assignmentExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2067)
            try unaryExpression()
            setState(2068)
            try assignmentOperator()
            setState(2069)
            try expression(0)

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
        try enterRule(_localctx, 332, ObjectiveCParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2071)
            _la = try _input.LA(1)
            if !((Int64((_la - 158)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 158)) & 8_581_545_985) != 0)
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
        open func EXTENSION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EXTENSION.rawValue, 0)
        }
        open func DIGITS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIGITS.rawValue, 0)
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
        try enterRule(_localctx, 334, ObjectiveCParser.RULE_castExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2084)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 274, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2073)
                try unaryExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2075)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.EXTENSION.rawValue {
                    setState(2074)
                    try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)

                }

                setState(2077)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2078)
                try typeName()
                setState(2079)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                setState(2081)
                try castExpression()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2083)
                try match(ObjectiveCParser.Tokens.DIGITS.rawValue)

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
        try enterRule(_localctx, 336, ObjectiveCParser.RULE_initializer)
        defer { try! exitRule() }
        do {
            setState(2089)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 275, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2086)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2087)
                try arrayInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2088)
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
        try enterRule(_localctx, 338, ObjectiveCParser.RULE_constantExpression)
        defer { try! exitRule() }
        do {
            setState(2093)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .AUTORELEASING_QUALIFIER,
                .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT, .DEPRECATED,
                .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE,
                .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY,
                .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(2091)
                try identifier()

                break
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                try enterOuterAlt(_localctx, 2)
                setState(2092)
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
        try enterRule(_localctx, 340, ObjectiveCParser.RULE_unaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2109)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 278, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2095)
                try postfixExpression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2096)
                try match(ObjectiveCParser.Tokens.SIZEOF.rawValue)
                setState(2102)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 277, _ctx) {
                case 1:
                    setState(2097)
                    try unaryExpression()

                    break
                case 2:
                    setState(2098)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(2099)
                    try typeSpecifier()
                    setState(2100)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2104)
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
                setState(2105)
                try unaryExpression()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2106)
                try unaryOperator()
                setState(2107)
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
        try enterRule(_localctx, 342, ObjectiveCParser.RULE_unaryOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2111)
            _la = try _input.LA(1)
            if !((Int64((_la - 161)) & ~0x3f) == 0 && ((Int64(1) << (_la - 161)) & 94211) != 0) {
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
        let _startState: Int = 344
        try enterRecursionRule(_localctx, 344, ObjectiveCParser.RULE_postfixExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2114)
            try primaryExpression()
            setState(2118)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 279, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2115)
                    try postfixExpr()

                }
                setState(2120)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 279, _ctx)
            }

            _ctx!.stop = try _input.LT(-1)
            setState(2132)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 281, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    _localctx = PostfixExpressionContext(_parentctx, _parentState)
                    try pushNewRecursionContext(
                        _localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
                    setState(2121)
                    if !(precpred(_ctx, 1)) {
                        throw ANTLRException.recognition(
                            e: FailedPredicateException(self, "precpred(_ctx, 1)"))
                    }
                    setState(2122)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.DOT.rawValue
                        || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }
                    setState(2123)
                    try identifier()
                    setState(2127)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 280, _ctx)
                    while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                        if _alt == 1 {
                            setState(2124)
                            try postfixExpr()

                        }
                        setState(2129)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 280, _ctx)
                    }

                }
                setState(2134)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 281, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class PostfixExprContext: ParserRuleContext {
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
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func argumentExpressionList() -> ArgumentExpressionListContext? {
            return getRuleContext(ArgumentExpressionListContext.self, 0)
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
        try enterRule(_localctx, 346, ObjectiveCParser.RULE_postfixExpr)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2145)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(2135)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(2136)
                try expression(0)
                setState(2137)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(2139)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2141)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(2140)
                    try argumentExpressionList()

                }

                setState(2143)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case .INC, .DEC:
                try enterOuterAlt(_localctx, 3)
                setState(2144)
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
            default: throw ANTLRException.recognition(e: NoViableAltException(self))
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
        try enterRule(_localctx, 348, ObjectiveCParser.RULE_argumentExpressionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2147)
            try argumentExpression()
            setState(2152)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(2148)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(2149)
                try argumentExpression()

                setState(2154)
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
        try enterRule(_localctx, 350, ObjectiveCParser.RULE_argumentExpression)
        defer { try! exitRule() }
        do {
            setState(2157)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 285, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2155)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2156)
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
        try enterRule(_localctx, 352, ObjectiveCParser.RULE_primaryExpression)
        defer { try! exitRule() }
        do {
            setState(2174)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 286, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2159)
                try identifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2160)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2161)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2162)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2163)
                try expression(0)
                setState(2164)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2166)
                try messageExpression()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2167)
                try selectorExpression()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2168)
                try protocolExpression()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2169)
                try encodeExpression()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2170)
                try dictionaryExpression()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2171)
                try arrayExpression()

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2172)
                try boxExpression()

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2173)
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
        try enterRule(_localctx, 354, ObjectiveCParser.RULE_constant)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2194)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 289, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2176)
                try match(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2177)
                try match(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2178)
                try match(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2180)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2179)
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

                setState(2182)
                try match(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2184)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2183)
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

                setState(2186)
                try match(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2187)
                try match(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue)

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2188)
                try match(ObjectiveCParser.Tokens.NIL.rawValue)

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2189)
                try match(ObjectiveCParser.Tokens.NULL.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2190)
                try match(ObjectiveCParser.Tokens.YES.rawValue)

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2191)
                try match(ObjectiveCParser.Tokens.NO.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2192)
                try match(ObjectiveCParser.Tokens.TRUE.rawValue)

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2193)
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
        try enterRule(_localctx, 356, ObjectiveCParser.RULE_stringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2204)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(2196)
                    try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
                    setState(2200)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                        || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
                    {
                        setState(2197)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                            || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }

                        setState(2202)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }
                    setState(2203)
                    try match(ObjectiveCParser.Tokens.STRING_END.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(2206)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 291, _ctx)
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
        try enterRule(_localctx, 358, ObjectiveCParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2208)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0)
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
        case 93:
            return try directDeclarator_sempred(
                _localctx?.castdown(DirectDeclaratorContext.self), predIndex)
        case 97:
            return try directAbstractDeclarator_sempred(
                _localctx?.castdown(DirectAbstractDeclaratorContext.self), predIndex)
        case 164:
            return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
        case 172:
            return try postfixExpression_sempred(
                _localctx?.castdown(PostfixExpressionContext.self), predIndex)
        default: return true
        }
    }
    private func directDeclarator_sempred(_ _localctx: DirectDeclaratorContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 0: return precpred(_ctx, 9)
        case 1: return precpred(_ctx, 8)
        case 2: return precpred(_ctx, 7)
        case 3: return precpred(_ctx, 6)
        case 4: return precpred(_ctx, 5)
        default: return true
        }
    }
    private func directAbstractDeclarator_sempred(
        _ _localctx: DirectAbstractDeclaratorContext!, _ predIndex: Int
    ) throws -> Bool {
        switch predIndex {
        case 5: return precpred(_ctx, 6)
        case 6: return precpred(_ctx, 5)
        case 7: return precpred(_ctx, 4)
        case 8: return precpred(_ctx, 3)
        case 9: return precpred(_ctx, 2)
        default: return true
        }
    }
    private func expression_sempred(_ _localctx: ExpressionContext!, _ predIndex: Int) throws
        -> Bool
    {
        switch predIndex {
        case 10: return precpred(_ctx, 13)
        case 11: return precpred(_ctx, 12)
        case 12: return precpred(_ctx, 11)
        case 13: return precpred(_ctx, 10)
        case 14: return precpred(_ctx, 9)
        case 15: return precpred(_ctx, 8)
        case 16: return precpred(_ctx, 7)
        case 17: return precpred(_ctx, 6)
        case 18: return precpred(_ctx, 5)
        case 19: return precpred(_ctx, 4)
        case 20: return precpred(_ctx, 3)
        default: return true
        }
    }
    private func postfixExpression_sempred(_ _localctx: PostfixExpressionContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 21: return precpred(_ctx, 1)
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 248, 2211, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
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
        7, 155, 2, 156, 7, 156, 2, 157, 7, 157, 2, 158, 7, 158, 2, 159, 7, 159, 2, 160, 7, 160, 2,
        161, 7, 161, 2, 162, 7, 162, 2, 163, 7, 163, 2, 164, 7, 164, 2, 165, 7, 165, 2, 166, 7, 166,
        2, 167, 7, 167, 2, 168, 7, 168, 2, 169, 7, 169, 2, 170, 7, 170, 2, 171, 7, 171, 2, 172, 7,
        172, 2, 173, 7, 173, 2, 174, 7, 174, 2, 175, 7, 175, 2, 176, 7, 176, 2, 177, 7, 177, 2, 178,
        7, 178, 2, 179, 7, 179, 1, 0, 5, 0, 362, 8, 0, 10, 0, 12, 0, 365, 9, 0, 1, 0, 1, 0, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 379, 8, 1, 1, 2, 1, 2, 1, 2, 1, 2,
        1, 3, 3, 3, 386, 8, 3, 1, 3, 1, 3, 1, 3, 3, 3, 391, 8, 3, 1, 3, 3, 3, 394, 8, 3, 1, 3, 1, 3,
        1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 402, 8, 4, 3, 4, 404, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 410,
        8, 4, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 416, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 423, 8,
        5, 1, 5, 3, 5, 426, 8, 5, 1, 5, 3, 5, 429, 8, 5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 3, 6, 436, 8,
        6, 1, 6, 3, 6, 439, 8, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 3, 7, 447, 8, 7, 3, 7, 449, 8,
        7, 1, 8, 1, 8, 1, 8, 1, 8, 3, 8, 455, 8, 8, 1, 8, 1, 8, 3, 8, 459, 8, 8, 1, 8, 1, 8, 1, 9,
        1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 3, 9, 469, 8, 9, 1, 10, 1, 10, 1, 11, 1, 11, 1, 11, 1, 12, 1,
        12, 1, 12, 1, 12, 5, 12, 480, 8, 12, 10, 12, 12, 12, 483, 9, 12, 3, 12, 485, 8, 12, 1, 12,
        1, 12, 1, 13, 5, 13, 490, 8, 13, 10, 13, 12, 13, 493, 9, 13, 1, 13, 1, 13, 3, 13, 497, 8,
        13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 505, 8, 14, 1, 14, 5, 14, 508, 8, 14,
        10, 14, 12, 14, 511, 9, 14, 1, 14, 1, 14, 1, 15, 1, 15, 5, 15, 517, 8, 15, 10, 15, 12, 15,
        520, 9, 15, 1, 15, 4, 15, 523, 8, 15, 11, 15, 12, 15, 524, 3, 15, 527, 8, 15, 1, 16, 1, 16,
        1, 16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17, 537, 8, 17, 10, 17, 12, 17, 540, 9, 17, 1,
        17, 1, 17, 1, 18, 1, 18, 1, 18, 5, 18, 547, 8, 18, 10, 18, 12, 18, 550, 9, 18, 1, 19, 1, 19,
        1, 19, 1, 19, 1, 19, 3, 19, 557, 8, 19, 1, 19, 3, 19, 560, 8, 19, 1, 19, 3, 19, 563, 8, 19,
        1, 19, 1, 19, 1, 20, 1, 20, 1, 20, 5, 20, 570, 8, 20, 10, 20, 12, 20, 573, 9, 20, 1, 21, 1,
        21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1,
        21, 1, 21, 1, 21, 1, 21, 1, 21, 3, 21, 594, 8, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 3, 22,
        601, 8, 22, 1, 22, 3, 22, 604, 8, 22, 1, 23, 1, 23, 5, 23, 608, 8, 23, 10, 23, 12, 23, 611,
        9, 23, 1, 23, 1, 23, 1, 24, 1, 24, 5, 24, 617, 8, 24, 10, 24, 12, 24, 620, 9, 24, 1, 24, 4,
        24, 623, 8, 24, 11, 24, 12, 24, 624, 3, 24, 627, 8, 24, 1, 25, 1, 25, 1, 26, 1, 26, 1, 26,
        1, 26, 1, 26, 4, 26, 636, 8, 26, 11, 26, 12, 26, 637, 1, 27, 1, 27, 1, 27, 1, 28, 1, 28, 1,
        28, 1, 29, 3, 29, 647, 8, 29, 1, 29, 1, 29, 5, 29, 651, 8, 29, 10, 29, 12, 29, 654, 9, 29,
        1, 29, 3, 29, 657, 8, 29, 1, 29, 1, 29, 1, 30, 1, 30, 1, 30, 1, 30, 1, 30, 4, 30, 666, 8,
        30, 11, 30, 12, 30, 667, 1, 31, 1, 31, 1, 31, 1, 32, 1, 32, 1, 32, 1, 33, 3, 33, 677, 8, 33,
        1, 33, 1, 33, 3, 33, 681, 8, 33, 1, 33, 3, 33, 684, 8, 33, 1, 33, 3, 33, 687, 8, 33, 1, 33,
        1, 33, 3, 33, 691, 8, 33, 1, 34, 1, 34, 4, 34, 695, 8, 34, 11, 34, 12, 34, 696, 1, 34, 1,
        34, 3, 34, 701, 8, 34, 3, 34, 703, 8, 34, 1, 35, 3, 35, 706, 8, 35, 1, 35, 1, 35, 5, 35,
        710, 8, 35, 10, 35, 12, 35, 713, 9, 35, 1, 35, 3, 35, 716, 8, 35, 1, 35, 1, 35, 1, 36, 1,
        36, 1, 36, 1, 36, 1, 36, 1, 36, 3, 36, 726, 8, 36, 1, 37, 1, 37, 1, 37, 1, 37, 1, 38, 1, 38,
        1, 38, 1, 38, 1, 38, 1, 38, 1, 38, 1, 38, 3, 38, 740, 8, 38, 1, 39, 1, 39, 1, 39, 5, 39,
        745, 8, 39, 10, 39, 12, 39, 748, 9, 39, 1, 40, 1, 40, 1, 40, 3, 40, 753, 8, 40, 1, 41, 3,
        41, 756, 8, 41, 1, 41, 1, 41, 3, 41, 760, 8, 41, 1, 41, 1, 41, 1, 41, 1, 41, 3, 41, 766, 8,
        41, 1, 41, 1, 41, 3, 41, 770, 8, 41, 1, 42, 1, 42, 1, 42, 1, 42, 1, 42, 5, 42, 777, 8, 42,
        10, 42, 12, 42, 780, 9, 42, 1, 42, 3, 42, 783, 8, 42, 3, 42, 785, 8, 42, 1, 42, 1, 42, 1,
        43, 1, 43, 1, 43, 1, 43, 1, 44, 1, 44, 1, 44, 1, 44, 3, 44, 797, 8, 44, 3, 44, 799, 8, 44,
        1, 44, 1, 44, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 3, 45, 811, 8, 45, 3,
        45, 813, 8, 45, 1, 46, 1, 46, 1, 46, 1, 46, 3, 46, 819, 8, 46, 1, 46, 1, 46, 5, 46, 823, 8,
        46, 10, 46, 12, 46, 826, 9, 46, 3, 46, 828, 8, 46, 1, 46, 3, 46, 831, 8, 46, 1, 47, 1, 47,
        3, 47, 835, 8, 47, 1, 48, 1, 48, 3, 48, 839, 8, 48, 1, 48, 3, 48, 842, 8, 48, 1, 48, 3, 48,
        845, 8, 48, 1, 48, 1, 48, 1, 49, 1, 49, 3, 49, 851, 8, 49, 1, 49, 1, 49, 1, 50, 1, 50, 1,
        50, 1, 50, 1, 50, 1, 51, 1, 51, 3, 51, 862, 8, 51, 1, 52, 1, 52, 4, 52, 866, 8, 52, 11, 52,
        12, 52, 867, 3, 52, 870, 8, 52, 1, 53, 3, 53, 873, 8, 53, 1, 53, 1, 53, 1, 53, 1, 53, 5, 53,
        879, 8, 53, 10, 53, 12, 53, 882, 9, 53, 1, 54, 1, 54, 3, 54, 886, 8, 54, 1, 54, 1, 54, 1,
        54, 1, 54, 3, 54, 892, 8, 54, 1, 55, 1, 55, 1, 55, 1, 55, 1, 55, 1, 56, 1, 56, 3, 56, 901,
        8, 56, 1, 56, 4, 56, 904, 8, 56, 11, 56, 12, 56, 905, 3, 56, 908, 8, 56, 1, 57, 1, 57, 1,
        57, 1, 57, 1, 57, 1, 58, 1, 58, 1, 58, 1, 58, 1, 58, 1, 59, 1, 59, 1, 59, 1, 60, 1, 60, 1,
        60, 1, 60, 1, 60, 1, 60, 1, 60, 3, 60, 930, 8, 60, 1, 61, 1, 61, 1, 61, 5, 61, 935, 8, 61,
        10, 61, 12, 61, 938, 9, 61, 1, 61, 1, 61, 3, 61, 942, 8, 61, 1, 62, 1, 62, 1, 62, 1, 62, 1,
        62, 1, 62, 1, 63, 1, 63, 1, 63, 1, 63, 1, 63, 1, 63, 1, 64, 1, 64, 1, 64, 1, 65, 1, 65, 1,
        65, 1, 66, 1, 66, 1, 66, 1, 67, 3, 67, 966, 8, 67, 1, 67, 1, 67, 3, 67, 970, 8, 67, 1, 68,
        4, 68, 973, 8, 68, 11, 68, 12, 68, 974, 1, 69, 1, 69, 3, 69, 979, 8, 69, 1, 70, 1, 70, 3,
        70, 983, 8, 70, 1, 71, 1, 71, 3, 71, 987, 8, 71, 1, 71, 1, 71, 1, 72, 1, 72, 1, 72, 5, 72,
        994, 8, 72, 10, 72, 12, 72, 997, 9, 72, 1, 73, 1, 73, 1, 73, 1, 73, 3, 73, 1003, 8, 73, 1,
        74, 1, 74, 1, 74, 1, 74, 1, 74, 3, 74, 1010, 8, 74, 1, 75, 1, 75, 1, 75, 1, 75, 3, 75, 1016,
        8, 75, 1, 75, 1, 75, 1, 75, 3, 75, 1021, 8, 75, 1, 75, 1, 75, 1, 76, 1, 76, 1, 76, 3, 76,
        1028, 8, 76, 1, 77, 1, 77, 1, 77, 5, 77, 1033, 8, 77, 10, 77, 12, 77, 1036, 9, 77, 1, 78, 1,
        78, 3, 78, 1040, 8, 78, 1, 78, 3, 78, 1043, 8, 78, 1, 78, 3, 78, 1046, 8, 78, 1, 79, 3, 79,
        1049, 8, 79, 1, 79, 1, 79, 3, 79, 1053, 8, 79, 1, 79, 1, 79, 1, 79, 1, 79, 1, 79, 1, 80, 3,
        80, 1061, 8, 80, 1, 80, 3, 80, 1064, 8, 80, 1, 80, 1, 80, 3, 80, 1068, 8, 80, 1, 80, 1, 80,
        1, 81, 1, 81, 1, 81, 1, 81, 3, 81, 1076, 8, 81, 1, 81, 1, 81, 1, 82, 3, 82, 1081, 8, 82, 1,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1088, 8, 82, 1, 82, 3, 82, 1091, 8, 82, 1, 82, 1, 82,
        1, 82, 3, 82, 1096, 8, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1102, 8, 82, 1, 83, 1, 83, 1,
        83, 5, 83, 1107, 8, 83, 10, 83, 12, 83, 1110, 9, 83, 1, 84, 1, 84, 1, 84, 1, 84, 1, 84, 1,
        84, 1, 84, 1, 84, 4, 84, 1120, 8, 84, 11, 84, 12, 84, 1121, 1, 85, 1, 85, 1, 85, 1, 85, 1,
        85, 1, 85, 1, 85, 1, 85, 3, 85, 1132, 8, 85, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1,
        86, 1, 86, 3, 86, 1142, 8, 86, 1, 87, 3, 87, 1145, 8, 87, 1, 87, 4, 87, 1148, 8, 87, 11, 87,
        12, 87, 1149, 1, 88, 3, 88, 1153, 8, 88, 1, 88, 4, 88, 1156, 8, 88, 11, 88, 12, 88, 1157, 1,
        89, 1, 89, 3, 89, 1162, 8, 89, 1, 89, 1, 89, 1, 89, 3, 89, 1167, 8, 89, 1, 90, 1, 90, 1, 90,
        5, 90, 1172, 8, 90, 10, 90, 12, 90, 1175, 9, 90, 1, 91, 1, 91, 1, 91, 3, 91, 1180, 8, 91, 1,
        92, 3, 92, 1183, 8, 92, 1, 92, 1, 92, 5, 92, 1187, 8, 92, 10, 92, 12, 92, 1190, 9, 92, 1,
        93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1201, 8, 93, 1, 93, 3,
        93, 1204, 8, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1,
        93, 1, 93, 1, 93, 1, 93, 3, 93, 1220, 8, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1225, 8, 93, 1, 93,
        3, 93, 1228, 8, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1235, 8, 93, 1, 93, 1, 93, 1,
        93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1250, 8,
        93, 1, 93, 1, 93, 1, 93, 1, 93, 1, 93, 3, 93, 1257, 8, 93, 1, 93, 5, 93, 1260, 8, 93, 10,
        93, 12, 93, 1263, 9, 93, 1, 94, 1, 94, 3, 94, 1267, 8, 94, 1, 95, 1, 95, 3, 95, 1271, 8, 95,
        1, 95, 1, 95, 3, 95, 1275, 8, 95, 1, 95, 1, 95, 4, 95, 1279, 8, 95, 11, 95, 12, 95, 1280, 1,
        95, 1, 95, 3, 95, 1285, 8, 95, 1, 95, 4, 95, 1288, 8, 95, 11, 95, 12, 95, 1289, 3, 95, 1292,
        8, 95, 1, 96, 1, 96, 3, 96, 1296, 8, 96, 1, 96, 1, 96, 5, 96, 1300, 8, 96, 10, 96, 12, 96,
        1303, 9, 96, 3, 96, 1305, 8, 96, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 5, 97, 1312, 8, 97, 10,
        97, 12, 97, 1315, 9, 97, 1, 97, 1, 97, 3, 97, 1319, 8, 97, 1, 97, 3, 97, 1322, 8, 97, 1, 97,
        1, 97, 1, 97, 1, 97, 3, 97, 1328, 8, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1,
        97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 3, 97, 1344, 8, 97, 1, 97, 1, 97, 5, 97, 1348,
        8, 97, 10, 97, 12, 97, 1351, 9, 97, 1, 97, 1, 97, 1, 97, 3, 97, 1356, 8, 97, 1, 97, 1, 97,
        3, 97, 1360, 8, 97, 1, 97, 1, 97, 1, 97, 3, 97, 1365, 8, 97, 1, 97, 3, 97, 1368, 8, 97, 1,
        97, 1, 97, 1, 97, 1, 97, 1, 97, 3, 97, 1375, 8, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1,
        97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 3, 97,
        1394, 8, 97, 1, 97, 1, 97, 5, 97, 1398, 8, 97, 10, 97, 12, 97, 1401, 9, 97, 5, 97, 1403, 8,
        97, 10, 97, 12, 97, 1406, 9, 97, 1, 98, 1, 98, 3, 98, 1410, 8, 98, 1, 98, 1, 98, 1, 98, 3,
        98, 1415, 8, 98, 1, 98, 3, 98, 1418, 8, 98, 1, 99, 1, 99, 1, 99, 3, 99, 1423, 8, 99, 1, 100,
        1, 100, 1, 100, 5, 100, 1428, 8, 100, 10, 100, 12, 100, 1431, 9, 100, 1, 101, 1, 101, 1,
        101, 5, 101, 1436, 8, 101, 10, 101, 12, 101, 1439, 9, 101, 1, 102, 1, 102, 1, 102, 1, 102,
        1, 102, 3, 102, 1446, 8, 102, 3, 102, 1448, 8, 102, 1, 103, 4, 103, 1451, 8, 103, 11, 103,
        12, 103, 1452, 1, 104, 1, 104, 1, 104, 5, 104, 1458, 8, 104, 10, 104, 12, 104, 1461, 9, 104,
        1, 105, 1, 105, 3, 105, 1465, 8, 105, 1, 105, 1, 105, 1, 106, 1, 106, 1, 106, 1, 106, 1,
        106, 1, 106, 5, 106, 1475, 8, 106, 10, 106, 12, 106, 1478, 9, 106, 1, 106, 1, 106, 1, 106,
        1, 107, 1, 107, 1, 107, 1, 107, 1, 107, 1, 108, 1, 108, 5, 108, 1490, 8, 108, 10, 108, 12,
        108, 1493, 9, 108, 1, 108, 1, 108, 3, 108, 1497, 8, 108, 1, 108, 1, 108, 4, 108, 1501, 8,
        108, 11, 108, 12, 108, 1502, 1, 108, 1, 108, 3, 108, 1507, 8, 108, 1, 109, 1, 109, 1, 109,
        3, 109, 1512, 8, 109, 1, 109, 1, 109, 1, 109, 1, 109, 1, 109, 3, 109, 1519, 8, 109, 1, 110,
        1, 110, 1, 110, 1, 110, 1, 110, 1, 110, 3, 110, 1527, 8, 110, 1, 111, 1, 111, 1, 112, 1,
        112, 1, 113, 1, 113, 1, 114, 1, 114, 1, 115, 1, 115, 1, 115, 1, 115, 1, 115, 3, 115, 1542,
        8, 115, 1, 116, 1, 116, 1, 116, 1, 116, 1, 116, 1, 116, 1, 116, 3, 116, 1551, 8, 116, 1,
        117, 1, 117, 1, 117, 1, 117, 3, 117, 1557, 8, 117, 1, 117, 1, 117, 1, 118, 1, 118, 1, 119,
        1, 119, 3, 119, 1565, 8, 119, 1, 119, 1, 119, 3, 119, 1569, 8, 119, 1, 119, 1, 119, 3, 119,
        1573, 8, 119, 1, 119, 1, 119, 3, 119, 1577, 8, 119, 1, 119, 1, 119, 3, 119, 1581, 8, 119, 1,
        119, 1, 119, 3, 119, 1585, 8, 119, 3, 119, 1587, 8, 119, 1, 120, 1, 120, 1, 120, 1, 120, 1,
        120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 1, 120, 3, 120,
        1604, 8, 120, 1, 121, 1, 121, 1, 122, 1, 122, 1, 122, 1, 123, 1, 123, 1, 123, 1, 123, 5,
        123, 1615, 8, 123, 10, 123, 12, 123, 1618, 9, 123, 3, 123, 1620, 8, 123, 1, 123, 1, 123, 1,
        124, 3, 124, 1625, 8, 124, 1, 124, 1, 124, 1, 125, 1, 125, 1, 126, 1, 126, 1, 126, 1, 126,
        1, 126, 1, 127, 1, 127, 1, 127, 5, 127, 1639, 8, 127, 10, 127, 12, 127, 1642, 9, 127, 1,
        128, 1, 128, 3, 128, 1646, 8, 128, 1, 128, 1, 128, 3, 128, 1650, 8, 128, 1, 129, 1, 129, 3,
        129, 1654, 8, 129, 1, 129, 1, 129, 3, 129, 1658, 8, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1,
        129, 3, 129, 1665, 8, 129, 1, 129, 1, 129, 1, 129, 1, 129, 3, 129, 1671, 8, 129, 1, 129, 1,
        129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 1, 129, 3, 129, 1683, 8, 129,
        1, 130, 1, 130, 1, 130, 5, 130, 1688, 8, 130, 10, 130, 12, 130, 1691, 9, 130, 1, 130, 3,
        130, 1694, 8, 130, 1, 131, 1, 131, 1, 131, 3, 131, 1699, 8, 131, 1, 132, 1, 132, 1, 133, 1,
        133, 1, 134, 1, 134, 1, 134, 4, 134, 1708, 8, 134, 11, 134, 12, 134, 1709, 1, 134, 1, 134,
        1, 134, 3, 134, 1715, 8, 134, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1,
        136, 3, 136, 1725, 8, 136, 1, 136, 1, 136, 3, 136, 1729, 8, 136, 5, 136, 1731, 8, 136, 10,
        136, 12, 136, 1734, 9, 136, 1, 137, 1, 137, 1, 137, 3, 137, 1739, 8, 137, 1, 137, 3, 137,
        1742, 8, 137, 1, 138, 1, 138, 3, 138, 1746, 8, 138, 1, 138, 3, 138, 1749, 8, 138, 1, 139, 4,
        139, 1752, 8, 139, 11, 139, 12, 139, 1753, 1, 140, 1, 140, 3, 140, 1758, 8, 140, 1, 141, 1,
        141, 1, 141, 1, 141, 4, 141, 1764, 8, 141, 11, 141, 12, 141, 1765, 1, 141, 3, 141, 1769, 8,
        141, 1, 142, 1, 142, 1, 142, 1, 142, 5, 142, 1775, 8, 142, 10, 142, 12, 142, 1778, 9, 142,
        1, 142, 3, 142, 1781, 8, 142, 3, 142, 1783, 8, 142, 1, 142, 1, 142, 1, 143, 1, 143, 1, 143,
        1, 143, 5, 143, 1791, 8, 143, 10, 143, 12, 143, 1794, 9, 143, 1, 143, 3, 143, 1797, 8, 143,
        3, 143, 1799, 8, 143, 1, 143, 1, 143, 1, 144, 1, 144, 1, 144, 1, 144, 3, 144, 1807, 8, 144,
        1, 145, 1, 145, 1, 145, 5, 145, 1812, 8, 145, 10, 145, 12, 145, 1815, 9, 145, 1, 145, 3,
        145, 1818, 8, 145, 1, 146, 1, 146, 1, 146, 1, 146, 1, 146, 4, 146, 1825, 8, 146, 11, 146,
        12, 146, 1826, 1, 146, 1, 146, 1, 146, 1, 147, 1, 147, 3, 147, 1834, 8, 147, 1, 147, 1, 147,
        3, 147, 1838, 8, 147, 1, 147, 1, 147, 3, 147, 1842, 8, 147, 1, 147, 1, 147, 3, 147, 1846, 8,
        147, 1, 147, 1, 147, 1, 147, 1, 147, 1, 147, 3, 147, 1853, 8, 147, 1, 147, 1, 147, 3, 147,
        1857, 8, 147, 1, 147, 1, 147, 1, 147, 1, 147, 1, 147, 3, 147, 1864, 8, 147, 1, 147, 1, 147,
        1, 147, 1, 147, 3, 147, 1870, 8, 147, 1, 148, 1, 148, 1, 148, 1, 148, 1, 149, 1, 149, 1,
        149, 3, 149, 1879, 8, 149, 1, 150, 1, 150, 1, 150, 5, 150, 1884, 8, 150, 10, 150, 12, 150,
        1887, 9, 150, 1, 150, 1, 150, 1, 151, 1, 151, 1, 151, 1, 151, 1, 151, 1, 151, 1, 151, 3,
        151, 1898, 8, 151, 1, 151, 3, 151, 1901, 8, 151, 1, 152, 1, 152, 1, 152, 1, 152, 1, 152, 1,
        152, 1, 153, 1, 153, 5, 153, 1911, 8, 153, 10, 153, 12, 153, 1914, 9, 153, 1, 153, 1, 153,
        1, 154, 4, 154, 1919, 8, 154, 11, 154, 12, 154, 1920, 1, 154, 4, 154, 1924, 8, 154, 11, 154,
        12, 154, 1925, 1, 155, 1, 155, 1, 155, 1, 155, 1, 155, 1, 155, 3, 155, 1934, 8, 155, 1, 155,
        1, 155, 1, 155, 1, 155, 3, 155, 1940, 8, 155, 1, 156, 1, 156, 1, 156, 1, 156, 3, 156, 1946,
        8, 156, 1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 1, 158, 1, 158, 1, 158, 1, 158, 1,
        158, 1, 158, 1, 158, 1, 158, 1, 159, 1, 159, 1, 159, 3, 159, 1965, 8, 159, 1, 159, 1, 159,
        3, 159, 1969, 8, 159, 1, 159, 1, 159, 3, 159, 1973, 8, 159, 1, 159, 1, 159, 1, 159, 1, 160,
        1, 160, 1, 160, 1, 160, 3, 160, 1982, 8, 160, 1, 161, 1, 161, 1, 161, 1, 161, 1, 161, 3,
        161, 1989, 8, 161, 1, 161, 1, 161, 1, 161, 1, 162, 1, 162, 1, 162, 1, 162, 1, 162, 1, 162,
        3, 162, 2000, 8, 162, 3, 162, 2002, 8, 162, 1, 163, 1, 163, 1, 163, 5, 163, 2007, 8, 163,
        10, 163, 12, 163, 2010, 9, 163, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 3,
        164, 2019, 8, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164,
        1, 164, 1, 164, 3, 164, 2032, 8, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1,
        164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164,
        1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 3, 164, 2059, 8, 164, 1, 164, 1,
        164, 5, 164, 2063, 8, 164, 10, 164, 12, 164, 2066, 9, 164, 1, 165, 1, 165, 1, 165, 1, 165,
        1, 166, 1, 166, 1, 167, 1, 167, 3, 167, 2076, 8, 167, 1, 167, 1, 167, 1, 167, 1, 167, 1,
        167, 1, 167, 1, 167, 3, 167, 2085, 8, 167, 1, 168, 1, 168, 1, 168, 3, 168, 2090, 8, 168, 1,
        169, 1, 169, 3, 169, 2094, 8, 169, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170,
        3, 170, 2103, 8, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 3, 170, 2110, 8, 170, 1, 171,
        1, 171, 1, 172, 1, 172, 1, 172, 5, 172, 2117, 8, 172, 10, 172, 12, 172, 2120, 9, 172, 1,
        172, 1, 172, 1, 172, 1, 172, 5, 172, 2126, 8, 172, 10, 172, 12, 172, 2129, 9, 172, 5, 172,
        2131, 8, 172, 10, 172, 12, 172, 2134, 9, 172, 1, 173, 1, 173, 1, 173, 1, 173, 1, 173, 1,
        173, 3, 173, 2142, 8, 173, 1, 173, 1, 173, 3, 173, 2146, 8, 173, 1, 174, 1, 174, 1, 174, 5,
        174, 2151, 8, 174, 10, 174, 12, 174, 2154, 9, 174, 1, 175, 1, 175, 3, 175, 2158, 8, 175, 1,
        176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176,
        1, 176, 1, 176, 1, 176, 3, 176, 2175, 8, 176, 1, 177, 1, 177, 1, 177, 1, 177, 3, 177, 2181,
        8, 177, 1, 177, 1, 177, 3, 177, 2185, 8, 177, 1, 177, 1, 177, 1, 177, 1, 177, 1, 177, 1,
        177, 1, 177, 1, 177, 3, 177, 2195, 8, 177, 1, 178, 1, 178, 5, 178, 2199, 8, 178, 10, 178,
        12, 178, 2202, 9, 178, 1, 178, 4, 178, 2205, 8, 178, 11, 178, 12, 178, 2206, 1, 179, 1, 179,
        1, 179, 0, 4, 186, 194, 328, 344, 180, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26,
        28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72,
        74, 76, 78, 80, 82, 84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114,
        116, 118, 120, 122, 124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150,
        152, 154, 156, 158, 160, 162, 164, 166, 168, 170, 172, 174, 176, 178, 180, 182, 184, 186,
        188, 190, 192, 194, 196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222,
        224, 226, 228, 230, 232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 256, 258,
        260, 262, 264, 266, 268, 270, 272, 274, 276, 278, 280, 282, 284, 286, 288, 290, 292, 294,
        296, 298, 300, 302, 304, 306, 308, 310, 312, 314, 316, 318, 320, 322, 324, 326, 328, 330,
        332, 334, 336, 338, 340, 342, 344, 346, 348, 350, 352, 354, 356, 358, 0, 26, 2, 0, 72, 72,
        77, 77, 1, 0, 92, 93, 3, 0, 70, 70, 73, 73, 75, 76, 2, 0, 27, 27, 30, 30, 4, 0, 87, 87, 96,
        96, 99, 99, 101, 101, 1, 0, 120, 123, 7, 0, 1, 1, 12, 12, 20, 20, 26, 26, 29, 29, 41, 41,
        118, 118, 4, 0, 17, 17, 88, 91, 95, 95, 124, 124, 4, 0, 17, 17, 105, 105, 110, 110, 116,
        116, 3, 0, 44, 45, 48, 49, 53, 54, 1, 0, 112, 114, 8, 0, 4, 4, 9, 9, 13, 13, 18, 19, 23, 24,
        31, 32, 35, 37, 112, 114, 1, 0, 125, 126, 2, 0, 103, 105, 107, 109, 2, 0, 147, 148, 154,
        154, 1, 0, 148, 148, 2, 0, 175, 176, 180, 180, 1, 0, 173, 174, 2, 0, 159, 160, 166, 167, 2,
        0, 165, 165, 168, 168, 2, 0, 158, 158, 181, 190, 1, 0, 171, 172, 3, 0, 161, 162, 173, 175,
        177, 177, 1, 0, 155, 156, 2, 0, 205, 205, 207, 207, 8, 0, 42, 49, 53, 58, 83, 85, 87, 87,
        90, 94, 100, 100, 120, 139, 146, 146, 2453, 0, 363, 1, 0, 0, 0, 2, 378, 1, 0, 0, 0, 4, 380,
        1, 0, 0, 0, 6, 385, 1, 0, 0, 0, 8, 397, 1, 0, 0, 0, 10, 411, 1, 0, 0, 0, 12, 432, 1, 0, 0,
        0, 14, 442, 1, 0, 0, 0, 16, 450, 1, 0, 0, 0, 18, 462, 1, 0, 0, 0, 20, 470, 1, 0, 0, 0, 22,
        472, 1, 0, 0, 0, 24, 475, 1, 0, 0, 0, 26, 491, 1, 0, 0, 0, 28, 498, 1, 0, 0, 0, 30, 526, 1,
        0, 0, 0, 32, 528, 1, 0, 0, 0, 34, 532, 1, 0, 0, 0, 36, 543, 1, 0, 0, 0, 38, 551, 1, 0, 0, 0,
        40, 566, 1, 0, 0, 0, 42, 593, 1, 0, 0, 0, 44, 603, 1, 0, 0, 0, 46, 605, 1, 0, 0, 0, 48, 626,
        1, 0, 0, 0, 50, 628, 1, 0, 0, 0, 52, 635, 1, 0, 0, 0, 54, 639, 1, 0, 0, 0, 56, 642, 1, 0, 0,
        0, 58, 646, 1, 0, 0, 0, 60, 665, 1, 0, 0, 0, 62, 669, 1, 0, 0, 0, 64, 672, 1, 0, 0, 0, 66,
        676, 1, 0, 0, 0, 68, 702, 1, 0, 0, 0, 70, 705, 1, 0, 0, 0, 72, 725, 1, 0, 0, 0, 74, 727, 1,
        0, 0, 0, 76, 739, 1, 0, 0, 0, 78, 741, 1, 0, 0, 0, 80, 749, 1, 0, 0, 0, 82, 755, 1, 0, 0, 0,
        84, 771, 1, 0, 0, 0, 86, 788, 1, 0, 0, 0, 88, 792, 1, 0, 0, 0, 90, 812, 1, 0, 0, 0, 92, 830,
        1, 0, 0, 0, 94, 834, 1, 0, 0, 0, 96, 836, 1, 0, 0, 0, 98, 848, 1, 0, 0, 0, 100, 854, 1, 0,
        0, 0, 102, 861, 1, 0, 0, 0, 104, 869, 1, 0, 0, 0, 106, 872, 1, 0, 0, 0, 108, 883, 1, 0, 0,
        0, 110, 893, 1, 0, 0, 0, 112, 907, 1, 0, 0, 0, 114, 909, 1, 0, 0, 0, 116, 914, 1, 0, 0, 0,
        118, 919, 1, 0, 0, 0, 120, 929, 1, 0, 0, 0, 122, 931, 1, 0, 0, 0, 124, 943, 1, 0, 0, 0, 126,
        949, 1, 0, 0, 0, 128, 955, 1, 0, 0, 0, 130, 958, 1, 0, 0, 0, 132, 961, 1, 0, 0, 0, 134, 965,
        1, 0, 0, 0, 136, 972, 1, 0, 0, 0, 138, 976, 1, 0, 0, 0, 140, 982, 1, 0, 0, 0, 142, 984, 1,
        0, 0, 0, 144, 990, 1, 0, 0, 0, 146, 1002, 1, 0, 0, 0, 148, 1004, 1, 0, 0, 0, 150, 1011, 1,
        0, 0, 0, 152, 1024, 1, 0, 0, 0, 154, 1029, 1, 0, 0, 0, 156, 1045, 1, 0, 0, 0, 158, 1048, 1,
        0, 0, 0, 160, 1060, 1, 0, 0, 0, 162, 1075, 1, 0, 0, 0, 164, 1101, 1, 0, 0, 0, 166, 1103, 1,
        0, 0, 0, 168, 1119, 1, 0, 0, 0, 170, 1131, 1, 0, 0, 0, 172, 1141, 1, 0, 0, 0, 174, 1144, 1,
        0, 0, 0, 176, 1152, 1, 0, 0, 0, 178, 1166, 1, 0, 0, 0, 180, 1168, 1, 0, 0, 0, 182, 1176, 1,
        0, 0, 0, 184, 1182, 1, 0, 0, 0, 186, 1219, 1, 0, 0, 0, 188, 1264, 1, 0, 0, 0, 190, 1291, 1,
        0, 0, 0, 192, 1304, 1, 0, 0, 0, 194, 1359, 1, 0, 0, 0, 196, 1417, 1, 0, 0, 0, 198, 1419, 1,
        0, 0, 0, 200, 1424, 1, 0, 0, 0, 202, 1432, 1, 0, 0, 0, 204, 1447, 1, 0, 0, 0, 206, 1450, 1,
        0, 0, 0, 208, 1454, 1, 0, 0, 0, 210, 1462, 1, 0, 0, 0, 212, 1468, 1, 0, 0, 0, 214, 1482, 1,
        0, 0, 0, 216, 1487, 1, 0, 0, 0, 218, 1518, 1, 0, 0, 0, 220, 1526, 1, 0, 0, 0, 222, 1528, 1,
        0, 0, 0, 224, 1530, 1, 0, 0, 0, 226, 1532, 1, 0, 0, 0, 228, 1534, 1, 0, 0, 0, 230, 1541, 1,
        0, 0, 0, 232, 1550, 1, 0, 0, 0, 234, 1552, 1, 0, 0, 0, 236, 1560, 1, 0, 0, 0, 238, 1586, 1,
        0, 0, 0, 240, 1603, 1, 0, 0, 0, 242, 1605, 1, 0, 0, 0, 244, 1607, 1, 0, 0, 0, 246, 1610, 1,
        0, 0, 0, 248, 1624, 1, 0, 0, 0, 250, 1628, 1, 0, 0, 0, 252, 1630, 1, 0, 0, 0, 254, 1635, 1,
        0, 0, 0, 256, 1649, 1, 0, 0, 0, 258, 1682, 1, 0, 0, 0, 260, 1684, 1, 0, 0, 0, 262, 1695, 1,
        0, 0, 0, 264, 1700, 1, 0, 0, 0, 266, 1702, 1, 0, 0, 0, 268, 1714, 1, 0, 0, 0, 270, 1716, 1,
        0, 0, 0, 272, 1724, 1, 0, 0, 0, 274, 1735, 1, 0, 0, 0, 276, 1743, 1, 0, 0, 0, 278, 1751, 1,
        0, 0, 0, 280, 1755, 1, 0, 0, 0, 282, 1759, 1, 0, 0, 0, 284, 1770, 1, 0, 0, 0, 286, 1786, 1,
        0, 0, 0, 288, 1806, 1, 0, 0, 0, 290, 1808, 1, 0, 0, 0, 292, 1819, 1, 0, 0, 0, 294, 1869, 1,
        0, 0, 0, 296, 1871, 1, 0, 0, 0, 298, 1875, 1, 0, 0, 0, 300, 1880, 1, 0, 0, 0, 302, 1900, 1,
        0, 0, 0, 304, 1902, 1, 0, 0, 0, 306, 1908, 1, 0, 0, 0, 308, 1918, 1, 0, 0, 0, 310, 1939, 1,
        0, 0, 0, 312, 1945, 1, 0, 0, 0, 314, 1947, 1, 0, 0, 0, 316, 1953, 1, 0, 0, 0, 318, 1961, 1,
        0, 0, 0, 320, 1981, 1, 0, 0, 0, 322, 1983, 1, 0, 0, 0, 324, 2001, 1, 0, 0, 0, 326, 2003, 1,
        0, 0, 0, 328, 2018, 1, 0, 0, 0, 330, 2067, 1, 0, 0, 0, 332, 2071, 1, 0, 0, 0, 334, 2084, 1,
        0, 0, 0, 336, 2089, 1, 0, 0, 0, 338, 2093, 1, 0, 0, 0, 340, 2109, 1, 0, 0, 0, 342, 2111, 1,
        0, 0, 0, 344, 2113, 1, 0, 0, 0, 346, 2145, 1, 0, 0, 0, 348, 2147, 1, 0, 0, 0, 350, 2157, 1,
        0, 0, 0, 352, 2174, 1, 0, 0, 0, 354, 2194, 1, 0, 0, 0, 356, 2204, 1, 0, 0, 0, 358, 2208, 1,
        0, 0, 0, 360, 362, 3, 2, 1, 0, 361, 360, 1, 0, 0, 0, 362, 365, 1, 0, 0, 0, 363, 361, 1, 0,
        0, 0, 363, 364, 1, 0, 0, 0, 364, 366, 1, 0, 0, 0, 365, 363, 1, 0, 0, 0, 366, 367, 5, 0, 0,
        1, 367, 1, 1, 0, 0, 0, 368, 379, 3, 4, 2, 0, 369, 379, 3, 178, 89, 0, 370, 379, 3, 6, 3, 0,
        371, 379, 3, 12, 6, 0, 372, 379, 3, 10, 5, 0, 373, 379, 3, 16, 8, 0, 374, 379, 3, 28, 14, 0,
        375, 379, 3, 32, 16, 0, 376, 379, 3, 34, 17, 0, 377, 379, 3, 132, 66, 0, 378, 368, 1, 0, 0,
        0, 378, 369, 1, 0, 0, 0, 378, 370, 1, 0, 0, 0, 378, 371, 1, 0, 0, 0, 378, 372, 1, 0, 0, 0,
        378, 373, 1, 0, 0, 0, 378, 374, 1, 0, 0, 0, 378, 375, 1, 0, 0, 0, 378, 376, 1, 0, 0, 0, 378,
        377, 1, 0, 0, 0, 379, 3, 1, 0, 0, 0, 380, 381, 5, 69, 0, 0, 381, 382, 3, 358, 179, 0, 382,
        383, 5, 153, 0, 0, 383, 5, 1, 0, 0, 0, 384, 386, 5, 139, 0, 0, 385, 384, 1, 0, 0, 0, 385,
        386, 1, 0, 0, 0, 386, 387, 1, 0, 0, 0, 387, 388, 5, 68, 0, 0, 388, 390, 3, 8, 4, 0, 389,
        391, 3, 46, 23, 0, 390, 389, 1, 0, 0, 0, 390, 391, 1, 0, 0, 0, 391, 393, 1, 0, 0, 0, 392,
        394, 3, 52, 26, 0, 393, 392, 1, 0, 0, 0, 393, 394, 1, 0, 0, 0, 394, 395, 1, 0, 0, 0, 395,
        396, 5, 65, 0, 0, 396, 7, 1, 0, 0, 0, 397, 403, 3, 18, 9, 0, 398, 399, 5, 164, 0, 0, 399,
        401, 3, 20, 10, 0, 400, 402, 3, 24, 12, 0, 401, 400, 1, 0, 0, 0, 401, 402, 1, 0, 0, 0, 402,
        404, 1, 0, 0, 0, 403, 398, 1, 0, 0, 0, 403, 404, 1, 0, 0, 0, 404, 409, 1, 0, 0, 0, 405, 406,
        5, 160, 0, 0, 406, 407, 3, 36, 18, 0, 407, 408, 5, 159, 0, 0, 408, 410, 1, 0, 0, 0, 409,
        405, 1, 0, 0, 0, 409, 410, 1, 0, 0, 0, 410, 9, 1, 0, 0, 0, 411, 412, 5, 68, 0, 0, 412, 413,
        3, 18, 9, 0, 413, 415, 5, 147, 0, 0, 414, 416, 3, 358, 179, 0, 415, 414, 1, 0, 0, 0, 415,
        416, 1, 0, 0, 0, 416, 417, 1, 0, 0, 0, 417, 422, 5, 148, 0, 0, 418, 419, 5, 160, 0, 0, 419,
        420, 3, 36, 18, 0, 420, 421, 5, 159, 0, 0, 421, 423, 1, 0, 0, 0, 422, 418, 1, 0, 0, 0, 422,
        423, 1, 0, 0, 0, 423, 425, 1, 0, 0, 0, 424, 426, 3, 46, 23, 0, 425, 424, 1, 0, 0, 0, 425,
        426, 1, 0, 0, 0, 426, 428, 1, 0, 0, 0, 427, 429, 3, 52, 26, 0, 428, 427, 1, 0, 0, 0, 428,
        429, 1, 0, 0, 0, 429, 430, 1, 0, 0, 0, 430, 431, 5, 65, 0, 0, 431, 11, 1, 0, 0, 0, 432, 433,
        5, 67, 0, 0, 433, 435, 3, 14, 7, 0, 434, 436, 3, 46, 23, 0, 435, 434, 1, 0, 0, 0, 435, 436,
        1, 0, 0, 0, 436, 438, 1, 0, 0, 0, 437, 439, 3, 60, 30, 0, 438, 437, 1, 0, 0, 0, 438, 439, 1,
        0, 0, 0, 439, 440, 1, 0, 0, 0, 440, 441, 5, 65, 0, 0, 441, 13, 1, 0, 0, 0, 442, 448, 3, 18,
        9, 0, 443, 444, 5, 164, 0, 0, 444, 446, 3, 20, 10, 0, 445, 447, 3, 24, 12, 0, 446, 445, 1,
        0, 0, 0, 446, 447, 1, 0, 0, 0, 447, 449, 1, 0, 0, 0, 448, 443, 1, 0, 0, 0, 448, 449, 1, 0,
        0, 0, 449, 15, 1, 0, 0, 0, 450, 451, 5, 67, 0, 0, 451, 452, 3, 18, 9, 0, 452, 454, 5, 147,
        0, 0, 453, 455, 3, 358, 179, 0, 454, 453, 1, 0, 0, 0, 454, 455, 1, 0, 0, 0, 455, 456, 1, 0,
        0, 0, 456, 458, 5, 148, 0, 0, 457, 459, 3, 60, 30, 0, 458, 457, 1, 0, 0, 0, 458, 459, 1, 0,
        0, 0, 459, 460, 1, 0, 0, 0, 460, 461, 5, 65, 0, 0, 461, 17, 1, 0, 0, 0, 462, 468, 3, 358,
        179, 0, 463, 464, 5, 160, 0, 0, 464, 465, 3, 36, 18, 0, 465, 466, 5, 159, 0, 0, 466, 469, 1,
        0, 0, 0, 467, 469, 3, 246, 123, 0, 468, 463, 1, 0, 0, 0, 468, 467, 1, 0, 0, 0, 468, 469, 1,
        0, 0, 0, 469, 19, 1, 0, 0, 0, 470, 471, 3, 358, 179, 0, 471, 21, 1, 0, 0, 0, 472, 473, 3,
        358, 179, 0, 473, 474, 3, 24, 12, 0, 474, 23, 1, 0, 0, 0, 475, 484, 5, 160, 0, 0, 476, 481,
        3, 26, 13, 0, 477, 478, 5, 154, 0, 0, 478, 480, 3, 26, 13, 0, 479, 477, 1, 0, 0, 0, 480,
        483, 1, 0, 0, 0, 481, 479, 1, 0, 0, 0, 481, 482, 1, 0, 0, 0, 482, 485, 1, 0, 0, 0, 483, 481,
        1, 0, 0, 0, 484, 476, 1, 0, 0, 0, 484, 485, 1, 0, 0, 0, 485, 486, 1, 0, 0, 0, 486, 487, 5,
        159, 0, 0, 487, 25, 1, 0, 0, 0, 488, 490, 3, 228, 114, 0, 489, 488, 1, 0, 0, 0, 490, 493, 1,
        0, 0, 0, 491, 489, 1, 0, 0, 0, 491, 492, 1, 0, 0, 0, 492, 494, 1, 0, 0, 0, 493, 491, 1, 0,
        0, 0, 494, 496, 3, 240, 120, 0, 495, 497, 3, 278, 139, 0, 496, 495, 1, 0, 0, 0, 496, 497, 1,
        0, 0, 0, 497, 27, 1, 0, 0, 0, 498, 499, 5, 71, 0, 0, 499, 504, 3, 44, 22, 0, 500, 501, 5,
        160, 0, 0, 501, 502, 3, 36, 18, 0, 502, 503, 5, 159, 0, 0, 503, 505, 1, 0, 0, 0, 504, 500,
        1, 0, 0, 0, 504, 505, 1, 0, 0, 0, 505, 509, 1, 0, 0, 0, 506, 508, 3, 30, 15, 0, 507, 506, 1,
        0, 0, 0, 508, 511, 1, 0, 0, 0, 509, 507, 1, 0, 0, 0, 509, 510, 1, 0, 0, 0, 510, 512, 1, 0,
        0, 0, 511, 509, 1, 0, 0, 0, 512, 513, 5, 65, 0, 0, 513, 29, 1, 0, 0, 0, 514, 518, 7, 0, 0,
        0, 515, 517, 3, 52, 26, 0, 516, 515, 1, 0, 0, 0, 517, 520, 1, 0, 0, 0, 518, 516, 1, 0, 0, 0,
        518, 519, 1, 0, 0, 0, 519, 527, 1, 0, 0, 0, 520, 518, 1, 0, 0, 0, 521, 523, 3, 52, 26, 0,
        522, 521, 1, 0, 0, 0, 523, 524, 1, 0, 0, 0, 524, 522, 1, 0, 0, 0, 524, 525, 1, 0, 0, 0, 525,
        527, 1, 0, 0, 0, 526, 514, 1, 0, 0, 0, 526, 522, 1, 0, 0, 0, 527, 31, 1, 0, 0, 0, 528, 529,
        5, 71, 0, 0, 529, 530, 3, 36, 18, 0, 530, 531, 5, 153, 0, 0, 531, 33, 1, 0, 0, 0, 532, 533,
        5, 62, 0, 0, 533, 538, 3, 18, 9, 0, 534, 535, 5, 154, 0, 0, 535, 537, 3, 18, 9, 0, 536, 534,
        1, 0, 0, 0, 537, 540, 1, 0, 0, 0, 538, 536, 1, 0, 0, 0, 538, 539, 1, 0, 0, 0, 539, 541, 1,
        0, 0, 0, 540, 538, 1, 0, 0, 0, 541, 542, 5, 153, 0, 0, 542, 35, 1, 0, 0, 0, 543, 548, 3, 44,
        22, 0, 544, 545, 5, 154, 0, 0, 545, 547, 3, 44, 22, 0, 546, 544, 1, 0, 0, 0, 547, 550, 1, 0,
        0, 0, 548, 546, 1, 0, 0, 0, 548, 549, 1, 0, 0, 0, 549, 37, 1, 0, 0, 0, 550, 548, 1, 0, 0, 0,
        551, 556, 5, 74, 0, 0, 552, 553, 5, 147, 0, 0, 553, 554, 3, 40, 20, 0, 554, 555, 5, 148, 0,
        0, 555, 557, 1, 0, 0, 0, 556, 552, 1, 0, 0, 0, 556, 557, 1, 0, 0, 0, 557, 559, 1, 0, 0, 0,
        558, 560, 3, 220, 110, 0, 559, 558, 1, 0, 0, 0, 559, 560, 1, 0, 0, 0, 560, 562, 1, 0, 0, 0,
        561, 563, 5, 138, 0, 0, 562, 561, 1, 0, 0, 0, 562, 563, 1, 0, 0, 0, 563, 564, 1, 0, 0, 0,
        564, 565, 3, 218, 109, 0, 565, 39, 1, 0, 0, 0, 566, 571, 3, 42, 21, 0, 567, 568, 5, 154, 0,
        0, 568, 570, 3, 42, 21, 0, 569, 567, 1, 0, 0, 0, 570, 573, 1, 0, 0, 0, 571, 569, 1, 0, 0, 0,
        571, 572, 1, 0, 0, 0, 572, 41, 1, 0, 0, 0, 573, 571, 1, 0, 0, 0, 574, 594, 5, 83, 0, 0, 575,
        594, 5, 84, 0, 0, 576, 594, 5, 131, 0, 0, 577, 594, 5, 134, 0, 0, 578, 594, 5, 85, 0, 0,
        579, 594, 5, 127, 0, 0, 580, 594, 5, 135, 0, 0, 581, 594, 5, 128, 0, 0, 582, 594, 5, 132, 0,
        0, 583, 594, 5, 133, 0, 0, 584, 585, 5, 129, 0, 0, 585, 586, 5, 158, 0, 0, 586, 594, 3, 358,
        179, 0, 587, 588, 5, 130, 0, 0, 588, 589, 5, 158, 0, 0, 589, 590, 3, 358, 179, 0, 590, 591,
        5, 164, 0, 0, 591, 594, 1, 0, 0, 0, 592, 594, 3, 224, 112, 0, 593, 574, 1, 0, 0, 0, 593,
        575, 1, 0, 0, 0, 593, 576, 1, 0, 0, 0, 593, 577, 1, 0, 0, 0, 593, 578, 1, 0, 0, 0, 593, 579,
        1, 0, 0, 0, 593, 580, 1, 0, 0, 0, 593, 581, 1, 0, 0, 0, 593, 582, 1, 0, 0, 0, 593, 583, 1,
        0, 0, 0, 593, 584, 1, 0, 0, 0, 593, 587, 1, 0, 0, 0, 593, 592, 1, 0, 0, 0, 594, 43, 1, 0, 0,
        0, 595, 596, 5, 160, 0, 0, 596, 597, 3, 36, 18, 0, 597, 598, 5, 159, 0, 0, 598, 604, 1, 0,
        0, 0, 599, 601, 7, 1, 0, 0, 600, 599, 1, 0, 0, 0, 600, 601, 1, 0, 0, 0, 601, 602, 1, 0, 0,
        0, 602, 604, 3, 358, 179, 0, 603, 595, 1, 0, 0, 0, 603, 600, 1, 0, 0, 0, 604, 45, 1, 0, 0,
        0, 605, 609, 5, 149, 0, 0, 606, 608, 3, 48, 24, 0, 607, 606, 1, 0, 0, 0, 608, 611, 1, 0, 0,
        0, 609, 607, 1, 0, 0, 0, 609, 610, 1, 0, 0, 0, 610, 612, 1, 0, 0, 0, 611, 609, 1, 0, 0, 0,
        612, 613, 5, 150, 0, 0, 613, 47, 1, 0, 0, 0, 614, 618, 3, 50, 25, 0, 615, 617, 3, 218, 109,
        0, 616, 615, 1, 0, 0, 0, 617, 620, 1, 0, 0, 0, 618, 616, 1, 0, 0, 0, 618, 619, 1, 0, 0, 0,
        619, 627, 1, 0, 0, 0, 620, 618, 1, 0, 0, 0, 621, 623, 3, 218, 109, 0, 622, 621, 1, 0, 0, 0,
        623, 624, 1, 0, 0, 0, 624, 622, 1, 0, 0, 0, 624, 625, 1, 0, 0, 0, 625, 627, 1, 0, 0, 0, 626,
        614, 1, 0, 0, 0, 626, 622, 1, 0, 0, 0, 627, 49, 1, 0, 0, 0, 628, 629, 7, 2, 0, 0, 629, 51,
        1, 0, 0, 0, 630, 636, 3, 178, 89, 0, 631, 636, 3, 54, 27, 0, 632, 636, 3, 56, 28, 0, 633,
        636, 3, 38, 19, 0, 634, 636, 3, 130, 65, 0, 635, 630, 1, 0, 0, 0, 635, 631, 1, 0, 0, 0, 635,
        632, 1, 0, 0, 0, 635, 633, 1, 0, 0, 0, 635, 634, 1, 0, 0, 0, 636, 637, 1, 0, 0, 0, 637, 635,
        1, 0, 0, 0, 637, 638, 1, 0, 0, 0, 638, 53, 1, 0, 0, 0, 639, 640, 5, 173, 0, 0, 640, 641, 3,
        58, 29, 0, 641, 55, 1, 0, 0, 0, 642, 643, 5, 174, 0, 0, 643, 644, 3, 58, 29, 0, 644, 57, 1,
        0, 0, 0, 645, 647, 3, 74, 37, 0, 646, 645, 1, 0, 0, 0, 646, 647, 1, 0, 0, 0, 647, 648, 1, 0,
        0, 0, 648, 652, 3, 68, 34, 0, 649, 651, 3, 212, 106, 0, 650, 649, 1, 0, 0, 0, 651, 654, 1,
        0, 0, 0, 652, 650, 1, 0, 0, 0, 652, 653, 1, 0, 0, 0, 653, 656, 1, 0, 0, 0, 654, 652, 1, 0,
        0, 0, 655, 657, 3, 282, 141, 0, 656, 655, 1, 0, 0, 0, 656, 657, 1, 0, 0, 0, 657, 658, 1, 0,
        0, 0, 658, 659, 5, 153, 0, 0, 659, 59, 1, 0, 0, 0, 660, 666, 3, 132, 66, 0, 661, 666, 3,
        178, 89, 0, 662, 666, 3, 62, 31, 0, 663, 666, 3, 64, 32, 0, 664, 666, 3, 76, 38, 0, 665,
        660, 1, 0, 0, 0, 665, 661, 1, 0, 0, 0, 665, 662, 1, 0, 0, 0, 665, 663, 1, 0, 0, 0, 665, 664,
        1, 0, 0, 0, 666, 667, 1, 0, 0, 0, 667, 665, 1, 0, 0, 0, 667, 668, 1, 0, 0, 0, 668, 61, 1, 0,
        0, 0, 669, 670, 5, 173, 0, 0, 670, 671, 3, 66, 33, 0, 671, 63, 1, 0, 0, 0, 672, 673, 5, 174,
        0, 0, 673, 674, 3, 66, 33, 0, 674, 65, 1, 0, 0, 0, 675, 677, 3, 74, 37, 0, 676, 675, 1, 0,
        0, 0, 676, 677, 1, 0, 0, 0, 677, 678, 1, 0, 0, 0, 678, 680, 3, 68, 34, 0, 679, 681, 3, 180,
        90, 0, 680, 679, 1, 0, 0, 0, 680, 681, 1, 0, 0, 0, 681, 683, 1, 0, 0, 0, 682, 684, 5, 153,
        0, 0, 683, 682, 1, 0, 0, 0, 683, 684, 1, 0, 0, 0, 684, 686, 1, 0, 0, 0, 685, 687, 3, 212,
        106, 0, 686, 685, 1, 0, 0, 0, 686, 687, 1, 0, 0, 0, 687, 688, 1, 0, 0, 0, 688, 690, 3, 300,
        150, 0, 689, 691, 5, 153, 0, 0, 690, 689, 1, 0, 0, 0, 690, 691, 1, 0, 0, 0, 691, 67, 1, 0,
        0, 0, 692, 703, 3, 72, 36, 0, 693, 695, 3, 70, 35, 0, 694, 693, 1, 0, 0, 0, 695, 696, 1, 0,
        0, 0, 696, 694, 1, 0, 0, 0, 696, 697, 1, 0, 0, 0, 697, 700, 1, 0, 0, 0, 698, 699, 5, 154, 0,
        0, 699, 701, 5, 191, 0, 0, 700, 698, 1, 0, 0, 0, 700, 701, 1, 0, 0, 0, 701, 703, 1, 0, 0, 0,
        702, 692, 1, 0, 0, 0, 702, 694, 1, 0, 0, 0, 703, 69, 1, 0, 0, 0, 704, 706, 3, 72, 36, 0,
        705, 704, 1, 0, 0, 0, 705, 706, 1, 0, 0, 0, 706, 707, 1, 0, 0, 0, 707, 711, 5, 164, 0, 0,
        708, 710, 3, 74, 37, 0, 709, 708, 1, 0, 0, 0, 710, 713, 1, 0, 0, 0, 711, 709, 1, 0, 0, 0,
        711, 712, 1, 0, 0, 0, 712, 715, 1, 0, 0, 0, 713, 711, 1, 0, 0, 0, 714, 716, 3, 222, 111, 0,
        715, 714, 1, 0, 0, 0, 715, 716, 1, 0, 0, 0, 716, 717, 1, 0, 0, 0, 717, 718, 3, 358, 179, 0,
        718, 71, 1, 0, 0, 0, 719, 726, 3, 358, 179, 0, 720, 726, 5, 22, 0, 0, 721, 726, 5, 28, 0, 0,
        722, 726, 5, 16, 0, 0, 723, 726, 5, 10, 0, 0, 724, 726, 5, 7, 0, 0, 725, 719, 1, 0, 0, 0,
        725, 720, 1, 0, 0, 0, 725, 721, 1, 0, 0, 0, 725, 722, 1, 0, 0, 0, 725, 723, 1, 0, 0, 0, 725,
        724, 1, 0, 0, 0, 726, 73, 1, 0, 0, 0, 727, 728, 5, 147, 0, 0, 728, 729, 3, 188, 94, 0, 729,
        730, 5, 148, 0, 0, 730, 75, 1, 0, 0, 0, 731, 732, 5, 80, 0, 0, 732, 733, 3, 78, 39, 0, 733,
        734, 5, 153, 0, 0, 734, 740, 1, 0, 0, 0, 735, 736, 5, 63, 0, 0, 736, 737, 3, 78, 39, 0, 737,
        738, 5, 153, 0, 0, 738, 740, 1, 0, 0, 0, 739, 731, 1, 0, 0, 0, 739, 735, 1, 0, 0, 0, 740,
        77, 1, 0, 0, 0, 741, 746, 3, 80, 40, 0, 742, 743, 5, 154, 0, 0, 743, 745, 3, 80, 40, 0, 744,
        742, 1, 0, 0, 0, 745, 748, 1, 0, 0, 0, 746, 744, 1, 0, 0, 0, 746, 747, 1, 0, 0, 0, 747, 79,
        1, 0, 0, 0, 748, 746, 1, 0, 0, 0, 749, 752, 3, 358, 179, 0, 750, 751, 5, 158, 0, 0, 751,
        753, 3, 358, 179, 0, 752, 750, 1, 0, 0, 0, 752, 753, 1, 0, 0, 0, 753, 81, 1, 0, 0, 0, 754,
        756, 3, 224, 112, 0, 755, 754, 1, 0, 0, 0, 755, 756, 1, 0, 0, 0, 756, 757, 1, 0, 0, 0, 757,
        759, 3, 240, 120, 0, 758, 760, 3, 224, 112, 0, 759, 758, 1, 0, 0, 0, 759, 760, 1, 0, 0, 0,
        760, 761, 1, 0, 0, 0, 761, 762, 5, 147, 0, 0, 762, 765, 5, 179, 0, 0, 763, 766, 3, 224, 112,
        0, 764, 766, 3, 240, 120, 0, 765, 763, 1, 0, 0, 0, 765, 764, 1, 0, 0, 0, 765, 766, 1, 0, 0,
        0, 766, 767, 1, 0, 0, 0, 767, 769, 5, 148, 0, 0, 768, 770, 3, 92, 46, 0, 769, 768, 1, 0, 0,
        0, 769, 770, 1, 0, 0, 0, 770, 83, 1, 0, 0, 0, 771, 772, 5, 157, 0, 0, 772, 784, 5, 149, 0,
        0, 773, 778, 3, 86, 43, 0, 774, 775, 5, 154, 0, 0, 775, 777, 3, 86, 43, 0, 776, 774, 1, 0,
        0, 0, 777, 780, 1, 0, 0, 0, 778, 776, 1, 0, 0, 0, 778, 779, 1, 0, 0, 0, 779, 782, 1, 0, 0,
        0, 780, 778, 1, 0, 0, 0, 781, 783, 5, 154, 0, 0, 782, 781, 1, 0, 0, 0, 782, 783, 1, 0, 0, 0,
        783, 785, 1, 0, 0, 0, 784, 773, 1, 0, 0, 0, 784, 785, 1, 0, 0, 0, 785, 786, 1, 0, 0, 0, 786,
        787, 5, 150, 0, 0, 787, 85, 1, 0, 0, 0, 788, 789, 3, 334, 167, 0, 789, 790, 5, 164, 0, 0,
        790, 791, 3, 328, 164, 0, 791, 87, 1, 0, 0, 0, 792, 793, 5, 157, 0, 0, 793, 798, 5, 151, 0,
        0, 794, 796, 3, 326, 163, 0, 795, 797, 5, 154, 0, 0, 796, 795, 1, 0, 0, 0, 796, 797, 1, 0,
        0, 0, 797, 799, 1, 0, 0, 0, 798, 794, 1, 0, 0, 0, 798, 799, 1, 0, 0, 0, 799, 800, 1, 0, 0,
        0, 800, 801, 5, 152, 0, 0, 801, 89, 1, 0, 0, 0, 802, 803, 5, 157, 0, 0, 803, 804, 5, 147, 0,
        0, 804, 805, 3, 328, 164, 0, 805, 806, 5, 148, 0, 0, 806, 813, 1, 0, 0, 0, 807, 810, 5, 157,
        0, 0, 808, 811, 3, 354, 177, 0, 809, 811, 3, 358, 179, 0, 810, 808, 1, 0, 0, 0, 810, 809, 1,
        0, 0, 0, 811, 813, 1, 0, 0, 0, 812, 802, 1, 0, 0, 0, 812, 807, 1, 0, 0, 0, 813, 91, 1, 0, 0,
        0, 814, 831, 3, 94, 47, 0, 815, 827, 5, 147, 0, 0, 816, 819, 3, 94, 47, 0, 817, 819, 5, 32,
        0, 0, 818, 816, 1, 0, 0, 0, 818, 817, 1, 0, 0, 0, 819, 824, 1, 0, 0, 0, 820, 821, 5, 154, 0,
        0, 821, 823, 3, 94, 47, 0, 822, 820, 1, 0, 0, 0, 823, 826, 1, 0, 0, 0, 824, 822, 1, 0, 0, 0,
        824, 825, 1, 0, 0, 0, 825, 828, 1, 0, 0, 0, 826, 824, 1, 0, 0, 0, 827, 818, 1, 0, 0, 0, 827,
        828, 1, 0, 0, 0, 828, 829, 1, 0, 0, 0, 829, 831, 5, 148, 0, 0, 830, 814, 1, 0, 0, 0, 830,
        815, 1, 0, 0, 0, 831, 93, 1, 0, 0, 0, 832, 835, 3, 118, 59, 0, 833, 835, 3, 188, 94, 0, 834,
        832, 1, 0, 0, 0, 834, 833, 1, 0, 0, 0, 835, 95, 1, 0, 0, 0, 836, 838, 5, 179, 0, 0, 837,
        839, 3, 240, 120, 0, 838, 837, 1, 0, 0, 0, 838, 839, 1, 0, 0, 0, 839, 841, 1, 0, 0, 0, 840,
        842, 3, 224, 112, 0, 841, 840, 1, 0, 0, 0, 841, 842, 1, 0, 0, 0, 842, 844, 1, 0, 0, 0, 843,
        845, 3, 92, 46, 0, 844, 843, 1, 0, 0, 0, 844, 845, 1, 0, 0, 0, 845, 846, 1, 0, 0, 0, 846,
        847, 3, 300, 150, 0, 847, 97, 1, 0, 0, 0, 848, 850, 5, 179, 0, 0, 849, 851, 3, 92, 46, 0,
        850, 849, 1, 0, 0, 0, 850, 851, 1, 0, 0, 0, 851, 852, 1, 0, 0, 0, 852, 853, 3, 300, 150, 0,
        853, 99, 1, 0, 0, 0, 854, 855, 5, 151, 0, 0, 855, 856, 3, 102, 51, 0, 856, 857, 3, 104, 52,
        0, 857, 858, 5, 152, 0, 0, 858, 101, 1, 0, 0, 0, 859, 862, 3, 328, 164, 0, 860, 862, 3, 244,
        122, 0, 861, 859, 1, 0, 0, 0, 861, 860, 1, 0, 0, 0, 862, 103, 1, 0, 0, 0, 863, 870, 3, 72,
        36, 0, 864, 866, 3, 106, 53, 0, 865, 864, 1, 0, 0, 0, 866, 867, 1, 0, 0, 0, 867, 865, 1, 0,
        0, 0, 867, 868, 1, 0, 0, 0, 868, 870, 1, 0, 0, 0, 869, 863, 1, 0, 0, 0, 869, 865, 1, 0, 0,
        0, 870, 105, 1, 0, 0, 0, 871, 873, 3, 72, 36, 0, 872, 871, 1, 0, 0, 0, 872, 873, 1, 0, 0, 0,
        873, 874, 1, 0, 0, 0, 874, 875, 5, 164, 0, 0, 875, 880, 3, 108, 54, 0, 876, 877, 5, 154, 0,
        0, 877, 879, 3, 108, 54, 0, 878, 876, 1, 0, 0, 0, 879, 882, 1, 0, 0, 0, 880, 878, 1, 0, 0,
        0, 880, 881, 1, 0, 0, 0, 881, 107, 1, 0, 0, 0, 882, 880, 1, 0, 0, 0, 883, 885, 3, 326, 163,
        0, 884, 886, 3, 224, 112, 0, 885, 884, 1, 0, 0, 0, 885, 886, 1, 0, 0, 0, 886, 891, 1, 0, 0,
        0, 887, 888, 5, 149, 0, 0, 888, 889, 3, 290, 145, 0, 889, 890, 5, 150, 0, 0, 890, 892, 1, 0,
        0, 0, 891, 887, 1, 0, 0, 0, 891, 892, 1, 0, 0, 0, 892, 109, 1, 0, 0, 0, 893, 894, 5, 78, 0,
        0, 894, 895, 5, 147, 0, 0, 895, 896, 3, 112, 56, 0, 896, 897, 5, 148, 0, 0, 897, 111, 1, 0,
        0, 0, 898, 908, 3, 72, 36, 0, 899, 901, 3, 72, 36, 0, 900, 899, 1, 0, 0, 0, 900, 901, 1, 0,
        0, 0, 901, 902, 1, 0, 0, 0, 902, 904, 5, 164, 0, 0, 903, 900, 1, 0, 0, 0, 904, 905, 1, 0, 0,
        0, 905, 903, 1, 0, 0, 0, 905, 906, 1, 0, 0, 0, 906, 908, 1, 0, 0, 0, 907, 898, 1, 0, 0, 0,
        907, 903, 1, 0, 0, 0, 908, 113, 1, 0, 0, 0, 909, 910, 5, 71, 0, 0, 910, 911, 5, 147, 0, 0,
        911, 912, 3, 44, 22, 0, 912, 913, 5, 148, 0, 0, 913, 115, 1, 0, 0, 0, 914, 915, 5, 64, 0, 0,
        915, 916, 5, 147, 0, 0, 916, 917, 3, 188, 94, 0, 917, 918, 5, 148, 0, 0, 918, 117, 1, 0, 0,
        0, 919, 920, 3, 174, 87, 0, 920, 921, 3, 184, 92, 0, 921, 119, 1, 0, 0, 0, 922, 923, 5, 81,
        0, 0, 923, 924, 5, 147, 0, 0, 924, 925, 3, 358, 179, 0, 925, 926, 5, 148, 0, 0, 926, 930, 1,
        0, 0, 0, 927, 928, 5, 81, 0, 0, 928, 930, 3, 328, 164, 0, 929, 922, 1, 0, 0, 0, 929, 927, 1,
        0, 0, 0, 930, 121, 1, 0, 0, 0, 931, 932, 5, 82, 0, 0, 932, 936, 3, 300, 150, 0, 933, 935, 3,
        124, 62, 0, 934, 933, 1, 0, 0, 0, 935, 938, 1, 0, 0, 0, 936, 934, 1, 0, 0, 0, 936, 937, 1,
        0, 0, 0, 937, 941, 1, 0, 0, 0, 938, 936, 1, 0, 0, 0, 939, 940, 5, 66, 0, 0, 940, 942, 3,
        300, 150, 0, 941, 939, 1, 0, 0, 0, 941, 942, 1, 0, 0, 0, 942, 123, 1, 0, 0, 0, 943, 944, 5,
        61, 0, 0, 944, 945, 5, 147, 0, 0, 945, 946, 3, 118, 59, 0, 946, 947, 5, 148, 0, 0, 947, 948,
        3, 300, 150, 0, 948, 125, 1, 0, 0, 0, 949, 950, 5, 79, 0, 0, 950, 951, 5, 147, 0, 0, 951,
        952, 3, 328, 164, 0, 952, 953, 5, 148, 0, 0, 953, 954, 3, 300, 150, 0, 954, 127, 1, 0, 0, 0,
        955, 956, 5, 60, 0, 0, 956, 957, 3, 300, 150, 0, 957, 129, 1, 0, 0, 0, 958, 959, 3, 134, 67,
        0, 959, 960, 5, 153, 0, 0, 960, 131, 1, 0, 0, 0, 961, 962, 3, 134, 67, 0, 962, 963, 3, 300,
        150, 0, 963, 133, 1, 0, 0, 0, 964, 966, 3, 174, 87, 0, 965, 964, 1, 0, 0, 0, 965, 966, 1, 0,
        0, 0, 966, 967, 1, 0, 0, 0, 967, 969, 3, 184, 92, 0, 968, 970, 3, 136, 68, 0, 969, 968, 1,
        0, 0, 0, 969, 970, 1, 0, 0, 0, 970, 135, 1, 0, 0, 0, 971, 973, 3, 178, 89, 0, 972, 971, 1,
        0, 0, 0, 973, 974, 1, 0, 0, 0, 974, 972, 1, 0, 0, 0, 974, 975, 1, 0, 0, 0, 975, 137, 1, 0,
        0, 0, 976, 978, 3, 140, 70, 0, 977, 979, 3, 142, 71, 0, 978, 977, 1, 0, 0, 0, 978, 979, 1,
        0, 0, 0, 979, 139, 1, 0, 0, 0, 980, 983, 5, 5, 0, 0, 981, 983, 3, 358, 179, 0, 982, 980, 1,
        0, 0, 0, 982, 981, 1, 0, 0, 0, 983, 141, 1, 0, 0, 0, 984, 986, 5, 147, 0, 0, 985, 987, 3,
        144, 72, 0, 986, 985, 1, 0, 0, 0, 986, 987, 1, 0, 0, 0, 987, 988, 1, 0, 0, 0, 988, 989, 5,
        148, 0, 0, 989, 143, 1, 0, 0, 0, 990, 995, 3, 146, 73, 0, 991, 992, 5, 154, 0, 0, 992, 994,
        3, 146, 73, 0, 993, 991, 1, 0, 0, 0, 994, 997, 1, 0, 0, 0, 995, 993, 1, 0, 0, 0, 995, 996,
        1, 0, 0, 0, 996, 145, 1, 0, 0, 0, 997, 995, 1, 0, 0, 0, 998, 1003, 3, 138, 69, 0, 999, 1003,
        3, 354, 177, 0, 1000, 1003, 3, 356, 178, 0, 1001, 1003, 3, 148, 74, 0, 1002, 998, 1, 0, 0,
        0, 1002, 999, 1, 0, 0, 0, 1002, 1000, 1, 0, 0, 0, 1002, 1001, 1, 0, 0, 0, 1003, 147, 1, 0,
        0, 0, 1004, 1005, 3, 140, 70, 0, 1005, 1009, 5, 158, 0, 0, 1006, 1010, 3, 354, 177, 0, 1007,
        1010, 3, 140, 70, 0, 1008, 1010, 3, 356, 178, 0, 1009, 1006, 1, 0, 0, 0, 1009, 1007, 1, 0,
        0, 0, 1009, 1008, 1, 0, 0, 0, 1010, 149, 1, 0, 0, 0, 1011, 1012, 3, 174, 87, 0, 1012, 1013,
        5, 147, 0, 0, 1013, 1015, 5, 175, 0, 0, 1014, 1016, 3, 358, 179, 0, 1015, 1014, 1, 0, 0, 0,
        1015, 1016, 1, 0, 0, 0, 1016, 1017, 1, 0, 0, 0, 1017, 1018, 5, 148, 0, 0, 1018, 1020, 5,
        147, 0, 0, 1019, 1021, 3, 152, 76, 0, 1020, 1019, 1, 0, 0, 0, 1020, 1021, 1, 0, 0, 0, 1021,
        1022, 1, 0, 0, 0, 1022, 1023, 5, 148, 0, 0, 1023, 151, 1, 0, 0, 0, 1024, 1027, 3, 154, 77,
        0, 1025, 1026, 5, 154, 0, 0, 1026, 1028, 5, 191, 0, 0, 1027, 1025, 1, 0, 0, 0, 1027, 1028,
        1, 0, 0, 0, 1028, 153, 1, 0, 0, 0, 1029, 1034, 3, 156, 78, 0, 1030, 1031, 5, 154, 0, 0,
        1031, 1033, 3, 156, 78, 0, 1032, 1030, 1, 0, 0, 0, 1033, 1036, 1, 0, 0, 0, 1034, 1032, 1, 0,
        0, 0, 1034, 1035, 1, 0, 0, 0, 1035, 155, 1, 0, 0, 0, 1036, 1034, 1, 0, 0, 0, 1037, 1040, 3,
        174, 87, 0, 1038, 1040, 3, 150, 75, 0, 1039, 1037, 1, 0, 0, 0, 1039, 1038, 1, 0, 0, 0, 1040,
        1042, 1, 0, 0, 0, 1041, 1043, 3, 184, 92, 0, 1042, 1041, 1, 0, 0, 0, 1042, 1043, 1, 0, 0, 0,
        1043, 1046, 1, 0, 0, 0, 1044, 1046, 5, 32, 0, 0, 1045, 1039, 1, 0, 0, 0, 1045, 1044, 1, 0,
        0, 0, 1046, 157, 1, 0, 0, 0, 1047, 1049, 3, 212, 106, 0, 1048, 1047, 1, 0, 0, 0, 1048, 1049,
        1, 0, 0, 0, 1049, 1050, 1, 0, 0, 0, 1050, 1052, 3, 358, 179, 0, 1051, 1053, 3, 212, 106, 0,
        1052, 1051, 1, 0, 0, 0, 1052, 1053, 1, 0, 0, 0, 1053, 1054, 1, 0, 0, 0, 1054, 1055, 5, 147,
        0, 0, 1055, 1056, 3, 186, 93, 0, 1056, 1057, 5, 148, 0, 0, 1057, 1058, 5, 153, 0, 0, 1058,
        159, 1, 0, 0, 0, 1059, 1061, 3, 212, 106, 0, 1060, 1059, 1, 0, 0, 0, 1060, 1061, 1, 0, 0, 0,
        1061, 1063, 1, 0, 0, 0, 1062, 1064, 5, 29, 0, 0, 1063, 1062, 1, 0, 0, 0, 1063, 1064, 1, 0,
        0, 0, 1064, 1065, 1, 0, 0, 0, 1065, 1067, 3, 258, 129, 0, 1066, 1068, 3, 358, 179, 0, 1067,
        1066, 1, 0, 0, 0, 1067, 1068, 1, 0, 0, 0, 1068, 1069, 1, 0, 0, 0, 1069, 1070, 5, 153, 0, 0,
        1070, 161, 1, 0, 0, 0, 1071, 1072, 3, 174, 87, 0, 1072, 1073, 3, 180, 90, 0, 1073, 1076, 1,
        0, 0, 0, 1074, 1076, 3, 174, 87, 0, 1075, 1071, 1, 0, 0, 0, 1075, 1074, 1, 0, 0, 0, 1076,
        1077, 1, 0, 0, 0, 1077, 1078, 5, 153, 0, 0, 1078, 163, 1, 0, 0, 0, 1079, 1081, 3, 212, 106,
        0, 1080, 1079, 1, 0, 0, 0, 1080, 1081, 1, 0, 0, 0, 1081, 1082, 1, 0, 0, 0, 1082, 1087, 5,
        29, 0, 0, 1083, 1084, 3, 174, 87, 0, 1084, 1085, 3, 166, 83, 0, 1085, 1088, 1, 0, 0, 0,
        1086, 1088, 3, 174, 87, 0, 1087, 1083, 1, 0, 0, 0, 1087, 1086, 1, 0, 0, 0, 1088, 1090, 1, 0,
        0, 0, 1089, 1091, 3, 282, 141, 0, 1090, 1089, 1, 0, 0, 0, 1090, 1091, 1, 0, 0, 0, 1091,
        1092, 1, 0, 0, 0, 1092, 1093, 5, 153, 0, 0, 1093, 1102, 1, 0, 0, 0, 1094, 1096, 3, 212, 106,
        0, 1095, 1094, 1, 0, 0, 0, 1095, 1096, 1, 0, 0, 0, 1096, 1097, 1, 0, 0, 0, 1097, 1098, 5,
        29, 0, 0, 1098, 1099, 3, 150, 75, 0, 1099, 1100, 5, 153, 0, 0, 1100, 1102, 1, 0, 0, 0, 1101,
        1080, 1, 0, 0, 0, 1101, 1095, 1, 0, 0, 0, 1102, 165, 1, 0, 0, 0, 1103, 1108, 3, 184, 92, 0,
        1104, 1105, 5, 154, 0, 0, 1105, 1107, 3, 184, 92, 0, 1106, 1104, 1, 0, 0, 0, 1107, 1110, 1,
        0, 0, 0, 1108, 1106, 1, 0, 0, 0, 1108, 1109, 1, 0, 0, 0, 1109, 167, 1, 0, 0, 0, 1110, 1108,
        1, 0, 0, 0, 1111, 1120, 3, 226, 113, 0, 1112, 1120, 3, 212, 106, 0, 1113, 1120, 3, 222, 111,
        0, 1114, 1120, 3, 224, 112, 0, 1115, 1120, 3, 220, 110, 0, 1116, 1120, 3, 228, 114, 0, 1117,
        1120, 3, 230, 115, 0, 1118, 1120, 3, 240, 120, 0, 1119, 1111, 1, 0, 0, 0, 1119, 1112, 1, 0,
        0, 0, 1119, 1113, 1, 0, 0, 0, 1119, 1114, 1, 0, 0, 0, 1119, 1115, 1, 0, 0, 0, 1119, 1116, 1,
        0, 0, 0, 1119, 1117, 1, 0, 0, 0, 1119, 1118, 1, 0, 0, 0, 1120, 1121, 1, 0, 0, 0, 1121, 1119,
        1, 0, 0, 0, 1121, 1122, 1, 0, 0, 0, 1122, 169, 1, 0, 0, 0, 1123, 1132, 3, 226, 113, 0, 1124,
        1132, 3, 240, 120, 0, 1125, 1132, 3, 230, 115, 0, 1126, 1132, 3, 232, 116, 0, 1127, 1132, 3,
        234, 117, 0, 1128, 1132, 3, 222, 111, 0, 1129, 1132, 3, 224, 112, 0, 1130, 1132, 3, 220,
        110, 0, 1131, 1123, 1, 0, 0, 0, 1131, 1124, 1, 0, 0, 0, 1131, 1125, 1, 0, 0, 0, 1131, 1126,
        1, 0, 0, 0, 1131, 1127, 1, 0, 0, 0, 1131, 1128, 1, 0, 0, 0, 1131, 1129, 1, 0, 0, 0, 1131,
        1130, 1, 0, 0, 0, 1132, 171, 1, 0, 0, 0, 1133, 1142, 3, 226, 113, 0, 1134, 1142, 3, 240,
        120, 0, 1135, 1142, 3, 230, 115, 0, 1136, 1142, 3, 232, 116, 0, 1137, 1142, 3, 234, 117, 0,
        1138, 1142, 3, 222, 111, 0, 1139, 1142, 3, 224, 112, 0, 1140, 1142, 3, 220, 110, 0, 1141,
        1133, 1, 0, 0, 0, 1141, 1134, 1, 0, 0, 0, 1141, 1135, 1, 0, 0, 0, 1141, 1136, 1, 0, 0, 0,
        1141, 1137, 1, 0, 0, 0, 1141, 1138, 1, 0, 0, 0, 1141, 1139, 1, 0, 0, 0, 1141, 1140, 1, 0, 0,
        0, 1142, 173, 1, 0, 0, 0, 1143, 1145, 3, 228, 114, 0, 1144, 1143, 1, 0, 0, 0, 1144, 1145, 1,
        0, 0, 0, 1145, 1147, 1, 0, 0, 0, 1146, 1148, 3, 172, 86, 0, 1147, 1146, 1, 0, 0, 0, 1148,
        1149, 1, 0, 0, 0, 1149, 1147, 1, 0, 0, 0, 1149, 1150, 1, 0, 0, 0, 1150, 175, 1, 0, 0, 0,
        1151, 1153, 3, 228, 114, 0, 1152, 1151, 1, 0, 0, 0, 1152, 1153, 1, 0, 0, 0, 1153, 1155, 1,
        0, 0, 0, 1154, 1156, 3, 172, 86, 0, 1155, 1154, 1, 0, 0, 0, 1156, 1157, 1, 0, 0, 0, 1157,
        1155, 1, 0, 0, 0, 1157, 1158, 1, 0, 0, 0, 1158, 177, 1, 0, 0, 0, 1159, 1161, 3, 174, 87, 0,
        1160, 1162, 3, 180, 90, 0, 1161, 1160, 1, 0, 0, 0, 1161, 1162, 1, 0, 0, 0, 1162, 1163, 1, 0,
        0, 0, 1163, 1164, 5, 153, 0, 0, 1164, 1167, 1, 0, 0, 0, 1165, 1167, 3, 292, 146, 0, 1166,
        1159, 1, 0, 0, 0, 1166, 1165, 1, 0, 0, 0, 1167, 179, 1, 0, 0, 0, 1168, 1173, 3, 182, 91, 0,
        1169, 1170, 5, 154, 0, 0, 1170, 1172, 3, 182, 91, 0, 1171, 1169, 1, 0, 0, 0, 1172, 1175, 1,
        0, 0, 0, 1173, 1171, 1, 0, 0, 0, 1173, 1174, 1, 0, 0, 0, 1174, 181, 1, 0, 0, 0, 1175, 1173,
        1, 0, 0, 0, 1176, 1179, 3, 184, 92, 0, 1177, 1178, 5, 158, 0, 0, 1178, 1180, 3, 336, 168, 0,
        1179, 1177, 1, 0, 0, 0, 1179, 1180, 1, 0, 0, 0, 1180, 183, 1, 0, 0, 0, 1181, 1183, 3, 278,
        139, 0, 1182, 1181, 1, 0, 0, 0, 1182, 1183, 1, 0, 0, 0, 1183, 1184, 1, 0, 0, 0, 1184, 1188,
        3, 186, 93, 0, 1185, 1187, 3, 268, 134, 0, 1186, 1185, 1, 0, 0, 0, 1187, 1190, 1, 0, 0, 0,
        1188, 1186, 1, 0, 0, 0, 1188, 1189, 1, 0, 0, 0, 1189, 185, 1, 0, 0, 0, 1190, 1188, 1, 0, 0,
        0, 1191, 1192, 6, 93, -1, 0, 1192, 1220, 3, 358, 179, 0, 1193, 1194, 5, 147, 0, 0, 1194,
        1195, 3, 184, 92, 0, 1195, 1196, 5, 148, 0, 0, 1196, 1220, 1, 0, 0, 0, 1197, 1198, 5, 147,
        0, 0, 1198, 1200, 5, 179, 0, 0, 1199, 1201, 3, 224, 112, 0, 1200, 1199, 1, 0, 0, 0, 1200,
        1201, 1, 0, 0, 0, 1201, 1203, 1, 0, 0, 0, 1202, 1204, 3, 186, 93, 0, 1203, 1202, 1, 0, 0, 0,
        1203, 1204, 1, 0, 0, 0, 1204, 1205, 1, 0, 0, 0, 1205, 1206, 5, 148, 0, 0, 1206, 1220, 3, 92,
        46, 0, 1207, 1208, 3, 358, 179, 0, 1208, 1209, 5, 164, 0, 0, 1209, 1210, 5, 198, 0, 0, 1210,
        1220, 1, 0, 0, 0, 1211, 1212, 3, 266, 133, 0, 1212, 1213, 3, 358, 179, 0, 1213, 1220, 1, 0,
        0, 0, 1214, 1215, 5, 147, 0, 0, 1215, 1216, 3, 266, 133, 0, 1216, 1217, 3, 184, 92, 0, 1217,
        1218, 5, 148, 0, 0, 1218, 1220, 1, 0, 0, 0, 1219, 1191, 1, 0, 0, 0, 1219, 1193, 1, 0, 0, 0,
        1219, 1197, 1, 0, 0, 0, 1219, 1207, 1, 0, 0, 0, 1219, 1211, 1, 0, 0, 0, 1219, 1214, 1, 0, 0,
        0, 1220, 1261, 1, 0, 0, 0, 1221, 1222, 10, 9, 0, 0, 1222, 1224, 5, 151, 0, 0, 1223, 1225, 3,
        206, 103, 0, 1224, 1223, 1, 0, 0, 0, 1224, 1225, 1, 0, 0, 0, 1225, 1227, 1, 0, 0, 0, 1226,
        1228, 3, 352, 176, 0, 1227, 1226, 1, 0, 0, 0, 1227, 1228, 1, 0, 0, 0, 1228, 1229, 1, 0, 0,
        0, 1229, 1260, 5, 152, 0, 0, 1230, 1231, 10, 8, 0, 0, 1231, 1232, 5, 151, 0, 0, 1232, 1234,
        5, 26, 0, 0, 1233, 1235, 3, 206, 103, 0, 1234, 1233, 1, 0, 0, 0, 1234, 1235, 1, 0, 0, 0,
        1235, 1236, 1, 0, 0, 0, 1236, 1237, 3, 352, 176, 0, 1237, 1238, 5, 152, 0, 0, 1238, 1260, 1,
        0, 0, 0, 1239, 1240, 10, 7, 0, 0, 1240, 1241, 5, 151, 0, 0, 1241, 1242, 3, 206, 103, 0,
        1242, 1243, 5, 26, 0, 0, 1243, 1244, 3, 352, 176, 0, 1244, 1245, 5, 152, 0, 0, 1245, 1260,
        1, 0, 0, 0, 1246, 1247, 10, 6, 0, 0, 1247, 1249, 5, 151, 0, 0, 1248, 1250, 3, 206, 103, 0,
        1249, 1248, 1, 0, 0, 0, 1249, 1250, 1, 0, 0, 0, 1250, 1251, 1, 0, 0, 0, 1251, 1252, 5, 175,
        0, 0, 1252, 1260, 5, 152, 0, 0, 1253, 1254, 10, 5, 0, 0, 1254, 1256, 5, 147, 0, 0, 1255,
        1257, 3, 198, 99, 0, 1256, 1255, 1, 0, 0, 0, 1256, 1257, 1, 0, 0, 0, 1257, 1258, 1, 0, 0, 0,
        1258, 1260, 5, 148, 0, 0, 1259, 1221, 1, 0, 0, 0, 1259, 1230, 1, 0, 0, 0, 1259, 1239, 1, 0,
        0, 0, 1259, 1246, 1, 0, 0, 0, 1259, 1253, 1, 0, 0, 0, 1260, 1263, 1, 0, 0, 0, 1261, 1259, 1,
        0, 0, 0, 1261, 1262, 1, 0, 0, 0, 1262, 187, 1, 0, 0, 0, 1263, 1261, 1, 0, 0, 0, 1264, 1266,
        3, 174, 87, 0, 1265, 1267, 3, 192, 96, 0, 1266, 1265, 1, 0, 0, 0, 1266, 1267, 1, 0, 0, 0,
        1267, 189, 1, 0, 0, 0, 1268, 1270, 3, 278, 139, 0, 1269, 1271, 3, 190, 95, 0, 1270, 1269, 1,
        0, 0, 0, 1270, 1271, 1, 0, 0, 0, 1271, 1292, 1, 0, 0, 0, 1272, 1274, 5, 147, 0, 0, 1273,
        1275, 3, 192, 96, 0, 1274, 1273, 1, 0, 0, 0, 1274, 1275, 1, 0, 0, 0, 1275, 1276, 1, 0, 0, 0,
        1276, 1278, 5, 148, 0, 0, 1277, 1279, 3, 196, 98, 0, 1278, 1277, 1, 0, 0, 0, 1279, 1280, 1,
        0, 0, 0, 1280, 1278, 1, 0, 0, 0, 1280, 1281, 1, 0, 0, 0, 1281, 1292, 1, 0, 0, 0, 1282, 1284,
        5, 151, 0, 0, 1283, 1285, 3, 338, 169, 0, 1284, 1283, 1, 0, 0, 0, 1284, 1285, 1, 0, 0, 0,
        1285, 1286, 1, 0, 0, 0, 1286, 1288, 5, 152, 0, 0, 1287, 1282, 1, 0, 0, 0, 1288, 1289, 1, 0,
        0, 0, 1289, 1287, 1, 0, 0, 0, 1289, 1290, 1, 0, 0, 0, 1290, 1292, 1, 0, 0, 0, 1291, 1268, 1,
        0, 0, 0, 1291, 1272, 1, 0, 0, 0, 1291, 1287, 1, 0, 0, 0, 1292, 191, 1, 0, 0, 0, 1293, 1305,
        3, 278, 139, 0, 1294, 1296, 3, 278, 139, 0, 1295, 1294, 1, 0, 0, 0, 1295, 1296, 1, 0, 0, 0,
        1296, 1297, 1, 0, 0, 0, 1297, 1301, 3, 194, 97, 0, 1298, 1300, 3, 268, 134, 0, 1299, 1298,
        1, 0, 0, 0, 1300, 1303, 1, 0, 0, 0, 1301, 1299, 1, 0, 0, 0, 1301, 1302, 1, 0, 0, 0, 1302,
        1305, 1, 0, 0, 0, 1303, 1301, 1, 0, 0, 0, 1304, 1293, 1, 0, 0, 0, 1304, 1295, 1, 0, 0, 0,
        1305, 193, 1, 0, 0, 0, 1306, 1307, 6, 97, -1, 0, 1307, 1308, 5, 147, 0, 0, 1308, 1309, 3,
        192, 96, 0, 1309, 1313, 5, 148, 0, 0, 1310, 1312, 3, 268, 134, 0, 1311, 1310, 1, 0, 0, 0,
        1312, 1315, 1, 0, 0, 0, 1313, 1311, 1, 0, 0, 0, 1313, 1314, 1, 0, 0, 0, 1314, 1360, 1, 0, 0,
        0, 1315, 1313, 1, 0, 0, 0, 1316, 1318, 5, 151, 0, 0, 1317, 1319, 3, 206, 103, 0, 1318, 1317,
        1, 0, 0, 0, 1318, 1319, 1, 0, 0, 0, 1319, 1321, 1, 0, 0, 0, 1320, 1322, 3, 352, 176, 0,
        1321, 1320, 1, 0, 0, 0, 1321, 1322, 1, 0, 0, 0, 1322, 1323, 1, 0, 0, 0, 1323, 1360, 5, 152,
        0, 0, 1324, 1325, 5, 151, 0, 0, 1325, 1327, 5, 26, 0, 0, 1326, 1328, 3, 206, 103, 0, 1327,
        1326, 1, 0, 0, 0, 1327, 1328, 1, 0, 0, 0, 1328, 1329, 1, 0, 0, 0, 1329, 1330, 3, 352, 176,
        0, 1330, 1331, 5, 152, 0, 0, 1331, 1360, 1, 0, 0, 0, 1332, 1333, 5, 151, 0, 0, 1333, 1334,
        3, 206, 103, 0, 1334, 1335, 5, 26, 0, 0, 1335, 1336, 3, 352, 176, 0, 1336, 1337, 5, 152, 0,
        0, 1337, 1360, 1, 0, 0, 0, 1338, 1339, 5, 151, 0, 0, 1339, 1340, 5, 175, 0, 0, 1340, 1360,
        5, 152, 0, 0, 1341, 1343, 5, 147, 0, 0, 1342, 1344, 3, 198, 99, 0, 1343, 1342, 1, 0, 0, 0,
        1343, 1344, 1, 0, 0, 0, 1344, 1345, 1, 0, 0, 0, 1345, 1349, 5, 148, 0, 0, 1346, 1348, 3,
        268, 134, 0, 1347, 1346, 1, 0, 0, 0, 1348, 1351, 1, 0, 0, 0, 1349, 1347, 1, 0, 0, 0, 1349,
        1350, 1, 0, 0, 0, 1350, 1360, 1, 0, 0, 0, 1351, 1349, 1, 0, 0, 0, 1352, 1353, 5, 147, 0, 0,
        1353, 1355, 5, 179, 0, 0, 1354, 1356, 3, 224, 112, 0, 1355, 1354, 1, 0, 0, 0, 1355, 1356, 1,
        0, 0, 0, 1356, 1357, 1, 0, 0, 0, 1357, 1358, 5, 148, 0, 0, 1358, 1360, 3, 92, 46, 0, 1359,
        1306, 1, 0, 0, 0, 1359, 1316, 1, 0, 0, 0, 1359, 1324, 1, 0, 0, 0, 1359, 1332, 1, 0, 0, 0,
        1359, 1338, 1, 0, 0, 0, 1359, 1341, 1, 0, 0, 0, 1359, 1352, 1, 0, 0, 0, 1360, 1404, 1, 0, 0,
        0, 1361, 1362, 10, 6, 0, 0, 1362, 1364, 5, 151, 0, 0, 1363, 1365, 3, 206, 103, 0, 1364,
        1363, 1, 0, 0, 0, 1364, 1365, 1, 0, 0, 0, 1365, 1367, 1, 0, 0, 0, 1366, 1368, 3, 352, 176,
        0, 1367, 1366, 1, 0, 0, 0, 1367, 1368, 1, 0, 0, 0, 1368, 1369, 1, 0, 0, 0, 1369, 1403, 5,
        152, 0, 0, 1370, 1371, 10, 5, 0, 0, 1371, 1372, 5, 151, 0, 0, 1372, 1374, 5, 26, 0, 0, 1373,
        1375, 3, 206, 103, 0, 1374, 1373, 1, 0, 0, 0, 1374, 1375, 1, 0, 0, 0, 1375, 1376, 1, 0, 0,
        0, 1376, 1377, 3, 352, 176, 0, 1377, 1378, 5, 152, 0, 0, 1378, 1403, 1, 0, 0, 0, 1379, 1380,
        10, 4, 0, 0, 1380, 1381, 5, 151, 0, 0, 1381, 1382, 3, 206, 103, 0, 1382, 1383, 5, 26, 0, 0,
        1383, 1384, 3, 352, 176, 0, 1384, 1385, 5, 152, 0, 0, 1385, 1403, 1, 0, 0, 0, 1386, 1387,
        10, 3, 0, 0, 1387, 1388, 5, 151, 0, 0, 1388, 1389, 5, 175, 0, 0, 1389, 1403, 5, 152, 0, 0,
        1390, 1391, 10, 2, 0, 0, 1391, 1393, 5, 147, 0, 0, 1392, 1394, 3, 198, 99, 0, 1393, 1392, 1,
        0, 0, 0, 1393, 1394, 1, 0, 0, 0, 1394, 1395, 1, 0, 0, 0, 1395, 1399, 5, 148, 0, 0, 1396,
        1398, 3, 268, 134, 0, 1397, 1396, 1, 0, 0, 0, 1398, 1401, 1, 0, 0, 0, 1399, 1397, 1, 0, 0,
        0, 1399, 1400, 1, 0, 0, 0, 1400, 1403, 1, 0, 0, 0, 1401, 1399, 1, 0, 0, 0, 1402, 1361, 1, 0,
        0, 0, 1402, 1370, 1, 0, 0, 0, 1402, 1379, 1, 0, 0, 0, 1402, 1386, 1, 0, 0, 0, 1402, 1390, 1,
        0, 0, 0, 1403, 1406, 1, 0, 0, 0, 1404, 1402, 1, 0, 0, 0, 1404, 1405, 1, 0, 0, 0, 1405, 195,
        1, 0, 0, 0, 1406, 1404, 1, 0, 0, 0, 1407, 1409, 5, 151, 0, 0, 1408, 1410, 3, 338, 169, 0,
        1409, 1408, 1, 0, 0, 0, 1409, 1410, 1, 0, 0, 0, 1410, 1411, 1, 0, 0, 0, 1411, 1418, 5, 152,
        0, 0, 1412, 1414, 5, 147, 0, 0, 1413, 1415, 3, 202, 101, 0, 1414, 1413, 1, 0, 0, 0, 1414,
        1415, 1, 0, 0, 0, 1415, 1416, 1, 0, 0, 0, 1416, 1418, 5, 148, 0, 0, 1417, 1407, 1, 0, 0, 0,
        1417, 1412, 1, 0, 0, 0, 1418, 197, 1, 0, 0, 0, 1419, 1422, 3, 200, 100, 0, 1420, 1421, 5,
        154, 0, 0, 1421, 1423, 5, 191, 0, 0, 1422, 1420, 1, 0, 0, 0, 1422, 1423, 1, 0, 0, 0, 1423,
        199, 1, 0, 0, 0, 1424, 1429, 3, 204, 102, 0, 1425, 1426, 5, 154, 0, 0, 1426, 1428, 3, 204,
        102, 0, 1427, 1425, 1, 0, 0, 0, 1428, 1431, 1, 0, 0, 0, 1429, 1427, 1, 0, 0, 0, 1429, 1430,
        1, 0, 0, 0, 1430, 201, 1, 0, 0, 0, 1431, 1429, 1, 0, 0, 0, 1432, 1437, 3, 204, 102, 0, 1433,
        1434, 5, 154, 0, 0, 1434, 1436, 3, 204, 102, 0, 1435, 1433, 1, 0, 0, 0, 1436, 1439, 1, 0, 0,
        0, 1437, 1435, 1, 0, 0, 0, 1437, 1438, 1, 0, 0, 0, 1438, 203, 1, 0, 0, 0, 1439, 1437, 1, 0,
        0, 0, 1440, 1441, 3, 174, 87, 0, 1441, 1442, 3, 184, 92, 0, 1442, 1448, 1, 0, 0, 0, 1443,
        1445, 3, 174, 87, 0, 1444, 1446, 3, 192, 96, 0, 1445, 1444, 1, 0, 0, 0, 1445, 1446, 1, 0, 0,
        0, 1446, 1448, 1, 0, 0, 0, 1447, 1440, 1, 0, 0, 0, 1447, 1443, 1, 0, 0, 0, 1448, 205, 1, 0,
        0, 0, 1449, 1451, 3, 230, 115, 0, 1450, 1449, 1, 0, 0, 0, 1451, 1452, 1, 0, 0, 0, 1452,
        1450, 1, 0, 0, 0, 1452, 1453, 1, 0, 0, 0, 1453, 207, 1, 0, 0, 0, 1454, 1459, 3, 358, 179, 0,
        1455, 1456, 5, 154, 0, 0, 1456, 1458, 3, 358, 179, 0, 1457, 1455, 1, 0, 0, 0, 1458, 1461, 1,
        0, 0, 0, 1459, 1457, 1, 0, 0, 0, 1459, 1460, 1, 0, 0, 0, 1460, 209, 1, 0, 0, 0, 1461, 1459,
        1, 0, 0, 0, 1462, 1464, 5, 151, 0, 0, 1463, 1465, 3, 338, 169, 0, 1464, 1463, 1, 0, 0, 0,
        1464, 1465, 1, 0, 0, 0, 1465, 1466, 1, 0, 0, 0, 1466, 1467, 5, 152, 0, 0, 1467, 211, 1, 0,
        0, 0, 1468, 1469, 5, 86, 0, 0, 1469, 1470, 5, 147, 0, 0, 1470, 1471, 5, 147, 0, 0, 1471,
        1476, 3, 138, 69, 0, 1472, 1473, 5, 154, 0, 0, 1473, 1475, 3, 138, 69, 0, 1474, 1472, 1, 0,
        0, 0, 1475, 1478, 1, 0, 0, 0, 1476, 1474, 1, 0, 0, 0, 1476, 1477, 1, 0, 0, 0, 1477, 1479, 1,
        0, 0, 0, 1478, 1476, 1, 0, 0, 0, 1479, 1480, 5, 148, 0, 0, 1480, 1481, 5, 148, 0, 0, 1481,
        213, 1, 0, 0, 0, 1482, 1483, 5, 115, 0, 0, 1483, 1484, 5, 147, 0, 0, 1484, 1485, 3, 188, 94,
        0, 1485, 1486, 5, 148, 0, 0, 1486, 215, 1, 0, 0, 0, 1487, 1491, 7, 3, 0, 0, 1488, 1490, 3,
        212, 106, 0, 1489, 1488, 1, 0, 0, 0, 1490, 1493, 1, 0, 0, 0, 1491, 1489, 1, 0, 0, 0, 1491,
        1492, 1, 0, 0, 0, 1492, 1506, 1, 0, 0, 0, 1493, 1491, 1, 0, 0, 0, 1494, 1507, 3, 358, 179,
        0, 1495, 1497, 3, 358, 179, 0, 1496, 1495, 1, 0, 0, 0, 1496, 1497, 1, 0, 0, 0, 1497, 1498,
        1, 0, 0, 0, 1498, 1500, 5, 149, 0, 0, 1499, 1501, 3, 218, 109, 0, 1500, 1499, 1, 0, 0, 0,
        1501, 1502, 1, 0, 0, 0, 1502, 1500, 1, 0, 0, 0, 1502, 1503, 1, 0, 0, 0, 1503, 1504, 1, 0, 0,
        0, 1504, 1505, 5, 150, 0, 0, 1505, 1507, 1, 0, 0, 0, 1506, 1494, 1, 0, 0, 0, 1506, 1496, 1,
        0, 0, 0, 1507, 217, 1, 0, 0, 0, 1508, 1509, 3, 174, 87, 0, 1509, 1511, 3, 254, 127, 0, 1510,
        1512, 3, 282, 141, 0, 1511, 1510, 1, 0, 0, 0, 1511, 1512, 1, 0, 0, 0, 1512, 1513, 1, 0, 0,
        0, 1513, 1514, 5, 153, 0, 0, 1514, 1519, 1, 0, 0, 0, 1515, 1516, 3, 150, 75, 0, 1516, 1517,
        5, 153, 0, 0, 1517, 1519, 1, 0, 0, 0, 1518, 1508, 1, 0, 0, 0, 1518, 1515, 1, 0, 0, 0, 1519,
        219, 1, 0, 0, 0, 1520, 1521, 5, 137, 0, 0, 1521, 1522, 5, 147, 0, 0, 1522, 1523, 3, 358,
        179, 0, 1523, 1524, 5, 148, 0, 0, 1524, 1527, 1, 0, 0, 0, 1525, 1527, 5, 136, 0, 0, 1526,
        1520, 1, 0, 0, 0, 1526, 1525, 1, 0, 0, 0, 1527, 221, 1, 0, 0, 0, 1528, 1529, 7, 4, 0, 0,
        1529, 223, 1, 0, 0, 0, 1530, 1531, 7, 5, 0, 0, 1531, 225, 1, 0, 0, 0, 1532, 1533, 7, 6, 0,
        0, 1533, 227, 1, 0, 0, 0, 1534, 1535, 7, 7, 0, 0, 1535, 229, 1, 0, 0, 0, 1536, 1542, 5, 5,
        0, 0, 1537, 1542, 5, 33, 0, 0, 1538, 1542, 5, 21, 0, 0, 1539, 1542, 5, 115, 0, 0, 1540,
        1542, 3, 236, 118, 0, 1541, 1536, 1, 0, 0, 0, 1541, 1537, 1, 0, 0, 0, 1541, 1538, 1, 0, 0,
        0, 1541, 1539, 1, 0, 0, 0, 1541, 1540, 1, 0, 0, 0, 1542, 231, 1, 0, 0, 0, 1543, 1551, 7, 8,
        0, 0, 1544, 1551, 3, 270, 135, 0, 1545, 1546, 5, 106, 0, 0, 1546, 1547, 5, 147, 0, 0, 1547,
        1548, 3, 358, 179, 0, 1548, 1549, 5, 148, 0, 0, 1549, 1551, 1, 0, 0, 0, 1550, 1543, 1, 0, 0,
        0, 1550, 1544, 1, 0, 0, 0, 1550, 1545, 1, 0, 0, 0, 1551, 233, 1, 0, 0, 0, 1552, 1553, 5,
        117, 0, 0, 1553, 1556, 5, 147, 0, 0, 1554, 1557, 3, 188, 94, 0, 1555, 1557, 3, 338, 169, 0,
        1556, 1554, 1, 0, 0, 0, 1556, 1555, 1, 0, 0, 0, 1557, 1558, 1, 0, 0, 0, 1558, 1559, 5, 148,
        0, 0, 1559, 235, 1, 0, 0, 0, 1560, 1561, 7, 9, 0, 0, 1561, 237, 1, 0, 0, 0, 1562, 1564, 3,
        250, 125, 0, 1563, 1565, 3, 278, 139, 0, 1564, 1563, 1, 0, 0, 0, 1564, 1565, 1, 0, 0, 0,
        1565, 1587, 1, 0, 0, 0, 1566, 1587, 3, 252, 126, 0, 1567, 1569, 5, 95, 0, 0, 1568, 1567, 1,
        0, 0, 0, 1568, 1569, 1, 0, 0, 0, 1569, 1570, 1, 0, 0, 0, 1570, 1572, 3, 244, 122, 0, 1571,
        1573, 3, 278, 139, 0, 1572, 1571, 1, 0, 0, 0, 1572, 1573, 1, 0, 0, 0, 1573, 1587, 1, 0, 0,
        0, 1574, 1576, 3, 216, 108, 0, 1575, 1577, 3, 278, 139, 0, 1576, 1575, 1, 0, 0, 0, 1576,
        1577, 1, 0, 0, 0, 1577, 1587, 1, 0, 0, 0, 1578, 1587, 3, 258, 129, 0, 1579, 1581, 5, 95, 0,
        0, 1580, 1579, 1, 0, 0, 0, 1580, 1581, 1, 0, 0, 0, 1581, 1582, 1, 0, 0, 0, 1582, 1584, 3,
        358, 179, 0, 1583, 1585, 3, 278, 139, 0, 1584, 1583, 1, 0, 0, 0, 1584, 1585, 1, 0, 0, 0,
        1585, 1587, 1, 0, 0, 0, 1586, 1562, 1, 0, 0, 0, 1586, 1566, 1, 0, 0, 0, 1586, 1568, 1, 0, 0,
        0, 1586, 1574, 1, 0, 0, 0, 1586, 1578, 1, 0, 0, 0, 1586, 1580, 1, 0, 0, 0, 1587, 239, 1, 0,
        0, 0, 1588, 1604, 3, 250, 125, 0, 1589, 1590, 5, 111, 0, 0, 1590, 1591, 5, 147, 0, 0, 1591,
        1592, 7, 10, 0, 0, 1592, 1604, 5, 148, 0, 0, 1593, 1604, 3, 244, 122, 0, 1594, 1604, 3, 214,
        107, 0, 1595, 1604, 3, 216, 108, 0, 1596, 1604, 3, 258, 129, 0, 1597, 1604, 3, 242, 121, 0,
        1598, 1599, 5, 98, 0, 0, 1599, 1600, 5, 147, 0, 0, 1600, 1601, 3, 338, 169, 0, 1601, 1602,
        5, 148, 0, 0, 1602, 1604, 1, 0, 0, 0, 1603, 1588, 1, 0, 0, 0, 1603, 1589, 1, 0, 0, 0, 1603,
        1593, 1, 0, 0, 0, 1603, 1594, 1, 0, 0, 0, 1603, 1595, 1, 0, 0, 0, 1603, 1596, 1, 0, 0, 0,
        1603, 1597, 1, 0, 0, 0, 1603, 1598, 1, 0, 0, 0, 1604, 241, 1, 0, 0, 0, 1605, 1606, 3, 358,
        179, 0, 1606, 243, 1, 0, 0, 0, 1607, 1608, 3, 358, 179, 0, 1608, 1609, 3, 246, 123, 0, 1609,
        245, 1, 0, 0, 0, 1610, 1619, 5, 160, 0, 0, 1611, 1616, 3, 248, 124, 0, 1612, 1613, 5, 154,
        0, 0, 1613, 1615, 3, 248, 124, 0, 1614, 1612, 1, 0, 0, 0, 1615, 1618, 1, 0, 0, 0, 1616,
        1614, 1, 0, 0, 0, 1616, 1617, 1, 0, 0, 0, 1617, 1620, 1, 0, 0, 0, 1618, 1616, 1, 0, 0, 0,
        1619, 1611, 1, 0, 0, 0, 1619, 1620, 1, 0, 0, 0, 1620, 1621, 1, 0, 0, 0, 1621, 1622, 5, 159,
        0, 0, 1622, 247, 1, 0, 0, 0, 1623, 1625, 7, 1, 0, 0, 1624, 1623, 1, 0, 0, 0, 1624, 1625, 1,
        0, 0, 0, 1625, 1626, 1, 0, 0, 0, 1626, 1627, 3, 188, 94, 0, 1627, 249, 1, 0, 0, 0, 1628,
        1629, 7, 11, 0, 0, 1629, 251, 1, 0, 0, 0, 1630, 1631, 5, 97, 0, 0, 1631, 1632, 5, 147, 0, 0,
        1632, 1633, 3, 328, 164, 0, 1633, 1634, 5, 148, 0, 0, 1634, 253, 1, 0, 0, 0, 1635, 1640, 3,
        256, 128, 0, 1636, 1637, 5, 154, 0, 0, 1637, 1639, 3, 256, 128, 0, 1638, 1636, 1, 0, 0, 0,
        1639, 1642, 1, 0, 0, 0, 1640, 1638, 1, 0, 0, 0, 1640, 1641, 1, 0, 0, 0, 1641, 255, 1, 0, 0,
        0, 1642, 1640, 1, 0, 0, 0, 1643, 1650, 3, 184, 92, 0, 1644, 1646, 3, 184, 92, 0, 1645, 1644,
        1, 0, 0, 0, 1645, 1646, 1, 0, 0, 0, 1646, 1647, 1, 0, 0, 0, 1647, 1648, 5, 164, 0, 0, 1648,
        1650, 3, 354, 177, 0, 1649, 1643, 1, 0, 0, 0, 1649, 1645, 1, 0, 0, 0, 1650, 257, 1, 0, 0, 0,
        1651, 1657, 5, 11, 0, 0, 1652, 1654, 3, 358, 179, 0, 1653, 1652, 1, 0, 0, 0, 1653, 1654, 1,
        0, 0, 0, 1654, 1655, 1, 0, 0, 0, 1655, 1656, 5, 164, 0, 0, 1656, 1658, 3, 188, 94, 0, 1657,
        1653, 1, 0, 0, 0, 1657, 1658, 1, 0, 0, 0, 1658, 1670, 1, 0, 0, 0, 1659, 1664, 3, 358, 179,
        0, 1660, 1661, 5, 149, 0, 0, 1661, 1662, 3, 260, 130, 0, 1662, 1663, 5, 150, 0, 0, 1663,
        1665, 1, 0, 0, 0, 1664, 1660, 1, 0, 0, 0, 1664, 1665, 1, 0, 0, 0, 1665, 1671, 1, 0, 0, 0,
        1666, 1667, 5, 149, 0, 0, 1667, 1668, 3, 260, 130, 0, 1668, 1669, 5, 150, 0, 0, 1669, 1671,
        1, 0, 0, 0, 1670, 1659, 1, 0, 0, 0, 1670, 1666, 1, 0, 0, 0, 1671, 1683, 1, 0, 0, 0, 1672,
        1673, 7, 12, 0, 0, 1673, 1674, 5, 147, 0, 0, 1674, 1675, 3, 188, 94, 0, 1675, 1676, 5, 154,
        0, 0, 1676, 1677, 3, 358, 179, 0, 1677, 1678, 5, 148, 0, 0, 1678, 1679, 5, 149, 0, 0, 1679,
        1680, 3, 260, 130, 0, 1680, 1681, 5, 150, 0, 0, 1681, 1683, 1, 0, 0, 0, 1682, 1651, 1, 0, 0,
        0, 1682, 1672, 1, 0, 0, 0, 1683, 259, 1, 0, 0, 0, 1684, 1689, 3, 262, 131, 0, 1685, 1686, 5,
        154, 0, 0, 1686, 1688, 3, 262, 131, 0, 1687, 1685, 1, 0, 0, 0, 1688, 1691, 1, 0, 0, 0, 1689,
        1687, 1, 0, 0, 0, 1689, 1690, 1, 0, 0, 0, 1690, 1693, 1, 0, 0, 0, 1691, 1689, 1, 0, 0, 0,
        1692, 1694, 5, 154, 0, 0, 1693, 1692, 1, 0, 0, 0, 1693, 1694, 1, 0, 0, 0, 1694, 261, 1, 0,
        0, 0, 1695, 1698, 3, 264, 132, 0, 1696, 1697, 5, 158, 0, 0, 1697, 1699, 3, 328, 164, 0,
        1698, 1696, 1, 0, 0, 0, 1698, 1699, 1, 0, 0, 0, 1699, 263, 1, 0, 0, 0, 1700, 1701, 3, 358,
        179, 0, 1701, 265, 1, 0, 0, 0, 1702, 1703, 7, 13, 0, 0, 1703, 267, 1, 0, 0, 0, 1704, 1705,
        5, 102, 0, 0, 1705, 1707, 5, 147, 0, 0, 1706, 1708, 3, 356, 178, 0, 1707, 1706, 1, 0, 0, 0,
        1708, 1709, 1, 0, 0, 0, 1709, 1707, 1, 0, 0, 0, 1709, 1710, 1, 0, 0, 0, 1710, 1711, 1, 0, 0,
        0, 1711, 1712, 5, 148, 0, 0, 1712, 1715, 1, 0, 0, 0, 1713, 1715, 3, 270, 135, 0, 1714, 1704,
        1, 0, 0, 0, 1714, 1713, 1, 0, 0, 0, 1715, 269, 1, 0, 0, 0, 1716, 1717, 5, 86, 0, 0, 1717,
        1718, 5, 147, 0, 0, 1718, 1719, 5, 147, 0, 0, 1719, 1720, 3, 272, 136, 0, 1720, 1721, 5,
        148, 0, 0, 1721, 1722, 5, 148, 0, 0, 1722, 271, 1, 0, 0, 0, 1723, 1725, 3, 274, 137, 0,
        1724, 1723, 1, 0, 0, 0, 1724, 1725, 1, 0, 0, 0, 1725, 1732, 1, 0, 0, 0, 1726, 1728, 5, 154,
        0, 0, 1727, 1729, 3, 274, 137, 0, 1728, 1727, 1, 0, 0, 0, 1728, 1729, 1, 0, 0, 0, 1729,
        1731, 1, 0, 0, 0, 1730, 1726, 1, 0, 0, 0, 1731, 1734, 1, 0, 0, 0, 1732, 1730, 1, 0, 0, 0,
        1732, 1733, 1, 0, 0, 0, 1733, 273, 1, 0, 0, 0, 1734, 1732, 1, 0, 0, 0, 1735, 1741, 8, 14, 0,
        0, 1736, 1738, 5, 147, 0, 0, 1737, 1739, 3, 348, 174, 0, 1738, 1737, 1, 0, 0, 0, 1738, 1739,
        1, 0, 0, 0, 1739, 1740, 1, 0, 0, 0, 1740, 1742, 5, 148, 0, 0, 1741, 1736, 1, 0, 0, 0, 1741,
        1742, 1, 0, 0, 0, 1742, 275, 1, 0, 0, 0, 1743, 1745, 5, 175, 0, 0, 1744, 1746, 3, 174, 87,
        0, 1745, 1744, 1, 0, 0, 0, 1745, 1746, 1, 0, 0, 0, 1746, 1748, 1, 0, 0, 0, 1747, 1749, 3,
        278, 139, 0, 1748, 1747, 1, 0, 0, 0, 1748, 1749, 1, 0, 0, 0, 1749, 277, 1, 0, 0, 0, 1750,
        1752, 3, 280, 140, 0, 1751, 1750, 1, 0, 0, 0, 1752, 1753, 1, 0, 0, 0, 1753, 1751, 1, 0, 0,
        0, 1753, 1754, 1, 0, 0, 0, 1754, 279, 1, 0, 0, 0, 1755, 1757, 5, 175, 0, 0, 1756, 1758, 3,
        206, 103, 0, 1757, 1756, 1, 0, 0, 0, 1757, 1758, 1, 0, 0, 0, 1758, 281, 1, 0, 0, 0, 1759,
        1768, 3, 358, 179, 0, 1760, 1763, 5, 147, 0, 0, 1761, 1764, 5, 154, 0, 0, 1762, 1764, 8, 15,
        0, 0, 1763, 1761, 1, 0, 0, 0, 1763, 1762, 1, 0, 0, 0, 1764, 1765, 1, 0, 0, 0, 1765, 1763, 1,
        0, 0, 0, 1765, 1766, 1, 0, 0, 0, 1766, 1767, 1, 0, 0, 0, 1767, 1769, 5, 148, 0, 0, 1768,
        1760, 1, 0, 0, 0, 1768, 1769, 1, 0, 0, 0, 1769, 283, 1, 0, 0, 0, 1770, 1782, 5, 149, 0, 0,
        1771, 1776, 3, 328, 164, 0, 1772, 1773, 5, 154, 0, 0, 1773, 1775, 3, 328, 164, 0, 1774,
        1772, 1, 0, 0, 0, 1775, 1778, 1, 0, 0, 0, 1776, 1774, 1, 0, 0, 0, 1776, 1777, 1, 0, 0, 0,
        1777, 1780, 1, 0, 0, 0, 1778, 1776, 1, 0, 0, 0, 1779, 1781, 5, 154, 0, 0, 1780, 1779, 1, 0,
        0, 0, 1780, 1781, 1, 0, 0, 0, 1781, 1783, 1, 0, 0, 0, 1782, 1771, 1, 0, 0, 0, 1782, 1783, 1,
        0, 0, 0, 1783, 1784, 1, 0, 0, 0, 1784, 1785, 5, 150, 0, 0, 1785, 285, 1, 0, 0, 0, 1786,
        1798, 5, 149, 0, 0, 1787, 1792, 3, 288, 144, 0, 1788, 1789, 5, 154, 0, 0, 1789, 1791, 3,
        288, 144, 0, 1790, 1788, 1, 0, 0, 0, 1791, 1794, 1, 0, 0, 0, 1792, 1790, 1, 0, 0, 0, 1792,
        1793, 1, 0, 0, 0, 1793, 1796, 1, 0, 0, 0, 1794, 1792, 1, 0, 0, 0, 1795, 1797, 5, 154, 0, 0,
        1796, 1795, 1, 0, 0, 0, 1796, 1797, 1, 0, 0, 0, 1797, 1799, 1, 0, 0, 0, 1798, 1787, 1, 0, 0,
        0, 1798, 1799, 1, 0, 0, 0, 1799, 1800, 1, 0, 0, 0, 1800, 1801, 5, 150, 0, 0, 1801, 287, 1,
        0, 0, 0, 1802, 1803, 5, 155, 0, 0, 1803, 1807, 3, 328, 164, 0, 1804, 1807, 3, 286, 143, 0,
        1805, 1807, 3, 284, 142, 0, 1806, 1802, 1, 0, 0, 0, 1806, 1804, 1, 0, 0, 0, 1806, 1805, 1,
        0, 0, 0, 1807, 289, 1, 0, 0, 0, 1808, 1813, 3, 336, 168, 0, 1809, 1810, 5, 154, 0, 0, 1810,
        1812, 3, 336, 168, 0, 1811, 1809, 1, 0, 0, 0, 1812, 1815, 1, 0, 0, 0, 1813, 1811, 1, 0, 0,
        0, 1813, 1814, 1, 0, 0, 0, 1814, 1817, 1, 0, 0, 0, 1815, 1813, 1, 0, 0, 0, 1816, 1818, 5,
        154, 0, 0, 1817, 1816, 1, 0, 0, 0, 1817, 1818, 1, 0, 0, 0, 1818, 291, 1, 0, 0, 0, 1819,
        1820, 5, 119, 0, 0, 1820, 1821, 5, 147, 0, 0, 1821, 1822, 3, 338, 169, 0, 1822, 1824, 5,
        154, 0, 0, 1823, 1825, 3, 356, 178, 0, 1824, 1823, 1, 0, 0, 0, 1825, 1826, 1, 0, 0, 0, 1826,
        1824, 1, 0, 0, 0, 1826, 1827, 1, 0, 0, 0, 1827, 1828, 1, 0, 0, 0, 1828, 1829, 5, 148, 0, 0,
        1829, 1830, 5, 153, 0, 0, 1830, 293, 1, 0, 0, 0, 1831, 1833, 3, 296, 148, 0, 1832, 1834, 5,
        153, 0, 0, 1833, 1832, 1, 0, 0, 0, 1833, 1834, 1, 0, 0, 0, 1834, 1870, 1, 0, 0, 0, 1835,
        1837, 3, 300, 150, 0, 1836, 1838, 5, 153, 0, 0, 1837, 1836, 1, 0, 0, 0, 1837, 1838, 1, 0, 0,
        0, 1838, 1870, 1, 0, 0, 0, 1839, 1841, 3, 302, 151, 0, 1840, 1842, 5, 153, 0, 0, 1841, 1840,
        1, 0, 0, 0, 1841, 1842, 1, 0, 0, 0, 1842, 1870, 1, 0, 0, 0, 1843, 1845, 3, 312, 156, 0,
        1844, 1846, 5, 153, 0, 0, 1845, 1844, 1, 0, 0, 0, 1845, 1846, 1, 0, 0, 0, 1846, 1870, 1, 0,
        0, 0, 1847, 1848, 3, 324, 162, 0, 1848, 1849, 5, 153, 0, 0, 1849, 1870, 1, 0, 0, 0, 1850,
        1852, 3, 126, 63, 0, 1851, 1853, 5, 153, 0, 0, 1852, 1851, 1, 0, 0, 0, 1852, 1853, 1, 0, 0,
        0, 1853, 1870, 1, 0, 0, 0, 1854, 1856, 3, 128, 64, 0, 1855, 1857, 5, 153, 0, 0, 1856, 1855,
        1, 0, 0, 0, 1856, 1857, 1, 0, 0, 0, 1857, 1870, 1, 0, 0, 0, 1858, 1859, 3, 120, 60, 0, 1859,
        1860, 5, 153, 0, 0, 1860, 1870, 1, 0, 0, 0, 1861, 1863, 3, 122, 61, 0, 1862, 1864, 5, 153,
        0, 0, 1863, 1862, 1, 0, 0, 0, 1863, 1864, 1, 0, 0, 0, 1864, 1870, 1, 0, 0, 0, 1865, 1866, 3,
        326, 163, 0, 1866, 1867, 5, 153, 0, 0, 1867, 1870, 1, 0, 0, 0, 1868, 1870, 5, 153, 0, 0,
        1869, 1831, 1, 0, 0, 0, 1869, 1835, 1, 0, 0, 0, 1869, 1839, 1, 0, 0, 0, 1869, 1843, 1, 0, 0,
        0, 1869, 1847, 1, 0, 0, 0, 1869, 1850, 1, 0, 0, 0, 1869, 1854, 1, 0, 0, 0, 1869, 1858, 1, 0,
        0, 0, 1869, 1861, 1, 0, 0, 0, 1869, 1865, 1, 0, 0, 0, 1869, 1868, 1, 0, 0, 0, 1870, 295, 1,
        0, 0, 0, 1871, 1872, 3, 358, 179, 0, 1872, 1873, 5, 164, 0, 0, 1873, 1874, 3, 294, 147, 0,
        1874, 297, 1, 0, 0, 0, 1875, 1878, 3, 328, 164, 0, 1876, 1877, 5, 191, 0, 0, 1877, 1879, 3,
        328, 164, 0, 1878, 1876, 1, 0, 0, 0, 1878, 1879, 1, 0, 0, 0, 1879, 299, 1, 0, 0, 0, 1880,
        1885, 5, 149, 0, 0, 1881, 1884, 3, 294, 147, 0, 1882, 1884, 3, 178, 89, 0, 1883, 1881, 1, 0,
        0, 0, 1883, 1882, 1, 0, 0, 0, 1884, 1887, 1, 0, 0, 0, 1885, 1883, 1, 0, 0, 0, 1885, 1886, 1,
        0, 0, 0, 1886, 1888, 1, 0, 0, 0, 1887, 1885, 1, 0, 0, 0, 1888, 1889, 5, 150, 0, 0, 1889,
        301, 1, 0, 0, 0, 1890, 1891, 5, 16, 0, 0, 1891, 1892, 5, 147, 0, 0, 1892, 1893, 3, 326, 163,
        0, 1893, 1894, 5, 148, 0, 0, 1894, 1897, 3, 294, 147, 0, 1895, 1896, 5, 10, 0, 0, 1896,
        1898, 3, 294, 147, 0, 1897, 1895, 1, 0, 0, 0, 1897, 1898, 1, 0, 0, 0, 1898, 1901, 1, 0, 0,
        0, 1899, 1901, 3, 304, 152, 0, 1900, 1890, 1, 0, 0, 0, 1900, 1899, 1, 0, 0, 0, 1901, 303, 1,
        0, 0, 0, 1902, 1903, 5, 28, 0, 0, 1903, 1904, 5, 147, 0, 0, 1904, 1905, 3, 328, 164, 0,
        1905, 1906, 5, 148, 0, 0, 1906, 1907, 3, 306, 153, 0, 1907, 305, 1, 0, 0, 0, 1908, 1912, 5,
        149, 0, 0, 1909, 1911, 3, 308, 154, 0, 1910, 1909, 1, 0, 0, 0, 1911, 1914, 1, 0, 0, 0, 1912,
        1910, 1, 0, 0, 0, 1912, 1913, 1, 0, 0, 0, 1913, 1915, 1, 0, 0, 0, 1914, 1912, 1, 0, 0, 0,
        1915, 1916, 5, 150, 0, 0, 1916, 307, 1, 0, 0, 0, 1917, 1919, 3, 310, 155, 0, 1918, 1917, 1,
        0, 0, 0, 1919, 1920, 1, 0, 0, 0, 1920, 1918, 1, 0, 0, 0, 1920, 1921, 1, 0, 0, 0, 1921, 1923,
        1, 0, 0, 0, 1922, 1924, 3, 294, 147, 0, 1923, 1922, 1, 0, 0, 0, 1924, 1925, 1, 0, 0, 0,
        1925, 1923, 1, 0, 0, 0, 1925, 1926, 1, 0, 0, 0, 1926, 309, 1, 0, 0, 0, 1927, 1933, 5, 3, 0,
        0, 1928, 1934, 3, 298, 149, 0, 1929, 1930, 5, 147, 0, 0, 1930, 1931, 3, 298, 149, 0, 1931,
        1932, 5, 148, 0, 0, 1932, 1934, 1, 0, 0, 0, 1933, 1928, 1, 0, 0, 0, 1933, 1929, 1, 0, 0, 0,
        1934, 1935, 1, 0, 0, 0, 1935, 1936, 5, 164, 0, 0, 1936, 1940, 1, 0, 0, 0, 1937, 1938, 5, 7,
        0, 0, 1938, 1940, 5, 164, 0, 0, 1939, 1927, 1, 0, 0, 0, 1939, 1937, 1, 0, 0, 0, 1940, 311,
        1, 0, 0, 0, 1941, 1946, 3, 314, 157, 0, 1942, 1946, 3, 316, 158, 0, 1943, 1946, 3, 318, 159,
        0, 1944, 1946, 3, 322, 161, 0, 1945, 1941, 1, 0, 0, 0, 1945, 1942, 1, 0, 0, 0, 1945, 1943,
        1, 0, 0, 0, 1945, 1944, 1, 0, 0, 0, 1946, 313, 1, 0, 0, 0, 1947, 1948, 5, 34, 0, 0, 1948,
        1949, 5, 147, 0, 0, 1949, 1950, 3, 328, 164, 0, 1950, 1951, 5, 148, 0, 0, 1951, 1952, 3,
        294, 147, 0, 1952, 315, 1, 0, 0, 0, 1953, 1954, 5, 8, 0, 0, 1954, 1955, 3, 294, 147, 0,
        1955, 1956, 5, 34, 0, 0, 1956, 1957, 5, 147, 0, 0, 1957, 1958, 3, 328, 164, 0, 1958, 1959,
        5, 148, 0, 0, 1959, 1960, 5, 153, 0, 0, 1960, 317, 1, 0, 0, 0, 1961, 1962, 5, 14, 0, 0,
        1962, 1964, 5, 147, 0, 0, 1963, 1965, 3, 320, 160, 0, 1964, 1963, 1, 0, 0, 0, 1964, 1965, 1,
        0, 0, 0, 1965, 1966, 1, 0, 0, 0, 1966, 1968, 5, 153, 0, 0, 1967, 1969, 3, 328, 164, 0, 1968,
        1967, 1, 0, 0, 0, 1968, 1969, 1, 0, 0, 0, 1969, 1970, 1, 0, 0, 0, 1970, 1972, 5, 153, 0, 0,
        1971, 1973, 3, 326, 163, 0, 1972, 1971, 1, 0, 0, 0, 1972, 1973, 1, 0, 0, 0, 1973, 1974, 1,
        0, 0, 0, 1974, 1975, 5, 148, 0, 0, 1975, 1976, 3, 294, 147, 0, 1976, 319, 1, 0, 0, 0, 1977,
        1978, 3, 174, 87, 0, 1978, 1979, 3, 180, 90, 0, 1979, 1982, 1, 0, 0, 0, 1980, 1982, 3, 326,
        163, 0, 1981, 1977, 1, 0, 0, 0, 1981, 1980, 1, 0, 0, 0, 1982, 321, 1, 0, 0, 0, 1983, 1984,
        5, 14, 0, 0, 1984, 1985, 5, 147, 0, 0, 1985, 1986, 3, 118, 59, 0, 1986, 1988, 5, 48, 0, 0,
        1987, 1989, 3, 328, 164, 0, 1988, 1987, 1, 0, 0, 0, 1988, 1989, 1, 0, 0, 0, 1989, 1990, 1,
        0, 0, 0, 1990, 1991, 5, 148, 0, 0, 1991, 1992, 3, 294, 147, 0, 1992, 323, 1, 0, 0, 0, 1993,
        1994, 5, 15, 0, 0, 1994, 2002, 3, 358, 179, 0, 1995, 2002, 5, 6, 0, 0, 1996, 2002, 5, 2, 0,
        0, 1997, 1999, 5, 22, 0, 0, 1998, 2000, 3, 328, 164, 0, 1999, 1998, 1, 0, 0, 0, 1999, 2000,
        1, 0, 0, 0, 2000, 2002, 1, 0, 0, 0, 2001, 1993, 1, 0, 0, 0, 2001, 1995, 1, 0, 0, 0, 2001,
        1996, 1, 0, 0, 0, 2001, 1997, 1, 0, 0, 0, 2002, 325, 1, 0, 0, 0, 2003, 2008, 3, 328, 164, 0,
        2004, 2005, 5, 154, 0, 0, 2005, 2007, 3, 328, 164, 0, 2006, 2004, 1, 0, 0, 0, 2007, 2010, 1,
        0, 0, 0, 2008, 2006, 1, 0, 0, 0, 2008, 2009, 1, 0, 0, 0, 2009, 327, 1, 0, 0, 0, 2010, 2008,
        1, 0, 0, 0, 2011, 2012, 6, 164, -1, 0, 2012, 2019, 3, 334, 167, 0, 2013, 2019, 3, 330, 165,
        0, 2014, 2015, 5, 147, 0, 0, 2015, 2016, 3, 300, 150, 0, 2016, 2017, 5, 148, 0, 0, 2017,
        2019, 1, 0, 0, 0, 2018, 2011, 1, 0, 0, 0, 2018, 2013, 1, 0, 0, 0, 2018, 2014, 1, 0, 0, 0,
        2019, 2064, 1, 0, 0, 0, 2020, 2021, 10, 13, 0, 0, 2021, 2022, 7, 16, 0, 0, 2022, 2063, 3,
        328, 164, 14, 2023, 2024, 10, 12, 0, 0, 2024, 2025, 7, 17, 0, 0, 2025, 2063, 3, 328, 164,
        13, 2026, 2031, 10, 11, 0, 0, 2027, 2028, 5, 160, 0, 0, 2028, 2032, 5, 160, 0, 0, 2029,
        2030, 5, 159, 0, 0, 2030, 2032, 5, 159, 0, 0, 2031, 2027, 1, 0, 0, 0, 2031, 2029, 1, 0, 0,
        0, 2032, 2033, 1, 0, 0, 0, 2033, 2063, 3, 328, 164, 12, 2034, 2035, 10, 10, 0, 0, 2035,
        2036, 7, 18, 0, 0, 2036, 2063, 3, 328, 164, 11, 2037, 2038, 10, 9, 0, 0, 2038, 2039, 7, 19,
        0, 0, 2039, 2063, 3, 328, 164, 10, 2040, 2041, 10, 8, 0, 0, 2041, 2042, 5, 177, 0, 0, 2042,
        2063, 3, 328, 164, 9, 2043, 2044, 10, 7, 0, 0, 2044, 2045, 5, 179, 0, 0, 2045, 2063, 3, 328,
        164, 8, 2046, 2047, 10, 6, 0, 0, 2047, 2048, 5, 178, 0, 0, 2048, 2063, 3, 328, 164, 7, 2049,
        2050, 10, 5, 0, 0, 2050, 2051, 5, 169, 0, 0, 2051, 2063, 3, 328, 164, 6, 2052, 2053, 10, 4,
        0, 0, 2053, 2054, 5, 170, 0, 0, 2054, 2063, 3, 328, 164, 5, 2055, 2056, 10, 3, 0, 0, 2056,
        2058, 5, 163, 0, 0, 2057, 2059, 3, 328, 164, 0, 2058, 2057, 1, 0, 0, 0, 2058, 2059, 1, 0, 0,
        0, 2059, 2060, 1, 0, 0, 0, 2060, 2061, 5, 164, 0, 0, 2061, 2063, 3, 328, 164, 4, 2062, 2020,
        1, 0, 0, 0, 2062, 2023, 1, 0, 0, 0, 2062, 2026, 1, 0, 0, 0, 2062, 2034, 1, 0, 0, 0, 2062,
        2037, 1, 0, 0, 0, 2062, 2040, 1, 0, 0, 0, 2062, 2043, 1, 0, 0, 0, 2062, 2046, 1, 0, 0, 0,
        2062, 2049, 1, 0, 0, 0, 2062, 2052, 1, 0, 0, 0, 2062, 2055, 1, 0, 0, 0, 2063, 2066, 1, 0, 0,
        0, 2064, 2062, 1, 0, 0, 0, 2064, 2065, 1, 0, 0, 0, 2065, 329, 1, 0, 0, 0, 2066, 2064, 1, 0,
        0, 0, 2067, 2068, 3, 340, 170, 0, 2068, 2069, 3, 332, 166, 0, 2069, 2070, 3, 328, 164, 0,
        2070, 331, 1, 0, 0, 0, 2071, 2072, 7, 20, 0, 0, 2072, 333, 1, 0, 0, 0, 2073, 2085, 3, 340,
        170, 0, 2074, 2076, 5, 111, 0, 0, 2075, 2074, 1, 0, 0, 0, 2075, 2076, 1, 0, 0, 0, 2076,
        2077, 1, 0, 0, 0, 2077, 2078, 5, 147, 0, 0, 2078, 2079, 3, 188, 94, 0, 2079, 2080, 5, 148,
        0, 0, 2080, 2081, 1, 0, 0, 0, 2081, 2082, 3, 334, 167, 0, 2082, 2085, 1, 0, 0, 0, 2083,
        2085, 5, 198, 0, 0, 2084, 2073, 1, 0, 0, 0, 2084, 2075, 1, 0, 0, 0, 2084, 2083, 1, 0, 0, 0,
        2085, 335, 1, 0, 0, 0, 2086, 2090, 3, 328, 164, 0, 2087, 2090, 3, 284, 142, 0, 2088, 2090,
        3, 286, 143, 0, 2089, 2086, 1, 0, 0, 0, 2089, 2087, 1, 0, 0, 0, 2089, 2088, 1, 0, 0, 0,
        2090, 337, 1, 0, 0, 0, 2091, 2094, 3, 358, 179, 0, 2092, 2094, 3, 354, 177, 0, 2093, 2091,
        1, 0, 0, 0, 2093, 2092, 1, 0, 0, 0, 2094, 339, 1, 0, 0, 0, 2095, 2110, 3, 344, 172, 0, 2096,
        2102, 5, 25, 0, 0, 2097, 2103, 3, 340, 170, 0, 2098, 2099, 5, 147, 0, 0, 2099, 2100, 3, 240,
        120, 0, 2100, 2101, 5, 148, 0, 0, 2101, 2103, 1, 0, 0, 0, 2102, 2097, 1, 0, 0, 0, 2102,
        2098, 1, 0, 0, 0, 2103, 2110, 1, 0, 0, 0, 2104, 2105, 7, 21, 0, 0, 2105, 2110, 3, 340, 170,
        0, 2106, 2107, 3, 342, 171, 0, 2107, 2108, 3, 334, 167, 0, 2108, 2110, 1, 0, 0, 0, 2109,
        2095, 1, 0, 0, 0, 2109, 2096, 1, 0, 0, 0, 2109, 2104, 1, 0, 0, 0, 2109, 2106, 1, 0, 0, 0,
        2110, 341, 1, 0, 0, 0, 2111, 2112, 7, 22, 0, 0, 2112, 343, 1, 0, 0, 0, 2113, 2114, 6, 172,
        -1, 0, 2114, 2118, 3, 352, 176, 0, 2115, 2117, 3, 346, 173, 0, 2116, 2115, 1, 0, 0, 0, 2117,
        2120, 1, 0, 0, 0, 2118, 2116, 1, 0, 0, 0, 2118, 2119, 1, 0, 0, 0, 2119, 2132, 1, 0, 0, 0,
        2120, 2118, 1, 0, 0, 0, 2121, 2122, 10, 1, 0, 0, 2122, 2123, 7, 23, 0, 0, 2123, 2127, 3,
        358, 179, 0, 2124, 2126, 3, 346, 173, 0, 2125, 2124, 1, 0, 0, 0, 2126, 2129, 1, 0, 0, 0,
        2127, 2125, 1, 0, 0, 0, 2127, 2128, 1, 0, 0, 0, 2128, 2131, 1, 0, 0, 0, 2129, 2127, 1, 0, 0,
        0, 2130, 2121, 1, 0, 0, 0, 2131, 2134, 1, 0, 0, 0, 2132, 2130, 1, 0, 0, 0, 2132, 2133, 1, 0,
        0, 0, 2133, 345, 1, 0, 0, 0, 2134, 2132, 1, 0, 0, 0, 2135, 2136, 5, 151, 0, 0, 2136, 2137,
        3, 328, 164, 0, 2137, 2138, 5, 152, 0, 0, 2138, 2146, 1, 0, 0, 0, 2139, 2141, 5, 147, 0, 0,
        2140, 2142, 3, 348, 174, 0, 2141, 2140, 1, 0, 0, 0, 2141, 2142, 1, 0, 0, 0, 2142, 2143, 1,
        0, 0, 0, 2143, 2146, 5, 148, 0, 0, 2144, 2146, 7, 21, 0, 0, 2145, 2135, 1, 0, 0, 0, 2145,
        2139, 1, 0, 0, 0, 2145, 2144, 1, 0, 0, 0, 2146, 347, 1, 0, 0, 0, 2147, 2152, 3, 350, 175, 0,
        2148, 2149, 5, 154, 0, 0, 2149, 2151, 3, 350, 175, 0, 2150, 2148, 1, 0, 0, 0, 2151, 2154, 1,
        0, 0, 0, 2152, 2150, 1, 0, 0, 0, 2152, 2153, 1, 0, 0, 0, 2153, 349, 1, 0, 0, 0, 2154, 2152,
        1, 0, 0, 0, 2155, 2158, 3, 328, 164, 0, 2156, 2158, 3, 244, 122, 0, 2157, 2155, 1, 0, 0, 0,
        2157, 2156, 1, 0, 0, 0, 2158, 351, 1, 0, 0, 0, 2159, 2175, 3, 358, 179, 0, 2160, 2175, 3,
        354, 177, 0, 2161, 2175, 3, 356, 178, 0, 2162, 2163, 5, 147, 0, 0, 2163, 2164, 3, 328, 164,
        0, 2164, 2165, 5, 148, 0, 0, 2165, 2175, 1, 0, 0, 0, 2166, 2175, 3, 100, 50, 0, 2167, 2175,
        3, 110, 55, 0, 2168, 2175, 3, 114, 57, 0, 2169, 2175, 3, 116, 58, 0, 2170, 2175, 3, 84, 42,
        0, 2171, 2175, 3, 88, 44, 0, 2172, 2175, 3, 90, 45, 0, 2173, 2175, 3, 98, 49, 0, 2174, 2159,
        1, 0, 0, 0, 2174, 2160, 1, 0, 0, 0, 2174, 2161, 1, 0, 0, 0, 2174, 2162, 1, 0, 0, 0, 2174,
        2166, 1, 0, 0, 0, 2174, 2167, 1, 0, 0, 0, 2174, 2168, 1, 0, 0, 0, 2174, 2169, 1, 0, 0, 0,
        2174, 2170, 1, 0, 0, 0, 2174, 2171, 1, 0, 0, 0, 2174, 2172, 1, 0, 0, 0, 2174, 2173, 1, 0, 0,
        0, 2175, 353, 1, 0, 0, 0, 2176, 2195, 5, 194, 0, 0, 2177, 2195, 5, 195, 0, 0, 2178, 2195, 5,
        196, 0, 0, 2179, 2181, 7, 17, 0, 0, 2180, 2179, 1, 0, 0, 0, 2180, 2181, 1, 0, 0, 0, 2181,
        2182, 1, 0, 0, 0, 2182, 2195, 5, 197, 0, 0, 2183, 2185, 7, 17, 0, 0, 2184, 2183, 1, 0, 0, 0,
        2184, 2185, 1, 0, 0, 0, 2185, 2186, 1, 0, 0, 0, 2186, 2195, 5, 199, 0, 0, 2187, 2195, 5,
        192, 0, 0, 2188, 2195, 5, 50, 0, 0, 2189, 2195, 5, 52, 0, 0, 2190, 2195, 5, 59, 0, 0, 2191,
        2195, 5, 51, 0, 0, 2192, 2195, 5, 39, 0, 0, 2193, 2195, 5, 40, 0, 0, 2194, 2176, 1, 0, 0, 0,
        2194, 2177, 1, 0, 0, 0, 2194, 2178, 1, 0, 0, 0, 2194, 2180, 1, 0, 0, 0, 2194, 2184, 1, 0, 0,
        0, 2194, 2187, 1, 0, 0, 0, 2194, 2188, 1, 0, 0, 0, 2194, 2189, 1, 0, 0, 0, 2194, 2190, 1, 0,
        0, 0, 2194, 2191, 1, 0, 0, 0, 2194, 2192, 1, 0, 0, 0, 2194, 2193, 1, 0, 0, 0, 2195, 355, 1,
        0, 0, 0, 2196, 2200, 5, 193, 0, 0, 2197, 2199, 7, 24, 0, 0, 2198, 2197, 1, 0, 0, 0, 2199,
        2202, 1, 0, 0, 0, 2200, 2198, 1, 0, 0, 0, 2200, 2201, 1, 0, 0, 0, 2201, 2203, 1, 0, 0, 0,
        2202, 2200, 1, 0, 0, 0, 2203, 2205, 5, 206, 0, 0, 2204, 2196, 1, 0, 0, 0, 2205, 2206, 1, 0,
        0, 0, 2206, 2204, 1, 0, 0, 0, 2206, 2207, 1, 0, 0, 0, 2207, 357, 1, 0, 0, 0, 2208, 2209, 7,
        25, 0, 0, 2209, 359, 1, 0, 0, 0, 292, 363, 378, 385, 390, 393, 401, 403, 409, 415, 422, 425,
        428, 435, 438, 446, 448, 454, 458, 468, 481, 484, 491, 496, 504, 509, 518, 524, 526, 538,
        548, 556, 559, 562, 571, 593, 600, 603, 609, 618, 624, 626, 635, 637, 646, 652, 656, 665,
        667, 676, 680, 683, 686, 690, 696, 700, 702, 705, 711, 715, 725, 739, 746, 752, 755, 759,
        765, 769, 778, 782, 784, 796, 798, 810, 812, 818, 824, 827, 830, 834, 838, 841, 844, 850,
        861, 867, 869, 872, 880, 885, 891, 900, 905, 907, 929, 936, 941, 965, 969, 974, 978, 982,
        986, 995, 1002, 1009, 1015, 1020, 1027, 1034, 1039, 1042, 1045, 1048, 1052, 1060, 1063,
        1067, 1075, 1080, 1087, 1090, 1095, 1101, 1108, 1119, 1121, 1131, 1141, 1144, 1149, 1152,
        1157, 1161, 1166, 1173, 1179, 1182, 1188, 1200, 1203, 1219, 1224, 1227, 1234, 1249, 1256,
        1259, 1261, 1266, 1270, 1274, 1280, 1284, 1289, 1291, 1295, 1301, 1304, 1313, 1318, 1321,
        1327, 1343, 1349, 1355, 1359, 1364, 1367, 1374, 1393, 1399, 1402, 1404, 1409, 1414, 1417,
        1422, 1429, 1437, 1445, 1447, 1452, 1459, 1464, 1476, 1491, 1496, 1502, 1506, 1511, 1518,
        1526, 1541, 1550, 1556, 1564, 1568, 1572, 1576, 1580, 1584, 1586, 1603, 1616, 1619, 1624,
        1640, 1645, 1649, 1653, 1657, 1664, 1670, 1682, 1689, 1693, 1698, 1709, 1714, 1724, 1728,
        1732, 1738, 1741, 1745, 1748, 1753, 1757, 1763, 1765, 1768, 1776, 1780, 1782, 1792, 1796,
        1798, 1806, 1813, 1817, 1826, 1833, 1837, 1841, 1845, 1852, 1856, 1863, 1869, 1878, 1883,
        1885, 1897, 1900, 1912, 1920, 1925, 1933, 1939, 1945, 1964, 1968, 1972, 1981, 1988, 1999,
        2001, 2008, 2018, 2031, 2058, 2062, 2064, 2075, 2084, 2089, 2093, 2102, 2109, 2118, 2127,
        2132, 2141, 2145, 2152, 2157, 2174, 2180, 2184, 2194, 2200, 2206,
    ]
}
