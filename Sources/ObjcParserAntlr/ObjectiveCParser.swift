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
        case LSHIFT = 159
        case RSHIFT = 160
        case GT = 161
        case LT = 162
        case BANG = 163
        case TILDE = 164
        case QUESTION = 165
        case COLON = 166
        case EQUAL = 167
        case LE = 168
        case GE = 169
        case NOTEQUAL = 170
        case AND = 171
        case OR = 172
        case INC = 173
        case DEC = 174
        case ADD = 175
        case SUB = 176
        case MUL = 177
        case DIV = 178
        case BITAND = 179
        case BITOR = 180
        case BITXOR = 181
        case MOD = 182
        case ADD_ASSIGN = 183
        case SUB_ASSIGN = 184
        case MUL_ASSIGN = 185
        case DIV_ASSIGN = 186
        case AND_ASSIGN = 187
        case OR_ASSIGN = 188
        case XOR_ASSIGN = 189
        case MOD_ASSIGN = 190
        case LSHIFT_ASSIGN = 191
        case RSHIFT_ASSIGN = 192
        case ELIPSIS = 193
        case CHARACTER_LITERAL = 194
        case STRING_START = 195
        case HEX_LITERAL = 196
        case OCTAL_LITERAL = 197
        case BINARY_LITERAL = 198
        case DECIMAL_LITERAL = 199
        case DIGITS = 200
        case FLOATING_POINT_LITERAL = 201
        case WS = 202
        case MULTI_COMMENT = 203
        case SINGLE_COMMENT = 204
        case BACKSLASH = 205
        case SHARP = 206
        case STRING_NEWLINE = 207
        case STRING_END = 208
        case STRING_VALUE = 209
        case PATH = 210
        case DIRECTIVE_IMPORT = 211
        case DIRECTIVE_INCLUDE = 212
        case DIRECTIVE_PRAGMA = 213
        case DIRECTIVE_DEFINE = 214
        case DIRECTIVE_DEFINED = 215
        case DIRECTIVE_IF = 216
        case DIRECTIVE_ELIF = 217
        case DIRECTIVE_ELSE = 218
        case DIRECTIVE_UNDEF = 219
        case DIRECTIVE_IFDEF = 220
        case DIRECTIVE_IFNDEF = 221
        case DIRECTIVE_ENDIF = 222
        case DIRECTIVE_TRUE = 223
        case DIRECTIVE_FALSE = 224
        case DIRECTIVE_ERROR = 225
        case DIRECTIVE_WARNING = 226
        case DIRECTIVE_HASINCLUDE = 227
        case DIRECTIVE_BANG = 228
        case DIRECTIVE_LP = 229
        case DIRECTIVE_RP = 230
        case DIRECTIVE_EQUAL = 231
        case DIRECTIVE_NOTEQUAL = 232
        case DIRECTIVE_AND = 233
        case DIRECTIVE_OR = 234
        case DIRECTIVE_LT = 235
        case DIRECTIVE_GT = 236
        case DIRECTIVE_LE = 237
        case DIRECTIVE_GE = 238
        case DIRECTIVE_STRING = 239
        case DIRECTIVE_ID = 240
        case DIRECTIVE_DECIMAL_LITERAL = 241
        case DIRECTIVE_FLOAT = 242
        case DIRECTIVE_NEWLINE = 243
        case DIRECTIVE_MULTI_COMMENT = 244
        case DIRECTIVE_SINGLE_COMMENT = 245
        case DIRECTIVE_BACKSLASH_NEWLINE = 246
        case DIRECTIVE_TEXT_NEWLINE = 247
        case DIRECTIVE_TEXT = 248
        case DIRECTIVE_PATH = 249
        case DIRECTIVE_PATH_STRING = 250
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
        RULE_receiver = 48, RULE_messageSelector = 49, RULE_keywordArgument = 50,
        RULE_keywordArgumentType = 51, RULE_selectorExpression = 52, RULE_selectorName = 53,
        RULE_protocolExpression = 54, RULE_encodeExpression = 55, RULE_typeVariableDeclarator = 56,
        RULE_throwStatement = 57, RULE_tryBlock = 58, RULE_catchStatement = 59,
        RULE_synchronizedStatement = 60, RULE_autoreleaseStatement = 61,
        RULE_functionDeclaration = 62, RULE_functionDefinition = 63, RULE_functionSignature = 64,
        RULE_declarationList = 65, RULE_attribute = 66, RULE_attributeName = 67,
        RULE_attributeParameters = 68, RULE_attributeParameterList = 69,
        RULE_attributeParameter = 70, RULE_attributeParameterAssignment = 71,
        RULE_functionPointer = 72, RULE_functionPointerParameterList = 73,
        RULE_functionPointerParameterDeclarationList = 74,
        RULE_functionPointerParameterDeclaration = 75, RULE_declarationSpecifier = 76,
        RULE_declarationSpecifiers = 77, RULE_declaration = 78, RULE_initDeclaratorList = 79,
        RULE_initDeclarator = 80, RULE_declarator = 81, RULE_directDeclarator = 82,
        RULE_blockDeclarationSpecifier = 83, RULE_typeName = 84, RULE_abstractDeclarator_ = 85,
        RULE_abstractDeclarator = 86, RULE_directAbstractDeclarator = 87,
        RULE_abstractDeclaratorSuffix_ = 88, RULE_parameterTypeList = 89, RULE_parameterList = 90,
        RULE_parameterDeclarationList_ = 91, RULE_parameterDeclaration = 92,
        RULE_typeQualifierList = 93, RULE_identifierList = 94, RULE_declaratorSuffix = 95,
        RULE_attributeSpecifier = 96, RULE_atomicTypeSpecifier = 97, RULE_fieldDeclaration = 98,
        RULE_structOrUnionSpecifier = 99, RULE_structOrUnion = 100,
        RULE_structDeclarationList = 101, RULE_structDeclaration = 102,
        RULE_specifierQualifierList = 103, RULE_enumSpecifier = 104, RULE_enumeratorList = 105,
        RULE_enumerator = 106, RULE_enumeratorIdentifier = 107, RULE_ibOutletQualifier = 108,
        RULE_arcBehaviourSpecifier = 109, RULE_nullabilitySpecifier = 110,
        RULE_storageClassSpecifier = 111, RULE_typePrefix = 112, RULE_typeQualifier = 113,
        RULE_functionSpecifier = 114, RULE_alignmentSpecifier = 115, RULE_protocolQualifier = 116,
        RULE_typeSpecifier = 117, RULE_typeofTypeSpecifier = 118, RULE_typedefName = 119,
        RULE_genericTypeSpecifier = 120, RULE_genericTypeList = 121,
        RULE_genericTypeParameter = 122, RULE_scalarTypeSpecifier = 123,
        RULE_fieldDeclaratorList = 124, RULE_fieldDeclarator = 125, RULE_vcSpecificModifier = 126,
        RULE_gccDeclaratorExtension = 127, RULE_gccAttributeSpecifier = 128,
        RULE_gccAttributeList = 129, RULE_gccAttribute = 130, RULE_pointer_ = 131,
        RULE_pointer = 132, RULE_pointerEntry = 133, RULE_macro = 134, RULE_arrayInitializer = 135,
        RULE_structInitializer = 136, RULE_structInitializerItem = 137, RULE_initializerList = 138,
        RULE_staticAssertDeclaration = 139, RULE_statement = 140, RULE_labeledStatement = 141,
        RULE_rangeExpression = 142, RULE_compoundStatement = 143, RULE_selectionStatement = 144,
        RULE_switchStatement = 145, RULE_switchBlock = 146, RULE_switchSection = 147,
        RULE_switchLabel = 148, RULE_iterationStatement = 149, RULE_whileStatement = 150,
        RULE_doStatement = 151, RULE_forStatement = 152, RULE_forLoopInitializer = 153,
        RULE_forInStatement = 154, RULE_jumpStatement = 155, RULE_expressions = 156,
        RULE_expression = 157, RULE_assignmentExpression = 158, RULE_assignmentOperator = 159,
        RULE_conditionalExpression = 160, RULE_logicalOrExpression = 161,
        RULE_logicalAndExpression = 162, RULE_bitwiseOrExpression = 163,
        RULE_bitwiseXorExpression = 164, RULE_bitwiseAndExpression = 165,
        RULE_equalityExpression = 166, RULE_equalityOperator = 167, RULE_comparisonExpression = 168,
        RULE_comparisonOperator = 169, RULE_shiftExpression = 170, RULE_shiftOperator = 171,
        RULE_additiveExpression = 172, RULE_additiveOperator = 173,
        RULE_multiplicativeExpression = 174, RULE_multiplicativeOperator = 175,
        RULE_castExpression = 176, RULE_initializer = 177, RULE_constantExpression = 178,
        RULE_unaryExpression = 179, RULE_unaryOperator = 180, RULE_postfixExpression = 181,
        RULE_primaryExpression = 182, RULE_postfixExpr = 183, RULE_argumentExpressionList = 184,
        RULE_argumentExpression = 185, RULE_messageExpression = 186, RULE_constant = 187,
        RULE_stringLiteral = 188, RULE_identifier = 189

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
        "receiver", "messageSelector", "keywordArgument", "keywordArgumentType",
        "selectorExpression", "selectorName", "protocolExpression", "encodeExpression",
        "typeVariableDeclarator", "throwStatement", "tryBlock", "catchStatement",
        "synchronizedStatement", "autoreleaseStatement", "functionDeclaration",
        "functionDefinition", "functionSignature", "declarationList", "attribute", "attributeName",
        "attributeParameters", "attributeParameterList", "attributeParameter",
        "attributeParameterAssignment", "functionPointer", "functionPointerParameterList",
        "functionPointerParameterDeclarationList", "functionPointerParameterDeclaration",
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
        "functionSpecifier", "alignmentSpecifier", "protocolQualifier", "typeSpecifier",
        "typeofTypeSpecifier", "typedefName", "genericTypeSpecifier", "genericTypeList",
        "genericTypeParameter", "scalarTypeSpecifier", "fieldDeclaratorList", "fieldDeclarator",
        "vcSpecificModifier", "gccDeclaratorExtension", "gccAttributeSpecifier", "gccAttributeList",
        "gccAttribute", "pointer_", "pointer", "pointerEntry", "macro", "arrayInitializer",
        "structInitializer", "structInitializerItem", "initializerList", "staticAssertDeclaration",
        "statement", "labeledStatement", "rangeExpression", "compoundStatement",
        "selectionStatement", "switchStatement", "switchBlock", "switchSection", "switchLabel",
        "iterationStatement", "whileStatement", "doStatement", "forStatement", "forLoopInitializer",
        "forInStatement", "jumpStatement", "expressions", "expression", "assignmentExpression",
        "assignmentOperator", "conditionalExpression", "logicalOrExpression",
        "logicalAndExpression", "bitwiseOrExpression", "bitwiseXorExpression",
        "bitwiseAndExpression", "equalityExpression", "equalityOperator", "comparisonExpression",
        "comparisonOperator", "shiftExpression", "shiftOperator", "additiveExpression",
        "additiveOperator", "multiplicativeExpression", "multiplicativeOperator", "castExpression",
        "initializer", "constantExpression", "unaryExpression", "unaryOperator",
        "postfixExpression", "primaryExpression", "postfixExpr", "argumentExpressionList",
        "argumentExpression", "messageExpression", "constant", "stringLiteral", "identifier",
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
        "'}'", "'['", "']'", "';'", "','", "'.'", "'->'", "'@'", "'='", "'<<'", "'>>'", nil, nil,
        nil, "'~'", "'?'", "':'", nil, nil, nil, nil, nil, nil, "'++'", "'--'", "'+'", "'-'", "'*'",
        "'/'", "'&'", "'|'", "'^'", "'%'", "'+='", "'-='", "'*='", "'/='", "'&='", "'|='", "'^='",
        "'%='", "'<<='", "'>>='", "'...'", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil,
        "'\\'", nil, nil, nil, nil, nil, nil, nil, nil, nil, "'defined'", nil, "'elif'", nil,
        "'undef'", "'ifdef'", "'ifndef'", "'endif'",
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
        "ASSIGNMENT", "LSHIFT", "RSHIFT", "GT", "LT", "BANG", "TILDE", "QUESTION", "COLON", "EQUAL",
        "LE", "GE", "NOTEQUAL", "AND", "OR", "INC", "DEC", "ADD", "SUB", "MUL", "DIV", "BITAND",
        "BITOR", "BITXOR", "MOD", "ADD_ASSIGN", "SUB_ASSIGN", "MUL_ASSIGN", "DIV_ASSIGN",
        "AND_ASSIGN", "OR_ASSIGN", "XOR_ASSIGN", "MOD_ASSIGN", "LSHIFT_ASSIGN", "RSHIFT_ASSIGN",
        "ELIPSIS", "CHARACTER_LITERAL", "STRING_START", "HEX_LITERAL", "OCTAL_LITERAL",
        "BINARY_LITERAL", "DECIMAL_LITERAL", "DIGITS", "FLOATING_POINT_LITERAL", "WS",
        "MULTI_COMMENT", "SINGLE_COMMENT", "BACKSLASH", "SHARP", "STRING_NEWLINE", "STRING_END",
        "STRING_VALUE", "PATH", "DIRECTIVE_IMPORT", "DIRECTIVE_INCLUDE", "DIRECTIVE_PRAGMA",
        "DIRECTIVE_DEFINE", "DIRECTIVE_DEFINED", "DIRECTIVE_IF", "DIRECTIVE_ELIF", "DIRECTIVE_ELSE",
        "DIRECTIVE_UNDEF", "DIRECTIVE_IFDEF", "DIRECTIVE_IFNDEF", "DIRECTIVE_ENDIF",
        "DIRECTIVE_TRUE", "DIRECTIVE_FALSE", "DIRECTIVE_ERROR", "DIRECTIVE_WARNING",
        "DIRECTIVE_HASINCLUDE", "DIRECTIVE_BANG", "DIRECTIVE_LP", "DIRECTIVE_RP", "DIRECTIVE_EQUAL",
        "DIRECTIVE_NOTEQUAL", "DIRECTIVE_AND", "DIRECTIVE_OR", "DIRECTIVE_LT", "DIRECTIVE_GT",
        "DIRECTIVE_LE", "DIRECTIVE_GE", "DIRECTIVE_STRING", "DIRECTIVE_ID",
        "DIRECTIVE_DECIMAL_LITERAL", "DIRECTIVE_FLOAT", "DIRECTIVE_NEWLINE",
        "DIRECTIVE_MULTI_COMMENT", "DIRECTIVE_SINGLE_COMMENT", "DIRECTIVE_BACKSLASH_NEWLINE",
        "DIRECTIVE_TEXT_NEWLINE", "DIRECTIVE_TEXT", "DIRECTIVE_PATH", "DIRECTIVE_PATH_STRING",
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
            setState(383)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 5_180_263_529_751_394_866) != 0
                || (Int64((_la - 67)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 67)) & -36_507_287_529) != 0
                || (Int64((_la - 131)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 131)) & 70_368_744_276_455) != 0
            {
                setState(380)
                try topLevelDeclaration()

                setState(385)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(386)
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
            setState(398)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(388)
                try importDeclaration()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(389)
                try declaration()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(390)
                try classInterface()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(391)
                try classImplementation()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(392)
                try categoryInterface()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(393)
                try categoryImplementation()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(394)
                try protocolDeclaration()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(395)
                try protocolDeclarationList()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(396)
                try classDeclarationList()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(397)
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
            setState(400)
            try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
            setState(401)
            try identifier()
            setState(402)
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
            setState(405)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue {
                setState(404)
                try match(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue)

            }

            setState(407)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(408)
            try classInterfaceName()
            setState(410)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(409)
                try instanceVariables()

            }

            setState(413)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -3_458_764_514_105_754_111) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 962_072_675_075) != 0
            {
                setState(412)
                try interfaceDeclarationList()

            }

            setState(415)
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
            setState(417)
            try className()
            setState(423)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(418)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(419)
                try superclassName()
                setState(421)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 5, _ctx) {
                case 1:
                    setState(420)
                    try genericClassParametersSpecifier()

                    break
                default: break
                }

            }

            setState(429)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(425)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(426)
                try protocolList()
                setState(427)
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
            setState(431)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(432)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryInterfaceContext.self).categoryName = assignmentValue
            }()

            setState(433)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(435)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(434)
                try identifier()

            }

            setState(437)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(442)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(438)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(439)
                try protocolList()
                setState(440)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(445)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(444)
                try instanceVariables()

            }

            setState(448)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -3_458_764_514_105_754_111) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 962_072_675_075) != 0
            {
                setState(447)
                try interfaceDeclarationList()

            }

            setState(450)
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
            setState(452)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(453)
            try classImplementationName()
            setState(455)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(454)
                try instanceVariables()

            }

            setState(458)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_073_944_569) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 3_758_096_387) != 0
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
            setState(462)
            try className()
            setState(468)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(463)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(464)
                try superclassName()
                setState(466)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
                    setState(465)
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
            setState(470)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(471)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryImplementationContext.self).categoryName =
                    assignmentValue
            }()

            setState(472)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(474)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(473)
                try identifier()

            }

            setState(476)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(478)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_073_944_569) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 3_758_096_387) != 0
            {
                setState(477)
                try implementationDefinitionList()

            }

            setState(480)
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
            setState(482)
            try identifier()
            setState(484)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 18, _ctx) {
            case 1:
                setState(483)
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
            setState(486)
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
            setState(488)
            try identifier()
            setState(489)
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
            setState(491)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(500)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_303_103_687_184) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_036_685_799_449) != 0
            {
                setState(492)
                try superclassTypeSpecifierWithPrefixes()
                setState(497)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(493)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(494)
                    try superclassTypeSpecifierWithPrefixes()

                    setState(499)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(502)
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
            setState(507)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(504)
                    try typePrefix()

                }
                setState(509)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            }
            setState(510)
            try typeSpecifier()
            setState(511)
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
            setState(513)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(514)
            try protocolName()
            setState(519)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(515)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(516)
                try protocolList()
                setState(517)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(524)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & 4_611_686_017_286_535_205) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 3_848_290_700_303) != 0
            {
                setState(521)
                try protocolDeclarationSection()

                setState(526)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(527)
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
            setState(541)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .OPTIONAL, .REQUIRED:
                try enterOuterAlt(_localctx, 1)
                setState(529)
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
                setState(533)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 24, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(530)
                        try interfaceDeclarationList()

                    }
                    setState(535)
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
                .UNSAFE_UNRETAINED_QUALIFIER, .UNUSED, .WEAK_QUALIFIER, .CDECL, .CLRCALL, .STDCALL,
                .DECLSPEC, .FASTCALL, .THISCALL, .VECTORCALL, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .STATIC_ASSERT_,
                .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM,
                .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER,
                .LP, .ADD, .SUB, .MUL:
                try enterOuterAlt(_localctx, 2)
                setState(537)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(536)
                        try interfaceDeclarationList()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(539)
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
            setState(543)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(544)
            try protocolList()
            setState(545)
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
            setState(547)
            try match(ObjectiveCParser.Tokens.CLASS.rawValue)
            setState(548)
            try classDeclaration()
            setState(553)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(549)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(550)
                try classDeclaration()

                setState(555)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(556)
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
            setState(558)
            try className()
            setState(563)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(559)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(560)
                try protocolList()
                setState(561)
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
            setState(565)
            try protocolName()
            setState(570)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(566)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(567)
                try protocolName()

                setState(572)
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
            setState(573)
            try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
            setState(578)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(574)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(575)
                try propertyAttributesList()
                setState(576)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

            setState(581)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 31, _ctx) {
            case 1:
                setState(580)
                try ibOutletQualifier()

                break
            default: break
            }
            setState(584)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 32, _ctx) {
            case 1:
                setState(583)
                try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

                break
            default: break
            }
            setState(586)
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
            setState(588)
            try propertyAttribute()
            setState(593)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(589)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(590)
                try propertyAttribute()

                setState(595)
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
            setState(607)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 34, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(596)
                try match(ObjectiveCParser.Tokens.WEAK.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(597)
                try match(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(598)
                try match(ObjectiveCParser.Tokens.COPY.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(599)
                try match(ObjectiveCParser.Tokens.GETTER.rawValue)
                setState(600)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(601)
                try selectorName()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(602)
                try match(ObjectiveCParser.Tokens.SETTER.rawValue)
                setState(603)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(604)
                try selectorName()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(605)
                try nullabilitySpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(606)
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
            setState(617)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LT:
                try enterOuterAlt(_localctx, 1)
                setState(609)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(610)
                try protocolList()
                setState(611)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(614)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 35, _ctx) {
                case 1:
                    setState(613)
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
                setState(616)
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
            setState(619)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(623)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 70)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 70)) & -563_942_359_310_231) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0 && ((Int64(1) << (_la - 136)) & 1039) != 0
            {
                setState(620)
                try visibilitySection()

                setState(625)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(626)
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
            setState(640)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .PACKAGE, .PRIVATE, .PROTECTED, .PUBLIC:
                try enterOuterAlt(_localctx, 1)
                setState(628)
                try accessModifier()
                setState(632)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 38, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(629)
                        try fieldDeclaration()

                    }
                    setState(634)
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
                .UNUSED, .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_OUTLET,
                .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(636)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(635)
                        try fieldDeclaration()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(638)
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
            setState(642)
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
            setState(649)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(649)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 41, _ctx) {
                    case 1:
                        setState(644)
                        try declaration()

                        break
                    case 2:
                        setState(645)
                        try classMethodDeclaration()

                        break
                    case 3:
                        setState(646)
                        try instanceMethodDeclaration()

                        break
                    case 4:
                        setState(647)
                        try propertyDeclaration()

                        break
                    case 5:
                        setState(648)
                        try functionDeclaration()

                        break
                    default: break
                    }

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(651)
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
            setState(653)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(654)
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
            setState(656)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(657)
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
            setState(660)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(659)
                try methodType()

            }

            setState(662)
            try methodSelector()
            setState(666)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(663)
                try attributeSpecifier()

                setState(668)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(670)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(669)
                try macro()

            }

            setState(672)
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
            setState(679)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(679)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 46, _ctx) {
                case 1:
                    setState(674)
                    try functionDefinition()

                    break
                case 2:
                    setState(675)
                    try declaration()

                    break
                case 3:
                    setState(676)
                    try classMethodDefinition()

                    break
                case 4:
                    setState(677)
                    try instanceMethodDefinition()

                    break
                case 5:
                    setState(678)
                    try propertyImplementation()

                    break
                default: break
                }

                setState(681)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_098_878_309_073_944_569) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 3_758_096_387) != 0

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
            setState(683)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(684)
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
            setState(686)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(687)
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
            setState(690)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(689)
                try methodType()

            }

            setState(692)
            try methodSelector()
            setState(694)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
                || _la == ObjectiveCParser.Tokens.MUL.rawValue
            {
                setState(693)
                try initDeclaratorList()

            }

            setState(697)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(696)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

            setState(700)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(699)
                try attributeSpecifier()

            }

            setState(702)
            try compoundStatement()
            setState(704)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(703)
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
            setState(716)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 55, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(706)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(708)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(707)
                        try keywordDeclarator()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(710)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 53, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER
                setState(714)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(712)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(713)
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
            setState(719)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(718)
                try selector()

            }

            setState(721)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(725)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(722)
                try methodType()

                setState(727)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(729)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 87)) & ~0x3f) == 0 && ((Int64(1) << (_la - 87)) & 20993) != 0 {
                setState(728)
                try arcBehaviourSpecifier()

            }

            setState(731)
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
            setState(739)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(733)
                try identifier()

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 2)
                setState(734)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)

                break

            case .SWITCH:
                try enterOuterAlt(_localctx, 3)
                setState(735)
                try match(ObjectiveCParser.Tokens.SWITCH.rawValue)

                break

            case .IF:
                try enterOuterAlt(_localctx, 4)
                setState(736)
                try match(ObjectiveCParser.Tokens.IF.rawValue)

                break

            case .ELSE:
                try enterOuterAlt(_localctx, 5)
                setState(737)
                try match(ObjectiveCParser.Tokens.ELSE.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 6)
                setState(738)
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
            setState(741)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(742)
            try typeName()
            setState(743)
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
            setState(753)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .SYNTHESIZE:
                try enterOuterAlt(_localctx, 1)
                setState(745)
                try match(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue)
                setState(746)
                try propertySynthesizeList()
                setState(747)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .DYNAMIC:
                try enterOuterAlt(_localctx, 2)
                setState(749)
                try match(ObjectiveCParser.Tokens.DYNAMIC.rawValue)
                setState(750)
                try propertySynthesizeList()
                setState(751)
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
            setState(755)
            try propertySynthesizeItem()
            setState(760)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(756)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(757)
                try propertySynthesizeItem()

                setState(762)
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
            setState(763)
            try identifier()
            setState(766)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(764)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(765)
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
            setState(768)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(769)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(781)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
            {
                setState(770)
                try dictionaryPair()
                setState(775)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(771)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(772)
                        try dictionaryPair()

                    }
                    setState(777)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 63, _ctx)
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
        try enterRule(_localctx, 86, ObjectiveCParser.RULE_dictionaryPair)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(785)
            try castExpression()
            setState(786)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(787)
            try expression()

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
            setState(789)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(790)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(795)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
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
        try enterRule(_localctx, 90, ObjectiveCParser.RULE_boxExpression)
        defer { try! exitRule() }
        do {
            setState(809)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 69, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(799)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(800)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(801)
                try expression()
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
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                    .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE,
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
            setState(811)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(823)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
            {
                setState(814)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 70, _ctx) {
                case 1:
                    setState(812)
                    try parameterDeclaration()

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
                    try parameterDeclaration()

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
            setState(842)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 73, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(827)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(828)
                try compoundStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(829)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(830)
                try typeName()
                setState(831)
                try blockParameters()
                setState(832)
                try compoundStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(834)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(835)
                try typeName()
                setState(836)
                try compoundStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(838)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(839)
                try blockParameters()
                setState(840)
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
        try enterRule(_localctx, 96, ObjectiveCParser.RULE_receiver)
        defer { try! exitRule() }
        do {
            setState(846)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 74, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(844)
                try expression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(845)
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
        try enterRule(_localctx, 98, ObjectiveCParser.RULE_messageSelector)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(854)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 76, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(848)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(850)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(849)
                    try keywordArgument()

                    setState(852)
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
        try enterRule(_localctx, 100, ObjectiveCParser.RULE_keywordArgument)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(857)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(856)
                try selector()

            }

            setState(859)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(860)
            try keywordArgumentType()
            setState(865)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(861)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(862)
                try keywordArgumentType()

                setState(867)
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
        try enterRule(_localctx, 102, ObjectiveCParser.RULE_keywordArgumentType)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(868)
            try expressions()
            setState(870)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(869)
                try nullabilitySpecifier()

            }

            setState(876)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(872)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(873)
                try initializerList()
                setState(874)
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
        try enterRule(_localctx, 104, ObjectiveCParser.RULE_selectorExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(878)
            try match(ObjectiveCParser.Tokens.SELECTOR.rawValue)
            setState(879)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(880)
            try selectorName()
            setState(881)
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
        try enterRule(_localctx, 106, ObjectiveCParser.RULE_selectorName)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(892)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 83, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(883)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(888)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(885)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    {
                        setState(884)
                        try selector()

                    }

                    setState(887)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)

                    setState(890)
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
        try enterRule(_localctx, 108, ObjectiveCParser.RULE_protocolExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(894)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(895)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(896)
            try protocolName()
            setState(897)
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
        try enterRule(_localctx, 110, ObjectiveCParser.RULE_encodeExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(899)
            try match(ObjectiveCParser.Tokens.ENCODE.rawValue)
            setState(900)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(901)
            try typeName()
            setState(902)
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
        try enterRule(_localctx, 112, ObjectiveCParser.RULE_typeVariableDeclarator)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(904)
            try declarationSpecifiers()
            setState(905)
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
        try enterRule(_localctx, 114, ObjectiveCParser.RULE_throwStatement)
        defer { try! exitRule() }
        do {
            setState(914)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 84, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(907)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(908)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(909)
                try identifier()
                setState(910)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(912)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(913)
                try expression()

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
        try enterRule(_localctx, 116, ObjectiveCParser.RULE_tryBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(916)
            try match(ObjectiveCParser.Tokens.TRY.rawValue)
            setState(917)
            try {
                let assignmentValue = try compoundStatement()
                _localctx.castdown(TryBlockContext.self).tryStatement = assignmentValue
            }()

            setState(921)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CATCH.rawValue {
                setState(918)
                try catchStatement()

                setState(923)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(926)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.FINALLY.rawValue {
                setState(924)
                try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
                setState(925)
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
        try enterRule(_localctx, 118, ObjectiveCParser.RULE_catchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(928)
            try match(ObjectiveCParser.Tokens.CATCH.rawValue)
            setState(929)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(930)
            try typeVariableDeclarator()
            setState(931)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(932)
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
        try enterRule(_localctx, 120, ObjectiveCParser.RULE_synchronizedStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(934)
            try match(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue)
            setState(935)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(936)
            try expression()
            setState(937)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(938)
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
        try enterRule(_localctx, 122, ObjectiveCParser.RULE_autoreleaseStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(940)
            try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
            setState(941)
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
        try enterRule(_localctx, 124, ObjectiveCParser.RULE_functionDeclaration)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(943)
            try functionSignature()
            setState(944)
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
        try enterRule(_localctx, 126, ObjectiveCParser.RULE_functionDefinition)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(946)
            try functionSignature()
            setState(947)
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
        try enterRule(_localctx, 128, ObjectiveCParser.RULE_functionSignature)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(950)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 87, _ctx) {
            case 1:
                setState(949)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(952)
            try declarator()
            setState(954)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_248_341_118_977) != 0
            {
                setState(953)
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
        try enterRule(_localctx, 130, ObjectiveCParser.RULE_declarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(957)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(956)
                try declaration()

                setState(959)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_248_341_118_977) != 0

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
        try enterRule(_localctx, 132, ObjectiveCParser.RULE_attribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(961)
            try attributeName()
            setState(963)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(962)
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
        try enterRule(_localctx, 134, ObjectiveCParser.RULE_attributeName)
        defer { try! exitRule() }
        do {
            setState(967)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(965)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(966)
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
        try enterRule(_localctx, 136, ObjectiveCParser.RULE_attributeParameters)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(969)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(971)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_568) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                || (Int64((_la - 175)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 175)) & 100_139_011) != 0
            {
                setState(970)
                try attributeParameterList()

            }

            setState(973)
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
        try enterRule(_localctx, 138, ObjectiveCParser.RULE_attributeParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(975)
            try attributeParameter()
            setState(980)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(976)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(977)
                try attributeParameter()

                setState(982)
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
        try enterRule(_localctx, 140, ObjectiveCParser.RULE_attributeParameter)
        defer { try! exitRule() }
        do {
            setState(987)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 94, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(983)
                try attribute()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(984)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(985)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(986)
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
        try enterRule(_localctx, 142, ObjectiveCParser.RULE_attributeParameterAssignment)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(989)
            try attributeName()
            setState(990)
            try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
            setState(994)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                setState(991)
                try constant()

                break
            case .CONST, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE,
                .IDENTIFIER:
                setState(992)
                try attributeName()

                break

            case .STRING_START:
                setState(993)
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
        try enterRule(_localctx, 144, ObjectiveCParser.RULE_functionPointer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(996)
            try declarationSpecifiers()
            setState(997)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(998)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1000)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(999)
                try identifier()

            }

            setState(1002)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1003)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1005)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
            {
                setState(1004)
                try functionPointerParameterList()

            }

            setState(1007)
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
        try enterRule(_localctx, 146, ObjectiveCParser.RULE_functionPointerParameterList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1009)
            try functionPointerParameterDeclarationList()
            setState(1012)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1010)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1011)
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
        try enterRule(_localctx, 148, ObjectiveCParser.RULE_functionPointerParameterDeclarationList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1014)
            try functionPointerParameterDeclaration()
            setState(1019)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 99, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1015)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1016)
                    try functionPointerParameterDeclaration()

                }
                setState(1021)
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
        try enterRule(_localctx, 150, ObjectiveCParser.RULE_functionPointerParameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1030)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 102, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1024)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 100, _ctx) {
                case 1:
                    setState(1022)
                    try declarationSpecifiers()

                    break
                case 2:
                    setState(1023)
                    try functionPointer()

                    break
                default: break
                }
                setState(1027)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1026)
                    try declarator()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1029)
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
        open func typePrefix() -> TypePrefixContext? {
            return getRuleContext(TypePrefixContext.self, 0)
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
        try enterRule(_localctx, 152, ObjectiveCParser.RULE_declarationSpecifier)
        defer { try! exitRule() }
        do {
            setState(1041)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 103, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1032)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1033)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1034)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1035)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1036)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1037)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1038)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1039)
                try ibOutletQualifier()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(1040)
                try typePrefix()

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
        try enterRule(_localctx, 154, ObjectiveCParser.RULE_declarationSpecifiers)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1044)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1043)
                    try declarationSpecifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1046)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 104, _ctx)
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
        try enterRule(_localctx, 156, ObjectiveCParser.RULE_declaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1055)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .AUTO, .CHAR, .CONST, .DOUBLE, .ENUM, .EXTERN, .FLOAT, .INLINE, .INT, .LONG,
                .REGISTER, .RESTRICT, .SHORT, .SIGNED, .STATIC, .STRUCT, .TYPEDEF, .UNION,
                .UNSIGNED, .VOID, .VOLATILE, .CBOOL, .BOOL_, .COMPLEX, .CONSTEXPR, .BOOL, .Class,
                .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_, .SEL, .SELF,
                .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .ATTRIBUTE, .AUTORELEASING_QUALIFIER, .BLOCK,
                .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF, .UNSAFE_UNRETAINED_QUALIFIER,
                .UNUSED, .WEAK_QUALIFIER, .STDCALL, .DECLSPEC, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .NULL_UNSPECIFIED,
                .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN,
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_OUTLET,
                .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(1048)
                try declarationSpecifiers()
                setState(1050)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1049)
                    try initDeclaratorList()

                }

                setState(1052)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .STATIC_ASSERT_:
                try enterOuterAlt(_localctx, 2)
                setState(1054)
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
        try enterRule(_localctx, 158, ObjectiveCParser.RULE_initDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1057)
            try initDeclarator()
            setState(1062)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1058)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1059)
                try initDeclarator()

                setState(1064)
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
        try enterRule(_localctx, 160, ObjectiveCParser.RULE_initDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1065)
            try declarator()
            setState(1068)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1066)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1067)
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
        try enterRule(_localctx, 162, ObjectiveCParser.RULE_declarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1071)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1070)
                try pointer()

            }

            setState(1073)
            try directDeclarator(0)
            setState(1077)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 110, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1074)
                    try gccDeclaratorExtension()

                }
                setState(1079)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 110, _ctx)
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
        let _startState: Int = 164
        try enterRecursionRule(_localctx, 164, ObjectiveCParser.RULE_directDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1110)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 112, _ctx) {
            case 1:
                setState(1081)
                try identifier()

                break
            case 2:
                setState(1082)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1083)
                try declarator()
                setState(1084)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                setState(1086)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1087)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1091)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 111, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1088)
                        try blockDeclarationSpecifier()

                    }
                    setState(1093)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 111, _ctx)
                }
                setState(1094)
                try directDeclarator(0)
                setState(1095)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1096)
                try blockParameters()

                break
            case 4:
                setState(1098)
                try identifier()
                setState(1099)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1100)
                try match(ObjectiveCParser.Tokens.DIGITS.rawValue)

                break
            case 5:
                setState(1102)
                try vcSpecificModifier()
                setState(1103)
                try identifier()

                break
            case 6:
                setState(1105)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1106)
                try vcSpecificModifier()
                setState(1107)
                try declarator()
                setState(1108)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1152)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 119, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1150)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 118, _ctx) {
                    case 1:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1112)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(1113)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1115)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 113, _ctx) {
                        case 1:
                            setState(1114)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1118)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                            || (Int64((_la - 92)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                        {
                            setState(1117)
                            try expression()

                        }

                        setState(1120)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1121)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(1122)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1123)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1125)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 115, _ctx) {
                        case 1:
                            setState(1124)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1127)
                        try expression()
                        setState(1128)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1130)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(1131)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1132)
                        try typeQualifierList()
                        setState(1133)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1134)
                        try expression()
                        setState(1135)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1137)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1138)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1140)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 27_918_807_844_519_968) != 0
                            || _la == ObjectiveCParser.Tokens.ATOMIC_.rawValue
                        {
                            setState(1139)
                            try typeQualifierList()

                        }

                        setState(1142)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1143)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1144)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1145)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1147)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
                        {
                            setState(1146)
                            try parameterTypeList()

                        }

                        setState(1149)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)

                        break
                    default: break
                    }
                }
                setState(1154)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 119, _ctx)
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
        try enterRule(_localctx, 166, ObjectiveCParser.RULE_blockDeclarationSpecifier)
        defer { try! exitRule() }
        do {
            setState(1159)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE:
                try enterOuterAlt(_localctx, 1)
                setState(1155)
                try nullabilitySpecifier()

                break
            case .AUTORELEASING_QUALIFIER, .STRONG_QUALIFIER, .UNSAFE_UNRETAINED_QUALIFIER,
                .WEAK_QUALIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(1156)
                try arcBehaviourSpecifier()

                break
            case .CONST, .RESTRICT, .VOLATILE, .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT,
                .ATOMIC_:
                try enterOuterAlt(_localctx, 3)
                setState(1157)
                try typeQualifier()

                break
            case .INLINE, .BLOCK, .BRIDGE, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .KINDOF, .UNUSED,
                .NS_INLINE:
                try enterOuterAlt(_localctx, 4)
                setState(1158)
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
        try enterRule(_localctx, 168, ObjectiveCParser.RULE_typeName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1161)
            try declarationSpecifiers()
            setState(1163)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 121, _ctx) {
            case 1:
                setState(1162)
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
        try enterRule(_localctx, 170, ObjectiveCParser.RULE_abstractDeclarator_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1188)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .MUL:
                try enterOuterAlt(_localctx, 1)
                setState(1165)
                try pointer()
                setState(1167)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 122, _ctx) {
                case 1:
                    setState(1166)
                    try abstractDeclarator_()

                    break
                default: break
                }

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1169)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1171)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 1_073_741_841) != 0
                {
                    setState(1170)
                    try abstractDeclarator()

                }

                setState(1173)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1175)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1174)
                        try abstractDeclaratorSuffix_()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1177)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 124, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

                break

            case .LBRACK:
                try enterOuterAlt(_localctx, 3)
                setState(1184)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1179)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1181)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                            || (Int64((_la - 175)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 175)) & 99_090_435) != 0
                        {
                            setState(1180)
                            try constantExpression()

                        }

                        setState(1183)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1186)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 126, _ctx)
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
        try enterRule(_localctx, 172, ObjectiveCParser.RULE_abstractDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1201)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 130, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1190)
                try pointer()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1192)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1191)
                    try pointer()

                }

                setState(1194)
                try directAbstractDeclarator(0)
                setState(1198)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue
                    || _la == ObjectiveCParser.Tokens.ASM.rawValue
                {
                    setState(1195)
                    try gccDeclaratorExtension()

                    setState(1200)
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
        let _startState: Int = 174
        try enterRecursionRule(_localctx, 174, ObjectiveCParser.RULE_directAbstractDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1262)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 139, _ctx) {
            case 1:
                setState(1204)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1205)
                try abstractDeclarator()
                setState(1206)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1210)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 131, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1207)
                        try gccDeclaratorExtension()

                    }
                    setState(1212)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 131, _ctx)
                }

                break
            case 2:
                setState(1213)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1215)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 132, _ctx) {
                case 1:
                    setState(1214)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1218)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                {
                    setState(1217)
                    try expression()

                }

                setState(1220)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 3:
                setState(1221)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1222)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1224)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 134, _ctx) {
                case 1:
                    setState(1223)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1226)
                try expression()
                setState(1227)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 4:
                setState(1229)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1230)
                try typeQualifierList()
                setState(1231)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1232)
                try expression()
                setState(1233)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 5:
                setState(1235)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1236)
                try match(ObjectiveCParser.Tokens.MUL.rawValue)
                setState(1237)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 6:
                setState(1238)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1240)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
                {
                    setState(1239)
                    try parameterTypeList()

                }

                setState(1242)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1246)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 136, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1243)
                        try gccDeclaratorExtension()

                    }
                    setState(1248)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 136, _ctx)
                }

                break
            case 7:
                setState(1249)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1250)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1254)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 137, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1251)
                        try blockDeclarationSpecifier()

                    }
                    setState(1256)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 137, _ctx)
                }
                setState(1258)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                {
                    setState(1257)
                    try identifier()

                }

                setState(1260)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1261)
                try blockParameters()

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1307)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 146, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1305)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 145, _ctx) {
                    case 1:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1264)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1265)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1267)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 140, _ctx) {
                        case 1:
                            setState(1266)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1270)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                            || (Int64((_la - 92)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                        {
                            setState(1269)
                            try expression()

                        }

                        setState(1272)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1273)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1274)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1275)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1277)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 142, _ctx) {
                        case 1:
                            setState(1276)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1279)
                        try expression()
                        setState(1280)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1282)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(1283)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1284)
                        try typeQualifierList()
                        setState(1285)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1286)
                        try expression()
                        setState(1287)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1289)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(1290)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1291)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1292)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1293)
                        if !(precpred(_ctx, 2)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 2)"))
                        }
                        setState(1294)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1296)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
                        {
                            setState(1295)
                            try parameterTypeList()

                        }

                        setState(1298)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)
                        setState(1302)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 144, _ctx)
                        while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                            if _alt == 1 {
                                setState(1299)
                                try gccDeclaratorExtension()

                            }
                            setState(1304)
                            try _errHandler.sync(self)
                            _alt = try getInterpreter().adaptivePredict(_input, 144, _ctx)
                        }

                        break
                    default: break
                    }
                }
                setState(1309)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 146, _ctx)
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
        try enterRule(_localctx, 176, ObjectiveCParser.RULE_abstractDeclaratorSuffix_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1320)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(1310)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1312)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    || (Int64((_la - 175)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 175)) & 99_090_435) != 0
                {
                    setState(1311)
                    try constantExpression()

                }

                setState(1314)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1315)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1317)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
                {
                    setState(1316)
                    try parameterDeclarationList_()

                }

                setState(1319)
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
        try enterRule(_localctx, 178, ObjectiveCParser.RULE_parameterTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1322)
            try parameterList()
            setState(1325)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1323)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1324)
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
        try enterRule(_localctx, 180, ObjectiveCParser.RULE_parameterList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1327)
            try parameterDeclaration()
            setState(1332)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 151, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1328)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1329)
                    try parameterDeclaration()

                }
                setState(1334)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 151, _ctx)
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
        try enterRule(_localctx, 182, ObjectiveCParser.RULE_parameterDeclarationList_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1335)
            try parameterDeclaration()
            setState(1340)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1336)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1337)
                try parameterDeclaration()

                setState(1342)
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
        try enterRule(_localctx, 184, ObjectiveCParser.RULE_parameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1350)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 154, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1343)
                try declarationSpecifiers()
                setState(1344)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1346)
                try declarationSpecifiers()
                setState(1348)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 1_073_741_841) != 0
                {
                    setState(1347)
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
        try enterRule(_localctx, 186, ObjectiveCParser.RULE_typeQualifierList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1353)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1352)
                    try typeQualifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1355)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 155, _ctx)
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
        try enterRule(_localctx, 188, ObjectiveCParser.RULE_identifierList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1357)
            try identifier()
            setState(1362)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1358)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1359)
                try identifier()

                setState(1364)
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
        try enterRule(_localctx, 190, ObjectiveCParser.RULE_declaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1365)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(1367)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                || (Int64((_la - 175)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 175)) & 99_090_435) != 0
            {
                setState(1366)
                try constantExpression()

            }

            setState(1369)
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
        try enterRule(_localctx, 192, ObjectiveCParser.RULE_attributeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1371)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1372)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1373)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1374)
            try attribute()
            setState(1379)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1375)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1376)
                try attribute()

                setState(1381)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1382)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1383)
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
        try enterRule(_localctx, 194, ObjectiveCParser.RULE_atomicTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1385)
            try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)
            setState(1386)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1387)
            try typeName()
            setState(1388)
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
        try enterRule(_localctx, 196, ObjectiveCParser.RULE_fieldDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1390)
            try declarationSpecifiers()
            setState(1391)
            try fieldDeclaratorList()
            setState(1393)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
            {
                setState(1392)
                try macro()

            }

            setState(1395)
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
        try enterRule(_localctx, 198, ObjectiveCParser.RULE_structOrUnionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1420)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 163, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1397)
                try structOrUnion()
                setState(1401)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1398)
                    try attributeSpecifier()

                    setState(1403)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1405)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                {
                    setState(1404)
                    try identifier()

                }

                setState(1407)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1408)
                try structDeclarationList()
                setState(1409)
                try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1411)
                try structOrUnion()
                setState(1415)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1412)
                    try attributeSpecifier()

                    setState(1417)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1418)
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
        try enterRule(_localctx, 200, ObjectiveCParser.RULE_structOrUnion)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1422)
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
        try enterRule(_localctx, 202, ObjectiveCParser.RULE_structDeclarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1425)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1424)
                try structDeclaration()

                setState(1427)
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
        try enterRule(_localctx, 204, ObjectiveCParser.RULE_structDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1449)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 167, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1432)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1429)
                    try attributeSpecifier()

                    setState(1434)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1435)
                try specifierQualifierList()
                setState(1436)
                try fieldDeclaratorList()
                setState(1437)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1442)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1439)
                    try attributeSpecifier()

                    setState(1444)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }
                setState(1445)
                try specifierQualifierList()
                setState(1446)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1448)
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
        try enterRule(_localctx, 206, ObjectiveCParser.RULE_specifierQualifierList)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1453)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 168, _ctx) {
            case 1:
                setState(1451)
                try typeSpecifier()

                break
            case 2:
                setState(1452)
                try typeQualifier()

                break
            default: break
            }
            setState(1456)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 169, _ctx) {
            case 1:
                setState(1455)
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
        try enterRule(_localctx, 208, ObjectiveCParser.RULE_enumSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1489)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ENUM:
                try enterOuterAlt(_localctx, 1)
                setState(1458)
                try match(ObjectiveCParser.Tokens.ENUM.rawValue)
                setState(1464)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 171, _ctx) {
                case 1:
                    setState(1460)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_113_036_045_007_450_617) != 0
                    {
                        setState(1459)
                        try {
                            let assignmentValue = try identifier()
                            _localctx.castdown(EnumSpecifierContext.self).enumName = assignmentValue
                        }()

                    }

                    setState(1462)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(1463)
                    try typeName()

                    break
                default: break
                }
                setState(1477)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY,
                    .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE,
                    .IB_DESIGNABLE, .IDENTIFIER:
                    setState(1466)
                    try identifier()
                    setState(1471)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 172, _ctx) {
                    case 1:
                        setState(1467)
                        try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                        setState(1468)
                        try enumeratorList()
                        setState(1469)
                        try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                        break
                    default: break
                    }

                    break

                case .LBRACE:
                    setState(1473)
                    try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                    setState(1474)
                    try enumeratorList()
                    setState(1475)
                    try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            case .NS_ENUM, .NS_OPTIONS:
                try enterOuterAlt(_localctx, 2)
                setState(1479)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.NS_ENUM.rawValue
                    || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1480)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1481)
                try typeName()
                setState(1482)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1483)
                try {
                    let assignmentValue = try identifier()
                    _localctx.castdown(EnumSpecifierContext.self).enumName = assignmentValue
                }()

                setState(1484)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1485)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1486)
                try enumeratorList()
                setState(1487)
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
        try enterRule(_localctx, 210, ObjectiveCParser.RULE_enumeratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1491)
            try enumerator()
            setState(1496)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 175, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1492)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1493)
                    try enumerator()

                }
                setState(1498)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 175, _ctx)
            }
            setState(1500)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1499)
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
        try enterRule(_localctx, 212, ObjectiveCParser.RULE_enumerator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1502)
            try enumeratorIdentifier()
            setState(1505)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1503)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1504)
                try expression()

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
        try enterRule(_localctx, 214, ObjectiveCParser.RULE_enumeratorIdentifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1507)
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
        try enterRule(_localctx, 216, ObjectiveCParser.RULE_ibOutletQualifier)
        defer { try! exitRule() }
        do {
            setState(1515)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IB_OUTLET_COLLECTION:
                try enterOuterAlt(_localctx, 1)
                setState(1509)
                try match(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue)
                setState(1510)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1511)
                try identifier()
                setState(1512)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .IB_OUTLET:
                try enterOuterAlt(_localctx, 2)
                setState(1514)
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
        try enterRule(_localctx, 218, ObjectiveCParser.RULE_arcBehaviourSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1517)
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
        try enterRule(_localctx, 220, ObjectiveCParser.RULE_nullabilitySpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1519)
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
        try enterRule(_localctx, 222, ObjectiveCParser.RULE_storageClassSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1521)
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
        open func UNUSED() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.UNUSED.rawValue, 0)
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
        try enterRule(_localctx, 224, ObjectiveCParser.RULE_typePrefix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1523)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.INLINE.rawValue
                || (Int64((_la - 88)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 88)) & 68_719_480_975) != 0)
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
        try enterRule(_localctx, 226, ObjectiveCParser.RULE_typeQualifier)
        defer { try! exitRule() }
        do {
            setState(1530)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(1525)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break

            case .VOLATILE:
                try enterOuterAlt(_localctx, 2)
                setState(1526)
                try match(ObjectiveCParser.Tokens.VOLATILE.rawValue)

                break

            case .RESTRICT:
                try enterOuterAlt(_localctx, 3)
                setState(1527)
                try match(ObjectiveCParser.Tokens.RESTRICT.rawValue)

                break

            case .ATOMIC_:
                try enterOuterAlt(_localctx, 4)
                setState(1528)
                try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)

                break
            case .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT:
                try enterOuterAlt(_localctx, 5)
                setState(1529)
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
        try enterRule(_localctx, 228, ObjectiveCParser.RULE_functionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1539)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .INLINE, .STDCALL, .INLINE__, .NORETURN_:
                try enterOuterAlt(_localctx, 1)
                setState(1532)
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
                setState(1533)
                try gccAttributeSpecifier()

                break

            case .DECLSPEC:
                try enterOuterAlt(_localctx, 3)
                setState(1534)
                try match(ObjectiveCParser.Tokens.DECLSPEC.rawValue)
                setState(1535)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1536)
                try identifier()
                setState(1537)
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
        try enterRule(_localctx, 230, ObjectiveCParser.RULE_alignmentSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1541)
            try match(ObjectiveCParser.Tokens.ALIGNAS_.rawValue)
            setState(1542)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1545)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 181, _ctx) {
            case 1:
                setState(1543)
                try typeName()

                break
            case 2:
                setState(1544)
                try constantExpression()

                break
            default: break
            }
            setState(1547)
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
        try enterRule(_localctx, 232, ObjectiveCParser.RULE_protocolQualifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1549)
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
        try enterRule(_localctx, 234, ObjectiveCParser.RULE_typeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1562)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 182, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1551)
                try scalarTypeSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1552)
                try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)
                setState(1553)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1554)
                _la = try _input.LA(1)
                if !((Int64((_la - 112)) & ~0x3f) == 0 && ((Int64(1) << (_la - 112)) & 7) != 0) {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1555)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1556)
                try genericTypeSpecifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1557)
                try atomicTypeSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1558)
                try structOrUnionSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1559)
                try enumSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1560)
                try typedefName()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1561)
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
        try enterRule(_localctx, 236, ObjectiveCParser.RULE_typeofTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1564)
            try match(ObjectiveCParser.Tokens.TYPEOF.rawValue)

            setState(1565)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1566)
            try expression()
            setState(1567)
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
        try enterRule(_localctx, 238, ObjectiveCParser.RULE_typedefName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1569)
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
        try enterRule(_localctx, 240, ObjectiveCParser.RULE_genericTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1571)
            try identifier()
            setState(1572)
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
        try enterRule(_localctx, 242, ObjectiveCParser.RULE_genericTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1574)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(1583)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
            {
                setState(1575)
                try genericTypeParameter()
                setState(1580)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1576)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1577)
                    try genericTypeParameter()

                    setState(1582)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(1585)
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
        try enterRule(_localctx, 244, ObjectiveCParser.RULE_genericTypeParameter)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1588)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 185, _ctx) {
            case 1:
                setState(1587)
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
            setState(1590)
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
        try enterRule(_localctx, 246, ObjectiveCParser.RULE_scalarTypeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1592)
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
        try enterRule(_localctx, 248, ObjectiveCParser.RULE_fieldDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1594)
            try fieldDeclarator()
            setState(1599)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1595)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1596)
                try fieldDeclarator()

                setState(1601)
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
        try enterRule(_localctx, 250, ObjectiveCParser.RULE_fieldDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1608)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 188, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1602)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1604)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_113_036_044_882_670_073) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1603)
                    try declarator()

                }

                setState(1606)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1607)
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
        try enterRule(_localctx, 252, ObjectiveCParser.RULE_vcSpecificModifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1610)
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
        try enterRule(_localctx, 254, ObjectiveCParser.RULE_gccDeclaratorExtension)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1622)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ASM:
                try enterOuterAlt(_localctx, 1)
                setState(1612)
                try match(ObjectiveCParser.Tokens.ASM.rawValue)
                setState(1613)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1615)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1614)
                    try stringLiteral()

                    setState(1617)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
                setState(1619)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .ATTRIBUTE:
                try enterOuterAlt(_localctx, 2)
                setState(1621)
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
        try enterRule(_localctx, 256, ObjectiveCParser.RULE_gccAttributeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1624)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1625)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1626)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1627)
            try gccAttributeList()
            setState(1628)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1629)
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
        try enterRule(_localctx, 258, ObjectiveCParser.RULE_gccAttributeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1632)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 192)) & 576_460_752_303_423_487) != 0
            {
                setState(1631)
                try gccAttribute()

            }

            setState(1640)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1634)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1636)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 576_460_752_303_423_487) != 0
                {
                    setState(1635)
                    try gccAttribute()

                }

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
        try enterRule(_localctx, 260, ObjectiveCParser.RULE_gccAttribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1643)
            _la = try _input.LA(1)
            if _la <= 0
                || ((Int64((_la - 147)) & ~0x3f) == 0 && ((Int64(1) << (_la - 147)) & 131) != 0)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1649)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1644)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1646)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                {
                    setState(1645)
                    try argumentExpressionList()

                }

                setState(1648)
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
        try enterRule(_localctx, 262, ObjectiveCParser.RULE_pointer_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1651)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1653)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_086_012_317_060_595_713) != 0
            {
                setState(1652)
                try declarationSpecifiers()

            }

            setState(1656)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1655)
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
        try enterRule(_localctx, 264, ObjectiveCParser.RULE_pointer)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1659)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1658)
                    try pointerEntry()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1661)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 198, _ctx)
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
        try enterRule(_localctx, 266, ObjectiveCParser.RULE_pointerEntry)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1663)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)

            setState(1665)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 199, _ctx) {
            case 1:
                setState(1664)
                try typeQualifierList()

                break
            default: break
            }
            setState(1668)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(1667)
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
        open var _tset2911: Token!
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
        try enterRule(_localctx, 268, ObjectiveCParser.RULE_macro)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1670)
            try identifier()
            setState(1679)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1671)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1674)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1674)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 201, _ctx) {
                    case 1:
                        setState(1672)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                        break
                    case 2:
                        setState(1673)
                        _localctx.castdown(MacroContext.self)._tset2911 = try _input.LT(1)
                        _la = try _input.LA(1)
                        if _la <= 0 || (_la == ObjectiveCParser.Tokens.RP.rawValue) {
                            _localctx.castdown(MacroContext.self)._tset2911 =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        _localctx.castdown(MacroContext.self).macroArguments.append(
                            _localctx.castdown(MacroContext.self)._tset2911)

                        break
                    default: break
                    }

                    setState(1676)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -1_048_577) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 576_460_752_303_423_487) != 0
                setState(1678)
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
        try enterRule(_localctx, 270, ObjectiveCParser.RULE_arrayInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1681)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1693)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
            {
                setState(1682)
                try expression()
                setState(1687)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 204, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1683)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1684)
                        try expression()

                    }
                    setState(1689)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 204, _ctx)
                }
                setState(1691)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1690)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1695)
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
        try enterRule(_localctx, 272, ObjectiveCParser.RULE_structInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1697)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1709)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue
                || _la == ObjectiveCParser.Tokens.DOT.rawValue
            {
                setState(1698)
                try structInitializerItem()
                setState(1703)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 207, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1699)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1700)
                        try structInitializerItem()

                    }
                    setState(1705)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 207, _ctx)
                }
                setState(1707)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1706)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1711)
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
        try enterRule(_localctx, 274, ObjectiveCParser.RULE_structInitializerItem)
        defer { try! exitRule() }
        do {
            setState(1717)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 210, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1713)
                try match(ObjectiveCParser.Tokens.DOT.rawValue)
                setState(1714)
                try expression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1715)
                try structInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1716)
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
        try enterRule(_localctx, 276, ObjectiveCParser.RULE_initializerList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1719)
            try initializer()
            setState(1724)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 211, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1720)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1721)
                    try initializer()

                }
                setState(1726)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 211, _ctx)
            }
            setState(1728)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1727)
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
        try enterRule(_localctx, 278, ObjectiveCParser.RULE_staticAssertDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1730)
            try match(ObjectiveCParser.Tokens.STATIC_ASSERT_.rawValue)
            setState(1731)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1732)
            try constantExpression()
            setState(1733)
            try match(ObjectiveCParser.Tokens.COMMA.rawValue)
            setState(1735)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1734)
                try stringLiteral()

                setState(1737)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
            setState(1739)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1740)
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
        try enterRule(_localctx, 280, ObjectiveCParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(1780)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 221, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1742)
                try labeledStatement()
                setState(1744)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 214, _ctx) {
                case 1:
                    setState(1743)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1746)
                try compoundStatement()
                setState(1748)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 215, _ctx) {
                case 1:
                    setState(1747)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1750)
                try selectionStatement()
                setState(1752)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 216, _ctx) {
                case 1:
                    setState(1751)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1754)
                try iterationStatement()
                setState(1756)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 217, _ctx) {
                case 1:
                    setState(1755)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1758)
                try jumpStatement()
                setState(1759)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1761)
                try synchronizedStatement()
                setState(1763)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 218, _ctx) {
                case 1:
                    setState(1762)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1765)
                try autoreleaseStatement()
                setState(1767)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 219, _ctx) {
                case 1:
                    setState(1766)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1769)
                try throwStatement()
                setState(1770)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(1772)
                try tryBlock()
                setState(1774)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 220, _ctx) {
                case 1:
                    setState(1773)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(1776)
                try expressions()
                setState(1777)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(1779)
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
        try enterRule(_localctx, 282, ObjectiveCParser.RULE_labeledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1782)
            try identifier()
            setState(1783)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(1784)
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
        try enterRule(_localctx, 284, ObjectiveCParser.RULE_rangeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1786)
            try expression()
            setState(1789)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue {
                setState(1787)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
                setState(1788)
                try expression()

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
        try enterRule(_localctx, 286, ObjectiveCParser.RULE_compoundStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1791)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1796)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_305_842_734_335_785_846) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -63_513_976_455_039) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 12_349_818_264_096_575) != 0
                || (Int64((_la - 194)) & ~0x3f) == 0 && ((Int64(1) << (_la - 194)) & 255) != 0
            {
                setState(1794)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 223, _ctx) {
                case 1:
                    setState(1792)
                    try statement()

                    break
                case 2:
                    setState(1793)
                    try declaration()

                    break
                default: break
                }

                setState(1798)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1799)
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
        try enterRule(_localctx, 288, ObjectiveCParser.RULE_selectionStatement)
        defer { try! exitRule() }
        do {
            setState(1811)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IF:
                try enterOuterAlt(_localctx, 1)
                setState(1801)
                try match(ObjectiveCParser.Tokens.IF.rawValue)
                setState(1802)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1803)
                try expressions()
                setState(1804)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1805)
                try {
                    let assignmentValue = try statement()
                    _localctx.castdown(SelectionStatementContext.self).ifBody = assignmentValue
                }()

                setState(1808)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 225, _ctx) {
                case 1:
                    setState(1806)
                    try match(ObjectiveCParser.Tokens.ELSE.rawValue)
                    setState(1807)
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
                setState(1810)
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
        try enterRule(_localctx, 290, ObjectiveCParser.RULE_switchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1813)
            try match(ObjectiveCParser.Tokens.SWITCH.rawValue)
            setState(1814)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1815)
            try expression()
            setState(1816)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1817)
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
        try enterRule(_localctx, 292, ObjectiveCParser.RULE_switchBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1819)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1823)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            {
                setState(1820)
                try switchSection()

                setState(1825)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1826)
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
        try enterRule(_localctx, 294, ObjectiveCParser.RULE_switchSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1829)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1828)
                try switchLabel()

                setState(1831)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            setState(1834)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1833)
                try statement()

                setState(1836)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64((_la - 2)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 2)) & 5_188_146_087_907_586_129) != 0
                || (Int64((_la - 71)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 71)) & 9_214_365_937_126_374_785) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & -72_045_533_668_529_405) != 0

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
        try enterRule(_localctx, 296, ObjectiveCParser.RULE_switchLabel)
        defer { try! exitRule() }
        do {
            setState(1850)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CASE:
                try enterOuterAlt(_localctx, 1)
                setState(1838)
                try match(ObjectiveCParser.Tokens.CASE.rawValue)
                setState(1844)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 230, _ctx) {
                case 1:
                    setState(1839)
                    try rangeExpression()

                    break
                case 2:
                    setState(1840)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(1841)
                    try rangeExpression()
                    setState(1842)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }
                setState(1846)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 2)
                setState(1848)
                try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)
                setState(1849)
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
        try enterRule(_localctx, 298, ObjectiveCParser.RULE_iterationStatement)
        defer { try! exitRule() }
        do {
            setState(1856)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 232, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1852)
                try whileStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1853)
                try doStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1854)
                try forStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1855)
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
        try enterRule(_localctx, 300, ObjectiveCParser.RULE_whileStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1858)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1859)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1860)
            try expression()
            setState(1861)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1862)
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
        try enterRule(_localctx, 302, ObjectiveCParser.RULE_doStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1864)
            try match(ObjectiveCParser.Tokens.DO.rawValue)
            setState(1865)
            try statement()
            setState(1866)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1867)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1868)
            try expression()
            setState(1869)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1870)
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
        try enterRule(_localctx, 304, ObjectiveCParser.RULE_forStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1872)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1873)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1875)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_921_212_276_324_914) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -36_092_310_995_844_991) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 12_349_818_228_444_991) != 0
                || (Int64((_la - 194)) & ~0x3f) == 0 && ((Int64(1) << (_la - 194)) & 255) != 0
            {
                setState(1874)
                try forLoopInitializer()

            }

            setState(1877)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1879)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
            {
                setState(1878)
                try expression()

            }

            setState(1881)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(1883)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
            {
                setState(1882)
                try expressions()

            }

            setState(1885)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1886)
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
        try enterRule(_localctx, 306, ObjectiveCParser.RULE_forLoopInitializer)
        defer { try! exitRule() }
        do {
            setState(1892)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 236, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1888)
                try declarationSpecifiers()
                setState(1889)
                try initDeclaratorList()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1891)
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
        try enterRule(_localctx, 308, ObjectiveCParser.RULE_forInStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1894)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(1895)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1896)
            try typeVariableDeclarator()
            setState(1897)
            try match(ObjectiveCParser.Tokens.IN.rawValue)
            setState(1899)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                || (Int64((_la - 92)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
            {
                setState(1898)
                try expression()

            }

            setState(1901)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1902)
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
        try enterRule(_localctx, 310, ObjectiveCParser.RULE_jumpStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1912)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .GOTO:
                try enterOuterAlt(_localctx, 1)
                setState(1904)
                try match(ObjectiveCParser.Tokens.GOTO.rawValue)
                setState(1905)
                try identifier()

                break

            case .CONTINUE:
                try enterOuterAlt(_localctx, 2)
                setState(1906)
                try match(ObjectiveCParser.Tokens.CONTINUE.rawValue)

                break

            case .BREAK:
                try enterOuterAlt(_localctx, 3)
                setState(1907)
                try match(ObjectiveCParser.Tokens.BREAK.rawValue)

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 4)
                setState(1908)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)
                setState(1910)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                {
                    setState(1909)
                    try expression()

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
        try enterRule(_localctx, 312, ObjectiveCParser.RULE_expressions)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1914)
            try expression()
            setState(1919)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 240, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1915)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1916)
                    try expression()

                }
                setState(1921)
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

    public class ExpressionContext: ParserRuleContext {
        open func assignmentExpression() -> AssignmentExpressionContext? {
            return getRuleContext(AssignmentExpressionContext.self, 0)
        }
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func compoundStatement() -> CompoundStatementContext? {
            return getRuleContext(CompoundStatementContext.self, 0)
        }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
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
    @discardableResult open func expression() throws -> ExpressionContext {
        var _localctx: ExpressionContext
        _localctx = ExpressionContext(_ctx, getState())
        try enterRule(_localctx, 314, ObjectiveCParser.RULE_expression)
        defer { try! exitRule() }
        do {
            setState(1927)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 241, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1922)
                try assignmentExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1923)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1924)
                try compoundStatement()
                setState(1925)
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

    public class AssignmentExpressionContext: ParserRuleContext {
        open func conditionalExpression() -> ConditionalExpressionContext? {
            return getRuleContext(ConditionalExpressionContext.self, 0)
        }
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
        try enterRule(_localctx, 316, ObjectiveCParser.RULE_assignmentExpression)
        defer { try! exitRule() }
        do {
            setState(1934)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 242, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1929)
                try conditionalExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1930)
                try unaryExpression()
                setState(1931)
                try assignmentOperator()
                setState(1932)
                try expression()

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
        try enterRule(_localctx, 318, ObjectiveCParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1936)
            _la = try _input.LA(1)
            if !((Int64((_la - 158)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 158)) & 34_326_183_937) != 0)
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

    public class ConditionalExpressionContext: ParserRuleContext {
        open var trueExpression: ExpressionContext!
        open var falseExpression: ConditionalExpressionContext!
        open func logicalOrExpression() -> LogicalOrExpressionContext? {
            return getRuleContext(LogicalOrExpressionContext.self, 0)
        }
        open func QUESTION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.QUESTION.rawValue, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func conditionalExpression() -> ConditionalExpressionContext? {
            return getRuleContext(ConditionalExpressionContext.self, 0)
        }
        open func expression() -> ExpressionContext? {
            return getRuleContext(ExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_conditionalExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterConditionalExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitConditionalExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitConditionalExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitConditionalExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func conditionalExpression() throws -> ConditionalExpressionContext {
        var _localctx: ConditionalExpressionContext
        _localctx = ConditionalExpressionContext(_ctx, getState())
        try enterRule(_localctx, 320, ObjectiveCParser.RULE_conditionalExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1938)
            try logicalOrExpression()
            setState(1945)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.QUESTION.rawValue {
                setState(1939)
                try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
                setState(1941)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                {
                    setState(1940)
                    try {
                        let assignmentValue = try expression()
                        _localctx.castdown(ConditionalExpressionContext.self).trueExpression =
                            assignmentValue
                    }()

                }

                setState(1943)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1944)
                try {
                    let assignmentValue = try conditionalExpression()
                    _localctx.castdown(ConditionalExpressionContext.self).falseExpression =
                        assignmentValue
                }()

            }

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class LogicalOrExpressionContext: ParserRuleContext {
        open func logicalAndExpression() -> [LogicalAndExpressionContext] {
            return getRuleContexts(LogicalAndExpressionContext.self)
        }
        open func logicalAndExpression(_ i: Int) -> LogicalAndExpressionContext? {
            return getRuleContext(LogicalAndExpressionContext.self, i)
        }
        open func OR() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.OR.rawValue) }
        open func OR(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.OR.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_logicalOrExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterLogicalOrExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitLogicalOrExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitLogicalOrExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitLogicalOrExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func logicalOrExpression() throws -> LogicalOrExpressionContext {
        var _localctx: LogicalOrExpressionContext
        _localctx = LogicalOrExpressionContext(_ctx, getState())
        try enterRule(_localctx, 322, ObjectiveCParser.RULE_logicalOrExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1947)
            try logicalAndExpression()
            setState(1952)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.OR.rawValue {
                setState(1948)
                try match(ObjectiveCParser.Tokens.OR.rawValue)
                setState(1949)
                try logicalAndExpression()

                setState(1954)
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

    public class LogicalAndExpressionContext: ParserRuleContext {
        open func bitwiseOrExpression() -> [BitwiseOrExpressionContext] {
            return getRuleContexts(BitwiseOrExpressionContext.self)
        }
        open func bitwiseOrExpression(_ i: Int) -> BitwiseOrExpressionContext? {
            return getRuleContext(BitwiseOrExpressionContext.self, i)
        }
        open func AND() -> [TerminalNode] { return getTokens(ObjectiveCParser.Tokens.AND.rawValue) }
        open func AND(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.AND.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_logicalAndExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterLogicalAndExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitLogicalAndExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitLogicalAndExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitLogicalAndExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func logicalAndExpression() throws -> LogicalAndExpressionContext {
        var _localctx: LogicalAndExpressionContext
        _localctx = LogicalAndExpressionContext(_ctx, getState())
        try enterRule(_localctx, 324, ObjectiveCParser.RULE_logicalAndExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1955)
            try bitwiseOrExpression()
            setState(1960)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.AND.rawValue {
                setState(1956)
                try match(ObjectiveCParser.Tokens.AND.rawValue)
                setState(1957)
                try bitwiseOrExpression()

                setState(1962)
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

    public class BitwiseOrExpressionContext: ParserRuleContext {
        open func bitwiseXorExpression() -> [BitwiseXorExpressionContext] {
            return getRuleContexts(BitwiseXorExpressionContext.self)
        }
        open func bitwiseXorExpression(_ i: Int) -> BitwiseXorExpressionContext? {
            return getRuleContext(BitwiseXorExpressionContext.self, i)
        }
        open func BITOR() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.BITOR.rawValue)
        }
        open func BITOR(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITOR.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_bitwiseOrExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBitwiseOrExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBitwiseOrExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBitwiseOrExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBitwiseOrExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func bitwiseOrExpression() throws -> BitwiseOrExpressionContext {
        var _localctx: BitwiseOrExpressionContext
        _localctx = BitwiseOrExpressionContext(_ctx, getState())
        try enterRule(_localctx, 326, ObjectiveCParser.RULE_bitwiseOrExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1963)
            try bitwiseXorExpression()
            setState(1968)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.BITOR.rawValue {
                setState(1964)
                try match(ObjectiveCParser.Tokens.BITOR.rawValue)
                setState(1965)
                try bitwiseXorExpression()

                setState(1970)
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

    public class BitwiseXorExpressionContext: ParserRuleContext {
        open func bitwiseAndExpression() -> [BitwiseAndExpressionContext] {
            return getRuleContexts(BitwiseAndExpressionContext.self)
        }
        open func bitwiseAndExpression(_ i: Int) -> BitwiseAndExpressionContext? {
            return getRuleContext(BitwiseAndExpressionContext.self, i)
        }
        open func BITXOR() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.BITXOR.rawValue)
        }
        open func BITXOR(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITXOR.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_bitwiseXorExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBitwiseXorExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBitwiseXorExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBitwiseXorExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBitwiseXorExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func bitwiseXorExpression() throws -> BitwiseXorExpressionContext {
        var _localctx: BitwiseXorExpressionContext
        _localctx = BitwiseXorExpressionContext(_ctx, getState())
        try enterRule(_localctx, 328, ObjectiveCParser.RULE_bitwiseXorExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1971)
            try bitwiseAndExpression()
            setState(1976)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.BITXOR.rawValue {
                setState(1972)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1973)
                try bitwiseAndExpression()

                setState(1978)
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

    public class BitwiseAndExpressionContext: ParserRuleContext {
        open func equalityExpression() -> [EqualityExpressionContext] {
            return getRuleContexts(EqualityExpressionContext.self)
        }
        open func equalityExpression(_ i: Int) -> EqualityExpressionContext? {
            return getRuleContext(EqualityExpressionContext.self, i)
        }
        open func BITAND() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.BITAND.rawValue)
        }
        open func BITAND(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.BITAND.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_bitwiseAndExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterBitwiseAndExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitBitwiseAndExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitBitwiseAndExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitBitwiseAndExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func bitwiseAndExpression() throws -> BitwiseAndExpressionContext {
        var _localctx: BitwiseAndExpressionContext
        _localctx = BitwiseAndExpressionContext(_ctx, getState())
        try enterRule(_localctx, 330, ObjectiveCParser.RULE_bitwiseAndExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1979)
            try equalityExpression()
            setState(1984)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.BITAND.rawValue {
                setState(1980)
                try match(ObjectiveCParser.Tokens.BITAND.rawValue)
                setState(1981)
                try equalityExpression()

                setState(1986)
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

    public class EqualityExpressionContext: ParserRuleContext {
        open func comparisonExpression() -> [ComparisonExpressionContext] {
            return getRuleContexts(ComparisonExpressionContext.self)
        }
        open func comparisonExpression(_ i: Int) -> ComparisonExpressionContext? {
            return getRuleContext(ComparisonExpressionContext.self, i)
        }
        open func equalityOperator() -> [EqualityOperatorContext] {
            return getRuleContexts(EqualityOperatorContext.self)
        }
        open func equalityOperator(_ i: Int) -> EqualityOperatorContext? {
            return getRuleContext(EqualityOperatorContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_equalityExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEqualityExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEqualityExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEqualityExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEqualityExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func equalityExpression() throws -> EqualityExpressionContext {
        var _localctx: EqualityExpressionContext
        _localctx = EqualityExpressionContext(_ctx, getState())
        try enterRule(_localctx, 332, ObjectiveCParser.RULE_equalityExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1987)
            try comparisonExpression()
            setState(1993)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.EQUAL.rawValue
                || _la == ObjectiveCParser.Tokens.NOTEQUAL.rawValue
            {
                setState(1988)
                try equalityOperator()
                setState(1989)
                try comparisonExpression()

                setState(1995)
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

    public class EqualityOperatorContext: ParserRuleContext {
        open func EQUAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EQUAL.rawValue, 0)
        }
        open func NOTEQUAL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.NOTEQUAL.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_equalityOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterEqualityOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitEqualityOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitEqualityOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitEqualityOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func equalityOperator() throws -> EqualityOperatorContext {
        var _localctx: EqualityOperatorContext
        _localctx = EqualityOperatorContext(_ctx, getState())
        try enterRule(_localctx, 334, ObjectiveCParser.RULE_equalityOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1996)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.EQUAL.rawValue
                || _la == ObjectiveCParser.Tokens.NOTEQUAL.rawValue)
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

    public class ComparisonExpressionContext: ParserRuleContext {
        open func shiftExpression() -> [ShiftExpressionContext] {
            return getRuleContexts(ShiftExpressionContext.self)
        }
        open func shiftExpression(_ i: Int) -> ShiftExpressionContext? {
            return getRuleContext(ShiftExpressionContext.self, i)
        }
        open func comparisonOperator() -> [ComparisonOperatorContext] {
            return getRuleContexts(ComparisonOperatorContext.self)
        }
        open func comparisonOperator(_ i: Int) -> ComparisonOperatorContext? {
            return getRuleContext(ComparisonOperatorContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_comparisonExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterComparisonExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitComparisonExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitComparisonExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitComparisonExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func comparisonExpression() throws -> ComparisonExpressionContext {
        var _localctx: ComparisonExpressionContext
        _localctx = ComparisonExpressionContext(_ctx, getState())
        try enterRule(_localctx, 336, ObjectiveCParser.RULE_comparisonExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1998)
            try shiftExpression()
            setState(2004)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64((_la - 161)) & ~0x3f) == 0 && ((Int64(1) << (_la - 161)) & 387) != 0 {
                setState(1999)
                try comparisonOperator()
                setState(2000)
                try shiftExpression()

                setState(2006)
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

    public class ComparisonOperatorContext: ParserRuleContext {
        open func LT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LT.rawValue, 0) }
        open func GT() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GT.rawValue, 0) }
        open func LE() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LE.rawValue, 0) }
        open func GE() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.GE.rawValue, 0) }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_comparisonOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterComparisonOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitComparisonOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitComparisonOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitComparisonOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func comparisonOperator() throws -> ComparisonOperatorContext {
        var _localctx: ComparisonOperatorContext
        _localctx = ComparisonOperatorContext(_ctx, getState())
        try enterRule(_localctx, 338, ObjectiveCParser.RULE_comparisonOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2007)
            _la = try _input.LA(1)
            if !((Int64((_la - 161)) & ~0x3f) == 0 && ((Int64(1) << (_la - 161)) & 387) != 0) {
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

    public class ShiftExpressionContext: ParserRuleContext {
        open func additiveExpression() -> [AdditiveExpressionContext] {
            return getRuleContexts(AdditiveExpressionContext.self)
        }
        open func additiveExpression(_ i: Int) -> AdditiveExpressionContext? {
            return getRuleContext(AdditiveExpressionContext.self, i)
        }
        open func shiftOperator() -> [ShiftOperatorContext] {
            return getRuleContexts(ShiftOperatorContext.self)
        }
        open func shiftOperator(_ i: Int) -> ShiftOperatorContext? {
            return getRuleContext(ShiftOperatorContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_shiftExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterShiftExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitShiftExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitShiftExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitShiftExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func shiftExpression() throws -> ShiftExpressionContext {
        var _localctx: ShiftExpressionContext
        _localctx = ShiftExpressionContext(_ctx, getState())
        try enterRule(_localctx, 340, ObjectiveCParser.RULE_shiftExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2009)
            try additiveExpression()
            setState(2015)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LSHIFT.rawValue
                || _la == ObjectiveCParser.Tokens.RSHIFT.rawValue
            {
                setState(2010)
                try shiftOperator()
                setState(2011)
                try additiveExpression()

                setState(2017)
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

    public class ShiftOperatorContext: ParserRuleContext {
        open func LSHIFT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.LSHIFT.rawValue, 0)
        }
        open func RSHIFT() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.RSHIFT.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_shiftOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterShiftOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitShiftOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitShiftOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitShiftOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func shiftOperator() throws -> ShiftOperatorContext {
        var _localctx: ShiftOperatorContext
        _localctx = ShiftOperatorContext(_ctx, getState())
        try enterRule(_localctx, 342, ObjectiveCParser.RULE_shiftOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2018)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.LSHIFT.rawValue
                || _la == ObjectiveCParser.Tokens.RSHIFT.rawValue)
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

    public class AdditiveExpressionContext: ParserRuleContext {
        open func multiplicativeExpression() -> [MultiplicativeExpressionContext] {
            return getRuleContexts(MultiplicativeExpressionContext.self)
        }
        open func multiplicativeExpression(_ i: Int) -> MultiplicativeExpressionContext? {
            return getRuleContext(MultiplicativeExpressionContext.self, i)
        }
        open func additiveOperator() -> [AdditiveOperatorContext] {
            return getRuleContexts(AdditiveOperatorContext.self)
        }
        open func additiveOperator(_ i: Int) -> AdditiveOperatorContext? {
            return getRuleContext(AdditiveOperatorContext.self, i)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_additiveExpression }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAdditiveExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAdditiveExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAdditiveExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAdditiveExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func additiveExpression() throws -> AdditiveExpressionContext {
        var _localctx: AdditiveExpressionContext
        _localctx = AdditiveExpressionContext(_ctx, getState())
        try enterRule(_localctx, 344, ObjectiveCParser.RULE_additiveExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2020)
            try multiplicativeExpression()
            setState(2026)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue
            {
                setState(2021)
                try additiveOperator()
                setState(2022)
                try multiplicativeExpression()

                setState(2028)
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

    public class AdditiveOperatorContext: ParserRuleContext {
        open func ADD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.ADD.rawValue, 0)
        }
        open func SUB() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SUB.rawValue, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_additiveOperator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterAdditiveOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitAdditiveOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitAdditiveOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitAdditiveOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func additiveOperator() throws -> AdditiveOperatorContext {
        var _localctx: AdditiveOperatorContext
        _localctx = AdditiveOperatorContext(_ctx, getState())
        try enterRule(_localctx, 346, ObjectiveCParser.RULE_additiveOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2029)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.ADD.rawValue
                || _la == ObjectiveCParser.Tokens.SUB.rawValue)
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

    public class MultiplicativeExpressionContext: ParserRuleContext {
        open func castExpression() -> [CastExpressionContext] {
            return getRuleContexts(CastExpressionContext.self)
        }
        open func castExpression(_ i: Int) -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, i)
        }
        open func multiplicativeOperator() -> [MultiplicativeOperatorContext] {
            return getRuleContexts(MultiplicativeOperatorContext.self)
        }
        open func multiplicativeOperator(_ i: Int) -> MultiplicativeOperatorContext? {
            return getRuleContext(MultiplicativeOperatorContext.self, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_multiplicativeExpression
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMultiplicativeExpression(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMultiplicativeExpression(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMultiplicativeExpression(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMultiplicativeExpression(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func multiplicativeExpression() throws
        -> MultiplicativeExpressionContext
    {
        var _localctx: MultiplicativeExpressionContext
        _localctx = MultiplicativeExpressionContext(_ctx, getState())
        try enterRule(_localctx, 348, ObjectiveCParser.RULE_multiplicativeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2031)
            try castExpression()
            setState(2037)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64((_la - 177)) & ~0x3f) == 0 && ((Int64(1) << (_la - 177)) & 35) != 0 {
                setState(2032)
                try multiplicativeOperator()
                setState(2033)
                try castExpression()

                setState(2039)
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

    public class MultiplicativeOperatorContext: ParserRuleContext {
        open func MUL() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MUL.rawValue, 0)
        }
        open func DIV() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.DIV.rawValue, 0)
        }
        open func MOD() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.MOD.rawValue, 0)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_multiplicativeOperator
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterMultiplicativeOperator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitMultiplicativeOperator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitMultiplicativeOperator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitMultiplicativeOperator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func multiplicativeOperator() throws -> MultiplicativeOperatorContext {
        var _localctx: MultiplicativeOperatorContext
        _localctx = MultiplicativeOperatorContext(_ctx, getState())
        try enterRule(_localctx, 350, ObjectiveCParser.RULE_multiplicativeOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2040)
            _la = try _input.LA(1)
            if !((Int64((_la - 177)) & ~0x3f) == 0 && ((Int64(1) << (_la - 177)) & 35) != 0) {
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
        open func LP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.LP.rawValue, 0) }
        open func typeName() -> TypeNameContext? { return getRuleContext(TypeNameContext.self, 0) }
        open func RP() -> TerminalNode? { return getToken(ObjectiveCParser.Tokens.RP.rawValue, 0) }
        open func castExpression() -> CastExpressionContext? {
            return getRuleContext(CastExpressionContext.self, 0)
        }
        open func EXTENSION() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.EXTENSION.rawValue, 0)
        }
        open func unaryExpression() -> UnaryExpressionContext? {
            return getRuleContext(UnaryExpressionContext.self, 0)
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
        try enterRule(_localctx, 352, ObjectiveCParser.RULE_castExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2052)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 256, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2043)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.EXTENSION.rawValue {
                    setState(2042)
                    try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)

                }

                setState(2045)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2046)
                try typeName()
                setState(2047)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(2048)
                try castExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2050)
                try unaryExpression()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2051)
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
        try enterRule(_localctx, 354, ObjectiveCParser.RULE_initializer)
        defer { try! exitRule() }
        do {
            setState(2057)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 257, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2054)
                try expression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2055)
                try arrayInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2056)
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
        try enterRule(_localctx, 356, ObjectiveCParser.RULE_constantExpression)
        defer { try! exitRule() }
        do {
            setState(2061)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT, .PROTOCOL_,
                .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN, .COVARIANT, .CONTRAVARIANT,
                .DEPRECATED, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER,
                .STRONG, .READONLY, .READWRITE, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(2059)
                try identifier()

                break
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                try enterOuterAlt(_localctx, 2)
                setState(2060)
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
        try enterRule(_localctx, 358, ObjectiveCParser.RULE_unaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2077)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 260, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2063)
                try postfixExpression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2064)
                try match(ObjectiveCParser.Tokens.SIZEOF.rawValue)
                setState(2070)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 259, _ctx) {
                case 1:
                    setState(2065)
                    try unaryExpression()

                    break
                case 2:
                    setState(2066)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(2067)
                    try typeSpecifier()
                    setState(2068)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2072)
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
                setState(2073)
                try unaryExpression()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2074)
                try unaryOperator()
                setState(2075)
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
        try enterRule(_localctx, 360, ObjectiveCParser.RULE_unaryOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2079)
            _la = try _input.LA(1)
            if !((Int64((_la - 163)) & ~0x3f) == 0 && ((Int64(1) << (_la - 163)) & 94211) != 0) {
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
        let _startState: Int = 362
        try enterRecursionRule(_localctx, 362, ObjectiveCParser.RULE_postfixExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2082)
            try primaryExpression()
            setState(2086)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 261, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2083)
                    try postfixExpr()

                }
                setState(2088)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 261, _ctx)
            }

            _ctx!.stop = try _input.LT(-1)
            setState(2100)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 263, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    _localctx = PostfixExpressionContext(_parentctx, _parentState)
                    try pushNewRecursionContext(
                        _localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
                    setState(2089)
                    if !(precpred(_ctx, 1)) {
                        throw ANTLRException.recognition(
                            e: FailedPredicateException(self, "precpred(_ctx, 1)"))
                    }
                    setState(2090)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.DOT.rawValue
                        || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }
                    setState(2091)
                    try identifier()
                    setState(2095)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 262, _ctx)
                    while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                        if _alt == 1 {
                            setState(2092)
                            try postfixExpr()

                        }
                        setState(2097)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 262, _ctx)
                    }

                }
                setState(2102)
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
        try enterRule(_localctx, 364, ObjectiveCParser.RULE_primaryExpression)
        defer { try! exitRule() }
        do {
            setState(2118)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 264, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2103)
                try identifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2104)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2105)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2106)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2107)
                try expression()
                setState(2108)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2110)
                try messageExpression()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2111)
                try selectorExpression()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2112)
                try protocolExpression()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2113)
                try encodeExpression()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2114)
                try dictionaryExpression()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2115)
                try arrayExpression()

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2116)
                try boxExpression()

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2117)
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
        try enterRule(_localctx, 366, ObjectiveCParser.RULE_postfixExpr)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2130)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(2120)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(2121)
                try expression()
                setState(2122)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(2124)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2126)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 2_026_690_785_176_371_201) != 0
                    || (Int64((_la - 92)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 92)) & 630_719_447_816_470_535) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 35_046_956_138_689) != 0
                {
                    setState(2125)
                    try argumentExpressionList()

                }

                setState(2128)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case .INC, .DEC:
                try enterOuterAlt(_localctx, 3)
                setState(2129)
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
        try enterRule(_localctx, 368, ObjectiveCParser.RULE_argumentExpressionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2132)
            try argumentExpression()
            setState(2137)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(2133)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(2134)
                try argumentExpression()

                setState(2139)
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
        try enterRule(_localctx, 370, ObjectiveCParser.RULE_argumentExpression)
        defer { try! exitRule() }
        do {
            setState(2142)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 268, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2140)
                try expression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2141)
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
        try enterRule(_localctx, 372, ObjectiveCParser.RULE_messageExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2144)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(2145)
            try receiver()
            setState(2146)
            try messageSelector()
            setState(2147)
            try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

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
        try enterRule(_localctx, 374, ObjectiveCParser.RULE_constant)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2167)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 271, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2149)
                try match(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2150)
                try match(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2151)
                try match(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2153)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2152)
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

                setState(2155)
                try match(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2157)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2156)
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

                setState(2159)
                try match(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2160)
                try match(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue)

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2161)
                try match(ObjectiveCParser.Tokens.NIL.rawValue)

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2162)
                try match(ObjectiveCParser.Tokens.NULL.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2163)
                try match(ObjectiveCParser.Tokens.YES.rawValue)

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2164)
                try match(ObjectiveCParser.Tokens.NO.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2165)
                try match(ObjectiveCParser.Tokens.TRUE.rawValue)

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2166)
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
        try enterRule(_localctx, 376, ObjectiveCParser.RULE_stringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2177)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(2169)
                    try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
                    setState(2173)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                        || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
                    {
                        setState(2170)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                            || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }

                        setState(2175)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }
                    setState(2176)
                    try match(ObjectiveCParser.Tokens.STRING_END.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(2179)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 273, _ctx)
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
        try enterRule(_localctx, 378, ObjectiveCParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2181)
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
        case 82:
            return try directDeclarator_sempred(
                _localctx?.castdown(DirectDeclaratorContext.self), predIndex)
        case 87:
            return try directAbstractDeclarator_sempred(
                _localctx?.castdown(DirectAbstractDeclaratorContext.self), predIndex)
        case 181:
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
    private func postfixExpression_sempred(_ _localctx: PostfixExpressionContext!, _ predIndex: Int)
        throws -> Bool
    {
        switch predIndex {
        case 10: return precpred(_ctx, 1)
        default: return true
        }
    }

    static let _serializedATN: [Int] = [
        4, 1, 250, 2184, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
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
        7, 178, 2, 179, 7, 179, 2, 180, 7, 180, 2, 181, 7, 181, 2, 182, 7, 182, 2, 183, 7, 183, 2,
        184, 7, 184, 2, 185, 7, 185, 2, 186, 7, 186, 2, 187, 7, 187, 2, 188, 7, 188, 2, 189, 7, 189,
        1, 0, 5, 0, 382, 8, 0, 10, 0, 12, 0, 385, 9, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 399, 8, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 3, 3, 3, 406, 8, 3,
        1, 3, 1, 3, 1, 3, 3, 3, 411, 8, 3, 1, 3, 3, 3, 414, 8, 3, 1, 3, 1, 3, 1, 4, 1, 4, 1, 4, 1,
        4, 3, 4, 422, 8, 4, 3, 4, 424, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 430, 8, 4, 1, 5, 1, 5, 1,
        5, 1, 5, 3, 5, 436, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 443, 8, 5, 1, 5, 3, 5, 446, 8,
        5, 1, 5, 3, 5, 449, 8, 5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 3, 6, 456, 8, 6, 1, 6, 3, 6, 459, 8,
        6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 3, 7, 467, 8, 7, 3, 7, 469, 8, 7, 1, 8, 1, 8, 1, 8,
        1, 8, 3, 8, 475, 8, 8, 1, 8, 1, 8, 3, 8, 479, 8, 8, 1, 8, 1, 8, 1, 9, 1, 9, 3, 9, 485, 8, 9,
        1, 10, 1, 10, 1, 11, 1, 11, 1, 11, 1, 12, 1, 12, 1, 12, 1, 12, 5, 12, 496, 8, 12, 10, 12,
        12, 12, 499, 9, 12, 3, 12, 501, 8, 12, 1, 12, 1, 12, 1, 13, 5, 13, 506, 8, 13, 10, 13, 12,
        13, 509, 9, 13, 1, 13, 1, 13, 1, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 520,
        8, 14, 1, 14, 5, 14, 523, 8, 14, 10, 14, 12, 14, 526, 9, 14, 1, 14, 1, 14, 1, 15, 1, 15, 5,
        15, 532, 8, 15, 10, 15, 12, 15, 535, 9, 15, 1, 15, 4, 15, 538, 8, 15, 11, 15, 12, 15, 539,
        3, 15, 542, 8, 15, 1, 16, 1, 16, 1, 16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17, 552, 8,
        17, 10, 17, 12, 17, 555, 9, 17, 1, 17, 1, 17, 1, 18, 1, 18, 1, 18, 1, 18, 1, 18, 3, 18, 564,
        8, 18, 1, 19, 1, 19, 1, 19, 5, 19, 569, 8, 19, 10, 19, 12, 19, 572, 9, 19, 1, 20, 1, 20, 1,
        20, 1, 20, 1, 20, 3, 20, 579, 8, 20, 1, 20, 3, 20, 582, 8, 20, 1, 20, 3, 20, 585, 8, 20, 1,
        20, 1, 20, 1, 21, 1, 21, 1, 21, 5, 21, 592, 8, 21, 10, 21, 12, 21, 595, 9, 21, 1, 22, 1, 22,
        1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22, 3, 22, 608, 8, 22, 1, 23, 1,
        23, 1, 23, 1, 23, 1, 23, 3, 23, 615, 8, 23, 1, 23, 3, 23, 618, 8, 23, 1, 24, 1, 24, 5, 24,
        622, 8, 24, 10, 24, 12, 24, 625, 9, 24, 1, 24, 1, 24, 1, 25, 1, 25, 5, 25, 631, 8, 25, 10,
        25, 12, 25, 634, 9, 25, 1, 25, 4, 25, 637, 8, 25, 11, 25, 12, 25, 638, 3, 25, 641, 8, 25, 1,
        26, 1, 26, 1, 27, 1, 27, 1, 27, 1, 27, 1, 27, 4, 27, 650, 8, 27, 11, 27, 12, 27, 651, 1, 28,
        1, 28, 1, 28, 1, 29, 1, 29, 1, 29, 1, 30, 3, 30, 661, 8, 30, 1, 30, 1, 30, 5, 30, 665, 8,
        30, 10, 30, 12, 30, 668, 9, 30, 1, 30, 3, 30, 671, 8, 30, 1, 30, 1, 30, 1, 31, 1, 31, 1, 31,
        1, 31, 1, 31, 4, 31, 680, 8, 31, 11, 31, 12, 31, 681, 1, 32, 1, 32, 1, 32, 1, 33, 1, 33, 1,
        33, 1, 34, 3, 34, 691, 8, 34, 1, 34, 1, 34, 3, 34, 695, 8, 34, 1, 34, 3, 34, 698, 8, 34, 1,
        34, 3, 34, 701, 8, 34, 1, 34, 1, 34, 3, 34, 705, 8, 34, 1, 35, 1, 35, 4, 35, 709, 8, 35, 11,
        35, 12, 35, 710, 1, 35, 1, 35, 3, 35, 715, 8, 35, 3, 35, 717, 8, 35, 1, 36, 3, 36, 720, 8,
        36, 1, 36, 1, 36, 5, 36, 724, 8, 36, 10, 36, 12, 36, 727, 9, 36, 1, 36, 3, 36, 730, 8, 36,
        1, 36, 1, 36, 1, 37, 1, 37, 1, 37, 1, 37, 1, 37, 1, 37, 3, 37, 740, 8, 37, 1, 38, 1, 38, 1,
        38, 1, 38, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 1, 39, 3, 39, 754, 8, 39, 1, 40,
        1, 40, 1, 40, 5, 40, 759, 8, 40, 10, 40, 12, 40, 762, 9, 40, 1, 41, 1, 41, 1, 41, 3, 41,
        767, 8, 41, 1, 42, 1, 42, 1, 42, 1, 42, 1, 42, 5, 42, 774, 8, 42, 10, 42, 12, 42, 777, 9,
        42, 1, 42, 3, 42, 780, 8, 42, 3, 42, 782, 8, 42, 1, 42, 1, 42, 1, 43, 1, 43, 1, 43, 1, 43,
        1, 44, 1, 44, 1, 44, 1, 44, 3, 44, 794, 8, 44, 3, 44, 796, 8, 44, 1, 44, 1, 44, 1, 45, 1,
        45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 3, 45, 808, 8, 45, 3, 45, 810, 8, 45, 1, 46,
        1, 46, 1, 46, 3, 46, 815, 8, 46, 1, 46, 1, 46, 5, 46, 819, 8, 46, 10, 46, 12, 46, 822, 9,
        46, 3, 46, 824, 8, 46, 1, 46, 1, 46, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47,
        1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 1, 47, 3, 47, 843, 8, 47, 1, 48, 1, 48, 3, 48,
        847, 8, 48, 1, 49, 1, 49, 4, 49, 851, 8, 49, 11, 49, 12, 49, 852, 3, 49, 855, 8, 49, 1, 50,
        3, 50, 858, 8, 50, 1, 50, 1, 50, 1, 50, 1, 50, 5, 50, 864, 8, 50, 10, 50, 12, 50, 867, 9,
        50, 1, 51, 1, 51, 3, 51, 871, 8, 51, 1, 51, 1, 51, 1, 51, 1, 51, 3, 51, 877, 8, 51, 1, 52,
        1, 52, 1, 52, 1, 52, 1, 52, 1, 53, 1, 53, 3, 53, 886, 8, 53, 1, 53, 4, 53, 889, 8, 53, 11,
        53, 12, 53, 890, 3, 53, 893, 8, 53, 1, 54, 1, 54, 1, 54, 1, 54, 1, 54, 1, 55, 1, 55, 1, 55,
        1, 55, 1, 55, 1, 56, 1, 56, 1, 56, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 1, 57, 3, 57,
        915, 8, 57, 1, 58, 1, 58, 1, 58, 5, 58, 920, 8, 58, 10, 58, 12, 58, 923, 9, 58, 1, 58, 1,
        58, 3, 58, 927, 8, 58, 1, 59, 1, 59, 1, 59, 1, 59, 1, 59, 1, 59, 1, 60, 1, 60, 1, 60, 1, 60,
        1, 60, 1, 60, 1, 61, 1, 61, 1, 61, 1, 62, 1, 62, 1, 62, 1, 63, 1, 63, 1, 63, 1, 64, 3, 64,
        951, 8, 64, 1, 64, 1, 64, 3, 64, 955, 8, 64, 1, 65, 4, 65, 958, 8, 65, 11, 65, 12, 65, 959,
        1, 66, 1, 66, 3, 66, 964, 8, 66, 1, 67, 1, 67, 3, 67, 968, 8, 67, 1, 68, 1, 68, 3, 68, 972,
        8, 68, 1, 68, 1, 68, 1, 69, 1, 69, 1, 69, 5, 69, 979, 8, 69, 10, 69, 12, 69, 982, 9, 69, 1,
        70, 1, 70, 1, 70, 1, 70, 3, 70, 988, 8, 70, 1, 71, 1, 71, 1, 71, 1, 71, 1, 71, 3, 71, 995,
        8, 71, 1, 72, 1, 72, 1, 72, 1, 72, 3, 72, 1001, 8, 72, 1, 72, 1, 72, 1, 72, 3, 72, 1006, 8,
        72, 1, 72, 1, 72, 1, 73, 1, 73, 1, 73, 3, 73, 1013, 8, 73, 1, 74, 1, 74, 1, 74, 5, 74, 1018,
        8, 74, 10, 74, 12, 74, 1021, 9, 74, 1, 75, 1, 75, 3, 75, 1025, 8, 75, 1, 75, 3, 75, 1028, 8,
        75, 1, 75, 3, 75, 1031, 8, 75, 1, 76, 1, 76, 1, 76, 1, 76, 1, 76, 1, 76, 1, 76, 1, 76, 1,
        76, 3, 76, 1042, 8, 76, 1, 77, 4, 77, 1045, 8, 77, 11, 77, 12, 77, 1046, 1, 78, 1, 78, 3,
        78, 1051, 8, 78, 1, 78, 1, 78, 1, 78, 3, 78, 1056, 8, 78, 1, 79, 1, 79, 1, 79, 5, 79, 1061,
        8, 79, 10, 79, 12, 79, 1064, 9, 79, 1, 80, 1, 80, 1, 80, 3, 80, 1069, 8, 80, 1, 81, 3, 81,
        1072, 8, 81, 1, 81, 1, 81, 5, 81, 1076, 8, 81, 10, 81, 12, 81, 1079, 9, 81, 1, 82, 1, 82, 1,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 5, 82, 1090, 8, 82, 10, 82, 12, 82, 1093, 9,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1,
        82, 1, 82, 1, 82, 1, 82, 3, 82, 1111, 8, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1116, 8, 82, 1, 82,
        3, 82, 1119, 8, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1126, 8, 82, 1, 82, 1, 82, 1,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1141, 8,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1148, 8, 82, 1, 82, 5, 82, 1151, 8, 82, 10,
        82, 12, 82, 1154, 9, 82, 1, 83, 1, 83, 1, 83, 1, 83, 3, 83, 1160, 8, 83, 1, 84, 1, 84, 3,
        84, 1164, 8, 84, 1, 85, 1, 85, 3, 85, 1168, 8, 85, 1, 85, 1, 85, 3, 85, 1172, 8, 85, 1, 85,
        1, 85, 4, 85, 1176, 8, 85, 11, 85, 12, 85, 1177, 1, 85, 1, 85, 3, 85, 1182, 8, 85, 1, 85, 4,
        85, 1185, 8, 85, 11, 85, 12, 85, 1186, 3, 85, 1189, 8, 85, 1, 86, 1, 86, 3, 86, 1193, 8, 86,
        1, 86, 1, 86, 5, 86, 1197, 8, 86, 10, 86, 12, 86, 1200, 9, 86, 3, 86, 1202, 8, 86, 1, 87, 1,
        87, 1, 87, 1, 87, 1, 87, 5, 87, 1209, 8, 87, 10, 87, 12, 87, 1212, 9, 87, 1, 87, 1, 87, 3,
        87, 1216, 8, 87, 1, 87, 3, 87, 1219, 8, 87, 1, 87, 1, 87, 1, 87, 1, 87, 3, 87, 1225, 8, 87,
        1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87,
        1, 87, 3, 87, 1241, 8, 87, 1, 87, 1, 87, 5, 87, 1245, 8, 87, 10, 87, 12, 87, 1248, 9, 87, 1,
        87, 1, 87, 1, 87, 5, 87, 1253, 8, 87, 10, 87, 12, 87, 1256, 9, 87, 1, 87, 3, 87, 1259, 8,
        87, 1, 87, 1, 87, 3, 87, 1263, 8, 87, 1, 87, 1, 87, 1, 87, 3, 87, 1268, 8, 87, 1, 87, 3, 87,
        1271, 8, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 3, 87, 1278, 8, 87, 1, 87, 1, 87, 1, 87, 1,
        87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1, 87, 1,
        87, 3, 87, 1297, 8, 87, 1, 87, 1, 87, 5, 87, 1301, 8, 87, 10, 87, 12, 87, 1304, 9, 87, 5,
        87, 1306, 8, 87, 10, 87, 12, 87, 1309, 9, 87, 1, 88, 1, 88, 3, 88, 1313, 8, 88, 1, 88, 1,
        88, 1, 88, 3, 88, 1318, 8, 88, 1, 88, 3, 88, 1321, 8, 88, 1, 89, 1, 89, 1, 89, 3, 89, 1326,
        8, 89, 1, 90, 1, 90, 1, 90, 5, 90, 1331, 8, 90, 10, 90, 12, 90, 1334, 9, 90, 1, 91, 1, 91,
        1, 91, 5, 91, 1339, 8, 91, 10, 91, 12, 91, 1342, 9, 91, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92,
        3, 92, 1349, 8, 92, 3, 92, 1351, 8, 92, 1, 93, 4, 93, 1354, 8, 93, 11, 93, 12, 93, 1355, 1,
        94, 1, 94, 1, 94, 5, 94, 1361, 8, 94, 10, 94, 12, 94, 1364, 9, 94, 1, 95, 1, 95, 3, 95,
        1368, 8, 95, 1, 95, 1, 95, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 5, 96, 1378, 8, 96, 10,
        96, 12, 96, 1381, 9, 96, 1, 96, 1, 96, 1, 96, 1, 97, 1, 97, 1, 97, 1, 97, 1, 97, 1, 98, 1,
        98, 1, 98, 3, 98, 1394, 8, 98, 1, 98, 1, 98, 1, 99, 1, 99, 5, 99, 1400, 8, 99, 10, 99, 12,
        99, 1403, 9, 99, 1, 99, 3, 99, 1406, 8, 99, 1, 99, 1, 99, 1, 99, 1, 99, 1, 99, 1, 99, 5, 99,
        1414, 8, 99, 10, 99, 12, 99, 1417, 9, 99, 1, 99, 1, 99, 3, 99, 1421, 8, 99, 1, 100, 1, 100,
        1, 101, 4, 101, 1426, 8, 101, 11, 101, 12, 101, 1427, 1, 102, 5, 102, 1431, 8, 102, 10, 102,
        12, 102, 1434, 9, 102, 1, 102, 1, 102, 1, 102, 1, 102, 1, 102, 5, 102, 1441, 8, 102, 10,
        102, 12, 102, 1444, 9, 102, 1, 102, 1, 102, 1, 102, 1, 102, 3, 102, 1450, 8, 102, 1, 103, 1,
        103, 3, 103, 1454, 8, 103, 1, 103, 3, 103, 1457, 8, 103, 1, 104, 1, 104, 3, 104, 1461, 8,
        104, 1, 104, 1, 104, 3, 104, 1465, 8, 104, 1, 104, 1, 104, 1, 104, 1, 104, 1, 104, 3, 104,
        1472, 8, 104, 1, 104, 1, 104, 1, 104, 1, 104, 3, 104, 1478, 8, 104, 1, 104, 1, 104, 1, 104,
        1, 104, 1, 104, 1, 104, 1, 104, 1, 104, 1, 104, 1, 104, 3, 104, 1490, 8, 104, 1, 105, 1,
        105, 1, 105, 5, 105, 1495, 8, 105, 10, 105, 12, 105, 1498, 9, 105, 1, 105, 3, 105, 1501, 8,
        105, 1, 106, 1, 106, 1, 106, 3, 106, 1506, 8, 106, 1, 107, 1, 107, 1, 108, 1, 108, 1, 108,
        1, 108, 1, 108, 1, 108, 3, 108, 1516, 8, 108, 1, 109, 1, 109, 1, 110, 1, 110, 1, 111, 1,
        111, 1, 112, 1, 112, 1, 113, 1, 113, 1, 113, 1, 113, 1, 113, 3, 113, 1531, 8, 113, 1, 114,
        1, 114, 1, 114, 1, 114, 1, 114, 1, 114, 1, 114, 3, 114, 1540, 8, 114, 1, 115, 1, 115, 1,
        115, 1, 115, 3, 115, 1546, 8, 115, 1, 115, 1, 115, 1, 116, 1, 116, 1, 117, 1, 117, 1, 117,
        1, 117, 1, 117, 1, 117, 1, 117, 1, 117, 1, 117, 1, 117, 1, 117, 3, 117, 1563, 8, 117, 1,
        118, 1, 118, 1, 118, 1, 118, 1, 118, 1, 119, 1, 119, 1, 120, 1, 120, 1, 120, 1, 121, 1, 121,
        1, 121, 1, 121, 5, 121, 1579, 8, 121, 10, 121, 12, 121, 1582, 9, 121, 3, 121, 1584, 8, 121,
        1, 121, 1, 121, 1, 122, 3, 122, 1589, 8, 122, 1, 122, 1, 122, 1, 123, 1, 123, 1, 124, 1,
        124, 1, 124, 5, 124, 1598, 8, 124, 10, 124, 12, 124, 1601, 9, 124, 1, 125, 1, 125, 3, 125,
        1605, 8, 125, 1, 125, 1, 125, 3, 125, 1609, 8, 125, 1, 126, 1, 126, 1, 127, 1, 127, 1, 127,
        4, 127, 1616, 8, 127, 11, 127, 12, 127, 1617, 1, 127, 1, 127, 1, 127, 3, 127, 1623, 8, 127,
        1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 1, 128, 1, 129, 3, 129, 1633, 8, 129, 1,
        129, 1, 129, 3, 129, 1637, 8, 129, 5, 129, 1639, 8, 129, 10, 129, 12, 129, 1642, 9, 129, 1,
        130, 1, 130, 1, 130, 3, 130, 1647, 8, 130, 1, 130, 3, 130, 1650, 8, 130, 1, 131, 1, 131, 3,
        131, 1654, 8, 131, 1, 131, 3, 131, 1657, 8, 131, 1, 132, 4, 132, 1660, 8, 132, 11, 132, 12,
        132, 1661, 1, 133, 1, 133, 3, 133, 1666, 8, 133, 1, 133, 3, 133, 1669, 8, 133, 1, 134, 1,
        134, 1, 134, 1, 134, 4, 134, 1675, 8, 134, 11, 134, 12, 134, 1676, 1, 134, 3, 134, 1680, 8,
        134, 1, 135, 1, 135, 1, 135, 1, 135, 5, 135, 1686, 8, 135, 10, 135, 12, 135, 1689, 9, 135,
        1, 135, 3, 135, 1692, 8, 135, 3, 135, 1694, 8, 135, 1, 135, 1, 135, 1, 136, 1, 136, 1, 136,
        1, 136, 5, 136, 1702, 8, 136, 10, 136, 12, 136, 1705, 9, 136, 1, 136, 3, 136, 1708, 8, 136,
        3, 136, 1710, 8, 136, 1, 136, 1, 136, 1, 137, 1, 137, 1, 137, 1, 137, 3, 137, 1718, 8, 137,
        1, 138, 1, 138, 1, 138, 5, 138, 1723, 8, 138, 10, 138, 12, 138, 1726, 9, 138, 1, 138, 3,
        138, 1729, 8, 138, 1, 139, 1, 139, 1, 139, 1, 139, 1, 139, 4, 139, 1736, 8, 139, 11, 139,
        12, 139, 1737, 1, 139, 1, 139, 1, 139, 1, 140, 1, 140, 3, 140, 1745, 8, 140, 1, 140, 1, 140,
        3, 140, 1749, 8, 140, 1, 140, 1, 140, 3, 140, 1753, 8, 140, 1, 140, 1, 140, 3, 140, 1757, 8,
        140, 1, 140, 1, 140, 1, 140, 1, 140, 1, 140, 3, 140, 1764, 8, 140, 1, 140, 1, 140, 3, 140,
        1768, 8, 140, 1, 140, 1, 140, 1, 140, 1, 140, 1, 140, 3, 140, 1775, 8, 140, 1, 140, 1, 140,
        1, 140, 1, 140, 3, 140, 1781, 8, 140, 1, 141, 1, 141, 1, 141, 1, 141, 1, 142, 1, 142, 1,
        142, 3, 142, 1790, 8, 142, 1, 143, 1, 143, 1, 143, 5, 143, 1795, 8, 143, 10, 143, 12, 143,
        1798, 9, 143, 1, 143, 1, 143, 1, 144, 1, 144, 1, 144, 1, 144, 1, 144, 1, 144, 1, 144, 3,
        144, 1809, 8, 144, 1, 144, 3, 144, 1812, 8, 144, 1, 145, 1, 145, 1, 145, 1, 145, 1, 145, 1,
        145, 1, 146, 1, 146, 5, 146, 1822, 8, 146, 10, 146, 12, 146, 1825, 9, 146, 1, 146, 1, 146,
        1, 147, 4, 147, 1830, 8, 147, 11, 147, 12, 147, 1831, 1, 147, 4, 147, 1835, 8, 147, 11, 147,
        12, 147, 1836, 1, 148, 1, 148, 1, 148, 1, 148, 1, 148, 1, 148, 3, 148, 1845, 8, 148, 1, 148,
        1, 148, 1, 148, 1, 148, 3, 148, 1851, 8, 148, 1, 149, 1, 149, 1, 149, 1, 149, 3, 149, 1857,
        8, 149, 1, 150, 1, 150, 1, 150, 1, 150, 1, 150, 1, 150, 1, 151, 1, 151, 1, 151, 1, 151, 1,
        151, 1, 151, 1, 151, 1, 151, 1, 152, 1, 152, 1, 152, 3, 152, 1876, 8, 152, 1, 152, 1, 152,
        3, 152, 1880, 8, 152, 1, 152, 1, 152, 3, 152, 1884, 8, 152, 1, 152, 1, 152, 1, 152, 1, 153,
        1, 153, 1, 153, 1, 153, 3, 153, 1893, 8, 153, 1, 154, 1, 154, 1, 154, 1, 154, 1, 154, 3,
        154, 1900, 8, 154, 1, 154, 1, 154, 1, 154, 1, 155, 1, 155, 1, 155, 1, 155, 1, 155, 1, 155,
        3, 155, 1911, 8, 155, 3, 155, 1913, 8, 155, 1, 156, 1, 156, 1, 156, 5, 156, 1918, 8, 156,
        10, 156, 12, 156, 1921, 9, 156, 1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 3, 157, 1928, 8,
        157, 1, 158, 1, 158, 1, 158, 1, 158, 1, 158, 3, 158, 1935, 8, 158, 1, 159, 1, 159, 1, 160,
        1, 160, 1, 160, 3, 160, 1942, 8, 160, 1, 160, 1, 160, 3, 160, 1946, 8, 160, 1, 161, 1, 161,
        1, 161, 5, 161, 1951, 8, 161, 10, 161, 12, 161, 1954, 9, 161, 1, 162, 1, 162, 1, 162, 5,
        162, 1959, 8, 162, 10, 162, 12, 162, 1962, 9, 162, 1, 163, 1, 163, 1, 163, 5, 163, 1967, 8,
        163, 10, 163, 12, 163, 1970, 9, 163, 1, 164, 1, 164, 1, 164, 5, 164, 1975, 8, 164, 10, 164,
        12, 164, 1978, 9, 164, 1, 165, 1, 165, 1, 165, 5, 165, 1983, 8, 165, 10, 165, 12, 165, 1986,
        9, 165, 1, 166, 1, 166, 1, 166, 1, 166, 5, 166, 1992, 8, 166, 10, 166, 12, 166, 1995, 9,
        166, 1, 167, 1, 167, 1, 168, 1, 168, 1, 168, 1, 168, 5, 168, 2003, 8, 168, 10, 168, 12, 168,
        2006, 9, 168, 1, 169, 1, 169, 1, 170, 1, 170, 1, 170, 1, 170, 5, 170, 2014, 8, 170, 10, 170,
        12, 170, 2017, 9, 170, 1, 171, 1, 171, 1, 172, 1, 172, 1, 172, 1, 172, 5, 172, 2025, 8, 172,
        10, 172, 12, 172, 2028, 9, 172, 1, 173, 1, 173, 1, 174, 1, 174, 1, 174, 1, 174, 5, 174,
        2036, 8, 174, 10, 174, 12, 174, 2039, 9, 174, 1, 175, 1, 175, 1, 176, 3, 176, 2044, 8, 176,
        1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 3, 176, 2053, 8, 176, 1, 177, 1,
        177, 1, 177, 3, 177, 2058, 8, 177, 1, 178, 1, 178, 3, 178, 2062, 8, 178, 1, 179, 1, 179, 1,
        179, 1, 179, 1, 179, 1, 179, 1, 179, 3, 179, 2071, 8, 179, 1, 179, 1, 179, 1, 179, 1, 179,
        1, 179, 3, 179, 2078, 8, 179, 1, 180, 1, 180, 1, 181, 1, 181, 1, 181, 5, 181, 2085, 8, 181,
        10, 181, 12, 181, 2088, 9, 181, 1, 181, 1, 181, 1, 181, 1, 181, 5, 181, 2094, 8, 181, 10,
        181, 12, 181, 2097, 9, 181, 5, 181, 2099, 8, 181, 10, 181, 12, 181, 2102, 9, 181, 1, 182, 1,
        182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182,
        1, 182, 1, 182, 3, 182, 2119, 8, 182, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 3,
        183, 2127, 8, 183, 1, 183, 1, 183, 3, 183, 2131, 8, 183, 1, 184, 1, 184, 1, 184, 5, 184,
        2136, 8, 184, 10, 184, 12, 184, 2139, 9, 184, 1, 185, 1, 185, 3, 185, 2143, 8, 185, 1, 186,
        1, 186, 1, 186, 1, 186, 1, 186, 1, 187, 1, 187, 1, 187, 1, 187, 3, 187, 2154, 8, 187, 1,
        187, 1, 187, 3, 187, 2158, 8, 187, 1, 187, 1, 187, 1, 187, 1, 187, 1, 187, 1, 187, 1, 187,
        1, 187, 3, 187, 2168, 8, 187, 1, 188, 1, 188, 5, 188, 2172, 8, 188, 10, 188, 12, 188, 2175,
        9, 188, 1, 188, 4, 188, 2178, 8, 188, 11, 188, 12, 188, 2179, 1, 189, 1, 189, 1, 189, 0, 3,
        164, 174, 362, 190, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36,
        38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82,
        84, 86, 88, 90, 92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122,
        124, 126, 128, 130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158,
        160, 162, 164, 166, 168, 170, 172, 174, 176, 178, 180, 182, 184, 186, 188, 190, 192, 194,
        196, 198, 200, 202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222, 224, 226, 228, 230,
        232, 234, 236, 238, 240, 242, 244, 246, 248, 250, 252, 254, 256, 258, 260, 262, 264, 266,
        268, 270, 272, 274, 276, 278, 280, 282, 284, 286, 288, 290, 292, 294, 296, 298, 300, 302,
        304, 306, 308, 310, 312, 314, 316, 318, 320, 322, 324, 326, 328, 330, 332, 334, 336, 338,
        340, 342, 344, 346, 348, 350, 352, 354, 356, 358, 360, 362, 364, 366, 368, 370, 372, 374,
        376, 378, 0, 27, 2, 0, 72, 72, 77, 77, 1, 0, 92, 93, 3, 0, 70, 70, 73, 73, 75, 76, 2, 0, 27,
        27, 30, 30, 1, 0, 125, 126, 4, 0, 87, 87, 96, 96, 99, 99, 101, 101, 1, 0, 120, 123, 7, 0, 1,
        1, 12, 12, 20, 20, 26, 26, 29, 29, 41, 41, 118, 118, 5, 0, 17, 17, 88, 91, 95, 95, 100, 100,
        124, 124, 4, 0, 17, 17, 105, 105, 110, 110, 116, 116, 3, 0, 44, 45, 48, 49, 53, 54, 1, 0,
        112, 114, 8, 0, 4, 4, 9, 9, 13, 13, 18, 19, 23, 24, 31, 32, 35, 37, 112, 114, 2, 0, 103,
        105, 107, 109, 2, 0, 147, 148, 154, 154, 1, 0, 148, 148, 2, 0, 158, 158, 183, 192, 2, 0,
        167, 167, 170, 170, 2, 0, 161, 162, 168, 169, 1, 0, 159, 160, 1, 0, 175, 176, 2, 0, 177,
        178, 182, 182, 1, 0, 173, 174, 3, 0, 163, 164, 175, 177, 179, 179, 1, 0, 155, 156, 2, 0,
        207, 207, 209, 209, 7, 0, 42, 49, 53, 58, 83, 85, 92, 94, 124, 133, 138, 139, 146, 146,
        2370, 0, 383, 1, 0, 0, 0, 2, 398, 1, 0, 0, 0, 4, 400, 1, 0, 0, 0, 6, 405, 1, 0, 0, 0, 8,
        417, 1, 0, 0, 0, 10, 431, 1, 0, 0, 0, 12, 452, 1, 0, 0, 0, 14, 462, 1, 0, 0, 0, 16, 470, 1,
        0, 0, 0, 18, 482, 1, 0, 0, 0, 20, 486, 1, 0, 0, 0, 22, 488, 1, 0, 0, 0, 24, 491, 1, 0, 0, 0,
        26, 507, 1, 0, 0, 0, 28, 513, 1, 0, 0, 0, 30, 541, 1, 0, 0, 0, 32, 543, 1, 0, 0, 0, 34, 547,
        1, 0, 0, 0, 36, 558, 1, 0, 0, 0, 38, 565, 1, 0, 0, 0, 40, 573, 1, 0, 0, 0, 42, 588, 1, 0, 0,
        0, 44, 607, 1, 0, 0, 0, 46, 617, 1, 0, 0, 0, 48, 619, 1, 0, 0, 0, 50, 640, 1, 0, 0, 0, 52,
        642, 1, 0, 0, 0, 54, 649, 1, 0, 0, 0, 56, 653, 1, 0, 0, 0, 58, 656, 1, 0, 0, 0, 60, 660, 1,
        0, 0, 0, 62, 679, 1, 0, 0, 0, 64, 683, 1, 0, 0, 0, 66, 686, 1, 0, 0, 0, 68, 690, 1, 0, 0, 0,
        70, 716, 1, 0, 0, 0, 72, 719, 1, 0, 0, 0, 74, 739, 1, 0, 0, 0, 76, 741, 1, 0, 0, 0, 78, 753,
        1, 0, 0, 0, 80, 755, 1, 0, 0, 0, 82, 763, 1, 0, 0, 0, 84, 768, 1, 0, 0, 0, 86, 785, 1, 0, 0,
        0, 88, 789, 1, 0, 0, 0, 90, 809, 1, 0, 0, 0, 92, 811, 1, 0, 0, 0, 94, 842, 1, 0, 0, 0, 96,
        846, 1, 0, 0, 0, 98, 854, 1, 0, 0, 0, 100, 857, 1, 0, 0, 0, 102, 868, 1, 0, 0, 0, 104, 878,
        1, 0, 0, 0, 106, 892, 1, 0, 0, 0, 108, 894, 1, 0, 0, 0, 110, 899, 1, 0, 0, 0, 112, 904, 1,
        0, 0, 0, 114, 914, 1, 0, 0, 0, 116, 916, 1, 0, 0, 0, 118, 928, 1, 0, 0, 0, 120, 934, 1, 0,
        0, 0, 122, 940, 1, 0, 0, 0, 124, 943, 1, 0, 0, 0, 126, 946, 1, 0, 0, 0, 128, 950, 1, 0, 0,
        0, 130, 957, 1, 0, 0, 0, 132, 961, 1, 0, 0, 0, 134, 967, 1, 0, 0, 0, 136, 969, 1, 0, 0, 0,
        138, 975, 1, 0, 0, 0, 140, 987, 1, 0, 0, 0, 142, 989, 1, 0, 0, 0, 144, 996, 1, 0, 0, 0, 146,
        1009, 1, 0, 0, 0, 148, 1014, 1, 0, 0, 0, 150, 1030, 1, 0, 0, 0, 152, 1041, 1, 0, 0, 0, 154,
        1044, 1, 0, 0, 0, 156, 1055, 1, 0, 0, 0, 158, 1057, 1, 0, 0, 0, 160, 1065, 1, 0, 0, 0, 162,
        1071, 1, 0, 0, 0, 164, 1110, 1, 0, 0, 0, 166, 1159, 1, 0, 0, 0, 168, 1161, 1, 0, 0, 0, 170,
        1188, 1, 0, 0, 0, 172, 1201, 1, 0, 0, 0, 174, 1262, 1, 0, 0, 0, 176, 1320, 1, 0, 0, 0, 178,
        1322, 1, 0, 0, 0, 180, 1327, 1, 0, 0, 0, 182, 1335, 1, 0, 0, 0, 184, 1350, 1, 0, 0, 0, 186,
        1353, 1, 0, 0, 0, 188, 1357, 1, 0, 0, 0, 190, 1365, 1, 0, 0, 0, 192, 1371, 1, 0, 0, 0, 194,
        1385, 1, 0, 0, 0, 196, 1390, 1, 0, 0, 0, 198, 1420, 1, 0, 0, 0, 200, 1422, 1, 0, 0, 0, 202,
        1425, 1, 0, 0, 0, 204, 1449, 1, 0, 0, 0, 206, 1453, 1, 0, 0, 0, 208, 1489, 1, 0, 0, 0, 210,
        1491, 1, 0, 0, 0, 212, 1502, 1, 0, 0, 0, 214, 1507, 1, 0, 0, 0, 216, 1515, 1, 0, 0, 0, 218,
        1517, 1, 0, 0, 0, 220, 1519, 1, 0, 0, 0, 222, 1521, 1, 0, 0, 0, 224, 1523, 1, 0, 0, 0, 226,
        1530, 1, 0, 0, 0, 228, 1539, 1, 0, 0, 0, 230, 1541, 1, 0, 0, 0, 232, 1549, 1, 0, 0, 0, 234,
        1562, 1, 0, 0, 0, 236, 1564, 1, 0, 0, 0, 238, 1569, 1, 0, 0, 0, 240, 1571, 1, 0, 0, 0, 242,
        1574, 1, 0, 0, 0, 244, 1588, 1, 0, 0, 0, 246, 1592, 1, 0, 0, 0, 248, 1594, 1, 0, 0, 0, 250,
        1608, 1, 0, 0, 0, 252, 1610, 1, 0, 0, 0, 254, 1622, 1, 0, 0, 0, 256, 1624, 1, 0, 0, 0, 258,
        1632, 1, 0, 0, 0, 260, 1643, 1, 0, 0, 0, 262, 1651, 1, 0, 0, 0, 264, 1659, 1, 0, 0, 0, 266,
        1663, 1, 0, 0, 0, 268, 1670, 1, 0, 0, 0, 270, 1681, 1, 0, 0, 0, 272, 1697, 1, 0, 0, 0, 274,
        1717, 1, 0, 0, 0, 276, 1719, 1, 0, 0, 0, 278, 1730, 1, 0, 0, 0, 280, 1780, 1, 0, 0, 0, 282,
        1782, 1, 0, 0, 0, 284, 1786, 1, 0, 0, 0, 286, 1791, 1, 0, 0, 0, 288, 1811, 1, 0, 0, 0, 290,
        1813, 1, 0, 0, 0, 292, 1819, 1, 0, 0, 0, 294, 1829, 1, 0, 0, 0, 296, 1850, 1, 0, 0, 0, 298,
        1856, 1, 0, 0, 0, 300, 1858, 1, 0, 0, 0, 302, 1864, 1, 0, 0, 0, 304, 1872, 1, 0, 0, 0, 306,
        1892, 1, 0, 0, 0, 308, 1894, 1, 0, 0, 0, 310, 1912, 1, 0, 0, 0, 312, 1914, 1, 0, 0, 0, 314,
        1927, 1, 0, 0, 0, 316, 1934, 1, 0, 0, 0, 318, 1936, 1, 0, 0, 0, 320, 1938, 1, 0, 0, 0, 322,
        1947, 1, 0, 0, 0, 324, 1955, 1, 0, 0, 0, 326, 1963, 1, 0, 0, 0, 328, 1971, 1, 0, 0, 0, 330,
        1979, 1, 0, 0, 0, 332, 1987, 1, 0, 0, 0, 334, 1996, 1, 0, 0, 0, 336, 1998, 1, 0, 0, 0, 338,
        2007, 1, 0, 0, 0, 340, 2009, 1, 0, 0, 0, 342, 2018, 1, 0, 0, 0, 344, 2020, 1, 0, 0, 0, 346,
        2029, 1, 0, 0, 0, 348, 2031, 1, 0, 0, 0, 350, 2040, 1, 0, 0, 0, 352, 2052, 1, 0, 0, 0, 354,
        2057, 1, 0, 0, 0, 356, 2061, 1, 0, 0, 0, 358, 2077, 1, 0, 0, 0, 360, 2079, 1, 0, 0, 0, 362,
        2081, 1, 0, 0, 0, 364, 2118, 1, 0, 0, 0, 366, 2130, 1, 0, 0, 0, 368, 2132, 1, 0, 0, 0, 370,
        2142, 1, 0, 0, 0, 372, 2144, 1, 0, 0, 0, 374, 2167, 1, 0, 0, 0, 376, 2177, 1, 0, 0, 0, 378,
        2181, 1, 0, 0, 0, 380, 382, 3, 2, 1, 0, 381, 380, 1, 0, 0, 0, 382, 385, 1, 0, 0, 0, 383,
        381, 1, 0, 0, 0, 383, 384, 1, 0, 0, 0, 384, 386, 1, 0, 0, 0, 385, 383, 1, 0, 0, 0, 386, 387,
        5, 0, 0, 1, 387, 1, 1, 0, 0, 0, 388, 399, 3, 4, 2, 0, 389, 399, 3, 156, 78, 0, 390, 399, 3,
        6, 3, 0, 391, 399, 3, 12, 6, 0, 392, 399, 3, 10, 5, 0, 393, 399, 3, 16, 8, 0, 394, 399, 3,
        28, 14, 0, 395, 399, 3, 32, 16, 0, 396, 399, 3, 34, 17, 0, 397, 399, 3, 126, 63, 0, 398,
        388, 1, 0, 0, 0, 398, 389, 1, 0, 0, 0, 398, 390, 1, 0, 0, 0, 398, 391, 1, 0, 0, 0, 398, 392,
        1, 0, 0, 0, 398, 393, 1, 0, 0, 0, 398, 394, 1, 0, 0, 0, 398, 395, 1, 0, 0, 0, 398, 396, 1,
        0, 0, 0, 398, 397, 1, 0, 0, 0, 399, 3, 1, 0, 0, 0, 400, 401, 5, 69, 0, 0, 401, 402, 3, 378,
        189, 0, 402, 403, 5, 153, 0, 0, 403, 5, 1, 0, 0, 0, 404, 406, 5, 139, 0, 0, 405, 404, 1, 0,
        0, 0, 405, 406, 1, 0, 0, 0, 406, 407, 1, 0, 0, 0, 407, 408, 5, 68, 0, 0, 408, 410, 3, 8, 4,
        0, 409, 411, 3, 48, 24, 0, 410, 409, 1, 0, 0, 0, 410, 411, 1, 0, 0, 0, 411, 413, 1, 0, 0, 0,
        412, 414, 3, 54, 27, 0, 413, 412, 1, 0, 0, 0, 413, 414, 1, 0, 0, 0, 414, 415, 1, 0, 0, 0,
        415, 416, 5, 65, 0, 0, 416, 7, 1, 0, 0, 0, 417, 423, 3, 18, 9, 0, 418, 419, 5, 166, 0, 0,
        419, 421, 3, 20, 10, 0, 420, 422, 3, 24, 12, 0, 421, 420, 1, 0, 0, 0, 421, 422, 1, 0, 0, 0,
        422, 424, 1, 0, 0, 0, 423, 418, 1, 0, 0, 0, 423, 424, 1, 0, 0, 0, 424, 429, 1, 0, 0, 0, 425,
        426, 5, 162, 0, 0, 426, 427, 3, 38, 19, 0, 427, 428, 5, 161, 0, 0, 428, 430, 1, 0, 0, 0,
        429, 425, 1, 0, 0, 0, 429, 430, 1, 0, 0, 0, 430, 9, 1, 0, 0, 0, 431, 432, 5, 68, 0, 0, 432,
        433, 3, 18, 9, 0, 433, 435, 5, 147, 0, 0, 434, 436, 3, 378, 189, 0, 435, 434, 1, 0, 0, 0,
        435, 436, 1, 0, 0, 0, 436, 437, 1, 0, 0, 0, 437, 442, 5, 148, 0, 0, 438, 439, 5, 162, 0, 0,
        439, 440, 3, 38, 19, 0, 440, 441, 5, 161, 0, 0, 441, 443, 1, 0, 0, 0, 442, 438, 1, 0, 0, 0,
        442, 443, 1, 0, 0, 0, 443, 445, 1, 0, 0, 0, 444, 446, 3, 48, 24, 0, 445, 444, 1, 0, 0, 0,
        445, 446, 1, 0, 0, 0, 446, 448, 1, 0, 0, 0, 447, 449, 3, 54, 27, 0, 448, 447, 1, 0, 0, 0,
        448, 449, 1, 0, 0, 0, 449, 450, 1, 0, 0, 0, 450, 451, 5, 65, 0, 0, 451, 11, 1, 0, 0, 0, 452,
        453, 5, 67, 0, 0, 453, 455, 3, 14, 7, 0, 454, 456, 3, 48, 24, 0, 455, 454, 1, 0, 0, 0, 455,
        456, 1, 0, 0, 0, 456, 458, 1, 0, 0, 0, 457, 459, 3, 62, 31, 0, 458, 457, 1, 0, 0, 0, 458,
        459, 1, 0, 0, 0, 459, 460, 1, 0, 0, 0, 460, 461, 5, 65, 0, 0, 461, 13, 1, 0, 0, 0, 462, 468,
        3, 18, 9, 0, 463, 464, 5, 166, 0, 0, 464, 466, 3, 20, 10, 0, 465, 467, 3, 24, 12, 0, 466,
        465, 1, 0, 0, 0, 466, 467, 1, 0, 0, 0, 467, 469, 1, 0, 0, 0, 468, 463, 1, 0, 0, 0, 468, 469,
        1, 0, 0, 0, 469, 15, 1, 0, 0, 0, 470, 471, 5, 67, 0, 0, 471, 472, 3, 18, 9, 0, 472, 474, 5,
        147, 0, 0, 473, 475, 3, 378, 189, 0, 474, 473, 1, 0, 0, 0, 474, 475, 1, 0, 0, 0, 475, 476,
        1, 0, 0, 0, 476, 478, 5, 148, 0, 0, 477, 479, 3, 62, 31, 0, 478, 477, 1, 0, 0, 0, 478, 479,
        1, 0, 0, 0, 479, 480, 1, 0, 0, 0, 480, 481, 5, 65, 0, 0, 481, 17, 1, 0, 0, 0, 482, 484, 3,
        378, 189, 0, 483, 485, 3, 24, 12, 0, 484, 483, 1, 0, 0, 0, 484, 485, 1, 0, 0, 0, 485, 19, 1,
        0, 0, 0, 486, 487, 3, 378, 189, 0, 487, 21, 1, 0, 0, 0, 488, 489, 3, 378, 189, 0, 489, 490,
        3, 24, 12, 0, 490, 23, 1, 0, 0, 0, 491, 500, 5, 162, 0, 0, 492, 497, 3, 26, 13, 0, 493, 494,
        5, 154, 0, 0, 494, 496, 3, 26, 13, 0, 495, 493, 1, 0, 0, 0, 496, 499, 1, 0, 0, 0, 497, 495,
        1, 0, 0, 0, 497, 498, 1, 0, 0, 0, 498, 501, 1, 0, 0, 0, 499, 497, 1, 0, 0, 0, 500, 492, 1,
        0, 0, 0, 500, 501, 1, 0, 0, 0, 501, 502, 1, 0, 0, 0, 502, 503, 5, 161, 0, 0, 503, 25, 1, 0,
        0, 0, 504, 506, 3, 224, 112, 0, 505, 504, 1, 0, 0, 0, 506, 509, 1, 0, 0, 0, 507, 505, 1, 0,
        0, 0, 507, 508, 1, 0, 0, 0, 508, 510, 1, 0, 0, 0, 509, 507, 1, 0, 0, 0, 510, 511, 3, 234,
        117, 0, 511, 512, 3, 264, 132, 0, 512, 27, 1, 0, 0, 0, 513, 514, 5, 71, 0, 0, 514, 519, 3,
        46, 23, 0, 515, 516, 5, 162, 0, 0, 516, 517, 3, 38, 19, 0, 517, 518, 5, 161, 0, 0, 518, 520,
        1, 0, 0, 0, 519, 515, 1, 0, 0, 0, 519, 520, 1, 0, 0, 0, 520, 524, 1, 0, 0, 0, 521, 523, 3,
        30, 15, 0, 522, 521, 1, 0, 0, 0, 523, 526, 1, 0, 0, 0, 524, 522, 1, 0, 0, 0, 524, 525, 1, 0,
        0, 0, 525, 527, 1, 0, 0, 0, 526, 524, 1, 0, 0, 0, 527, 528, 5, 65, 0, 0, 528, 29, 1, 0, 0,
        0, 529, 533, 7, 0, 0, 0, 530, 532, 3, 54, 27, 0, 531, 530, 1, 0, 0, 0, 532, 535, 1, 0, 0, 0,
        533, 531, 1, 0, 0, 0, 533, 534, 1, 0, 0, 0, 534, 542, 1, 0, 0, 0, 535, 533, 1, 0, 0, 0, 536,
        538, 3, 54, 27, 0, 537, 536, 1, 0, 0, 0, 538, 539, 1, 0, 0, 0, 539, 537, 1, 0, 0, 0, 539,
        540, 1, 0, 0, 0, 540, 542, 1, 0, 0, 0, 541, 529, 1, 0, 0, 0, 541, 537, 1, 0, 0, 0, 542, 31,
        1, 0, 0, 0, 543, 544, 5, 71, 0, 0, 544, 545, 3, 38, 19, 0, 545, 546, 5, 153, 0, 0, 546, 33,
        1, 0, 0, 0, 547, 548, 5, 62, 0, 0, 548, 553, 3, 36, 18, 0, 549, 550, 5, 154, 0, 0, 550, 552,
        3, 36, 18, 0, 551, 549, 1, 0, 0, 0, 552, 555, 1, 0, 0, 0, 553, 551, 1, 0, 0, 0, 553, 554, 1,
        0, 0, 0, 554, 556, 1, 0, 0, 0, 555, 553, 1, 0, 0, 0, 556, 557, 5, 153, 0, 0, 557, 35, 1, 0,
        0, 0, 558, 563, 3, 18, 9, 0, 559, 560, 5, 162, 0, 0, 560, 561, 3, 38, 19, 0, 561, 562, 5,
        161, 0, 0, 562, 564, 1, 0, 0, 0, 563, 559, 1, 0, 0, 0, 563, 564, 1, 0, 0, 0, 564, 37, 1, 0,
        0, 0, 565, 570, 3, 46, 23, 0, 566, 567, 5, 154, 0, 0, 567, 569, 3, 46, 23, 0, 568, 566, 1,
        0, 0, 0, 569, 572, 1, 0, 0, 0, 570, 568, 1, 0, 0, 0, 570, 571, 1, 0, 0, 0, 571, 39, 1, 0, 0,
        0, 572, 570, 1, 0, 0, 0, 573, 578, 5, 74, 0, 0, 574, 575, 5, 147, 0, 0, 575, 576, 3, 42, 21,
        0, 576, 577, 5, 148, 0, 0, 577, 579, 1, 0, 0, 0, 578, 574, 1, 0, 0, 0, 578, 579, 1, 0, 0, 0,
        579, 581, 1, 0, 0, 0, 580, 582, 3, 216, 108, 0, 581, 580, 1, 0, 0, 0, 581, 582, 1, 0, 0, 0,
        582, 584, 1, 0, 0, 0, 583, 585, 5, 138, 0, 0, 584, 583, 1, 0, 0, 0, 584, 585, 1, 0, 0, 0,
        585, 586, 1, 0, 0, 0, 586, 587, 3, 196, 98, 0, 587, 41, 1, 0, 0, 0, 588, 593, 3, 44, 22, 0,
        589, 590, 5, 154, 0, 0, 590, 592, 3, 44, 22, 0, 591, 589, 1, 0, 0, 0, 592, 595, 1, 0, 0, 0,
        593, 591, 1, 0, 0, 0, 593, 594, 1, 0, 0, 0, 594, 43, 1, 0, 0, 0, 595, 593, 1, 0, 0, 0, 596,
        608, 5, 134, 0, 0, 597, 608, 5, 135, 0, 0, 598, 608, 5, 128, 0, 0, 599, 600, 5, 129, 0, 0,
        600, 601, 5, 158, 0, 0, 601, 608, 3, 106, 53, 0, 602, 603, 5, 130, 0, 0, 603, 604, 5, 158,
        0, 0, 604, 608, 3, 106, 53, 0, 605, 608, 3, 220, 110, 0, 606, 608, 3, 378, 189, 0, 607, 596,
        1, 0, 0, 0, 607, 597, 1, 0, 0, 0, 607, 598, 1, 0, 0, 0, 607, 599, 1, 0, 0, 0, 607, 602, 1,
        0, 0, 0, 607, 605, 1, 0, 0, 0, 607, 606, 1, 0, 0, 0, 608, 45, 1, 0, 0, 0, 609, 610, 5, 162,
        0, 0, 610, 611, 3, 38, 19, 0, 611, 612, 5, 161, 0, 0, 612, 618, 1, 0, 0, 0, 613, 615, 7, 1,
        0, 0, 614, 613, 1, 0, 0, 0, 614, 615, 1, 0, 0, 0, 615, 616, 1, 0, 0, 0, 616, 618, 3, 378,
        189, 0, 617, 609, 1, 0, 0, 0, 617, 614, 1, 0, 0, 0, 618, 47, 1, 0, 0, 0, 619, 623, 5, 149,
        0, 0, 620, 622, 3, 50, 25, 0, 621, 620, 1, 0, 0, 0, 622, 625, 1, 0, 0, 0, 623, 621, 1, 0, 0,
        0, 623, 624, 1, 0, 0, 0, 624, 626, 1, 0, 0, 0, 625, 623, 1, 0, 0, 0, 626, 627, 5, 150, 0, 0,
        627, 49, 1, 0, 0, 0, 628, 632, 3, 52, 26, 0, 629, 631, 3, 196, 98, 0, 630, 629, 1, 0, 0, 0,
        631, 634, 1, 0, 0, 0, 632, 630, 1, 0, 0, 0, 632, 633, 1, 0, 0, 0, 633, 641, 1, 0, 0, 0, 634,
        632, 1, 0, 0, 0, 635, 637, 3, 196, 98, 0, 636, 635, 1, 0, 0, 0, 637, 638, 1, 0, 0, 0, 638,
        636, 1, 0, 0, 0, 638, 639, 1, 0, 0, 0, 639, 641, 1, 0, 0, 0, 640, 628, 1, 0, 0, 0, 640, 636,
        1, 0, 0, 0, 641, 51, 1, 0, 0, 0, 642, 643, 7, 2, 0, 0, 643, 53, 1, 0, 0, 0, 644, 650, 3,
        156, 78, 0, 645, 650, 3, 56, 28, 0, 646, 650, 3, 58, 29, 0, 647, 650, 3, 40, 20, 0, 648,
        650, 3, 124, 62, 0, 649, 644, 1, 0, 0, 0, 649, 645, 1, 0, 0, 0, 649, 646, 1, 0, 0, 0, 649,
        647, 1, 0, 0, 0, 649, 648, 1, 0, 0, 0, 650, 651, 1, 0, 0, 0, 651, 649, 1, 0, 0, 0, 651, 652,
        1, 0, 0, 0, 652, 55, 1, 0, 0, 0, 653, 654, 5, 175, 0, 0, 654, 655, 3, 60, 30, 0, 655, 57, 1,
        0, 0, 0, 656, 657, 5, 176, 0, 0, 657, 658, 3, 60, 30, 0, 658, 59, 1, 0, 0, 0, 659, 661, 3,
        76, 38, 0, 660, 659, 1, 0, 0, 0, 660, 661, 1, 0, 0, 0, 661, 662, 1, 0, 0, 0, 662, 666, 3,
        70, 35, 0, 663, 665, 3, 192, 96, 0, 664, 663, 1, 0, 0, 0, 665, 668, 1, 0, 0, 0, 666, 664, 1,
        0, 0, 0, 666, 667, 1, 0, 0, 0, 667, 670, 1, 0, 0, 0, 668, 666, 1, 0, 0, 0, 669, 671, 3, 268,
        134, 0, 670, 669, 1, 0, 0, 0, 670, 671, 1, 0, 0, 0, 671, 672, 1, 0, 0, 0, 672, 673, 5, 153,
        0, 0, 673, 61, 1, 0, 0, 0, 674, 680, 3, 126, 63, 0, 675, 680, 3, 156, 78, 0, 676, 680, 3,
        64, 32, 0, 677, 680, 3, 66, 33, 0, 678, 680, 3, 78, 39, 0, 679, 674, 1, 0, 0, 0, 679, 675,
        1, 0, 0, 0, 679, 676, 1, 0, 0, 0, 679, 677, 1, 0, 0, 0, 679, 678, 1, 0, 0, 0, 680, 681, 1,
        0, 0, 0, 681, 679, 1, 0, 0, 0, 681, 682, 1, 0, 0, 0, 682, 63, 1, 0, 0, 0, 683, 684, 5, 175,
        0, 0, 684, 685, 3, 68, 34, 0, 685, 65, 1, 0, 0, 0, 686, 687, 5, 176, 0, 0, 687, 688, 3, 68,
        34, 0, 688, 67, 1, 0, 0, 0, 689, 691, 3, 76, 38, 0, 690, 689, 1, 0, 0, 0, 690, 691, 1, 0, 0,
        0, 691, 692, 1, 0, 0, 0, 692, 694, 3, 70, 35, 0, 693, 695, 3, 158, 79, 0, 694, 693, 1, 0, 0,
        0, 694, 695, 1, 0, 0, 0, 695, 697, 1, 0, 0, 0, 696, 698, 5, 153, 0, 0, 697, 696, 1, 0, 0, 0,
        697, 698, 1, 0, 0, 0, 698, 700, 1, 0, 0, 0, 699, 701, 3, 192, 96, 0, 700, 699, 1, 0, 0, 0,
        700, 701, 1, 0, 0, 0, 701, 702, 1, 0, 0, 0, 702, 704, 3, 286, 143, 0, 703, 705, 5, 153, 0,
        0, 704, 703, 1, 0, 0, 0, 704, 705, 1, 0, 0, 0, 705, 69, 1, 0, 0, 0, 706, 717, 3, 74, 37, 0,
        707, 709, 3, 72, 36, 0, 708, 707, 1, 0, 0, 0, 709, 710, 1, 0, 0, 0, 710, 708, 1, 0, 0, 0,
        710, 711, 1, 0, 0, 0, 711, 714, 1, 0, 0, 0, 712, 713, 5, 154, 0, 0, 713, 715, 5, 193, 0, 0,
        714, 712, 1, 0, 0, 0, 714, 715, 1, 0, 0, 0, 715, 717, 1, 0, 0, 0, 716, 706, 1, 0, 0, 0, 716,
        708, 1, 0, 0, 0, 717, 71, 1, 0, 0, 0, 718, 720, 3, 74, 37, 0, 719, 718, 1, 0, 0, 0, 719,
        720, 1, 0, 0, 0, 720, 721, 1, 0, 0, 0, 721, 725, 5, 166, 0, 0, 722, 724, 3, 76, 38, 0, 723,
        722, 1, 0, 0, 0, 724, 727, 1, 0, 0, 0, 725, 723, 1, 0, 0, 0, 725, 726, 1, 0, 0, 0, 726, 729,
        1, 0, 0, 0, 727, 725, 1, 0, 0, 0, 728, 730, 3, 218, 109, 0, 729, 728, 1, 0, 0, 0, 729, 730,
        1, 0, 0, 0, 730, 731, 1, 0, 0, 0, 731, 732, 3, 378, 189, 0, 732, 73, 1, 0, 0, 0, 733, 740,
        3, 378, 189, 0, 734, 740, 5, 22, 0, 0, 735, 740, 5, 28, 0, 0, 736, 740, 5, 16, 0, 0, 737,
        740, 5, 10, 0, 0, 738, 740, 5, 7, 0, 0, 739, 733, 1, 0, 0, 0, 739, 734, 1, 0, 0, 0, 739,
        735, 1, 0, 0, 0, 739, 736, 1, 0, 0, 0, 739, 737, 1, 0, 0, 0, 739, 738, 1, 0, 0, 0, 740, 75,
        1, 0, 0, 0, 741, 742, 5, 147, 0, 0, 742, 743, 3, 168, 84, 0, 743, 744, 5, 148, 0, 0, 744,
        77, 1, 0, 0, 0, 745, 746, 5, 80, 0, 0, 746, 747, 3, 80, 40, 0, 747, 748, 5, 153, 0, 0, 748,
        754, 1, 0, 0, 0, 749, 750, 5, 63, 0, 0, 750, 751, 3, 80, 40, 0, 751, 752, 5, 153, 0, 0, 752,
        754, 1, 0, 0, 0, 753, 745, 1, 0, 0, 0, 753, 749, 1, 0, 0, 0, 754, 79, 1, 0, 0, 0, 755, 760,
        3, 82, 41, 0, 756, 757, 5, 154, 0, 0, 757, 759, 3, 82, 41, 0, 758, 756, 1, 0, 0, 0, 759,
        762, 1, 0, 0, 0, 760, 758, 1, 0, 0, 0, 760, 761, 1, 0, 0, 0, 761, 81, 1, 0, 0, 0, 762, 760,
        1, 0, 0, 0, 763, 766, 3, 378, 189, 0, 764, 765, 5, 158, 0, 0, 765, 767, 3, 378, 189, 0, 766,
        764, 1, 0, 0, 0, 766, 767, 1, 0, 0, 0, 767, 83, 1, 0, 0, 0, 768, 769, 5, 157, 0, 0, 769,
        781, 5, 149, 0, 0, 770, 775, 3, 86, 43, 0, 771, 772, 5, 154, 0, 0, 772, 774, 3, 86, 43, 0,
        773, 771, 1, 0, 0, 0, 774, 777, 1, 0, 0, 0, 775, 773, 1, 0, 0, 0, 775, 776, 1, 0, 0, 0, 776,
        779, 1, 0, 0, 0, 777, 775, 1, 0, 0, 0, 778, 780, 5, 154, 0, 0, 779, 778, 1, 0, 0, 0, 779,
        780, 1, 0, 0, 0, 780, 782, 1, 0, 0, 0, 781, 770, 1, 0, 0, 0, 781, 782, 1, 0, 0, 0, 782, 783,
        1, 0, 0, 0, 783, 784, 5, 150, 0, 0, 784, 85, 1, 0, 0, 0, 785, 786, 3, 352, 176, 0, 786, 787,
        5, 166, 0, 0, 787, 788, 3, 314, 157, 0, 788, 87, 1, 0, 0, 0, 789, 790, 5, 157, 0, 0, 790,
        795, 5, 151, 0, 0, 791, 793, 3, 312, 156, 0, 792, 794, 5, 154, 0, 0, 793, 792, 1, 0, 0, 0,
        793, 794, 1, 0, 0, 0, 794, 796, 1, 0, 0, 0, 795, 791, 1, 0, 0, 0, 795, 796, 1, 0, 0, 0, 796,
        797, 1, 0, 0, 0, 797, 798, 5, 152, 0, 0, 798, 89, 1, 0, 0, 0, 799, 800, 5, 157, 0, 0, 800,
        801, 5, 147, 0, 0, 801, 802, 3, 314, 157, 0, 802, 803, 5, 148, 0, 0, 803, 810, 1, 0, 0, 0,
        804, 807, 5, 157, 0, 0, 805, 808, 3, 374, 187, 0, 806, 808, 3, 378, 189, 0, 807, 805, 1, 0,
        0, 0, 807, 806, 1, 0, 0, 0, 808, 810, 1, 0, 0, 0, 809, 799, 1, 0, 0, 0, 809, 804, 1, 0, 0,
        0, 810, 91, 1, 0, 0, 0, 811, 823, 5, 147, 0, 0, 812, 815, 3, 184, 92, 0, 813, 815, 5, 32, 0,
        0, 814, 812, 1, 0, 0, 0, 814, 813, 1, 0, 0, 0, 815, 820, 1, 0, 0, 0, 816, 817, 5, 154, 0, 0,
        817, 819, 3, 184, 92, 0, 818, 816, 1, 0, 0, 0, 819, 822, 1, 0, 0, 0, 820, 818, 1, 0, 0, 0,
        820, 821, 1, 0, 0, 0, 821, 824, 1, 0, 0, 0, 822, 820, 1, 0, 0, 0, 823, 814, 1, 0, 0, 0, 823,
        824, 1, 0, 0, 0, 824, 825, 1, 0, 0, 0, 825, 826, 5, 148, 0, 0, 826, 93, 1, 0, 0, 0, 827,
        828, 5, 181, 0, 0, 828, 843, 3, 286, 143, 0, 829, 830, 5, 181, 0, 0, 830, 831, 3, 168, 84,
        0, 831, 832, 3, 92, 46, 0, 832, 833, 3, 286, 143, 0, 833, 843, 1, 0, 0, 0, 834, 835, 5, 181,
        0, 0, 835, 836, 3, 168, 84, 0, 836, 837, 3, 286, 143, 0, 837, 843, 1, 0, 0, 0, 838, 839, 5,
        181, 0, 0, 839, 840, 3, 92, 46, 0, 840, 841, 3, 286, 143, 0, 841, 843, 1, 0, 0, 0, 842, 827,
        1, 0, 0, 0, 842, 829, 1, 0, 0, 0, 842, 834, 1, 0, 0, 0, 842, 838, 1, 0, 0, 0, 843, 95, 1, 0,
        0, 0, 844, 847, 3, 314, 157, 0, 845, 847, 3, 240, 120, 0, 846, 844, 1, 0, 0, 0, 846, 845, 1,
        0, 0, 0, 847, 97, 1, 0, 0, 0, 848, 855, 3, 74, 37, 0, 849, 851, 3, 100, 50, 0, 850, 849, 1,
        0, 0, 0, 851, 852, 1, 0, 0, 0, 852, 850, 1, 0, 0, 0, 852, 853, 1, 0, 0, 0, 853, 855, 1, 0,
        0, 0, 854, 848, 1, 0, 0, 0, 854, 850, 1, 0, 0, 0, 855, 99, 1, 0, 0, 0, 856, 858, 3, 74, 37,
        0, 857, 856, 1, 0, 0, 0, 857, 858, 1, 0, 0, 0, 858, 859, 1, 0, 0, 0, 859, 860, 5, 166, 0, 0,
        860, 865, 3, 102, 51, 0, 861, 862, 5, 154, 0, 0, 862, 864, 3, 102, 51, 0, 863, 861, 1, 0, 0,
        0, 864, 867, 1, 0, 0, 0, 865, 863, 1, 0, 0, 0, 865, 866, 1, 0, 0, 0, 866, 101, 1, 0, 0, 0,
        867, 865, 1, 0, 0, 0, 868, 870, 3, 312, 156, 0, 869, 871, 3, 220, 110, 0, 870, 869, 1, 0, 0,
        0, 870, 871, 1, 0, 0, 0, 871, 876, 1, 0, 0, 0, 872, 873, 5, 149, 0, 0, 873, 874, 3, 276,
        138, 0, 874, 875, 5, 150, 0, 0, 875, 877, 1, 0, 0, 0, 876, 872, 1, 0, 0, 0, 876, 877, 1, 0,
        0, 0, 877, 103, 1, 0, 0, 0, 878, 879, 5, 78, 0, 0, 879, 880, 5, 147, 0, 0, 880, 881, 3, 106,
        53, 0, 881, 882, 5, 148, 0, 0, 882, 105, 1, 0, 0, 0, 883, 893, 3, 74, 37, 0, 884, 886, 3,
        74, 37, 0, 885, 884, 1, 0, 0, 0, 885, 886, 1, 0, 0, 0, 886, 887, 1, 0, 0, 0, 887, 889, 5,
        166, 0, 0, 888, 885, 1, 0, 0, 0, 889, 890, 1, 0, 0, 0, 890, 888, 1, 0, 0, 0, 890, 891, 1, 0,
        0, 0, 891, 893, 1, 0, 0, 0, 892, 883, 1, 0, 0, 0, 892, 888, 1, 0, 0, 0, 893, 107, 1, 0, 0,
        0, 894, 895, 5, 71, 0, 0, 895, 896, 5, 147, 0, 0, 896, 897, 3, 46, 23, 0, 897, 898, 5, 148,
        0, 0, 898, 109, 1, 0, 0, 0, 899, 900, 5, 64, 0, 0, 900, 901, 5, 147, 0, 0, 901, 902, 3, 168,
        84, 0, 902, 903, 5, 148, 0, 0, 903, 111, 1, 0, 0, 0, 904, 905, 3, 154, 77, 0, 905, 906, 3,
        162, 81, 0, 906, 113, 1, 0, 0, 0, 907, 908, 5, 81, 0, 0, 908, 909, 5, 147, 0, 0, 909, 910,
        3, 378, 189, 0, 910, 911, 5, 148, 0, 0, 911, 915, 1, 0, 0, 0, 912, 913, 5, 81, 0, 0, 913,
        915, 3, 314, 157, 0, 914, 907, 1, 0, 0, 0, 914, 912, 1, 0, 0, 0, 915, 115, 1, 0, 0, 0, 916,
        917, 5, 82, 0, 0, 917, 921, 3, 286, 143, 0, 918, 920, 3, 118, 59, 0, 919, 918, 1, 0, 0, 0,
        920, 923, 1, 0, 0, 0, 921, 919, 1, 0, 0, 0, 921, 922, 1, 0, 0, 0, 922, 926, 1, 0, 0, 0, 923,
        921, 1, 0, 0, 0, 924, 925, 5, 66, 0, 0, 925, 927, 3, 286, 143, 0, 926, 924, 1, 0, 0, 0, 926,
        927, 1, 0, 0, 0, 927, 117, 1, 0, 0, 0, 928, 929, 5, 61, 0, 0, 929, 930, 5, 147, 0, 0, 930,
        931, 3, 112, 56, 0, 931, 932, 5, 148, 0, 0, 932, 933, 3, 286, 143, 0, 933, 119, 1, 0, 0, 0,
        934, 935, 5, 79, 0, 0, 935, 936, 5, 147, 0, 0, 936, 937, 3, 314, 157, 0, 937, 938, 5, 148,
        0, 0, 938, 939, 3, 286, 143, 0, 939, 121, 1, 0, 0, 0, 940, 941, 5, 60, 0, 0, 941, 942, 3,
        286, 143, 0, 942, 123, 1, 0, 0, 0, 943, 944, 3, 128, 64, 0, 944, 945, 5, 153, 0, 0, 945,
        125, 1, 0, 0, 0, 946, 947, 3, 128, 64, 0, 947, 948, 3, 286, 143, 0, 948, 127, 1, 0, 0, 0,
        949, 951, 3, 154, 77, 0, 950, 949, 1, 0, 0, 0, 950, 951, 1, 0, 0, 0, 951, 952, 1, 0, 0, 0,
        952, 954, 3, 162, 81, 0, 953, 955, 3, 130, 65, 0, 954, 953, 1, 0, 0, 0, 954, 955, 1, 0, 0,
        0, 955, 129, 1, 0, 0, 0, 956, 958, 3, 156, 78, 0, 957, 956, 1, 0, 0, 0, 958, 959, 1, 0, 0,
        0, 959, 957, 1, 0, 0, 0, 959, 960, 1, 0, 0, 0, 960, 131, 1, 0, 0, 0, 961, 963, 3, 134, 67,
        0, 962, 964, 3, 136, 68, 0, 963, 962, 1, 0, 0, 0, 963, 964, 1, 0, 0, 0, 964, 133, 1, 0, 0,
        0, 965, 968, 5, 5, 0, 0, 966, 968, 3, 378, 189, 0, 967, 965, 1, 0, 0, 0, 967, 966, 1, 0, 0,
        0, 968, 135, 1, 0, 0, 0, 969, 971, 5, 147, 0, 0, 970, 972, 3, 138, 69, 0, 971, 970, 1, 0, 0,
        0, 971, 972, 1, 0, 0, 0, 972, 973, 1, 0, 0, 0, 973, 974, 5, 148, 0, 0, 974, 137, 1, 0, 0, 0,
        975, 980, 3, 140, 70, 0, 976, 977, 5, 154, 0, 0, 977, 979, 3, 140, 70, 0, 978, 976, 1, 0, 0,
        0, 979, 982, 1, 0, 0, 0, 980, 978, 1, 0, 0, 0, 980, 981, 1, 0, 0, 0, 981, 139, 1, 0, 0, 0,
        982, 980, 1, 0, 0, 0, 983, 988, 3, 132, 66, 0, 984, 988, 3, 374, 187, 0, 985, 988, 3, 376,
        188, 0, 986, 988, 3, 142, 71, 0, 987, 983, 1, 0, 0, 0, 987, 984, 1, 0, 0, 0, 987, 985, 1, 0,
        0, 0, 987, 986, 1, 0, 0, 0, 988, 141, 1, 0, 0, 0, 989, 990, 3, 134, 67, 0, 990, 994, 5, 158,
        0, 0, 991, 995, 3, 374, 187, 0, 992, 995, 3, 134, 67, 0, 993, 995, 3, 376, 188, 0, 994, 991,
        1, 0, 0, 0, 994, 992, 1, 0, 0, 0, 994, 993, 1, 0, 0, 0, 995, 143, 1, 0, 0, 0, 996, 997, 3,
        154, 77, 0, 997, 998, 5, 147, 0, 0, 998, 1000, 5, 177, 0, 0, 999, 1001, 3, 378, 189, 0,
        1000, 999, 1, 0, 0, 0, 1000, 1001, 1, 0, 0, 0, 1001, 1002, 1, 0, 0, 0, 1002, 1003, 5, 148,
        0, 0, 1003, 1005, 5, 147, 0, 0, 1004, 1006, 3, 146, 73, 0, 1005, 1004, 1, 0, 0, 0, 1005,
        1006, 1, 0, 0, 0, 1006, 1007, 1, 0, 0, 0, 1007, 1008, 5, 148, 0, 0, 1008, 145, 1, 0, 0, 0,
        1009, 1012, 3, 148, 74, 0, 1010, 1011, 5, 154, 0, 0, 1011, 1013, 5, 193, 0, 0, 1012, 1010,
        1, 0, 0, 0, 1012, 1013, 1, 0, 0, 0, 1013, 147, 1, 0, 0, 0, 1014, 1019, 3, 150, 75, 0, 1015,
        1016, 5, 154, 0, 0, 1016, 1018, 3, 150, 75, 0, 1017, 1015, 1, 0, 0, 0, 1018, 1021, 1, 0, 0,
        0, 1019, 1017, 1, 0, 0, 0, 1019, 1020, 1, 0, 0, 0, 1020, 149, 1, 0, 0, 0, 1021, 1019, 1, 0,
        0, 0, 1022, 1025, 3, 154, 77, 0, 1023, 1025, 3, 144, 72, 0, 1024, 1022, 1, 0, 0, 0, 1024,
        1023, 1, 0, 0, 0, 1025, 1027, 1, 0, 0, 0, 1026, 1028, 3, 162, 81, 0, 1027, 1026, 1, 0, 0, 0,
        1027, 1028, 1, 0, 0, 0, 1028, 1031, 1, 0, 0, 0, 1029, 1031, 5, 32, 0, 0, 1030, 1024, 1, 0,
        0, 0, 1030, 1029, 1, 0, 0, 0, 1031, 151, 1, 0, 0, 0, 1032, 1042, 3, 222, 111, 0, 1033, 1042,
        3, 234, 117, 0, 1034, 1042, 3, 226, 113, 0, 1035, 1042, 3, 228, 114, 0, 1036, 1042, 3, 230,
        115, 0, 1037, 1042, 3, 218, 109, 0, 1038, 1042, 3, 220, 110, 0, 1039, 1042, 3, 216, 108, 0,
        1040, 1042, 3, 224, 112, 0, 1041, 1032, 1, 0, 0, 0, 1041, 1033, 1, 0, 0, 0, 1041, 1034, 1,
        0, 0, 0, 1041, 1035, 1, 0, 0, 0, 1041, 1036, 1, 0, 0, 0, 1041, 1037, 1, 0, 0, 0, 1041, 1038,
        1, 0, 0, 0, 1041, 1039, 1, 0, 0, 0, 1041, 1040, 1, 0, 0, 0, 1042, 153, 1, 0, 0, 0, 1043,
        1045, 3, 152, 76, 0, 1044, 1043, 1, 0, 0, 0, 1045, 1046, 1, 0, 0, 0, 1046, 1044, 1, 0, 0, 0,
        1046, 1047, 1, 0, 0, 0, 1047, 155, 1, 0, 0, 0, 1048, 1050, 3, 154, 77, 0, 1049, 1051, 3,
        158, 79, 0, 1050, 1049, 1, 0, 0, 0, 1050, 1051, 1, 0, 0, 0, 1051, 1052, 1, 0, 0, 0, 1052,
        1053, 5, 153, 0, 0, 1053, 1056, 1, 0, 0, 0, 1054, 1056, 3, 278, 139, 0, 1055, 1048, 1, 0, 0,
        0, 1055, 1054, 1, 0, 0, 0, 1056, 157, 1, 0, 0, 0, 1057, 1062, 3, 160, 80, 0, 1058, 1059, 5,
        154, 0, 0, 1059, 1061, 3, 160, 80, 0, 1060, 1058, 1, 0, 0, 0, 1061, 1064, 1, 0, 0, 0, 1062,
        1060, 1, 0, 0, 0, 1062, 1063, 1, 0, 0, 0, 1063, 159, 1, 0, 0, 0, 1064, 1062, 1, 0, 0, 0,
        1065, 1068, 3, 162, 81, 0, 1066, 1067, 5, 158, 0, 0, 1067, 1069, 3, 354, 177, 0, 1068, 1066,
        1, 0, 0, 0, 1068, 1069, 1, 0, 0, 0, 1069, 161, 1, 0, 0, 0, 1070, 1072, 3, 264, 132, 0, 1071,
        1070, 1, 0, 0, 0, 1071, 1072, 1, 0, 0, 0, 1072, 1073, 1, 0, 0, 0, 1073, 1077, 3, 164, 82, 0,
        1074, 1076, 3, 254, 127, 0, 1075, 1074, 1, 0, 0, 0, 1076, 1079, 1, 0, 0, 0, 1077, 1075, 1,
        0, 0, 0, 1077, 1078, 1, 0, 0, 0, 1078, 163, 1, 0, 0, 0, 1079, 1077, 1, 0, 0, 0, 1080, 1081,
        6, 82, -1, 0, 1081, 1111, 3, 378, 189, 0, 1082, 1083, 5, 147, 0, 0, 1083, 1084, 3, 162, 81,
        0, 1084, 1085, 5, 148, 0, 0, 1085, 1111, 1, 0, 0, 0, 1086, 1087, 5, 147, 0, 0, 1087, 1091,
        5, 181, 0, 0, 1088, 1090, 3, 166, 83, 0, 1089, 1088, 1, 0, 0, 0, 1090, 1093, 1, 0, 0, 0,
        1091, 1089, 1, 0, 0, 0, 1091, 1092, 1, 0, 0, 0, 1092, 1094, 1, 0, 0, 0, 1093, 1091, 1, 0, 0,
        0, 1094, 1095, 3, 164, 82, 0, 1095, 1096, 5, 148, 0, 0, 1096, 1097, 3, 92, 46, 0, 1097,
        1111, 1, 0, 0, 0, 1098, 1099, 3, 378, 189, 0, 1099, 1100, 5, 166, 0, 0, 1100, 1101, 5, 200,
        0, 0, 1101, 1111, 1, 0, 0, 0, 1102, 1103, 3, 252, 126, 0, 1103, 1104, 3, 378, 189, 0, 1104,
        1111, 1, 0, 0, 0, 1105, 1106, 5, 147, 0, 0, 1106, 1107, 3, 252, 126, 0, 1107, 1108, 3, 162,
        81, 0, 1108, 1109, 5, 148, 0, 0, 1109, 1111, 1, 0, 0, 0, 1110, 1080, 1, 0, 0, 0, 1110, 1082,
        1, 0, 0, 0, 1110, 1086, 1, 0, 0, 0, 1110, 1098, 1, 0, 0, 0, 1110, 1102, 1, 0, 0, 0, 1110,
        1105, 1, 0, 0, 0, 1111, 1152, 1, 0, 0, 0, 1112, 1113, 10, 9, 0, 0, 1113, 1115, 5, 151, 0, 0,
        1114, 1116, 3, 186, 93, 0, 1115, 1114, 1, 0, 0, 0, 1115, 1116, 1, 0, 0, 0, 1116, 1118, 1, 0,
        0, 0, 1117, 1119, 3, 314, 157, 0, 1118, 1117, 1, 0, 0, 0, 1118, 1119, 1, 0, 0, 0, 1119,
        1120, 1, 0, 0, 0, 1120, 1151, 5, 152, 0, 0, 1121, 1122, 10, 8, 0, 0, 1122, 1123, 5, 151, 0,
        0, 1123, 1125, 5, 26, 0, 0, 1124, 1126, 3, 186, 93, 0, 1125, 1124, 1, 0, 0, 0, 1125, 1126,
        1, 0, 0, 0, 1126, 1127, 1, 0, 0, 0, 1127, 1128, 3, 314, 157, 0, 1128, 1129, 5, 152, 0, 0,
        1129, 1151, 1, 0, 0, 0, 1130, 1131, 10, 7, 0, 0, 1131, 1132, 5, 151, 0, 0, 1132, 1133, 3,
        186, 93, 0, 1133, 1134, 5, 26, 0, 0, 1134, 1135, 3, 314, 157, 0, 1135, 1136, 5, 152, 0, 0,
        1136, 1151, 1, 0, 0, 0, 1137, 1138, 10, 6, 0, 0, 1138, 1140, 5, 151, 0, 0, 1139, 1141, 3,
        186, 93, 0, 1140, 1139, 1, 0, 0, 0, 1140, 1141, 1, 0, 0, 0, 1141, 1142, 1, 0, 0, 0, 1142,
        1143, 5, 177, 0, 0, 1143, 1151, 5, 152, 0, 0, 1144, 1145, 10, 5, 0, 0, 1145, 1147, 5, 147,
        0, 0, 1146, 1148, 3, 178, 89, 0, 1147, 1146, 1, 0, 0, 0, 1147, 1148, 1, 0, 0, 0, 1148, 1149,
        1, 0, 0, 0, 1149, 1151, 5, 148, 0, 0, 1150, 1112, 1, 0, 0, 0, 1150, 1121, 1, 0, 0, 0, 1150,
        1130, 1, 0, 0, 0, 1150, 1137, 1, 0, 0, 0, 1150, 1144, 1, 0, 0, 0, 1151, 1154, 1, 0, 0, 0,
        1152, 1150, 1, 0, 0, 0, 1152, 1153, 1, 0, 0, 0, 1153, 165, 1, 0, 0, 0, 1154, 1152, 1, 0, 0,
        0, 1155, 1160, 3, 220, 110, 0, 1156, 1160, 3, 218, 109, 0, 1157, 1160, 3, 226, 113, 0, 1158,
        1160, 3, 224, 112, 0, 1159, 1155, 1, 0, 0, 0, 1159, 1156, 1, 0, 0, 0, 1159, 1157, 1, 0, 0,
        0, 1159, 1158, 1, 0, 0, 0, 1160, 167, 1, 0, 0, 0, 1161, 1163, 3, 154, 77, 0, 1162, 1164, 3,
        172, 86, 0, 1163, 1162, 1, 0, 0, 0, 1163, 1164, 1, 0, 0, 0, 1164, 169, 1, 0, 0, 0, 1165,
        1167, 3, 264, 132, 0, 1166, 1168, 3, 170, 85, 0, 1167, 1166, 1, 0, 0, 0, 1167, 1168, 1, 0,
        0, 0, 1168, 1189, 1, 0, 0, 0, 1169, 1171, 5, 147, 0, 0, 1170, 1172, 3, 172, 86, 0, 1171,
        1170, 1, 0, 0, 0, 1171, 1172, 1, 0, 0, 0, 1172, 1173, 1, 0, 0, 0, 1173, 1175, 5, 148, 0, 0,
        1174, 1176, 3, 176, 88, 0, 1175, 1174, 1, 0, 0, 0, 1176, 1177, 1, 0, 0, 0, 1177, 1175, 1, 0,
        0, 0, 1177, 1178, 1, 0, 0, 0, 1178, 1189, 1, 0, 0, 0, 1179, 1181, 5, 151, 0, 0, 1180, 1182,
        3, 356, 178, 0, 1181, 1180, 1, 0, 0, 0, 1181, 1182, 1, 0, 0, 0, 1182, 1183, 1, 0, 0, 0,
        1183, 1185, 5, 152, 0, 0, 1184, 1179, 1, 0, 0, 0, 1185, 1186, 1, 0, 0, 0, 1186, 1184, 1, 0,
        0, 0, 1186, 1187, 1, 0, 0, 0, 1187, 1189, 1, 0, 0, 0, 1188, 1165, 1, 0, 0, 0, 1188, 1169, 1,
        0, 0, 0, 1188, 1184, 1, 0, 0, 0, 1189, 171, 1, 0, 0, 0, 1190, 1202, 3, 264, 132, 0, 1191,
        1193, 3, 264, 132, 0, 1192, 1191, 1, 0, 0, 0, 1192, 1193, 1, 0, 0, 0, 1193, 1194, 1, 0, 0,
        0, 1194, 1198, 3, 174, 87, 0, 1195, 1197, 3, 254, 127, 0, 1196, 1195, 1, 0, 0, 0, 1197,
        1200, 1, 0, 0, 0, 1198, 1196, 1, 0, 0, 0, 1198, 1199, 1, 0, 0, 0, 1199, 1202, 1, 0, 0, 0,
        1200, 1198, 1, 0, 0, 0, 1201, 1190, 1, 0, 0, 0, 1201, 1192, 1, 0, 0, 0, 1202, 173, 1, 0, 0,
        0, 1203, 1204, 6, 87, -1, 0, 1204, 1205, 5, 147, 0, 0, 1205, 1206, 3, 172, 86, 0, 1206,
        1210, 5, 148, 0, 0, 1207, 1209, 3, 254, 127, 0, 1208, 1207, 1, 0, 0, 0, 1209, 1212, 1, 0, 0,
        0, 1210, 1208, 1, 0, 0, 0, 1210, 1211, 1, 0, 0, 0, 1211, 1263, 1, 0, 0, 0, 1212, 1210, 1, 0,
        0, 0, 1213, 1215, 5, 151, 0, 0, 1214, 1216, 3, 186, 93, 0, 1215, 1214, 1, 0, 0, 0, 1215,
        1216, 1, 0, 0, 0, 1216, 1218, 1, 0, 0, 0, 1217, 1219, 3, 314, 157, 0, 1218, 1217, 1, 0, 0,
        0, 1218, 1219, 1, 0, 0, 0, 1219, 1220, 1, 0, 0, 0, 1220, 1263, 5, 152, 0, 0, 1221, 1222, 5,
        151, 0, 0, 1222, 1224, 5, 26, 0, 0, 1223, 1225, 3, 186, 93, 0, 1224, 1223, 1, 0, 0, 0, 1224,
        1225, 1, 0, 0, 0, 1225, 1226, 1, 0, 0, 0, 1226, 1227, 3, 314, 157, 0, 1227, 1228, 5, 152, 0,
        0, 1228, 1263, 1, 0, 0, 0, 1229, 1230, 5, 151, 0, 0, 1230, 1231, 3, 186, 93, 0, 1231, 1232,
        5, 26, 0, 0, 1232, 1233, 3, 314, 157, 0, 1233, 1234, 5, 152, 0, 0, 1234, 1263, 1, 0, 0, 0,
        1235, 1236, 5, 151, 0, 0, 1236, 1237, 5, 177, 0, 0, 1237, 1263, 5, 152, 0, 0, 1238, 1240, 5,
        147, 0, 0, 1239, 1241, 3, 178, 89, 0, 1240, 1239, 1, 0, 0, 0, 1240, 1241, 1, 0, 0, 0, 1241,
        1242, 1, 0, 0, 0, 1242, 1246, 5, 148, 0, 0, 1243, 1245, 3, 254, 127, 0, 1244, 1243, 1, 0, 0,
        0, 1245, 1248, 1, 0, 0, 0, 1246, 1244, 1, 0, 0, 0, 1246, 1247, 1, 0, 0, 0, 1247, 1263, 1, 0,
        0, 0, 1248, 1246, 1, 0, 0, 0, 1249, 1250, 5, 147, 0, 0, 1250, 1254, 5, 181, 0, 0, 1251,
        1253, 3, 166, 83, 0, 1252, 1251, 1, 0, 0, 0, 1253, 1256, 1, 0, 0, 0, 1254, 1252, 1, 0, 0, 0,
        1254, 1255, 1, 0, 0, 0, 1255, 1258, 1, 0, 0, 0, 1256, 1254, 1, 0, 0, 0, 1257, 1259, 3, 378,
        189, 0, 1258, 1257, 1, 0, 0, 0, 1258, 1259, 1, 0, 0, 0, 1259, 1260, 1, 0, 0, 0, 1260, 1261,
        5, 148, 0, 0, 1261, 1263, 3, 92, 46, 0, 1262, 1203, 1, 0, 0, 0, 1262, 1213, 1, 0, 0, 0,
        1262, 1221, 1, 0, 0, 0, 1262, 1229, 1, 0, 0, 0, 1262, 1235, 1, 0, 0, 0, 1262, 1238, 1, 0, 0,
        0, 1262, 1249, 1, 0, 0, 0, 1263, 1307, 1, 0, 0, 0, 1264, 1265, 10, 6, 0, 0, 1265, 1267, 5,
        151, 0, 0, 1266, 1268, 3, 186, 93, 0, 1267, 1266, 1, 0, 0, 0, 1267, 1268, 1, 0, 0, 0, 1268,
        1270, 1, 0, 0, 0, 1269, 1271, 3, 314, 157, 0, 1270, 1269, 1, 0, 0, 0, 1270, 1271, 1, 0, 0,
        0, 1271, 1272, 1, 0, 0, 0, 1272, 1306, 5, 152, 0, 0, 1273, 1274, 10, 5, 0, 0, 1274, 1275, 5,
        151, 0, 0, 1275, 1277, 5, 26, 0, 0, 1276, 1278, 3, 186, 93, 0, 1277, 1276, 1, 0, 0, 0, 1277,
        1278, 1, 0, 0, 0, 1278, 1279, 1, 0, 0, 0, 1279, 1280, 3, 314, 157, 0, 1280, 1281, 5, 152, 0,
        0, 1281, 1306, 1, 0, 0, 0, 1282, 1283, 10, 4, 0, 0, 1283, 1284, 5, 151, 0, 0, 1284, 1285, 3,
        186, 93, 0, 1285, 1286, 5, 26, 0, 0, 1286, 1287, 3, 314, 157, 0, 1287, 1288, 5, 152, 0, 0,
        1288, 1306, 1, 0, 0, 0, 1289, 1290, 10, 3, 0, 0, 1290, 1291, 5, 151, 0, 0, 1291, 1292, 5,
        177, 0, 0, 1292, 1306, 5, 152, 0, 0, 1293, 1294, 10, 2, 0, 0, 1294, 1296, 5, 147, 0, 0,
        1295, 1297, 3, 178, 89, 0, 1296, 1295, 1, 0, 0, 0, 1296, 1297, 1, 0, 0, 0, 1297, 1298, 1, 0,
        0, 0, 1298, 1302, 5, 148, 0, 0, 1299, 1301, 3, 254, 127, 0, 1300, 1299, 1, 0, 0, 0, 1301,
        1304, 1, 0, 0, 0, 1302, 1300, 1, 0, 0, 0, 1302, 1303, 1, 0, 0, 0, 1303, 1306, 1, 0, 0, 0,
        1304, 1302, 1, 0, 0, 0, 1305, 1264, 1, 0, 0, 0, 1305, 1273, 1, 0, 0, 0, 1305, 1282, 1, 0, 0,
        0, 1305, 1289, 1, 0, 0, 0, 1305, 1293, 1, 0, 0, 0, 1306, 1309, 1, 0, 0, 0, 1307, 1305, 1, 0,
        0, 0, 1307, 1308, 1, 0, 0, 0, 1308, 175, 1, 0, 0, 0, 1309, 1307, 1, 0, 0, 0, 1310, 1312, 5,
        151, 0, 0, 1311, 1313, 3, 356, 178, 0, 1312, 1311, 1, 0, 0, 0, 1312, 1313, 1, 0, 0, 0, 1313,
        1314, 1, 0, 0, 0, 1314, 1321, 5, 152, 0, 0, 1315, 1317, 5, 147, 0, 0, 1316, 1318, 3, 182,
        91, 0, 1317, 1316, 1, 0, 0, 0, 1317, 1318, 1, 0, 0, 0, 1318, 1319, 1, 0, 0, 0, 1319, 1321,
        5, 148, 0, 0, 1320, 1310, 1, 0, 0, 0, 1320, 1315, 1, 0, 0, 0, 1321, 177, 1, 0, 0, 0, 1322,
        1325, 3, 180, 90, 0, 1323, 1324, 5, 154, 0, 0, 1324, 1326, 5, 193, 0, 0, 1325, 1323, 1, 0,
        0, 0, 1325, 1326, 1, 0, 0, 0, 1326, 179, 1, 0, 0, 0, 1327, 1332, 3, 184, 92, 0, 1328, 1329,
        5, 154, 0, 0, 1329, 1331, 3, 184, 92, 0, 1330, 1328, 1, 0, 0, 0, 1331, 1334, 1, 0, 0, 0,
        1332, 1330, 1, 0, 0, 0, 1332, 1333, 1, 0, 0, 0, 1333, 181, 1, 0, 0, 0, 1334, 1332, 1, 0, 0,
        0, 1335, 1340, 3, 184, 92, 0, 1336, 1337, 5, 154, 0, 0, 1337, 1339, 3, 184, 92, 0, 1338,
        1336, 1, 0, 0, 0, 1339, 1342, 1, 0, 0, 0, 1340, 1338, 1, 0, 0, 0, 1340, 1341, 1, 0, 0, 0,
        1341, 183, 1, 0, 0, 0, 1342, 1340, 1, 0, 0, 0, 1343, 1344, 3, 154, 77, 0, 1344, 1345, 3,
        162, 81, 0, 1345, 1351, 1, 0, 0, 0, 1346, 1348, 3, 154, 77, 0, 1347, 1349, 3, 172, 86, 0,
        1348, 1347, 1, 0, 0, 0, 1348, 1349, 1, 0, 0, 0, 1349, 1351, 1, 0, 0, 0, 1350, 1343, 1, 0, 0,
        0, 1350, 1346, 1, 0, 0, 0, 1351, 185, 1, 0, 0, 0, 1352, 1354, 3, 226, 113, 0, 1353, 1352, 1,
        0, 0, 0, 1354, 1355, 1, 0, 0, 0, 1355, 1353, 1, 0, 0, 0, 1355, 1356, 1, 0, 0, 0, 1356, 187,
        1, 0, 0, 0, 1357, 1362, 3, 378, 189, 0, 1358, 1359, 5, 154, 0, 0, 1359, 1361, 3, 378, 189,
        0, 1360, 1358, 1, 0, 0, 0, 1361, 1364, 1, 0, 0, 0, 1362, 1360, 1, 0, 0, 0, 1362, 1363, 1, 0,
        0, 0, 1363, 189, 1, 0, 0, 0, 1364, 1362, 1, 0, 0, 0, 1365, 1367, 5, 151, 0, 0, 1366, 1368,
        3, 356, 178, 0, 1367, 1366, 1, 0, 0, 0, 1367, 1368, 1, 0, 0, 0, 1368, 1369, 1, 0, 0, 0,
        1369, 1370, 5, 152, 0, 0, 1370, 191, 1, 0, 0, 0, 1371, 1372, 5, 86, 0, 0, 1372, 1373, 5,
        147, 0, 0, 1373, 1374, 5, 147, 0, 0, 1374, 1379, 3, 132, 66, 0, 1375, 1376, 5, 154, 0, 0,
        1376, 1378, 3, 132, 66, 0, 1377, 1375, 1, 0, 0, 0, 1378, 1381, 1, 0, 0, 0, 1379, 1377, 1, 0,
        0, 0, 1379, 1380, 1, 0, 0, 0, 1380, 1382, 1, 0, 0, 0, 1381, 1379, 1, 0, 0, 0, 1382, 1383, 5,
        148, 0, 0, 1383, 1384, 5, 148, 0, 0, 1384, 193, 1, 0, 0, 0, 1385, 1386, 5, 115, 0, 0, 1386,
        1387, 5, 147, 0, 0, 1387, 1388, 3, 168, 84, 0, 1388, 1389, 5, 148, 0, 0, 1389, 195, 1, 0, 0,
        0, 1390, 1391, 3, 154, 77, 0, 1391, 1393, 3, 248, 124, 0, 1392, 1394, 3, 268, 134, 0, 1393,
        1392, 1, 0, 0, 0, 1393, 1394, 1, 0, 0, 0, 1394, 1395, 1, 0, 0, 0, 1395, 1396, 5, 153, 0, 0,
        1396, 197, 1, 0, 0, 0, 1397, 1401, 3, 200, 100, 0, 1398, 1400, 3, 192, 96, 0, 1399, 1398, 1,
        0, 0, 0, 1400, 1403, 1, 0, 0, 0, 1401, 1399, 1, 0, 0, 0, 1401, 1402, 1, 0, 0, 0, 1402, 1405,
        1, 0, 0, 0, 1403, 1401, 1, 0, 0, 0, 1404, 1406, 3, 378, 189, 0, 1405, 1404, 1, 0, 0, 0,
        1405, 1406, 1, 0, 0, 0, 1406, 1407, 1, 0, 0, 0, 1407, 1408, 5, 149, 0, 0, 1408, 1409, 3,
        202, 101, 0, 1409, 1410, 5, 150, 0, 0, 1410, 1421, 1, 0, 0, 0, 1411, 1415, 3, 200, 100, 0,
        1412, 1414, 3, 192, 96, 0, 1413, 1412, 1, 0, 0, 0, 1414, 1417, 1, 0, 0, 0, 1415, 1413, 1, 0,
        0, 0, 1415, 1416, 1, 0, 0, 0, 1416, 1418, 1, 0, 0, 0, 1417, 1415, 1, 0, 0, 0, 1418, 1419, 3,
        378, 189, 0, 1419, 1421, 1, 0, 0, 0, 1420, 1397, 1, 0, 0, 0, 1420, 1411, 1, 0, 0, 0, 1421,
        199, 1, 0, 0, 0, 1422, 1423, 7, 3, 0, 0, 1423, 201, 1, 0, 0, 0, 1424, 1426, 3, 204, 102, 0,
        1425, 1424, 1, 0, 0, 0, 1426, 1427, 1, 0, 0, 0, 1427, 1425, 1, 0, 0, 0, 1427, 1428, 1, 0, 0,
        0, 1428, 203, 1, 0, 0, 0, 1429, 1431, 3, 192, 96, 0, 1430, 1429, 1, 0, 0, 0, 1431, 1434, 1,
        0, 0, 0, 1432, 1430, 1, 0, 0, 0, 1432, 1433, 1, 0, 0, 0, 1433, 1435, 1, 0, 0, 0, 1434, 1432,
        1, 0, 0, 0, 1435, 1436, 3, 206, 103, 0, 1436, 1437, 3, 248, 124, 0, 1437, 1438, 5, 153, 0,
        0, 1438, 1450, 1, 0, 0, 0, 1439, 1441, 3, 192, 96, 0, 1440, 1439, 1, 0, 0, 0, 1441, 1444, 1,
        0, 0, 0, 1442, 1440, 1, 0, 0, 0, 1442, 1443, 1, 0, 0, 0, 1443, 1445, 1, 0, 0, 0, 1444, 1442,
        1, 0, 0, 0, 1445, 1446, 3, 206, 103, 0, 1446, 1447, 5, 153, 0, 0, 1447, 1450, 1, 0, 0, 0,
        1448, 1450, 3, 278, 139, 0, 1449, 1432, 1, 0, 0, 0, 1449, 1442, 1, 0, 0, 0, 1449, 1448, 1,
        0, 0, 0, 1450, 205, 1, 0, 0, 0, 1451, 1454, 3, 234, 117, 0, 1452, 1454, 3, 226, 113, 0,
        1453, 1451, 1, 0, 0, 0, 1453, 1452, 1, 0, 0, 0, 1454, 1456, 1, 0, 0, 0, 1455, 1457, 3, 206,
        103, 0, 1456, 1455, 1, 0, 0, 0, 1456, 1457, 1, 0, 0, 0, 1457, 207, 1, 0, 0, 0, 1458, 1464,
        5, 11, 0, 0, 1459, 1461, 3, 378, 189, 0, 1460, 1459, 1, 0, 0, 0, 1460, 1461, 1, 0, 0, 0,
        1461, 1462, 1, 0, 0, 0, 1462, 1463, 5, 166, 0, 0, 1463, 1465, 3, 168, 84, 0, 1464, 1460, 1,
        0, 0, 0, 1464, 1465, 1, 0, 0, 0, 1465, 1477, 1, 0, 0, 0, 1466, 1471, 3, 378, 189, 0, 1467,
        1468, 5, 149, 0, 0, 1468, 1469, 3, 210, 105, 0, 1469, 1470, 5, 150, 0, 0, 1470, 1472, 1, 0,
        0, 0, 1471, 1467, 1, 0, 0, 0, 1471, 1472, 1, 0, 0, 0, 1472, 1478, 1, 0, 0, 0, 1473, 1474, 5,
        149, 0, 0, 1474, 1475, 3, 210, 105, 0, 1475, 1476, 5, 150, 0, 0, 1476, 1478, 1, 0, 0, 0,
        1477, 1466, 1, 0, 0, 0, 1477, 1473, 1, 0, 0, 0, 1478, 1490, 1, 0, 0, 0, 1479, 1480, 7, 4, 0,
        0, 1480, 1481, 5, 147, 0, 0, 1481, 1482, 3, 168, 84, 0, 1482, 1483, 5, 154, 0, 0, 1483,
        1484, 3, 378, 189, 0, 1484, 1485, 5, 148, 0, 0, 1485, 1486, 5, 149, 0, 0, 1486, 1487, 3,
        210, 105, 0, 1487, 1488, 5, 150, 0, 0, 1488, 1490, 1, 0, 0, 0, 1489, 1458, 1, 0, 0, 0, 1489,
        1479, 1, 0, 0, 0, 1490, 209, 1, 0, 0, 0, 1491, 1496, 3, 212, 106, 0, 1492, 1493, 5, 154, 0,
        0, 1493, 1495, 3, 212, 106, 0, 1494, 1492, 1, 0, 0, 0, 1495, 1498, 1, 0, 0, 0, 1496, 1494,
        1, 0, 0, 0, 1496, 1497, 1, 0, 0, 0, 1497, 1500, 1, 0, 0, 0, 1498, 1496, 1, 0, 0, 0, 1499,
        1501, 5, 154, 0, 0, 1500, 1499, 1, 0, 0, 0, 1500, 1501, 1, 0, 0, 0, 1501, 211, 1, 0, 0, 0,
        1502, 1505, 3, 214, 107, 0, 1503, 1504, 5, 158, 0, 0, 1504, 1506, 3, 314, 157, 0, 1505,
        1503, 1, 0, 0, 0, 1505, 1506, 1, 0, 0, 0, 1506, 213, 1, 0, 0, 0, 1507, 1508, 3, 378, 189, 0,
        1508, 215, 1, 0, 0, 0, 1509, 1510, 5, 137, 0, 0, 1510, 1511, 5, 147, 0, 0, 1511, 1512, 3,
        378, 189, 0, 1512, 1513, 5, 148, 0, 0, 1513, 1516, 1, 0, 0, 0, 1514, 1516, 5, 136, 0, 0,
        1515, 1509, 1, 0, 0, 0, 1515, 1514, 1, 0, 0, 0, 1516, 217, 1, 0, 0, 0, 1517, 1518, 7, 5, 0,
        0, 1518, 219, 1, 0, 0, 0, 1519, 1520, 7, 6, 0, 0, 1520, 221, 1, 0, 0, 0, 1521, 1522, 7, 7,
        0, 0, 1522, 223, 1, 0, 0, 0, 1523, 1524, 7, 8, 0, 0, 1524, 225, 1, 0, 0, 0, 1525, 1531, 5,
        5, 0, 0, 1526, 1531, 5, 33, 0, 0, 1527, 1531, 5, 21, 0, 0, 1528, 1531, 5, 115, 0, 0, 1529,
        1531, 3, 232, 116, 0, 1530, 1525, 1, 0, 0, 0, 1530, 1526, 1, 0, 0, 0, 1530, 1527, 1, 0, 0,
        0, 1530, 1528, 1, 0, 0, 0, 1530, 1529, 1, 0, 0, 0, 1531, 227, 1, 0, 0, 0, 1532, 1540, 7, 9,
        0, 0, 1533, 1540, 3, 256, 128, 0, 1534, 1535, 5, 106, 0, 0, 1535, 1536, 5, 147, 0, 0, 1536,
        1537, 3, 378, 189, 0, 1537, 1538, 5, 148, 0, 0, 1538, 1540, 1, 0, 0, 0, 1539, 1532, 1, 0, 0,
        0, 1539, 1533, 1, 0, 0, 0, 1539, 1534, 1, 0, 0, 0, 1540, 229, 1, 0, 0, 0, 1541, 1542, 5,
        117, 0, 0, 1542, 1545, 5, 147, 0, 0, 1543, 1546, 3, 168, 84, 0, 1544, 1546, 3, 356, 178, 0,
        1545, 1543, 1, 0, 0, 0, 1545, 1544, 1, 0, 0, 0, 1546, 1547, 1, 0, 0, 0, 1547, 1548, 5, 148,
        0, 0, 1548, 231, 1, 0, 0, 0, 1549, 1550, 7, 10, 0, 0, 1550, 233, 1, 0, 0, 0, 1551, 1563, 3,
        246, 123, 0, 1552, 1553, 5, 111, 0, 0, 1553, 1554, 5, 147, 0, 0, 1554, 1555, 7, 11, 0, 0,
        1555, 1563, 5, 148, 0, 0, 1556, 1563, 3, 240, 120, 0, 1557, 1563, 3, 194, 97, 0, 1558, 1563,
        3, 198, 99, 0, 1559, 1563, 3, 208, 104, 0, 1560, 1563, 3, 238, 119, 0, 1561, 1563, 3, 236,
        118, 0, 1562, 1551, 1, 0, 0, 0, 1562, 1552, 1, 0, 0, 0, 1562, 1556, 1, 0, 0, 0, 1562, 1557,
        1, 0, 0, 0, 1562, 1558, 1, 0, 0, 0, 1562, 1559, 1, 0, 0, 0, 1562, 1560, 1, 0, 0, 0, 1562,
        1561, 1, 0, 0, 0, 1563, 235, 1, 0, 0, 0, 1564, 1565, 5, 97, 0, 0, 1565, 1566, 5, 147, 0, 0,
        1566, 1567, 3, 314, 157, 0, 1567, 1568, 5, 148, 0, 0, 1568, 237, 1, 0, 0, 0, 1569, 1570, 3,
        378, 189, 0, 1570, 239, 1, 0, 0, 0, 1571, 1572, 3, 378, 189, 0, 1572, 1573, 3, 242, 121, 0,
        1573, 241, 1, 0, 0, 0, 1574, 1583, 5, 162, 0, 0, 1575, 1580, 3, 244, 122, 0, 1576, 1577, 5,
        154, 0, 0, 1577, 1579, 3, 244, 122, 0, 1578, 1576, 1, 0, 0, 0, 1579, 1582, 1, 0, 0, 0, 1580,
        1578, 1, 0, 0, 0, 1580, 1581, 1, 0, 0, 0, 1581, 1584, 1, 0, 0, 0, 1582, 1580, 1, 0, 0, 0,
        1583, 1575, 1, 0, 0, 0, 1583, 1584, 1, 0, 0, 0, 1584, 1585, 1, 0, 0, 0, 1585, 1586, 5, 161,
        0, 0, 1586, 243, 1, 0, 0, 0, 1587, 1589, 7, 1, 0, 0, 1588, 1587, 1, 0, 0, 0, 1588, 1589, 1,
        0, 0, 0, 1589, 1590, 1, 0, 0, 0, 1590, 1591, 3, 168, 84, 0, 1591, 245, 1, 0, 0, 0, 1592,
        1593, 7, 12, 0, 0, 1593, 247, 1, 0, 0, 0, 1594, 1599, 3, 250, 125, 0, 1595, 1596, 5, 154, 0,
        0, 1596, 1598, 3, 250, 125, 0, 1597, 1595, 1, 0, 0, 0, 1598, 1601, 1, 0, 0, 0, 1599, 1597,
        1, 0, 0, 0, 1599, 1600, 1, 0, 0, 0, 1600, 249, 1, 0, 0, 0, 1601, 1599, 1, 0, 0, 0, 1602,
        1609, 3, 162, 81, 0, 1603, 1605, 3, 162, 81, 0, 1604, 1603, 1, 0, 0, 0, 1604, 1605, 1, 0, 0,
        0, 1605, 1606, 1, 0, 0, 0, 1606, 1607, 5, 166, 0, 0, 1607, 1609, 3, 356, 178, 0, 1608, 1602,
        1, 0, 0, 0, 1608, 1604, 1, 0, 0, 0, 1609, 251, 1, 0, 0, 0, 1610, 1611, 7, 13, 0, 0, 1611,
        253, 1, 0, 0, 0, 1612, 1613, 5, 102, 0, 0, 1613, 1615, 5, 147, 0, 0, 1614, 1616, 3, 376,
        188, 0, 1615, 1614, 1, 0, 0, 0, 1616, 1617, 1, 0, 0, 0, 1617, 1615, 1, 0, 0, 0, 1617, 1618,
        1, 0, 0, 0, 1618, 1619, 1, 0, 0, 0, 1619, 1620, 5, 148, 0, 0, 1620, 1623, 1, 0, 0, 0, 1621,
        1623, 3, 256, 128, 0, 1622, 1612, 1, 0, 0, 0, 1622, 1621, 1, 0, 0, 0, 1623, 255, 1, 0, 0, 0,
        1624, 1625, 5, 86, 0, 0, 1625, 1626, 5, 147, 0, 0, 1626, 1627, 5, 147, 0, 0, 1627, 1628, 3,
        258, 129, 0, 1628, 1629, 5, 148, 0, 0, 1629, 1630, 5, 148, 0, 0, 1630, 257, 1, 0, 0, 0,
        1631, 1633, 3, 260, 130, 0, 1632, 1631, 1, 0, 0, 0, 1632, 1633, 1, 0, 0, 0, 1633, 1640, 1,
        0, 0, 0, 1634, 1636, 5, 154, 0, 0, 1635, 1637, 3, 260, 130, 0, 1636, 1635, 1, 0, 0, 0, 1636,
        1637, 1, 0, 0, 0, 1637, 1639, 1, 0, 0, 0, 1638, 1634, 1, 0, 0, 0, 1639, 1642, 1, 0, 0, 0,
        1640, 1638, 1, 0, 0, 0, 1640, 1641, 1, 0, 0, 0, 1641, 259, 1, 0, 0, 0, 1642, 1640, 1, 0, 0,
        0, 1643, 1649, 8, 14, 0, 0, 1644, 1646, 5, 147, 0, 0, 1645, 1647, 3, 368, 184, 0, 1646,
        1645, 1, 0, 0, 0, 1646, 1647, 1, 0, 0, 0, 1647, 1648, 1, 0, 0, 0, 1648, 1650, 5, 148, 0, 0,
        1649, 1644, 1, 0, 0, 0, 1649, 1650, 1, 0, 0, 0, 1650, 261, 1, 0, 0, 0, 1651, 1653, 5, 177,
        0, 0, 1652, 1654, 3, 154, 77, 0, 1653, 1652, 1, 0, 0, 0, 1653, 1654, 1, 0, 0, 0, 1654, 1656,
        1, 0, 0, 0, 1655, 1657, 3, 264, 132, 0, 1656, 1655, 1, 0, 0, 0, 1656, 1657, 1, 0, 0, 0,
        1657, 263, 1, 0, 0, 0, 1658, 1660, 3, 266, 133, 0, 1659, 1658, 1, 0, 0, 0, 1660, 1661, 1, 0,
        0, 0, 1661, 1659, 1, 0, 0, 0, 1661, 1662, 1, 0, 0, 0, 1662, 265, 1, 0, 0, 0, 1663, 1665, 5,
        177, 0, 0, 1664, 1666, 3, 186, 93, 0, 1665, 1664, 1, 0, 0, 0, 1665, 1666, 1, 0, 0, 0, 1666,
        1668, 1, 0, 0, 0, 1667, 1669, 3, 220, 110, 0, 1668, 1667, 1, 0, 0, 0, 1668, 1669, 1, 0, 0,
        0, 1669, 267, 1, 0, 0, 0, 1670, 1679, 3, 378, 189, 0, 1671, 1674, 5, 147, 0, 0, 1672, 1675,
        5, 154, 0, 0, 1673, 1675, 8, 15, 0, 0, 1674, 1672, 1, 0, 0, 0, 1674, 1673, 1, 0, 0, 0, 1675,
        1676, 1, 0, 0, 0, 1676, 1674, 1, 0, 0, 0, 1676, 1677, 1, 0, 0, 0, 1677, 1678, 1, 0, 0, 0,
        1678, 1680, 5, 148, 0, 0, 1679, 1671, 1, 0, 0, 0, 1679, 1680, 1, 0, 0, 0, 1680, 269, 1, 0,
        0, 0, 1681, 1693, 5, 149, 0, 0, 1682, 1687, 3, 314, 157, 0, 1683, 1684, 5, 154, 0, 0, 1684,
        1686, 3, 314, 157, 0, 1685, 1683, 1, 0, 0, 0, 1686, 1689, 1, 0, 0, 0, 1687, 1685, 1, 0, 0,
        0, 1687, 1688, 1, 0, 0, 0, 1688, 1691, 1, 0, 0, 0, 1689, 1687, 1, 0, 0, 0, 1690, 1692, 5,
        154, 0, 0, 1691, 1690, 1, 0, 0, 0, 1691, 1692, 1, 0, 0, 0, 1692, 1694, 1, 0, 0, 0, 1693,
        1682, 1, 0, 0, 0, 1693, 1694, 1, 0, 0, 0, 1694, 1695, 1, 0, 0, 0, 1695, 1696, 5, 150, 0, 0,
        1696, 271, 1, 0, 0, 0, 1697, 1709, 5, 149, 0, 0, 1698, 1703, 3, 274, 137, 0, 1699, 1700, 5,
        154, 0, 0, 1700, 1702, 3, 274, 137, 0, 1701, 1699, 1, 0, 0, 0, 1702, 1705, 1, 0, 0, 0, 1703,
        1701, 1, 0, 0, 0, 1703, 1704, 1, 0, 0, 0, 1704, 1707, 1, 0, 0, 0, 1705, 1703, 1, 0, 0, 0,
        1706, 1708, 5, 154, 0, 0, 1707, 1706, 1, 0, 0, 0, 1707, 1708, 1, 0, 0, 0, 1708, 1710, 1, 0,
        0, 0, 1709, 1698, 1, 0, 0, 0, 1709, 1710, 1, 0, 0, 0, 1710, 1711, 1, 0, 0, 0, 1711, 1712, 5,
        150, 0, 0, 1712, 273, 1, 0, 0, 0, 1713, 1714, 5, 155, 0, 0, 1714, 1718, 3, 314, 157, 0,
        1715, 1718, 3, 272, 136, 0, 1716, 1718, 3, 270, 135, 0, 1717, 1713, 1, 0, 0, 0, 1717, 1715,
        1, 0, 0, 0, 1717, 1716, 1, 0, 0, 0, 1718, 275, 1, 0, 0, 0, 1719, 1724, 3, 354, 177, 0, 1720,
        1721, 5, 154, 0, 0, 1721, 1723, 3, 354, 177, 0, 1722, 1720, 1, 0, 0, 0, 1723, 1726, 1, 0, 0,
        0, 1724, 1722, 1, 0, 0, 0, 1724, 1725, 1, 0, 0, 0, 1725, 1728, 1, 0, 0, 0, 1726, 1724, 1, 0,
        0, 0, 1727, 1729, 5, 154, 0, 0, 1728, 1727, 1, 0, 0, 0, 1728, 1729, 1, 0, 0, 0, 1729, 277,
        1, 0, 0, 0, 1730, 1731, 5, 119, 0, 0, 1731, 1732, 5, 147, 0, 0, 1732, 1733, 3, 356, 178, 0,
        1733, 1735, 5, 154, 0, 0, 1734, 1736, 3, 376, 188, 0, 1735, 1734, 1, 0, 0, 0, 1736, 1737, 1,
        0, 0, 0, 1737, 1735, 1, 0, 0, 0, 1737, 1738, 1, 0, 0, 0, 1738, 1739, 1, 0, 0, 0, 1739, 1740,
        5, 148, 0, 0, 1740, 1741, 5, 153, 0, 0, 1741, 279, 1, 0, 0, 0, 1742, 1744, 3, 282, 141, 0,
        1743, 1745, 5, 153, 0, 0, 1744, 1743, 1, 0, 0, 0, 1744, 1745, 1, 0, 0, 0, 1745, 1781, 1, 0,
        0, 0, 1746, 1748, 3, 286, 143, 0, 1747, 1749, 5, 153, 0, 0, 1748, 1747, 1, 0, 0, 0, 1748,
        1749, 1, 0, 0, 0, 1749, 1781, 1, 0, 0, 0, 1750, 1752, 3, 288, 144, 0, 1751, 1753, 5, 153, 0,
        0, 1752, 1751, 1, 0, 0, 0, 1752, 1753, 1, 0, 0, 0, 1753, 1781, 1, 0, 0, 0, 1754, 1756, 3,
        298, 149, 0, 1755, 1757, 5, 153, 0, 0, 1756, 1755, 1, 0, 0, 0, 1756, 1757, 1, 0, 0, 0, 1757,
        1781, 1, 0, 0, 0, 1758, 1759, 3, 310, 155, 0, 1759, 1760, 5, 153, 0, 0, 1760, 1781, 1, 0, 0,
        0, 1761, 1763, 3, 120, 60, 0, 1762, 1764, 5, 153, 0, 0, 1763, 1762, 1, 0, 0, 0, 1763, 1764,
        1, 0, 0, 0, 1764, 1781, 1, 0, 0, 0, 1765, 1767, 3, 122, 61, 0, 1766, 1768, 5, 153, 0, 0,
        1767, 1766, 1, 0, 0, 0, 1767, 1768, 1, 0, 0, 0, 1768, 1781, 1, 0, 0, 0, 1769, 1770, 3, 114,
        57, 0, 1770, 1771, 5, 153, 0, 0, 1771, 1781, 1, 0, 0, 0, 1772, 1774, 3, 116, 58, 0, 1773,
        1775, 5, 153, 0, 0, 1774, 1773, 1, 0, 0, 0, 1774, 1775, 1, 0, 0, 0, 1775, 1781, 1, 0, 0, 0,
        1776, 1777, 3, 312, 156, 0, 1777, 1778, 5, 153, 0, 0, 1778, 1781, 1, 0, 0, 0, 1779, 1781, 5,
        153, 0, 0, 1780, 1742, 1, 0, 0, 0, 1780, 1746, 1, 0, 0, 0, 1780, 1750, 1, 0, 0, 0, 1780,
        1754, 1, 0, 0, 0, 1780, 1758, 1, 0, 0, 0, 1780, 1761, 1, 0, 0, 0, 1780, 1765, 1, 0, 0, 0,
        1780, 1769, 1, 0, 0, 0, 1780, 1772, 1, 0, 0, 0, 1780, 1776, 1, 0, 0, 0, 1780, 1779, 1, 0, 0,
        0, 1781, 281, 1, 0, 0, 0, 1782, 1783, 3, 378, 189, 0, 1783, 1784, 5, 166, 0, 0, 1784, 1785,
        3, 280, 140, 0, 1785, 283, 1, 0, 0, 0, 1786, 1789, 3, 314, 157, 0, 1787, 1788, 5, 193, 0, 0,
        1788, 1790, 3, 314, 157, 0, 1789, 1787, 1, 0, 0, 0, 1789, 1790, 1, 0, 0, 0, 1790, 285, 1, 0,
        0, 0, 1791, 1796, 5, 149, 0, 0, 1792, 1795, 3, 280, 140, 0, 1793, 1795, 3, 156, 78, 0, 1794,
        1792, 1, 0, 0, 0, 1794, 1793, 1, 0, 0, 0, 1795, 1798, 1, 0, 0, 0, 1796, 1794, 1, 0, 0, 0,
        1796, 1797, 1, 0, 0, 0, 1797, 1799, 1, 0, 0, 0, 1798, 1796, 1, 0, 0, 0, 1799, 1800, 5, 150,
        0, 0, 1800, 287, 1, 0, 0, 0, 1801, 1802, 5, 16, 0, 0, 1802, 1803, 5, 147, 0, 0, 1803, 1804,
        3, 312, 156, 0, 1804, 1805, 5, 148, 0, 0, 1805, 1808, 3, 280, 140, 0, 1806, 1807, 5, 10, 0,
        0, 1807, 1809, 3, 280, 140, 0, 1808, 1806, 1, 0, 0, 0, 1808, 1809, 1, 0, 0, 0, 1809, 1812,
        1, 0, 0, 0, 1810, 1812, 3, 290, 145, 0, 1811, 1801, 1, 0, 0, 0, 1811, 1810, 1, 0, 0, 0,
        1812, 289, 1, 0, 0, 0, 1813, 1814, 5, 28, 0, 0, 1814, 1815, 5, 147, 0, 0, 1815, 1816, 3,
        314, 157, 0, 1816, 1817, 5, 148, 0, 0, 1817, 1818, 3, 292, 146, 0, 1818, 291, 1, 0, 0, 0,
        1819, 1823, 5, 149, 0, 0, 1820, 1822, 3, 294, 147, 0, 1821, 1820, 1, 0, 0, 0, 1822, 1825, 1,
        0, 0, 0, 1823, 1821, 1, 0, 0, 0, 1823, 1824, 1, 0, 0, 0, 1824, 1826, 1, 0, 0, 0, 1825, 1823,
        1, 0, 0, 0, 1826, 1827, 5, 150, 0, 0, 1827, 293, 1, 0, 0, 0, 1828, 1830, 3, 296, 148, 0,
        1829, 1828, 1, 0, 0, 0, 1830, 1831, 1, 0, 0, 0, 1831, 1829, 1, 0, 0, 0, 1831, 1832, 1, 0, 0,
        0, 1832, 1834, 1, 0, 0, 0, 1833, 1835, 3, 280, 140, 0, 1834, 1833, 1, 0, 0, 0, 1835, 1836,
        1, 0, 0, 0, 1836, 1834, 1, 0, 0, 0, 1836, 1837, 1, 0, 0, 0, 1837, 295, 1, 0, 0, 0, 1838,
        1844, 5, 3, 0, 0, 1839, 1845, 3, 284, 142, 0, 1840, 1841, 5, 147, 0, 0, 1841, 1842, 3, 284,
        142, 0, 1842, 1843, 5, 148, 0, 0, 1843, 1845, 1, 0, 0, 0, 1844, 1839, 1, 0, 0, 0, 1844,
        1840, 1, 0, 0, 0, 1845, 1846, 1, 0, 0, 0, 1846, 1847, 5, 166, 0, 0, 1847, 1851, 1, 0, 0, 0,
        1848, 1849, 5, 7, 0, 0, 1849, 1851, 5, 166, 0, 0, 1850, 1838, 1, 0, 0, 0, 1850, 1848, 1, 0,
        0, 0, 1851, 297, 1, 0, 0, 0, 1852, 1857, 3, 300, 150, 0, 1853, 1857, 3, 302, 151, 0, 1854,
        1857, 3, 304, 152, 0, 1855, 1857, 3, 308, 154, 0, 1856, 1852, 1, 0, 0, 0, 1856, 1853, 1, 0,
        0, 0, 1856, 1854, 1, 0, 0, 0, 1856, 1855, 1, 0, 0, 0, 1857, 299, 1, 0, 0, 0, 1858, 1859, 5,
        34, 0, 0, 1859, 1860, 5, 147, 0, 0, 1860, 1861, 3, 314, 157, 0, 1861, 1862, 5, 148, 0, 0,
        1862, 1863, 3, 280, 140, 0, 1863, 301, 1, 0, 0, 0, 1864, 1865, 5, 8, 0, 0, 1865, 1866, 3,
        280, 140, 0, 1866, 1867, 5, 34, 0, 0, 1867, 1868, 5, 147, 0, 0, 1868, 1869, 3, 314, 157, 0,
        1869, 1870, 5, 148, 0, 0, 1870, 1871, 5, 153, 0, 0, 1871, 303, 1, 0, 0, 0, 1872, 1873, 5,
        14, 0, 0, 1873, 1875, 5, 147, 0, 0, 1874, 1876, 3, 306, 153, 0, 1875, 1874, 1, 0, 0, 0,
        1875, 1876, 1, 0, 0, 0, 1876, 1877, 1, 0, 0, 0, 1877, 1879, 5, 153, 0, 0, 1878, 1880, 3,
        314, 157, 0, 1879, 1878, 1, 0, 0, 0, 1879, 1880, 1, 0, 0, 0, 1880, 1881, 1, 0, 0, 0, 1881,
        1883, 5, 153, 0, 0, 1882, 1884, 3, 312, 156, 0, 1883, 1882, 1, 0, 0, 0, 1883, 1884, 1, 0, 0,
        0, 1884, 1885, 1, 0, 0, 0, 1885, 1886, 5, 148, 0, 0, 1886, 1887, 3, 280, 140, 0, 1887, 305,
        1, 0, 0, 0, 1888, 1889, 3, 154, 77, 0, 1889, 1890, 3, 158, 79, 0, 1890, 1893, 1, 0, 0, 0,
        1891, 1893, 3, 312, 156, 0, 1892, 1888, 1, 0, 0, 0, 1892, 1891, 1, 0, 0, 0, 1893, 307, 1, 0,
        0, 0, 1894, 1895, 5, 14, 0, 0, 1895, 1896, 5, 147, 0, 0, 1896, 1897, 3, 112, 56, 0, 1897,
        1899, 5, 48, 0, 0, 1898, 1900, 3, 314, 157, 0, 1899, 1898, 1, 0, 0, 0, 1899, 1900, 1, 0, 0,
        0, 1900, 1901, 1, 0, 0, 0, 1901, 1902, 5, 148, 0, 0, 1902, 1903, 3, 280, 140, 0, 1903, 309,
        1, 0, 0, 0, 1904, 1905, 5, 15, 0, 0, 1905, 1913, 3, 378, 189, 0, 1906, 1913, 5, 6, 0, 0,
        1907, 1913, 5, 2, 0, 0, 1908, 1910, 5, 22, 0, 0, 1909, 1911, 3, 314, 157, 0, 1910, 1909, 1,
        0, 0, 0, 1910, 1911, 1, 0, 0, 0, 1911, 1913, 1, 0, 0, 0, 1912, 1904, 1, 0, 0, 0, 1912, 1906,
        1, 0, 0, 0, 1912, 1907, 1, 0, 0, 0, 1912, 1908, 1, 0, 0, 0, 1913, 311, 1, 0, 0, 0, 1914,
        1919, 3, 314, 157, 0, 1915, 1916, 5, 154, 0, 0, 1916, 1918, 3, 314, 157, 0, 1917, 1915, 1,
        0, 0, 0, 1918, 1921, 1, 0, 0, 0, 1919, 1917, 1, 0, 0, 0, 1919, 1920, 1, 0, 0, 0, 1920, 313,
        1, 0, 0, 0, 1921, 1919, 1, 0, 0, 0, 1922, 1928, 3, 316, 158, 0, 1923, 1924, 5, 147, 0, 0,
        1924, 1925, 3, 286, 143, 0, 1925, 1926, 5, 148, 0, 0, 1926, 1928, 1, 0, 0, 0, 1927, 1922, 1,
        0, 0, 0, 1927, 1923, 1, 0, 0, 0, 1928, 315, 1, 0, 0, 0, 1929, 1935, 3, 320, 160, 0, 1930,
        1931, 3, 358, 179, 0, 1931, 1932, 3, 318, 159, 0, 1932, 1933, 3, 314, 157, 0, 1933, 1935, 1,
        0, 0, 0, 1934, 1929, 1, 0, 0, 0, 1934, 1930, 1, 0, 0, 0, 1935, 317, 1, 0, 0, 0, 1936, 1937,
        7, 16, 0, 0, 1937, 319, 1, 0, 0, 0, 1938, 1945, 3, 322, 161, 0, 1939, 1941, 5, 165, 0, 0,
        1940, 1942, 3, 314, 157, 0, 1941, 1940, 1, 0, 0, 0, 1941, 1942, 1, 0, 0, 0, 1942, 1943, 1,
        0, 0, 0, 1943, 1944, 5, 166, 0, 0, 1944, 1946, 3, 320, 160, 0, 1945, 1939, 1, 0, 0, 0, 1945,
        1946, 1, 0, 0, 0, 1946, 321, 1, 0, 0, 0, 1947, 1952, 3, 324, 162, 0, 1948, 1949, 5, 172, 0,
        0, 1949, 1951, 3, 324, 162, 0, 1950, 1948, 1, 0, 0, 0, 1951, 1954, 1, 0, 0, 0, 1952, 1950,
        1, 0, 0, 0, 1952, 1953, 1, 0, 0, 0, 1953, 323, 1, 0, 0, 0, 1954, 1952, 1, 0, 0, 0, 1955,
        1960, 3, 326, 163, 0, 1956, 1957, 5, 171, 0, 0, 1957, 1959, 3, 326, 163, 0, 1958, 1956, 1,
        0, 0, 0, 1959, 1962, 1, 0, 0, 0, 1960, 1958, 1, 0, 0, 0, 1960, 1961, 1, 0, 0, 0, 1961, 325,
        1, 0, 0, 0, 1962, 1960, 1, 0, 0, 0, 1963, 1968, 3, 328, 164, 0, 1964, 1965, 5, 180, 0, 0,
        1965, 1967, 3, 328, 164, 0, 1966, 1964, 1, 0, 0, 0, 1967, 1970, 1, 0, 0, 0, 1968, 1966, 1,
        0, 0, 0, 1968, 1969, 1, 0, 0, 0, 1969, 327, 1, 0, 0, 0, 1970, 1968, 1, 0, 0, 0, 1971, 1976,
        3, 330, 165, 0, 1972, 1973, 5, 181, 0, 0, 1973, 1975, 3, 330, 165, 0, 1974, 1972, 1, 0, 0,
        0, 1975, 1978, 1, 0, 0, 0, 1976, 1974, 1, 0, 0, 0, 1976, 1977, 1, 0, 0, 0, 1977, 329, 1, 0,
        0, 0, 1978, 1976, 1, 0, 0, 0, 1979, 1984, 3, 332, 166, 0, 1980, 1981, 5, 179, 0, 0, 1981,
        1983, 3, 332, 166, 0, 1982, 1980, 1, 0, 0, 0, 1983, 1986, 1, 0, 0, 0, 1984, 1982, 1, 0, 0,
        0, 1984, 1985, 1, 0, 0, 0, 1985, 331, 1, 0, 0, 0, 1986, 1984, 1, 0, 0, 0, 1987, 1993, 3,
        336, 168, 0, 1988, 1989, 3, 334, 167, 0, 1989, 1990, 3, 336, 168, 0, 1990, 1992, 1, 0, 0, 0,
        1991, 1988, 1, 0, 0, 0, 1992, 1995, 1, 0, 0, 0, 1993, 1991, 1, 0, 0, 0, 1993, 1994, 1, 0, 0,
        0, 1994, 333, 1, 0, 0, 0, 1995, 1993, 1, 0, 0, 0, 1996, 1997, 7, 17, 0, 0, 1997, 335, 1, 0,
        0, 0, 1998, 2004, 3, 340, 170, 0, 1999, 2000, 3, 338, 169, 0, 2000, 2001, 3, 340, 170, 0,
        2001, 2003, 1, 0, 0, 0, 2002, 1999, 1, 0, 0, 0, 2003, 2006, 1, 0, 0, 0, 2004, 2002, 1, 0, 0,
        0, 2004, 2005, 1, 0, 0, 0, 2005, 337, 1, 0, 0, 0, 2006, 2004, 1, 0, 0, 0, 2007, 2008, 7, 18,
        0, 0, 2008, 339, 1, 0, 0, 0, 2009, 2015, 3, 344, 172, 0, 2010, 2011, 3, 342, 171, 0, 2011,
        2012, 3, 344, 172, 0, 2012, 2014, 1, 0, 0, 0, 2013, 2010, 1, 0, 0, 0, 2014, 2017, 1, 0, 0,
        0, 2015, 2013, 1, 0, 0, 0, 2015, 2016, 1, 0, 0, 0, 2016, 341, 1, 0, 0, 0, 2017, 2015, 1, 0,
        0, 0, 2018, 2019, 7, 19, 0, 0, 2019, 343, 1, 0, 0, 0, 2020, 2026, 3, 348, 174, 0, 2021,
        2022, 3, 346, 173, 0, 2022, 2023, 3, 348, 174, 0, 2023, 2025, 1, 0, 0, 0, 2024, 2021, 1, 0,
        0, 0, 2025, 2028, 1, 0, 0, 0, 2026, 2024, 1, 0, 0, 0, 2026, 2027, 1, 0, 0, 0, 2027, 345, 1,
        0, 0, 0, 2028, 2026, 1, 0, 0, 0, 2029, 2030, 7, 20, 0, 0, 2030, 347, 1, 0, 0, 0, 2031, 2037,
        3, 352, 176, 0, 2032, 2033, 3, 350, 175, 0, 2033, 2034, 3, 352, 176, 0, 2034, 2036, 1, 0, 0,
        0, 2035, 2032, 1, 0, 0, 0, 2036, 2039, 1, 0, 0, 0, 2037, 2035, 1, 0, 0, 0, 2037, 2038, 1, 0,
        0, 0, 2038, 349, 1, 0, 0, 0, 2039, 2037, 1, 0, 0, 0, 2040, 2041, 7, 21, 0, 0, 2041, 351, 1,
        0, 0, 0, 2042, 2044, 5, 111, 0, 0, 2043, 2042, 1, 0, 0, 0, 2043, 2044, 1, 0, 0, 0, 2044,
        2045, 1, 0, 0, 0, 2045, 2046, 5, 147, 0, 0, 2046, 2047, 3, 168, 84, 0, 2047, 2048, 5, 148,
        0, 0, 2048, 2049, 3, 352, 176, 0, 2049, 2053, 1, 0, 0, 0, 2050, 2053, 3, 358, 179, 0, 2051,
        2053, 5, 200, 0, 0, 2052, 2043, 1, 0, 0, 0, 2052, 2050, 1, 0, 0, 0, 2052, 2051, 1, 0, 0, 0,
        2053, 353, 1, 0, 0, 0, 2054, 2058, 3, 314, 157, 0, 2055, 2058, 3, 270, 135, 0, 2056, 2058,
        3, 272, 136, 0, 2057, 2054, 1, 0, 0, 0, 2057, 2055, 1, 0, 0, 0, 2057, 2056, 1, 0, 0, 0,
        2058, 355, 1, 0, 0, 0, 2059, 2062, 3, 378, 189, 0, 2060, 2062, 3, 374, 187, 0, 2061, 2059,
        1, 0, 0, 0, 2061, 2060, 1, 0, 0, 0, 2062, 357, 1, 0, 0, 0, 2063, 2078, 3, 362, 181, 0, 2064,
        2070, 5, 25, 0, 0, 2065, 2071, 3, 358, 179, 0, 2066, 2067, 5, 147, 0, 0, 2067, 2068, 3, 234,
        117, 0, 2068, 2069, 5, 148, 0, 0, 2069, 2071, 1, 0, 0, 0, 2070, 2065, 1, 0, 0, 0, 2070,
        2066, 1, 0, 0, 0, 2071, 2078, 1, 0, 0, 0, 2072, 2073, 7, 22, 0, 0, 2073, 2078, 3, 358, 179,
        0, 2074, 2075, 3, 360, 180, 0, 2075, 2076, 3, 352, 176, 0, 2076, 2078, 1, 0, 0, 0, 2077,
        2063, 1, 0, 0, 0, 2077, 2064, 1, 0, 0, 0, 2077, 2072, 1, 0, 0, 0, 2077, 2074, 1, 0, 0, 0,
        2078, 359, 1, 0, 0, 0, 2079, 2080, 7, 23, 0, 0, 2080, 361, 1, 0, 0, 0, 2081, 2082, 6, 181,
        -1, 0, 2082, 2086, 3, 364, 182, 0, 2083, 2085, 3, 366, 183, 0, 2084, 2083, 1, 0, 0, 0, 2085,
        2088, 1, 0, 0, 0, 2086, 2084, 1, 0, 0, 0, 2086, 2087, 1, 0, 0, 0, 2087, 2100, 1, 0, 0, 0,
        2088, 2086, 1, 0, 0, 0, 2089, 2090, 10, 1, 0, 0, 2090, 2091, 7, 24, 0, 0, 2091, 2095, 3,
        378, 189, 0, 2092, 2094, 3, 366, 183, 0, 2093, 2092, 1, 0, 0, 0, 2094, 2097, 1, 0, 0, 0,
        2095, 2093, 1, 0, 0, 0, 2095, 2096, 1, 0, 0, 0, 2096, 2099, 1, 0, 0, 0, 2097, 2095, 1, 0, 0,
        0, 2098, 2089, 1, 0, 0, 0, 2099, 2102, 1, 0, 0, 0, 2100, 2098, 1, 0, 0, 0, 2100, 2101, 1, 0,
        0, 0, 2101, 363, 1, 0, 0, 0, 2102, 2100, 1, 0, 0, 0, 2103, 2119, 3, 378, 189, 0, 2104, 2119,
        3, 374, 187, 0, 2105, 2119, 3, 376, 188, 0, 2106, 2107, 5, 147, 0, 0, 2107, 2108, 3, 314,
        157, 0, 2108, 2109, 5, 148, 0, 0, 2109, 2119, 1, 0, 0, 0, 2110, 2119, 3, 372, 186, 0, 2111,
        2119, 3, 104, 52, 0, 2112, 2119, 3, 108, 54, 0, 2113, 2119, 3, 110, 55, 0, 2114, 2119, 3,
        84, 42, 0, 2115, 2119, 3, 88, 44, 0, 2116, 2119, 3, 90, 45, 0, 2117, 2119, 3, 94, 47, 0,
        2118, 2103, 1, 0, 0, 0, 2118, 2104, 1, 0, 0, 0, 2118, 2105, 1, 0, 0, 0, 2118, 2106, 1, 0, 0,
        0, 2118, 2110, 1, 0, 0, 0, 2118, 2111, 1, 0, 0, 0, 2118, 2112, 1, 0, 0, 0, 2118, 2113, 1, 0,
        0, 0, 2118, 2114, 1, 0, 0, 0, 2118, 2115, 1, 0, 0, 0, 2118, 2116, 1, 0, 0, 0, 2118, 2117, 1,
        0, 0, 0, 2119, 365, 1, 0, 0, 0, 2120, 2121, 5, 151, 0, 0, 2121, 2122, 3, 314, 157, 0, 2122,
        2123, 5, 152, 0, 0, 2123, 2131, 1, 0, 0, 0, 2124, 2126, 5, 147, 0, 0, 2125, 2127, 3, 368,
        184, 0, 2126, 2125, 1, 0, 0, 0, 2126, 2127, 1, 0, 0, 0, 2127, 2128, 1, 0, 0, 0, 2128, 2131,
        5, 148, 0, 0, 2129, 2131, 7, 22, 0, 0, 2130, 2120, 1, 0, 0, 0, 2130, 2124, 1, 0, 0, 0, 2130,
        2129, 1, 0, 0, 0, 2131, 367, 1, 0, 0, 0, 2132, 2137, 3, 370, 185, 0, 2133, 2134, 5, 154, 0,
        0, 2134, 2136, 3, 370, 185, 0, 2135, 2133, 1, 0, 0, 0, 2136, 2139, 1, 0, 0, 0, 2137, 2135,
        1, 0, 0, 0, 2137, 2138, 1, 0, 0, 0, 2138, 369, 1, 0, 0, 0, 2139, 2137, 1, 0, 0, 0, 2140,
        2143, 3, 314, 157, 0, 2141, 2143, 3, 240, 120, 0, 2142, 2140, 1, 0, 0, 0, 2142, 2141, 1, 0,
        0, 0, 2143, 371, 1, 0, 0, 0, 2144, 2145, 5, 151, 0, 0, 2145, 2146, 3, 96, 48, 0, 2146, 2147,
        3, 98, 49, 0, 2147, 2148, 5, 152, 0, 0, 2148, 373, 1, 0, 0, 0, 2149, 2168, 5, 196, 0, 0,
        2150, 2168, 5, 197, 0, 0, 2151, 2168, 5, 198, 0, 0, 2152, 2154, 7, 20, 0, 0, 2153, 2152, 1,
        0, 0, 0, 2153, 2154, 1, 0, 0, 0, 2154, 2155, 1, 0, 0, 0, 2155, 2168, 5, 199, 0, 0, 2156,
        2158, 7, 20, 0, 0, 2157, 2156, 1, 0, 0, 0, 2157, 2158, 1, 0, 0, 0, 2158, 2159, 1, 0, 0, 0,
        2159, 2168, 5, 201, 0, 0, 2160, 2168, 5, 194, 0, 0, 2161, 2168, 5, 50, 0, 0, 2162, 2168, 5,
        52, 0, 0, 2163, 2168, 5, 59, 0, 0, 2164, 2168, 5, 51, 0, 0, 2165, 2168, 5, 39, 0, 0, 2166,
        2168, 5, 40, 0, 0, 2167, 2149, 1, 0, 0, 0, 2167, 2150, 1, 0, 0, 0, 2167, 2151, 1, 0, 0, 0,
        2167, 2153, 1, 0, 0, 0, 2167, 2157, 1, 0, 0, 0, 2167, 2160, 1, 0, 0, 0, 2167, 2161, 1, 0, 0,
        0, 2167, 2162, 1, 0, 0, 0, 2167, 2163, 1, 0, 0, 0, 2167, 2164, 1, 0, 0, 0, 2167, 2165, 1, 0,
        0, 0, 2167, 2166, 1, 0, 0, 0, 2168, 375, 1, 0, 0, 0, 2169, 2173, 5, 195, 0, 0, 2170, 2172,
        7, 25, 0, 0, 2171, 2170, 1, 0, 0, 0, 2172, 2175, 1, 0, 0, 0, 2173, 2171, 1, 0, 0, 0, 2173,
        2174, 1, 0, 0, 0, 2174, 2176, 1, 0, 0, 0, 2175, 2173, 1, 0, 0, 0, 2176, 2178, 5, 208, 0, 0,
        2177, 2169, 1, 0, 0, 0, 2178, 2179, 1, 0, 0, 0, 2179, 2177, 1, 0, 0, 0, 2179, 2180, 1, 0, 0,
        0, 2180, 377, 1, 0, 0, 0, 2181, 2182, 7, 26, 0, 0, 2182, 379, 1, 0, 0, 0, 274, 383, 398,
        405, 410, 413, 421, 423, 429, 435, 442, 445, 448, 455, 458, 466, 468, 474, 478, 484, 497,
        500, 507, 519, 524, 533, 539, 541, 553, 563, 570, 578, 581, 584, 593, 607, 614, 617, 623,
        632, 638, 640, 649, 651, 660, 666, 670, 679, 681, 690, 694, 697, 700, 704, 710, 714, 716,
        719, 725, 729, 739, 753, 760, 766, 775, 779, 781, 793, 795, 807, 809, 814, 820, 823, 842,
        846, 852, 854, 857, 865, 870, 876, 885, 890, 892, 914, 921, 926, 950, 954, 959, 963, 967,
        971, 980, 987, 994, 1000, 1005, 1012, 1019, 1024, 1027, 1030, 1041, 1046, 1050, 1055, 1062,
        1068, 1071, 1077, 1091, 1110, 1115, 1118, 1125, 1140, 1147, 1150, 1152, 1159, 1163, 1167,
        1171, 1177, 1181, 1186, 1188, 1192, 1198, 1201, 1210, 1215, 1218, 1224, 1240, 1246, 1254,
        1258, 1262, 1267, 1270, 1277, 1296, 1302, 1305, 1307, 1312, 1317, 1320, 1325, 1332, 1340,
        1348, 1350, 1355, 1362, 1367, 1379, 1393, 1401, 1405, 1415, 1420, 1427, 1432, 1442, 1449,
        1453, 1456, 1460, 1464, 1471, 1477, 1489, 1496, 1500, 1505, 1515, 1530, 1539, 1545, 1562,
        1580, 1583, 1588, 1599, 1604, 1608, 1617, 1622, 1632, 1636, 1640, 1646, 1649, 1653, 1656,
        1661, 1665, 1668, 1674, 1676, 1679, 1687, 1691, 1693, 1703, 1707, 1709, 1717, 1724, 1728,
        1737, 1744, 1748, 1752, 1756, 1763, 1767, 1774, 1780, 1789, 1794, 1796, 1808, 1811, 1823,
        1831, 1836, 1844, 1850, 1856, 1875, 1879, 1883, 1892, 1899, 1910, 1912, 1919, 1927, 1934,
        1941, 1945, 1952, 1960, 1968, 1976, 1984, 1993, 2004, 2015, 2026, 2037, 2043, 2052, 2057,
        2061, 2070, 2077, 2086, 2095, 2100, 2118, 2126, 2130, 2137, 2142, 2153, 2157, 2167, 2173,
        2179,
    ]
}
