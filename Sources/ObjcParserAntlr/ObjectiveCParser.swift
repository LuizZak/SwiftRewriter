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
        RULE_categoryInterface = 5, RULE_classImplementation = 6, RULE_classImplementationName = 7,
        RULE_categoryImplementation = 8, RULE_className = 9, RULE_superclassName = 10,
        RULE_genericSuperclassName = 11, RULE_genericClassParametersSpecifier = 12,
        RULE_superclassTypeSpecifierWithPrefixes = 13, RULE_protocolDeclaration = 14,
        RULE_protocolDeclarationSection = 15, RULE_protocolDeclarationList = 16,
        RULE_classDeclarationList = 17, RULE_classDeclaration = 18, RULE_protocolList = 19,
        RULE_propertyDeclaration = 20, RULE_propertyAttributesList = 21,
        RULE_propertyAttribute = 22, RULE_protocolName = 23, RULE_instanceVariables = 24,
        RULE_visibilitySection = 25, RULE_accessModifier = 26, RULE_interfaceDeclarationList = 27,
        RULE_classMethodDeclaration = 28, RULE_instanceMethodDeclaration = 29,
        RULE_methodDeclaration = 30, RULE_implementationDefinitionList = 31,
        RULE_classMethodDefinition = 32, RULE_instanceMethodDefinition = 33,
        RULE_methodDefinition = 34, RULE_methodSelector = 35, RULE_keywordDeclarator = 36,
        RULE_selector = 37, RULE_methodType = 38, RULE_propertyImplementation = 39,
        RULE_propertySynthesizeList = 40, RULE_propertySynthesizeItem = 41,
        RULE_dictionaryExpression = 42, RULE_dictionaryPair = 43, RULE_arrayExpression = 44,
        RULE_boxExpression = 45, RULE_blockParameters = 46, RULE_blockExpression = 47,
        RULE_messageExpression = 48, RULE_receiver = 49, RULE_messageSelector = 50,
        RULE_keywordArgument = 51, RULE_keywordArgumentType = 52, RULE_selectorExpression = 53,
        RULE_selectorName = 54, RULE_protocolExpression = 55, RULE_encodeExpression = 56,
        RULE_typeVariableDeclarator = 57, RULE_throwStatement = 58, RULE_tryBlock = 59,
        RULE_catchStatement = 60, RULE_synchronizedStatement = 61, RULE_autoreleaseStatement = 62,
        RULE_functionDeclaration = 63, RULE_functionDefinition = 64, RULE_functionSignature = 65,
        RULE_declarationList = 66, RULE_attribute = 67, RULE_attributeName = 68,
        RULE_attributeParameters = 69, RULE_attributeParameterList = 70,
        RULE_attributeParameter = 71, RULE_attributeParameterAssignment = 72,
        RULE_functionPointer = 73, RULE_functionPointerParameterList = 74,
        RULE_functionPointerParameterDeclarationList = 75,
        RULE_functionPointerParameterDeclaration = 76, RULE_functionCallExpression = 77,
        RULE_enumDeclaration = 78, RULE_varDeclaration_ = 79, RULE_typedefDeclaration_ = 80,
        RULE_typeDeclaratorList = 81, RULE_declarationSpecifiers_ = 82,
        RULE_declarationSpecifier__ = 83, RULE_declarationSpecifier = 84,
        RULE_declarationSpecifiers = 85, RULE_declaration = 86, RULE_initDeclaratorList = 87,
        RULE_initDeclarator = 88, RULE_declarator = 89, RULE_directDeclarator = 90,
        RULE_blockDeclarationSpecifier = 91, RULE_typeName = 92, RULE_abstractDeclarator_ = 93,
        RULE_abstractDeclarator = 94, RULE_directAbstractDeclarator = 95,
        RULE_abstractDeclaratorSuffix_ = 96, RULE_parameterTypeList = 97, RULE_parameterList = 98,
        RULE_parameterDeclarationList_ = 99, RULE_parameterDeclaration = 100,
        RULE_typeQualifierList = 101, RULE_identifierList = 102, RULE_declaratorSuffix = 103,
        RULE_attributeSpecifier = 104, RULE_atomicTypeSpecifier = 105, RULE_fieldDeclaration = 106,
        RULE_structOrUnionSpecifier = 107, RULE_structOrUnion = 108,
        RULE_structDeclarationList = 109, RULE_structDeclaration = 110,
        RULE_specifierQualifierList = 111, RULE_enumSpecifier = 112, RULE_enumeratorList = 113,
        RULE_enumerator = 114, RULE_enumeratorIdentifier = 115, RULE_ibOutletQualifier = 116,
        RULE_arcBehaviourSpecifier = 117, RULE_nullabilitySpecifier = 118,
        RULE_storageClassSpecifier = 119, RULE_typePrefix = 120, RULE_typeQualifier = 121,
        RULE_functionSpecifier = 122, RULE_alignmentSpecifier = 123, RULE_protocolQualifier = 124,
        RULE_typeSpecifier_ = 125, RULE_typeSpecifier = 126, RULE_typeofTypeSpecifier = 127,
        RULE_typedefName = 128, RULE_genericTypeSpecifier = 129, RULE_genericTypeList = 130,
        RULE_genericTypeParameter = 131, RULE_scalarTypeSpecifier = 132,
        RULE_fieldDeclaratorList = 133, RULE_fieldDeclarator = 134, RULE_vcSpecificModifier = 135,
        RULE_gccDeclaratorExtension = 136, RULE_gccAttributeSpecifier = 137,
        RULE_gccAttributeList = 138, RULE_gccAttribute = 139, RULE_pointer_ = 140,
        RULE_pointer = 141, RULE_pointerEntry = 142, RULE_macro = 143, RULE_arrayInitializer = 144,
        RULE_structInitializer = 145, RULE_structInitializerItem = 146, RULE_initializerList = 147,
        RULE_staticAssertDeclaration = 148, RULE_statement = 149, RULE_labeledStatement = 150,
        RULE_rangeExpression = 151, RULE_compoundStatement = 152, RULE_selectionStatement = 153,
        RULE_switchStatement = 154, RULE_switchBlock = 155, RULE_switchSection = 156,
        RULE_switchLabel = 157, RULE_iterationStatement = 158, RULE_whileStatement = 159,
        RULE_doStatement = 160, RULE_forStatement = 161, RULE_forLoopInitializer = 162,
        RULE_forInStatement = 163, RULE_jumpStatement = 164, RULE_expressions = 165,
        RULE_expression = 166, RULE_assignmentExpression = 167, RULE_assignmentOperator = 168,
        RULE_castExpression = 169, RULE_initializer = 170, RULE_constantExpression = 171,
        RULE_unaryExpression = 172, RULE_unaryOperator = 173, RULE_postfixExpression = 174,
        RULE_postfixExpr = 175, RULE_argumentExpressionList = 176, RULE_argumentExpression = 177,
        RULE_primaryExpression = 178, RULE_constant = 179, RULE_stringLiteral = 180,
        RULE_identifier = 181

    public static let ruleNames: [String] = [
        "translationUnit", "topLevelDeclaration", "importDeclaration", "classInterface",
        "classInterfaceName", "categoryInterface", "classImplementation", "classImplementationName",
        "categoryImplementation", "className", "superclassName", "genericSuperclassName",
        "genericClassParametersSpecifier", "superclassTypeSpecifierWithPrefixes",
        "protocolDeclaration", "protocolDeclarationSection", "protocolDeclarationList",
        "classDeclarationList", "classDeclaration", "protocolList", "propertyDeclaration",
        "propertyAttributesList", "propertyAttribute", "protocolName", "instanceVariables",
        "visibilitySection", "accessModifier", "interfaceDeclarationList", "classMethodDeclaration",
        "instanceMethodDeclaration", "methodDeclaration", "implementationDefinitionList",
        "classMethodDefinition", "instanceMethodDefinition", "methodDefinition", "methodSelector",
        "keywordDeclarator", "selector", "methodType", "propertyImplementation",
        "propertySynthesizeList", "propertySynthesizeItem", "dictionaryExpression",
        "dictionaryPair", "arrayExpression", "boxExpression", "blockParameters", "blockExpression",
        "messageExpression", "receiver", "messageSelector", "keywordArgument",
        "keywordArgumentType", "selectorExpression", "selectorName", "protocolExpression",
        "encodeExpression", "typeVariableDeclarator", "throwStatement", "tryBlock",
        "catchStatement", "synchronizedStatement", "autoreleaseStatement", "functionDeclaration",
        "functionDefinition", "functionSignature", "declarationList", "attribute", "attributeName",
        "attributeParameters", "attributeParameterList", "attributeParameter",
        "attributeParameterAssignment", "functionPointer", "functionPointerParameterList",
        "functionPointerParameterDeclarationList", "functionPointerParameterDeclaration",
        "functionCallExpression", "enumDeclaration", "varDeclaration_", "typedefDeclaration_",
        "typeDeclaratorList", "declarationSpecifiers_", "declarationSpecifier__",
        "declarationSpecifier", "declarationSpecifiers", "declaration", "initDeclaratorList",
        "initDeclarator", "declarator", "directDeclarator", "blockDeclarationSpecifier", "typeName",
        "abstractDeclarator_", "abstractDeclarator", "directAbstractDeclarator",
        "abstractDeclaratorSuffix_", "parameterTypeList", "parameterList",
        "parameterDeclarationList_", "parameterDeclaration", "typeQualifierList", "identifierList",
        "declaratorSuffix", "attributeSpecifier", "atomicTypeSpecifier", "fieldDeclaration",
        "structOrUnionSpecifier", "structOrUnion", "structDeclarationList", "structDeclaration",
        "specifierQualifierList", "enumSpecifier", "enumeratorList", "enumerator",
        "enumeratorIdentifier", "ibOutletQualifier", "arcBehaviourSpecifier",
        "nullabilitySpecifier", "storageClassSpecifier", "typePrefix", "typeQualifier",
        "functionSpecifier", "alignmentSpecifier", "protocolQualifier", "typeSpecifier_",
        "typeSpecifier", "typeofTypeSpecifier", "typedefName", "genericTypeSpecifier",
        "genericTypeList", "genericTypeParameter", "scalarTypeSpecifier", "fieldDeclaratorList",
        "fieldDeclarator", "vcSpecificModifier", "gccDeclaratorExtension", "gccAttributeSpecifier",
        "gccAttributeList", "gccAttribute", "pointer_", "pointer", "pointerEntry", "macro",
        "arrayInitializer", "structInitializer", "structInitializerItem", "initializerList",
        "staticAssertDeclaration", "statement", "labeledStatement", "rangeExpression",
        "compoundStatement", "selectionStatement", "switchStatement", "switchBlock",
        "switchSection", "switchLabel", "iterationStatement", "whileStatement", "doStatement",
        "forStatement", "forLoopInitializer", "forInStatement", "jumpStatement", "expressions",
        "expression", "assignmentExpression", "assignmentOperator", "castExpression", "initializer",
        "constantExpression", "unaryExpression", "unaryOperator", "postfixExpression",
        "postfixExpr", "argumentExpressionList", "argumentExpression", "primaryExpression",
        "constant", "stringLiteral", "identifier",
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
        nil, nil, nil, nil, "'NS_INLINE'", "'NS_ENUM'", "'NS_OPTIONS'", "'assign'", "'copy'",
        "'getter'", "'setter'", "'strong'", "'readonly'", "'readwrite'", "'weak'",
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
            setState(367)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 5_180_263_529_751_394_866) != 0
                || (Int64((_la - 67)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 67)) & -45_097_222_121) != 0
                || (Int64((_la - 131)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 131)) & 17_592_186_143_207) != 0
            {
                setState(364)
                try topLevelDeclaration()

                setState(369)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(370)
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
            setState(382)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(372)
                try importDeclaration()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(373)
                try declaration()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(374)
                try classInterface()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(375)
                try classImplementation()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(376)
                try categoryInterface()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(377)
                try categoryImplementation()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(378)
                try protocolDeclaration()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(379)
                try protocolDeclarationList()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(380)
                try classDeclarationList()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(381)
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
            setState(384)
            try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
            setState(385)
            try identifier()
            setState(386)
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
            setState(389)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue {
                setState(388)
                try match(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue)

            }

            setState(391)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(392)
            try classInterfaceName()
            setState(394)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(393)
                try instanceVariables()

            }

            setState(397)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -3_458_764_514_172_862_975) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(396)
                try interfaceDeclarationList()

            }

            setState(399)
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
        open func genericClassParametersSpecifier() -> GenericClassParametersSpecifierContext? {
            return getRuleContext(GenericClassParametersSpecifierContext.self, 0)
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
            setState(401)
            try className()
            setState(407)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(402)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(403)
                try superclassName()
                setState(405)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 5, _ctx) {
                case 1:
                    setState(404)
                    try genericClassParametersSpecifier()

                    break
                default: break
                }

            }

            setState(413)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(409)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(410)
                try protocolList()
                setState(411)
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
            setState(415)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(416)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryInterfaceContext.self).categoryName = assignmentValue
            }()

            setState(417)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(419)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(418)
                try identifier()

            }

            setState(421)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(426)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(422)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(423)
                try protocolList()
                setState(424)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(429)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(428)
                try instanceVariables()

            }

            setState(432)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -3_458_764_514_172_862_975) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(431)
                try interfaceDeclarationList()

            }

            setState(434)
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
        open func classImplementationName() -> ClassImplementationNameContext? {
            return getRuleContext(ClassImplementationNameContext.self, 0)
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
            setState(436)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(437)
            try classImplementationName()
            setState(439)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(438)
                try instanceVariables()

            }

            setState(442)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_072_895_993) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(441)
                try implementationDefinitionList()

            }

            setState(444)
            try match(ObjectiveCParser.Tokens.END.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassImplementationNameContext: ParserRuleContext {
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func superclassName() -> SuperclassNameContext? {
            return getRuleContext(SuperclassNameContext.self, 0)
        }
        open func genericClassParametersSpecifier() -> GenericClassParametersSpecifierContext? {
            return getRuleContext(GenericClassParametersSpecifierContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_classImplementationName
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassImplementationName(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassImplementationName(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassImplementationName(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassImplementationName(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classImplementationName() throws -> ClassImplementationNameContext
    {
        var _localctx: ClassImplementationNameContext
        _localctx = ClassImplementationNameContext(_ctx, getState())
        try enterRule(_localctx, 14, ObjectiveCParser.RULE_classImplementationName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(446)
            try className()
            setState(452)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(447)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(448)
                try superclassName()
                setState(450)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
                    setState(449)
                    try genericClassParametersSpecifier()

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
            setState(454)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(455)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryImplementationContext.self).categoryName =
                    assignmentValue
            }()

            setState(456)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(458)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(457)
                try identifier()

            }

            setState(460)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(462)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_072_895_993) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(461)
                try implementationDefinitionList()

            }

            setState(464)
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
        open func genericClassParametersSpecifier() -> GenericClassParametersSpecifierContext? {
            return getRuleContext(GenericClassParametersSpecifierContext.self, 0)
        }
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
            setState(466)
            try identifier()
            setState(468)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 18, _ctx) {
            case 1:
                setState(467)
                try genericClassParametersSpecifier()

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
        open func genericClassParametersSpecifier() -> GenericClassParametersSpecifierContext? {
            return getRuleContext(GenericClassParametersSpecifierContext.self, 0)
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
            try genericClassParametersSpecifier()

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class GenericClassParametersSpecifierContext: ParserRuleContext {
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
            return ObjectiveCParser.RULE_genericClassParametersSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterGenericClassParametersSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitGenericClassParametersSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitGenericClassParametersSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitGenericClassParametersSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func genericClassParametersSpecifier() throws
        -> GenericClassParametersSpecifierContext
    {
        var _localctx: GenericClassParametersSpecifierContext
        _localctx = GenericClassParametersSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 24, ObjectiveCParser.RULE_genericClassParametersSpecifier)
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
                    && ((Int64(1) << (_la - 83)) & -9_113_036_036_685_930_521) != 0
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
        open func pointer() -> PointerContext? { return getRuleContext(PointerContext.self, 0) }
        open func typePrefix() -> [TypePrefixContext] {
            return getRuleContexts(TypePrefixContext.self)
        }
        open func typePrefix(_ i: Int) -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, i)
        }
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
            setState(495)
            try pointer()

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
            setState(497)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(498)
            try protocolName()
            setState(503)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(499)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(500)
                try protocolList()
                setState(501)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(508)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & 4_611_686_017_018_099_749) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 962_072_677_391) != 0
            {
                setState(505)
                try protocolDeclarationSection()

                setState(510)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(511)
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
            setState(525)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .OPTIONAL, .REQUIRED:
                try enterOuterAlt(_localctx, 1)
                setState(513)
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
                setState(517)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 24, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(514)
                        try interfaceDeclarationList()

                    }
                    setState(519)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 24, _ctx)
                }

                break
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .PROPERTY, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE,
                .AUTORELEASING_QUALIFIER, .BLOCK, .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER,
                .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF,
                .UNSAFE_UNRETAINED_QUALIFIER, .WEAK_QUALIFIER, .CDECL, .CLRCALL, .STDCALL,
                .DECLSPEC, .FASTCALL, .THISCALL, .VECTORCALL, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .STATIC_ASSERT_,
                .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM,
                .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER,
                .LP, .ADD, .SUB, .MUL:
                try enterOuterAlt(_localctx, 2)
                setState(521)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(520)
                        try interfaceDeclarationList()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(523)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 25, _ctx)
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
            setState(527)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(528)
            try protocolList()
            setState(529)
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
        open func classDeclaration() -> [ClassDeclarationContext] {
            return getRuleContexts(ClassDeclarationContext.self)
        }
        open func classDeclaration(_ i: Int) -> ClassDeclarationContext? {
            return getRuleContext(ClassDeclarationContext.self, i)
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
            setState(531)
            try match(ObjectiveCParser.Tokens.CLASS.rawValue)
            setState(532)
            try classDeclaration()
            setState(537)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(533)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(534)
                try classDeclaration()

                setState(539)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(540)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class ClassDeclarationContext: ParserRuleContext {
        open func className() -> ClassNameContext? {
            return getRuleContext(ClassNameContext.self, 0)
        }
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func protocolList() -> ProtocolListContext? {
            return getRuleContext(ProtocolListContext.self, 0)
        }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_classDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterClassDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitClassDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitClassDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitClassDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func classDeclaration() throws -> ClassDeclarationContext {
        var _localctx: ClassDeclarationContext
        _localctx = ClassDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 36, ObjectiveCParser.RULE_classDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(542)
            try className()
            setState(547)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(543)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(544)
                try protocolList()
                setState(545)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

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
            setState(549)
            try protocolName()
            setState(554)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(550)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(551)
                try protocolName()

                setState(556)
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
            setState(557)
            try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
            setState(562)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(558)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(559)
                try propertyAttributesList()
                setState(560)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

            setState(565)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 31, _ctx) {
            case 1:
                setState(564)
                try ibOutletQualifier()

                break
            default: break
            }
            setState(568)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 32, _ctx) {
            case 1:
                setState(567)
                try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

                break
            default: break
            }
            setState(570)
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
            setState(572)
            try propertyAttribute()
            setState(577)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(573)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(574)
                try propertyAttribute()

                setState(579)
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
        open func WEAK() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.WEAK.rawValue, 0)
        }
        open func UNSAFE_UNRETAINED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue, 0)
        }
        open func COPY() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COPY.rawValue, 0)
        }
        open func GETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.GETTER.rawValue, 0)
        }
        open func ASSIGNMENT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue, 0)
        }
        open func selectorName() -> SelectorNameContext? {
            return getRuleContext(SelectorNameContext.self, 0)
        }
        open func SETTER() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SETTER.rawValue, 0)
        }
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
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
            setState(591)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 34, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(580)
                try match(ObjectiveCParser.Tokens.WEAK.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(581)
                try match(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(582)
                try match(ObjectiveCParser.Tokens.COPY.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(583)
                try match(ObjectiveCParser.Tokens.GETTER.rawValue)
                setState(584)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(585)
                try selectorName()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(586)
                try match(ObjectiveCParser.Tokens.SETTER.rawValue)
                setState(587)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(588)
                try selectorName()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(589)
                try nullabilitySpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(590)
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
            setState(601)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LT:
                try enterOuterAlt(_localctx, 1)
                setState(593)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(594)
                try protocolList()
                setState(595)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(598)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 35, _ctx) {
                case 1:
                    setState(597)
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
                setState(600)
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
            setState(603)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(607)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 70)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 70)) & -563_943_433_052_055) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0 && ((Int64(1) << (_la - 136)) & 1039) != 0
            {
                setState(604)
                try visibilitySection()

                setState(609)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(610)
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
            setState(624)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .PACKAGE, .PRIVATE, .PROTECTED, .PUBLIC:
                try enterOuterAlt(_localctx, 1)
                setState(612)
                try accessModifier()
                setState(616)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 38, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(613)
                        try fieldDeclaration()

                    }
                    setState(618)
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
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF, .UNSAFE_UNRETAINED_QUALIFIER,
                .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D, .M128I,
                .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED, .NULLABLE,
                .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(620)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(619)
                        try fieldDeclaration()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(622)
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
        try enterRule(_localctx, 52, ObjectiveCParser.RULE_accessModifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(626)
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
        try enterRule(_localctx, 54, ObjectiveCParser.RULE_interfaceDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(633)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(633)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 41, _ctx) {
                    case 1:
                        setState(628)
                        try declaration()

                        break
                    case 2:
                        setState(629)
                        try classMethodDeclaration()

                        break
                    case 3:
                        setState(630)
                        try instanceMethodDeclaration()

                        break
                    case 4:
                        setState(631)
                        try propertyDeclaration()

                        break
                    case 5:
                        setState(632)
                        try functionDeclaration()

                        break
                    default: break
                    }

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(635)
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
        try enterRule(_localctx, 56, ObjectiveCParser.RULE_classMethodDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(637)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(638)
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
            setState(640)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(641)
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
            setState(644)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(643)
                try methodType()

            }

            setState(646)
            try methodSelector()
            setState(650)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(647)
                try attributeSpecifier()

                setState(652)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(654)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(653)
                try macro()

            }

            setState(656)
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
            setState(663)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(663)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 46, _ctx) {
                case 1:
                    setState(658)
                    try functionDefinition()

                    break
                case 2:
                    setState(659)
                    try declaration()

                    break
                case 3:
                    setState(660)
                    try classMethodDefinition()

                    break
                case 4:
                    setState(661)
                    try instanceMethodDefinition()

                    break
                case 5:
                    setState(662)
                    try propertyImplementation()

                    break
                default: break
                }

                setState(665)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_072_895_993) != 0
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
        try enterRule(_localctx, 64, ObjectiveCParser.RULE_classMethodDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(667)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(668)
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
            setState(670)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(671)
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
            setState(674)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(673)
                try methodType()

            }

            setState(676)
            try methodSelector()
            setState(678)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
                || _la == ObjectiveCParser.Tokens.MUL.rawValue
            {
                setState(677)
                try initDeclaratorList()

            }

            setState(681)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(680)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

            setState(684)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(683)
                try attributeSpecifier()

            }

            setState(686)
            try compoundStatement()
            setState(688)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(687)
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
            setState(700)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 55, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(690)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(692)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(691)
                        try keywordDeclarator()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(694)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 53, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER
                setState(698)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(696)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(697)
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
            setState(703)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(702)
                try selector()

            }

            setState(705)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(709)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(706)
                try methodType()

                setState(711)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(713)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 87)) & ~0x3f) == 0 && ((Int64(1) << (_la - 87)) & 20993) != 0 {
                setState(712)
                try arcBehaviourSpecifier()

            }

            setState(715)
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
            setState(723)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(717)
                try identifier()

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 2)
                setState(718)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)

                break

            case .SWITCH:
                try enterOuterAlt(_localctx, 3)
                setState(719)
                try match(ObjectiveCParser.Tokens.SWITCH.rawValue)

                break

            case .IF:
                try enterOuterAlt(_localctx, 4)
                setState(720)
                try match(ObjectiveCParser.Tokens.IF.rawValue)

                break

            case .ELSE:
                try enterOuterAlt(_localctx, 5)
                setState(721)
                try match(ObjectiveCParser.Tokens.ELSE.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 6)
                setState(722)
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
            setState(725)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(726)
            try typeName()
            setState(727)
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
            setState(737)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .SYNTHESIZE:
                try enterOuterAlt(_localctx, 1)
                setState(729)
                try match(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue)
                setState(730)
                try propertySynthesizeList()
                setState(731)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .DYNAMIC:
                try enterOuterAlt(_localctx, 2)
                setState(733)
                try match(ObjectiveCParser.Tokens.DYNAMIC.rawValue)
                setState(734)
                try propertySynthesizeList()
                setState(735)
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
            setState(739)
            try propertySynthesizeItem()
            setState(744)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(740)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(741)
                try propertySynthesizeItem()

                setState(746)
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
            setState(747)
            try identifier()
            setState(750)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(748)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(749)
                try identifier()

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
            setState(752)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(753)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(765)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(754)
                try dictionaryPair()
                setState(759)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(755)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(756)
                        try dictionaryPair()

                    }
                    setState(761)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
                }
                setState(763)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(762)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(767)
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
            setState(769)
            try castExpression()
            setState(770)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(771)
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
            setState(773)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(774)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(779)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(775)
                try expressions()
                setState(777)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(776)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(781)
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
            setState(793)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 69, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(783)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(784)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(785)
                try expression(0)
                setState(786)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(788)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(791)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                    .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                    .FLOATING_POINT_LITERAL:
                    setState(789)
                    try constant()

                    break
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                    .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
                    setState(790)
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
        open func parameterDeclaration() -> [ParameterDeclarationContext] {
            return getRuleContexts(ParameterDeclarationContext.self)
        }
        open func parameterDeclaration(_ i: Int) -> ParameterDeclarationContext? {
            return getRuleContext(ParameterDeclarationContext.self, i)
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
        try enterRule(_localctx, 92, ObjectiveCParser.RULE_blockParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(795)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(807)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
            {
                setState(798)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 70, _ctx) {
                case 1:
                    setState(796)
                    try parameterDeclaration()

                    break
                case 2:
                    setState(797)
                    try match(ObjectiveCParser.Tokens.VOID.rawValue)

                    break
                default: break
                }
                setState(804)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(800)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(801)
                    try parameterDeclaration()

                    setState(806)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(809)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

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
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
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
        try enterRule(_localctx, 94, ObjectiveCParser.RULE_blockExpression)
        defer { try! exitRule() }
        do {
            setState(826)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 73, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(811)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(812)
                try compoundStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(813)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(814)
                try typeName()
                setState(815)
                try blockParameters()
                setState(816)
                try compoundStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(818)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(819)
                try typeName()
                setState(820)
                try compoundStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(822)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(823)
                try blockParameters()
                setState(824)
                try compoundStatement()

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
        try enterRule(_localctx, 96, ObjectiveCParser.RULE_messageExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(828)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(829)
            try receiver()
            setState(830)
            try messageSelector()
            setState(831)
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
        try enterRule(_localctx, 98, ObjectiveCParser.RULE_receiver)
        defer { try! exitRule() }
        do {
            setState(835)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 74, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(833)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(834)
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
        try enterRule(_localctx, 100, ObjectiveCParser.RULE_messageSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(843)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 76, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(837)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(839)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(838)
                    try keywordArgument()

                    setState(841)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
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
        try enterRule(_localctx, 102, ObjectiveCParser.RULE_keywordArgument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(846)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(845)
                try selector()

            }

            setState(848)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(849)
            try keywordArgumentType()
            setState(854)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(850)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(851)
                try keywordArgumentType()

                setState(856)
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
        try enterRule(_localctx, 104, ObjectiveCParser.RULE_keywordArgumentType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(857)
            try expressions()
            setState(859)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(858)
                try nullabilitySpecifier()

            }

            setState(865)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(861)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(862)
                try initializerList()
                setState(863)
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
        try enterRule(_localctx, 106, ObjectiveCParser.RULE_selectorExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(867)
            try match(ObjectiveCParser.Tokens.SELECTOR.rawValue)
            setState(868)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(869)
            try selectorName()
            setState(870)
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
        try enterRule(_localctx, 108, ObjectiveCParser.RULE_selectorName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(881)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 83, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(872)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(877)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(874)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    {
                        setState(873)
                        try selector()

                    }

                    setState(876)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)

                    setState(879)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
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
        try enterRule(_localctx, 110, ObjectiveCParser.RULE_protocolExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(883)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(884)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(885)
            try protocolName()
            setState(886)
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
        try enterRule(_localctx, 112, ObjectiveCParser.RULE_encodeExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(888)
            try match(ObjectiveCParser.Tokens.ENCODE.rawValue)
            setState(889)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(890)
            try typeName()
            setState(891)
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
        try enterRule(_localctx, 114, ObjectiveCParser.RULE_typeVariableDeclarator)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(893)
            try declarationSpecifiers()
            setState(894)
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
        try enterRule(_localctx, 116, ObjectiveCParser.RULE_throwStatement)
        defer { try! exitRule() }
        do {
            setState(903)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 84, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(896)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(897)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(898)
                try identifier()
                setState(899)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(901)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(902)
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
        try enterRule(_localctx, 118, ObjectiveCParser.RULE_tryBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(905)
            try match(ObjectiveCParser.Tokens.TRY.rawValue)
            setState(906)
            try {
                let assignmentValue = try compoundStatement()
                _localctx.castdown(TryBlockContext.self).tryStatement = assignmentValue
            }()

            setState(910)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CATCH.rawValue {
                setState(907)
                try catchStatement()

                setState(912)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(915)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.FINALLY.rawValue {
                setState(913)
                try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
                setState(914)
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
        try enterRule(_localctx, 120, ObjectiveCParser.RULE_catchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(917)
            try match(ObjectiveCParser.Tokens.CATCH.rawValue)
            setState(918)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(919)
            try typeVariableDeclarator()
            setState(920)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(921)
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
        try enterRule(_localctx, 122, ObjectiveCParser.RULE_synchronizedStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(923)
            try match(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue)
            setState(924)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(925)
            try expression(0)
            setState(926)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(927)
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
        try enterRule(_localctx, 124, ObjectiveCParser.RULE_autoreleaseStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(929)
            try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
            setState(930)
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
        try enterRule(_localctx, 126, ObjectiveCParser.RULE_functionDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(932)
            try functionSignature()
            setState(933)
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
        try enterRule(_localctx, 128, ObjectiveCParser.RULE_functionDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(935)
            try functionSignature()
            setState(936)
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
        try enterRule(_localctx, 130, ObjectiveCParser.RULE_functionSignature)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(939)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 87, _ctx) {
            case 1:
                setState(938)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(941)
            try declarator()
            setState(943)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_248_341_250_049) != 0
            {
                setState(942)
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
        try enterRule(_localctx, 132, ObjectiveCParser.RULE_declarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(946)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(945)
                try declaration()

                setState(948)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_248_341_250_049) != 0

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
        try enterRule(_localctx, 134, ObjectiveCParser.RULE_attribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(950)
            try attributeName()
            setState(952)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(951)
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
        try enterRule(_localctx, 136, ObjectiveCParser.RULE_attributeName)
        defer { try! exitRule() }
        do {
            setState(956)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(954)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(955)
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
        try enterRule(_localctx, 138, ObjectiveCParser.RULE_attributeParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(958)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(960)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_568) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 100_139_011) != 0
            {
                setState(959)
                try attributeParameterList()

            }

            setState(962)
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
        try enterRule(_localctx, 140, ObjectiveCParser.RULE_attributeParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(964)
            try attributeParameter()
            setState(969)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(965)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(966)
                try attributeParameter()

                setState(971)
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
        try enterRule(_localctx, 142, ObjectiveCParser.RULE_attributeParameter)
        defer { try! exitRule() }
        do {
            setState(976)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 94, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(972)
                try attribute()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(973)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(974)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(975)
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
        try enterRule(_localctx, 144, ObjectiveCParser.RULE_attributeParameterAssignment)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(978)
            try attributeName()
            setState(979)
            try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
            setState(983)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                setState(980)
                try constant()

                break
            case .CONST, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE,
                .IDENTIFIER:
                setState(981)
                try attributeName()

                break

            case .STRING_START:
                setState(982)
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
        try enterRule(_localctx, 146, ObjectiveCParser.RULE_functionPointer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(985)
            try declarationSpecifiers()
            setState(986)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(987)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(989)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(988)
                try identifier()

            }

            setState(991)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(992)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(994)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
            {
                setState(993)
                try functionPointerParameterList()

            }

            setState(996)
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
        try enterRule(_localctx, 148, ObjectiveCParser.RULE_functionPointerParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(998)
            try functionPointerParameterDeclarationList()
            setState(1001)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(999)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1000)
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
        try enterRule(_localctx, 150, ObjectiveCParser.RULE_functionPointerParameterDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1003)
            try functionPointerParameterDeclaration()
            setState(1008)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 99, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1004)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1005)
                    try functionPointerParameterDeclaration()

                }
                setState(1010)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 99, _ctx)
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
        try enterRule(_localctx, 152, ObjectiveCParser.RULE_functionPointerParameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1019)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 102, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1013)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 100, _ctx) {
                case 1:
                    setState(1011)
                    try declarationSpecifiers()

                    break
                case 2:
                    setState(1012)
                    try functionPointer()

                    break
                default: break
                }
                setState(1016)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1015)
                    try declarator()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1018)
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
        try enterRule(_localctx, 154, ObjectiveCParser.RULE_functionCallExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1022)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1021)
                try attributeSpecifier()

            }

            setState(1024)
            try identifier()
            setState(1026)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1025)
                try attributeSpecifier()

            }

            setState(1028)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1029)
            try directDeclarator(0)
            setState(1030)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1031)
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
        try enterRule(_localctx, 156, ObjectiveCParser.RULE_enumDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1034)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1033)
                try attributeSpecifier()

            }

            setState(1037)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.TYPEDEF.rawValue {
                setState(1036)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)

            }

            setState(1039)
            try enumSpecifier()
            setState(1041)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(1040)
                try identifier()

            }

            setState(1043)
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
        try enterRule(_localctx, 158, ObjectiveCParser.RULE_varDeclaration_)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1049)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 108, _ctx) {
            case 1:
                setState(1045)
                try declarationSpecifiers()
                setState(1046)
                try initDeclaratorList()

                break
            case 2:
                setState(1048)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(1051)
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
        try enterRule(_localctx, 160, ObjectiveCParser.RULE_typedefDeclaration_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1075)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 113, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1054)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1053)
                    try attributeSpecifier()

                }

                setState(1056)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1061)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 110, _ctx) {
                case 1:
                    setState(1057)
                    try declarationSpecifiers()
                    setState(1058)
                    try typeDeclaratorList()

                    break
                case 2:
                    setState(1060)
                    try declarationSpecifiers()

                    break
                default: break
                }
                setState(1064)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                {
                    setState(1063)
                    try macro()

                }

                setState(1066)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1069)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1068)
                    try attributeSpecifier()

                }

                setState(1071)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1072)
                try functionPointer()
                setState(1073)
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
        try enterRule(_localctx, 162, ObjectiveCParser.RULE_typeDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1077)
            try declarator()
            setState(1082)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1078)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1079)
                try declarator()

                setState(1084)
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
        try enterRule(_localctx, 164, ObjectiveCParser.RULE_declarationSpecifiers_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1093)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1093)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 115, _ctx) {
                case 1:
                    setState(1085)
                    try storageClassSpecifier()

                    break
                case 2:
                    setState(1086)
                    try attributeSpecifier()

                    break
                case 3:
                    setState(1087)
                    try arcBehaviourSpecifier()

                    break
                case 4:
                    setState(1088)
                    try nullabilitySpecifier()

                    break
                case 5:
                    setState(1089)
                    try ibOutletQualifier()

                    break
                case 6:
                    setState(1090)
                    try typePrefix()

                    break
                case 7:
                    setState(1091)
                    try typeQualifier()

                    break
                case 8:
                    setState(1092)
                    try typeSpecifier()

                    break
                default: break
                }

                setState(1095)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_342_977_331_201) != 0

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
        try enterRule(_localctx, 166, ObjectiveCParser.RULE_declarationSpecifier__)
        defer { try! exitRule() }
        do {
            setState(1105)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 117, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1097)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1098)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1099)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1100)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1101)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1102)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1103)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1104)
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
        try enterRule(_localctx, 168, ObjectiveCParser.RULE_declarationSpecifier)
        defer { try! exitRule() }
        do {
            setState(1115)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 118, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1107)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1108)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1109)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1110)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1111)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1112)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1113)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1114)
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
        try enterRule(_localctx, 170, ObjectiveCParser.RULE_declarationSpecifiers)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1118)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 119, _ctx) {
            case 1:
                setState(1117)
                try typePrefix()

                break
            default: break
            }
            setState(1121)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1120)
                    try declarationSpecifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1123)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 120, _ctx)
            } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

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
        try enterRule(_localctx, 172, ObjectiveCParser.RULE_declaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1132)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF, .UNSAFE_UNRETAINED_QUALIFIER,
                .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D, .M128I,
                .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED, .NULLABLE,
                .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_OUTLET, .IB_OUTLET_COLLECTION,
                .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(1125)
                try declarationSpecifiers()
                setState(1127)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1126)
                    try initDeclaratorList()

                }

                setState(1129)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .STATIC_ASSERT_:
                try enterOuterAlt(_localctx, 2)
                setState(1131)
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
        try enterRule(_localctx, 174, ObjectiveCParser.RULE_initDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1134)
            try initDeclarator()
            setState(1139)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1135)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1136)
                try initDeclarator()

                setState(1141)
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
        try enterRule(_localctx, 176, ObjectiveCParser.RULE_initDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1142)
            try declarator()
            setState(1145)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1143)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1144)
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
        try enterRule(_localctx, 178, ObjectiveCParser.RULE_declarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1148)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1147)
                try pointer()

            }

            setState(1150)
            try directDeclarator(0)
            setState(1154)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 126, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1151)
                    try gccDeclaratorExtension()

                }
                setState(1156)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 126, _ctx)
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
        open func directDeclarator() -> DirectDeclaratorContext? {
            return getRuleContext(DirectDeclaratorContext.self, 0)
        }
        open func blockParameters() -> BlockParametersContext? {
            return getRuleContext(BlockParametersContext.self, 0)
        }
        open func blockDeclarationSpecifier() -> [BlockDeclarationSpecifierContext] {
            return getRuleContexts(BlockDeclarationSpecifierContext.self)
        }
        open func blockDeclarationSpecifier(_ i: Int) -> BlockDeclarationSpecifierContext? {
            return getRuleContext(BlockDeclarationSpecifierContext.self, i)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func DIGITS() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIGITS.rawValue, 0)
        }
        open func vcSpecificModifier() -> VcSpecificModifierContext? {
            return getRuleContext(VcSpecificModifierContext.self, 0)
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
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
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
        let _startState: Int = 180
        try enterRecursionRule(_localctx, 180, ObjectiveCParser.RULE_directDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1187)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 128, _ctx) {
            case 1:
                setState(1158)
                try identifier()

                break
            case 2:
                setState(1159)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1160)
                try declarator()
                setState(1161)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                setState(1163)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1164)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1168)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 127, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1165)
                        try blockDeclarationSpecifier()

                    }
                    setState(1170)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 127, _ctx)
                }
                setState(1171)
                try directDeclarator(0)
                setState(1172)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1173)
                try blockParameters()

                break
            case 4:
                setState(1175)
                try identifier()
                setState(1176)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1177)
                try match(ObjectiveCParser.Tokens.DIGITS.rawValue)

                break
            case 5:
                setState(1179)
                try vcSpecificModifier()
                setState(1180)
                try identifier()

                break
            case 6:
                setState(1182)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1183)
                try vcSpecificModifier()
                setState(1184)
                try declarator()
                setState(1185)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1229)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 135, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1227)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 134, _ctx) {
                    case 1:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1189)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(1190)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1192)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 129, _ctx) {
                        case 1:
                            setState(1191)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1195)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                            || (Int64((_la - 92)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                        {
                            setState(1194)
                            try expression(0)

                        }

                        setState(1197)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1198)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(1199)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1200)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1202)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 131, _ctx) {
                        case 1:
                            setState(1201)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1204)
                        try expression(0)
                        setState(1205)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1207)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(1208)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1209)
                        try typeQualifierList()
                        setState(1210)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1211)
                        try expression(0)
                        setState(1212)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1214)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1215)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1217)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 27_918_807_844_519_968) != 0
                            || _la == ObjectiveCParser.Tokens.ATOMIC_.rawValue
                        {
                            setState(1216)
                            try typeQualifierList()

                        }

                        setState(1219)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1220)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1221)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1222)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1224)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
                        {
                            setState(1223)
                            try parameterTypeList()

                        }

                        setState(1226)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)

                        break
                    default: break
                    }
                }
                setState(1231)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 135, _ctx)
            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class BlockDeclarationSpecifierContext: ParserRuleContext {
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
        }
        open func arcBehaviourSpecifier() -> ArcBehaviourSpecifierContext? {
            return getRuleContext(ArcBehaviourSpecifierContext.self, 0)
        }
        open func typeQualifier() -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, 0)
        }
        open func typePrefix() -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_blockDeclarationSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBlockDeclarationSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBlockDeclarationSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBlockDeclarationSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBlockDeclarationSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func blockDeclarationSpecifier() throws
        -> BlockDeclarationSpecifierContext
    {
        var _localctx: BlockDeclarationSpecifierContext
        _localctx = BlockDeclarationSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 182, ObjectiveCParser.RULE_blockDeclarationSpecifier)
        defer { try! exitRule() }
        do {
            setState(1236)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE:
                try enterOuterAlt(_localctx, 1)
                setState(1232)
                try nullabilitySpecifier()

                break
            case .AUTORELEASING_QUALIFIER, .STRONG_QUALIFIER, .UNSAFE_UNRETAINED_QUALIFIER,
                .WEAK_QUALIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(1233)
                try arcBehaviourSpecifier()

                break
            case .CONST, .RESTRICT, .VOLATILE, .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT,
                .ATOMIC_:
                try enterOuterAlt(_localctx, 3)
                setState(1234)
                try typeQualifier()

                break
            case .INLINE, .BLOCK, .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .KINDOF, .NS_INLINE:
                try enterOuterAlt(_localctx, 4)
                setState(1235)
                try typePrefix()

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
        try enterRule(_localctx, 184, ObjectiveCParser.RULE_typeName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1238)
            try declarationSpecifiers()
            setState(1240)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 137, _ctx) {
            case 1:
                setState(1239)
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
        try enterRule(_localctx, 186, ObjectiveCParser.RULE_abstractDeclarator_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1265)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .MUL:
                try enterOuterAlt(_localctx, 1)
                setState(1242)
                try pointer()
                setState(1244)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 138, _ctx) {
                case 1:
                    setState(1243)
                    try abstractDeclarator_()

                    break
                default: break
                }

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1246)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1248)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1247)
                    try abstractDeclarator()

                }

                setState(1250)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1252)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1251)
                        try abstractDeclaratorSuffix_()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1254)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 140, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

                break

            case .LBRACK:
                try enterOuterAlt(_localctx, 3)
                setState(1261)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1256)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1258)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                            || (Int64((_la - 173)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                        {
                            setState(1257)
                            try constantExpression()

                        }

                        setState(1260)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1263)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 142, _ctx)
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
        try enterRule(_localctx, 188, ObjectiveCParser.RULE_abstractDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1278)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 146, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1267)
                try pointer()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1269)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1268)
                    try pointer()

                }

                setState(1271)
                try directAbstractDeclarator(0)
                setState(1275)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
                    || _la == ObjectiveCParser.Tokens.ASM.rawValue
                {
                    setState(1272)
                    try gccDeclaratorExtension()

                    setState(1277)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
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
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
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
        open func blockDeclarationSpecifier() -> [BlockDeclarationSpecifierContext] {
            return getRuleContexts(BlockDeclarationSpecifierContext.self)
        }
        open func blockDeclarationSpecifier(_ i: Int) -> BlockDeclarationSpecifierContext? {
            return getRuleContext(BlockDeclarationSpecifierContext.self, i)
        }
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
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
        let _startState: Int = 190
        try enterRecursionRule(_localctx, 190, ObjectiveCParser.RULE_directAbstractDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1339)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 155, _ctx) {
            case 1:
                setState(1281)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1282)
                try abstractDeclarator()
                setState(1283)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1287)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 147, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1284)
                        try gccDeclaratorExtension()

                    }
                    setState(1289)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 147, _ctx)
                }

                break
            case 2:
                setState(1290)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1292)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 148, _ctx) {
                case 1:
                    setState(1291)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1295)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(1294)
                    try expression(0)

                }

                setState(1297)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 3:
                setState(1298)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1299)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1301)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 150, _ctx) {
                case 1:
                    setState(1300)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1303)
                try expression(0)
                setState(1304)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 4:
                setState(1306)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1307)
                try typeQualifierList()
                setState(1308)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1309)
                try expression(0)
                setState(1310)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 5:
                setState(1312)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1313)
                try match(ObjectiveCParser.Tokens.MUL.rawValue)
                setState(1314)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 6:
                setState(1315)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1317)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
                {
                    setState(1316)
                    try parameterTypeList()

                }

                setState(1319)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1323)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 152, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1320)
                        try gccDeclaratorExtension()

                    }
                    setState(1325)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 152, _ctx)
                }

                break
            case 7:
                setState(1326)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1327)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1331)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 153, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1328)
                        try blockDeclarationSpecifier()

                    }
                    setState(1333)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 153, _ctx)
                }
                setState(1335)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                {
                    setState(1334)
                    try identifier()

                }

                setState(1337)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1338)
                try blockParameters()

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1384)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 162, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1382)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 161, _ctx) {
                    case 1:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1341)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1342)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1344)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 156, _ctx) {
                        case 1:
                            setState(1343)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1347)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                            || (Int64((_la - 92)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                        {
                            setState(1346)
                            try expression(0)

                        }

                        setState(1349)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1350)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1351)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1352)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1354)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 158, _ctx) {
                        case 1:
                            setState(1353)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1356)
                        try expression(0)
                        setState(1357)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1359)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(1360)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1361)
                        try typeQualifierList()
                        setState(1362)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1363)
                        try expression(0)
                        setState(1364)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1366)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(1367)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1368)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1369)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1370)
                        if !(precpred(_ctx, 2)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 2)"))
                        }
                        setState(1371)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1373)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
                        {
                            setState(1372)
                            try parameterTypeList()

                        }

                        setState(1375)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)
                        setState(1379)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 160, _ctx)
                        while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                            if _alt == 1 {
                                setState(1376)
                                try gccDeclaratorExtension()

                            }
                            setState(1381)
                            try _errHandler.sync(self)
                            _alt = try getInterpreter().adaptivePredict(_input, 160, _ctx)
                        }

                        break
                    default: break
                    }
                }
                setState(1386)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 162, _ctx)
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
        try enterRule(_localctx, 192, ObjectiveCParser.RULE_abstractDeclaratorSuffix_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1397)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(1387)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1389)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    || (Int64((_la - 173)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                {
                    setState(1388)
                    try constantExpression()

                }

                setState(1391)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1392)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1394)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
                {
                    setState(1393)
                    try parameterDeclarationList_()

                }

                setState(1396)
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
        try enterRule(_localctx, 194, ObjectiveCParser.RULE_parameterTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1399)
            try parameterList()
            setState(1402)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1400)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1401)
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
        try enterRule(_localctx, 196, ObjectiveCParser.RULE_parameterList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1404)
            try parameterDeclaration()
            setState(1409)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 167, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1405)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1406)
                    try parameterDeclaration()

                }
                setState(1411)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 167, _ctx)
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
        try enterRule(_localctx, 198, ObjectiveCParser.RULE_parameterDeclarationList_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1412)
            try parameterDeclaration()
            setState(1417)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1413)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1414)
                try parameterDeclaration()

                setState(1419)
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
        try enterRule(_localctx, 200, ObjectiveCParser.RULE_parameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1427)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 170, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1420)
                try declarationSpecifiers()
                setState(1421)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1423)
                try declarationSpecifiers()
                setState(1425)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1424)
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
        try enterRule(_localctx, 202, ObjectiveCParser.RULE_typeQualifierList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1430)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1429)
                    try typeQualifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1432)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 171, _ctx)
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
        try enterRule(_localctx, 204, ObjectiveCParser.RULE_identifierList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1434)
            try identifier()
            setState(1439)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1435)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1436)
                try identifier()

                setState(1441)
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
        try enterRule(_localctx, 206, ObjectiveCParser.RULE_declaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1442)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(1444)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
            {
                setState(1443)
                try constantExpression()

            }

            setState(1446)
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
        try enterRule(_localctx, 208, ObjectiveCParser.RULE_attributeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1448)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1449)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1450)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1451)
            try attribute()
            setState(1456)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1452)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1453)
                try attribute()

                setState(1458)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1459)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1460)
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
        try enterRule(_localctx, 210, ObjectiveCParser.RULE_atomicTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1462)
            try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)
            setState(1463)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1464)
            try typeName()
            setState(1465)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

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
        try enterRule(_localctx, 212, ObjectiveCParser.RULE_fieldDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1467)
            try declarationSpecifiers()
            setState(1468)
            try fieldDeclaratorList()
            setState(1470)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(1469)
                try macro()

            }

            setState(1472)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructOrUnionSpecifierContext: ParserRuleContext {
        open func structOrUnion() -> StructOrUnionContext? {
            return getRuleContext(StructOrUnionContext.self, 0)
        }
        open func LBRACE() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LBRACE.rawValue, 0)
        }
        open func structDeclarationList() -> StructDeclarationListContext? {
            return getRuleContext(StructDeclarationListContext.self, 0)
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
        open func identifier() -> IdentifierContext? {
            return getRuleContext(IdentifierContext.self, 0)
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
        try enterRule(_localctx, 214, ObjectiveCParser.RULE_structOrUnionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1497)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 179, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1474)
                try structOrUnion()
                setState(1478)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1475)
                    try attributeSpecifier()

                    setState(1480)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1482)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                {
                    setState(1481)
                    try identifier()

                }

                setState(1484)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1485)
                try structDeclarationList()
                setState(1486)
                try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1488)
                try structOrUnion()
                setState(1492)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1489)
                    try attributeSpecifier()

                    setState(1494)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1495)
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

    public class StructOrUnionContext: ParserRuleContext {
        open func STRUCT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.STRUCT.rawValue, 0)
        }
        open func UNION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNION.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_structOrUnion }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructOrUnion(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructOrUnion(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructOrUnion(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructOrUnion(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structOrUnion() throws -> StructOrUnionContext {
        var _localctx: StructOrUnionContext
        _localctx = StructOrUnionContext(_ctx, getState())
        try enterRule(_localctx, 216, ObjectiveCParser.RULE_structOrUnion)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1499)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.STRUCT.rawValue
                || _la == ObjectiveCParser.Tokens.UNION.rawValue)
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

    public class StructDeclarationListContext: ParserRuleContext {
        open func structDeclaration() -> [StructDeclarationContext] {
            return getRuleContexts(StructDeclarationContext.self)
        }
        open func structDeclaration(_ i: Int) -> StructDeclarationContext? {
            return getRuleContext(StructDeclarationContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_structDeclarationList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructDeclarationList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructDeclarationList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructDeclarationList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructDeclarationList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structDeclarationList() throws -> StructDeclarationListContext {
        var _localctx: StructDeclarationListContext
        _localctx = StructDeclarationListContext(_ctx, getState())
        try enterRule(_localctx, 218, ObjectiveCParser.RULE_structDeclarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1502)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1501)
                try structDeclaration()

                setState(1504)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_311_695_587_888) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_035_967_966_458_353) != 0

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructDeclarationContext: ParserRuleContext {
        open func specifierQualifierList() -> SpecifierQualifierListContext? {
            return getRuleContext(SpecifierQualifierListContext.self, 0)
        }
        open func fieldDeclaratorList() -> FieldDeclaratorListContext? {
            return getRuleContext(FieldDeclaratorListContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
        }
        open func attributeSpecifier() -> [AttributeSpecifierContext] {
            return getRuleContexts(AttributeSpecifierContext.self)
        }
        open func attributeSpecifier(_ i: Int) -> AttributeSpecifierContext? {
            return getRuleContext(AttributeSpecifierContext.self, i)
        }
        open func staticAssertDeclaration() -> StaticAssertDeclarationContext? {
            return getRuleContext(StaticAssertDeclarationContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_structDeclaration }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructDeclaration(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructDeclaration(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructDeclaration(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructDeclaration(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structDeclaration() throws -> StructDeclarationContext {
        var _localctx: StructDeclarationContext
        _localctx = StructDeclarationContext(_ctx, getState())
        try enterRule(_localctx, 220, ObjectiveCParser.RULE_structDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1526)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 183, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1509)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1506)
                    try attributeSpecifier()

                    setState(1511)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1512)
                try specifierQualifierList()
                setState(1513)
                try fieldDeclaratorList()
                setState(1514)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1519)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1516)
                    try attributeSpecifier()

                    setState(1521)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1522)
                try specifierQualifierList()
                setState(1523)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1525)
                try staticAssertDeclaration()

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
        open func typeSpecifier() -> TypeSpecifierContext? {
            return getRuleContext(TypeSpecifierContext.self, 0)
        }
        open func typeQualifier() -> TypeQualifierContext? {
            return getRuleContext(TypeQualifierContext.self, 0)
        }
        open func specifierQualifierList() -> SpecifierQualifierListContext? {
            return getRuleContext(SpecifierQualifierListContext.self, 0)
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
        try enterRule(_localctx, 222, ObjectiveCParser.RULE_specifierQualifierList)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1530)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 184, _ctx) {
            case 1:
                setState(1528)
                try typeSpecifier()

                break
            case 2:
                setState(1529)
                try typeQualifier()

                break
            default: break
            }
            setState(1533)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 185, _ctx) {
            case 1:
                setState(1532)
                try specifierQualifierList()

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
        open var enumName: IdentifierContext!
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
        try enterRule(_localctx, 224, ObjectiveCParser.RULE_enumSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1566)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ENUM:
                try enterOuterAlt(_localctx, 1)
                setState(1535)
                try match(ObjectiveCParser.Tokens.ENUM.rawValue)
                setState(1541)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 187, _ctx) {
                case 1:
                    setState(1537)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    {
                        setState(1536)
                        try {
                            let assignmentValue = try identifier()
                            _localctx.castdown(EnumSpecifierContext.self).enumName = assignmentValue
                        }()

                    }

                    setState(1539)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(1540)
                    try typeName()

                    break
                default: break
                }
                setState(1554)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                    .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
                    setState(1543)
                    try identifier()
                    setState(1548)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 188, _ctx) {
                    case 1:
                        setState(1544)
                        try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                        setState(1545)
                        try enumeratorList()
                        setState(1546)
                        try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                        break
                    default: break
                    }

                    break

                case .LBRACE:
                    setState(1550)
                    try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                    setState(1551)
                    try enumeratorList()
                    setState(1552)
                    try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            case .NS_ENUM, .NS_OPTIONS:
                try enterOuterAlt(_localctx, 2)
                setState(1556)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.NS_ENUM.rawValue
                    || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1557)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1558)
                try typeName()
                setState(1559)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1560)
                try {
                    let assignmentValue = try identifier()
                    _localctx.castdown(EnumSpecifierContext.self).enumName = assignmentValue
                }()

                setState(1561)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1562)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1563)
                try enumeratorList()
                setState(1564)
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
        try enterRule(_localctx, 226, ObjectiveCParser.RULE_enumeratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1568)
            try enumerator()
            setState(1573)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 191, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1569)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1570)
                    try enumerator()

                }
                setState(1575)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 191, _ctx)
            }
            setState(1577)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1576)
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
        try enterRule(_localctx, 228, ObjectiveCParser.RULE_enumerator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1579)
            try enumeratorIdentifier()
            setState(1582)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1580)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1581)
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
        try enterRule(_localctx, 230, ObjectiveCParser.RULE_enumeratorIdentifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1584)
            try identifier()

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
        try enterRule(_localctx, 232, ObjectiveCParser.RULE_ibOutletQualifier)
        defer { try! exitRule() }
        do {
            setState(1592)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IB_OUTLET_COLLECTION:
                try enterOuterAlt(_localctx, 1)
                setState(1586)
                try match(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue)
                setState(1587)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1588)
                try identifier()
                setState(1589)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .IB_OUTLET:
                try enterOuterAlt(_localctx, 2)
                setState(1591)
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
        try enterRule(_localctx, 234, ObjectiveCParser.RULE_arcBehaviourSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1594)
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
        try enterRule(_localctx, 236, ObjectiveCParser.RULE_nullabilitySpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1596)
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
        try enterRule(_localctx, 238, ObjectiveCParser.RULE_storageClassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1598)
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
        try enterRule(_localctx, 240, ObjectiveCParser.RULE_typePrefix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1600)
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
        try enterRule(_localctx, 242, ObjectiveCParser.RULE_typeQualifier)
        defer { try! exitRule() }
        do {
            setState(1607)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(1602)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break

            case .VOLATILE:
                try enterOuterAlt(_localctx, 2)
                setState(1603)
                try match(ObjectiveCParser.Tokens.VOLATILE.rawValue)

                break

            case .RESTRICT:
                try enterOuterAlt(_localctx, 3)
                setState(1604)
                try match(ObjectiveCParser.Tokens.RESTRICT.rawValue)

                break

            case .ATOMIC_:
                try enterOuterAlt(_localctx, 4)
                setState(1605)
                try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)

                break
            case .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT:
                try enterOuterAlt(_localctx, 5)
                setState(1606)
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
        try enterRule(_localctx, 244, ObjectiveCParser.RULE_functionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1616)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .INLINE, .STDCALL, .INLINE__, .NORETURN_:
                try enterOuterAlt(_localctx, 1)
                setState(1609)
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
                setState(1610)
                try gccAttributeSpecifier()

                break

            case .DECLSPEC:
                try enterOuterAlt(_localctx, 3)
                setState(1611)
                try match(ObjectiveCParser.Tokens.DECLSPEC.rawValue)
                setState(1612)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1613)
                try identifier()
                setState(1614)
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
        try enterRule(_localctx, 246, ObjectiveCParser.RULE_alignmentSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1618)
            try match(ObjectiveCParser.Tokens.ALIGNAS_.rawValue)
            setState(1619)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1622)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 197, _ctx) {
            case 1:
                setState(1620)
                try typeName()

                break
            case 2:
                setState(1621)
                try constantExpression()

                break
            default: break
            }
            setState(1624)
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
        try enterRule(_localctx, 248, ObjectiveCParser.RULE_protocolQualifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1626)
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
        open func typeofTypeSpecifier() -> TypeofTypeSpecifierContext? {
            return getRuleContext(TypeofTypeSpecifierContext.self, 0)
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
        try enterRule(_localctx, 250, ObjectiveCParser.RULE_typeSpecifier_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1652)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 204, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1628)
                try scalarTypeSpecifier()
                setState(1630)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1629)
                    try pointer()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1632)
                try typeofTypeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1634)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1633)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1636)
                try genericTypeSpecifier()
                setState(1638)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1637)
                    try pointer()

                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1640)
                try structOrUnionSpecifier()
                setState(1642)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1641)
                    try pointer()

                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1644)
                try enumSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1646)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1645)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1648)
                try identifier()
                setState(1650)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1649)
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
        open func typeofTypeSpecifier() -> TypeofTypeSpecifierContext? {
            return getRuleContext(TypeofTypeSpecifierContext.self, 0)
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
        try enterRule(_localctx, 252, ObjectiveCParser.RULE_typeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1665)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 205, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1654)
                try scalarTypeSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1655)
                try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)
                setState(1656)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1657)
                _la = try _input.LA(1)
                if !((Int64((_la - 112)) & ~0x3f) == 0 && ((Int64(1) << (_la - 112)) & 7) != 0) {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1658)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1659)
                try genericTypeSpecifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1660)
                try atomicTypeSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1661)
                try structOrUnionSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1662)
                try enumSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1663)
                try typedefName()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1664)
                try typeofTypeSpecifier()

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

    public class TypeofTypeSpecifierContext: ParserRuleContext {
        open func TYPEOF() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.TYPEOF.rawValue, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_typeofTypeSpecifier
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterTypeofTypeSpecifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitTypeofTypeSpecifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitTypeofTypeSpecifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitTypeofTypeSpecifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func typeofTypeSpecifier() throws -> TypeofTypeSpecifierContext {
        var _localctx: TypeofTypeSpecifierContext
        _localctx = TypeofTypeSpecifierContext(_ctx, getState())
        try enterRule(_localctx, 254, ObjectiveCParser.RULE_typeofTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1667)
            try match(ObjectiveCParser.Tokens.TYPEOF.rawValue)

            setState(1668)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1669)
            try expression(0)
            setState(1670)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

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
        try enterRule(_localctx, 256, ObjectiveCParser.RULE_typedefName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1672)
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
        try enterRule(_localctx, 258, ObjectiveCParser.RULE_genericTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1674)
            try identifier()
            setState(1675)
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
        try enterRule(_localctx, 260, ObjectiveCParser.RULE_genericTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1677)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(1686)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
            {
                setState(1678)
                try genericTypeParameter()
                setState(1683)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1679)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1680)
                    try genericTypeParameter()

                    setState(1685)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(1688)
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
        try enterRule(_localctx, 262, ObjectiveCParser.RULE_genericTypeParameter)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1691)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 208, _ctx) {
            case 1:
                setState(1690)
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
            setState(1693)
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
        try enterRule(_localctx, 264, ObjectiveCParser.RULE_scalarTypeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1695)
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
        try enterRule(_localctx, 266, ObjectiveCParser.RULE_fieldDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1697)
            try fieldDeclarator()
            setState(1702)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1698)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1699)
                try fieldDeclarator()

                setState(1704)
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
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
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
        try enterRule(_localctx, 268, ObjectiveCParser.RULE_fieldDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1711)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 211, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1705)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1707)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1706)
                    try declarator()

                }

                setState(1709)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1710)
                try constantExpression()

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

    public class VcSpecificModifierContext: ParserRuleContext {
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
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_vcSpecificModifier }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterVcSpecificModifier(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitVcSpecificModifier(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitVcSpecificModifier(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitVcSpecificModifier(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func vcSpecificModifier() throws -> VcSpecificModifierContext {
        var _localctx: VcSpecificModifierContext
        _localctx = VcSpecificModifierContext(_ctx, getState())
        try enterRule(_localctx, 270, ObjectiveCParser.RULE_vcSpecificModifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1713)
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
        try enterRule(_localctx, 272, ObjectiveCParser.RULE_gccDeclaratorExtension)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1725)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ASM:
                try enterOuterAlt(_localctx, 1)
                setState(1715)
                try match(ObjectiveCParser.Tokens.ASM.rawValue)
                setState(1716)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1718)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1717)
                    try stringLiteral()

                    setState(1720)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
                setState(1722)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .ATTRIBUTE:
                try enterOuterAlt(_localctx, 2)
                setState(1724)
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
        try enterRule(_localctx, 274, ObjectiveCParser.RULE_gccAttributeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1727)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1728)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1729)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1730)
            try gccAttributeList()
            setState(1731)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1732)
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
        try enterRule(_localctx, 276, ObjectiveCParser.RULE_gccAttributeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1735)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
            {
                setState(1734)
                try gccAttribute()

            }

            setState(1743)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1737)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1739)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                {
                    setState(1738)
                    try gccAttribute()

                }

                setState(1745)
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
        try enterRule(_localctx, 278, ObjectiveCParser.RULE_gccAttribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1746)
            _la = try _input.LA(1)
            if _la <= 0
                || ((Int64((_la - 147)) & ~0x3f) == 0 && ((Int64(1) << (_la - 147)) & 131) != 0)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1752)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1747)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1749)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(1748)
                    try argumentExpressionList()

                }

                setState(1751)
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
        try enterRule(_localctx, 280, ObjectiveCParser.RULE_pointer_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1754)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1756)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_726_785) != 0
            {
                setState(1755)
                try declarationSpecifiers()

            }

            setState(1759)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1758)
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
        try enterRule(_localctx, 282, ObjectiveCParser.RULE_pointer)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1762)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1761)
                    try pointerEntry()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1764)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 221, _ctx)
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
        open func nullabilitySpecifier() -> NullabilitySpecifierContext? {
            return getRuleContext(NullabilitySpecifierContext.self, 0)
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
        try enterRule(_localctx, 284, ObjectiveCParser.RULE_pointerEntry)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1766)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)

            setState(1768)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 222, _ctx) {
            case 1:
                setState(1767)
                try typeQualifierList()

                break
            default: break
            }
            setState(1771)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(1770)
                try nullabilitySpecifier()

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
        open var _tset3152: Token!
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
        try enterRule(_localctx, 286, ObjectiveCParser.RULE_macro)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1773)
            try identifier()
            setState(1782)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1774)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1777)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1777)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 224, _ctx) {
                    case 1:
                        setState(1775)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                        break
                    case 2:
                        setState(1776)
                        _localctx.castdown(MacroContext.self)._tset3152 = try _input.LT(1)
                        _la = try _input.LA(1)
                        if _la <= 0 || (_la == ObjectiveCParser.Tokens.RP.rawValue) {
                            _localctx.castdown(MacroContext.self)._tset3152 =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        _localctx.castdown(MacroContext.self).macroArguments.append(
                            _localctx.castdown(MacroContext.self)._tset3152)

                        break
                    default: break
                    }

                    setState(1779)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -1_048_577) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                setState(1781)
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
        try enterRule(_localctx, 288, ObjectiveCParser.RULE_arrayInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1784)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1796)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1785)
                try expression(0)
                setState(1790)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 227, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1786)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1787)
                        try expression(0)

                    }
                    setState(1792)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 227, _ctx)
                }
                setState(1794)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1793)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1798)
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
        try enterRule(_localctx, 290, ObjectiveCParser.RULE_structInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1800)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1812)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue
                || _la == ObjectiveCParser.Tokens.DOT.rawValue
            {
                setState(1801)
                try structInitializerItem()
                setState(1806)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 230, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1802)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1803)
                        try structInitializerItem()

                    }
                    setState(1808)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 230, _ctx)
                }
                setState(1810)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1809)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1814)
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
        try enterRule(_localctx, 292, ObjectiveCParser.RULE_structInitializerItem)
        defer { try! exitRule() }
        do {
            setState(1820)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 233, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1816)
                try match(ObjectiveCParser.Tokens.DOT.rawValue)
                setState(1817)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1818)
                try structInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1819)
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
        try enterRule(_localctx, 294, ObjectiveCParser.RULE_initializerList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1822)
            try initializer()
            setState(1827)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 234, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1823)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1824)
                    try initializer()

                }
                setState(1829)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 234, _ctx)
            }
            setState(1831)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1830)
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
        try enterRule(_localctx, 296, ObjectiveCParser.RULE_staticAssertDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1833)
            try match(ObjectiveCParser.Tokens.STATIC_ASSERT_.rawValue)
            setState(1834)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1835)
            try constantExpression()
            setState(1836)
            try match(ObjectiveCParser.Tokens.COMMA.rawValue)
            setState(1838)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1837)
                try stringLiteral()

                setState(1840)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
            setState(1842)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1843)
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
        try enterRule(_localctx, 298, ObjectiveCParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(1883)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 244, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1845)
                try labeledStatement()
                setState(1847)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 237, _ctx) {
                case 1:
                    setState(1846)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1849)
                try compoundStatement()
                setState(1851)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 238, _ctx) {
                case 1:
                    setState(1850)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1853)
                try selectionStatement()
                setState(1855)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 239, _ctx) {
                case 1:
                    setState(1854)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1857)
                try iterationStatement()
                setState(1859)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 240, _ctx) {
                case 1:
                    setState(1858)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1861)
                try jumpStatement()
                setState(1862)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1864)
                try synchronizedStatement()
                setState(1866)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 241, _ctx) {
                case 1:
                    setState(1865)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1868)
                try autoreleaseStatement()
                setState(1870)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 242, _ctx) {
                case 1:
                    setState(1869)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1872)
                try throwStatement()
                setState(1873)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(1875)
                try tryBlock()
                setState(1877)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 243, _ctx) {
                case 1:
                    setState(1876)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(1879)
                try expressions()
                setState(1880)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(1882)
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
        try enterRule(_localctx, 300, ObjectiveCParser.RULE_labeledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1885)
            try identifier()
            setState(1886)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(1887)
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
        try enterRule(_localctx, 302, ObjectiveCParser.RULE_rangeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1889)
            try expression(0)
            setState(1892)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue {
                setState(1890)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
                setState(1891)
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
        try enterRule(_localctx, 304, ObjectiveCParser.RULE_compoundStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1894)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1899)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64((_la - 1)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 1)) & -8_070_450_669_686_882_885) != 0
                || (Int64((_la - 71)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 71)) & 9_223_371_540_114_963_841) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & -72_045_533_666_825_201) != 0
            {
                setState(1897)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 246, _ctx) {
                case 1:
                    setState(1895)
                    try statement()

                    break
                case 2:
                    setState(1896)
                    try declaration()

                    break
                default: break
                }

                setState(1901)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1902)
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
        try enterRule(_localctx, 306, ObjectiveCParser.RULE_selectionStatement)
        defer { try! exitRule() }
        do {
            setState(1914)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IF:
                try enterOuterAlt(_localctx, 1)
                setState(1904)
                try match(ObjectiveCParser.Tokens.IF.rawValue)
                setState(1905)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1906)
                try expressions()
                setState(1907)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1908)
                try {
                    let assignmentValue = try statement()
                    _localctx.castdown(SelectionStatementContext.self).ifBody = assignmentValue
                }()

                setState(1911)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 248, _ctx) {
                case 1:
                    setState(1909)
                    try match(ObjectiveCParser.Tokens.ELSE.rawValue)
                    setState(1910)
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
                setState(1913)
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
        try enterRule(_localctx, 308, ObjectiveCParser.RULE_switchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1916)
            try match(ObjectiveCParser.Tokens.SWITCH.rawValue)
            setState(1917)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1918)
            try expression(0)
            setState(1919)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1920)
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
        try enterRule(_localctx, 310, ObjectiveCParser.RULE_switchBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1922)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1926)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            {
                setState(1923)
                try switchSection()

                setState(1928)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1929)
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
        try enterRule(_localctx, 312, ObjectiveCParser.RULE_switchSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1932)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1931)
                try switchLabel()

                setState(1934)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            setState(1937)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1936)
                try statement()

                setState(1939)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64((_la - 2)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 2)) & 5_188_146_087_907_586_129) != 0
                || (Int64((_la - 71)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 71)) & 9_214_365_937_126_374_785) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 4_593_674_635_010_681_603) != 0

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
        try enterRule(_localctx, 314, ObjectiveCParser.RULE_switchLabel)
        defer { try! exitRule() }
        do {
            setState(1953)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CASE:
                try enterOuterAlt(_localctx, 1)
                setState(1941)
                try match(ObjectiveCParser.Tokens.CASE.rawValue)
                setState(1947)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 253, _ctx) {
                case 1:
                    setState(1942)
                    try rangeExpression()

                    break
                case 2:
                    setState(1943)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(1944)
                    try rangeExpression()
                    setState(1945)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }
                setState(1949)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 2)
                setState(1951)
                try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)
                setState(1952)
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
        try enterRule(_localctx, 316, ObjectiveCParser.RULE_iterationStatement)
        defer { try! exitRule() }
        do {
            setState(1959)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 255, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1955)
                try whileStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1956)
                try doStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1957)
                try forStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1958)
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
        try enterRule(_localctx, 318, ObjectiveCParser.RULE_whileStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1961)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1962)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1963)
            try expression(0)
            setState(1964)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1965)
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
        try enterRule(_localctx, 320, ObjectiveCParser.RULE_doStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1967)
            try match(ObjectiveCParser.Tokens.DO.rawValue)
            setState(1968)
            try statement()
            setState(1969)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1970)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1971)
            try expression(0)
            setState(1972)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1973)
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
        try enterRule(_localctx, 322, ObjectiveCParser.RULE_forStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1975)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1976)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1978)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 1)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 1)) & -8_646_911_430_716_613_351) != 0
                || (Int64((_la - 71)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 71)) & 9_223_090_065_138_249_857) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & -72_045_533_666_964_465) != 0
            {
                setState(1977)
                try forLoopInitializer()

            }

            setState(1980)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1982)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1981)
                try expression(0)

            }

            setState(1984)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1986)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1985)
                try expressions()

            }

            setState(1988)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1989)
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
        try enterRule(_localctx, 324, ObjectiveCParser.RULE_forLoopInitializer)
        defer { try! exitRule() }
        do {
            setState(1995)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 259, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1991)
                try declarationSpecifiers()
                setState(1992)
                try initDeclaratorList()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1994)
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
        try enterRule(_localctx, 326, ObjectiveCParser.RULE_forInStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1997)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1998)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1999)
            try typeVariableDeclarator()
            setState(2000)
            try match(ObjectiveCParser.Tokens.IN.rawValue)
            setState(2002)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(2001)
                try expression(0)

            }

            setState(2004)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(2005)
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
        try enterRule(_localctx, 328, ObjectiveCParser.RULE_jumpStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2015)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .GOTO:
                try enterOuterAlt(_localctx, 1)
                setState(2007)
                try match(ObjectiveCParser.Tokens.GOTO.rawValue)
                setState(2008)
                try identifier()

                break

            case .CONTINUE:
                try enterOuterAlt(_localctx, 2)
                setState(2009)
                try match(ObjectiveCParser.Tokens.CONTINUE.rawValue)

                break

            case .BREAK:
                try enterOuterAlt(_localctx, 3)
                setState(2010)
                try match(ObjectiveCParser.Tokens.BREAK.rawValue)

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 4)
                setState(2011)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)
                setState(2013)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(2012)
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
        try enterRule(_localctx, 330, ObjectiveCParser.RULE_expressions)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2017)
            try expression(0)
            setState(2022)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 263, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2018)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(2019)
                    try expression(0)

                }
                setState(2024)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 263, _ctx)
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
        let _startState: Int = 332
        try enterRecursionRule(_localctx, 332, ObjectiveCParser.RULE_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2032)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 264, _ctx) {
            case 1:
                setState(2026)
                try castExpression()

                break
            case 2:
                setState(2027)
                try assignmentExpression()

                break
            case 3:
                setState(2028)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2029)
                try compoundStatement()
                setState(2030)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(2078)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 268, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(2076)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 267, _ctx) {
                    case 1:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2034)
                        if !(precpred(_ctx, 13)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 13)"))
                        }
                        setState(2035)
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
                        setState(2036)
                        try expression(14)

                        break
                    case 2:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2037)
                        if !(precpred(_ctx, 12)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 12)"))
                        }
                        setState(2038)
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
                        setState(2039)
                        try expression(13)

                        break
                    case 3:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2040)
                        if !(precpred(_ctx, 11)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 11)"))
                        }
                        setState(2045)
                        try _errHandler.sync(self)
                        switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                        case .LT:
                            setState(2041)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)
                            setState(2042)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)

                            break

                        case .GT:
                            setState(2043)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)
                            setState(2044)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)

                            break
                        default: throw ANTLRException.recognition(e: NoViableAltException(self))
                        }
                        setState(2047)
                        try expression(12)

                        break
                    case 4:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2048)
                        if !(precpred(_ctx, 10)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 10)"))
                        }
                        setState(2049)
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
                        setState(2050)
                        try expression(11)

                        break
                    case 5:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2051)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(2052)
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
                        setState(2053)
                        try expression(10)

                        break
                    case 6:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2054)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(2055)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITAND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2056)
                        try expression(9)

                        break
                    case 7:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2057)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(2058)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2059)
                        try expression(8)

                        break
                    case 8:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2060)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(2061)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2062)
                        try expression(7)

                        break
                    case 9:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2063)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(2064)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.AND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2065)
                        try expression(6)

                        break
                    case 10:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2066)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(2067)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.OR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2068)
                        try expression(5)

                        break
                    case 11:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2069)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(2070)
                        try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
                        setState(2072)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                            || (Int64((_la - 92)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                        {
                            setState(2071)
                            try {
                                let assignmentValue = try expression(0)
                                _localctx.castdown(ExpressionContext.self).trueExpression =
                                    assignmentValue
                            }()

                        }

                        setState(2074)
                        try match(ObjectiveCParser.Tokens.COLON.rawValue)
                        setState(2075)
                        try {
                            let assignmentValue = try expression(4)
                            _localctx.castdown(ExpressionContext.self).falseExpression =
                                assignmentValue
                        }()

                        break
                    default: break
                    }
                }
                setState(2080)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 268, _ctx)
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
        try enterRule(_localctx, 334, ObjectiveCParser.RULE_assignmentExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2081)
            try unaryExpression()
            setState(2082)
            try assignmentOperator()
            setState(2083)
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
        try enterRule(_localctx, 336, ObjectiveCParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2085)
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
        try enterRule(_localctx, 338, ObjectiveCParser.RULE_castExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2097)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 270, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2087)
                try unaryExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2089)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.EXTENSION.rawValue {
                    setState(2088)
                    try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)

                }

                setState(2091)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2092)
                try typeName()
                setState(2093)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(2094)
                try castExpression()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2096)
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
        try enterRule(_localctx, 340, ObjectiveCParser.RULE_initializer)
        defer { try! exitRule() }
        do {
            setState(2102)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 271, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2099)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2100)
                try arrayInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2101)
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
        try enterRule(_localctx, 342, ObjectiveCParser.RULE_constantExpression)
        defer { try! exitRule() }
        do {
            setState(2106)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(2104)
                try identifier()

                break
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                try enterOuterAlt(_localctx, 2)
                setState(2105)
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
        try enterRule(_localctx, 344, ObjectiveCParser.RULE_unaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2122)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 274, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2108)
                try postfixExpression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2109)
                try match(ObjectiveCParser.Tokens.SIZEOF.rawValue)
                setState(2115)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 273, _ctx) {
                case 1:
                    setState(2110)
                    try unaryExpression()

                    break
                case 2:
                    setState(2111)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(2112)
                    try typeSpecifier()
                    setState(2113)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2117)
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
                setState(2118)
                try unaryExpression()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2119)
                try unaryOperator()
                setState(2120)
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
        try enterRule(_localctx, 346, ObjectiveCParser.RULE_unaryOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2124)
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
        let _startState: Int = 348
        try enterRecursionRule(_localctx, 348, ObjectiveCParser.RULE_postfixExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2127)
            try primaryExpression()
            setState(2131)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 275, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2128)
                    try postfixExpr()

                }
                setState(2133)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 275, _ctx)
            }

            _ctx!.stop = try _input.LT(-1)
            setState(2145)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 277, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    _localctx = PostfixExpressionContext(_parentctx, _parentState)
                    try pushNewRecursionContext(
                        _localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
                    setState(2134)
                    if !(precpred(_ctx, 1)) {
                        throw ANTLRException.recognition(
                            e: FailedPredicateException(self, "precpred(_ctx, 1)"))
                    }
                    setState(2135)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.DOT.rawValue
                        || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }
                    setState(2136)
                    try identifier()
                    setState(2140)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 276, _ctx)
                    while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                        if _alt == 1 {
                            setState(2137)
                            try postfixExpr()

                        }
                        setState(2142)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 276, _ctx)
                    }

                }
                setState(2147)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 277, _ctx)
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
        try enterRule(_localctx, 350, ObjectiveCParser.RULE_postfixExpr)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2158)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(2148)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(2149)
                try expression(0)
                setState(2150)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(2152)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2154)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(2153)
                    try argumentExpressionList()

                }

                setState(2156)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case .INC, .DEC:
                try enterOuterAlt(_localctx, 3)
                setState(2157)
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
        try enterRule(_localctx, 352, ObjectiveCParser.RULE_argumentExpressionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2160)
            try argumentExpression()
            setState(2165)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(2161)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(2162)
                try argumentExpression()

                setState(2167)
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
        try enterRule(_localctx, 354, ObjectiveCParser.RULE_argumentExpression)
        defer { try! exitRule() }
        do {
            setState(2170)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 281, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2168)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2169)
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
        try enterRule(_localctx, 356, ObjectiveCParser.RULE_primaryExpression)
        defer { try! exitRule() }
        do {
            setState(2187)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 282, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2172)
                try identifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2173)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2174)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2175)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2176)
                try expression(0)
                setState(2177)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2179)
                try messageExpression()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2180)
                try selectorExpression()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2181)
                try protocolExpression()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2182)
                try encodeExpression()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2183)
                try dictionaryExpression()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2184)
                try arrayExpression()

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2185)
                try boxExpression()

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2186)
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
        try enterRule(_localctx, 358, ObjectiveCParser.RULE_constant)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2207)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 285, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2189)
                try match(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2190)
                try match(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2191)
                try match(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2193)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2192)
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

                setState(2195)
                try match(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2197)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2196)
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

                setState(2199)
                try match(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2200)
                try match(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue)

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2201)
                try match(ObjectiveCParser.Tokens.NIL.rawValue)

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2202)
                try match(ObjectiveCParser.Tokens.NULL.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2203)
                try match(ObjectiveCParser.Tokens.YES.rawValue)

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2204)
                try match(ObjectiveCParser.Tokens.NO.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2205)
                try match(ObjectiveCParser.Tokens.TRUE.rawValue)

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2206)
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
        try enterRule(_localctx, 360, ObjectiveCParser.RULE_stringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2217)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(2209)
                    try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
                    setState(2213)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                        || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
                    {
                        setState(2210)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                            || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }

                        setState(2215)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }
                    setState(2216)
                    try match(ObjectiveCParser.Tokens.STRING_END.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(2219)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 287, _ctx)
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
        open func COVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COVARIANT.rawValue, 0)
        }
        open func CONTRAVARIANT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.CONTRAVARIANT.rawValue, 0)
        }
        open func DEPRECATED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DEPRECATED.rawValue, 0)
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
        try enterRule(_localctx, 362, ObjectiveCParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2221)
            _la = try _input.LA(1)
            if !((Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0)
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
        case 90:
            return try directDeclarator_sempred(
                _localctx?.castdown(DirectDeclaratorContext.self), predIndex)
        case 95:
            return try directAbstractDeclarator_sempred(
                _localctx?.castdown(DirectAbstractDeclaratorContext.self), predIndex)
        case 166:
            return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
        case 174:
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
        4, 1, 248, 2224, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
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
        7, 178, 2, 179, 7, 179, 2, 180, 7, 180, 2, 181, 7, 181, 1, 0, 5, 0, 366, 8, 0, 10, 0, 12, 0,
        369, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1,
        383, 8, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 3, 3, 390, 8, 3, 1, 3, 1, 3, 1, 3, 3, 3, 395, 8, 3,
        1, 3, 3, 3, 398, 8, 3, 1, 3, 1, 3, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 406, 8, 4, 3, 4, 408, 8, 4,
        1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 414, 8, 4, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 420, 8, 5, 1, 5, 1,
        5, 1, 5, 1, 5, 1, 5, 3, 5, 427, 8, 5, 1, 5, 3, 5, 430, 8, 5, 1, 5, 3, 5, 433, 8, 5, 1, 5, 1,
        5, 1, 6, 1, 6, 1, 6, 3, 6, 440, 8, 6, 1, 6, 3, 6, 443, 8, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7,
        1, 7, 3, 7, 451, 8, 7, 3, 7, 453, 8, 7, 1, 8, 1, 8, 1, 8, 1, 8, 3, 8, 459, 8, 8, 1, 8, 1, 8,
        3, 8, 463, 8, 8, 1, 8, 1, 8, 1, 9, 1, 9, 3, 9, 469, 8, 9, 1, 10, 1, 10, 1, 11, 1, 11, 1, 11,
        1, 12, 1, 12, 1, 12, 1, 12, 5, 12, 480, 8, 12, 10, 12, 12, 12, 483, 9, 12, 3, 12, 485, 8,
        12, 1, 12, 1, 12, 1, 13, 5, 13, 490, 8, 13, 10, 13, 12, 13, 493, 9, 13, 1, 13, 1, 13, 1, 13,
        1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 504, 8, 14, 1, 14, 5, 14, 507, 8, 14, 10,
        14, 12, 14, 510, 9, 14, 1, 14, 1, 14, 1, 15, 1, 15, 5, 15, 516, 8, 15, 10, 15, 12, 15, 519,
        9, 15, 1, 15, 4, 15, 522, 8, 15, 11, 15, 12, 15, 523, 3, 15, 526, 8, 15, 1, 16, 1, 16, 1,
        16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17, 536, 8, 17, 10, 17, 12, 17, 539, 9, 17, 1, 17,
        1, 17, 1, 18, 1, 18, 1, 18, 1, 18, 1, 18, 3, 18, 548, 8, 18, 1, 19, 1, 19, 1, 19, 5, 19,
        553, 8, 19, 10, 19, 12, 19, 556, 9, 19, 1, 20, 1, 20, 1, 20, 1, 20, 1, 20, 3, 20, 563, 8,
        20, 1, 20, 3, 20, 566, 8, 20, 1, 20, 3, 20, 569, 8, 20, 1, 20, 1, 20, 1, 21, 1, 21, 1, 21,
        5, 21, 576, 8, 21, 10, 21, 12, 21, 579, 9, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1,
        22, 1, 22, 1, 22, 1, 22, 1, 22, 3, 22, 592, 8, 22, 1, 23, 1, 23, 1, 23, 1, 23, 1, 23, 3, 23,
        599, 8, 23, 1, 23, 3, 23, 602, 8, 23, 1, 24, 1, 24, 5, 24, 606, 8, 24, 10, 24, 12, 24, 609,
        9, 24, 1, 24, 1, 24, 1, 25, 1, 25, 5, 25, 615, 8, 25, 10, 25, 12, 25, 618, 9, 25, 1, 25, 4,
        25, 621, 8, 25, 11, 25, 12, 25, 622, 3, 25, 625, 8, 25, 1, 26, 1, 26, 1, 27, 1, 27, 1, 27,
        1, 27, 1, 27, 4, 27, 634, 8, 27, 11, 27, 12, 27, 635, 1, 28, 1, 28, 1, 28, 1, 29, 1, 29, 1,
        29, 1, 30, 3, 30, 645, 8, 30, 1, 30, 1, 30, 5, 30, 649, 8, 30, 10, 30, 12, 30, 652, 9, 30,
        1, 30, 3, 30, 655, 8, 30, 1, 30, 1, 30, 1, 31, 1, 31, 1, 31, 1, 31, 1, 31, 4, 31, 664, 8,
        31, 11, 31, 12, 31, 665, 1, 32, 1, 32, 1, 32, 1, 33, 1, 33, 1, 33, 1, 34, 3, 34, 675, 8, 34,
        1, 34, 1, 34, 3, 34, 679, 8, 34, 1, 34, 3, 34, 682, 8, 34, 1, 34, 3, 34, 685, 8, 34, 1, 34,
        1, 34, 3, 34, 689, 8, 34, 1, 35, 1, 35, 4, 35, 693, 8, 35, 11, 35, 12, 35, 694, 1, 35, 1,
        35, 3, 35, 699, 8, 35, 3, 35, 701, 8, 35, 1, 36, 3, 36, 704, 8, 36, 1, 36, 1, 36, 5, 36,
        708, 8, 36, 10, 36, 12, 36, 711, 9, 36, 1, 36, 3, 36, 714, 8, 36, 1, 36, 1, 36, 1, 37, 1,
        37, 1, 37, 1, 37, 1, 37, 1, 37, 3, 37, 724, 8, 37, 1, 38, 1, 38, 1, 38, 1, 38, 1, 39, 1, 39,
        1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 3, 39, 738, 8, 39, 1, 40, 1, 40, 1, 40, 5, 40,
        743, 8, 40, 10, 40, 12, 40, 746, 9, 40, 1, 41, 1, 41, 1, 41, 3, 41, 751, 8, 41, 1, 42, 1,
        42, 1, 42, 1, 42, 1, 42, 5, 42, 758, 8, 42, 10, 42, 12, 42, 761, 9, 42, 1, 42, 3, 42, 764,
        8, 42, 3, 42, 766, 8, 42, 1, 42, 1, 42, 1, 43, 1, 43, 1, 43, 1, 43, 1, 44, 1, 44, 1, 44, 1,
        44, 3, 44, 778, 8, 44, 3, 44, 780, 8, 44, 1, 44, 1, 44, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45,
        1, 45, 1, 45, 1, 45, 3, 45, 792, 8, 45, 3, 45, 794, 8, 45, 1, 46, 1, 46, 1, 46, 3, 46, 799,
        8, 46, 1, 46, 1, 46, 5, 46, 803, 8, 46, 10, 46, 12, 46, 806, 9, 46, 3, 46, 808, 8, 46, 1,
        46, 1, 46, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1,
        47, 1, 47, 1, 47, 1, 47, 3, 47, 827, 8, 47, 1, 48, 1, 48, 1, 48, 1, 48, 1, 48, 1, 49, 1, 49,
        3, 49, 836, 8, 49, 1, 50, 1, 50, 4, 50, 840, 8, 50, 11, 50, 12, 50, 841, 3, 50, 844, 8, 50,
        1, 51, 3, 51, 847, 8, 51, 1, 51, 1, 51, 1, 51, 1, 51, 5, 51, 853, 8, 51, 10, 51, 12, 51,
        856, 9, 51, 1, 52, 1, 52, 3, 52, 860, 8, 52, 1, 52, 1, 52, 1, 52, 1, 52, 3, 52, 866, 8, 52,
        1, 53, 1, 53, 1, 53, 1, 53, 1, 53, 1, 54, 1, 54, 3, 54, 875, 8, 54, 1, 54, 4, 54, 878, 8,
        54, 11, 54, 12, 54, 879, 3, 54, 882, 8, 54, 1, 55, 1, 55, 1, 55, 1, 55, 1, 55, 1, 56, 1, 56,
        1, 56, 1, 56, 1, 56, 1, 57, 1, 57, 1, 57, 1, 58, 1, 58, 1, 58, 1, 58, 1, 58, 1, 58, 1, 58,
        3, 58, 904, 8, 58, 1, 59, 1, 59, 1, 59, 5, 59, 909, 8, 59, 10, 59, 12, 59, 912, 9, 59, 1,
        59, 1, 59, 3, 59, 916, 8, 59, 1, 60, 1, 60, 1, 60, 1, 60, 1, 60, 1, 60, 1, 61, 1, 61, 1, 61,
        1, 61, 1, 61, 1, 61, 1, 62, 1, 62, 1, 62, 1, 63, 1, 63, 1, 63, 1, 64, 1, 64, 1, 64, 1, 65,
        3, 65, 940, 8, 65, 1, 65, 1, 65, 3, 65, 944, 8, 65, 1, 66, 4, 66, 947, 8, 66, 11, 66, 12,
        66, 948, 1, 67, 1, 67, 3, 67, 953, 8, 67, 1, 68, 1, 68, 3, 68, 957, 8, 68, 1, 69, 1, 69, 3,
        69, 961, 8, 69, 1, 69, 1, 69, 1, 70, 1, 70, 1, 70, 5, 70, 968, 8, 70, 10, 70, 12, 70, 971,
        9, 70, 1, 71, 1, 71, 1, 71, 1, 71, 3, 71, 977, 8, 71, 1, 72, 1, 72, 1, 72, 1, 72, 1, 72, 3,
        72, 984, 8, 72, 1, 73, 1, 73, 1, 73, 1, 73, 3, 73, 990, 8, 73, 1, 73, 1, 73, 1, 73, 3, 73,
        995, 8, 73, 1, 73, 1, 73, 1, 74, 1, 74, 1, 74, 3, 74, 1002, 8, 74, 1, 75, 1, 75, 1, 75, 5,
        75, 1007, 8, 75, 10, 75, 12, 75, 1010, 9, 75, 1, 76, 1, 76, 3, 76, 1014, 8, 76, 1, 76, 3,
        76, 1017, 8, 76, 1, 76, 3, 76, 1020, 8, 76, 1, 77, 3, 77, 1023, 8, 77, 1, 77, 1, 77, 3, 77,
        1027, 8, 77, 1, 77, 1, 77, 1, 77, 1, 77, 1, 77, 1, 78, 3, 78, 1035, 8, 78, 1, 78, 3, 78,
        1038, 8, 78, 1, 78, 1, 78, 3, 78, 1042, 8, 78, 1, 78, 1, 78, 1, 79, 1, 79, 1, 79, 1, 79, 3,
        79, 1050, 8, 79, 1, 79, 1, 79, 1, 80, 3, 80, 1055, 8, 80, 1, 80, 1, 80, 1, 80, 1, 80, 1, 80,
        3, 80, 1062, 8, 80, 1, 80, 3, 80, 1065, 8, 80, 1, 80, 1, 80, 1, 80, 3, 80, 1070, 8, 80, 1,
        80, 1, 80, 1, 80, 1, 80, 3, 80, 1076, 8, 80, 1, 81, 1, 81, 1, 81, 5, 81, 1081, 8, 81, 10,
        81, 12, 81, 1084, 9, 81, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 4, 82,
        1094, 8, 82, 11, 82, 12, 82, 1095, 1, 83, 1, 83, 1, 83, 1, 83, 1, 83, 1, 83, 1, 83, 1, 83,
        3, 83, 1106, 8, 83, 1, 84, 1, 84, 1, 84, 1, 84, 1, 84, 1, 84, 1, 84, 1, 84, 3, 84, 1116, 8,
        84, 1, 85, 3, 85, 1119, 8, 85, 1, 85, 4, 85, 1122, 8, 85, 11, 85, 12, 85, 1123, 1, 86, 1,
        86, 3, 86, 1128, 8, 86, 1, 86, 1, 86, 1, 86, 3, 86, 1133, 8, 86, 1, 87, 1, 87, 1, 87, 5, 87,
        1138, 8, 87, 10, 87, 12, 87, 1141, 9, 87, 1, 88, 1, 88, 1, 88, 3, 88, 1146, 8, 88, 1, 89, 3,
        89, 1149, 8, 89, 1, 89, 1, 89, 5, 89, 1153, 8, 89, 10, 89, 12, 89, 1156, 9, 89, 1, 90, 1,
        90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 5, 90, 1167, 8, 90, 10, 90, 12, 90,
        1170, 9, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1,
        90, 1, 90, 1, 90, 1, 90, 1, 90, 3, 90, 1188, 8, 90, 1, 90, 1, 90, 1, 90, 3, 90, 1193, 8, 90,
        1, 90, 3, 90, 1196, 8, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 3, 90, 1203, 8, 90, 1, 90, 1,
        90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 3, 90,
        1218, 8, 90, 1, 90, 1, 90, 1, 90, 1, 90, 1, 90, 3, 90, 1225, 8, 90, 1, 90, 5, 90, 1228, 8,
        90, 10, 90, 12, 90, 1231, 9, 90, 1, 91, 1, 91, 1, 91, 1, 91, 3, 91, 1237, 8, 91, 1, 92, 1,
        92, 3, 92, 1241, 8, 92, 1, 93, 1, 93, 3, 93, 1245, 8, 93, 1, 93, 1, 93, 3, 93, 1249, 8, 93,
        1, 93, 1, 93, 4, 93, 1253, 8, 93, 11, 93, 12, 93, 1254, 1, 93, 1, 93, 3, 93, 1259, 8, 93, 1,
        93, 4, 93, 1262, 8, 93, 11, 93, 12, 93, 1263, 3, 93, 1266, 8, 93, 1, 94, 1, 94, 3, 94, 1270,
        8, 94, 1, 94, 1, 94, 5, 94, 1274, 8, 94, 10, 94, 12, 94, 1277, 9, 94, 3, 94, 1279, 8, 94, 1,
        95, 1, 95, 1, 95, 1, 95, 1, 95, 5, 95, 1286, 8, 95, 10, 95, 12, 95, 1289, 9, 95, 1, 95, 1,
        95, 3, 95, 1293, 8, 95, 1, 95, 3, 95, 1296, 8, 95, 1, 95, 1, 95, 1, 95, 1, 95, 3, 95, 1302,
        8, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95,
        1, 95, 1, 95, 3, 95, 1318, 8, 95, 1, 95, 1, 95, 5, 95, 1322, 8, 95, 10, 95, 12, 95, 1325, 9,
        95, 1, 95, 1, 95, 1, 95, 5, 95, 1330, 8, 95, 10, 95, 12, 95, 1333, 9, 95, 1, 95, 3, 95,
        1336, 8, 95, 1, 95, 1, 95, 3, 95, 1340, 8, 95, 1, 95, 1, 95, 1, 95, 3, 95, 1345, 8, 95, 1,
        95, 3, 95, 1348, 8, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 3, 95, 1355, 8, 95, 1, 95, 1, 95,
        1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95, 1, 95,
        1, 95, 1, 95, 3, 95, 1374, 8, 95, 1, 95, 1, 95, 5, 95, 1378, 8, 95, 10, 95, 12, 95, 1381, 9,
        95, 5, 95, 1383, 8, 95, 10, 95, 12, 95, 1386, 9, 95, 1, 96, 1, 96, 3, 96, 1390, 8, 96, 1,
        96, 1, 96, 1, 96, 3, 96, 1395, 8, 96, 1, 96, 3, 96, 1398, 8, 96, 1, 97, 1, 97, 1, 97, 3, 97,
        1403, 8, 97, 1, 98, 1, 98, 1, 98, 5, 98, 1408, 8, 98, 10, 98, 12, 98, 1411, 9, 98, 1, 99, 1,
        99, 1, 99, 5, 99, 1416, 8, 99, 10, 99, 12, 99, 1419, 9, 99, 1, 100, 1, 100, 1, 100, 1, 100,
        1, 100, 3, 100, 1426, 8, 100, 3, 100, 1428, 8, 100, 1, 101, 4, 101, 1431, 8, 101, 11, 101,
        12, 101, 1432, 1, 102, 1, 102, 1, 102, 5, 102, 1438, 8, 102, 10, 102, 12, 102, 1441, 9, 102,
        1, 103, 1, 103, 3, 103, 1445, 8, 103, 1, 103, 1, 103, 1, 104, 1, 104, 1, 104, 1, 104, 1,
        104, 1, 104, 5, 104, 1455, 8, 104, 10, 104, 12, 104, 1458, 9, 104, 1, 104, 1, 104, 1, 104,
        1, 105, 1, 105, 1, 105, 1, 105, 1, 105, 1, 106, 1, 106, 1, 106, 3, 106, 1471, 8, 106, 1,
        106, 1, 106, 1, 107, 1, 107, 5, 107, 1477, 8, 107, 10, 107, 12, 107, 1480, 9, 107, 1, 107,
        3, 107, 1483, 8, 107, 1, 107, 1, 107, 1, 107, 1, 107, 1, 107, 1, 107, 5, 107, 1491, 8, 107,
        10, 107, 12, 107, 1494, 9, 107, 1, 107, 1, 107, 3, 107, 1498, 8, 107, 1, 108, 1, 108, 1,
        109, 4, 109, 1503, 8, 109, 11, 109, 12, 109, 1504, 1, 110, 5, 110, 1508, 8, 110, 10, 110,
        12, 110, 1511, 9, 110, 1, 110, 1, 110, 1, 110, 1, 110, 1, 110, 5, 110, 1518, 8, 110, 10,
        110, 12, 110, 1521, 9, 110, 1, 110, 1, 110, 1, 110, 1, 110, 3, 110, 1527, 8, 110, 1, 111, 1,
        111, 3, 111, 1531, 8, 111, 1, 111, 3, 111, 1534, 8, 111, 1, 112, 1, 112, 3, 112, 1538, 8,
        112, 1, 112, 1, 112, 3, 112, 1542, 8, 112, 1, 112, 1, 112, 1, 112, 1, 112, 1, 112, 3, 112,
        1549, 8, 112, 1, 112, 1, 112, 1, 112, 1, 112, 3, 112, 1555, 8, 112, 1, 112, 1, 112, 1, 112,
        1, 112, 1, 112, 1, 112, 1, 112, 1, 112, 1, 112, 1, 112, 3, 112, 1567, 8, 112, 1, 113, 1,
        113, 1, 113, 5, 113, 1572, 8, 113, 10, 113, 12, 113, 1575, 9, 113, 1, 113, 3, 113, 1578, 8,
        113, 1, 114, 1, 114, 1, 114, 3, 114, 1583, 8, 114, 1, 115, 1, 115, 1, 116, 1, 116, 1, 116,
        1, 116, 1, 116, 1, 116, 3, 116, 1593, 8, 116, 1, 117, 1, 117, 1, 118, 1, 118, 1, 119, 1,
        119, 1, 120, 1, 120, 1, 121, 1, 121, 1, 121, 1, 121, 1, 121, 3, 121, 1608, 8, 121, 1, 122,
        1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 3, 122, 1617, 8, 122, 1, 123, 1, 123, 1,
        123, 1, 123, 3, 123, 1623, 8, 123, 1, 123, 1, 123, 1, 124, 1, 124, 1, 125, 1, 125, 3, 125,
        1631, 8, 125, 1, 125, 1, 125, 3, 125, 1635, 8, 125, 1, 125, 1, 125, 3, 125, 1639, 8, 125, 1,
        125, 1, 125, 3, 125, 1643, 8, 125, 1, 125, 1, 125, 3, 125, 1647, 8, 125, 1, 125, 1, 125, 3,
        125, 1651, 8, 125, 3, 125, 1653, 8, 125, 1, 126, 1, 126, 1, 126, 1, 126, 1, 126, 1, 126, 1,
        126, 1, 126, 1, 126, 1, 126, 1, 126, 3, 126, 1666, 8, 126, 1, 127, 1, 127, 1, 127, 1, 127,
        1, 127, 1, 128, 1, 128, 1, 129, 1, 129, 1, 129, 1, 130, 1, 130, 1, 130, 1, 130, 5, 130,
        1682, 8, 130, 10, 130, 12, 130, 1685, 9, 130, 3, 130, 1687, 8, 130, 1, 130, 1, 130, 1, 131,
        3, 131, 1692, 8, 131, 1, 131, 1, 131, 1, 132, 1, 132, 1, 133, 1, 133, 1, 133, 5, 133, 1701,
        8, 133, 10, 133, 12, 133, 1704, 9, 133, 1, 134, 1, 134, 3, 134, 1708, 8, 134, 1, 134, 1,
        134, 3, 134, 1712, 8, 134, 1, 135, 1, 135, 1, 136, 1, 136, 1, 136, 4, 136, 1719, 8, 136, 11,
        136, 12, 136, 1720, 1, 136, 1, 136, 1, 136, 3, 136, 1726, 8, 136, 1, 137, 1, 137, 1, 137, 1,
        137, 1, 137, 1, 137, 1, 137, 1, 138, 3, 138, 1736, 8, 138, 1, 138, 1, 138, 3, 138, 1740, 8,
        138, 5, 138, 1742, 8, 138, 10, 138, 12, 138, 1745, 9, 138, 1, 139, 1, 139, 1, 139, 3, 139,
        1750, 8, 139, 1, 139, 3, 139, 1753, 8, 139, 1, 140, 1, 140, 3, 140, 1757, 8, 140, 1, 140, 3,
        140, 1760, 8, 140, 1, 141, 4, 141, 1763, 8, 141, 11, 141, 12, 141, 1764, 1, 142, 1, 142, 3,
        142, 1769, 8, 142, 1, 142, 3, 142, 1772, 8, 142, 1, 143, 1, 143, 1, 143, 1, 143, 4, 143,
        1778, 8, 143, 11, 143, 12, 143, 1779, 1, 143, 3, 143, 1783, 8, 143, 1, 144, 1, 144, 1, 144,
        1, 144, 5, 144, 1789, 8, 144, 10, 144, 12, 144, 1792, 9, 144, 1, 144, 3, 144, 1795, 8, 144,
        3, 144, 1797, 8, 144, 1, 144, 1, 144, 1, 145, 1, 145, 1, 145, 1, 145, 5, 145, 1805, 8, 145,
        10, 145, 12, 145, 1808, 9, 145, 1, 145, 3, 145, 1811, 8, 145, 3, 145, 1813, 8, 145, 1, 145,
        1, 145, 1, 146, 1, 146, 1, 146, 1, 146, 3, 146, 1821, 8, 146, 1, 147, 1, 147, 1, 147, 5,
        147, 1826, 8, 147, 10, 147, 12, 147, 1829, 9, 147, 1, 147, 3, 147, 1832, 8, 147, 1, 148, 1,
        148, 1, 148, 1, 148, 1, 148, 4, 148, 1839, 8, 148, 11, 148, 12, 148, 1840, 1, 148, 1, 148,
        1, 148, 1, 149, 1, 149, 3, 149, 1848, 8, 149, 1, 149, 1, 149, 3, 149, 1852, 8, 149, 1, 149,
        1, 149, 3, 149, 1856, 8, 149, 1, 149, 1, 149, 3, 149, 1860, 8, 149, 1, 149, 1, 149, 1, 149,
        1, 149, 1, 149, 3, 149, 1867, 8, 149, 1, 149, 1, 149, 3, 149, 1871, 8, 149, 1, 149, 1, 149,
        1, 149, 1, 149, 1, 149, 3, 149, 1878, 8, 149, 1, 149, 1, 149, 1, 149, 1, 149, 3, 149, 1884,
        8, 149, 1, 150, 1, 150, 1, 150, 1, 150, 1, 151, 1, 151, 1, 151, 3, 151, 1893, 8, 151, 1,
        152, 1, 152, 1, 152, 5, 152, 1898, 8, 152, 10, 152, 12, 152, 1901, 9, 152, 1, 152, 1, 152,
        1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 1, 153, 3, 153, 1912, 8, 153, 1, 153, 3,
        153, 1915, 8, 153, 1, 154, 1, 154, 1, 154, 1, 154, 1, 154, 1, 154, 1, 155, 1, 155, 5, 155,
        1925, 8, 155, 10, 155, 12, 155, 1928, 9, 155, 1, 155, 1, 155, 1, 156, 4, 156, 1933, 8, 156,
        11, 156, 12, 156, 1934, 1, 156, 4, 156, 1938, 8, 156, 11, 156, 12, 156, 1939, 1, 157, 1,
        157, 1, 157, 1, 157, 1, 157, 1, 157, 3, 157, 1948, 8, 157, 1, 157, 1, 157, 1, 157, 1, 157,
        3, 157, 1954, 8, 157, 1, 158, 1, 158, 1, 158, 1, 158, 3, 158, 1960, 8, 158, 1, 159, 1, 159,
        1, 159, 1, 159, 1, 159, 1, 159, 1, 160, 1, 160, 1, 160, 1, 160, 1, 160, 1, 160, 1, 160, 1,
        160, 1, 161, 1, 161, 1, 161, 3, 161, 1979, 8, 161, 1, 161, 1, 161, 3, 161, 1983, 8, 161, 1,
        161, 1, 161, 3, 161, 1987, 8, 161, 1, 161, 1, 161, 1, 161, 1, 162, 1, 162, 1, 162, 1, 162,
        3, 162, 1996, 8, 162, 1, 163, 1, 163, 1, 163, 1, 163, 1, 163, 3, 163, 2003, 8, 163, 1, 163,
        1, 163, 1, 163, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 3, 164, 2014, 8, 164, 3,
        164, 2016, 8, 164, 1, 165, 1, 165, 1, 165, 5, 165, 2021, 8, 165, 10, 165, 12, 165, 2024, 9,
        165, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 3, 166, 2033, 8, 166, 1, 166,
        1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 3, 166,
        2046, 8, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1,
        166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166, 1, 166,
        1, 166, 1, 166, 1, 166, 1, 166, 3, 166, 2073, 8, 166, 1, 166, 1, 166, 5, 166, 2077, 8, 166,
        10, 166, 12, 166, 2080, 9, 166, 1, 167, 1, 167, 1, 167, 1, 167, 1, 168, 1, 168, 1, 169, 1,
        169, 3, 169, 2090, 8, 169, 1, 169, 1, 169, 1, 169, 1, 169, 1, 169, 1, 169, 3, 169, 2098, 8,
        169, 1, 170, 1, 170, 1, 170, 3, 170, 2103, 8, 170, 1, 171, 1, 171, 3, 171, 2107, 8, 171, 1,
        172, 1, 172, 1, 172, 1, 172, 1, 172, 1, 172, 1, 172, 3, 172, 2116, 8, 172, 1, 172, 1, 172,
        1, 172, 1, 172, 1, 172, 3, 172, 2123, 8, 172, 1, 173, 1, 173, 1, 174, 1, 174, 1, 174, 5,
        174, 2130, 8, 174, 10, 174, 12, 174, 2133, 9, 174, 1, 174, 1, 174, 1, 174, 1, 174, 5, 174,
        2139, 8, 174, 10, 174, 12, 174, 2142, 9, 174, 5, 174, 2144, 8, 174, 10, 174, 12, 174, 2147,
        9, 174, 1, 175, 1, 175, 1, 175, 1, 175, 1, 175, 1, 175, 3, 175, 2155, 8, 175, 1, 175, 1,
        175, 3, 175, 2159, 8, 175, 1, 176, 1, 176, 1, 176, 5, 176, 2164, 8, 176, 10, 176, 12, 176,
        2167, 9, 176, 1, 177, 1, 177, 3, 177, 2171, 8, 177, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178,
        1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 1, 178, 3, 178,
        2188, 8, 178, 1, 179, 1, 179, 1, 179, 1, 179, 3, 179, 2194, 8, 179, 1, 179, 1, 179, 3, 179,
        2198, 8, 179, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 3, 179, 2208,
        8, 179, 1, 180, 1, 180, 5, 180, 2212, 8, 180, 10, 180, 12, 180, 2215, 9, 180, 1, 180, 4,
        180, 2218, 8, 180, 11, 180, 12, 180, 2219, 1, 181, 1, 181, 1, 181, 0, 4, 180, 190, 332, 348,
        182, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44,
        46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90,
        92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128,
        130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160, 162, 164,
        166, 168, 170, 172, 174, 176, 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200,
        202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222, 224, 226, 228, 230, 232, 234, 236,
        238, 240, 242, 244, 246, 248, 250, 252, 254, 256, 258, 260, 262, 264, 266, 268, 270, 272,
        274, 276, 278, 280, 282, 284, 286, 288, 290, 292, 294, 296, 298, 300, 302, 304, 306, 308,
        310, 312, 314, 316, 318, 320, 322, 324, 326, 328, 330, 332, 334, 336, 338, 340, 342, 344,
        346, 348, 350, 352, 354, 356, 358, 360, 362, 0, 26, 2, 0, 72, 72, 77, 77, 1, 0, 92, 93, 3,
        0, 70, 70, 73, 73, 75, 76, 2, 0, 27, 27, 30, 30, 1, 0, 125, 126, 4, 0, 87, 87, 96, 96, 99,
        99, 101, 101, 1, 0, 120, 123, 7, 0, 1, 1, 12, 12, 20, 20, 26, 26, 29, 29, 41, 41, 118, 118,
        4, 0, 17, 17, 88, 91, 95, 95, 124, 124, 4, 0, 17, 17, 105, 105, 110, 110, 116, 116, 3, 0,
        44, 45, 48, 49, 53, 54, 1, 0, 112, 114, 8, 0, 4, 4, 9, 9, 13, 13, 18, 19, 23, 24, 31, 32,
        35, 37, 112, 114, 2, 0, 103, 105, 107, 109, 2, 0, 147, 148, 154, 154, 1, 0, 148, 148, 2, 0,
        175, 176, 180, 180, 1, 0, 173, 174, 2, 0, 159, 160, 166, 167, 2, 0, 165, 165, 168, 168, 2,
        0, 158, 158, 181, 190, 1, 0, 171, 172, 3, 0, 161, 162, 173, 175, 177, 177, 1, 0, 155, 156,
        2, 0, 205, 205, 207, 207, 7, 0, 42, 49, 53, 58, 83, 85, 92, 94, 124, 133, 138, 139, 146,
        146, 2457, 0, 367, 1, 0, 0, 0, 2, 382, 1, 0, 0, 0, 4, 384, 1, 0, 0, 0, 6, 389, 1, 0, 0, 0,
        8, 401, 1, 0, 0, 0, 10, 415, 1, 0, 0, 0, 12, 436, 1, 0, 0, 0, 14, 446, 1, 0, 0, 0, 16, 454,
        1, 0, 0, 0, 18, 466, 1, 0, 0, 0, 20, 470, 1, 0, 0, 0, 22, 472, 1, 0, 0, 0, 24, 475, 1, 0, 0,
        0, 26, 491, 1, 0, 0, 0, 28, 497, 1, 0, 0, 0, 30, 525, 1, 0, 0, 0, 32, 527, 1, 0, 0, 0, 34,
        531, 1, 0, 0, 0, 36, 542, 1, 0, 0, 0, 38, 549, 1, 0, 0, 0, 40, 557, 1, 0, 0, 0, 42, 572, 1,
        0, 0, 0, 44, 591, 1, 0, 0, 0, 46, 601, 1, 0, 0, 0, 48, 603, 1, 0, 0, 0, 50, 624, 1, 0, 0, 0,
        52, 626, 1, 0, 0, 0, 54, 633, 1, 0, 0, 0, 56, 637, 1, 0, 0, 0, 58, 640, 1, 0, 0, 0, 60, 644,
        1, 0, 0, 0, 62, 663, 1, 0, 0, 0, 64, 667, 1, 0, 0, 0, 66, 670, 1, 0, 0, 0, 68, 674, 1, 0, 0,
        0, 70, 700, 1, 0, 0, 0, 72, 703, 1, 0, 0, 0, 74, 723, 1, 0, 0, 0, 76, 725, 1, 0, 0, 0, 78,
        737, 1, 0, 0, 0, 80, 739, 1, 0, 0, 0, 82, 747, 1, 0, 0, 0, 84, 752, 1, 0, 0, 0, 86, 769, 1,
        0, 0, 0, 88, 773, 1, 0, 0, 0, 90, 793, 1, 0, 0, 0, 92, 795, 1, 0, 0, 0, 94, 826, 1, 0, 0, 0,
        96, 828, 1, 0, 0, 0, 98, 835, 1, 0, 0, 0, 100, 843, 1, 0, 0, 0, 102, 846, 1, 0, 0, 0, 104,
        857, 1, 0, 0, 0, 106, 867, 1, 0, 0, 0, 108, 881, 1, 0, 0, 0, 110, 883, 1, 0, 0, 0, 112, 888,
        1, 0, 0, 0, 114, 893, 1, 0, 0, 0, 116, 903, 1, 0, 0, 0, 118, 905, 1, 0, 0, 0, 120, 917, 1,
        0, 0, 0, 122, 923, 1, 0, 0, 0, 124, 929, 1, 0, 0, 0, 126, 932, 1, 0, 0, 0, 128, 935, 1, 0,
        0, 0, 130, 939, 1, 0, 0, 0, 132, 946, 1, 0, 0, 0, 134, 950, 1, 0, 0, 0, 136, 956, 1, 0, 0,
        0, 138, 958, 1, 0, 0, 0, 140, 964, 1, 0, 0, 0, 142, 976, 1, 0, 0, 0, 144, 978, 1, 0, 0, 0,
        146, 985, 1, 0, 0, 0, 148, 998, 1, 0, 0, 0, 150, 1003, 1, 0, 0, 0, 152, 1019, 1, 0, 0, 0,
        154, 1022, 1, 0, 0, 0, 156, 1034, 1, 0, 0, 0, 158, 1049, 1, 0, 0, 0, 160, 1075, 1, 0, 0, 0,
        162, 1077, 1, 0, 0, 0, 164, 1093, 1, 0, 0, 0, 166, 1105, 1, 0, 0, 0, 168, 1115, 1, 0, 0, 0,
        170, 1118, 1, 0, 0, 0, 172, 1132, 1, 0, 0, 0, 174, 1134, 1, 0, 0, 0, 176, 1142, 1, 0, 0, 0,
        178, 1148, 1, 0, 0, 0, 180, 1187, 1, 0, 0, 0, 182, 1236, 1, 0, 0, 0, 184, 1238, 1, 0, 0, 0,
        186, 1265, 1, 0, 0, 0, 188, 1278, 1, 0, 0, 0, 190, 1339, 1, 0, 0, 0, 192, 1397, 1, 0, 0, 0,
        194, 1399, 1, 0, 0, 0, 196, 1404, 1, 0, 0, 0, 198, 1412, 1, 0, 0, 0, 200, 1427, 1, 0, 0, 0,
        202, 1430, 1, 0, 0, 0, 204, 1434, 1, 0, 0, 0, 206, 1442, 1, 0, 0, 0, 208, 1448, 1, 0, 0, 0,
        210, 1462, 1, 0, 0, 0, 212, 1467, 1, 0, 0, 0, 214, 1497, 1, 0, 0, 0, 216, 1499, 1, 0, 0, 0,
        218, 1502, 1, 0, 0, 0, 220, 1526, 1, 0, 0, 0, 222, 1530, 1, 0, 0, 0, 224, 1566, 1, 0, 0, 0,
        226, 1568, 1, 0, 0, 0, 228, 1579, 1, 0, 0, 0, 230, 1584, 1, 0, 0, 0, 232, 1592, 1, 0, 0, 0,
        234, 1594, 1, 0, 0, 0, 236, 1596, 1, 0, 0, 0, 238, 1598, 1, 0, 0, 0, 240, 1600, 1, 0, 0, 0,
        242, 1607, 1, 0, 0, 0, 244, 1616, 1, 0, 0, 0, 246, 1618, 1, 0, 0, 0, 248, 1626, 1, 0, 0, 0,
        250, 1652, 1, 0, 0, 0, 252, 1665, 1, 0, 0, 0, 254, 1667, 1, 0, 0, 0, 256, 1672, 1, 0, 0, 0,
        258, 1674, 1, 0, 0, 0, 260, 1677, 1, 0, 0, 0, 262, 1691, 1, 0, 0, 0, 264, 1695, 1, 0, 0, 0,
        266, 1697, 1, 0, 0, 0, 268, 1711, 1, 0, 0, 0, 270, 1713, 1, 0, 0, 0, 272, 1725, 1, 0, 0, 0,
        274, 1727, 1, 0, 0, 0, 276, 1735, 1, 0, 0, 0, 278, 1746, 1, 0, 0, 0, 280, 1754, 1, 0, 0, 0,
        282, 1762, 1, 0, 0, 0, 284, 1766, 1, 0, 0, 0, 286, 1773, 1, 0, 0, 0, 288, 1784, 1, 0, 0, 0,
        290, 1800, 1, 0, 0, 0, 292, 1820, 1, 0, 0, 0, 294, 1822, 1, 0, 0, 0, 296, 1833, 1, 0, 0, 0,
        298, 1883, 1, 0, 0, 0, 300, 1885, 1, 0, 0, 0, 302, 1889, 1, 0, 0, 0, 304, 1894, 1, 0, 0, 0,
        306, 1914, 1, 0, 0, 0, 308, 1916, 1, 0, 0, 0, 310, 1922, 1, 0, 0, 0, 312, 1932, 1, 0, 0, 0,
        314, 1953, 1, 0, 0, 0, 316, 1959, 1, 0, 0, 0, 318, 1961, 1, 0, 0, 0, 320, 1967, 1, 0, 0, 0,
        322, 1975, 1, 0, 0, 0, 324, 1995, 1, 0, 0, 0, 326, 1997, 1, 0, 0, 0, 328, 2015, 1, 0, 0, 0,
        330, 2017, 1, 0, 0, 0, 332, 2032, 1, 0, 0, 0, 334, 2081, 1, 0, 0, 0, 336, 2085, 1, 0, 0, 0,
        338, 2097, 1, 0, 0, 0, 340, 2102, 1, 0, 0, 0, 342, 2106, 1, 0, 0, 0, 344, 2122, 1, 0, 0, 0,
        346, 2124, 1, 0, 0, 0, 348, 2126, 1, 0, 0, 0, 350, 2158, 1, 0, 0, 0, 352, 2160, 1, 0, 0, 0,
        354, 2170, 1, 0, 0, 0, 356, 2187, 1, 0, 0, 0, 358, 2207, 1, 0, 0, 0, 360, 2217, 1, 0, 0, 0,
        362, 2221, 1, 0, 0, 0, 364, 366, 3, 2, 1, 0, 365, 364, 1, 0, 0, 0, 366, 369, 1, 0, 0, 0,
        367, 365, 1, 0, 0, 0, 367, 368, 1, 0, 0, 0, 368, 370, 1, 0, 0, 0, 369, 367, 1, 0, 0, 0, 370,
        371, 5, 0, 0, 1, 371, 1, 1, 0, 0, 0, 372, 383, 3, 4, 2, 0, 373, 383, 3, 172, 86, 0, 374,
        383, 3, 6, 3, 0, 375, 383, 3, 12, 6, 0, 376, 383, 3, 10, 5, 0, 377, 383, 3, 16, 8, 0, 378,
        383, 3, 28, 14, 0, 379, 383, 3, 32, 16, 0, 380, 383, 3, 34, 17, 0, 381, 383, 3, 128, 64, 0,
        382, 372, 1, 0, 0, 0, 382, 373, 1, 0, 0, 0, 382, 374, 1, 0, 0, 0, 382, 375, 1, 0, 0, 0, 382,
        376, 1, 0, 0, 0, 382, 377, 1, 0, 0, 0, 382, 378, 1, 0, 0, 0, 382, 379, 1, 0, 0, 0, 382, 380,
        1, 0, 0, 0, 382, 381, 1, 0, 0, 0, 383, 3, 1, 0, 0, 0, 384, 385, 5, 69, 0, 0, 385, 386, 3,
        362, 181, 0, 386, 387, 5, 153, 0, 0, 387, 5, 1, 0, 0, 0, 388, 390, 5, 139, 0, 0, 389, 388,
        1, 0, 0, 0, 389, 390, 1, 0, 0, 0, 390, 391, 1, 0, 0, 0, 391, 392, 5, 68, 0, 0, 392, 394, 3,
        8, 4, 0, 393, 395, 3, 48, 24, 0, 394, 393, 1, 0, 0, 0, 394, 395, 1, 0, 0, 0, 395, 397, 1, 0,
        0, 0, 396, 398, 3, 54, 27, 0, 397, 396, 1, 0, 0, 0, 397, 398, 1, 0, 0, 0, 398, 399, 1, 0, 0,
        0, 399, 400, 5, 65, 0, 0, 400, 7, 1, 0, 0, 0, 401, 407, 3, 18, 9, 0, 402, 403, 5, 164, 0, 0,
        403, 405, 3, 20, 10, 0, 404, 406, 3, 24, 12, 0, 405, 404, 1, 0, 0, 0, 405, 406, 1, 0, 0, 0,
        406, 408, 1, 0, 0, 0, 407, 402, 1, 0, 0, 0, 407, 408, 1, 0, 0, 0, 408, 413, 1, 0, 0, 0, 409,
        410, 5, 160, 0, 0, 410, 411, 3, 38, 19, 0, 411, 412, 5, 159, 0, 0, 412, 414, 1, 0, 0, 0,
        413, 409, 1, 0, 0, 0, 413, 414, 1, 0, 0, 0, 414, 9, 1, 0, 0, 0, 415, 416, 5, 68, 0, 0, 416,
        417, 3, 18, 9, 0, 417, 419, 5, 147, 0, 0, 418, 420, 3, 362, 181, 0, 419, 418, 1, 0, 0, 0,
        419, 420, 1, 0, 0, 0, 420, 421, 1, 0, 0, 0, 421, 426, 5, 148, 0, 0, 422, 423, 5, 160, 0, 0,
        423, 424, 3, 38, 19, 0, 424, 425, 5, 159, 0, 0, 425, 427, 1, 0, 0, 0, 426, 422, 1, 0, 0, 0,
        426, 427, 1, 0, 0, 0, 427, 429, 1, 0, 0, 0, 428, 430, 3, 48, 24, 0, 429, 428, 1, 0, 0, 0,
        429, 430, 1, 0, 0, 0, 430, 432, 1, 0, 0, 0, 431, 433, 3, 54, 27, 0, 432, 431, 1, 0, 0, 0,
        432, 433, 1, 0, 0, 0, 433, 434, 1, 0, 0, 0, 434, 435, 5, 65, 0, 0, 435, 11, 1, 0, 0, 0, 436,
        437, 5, 67, 0, 0, 437, 439, 3, 14, 7, 0, 438, 440, 3, 48, 24, 0, 439, 438, 1, 0, 0, 0, 439,
        440, 1, 0, 0, 0, 440, 442, 1, 0, 0, 0, 441, 443, 3, 62, 31, 0, 442, 441, 1, 0, 0, 0, 442,
        443, 1, 0, 0, 0, 443, 444, 1, 0, 0, 0, 444, 445, 5, 65, 0, 0, 445, 13, 1, 0, 0, 0, 446, 452,
        3, 18, 9, 0, 447, 448, 5, 164, 0, 0, 448, 450, 3, 20, 10, 0, 449, 451, 3, 24, 12, 0, 450,
        449, 1, 0, 0, 0, 450, 451, 1, 0, 0, 0, 451, 453, 1, 0, 0, 0, 452, 447, 1, 0, 0, 0, 452, 453,
        1, 0, 0, 0, 453, 15, 1, 0, 0, 0, 454, 455, 5, 67, 0, 0, 455, 456, 3, 18, 9, 0, 456, 458, 5,
        147, 0, 0, 457, 459, 3, 362, 181, 0, 458, 457, 1, 0, 0, 0, 458, 459, 1, 0, 0, 0, 459, 460,
        1, 0, 0, 0, 460, 462, 5, 148, 0, 0, 461, 463, 3, 62, 31, 0, 462, 461, 1, 0, 0, 0, 462, 463,
        1, 0, 0, 0, 463, 464, 1, 0, 0, 0, 464, 465, 5, 65, 0, 0, 465, 17, 1, 0, 0, 0, 466, 468, 3,
        362, 181, 0, 467, 469, 3, 24, 12, 0, 468, 467, 1, 0, 0, 0, 468, 469, 1, 0, 0, 0, 469, 19, 1,
        0, 0, 0, 470, 471, 3, 362, 181, 0, 471, 21, 1, 0, 0, 0, 472, 473, 3, 362, 181, 0, 473, 474,
        3, 24, 12, 0, 474, 23, 1, 0, 0, 0, 475, 484, 5, 160, 0, 0, 476, 481, 3, 26, 13, 0, 477, 478,
        5, 154, 0, 0, 478, 480, 3, 26, 13, 0, 479, 477, 1, 0, 0, 0, 480, 483, 1, 0, 0, 0, 481, 479,
        1, 0, 0, 0, 481, 482, 1, 0, 0, 0, 482, 485, 1, 0, 0, 0, 483, 481, 1, 0, 0, 0, 484, 476, 1,
        0, 0, 0, 484, 485, 1, 0, 0, 0, 485, 486, 1, 0, 0, 0, 486, 487, 5, 159, 0, 0, 487, 25, 1, 0,
        0, 0, 488, 490, 3, 240, 120, 0, 489, 488, 1, 0, 0, 0, 490, 493, 1, 0, 0, 0, 491, 489, 1, 0,
        0, 0, 491, 492, 1, 0, 0, 0, 492, 494, 1, 0, 0, 0, 493, 491, 1, 0, 0, 0, 494, 495, 3, 252,
        126, 0, 495, 496, 3, 282, 141, 0, 496, 27, 1, 0, 0, 0, 497, 498, 5, 71, 0, 0, 498, 503, 3,
        46, 23, 0, 499, 500, 5, 160, 0, 0, 500, 501, 3, 38, 19, 0, 501, 502, 5, 159, 0, 0, 502, 504,
        1, 0, 0, 0, 503, 499, 1, 0, 0, 0, 503, 504, 1, 0, 0, 0, 504, 508, 1, 0, 0, 0, 505, 507, 3,
        30, 15, 0, 506, 505, 1, 0, 0, 0, 507, 510, 1, 0, 0, 0, 508, 506, 1, 0, 0, 0, 508, 509, 1, 0,
        0, 0, 509, 511, 1, 0, 0, 0, 510, 508, 1, 0, 0, 0, 511, 512, 5, 65, 0, 0, 512, 29, 1, 0, 0,
        0, 513, 517, 7, 0, 0, 0, 514, 516, 3, 54, 27, 0, 515, 514, 1, 0, 0, 0, 516, 519, 1, 0, 0, 0,
        517, 515, 1, 0, 0, 0, 517, 518, 1, 0, 0, 0, 518, 526, 1, 0, 0, 0, 519, 517, 1, 0, 0, 0, 520,
        522, 3, 54, 27, 0, 521, 520, 1, 0, 0, 0, 522, 523, 1, 0, 0, 0, 523, 521, 1, 0, 0, 0, 523,
        524, 1, 0, 0, 0, 524, 526, 1, 0, 0, 0, 525, 513, 1, 0, 0, 0, 525, 521, 1, 0, 0, 0, 526, 31,
        1, 0, 0, 0, 527, 528, 5, 71, 0, 0, 528, 529, 3, 38, 19, 0, 529, 530, 5, 153, 0, 0, 530, 33,
        1, 0, 0, 0, 531, 532, 5, 62, 0, 0, 532, 537, 3, 36, 18, 0, 533, 534, 5, 154, 0, 0, 534, 536,
        3, 36, 18, 0, 535, 533, 1, 0, 0, 0, 536, 539, 1, 0, 0, 0, 537, 535, 1, 0, 0, 0, 537, 538, 1,
        0, 0, 0, 538, 540, 1, 0, 0, 0, 539, 537, 1, 0, 0, 0, 540, 541, 5, 153, 0, 0, 541, 35, 1, 0,
        0, 0, 542, 547, 3, 18, 9, 0, 543, 544, 5, 160, 0, 0, 544, 545, 3, 38, 19, 0, 545, 546, 5,
        159, 0, 0, 546, 548, 1, 0, 0, 0, 547, 543, 1, 0, 0, 0, 547, 548, 1, 0, 0, 0, 548, 37, 1, 0,
        0, 0, 549, 554, 3, 46, 23, 0, 550, 551, 5, 154, 0, 0, 551, 553, 3, 46, 23, 0, 552, 550, 1,
        0, 0, 0, 553, 556, 1, 0, 0, 0, 554, 552, 1, 0, 0, 0, 554, 555, 1, 0, 0, 0, 555, 39, 1, 0, 0,
        0, 556, 554, 1, 0, 0, 0, 557, 562, 5, 74, 0, 0, 558, 559, 5, 147, 0, 0, 559, 560, 3, 42, 21,
        0, 560, 561, 5, 148, 0, 0, 561, 563, 1, 0, 0, 0, 562, 558, 1, 0, 0, 0, 562, 563, 1, 0, 0, 0,
        563, 565, 1, 0, 0, 0, 564, 566, 3, 232, 116, 0, 565, 564, 1, 0, 0, 0, 565, 566, 1, 0, 0, 0,
        566, 568, 1, 0, 0, 0, 567, 569, 5, 138, 0, 0, 568, 567, 1, 0, 0, 0, 568, 569, 1, 0, 0, 0,
        569, 570, 1, 0, 0, 0, 570, 571, 3, 212, 106, 0, 571, 41, 1, 0, 0, 0, 572, 577, 3, 44, 22, 0,
        573, 574, 5, 154, 0, 0, 574, 576, 3, 44, 22, 0, 575, 573, 1, 0, 0, 0, 576, 579, 1, 0, 0, 0,
        577, 575, 1, 0, 0, 0, 577, 578, 1, 0, 0, 0, 578, 43, 1, 0, 0, 0, 579, 577, 1, 0, 0, 0, 580,
        592, 5, 134, 0, 0, 581, 592, 5, 135, 0, 0, 582, 592, 5, 128, 0, 0, 583, 584, 5, 129, 0, 0,
        584, 585, 5, 158, 0, 0, 585, 592, 3, 108, 54, 0, 586, 587, 5, 130, 0, 0, 587, 588, 5, 158,
        0, 0, 588, 592, 3, 108, 54, 0, 589, 592, 3, 236, 118, 0, 590, 592, 3, 362, 181, 0, 591, 580,
        1, 0, 0, 0, 591, 581, 1, 0, 0, 0, 591, 582, 1, 0, 0, 0, 591, 583, 1, 0, 0, 0, 591, 586, 1,
        0, 0, 0, 591, 589, 1, 0, 0, 0, 591, 590, 1, 0, 0, 0, 592, 45, 1, 0, 0, 0, 593, 594, 5, 160,
        0, 0, 594, 595, 3, 38, 19, 0, 595, 596, 5, 159, 0, 0, 596, 602, 1, 0, 0, 0, 597, 599, 7, 1,
        0, 0, 598, 597, 1, 0, 0, 0, 598, 599, 1, 0, 0, 0, 599, 600, 1, 0, 0, 0, 600, 602, 3, 362,
        181, 0, 601, 593, 1, 0, 0, 0, 601, 598, 1, 0, 0, 0, 602, 47, 1, 0, 0, 0, 603, 607, 5, 149,
        0, 0, 604, 606, 3, 50, 25, 0, 605, 604, 1, 0, 0, 0, 606, 609, 1, 0, 0, 0, 607, 605, 1, 0, 0,
        0, 607, 608, 1, 0, 0, 0, 608, 610, 1, 0, 0, 0, 609, 607, 1, 0, 0, 0, 610, 611, 5, 150, 0, 0,
        611, 49, 1, 0, 0, 0, 612, 616, 3, 52, 26, 0, 613, 615, 3, 212, 106, 0, 614, 613, 1, 0, 0, 0,
        615, 618, 1, 0, 0, 0, 616, 614, 1, 0, 0, 0, 616, 617, 1, 0, 0, 0, 617, 625, 1, 0, 0, 0, 618,
        616, 1, 0, 0, 0, 619, 621, 3, 212, 106, 0, 620, 619, 1, 0, 0, 0, 621, 622, 1, 0, 0, 0, 622,
        620, 1, 0, 0, 0, 622, 623, 1, 0, 0, 0, 623, 625, 1, 0, 0, 0, 624, 612, 1, 0, 0, 0, 624, 620,
        1, 0, 0, 0, 625, 51, 1, 0, 0, 0, 626, 627, 7, 2, 0, 0, 627, 53, 1, 0, 0, 0, 628, 634, 3,
        172, 86, 0, 629, 634, 3, 56, 28, 0, 630, 634, 3, 58, 29, 0, 631, 634, 3, 40, 20, 0, 632,
        634, 3, 126, 63, 0, 633, 628, 1, 0, 0, 0, 633, 629, 1, 0, 0, 0, 633, 630, 1, 0, 0, 0, 633,
        631, 1, 0, 0, 0, 633, 632, 1, 0, 0, 0, 634, 635, 1, 0, 0, 0, 635, 633, 1, 0, 0, 0, 635, 636,
        1, 0, 0, 0, 636, 55, 1, 0, 0, 0, 637, 638, 5, 173, 0, 0, 638, 639, 3, 60, 30, 0, 639, 57, 1,
        0, 0, 0, 640, 641, 5, 174, 0, 0, 641, 642, 3, 60, 30, 0, 642, 59, 1, 0, 0, 0, 643, 645, 3,
        76, 38, 0, 644, 643, 1, 0, 0, 0, 644, 645, 1, 0, 0, 0, 645, 646, 1, 0, 0, 0, 646, 650, 3,
        70, 35, 0, 647, 649, 3, 208, 104, 0, 648, 647, 1, 0, 0, 0, 649, 652, 1, 0, 0, 0, 650, 648,
        1, 0, 0, 0, 650, 651, 1, 0, 0, 0, 651, 654, 1, 0, 0, 0, 652, 650, 1, 0, 0, 0, 653, 655, 3,
        286, 143, 0, 654, 653, 1, 0, 0, 0, 654, 655, 1, 0, 0, 0, 655, 656, 1, 0, 0, 0, 656, 657, 5,
        153, 0, 0, 657, 61, 1, 0, 0, 0, 658, 664, 3, 128, 64, 0, 659, 664, 3, 172, 86, 0, 660, 664,
        3, 64, 32, 0, 661, 664, 3, 66, 33, 0, 662, 664, 3, 78, 39, 0, 663, 658, 1, 0, 0, 0, 663,
        659, 1, 0, 0, 0, 663, 660, 1, 0, 0, 0, 663, 661, 1, 0, 0, 0, 663, 662, 1, 0, 0, 0, 664, 665,
        1, 0, 0, 0, 665, 663, 1, 0, 0, 0, 665, 666, 1, 0, 0, 0, 666, 63, 1, 0, 0, 0, 667, 668, 5,
        173, 0, 0, 668, 669, 3, 68, 34, 0, 669, 65, 1, 0, 0, 0, 670, 671, 5, 174, 0, 0, 671, 672, 3,
        68, 34, 0, 672, 67, 1, 0, 0, 0, 673, 675, 3, 76, 38, 0, 674, 673, 1, 0, 0, 0, 674, 675, 1,
        0, 0, 0, 675, 676, 1, 0, 0, 0, 676, 678, 3, 70, 35, 0, 677, 679, 3, 174, 87, 0, 678, 677, 1,
        0, 0, 0, 678, 679, 1, 0, 0, 0, 679, 681, 1, 0, 0, 0, 680, 682, 5, 153, 0, 0, 681, 680, 1, 0,
        0, 0, 681, 682, 1, 0, 0, 0, 682, 684, 1, 0, 0, 0, 683, 685, 3, 208, 104, 0, 684, 683, 1, 0,
        0, 0, 684, 685, 1, 0, 0, 0, 685, 686, 1, 0, 0, 0, 686, 688, 3, 304, 152, 0, 687, 689, 5,
        153, 0, 0, 688, 687, 1, 0, 0, 0, 688, 689, 1, 0, 0, 0, 689, 69, 1, 0, 0, 0, 690, 701, 3, 74,
        37, 0, 691, 693, 3, 72, 36, 0, 692, 691, 1, 0, 0, 0, 693, 694, 1, 0, 0, 0, 694, 692, 1, 0,
        0, 0, 694, 695, 1, 0, 0, 0, 695, 698, 1, 0, 0, 0, 696, 697, 5, 154, 0, 0, 697, 699, 5, 191,
        0, 0, 698, 696, 1, 0, 0, 0, 698, 699, 1, 0, 0, 0, 699, 701, 1, 0, 0, 0, 700, 690, 1, 0, 0,
        0, 700, 692, 1, 0, 0, 0, 701, 71, 1, 0, 0, 0, 702, 704, 3, 74, 37, 0, 703, 702, 1, 0, 0, 0,
        703, 704, 1, 0, 0, 0, 704, 705, 1, 0, 0, 0, 705, 709, 5, 164, 0, 0, 706, 708, 3, 76, 38, 0,
        707, 706, 1, 0, 0, 0, 708, 711, 1, 0, 0, 0, 709, 707, 1, 0, 0, 0, 709, 710, 1, 0, 0, 0, 710,
        713, 1, 0, 0, 0, 711, 709, 1, 0, 0, 0, 712, 714, 3, 234, 117, 0, 713, 712, 1, 0, 0, 0, 713,
        714, 1, 0, 0, 0, 714, 715, 1, 0, 0, 0, 715, 716, 3, 362, 181, 0, 716, 73, 1, 0, 0, 0, 717,
        724, 3, 362, 181, 0, 718, 724, 5, 22, 0, 0, 719, 724, 5, 28, 0, 0, 720, 724, 5, 16, 0, 0,
        721, 724, 5, 10, 0, 0, 722, 724, 5, 7, 0, 0, 723, 717, 1, 0, 0, 0, 723, 718, 1, 0, 0, 0,
        723, 719, 1, 0, 0, 0, 723, 720, 1, 0, 0, 0, 723, 721, 1, 0, 0, 0, 723, 722, 1, 0, 0, 0, 724,
        75, 1, 0, 0, 0, 725, 726, 5, 147, 0, 0, 726, 727, 3, 184, 92, 0, 727, 728, 5, 148, 0, 0,
        728, 77, 1, 0, 0, 0, 729, 730, 5, 80, 0, 0, 730, 731, 3, 80, 40, 0, 731, 732, 5, 153, 0, 0,
        732, 738, 1, 0, 0, 0, 733, 734, 5, 63, 0, 0, 734, 735, 3, 80, 40, 0, 735, 736, 5, 153, 0, 0,
        736, 738, 1, 0, 0, 0, 737, 729, 1, 0, 0, 0, 737, 733, 1, 0, 0, 0, 738, 79, 1, 0, 0, 0, 739,
        744, 3, 82, 41, 0, 740, 741, 5, 154, 0, 0, 741, 743, 3, 82, 41, 0, 742, 740, 1, 0, 0, 0,
        743, 746, 1, 0, 0, 0, 744, 742, 1, 0, 0, 0, 744, 745, 1, 0, 0, 0, 745, 81, 1, 0, 0, 0, 746,
        744, 1, 0, 0, 0, 747, 750, 3, 362, 181, 0, 748, 749, 5, 158, 0, 0, 749, 751, 3, 362, 181, 0,
        750, 748, 1, 0, 0, 0, 750, 751, 1, 0, 0, 0, 751, 83, 1, 0, 0, 0, 752, 753, 5, 157, 0, 0,
        753, 765, 5, 149, 0, 0, 754, 759, 3, 86, 43, 0, 755, 756, 5, 154, 0, 0, 756, 758, 3, 86, 43,
        0, 757, 755, 1, 0, 0, 0, 758, 761, 1, 0, 0, 0, 759, 757, 1, 0, 0, 0, 759, 760, 1, 0, 0, 0,
        760, 763, 1, 0, 0, 0, 761, 759, 1, 0, 0, 0, 762, 764, 5, 154, 0, 0, 763, 762, 1, 0, 0, 0,
        763, 764, 1, 0, 0, 0, 764, 766, 1, 0, 0, 0, 765, 754, 1, 0, 0, 0, 765, 766, 1, 0, 0, 0, 766,
        767, 1, 0, 0, 0, 767, 768, 5, 150, 0, 0, 768, 85, 1, 0, 0, 0, 769, 770, 3, 338, 169, 0, 770,
        771, 5, 164, 0, 0, 771, 772, 3, 332, 166, 0, 772, 87, 1, 0, 0, 0, 773, 774, 5, 157, 0, 0,
        774, 779, 5, 151, 0, 0, 775, 777, 3, 330, 165, 0, 776, 778, 5, 154, 0, 0, 777, 776, 1, 0, 0,
        0, 777, 778, 1, 0, 0, 0, 778, 780, 1, 0, 0, 0, 779, 775, 1, 0, 0, 0, 779, 780, 1, 0, 0, 0,
        780, 781, 1, 0, 0, 0, 781, 782, 5, 152, 0, 0, 782, 89, 1, 0, 0, 0, 783, 784, 5, 157, 0, 0,
        784, 785, 5, 147, 0, 0, 785, 786, 3, 332, 166, 0, 786, 787, 5, 148, 0, 0, 787, 794, 1, 0, 0,
        0, 788, 791, 5, 157, 0, 0, 789, 792, 3, 358, 179, 0, 790, 792, 3, 362, 181, 0, 791, 789, 1,
        0, 0, 0, 791, 790, 1, 0, 0, 0, 792, 794, 1, 0, 0, 0, 793, 783, 1, 0, 0, 0, 793, 788, 1, 0,
        0, 0, 794, 91, 1, 0, 0, 0, 795, 807, 5, 147, 0, 0, 796, 799, 3, 200, 100, 0, 797, 799, 5,
        32, 0, 0, 798, 796, 1, 0, 0, 0, 798, 797, 1, 0, 0, 0, 799, 804, 1, 0, 0, 0, 800, 801, 5,
        154, 0, 0, 801, 803, 3, 200, 100, 0, 802, 800, 1, 0, 0, 0, 803, 806, 1, 0, 0, 0, 804, 802,
        1, 0, 0, 0, 804, 805, 1, 0, 0, 0, 805, 808, 1, 0, 0, 0, 806, 804, 1, 0, 0, 0, 807, 798, 1,
        0, 0, 0, 807, 808, 1, 0, 0, 0, 808, 809, 1, 0, 0, 0, 809, 810, 5, 148, 0, 0, 810, 93, 1, 0,
        0, 0, 811, 812, 5, 179, 0, 0, 812, 827, 3, 304, 152, 0, 813, 814, 5, 179, 0, 0, 814, 815, 3,
        184, 92, 0, 815, 816, 3, 92, 46, 0, 816, 817, 3, 304, 152, 0, 817, 827, 1, 0, 0, 0, 818,
        819, 5, 179, 0, 0, 819, 820, 3, 184, 92, 0, 820, 821, 3, 304, 152, 0, 821, 827, 1, 0, 0, 0,
        822, 823, 5, 179, 0, 0, 823, 824, 3, 92, 46, 0, 824, 825, 3, 304, 152, 0, 825, 827, 1, 0, 0,
        0, 826, 811, 1, 0, 0, 0, 826, 813, 1, 0, 0, 0, 826, 818, 1, 0, 0, 0, 826, 822, 1, 0, 0, 0,
        827, 95, 1, 0, 0, 0, 828, 829, 5, 151, 0, 0, 829, 830, 3, 98, 49, 0, 830, 831, 3, 100, 50,
        0, 831, 832, 5, 152, 0, 0, 832, 97, 1, 0, 0, 0, 833, 836, 3, 332, 166, 0, 834, 836, 3, 258,
        129, 0, 835, 833, 1, 0, 0, 0, 835, 834, 1, 0, 0, 0, 836, 99, 1, 0, 0, 0, 837, 844, 3, 74,
        37, 0, 838, 840, 3, 102, 51, 0, 839, 838, 1, 0, 0, 0, 840, 841, 1, 0, 0, 0, 841, 839, 1, 0,
        0, 0, 841, 842, 1, 0, 0, 0, 842, 844, 1, 0, 0, 0, 843, 837, 1, 0, 0, 0, 843, 839, 1, 0, 0,
        0, 844, 101, 1, 0, 0, 0, 845, 847, 3, 74, 37, 0, 846, 845, 1, 0, 0, 0, 846, 847, 1, 0, 0, 0,
        847, 848, 1, 0, 0, 0, 848, 849, 5, 164, 0, 0, 849, 854, 3, 104, 52, 0, 850, 851, 5, 154, 0,
        0, 851, 853, 3, 104, 52, 0, 852, 850, 1, 0, 0, 0, 853, 856, 1, 0, 0, 0, 854, 852, 1, 0, 0,
        0, 854, 855, 1, 0, 0, 0, 855, 103, 1, 0, 0, 0, 856, 854, 1, 0, 0, 0, 857, 859, 3, 330, 165,
        0, 858, 860, 3, 236, 118, 0, 859, 858, 1, 0, 0, 0, 859, 860, 1, 0, 0, 0, 860, 865, 1, 0, 0,
        0, 861, 862, 5, 149, 0, 0, 862, 863, 3, 294, 147, 0, 863, 864, 5, 150, 0, 0, 864, 866, 1, 0,
        0, 0, 865, 861, 1, 0, 0, 0, 865, 866, 1, 0, 0, 0, 866, 105, 1, 0, 0, 0, 867, 868, 5, 78, 0,
        0, 868, 869, 5, 147, 0, 0, 869, 870, 3, 108, 54, 0, 870, 871, 5, 148, 0, 0, 871, 107, 1, 0,
        0, 0, 872, 882, 3, 74, 37, 0, 873, 875, 3, 74, 37, 0, 874, 873, 1, 0, 0, 0, 874, 875, 1, 0,
        0, 0, 875, 876, 1, 0, 0, 0, 876, 878, 5, 164, 0, 0, 877, 874, 1, 0, 0, 0, 878, 879, 1, 0, 0,
        0, 879, 877, 1, 0, 0, 0, 879, 880, 1, 0, 0, 0, 880, 882, 1, 0, 0, 0, 881, 872, 1, 0, 0, 0,
        881, 877, 1, 0, 0, 0, 882, 109, 1, 0, 0, 0, 883, 884, 5, 71, 0, 0, 884, 885, 5, 147, 0, 0,
        885, 886, 3, 46, 23, 0, 886, 887, 5, 148, 0, 0, 887, 111, 1, 0, 0, 0, 888, 889, 5, 64, 0, 0,
        889, 890, 5, 147, 0, 0, 890, 891, 3, 184, 92, 0, 891, 892, 5, 148, 0, 0, 892, 113, 1, 0, 0,
        0, 893, 894, 3, 170, 85, 0, 894, 895, 3, 178, 89, 0, 895, 115, 1, 0, 0, 0, 896, 897, 5, 81,
        0, 0, 897, 898, 5, 147, 0, 0, 898, 899, 3, 362, 181, 0, 899, 900, 5, 148, 0, 0, 900, 904, 1,
        0, 0, 0, 901, 902, 5, 81, 0, 0, 902, 904, 3, 332, 166, 0, 903, 896, 1, 0, 0, 0, 903, 901, 1,
        0, 0, 0, 904, 117, 1, 0, 0, 0, 905, 906, 5, 82, 0, 0, 906, 910, 3, 304, 152, 0, 907, 909, 3,
        120, 60, 0, 908, 907, 1, 0, 0, 0, 909, 912, 1, 0, 0, 0, 910, 908, 1, 0, 0, 0, 910, 911, 1,
        0, 0, 0, 911, 915, 1, 0, 0, 0, 912, 910, 1, 0, 0, 0, 913, 914, 5, 66, 0, 0, 914, 916, 3,
        304, 152, 0, 915, 913, 1, 0, 0, 0, 915, 916, 1, 0, 0, 0, 916, 119, 1, 0, 0, 0, 917, 918, 5,
        61, 0, 0, 918, 919, 5, 147, 0, 0, 919, 920, 3, 114, 57, 0, 920, 921, 5, 148, 0, 0, 921, 922,
        3, 304, 152, 0, 922, 121, 1, 0, 0, 0, 923, 924, 5, 79, 0, 0, 924, 925, 5, 147, 0, 0, 925,
        926, 3, 332, 166, 0, 926, 927, 5, 148, 0, 0, 927, 928, 3, 304, 152, 0, 928, 123, 1, 0, 0, 0,
        929, 930, 5, 60, 0, 0, 930, 931, 3, 304, 152, 0, 931, 125, 1, 0, 0, 0, 932, 933, 3, 130, 65,
        0, 933, 934, 5, 153, 0, 0, 934, 127, 1, 0, 0, 0, 935, 936, 3, 130, 65, 0, 936, 937, 3, 304,
        152, 0, 937, 129, 1, 0, 0, 0, 938, 940, 3, 170, 85, 0, 939, 938, 1, 0, 0, 0, 939, 940, 1, 0,
        0, 0, 940, 941, 1, 0, 0, 0, 941, 943, 3, 178, 89, 0, 942, 944, 3, 132, 66, 0, 943, 942, 1,
        0, 0, 0, 943, 944, 1, 0, 0, 0, 944, 131, 1, 0, 0, 0, 945, 947, 3, 172, 86, 0, 946, 945, 1,
        0, 0, 0, 947, 948, 1, 0, 0, 0, 948, 946, 1, 0, 0, 0, 948, 949, 1, 0, 0, 0, 949, 133, 1, 0,
        0, 0, 950, 952, 3, 136, 68, 0, 951, 953, 3, 138, 69, 0, 952, 951, 1, 0, 0, 0, 952, 953, 1,
        0, 0, 0, 953, 135, 1, 0, 0, 0, 954, 957, 5, 5, 0, 0, 955, 957, 3, 362, 181, 0, 956, 954, 1,
        0, 0, 0, 956, 955, 1, 0, 0, 0, 957, 137, 1, 0, 0, 0, 958, 960, 5, 147, 0, 0, 959, 961, 3,
        140, 70, 0, 960, 959, 1, 0, 0, 0, 960, 961, 1, 0, 0, 0, 961, 962, 1, 0, 0, 0, 962, 963, 5,
        148, 0, 0, 963, 139, 1, 0, 0, 0, 964, 969, 3, 142, 71, 0, 965, 966, 5, 154, 0, 0, 966, 968,
        3, 142, 71, 0, 967, 965, 1, 0, 0, 0, 968, 971, 1, 0, 0, 0, 969, 967, 1, 0, 0, 0, 969, 970,
        1, 0, 0, 0, 970, 141, 1, 0, 0, 0, 971, 969, 1, 0, 0, 0, 972, 977, 3, 134, 67, 0, 973, 977,
        3, 358, 179, 0, 974, 977, 3, 360, 180, 0, 975, 977, 3, 144, 72, 0, 976, 972, 1, 0, 0, 0,
        976, 973, 1, 0, 0, 0, 976, 974, 1, 0, 0, 0, 976, 975, 1, 0, 0, 0, 977, 143, 1, 0, 0, 0, 978,
        979, 3, 136, 68, 0, 979, 983, 5, 158, 0, 0, 980, 984, 3, 358, 179, 0, 981, 984, 3, 136, 68,
        0, 982, 984, 3, 360, 180, 0, 983, 980, 1, 0, 0, 0, 983, 981, 1, 0, 0, 0, 983, 982, 1, 0, 0,
        0, 984, 145, 1, 0, 0, 0, 985, 986, 3, 170, 85, 0, 986, 987, 5, 147, 0, 0, 987, 989, 5, 175,
        0, 0, 988, 990, 3, 362, 181, 0, 989, 988, 1, 0, 0, 0, 989, 990, 1, 0, 0, 0, 990, 991, 1, 0,
        0, 0, 991, 992, 5, 148, 0, 0, 992, 994, 5, 147, 0, 0, 993, 995, 3, 148, 74, 0, 994, 993, 1,
        0, 0, 0, 994, 995, 1, 0, 0, 0, 995, 996, 1, 0, 0, 0, 996, 997, 5, 148, 0, 0, 997, 147, 1, 0,
        0, 0, 998, 1001, 3, 150, 75, 0, 999, 1000, 5, 154, 0, 0, 1000, 1002, 5, 191, 0, 0, 1001,
        999, 1, 0, 0, 0, 1001, 1002, 1, 0, 0, 0, 1002, 149, 1, 0, 0, 0, 1003, 1008, 3, 152, 76, 0,
        1004, 1005, 5, 154, 0, 0, 1005, 1007, 3, 152, 76, 0, 1006, 1004, 1, 0, 0, 0, 1007, 1010, 1,
        0, 0, 0, 1008, 1006, 1, 0, 0, 0, 1008, 1009, 1, 0, 0, 0, 1009, 151, 1, 0, 0, 0, 1010, 1008,
        1, 0, 0, 0, 1011, 1014, 3, 170, 85, 0, 1012, 1014, 3, 146, 73, 0, 1013, 1011, 1, 0, 0, 0,
        1013, 1012, 1, 0, 0, 0, 1014, 1016, 1, 0, 0, 0, 1015, 1017, 3, 178, 89, 0, 1016, 1015, 1, 0,
        0, 0, 1016, 1017, 1, 0, 0, 0, 1017, 1020, 1, 0, 0, 0, 1018, 1020, 5, 32, 0, 0, 1019, 1013,
        1, 0, 0, 0, 1019, 1018, 1, 0, 0, 0, 1020, 153, 1, 0, 0, 0, 1021, 1023, 3, 208, 104, 0, 1022,
        1021, 1, 0, 0, 0, 1022, 1023, 1, 0, 0, 0, 1023, 1024, 1, 0, 0, 0, 1024, 1026, 3, 362, 181,
        0, 1025, 1027, 3, 208, 104, 0, 1026, 1025, 1, 0, 0, 0, 1026, 1027, 1, 0, 0, 0, 1027, 1028,
        1, 0, 0, 0, 1028, 1029, 5, 147, 0, 0, 1029, 1030, 3, 180, 90, 0, 1030, 1031, 5, 148, 0, 0,
        1031, 1032, 5, 153, 0, 0, 1032, 155, 1, 0, 0, 0, 1033, 1035, 3, 208, 104, 0, 1034, 1033, 1,
        0, 0, 0, 1034, 1035, 1, 0, 0, 0, 1035, 1037, 1, 0, 0, 0, 1036, 1038, 5, 29, 0, 0, 1037,
        1036, 1, 0, 0, 0, 1037, 1038, 1, 0, 0, 0, 1038, 1039, 1, 0, 0, 0, 1039, 1041, 3, 224, 112,
        0, 1040, 1042, 3, 362, 181, 0, 1041, 1040, 1, 0, 0, 0, 1041, 1042, 1, 0, 0, 0, 1042, 1043,
        1, 0, 0, 0, 1043, 1044, 5, 153, 0, 0, 1044, 157, 1, 0, 0, 0, 1045, 1046, 3, 170, 85, 0,
        1046, 1047, 3, 174, 87, 0, 1047, 1050, 1, 0, 0, 0, 1048, 1050, 3, 170, 85, 0, 1049, 1045, 1,
        0, 0, 0, 1049, 1048, 1, 0, 0, 0, 1050, 1051, 1, 0, 0, 0, 1051, 1052, 5, 153, 0, 0, 1052,
        159, 1, 0, 0, 0, 1053, 1055, 3, 208, 104, 0, 1054, 1053, 1, 0, 0, 0, 1054, 1055, 1, 0, 0, 0,
        1055, 1056, 1, 0, 0, 0, 1056, 1061, 5, 29, 0, 0, 1057, 1058, 3, 170, 85, 0, 1058, 1059, 3,
        162, 81, 0, 1059, 1062, 1, 0, 0, 0, 1060, 1062, 3, 170, 85, 0, 1061, 1057, 1, 0, 0, 0, 1061,
        1060, 1, 0, 0, 0, 1062, 1064, 1, 0, 0, 0, 1063, 1065, 3, 286, 143, 0, 1064, 1063, 1, 0, 0,
        0, 1064, 1065, 1, 0, 0, 0, 1065, 1066, 1, 0, 0, 0, 1066, 1067, 5, 153, 0, 0, 1067, 1076, 1,
        0, 0, 0, 1068, 1070, 3, 208, 104, 0, 1069, 1068, 1, 0, 0, 0, 1069, 1070, 1, 0, 0, 0, 1070,
        1071, 1, 0, 0, 0, 1071, 1072, 5, 29, 0, 0, 1072, 1073, 3, 146, 73, 0, 1073, 1074, 5, 153, 0,
        0, 1074, 1076, 1, 0, 0, 0, 1075, 1054, 1, 0, 0, 0, 1075, 1069, 1, 0, 0, 0, 1076, 161, 1, 0,
        0, 0, 1077, 1082, 3, 178, 89, 0, 1078, 1079, 5, 154, 0, 0, 1079, 1081, 3, 178, 89, 0, 1080,
        1078, 1, 0, 0, 0, 1081, 1084, 1, 0, 0, 0, 1082, 1080, 1, 0, 0, 0, 1082, 1083, 1, 0, 0, 0,
        1083, 163, 1, 0, 0, 0, 1084, 1082, 1, 0, 0, 0, 1085, 1094, 3, 238, 119, 0, 1086, 1094, 3,
        208, 104, 0, 1087, 1094, 3, 234, 117, 0, 1088, 1094, 3, 236, 118, 0, 1089, 1094, 3, 232,
        116, 0, 1090, 1094, 3, 240, 120, 0, 1091, 1094, 3, 242, 121, 0, 1092, 1094, 3, 252, 126, 0,
        1093, 1085, 1, 0, 0, 0, 1093, 1086, 1, 0, 0, 0, 1093, 1087, 1, 0, 0, 0, 1093, 1088, 1, 0, 0,
        0, 1093, 1089, 1, 0, 0, 0, 1093, 1090, 1, 0, 0, 0, 1093, 1091, 1, 0, 0, 0, 1093, 1092, 1, 0,
        0, 0, 1094, 1095, 1, 0, 0, 0, 1095, 1093, 1, 0, 0, 0, 1095, 1096, 1, 0, 0, 0, 1096, 165, 1,
        0, 0, 0, 1097, 1106, 3, 238, 119, 0, 1098, 1106, 3, 252, 126, 0, 1099, 1106, 3, 242, 121, 0,
        1100, 1106, 3, 244, 122, 0, 1101, 1106, 3, 246, 123, 0, 1102, 1106, 3, 234, 117, 0, 1103,
        1106, 3, 236, 118, 0, 1104, 1106, 3, 232, 116, 0, 1105, 1097, 1, 0, 0, 0, 1105, 1098, 1, 0,
        0, 0, 1105, 1099, 1, 0, 0, 0, 1105, 1100, 1, 0, 0, 0, 1105, 1101, 1, 0, 0, 0, 1105, 1102, 1,
        0, 0, 0, 1105, 1103, 1, 0, 0, 0, 1105, 1104, 1, 0, 0, 0, 1106, 167, 1, 0, 0, 0, 1107, 1116,
        3, 238, 119, 0, 1108, 1116, 3, 252, 126, 0, 1109, 1116, 3, 242, 121, 0, 1110, 1116, 3, 244,
        122, 0, 1111, 1116, 3, 246, 123, 0, 1112, 1116, 3, 234, 117, 0, 1113, 1116, 3, 236, 118, 0,
        1114, 1116, 3, 232, 116, 0, 1115, 1107, 1, 0, 0, 0, 1115, 1108, 1, 0, 0, 0, 1115, 1109, 1,
        0, 0, 0, 1115, 1110, 1, 0, 0, 0, 1115, 1111, 1, 0, 0, 0, 1115, 1112, 1, 0, 0, 0, 1115, 1113,
        1, 0, 0, 0, 1115, 1114, 1, 0, 0, 0, 1116, 169, 1, 0, 0, 0, 1117, 1119, 3, 240, 120, 0, 1118,
        1117, 1, 0, 0, 0, 1118, 1119, 1, 0, 0, 0, 1119, 1121, 1, 0, 0, 0, 1120, 1122, 3, 168, 84, 0,
        1121, 1120, 1, 0, 0, 0, 1122, 1123, 1, 0, 0, 0, 1123, 1121, 1, 0, 0, 0, 1123, 1124, 1, 0, 0,
        0, 1124, 171, 1, 0, 0, 0, 1125, 1127, 3, 170, 85, 0, 1126, 1128, 3, 174, 87, 0, 1127, 1126,
        1, 0, 0, 0, 1127, 1128, 1, 0, 0, 0, 1128, 1129, 1, 0, 0, 0, 1129, 1130, 5, 153, 0, 0, 1130,
        1133, 1, 0, 0, 0, 1131, 1133, 3, 296, 148, 0, 1132, 1125, 1, 0, 0, 0, 1132, 1131, 1, 0, 0,
        0, 1133, 173, 1, 0, 0, 0, 1134, 1139, 3, 176, 88, 0, 1135, 1136, 5, 154, 0, 0, 1136, 1138,
        3, 176, 88, 0, 1137, 1135, 1, 0, 0, 0, 1138, 1141, 1, 0, 0, 0, 1139, 1137, 1, 0, 0, 0, 1139,
        1140, 1, 0, 0, 0, 1140, 175, 1, 0, 0, 0, 1141, 1139, 1, 0, 0, 0, 1142, 1145, 3, 178, 89, 0,
        1143, 1144, 5, 158, 0, 0, 1144, 1146, 3, 340, 170, 0, 1145, 1143, 1, 0, 0, 0, 1145, 1146, 1,
        0, 0, 0, 1146, 177, 1, 0, 0, 0, 1147, 1149, 3, 282, 141, 0, 1148, 1147, 1, 0, 0, 0, 1148,
        1149, 1, 0, 0, 0, 1149, 1150, 1, 0, 0, 0, 1150, 1154, 3, 180, 90, 0, 1151, 1153, 3, 272,
        136, 0, 1152, 1151, 1, 0, 0, 0, 1153, 1156, 1, 0, 0, 0, 1154, 1152, 1, 0, 0, 0, 1154, 1155,
        1, 0, 0, 0, 1155, 179, 1, 0, 0, 0, 1156, 1154, 1, 0, 0, 0, 1157, 1158, 6, 90, -1, 0, 1158,
        1188, 3, 362, 181, 0, 1159, 1160, 5, 147, 0, 0, 1160, 1161, 3, 178, 89, 0, 1161, 1162, 5,
        148, 0, 0, 1162, 1188, 1, 0, 0, 0, 1163, 1164, 5, 147, 0, 0, 1164, 1168, 5, 179, 0, 0, 1165,
        1167, 3, 182, 91, 0, 1166, 1165, 1, 0, 0, 0, 1167, 1170, 1, 0, 0, 0, 1168, 1166, 1, 0, 0, 0,
        1168, 1169, 1, 0, 0, 0, 1169, 1171, 1, 0, 0, 0, 1170, 1168, 1, 0, 0, 0, 1171, 1172, 3, 180,
        90, 0, 1172, 1173, 5, 148, 0, 0, 1173, 1174, 3, 92, 46, 0, 1174, 1188, 1, 0, 0, 0, 1175,
        1176, 3, 362, 181, 0, 1176, 1177, 5, 164, 0, 0, 1177, 1178, 5, 198, 0, 0, 1178, 1188, 1, 0,
        0, 0, 1179, 1180, 3, 270, 135, 0, 1180, 1181, 3, 362, 181, 0, 1181, 1188, 1, 0, 0, 0, 1182,
        1183, 5, 147, 0, 0, 1183, 1184, 3, 270, 135, 0, 1184, 1185, 3, 178, 89, 0, 1185, 1186, 5,
        148, 0, 0, 1186, 1188, 1, 0, 0, 0, 1187, 1157, 1, 0, 0, 0, 1187, 1159, 1, 0, 0, 0, 1187,
        1163, 1, 0, 0, 0, 1187, 1175, 1, 0, 0, 0, 1187, 1179, 1, 0, 0, 0, 1187, 1182, 1, 0, 0, 0,
        1188, 1229, 1, 0, 0, 0, 1189, 1190, 10, 9, 0, 0, 1190, 1192, 5, 151, 0, 0, 1191, 1193, 3,
        202, 101, 0, 1192, 1191, 1, 0, 0, 0, 1192, 1193, 1, 0, 0, 0, 1193, 1195, 1, 0, 0, 0, 1194,
        1196, 3, 332, 166, 0, 1195, 1194, 1, 0, 0, 0, 1195, 1196, 1, 0, 0, 0, 1196, 1197, 1, 0, 0,
        0, 1197, 1228, 5, 152, 0, 0, 1198, 1199, 10, 8, 0, 0, 1199, 1200, 5, 151, 0, 0, 1200, 1202,
        5, 26, 0, 0, 1201, 1203, 3, 202, 101, 0, 1202, 1201, 1, 0, 0, 0, 1202, 1203, 1, 0, 0, 0,
        1203, 1204, 1, 0, 0, 0, 1204, 1205, 3, 332, 166, 0, 1205, 1206, 5, 152, 0, 0, 1206, 1228, 1,
        0, 0, 0, 1207, 1208, 10, 7, 0, 0, 1208, 1209, 5, 151, 0, 0, 1209, 1210, 3, 202, 101, 0,
        1210, 1211, 5, 26, 0, 0, 1211, 1212, 3, 332, 166, 0, 1212, 1213, 5, 152, 0, 0, 1213, 1228,
        1, 0, 0, 0, 1214, 1215, 10, 6, 0, 0, 1215, 1217, 5, 151, 0, 0, 1216, 1218, 3, 202, 101, 0,
        1217, 1216, 1, 0, 0, 0, 1217, 1218, 1, 0, 0, 0, 1218, 1219, 1, 0, 0, 0, 1219, 1220, 5, 175,
        0, 0, 1220, 1228, 5, 152, 0, 0, 1221, 1222, 10, 5, 0, 0, 1222, 1224, 5, 147, 0, 0, 1223,
        1225, 3, 194, 97, 0, 1224, 1223, 1, 0, 0, 0, 1224, 1225, 1, 0, 0, 0, 1225, 1226, 1, 0, 0, 0,
        1226, 1228, 5, 148, 0, 0, 1227, 1189, 1, 0, 0, 0, 1227, 1198, 1, 0, 0, 0, 1227, 1207, 1, 0,
        0, 0, 1227, 1214, 1, 0, 0, 0, 1227, 1221, 1, 0, 0, 0, 1228, 1231, 1, 0, 0, 0, 1229, 1227, 1,
        0, 0, 0, 1229, 1230, 1, 0, 0, 0, 1230, 181, 1, 0, 0, 0, 1231, 1229, 1, 0, 0, 0, 1232, 1237,
        3, 236, 118, 0, 1233, 1237, 3, 234, 117, 0, 1234, 1237, 3, 242, 121, 0, 1235, 1237, 3, 240,
        120, 0, 1236, 1232, 1, 0, 0, 0, 1236, 1233, 1, 0, 0, 0, 1236, 1234, 1, 0, 0, 0, 1236, 1235,
        1, 0, 0, 0, 1237, 183, 1, 0, 0, 0, 1238, 1240, 3, 170, 85, 0, 1239, 1241, 3, 188, 94, 0,
        1240, 1239, 1, 0, 0, 0, 1240, 1241, 1, 0, 0, 0, 1241, 185, 1, 0, 0, 0, 1242, 1244, 3, 282,
        141, 0, 1243, 1245, 3, 186, 93, 0, 1244, 1243, 1, 0, 0, 0, 1244, 1245, 1, 0, 0, 0, 1245,
        1266, 1, 0, 0, 0, 1246, 1248, 5, 147, 0, 0, 1247, 1249, 3, 188, 94, 0, 1248, 1247, 1, 0, 0,
        0, 1248, 1249, 1, 0, 0, 0, 1249, 1250, 1, 0, 0, 0, 1250, 1252, 5, 148, 0, 0, 1251, 1253, 3,
        192, 96, 0, 1252, 1251, 1, 0, 0, 0, 1253, 1254, 1, 0, 0, 0, 1254, 1252, 1, 0, 0, 0, 1254,
        1255, 1, 0, 0, 0, 1255, 1266, 1, 0, 0, 0, 1256, 1258, 5, 151, 0, 0, 1257, 1259, 3, 342, 171,
        0, 1258, 1257, 1, 0, 0, 0, 1258, 1259, 1, 0, 0, 0, 1259, 1260, 1, 0, 0, 0, 1260, 1262, 5,
        152, 0, 0, 1261, 1256, 1, 0, 0, 0, 1262, 1263, 1, 0, 0, 0, 1263, 1261, 1, 0, 0, 0, 1263,
        1264, 1, 0, 0, 0, 1264, 1266, 1, 0, 0, 0, 1265, 1242, 1, 0, 0, 0, 1265, 1246, 1, 0, 0, 0,
        1265, 1261, 1, 0, 0, 0, 1266, 187, 1, 0, 0, 0, 1267, 1279, 3, 282, 141, 0, 1268, 1270, 3,
        282, 141, 0, 1269, 1268, 1, 0, 0, 0, 1269, 1270, 1, 0, 0, 0, 1270, 1271, 1, 0, 0, 0, 1271,
        1275, 3, 190, 95, 0, 1272, 1274, 3, 272, 136, 0, 1273, 1272, 1, 0, 0, 0, 1274, 1277, 1, 0,
        0, 0, 1275, 1273, 1, 0, 0, 0, 1275, 1276, 1, 0, 0, 0, 1276, 1279, 1, 0, 0, 0, 1277, 1275, 1,
        0, 0, 0, 1278, 1267, 1, 0, 0, 0, 1278, 1269, 1, 0, 0, 0, 1279, 189, 1, 0, 0, 0, 1280, 1281,
        6, 95, -1, 0, 1281, 1282, 5, 147, 0, 0, 1282, 1283, 3, 188, 94, 0, 1283, 1287, 5, 148, 0, 0,
        1284, 1286, 3, 272, 136, 0, 1285, 1284, 1, 0, 0, 0, 1286, 1289, 1, 0, 0, 0, 1287, 1285, 1,
        0, 0, 0, 1287, 1288, 1, 0, 0, 0, 1288, 1340, 1, 0, 0, 0, 1289, 1287, 1, 0, 0, 0, 1290, 1292,
        5, 151, 0, 0, 1291, 1293, 3, 202, 101, 0, 1292, 1291, 1, 0, 0, 0, 1292, 1293, 1, 0, 0, 0,
        1293, 1295, 1, 0, 0, 0, 1294, 1296, 3, 332, 166, 0, 1295, 1294, 1, 0, 0, 0, 1295, 1296, 1,
        0, 0, 0, 1296, 1297, 1, 0, 0, 0, 1297, 1340, 5, 152, 0, 0, 1298, 1299, 5, 151, 0, 0, 1299,
        1301, 5, 26, 0, 0, 1300, 1302, 3, 202, 101, 0, 1301, 1300, 1, 0, 0, 0, 1301, 1302, 1, 0, 0,
        0, 1302, 1303, 1, 0, 0, 0, 1303, 1304, 3, 332, 166, 0, 1304, 1305, 5, 152, 0, 0, 1305, 1340,
        1, 0, 0, 0, 1306, 1307, 5, 151, 0, 0, 1307, 1308, 3, 202, 101, 0, 1308, 1309, 5, 26, 0, 0,
        1309, 1310, 3, 332, 166, 0, 1310, 1311, 5, 152, 0, 0, 1311, 1340, 1, 0, 0, 0, 1312, 1313, 5,
        151, 0, 0, 1313, 1314, 5, 175, 0, 0, 1314, 1340, 5, 152, 0, 0, 1315, 1317, 5, 147, 0, 0,
        1316, 1318, 3, 194, 97, 0, 1317, 1316, 1, 0, 0, 0, 1317, 1318, 1, 0, 0, 0, 1318, 1319, 1, 0,
        0, 0, 1319, 1323, 5, 148, 0, 0, 1320, 1322, 3, 272, 136, 0, 1321, 1320, 1, 0, 0, 0, 1322,
        1325, 1, 0, 0, 0, 1323, 1321, 1, 0, 0, 0, 1323, 1324, 1, 0, 0, 0, 1324, 1340, 1, 0, 0, 0,
        1325, 1323, 1, 0, 0, 0, 1326, 1327, 5, 147, 0, 0, 1327, 1331, 5, 179, 0, 0, 1328, 1330, 3,
        182, 91, 0, 1329, 1328, 1, 0, 0, 0, 1330, 1333, 1, 0, 0, 0, 1331, 1329, 1, 0, 0, 0, 1331,
        1332, 1, 0, 0, 0, 1332, 1335, 1, 0, 0, 0, 1333, 1331, 1, 0, 0, 0, 1334, 1336, 3, 362, 181,
        0, 1335, 1334, 1, 0, 0, 0, 1335, 1336, 1, 0, 0, 0, 1336, 1337, 1, 0, 0, 0, 1337, 1338, 5,
        148, 0, 0, 1338, 1340, 3, 92, 46, 0, 1339, 1280, 1, 0, 0, 0, 1339, 1290, 1, 0, 0, 0, 1339,
        1298, 1, 0, 0, 0, 1339, 1306, 1, 0, 0, 0, 1339, 1312, 1, 0, 0, 0, 1339, 1315, 1, 0, 0, 0,
        1339, 1326, 1, 0, 0, 0, 1340, 1384, 1, 0, 0, 0, 1341, 1342, 10, 6, 0, 0, 1342, 1344, 5, 151,
        0, 0, 1343, 1345, 3, 202, 101, 0, 1344, 1343, 1, 0, 0, 0, 1344, 1345, 1, 0, 0, 0, 1345,
        1347, 1, 0, 0, 0, 1346, 1348, 3, 332, 166, 0, 1347, 1346, 1, 0, 0, 0, 1347, 1348, 1, 0, 0,
        0, 1348, 1349, 1, 0, 0, 0, 1349, 1383, 5, 152, 0, 0, 1350, 1351, 10, 5, 0, 0, 1351, 1352, 5,
        151, 0, 0, 1352, 1354, 5, 26, 0, 0, 1353, 1355, 3, 202, 101, 0, 1354, 1353, 1, 0, 0, 0,
        1354, 1355, 1, 0, 0, 0, 1355, 1356, 1, 0, 0, 0, 1356, 1357, 3, 332, 166, 0, 1357, 1358, 5,
        152, 0, 0, 1358, 1383, 1, 0, 0, 0, 1359, 1360, 10, 4, 0, 0, 1360, 1361, 5, 151, 0, 0, 1361,
        1362, 3, 202, 101, 0, 1362, 1363, 5, 26, 0, 0, 1363, 1364, 3, 332, 166, 0, 1364, 1365, 5,
        152, 0, 0, 1365, 1383, 1, 0, 0, 0, 1366, 1367, 10, 3, 0, 0, 1367, 1368, 5, 151, 0, 0, 1368,
        1369, 5, 175, 0, 0, 1369, 1383, 5, 152, 0, 0, 1370, 1371, 10, 2, 0, 0, 1371, 1373, 5, 147,
        0, 0, 1372, 1374, 3, 194, 97, 0, 1373, 1372, 1, 0, 0, 0, 1373, 1374, 1, 0, 0, 0, 1374, 1375,
        1, 0, 0, 0, 1375, 1379, 5, 148, 0, 0, 1376, 1378, 3, 272, 136, 0, 1377, 1376, 1, 0, 0, 0,
        1378, 1381, 1, 0, 0, 0, 1379, 1377, 1, 0, 0, 0, 1379, 1380, 1, 0, 0, 0, 1380, 1383, 1, 0, 0,
        0, 1381, 1379, 1, 0, 0, 0, 1382, 1341, 1, 0, 0, 0, 1382, 1350, 1, 0, 0, 0, 1382, 1359, 1, 0,
        0, 0, 1382, 1366, 1, 0, 0, 0, 1382, 1370, 1, 0, 0, 0, 1383, 1386, 1, 0, 0, 0, 1384, 1382, 1,
        0, 0, 0, 1384, 1385, 1, 0, 0, 0, 1385, 191, 1, 0, 0, 0, 1386, 1384, 1, 0, 0, 0, 1387, 1389,
        5, 151, 0, 0, 1388, 1390, 3, 342, 171, 0, 1389, 1388, 1, 0, 0, 0, 1389, 1390, 1, 0, 0, 0,
        1390, 1391, 1, 0, 0, 0, 1391, 1398, 5, 152, 0, 0, 1392, 1394, 5, 147, 0, 0, 1393, 1395, 3,
        198, 99, 0, 1394, 1393, 1, 0, 0, 0, 1394, 1395, 1, 0, 0, 0, 1395, 1396, 1, 0, 0, 0, 1396,
        1398, 5, 148, 0, 0, 1397, 1387, 1, 0, 0, 0, 1397, 1392, 1, 0, 0, 0, 1398, 193, 1, 0, 0, 0,
        1399, 1402, 3, 196, 98, 0, 1400, 1401, 5, 154, 0, 0, 1401, 1403, 5, 191, 0, 0, 1402, 1400,
        1, 0, 0, 0, 1402, 1403, 1, 0, 0, 0, 1403, 195, 1, 0, 0, 0, 1404, 1409, 3, 200, 100, 0, 1405,
        1406, 5, 154, 0, 0, 1406, 1408, 3, 200, 100, 0, 1407, 1405, 1, 0, 0, 0, 1408, 1411, 1, 0, 0,
        0, 1409, 1407, 1, 0, 0, 0, 1409, 1410, 1, 0, 0, 0, 1410, 197, 1, 0, 0, 0, 1411, 1409, 1, 0,
        0, 0, 1412, 1417, 3, 200, 100, 0, 1413, 1414, 5, 154, 0, 0, 1414, 1416, 3, 200, 100, 0,
        1415, 1413, 1, 0, 0, 0, 1416, 1419, 1, 0, 0, 0, 1417, 1415, 1, 0, 0, 0, 1417, 1418, 1, 0, 0,
        0, 1418, 199, 1, 0, 0, 0, 1419, 1417, 1, 0, 0, 0, 1420, 1421, 3, 170, 85, 0, 1421, 1422, 3,
        178, 89, 0, 1422, 1428, 1, 0, 0, 0, 1423, 1425, 3, 170, 85, 0, 1424, 1426, 3, 188, 94, 0,
        1425, 1424, 1, 0, 0, 0, 1425, 1426, 1, 0, 0, 0, 1426, 1428, 1, 0, 0, 0, 1427, 1420, 1, 0, 0,
        0, 1427, 1423, 1, 0, 0, 0, 1428, 201, 1, 0, 0, 0, 1429, 1431, 3, 242, 121, 0, 1430, 1429, 1,
        0, 0, 0, 1431, 1432, 1, 0, 0, 0, 1432, 1430, 1, 0, 0, 0, 1432, 1433, 1, 0, 0, 0, 1433, 203,
        1, 0, 0, 0, 1434, 1439, 3, 362, 181, 0, 1435, 1436, 5, 154, 0, 0, 1436, 1438, 3, 362, 181,
        0, 1437, 1435, 1, 0, 0, 0, 1438, 1441, 1, 0, 0, 0, 1439, 1437, 1, 0, 0, 0, 1439, 1440, 1, 0,
        0, 0, 1440, 205, 1, 0, 0, 0, 1441, 1439, 1, 0, 0, 0, 1442, 1444, 5, 151, 0, 0, 1443, 1445,
        3, 342, 171, 0, 1444, 1443, 1, 0, 0, 0, 1444, 1445, 1, 0, 0, 0, 1445, 1446, 1, 0, 0, 0,
        1446, 1447, 5, 152, 0, 0, 1447, 207, 1, 0, 0, 0, 1448, 1449, 5, 86, 0, 0, 1449, 1450, 5,
        147, 0, 0, 1450, 1451, 5, 147, 0, 0, 1451, 1456, 3, 134, 67, 0, 1452, 1453, 5, 154, 0, 0,
        1453, 1455, 3, 134, 67, 0, 1454, 1452, 1, 0, 0, 0, 1455, 1458, 1, 0, 0, 0, 1456, 1454, 1, 0,
        0, 0, 1456, 1457, 1, 0, 0, 0, 1457, 1459, 1, 0, 0, 0, 1458, 1456, 1, 0, 0, 0, 1459, 1460, 5,
        148, 0, 0, 1460, 1461, 5, 148, 0, 0, 1461, 209, 1, 0, 0, 0, 1462, 1463, 5, 115, 0, 0, 1463,
        1464, 5, 147, 0, 0, 1464, 1465, 3, 184, 92, 0, 1465, 1466, 5, 148, 0, 0, 1466, 211, 1, 0, 0,
        0, 1467, 1468, 3, 170, 85, 0, 1468, 1470, 3, 266, 133, 0, 1469, 1471, 3, 286, 143, 0, 1470,
        1469, 1, 0, 0, 0, 1470, 1471, 1, 0, 0, 0, 1471, 1472, 1, 0, 0, 0, 1472, 1473, 5, 153, 0, 0,
        1473, 213, 1, 0, 0, 0, 1474, 1478, 3, 216, 108, 0, 1475, 1477, 3, 208, 104, 0, 1476, 1475,
        1, 0, 0, 0, 1477, 1480, 1, 0, 0, 0, 1478, 1476, 1, 0, 0, 0, 1478, 1479, 1, 0, 0, 0, 1479,
        1482, 1, 0, 0, 0, 1480, 1478, 1, 0, 0, 0, 1481, 1483, 3, 362, 181, 0, 1482, 1481, 1, 0, 0,
        0, 1482, 1483, 1, 0, 0, 0, 1483, 1484, 1, 0, 0, 0, 1484, 1485, 5, 149, 0, 0, 1485, 1486, 3,
        218, 109, 0, 1486, 1487, 5, 150, 0, 0, 1487, 1498, 1, 0, 0, 0, 1488, 1492, 3, 216, 108, 0,
        1489, 1491, 3, 208, 104, 0, 1490, 1489, 1, 0, 0, 0, 1491, 1494, 1, 0, 0, 0, 1492, 1490, 1,
        0, 0, 0, 1492, 1493, 1, 0, 0, 0, 1493, 1495, 1, 0, 0, 0, 1494, 1492, 1, 0, 0, 0, 1495, 1496,
        3, 362, 181, 0, 1496, 1498, 1, 0, 0, 0, 1497, 1474, 1, 0, 0, 0, 1497, 1488, 1, 0, 0, 0,
        1498, 215, 1, 0, 0, 0, 1499, 1500, 7, 3, 0, 0, 1500, 217, 1, 0, 0, 0, 1501, 1503, 3, 220,
        110, 0, 1502, 1501, 1, 0, 0, 0, 1503, 1504, 1, 0, 0, 0, 1504, 1502, 1, 0, 0, 0, 1504, 1505,
        1, 0, 0, 0, 1505, 219, 1, 0, 0, 0, 1506, 1508, 3, 208, 104, 0, 1507, 1506, 1, 0, 0, 0, 1508,
        1511, 1, 0, 0, 0, 1509, 1507, 1, 0, 0, 0, 1509, 1510, 1, 0, 0, 0, 1510, 1512, 1, 0, 0, 0,
        1511, 1509, 1, 0, 0, 0, 1512, 1513, 3, 222, 111, 0, 1513, 1514, 3, 266, 133, 0, 1514, 1515,
        5, 153, 0, 0, 1515, 1527, 1, 0, 0, 0, 1516, 1518, 3, 208, 104, 0, 1517, 1516, 1, 0, 0, 0,
        1518, 1521, 1, 0, 0, 0, 1519, 1517, 1, 0, 0, 0, 1519, 1520, 1, 0, 0, 0, 1520, 1522, 1, 0, 0,
        0, 1521, 1519, 1, 0, 0, 0, 1522, 1523, 3, 222, 111, 0, 1523, 1524, 5, 153, 0, 0, 1524, 1527,
        1, 0, 0, 0, 1525, 1527, 3, 296, 148, 0, 1526, 1509, 1, 0, 0, 0, 1526, 1519, 1, 0, 0, 0,
        1526, 1525, 1, 0, 0, 0, 1527, 221, 1, 0, 0, 0, 1528, 1531, 3, 252, 126, 0, 1529, 1531, 3,
        242, 121, 0, 1530, 1528, 1, 0, 0, 0, 1530, 1529, 1, 0, 0, 0, 1531, 1533, 1, 0, 0, 0, 1532,
        1534, 3, 222, 111, 0, 1533, 1532, 1, 0, 0, 0, 1533, 1534, 1, 0, 0, 0, 1534, 223, 1, 0, 0, 0,
        1535, 1541, 5, 11, 0, 0, 1536, 1538, 3, 362, 181, 0, 1537, 1536, 1, 0, 0, 0, 1537, 1538, 1,
        0, 0, 0, 1538, 1539, 1, 0, 0, 0, 1539, 1540, 5, 164, 0, 0, 1540, 1542, 3, 184, 92, 0, 1541,
        1537, 1, 0, 0, 0, 1541, 1542, 1, 0, 0, 0, 1542, 1554, 1, 0, 0, 0, 1543, 1548, 3, 362, 181,
        0, 1544, 1545, 5, 149, 0, 0, 1545, 1546, 3, 226, 113, 0, 1546, 1547, 5, 150, 0, 0, 1547,
        1549, 1, 0, 0, 0, 1548, 1544, 1, 0, 0, 0, 1548, 1549, 1, 0, 0, 0, 1549, 1555, 1, 0, 0, 0,
        1550, 1551, 5, 149, 0, 0, 1551, 1552, 3, 226, 113, 0, 1552, 1553, 5, 150, 0, 0, 1553, 1555,
        1, 0, 0, 0, 1554, 1543, 1, 0, 0, 0, 1554, 1550, 1, 0, 0, 0, 1555, 1567, 1, 0, 0, 0, 1556,
        1557, 7, 4, 0, 0, 1557, 1558, 5, 147, 0, 0, 1558, 1559, 3, 184, 92, 0, 1559, 1560, 5, 154,
        0, 0, 1560, 1561, 3, 362, 181, 0, 1561, 1562, 5, 148, 0, 0, 1562, 1563, 5, 149, 0, 0, 1563,
        1564, 3, 226, 113, 0, 1564, 1565, 5, 150, 0, 0, 1565, 1567, 1, 0, 0, 0, 1566, 1535, 1, 0, 0,
        0, 1566, 1556, 1, 0, 0, 0, 1567, 225, 1, 0, 0, 0, 1568, 1573, 3, 228, 114, 0, 1569, 1570, 5,
        154, 0, 0, 1570, 1572, 3, 228, 114, 0, 1571, 1569, 1, 0, 0, 0, 1572, 1575, 1, 0, 0, 0, 1573,
        1571, 1, 0, 0, 0, 1573, 1574, 1, 0, 0, 0, 1574, 1577, 1, 0, 0, 0, 1575, 1573, 1, 0, 0, 0,
        1576, 1578, 5, 154, 0, 0, 1577, 1576, 1, 0, 0, 0, 1577, 1578, 1, 0, 0, 0, 1578, 227, 1, 0,
        0, 0, 1579, 1582, 3, 230, 115, 0, 1580, 1581, 5, 158, 0, 0, 1581, 1583, 3, 332, 166, 0,
        1582, 1580, 1, 0, 0, 0, 1582, 1583, 1, 0, 0, 0, 1583, 229, 1, 0, 0, 0, 1584, 1585, 3, 362,
        181, 0, 1585, 231, 1, 0, 0, 0, 1586, 1587, 5, 137, 0, 0, 1587, 1588, 5, 147, 0, 0, 1588,
        1589, 3, 362, 181, 0, 1589, 1590, 5, 148, 0, 0, 1590, 1593, 1, 0, 0, 0, 1591, 1593, 5, 136,
        0, 0, 1592, 1586, 1, 0, 0, 0, 1592, 1591, 1, 0, 0, 0, 1593, 233, 1, 0, 0, 0, 1594, 1595, 7,
        5, 0, 0, 1595, 235, 1, 0, 0, 0, 1596, 1597, 7, 6, 0, 0, 1597, 237, 1, 0, 0, 0, 1598, 1599,
        7, 7, 0, 0, 1599, 239, 1, 0, 0, 0, 1600, 1601, 7, 8, 0, 0, 1601, 241, 1, 0, 0, 0, 1602,
        1608, 5, 5, 0, 0, 1603, 1608, 5, 33, 0, 0, 1604, 1608, 5, 21, 0, 0, 1605, 1608, 5, 115, 0,
        0, 1606, 1608, 3, 248, 124, 0, 1607, 1602, 1, 0, 0, 0, 1607, 1603, 1, 0, 0, 0, 1607, 1604,
        1, 0, 0, 0, 1607, 1605, 1, 0, 0, 0, 1607, 1606, 1, 0, 0, 0, 1608, 243, 1, 0, 0, 0, 1609,
        1617, 7, 9, 0, 0, 1610, 1617, 3, 274, 137, 0, 1611, 1612, 5, 106, 0, 0, 1612, 1613, 5, 147,
        0, 0, 1613, 1614, 3, 362, 181, 0, 1614, 1615, 5, 148, 0, 0, 1615, 1617, 1, 0, 0, 0, 1616,
        1609, 1, 0, 0, 0, 1616, 1610, 1, 0, 0, 0, 1616, 1611, 1, 0, 0, 0, 1617, 245, 1, 0, 0, 0,
        1618, 1619, 5, 117, 0, 0, 1619, 1622, 5, 147, 0, 0, 1620, 1623, 3, 184, 92, 0, 1621, 1623,
        3, 342, 171, 0, 1622, 1620, 1, 0, 0, 0, 1622, 1621, 1, 0, 0, 0, 1623, 1624, 1, 0, 0, 0,
        1624, 1625, 5, 148, 0, 0, 1625, 247, 1, 0, 0, 0, 1626, 1627, 7, 10, 0, 0, 1627, 249, 1, 0,
        0, 0, 1628, 1630, 3, 264, 132, 0, 1629, 1631, 3, 282, 141, 0, 1630, 1629, 1, 0, 0, 0, 1630,
        1631, 1, 0, 0, 0, 1631, 1653, 1, 0, 0, 0, 1632, 1653, 3, 254, 127, 0, 1633, 1635, 5, 95, 0,
        0, 1634, 1633, 1, 0, 0, 0, 1634, 1635, 1, 0, 0, 0, 1635, 1636, 1, 0, 0, 0, 1636, 1638, 3,
        258, 129, 0, 1637, 1639, 3, 282, 141, 0, 1638, 1637, 1, 0, 0, 0, 1638, 1639, 1, 0, 0, 0,
        1639, 1653, 1, 0, 0, 0, 1640, 1642, 3, 214, 107, 0, 1641, 1643, 3, 282, 141, 0, 1642, 1641,
        1, 0, 0, 0, 1642, 1643, 1, 0, 0, 0, 1643, 1653, 1, 0, 0, 0, 1644, 1653, 3, 224, 112, 0,
        1645, 1647, 5, 95, 0, 0, 1646, 1645, 1, 0, 0, 0, 1646, 1647, 1, 0, 0, 0, 1647, 1648, 1, 0,
        0, 0, 1648, 1650, 3, 362, 181, 0, 1649, 1651, 3, 282, 141, 0, 1650, 1649, 1, 0, 0, 0, 1650,
        1651, 1, 0, 0, 0, 1651, 1653, 1, 0, 0, 0, 1652, 1628, 1, 0, 0, 0, 1652, 1632, 1, 0, 0, 0,
        1652, 1634, 1, 0, 0, 0, 1652, 1640, 1, 0, 0, 0, 1652, 1644, 1, 0, 0, 0, 1652, 1646, 1, 0, 0,
        0, 1653, 251, 1, 0, 0, 0, 1654, 1666, 3, 264, 132, 0, 1655, 1656, 5, 111, 0, 0, 1656, 1657,
        5, 147, 0, 0, 1657, 1658, 7, 11, 0, 0, 1658, 1666, 5, 148, 0, 0, 1659, 1666, 3, 258, 129, 0,
        1660, 1666, 3, 210, 105, 0, 1661, 1666, 3, 214, 107, 0, 1662, 1666, 3, 224, 112, 0, 1663,
        1666, 3, 256, 128, 0, 1664, 1666, 3, 254, 127, 0, 1665, 1654, 1, 0, 0, 0, 1665, 1655, 1, 0,
        0, 0, 1665, 1659, 1, 0, 0, 0, 1665, 1660, 1, 0, 0, 0, 1665, 1661, 1, 0, 0, 0, 1665, 1662, 1,
        0, 0, 0, 1665, 1663, 1, 0, 0, 0, 1665, 1664, 1, 0, 0, 0, 1666, 253, 1, 0, 0, 0, 1667, 1668,
        5, 97, 0, 0, 1668, 1669, 5, 147, 0, 0, 1669, 1670, 3, 332, 166, 0, 1670, 1671, 5, 148, 0, 0,
        1671, 255, 1, 0, 0, 0, 1672, 1673, 3, 362, 181, 0, 1673, 257, 1, 0, 0, 0, 1674, 1675, 3,
        362, 181, 0, 1675, 1676, 3, 260, 130, 0, 1676, 259, 1, 0, 0, 0, 1677, 1686, 5, 160, 0, 0,
        1678, 1683, 3, 262, 131, 0, 1679, 1680, 5, 154, 0, 0, 1680, 1682, 3, 262, 131, 0, 1681,
        1679, 1, 0, 0, 0, 1682, 1685, 1, 0, 0, 0, 1683, 1681, 1, 0, 0, 0, 1683, 1684, 1, 0, 0, 0,
        1684, 1687, 1, 0, 0, 0, 1685, 1683, 1, 0, 0, 0, 1686, 1678, 1, 0, 0, 0, 1686, 1687, 1, 0, 0,
        0, 1687, 1688, 1, 0, 0, 0, 1688, 1689, 5, 159, 0, 0, 1689, 261, 1, 0, 0, 0, 1690, 1692, 7,
        1, 0, 0, 1691, 1690, 1, 0, 0, 0, 1691, 1692, 1, 0, 0, 0, 1692, 1693, 1, 0, 0, 0, 1693, 1694,
        3, 184, 92, 0, 1694, 263, 1, 0, 0, 0, 1695, 1696, 7, 12, 0, 0, 1696, 265, 1, 0, 0, 0, 1697,
        1702, 3, 268, 134, 0, 1698, 1699, 5, 154, 0, 0, 1699, 1701, 3, 268, 134, 0, 1700, 1698, 1,
        0, 0, 0, 1701, 1704, 1, 0, 0, 0, 1702, 1700, 1, 0, 0, 0, 1702, 1703, 1, 0, 0, 0, 1703, 267,
        1, 0, 0, 0, 1704, 1702, 1, 0, 0, 0, 1705, 1712, 3, 178, 89, 0, 1706, 1708, 3, 178, 89, 0,
        1707, 1706, 1, 0, 0, 0, 1707, 1708, 1, 0, 0, 0, 1708, 1709, 1, 0, 0, 0, 1709, 1710, 5, 164,
        0, 0, 1710, 1712, 3, 342, 171, 0, 1711, 1705, 1, 0, 0, 0, 1711, 1707, 1, 0, 0, 0, 1712, 269,
        1, 0, 0, 0, 1713, 1714, 7, 13, 0, 0, 1714, 271, 1, 0, 0, 0, 1715, 1716, 5, 102, 0, 0, 1716,
        1718, 5, 147, 0, 0, 1717, 1719, 3, 360, 180, 0, 1718, 1717, 1, 0, 0, 0, 1719, 1720, 1, 0, 0,
        0, 1720, 1718, 1, 0, 0, 0, 1720, 1721, 1, 0, 0, 0, 1721, 1722, 1, 0, 0, 0, 1722, 1723, 5,
        148, 0, 0, 1723, 1726, 1, 0, 0, 0, 1724, 1726, 3, 274, 137, 0, 1725, 1715, 1, 0, 0, 0, 1725,
        1724, 1, 0, 0, 0, 1726, 273, 1, 0, 0, 0, 1727, 1728, 5, 86, 0, 0, 1728, 1729, 5, 147, 0, 0,
        1729, 1730, 5, 147, 0, 0, 1730, 1731, 3, 276, 138, 0, 1731, 1732, 5, 148, 0, 0, 1732, 1733,
        5, 148, 0, 0, 1733, 275, 1, 0, 0, 0, 1734, 1736, 3, 278, 139, 0, 1735, 1734, 1, 0, 0, 0,
        1735, 1736, 1, 0, 0, 0, 1736, 1743, 1, 0, 0, 0, 1737, 1739, 5, 154, 0, 0, 1738, 1740, 3,
        278, 139, 0, 1739, 1738, 1, 0, 0, 0, 1739, 1740, 1, 0, 0, 0, 1740, 1742, 1, 0, 0, 0, 1741,
        1737, 1, 0, 0, 0, 1742, 1745, 1, 0, 0, 0, 1743, 1741, 1, 0, 0, 0, 1743, 1744, 1, 0, 0, 0,
        1744, 277, 1, 0, 0, 0, 1745, 1743, 1, 0, 0, 0, 1746, 1752, 8, 14, 0, 0, 1747, 1749, 5, 147,
        0, 0, 1748, 1750, 3, 352, 176, 0, 1749, 1748, 1, 0, 0, 0, 1749, 1750, 1, 0, 0, 0, 1750,
        1751, 1, 0, 0, 0, 1751, 1753, 5, 148, 0, 0, 1752, 1747, 1, 0, 0, 0, 1752, 1753, 1, 0, 0, 0,
        1753, 279, 1, 0, 0, 0, 1754, 1756, 5, 175, 0, 0, 1755, 1757, 3, 170, 85, 0, 1756, 1755, 1,
        0, 0, 0, 1756, 1757, 1, 0, 0, 0, 1757, 1759, 1, 0, 0, 0, 1758, 1760, 3, 282, 141, 0, 1759,
        1758, 1, 0, 0, 0, 1759, 1760, 1, 0, 0, 0, 1760, 281, 1, 0, 0, 0, 1761, 1763, 3, 284, 142, 0,
        1762, 1761, 1, 0, 0, 0, 1763, 1764, 1, 0, 0, 0, 1764, 1762, 1, 0, 0, 0, 1764, 1765, 1, 0, 0,
        0, 1765, 283, 1, 0, 0, 0, 1766, 1768, 5, 175, 0, 0, 1767, 1769, 3, 202, 101, 0, 1768, 1767,
        1, 0, 0, 0, 1768, 1769, 1, 0, 0, 0, 1769, 1771, 1, 0, 0, 0, 1770, 1772, 3, 236, 118, 0,
        1771, 1770, 1, 0, 0, 0, 1771, 1772, 1, 0, 0, 0, 1772, 285, 1, 0, 0, 0, 1773, 1782, 3, 362,
        181, 0, 1774, 1777, 5, 147, 0, 0, 1775, 1778, 5, 154, 0, 0, 1776, 1778, 8, 15, 0, 0, 1777,
        1775, 1, 0, 0, 0, 1777, 1776, 1, 0, 0, 0, 1778, 1779, 1, 0, 0, 0, 1779, 1777, 1, 0, 0, 0,
        1779, 1780, 1, 0, 0, 0, 1780, 1781, 1, 0, 0, 0, 1781, 1783, 5, 148, 0, 0, 1782, 1774, 1, 0,
        0, 0, 1782, 1783, 1, 0, 0, 0, 1783, 287, 1, 0, 0, 0, 1784, 1796, 5, 149, 0, 0, 1785, 1790,
        3, 332, 166, 0, 1786, 1787, 5, 154, 0, 0, 1787, 1789, 3, 332, 166, 0, 1788, 1786, 1, 0, 0,
        0, 1789, 1792, 1, 0, 0, 0, 1790, 1788, 1, 0, 0, 0, 1790, 1791, 1, 0, 0, 0, 1791, 1794, 1, 0,
        0, 0, 1792, 1790, 1, 0, 0, 0, 1793, 1795, 5, 154, 0, 0, 1794, 1793, 1, 0, 0, 0, 1794, 1795,
        1, 0, 0, 0, 1795, 1797, 1, 0, 0, 0, 1796, 1785, 1, 0, 0, 0, 1796, 1797, 1, 0, 0, 0, 1797,
        1798, 1, 0, 0, 0, 1798, 1799, 5, 150, 0, 0, 1799, 289, 1, 0, 0, 0, 1800, 1812, 5, 149, 0, 0,
        1801, 1806, 3, 292, 146, 0, 1802, 1803, 5, 154, 0, 0, 1803, 1805, 3, 292, 146, 0, 1804,
        1802, 1, 0, 0, 0, 1805, 1808, 1, 0, 0, 0, 1806, 1804, 1, 0, 0, 0, 1806, 1807, 1, 0, 0, 0,
        1807, 1810, 1, 0, 0, 0, 1808, 1806, 1, 0, 0, 0, 1809, 1811, 5, 154, 0, 0, 1810, 1809, 1, 0,
        0, 0, 1810, 1811, 1, 0, 0, 0, 1811, 1813, 1, 0, 0, 0, 1812, 1801, 1, 0, 0, 0, 1812, 1813, 1,
        0, 0, 0, 1813, 1814, 1, 0, 0, 0, 1814, 1815, 5, 150, 0, 0, 1815, 291, 1, 0, 0, 0, 1816,
        1817, 5, 155, 0, 0, 1817, 1821, 3, 332, 166, 0, 1818, 1821, 3, 290, 145, 0, 1819, 1821, 3,
        288, 144, 0, 1820, 1816, 1, 0, 0, 0, 1820, 1818, 1, 0, 0, 0, 1820, 1819, 1, 0, 0, 0, 1821,
        293, 1, 0, 0, 0, 1822, 1827, 3, 340, 170, 0, 1823, 1824, 5, 154, 0, 0, 1824, 1826, 3, 340,
        170, 0, 1825, 1823, 1, 0, 0, 0, 1826, 1829, 1, 0, 0, 0, 1827, 1825, 1, 0, 0, 0, 1827, 1828,
        1, 0, 0, 0, 1828, 1831, 1, 0, 0, 0, 1829, 1827, 1, 0, 0, 0, 1830, 1832, 5, 154, 0, 0, 1831,
        1830, 1, 0, 0, 0, 1831, 1832, 1, 0, 0, 0, 1832, 295, 1, 0, 0, 0, 1833, 1834, 5, 119, 0, 0,
        1834, 1835, 5, 147, 0, 0, 1835, 1836, 3, 342, 171, 0, 1836, 1838, 5, 154, 0, 0, 1837, 1839,
        3, 360, 180, 0, 1838, 1837, 1, 0, 0, 0, 1839, 1840, 1, 0, 0, 0, 1840, 1838, 1, 0, 0, 0,
        1840, 1841, 1, 0, 0, 0, 1841, 1842, 1, 0, 0, 0, 1842, 1843, 5, 148, 0, 0, 1843, 1844, 5,
        153, 0, 0, 1844, 297, 1, 0, 0, 0, 1845, 1847, 3, 300, 150, 0, 1846, 1848, 5, 153, 0, 0,
        1847, 1846, 1, 0, 0, 0, 1847, 1848, 1, 0, 0, 0, 1848, 1884, 1, 0, 0, 0, 1849, 1851, 3, 304,
        152, 0, 1850, 1852, 5, 153, 0, 0, 1851, 1850, 1, 0, 0, 0, 1851, 1852, 1, 0, 0, 0, 1852,
        1884, 1, 0, 0, 0, 1853, 1855, 3, 306, 153, 0, 1854, 1856, 5, 153, 0, 0, 1855, 1854, 1, 0, 0,
        0, 1855, 1856, 1, 0, 0, 0, 1856, 1884, 1, 0, 0, 0, 1857, 1859, 3, 316, 158, 0, 1858, 1860,
        5, 153, 0, 0, 1859, 1858, 1, 0, 0, 0, 1859, 1860, 1, 0, 0, 0, 1860, 1884, 1, 0, 0, 0, 1861,
        1862, 3, 328, 164, 0, 1862, 1863, 5, 153, 0, 0, 1863, 1884, 1, 0, 0, 0, 1864, 1866, 3, 122,
        61, 0, 1865, 1867, 5, 153, 0, 0, 1866, 1865, 1, 0, 0, 0, 1866, 1867, 1, 0, 0, 0, 1867, 1884,
        1, 0, 0, 0, 1868, 1870, 3, 124, 62, 0, 1869, 1871, 5, 153, 0, 0, 1870, 1869, 1, 0, 0, 0,
        1870, 1871, 1, 0, 0, 0, 1871, 1884, 1, 0, 0, 0, 1872, 1873, 3, 116, 58, 0, 1873, 1874, 5,
        153, 0, 0, 1874, 1884, 1, 0, 0, 0, 1875, 1877, 3, 118, 59, 0, 1876, 1878, 5, 153, 0, 0,
        1877, 1876, 1, 0, 0, 0, 1877, 1878, 1, 0, 0, 0, 1878, 1884, 1, 0, 0, 0, 1879, 1880, 3, 330,
        165, 0, 1880, 1881, 5, 153, 0, 0, 1881, 1884, 1, 0, 0, 0, 1882, 1884, 5, 153, 0, 0, 1883,
        1845, 1, 0, 0, 0, 1883, 1849, 1, 0, 0, 0, 1883, 1853, 1, 0, 0, 0, 1883, 1857, 1, 0, 0, 0,
        1883, 1861, 1, 0, 0, 0, 1883, 1864, 1, 0, 0, 0, 1883, 1868, 1, 0, 0, 0, 1883, 1872, 1, 0, 0,
        0, 1883, 1875, 1, 0, 0, 0, 1883, 1879, 1, 0, 0, 0, 1883, 1882, 1, 0, 0, 0, 1884, 299, 1, 0,
        0, 0, 1885, 1886, 3, 362, 181, 0, 1886, 1887, 5, 164, 0, 0, 1887, 1888, 3, 298, 149, 0,
        1888, 301, 1, 0, 0, 0, 1889, 1892, 3, 332, 166, 0, 1890, 1891, 5, 191, 0, 0, 1891, 1893, 3,
        332, 166, 0, 1892, 1890, 1, 0, 0, 0, 1892, 1893, 1, 0, 0, 0, 1893, 303, 1, 0, 0, 0, 1894,
        1899, 5, 149, 0, 0, 1895, 1898, 3, 298, 149, 0, 1896, 1898, 3, 172, 86, 0, 1897, 1895, 1, 0,
        0, 0, 1897, 1896, 1, 0, 0, 0, 1898, 1901, 1, 0, 0, 0, 1899, 1897, 1, 0, 0, 0, 1899, 1900, 1,
        0, 0, 0, 1900, 1902, 1, 0, 0, 0, 1901, 1899, 1, 0, 0, 0, 1902, 1903, 5, 150, 0, 0, 1903,
        305, 1, 0, 0, 0, 1904, 1905, 5, 16, 0, 0, 1905, 1906, 5, 147, 0, 0, 1906, 1907, 3, 330, 165,
        0, 1907, 1908, 5, 148, 0, 0, 1908, 1911, 3, 298, 149, 0, 1909, 1910, 5, 10, 0, 0, 1910,
        1912, 3, 298, 149, 0, 1911, 1909, 1, 0, 0, 0, 1911, 1912, 1, 0, 0, 0, 1912, 1915, 1, 0, 0,
        0, 1913, 1915, 3, 308, 154, 0, 1914, 1904, 1, 0, 0, 0, 1914, 1913, 1, 0, 0, 0, 1915, 307, 1,
        0, 0, 0, 1916, 1917, 5, 28, 0, 0, 1917, 1918, 5, 147, 0, 0, 1918, 1919, 3, 332, 166, 0,
        1919, 1920, 5, 148, 0, 0, 1920, 1921, 3, 310, 155, 0, 1921, 309, 1, 0, 0, 0, 1922, 1926, 5,
        149, 0, 0, 1923, 1925, 3, 312, 156, 0, 1924, 1923, 1, 0, 0, 0, 1925, 1928, 1, 0, 0, 0, 1926,
        1924, 1, 0, 0, 0, 1926, 1927, 1, 0, 0, 0, 1927, 1929, 1, 0, 0, 0, 1928, 1926, 1, 0, 0, 0,
        1929, 1930, 5, 150, 0, 0, 1930, 311, 1, 0, 0, 0, 1931, 1933, 3, 314, 157, 0, 1932, 1931, 1,
        0, 0, 0, 1933, 1934, 1, 0, 0, 0, 1934, 1932, 1, 0, 0, 0, 1934, 1935, 1, 0, 0, 0, 1935, 1937,
        1, 0, 0, 0, 1936, 1938, 3, 298, 149, 0, 1937, 1936, 1, 0, 0, 0, 1938, 1939, 1, 0, 0, 0,
        1939, 1937, 1, 0, 0, 0, 1939, 1940, 1, 0, 0, 0, 1940, 313, 1, 0, 0, 0, 1941, 1947, 5, 3, 0,
        0, 1942, 1948, 3, 302, 151, 0, 1943, 1944, 5, 147, 0, 0, 1944, 1945, 3, 302, 151, 0, 1945,
        1946, 5, 148, 0, 0, 1946, 1948, 1, 0, 0, 0, 1947, 1942, 1, 0, 0, 0, 1947, 1943, 1, 0, 0, 0,
        1948, 1949, 1, 0, 0, 0, 1949, 1950, 5, 164, 0, 0, 1950, 1954, 1, 0, 0, 0, 1951, 1952, 5, 7,
        0, 0, 1952, 1954, 5, 164, 0, 0, 1953, 1941, 1, 0, 0, 0, 1953, 1951, 1, 0, 0, 0, 1954, 315,
        1, 0, 0, 0, 1955, 1960, 3, 318, 159, 0, 1956, 1960, 3, 320, 160, 0, 1957, 1960, 3, 322, 161,
        0, 1958, 1960, 3, 326, 163, 0, 1959, 1955, 1, 0, 0, 0, 1959, 1956, 1, 0, 0, 0, 1959, 1957,
        1, 0, 0, 0, 1959, 1958, 1, 0, 0, 0, 1960, 317, 1, 0, 0, 0, 1961, 1962, 5, 34, 0, 0, 1962,
        1963, 5, 147, 0, 0, 1963, 1964, 3, 332, 166, 0, 1964, 1965, 5, 148, 0, 0, 1965, 1966, 3,
        298, 149, 0, 1966, 319, 1, 0, 0, 0, 1967, 1968, 5, 8, 0, 0, 1968, 1969, 3, 298, 149, 0,
        1969, 1970, 5, 34, 0, 0, 1970, 1971, 5, 147, 0, 0, 1971, 1972, 3, 332, 166, 0, 1972, 1973,
        5, 148, 0, 0, 1973, 1974, 5, 153, 0, 0, 1974, 321, 1, 0, 0, 0, 1975, 1976, 5, 14, 0, 0,
        1976, 1978, 5, 147, 0, 0, 1977, 1979, 3, 324, 162, 0, 1978, 1977, 1, 0, 0, 0, 1978, 1979, 1,
        0, 0, 0, 1979, 1980, 1, 0, 0, 0, 1980, 1982, 5, 153, 0, 0, 1981, 1983, 3, 332, 166, 0, 1982,
        1981, 1, 0, 0, 0, 1982, 1983, 1, 0, 0, 0, 1983, 1984, 1, 0, 0, 0, 1984, 1986, 5, 153, 0, 0,
        1985, 1987, 3, 330, 165, 0, 1986, 1985, 1, 0, 0, 0, 1986, 1987, 1, 0, 0, 0, 1987, 1988, 1,
        0, 0, 0, 1988, 1989, 5, 148, 0, 0, 1989, 1990, 3, 298, 149, 0, 1990, 323, 1, 0, 0, 0, 1991,
        1992, 3, 170, 85, 0, 1992, 1993, 3, 174, 87, 0, 1993, 1996, 1, 0, 0, 0, 1994, 1996, 3, 330,
        165, 0, 1995, 1991, 1, 0, 0, 0, 1995, 1994, 1, 0, 0, 0, 1996, 325, 1, 0, 0, 0, 1997, 1998,
        5, 14, 0, 0, 1998, 1999, 5, 147, 0, 0, 1999, 2000, 3, 114, 57, 0, 2000, 2002, 5, 48, 0, 0,
        2001, 2003, 3, 332, 166, 0, 2002, 2001, 1, 0, 0, 0, 2002, 2003, 1, 0, 0, 0, 2003, 2004, 1,
        0, 0, 0, 2004, 2005, 5, 148, 0, 0, 2005, 2006, 3, 298, 149, 0, 2006, 327, 1, 0, 0, 0, 2007,
        2008, 5, 15, 0, 0, 2008, 2016, 3, 362, 181, 0, 2009, 2016, 5, 6, 0, 0, 2010, 2016, 5, 2, 0,
        0, 2011, 2013, 5, 22, 0, 0, 2012, 2014, 3, 332, 166, 0, 2013, 2012, 1, 0, 0, 0, 2013, 2014,
        1, 0, 0, 0, 2014, 2016, 1, 0, 0, 0, 2015, 2007, 1, 0, 0, 0, 2015, 2009, 1, 0, 0, 0, 2015,
        2010, 1, 0, 0, 0, 2015, 2011, 1, 0, 0, 0, 2016, 329, 1, 0, 0, 0, 2017, 2022, 3, 332, 166, 0,
        2018, 2019, 5, 154, 0, 0, 2019, 2021, 3, 332, 166, 0, 2020, 2018, 1, 0, 0, 0, 2021, 2024, 1,
        0, 0, 0, 2022, 2020, 1, 0, 0, 0, 2022, 2023, 1, 0, 0, 0, 2023, 331, 1, 0, 0, 0, 2024, 2022,
        1, 0, 0, 0, 2025, 2026, 6, 166, -1, 0, 2026, 2033, 3, 338, 169, 0, 2027, 2033, 3, 334, 167,
        0, 2028, 2029, 5, 147, 0, 0, 2029, 2030, 3, 304, 152, 0, 2030, 2031, 5, 148, 0, 0, 2031,
        2033, 1, 0, 0, 0, 2032, 2025, 1, 0, 0, 0, 2032, 2027, 1, 0, 0, 0, 2032, 2028, 1, 0, 0, 0,
        2033, 2078, 1, 0, 0, 0, 2034, 2035, 10, 13, 0, 0, 2035, 2036, 7, 16, 0, 0, 2036, 2077, 3,
        332, 166, 14, 2037, 2038, 10, 12, 0, 0, 2038, 2039, 7, 17, 0, 0, 2039, 2077, 3, 332, 166,
        13, 2040, 2045, 10, 11, 0, 0, 2041, 2042, 5, 160, 0, 0, 2042, 2046, 5, 160, 0, 0, 2043,
        2044, 5, 159, 0, 0, 2044, 2046, 5, 159, 0, 0, 2045, 2041, 1, 0, 0, 0, 2045, 2043, 1, 0, 0,
        0, 2046, 2047, 1, 0, 0, 0, 2047, 2077, 3, 332, 166, 12, 2048, 2049, 10, 10, 0, 0, 2049,
        2050, 7, 18, 0, 0, 2050, 2077, 3, 332, 166, 11, 2051, 2052, 10, 9, 0, 0, 2052, 2053, 7, 19,
        0, 0, 2053, 2077, 3, 332, 166, 10, 2054, 2055, 10, 8, 0, 0, 2055, 2056, 5, 177, 0, 0, 2056,
        2077, 3, 332, 166, 9, 2057, 2058, 10, 7, 0, 0, 2058, 2059, 5, 179, 0, 0, 2059, 2077, 3, 332,
        166, 8, 2060, 2061, 10, 6, 0, 0, 2061, 2062, 5, 178, 0, 0, 2062, 2077, 3, 332, 166, 7, 2063,
        2064, 10, 5, 0, 0, 2064, 2065, 5, 169, 0, 0, 2065, 2077, 3, 332, 166, 6, 2066, 2067, 10, 4,
        0, 0, 2067, 2068, 5, 170, 0, 0, 2068, 2077, 3, 332, 166, 5, 2069, 2070, 10, 3, 0, 0, 2070,
        2072, 5, 163, 0, 0, 2071, 2073, 3, 332, 166, 0, 2072, 2071, 1, 0, 0, 0, 2072, 2073, 1, 0, 0,
        0, 2073, 2074, 1, 0, 0, 0, 2074, 2075, 5, 164, 0, 0, 2075, 2077, 3, 332, 166, 4, 2076, 2034,
        1, 0, 0, 0, 2076, 2037, 1, 0, 0, 0, 2076, 2040, 1, 0, 0, 0, 2076, 2048, 1, 0, 0, 0, 2076,
        2051, 1, 0, 0, 0, 2076, 2054, 1, 0, 0, 0, 2076, 2057, 1, 0, 0, 0, 2076, 2060, 1, 0, 0, 0,
        2076, 2063, 1, 0, 0, 0, 2076, 2066, 1, 0, 0, 0, 2076, 2069, 1, 0, 0, 0, 2077, 2080, 1, 0, 0,
        0, 2078, 2076, 1, 0, 0, 0, 2078, 2079, 1, 0, 0, 0, 2079, 333, 1, 0, 0, 0, 2080, 2078, 1, 0,
        0, 0, 2081, 2082, 3, 344, 172, 0, 2082, 2083, 3, 336, 168, 0, 2083, 2084, 3, 332, 166, 0,
        2084, 335, 1, 0, 0, 0, 2085, 2086, 7, 20, 0, 0, 2086, 337, 1, 0, 0, 0, 2087, 2098, 3, 344,
        172, 0, 2088, 2090, 5, 111, 0, 0, 2089, 2088, 1, 0, 0, 0, 2089, 2090, 1, 0, 0, 0, 2090,
        2091, 1, 0, 0, 0, 2091, 2092, 5, 147, 0, 0, 2092, 2093, 3, 184, 92, 0, 2093, 2094, 5, 148,
        0, 0, 2094, 2095, 3, 338, 169, 0, 2095, 2098, 1, 0, 0, 0, 2096, 2098, 5, 198, 0, 0, 2097,
        2087, 1, 0, 0, 0, 2097, 2089, 1, 0, 0, 0, 2097, 2096, 1, 0, 0, 0, 2098, 339, 1, 0, 0, 0,
        2099, 2103, 3, 332, 166, 0, 2100, 2103, 3, 288, 144, 0, 2101, 2103, 3, 290, 145, 0, 2102,
        2099, 1, 0, 0, 0, 2102, 2100, 1, 0, 0, 0, 2102, 2101, 1, 0, 0, 0, 2103, 341, 1, 0, 0, 0,
        2104, 2107, 3, 362, 181, 0, 2105, 2107, 3, 358, 179, 0, 2106, 2104, 1, 0, 0, 0, 2106, 2105,
        1, 0, 0, 0, 2107, 343, 1, 0, 0, 0, 2108, 2123, 3, 348, 174, 0, 2109, 2115, 5, 25, 0, 0,
        2110, 2116, 3, 344, 172, 0, 2111, 2112, 5, 147, 0, 0, 2112, 2113, 3, 252, 126, 0, 2113,
        2114, 5, 148, 0, 0, 2114, 2116, 1, 0, 0, 0, 2115, 2110, 1, 0, 0, 0, 2115, 2111, 1, 0, 0, 0,
        2116, 2123, 1, 0, 0, 0, 2117, 2118, 7, 21, 0, 0, 2118, 2123, 3, 344, 172, 0, 2119, 2120, 3,
        346, 173, 0, 2120, 2121, 3, 338, 169, 0, 2121, 2123, 1, 0, 0, 0, 2122, 2108, 1, 0, 0, 0,
        2122, 2109, 1, 0, 0, 0, 2122, 2117, 1, 0, 0, 0, 2122, 2119, 1, 0, 0, 0, 2123, 345, 1, 0, 0,
        0, 2124, 2125, 7, 22, 0, 0, 2125, 347, 1, 0, 0, 0, 2126, 2127, 6, 174, -1, 0, 2127, 2131, 3,
        356, 178, 0, 2128, 2130, 3, 350, 175, 0, 2129, 2128, 1, 0, 0, 0, 2130, 2133, 1, 0, 0, 0,
        2131, 2129, 1, 0, 0, 0, 2131, 2132, 1, 0, 0, 0, 2132, 2145, 1, 0, 0, 0, 2133, 2131, 1, 0, 0,
        0, 2134, 2135, 10, 1, 0, 0, 2135, 2136, 7, 23, 0, 0, 2136, 2140, 3, 362, 181, 0, 2137, 2139,
        3, 350, 175, 0, 2138, 2137, 1, 0, 0, 0, 2139, 2142, 1, 0, 0, 0, 2140, 2138, 1, 0, 0, 0,
        2140, 2141, 1, 0, 0, 0, 2141, 2144, 1, 0, 0, 0, 2142, 2140, 1, 0, 0, 0, 2143, 2134, 1, 0, 0,
        0, 2144, 2147, 1, 0, 0, 0, 2145, 2143, 1, 0, 0, 0, 2145, 2146, 1, 0, 0, 0, 2146, 349, 1, 0,
        0, 0, 2147, 2145, 1, 0, 0, 0, 2148, 2149, 5, 151, 0, 0, 2149, 2150, 3, 332, 166, 0, 2150,
        2151, 5, 152, 0, 0, 2151, 2159, 1, 0, 0, 0, 2152, 2154, 5, 147, 0, 0, 2153, 2155, 3, 352,
        176, 0, 2154, 2153, 1, 0, 0, 0, 2154, 2155, 1, 0, 0, 0, 2155, 2156, 1, 0, 0, 0, 2156, 2159,
        5, 148, 0, 0, 2157, 2159, 7, 21, 0, 0, 2158, 2148, 1, 0, 0, 0, 2158, 2152, 1, 0, 0, 0, 2158,
        2157, 1, 0, 0, 0, 2159, 351, 1, 0, 0, 0, 2160, 2165, 3, 354, 177, 0, 2161, 2162, 5, 154, 0,
        0, 2162, 2164, 3, 354, 177, 0, 2163, 2161, 1, 0, 0, 0, 2164, 2167, 1, 0, 0, 0, 2165, 2163,
        1, 0, 0, 0, 2165, 2166, 1, 0, 0, 0, 2166, 353, 1, 0, 0, 0, 2167, 2165, 1, 0, 0, 0, 2168,
        2171, 3, 332, 166, 0, 2169, 2171, 3, 258, 129, 0, 2170, 2168, 1, 0, 0, 0, 2170, 2169, 1, 0,
        0, 0, 2171, 355, 1, 0, 0, 0, 2172, 2188, 3, 362, 181, 0, 2173, 2188, 3, 358, 179, 0, 2174,
        2188, 3, 360, 180, 0, 2175, 2176, 5, 147, 0, 0, 2176, 2177, 3, 332, 166, 0, 2177, 2178, 5,
        148, 0, 0, 2178, 2188, 1, 0, 0, 0, 2179, 2188, 3, 96, 48, 0, 2180, 2188, 3, 106, 53, 0,
        2181, 2188, 3, 110, 55, 0, 2182, 2188, 3, 112, 56, 0, 2183, 2188, 3, 84, 42, 0, 2184, 2188,
        3, 88, 44, 0, 2185, 2188, 3, 90, 45, 0, 2186, 2188, 3, 94, 47, 0, 2187, 2172, 1, 0, 0, 0,
        2187, 2173, 1, 0, 0, 0, 2187, 2174, 1, 0, 0, 0, 2187, 2175, 1, 0, 0, 0, 2187, 2179, 1, 0, 0,
        0, 2187, 2180, 1, 0, 0, 0, 2187, 2181, 1, 0, 0, 0, 2187, 2182, 1, 0, 0, 0, 2187, 2183, 1, 0,
        0, 0, 2187, 2184, 1, 0, 0, 0, 2187, 2185, 1, 0, 0, 0, 2187, 2186, 1, 0, 0, 0, 2188, 357, 1,
        0, 0, 0, 2189, 2208, 5, 194, 0, 0, 2190, 2208, 5, 195, 0, 0, 2191, 2208, 5, 196, 0, 0, 2192,
        2194, 7, 17, 0, 0, 2193, 2192, 1, 0, 0, 0, 2193, 2194, 1, 0, 0, 0, 2194, 2195, 1, 0, 0, 0,
        2195, 2208, 5, 197, 0, 0, 2196, 2198, 7, 17, 0, 0, 2197, 2196, 1, 0, 0, 0, 2197, 2198, 1, 0,
        0, 0, 2198, 2199, 1, 0, 0, 0, 2199, 2208, 5, 199, 0, 0, 2200, 2208, 5, 192, 0, 0, 2201,
        2208, 5, 50, 0, 0, 2202, 2208, 5, 52, 0, 0, 2203, 2208, 5, 59, 0, 0, 2204, 2208, 5, 51, 0,
        0, 2205, 2208, 5, 39, 0, 0, 2206, 2208, 5, 40, 0, 0, 2207, 2189, 1, 0, 0, 0, 2207, 2190, 1,
        0, 0, 0, 2207, 2191, 1, 0, 0, 0, 2207, 2193, 1, 0, 0, 0, 2207, 2197, 1, 0, 0, 0, 2207, 2200,
        1, 0, 0, 0, 2207, 2201, 1, 0, 0, 0, 2207, 2202, 1, 0, 0, 0, 2207, 2203, 1, 0, 0, 0, 2207,
        2204, 1, 0, 0, 0, 2207, 2205, 1, 0, 0, 0, 2207, 2206, 1, 0, 0, 0, 2208, 359, 1, 0, 0, 0,
        2209, 2213, 5, 193, 0, 0, 2210, 2212, 7, 24, 0, 0, 2211, 2210, 1, 0, 0, 0, 2212, 2215, 1, 0,
        0, 0, 2213, 2211, 1, 0, 0, 0, 2213, 2214, 1, 0, 0, 0, 2214, 2216, 1, 0, 0, 0, 2215, 2213, 1,
        0, 0, 0, 2216, 2218, 5, 206, 0, 0, 2217, 2209, 1, 0, 0, 0, 2218, 2219, 1, 0, 0, 0, 2219,
        2217, 1, 0, 0, 0, 2219, 2220, 1, 0, 0, 0, 2220, 361, 1, 0, 0, 0, 2221, 2222, 7, 25, 0, 0,
        2222, 363, 1, 0, 0, 0, 288, 367, 382, 389, 394, 397, 405, 407, 413, 419, 426, 429, 432, 439,
        442, 450, 452, 458, 462, 468, 481, 484, 491, 503, 508, 517, 523, 525, 537, 547, 554, 562,
        565, 568, 577, 591, 598, 601, 607, 616, 622, 624, 633, 635, 644, 650, 654, 663, 665, 674,
        678, 681, 684, 688, 694, 698, 700, 703, 709, 713, 723, 737, 744, 750, 759, 763, 765, 777,
        779, 791, 793, 798, 804, 807, 826, 835, 841, 843, 846, 854, 859, 865, 874, 879, 881, 903,
        910, 915, 939, 943, 948, 952, 956, 960, 969, 976, 983, 989, 994, 1001, 1008, 1013, 1016,
        1019, 1022, 1026, 1034, 1037, 1041, 1049, 1054, 1061, 1064, 1069, 1075, 1082, 1093, 1095,
        1105, 1115, 1118, 1123, 1127, 1132, 1139, 1145, 1148, 1154, 1168, 1187, 1192, 1195, 1202,
        1217, 1224, 1227, 1229, 1236, 1240, 1244, 1248, 1254, 1258, 1263, 1265, 1269, 1275, 1278,
        1287, 1292, 1295, 1301, 1317, 1323, 1331, 1335, 1339, 1344, 1347, 1354, 1373, 1379, 1382,
        1384, 1389, 1394, 1397, 1402, 1409, 1417, 1425, 1427, 1432, 1439, 1444, 1456, 1470, 1478,
        1482, 1492, 1497, 1504, 1509, 1519, 1526, 1530, 1533, 1537, 1541, 1548, 1554, 1566, 1573,
        1577, 1582, 1592, 1607, 1616, 1622, 1630, 1634, 1638, 1642, 1646, 1650, 1652, 1665, 1683,
        1686, 1691, 1702, 1707, 1711, 1720, 1725, 1735, 1739, 1743, 1749, 1752, 1756, 1759, 1764,
        1768, 1771, 1777, 1779, 1782, 1790, 1794, 1796, 1806, 1810, 1812, 1820, 1827, 1831, 1840,
        1847, 1851, 1855, 1859, 1866, 1870, 1877, 1883, 1892, 1897, 1899, 1911, 1914, 1926, 1934,
        1939, 1947, 1953, 1959, 1978, 1982, 1986, 1995, 2002, 2013, 2015, 2022, 2032, 2045, 2072,
        2076, 2078, 2089, 2097, 2102, 2106, 2115, 2122, 2131, 2140, 2145, 2154, 2158, 2165, 2170,
        2187, 2193, 2197, 2207, 2213, 2219,
    ]
}
