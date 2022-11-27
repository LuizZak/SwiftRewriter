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
        RULE_declarationSpecifiers = 87, RULE_declaration = 88, RULE_initDeclaratorList = 89,
        RULE_initDeclarator = 90, RULE_declarator = 91, RULE_directDeclarator = 92,
        RULE_typeName = 93, RULE_abstractDeclarator_ = 94, RULE_abstractDeclarator = 95,
        RULE_directAbstractDeclarator = 96, RULE_abstractDeclaratorSuffix_ = 97,
        RULE_parameterTypeList = 98, RULE_parameterList = 99, RULE_parameterDeclarationList_ = 100,
        RULE_parameterDeclaration = 101, RULE_typeQualifierList = 102, RULE_identifierList = 103,
        RULE_declaratorSuffix = 104, RULE_attributeSpecifier = 105, RULE_atomicTypeSpecifier = 106,
        RULE_structOrUnionSpecifier_ = 107, RULE_structOrUnionSpecifier = 108,
        RULE_structOrUnion = 109, RULE_structDeclarationList = 110, RULE_structDeclaration = 111,
        RULE_specifierQualifierList = 112, RULE_structDeclaratorList = 113,
        RULE_structDeclarator = 114, RULE_fieldDeclaration = 115, RULE_ibOutletQualifier = 116,
        RULE_arcBehaviourSpecifier = 117, RULE_nullabilitySpecifier = 118,
        RULE_storageClassSpecifier = 119, RULE_typePrefix = 120, RULE_typeQualifier = 121,
        RULE_functionSpecifier = 122, RULE_alignmentSpecifier = 123, RULE_protocolQualifier = 124,
        RULE_typeSpecifier_ = 125, RULE_typeSpecifier = 126, RULE_typeofTypeSpecifier = 127,
        RULE_typedefName = 128, RULE_genericTypeSpecifier = 129, RULE_genericTypeList = 130,
        RULE_genericTypeParameter = 131, RULE_scalarTypeSpecifier = 132,
        RULE_fieldDeclaratorList = 133, RULE_fieldDeclarator = 134, RULE_enumSpecifier = 135,
        RULE_enumeratorList = 136, RULE_enumerator = 137, RULE_enumeratorIdentifier = 138,
        RULE_vcSpecificModifer = 139, RULE_gccDeclaratorExtension = 140,
        RULE_gccAttributeSpecifier = 141, RULE_gccAttributeList = 142, RULE_gccAttribute = 143,
        RULE_pointer_ = 144, RULE_pointer = 145, RULE_pointerEntry = 146, RULE_macro = 147,
        RULE_arrayInitializer = 148, RULE_structInitializer = 149, RULE_structInitializerItem = 150,
        RULE_initializerList = 151, RULE_staticAssertDeclaration = 152, RULE_statement = 153,
        RULE_labeledStatement = 154, RULE_rangeExpression = 155, RULE_compoundStatement = 156,
        RULE_selectionStatement = 157, RULE_switchStatement = 158, RULE_switchBlock = 159,
        RULE_switchSection = 160, RULE_switchLabel = 161, RULE_iterationStatement = 162,
        RULE_whileStatement = 163, RULE_doStatement = 164, RULE_forStatement = 165,
        RULE_forLoopInitializer = 166, RULE_forInStatement = 167, RULE_jumpStatement = 168,
        RULE_expressions = 169, RULE_expression = 170, RULE_assignmentExpression = 171,
        RULE_assignmentOperator = 172, RULE_castExpression = 173, RULE_initializer = 174,
        RULE_constantExpression = 175, RULE_unaryExpression = 176, RULE_unaryOperator = 177,
        RULE_postfixExpression = 178, RULE_postfixExpr = 179, RULE_argumentExpressionList = 180,
        RULE_argumentExpression = 181, RULE_primaryExpression = 182, RULE_constant = 183,
        RULE_stringLiteral = 184, RULE_identifier = 185

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
        "declarationSpecifier__", "declarationSpecifier", "declarationSpecifiers", "declaration",
        "initDeclaratorList", "initDeclarator", "declarator", "directDeclarator", "typeName",
        "abstractDeclarator_", "abstractDeclarator", "directAbstractDeclarator",
        "abstractDeclaratorSuffix_", "parameterTypeList", "parameterList",
        "parameterDeclarationList_", "parameterDeclaration", "typeQualifierList", "identifierList",
        "declaratorSuffix", "attributeSpecifier", "atomicTypeSpecifier", "structOrUnionSpecifier_",
        "structOrUnionSpecifier", "structOrUnion", "structDeclarationList", "structDeclaration",
        "specifierQualifierList", "structDeclaratorList", "structDeclarator", "fieldDeclaration",
        "ibOutletQualifier", "arcBehaviourSpecifier", "nullabilitySpecifier",
        "storageClassSpecifier", "typePrefix", "typeQualifier", "functionSpecifier",
        "alignmentSpecifier", "protocolQualifier", "typeSpecifier_", "typeSpecifier",
        "typeofTypeSpecifier", "typedefName", "genericTypeSpecifier", "genericTypeList",
        "genericTypeParameter", "scalarTypeSpecifier", "fieldDeclaratorList", "fieldDeclarator",
        "enumSpecifier", "enumeratorList", "enumerator", "enumeratorIdentifier",
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
            setState(375)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 5_180_263_529_751_394_866) != 0
                || (Int64((_la - 67)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 67)) & -36_507_287_529) != 0
                || (Int64((_la - 131)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 131)) & 17_592_186_143_231) != 0
            {
                setState(372)
                try topLevelDeclaration()

                setState(377)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(378)
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
            setState(390)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 1, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(380)
                try importDeclaration()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(381)
                try declaration()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(382)
                try classInterface()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(383)
                try classImplementation()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(384)
                try categoryInterface()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(385)
                try categoryImplementation()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(386)
                try protocolDeclaration()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(387)
                try protocolDeclarationList()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(388)
                try classDeclarationList()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(389)
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
            setState(392)
            try match(ObjectiveCParser.Tokens.IMPORT.rawValue)
            setState(393)
            try identifier()
            setState(394)
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
            setState(397)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue {
                setState(396)
                try match(ObjectiveCParser.Tokens.IB_DESIGNABLE.rawValue)

            }

            setState(399)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(400)
            try classInterfaceName()
            setState(402)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(401)
                try instanceVariables()

            }

            setState(405)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -285_213_183) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(404)
                try interfaceDeclarationList()

            }

            setState(407)
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
            setState(409)
            try className()
            setState(415)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(410)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(411)
                try superclassName()
                setState(413)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 5, _ctx) {
                case 1:
                    setState(412)
                    try genericSuperclassSpecifier()

                    break
                default: break
                }

            }

            setState(421)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(417)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(418)
                try protocolList()
                setState(419)
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
            setState(423)
            try match(ObjectiveCParser.Tokens.INTERFACE.rawValue)
            setState(424)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryInterfaceContext.self).categoryName = assignmentValue
            }()

            setState(425)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(427)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(426)
                try identifier()

            }

            setState(429)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(434)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(430)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(431)
                try protocolList()
                setState(432)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(437)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(436)
                try instanceVariables()

            }

            setState(440)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 74)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 74)) & -285_213_183) != 0
                || (Int64((_la - 138)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 138)) & 240_518_169_347) != 0
            {
                setState(439)
                try interfaceDeclarationList()

            }

            setState(442)
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
            setState(444)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(445)
            try classImplementatioName()
            setState(447)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(446)
                try instanceVariables()

            }

            setState(450)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_390_521) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(449)
                try implementationDefinitionList()

            }

            setState(452)
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
            setState(454)
            try className()
            setState(460)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COLON.rawValue {
                setState(455)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(456)
                try superclassName()
                setState(458)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.LT.rawValue {
                    setState(457)
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
            setState(462)
            try match(ObjectiveCParser.Tokens.IMPLEMENTATION.rawValue)
            setState(463)
            try {
                let assignmentValue = try className()
                _localctx.castdown(CategoryImplementationContext.self).categoryName =
                    assignmentValue
            }()

            setState(464)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(466)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(465)
                try identifier()

            }

            setState(468)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(470)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_390_521) != 0
                || (Int64((_la - 146)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 146)) & 939_524_099) != 0
            {
                setState(469)
                try implementationDefinitionList()

            }

            setState(472)
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
            setState(474)
            try identifier()
            setState(480)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 18, _ctx) {
            case 1:
                setState(475)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(476)
                try protocolList()
                setState(477)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

                break
            case 2:
                setState(479)
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
            setState(482)
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
            setState(484)
            try identifier()
            setState(485)
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
            setState(487)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(496)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_303_103_687_184) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_977_896_218_633) != 0
            {
                setState(488)
                try superclassTypeSpecifierWithPrefixes()
                setState(493)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(489)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(490)
                    try superclassTypeSpecifierWithPrefixes()

                    setState(495)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(498)
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
            setState(503)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(500)
                    try typePrefix()

                }
                setState(505)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 21, _ctx)
            }
            setState(506)
            try typeSpecifier()
            setState(508)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(507)
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
            setState(510)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(511)
            try protocolName()
            setState(516)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LT.rawValue {
                setState(512)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(513)
                try protocolList()
                setState(514)
                try match(ObjectiveCParser.Tokens.GT.rawValue)

            }

            setState(521)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 72)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 72)) & -1_140_852_699) != 0
                || (Int64((_la - 136)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 136)) & 962_072_677_391) != 0
            {
                setState(518)
                try protocolDeclarationSection()

                setState(523)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(524)
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
            setState(538)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .OPTIONAL, .REQUIRED:
                try enterOuterAlt(_localctx, 1)
                setState(526)
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
                setState(530)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 25, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(527)
                        try interfaceDeclarationList()

                    }
                    setState(532)
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
                .COVARIANT, .CONTRAVARIANT, .DEPRECATED, .KINDOF, .STRONG_QUALIFIER, .TYPEOF,
                .UNSAFE_UNRETAINED_QUALIFIER, .UNUSED, .WEAK_QUALIFIER, .CDECL, .CLRCALL, .STDCALL,
                .DECLSPEC, .FASTCALL, .THISCALL, .VECTORCALL, .INLINE__, .EXTENSION, .M128, .M128D,
                .M128I, .ATOMIC_, .NORETURN_, .ALIGNAS_, .THREAD_LOCAL_, .STATIC_ASSERT_,
                .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM,
                .NS_OPTIONS, .ASSIGN, .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE,
                .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE,
                .IB_DESIGNABLE, .IDENTIFIER, .LP, .ADD, .SUB, .MUL:
                try enterOuterAlt(_localctx, 2)
                setState(534)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(533)
                        try interfaceDeclarationList()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(536)
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
            setState(540)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(541)
            try protocolList()
            setState(542)
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
            setState(544)
            try match(ObjectiveCParser.Tokens.CLASS.rawValue)
            setState(545)
            try className()
            setState(550)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(546)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(547)
                try className()

                setState(552)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(553)
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
            setState(555)
            try protocolName()
            setState(560)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(556)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(557)
                try protocolName()

                setState(562)
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
            setState(563)
            try match(ObjectiveCParser.Tokens.PROPERTY.rawValue)
            setState(568)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(564)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(565)
                try propertyAttributesList()
                setState(566)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

            }

            setState(571)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 31, _ctx) {
            case 1:
                setState(570)
                try ibOutletQualifier()

                break
            default: break
            }
            setState(574)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 32, _ctx) {
            case 1:
                setState(573)
                try match(ObjectiveCParser.Tokens.IB_INSPECTABLE.rawValue)

                break
            default: break
            }
            setState(576)
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
            setState(578)
            try propertyAttribute()
            setState(583)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(579)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(580)
                try propertyAttribute()

                setState(585)
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
            setState(605)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ATOMIC:
                try enterOuterAlt(_localctx, 1)
                setState(586)
                try match(ObjectiveCParser.Tokens.ATOMIC.rawValue)

                break

            case .NONATOMIC:
                try enterOuterAlt(_localctx, 2)
                setState(587)
                try match(ObjectiveCParser.Tokens.NONATOMIC.rawValue)

                break

            case .STRONG:
                try enterOuterAlt(_localctx, 3)
                setState(588)
                try match(ObjectiveCParser.Tokens.STRONG.rawValue)

                break

            case .WEAK:
                try enterOuterAlt(_localctx, 4)
                setState(589)
                try match(ObjectiveCParser.Tokens.WEAK.rawValue)

                break

            case .RETAIN:
                try enterOuterAlt(_localctx, 5)
                setState(590)
                try match(ObjectiveCParser.Tokens.RETAIN.rawValue)

                break

            case .ASSIGN:
                try enterOuterAlt(_localctx, 6)
                setState(591)
                try match(ObjectiveCParser.Tokens.ASSIGN.rawValue)

                break

            case .UNSAFE_UNRETAINED:
                try enterOuterAlt(_localctx, 7)
                setState(592)
                try match(ObjectiveCParser.Tokens.UNSAFE_UNRETAINED.rawValue)

                break

            case .COPY:
                try enterOuterAlt(_localctx, 8)
                setState(593)
                try match(ObjectiveCParser.Tokens.COPY.rawValue)

                break

            case .READONLY:
                try enterOuterAlt(_localctx, 9)
                setState(594)
                try match(ObjectiveCParser.Tokens.READONLY.rawValue)

                break

            case .READWRITE:
                try enterOuterAlt(_localctx, 10)
                setState(595)
                try match(ObjectiveCParser.Tokens.READWRITE.rawValue)

                break

            case .GETTER:
                try enterOuterAlt(_localctx, 11)
                setState(596)
                try match(ObjectiveCParser.Tokens.GETTER.rawValue)
                setState(597)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(598)
                try identifier()

                break

            case .SETTER:
                try enterOuterAlt(_localctx, 12)
                setState(599)
                try match(ObjectiveCParser.Tokens.SETTER.rawValue)
                setState(600)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(601)
                try identifier()
                setState(602)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break
            case .NULL_UNSPECIFIED, .NULLABLE, .NONNULL, .NULL_RESETTABLE:
                try enterOuterAlt(_localctx, 13)
                setState(604)
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
            setState(615)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LT:
                try enterOuterAlt(_localctx, 1)
                setState(607)
                try match(ObjectiveCParser.Tokens.LT.rawValue)
                setState(608)
                try protocolList()
                setState(609)
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
                setState(612)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 35, _ctx) {
                case 1:
                    setState(611)
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
                setState(614)
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
            setState(617)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(621)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 70)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 70)) & -563_942_359_310_231) != 0
                || (Int64((_la - 134)) & ~0x3f) == 0 && ((Int64(1) << (_la - 134)) & 4159) != 0
            {
                setState(618)
                try visibilitySection()

                setState(623)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(624)
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
            setState(638)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .PACKAGE, .PRIVATE, .PROTECTED, .PUBLIC:
                try enterOuterAlt(_localctx, 1)
                setState(626)
                try accessModifier()
                setState(630)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 38, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(627)
                        try fieldDeclaration()

                    }
                    setState(632)
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
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 2)
                setState(634)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(633)
                        try fieldDeclaration()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(636)
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
            setState(640)
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
            setState(647)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(647)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 41, _ctx) {
                    case 1:
                        setState(642)
                        try declaration()

                        break
                    case 2:
                        setState(643)
                        try classMethodDeclaration()

                        break
                    case 3:
                        setState(644)
                        try instanceMethodDeclaration()

                        break
                    case 4:
                        setState(645)
                        try propertyDeclaration()

                        break
                    case 5:
                        setState(646)
                        try functionDeclaration()

                        break
                    default: break
                    }

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(649)
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
            setState(651)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(652)
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
            setState(654)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(655)
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
            setState(658)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(657)
                try methodType()

            }

            setState(660)
            try methodSelector()
            setState(664)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(661)
                try attributeSpecifier()

                setState(666)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(668)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(667)
                try macro()

            }

            setState(670)
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
            setState(677)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(677)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 46, _ctx) {
                case 1:
                    setState(672)
                    try functionDefinition()

                    break
                case 2:
                    setState(673)
                    try declaration()

                    break
                case 3:
                    setState(674)
                    try classMethodDefinition()

                    break
                case 4:
                    setState(675)
                    try instanceMethodDefinition()

                    break
                case 5:
                    setState(676)
                    try propertyImplementation()

                    break
                default: break
                }

                setState(679)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0
                && ((Int64(1) << _la) & -8_654_794_525_530_768_846) != 0
                || (Int64((_la - 80)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 80)) & 1_152_921_504_602_390_521) != 0
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
            setState(681)
            try match(ObjectiveCParser.Tokens.ADD.rawValue)
            setState(682)
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
            setState(684)
            try match(ObjectiveCParser.Tokens.SUB.rawValue)
            setState(685)
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
            setState(688)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(687)
                try methodType()

            }

            setState(690)
            try methodSelector()
            setState(692)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
                || _la == ObjectiveCParser.Tokens.MUL.rawValue
            {
                setState(691)
                try initDeclaratorList()

            }

            setState(695)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(694)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

            }

            setState(698)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(697)
                try attributeSpecifier()

            }

            setState(700)
            try compoundStatement()
            setState(702)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.SEMI.rawValue {
                setState(701)
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
            setState(714)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 55, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(704)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(706)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(705)
                        try keywordDeclarator()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(708)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 53, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER
                setState(712)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(710)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(711)
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
            setState(717)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(716)
                try selector()

            }

            setState(719)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(723)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(720)
                try methodType()

                setState(725)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(727)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 58, _ctx) {
            case 1:
                setState(726)
                try arcBehaviourSpecifier()

                break
            default: break
            }
            setState(729)
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
            setState(737)
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
                setState(731)
                try identifier()

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 2)
                setState(732)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)

                break

            case .SWITCH:
                try enterOuterAlt(_localctx, 3)
                setState(733)
                try match(ObjectiveCParser.Tokens.SWITCH.rawValue)

                break

            case .IF:
                try enterOuterAlt(_localctx, 4)
                setState(734)
                try match(ObjectiveCParser.Tokens.IF.rawValue)

                break

            case .ELSE:
                try enterOuterAlt(_localctx, 5)
                setState(735)
                try match(ObjectiveCParser.Tokens.ELSE.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 6)
                setState(736)
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
            setState(739)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(740)
            try typeName()
            setState(741)
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
            setState(751)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .SYNTHESIZE:
                try enterOuterAlt(_localctx, 1)
                setState(743)
                try match(ObjectiveCParser.Tokens.SYNTHESIZE.rawValue)
                setState(744)
                try propertySynthesizeList()
                setState(745)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .DYNAMIC:
                try enterOuterAlt(_localctx, 2)
                setState(747)
                try match(ObjectiveCParser.Tokens.DYNAMIC.rawValue)
                setState(748)
                try propertySynthesizeList()
                setState(749)
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
            setState(753)
            try propertySynthesizeItem()
            setState(758)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(754)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(755)
                try propertySynthesizeItem()

                setState(760)
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
            setState(761)
            try identifier()
            setState(764)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(762)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(763)
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
            setState(767)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 63, _ctx) {
            case 1:
                setState(766)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(769)
            try typeSpecifier()
            setState(771)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                setState(770)
                try nullabilitySpecifier()

            }

            setState(773)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(774)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(777)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 65, _ctx) {
            case 1:
                setState(775)
                try nullabilitySpecifier()

                break
            case 2:
                setState(776)
                try typeSpecifier()

                break
            default: break
            }
            setState(779)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(781)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(780)
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
            setState(783)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(784)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(796)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(785)
                try dictionaryPair()
                setState(790)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 67, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(786)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(787)
                        try dictionaryPair()

                    }
                    setState(792)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 67, _ctx)
                }
                setState(794)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(793)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(798)
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
            setState(800)
            try castExpression()
            setState(801)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(802)
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
            setState(804)
            try match(ObjectiveCParser.Tokens.AT.rawValue)
            setState(805)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(810)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(806)
                try expressions()
                setState(808)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(807)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(812)
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
            setState(824)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 73, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(814)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(815)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(816)
                try expression(0)
                setState(817)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(819)
                try match(ObjectiveCParser.Tokens.AT.rawValue)
                setState(822)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                    .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                    .FLOATING_POINT_LITERAL:
                    setState(820)
                    try constant()

                    break
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                    .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                    .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                    .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                    setState(821)
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
            setState(842)
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
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(826)
                try typeVariableDeclaratorOrName()

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(827)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(839)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                {
                    setState(830)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 74, _ctx) {
                    case 1:
                        setState(828)
                        try typeVariableDeclaratorOrName()

                        break
                    case 2:
                        setState(829)
                        try match(ObjectiveCParser.Tokens.VOID.rawValue)

                        break
                    default: break
                    }
                    setState(836)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                        setState(832)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(833)
                        try typeVariableDeclaratorOrName()

                        setState(838)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }

                }

                setState(841)
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
            setState(846)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 78, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(844)
                try typeVariableDeclarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(845)
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
            setState(848)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(850)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 79, _ctx) {
            case 1:
                setState(849)
                try typeSpecifier()

                break
            default: break
            }
            setState(853)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 80, _ctx) {
            case 1:
                setState(852)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(856)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(855)
                try blockParameters()

            }

            setState(858)
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
            setState(860)
            try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
            setState(862)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                || _la == ObjectiveCParser.Tokens.LP.rawValue
            {
                setState(861)
                try blockParameters()

            }

            setState(864)
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
            setState(866)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(867)
            try receiver()
            setState(868)
            try messageSelector()
            setState(869)
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
            setState(873)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 83, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(871)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(872)
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
            setState(881)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 85, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(875)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(877)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(876)
                    try keywordArgument()

                    setState(879)
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
            setState(884)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(883)
                try selector()

            }

            setState(886)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(887)
            try keywordArgumentType()
            setState(892)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(888)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(889)
                try keywordArgumentType()

                setState(894)
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
            setState(895)
            try expressions()
            setState(897)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 88, _ctx) {
            case 1:
                setState(896)
                try nullabilitySpecifier()

                break
            default: break
            }
            setState(903)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue {
                setState(899)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(900)
                try initializerList()
                setState(901)
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
            setState(905)
            try match(ObjectiveCParser.Tokens.SELECTOR.rawValue)
            setState(906)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(907)
            try selectorName()
            setState(908)
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
            setState(919)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 92, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(910)
                try selector()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(915)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(912)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_055_181_710_464) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    {
                        setState(911)
                        try selector()

                    }

                    setState(914)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)

                    setState(917)
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
            setState(921)
            try match(ObjectiveCParser.Tokens.PROTOCOL.rawValue)
            setState(922)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(923)
            try protocolName()
            setState(924)
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
            setState(926)
            try match(ObjectiveCParser.Tokens.ENCODE.rawValue)
            setState(927)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(928)
            try typeName()
            setState(929)
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
            setState(931)
            try declarationSpecifiers()
            setState(932)
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
            setState(941)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 93, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(934)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(935)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(936)
                try identifier()
                setState(937)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(939)
                try match(ObjectiveCParser.Tokens.THROW.rawValue)
                setState(940)
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
            setState(943)
            try match(ObjectiveCParser.Tokens.TRY.rawValue)
            setState(944)
            try {
                let assignmentValue = try compoundStatement()
                _localctx.castdown(TryBlockContext.self).tryStatement = assignmentValue
            }()

            setState(948)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CATCH.rawValue {
                setState(945)
                try catchStatement()

                setState(950)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(953)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.FINALLY.rawValue {
                setState(951)
                try match(ObjectiveCParser.Tokens.FINALLY.rawValue)
                setState(952)
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
            setState(955)
            try match(ObjectiveCParser.Tokens.CATCH.rawValue)
            setState(956)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(957)
            try typeVariableDeclarator()
            setState(958)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(959)
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
            setState(961)
            try match(ObjectiveCParser.Tokens.SYNCHRONIZED.rawValue)
            setState(962)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(963)
            try expression(0)
            setState(964)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(965)
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
            setState(967)
            try match(ObjectiveCParser.Tokens.AUTORELEASEPOOL.rawValue)
            setState(968)
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
            setState(970)
            try functionSignature()
            setState(971)
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
            setState(973)
            try functionSignature()
            setState(974)
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
            setState(977)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 96, _ctx) {
            case 1:
                setState(976)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(979)
            try declarator()
            setState(981)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_848_900_063_233) != 0
            {
                setState(980)
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
            setState(984)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(983)
                try declaration()

                setState(986)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_848_900_063_233) != 0

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
            setState(988)
            try attributeName()
            setState(990)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(989)
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
            setState(994)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(992)
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
                setState(993)
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
            setState(996)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(998)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_568) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 100_139_011) != 0
            {
                setState(997)
                try attributeParameterList()

            }

            setState(1000)
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
            setState(1002)
            try attributeParameter()
            setState(1007)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1003)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1004)
                try attributeParameter()

                setState(1009)
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
            setState(1014)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 103, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1010)
                try attribute()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1011)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1012)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1013)
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
            setState(1016)
            try attributeName()
            setState(1017)
            try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
            setState(1021)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                setState(1018)
                try constant()

                break
            case .CONST, .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                setState(1019)
                try attributeName()

                break

            case .STRING_START:
                setState(1020)
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
            setState(1023)
            try declarationSpecifiers()
            setState(1024)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1025)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1027)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(1026)
                try identifier()

            }

            setState(1029)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1030)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1032)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
            {
                setState(1031)
                try functionPointerParameterList()

            }

            setState(1034)
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
            setState(1036)
            try functionPointerParameterDeclarationList()
            setState(1039)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1037)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1038)
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
            setState(1041)
            try functionPointerParameterDeclaration()
            setState(1046)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 108, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1042)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1043)
                    try functionPointerParameterDeclaration()

                }
                setState(1048)
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
            setState(1057)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 111, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1051)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 109, _ctx) {
                case 1:
                    setState(1049)
                    try declarationSpecifiers()

                    break
                case 2:
                    setState(1050)
                    try functionPointer()

                    break
                default: break
                }
                setState(1054)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1053)
                    try declarator()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1056)
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
            setState(1060)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1059)
                try attributeSpecifier()

            }

            setState(1062)
            try identifier()
            setState(1064)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1063)
                try attributeSpecifier()

            }

            setState(1066)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1067)
            try directDeclarator(0)
            setState(1068)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1069)
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
            setState(1072)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1071)
                try attributeSpecifier()

            }

            setState(1075)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.TYPEDEF.rawValue {
                setState(1074)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)

            }

            setState(1077)
            try enumSpecifier()
            setState(1079)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(1078)
                try identifier()

            }

            setState(1081)
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
            setState(1087)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 117, _ctx) {
            case 1:
                setState(1083)
                try declarationSpecifiers()
                setState(1084)
                try initDeclaratorList()

                break
            case 2:
                setState(1086)
                try declarationSpecifiers()

                break
            default: break
            }
            setState(1089)
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
            setState(1113)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 122, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1092)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1091)
                    try attributeSpecifier()

                }

                setState(1094)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1099)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 119, _ctx) {
                case 1:
                    setState(1095)
                    try declarationSpecifiers()
                    setState(1096)
                    try typeDeclaratorList()

                    break
                case 2:
                    setState(1098)
                    try declarationSpecifiers()

                    break
                default: break
                }
                setState(1102)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1101)
                    try macro()

                }

                setState(1104)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1107)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                    setState(1106)
                    try attributeSpecifier()

                }

                setState(1109)
                try match(ObjectiveCParser.Tokens.TYPEDEF.rawValue)
                setState(1110)
                try functionPointer()
                setState(1111)
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
            setState(1115)
            try declarator()
            setState(1120)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1116)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1117)
                try declarator()

                setState(1122)
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
            setState(1131)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1131)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 124, _ctx) {
                case 1:
                    setState(1123)
                    try storageClassSpecifier()

                    break
                case 2:
                    setState(1124)
                    try attributeSpecifier()

                    break
                case 3:
                    setState(1125)
                    try arcBehaviourSpecifier()

                    break
                case 4:
                    setState(1126)
                    try nullabilitySpecifier()

                    break
                case 5:
                    setState(1127)
                    try ibOutletQualifier()

                    break
                case 6:
                    setState(1128)
                    try typePrefix()

                    break
                case 7:
                    setState(1129)
                    try typeQualifier()

                    break
                case 8:
                    setState(1130)
                    try typeSpecifier()

                    break
                default: break
                }

                setState(1133)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_943_536_144_385) != 0

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
            setState(1143)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 126, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1135)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1136)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1137)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1138)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1139)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1140)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1141)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1142)
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
            setState(1153)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 127, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1145)
                try storageClassSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1146)
                try typeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1147)
                try typeQualifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1148)
                try functionSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1149)
                try alignmentSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1150)
                try arcBehaviourSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1151)
                try nullabilitySpecifier()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1152)
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
            setState(1156)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 128, _ctx) {
            case 1:
                setState(1155)
                try typePrefix()

                break
            default: break
            }
            setState(1159)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1158)
                    try declarationSpecifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1161)
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
        try enterRule(_localctx, 176, ObjectiveCParser.RULE_declaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1170)
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
                .COPY, .GETTER, .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED,
                .IB_OUTLET, .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                try enterOuterAlt(_localctx, 1)
                setState(1163)
                try declarationSpecifiers()
                setState(1165)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1164)
                    try initDeclaratorList()

                }

                setState(1167)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break

            case .STATIC_ASSERT_:
                try enterOuterAlt(_localctx, 2)
                setState(1169)
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
        try enterRule(_localctx, 178, ObjectiveCParser.RULE_initDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1172)
            try initDeclarator()
            setState(1177)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1173)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1174)
                try initDeclarator()

                setState(1179)
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
        try enterRule(_localctx, 180, ObjectiveCParser.RULE_initDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1180)
            try declarator()
            setState(1183)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1181)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1182)
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
        try enterRule(_localctx, 182, ObjectiveCParser.RULE_declarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1186)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1185)
                try pointer()

            }

            setState(1188)
            try directDeclarator(0)
            setState(1192)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 135, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1189)
                    try gccDeclaratorExtension()

                }
                setState(1194)
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
        let _startState: Int = 184
        try enterRecursionRule(_localctx, 184, ObjectiveCParser.RULE_directDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1223)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 138, _ctx) {
            case 1:
                setState(1196)
                try identifier()

                break
            case 2:
                setState(1197)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1198)
                try declarator()
                setState(1199)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                setState(1201)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1202)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1204)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 136, _ctx) {
                case 1:
                    setState(1203)
                    try nullabilitySpecifier()

                    break
                default: break
                }
                setState(1207)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 42)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 42)) & -2_008_836_331_248_944_897) != 0
                    || (Int64((_la - 107)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 107)) & 1_657_857_368_071) != 0
                {
                    setState(1206)
                    try directDeclarator(0)

                }

                setState(1209)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1210)
                try blockParameters()

                break
            case 4:
                setState(1211)
                try identifier()
                setState(1212)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1213)
                try match(ObjectiveCParser.Tokens.DIGITS.rawValue)

                break
            case 5:
                setState(1215)
                try vcSpecificModifer()
                setState(1216)
                try identifier()

                break
            case 6:
                setState(1218)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1219)
                try vcSpecificModifer()
                setState(1220)
                try declarator()
                setState(1221)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1265)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 145, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1263)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 144, _ctx) {
                    case 1:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1225)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(1226)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1228)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 139, _ctx) {
                        case 1:
                            setState(1227)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1231)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 39)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                            || (Int64((_la - 120)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                            || (Int64((_la - 192)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 192)) & 191) != 0
                        {
                            setState(1230)
                            try primaryExpression()

                        }

                        setState(1233)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1234)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(1235)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1236)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1238)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 141, _ctx) {
                        case 1:
                            setState(1237)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1240)
                        try primaryExpression()
                        setState(1241)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1243)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(1244)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1245)
                        try typeQualifierList()
                        setState(1246)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1247)
                        try primaryExpression()
                        setState(1248)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1250)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1251)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1253)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 27_918_807_844_519_968) != 0
                            || _la == ObjectiveCParser.Tokens.ATOMIC_.rawValue
                        {
                            setState(1252)
                            try typeQualifierList()

                        }

                        setState(1255)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1256)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directDeclarator)
                        setState(1257)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1258)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1260)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                        {
                            setState(1259)
                            try parameterTypeList()

                        }

                        setState(1262)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)

                        break
                    default: break
                    }
                }
                setState(1267)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 145, _ctx)
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
        try enterRule(_localctx, 186, ObjectiveCParser.RULE_typeName)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1268)
            try declarationSpecifiers()
            setState(1270)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 146, _ctx) {
            case 1:
                setState(1269)
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
        try enterRule(_localctx, 188, ObjectiveCParser.RULE_abstractDeclarator_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1295)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .MUL:
                try enterOuterAlt(_localctx, 1)
                setState(1272)
                try pointer()
                setState(1274)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 147, _ctx) {
                case 1:
                    setState(1273)
                    try abstractDeclarator_()

                    break
                default: break
                }

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1276)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1278)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1277)
                    try abstractDeclarator()

                }

                setState(1280)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1282)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1281)
                        try abstractDeclaratorSuffix_()

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1284)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 149, _ctx)
                } while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER

                break

            case .LBRACK:
                try enterOuterAlt(_localctx, 3)
                setState(1291)
                try _errHandler.sync(self)
                _alt = 1
                repeat {
                    switch _alt {
                    case 1:
                        setState(1286)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1288)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                            || (Int64((_la - 173)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                        {
                            setState(1287)
                            try constantExpression()

                        }

                        setState(1290)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    default: throw ANTLRException.recognition(e: NoViableAltException(self))
                    }
                    setState(1293)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 151, _ctx)
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
        try enterRule(_localctx, 190, ObjectiveCParser.RULE_abstractDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            setState(1308)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 155, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1297)
                try pointer()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1299)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1298)
                    try pointer()

                }

                setState(1301)
                try directAbstractDeclarator(0)
                setState(1305)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 154, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1302)
                        try gccDeclaratorExtension()

                    }
                    setState(1307)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 154, _ctx)
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
        let _startState: Int = 192
        try enterRecursionRule(_localctx, 192, ObjectiveCParser.RULE_directAbstractDeclarator, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1363)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 163, _ctx) {
            case 1:
                setState(1311)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1312)
                try abstractDeclarator()
                setState(1313)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1317)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 156, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1314)
                        try gccDeclaratorExtension()

                    }
                    setState(1319)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 156, _ctx)
                }

                break
            case 2:
                setState(1320)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1322)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 157, _ctx) {
                case 1:
                    setState(1321)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1325)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 39)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                    || (Int64((_la - 120)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 191) != 0
                {
                    setState(1324)
                    try primaryExpression()

                }

                setState(1327)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 3:
                setState(1328)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1329)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1331)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 159, _ctx) {
                case 1:
                    setState(1330)
                    try typeQualifierList()

                    break
                default: break
                }
                setState(1333)
                try primaryExpression()
                setState(1334)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 4:
                setState(1336)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1337)
                try typeQualifierList()
                setState(1338)
                try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                setState(1339)
                try primaryExpression()
                setState(1340)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 5:
                setState(1342)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1343)
                try match(ObjectiveCParser.Tokens.MUL.rawValue)
                setState(1344)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break
            case 6:
                setState(1345)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1347)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                {
                    setState(1346)
                    try parameterTypeList()

                }

                setState(1349)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1353)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 161, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1350)
                        try gccDeclaratorExtension()

                    }
                    setState(1355)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 161, _ctx)
                }

                break
            case 7:
                setState(1356)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1357)
                try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                setState(1359)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 120)) & ~0x3f) == 0 && ((Int64(1) << (_la - 120)) & 15) != 0 {
                    setState(1358)
                    try nullabilitySpecifier()

                }

                setState(1361)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1362)
                try blockParameters()

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(1408)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 170, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(1406)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 169, _ctx) {
                    case 1:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1365)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(1366)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1368)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 164, _ctx) {
                        case 1:
                            setState(1367)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1371)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 39)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 39)) & 2_376_053_977_803_390_971) != 0
                            || (Int64((_la - 120)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 120)) & 603_482_489_856_458_751) != 0
                            || (Int64((_la - 192)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 192)) & 191) != 0
                        {
                            setState(1370)
                            try primaryExpression()

                        }

                        setState(1373)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 2:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1374)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(1375)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1376)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1378)
                        try _errHandler.sync(self)
                        switch try getInterpreter().adaptivePredict(_input, 166, _ctx) {
                        case 1:
                            setState(1377)
                            try typeQualifierList()

                            break
                        default: break
                        }
                        setState(1380)
                        try primaryExpression()
                        setState(1381)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 3:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1383)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(1384)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1385)
                        try typeQualifierList()
                        setState(1386)
                        try match(ObjectiveCParser.Tokens.STATIC.rawValue)
                        setState(1387)
                        try primaryExpression()
                        setState(1388)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 4:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1390)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(1391)
                        try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                        setState(1392)
                        try match(ObjectiveCParser.Tokens.MUL.rawValue)
                        setState(1393)
                        try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                        break
                    case 5:
                        _localctx = DirectAbstractDeclaratorContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_directAbstractDeclarator)
                        setState(1394)
                        if !(precpred(_ctx, 2)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 2)"))
                        }
                        setState(1395)
                        try match(ObjectiveCParser.Tokens.LP.rawValue)
                        setState(1397)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64(_la) & ~0x3f) == 0
                            && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                            || (Int64((_la - 83)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                        {
                            setState(1396)
                            try parameterTypeList()

                        }

                        setState(1399)
                        try match(ObjectiveCParser.Tokens.RP.rawValue)
                        setState(1403)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 168, _ctx)
                        while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                            if _alt == 1 {
                                setState(1400)
                                try gccDeclaratorExtension()

                            }
                            setState(1405)
                            try _errHandler.sync(self)
                            _alt = try getInterpreter().adaptivePredict(_input, 168, _ctx)
                        }

                        break
                    default: break
                    }
                }
                setState(1410)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 170, _ctx)
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
        try enterRule(_localctx, 194, ObjectiveCParser.RULE_abstractDeclaratorSuffix_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1421)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(1411)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(1413)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    || (Int64((_la - 173)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
                {
                    setState(1412)
                    try constantExpression()

                }

                setState(1415)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(1416)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1418)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                {
                    setState(1417)
                    try parameterDeclarationList_()

                }

                setState(1420)
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
        try enterRule(_localctx, 196, ObjectiveCParser.RULE_parameterTypeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1423)
            try parameterList()
            setState(1426)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1424)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1425)
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
        try enterRule(_localctx, 198, ObjectiveCParser.RULE_parameterList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1428)
            try parameterDeclaration()
            setState(1433)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 175, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1429)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1430)
                    try parameterDeclaration()

                }
                setState(1435)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 175, _ctx)
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
        try enterRule(_localctx, 200, ObjectiveCParser.RULE_parameterDeclarationList_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1436)
            try parameterDeclaration()
            setState(1441)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1437)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1438)
                try parameterDeclaration()

                setState(1443)
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
        try enterRule(_localctx, 202, ObjectiveCParser.RULE_parameterDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1451)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 178, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1444)
                try declarationSpecifiers()
                setState(1445)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1447)
                try declarationSpecifiers()
                setState(1449)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 147)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 147)) & 268_435_473) != 0
                {
                    setState(1448)
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
        try enterRule(_localctx, 204, ObjectiveCParser.RULE_typeQualifierList)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1454)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1453)
                    try typeQualifier()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1456)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 179, _ctx)
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
        try enterRule(_localctx, 206, ObjectiveCParser.RULE_identifierList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1458)
            try identifier()
            setState(1463)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1459)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1460)
                try identifier()

                setState(1465)
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
        try enterRule(_localctx, 208, ObjectiveCParser.RULE_declaratorSuffix)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1466)
            try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
            setState(1468)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_918_755_827_777_536) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                || (Int64((_la - 173)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 173)) & 99_090_435) != 0
            {
                setState(1467)
                try constantExpression()

            }

            setState(1470)
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
        try enterRule(_localctx, 210, ObjectiveCParser.RULE_attributeSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1472)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1473)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1474)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1475)
            try attribute()
            setState(1480)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1476)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1477)
                try attribute()

                setState(1482)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1483)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1484)
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
        try enterRule(_localctx, 212, ObjectiveCParser.RULE_atomicTypeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1486)
            try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)
            setState(1487)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1488)
            try typeName()
            setState(1489)
            try match(ObjectiveCParser.Tokens.RP.rawValue)

        } catch ANTLRException.recognition(let re) {
            _localctx.exception = re
            _errHandler.reportError(self, re)
            try _errHandler.recover(self, re)
        }

        return _localctx
    }

    public class StructOrUnionSpecifier_Context: ParserRuleContext {
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
            return ObjectiveCParser.RULE_structOrUnionSpecifier_
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructOrUnionSpecifier_(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructOrUnionSpecifier_(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructOrUnionSpecifier_(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructOrUnionSpecifier_(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structOrUnionSpecifier_() throws -> StructOrUnionSpecifier_Context
    {
        var _localctx: StructOrUnionSpecifier_Context
        _localctx = StructOrUnionSpecifier_Context(_ctx, getState())
        try enterRule(_localctx, 214, ObjectiveCParser.RULE_structOrUnionSpecifier_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1491)
            _la = try _input.LA(1)
            if !(_la == ObjectiveCParser.Tokens.STRUCT.rawValue
                || _la == ObjectiveCParser.Tokens.UNION.rawValue)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1495)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.ATTRIBUTE.rawValue {
                setState(1492)
                try attributeSpecifier()

                setState(1497)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1510)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 186, _ctx) {
            case 1:
                setState(1498)
                try identifier()

                break
            case 2:
                setState(1500)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1499)
                    try identifier()

                }

                setState(1502)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1504)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1503)
                    try fieldDeclaration()

                    setState(1506)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0
                    && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
                setState(1508)
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
        try enterRule(_localctx, 216, ObjectiveCParser.RULE_structOrUnionSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1523)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 188, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1512)
                try structOrUnion()
                setState(1514)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                {
                    setState(1513)
                    try identifier()

                }

                setState(1516)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1517)
                try structDeclarationList()
                setState(1518)
                try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1520)
                try structOrUnion()
                setState(1521)
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
        try enterRule(_localctx, 218, ObjectiveCParser.RULE_structOrUnion)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1525)
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
        try enterRule(_localctx, 220, ObjectiveCParser.RULE_structDeclarationList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1528)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1527)
                try structDeclaration()

                setState(1530)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_311_695_587_888) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_909_176_746_089) != 0

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
        open func structDeclaratorList() -> StructDeclaratorListContext? {
            return getRuleContext(StructDeclaratorListContext.self, 0)
        }
        open func SEMI() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.SEMI.rawValue, 0)
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
        try enterRule(_localctx, 222, ObjectiveCParser.RULE_structDeclaration)
        defer { try! exitRule() }
        do {
            setState(1540)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 190, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1532)
                try specifierQualifierList()
                setState(1533)
                try structDeclaratorList()
                setState(1534)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1536)
                try specifierQualifierList()
                setState(1537)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1539)
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
        try enterRule(_localctx, 224, ObjectiveCParser.RULE_specifierQualifierList)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1544)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 191, _ctx) {
            case 1:
                setState(1542)
                try typeSpecifier()

                break
            case 2:
                setState(1543)
                try typeQualifier()

                break
            default: break
            }
            setState(1547)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 192, _ctx) {
            case 1:
                setState(1546)
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

    public class StructDeclaratorListContext: ParserRuleContext {
        open func structDeclarator() -> [StructDeclaratorContext] {
            return getRuleContexts(StructDeclaratorContext.self)
        }
        open func structDeclarator(_ i: Int) -> StructDeclaratorContext? {
            return getRuleContext(StructDeclaratorContext.self, i)
        }
        open func COMMA() -> [TerminalNode] {
            return getTokens(ObjectiveCParser.Tokens.COMMA.rawValue)
        }
        open func COMMA(_ i: Int) -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COMMA.rawValue, i)
        }
        override open func getRuleIndex() -> Int {
            return ObjectiveCParser.RULE_structDeclaratorList
        }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructDeclaratorList(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructDeclaratorList(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructDeclaratorList(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructDeclaratorList(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structDeclaratorList() throws -> StructDeclaratorListContext {
        var _localctx: StructDeclaratorListContext
        _localctx = StructDeclaratorListContext(_ctx, getState())
        try enterRule(_localctx, 226, ObjectiveCParser.RULE_structDeclaratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1549)
            try structDeclarator()
            setState(1554)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1550)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1551)
                try structDeclarator()

                setState(1556)
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

    public class StructDeclaratorContext: ParserRuleContext {
        open func declarator() -> DeclaratorContext? {
            return getRuleContext(DeclaratorContext.self, 0)
        }
        open func COLON() -> TerminalNode? {
            return getToken(ObjectiveCParser.Tokens.COLON.rawValue, 0)
        }
        open func constantExpression() -> ConstantExpressionContext? {
            return getRuleContext(ConstantExpressionContext.self, 0)
        }
        override open func getRuleIndex() -> Int { return ObjectiveCParser.RULE_structDeclarator }
        override open func enterRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.enterStructDeclarator(self)
            }
        }
        override open func exitRule(_ listener: ParseTreeListener) {
            if let listener = listener as? ObjectiveCParserListener {
                listener.exitStructDeclarator(self)
            }
        }
        override open func accept<T>(_ visitor: ParseTreeVisitor<T>) -> T? {
            if let visitor = visitor as? ObjectiveCParserVisitor {
                return visitor.visitStructDeclarator(self)
            } else if let visitor = visitor as? ObjectiveCParserBaseVisitor {
                return visitor.visitStructDeclarator(self)
            } else {
                return visitor.visitChildren(self)
            }
        }
    }
    @discardableResult open func structDeclarator() throws -> StructDeclaratorContext {
        var _localctx: StructDeclaratorContext
        _localctx = StructDeclaratorContext(_ctx, getState())
        try enterRule(_localctx, 228, ObjectiveCParser.RULE_structDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1563)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 195, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1557)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1559)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1558)
                    try declarator()

                }

                setState(1561)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1562)
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
        try enterRule(_localctx, 230, ObjectiveCParser.RULE_fieldDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1565)
            try declarationSpecifiers()
            setState(1566)
            try fieldDeclaratorList()
            setState(1568)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
            {
                setState(1567)
                try macro()

            }

            setState(1570)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)

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
            setState(1578)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IB_OUTLET_COLLECTION:
                try enterOuterAlt(_localctx, 1)
                setState(1572)
                try match(ObjectiveCParser.Tokens.IB_OUTLET_COLLECTION.rawValue)
                setState(1573)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1574)
                try identifier()
                setState(1575)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .IB_OUTLET:
                try enterOuterAlt(_localctx, 2)
                setState(1577)
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
            setState(1580)
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
            setState(1582)
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
            setState(1584)
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
            setState(1586)
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
            setState(1593)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CONST:
                try enterOuterAlt(_localctx, 1)
                setState(1588)
                try match(ObjectiveCParser.Tokens.CONST.rawValue)

                break

            case .VOLATILE:
                try enterOuterAlt(_localctx, 2)
                setState(1589)
                try match(ObjectiveCParser.Tokens.VOLATILE.rawValue)

                break

            case .RESTRICT:
                try enterOuterAlt(_localctx, 3)
                setState(1590)
                try match(ObjectiveCParser.Tokens.RESTRICT.rawValue)

                break

            case .ATOMIC_:
                try enterOuterAlt(_localctx, 4)
                setState(1591)
                try match(ObjectiveCParser.Tokens.ATOMIC_.rawValue)

                break
            case .BYCOPY, .BYREF, .IN, .INOUT, .ONEWAY, .OUT:
                try enterOuterAlt(_localctx, 5)
                setState(1592)
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
            setState(1602)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .INLINE, .STDCALL, .INLINE__, .NORETURN_:
                try enterOuterAlt(_localctx, 1)
                setState(1595)
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
                setState(1596)
                try gccAttributeSpecifier()

                break

            case .DECLSPEC:
                try enterOuterAlt(_localctx, 3)
                setState(1597)
                try match(ObjectiveCParser.Tokens.DECLSPEC.rawValue)
                setState(1598)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1599)
                try identifier()
                setState(1600)
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
            setState(1604)
            try match(ObjectiveCParser.Tokens.ALIGNAS_.rawValue)
            setState(1605)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1608)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 200, _ctx) {
            case 1:
                setState(1606)
                try typeName()

                break
            case 2:
                setState(1607)
                try constantExpression()

                break
            default: break
            }
            setState(1610)
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
            setState(1612)
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
            setState(1638)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 207, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1614)
                try scalarTypeSpecifier()
                setState(1616)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1615)
                    try pointer()

                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1618)
                try typeofTypeSpecifier()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1620)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1619)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1622)
                try genericTypeSpecifier()
                setState(1624)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1623)
                    try pointer()

                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1626)
                try structOrUnionSpecifier()
                setState(1628)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1627)
                    try pointer()

                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1630)
                try enumSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1632)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.KINDOF.rawValue {
                    setState(1631)
                    try match(ObjectiveCParser.Tokens.KINDOF.rawValue)

                }

                setState(1634)
                try identifier()
                setState(1636)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                    setState(1635)
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
            setState(1651)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 208, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1640)
                try scalarTypeSpecifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1641)
                try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)
                setState(1642)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1643)
                _la = try _input.LA(1)
                if !((Int64((_la - 112)) & ~0x3f) == 0 && ((Int64(1) << (_la - 112)) & 7) != 0) {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1644)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1645)
                try genericTypeSpecifier()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1646)
                try atomicTypeSpecifier()

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1647)
                try structOrUnionSpecifier()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1648)
                try enumSpecifier()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1649)
                try typedefName()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1650)
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
            setState(1653)
            try match(ObjectiveCParser.Tokens.TYPEOF.rawValue)

            setState(1654)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1655)
            try expression(0)
            setState(1656)
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
            setState(1658)
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
            setState(1660)
            try identifier()
            setState(1661)
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
            setState(1663)
            try match(ObjectiveCParser.Tokens.LT.rawValue)
            setState(1672)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
            {
                setState(1664)
                try genericTypeParameter()
                setState(1669)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1665)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1666)
                    try genericTypeParameter()

                    setState(1671)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                }

            }

            setState(1674)
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
            setState(1677)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 211, _ctx) {
            case 1:
                setState(1676)
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
            setState(1679)
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
            setState(1681)
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
            setState(1683)
            try fieldDeclarator()
            setState(1688)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1684)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1685)
                try fieldDeclarator()

                setState(1690)
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
        try enterRule(_localctx, 268, ObjectiveCParser.RULE_fieldDeclarator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1697)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 214, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1691)
                try declarator()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1693)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                    || (Int64((_la - 83)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 83)) & -9_079_256_986_092_957_801) != 0
                    || _la == ObjectiveCParser.Tokens.LP.rawValue
                    || _la == ObjectiveCParser.Tokens.MUL.rawValue
                {
                    setState(1692)
                    try declarator()

                }

                setState(1695)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)
                setState(1696)
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
        try enterRule(_localctx, 270, ObjectiveCParser.RULE_enumSpecifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1730)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ENUM:
                try enterOuterAlt(_localctx, 1)
                setState(1699)
                try match(ObjectiveCParser.Tokens.ENUM.rawValue)
                setState(1705)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 216, _ctx) {
                case 1:
                    setState(1701)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    if (Int64(_la) & ~0x3f) == 0
                        && ((Int64(1) << _la) & 568_575_054_909_014_016) != 0
                        || (Int64((_la - 83)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 83)) & -9_079_256_986_217_738_345) != 0
                    {
                        setState(1700)
                        try identifier()

                    }

                    setState(1703)
                    try match(ObjectiveCParser.Tokens.COLON.rawValue)
                    setState(1704)
                    try typeName()

                    break
                default: break
                }
                setState(1718)
                try _errHandler.sync(self)
                switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                case .BOOL, .Class, .BYCOPY, .BYREF, .ID, .IMP, .IN, .INOUT, .ONEWAY, .OUT,
                    .PROTOCOL_, .SEL, .SELF, .SUPER, .ATOMIC, .NONATOMIC, .RETAIN,
                    .AUTORELEASING_QUALIFIER, .BRIDGE_RETAINED, .BRIDGE_TRANSFER, .COVARIANT,
                    .CONTRAVARIANT, .DEPRECATED, .UNUSED, .NULL_UNSPECIFIED, .NULLABLE, .NONNULL,
                    .NULL_RESETTABLE, .NS_INLINE, .NS_ENUM, .NS_OPTIONS, .ASSIGN, .COPY, .GETTER,
                    .SETTER, .STRONG, .READONLY, .READWRITE, .WEAK, .UNSAFE_UNRETAINED, .IB_OUTLET,
                    .IB_OUTLET_COLLECTION, .IB_INSPECTABLE, .IB_DESIGNABLE, .IDENTIFIER:
                    setState(1707)
                    try identifier()
                    setState(1712)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 217, _ctx) {
                    case 1:
                        setState(1708)
                        try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                        setState(1709)
                        try enumeratorList()
                        setState(1710)
                        try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                        break
                    default: break
                    }

                    break

                case .LBRACE:
                    setState(1714)
                    try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                    setState(1715)
                    try enumeratorList()
                    setState(1716)
                    try match(ObjectiveCParser.Tokens.RBRACE.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }

                break
            case .NS_ENUM, .NS_OPTIONS:
                try enterOuterAlt(_localctx, 2)
                setState(1720)
                _la = try _input.LA(1)
                if !(_la == ObjectiveCParser.Tokens.NS_ENUM.rawValue
                    || _la == ObjectiveCParser.Tokens.NS_OPTIONS.rawValue)
                {
                    try _errHandler.recoverInline(self)
                } else {
                    _errHandler.reportMatch(self)
                    try consume()
                }
                setState(1721)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1722)
                try typeName()
                setState(1723)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1724)
                try identifier()
                setState(1725)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1726)
                try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
                setState(1727)
                try enumeratorList()
                setState(1728)
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
        try enterRule(_localctx, 272, ObjectiveCParser.RULE_enumeratorList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1732)
            try enumerator()
            setState(1737)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 220, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1733)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1734)
                    try enumerator()

                }
                setState(1739)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 220, _ctx)
            }
            setState(1741)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1740)
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
        try enterRule(_localctx, 274, ObjectiveCParser.RULE_enumerator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1743)
            try enumeratorIdentifier()
            setState(1746)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ASSIGNMENT.rawValue {
                setState(1744)
                try match(ObjectiveCParser.Tokens.ASSIGNMENT.rawValue)
                setState(1745)
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
        try enterRule(_localctx, 276, ObjectiveCParser.RULE_enumeratorIdentifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1748)
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
        try enterRule(_localctx, 278, ObjectiveCParser.RULE_vcSpecificModifer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1750)
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
        try enterRule(_localctx, 280, ObjectiveCParser.RULE_gccDeclaratorExtension)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(1762)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .ASM:
                try enterOuterAlt(_localctx, 1)
                setState(1752)
                try match(ObjectiveCParser.Tokens.ASM.rawValue)
                setState(1753)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1755)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1754)
                    try stringLiteral()

                    setState(1757)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
                setState(1759)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break

            case .ATTRIBUTE:
                try enterOuterAlt(_localctx, 2)
                setState(1761)
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
        try enterRule(_localctx, 282, ObjectiveCParser.RULE_gccAttributeSpecifier)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1764)
            try match(ObjectiveCParser.Tokens.ATTRIBUTE.rawValue)
            setState(1765)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1766)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1767)
            try gccAttributeList()
            setState(1768)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1769)
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
        try enterRule(_localctx, 284, ObjectiveCParser.RULE_gccAttributeList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1772)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
            {
                setState(1771)
                try gccAttribute()

            }

            setState(1780)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1774)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(1776)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -68_681_729) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                {
                    setState(1775)
                    try gccAttribute()

                }

                setState(1782)
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
        try enterRule(_localctx, 286, ObjectiveCParser.RULE_gccAttribute)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1783)
            _la = try _input.LA(1)
            if _la <= 0
                || ((Int64((_la - 147)) & ~0x3f) == 0 && ((Int64(1) << (_la - 147)) & 131) != 0)
            {
                try _errHandler.recoverInline(self)
            } else {
                _errHandler.reportMatch(self)
                try consume()
            }
            setState(1789)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1784)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1786)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(1785)
                    try argumentExpressionList()

                }

                setState(1788)
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
        try enterRule(_localctx, 288, ObjectiveCParser.RULE_pointer_)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1791)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)
            setState(1793)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 568_577_511_324_006_962) != 0
                || (Int64((_la - 83)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 83)) & -9_079_256_917_619_539_969) != 0
            {
                setState(1792)
                try declarationSpecifiers()

            }

            setState(1796)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.MUL.rawValue {
                setState(1795)
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
        try enterRule(_localctx, 290, ObjectiveCParser.RULE_pointer)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1799)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(1798)
                    try pointerEntry()

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(1801)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 232, _ctx)
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
        try enterRule(_localctx, 292, ObjectiveCParser.RULE_pointerEntry)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1803)
            try match(ObjectiveCParser.Tokens.MUL.rawValue)

            setState(1805)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 233, _ctx) {
            case 1:
                setState(1804)
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
        open var _tset3248: Token!
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
        try enterRule(_localctx, 294, ObjectiveCParser.RULE_macro)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1807)
            try identifier()
            setState(1816)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LP.rawValue {
                setState(1808)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1811)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                repeat {
                    setState(1811)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 234, _ctx) {
                    case 1:
                        setState(1809)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                        break
                    case 2:
                        setState(1810)
                        _localctx.castdown(MacroContext.self)._tset3248 = try _input.LT(1)
                        _la = try _input.LA(1)
                        if _la <= 0 || (_la == ObjectiveCParser.Tokens.RP.rawValue) {
                            _localctx.castdown(MacroContext.self)._tset3248 =
                                try _errHandler.recoverInline(self) as Token
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }
                        _localctx.castdown(MacroContext.self).macroArguments.append(
                            _localctx.castdown(MacroContext.self)._tset3248)

                        break
                    default: break
                    }

                    setState(1813)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                } while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & -2) != 0
                    || (Int64((_la - 64)) & ~0x3f) == 0 && ((Int64(1) << (_la - 64)) & -1) != 0
                    || (Int64((_la - 128)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 128)) & -1_048_577) != 0
                    || (Int64((_la - 192)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 192)) & 144_115_188_075_855_871) != 0
                setState(1815)
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
        try enterRule(_localctx, 296, ObjectiveCParser.RULE_arrayInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1818)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1830)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(1819)
                try expression(0)
                setState(1824)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 237, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1820)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1821)
                        try expression(0)

                    }
                    setState(1826)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 237, _ctx)
                }
                setState(1828)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1827)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1832)
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
        try enterRule(_localctx, 298, ObjectiveCParser.RULE_structInitializer)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1834)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1846)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.LBRACE.rawValue
                || _la == ObjectiveCParser.Tokens.DOT.rawValue
            {
                setState(1835)
                try structInitializerItem()
                setState(1840)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 240, _ctx)
                while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                    if _alt == 1 {
                        setState(1836)
                        try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                        setState(1837)
                        try structInitializerItem()

                    }
                    setState(1842)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 240, _ctx)
                }
                setState(1844)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                    setState(1843)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)

                }

            }

            setState(1848)
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
        try enterRule(_localctx, 300, ObjectiveCParser.RULE_structInitializerItem)
        defer { try! exitRule() }
        do {
            setState(1854)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 243, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1850)
                try match(ObjectiveCParser.Tokens.DOT.rawValue)
                setState(1851)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1852)
                try structInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1853)
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
        try enterRule(_localctx, 302, ObjectiveCParser.RULE_initializerList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(1856)
            try initializer()
            setState(1861)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 244, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(1857)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(1858)
                    try initializer()

                }
                setState(1863)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 244, _ctx)
            }
            setState(1865)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(1864)
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
        try enterRule(_localctx, 304, ObjectiveCParser.RULE_staticAssertDeclaration)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1867)
            try match(ObjectiveCParser.Tokens.STATIC_ASSERT_.rawValue)
            setState(1868)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1869)
            try constantExpression()
            setState(1870)
            try match(ObjectiveCParser.Tokens.COMMA.rawValue)
            setState(1872)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1871)
                try stringLiteral()

                setState(1874)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.STRING_START.rawValue
            setState(1876)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1877)
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
        try enterRule(_localctx, 306, ObjectiveCParser.RULE_statement)
        defer { try! exitRule() }
        do {
            setState(1917)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 254, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1879)
                try labeledStatement()
                setState(1881)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 247, _ctx) {
                case 1:
                    setState(1880)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1883)
                try compoundStatement()
                setState(1885)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 248, _ctx) {
                case 1:
                    setState(1884)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1887)
                try selectionStatement()
                setState(1889)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 249, _ctx) {
                case 1:
                    setState(1888)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1891)
                try iterationStatement()
                setState(1893)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 250, _ctx) {
                case 1:
                    setState(1892)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(1895)
                try jumpStatement()
                setState(1896)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(1898)
                try synchronizedStatement()
                setState(1900)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 251, _ctx) {
                case 1:
                    setState(1899)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(1902)
                try autoreleaseStatement()
                setState(1904)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 252, _ctx) {
                case 1:
                    setState(1903)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(1906)
                try throwStatement()
                setState(1907)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(1909)
                try tryBlock()
                setState(1911)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 253, _ctx) {
                case 1:
                    setState(1910)
                    try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                    break
                default: break
                }

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(1913)
                try expressions()
                setState(1914)
                try match(ObjectiveCParser.Tokens.SEMI.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(1916)
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
        try enterRule(_localctx, 308, ObjectiveCParser.RULE_labeledStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1919)
            try identifier()
            setState(1920)
            try match(ObjectiveCParser.Tokens.COLON.rawValue)
            setState(1921)
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
        try enterRule(_localctx, 310, ObjectiveCParser.RULE_rangeExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1923)
            try expression(0)
            setState(1926)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if _la == ObjectiveCParser.Tokens.ELIPSIS.rawValue {
                setState(1924)
                try match(ObjectiveCParser.Tokens.ELIPSIS.rawValue)
                setState(1925)
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
        try enterRule(_localctx, 312, ObjectiveCParser.RULE_compoundStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1928)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1933)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 2_305_842_734_335_785_846) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -63_513_976_455_039) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 3_087_455_002_300_415) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 255) != 0
            {
                setState(1931)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 256, _ctx) {
                case 1:
                    setState(1929)
                    try statement()

                    break
                case 2:
                    setState(1930)
                    try declaration()

                    break
                default: break
                }

                setState(1935)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1936)
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
        try enterRule(_localctx, 314, ObjectiveCParser.RULE_selectionStatement)
        defer { try! exitRule() }
        do {
            setState(1948)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .IF:
                try enterOuterAlt(_localctx, 1)
                setState(1938)
                try match(ObjectiveCParser.Tokens.IF.rawValue)
                setState(1939)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(1940)
                try expressions()
                setState(1941)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(1942)
                try {
                    let assignmentValue = try statement()
                    _localctx.castdown(SelectionStatementContext.self).ifBody = assignmentValue
                }()

                setState(1945)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 258, _ctx) {
                case 1:
                    setState(1943)
                    try match(ObjectiveCParser.Tokens.ELSE.rawValue)
                    setState(1944)
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
                setState(1947)
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
        try enterRule(_localctx, 316, ObjectiveCParser.RULE_switchStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1950)
            try match(ObjectiveCParser.Tokens.SWITCH.rawValue)
            setState(1951)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1952)
            try expression(0)
            setState(1953)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1954)
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
        try enterRule(_localctx, 318, ObjectiveCParser.RULE_switchBlock)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1956)
            try match(ObjectiveCParser.Tokens.LBRACE.rawValue)
            setState(1960)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            {
                setState(1957)
                try switchSection()

                setState(1962)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            }
            setState(1963)
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
        try enterRule(_localctx, 320, ObjectiveCParser.RULE_switchSection)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1966)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1965)
                try switchLabel()

                setState(1968)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
            } while _la == ObjectiveCParser.Tokens.CASE.rawValue
                || _la == ObjectiveCParser.Tokens.DEFAULT.rawValue
            setState(1971)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            repeat {
                setState(1970)
                try statement()

                setState(1973)
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
        try enterRule(_localctx, 322, ObjectiveCParser.RULE_switchLabel)
        defer { try! exitRule() }
        do {
            setState(1987)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .CASE:
                try enterOuterAlt(_localctx, 1)
                setState(1975)
                try match(ObjectiveCParser.Tokens.CASE.rawValue)
                setState(1981)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 263, _ctx) {
                case 1:
                    setState(1976)
                    try rangeExpression()

                    break
                case 2:
                    setState(1977)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(1978)
                    try rangeExpression()
                    setState(1979)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }
                setState(1983)
                try match(ObjectiveCParser.Tokens.COLON.rawValue)

                break

            case .DEFAULT:
                try enterOuterAlt(_localctx, 2)
                setState(1985)
                try match(ObjectiveCParser.Tokens.DEFAULT.rawValue)
                setState(1986)
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
        try enterRule(_localctx, 324, ObjectiveCParser.RULE_iterationStatement)
        defer { try! exitRule() }
        do {
            setState(1993)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 265, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(1989)
                try whileStatement()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(1990)
                try doStatement()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(1991)
                try forStatement()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(1992)
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
        try enterRule(_localctx, 326, ObjectiveCParser.RULE_whileStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(1995)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(1996)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(1997)
            try expression(0)
            setState(1998)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(1999)
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
        try enterRule(_localctx, 328, ObjectiveCParser.RULE_doStatement)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2001)
            try match(ObjectiveCParser.Tokens.DO.rawValue)
            setState(2002)
            try statement()
            setState(2003)
            try match(ObjectiveCParser.Tokens.WHILE.rawValue)
            setState(2004)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(2005)
            try expression(0)
            setState(2006)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(2007)
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
        try enterRule(_localctx, 330, ObjectiveCParser.RULE_forStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2009)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(2010)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(2012)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64(_la) & ~0x3f) == 0 && ((Int64(1) << _la) & 1_152_921_212_276_324_914) != 0
                || (Int64((_la - 64)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 64)) & -36_092_310_995_844_991) != 0
                || (Int64((_la - 128)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 128)) & 3_087_454_966_648_831) != 0
                || (Int64((_la - 192)) & ~0x3f) == 0 && ((Int64(1) << (_la - 192)) & 255) != 0
            {
                setState(2011)
                try forLoopInitializer()

            }

            setState(2014)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(2016)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(2015)
                try expression(0)

            }

            setState(2018)
            try match(ObjectiveCParser.Tokens.SEMI.rawValue)
            setState(2020)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(2019)
                try expressions()

            }

            setState(2022)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(2023)
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
        try enterRule(_localctx, 332, ObjectiveCParser.RULE_forLoopInitializer)
        defer { try! exitRule() }
        do {
            setState(2029)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 269, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2025)
                try declarationSpecifiers()
                setState(2026)
                try initDeclaratorList()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2028)
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
        try enterRule(_localctx, 334, ObjectiveCParser.RULE_forInStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2031)
            try match(ObjectiveCParser.Tokens.FOR.rawValue)
            setState(2032)
            try match(ObjectiveCParser.Tokens.LP.rawValue)
            setState(2033)
            try typeVariableDeclarator()
            setState(2034)
            try match(ObjectiveCParser.Tokens.IN.rawValue)
            setState(2036)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            if (Int64((_la - 25)) & ~0x3f) == 0
                && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                || (Int64((_la - 90)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                || (Int64((_la - 157)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
            {
                setState(2035)
                try expression(0)

            }

            setState(2038)
            try match(ObjectiveCParser.Tokens.RP.rawValue)
            setState(2039)
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
        try enterRule(_localctx, 336, ObjectiveCParser.RULE_jumpStatement)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2049)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .GOTO:
                try enterOuterAlt(_localctx, 1)
                setState(2041)
                try match(ObjectiveCParser.Tokens.GOTO.rawValue)
                setState(2042)
                try identifier()

                break

            case .CONTINUE:
                try enterOuterAlt(_localctx, 2)
                setState(2043)
                try match(ObjectiveCParser.Tokens.CONTINUE.rawValue)

                break

            case .BREAK:
                try enterOuterAlt(_localctx, 3)
                setState(2044)
                try match(ObjectiveCParser.Tokens.BREAK.rawValue)

                break

            case .RETURN:
                try enterOuterAlt(_localctx, 4)
                setState(2045)
                try match(ObjectiveCParser.Tokens.RETURN.rawValue)
                setState(2047)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(2046)
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
        try enterRule(_localctx, 338, ObjectiveCParser.RULE_expressions)
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2051)
            try expression(0)
            setState(2056)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 273, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2052)
                    try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                    setState(2053)
                    try expression(0)

                }
                setState(2058)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 273, _ctx)
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
        let _startState: Int = 340
        try enterRecursionRule(_localctx, 340, ObjectiveCParser.RULE_expression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2066)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 274, _ctx) {
            case 1:
                setState(2060)
                try castExpression()

                break
            case 2:
                setState(2061)
                try assignmentExpression()

                break
            case 3:
                setState(2062)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2063)
                try compoundStatement()
                setState(2064)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            default: break
            }
            _ctx!.stop = try _input.LT(-1)
            setState(2112)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 278, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    setState(2110)
                    try _errHandler.sync(self)
                    switch try getInterpreter().adaptivePredict(_input, 277, _ctx) {
                    case 1:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2068)
                        if !(precpred(_ctx, 13)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 13)"))
                        }
                        setState(2069)
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
                        setState(2070)
                        try expression(14)

                        break
                    case 2:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2071)
                        if !(precpred(_ctx, 12)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 12)"))
                        }
                        setState(2072)
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
                        setState(2073)
                        try expression(13)

                        break
                    case 3:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2074)
                        if !(precpred(_ctx, 11)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 11)"))
                        }
                        setState(2079)
                        try _errHandler.sync(self)
                        switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
                        case .LT:
                            setState(2075)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)
                            setState(2076)
                            try match(ObjectiveCParser.Tokens.LT.rawValue)

                            break

                        case .GT:
                            setState(2077)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)
                            setState(2078)
                            try match(ObjectiveCParser.Tokens.GT.rawValue)

                            break
                        default: throw ANTLRException.recognition(e: NoViableAltException(self))
                        }
                        setState(2081)
                        try expression(12)

                        break
                    case 4:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2082)
                        if !(precpred(_ctx, 10)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 10)"))
                        }
                        setState(2083)
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
                        setState(2084)
                        try expression(11)

                        break
                    case 5:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2085)
                        if !(precpred(_ctx, 9)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 9)"))
                        }
                        setState(2086)
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
                        setState(2087)
                        try expression(10)

                        break
                    case 6:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2088)
                        if !(precpred(_ctx, 8)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 8)"))
                        }
                        setState(2089)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITAND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2090)
                        try expression(9)

                        break
                    case 7:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2091)
                        if !(precpred(_ctx, 7)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 7)"))
                        }
                        setState(2092)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITXOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2093)
                        try expression(8)

                        break
                    case 8:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2094)
                        if !(precpred(_ctx, 6)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 6)"))
                        }
                        setState(2095)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.BITOR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2096)
                        try expression(7)

                        break
                    case 9:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2097)
                        if !(precpred(_ctx, 5)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 5)"))
                        }
                        setState(2098)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.AND.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2099)
                        try expression(6)

                        break
                    case 10:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2100)
                        if !(precpred(_ctx, 4)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 4)"))
                        }
                        setState(2101)
                        try {
                            let assignmentValue = try match(ObjectiveCParser.Tokens.OR.rawValue)
                            _localctx.castdown(ExpressionContext.self).op = assignmentValue
                        }()

                        setState(2102)
                        try expression(5)

                        break
                    case 11:
                        _localctx = ExpressionContext(_parentctx, _parentState)
                        try pushNewRecursionContext(
                            _localctx, _startState, ObjectiveCParser.RULE_expression)
                        setState(2103)
                        if !(precpred(_ctx, 3)) {
                            throw ANTLRException.recognition(
                                e: FailedPredicateException(self, "precpred(_ctx, 3)"))
                        }
                        setState(2104)
                        try match(ObjectiveCParser.Tokens.QUESTION.rawValue)
                        setState(2106)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                        if (Int64((_la - 25)) & ~0x3f) == 0
                            && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                            || (Int64((_la - 90)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                            || (Int64((_la - 157)) & ~0x3f) == 0
                                && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                        {
                            setState(2105)
                            try {
                                let assignmentValue = try expression(0)
                                _localctx.castdown(ExpressionContext.self).trueExpression =
                                    assignmentValue
                            }()

                        }

                        setState(2108)
                        try match(ObjectiveCParser.Tokens.COLON.rawValue)
                        setState(2109)
                        try {
                            let assignmentValue = try expression(4)
                            _localctx.castdown(ExpressionContext.self).falseExpression =
                                assignmentValue
                        }()

                        break
                    default: break
                    }
                }
                setState(2114)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 278, _ctx)
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
        try enterRule(_localctx, 342, ObjectiveCParser.RULE_assignmentExpression)
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2115)
            try unaryExpression()
            setState(2116)
            try assignmentOperator()
            setState(2117)
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
        try enterRule(_localctx, 344, ObjectiveCParser.RULE_assignmentOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2119)
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
        try enterRule(_localctx, 346, ObjectiveCParser.RULE_castExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2131)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 280, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2121)
                try unaryExpression()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2123)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.EXTENSION.rawValue {
                    setState(2122)
                    try match(ObjectiveCParser.Tokens.EXTENSION.rawValue)

                }

                setState(2125)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2126)
                try typeName()
                setState(2127)
                try match(ObjectiveCParser.Tokens.RP.rawValue)
                setState(2128)
                try castExpression()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2130)
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
        try enterRule(_localctx, 348, ObjectiveCParser.RULE_initializer)
        defer { try! exitRule() }
        do {
            setState(2136)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 281, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2133)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2134)
                try arrayInitializer()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2135)
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
        try enterRule(_localctx, 350, ObjectiveCParser.RULE_constantExpression)
        defer { try! exitRule() }
        do {
            setState(2140)
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
                setState(2138)
                try identifier()

                break
            case .TRUE, .FALSE, .NIL, .NO, .NULL, .YES, .ADD, .SUB, .CHARACTER_LITERAL,
                .HEX_LITERAL, .OCTAL_LITERAL, .BINARY_LITERAL, .DECIMAL_LITERAL,
                .FLOATING_POINT_LITERAL:
                try enterOuterAlt(_localctx, 2)
                setState(2139)
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
        try enterRule(_localctx, 352, ObjectiveCParser.RULE_unaryExpression)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2156)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 284, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2142)
                try postfixExpression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2143)
                try match(ObjectiveCParser.Tokens.SIZEOF.rawValue)
                setState(2149)
                try _errHandler.sync(self)
                switch try getInterpreter().adaptivePredict(_input, 283, _ctx) {
                case 1:
                    setState(2144)
                    try unaryExpression()

                    break
                case 2:
                    setState(2145)
                    try match(ObjectiveCParser.Tokens.LP.rawValue)
                    setState(2146)
                    try typeSpecifier()
                    setState(2147)
                    try match(ObjectiveCParser.Tokens.RP.rawValue)

                    break
                default: break
                }

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2151)
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
                setState(2152)
                try unaryExpression()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2153)
                try unaryOperator()
                setState(2154)
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
        try enterRule(_localctx, 354, ObjectiveCParser.RULE_unaryOperator)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2158)
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
        let _startState: Int = 356
        try enterRecursionRule(_localctx, 356, ObjectiveCParser.RULE_postfixExpression, _p)
        var _la: Int = 0
        defer { try! unrollRecursionContexts(_parentctx) }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2161)
            try primaryExpression()
            setState(2165)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 285, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    setState(2162)
                    try postfixExpr()

                }
                setState(2167)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 285, _ctx)
            }

            _ctx!.stop = try _input.LT(-1)
            setState(2179)
            try _errHandler.sync(self)
            _alt = try getInterpreter().adaptivePredict(_input, 287, _ctx)
            while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                if _alt == 1 {
                    if _parseListeners != nil { try triggerExitRuleEvent() }
                    _localctx = PostfixExpressionContext(_parentctx, _parentState)
                    try pushNewRecursionContext(
                        _localctx, _startState, ObjectiveCParser.RULE_postfixExpression)
                    setState(2168)
                    if !(precpred(_ctx, 1)) {
                        throw ANTLRException.recognition(
                            e: FailedPredicateException(self, "precpred(_ctx, 1)"))
                    }
                    setState(2169)
                    _la = try _input.LA(1)
                    if !(_la == ObjectiveCParser.Tokens.DOT.rawValue
                        || _la == ObjectiveCParser.Tokens.STRUCTACCESS.rawValue)
                    {
                        try _errHandler.recoverInline(self)
                    } else {
                        _errHandler.reportMatch(self)
                        try consume()
                    }
                    setState(2170)
                    try identifier()
                    setState(2174)
                    try _errHandler.sync(self)
                    _alt = try getInterpreter().adaptivePredict(_input, 286, _ctx)
                    while _alt != 2 && _alt != ATN.INVALID_ALT_NUMBER {
                        if _alt == 1 {
                            setState(2171)
                            try postfixExpr()

                        }
                        setState(2176)
                        try _errHandler.sync(self)
                        _alt = try getInterpreter().adaptivePredict(_input, 286, _ctx)
                    }

                }
                setState(2181)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 287, _ctx)
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
        try enterRule(_localctx, 358, ObjectiveCParser.RULE_postfixExpr)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2192)
            try _errHandler.sync(self)
            switch ObjectiveCParser.Tokens(rawValue: try _input.LA(1))! {
            case .LBRACK:
                try enterOuterAlt(_localctx, 1)
                setState(2182)
                try match(ObjectiveCParser.Tokens.LBRACK.rawValue)
                setState(2183)
                try expression(0)
                setState(2184)
                try match(ObjectiveCParser.Tokens.RBRACK.rawValue)

                break

            case .LP:
                try enterOuterAlt(_localctx, 2)
                setState(2186)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2188)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if (Int64((_la - 25)) & ~0x3f) == 0
                    && ((Int64(1) << (_la - 25)) & 6_638_376_803_603_759_105) != 0
                    || (Int64((_la - 90)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 90)) & 2_523_141_690_162_676_767) != 0
                    || (Int64((_la - 157)) & ~0x3f) == 0
                        && ((Int64(1) << (_la - 157)) & 8_761_739_034_673) != 0
                {
                    setState(2187)
                    try argumentExpressionList()

                }

                setState(2190)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case .INC, .DEC:
                try enterOuterAlt(_localctx, 3)
                setState(2191)
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
        try enterRule(_localctx, 360, ObjectiveCParser.RULE_argumentExpressionList)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2194)
            try argumentExpression()
            setState(2199)
            try _errHandler.sync(self)
            _la = try _input.LA(1)
            while _la == ObjectiveCParser.Tokens.COMMA.rawValue {
                setState(2195)
                try match(ObjectiveCParser.Tokens.COMMA.rawValue)
                setState(2196)
                try argumentExpression()

                setState(2201)
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
        try enterRule(_localctx, 362, ObjectiveCParser.RULE_argumentExpression)
        defer { try! exitRule() }
        do {
            setState(2204)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 291, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2202)
                try expression(0)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2203)
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
        try enterRule(_localctx, 364, ObjectiveCParser.RULE_primaryExpression)
        defer { try! exitRule() }
        do {
            setState(2221)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 292, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2206)
                try identifier()

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2207)
                try constant()

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2208)
                try stringLiteral()

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2209)
                try match(ObjectiveCParser.Tokens.LP.rawValue)
                setState(2210)
                try expression(0)
                setState(2211)
                try match(ObjectiveCParser.Tokens.RP.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2213)
                try messageExpression()

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2214)
                try selectorExpression()

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2215)
                try protocolExpression()

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2216)
                try encodeExpression()

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2217)
                try dictionaryExpression()

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2218)
                try arrayExpression()

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2219)
                try boxExpression()

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2220)
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
        try enterRule(_localctx, 366, ObjectiveCParser.RULE_constant)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            setState(2241)
            try _errHandler.sync(self)
            switch try getInterpreter().adaptivePredict(_input, 295, _ctx) {
            case 1:
                try enterOuterAlt(_localctx, 1)
                setState(2223)
                try match(ObjectiveCParser.Tokens.HEX_LITERAL.rawValue)

                break
            case 2:
                try enterOuterAlt(_localctx, 2)
                setState(2224)
                try match(ObjectiveCParser.Tokens.OCTAL_LITERAL.rawValue)

                break
            case 3:
                try enterOuterAlt(_localctx, 3)
                setState(2225)
                try match(ObjectiveCParser.Tokens.BINARY_LITERAL.rawValue)

                break
            case 4:
                try enterOuterAlt(_localctx, 4)
                setState(2227)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2226)
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

                setState(2229)
                try match(ObjectiveCParser.Tokens.DECIMAL_LITERAL.rawValue)

                break
            case 5:
                try enterOuterAlt(_localctx, 5)
                setState(2231)
                try _errHandler.sync(self)
                _la = try _input.LA(1)
                if _la == ObjectiveCParser.Tokens.ADD.rawValue
                    || _la == ObjectiveCParser.Tokens.SUB.rawValue
                {
                    setState(2230)
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

                setState(2233)
                try match(ObjectiveCParser.Tokens.FLOATING_POINT_LITERAL.rawValue)

                break
            case 6:
                try enterOuterAlt(_localctx, 6)
                setState(2234)
                try match(ObjectiveCParser.Tokens.CHARACTER_LITERAL.rawValue)

                break
            case 7:
                try enterOuterAlt(_localctx, 7)
                setState(2235)
                try match(ObjectiveCParser.Tokens.NIL.rawValue)

                break
            case 8:
                try enterOuterAlt(_localctx, 8)
                setState(2236)
                try match(ObjectiveCParser.Tokens.NULL.rawValue)

                break
            case 9:
                try enterOuterAlt(_localctx, 9)
                setState(2237)
                try match(ObjectiveCParser.Tokens.YES.rawValue)

                break
            case 10:
                try enterOuterAlt(_localctx, 10)
                setState(2238)
                try match(ObjectiveCParser.Tokens.NO.rawValue)

                break
            case 11:
                try enterOuterAlt(_localctx, 11)
                setState(2239)
                try match(ObjectiveCParser.Tokens.TRUE.rawValue)

                break
            case 12:
                try enterOuterAlt(_localctx, 12)
                setState(2240)
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
        try enterRule(_localctx, 368, ObjectiveCParser.RULE_stringLiteral)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            var _alt: Int
            try enterOuterAlt(_localctx, 1)
            setState(2251)
            try _errHandler.sync(self)
            _alt = 1
            repeat {
                switch _alt {
                case 1:
                    setState(2243)
                    try match(ObjectiveCParser.Tokens.STRING_START.rawValue)
                    setState(2247)
                    try _errHandler.sync(self)
                    _la = try _input.LA(1)
                    while _la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                        || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue
                    {
                        setState(2244)
                        _la = try _input.LA(1)
                        if !(_la == ObjectiveCParser.Tokens.STRING_NEWLINE.rawValue
                            || _la == ObjectiveCParser.Tokens.STRING_VALUE.rawValue)
                        {
                            try _errHandler.recoverInline(self)
                        } else {
                            _errHandler.reportMatch(self)
                            try consume()
                        }

                        setState(2249)
                        try _errHandler.sync(self)
                        _la = try _input.LA(1)
                    }
                    setState(2250)
                    try match(ObjectiveCParser.Tokens.STRING_END.rawValue)

                    break
                default: throw ANTLRException.recognition(e: NoViableAltException(self))
                }
                setState(2253)
                try _errHandler.sync(self)
                _alt = try getInterpreter().adaptivePredict(_input, 297, _ctx)
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
        try enterRule(_localctx, 370, ObjectiveCParser.RULE_identifier)
        var _la: Int = 0
        defer { try! exitRule() }
        do {
            try enterOuterAlt(_localctx, 1)
            setState(2255)
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
        case 92:
            return try directDeclarator_sempred(
                _localctx?.castdown(DirectDeclaratorContext.self), predIndex)
        case 96:
            return try directAbstractDeclarator_sempred(
                _localctx?.castdown(DirectAbstractDeclaratorContext.self), predIndex)
        case 170:
            return try expression_sempred(_localctx?.castdown(ExpressionContext.self), predIndex)
        case 178:
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
        4, 1, 248, 2258, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7, 4, 2, 5, 7, 5, 2,
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
        184, 7, 184, 2, 185, 7, 185, 1, 0, 5, 0, 374, 8, 0, 10, 0, 12, 0, 377, 9, 0, 1, 0, 1, 0, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 391, 8, 1, 1, 2, 1, 2, 1, 2,
        1, 2, 1, 3, 3, 3, 398, 8, 3, 1, 3, 1, 3, 1, 3, 3, 3, 403, 8, 3, 1, 3, 3, 3, 406, 8, 3, 1, 3,
        1, 3, 1, 4, 1, 4, 1, 4, 1, 4, 3, 4, 414, 8, 4, 3, 4, 416, 8, 4, 1, 4, 1, 4, 1, 4, 1, 4, 3,
        4, 422, 8, 4, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5, 428, 8, 5, 1, 5, 1, 5, 1, 5, 1, 5, 1, 5, 3, 5,
        435, 8, 5, 1, 5, 3, 5, 438, 8, 5, 1, 5, 3, 5, 441, 8, 5, 1, 5, 1, 5, 1, 6, 1, 6, 1, 6, 3, 6,
        448, 8, 6, 1, 6, 3, 6, 451, 8, 6, 1, 6, 1, 6, 1, 7, 1, 7, 1, 7, 1, 7, 3, 7, 459, 8, 7, 3, 7,
        461, 8, 7, 1, 8, 1, 8, 1, 8, 1, 8, 3, 8, 467, 8, 8, 1, 8, 1, 8, 3, 8, 471, 8, 8, 1, 8, 1, 8,
        1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 1, 9, 3, 9, 481, 8, 9, 1, 10, 1, 10, 1, 11, 1, 11, 1, 11, 1,
        12, 1, 12, 1, 12, 1, 12, 5, 12, 492, 8, 12, 10, 12, 12, 12, 495, 9, 12, 3, 12, 497, 8, 12,
        1, 12, 1, 12, 1, 13, 5, 13, 502, 8, 13, 10, 13, 12, 13, 505, 9, 13, 1, 13, 1, 13, 3, 13,
        509, 8, 13, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 1, 14, 3, 14, 517, 8, 14, 1, 14, 5, 14, 520,
        8, 14, 10, 14, 12, 14, 523, 9, 14, 1, 14, 1, 14, 1, 15, 1, 15, 5, 15, 529, 8, 15, 10, 15,
        12, 15, 532, 9, 15, 1, 15, 4, 15, 535, 8, 15, 11, 15, 12, 15, 536, 3, 15, 539, 8, 15, 1, 16,
        1, 16, 1, 16, 1, 16, 1, 17, 1, 17, 1, 17, 1, 17, 5, 17, 549, 8, 17, 10, 17, 12, 17, 552, 9,
        17, 1, 17, 1, 17, 1, 18, 1, 18, 1, 18, 5, 18, 559, 8, 18, 10, 18, 12, 18, 562, 9, 18, 1, 19,
        1, 19, 1, 19, 1, 19, 1, 19, 3, 19, 569, 8, 19, 1, 19, 3, 19, 572, 8, 19, 1, 19, 3, 19, 575,
        8, 19, 1, 19, 1, 19, 1, 20, 1, 20, 1, 20, 5, 20, 582, 8, 20, 10, 20, 12, 20, 585, 9, 20, 1,
        21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 1,
        21, 1, 21, 1, 21, 1, 21, 1, 21, 1, 21, 3, 21, 606, 8, 21, 1, 22, 1, 22, 1, 22, 1, 22, 1, 22,
        3, 22, 613, 8, 22, 1, 22, 3, 22, 616, 8, 22, 1, 23, 1, 23, 5, 23, 620, 8, 23, 10, 23, 12,
        23, 623, 9, 23, 1, 23, 1, 23, 1, 24, 1, 24, 5, 24, 629, 8, 24, 10, 24, 12, 24, 632, 9, 24,
        1, 24, 4, 24, 635, 8, 24, 11, 24, 12, 24, 636, 3, 24, 639, 8, 24, 1, 25, 1, 25, 1, 26, 1,
        26, 1, 26, 1, 26, 1, 26, 4, 26, 648, 8, 26, 11, 26, 12, 26, 649, 1, 27, 1, 27, 1, 27, 1, 28,
        1, 28, 1, 28, 1, 29, 3, 29, 659, 8, 29, 1, 29, 1, 29, 5, 29, 663, 8, 29, 10, 29, 12, 29,
        666, 9, 29, 1, 29, 3, 29, 669, 8, 29, 1, 29, 1, 29, 1, 30, 1, 30, 1, 30, 1, 30, 1, 30, 4,
        30, 678, 8, 30, 11, 30, 12, 30, 679, 1, 31, 1, 31, 1, 31, 1, 32, 1, 32, 1, 32, 1, 33, 3, 33,
        689, 8, 33, 1, 33, 1, 33, 3, 33, 693, 8, 33, 1, 33, 3, 33, 696, 8, 33, 1, 33, 3, 33, 699, 8,
        33, 1, 33, 1, 33, 3, 33, 703, 8, 33, 1, 34, 1, 34, 4, 34, 707, 8, 34, 11, 34, 12, 34, 708,
        1, 34, 1, 34, 3, 34, 713, 8, 34, 3, 34, 715, 8, 34, 1, 35, 3, 35, 718, 8, 35, 1, 35, 1, 35,
        5, 35, 722, 8, 35, 10, 35, 12, 35, 725, 9, 35, 1, 35, 3, 35, 728, 8, 35, 1, 35, 1, 35, 1,
        36, 1, 36, 1, 36, 1, 36, 1, 36, 1, 36, 3, 36, 738, 8, 36, 1, 37, 1, 37, 1, 37, 1, 37, 1, 38,
        1, 38, 1, 38, 1, 38, 1, 38, 1, 38, 1, 38, 1, 38, 3, 38, 752, 8, 38, 1, 39, 1, 39, 1, 39, 5,
        39, 757, 8, 39, 10, 39, 12, 39, 760, 9, 39, 1, 40, 1, 40, 1, 40, 3, 40, 765, 8, 40, 1, 41,
        3, 41, 768, 8, 41, 1, 41, 1, 41, 3, 41, 772, 8, 41, 1, 41, 1, 41, 1, 41, 1, 41, 3, 41, 778,
        8, 41, 1, 41, 1, 41, 3, 41, 782, 8, 41, 1, 42, 1, 42, 1, 42, 1, 42, 1, 42, 5, 42, 789, 8,
        42, 10, 42, 12, 42, 792, 9, 42, 1, 42, 3, 42, 795, 8, 42, 3, 42, 797, 8, 42, 1, 42, 1, 42,
        1, 43, 1, 43, 1, 43, 1, 43, 1, 44, 1, 44, 1, 44, 1, 44, 3, 44, 809, 8, 44, 3, 44, 811, 8,
        44, 1, 44, 1, 44, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 1, 45, 3, 45, 823, 8, 45,
        3, 45, 825, 8, 45, 1, 46, 1, 46, 1, 46, 1, 46, 3, 46, 831, 8, 46, 1, 46, 1, 46, 5, 46, 835,
        8, 46, 10, 46, 12, 46, 838, 9, 46, 3, 46, 840, 8, 46, 1, 46, 3, 46, 843, 8, 46, 1, 47, 1,
        47, 3, 47, 847, 8, 47, 1, 48, 1, 48, 3, 48, 851, 8, 48, 1, 48, 3, 48, 854, 8, 48, 1, 48, 3,
        48, 857, 8, 48, 1, 48, 1, 48, 1, 49, 1, 49, 3, 49, 863, 8, 49, 1, 49, 1, 49, 1, 50, 1, 50,
        1, 50, 1, 50, 1, 50, 1, 51, 1, 51, 3, 51, 874, 8, 51, 1, 52, 1, 52, 4, 52, 878, 8, 52, 11,
        52, 12, 52, 879, 3, 52, 882, 8, 52, 1, 53, 3, 53, 885, 8, 53, 1, 53, 1, 53, 1, 53, 1, 53, 5,
        53, 891, 8, 53, 10, 53, 12, 53, 894, 9, 53, 1, 54, 1, 54, 3, 54, 898, 8, 54, 1, 54, 1, 54,
        1, 54, 1, 54, 3, 54, 904, 8, 54, 1, 55, 1, 55, 1, 55, 1, 55, 1, 55, 1, 56, 1, 56, 3, 56,
        913, 8, 56, 1, 56, 4, 56, 916, 8, 56, 11, 56, 12, 56, 917, 3, 56, 920, 8, 56, 1, 57, 1, 57,
        1, 57, 1, 57, 1, 57, 1, 58, 1, 58, 1, 58, 1, 58, 1, 58, 1, 59, 1, 59, 1, 59, 1, 60, 1, 60,
        1, 60, 1, 60, 1, 60, 1, 60, 1, 60, 3, 60, 942, 8, 60, 1, 61, 1, 61, 1, 61, 5, 61, 947, 8,
        61, 10, 61, 12, 61, 950, 9, 61, 1, 61, 1, 61, 3, 61, 954, 8, 61, 1, 62, 1, 62, 1, 62, 1, 62,
        1, 62, 1, 62, 1, 63, 1, 63, 1, 63, 1, 63, 1, 63, 1, 63, 1, 64, 1, 64, 1, 64, 1, 65, 1, 65,
        1, 65, 1, 66, 1, 66, 1, 66, 1, 67, 3, 67, 978, 8, 67, 1, 67, 1, 67, 3, 67, 982, 8, 67, 1,
        68, 4, 68, 985, 8, 68, 11, 68, 12, 68, 986, 1, 69, 1, 69, 3, 69, 991, 8, 69, 1, 70, 1, 70,
        3, 70, 995, 8, 70, 1, 71, 1, 71, 3, 71, 999, 8, 71, 1, 71, 1, 71, 1, 72, 1, 72, 1, 72, 5,
        72, 1006, 8, 72, 10, 72, 12, 72, 1009, 9, 72, 1, 73, 1, 73, 1, 73, 1, 73, 3, 73, 1015, 8,
        73, 1, 74, 1, 74, 1, 74, 1, 74, 1, 74, 3, 74, 1022, 8, 74, 1, 75, 1, 75, 1, 75, 1, 75, 3,
        75, 1028, 8, 75, 1, 75, 1, 75, 1, 75, 3, 75, 1033, 8, 75, 1, 75, 1, 75, 1, 76, 1, 76, 1, 76,
        3, 76, 1040, 8, 76, 1, 77, 1, 77, 1, 77, 5, 77, 1045, 8, 77, 10, 77, 12, 77, 1048, 9, 77, 1,
        78, 1, 78, 3, 78, 1052, 8, 78, 1, 78, 3, 78, 1055, 8, 78, 1, 78, 3, 78, 1058, 8, 78, 1, 79,
        3, 79, 1061, 8, 79, 1, 79, 1, 79, 3, 79, 1065, 8, 79, 1, 79, 1, 79, 1, 79, 1, 79, 1, 79, 1,
        80, 3, 80, 1073, 8, 80, 1, 80, 3, 80, 1076, 8, 80, 1, 80, 1, 80, 3, 80, 1080, 8, 80, 1, 80,
        1, 80, 1, 81, 1, 81, 1, 81, 1, 81, 3, 81, 1088, 8, 81, 1, 81, 1, 81, 1, 82, 3, 82, 1093, 8,
        82, 1, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1100, 8, 82, 1, 82, 3, 82, 1103, 8, 82, 1, 82,
        1, 82, 1, 82, 3, 82, 1108, 8, 82, 1, 82, 1, 82, 1, 82, 1, 82, 3, 82, 1114, 8, 82, 1, 83, 1,
        83, 1, 83, 5, 83, 1119, 8, 83, 10, 83, 12, 83, 1122, 9, 83, 1, 84, 1, 84, 1, 84, 1, 84, 1,
        84, 1, 84, 1, 84, 1, 84, 4, 84, 1132, 8, 84, 11, 84, 12, 84, 1133, 1, 85, 1, 85, 1, 85, 1,
        85, 1, 85, 1, 85, 1, 85, 1, 85, 3, 85, 1144, 8, 85, 1, 86, 1, 86, 1, 86, 1, 86, 1, 86, 1,
        86, 1, 86, 1, 86, 3, 86, 1154, 8, 86, 1, 87, 3, 87, 1157, 8, 87, 1, 87, 4, 87, 1160, 8, 87,
        11, 87, 12, 87, 1161, 1, 88, 1, 88, 3, 88, 1166, 8, 88, 1, 88, 1, 88, 1, 88, 3, 88, 1171, 8,
        88, 1, 89, 1, 89, 1, 89, 5, 89, 1176, 8, 89, 10, 89, 12, 89, 1179, 9, 89, 1, 90, 1, 90, 1,
        90, 3, 90, 1184, 8, 90, 1, 91, 3, 91, 1187, 8, 91, 1, 91, 1, 91, 5, 91, 1191, 8, 91, 10, 91,
        12, 91, 1194, 9, 91, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 3, 92,
        1205, 8, 92, 1, 92, 3, 92, 1208, 8, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1,
        92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 3, 92, 1224, 8, 92, 1, 92, 1, 92, 1, 92, 3,
        92, 1229, 8, 92, 1, 92, 3, 92, 1232, 8, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 3, 92, 1239,
        8, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92,
        1, 92, 3, 92, 1254, 8, 92, 1, 92, 1, 92, 1, 92, 1, 92, 1, 92, 3, 92, 1261, 8, 92, 1, 92, 5,
        92, 1264, 8, 92, 10, 92, 12, 92, 1267, 9, 92, 1, 93, 1, 93, 3, 93, 1271, 8, 93, 1, 94, 1,
        94, 3, 94, 1275, 8, 94, 1, 94, 1, 94, 3, 94, 1279, 8, 94, 1, 94, 1, 94, 4, 94, 1283, 8, 94,
        11, 94, 12, 94, 1284, 1, 94, 1, 94, 3, 94, 1289, 8, 94, 1, 94, 4, 94, 1292, 8, 94, 11, 94,
        12, 94, 1293, 3, 94, 1296, 8, 94, 1, 95, 1, 95, 3, 95, 1300, 8, 95, 1, 95, 1, 95, 5, 95,
        1304, 8, 95, 10, 95, 12, 95, 1307, 9, 95, 3, 95, 1309, 8, 95, 1, 96, 1, 96, 1, 96, 1, 96, 1,
        96, 5, 96, 1316, 8, 96, 10, 96, 12, 96, 1319, 9, 96, 1, 96, 1, 96, 3, 96, 1323, 8, 96, 1,
        96, 3, 96, 1326, 8, 96, 1, 96, 1, 96, 1, 96, 1, 96, 3, 96, 1332, 8, 96, 1, 96, 1, 96, 1, 96,
        1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 3, 96, 1348, 8,
        96, 1, 96, 1, 96, 5, 96, 1352, 8, 96, 10, 96, 12, 96, 1355, 9, 96, 1, 96, 1, 96, 1, 96, 3,
        96, 1360, 8, 96, 1, 96, 1, 96, 3, 96, 1364, 8, 96, 1, 96, 1, 96, 1, 96, 3, 96, 1369, 8, 96,
        1, 96, 3, 96, 1372, 8, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 3, 96, 1379, 8, 96, 1, 96, 1,
        96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1, 96, 1,
        96, 1, 96, 1, 96, 3, 96, 1398, 8, 96, 1, 96, 1, 96, 5, 96, 1402, 8, 96, 10, 96, 12, 96,
        1405, 9, 96, 5, 96, 1407, 8, 96, 10, 96, 12, 96, 1410, 9, 96, 1, 97, 1, 97, 3, 97, 1414, 8,
        97, 1, 97, 1, 97, 1, 97, 3, 97, 1419, 8, 97, 1, 97, 3, 97, 1422, 8, 97, 1, 98, 1, 98, 1, 98,
        3, 98, 1427, 8, 98, 1, 99, 1, 99, 1, 99, 5, 99, 1432, 8, 99, 10, 99, 12, 99, 1435, 9, 99, 1,
        100, 1, 100, 1, 100, 5, 100, 1440, 8, 100, 10, 100, 12, 100, 1443, 9, 100, 1, 101, 1, 101,
        1, 101, 1, 101, 1, 101, 3, 101, 1450, 8, 101, 3, 101, 1452, 8, 101, 1, 102, 4, 102, 1455, 8,
        102, 11, 102, 12, 102, 1456, 1, 103, 1, 103, 1, 103, 5, 103, 1462, 8, 103, 10, 103, 12, 103,
        1465, 9, 103, 1, 104, 1, 104, 3, 104, 1469, 8, 104, 1, 104, 1, 104, 1, 105, 1, 105, 1, 105,
        1, 105, 1, 105, 1, 105, 5, 105, 1479, 8, 105, 10, 105, 12, 105, 1482, 9, 105, 1, 105, 1,
        105, 1, 105, 1, 106, 1, 106, 1, 106, 1, 106, 1, 106, 1, 107, 1, 107, 5, 107, 1494, 8, 107,
        10, 107, 12, 107, 1497, 9, 107, 1, 107, 1, 107, 3, 107, 1501, 8, 107, 1, 107, 1, 107, 4,
        107, 1505, 8, 107, 11, 107, 12, 107, 1506, 1, 107, 1, 107, 3, 107, 1511, 8, 107, 1, 108, 1,
        108, 3, 108, 1515, 8, 108, 1, 108, 1, 108, 1, 108, 1, 108, 1, 108, 1, 108, 1, 108, 3, 108,
        1524, 8, 108, 1, 109, 1, 109, 1, 110, 4, 110, 1529, 8, 110, 11, 110, 12, 110, 1530, 1, 111,
        1, 111, 1, 111, 1, 111, 1, 111, 1, 111, 1, 111, 1, 111, 3, 111, 1541, 8, 111, 1, 112, 1,
        112, 3, 112, 1545, 8, 112, 1, 112, 3, 112, 1548, 8, 112, 1, 113, 1, 113, 1, 113, 5, 113,
        1553, 8, 113, 10, 113, 12, 113, 1556, 9, 113, 1, 114, 1, 114, 3, 114, 1560, 8, 114, 1, 114,
        1, 114, 3, 114, 1564, 8, 114, 1, 115, 1, 115, 1, 115, 3, 115, 1569, 8, 115, 1, 115, 1, 115,
        1, 116, 1, 116, 1, 116, 1, 116, 1, 116, 1, 116, 3, 116, 1579, 8, 116, 1, 117, 1, 117, 1,
        118, 1, 118, 1, 119, 1, 119, 1, 120, 1, 120, 1, 121, 1, 121, 1, 121, 1, 121, 1, 121, 3, 121,
        1594, 8, 121, 1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 1, 122, 3, 122, 1603, 8, 122,
        1, 123, 1, 123, 1, 123, 1, 123, 3, 123, 1609, 8, 123, 1, 123, 1, 123, 1, 124, 1, 124, 1,
        125, 1, 125, 3, 125, 1617, 8, 125, 1, 125, 1, 125, 3, 125, 1621, 8, 125, 1, 125, 1, 125, 3,
        125, 1625, 8, 125, 1, 125, 1, 125, 3, 125, 1629, 8, 125, 1, 125, 1, 125, 3, 125, 1633, 8,
        125, 1, 125, 1, 125, 3, 125, 1637, 8, 125, 3, 125, 1639, 8, 125, 1, 126, 1, 126, 1, 126, 1,
        126, 1, 126, 1, 126, 1, 126, 1, 126, 1, 126, 1, 126, 1, 126, 3, 126, 1652, 8, 126, 1, 127,
        1, 127, 1, 127, 1, 127, 1, 127, 1, 128, 1, 128, 1, 129, 1, 129, 1, 129, 1, 130, 1, 130, 1,
        130, 1, 130, 5, 130, 1668, 8, 130, 10, 130, 12, 130, 1671, 9, 130, 3, 130, 1673, 8, 130, 1,
        130, 1, 130, 1, 131, 3, 131, 1678, 8, 131, 1, 131, 1, 131, 1, 132, 1, 132, 1, 133, 1, 133,
        1, 133, 5, 133, 1687, 8, 133, 10, 133, 12, 133, 1690, 9, 133, 1, 134, 1, 134, 3, 134, 1694,
        8, 134, 1, 134, 1, 134, 3, 134, 1698, 8, 134, 1, 135, 1, 135, 3, 135, 1702, 8, 135, 1, 135,
        1, 135, 3, 135, 1706, 8, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 3, 135, 1713, 8, 135,
        1, 135, 1, 135, 1, 135, 1, 135, 3, 135, 1719, 8, 135, 1, 135, 1, 135, 1, 135, 1, 135, 1,
        135, 1, 135, 1, 135, 1, 135, 1, 135, 1, 135, 3, 135, 1731, 8, 135, 1, 136, 1, 136, 1, 136,
        5, 136, 1736, 8, 136, 10, 136, 12, 136, 1739, 9, 136, 1, 136, 3, 136, 1742, 8, 136, 1, 137,
        1, 137, 1, 137, 3, 137, 1747, 8, 137, 1, 138, 1, 138, 1, 139, 1, 139, 1, 140, 1, 140, 1,
        140, 4, 140, 1756, 8, 140, 11, 140, 12, 140, 1757, 1, 140, 1, 140, 1, 140, 3, 140, 1763, 8,
        140, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 141, 1, 142, 3, 142, 1773, 8, 142,
        1, 142, 1, 142, 3, 142, 1777, 8, 142, 5, 142, 1779, 8, 142, 10, 142, 12, 142, 1782, 9, 142,
        1, 143, 1, 143, 1, 143, 3, 143, 1787, 8, 143, 1, 143, 3, 143, 1790, 8, 143, 1, 144, 1, 144,
        3, 144, 1794, 8, 144, 1, 144, 3, 144, 1797, 8, 144, 1, 145, 4, 145, 1800, 8, 145, 11, 145,
        12, 145, 1801, 1, 146, 1, 146, 3, 146, 1806, 8, 146, 1, 147, 1, 147, 1, 147, 1, 147, 4, 147,
        1812, 8, 147, 11, 147, 12, 147, 1813, 1, 147, 3, 147, 1817, 8, 147, 1, 148, 1, 148, 1, 148,
        1, 148, 5, 148, 1823, 8, 148, 10, 148, 12, 148, 1826, 9, 148, 1, 148, 3, 148, 1829, 8, 148,
        3, 148, 1831, 8, 148, 1, 148, 1, 148, 1, 149, 1, 149, 1, 149, 1, 149, 5, 149, 1839, 8, 149,
        10, 149, 12, 149, 1842, 9, 149, 1, 149, 3, 149, 1845, 8, 149, 3, 149, 1847, 8, 149, 1, 149,
        1, 149, 1, 150, 1, 150, 1, 150, 1, 150, 3, 150, 1855, 8, 150, 1, 151, 1, 151, 1, 151, 5,
        151, 1860, 8, 151, 10, 151, 12, 151, 1863, 9, 151, 1, 151, 3, 151, 1866, 8, 151, 1, 152, 1,
        152, 1, 152, 1, 152, 1, 152, 4, 152, 1873, 8, 152, 11, 152, 12, 152, 1874, 1, 152, 1, 152,
        1, 152, 1, 153, 1, 153, 3, 153, 1882, 8, 153, 1, 153, 1, 153, 3, 153, 1886, 8, 153, 1, 153,
        1, 153, 3, 153, 1890, 8, 153, 1, 153, 1, 153, 3, 153, 1894, 8, 153, 1, 153, 1, 153, 1, 153,
        1, 153, 1, 153, 3, 153, 1901, 8, 153, 1, 153, 1, 153, 3, 153, 1905, 8, 153, 1, 153, 1, 153,
        1, 153, 1, 153, 1, 153, 3, 153, 1912, 8, 153, 1, 153, 1, 153, 1, 153, 1, 153, 3, 153, 1918,
        8, 153, 1, 154, 1, 154, 1, 154, 1, 154, 1, 155, 1, 155, 1, 155, 3, 155, 1927, 8, 155, 1,
        156, 1, 156, 1, 156, 5, 156, 1932, 8, 156, 10, 156, 12, 156, 1935, 9, 156, 1, 156, 1, 156,
        1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 1, 157, 3, 157, 1946, 8, 157, 1, 157, 3,
        157, 1949, 8, 157, 1, 158, 1, 158, 1, 158, 1, 158, 1, 158, 1, 158, 1, 159, 1, 159, 5, 159,
        1959, 8, 159, 10, 159, 12, 159, 1962, 9, 159, 1, 159, 1, 159, 1, 160, 4, 160, 1967, 8, 160,
        11, 160, 12, 160, 1968, 1, 160, 4, 160, 1972, 8, 160, 11, 160, 12, 160, 1973, 1, 161, 1,
        161, 1, 161, 1, 161, 1, 161, 1, 161, 3, 161, 1982, 8, 161, 1, 161, 1, 161, 1, 161, 1, 161,
        3, 161, 1988, 8, 161, 1, 162, 1, 162, 1, 162, 1, 162, 3, 162, 1994, 8, 162, 1, 163, 1, 163,
        1, 163, 1, 163, 1, 163, 1, 163, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1, 164, 1,
        164, 1, 165, 1, 165, 1, 165, 3, 165, 2013, 8, 165, 1, 165, 1, 165, 3, 165, 2017, 8, 165, 1,
        165, 1, 165, 3, 165, 2021, 8, 165, 1, 165, 1, 165, 1, 165, 1, 166, 1, 166, 1, 166, 1, 166,
        3, 166, 2030, 8, 166, 1, 167, 1, 167, 1, 167, 1, 167, 1, 167, 3, 167, 2037, 8, 167, 1, 167,
        1, 167, 1, 167, 1, 168, 1, 168, 1, 168, 1, 168, 1, 168, 1, 168, 3, 168, 2048, 8, 168, 3,
        168, 2050, 8, 168, 1, 169, 1, 169, 1, 169, 5, 169, 2055, 8, 169, 10, 169, 12, 169, 2058, 9,
        169, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 3, 170, 2067, 8, 170, 1, 170,
        1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 3, 170,
        2080, 8, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1,
        170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170, 1, 170,
        1, 170, 1, 170, 1, 170, 1, 170, 3, 170, 2107, 8, 170, 1, 170, 1, 170, 5, 170, 2111, 8, 170,
        10, 170, 12, 170, 2114, 9, 170, 1, 171, 1, 171, 1, 171, 1, 171, 1, 172, 1, 172, 1, 173, 1,
        173, 3, 173, 2124, 8, 173, 1, 173, 1, 173, 1, 173, 1, 173, 1, 173, 1, 173, 3, 173, 2132, 8,
        173, 1, 174, 1, 174, 1, 174, 3, 174, 2137, 8, 174, 1, 175, 1, 175, 3, 175, 2141, 8, 175, 1,
        176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 1, 176, 3, 176, 2150, 8, 176, 1, 176, 1, 176,
        1, 176, 1, 176, 1, 176, 3, 176, 2157, 8, 176, 1, 177, 1, 177, 1, 178, 1, 178, 1, 178, 5,
        178, 2164, 8, 178, 10, 178, 12, 178, 2167, 9, 178, 1, 178, 1, 178, 1, 178, 1, 178, 5, 178,
        2173, 8, 178, 10, 178, 12, 178, 2176, 9, 178, 5, 178, 2178, 8, 178, 10, 178, 12, 178, 2181,
        9, 178, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 1, 179, 3, 179, 2189, 8, 179, 1, 179, 1,
        179, 3, 179, 2193, 8, 179, 1, 180, 1, 180, 1, 180, 5, 180, 2198, 8, 180, 10, 180, 12, 180,
        2201, 9, 180, 1, 181, 1, 181, 3, 181, 2205, 8, 181, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182,
        1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 1, 182, 3, 182,
        2222, 8, 182, 1, 183, 1, 183, 1, 183, 1, 183, 3, 183, 2228, 8, 183, 1, 183, 1, 183, 3, 183,
        2232, 8, 183, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 1, 183, 3, 183, 2242,
        8, 183, 1, 184, 1, 184, 5, 184, 2246, 8, 184, 10, 184, 12, 184, 2249, 9, 184, 1, 184, 4,
        184, 2252, 8, 184, 11, 184, 12, 184, 2253, 1, 185, 1, 185, 1, 185, 0, 4, 184, 192, 340, 356,
        186, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44,
        46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, 84, 86, 88, 90,
        92, 94, 96, 98, 100, 102, 104, 106, 108, 110, 112, 114, 116, 118, 120, 122, 124, 126, 128,
        130, 132, 134, 136, 138, 140, 142, 144, 146, 148, 150, 152, 154, 156, 158, 160, 162, 164,
        166, 168, 170, 172, 174, 176, 178, 180, 182, 184, 186, 188, 190, 192, 194, 196, 198, 200,
        202, 204, 206, 208, 210, 212, 214, 216, 218, 220, 222, 224, 226, 228, 230, 232, 234, 236,
        238, 240, 242, 244, 246, 248, 250, 252, 254, 256, 258, 260, 262, 264, 266, 268, 270, 272,
        274, 276, 278, 280, 282, 284, 286, 288, 290, 292, 294, 296, 298, 300, 302, 304, 306, 308,
        310, 312, 314, 316, 318, 320, 322, 324, 326, 328, 330, 332, 334, 336, 338, 340, 342, 344,
        346, 348, 350, 352, 354, 356, 358, 360, 362, 364, 366, 368, 370, 0, 26, 2, 0, 72, 72, 77,
        77, 1, 0, 92, 93, 3, 0, 70, 70, 73, 73, 75, 76, 2, 0, 27, 27, 30, 30, 4, 0, 87, 87, 96, 96,
        99, 99, 101, 101, 1, 0, 120, 123, 7, 0, 1, 1, 12, 12, 20, 20, 26, 26, 29, 29, 41, 41, 118,
        118, 4, 0, 17, 17, 88, 91, 95, 95, 124, 124, 4, 0, 17, 17, 105, 105, 110, 110, 116, 116, 3,
        0, 44, 45, 48, 49, 53, 54, 1, 0, 112, 114, 8, 0, 4, 4, 9, 9, 13, 13, 18, 19, 23, 24, 31, 32,
        35, 37, 112, 114, 1, 0, 125, 126, 2, 0, 103, 105, 107, 109, 2, 0, 147, 148, 154, 154, 1, 0,
        148, 148, 2, 0, 175, 176, 180, 180, 1, 0, 173, 174, 2, 0, 159, 160, 166, 167, 2, 0, 165,
        165, 168, 168, 2, 0, 158, 158, 181, 190, 1, 0, 171, 172, 3, 0, 161, 162, 173, 175, 177, 177,
        1, 0, 155, 156, 2, 0, 205, 205, 207, 207, 8, 0, 42, 49, 53, 58, 83, 85, 87, 87, 90, 94, 100,
        100, 120, 139, 146, 146, 2501, 0, 375, 1, 0, 0, 0, 2, 390, 1, 0, 0, 0, 4, 392, 1, 0, 0, 0,
        6, 397, 1, 0, 0, 0, 8, 409, 1, 0, 0, 0, 10, 423, 1, 0, 0, 0, 12, 444, 1, 0, 0, 0, 14, 454,
        1, 0, 0, 0, 16, 462, 1, 0, 0, 0, 18, 474, 1, 0, 0, 0, 20, 482, 1, 0, 0, 0, 22, 484, 1, 0, 0,
        0, 24, 487, 1, 0, 0, 0, 26, 503, 1, 0, 0, 0, 28, 510, 1, 0, 0, 0, 30, 538, 1, 0, 0, 0, 32,
        540, 1, 0, 0, 0, 34, 544, 1, 0, 0, 0, 36, 555, 1, 0, 0, 0, 38, 563, 1, 0, 0, 0, 40, 578, 1,
        0, 0, 0, 42, 605, 1, 0, 0, 0, 44, 615, 1, 0, 0, 0, 46, 617, 1, 0, 0, 0, 48, 638, 1, 0, 0, 0,
        50, 640, 1, 0, 0, 0, 52, 647, 1, 0, 0, 0, 54, 651, 1, 0, 0, 0, 56, 654, 1, 0, 0, 0, 58, 658,
        1, 0, 0, 0, 60, 677, 1, 0, 0, 0, 62, 681, 1, 0, 0, 0, 64, 684, 1, 0, 0, 0, 66, 688, 1, 0, 0,
        0, 68, 714, 1, 0, 0, 0, 70, 717, 1, 0, 0, 0, 72, 737, 1, 0, 0, 0, 74, 739, 1, 0, 0, 0, 76,
        751, 1, 0, 0, 0, 78, 753, 1, 0, 0, 0, 80, 761, 1, 0, 0, 0, 82, 767, 1, 0, 0, 0, 84, 783, 1,
        0, 0, 0, 86, 800, 1, 0, 0, 0, 88, 804, 1, 0, 0, 0, 90, 824, 1, 0, 0, 0, 92, 842, 1, 0, 0, 0,
        94, 846, 1, 0, 0, 0, 96, 848, 1, 0, 0, 0, 98, 860, 1, 0, 0, 0, 100, 866, 1, 0, 0, 0, 102,
        873, 1, 0, 0, 0, 104, 881, 1, 0, 0, 0, 106, 884, 1, 0, 0, 0, 108, 895, 1, 0, 0, 0, 110, 905,
        1, 0, 0, 0, 112, 919, 1, 0, 0, 0, 114, 921, 1, 0, 0, 0, 116, 926, 1, 0, 0, 0, 118, 931, 1,
        0, 0, 0, 120, 941, 1, 0, 0, 0, 122, 943, 1, 0, 0, 0, 124, 955, 1, 0, 0, 0, 126, 961, 1, 0,
        0, 0, 128, 967, 1, 0, 0, 0, 130, 970, 1, 0, 0, 0, 132, 973, 1, 0, 0, 0, 134, 977, 1, 0, 0,
        0, 136, 984, 1, 0, 0, 0, 138, 988, 1, 0, 0, 0, 140, 994, 1, 0, 0, 0, 142, 996, 1, 0, 0, 0,
        144, 1002, 1, 0, 0, 0, 146, 1014, 1, 0, 0, 0, 148, 1016, 1, 0, 0, 0, 150, 1023, 1, 0, 0, 0,
        152, 1036, 1, 0, 0, 0, 154, 1041, 1, 0, 0, 0, 156, 1057, 1, 0, 0, 0, 158, 1060, 1, 0, 0, 0,
        160, 1072, 1, 0, 0, 0, 162, 1087, 1, 0, 0, 0, 164, 1113, 1, 0, 0, 0, 166, 1115, 1, 0, 0, 0,
        168, 1131, 1, 0, 0, 0, 170, 1143, 1, 0, 0, 0, 172, 1153, 1, 0, 0, 0, 174, 1156, 1, 0, 0, 0,
        176, 1170, 1, 0, 0, 0, 178, 1172, 1, 0, 0, 0, 180, 1180, 1, 0, 0, 0, 182, 1186, 1, 0, 0, 0,
        184, 1223, 1, 0, 0, 0, 186, 1268, 1, 0, 0, 0, 188, 1295, 1, 0, 0, 0, 190, 1308, 1, 0, 0, 0,
        192, 1363, 1, 0, 0, 0, 194, 1421, 1, 0, 0, 0, 196, 1423, 1, 0, 0, 0, 198, 1428, 1, 0, 0, 0,
        200, 1436, 1, 0, 0, 0, 202, 1451, 1, 0, 0, 0, 204, 1454, 1, 0, 0, 0, 206, 1458, 1, 0, 0, 0,
        208, 1466, 1, 0, 0, 0, 210, 1472, 1, 0, 0, 0, 212, 1486, 1, 0, 0, 0, 214, 1491, 1, 0, 0, 0,
        216, 1523, 1, 0, 0, 0, 218, 1525, 1, 0, 0, 0, 220, 1528, 1, 0, 0, 0, 222, 1540, 1, 0, 0, 0,
        224, 1544, 1, 0, 0, 0, 226, 1549, 1, 0, 0, 0, 228, 1563, 1, 0, 0, 0, 230, 1565, 1, 0, 0, 0,
        232, 1578, 1, 0, 0, 0, 234, 1580, 1, 0, 0, 0, 236, 1582, 1, 0, 0, 0, 238, 1584, 1, 0, 0, 0,
        240, 1586, 1, 0, 0, 0, 242, 1593, 1, 0, 0, 0, 244, 1602, 1, 0, 0, 0, 246, 1604, 1, 0, 0, 0,
        248, 1612, 1, 0, 0, 0, 250, 1638, 1, 0, 0, 0, 252, 1651, 1, 0, 0, 0, 254, 1653, 1, 0, 0, 0,
        256, 1658, 1, 0, 0, 0, 258, 1660, 1, 0, 0, 0, 260, 1663, 1, 0, 0, 0, 262, 1677, 1, 0, 0, 0,
        264, 1681, 1, 0, 0, 0, 266, 1683, 1, 0, 0, 0, 268, 1697, 1, 0, 0, 0, 270, 1730, 1, 0, 0, 0,
        272, 1732, 1, 0, 0, 0, 274, 1743, 1, 0, 0, 0, 276, 1748, 1, 0, 0, 0, 278, 1750, 1, 0, 0, 0,
        280, 1762, 1, 0, 0, 0, 282, 1764, 1, 0, 0, 0, 284, 1772, 1, 0, 0, 0, 286, 1783, 1, 0, 0, 0,
        288, 1791, 1, 0, 0, 0, 290, 1799, 1, 0, 0, 0, 292, 1803, 1, 0, 0, 0, 294, 1807, 1, 0, 0, 0,
        296, 1818, 1, 0, 0, 0, 298, 1834, 1, 0, 0, 0, 300, 1854, 1, 0, 0, 0, 302, 1856, 1, 0, 0, 0,
        304, 1867, 1, 0, 0, 0, 306, 1917, 1, 0, 0, 0, 308, 1919, 1, 0, 0, 0, 310, 1923, 1, 0, 0, 0,
        312, 1928, 1, 0, 0, 0, 314, 1948, 1, 0, 0, 0, 316, 1950, 1, 0, 0, 0, 318, 1956, 1, 0, 0, 0,
        320, 1966, 1, 0, 0, 0, 322, 1987, 1, 0, 0, 0, 324, 1993, 1, 0, 0, 0, 326, 1995, 1, 0, 0, 0,
        328, 2001, 1, 0, 0, 0, 330, 2009, 1, 0, 0, 0, 332, 2029, 1, 0, 0, 0, 334, 2031, 1, 0, 0, 0,
        336, 2049, 1, 0, 0, 0, 338, 2051, 1, 0, 0, 0, 340, 2066, 1, 0, 0, 0, 342, 2115, 1, 0, 0, 0,
        344, 2119, 1, 0, 0, 0, 346, 2131, 1, 0, 0, 0, 348, 2136, 1, 0, 0, 0, 350, 2140, 1, 0, 0, 0,
        352, 2156, 1, 0, 0, 0, 354, 2158, 1, 0, 0, 0, 356, 2160, 1, 0, 0, 0, 358, 2192, 1, 0, 0, 0,
        360, 2194, 1, 0, 0, 0, 362, 2204, 1, 0, 0, 0, 364, 2221, 1, 0, 0, 0, 366, 2241, 1, 0, 0, 0,
        368, 2251, 1, 0, 0, 0, 370, 2255, 1, 0, 0, 0, 372, 374, 3, 2, 1, 0, 373, 372, 1, 0, 0, 0,
        374, 377, 1, 0, 0, 0, 375, 373, 1, 0, 0, 0, 375, 376, 1, 0, 0, 0, 376, 378, 1, 0, 0, 0, 377,
        375, 1, 0, 0, 0, 378, 379, 5, 0, 0, 1, 379, 1, 1, 0, 0, 0, 380, 391, 3, 4, 2, 0, 381, 391,
        3, 176, 88, 0, 382, 391, 3, 6, 3, 0, 383, 391, 3, 12, 6, 0, 384, 391, 3, 10, 5, 0, 385, 391,
        3, 16, 8, 0, 386, 391, 3, 28, 14, 0, 387, 391, 3, 32, 16, 0, 388, 391, 3, 34, 17, 0, 389,
        391, 3, 132, 66, 0, 390, 380, 1, 0, 0, 0, 390, 381, 1, 0, 0, 0, 390, 382, 1, 0, 0, 0, 390,
        383, 1, 0, 0, 0, 390, 384, 1, 0, 0, 0, 390, 385, 1, 0, 0, 0, 390, 386, 1, 0, 0, 0, 390, 387,
        1, 0, 0, 0, 390, 388, 1, 0, 0, 0, 390, 389, 1, 0, 0, 0, 391, 3, 1, 0, 0, 0, 392, 393, 5, 69,
        0, 0, 393, 394, 3, 370, 185, 0, 394, 395, 5, 153, 0, 0, 395, 5, 1, 0, 0, 0, 396, 398, 5,
        139, 0, 0, 397, 396, 1, 0, 0, 0, 397, 398, 1, 0, 0, 0, 398, 399, 1, 0, 0, 0, 399, 400, 5,
        68, 0, 0, 400, 402, 3, 8, 4, 0, 401, 403, 3, 46, 23, 0, 402, 401, 1, 0, 0, 0, 402, 403, 1,
        0, 0, 0, 403, 405, 1, 0, 0, 0, 404, 406, 3, 52, 26, 0, 405, 404, 1, 0, 0, 0, 405, 406, 1, 0,
        0, 0, 406, 407, 1, 0, 0, 0, 407, 408, 5, 65, 0, 0, 408, 7, 1, 0, 0, 0, 409, 415, 3, 18, 9,
        0, 410, 411, 5, 164, 0, 0, 411, 413, 3, 20, 10, 0, 412, 414, 3, 24, 12, 0, 413, 412, 1, 0,
        0, 0, 413, 414, 1, 0, 0, 0, 414, 416, 1, 0, 0, 0, 415, 410, 1, 0, 0, 0, 415, 416, 1, 0, 0,
        0, 416, 421, 1, 0, 0, 0, 417, 418, 5, 160, 0, 0, 418, 419, 3, 36, 18, 0, 419, 420, 5, 159,
        0, 0, 420, 422, 1, 0, 0, 0, 421, 417, 1, 0, 0, 0, 421, 422, 1, 0, 0, 0, 422, 9, 1, 0, 0, 0,
        423, 424, 5, 68, 0, 0, 424, 425, 3, 18, 9, 0, 425, 427, 5, 147, 0, 0, 426, 428, 3, 370, 185,
        0, 427, 426, 1, 0, 0, 0, 427, 428, 1, 0, 0, 0, 428, 429, 1, 0, 0, 0, 429, 434, 5, 148, 0, 0,
        430, 431, 5, 160, 0, 0, 431, 432, 3, 36, 18, 0, 432, 433, 5, 159, 0, 0, 433, 435, 1, 0, 0,
        0, 434, 430, 1, 0, 0, 0, 434, 435, 1, 0, 0, 0, 435, 437, 1, 0, 0, 0, 436, 438, 3, 46, 23, 0,
        437, 436, 1, 0, 0, 0, 437, 438, 1, 0, 0, 0, 438, 440, 1, 0, 0, 0, 439, 441, 3, 52, 26, 0,
        440, 439, 1, 0, 0, 0, 440, 441, 1, 0, 0, 0, 441, 442, 1, 0, 0, 0, 442, 443, 5, 65, 0, 0,
        443, 11, 1, 0, 0, 0, 444, 445, 5, 67, 0, 0, 445, 447, 3, 14, 7, 0, 446, 448, 3, 46, 23, 0,
        447, 446, 1, 0, 0, 0, 447, 448, 1, 0, 0, 0, 448, 450, 1, 0, 0, 0, 449, 451, 3, 60, 30, 0,
        450, 449, 1, 0, 0, 0, 450, 451, 1, 0, 0, 0, 451, 452, 1, 0, 0, 0, 452, 453, 5, 65, 0, 0,
        453, 13, 1, 0, 0, 0, 454, 460, 3, 18, 9, 0, 455, 456, 5, 164, 0, 0, 456, 458, 3, 20, 10, 0,
        457, 459, 3, 24, 12, 0, 458, 457, 1, 0, 0, 0, 458, 459, 1, 0, 0, 0, 459, 461, 1, 0, 0, 0,
        460, 455, 1, 0, 0, 0, 460, 461, 1, 0, 0, 0, 461, 15, 1, 0, 0, 0, 462, 463, 5, 67, 0, 0, 463,
        464, 3, 18, 9, 0, 464, 466, 5, 147, 0, 0, 465, 467, 3, 370, 185, 0, 466, 465, 1, 0, 0, 0,
        466, 467, 1, 0, 0, 0, 467, 468, 1, 0, 0, 0, 468, 470, 5, 148, 0, 0, 469, 471, 3, 60, 30, 0,
        470, 469, 1, 0, 0, 0, 470, 471, 1, 0, 0, 0, 471, 472, 1, 0, 0, 0, 472, 473, 5, 65, 0, 0,
        473, 17, 1, 0, 0, 0, 474, 480, 3, 370, 185, 0, 475, 476, 5, 160, 0, 0, 476, 477, 3, 36, 18,
        0, 477, 478, 5, 159, 0, 0, 478, 481, 1, 0, 0, 0, 479, 481, 3, 260, 130, 0, 480, 475, 1, 0,
        0, 0, 480, 479, 1, 0, 0, 0, 480, 481, 1, 0, 0, 0, 481, 19, 1, 0, 0, 0, 482, 483, 3, 370,
        185, 0, 483, 21, 1, 0, 0, 0, 484, 485, 3, 370, 185, 0, 485, 486, 3, 24, 12, 0, 486, 23, 1,
        0, 0, 0, 487, 496, 5, 160, 0, 0, 488, 493, 3, 26, 13, 0, 489, 490, 5, 154, 0, 0, 490, 492,
        3, 26, 13, 0, 491, 489, 1, 0, 0, 0, 492, 495, 1, 0, 0, 0, 493, 491, 1, 0, 0, 0, 493, 494, 1,
        0, 0, 0, 494, 497, 1, 0, 0, 0, 495, 493, 1, 0, 0, 0, 496, 488, 1, 0, 0, 0, 496, 497, 1, 0,
        0, 0, 497, 498, 1, 0, 0, 0, 498, 499, 5, 159, 0, 0, 499, 25, 1, 0, 0, 0, 500, 502, 3, 240,
        120, 0, 501, 500, 1, 0, 0, 0, 502, 505, 1, 0, 0, 0, 503, 501, 1, 0, 0, 0, 503, 504, 1, 0, 0,
        0, 504, 506, 1, 0, 0, 0, 505, 503, 1, 0, 0, 0, 506, 508, 3, 252, 126, 0, 507, 509, 3, 290,
        145, 0, 508, 507, 1, 0, 0, 0, 508, 509, 1, 0, 0, 0, 509, 27, 1, 0, 0, 0, 510, 511, 5, 71, 0,
        0, 511, 516, 3, 44, 22, 0, 512, 513, 5, 160, 0, 0, 513, 514, 3, 36, 18, 0, 514, 515, 5, 159,
        0, 0, 515, 517, 1, 0, 0, 0, 516, 512, 1, 0, 0, 0, 516, 517, 1, 0, 0, 0, 517, 521, 1, 0, 0,
        0, 518, 520, 3, 30, 15, 0, 519, 518, 1, 0, 0, 0, 520, 523, 1, 0, 0, 0, 521, 519, 1, 0, 0, 0,
        521, 522, 1, 0, 0, 0, 522, 524, 1, 0, 0, 0, 523, 521, 1, 0, 0, 0, 524, 525, 5, 65, 0, 0,
        525, 29, 1, 0, 0, 0, 526, 530, 7, 0, 0, 0, 527, 529, 3, 52, 26, 0, 528, 527, 1, 0, 0, 0,
        529, 532, 1, 0, 0, 0, 530, 528, 1, 0, 0, 0, 530, 531, 1, 0, 0, 0, 531, 539, 1, 0, 0, 0, 532,
        530, 1, 0, 0, 0, 533, 535, 3, 52, 26, 0, 534, 533, 1, 0, 0, 0, 535, 536, 1, 0, 0, 0, 536,
        534, 1, 0, 0, 0, 536, 537, 1, 0, 0, 0, 537, 539, 1, 0, 0, 0, 538, 526, 1, 0, 0, 0, 538, 534,
        1, 0, 0, 0, 539, 31, 1, 0, 0, 0, 540, 541, 5, 71, 0, 0, 541, 542, 3, 36, 18, 0, 542, 543, 5,
        153, 0, 0, 543, 33, 1, 0, 0, 0, 544, 545, 5, 62, 0, 0, 545, 550, 3, 18, 9, 0, 546, 547, 5,
        154, 0, 0, 547, 549, 3, 18, 9, 0, 548, 546, 1, 0, 0, 0, 549, 552, 1, 0, 0, 0, 550, 548, 1,
        0, 0, 0, 550, 551, 1, 0, 0, 0, 551, 553, 1, 0, 0, 0, 552, 550, 1, 0, 0, 0, 553, 554, 5, 153,
        0, 0, 554, 35, 1, 0, 0, 0, 555, 560, 3, 44, 22, 0, 556, 557, 5, 154, 0, 0, 557, 559, 3, 44,
        22, 0, 558, 556, 1, 0, 0, 0, 559, 562, 1, 0, 0, 0, 560, 558, 1, 0, 0, 0, 560, 561, 1, 0, 0,
        0, 561, 37, 1, 0, 0, 0, 562, 560, 1, 0, 0, 0, 563, 568, 5, 74, 0, 0, 564, 565, 5, 147, 0, 0,
        565, 566, 3, 40, 20, 0, 566, 567, 5, 148, 0, 0, 567, 569, 1, 0, 0, 0, 568, 564, 1, 0, 0, 0,
        568, 569, 1, 0, 0, 0, 569, 571, 1, 0, 0, 0, 570, 572, 3, 232, 116, 0, 571, 570, 1, 0, 0, 0,
        571, 572, 1, 0, 0, 0, 572, 574, 1, 0, 0, 0, 573, 575, 5, 138, 0, 0, 574, 573, 1, 0, 0, 0,
        574, 575, 1, 0, 0, 0, 575, 576, 1, 0, 0, 0, 576, 577, 3, 230, 115, 0, 577, 39, 1, 0, 0, 0,
        578, 583, 3, 42, 21, 0, 579, 580, 5, 154, 0, 0, 580, 582, 3, 42, 21, 0, 581, 579, 1, 0, 0,
        0, 582, 585, 1, 0, 0, 0, 583, 581, 1, 0, 0, 0, 583, 584, 1, 0, 0, 0, 584, 41, 1, 0, 0, 0,
        585, 583, 1, 0, 0, 0, 586, 606, 5, 83, 0, 0, 587, 606, 5, 84, 0, 0, 588, 606, 5, 131, 0, 0,
        589, 606, 5, 134, 0, 0, 590, 606, 5, 85, 0, 0, 591, 606, 5, 127, 0, 0, 592, 606, 5, 135, 0,
        0, 593, 606, 5, 128, 0, 0, 594, 606, 5, 132, 0, 0, 595, 606, 5, 133, 0, 0, 596, 597, 5, 129,
        0, 0, 597, 598, 5, 158, 0, 0, 598, 606, 3, 370, 185, 0, 599, 600, 5, 130, 0, 0, 600, 601, 5,
        158, 0, 0, 601, 602, 3, 370, 185, 0, 602, 603, 5, 164, 0, 0, 603, 606, 1, 0, 0, 0, 604, 606,
        3, 236, 118, 0, 605, 586, 1, 0, 0, 0, 605, 587, 1, 0, 0, 0, 605, 588, 1, 0, 0, 0, 605, 589,
        1, 0, 0, 0, 605, 590, 1, 0, 0, 0, 605, 591, 1, 0, 0, 0, 605, 592, 1, 0, 0, 0, 605, 593, 1,
        0, 0, 0, 605, 594, 1, 0, 0, 0, 605, 595, 1, 0, 0, 0, 605, 596, 1, 0, 0, 0, 605, 599, 1, 0,
        0, 0, 605, 604, 1, 0, 0, 0, 606, 43, 1, 0, 0, 0, 607, 608, 5, 160, 0, 0, 608, 609, 3, 36,
        18, 0, 609, 610, 5, 159, 0, 0, 610, 616, 1, 0, 0, 0, 611, 613, 7, 1, 0, 0, 612, 611, 1, 0,
        0, 0, 612, 613, 1, 0, 0, 0, 613, 614, 1, 0, 0, 0, 614, 616, 3, 370, 185, 0, 615, 607, 1, 0,
        0, 0, 615, 612, 1, 0, 0, 0, 616, 45, 1, 0, 0, 0, 617, 621, 5, 149, 0, 0, 618, 620, 3, 48,
        24, 0, 619, 618, 1, 0, 0, 0, 620, 623, 1, 0, 0, 0, 621, 619, 1, 0, 0, 0, 621, 622, 1, 0, 0,
        0, 622, 624, 1, 0, 0, 0, 623, 621, 1, 0, 0, 0, 624, 625, 5, 150, 0, 0, 625, 47, 1, 0, 0, 0,
        626, 630, 3, 50, 25, 0, 627, 629, 3, 230, 115, 0, 628, 627, 1, 0, 0, 0, 629, 632, 1, 0, 0,
        0, 630, 628, 1, 0, 0, 0, 630, 631, 1, 0, 0, 0, 631, 639, 1, 0, 0, 0, 632, 630, 1, 0, 0, 0,
        633, 635, 3, 230, 115, 0, 634, 633, 1, 0, 0, 0, 635, 636, 1, 0, 0, 0, 636, 634, 1, 0, 0, 0,
        636, 637, 1, 0, 0, 0, 637, 639, 1, 0, 0, 0, 638, 626, 1, 0, 0, 0, 638, 634, 1, 0, 0, 0, 639,
        49, 1, 0, 0, 0, 640, 641, 7, 2, 0, 0, 641, 51, 1, 0, 0, 0, 642, 648, 3, 176, 88, 0, 643,
        648, 3, 54, 27, 0, 644, 648, 3, 56, 28, 0, 645, 648, 3, 38, 19, 0, 646, 648, 3, 130, 65, 0,
        647, 642, 1, 0, 0, 0, 647, 643, 1, 0, 0, 0, 647, 644, 1, 0, 0, 0, 647, 645, 1, 0, 0, 0, 647,
        646, 1, 0, 0, 0, 648, 649, 1, 0, 0, 0, 649, 647, 1, 0, 0, 0, 649, 650, 1, 0, 0, 0, 650, 53,
        1, 0, 0, 0, 651, 652, 5, 173, 0, 0, 652, 653, 3, 58, 29, 0, 653, 55, 1, 0, 0, 0, 654, 655,
        5, 174, 0, 0, 655, 656, 3, 58, 29, 0, 656, 57, 1, 0, 0, 0, 657, 659, 3, 74, 37, 0, 658, 657,
        1, 0, 0, 0, 658, 659, 1, 0, 0, 0, 659, 660, 1, 0, 0, 0, 660, 664, 3, 68, 34, 0, 661, 663, 3,
        210, 105, 0, 662, 661, 1, 0, 0, 0, 663, 666, 1, 0, 0, 0, 664, 662, 1, 0, 0, 0, 664, 665, 1,
        0, 0, 0, 665, 668, 1, 0, 0, 0, 666, 664, 1, 0, 0, 0, 667, 669, 3, 294, 147, 0, 668, 667, 1,
        0, 0, 0, 668, 669, 1, 0, 0, 0, 669, 670, 1, 0, 0, 0, 670, 671, 5, 153, 0, 0, 671, 59, 1, 0,
        0, 0, 672, 678, 3, 132, 66, 0, 673, 678, 3, 176, 88, 0, 674, 678, 3, 62, 31, 0, 675, 678, 3,
        64, 32, 0, 676, 678, 3, 76, 38, 0, 677, 672, 1, 0, 0, 0, 677, 673, 1, 0, 0, 0, 677, 674, 1,
        0, 0, 0, 677, 675, 1, 0, 0, 0, 677, 676, 1, 0, 0, 0, 678, 679, 1, 0, 0, 0, 679, 677, 1, 0,
        0, 0, 679, 680, 1, 0, 0, 0, 680, 61, 1, 0, 0, 0, 681, 682, 5, 173, 0, 0, 682, 683, 3, 66,
        33, 0, 683, 63, 1, 0, 0, 0, 684, 685, 5, 174, 0, 0, 685, 686, 3, 66, 33, 0, 686, 65, 1, 0,
        0, 0, 687, 689, 3, 74, 37, 0, 688, 687, 1, 0, 0, 0, 688, 689, 1, 0, 0, 0, 689, 690, 1, 0, 0,
        0, 690, 692, 3, 68, 34, 0, 691, 693, 3, 178, 89, 0, 692, 691, 1, 0, 0, 0, 692, 693, 1, 0, 0,
        0, 693, 695, 1, 0, 0, 0, 694, 696, 5, 153, 0, 0, 695, 694, 1, 0, 0, 0, 695, 696, 1, 0, 0, 0,
        696, 698, 1, 0, 0, 0, 697, 699, 3, 210, 105, 0, 698, 697, 1, 0, 0, 0, 698, 699, 1, 0, 0, 0,
        699, 700, 1, 0, 0, 0, 700, 702, 3, 312, 156, 0, 701, 703, 5, 153, 0, 0, 702, 701, 1, 0, 0,
        0, 702, 703, 1, 0, 0, 0, 703, 67, 1, 0, 0, 0, 704, 715, 3, 72, 36, 0, 705, 707, 3, 70, 35,
        0, 706, 705, 1, 0, 0, 0, 707, 708, 1, 0, 0, 0, 708, 706, 1, 0, 0, 0, 708, 709, 1, 0, 0, 0,
        709, 712, 1, 0, 0, 0, 710, 711, 5, 154, 0, 0, 711, 713, 5, 191, 0, 0, 712, 710, 1, 0, 0, 0,
        712, 713, 1, 0, 0, 0, 713, 715, 1, 0, 0, 0, 714, 704, 1, 0, 0, 0, 714, 706, 1, 0, 0, 0, 715,
        69, 1, 0, 0, 0, 716, 718, 3, 72, 36, 0, 717, 716, 1, 0, 0, 0, 717, 718, 1, 0, 0, 0, 718,
        719, 1, 0, 0, 0, 719, 723, 5, 164, 0, 0, 720, 722, 3, 74, 37, 0, 721, 720, 1, 0, 0, 0, 722,
        725, 1, 0, 0, 0, 723, 721, 1, 0, 0, 0, 723, 724, 1, 0, 0, 0, 724, 727, 1, 0, 0, 0, 725, 723,
        1, 0, 0, 0, 726, 728, 3, 234, 117, 0, 727, 726, 1, 0, 0, 0, 727, 728, 1, 0, 0, 0, 728, 729,
        1, 0, 0, 0, 729, 730, 3, 370, 185, 0, 730, 71, 1, 0, 0, 0, 731, 738, 3, 370, 185, 0, 732,
        738, 5, 22, 0, 0, 733, 738, 5, 28, 0, 0, 734, 738, 5, 16, 0, 0, 735, 738, 5, 10, 0, 0, 736,
        738, 5, 7, 0, 0, 737, 731, 1, 0, 0, 0, 737, 732, 1, 0, 0, 0, 737, 733, 1, 0, 0, 0, 737, 734,
        1, 0, 0, 0, 737, 735, 1, 0, 0, 0, 737, 736, 1, 0, 0, 0, 738, 73, 1, 0, 0, 0, 739, 740, 5,
        147, 0, 0, 740, 741, 3, 186, 93, 0, 741, 742, 5, 148, 0, 0, 742, 75, 1, 0, 0, 0, 743, 744,
        5, 80, 0, 0, 744, 745, 3, 78, 39, 0, 745, 746, 5, 153, 0, 0, 746, 752, 1, 0, 0, 0, 747, 748,
        5, 63, 0, 0, 748, 749, 3, 78, 39, 0, 749, 750, 5, 153, 0, 0, 750, 752, 1, 0, 0, 0, 751, 743,
        1, 0, 0, 0, 751, 747, 1, 0, 0, 0, 752, 77, 1, 0, 0, 0, 753, 758, 3, 80, 40, 0, 754, 755, 5,
        154, 0, 0, 755, 757, 3, 80, 40, 0, 756, 754, 1, 0, 0, 0, 757, 760, 1, 0, 0, 0, 758, 756, 1,
        0, 0, 0, 758, 759, 1, 0, 0, 0, 759, 79, 1, 0, 0, 0, 760, 758, 1, 0, 0, 0, 761, 764, 3, 370,
        185, 0, 762, 763, 5, 158, 0, 0, 763, 765, 3, 370, 185, 0, 764, 762, 1, 0, 0, 0, 764, 765, 1,
        0, 0, 0, 765, 81, 1, 0, 0, 0, 766, 768, 3, 236, 118, 0, 767, 766, 1, 0, 0, 0, 767, 768, 1,
        0, 0, 0, 768, 769, 1, 0, 0, 0, 769, 771, 3, 252, 126, 0, 770, 772, 3, 236, 118, 0, 771, 770,
        1, 0, 0, 0, 771, 772, 1, 0, 0, 0, 772, 773, 1, 0, 0, 0, 773, 774, 5, 147, 0, 0, 774, 777, 5,
        179, 0, 0, 775, 778, 3, 236, 118, 0, 776, 778, 3, 252, 126, 0, 777, 775, 1, 0, 0, 0, 777,
        776, 1, 0, 0, 0, 777, 778, 1, 0, 0, 0, 778, 779, 1, 0, 0, 0, 779, 781, 5, 148, 0, 0, 780,
        782, 3, 92, 46, 0, 781, 780, 1, 0, 0, 0, 781, 782, 1, 0, 0, 0, 782, 83, 1, 0, 0, 0, 783,
        784, 5, 157, 0, 0, 784, 796, 5, 149, 0, 0, 785, 790, 3, 86, 43, 0, 786, 787, 5, 154, 0, 0,
        787, 789, 3, 86, 43, 0, 788, 786, 1, 0, 0, 0, 789, 792, 1, 0, 0, 0, 790, 788, 1, 0, 0, 0,
        790, 791, 1, 0, 0, 0, 791, 794, 1, 0, 0, 0, 792, 790, 1, 0, 0, 0, 793, 795, 5, 154, 0, 0,
        794, 793, 1, 0, 0, 0, 794, 795, 1, 0, 0, 0, 795, 797, 1, 0, 0, 0, 796, 785, 1, 0, 0, 0, 796,
        797, 1, 0, 0, 0, 797, 798, 1, 0, 0, 0, 798, 799, 5, 150, 0, 0, 799, 85, 1, 0, 0, 0, 800,
        801, 3, 346, 173, 0, 801, 802, 5, 164, 0, 0, 802, 803, 3, 340, 170, 0, 803, 87, 1, 0, 0, 0,
        804, 805, 5, 157, 0, 0, 805, 810, 5, 151, 0, 0, 806, 808, 3, 338, 169, 0, 807, 809, 5, 154,
        0, 0, 808, 807, 1, 0, 0, 0, 808, 809, 1, 0, 0, 0, 809, 811, 1, 0, 0, 0, 810, 806, 1, 0, 0,
        0, 810, 811, 1, 0, 0, 0, 811, 812, 1, 0, 0, 0, 812, 813, 5, 152, 0, 0, 813, 89, 1, 0, 0, 0,
        814, 815, 5, 157, 0, 0, 815, 816, 5, 147, 0, 0, 816, 817, 3, 340, 170, 0, 817, 818, 5, 148,
        0, 0, 818, 825, 1, 0, 0, 0, 819, 822, 5, 157, 0, 0, 820, 823, 3, 366, 183, 0, 821, 823, 3,
        370, 185, 0, 822, 820, 1, 0, 0, 0, 822, 821, 1, 0, 0, 0, 823, 825, 1, 0, 0, 0, 824, 814, 1,
        0, 0, 0, 824, 819, 1, 0, 0, 0, 825, 91, 1, 0, 0, 0, 826, 843, 3, 94, 47, 0, 827, 839, 5,
        147, 0, 0, 828, 831, 3, 94, 47, 0, 829, 831, 5, 32, 0, 0, 830, 828, 1, 0, 0, 0, 830, 829, 1,
        0, 0, 0, 831, 836, 1, 0, 0, 0, 832, 833, 5, 154, 0, 0, 833, 835, 3, 94, 47, 0, 834, 832, 1,
        0, 0, 0, 835, 838, 1, 0, 0, 0, 836, 834, 1, 0, 0, 0, 836, 837, 1, 0, 0, 0, 837, 840, 1, 0,
        0, 0, 838, 836, 1, 0, 0, 0, 839, 830, 1, 0, 0, 0, 839, 840, 1, 0, 0, 0, 840, 841, 1, 0, 0,
        0, 841, 843, 5, 148, 0, 0, 842, 826, 1, 0, 0, 0, 842, 827, 1, 0, 0, 0, 843, 93, 1, 0, 0, 0,
        844, 847, 3, 118, 59, 0, 845, 847, 3, 186, 93, 0, 846, 844, 1, 0, 0, 0, 846, 845, 1, 0, 0,
        0, 847, 95, 1, 0, 0, 0, 848, 850, 5, 179, 0, 0, 849, 851, 3, 252, 126, 0, 850, 849, 1, 0, 0,
        0, 850, 851, 1, 0, 0, 0, 851, 853, 1, 0, 0, 0, 852, 854, 3, 236, 118, 0, 853, 852, 1, 0, 0,
        0, 853, 854, 1, 0, 0, 0, 854, 856, 1, 0, 0, 0, 855, 857, 3, 92, 46, 0, 856, 855, 1, 0, 0, 0,
        856, 857, 1, 0, 0, 0, 857, 858, 1, 0, 0, 0, 858, 859, 3, 312, 156, 0, 859, 97, 1, 0, 0, 0,
        860, 862, 5, 179, 0, 0, 861, 863, 3, 92, 46, 0, 862, 861, 1, 0, 0, 0, 862, 863, 1, 0, 0, 0,
        863, 864, 1, 0, 0, 0, 864, 865, 3, 312, 156, 0, 865, 99, 1, 0, 0, 0, 866, 867, 5, 151, 0, 0,
        867, 868, 3, 102, 51, 0, 868, 869, 3, 104, 52, 0, 869, 870, 5, 152, 0, 0, 870, 101, 1, 0, 0,
        0, 871, 874, 3, 340, 170, 0, 872, 874, 3, 258, 129, 0, 873, 871, 1, 0, 0, 0, 873, 872, 1, 0,
        0, 0, 874, 103, 1, 0, 0, 0, 875, 882, 3, 72, 36, 0, 876, 878, 3, 106, 53, 0, 877, 876, 1, 0,
        0, 0, 878, 879, 1, 0, 0, 0, 879, 877, 1, 0, 0, 0, 879, 880, 1, 0, 0, 0, 880, 882, 1, 0, 0,
        0, 881, 875, 1, 0, 0, 0, 881, 877, 1, 0, 0, 0, 882, 105, 1, 0, 0, 0, 883, 885, 3, 72, 36, 0,
        884, 883, 1, 0, 0, 0, 884, 885, 1, 0, 0, 0, 885, 886, 1, 0, 0, 0, 886, 887, 5, 164, 0, 0,
        887, 892, 3, 108, 54, 0, 888, 889, 5, 154, 0, 0, 889, 891, 3, 108, 54, 0, 890, 888, 1, 0, 0,
        0, 891, 894, 1, 0, 0, 0, 892, 890, 1, 0, 0, 0, 892, 893, 1, 0, 0, 0, 893, 107, 1, 0, 0, 0,
        894, 892, 1, 0, 0, 0, 895, 897, 3, 338, 169, 0, 896, 898, 3, 236, 118, 0, 897, 896, 1, 0, 0,
        0, 897, 898, 1, 0, 0, 0, 898, 903, 1, 0, 0, 0, 899, 900, 5, 149, 0, 0, 900, 901, 3, 302,
        151, 0, 901, 902, 5, 150, 0, 0, 902, 904, 1, 0, 0, 0, 903, 899, 1, 0, 0, 0, 903, 904, 1, 0,
        0, 0, 904, 109, 1, 0, 0, 0, 905, 906, 5, 78, 0, 0, 906, 907, 5, 147, 0, 0, 907, 908, 3, 112,
        56, 0, 908, 909, 5, 148, 0, 0, 909, 111, 1, 0, 0, 0, 910, 920, 3, 72, 36, 0, 911, 913, 3,
        72, 36, 0, 912, 911, 1, 0, 0, 0, 912, 913, 1, 0, 0, 0, 913, 914, 1, 0, 0, 0, 914, 916, 5,
        164, 0, 0, 915, 912, 1, 0, 0, 0, 916, 917, 1, 0, 0, 0, 917, 915, 1, 0, 0, 0, 917, 918, 1, 0,
        0, 0, 918, 920, 1, 0, 0, 0, 919, 910, 1, 0, 0, 0, 919, 915, 1, 0, 0, 0, 920, 113, 1, 0, 0,
        0, 921, 922, 5, 71, 0, 0, 922, 923, 5, 147, 0, 0, 923, 924, 3, 44, 22, 0, 924, 925, 5, 148,
        0, 0, 925, 115, 1, 0, 0, 0, 926, 927, 5, 64, 0, 0, 927, 928, 5, 147, 0, 0, 928, 929, 3, 186,
        93, 0, 929, 930, 5, 148, 0, 0, 930, 117, 1, 0, 0, 0, 931, 932, 3, 174, 87, 0, 932, 933, 3,
        182, 91, 0, 933, 119, 1, 0, 0, 0, 934, 935, 5, 81, 0, 0, 935, 936, 5, 147, 0, 0, 936, 937,
        3, 370, 185, 0, 937, 938, 5, 148, 0, 0, 938, 942, 1, 0, 0, 0, 939, 940, 5, 81, 0, 0, 940,
        942, 3, 340, 170, 0, 941, 934, 1, 0, 0, 0, 941, 939, 1, 0, 0, 0, 942, 121, 1, 0, 0, 0, 943,
        944, 5, 82, 0, 0, 944, 948, 3, 312, 156, 0, 945, 947, 3, 124, 62, 0, 946, 945, 1, 0, 0, 0,
        947, 950, 1, 0, 0, 0, 948, 946, 1, 0, 0, 0, 948, 949, 1, 0, 0, 0, 949, 953, 1, 0, 0, 0, 950,
        948, 1, 0, 0, 0, 951, 952, 5, 66, 0, 0, 952, 954, 3, 312, 156, 0, 953, 951, 1, 0, 0, 0, 953,
        954, 1, 0, 0, 0, 954, 123, 1, 0, 0, 0, 955, 956, 5, 61, 0, 0, 956, 957, 5, 147, 0, 0, 957,
        958, 3, 118, 59, 0, 958, 959, 5, 148, 0, 0, 959, 960, 3, 312, 156, 0, 960, 125, 1, 0, 0, 0,
        961, 962, 5, 79, 0, 0, 962, 963, 5, 147, 0, 0, 963, 964, 3, 340, 170, 0, 964, 965, 5, 148,
        0, 0, 965, 966, 3, 312, 156, 0, 966, 127, 1, 0, 0, 0, 967, 968, 5, 60, 0, 0, 968, 969, 3,
        312, 156, 0, 969, 129, 1, 0, 0, 0, 970, 971, 3, 134, 67, 0, 971, 972, 5, 153, 0, 0, 972,
        131, 1, 0, 0, 0, 973, 974, 3, 134, 67, 0, 974, 975, 3, 312, 156, 0, 975, 133, 1, 0, 0, 0,
        976, 978, 3, 174, 87, 0, 977, 976, 1, 0, 0, 0, 977, 978, 1, 0, 0, 0, 978, 979, 1, 0, 0, 0,
        979, 981, 3, 182, 91, 0, 980, 982, 3, 136, 68, 0, 981, 980, 1, 0, 0, 0, 981, 982, 1, 0, 0,
        0, 982, 135, 1, 0, 0, 0, 983, 985, 3, 176, 88, 0, 984, 983, 1, 0, 0, 0, 985, 986, 1, 0, 0,
        0, 986, 984, 1, 0, 0, 0, 986, 987, 1, 0, 0, 0, 987, 137, 1, 0, 0, 0, 988, 990, 3, 140, 70,
        0, 989, 991, 3, 142, 71, 0, 990, 989, 1, 0, 0, 0, 990, 991, 1, 0, 0, 0, 991, 139, 1, 0, 0,
        0, 992, 995, 5, 5, 0, 0, 993, 995, 3, 370, 185, 0, 994, 992, 1, 0, 0, 0, 994, 993, 1, 0, 0,
        0, 995, 141, 1, 0, 0, 0, 996, 998, 5, 147, 0, 0, 997, 999, 3, 144, 72, 0, 998, 997, 1, 0, 0,
        0, 998, 999, 1, 0, 0, 0, 999, 1000, 1, 0, 0, 0, 1000, 1001, 5, 148, 0, 0, 1001, 143, 1, 0,
        0, 0, 1002, 1007, 3, 146, 73, 0, 1003, 1004, 5, 154, 0, 0, 1004, 1006, 3, 146, 73, 0, 1005,
        1003, 1, 0, 0, 0, 1006, 1009, 1, 0, 0, 0, 1007, 1005, 1, 0, 0, 0, 1007, 1008, 1, 0, 0, 0,
        1008, 145, 1, 0, 0, 0, 1009, 1007, 1, 0, 0, 0, 1010, 1015, 3, 138, 69, 0, 1011, 1015, 3,
        366, 183, 0, 1012, 1015, 3, 368, 184, 0, 1013, 1015, 3, 148, 74, 0, 1014, 1010, 1, 0, 0, 0,
        1014, 1011, 1, 0, 0, 0, 1014, 1012, 1, 0, 0, 0, 1014, 1013, 1, 0, 0, 0, 1015, 147, 1, 0, 0,
        0, 1016, 1017, 3, 140, 70, 0, 1017, 1021, 5, 158, 0, 0, 1018, 1022, 3, 366, 183, 0, 1019,
        1022, 3, 140, 70, 0, 1020, 1022, 3, 368, 184, 0, 1021, 1018, 1, 0, 0, 0, 1021, 1019, 1, 0,
        0, 0, 1021, 1020, 1, 0, 0, 0, 1022, 149, 1, 0, 0, 0, 1023, 1024, 3, 174, 87, 0, 1024, 1025,
        5, 147, 0, 0, 1025, 1027, 5, 175, 0, 0, 1026, 1028, 3, 370, 185, 0, 1027, 1026, 1, 0, 0, 0,
        1027, 1028, 1, 0, 0, 0, 1028, 1029, 1, 0, 0, 0, 1029, 1030, 5, 148, 0, 0, 1030, 1032, 5,
        147, 0, 0, 1031, 1033, 3, 152, 76, 0, 1032, 1031, 1, 0, 0, 0, 1032, 1033, 1, 0, 0, 0, 1033,
        1034, 1, 0, 0, 0, 1034, 1035, 5, 148, 0, 0, 1035, 151, 1, 0, 0, 0, 1036, 1039, 3, 154, 77,
        0, 1037, 1038, 5, 154, 0, 0, 1038, 1040, 5, 191, 0, 0, 1039, 1037, 1, 0, 0, 0, 1039, 1040,
        1, 0, 0, 0, 1040, 153, 1, 0, 0, 0, 1041, 1046, 3, 156, 78, 0, 1042, 1043, 5, 154, 0, 0,
        1043, 1045, 3, 156, 78, 0, 1044, 1042, 1, 0, 0, 0, 1045, 1048, 1, 0, 0, 0, 1046, 1044, 1, 0,
        0, 0, 1046, 1047, 1, 0, 0, 0, 1047, 155, 1, 0, 0, 0, 1048, 1046, 1, 0, 0, 0, 1049, 1052, 3,
        174, 87, 0, 1050, 1052, 3, 150, 75, 0, 1051, 1049, 1, 0, 0, 0, 1051, 1050, 1, 0, 0, 0, 1052,
        1054, 1, 0, 0, 0, 1053, 1055, 3, 182, 91, 0, 1054, 1053, 1, 0, 0, 0, 1054, 1055, 1, 0, 0, 0,
        1055, 1058, 1, 0, 0, 0, 1056, 1058, 5, 32, 0, 0, 1057, 1051, 1, 0, 0, 0, 1057, 1056, 1, 0,
        0, 0, 1058, 157, 1, 0, 0, 0, 1059, 1061, 3, 210, 105, 0, 1060, 1059, 1, 0, 0, 0, 1060, 1061,
        1, 0, 0, 0, 1061, 1062, 1, 0, 0, 0, 1062, 1064, 3, 370, 185, 0, 1063, 1065, 3, 210, 105, 0,
        1064, 1063, 1, 0, 0, 0, 1064, 1065, 1, 0, 0, 0, 1065, 1066, 1, 0, 0, 0, 1066, 1067, 5, 147,
        0, 0, 1067, 1068, 3, 184, 92, 0, 1068, 1069, 5, 148, 0, 0, 1069, 1070, 5, 153, 0, 0, 1070,
        159, 1, 0, 0, 0, 1071, 1073, 3, 210, 105, 0, 1072, 1071, 1, 0, 0, 0, 1072, 1073, 1, 0, 0, 0,
        1073, 1075, 1, 0, 0, 0, 1074, 1076, 5, 29, 0, 0, 1075, 1074, 1, 0, 0, 0, 1075, 1076, 1, 0,
        0, 0, 1076, 1077, 1, 0, 0, 0, 1077, 1079, 3, 270, 135, 0, 1078, 1080, 3, 370, 185, 0, 1079,
        1078, 1, 0, 0, 0, 1079, 1080, 1, 0, 0, 0, 1080, 1081, 1, 0, 0, 0, 1081, 1082, 5, 153, 0, 0,
        1082, 161, 1, 0, 0, 0, 1083, 1084, 3, 174, 87, 0, 1084, 1085, 3, 178, 89, 0, 1085, 1088, 1,
        0, 0, 0, 1086, 1088, 3, 174, 87, 0, 1087, 1083, 1, 0, 0, 0, 1087, 1086, 1, 0, 0, 0, 1088,
        1089, 1, 0, 0, 0, 1089, 1090, 5, 153, 0, 0, 1090, 163, 1, 0, 0, 0, 1091, 1093, 3, 210, 105,
        0, 1092, 1091, 1, 0, 0, 0, 1092, 1093, 1, 0, 0, 0, 1093, 1094, 1, 0, 0, 0, 1094, 1099, 5,
        29, 0, 0, 1095, 1096, 3, 174, 87, 0, 1096, 1097, 3, 166, 83, 0, 1097, 1100, 1, 0, 0, 0,
        1098, 1100, 3, 174, 87, 0, 1099, 1095, 1, 0, 0, 0, 1099, 1098, 1, 0, 0, 0, 1100, 1102, 1, 0,
        0, 0, 1101, 1103, 3, 294, 147, 0, 1102, 1101, 1, 0, 0, 0, 1102, 1103, 1, 0, 0, 0, 1103,
        1104, 1, 0, 0, 0, 1104, 1105, 5, 153, 0, 0, 1105, 1114, 1, 0, 0, 0, 1106, 1108, 3, 210, 105,
        0, 1107, 1106, 1, 0, 0, 0, 1107, 1108, 1, 0, 0, 0, 1108, 1109, 1, 0, 0, 0, 1109, 1110, 5,
        29, 0, 0, 1110, 1111, 3, 150, 75, 0, 1111, 1112, 5, 153, 0, 0, 1112, 1114, 1, 0, 0, 0, 1113,
        1092, 1, 0, 0, 0, 1113, 1107, 1, 0, 0, 0, 1114, 165, 1, 0, 0, 0, 1115, 1120, 3, 182, 91, 0,
        1116, 1117, 5, 154, 0, 0, 1117, 1119, 3, 182, 91, 0, 1118, 1116, 1, 0, 0, 0, 1119, 1122, 1,
        0, 0, 0, 1120, 1118, 1, 0, 0, 0, 1120, 1121, 1, 0, 0, 0, 1121, 167, 1, 0, 0, 0, 1122, 1120,
        1, 0, 0, 0, 1123, 1132, 3, 238, 119, 0, 1124, 1132, 3, 210, 105, 0, 1125, 1132, 3, 234, 117,
        0, 1126, 1132, 3, 236, 118, 0, 1127, 1132, 3, 232, 116, 0, 1128, 1132, 3, 240, 120, 0, 1129,
        1132, 3, 242, 121, 0, 1130, 1132, 3, 252, 126, 0, 1131, 1123, 1, 0, 0, 0, 1131, 1124, 1, 0,
        0, 0, 1131, 1125, 1, 0, 0, 0, 1131, 1126, 1, 0, 0, 0, 1131, 1127, 1, 0, 0, 0, 1131, 1128, 1,
        0, 0, 0, 1131, 1129, 1, 0, 0, 0, 1131, 1130, 1, 0, 0, 0, 1132, 1133, 1, 0, 0, 0, 1133, 1131,
        1, 0, 0, 0, 1133, 1134, 1, 0, 0, 0, 1134, 169, 1, 0, 0, 0, 1135, 1144, 3, 238, 119, 0, 1136,
        1144, 3, 252, 126, 0, 1137, 1144, 3, 242, 121, 0, 1138, 1144, 3, 244, 122, 0, 1139, 1144, 3,
        246, 123, 0, 1140, 1144, 3, 234, 117, 0, 1141, 1144, 3, 236, 118, 0, 1142, 1144, 3, 232,
        116, 0, 1143, 1135, 1, 0, 0, 0, 1143, 1136, 1, 0, 0, 0, 1143, 1137, 1, 0, 0, 0, 1143, 1138,
        1, 0, 0, 0, 1143, 1139, 1, 0, 0, 0, 1143, 1140, 1, 0, 0, 0, 1143, 1141, 1, 0, 0, 0, 1143,
        1142, 1, 0, 0, 0, 1144, 171, 1, 0, 0, 0, 1145, 1154, 3, 238, 119, 0, 1146, 1154, 3, 252,
        126, 0, 1147, 1154, 3, 242, 121, 0, 1148, 1154, 3, 244, 122, 0, 1149, 1154, 3, 246, 123, 0,
        1150, 1154, 3, 234, 117, 0, 1151, 1154, 3, 236, 118, 0, 1152, 1154, 3, 232, 116, 0, 1153,
        1145, 1, 0, 0, 0, 1153, 1146, 1, 0, 0, 0, 1153, 1147, 1, 0, 0, 0, 1153, 1148, 1, 0, 0, 0,
        1153, 1149, 1, 0, 0, 0, 1153, 1150, 1, 0, 0, 0, 1153, 1151, 1, 0, 0, 0, 1153, 1152, 1, 0, 0,
        0, 1154, 173, 1, 0, 0, 0, 1155, 1157, 3, 240, 120, 0, 1156, 1155, 1, 0, 0, 0, 1156, 1157, 1,
        0, 0, 0, 1157, 1159, 1, 0, 0, 0, 1158, 1160, 3, 172, 86, 0, 1159, 1158, 1, 0, 0, 0, 1160,
        1161, 1, 0, 0, 0, 1161, 1159, 1, 0, 0, 0, 1161, 1162, 1, 0, 0, 0, 1162, 175, 1, 0, 0, 0,
        1163, 1165, 3, 174, 87, 0, 1164, 1166, 3, 178, 89, 0, 1165, 1164, 1, 0, 0, 0, 1165, 1166, 1,
        0, 0, 0, 1166, 1167, 1, 0, 0, 0, 1167, 1168, 5, 153, 0, 0, 1168, 1171, 1, 0, 0, 0, 1169,
        1171, 3, 304, 152, 0, 1170, 1163, 1, 0, 0, 0, 1170, 1169, 1, 0, 0, 0, 1171, 177, 1, 0, 0, 0,
        1172, 1177, 3, 180, 90, 0, 1173, 1174, 5, 154, 0, 0, 1174, 1176, 3, 180, 90, 0, 1175, 1173,
        1, 0, 0, 0, 1176, 1179, 1, 0, 0, 0, 1177, 1175, 1, 0, 0, 0, 1177, 1178, 1, 0, 0, 0, 1178,
        179, 1, 0, 0, 0, 1179, 1177, 1, 0, 0, 0, 1180, 1183, 3, 182, 91, 0, 1181, 1182, 5, 158, 0,
        0, 1182, 1184, 3, 348, 174, 0, 1183, 1181, 1, 0, 0, 0, 1183, 1184, 1, 0, 0, 0, 1184, 181, 1,
        0, 0, 0, 1185, 1187, 3, 290, 145, 0, 1186, 1185, 1, 0, 0, 0, 1186, 1187, 1, 0, 0, 0, 1187,
        1188, 1, 0, 0, 0, 1188, 1192, 3, 184, 92, 0, 1189, 1191, 3, 280, 140, 0, 1190, 1189, 1, 0,
        0, 0, 1191, 1194, 1, 0, 0, 0, 1192, 1190, 1, 0, 0, 0, 1192, 1193, 1, 0, 0, 0, 1193, 183, 1,
        0, 0, 0, 1194, 1192, 1, 0, 0, 0, 1195, 1196, 6, 92, -1, 0, 1196, 1224, 3, 370, 185, 0, 1197,
        1198, 5, 147, 0, 0, 1198, 1199, 3, 182, 91, 0, 1199, 1200, 5, 148, 0, 0, 1200, 1224, 1, 0,
        0, 0, 1201, 1202, 5, 147, 0, 0, 1202, 1204, 5, 179, 0, 0, 1203, 1205, 3, 236, 118, 0, 1204,
        1203, 1, 0, 0, 0, 1204, 1205, 1, 0, 0, 0, 1205, 1207, 1, 0, 0, 0, 1206, 1208, 3, 184, 92, 0,
        1207, 1206, 1, 0, 0, 0, 1207, 1208, 1, 0, 0, 0, 1208, 1209, 1, 0, 0, 0, 1209, 1210, 5, 148,
        0, 0, 1210, 1224, 3, 92, 46, 0, 1211, 1212, 3, 370, 185, 0, 1212, 1213, 5, 164, 0, 0, 1213,
        1214, 5, 198, 0, 0, 1214, 1224, 1, 0, 0, 0, 1215, 1216, 3, 278, 139, 0, 1216, 1217, 3, 370,
        185, 0, 1217, 1224, 1, 0, 0, 0, 1218, 1219, 5, 147, 0, 0, 1219, 1220, 3, 278, 139, 0, 1220,
        1221, 3, 182, 91, 0, 1221, 1222, 5, 148, 0, 0, 1222, 1224, 1, 0, 0, 0, 1223, 1195, 1, 0, 0,
        0, 1223, 1197, 1, 0, 0, 0, 1223, 1201, 1, 0, 0, 0, 1223, 1211, 1, 0, 0, 0, 1223, 1215, 1, 0,
        0, 0, 1223, 1218, 1, 0, 0, 0, 1224, 1265, 1, 0, 0, 0, 1225, 1226, 10, 9, 0, 0, 1226, 1228,
        5, 151, 0, 0, 1227, 1229, 3, 204, 102, 0, 1228, 1227, 1, 0, 0, 0, 1228, 1229, 1, 0, 0, 0,
        1229, 1231, 1, 0, 0, 0, 1230, 1232, 3, 364, 182, 0, 1231, 1230, 1, 0, 0, 0, 1231, 1232, 1,
        0, 0, 0, 1232, 1233, 1, 0, 0, 0, 1233, 1264, 5, 152, 0, 0, 1234, 1235, 10, 8, 0, 0, 1235,
        1236, 5, 151, 0, 0, 1236, 1238, 5, 26, 0, 0, 1237, 1239, 3, 204, 102, 0, 1238, 1237, 1, 0,
        0, 0, 1238, 1239, 1, 0, 0, 0, 1239, 1240, 1, 0, 0, 0, 1240, 1241, 3, 364, 182, 0, 1241,
        1242, 5, 152, 0, 0, 1242, 1264, 1, 0, 0, 0, 1243, 1244, 10, 7, 0, 0, 1244, 1245, 5, 151, 0,
        0, 1245, 1246, 3, 204, 102, 0, 1246, 1247, 5, 26, 0, 0, 1247, 1248, 3, 364, 182, 0, 1248,
        1249, 5, 152, 0, 0, 1249, 1264, 1, 0, 0, 0, 1250, 1251, 10, 6, 0, 0, 1251, 1253, 5, 151, 0,
        0, 1252, 1254, 3, 204, 102, 0, 1253, 1252, 1, 0, 0, 0, 1253, 1254, 1, 0, 0, 0, 1254, 1255,
        1, 0, 0, 0, 1255, 1256, 5, 175, 0, 0, 1256, 1264, 5, 152, 0, 0, 1257, 1258, 10, 5, 0, 0,
        1258, 1260, 5, 147, 0, 0, 1259, 1261, 3, 196, 98, 0, 1260, 1259, 1, 0, 0, 0, 1260, 1261, 1,
        0, 0, 0, 1261, 1262, 1, 0, 0, 0, 1262, 1264, 5, 148, 0, 0, 1263, 1225, 1, 0, 0, 0, 1263,
        1234, 1, 0, 0, 0, 1263, 1243, 1, 0, 0, 0, 1263, 1250, 1, 0, 0, 0, 1263, 1257, 1, 0, 0, 0,
        1264, 1267, 1, 0, 0, 0, 1265, 1263, 1, 0, 0, 0, 1265, 1266, 1, 0, 0, 0, 1266, 185, 1, 0, 0,
        0, 1267, 1265, 1, 0, 0, 0, 1268, 1270, 3, 174, 87, 0, 1269, 1271, 3, 190, 95, 0, 1270, 1269,
        1, 0, 0, 0, 1270, 1271, 1, 0, 0, 0, 1271, 187, 1, 0, 0, 0, 1272, 1274, 3, 290, 145, 0, 1273,
        1275, 3, 188, 94, 0, 1274, 1273, 1, 0, 0, 0, 1274, 1275, 1, 0, 0, 0, 1275, 1296, 1, 0, 0, 0,
        1276, 1278, 5, 147, 0, 0, 1277, 1279, 3, 190, 95, 0, 1278, 1277, 1, 0, 0, 0, 1278, 1279, 1,
        0, 0, 0, 1279, 1280, 1, 0, 0, 0, 1280, 1282, 5, 148, 0, 0, 1281, 1283, 3, 194, 97, 0, 1282,
        1281, 1, 0, 0, 0, 1283, 1284, 1, 0, 0, 0, 1284, 1282, 1, 0, 0, 0, 1284, 1285, 1, 0, 0, 0,
        1285, 1296, 1, 0, 0, 0, 1286, 1288, 5, 151, 0, 0, 1287, 1289, 3, 350, 175, 0, 1288, 1287, 1,
        0, 0, 0, 1288, 1289, 1, 0, 0, 0, 1289, 1290, 1, 0, 0, 0, 1290, 1292, 5, 152, 0, 0, 1291,
        1286, 1, 0, 0, 0, 1292, 1293, 1, 0, 0, 0, 1293, 1291, 1, 0, 0, 0, 1293, 1294, 1, 0, 0, 0,
        1294, 1296, 1, 0, 0, 0, 1295, 1272, 1, 0, 0, 0, 1295, 1276, 1, 0, 0, 0, 1295, 1291, 1, 0, 0,
        0, 1296, 189, 1, 0, 0, 0, 1297, 1309, 3, 290, 145, 0, 1298, 1300, 3, 290, 145, 0, 1299,
        1298, 1, 0, 0, 0, 1299, 1300, 1, 0, 0, 0, 1300, 1301, 1, 0, 0, 0, 1301, 1305, 3, 192, 96, 0,
        1302, 1304, 3, 280, 140, 0, 1303, 1302, 1, 0, 0, 0, 1304, 1307, 1, 0, 0, 0, 1305, 1303, 1,
        0, 0, 0, 1305, 1306, 1, 0, 0, 0, 1306, 1309, 1, 0, 0, 0, 1307, 1305, 1, 0, 0, 0, 1308, 1297,
        1, 0, 0, 0, 1308, 1299, 1, 0, 0, 0, 1309, 191, 1, 0, 0, 0, 1310, 1311, 6, 96, -1, 0, 1311,
        1312, 5, 147, 0, 0, 1312, 1313, 3, 190, 95, 0, 1313, 1317, 5, 148, 0, 0, 1314, 1316, 3, 280,
        140, 0, 1315, 1314, 1, 0, 0, 0, 1316, 1319, 1, 0, 0, 0, 1317, 1315, 1, 0, 0, 0, 1317, 1318,
        1, 0, 0, 0, 1318, 1364, 1, 0, 0, 0, 1319, 1317, 1, 0, 0, 0, 1320, 1322, 5, 151, 0, 0, 1321,
        1323, 3, 204, 102, 0, 1322, 1321, 1, 0, 0, 0, 1322, 1323, 1, 0, 0, 0, 1323, 1325, 1, 0, 0,
        0, 1324, 1326, 3, 364, 182, 0, 1325, 1324, 1, 0, 0, 0, 1325, 1326, 1, 0, 0, 0, 1326, 1327,
        1, 0, 0, 0, 1327, 1364, 5, 152, 0, 0, 1328, 1329, 5, 151, 0, 0, 1329, 1331, 5, 26, 0, 0,
        1330, 1332, 3, 204, 102, 0, 1331, 1330, 1, 0, 0, 0, 1331, 1332, 1, 0, 0, 0, 1332, 1333, 1,
        0, 0, 0, 1333, 1334, 3, 364, 182, 0, 1334, 1335, 5, 152, 0, 0, 1335, 1364, 1, 0, 0, 0, 1336,
        1337, 5, 151, 0, 0, 1337, 1338, 3, 204, 102, 0, 1338, 1339, 5, 26, 0, 0, 1339, 1340, 3, 364,
        182, 0, 1340, 1341, 5, 152, 0, 0, 1341, 1364, 1, 0, 0, 0, 1342, 1343, 5, 151, 0, 0, 1343,
        1344, 5, 175, 0, 0, 1344, 1364, 5, 152, 0, 0, 1345, 1347, 5, 147, 0, 0, 1346, 1348, 3, 196,
        98, 0, 1347, 1346, 1, 0, 0, 0, 1347, 1348, 1, 0, 0, 0, 1348, 1349, 1, 0, 0, 0, 1349, 1353,
        5, 148, 0, 0, 1350, 1352, 3, 280, 140, 0, 1351, 1350, 1, 0, 0, 0, 1352, 1355, 1, 0, 0, 0,
        1353, 1351, 1, 0, 0, 0, 1353, 1354, 1, 0, 0, 0, 1354, 1364, 1, 0, 0, 0, 1355, 1353, 1, 0, 0,
        0, 1356, 1357, 5, 147, 0, 0, 1357, 1359, 5, 179, 0, 0, 1358, 1360, 3, 236, 118, 0, 1359,
        1358, 1, 0, 0, 0, 1359, 1360, 1, 0, 0, 0, 1360, 1361, 1, 0, 0, 0, 1361, 1362, 5, 148, 0, 0,
        1362, 1364, 3, 92, 46, 0, 1363, 1310, 1, 0, 0, 0, 1363, 1320, 1, 0, 0, 0, 1363, 1328, 1, 0,
        0, 0, 1363, 1336, 1, 0, 0, 0, 1363, 1342, 1, 0, 0, 0, 1363, 1345, 1, 0, 0, 0, 1363, 1356, 1,
        0, 0, 0, 1364, 1408, 1, 0, 0, 0, 1365, 1366, 10, 6, 0, 0, 1366, 1368, 5, 151, 0, 0, 1367,
        1369, 3, 204, 102, 0, 1368, 1367, 1, 0, 0, 0, 1368, 1369, 1, 0, 0, 0, 1369, 1371, 1, 0, 0,
        0, 1370, 1372, 3, 364, 182, 0, 1371, 1370, 1, 0, 0, 0, 1371, 1372, 1, 0, 0, 0, 1372, 1373,
        1, 0, 0, 0, 1373, 1407, 5, 152, 0, 0, 1374, 1375, 10, 5, 0, 0, 1375, 1376, 5, 151, 0, 0,
        1376, 1378, 5, 26, 0, 0, 1377, 1379, 3, 204, 102, 0, 1378, 1377, 1, 0, 0, 0, 1378, 1379, 1,
        0, 0, 0, 1379, 1380, 1, 0, 0, 0, 1380, 1381, 3, 364, 182, 0, 1381, 1382, 5, 152, 0, 0, 1382,
        1407, 1, 0, 0, 0, 1383, 1384, 10, 4, 0, 0, 1384, 1385, 5, 151, 0, 0, 1385, 1386, 3, 204,
        102, 0, 1386, 1387, 5, 26, 0, 0, 1387, 1388, 3, 364, 182, 0, 1388, 1389, 5, 152, 0, 0, 1389,
        1407, 1, 0, 0, 0, 1390, 1391, 10, 3, 0, 0, 1391, 1392, 5, 151, 0, 0, 1392, 1393, 5, 175, 0,
        0, 1393, 1407, 5, 152, 0, 0, 1394, 1395, 10, 2, 0, 0, 1395, 1397, 5, 147, 0, 0, 1396, 1398,
        3, 196, 98, 0, 1397, 1396, 1, 0, 0, 0, 1397, 1398, 1, 0, 0, 0, 1398, 1399, 1, 0, 0, 0, 1399,
        1403, 5, 148, 0, 0, 1400, 1402, 3, 280, 140, 0, 1401, 1400, 1, 0, 0, 0, 1402, 1405, 1, 0, 0,
        0, 1403, 1401, 1, 0, 0, 0, 1403, 1404, 1, 0, 0, 0, 1404, 1407, 1, 0, 0, 0, 1405, 1403, 1, 0,
        0, 0, 1406, 1365, 1, 0, 0, 0, 1406, 1374, 1, 0, 0, 0, 1406, 1383, 1, 0, 0, 0, 1406, 1390, 1,
        0, 0, 0, 1406, 1394, 1, 0, 0, 0, 1407, 1410, 1, 0, 0, 0, 1408, 1406, 1, 0, 0, 0, 1408, 1409,
        1, 0, 0, 0, 1409, 193, 1, 0, 0, 0, 1410, 1408, 1, 0, 0, 0, 1411, 1413, 5, 151, 0, 0, 1412,
        1414, 3, 350, 175, 0, 1413, 1412, 1, 0, 0, 0, 1413, 1414, 1, 0, 0, 0, 1414, 1415, 1, 0, 0,
        0, 1415, 1422, 5, 152, 0, 0, 1416, 1418, 5, 147, 0, 0, 1417, 1419, 3, 200, 100, 0, 1418,
        1417, 1, 0, 0, 0, 1418, 1419, 1, 0, 0, 0, 1419, 1420, 1, 0, 0, 0, 1420, 1422, 5, 148, 0, 0,
        1421, 1411, 1, 0, 0, 0, 1421, 1416, 1, 0, 0, 0, 1422, 195, 1, 0, 0, 0, 1423, 1426, 3, 198,
        99, 0, 1424, 1425, 5, 154, 0, 0, 1425, 1427, 5, 191, 0, 0, 1426, 1424, 1, 0, 0, 0, 1426,
        1427, 1, 0, 0, 0, 1427, 197, 1, 0, 0, 0, 1428, 1433, 3, 202, 101, 0, 1429, 1430, 5, 154, 0,
        0, 1430, 1432, 3, 202, 101, 0, 1431, 1429, 1, 0, 0, 0, 1432, 1435, 1, 0, 0, 0, 1433, 1431,
        1, 0, 0, 0, 1433, 1434, 1, 0, 0, 0, 1434, 199, 1, 0, 0, 0, 1435, 1433, 1, 0, 0, 0, 1436,
        1441, 3, 202, 101, 0, 1437, 1438, 5, 154, 0, 0, 1438, 1440, 3, 202, 101, 0, 1439, 1437, 1,
        0, 0, 0, 1440, 1443, 1, 0, 0, 0, 1441, 1439, 1, 0, 0, 0, 1441, 1442, 1, 0, 0, 0, 1442, 201,
        1, 0, 0, 0, 1443, 1441, 1, 0, 0, 0, 1444, 1445, 3, 174, 87, 0, 1445, 1446, 3, 182, 91, 0,
        1446, 1452, 1, 0, 0, 0, 1447, 1449, 3, 174, 87, 0, 1448, 1450, 3, 190, 95, 0, 1449, 1448, 1,
        0, 0, 0, 1449, 1450, 1, 0, 0, 0, 1450, 1452, 1, 0, 0, 0, 1451, 1444, 1, 0, 0, 0, 1451, 1447,
        1, 0, 0, 0, 1452, 203, 1, 0, 0, 0, 1453, 1455, 3, 242, 121, 0, 1454, 1453, 1, 0, 0, 0, 1455,
        1456, 1, 0, 0, 0, 1456, 1454, 1, 0, 0, 0, 1456, 1457, 1, 0, 0, 0, 1457, 205, 1, 0, 0, 0,
        1458, 1463, 3, 370, 185, 0, 1459, 1460, 5, 154, 0, 0, 1460, 1462, 3, 370, 185, 0, 1461,
        1459, 1, 0, 0, 0, 1462, 1465, 1, 0, 0, 0, 1463, 1461, 1, 0, 0, 0, 1463, 1464, 1, 0, 0, 0,
        1464, 207, 1, 0, 0, 0, 1465, 1463, 1, 0, 0, 0, 1466, 1468, 5, 151, 0, 0, 1467, 1469, 3, 350,
        175, 0, 1468, 1467, 1, 0, 0, 0, 1468, 1469, 1, 0, 0, 0, 1469, 1470, 1, 0, 0, 0, 1470, 1471,
        5, 152, 0, 0, 1471, 209, 1, 0, 0, 0, 1472, 1473, 5, 86, 0, 0, 1473, 1474, 5, 147, 0, 0,
        1474, 1475, 5, 147, 0, 0, 1475, 1480, 3, 138, 69, 0, 1476, 1477, 5, 154, 0, 0, 1477, 1479,
        3, 138, 69, 0, 1478, 1476, 1, 0, 0, 0, 1479, 1482, 1, 0, 0, 0, 1480, 1478, 1, 0, 0, 0, 1480,
        1481, 1, 0, 0, 0, 1481, 1483, 1, 0, 0, 0, 1482, 1480, 1, 0, 0, 0, 1483, 1484, 5, 148, 0, 0,
        1484, 1485, 5, 148, 0, 0, 1485, 211, 1, 0, 0, 0, 1486, 1487, 5, 115, 0, 0, 1487, 1488, 5,
        147, 0, 0, 1488, 1489, 3, 186, 93, 0, 1489, 1490, 5, 148, 0, 0, 1490, 213, 1, 0, 0, 0, 1491,
        1495, 7, 3, 0, 0, 1492, 1494, 3, 210, 105, 0, 1493, 1492, 1, 0, 0, 0, 1494, 1497, 1, 0, 0,
        0, 1495, 1493, 1, 0, 0, 0, 1495, 1496, 1, 0, 0, 0, 1496, 1510, 1, 0, 0, 0, 1497, 1495, 1, 0,
        0, 0, 1498, 1511, 3, 370, 185, 0, 1499, 1501, 3, 370, 185, 0, 1500, 1499, 1, 0, 0, 0, 1500,
        1501, 1, 0, 0, 0, 1501, 1502, 1, 0, 0, 0, 1502, 1504, 5, 149, 0, 0, 1503, 1505, 3, 230, 115,
        0, 1504, 1503, 1, 0, 0, 0, 1505, 1506, 1, 0, 0, 0, 1506, 1504, 1, 0, 0, 0, 1506, 1507, 1, 0,
        0, 0, 1507, 1508, 1, 0, 0, 0, 1508, 1509, 5, 150, 0, 0, 1509, 1511, 1, 0, 0, 0, 1510, 1498,
        1, 0, 0, 0, 1510, 1500, 1, 0, 0, 0, 1511, 215, 1, 0, 0, 0, 1512, 1514, 3, 218, 109, 0, 1513,
        1515, 3, 370, 185, 0, 1514, 1513, 1, 0, 0, 0, 1514, 1515, 1, 0, 0, 0, 1515, 1516, 1, 0, 0,
        0, 1516, 1517, 5, 149, 0, 0, 1517, 1518, 3, 220, 110, 0, 1518, 1519, 5, 150, 0, 0, 1519,
        1524, 1, 0, 0, 0, 1520, 1521, 3, 218, 109, 0, 1521, 1522, 3, 370, 185, 0, 1522, 1524, 1, 0,
        0, 0, 1523, 1512, 1, 0, 0, 0, 1523, 1520, 1, 0, 0, 0, 1524, 217, 1, 0, 0, 0, 1525, 1526, 7,
        3, 0, 0, 1526, 219, 1, 0, 0, 0, 1527, 1529, 3, 222, 111, 0, 1528, 1527, 1, 0, 0, 0, 1529,
        1530, 1, 0, 0, 0, 1530, 1528, 1, 0, 0, 0, 1530, 1531, 1, 0, 0, 0, 1531, 221, 1, 0, 0, 0,
        1532, 1533, 3, 224, 112, 0, 1533, 1534, 3, 226, 113, 0, 1534, 1535, 5, 153, 0, 0, 1535,
        1541, 1, 0, 0, 0, 1536, 1537, 3, 224, 112, 0, 1537, 1538, 5, 153, 0, 0, 1538, 1541, 1, 0, 0,
        0, 1539, 1541, 3, 304, 152, 0, 1540, 1532, 1, 0, 0, 0, 1540, 1536, 1, 0, 0, 0, 1540, 1539,
        1, 0, 0, 0, 1541, 223, 1, 0, 0, 0, 1542, 1545, 3, 252, 126, 0, 1543, 1545, 3, 242, 121, 0,
        1544, 1542, 1, 0, 0, 0, 1544, 1543, 1, 0, 0, 0, 1545, 1547, 1, 0, 0, 0, 1546, 1548, 3, 224,
        112, 0, 1547, 1546, 1, 0, 0, 0, 1547, 1548, 1, 0, 0, 0, 1548, 225, 1, 0, 0, 0, 1549, 1554,
        3, 228, 114, 0, 1550, 1551, 5, 154, 0, 0, 1551, 1553, 3, 228, 114, 0, 1552, 1550, 1, 0, 0,
        0, 1553, 1556, 1, 0, 0, 0, 1554, 1552, 1, 0, 0, 0, 1554, 1555, 1, 0, 0, 0, 1555, 227, 1, 0,
        0, 0, 1556, 1554, 1, 0, 0, 0, 1557, 1564, 3, 182, 91, 0, 1558, 1560, 3, 182, 91, 0, 1559,
        1558, 1, 0, 0, 0, 1559, 1560, 1, 0, 0, 0, 1560, 1561, 1, 0, 0, 0, 1561, 1562, 5, 164, 0, 0,
        1562, 1564, 3, 350, 175, 0, 1563, 1557, 1, 0, 0, 0, 1563, 1559, 1, 0, 0, 0, 1564, 229, 1, 0,
        0, 0, 1565, 1566, 3, 174, 87, 0, 1566, 1568, 3, 266, 133, 0, 1567, 1569, 3, 294, 147, 0,
        1568, 1567, 1, 0, 0, 0, 1568, 1569, 1, 0, 0, 0, 1569, 1570, 1, 0, 0, 0, 1570, 1571, 5, 153,
        0, 0, 1571, 231, 1, 0, 0, 0, 1572, 1573, 5, 137, 0, 0, 1573, 1574, 5, 147, 0, 0, 1574, 1575,
        3, 370, 185, 0, 1575, 1576, 5, 148, 0, 0, 1576, 1579, 1, 0, 0, 0, 1577, 1579, 5, 136, 0, 0,
        1578, 1572, 1, 0, 0, 0, 1578, 1577, 1, 0, 0, 0, 1579, 233, 1, 0, 0, 0, 1580, 1581, 7, 4, 0,
        0, 1581, 235, 1, 0, 0, 0, 1582, 1583, 7, 5, 0, 0, 1583, 237, 1, 0, 0, 0, 1584, 1585, 7, 6,
        0, 0, 1585, 239, 1, 0, 0, 0, 1586, 1587, 7, 7, 0, 0, 1587, 241, 1, 0, 0, 0, 1588, 1594, 5,
        5, 0, 0, 1589, 1594, 5, 33, 0, 0, 1590, 1594, 5, 21, 0, 0, 1591, 1594, 5, 115, 0, 0, 1592,
        1594, 3, 248, 124, 0, 1593, 1588, 1, 0, 0, 0, 1593, 1589, 1, 0, 0, 0, 1593, 1590, 1, 0, 0,
        0, 1593, 1591, 1, 0, 0, 0, 1593, 1592, 1, 0, 0, 0, 1594, 243, 1, 0, 0, 0, 1595, 1603, 7, 8,
        0, 0, 1596, 1603, 3, 282, 141, 0, 1597, 1598, 5, 106, 0, 0, 1598, 1599, 5, 147, 0, 0, 1599,
        1600, 3, 370, 185, 0, 1600, 1601, 5, 148, 0, 0, 1601, 1603, 1, 0, 0, 0, 1602, 1595, 1, 0, 0,
        0, 1602, 1596, 1, 0, 0, 0, 1602, 1597, 1, 0, 0, 0, 1603, 245, 1, 0, 0, 0, 1604, 1605, 5,
        117, 0, 0, 1605, 1608, 5, 147, 0, 0, 1606, 1609, 3, 186, 93, 0, 1607, 1609, 3, 350, 175, 0,
        1608, 1606, 1, 0, 0, 0, 1608, 1607, 1, 0, 0, 0, 1609, 1610, 1, 0, 0, 0, 1610, 1611, 5, 148,
        0, 0, 1611, 247, 1, 0, 0, 0, 1612, 1613, 7, 9, 0, 0, 1613, 249, 1, 0, 0, 0, 1614, 1616, 3,
        264, 132, 0, 1615, 1617, 3, 290, 145, 0, 1616, 1615, 1, 0, 0, 0, 1616, 1617, 1, 0, 0, 0,
        1617, 1639, 1, 0, 0, 0, 1618, 1639, 3, 254, 127, 0, 1619, 1621, 5, 95, 0, 0, 1620, 1619, 1,
        0, 0, 0, 1620, 1621, 1, 0, 0, 0, 1621, 1622, 1, 0, 0, 0, 1622, 1624, 3, 258, 129, 0, 1623,
        1625, 3, 290, 145, 0, 1624, 1623, 1, 0, 0, 0, 1624, 1625, 1, 0, 0, 0, 1625, 1639, 1, 0, 0,
        0, 1626, 1628, 3, 216, 108, 0, 1627, 1629, 3, 290, 145, 0, 1628, 1627, 1, 0, 0, 0, 1628,
        1629, 1, 0, 0, 0, 1629, 1639, 1, 0, 0, 0, 1630, 1639, 3, 270, 135, 0, 1631, 1633, 5, 95, 0,
        0, 1632, 1631, 1, 0, 0, 0, 1632, 1633, 1, 0, 0, 0, 1633, 1634, 1, 0, 0, 0, 1634, 1636, 3,
        370, 185, 0, 1635, 1637, 3, 290, 145, 0, 1636, 1635, 1, 0, 0, 0, 1636, 1637, 1, 0, 0, 0,
        1637, 1639, 1, 0, 0, 0, 1638, 1614, 1, 0, 0, 0, 1638, 1618, 1, 0, 0, 0, 1638, 1620, 1, 0, 0,
        0, 1638, 1626, 1, 0, 0, 0, 1638, 1630, 1, 0, 0, 0, 1638, 1632, 1, 0, 0, 0, 1639, 251, 1, 0,
        0, 0, 1640, 1652, 3, 264, 132, 0, 1641, 1642, 5, 111, 0, 0, 1642, 1643, 5, 147, 0, 0, 1643,
        1644, 7, 10, 0, 0, 1644, 1652, 5, 148, 0, 0, 1645, 1652, 3, 258, 129, 0, 1646, 1652, 3, 212,
        106, 0, 1647, 1652, 3, 216, 108, 0, 1648, 1652, 3, 270, 135, 0, 1649, 1652, 3, 256, 128, 0,
        1650, 1652, 3, 254, 127, 0, 1651, 1640, 1, 0, 0, 0, 1651, 1641, 1, 0, 0, 0, 1651, 1645, 1,
        0, 0, 0, 1651, 1646, 1, 0, 0, 0, 1651, 1647, 1, 0, 0, 0, 1651, 1648, 1, 0, 0, 0, 1651, 1649,
        1, 0, 0, 0, 1651, 1650, 1, 0, 0, 0, 1652, 253, 1, 0, 0, 0, 1653, 1654, 5, 97, 0, 0, 1654,
        1655, 5, 147, 0, 0, 1655, 1656, 3, 340, 170, 0, 1656, 1657, 5, 148, 0, 0, 1657, 255, 1, 0,
        0, 0, 1658, 1659, 3, 370, 185, 0, 1659, 257, 1, 0, 0, 0, 1660, 1661, 3, 370, 185, 0, 1661,
        1662, 3, 260, 130, 0, 1662, 259, 1, 0, 0, 0, 1663, 1672, 5, 160, 0, 0, 1664, 1669, 3, 262,
        131, 0, 1665, 1666, 5, 154, 0, 0, 1666, 1668, 3, 262, 131, 0, 1667, 1665, 1, 0, 0, 0, 1668,
        1671, 1, 0, 0, 0, 1669, 1667, 1, 0, 0, 0, 1669, 1670, 1, 0, 0, 0, 1670, 1673, 1, 0, 0, 0,
        1671, 1669, 1, 0, 0, 0, 1672, 1664, 1, 0, 0, 0, 1672, 1673, 1, 0, 0, 0, 1673, 1674, 1, 0, 0,
        0, 1674, 1675, 5, 159, 0, 0, 1675, 261, 1, 0, 0, 0, 1676, 1678, 7, 1, 0, 0, 1677, 1676, 1,
        0, 0, 0, 1677, 1678, 1, 0, 0, 0, 1678, 1679, 1, 0, 0, 0, 1679, 1680, 3, 186, 93, 0, 1680,
        263, 1, 0, 0, 0, 1681, 1682, 7, 11, 0, 0, 1682, 265, 1, 0, 0, 0, 1683, 1688, 3, 268, 134, 0,
        1684, 1685, 5, 154, 0, 0, 1685, 1687, 3, 268, 134, 0, 1686, 1684, 1, 0, 0, 0, 1687, 1690, 1,
        0, 0, 0, 1688, 1686, 1, 0, 0, 0, 1688, 1689, 1, 0, 0, 0, 1689, 267, 1, 0, 0, 0, 1690, 1688,
        1, 0, 0, 0, 1691, 1698, 3, 182, 91, 0, 1692, 1694, 3, 182, 91, 0, 1693, 1692, 1, 0, 0, 0,
        1693, 1694, 1, 0, 0, 0, 1694, 1695, 1, 0, 0, 0, 1695, 1696, 5, 164, 0, 0, 1696, 1698, 3,
        366, 183, 0, 1697, 1691, 1, 0, 0, 0, 1697, 1693, 1, 0, 0, 0, 1698, 269, 1, 0, 0, 0, 1699,
        1705, 5, 11, 0, 0, 1700, 1702, 3, 370, 185, 0, 1701, 1700, 1, 0, 0, 0, 1701, 1702, 1, 0, 0,
        0, 1702, 1703, 1, 0, 0, 0, 1703, 1704, 5, 164, 0, 0, 1704, 1706, 3, 186, 93, 0, 1705, 1701,
        1, 0, 0, 0, 1705, 1706, 1, 0, 0, 0, 1706, 1718, 1, 0, 0, 0, 1707, 1712, 3, 370, 185, 0,
        1708, 1709, 5, 149, 0, 0, 1709, 1710, 3, 272, 136, 0, 1710, 1711, 5, 150, 0, 0, 1711, 1713,
        1, 0, 0, 0, 1712, 1708, 1, 0, 0, 0, 1712, 1713, 1, 0, 0, 0, 1713, 1719, 1, 0, 0, 0, 1714,
        1715, 5, 149, 0, 0, 1715, 1716, 3, 272, 136, 0, 1716, 1717, 5, 150, 0, 0, 1717, 1719, 1, 0,
        0, 0, 1718, 1707, 1, 0, 0, 0, 1718, 1714, 1, 0, 0, 0, 1719, 1731, 1, 0, 0, 0, 1720, 1721, 7,
        12, 0, 0, 1721, 1722, 5, 147, 0, 0, 1722, 1723, 3, 186, 93, 0, 1723, 1724, 5, 154, 0, 0,
        1724, 1725, 3, 370, 185, 0, 1725, 1726, 5, 148, 0, 0, 1726, 1727, 5, 149, 0, 0, 1727, 1728,
        3, 272, 136, 0, 1728, 1729, 5, 150, 0, 0, 1729, 1731, 1, 0, 0, 0, 1730, 1699, 1, 0, 0, 0,
        1730, 1720, 1, 0, 0, 0, 1731, 271, 1, 0, 0, 0, 1732, 1737, 3, 274, 137, 0, 1733, 1734, 5,
        154, 0, 0, 1734, 1736, 3, 274, 137, 0, 1735, 1733, 1, 0, 0, 0, 1736, 1739, 1, 0, 0, 0, 1737,
        1735, 1, 0, 0, 0, 1737, 1738, 1, 0, 0, 0, 1738, 1741, 1, 0, 0, 0, 1739, 1737, 1, 0, 0, 0,
        1740, 1742, 5, 154, 0, 0, 1741, 1740, 1, 0, 0, 0, 1741, 1742, 1, 0, 0, 0, 1742, 273, 1, 0,
        0, 0, 1743, 1746, 3, 276, 138, 0, 1744, 1745, 5, 158, 0, 0, 1745, 1747, 3, 340, 170, 0,
        1746, 1744, 1, 0, 0, 0, 1746, 1747, 1, 0, 0, 0, 1747, 275, 1, 0, 0, 0, 1748, 1749, 3, 370,
        185, 0, 1749, 277, 1, 0, 0, 0, 1750, 1751, 7, 13, 0, 0, 1751, 279, 1, 0, 0, 0, 1752, 1753,
        5, 102, 0, 0, 1753, 1755, 5, 147, 0, 0, 1754, 1756, 3, 368, 184, 0, 1755, 1754, 1, 0, 0, 0,
        1756, 1757, 1, 0, 0, 0, 1757, 1755, 1, 0, 0, 0, 1757, 1758, 1, 0, 0, 0, 1758, 1759, 1, 0, 0,
        0, 1759, 1760, 5, 148, 0, 0, 1760, 1763, 1, 0, 0, 0, 1761, 1763, 3, 282, 141, 0, 1762, 1752,
        1, 0, 0, 0, 1762, 1761, 1, 0, 0, 0, 1763, 281, 1, 0, 0, 0, 1764, 1765, 5, 86, 0, 0, 1765,
        1766, 5, 147, 0, 0, 1766, 1767, 5, 147, 0, 0, 1767, 1768, 3, 284, 142, 0, 1768, 1769, 5,
        148, 0, 0, 1769, 1770, 5, 148, 0, 0, 1770, 283, 1, 0, 0, 0, 1771, 1773, 3, 286, 143, 0,
        1772, 1771, 1, 0, 0, 0, 1772, 1773, 1, 0, 0, 0, 1773, 1780, 1, 0, 0, 0, 1774, 1776, 5, 154,
        0, 0, 1775, 1777, 3, 286, 143, 0, 1776, 1775, 1, 0, 0, 0, 1776, 1777, 1, 0, 0, 0, 1777,
        1779, 1, 0, 0, 0, 1778, 1774, 1, 0, 0, 0, 1779, 1782, 1, 0, 0, 0, 1780, 1778, 1, 0, 0, 0,
        1780, 1781, 1, 0, 0, 0, 1781, 285, 1, 0, 0, 0, 1782, 1780, 1, 0, 0, 0, 1783, 1789, 8, 14, 0,
        0, 1784, 1786, 5, 147, 0, 0, 1785, 1787, 3, 360, 180, 0, 1786, 1785, 1, 0, 0, 0, 1786, 1787,
        1, 0, 0, 0, 1787, 1788, 1, 0, 0, 0, 1788, 1790, 5, 148, 0, 0, 1789, 1784, 1, 0, 0, 0, 1789,
        1790, 1, 0, 0, 0, 1790, 287, 1, 0, 0, 0, 1791, 1793, 5, 175, 0, 0, 1792, 1794, 3, 174, 87,
        0, 1793, 1792, 1, 0, 0, 0, 1793, 1794, 1, 0, 0, 0, 1794, 1796, 1, 0, 0, 0, 1795, 1797, 3,
        290, 145, 0, 1796, 1795, 1, 0, 0, 0, 1796, 1797, 1, 0, 0, 0, 1797, 289, 1, 0, 0, 0, 1798,
        1800, 3, 292, 146, 0, 1799, 1798, 1, 0, 0, 0, 1800, 1801, 1, 0, 0, 0, 1801, 1799, 1, 0, 0,
        0, 1801, 1802, 1, 0, 0, 0, 1802, 291, 1, 0, 0, 0, 1803, 1805, 5, 175, 0, 0, 1804, 1806, 3,
        204, 102, 0, 1805, 1804, 1, 0, 0, 0, 1805, 1806, 1, 0, 0, 0, 1806, 293, 1, 0, 0, 0, 1807,
        1816, 3, 370, 185, 0, 1808, 1811, 5, 147, 0, 0, 1809, 1812, 5, 154, 0, 0, 1810, 1812, 8, 15,
        0, 0, 1811, 1809, 1, 0, 0, 0, 1811, 1810, 1, 0, 0, 0, 1812, 1813, 1, 0, 0, 0, 1813, 1811, 1,
        0, 0, 0, 1813, 1814, 1, 0, 0, 0, 1814, 1815, 1, 0, 0, 0, 1815, 1817, 5, 148, 0, 0, 1816,
        1808, 1, 0, 0, 0, 1816, 1817, 1, 0, 0, 0, 1817, 295, 1, 0, 0, 0, 1818, 1830, 5, 149, 0, 0,
        1819, 1824, 3, 340, 170, 0, 1820, 1821, 5, 154, 0, 0, 1821, 1823, 3, 340, 170, 0, 1822,
        1820, 1, 0, 0, 0, 1823, 1826, 1, 0, 0, 0, 1824, 1822, 1, 0, 0, 0, 1824, 1825, 1, 0, 0, 0,
        1825, 1828, 1, 0, 0, 0, 1826, 1824, 1, 0, 0, 0, 1827, 1829, 5, 154, 0, 0, 1828, 1827, 1, 0,
        0, 0, 1828, 1829, 1, 0, 0, 0, 1829, 1831, 1, 0, 0, 0, 1830, 1819, 1, 0, 0, 0, 1830, 1831, 1,
        0, 0, 0, 1831, 1832, 1, 0, 0, 0, 1832, 1833, 5, 150, 0, 0, 1833, 297, 1, 0, 0, 0, 1834,
        1846, 5, 149, 0, 0, 1835, 1840, 3, 300, 150, 0, 1836, 1837, 5, 154, 0, 0, 1837, 1839, 3,
        300, 150, 0, 1838, 1836, 1, 0, 0, 0, 1839, 1842, 1, 0, 0, 0, 1840, 1838, 1, 0, 0, 0, 1840,
        1841, 1, 0, 0, 0, 1841, 1844, 1, 0, 0, 0, 1842, 1840, 1, 0, 0, 0, 1843, 1845, 5, 154, 0, 0,
        1844, 1843, 1, 0, 0, 0, 1844, 1845, 1, 0, 0, 0, 1845, 1847, 1, 0, 0, 0, 1846, 1835, 1, 0, 0,
        0, 1846, 1847, 1, 0, 0, 0, 1847, 1848, 1, 0, 0, 0, 1848, 1849, 5, 150, 0, 0, 1849, 299, 1,
        0, 0, 0, 1850, 1851, 5, 155, 0, 0, 1851, 1855, 3, 340, 170, 0, 1852, 1855, 3, 298, 149, 0,
        1853, 1855, 3, 296, 148, 0, 1854, 1850, 1, 0, 0, 0, 1854, 1852, 1, 0, 0, 0, 1854, 1853, 1,
        0, 0, 0, 1855, 301, 1, 0, 0, 0, 1856, 1861, 3, 348, 174, 0, 1857, 1858, 5, 154, 0, 0, 1858,
        1860, 3, 348, 174, 0, 1859, 1857, 1, 0, 0, 0, 1860, 1863, 1, 0, 0, 0, 1861, 1859, 1, 0, 0,
        0, 1861, 1862, 1, 0, 0, 0, 1862, 1865, 1, 0, 0, 0, 1863, 1861, 1, 0, 0, 0, 1864, 1866, 5,
        154, 0, 0, 1865, 1864, 1, 0, 0, 0, 1865, 1866, 1, 0, 0, 0, 1866, 303, 1, 0, 0, 0, 1867,
        1868, 5, 119, 0, 0, 1868, 1869, 5, 147, 0, 0, 1869, 1870, 3, 350, 175, 0, 1870, 1872, 5,
        154, 0, 0, 1871, 1873, 3, 368, 184, 0, 1872, 1871, 1, 0, 0, 0, 1873, 1874, 1, 0, 0, 0, 1874,
        1872, 1, 0, 0, 0, 1874, 1875, 1, 0, 0, 0, 1875, 1876, 1, 0, 0, 0, 1876, 1877, 5, 148, 0, 0,
        1877, 1878, 5, 153, 0, 0, 1878, 305, 1, 0, 0, 0, 1879, 1881, 3, 308, 154, 0, 1880, 1882, 5,
        153, 0, 0, 1881, 1880, 1, 0, 0, 0, 1881, 1882, 1, 0, 0, 0, 1882, 1918, 1, 0, 0, 0, 1883,
        1885, 3, 312, 156, 0, 1884, 1886, 5, 153, 0, 0, 1885, 1884, 1, 0, 0, 0, 1885, 1886, 1, 0, 0,
        0, 1886, 1918, 1, 0, 0, 0, 1887, 1889, 3, 314, 157, 0, 1888, 1890, 5, 153, 0, 0, 1889, 1888,
        1, 0, 0, 0, 1889, 1890, 1, 0, 0, 0, 1890, 1918, 1, 0, 0, 0, 1891, 1893, 3, 324, 162, 0,
        1892, 1894, 5, 153, 0, 0, 1893, 1892, 1, 0, 0, 0, 1893, 1894, 1, 0, 0, 0, 1894, 1918, 1, 0,
        0, 0, 1895, 1896, 3, 336, 168, 0, 1896, 1897, 5, 153, 0, 0, 1897, 1918, 1, 0, 0, 0, 1898,
        1900, 3, 126, 63, 0, 1899, 1901, 5, 153, 0, 0, 1900, 1899, 1, 0, 0, 0, 1900, 1901, 1, 0, 0,
        0, 1901, 1918, 1, 0, 0, 0, 1902, 1904, 3, 128, 64, 0, 1903, 1905, 5, 153, 0, 0, 1904, 1903,
        1, 0, 0, 0, 1904, 1905, 1, 0, 0, 0, 1905, 1918, 1, 0, 0, 0, 1906, 1907, 3, 120, 60, 0, 1907,
        1908, 5, 153, 0, 0, 1908, 1918, 1, 0, 0, 0, 1909, 1911, 3, 122, 61, 0, 1910, 1912, 5, 153,
        0, 0, 1911, 1910, 1, 0, 0, 0, 1911, 1912, 1, 0, 0, 0, 1912, 1918, 1, 0, 0, 0, 1913, 1914, 3,
        338, 169, 0, 1914, 1915, 5, 153, 0, 0, 1915, 1918, 1, 0, 0, 0, 1916, 1918, 5, 153, 0, 0,
        1917, 1879, 1, 0, 0, 0, 1917, 1883, 1, 0, 0, 0, 1917, 1887, 1, 0, 0, 0, 1917, 1891, 1, 0, 0,
        0, 1917, 1895, 1, 0, 0, 0, 1917, 1898, 1, 0, 0, 0, 1917, 1902, 1, 0, 0, 0, 1917, 1906, 1, 0,
        0, 0, 1917, 1909, 1, 0, 0, 0, 1917, 1913, 1, 0, 0, 0, 1917, 1916, 1, 0, 0, 0, 1918, 307, 1,
        0, 0, 0, 1919, 1920, 3, 370, 185, 0, 1920, 1921, 5, 164, 0, 0, 1921, 1922, 3, 306, 153, 0,
        1922, 309, 1, 0, 0, 0, 1923, 1926, 3, 340, 170, 0, 1924, 1925, 5, 191, 0, 0, 1925, 1927, 3,
        340, 170, 0, 1926, 1924, 1, 0, 0, 0, 1926, 1927, 1, 0, 0, 0, 1927, 311, 1, 0, 0, 0, 1928,
        1933, 5, 149, 0, 0, 1929, 1932, 3, 306, 153, 0, 1930, 1932, 3, 176, 88, 0, 1931, 1929, 1, 0,
        0, 0, 1931, 1930, 1, 0, 0, 0, 1932, 1935, 1, 0, 0, 0, 1933, 1931, 1, 0, 0, 0, 1933, 1934, 1,
        0, 0, 0, 1934, 1936, 1, 0, 0, 0, 1935, 1933, 1, 0, 0, 0, 1936, 1937, 5, 150, 0, 0, 1937,
        313, 1, 0, 0, 0, 1938, 1939, 5, 16, 0, 0, 1939, 1940, 5, 147, 0, 0, 1940, 1941, 3, 338, 169,
        0, 1941, 1942, 5, 148, 0, 0, 1942, 1945, 3, 306, 153, 0, 1943, 1944, 5, 10, 0, 0, 1944,
        1946, 3, 306, 153, 0, 1945, 1943, 1, 0, 0, 0, 1945, 1946, 1, 0, 0, 0, 1946, 1949, 1, 0, 0,
        0, 1947, 1949, 3, 316, 158, 0, 1948, 1938, 1, 0, 0, 0, 1948, 1947, 1, 0, 0, 0, 1949, 315, 1,
        0, 0, 0, 1950, 1951, 5, 28, 0, 0, 1951, 1952, 5, 147, 0, 0, 1952, 1953, 3, 340, 170, 0,
        1953, 1954, 5, 148, 0, 0, 1954, 1955, 3, 318, 159, 0, 1955, 317, 1, 0, 0, 0, 1956, 1960, 5,
        149, 0, 0, 1957, 1959, 3, 320, 160, 0, 1958, 1957, 1, 0, 0, 0, 1959, 1962, 1, 0, 0, 0, 1960,
        1958, 1, 0, 0, 0, 1960, 1961, 1, 0, 0, 0, 1961, 1963, 1, 0, 0, 0, 1962, 1960, 1, 0, 0, 0,
        1963, 1964, 5, 150, 0, 0, 1964, 319, 1, 0, 0, 0, 1965, 1967, 3, 322, 161, 0, 1966, 1965, 1,
        0, 0, 0, 1967, 1968, 1, 0, 0, 0, 1968, 1966, 1, 0, 0, 0, 1968, 1969, 1, 0, 0, 0, 1969, 1971,
        1, 0, 0, 0, 1970, 1972, 3, 306, 153, 0, 1971, 1970, 1, 0, 0, 0, 1972, 1973, 1, 0, 0, 0,
        1973, 1971, 1, 0, 0, 0, 1973, 1974, 1, 0, 0, 0, 1974, 321, 1, 0, 0, 0, 1975, 1981, 5, 3, 0,
        0, 1976, 1982, 3, 310, 155, 0, 1977, 1978, 5, 147, 0, 0, 1978, 1979, 3, 310, 155, 0, 1979,
        1980, 5, 148, 0, 0, 1980, 1982, 1, 0, 0, 0, 1981, 1976, 1, 0, 0, 0, 1981, 1977, 1, 0, 0, 0,
        1982, 1983, 1, 0, 0, 0, 1983, 1984, 5, 164, 0, 0, 1984, 1988, 1, 0, 0, 0, 1985, 1986, 5, 7,
        0, 0, 1986, 1988, 5, 164, 0, 0, 1987, 1975, 1, 0, 0, 0, 1987, 1985, 1, 0, 0, 0, 1988, 323,
        1, 0, 0, 0, 1989, 1994, 3, 326, 163, 0, 1990, 1994, 3, 328, 164, 0, 1991, 1994, 3, 330, 165,
        0, 1992, 1994, 3, 334, 167, 0, 1993, 1989, 1, 0, 0, 0, 1993, 1990, 1, 0, 0, 0, 1993, 1991,
        1, 0, 0, 0, 1993, 1992, 1, 0, 0, 0, 1994, 325, 1, 0, 0, 0, 1995, 1996, 5, 34, 0, 0, 1996,
        1997, 5, 147, 0, 0, 1997, 1998, 3, 340, 170, 0, 1998, 1999, 5, 148, 0, 0, 1999, 2000, 3,
        306, 153, 0, 2000, 327, 1, 0, 0, 0, 2001, 2002, 5, 8, 0, 0, 2002, 2003, 3, 306, 153, 0,
        2003, 2004, 5, 34, 0, 0, 2004, 2005, 5, 147, 0, 0, 2005, 2006, 3, 340, 170, 0, 2006, 2007,
        5, 148, 0, 0, 2007, 2008, 5, 153, 0, 0, 2008, 329, 1, 0, 0, 0, 2009, 2010, 5, 14, 0, 0,
        2010, 2012, 5, 147, 0, 0, 2011, 2013, 3, 332, 166, 0, 2012, 2011, 1, 0, 0, 0, 2012, 2013, 1,
        0, 0, 0, 2013, 2014, 1, 0, 0, 0, 2014, 2016, 5, 153, 0, 0, 2015, 2017, 3, 340, 170, 0, 2016,
        2015, 1, 0, 0, 0, 2016, 2017, 1, 0, 0, 0, 2017, 2018, 1, 0, 0, 0, 2018, 2020, 5, 153, 0, 0,
        2019, 2021, 3, 338, 169, 0, 2020, 2019, 1, 0, 0, 0, 2020, 2021, 1, 0, 0, 0, 2021, 2022, 1,
        0, 0, 0, 2022, 2023, 5, 148, 0, 0, 2023, 2024, 3, 306, 153, 0, 2024, 331, 1, 0, 0, 0, 2025,
        2026, 3, 174, 87, 0, 2026, 2027, 3, 178, 89, 0, 2027, 2030, 1, 0, 0, 0, 2028, 2030, 3, 338,
        169, 0, 2029, 2025, 1, 0, 0, 0, 2029, 2028, 1, 0, 0, 0, 2030, 333, 1, 0, 0, 0, 2031, 2032,
        5, 14, 0, 0, 2032, 2033, 5, 147, 0, 0, 2033, 2034, 3, 118, 59, 0, 2034, 2036, 5, 48, 0, 0,
        2035, 2037, 3, 340, 170, 0, 2036, 2035, 1, 0, 0, 0, 2036, 2037, 1, 0, 0, 0, 2037, 2038, 1,
        0, 0, 0, 2038, 2039, 5, 148, 0, 0, 2039, 2040, 3, 306, 153, 0, 2040, 335, 1, 0, 0, 0, 2041,
        2042, 5, 15, 0, 0, 2042, 2050, 3, 370, 185, 0, 2043, 2050, 5, 6, 0, 0, 2044, 2050, 5, 2, 0,
        0, 2045, 2047, 5, 22, 0, 0, 2046, 2048, 3, 340, 170, 0, 2047, 2046, 1, 0, 0, 0, 2047, 2048,
        1, 0, 0, 0, 2048, 2050, 1, 0, 0, 0, 2049, 2041, 1, 0, 0, 0, 2049, 2043, 1, 0, 0, 0, 2049,
        2044, 1, 0, 0, 0, 2049, 2045, 1, 0, 0, 0, 2050, 337, 1, 0, 0, 0, 2051, 2056, 3, 340, 170, 0,
        2052, 2053, 5, 154, 0, 0, 2053, 2055, 3, 340, 170, 0, 2054, 2052, 1, 0, 0, 0, 2055, 2058, 1,
        0, 0, 0, 2056, 2054, 1, 0, 0, 0, 2056, 2057, 1, 0, 0, 0, 2057, 339, 1, 0, 0, 0, 2058, 2056,
        1, 0, 0, 0, 2059, 2060, 6, 170, -1, 0, 2060, 2067, 3, 346, 173, 0, 2061, 2067, 3, 342, 171,
        0, 2062, 2063, 5, 147, 0, 0, 2063, 2064, 3, 312, 156, 0, 2064, 2065, 5, 148, 0, 0, 2065,
        2067, 1, 0, 0, 0, 2066, 2059, 1, 0, 0, 0, 2066, 2061, 1, 0, 0, 0, 2066, 2062, 1, 0, 0, 0,
        2067, 2112, 1, 0, 0, 0, 2068, 2069, 10, 13, 0, 0, 2069, 2070, 7, 16, 0, 0, 2070, 2111, 3,
        340, 170, 14, 2071, 2072, 10, 12, 0, 0, 2072, 2073, 7, 17, 0, 0, 2073, 2111, 3, 340, 170,
        13, 2074, 2079, 10, 11, 0, 0, 2075, 2076, 5, 160, 0, 0, 2076, 2080, 5, 160, 0, 0, 2077,
        2078, 5, 159, 0, 0, 2078, 2080, 5, 159, 0, 0, 2079, 2075, 1, 0, 0, 0, 2079, 2077, 1, 0, 0,
        0, 2080, 2081, 1, 0, 0, 0, 2081, 2111, 3, 340, 170, 12, 2082, 2083, 10, 10, 0, 0, 2083,
        2084, 7, 18, 0, 0, 2084, 2111, 3, 340, 170, 11, 2085, 2086, 10, 9, 0, 0, 2086, 2087, 7, 19,
        0, 0, 2087, 2111, 3, 340, 170, 10, 2088, 2089, 10, 8, 0, 0, 2089, 2090, 5, 177, 0, 0, 2090,
        2111, 3, 340, 170, 9, 2091, 2092, 10, 7, 0, 0, 2092, 2093, 5, 179, 0, 0, 2093, 2111, 3, 340,
        170, 8, 2094, 2095, 10, 6, 0, 0, 2095, 2096, 5, 178, 0, 0, 2096, 2111, 3, 340, 170, 7, 2097,
        2098, 10, 5, 0, 0, 2098, 2099, 5, 169, 0, 0, 2099, 2111, 3, 340, 170, 6, 2100, 2101, 10, 4,
        0, 0, 2101, 2102, 5, 170, 0, 0, 2102, 2111, 3, 340, 170, 5, 2103, 2104, 10, 3, 0, 0, 2104,
        2106, 5, 163, 0, 0, 2105, 2107, 3, 340, 170, 0, 2106, 2105, 1, 0, 0, 0, 2106, 2107, 1, 0, 0,
        0, 2107, 2108, 1, 0, 0, 0, 2108, 2109, 5, 164, 0, 0, 2109, 2111, 3, 340, 170, 4, 2110, 2068,
        1, 0, 0, 0, 2110, 2071, 1, 0, 0, 0, 2110, 2074, 1, 0, 0, 0, 2110, 2082, 1, 0, 0, 0, 2110,
        2085, 1, 0, 0, 0, 2110, 2088, 1, 0, 0, 0, 2110, 2091, 1, 0, 0, 0, 2110, 2094, 1, 0, 0, 0,
        2110, 2097, 1, 0, 0, 0, 2110, 2100, 1, 0, 0, 0, 2110, 2103, 1, 0, 0, 0, 2111, 2114, 1, 0, 0,
        0, 2112, 2110, 1, 0, 0, 0, 2112, 2113, 1, 0, 0, 0, 2113, 341, 1, 0, 0, 0, 2114, 2112, 1, 0,
        0, 0, 2115, 2116, 3, 352, 176, 0, 2116, 2117, 3, 344, 172, 0, 2117, 2118, 3, 340, 170, 0,
        2118, 343, 1, 0, 0, 0, 2119, 2120, 7, 20, 0, 0, 2120, 345, 1, 0, 0, 0, 2121, 2132, 3, 352,
        176, 0, 2122, 2124, 5, 111, 0, 0, 2123, 2122, 1, 0, 0, 0, 2123, 2124, 1, 0, 0, 0, 2124,
        2125, 1, 0, 0, 0, 2125, 2126, 5, 147, 0, 0, 2126, 2127, 3, 186, 93, 0, 2127, 2128, 5, 148,
        0, 0, 2128, 2129, 3, 346, 173, 0, 2129, 2132, 1, 0, 0, 0, 2130, 2132, 5, 198, 0, 0, 2131,
        2121, 1, 0, 0, 0, 2131, 2123, 1, 0, 0, 0, 2131, 2130, 1, 0, 0, 0, 2132, 347, 1, 0, 0, 0,
        2133, 2137, 3, 340, 170, 0, 2134, 2137, 3, 296, 148, 0, 2135, 2137, 3, 298, 149, 0, 2136,
        2133, 1, 0, 0, 0, 2136, 2134, 1, 0, 0, 0, 2136, 2135, 1, 0, 0, 0, 2137, 349, 1, 0, 0, 0,
        2138, 2141, 3, 370, 185, 0, 2139, 2141, 3, 366, 183, 0, 2140, 2138, 1, 0, 0, 0, 2140, 2139,
        1, 0, 0, 0, 2141, 351, 1, 0, 0, 0, 2142, 2157, 3, 356, 178, 0, 2143, 2149, 5, 25, 0, 0,
        2144, 2150, 3, 352, 176, 0, 2145, 2146, 5, 147, 0, 0, 2146, 2147, 3, 252, 126, 0, 2147,
        2148, 5, 148, 0, 0, 2148, 2150, 1, 0, 0, 0, 2149, 2144, 1, 0, 0, 0, 2149, 2145, 1, 0, 0, 0,
        2150, 2157, 1, 0, 0, 0, 2151, 2152, 7, 21, 0, 0, 2152, 2157, 3, 352, 176, 0, 2153, 2154, 3,
        354, 177, 0, 2154, 2155, 3, 346, 173, 0, 2155, 2157, 1, 0, 0, 0, 2156, 2142, 1, 0, 0, 0,
        2156, 2143, 1, 0, 0, 0, 2156, 2151, 1, 0, 0, 0, 2156, 2153, 1, 0, 0, 0, 2157, 353, 1, 0, 0,
        0, 2158, 2159, 7, 22, 0, 0, 2159, 355, 1, 0, 0, 0, 2160, 2161, 6, 178, -1, 0, 2161, 2165, 3,
        364, 182, 0, 2162, 2164, 3, 358, 179, 0, 2163, 2162, 1, 0, 0, 0, 2164, 2167, 1, 0, 0, 0,
        2165, 2163, 1, 0, 0, 0, 2165, 2166, 1, 0, 0, 0, 2166, 2179, 1, 0, 0, 0, 2167, 2165, 1, 0, 0,
        0, 2168, 2169, 10, 1, 0, 0, 2169, 2170, 7, 23, 0, 0, 2170, 2174, 3, 370, 185, 0, 2171, 2173,
        3, 358, 179, 0, 2172, 2171, 1, 0, 0, 0, 2173, 2176, 1, 0, 0, 0, 2174, 2172, 1, 0, 0, 0,
        2174, 2175, 1, 0, 0, 0, 2175, 2178, 1, 0, 0, 0, 2176, 2174, 1, 0, 0, 0, 2177, 2168, 1, 0, 0,
        0, 2178, 2181, 1, 0, 0, 0, 2179, 2177, 1, 0, 0, 0, 2179, 2180, 1, 0, 0, 0, 2180, 357, 1, 0,
        0, 0, 2181, 2179, 1, 0, 0, 0, 2182, 2183, 5, 151, 0, 0, 2183, 2184, 3, 340, 170, 0, 2184,
        2185, 5, 152, 0, 0, 2185, 2193, 1, 0, 0, 0, 2186, 2188, 5, 147, 0, 0, 2187, 2189, 3, 360,
        180, 0, 2188, 2187, 1, 0, 0, 0, 2188, 2189, 1, 0, 0, 0, 2189, 2190, 1, 0, 0, 0, 2190, 2193,
        5, 148, 0, 0, 2191, 2193, 7, 21, 0, 0, 2192, 2182, 1, 0, 0, 0, 2192, 2186, 1, 0, 0, 0, 2192,
        2191, 1, 0, 0, 0, 2193, 359, 1, 0, 0, 0, 2194, 2199, 3, 362, 181, 0, 2195, 2196, 5, 154, 0,
        0, 2196, 2198, 3, 362, 181, 0, 2197, 2195, 1, 0, 0, 0, 2198, 2201, 1, 0, 0, 0, 2199, 2197,
        1, 0, 0, 0, 2199, 2200, 1, 0, 0, 0, 2200, 361, 1, 0, 0, 0, 2201, 2199, 1, 0, 0, 0, 2202,
        2205, 3, 340, 170, 0, 2203, 2205, 3, 258, 129, 0, 2204, 2202, 1, 0, 0, 0, 2204, 2203, 1, 0,
        0, 0, 2205, 363, 1, 0, 0, 0, 2206, 2222, 3, 370, 185, 0, 2207, 2222, 3, 366, 183, 0, 2208,
        2222, 3, 368, 184, 0, 2209, 2210, 5, 147, 0, 0, 2210, 2211, 3, 340, 170, 0, 2211, 2212, 5,
        148, 0, 0, 2212, 2222, 1, 0, 0, 0, 2213, 2222, 3, 100, 50, 0, 2214, 2222, 3, 110, 55, 0,
        2215, 2222, 3, 114, 57, 0, 2216, 2222, 3, 116, 58, 0, 2217, 2222, 3, 84, 42, 0, 2218, 2222,
        3, 88, 44, 0, 2219, 2222, 3, 90, 45, 0, 2220, 2222, 3, 98, 49, 0, 2221, 2206, 1, 0, 0, 0,
        2221, 2207, 1, 0, 0, 0, 2221, 2208, 1, 0, 0, 0, 2221, 2209, 1, 0, 0, 0, 2221, 2213, 1, 0, 0,
        0, 2221, 2214, 1, 0, 0, 0, 2221, 2215, 1, 0, 0, 0, 2221, 2216, 1, 0, 0, 0, 2221, 2217, 1, 0,
        0, 0, 2221, 2218, 1, 0, 0, 0, 2221, 2219, 1, 0, 0, 0, 2221, 2220, 1, 0, 0, 0, 2222, 365, 1,
        0, 0, 0, 2223, 2242, 5, 194, 0, 0, 2224, 2242, 5, 195, 0, 0, 2225, 2242, 5, 196, 0, 0, 2226,
        2228, 7, 17, 0, 0, 2227, 2226, 1, 0, 0, 0, 2227, 2228, 1, 0, 0, 0, 2228, 2229, 1, 0, 0, 0,
        2229, 2242, 5, 197, 0, 0, 2230, 2232, 7, 17, 0, 0, 2231, 2230, 1, 0, 0, 0, 2231, 2232, 1, 0,
        0, 0, 2232, 2233, 1, 0, 0, 0, 2233, 2242, 5, 199, 0, 0, 2234, 2242, 5, 192, 0, 0, 2235,
        2242, 5, 50, 0, 0, 2236, 2242, 5, 52, 0, 0, 2237, 2242, 5, 59, 0, 0, 2238, 2242, 5, 51, 0,
        0, 2239, 2242, 5, 39, 0, 0, 2240, 2242, 5, 40, 0, 0, 2241, 2223, 1, 0, 0, 0, 2241, 2224, 1,
        0, 0, 0, 2241, 2225, 1, 0, 0, 0, 2241, 2227, 1, 0, 0, 0, 2241, 2231, 1, 0, 0, 0, 2241, 2234,
        1, 0, 0, 0, 2241, 2235, 1, 0, 0, 0, 2241, 2236, 1, 0, 0, 0, 2241, 2237, 1, 0, 0, 0, 2241,
        2238, 1, 0, 0, 0, 2241, 2239, 1, 0, 0, 0, 2241, 2240, 1, 0, 0, 0, 2242, 367, 1, 0, 0, 0,
        2243, 2247, 5, 193, 0, 0, 2244, 2246, 7, 24, 0, 0, 2245, 2244, 1, 0, 0, 0, 2246, 2249, 1, 0,
        0, 0, 2247, 2245, 1, 0, 0, 0, 2247, 2248, 1, 0, 0, 0, 2248, 2250, 1, 0, 0, 0, 2249, 2247, 1,
        0, 0, 0, 2250, 2252, 5, 206, 0, 0, 2251, 2243, 1, 0, 0, 0, 2252, 2253, 1, 0, 0, 0, 2253,
        2251, 1, 0, 0, 0, 2253, 2254, 1, 0, 0, 0, 2254, 369, 1, 0, 0, 0, 2255, 2256, 7, 25, 0, 0,
        2256, 371, 1, 0, 0, 0, 298, 375, 390, 397, 402, 405, 413, 415, 421, 427, 434, 437, 440, 447,
        450, 458, 460, 466, 470, 480, 493, 496, 503, 508, 516, 521, 530, 536, 538, 550, 560, 568,
        571, 574, 583, 605, 612, 615, 621, 630, 636, 638, 647, 649, 658, 664, 668, 677, 679, 688,
        692, 695, 698, 702, 708, 712, 714, 717, 723, 727, 737, 751, 758, 764, 767, 771, 777, 781,
        790, 794, 796, 808, 810, 822, 824, 830, 836, 839, 842, 846, 850, 853, 856, 862, 873, 879,
        881, 884, 892, 897, 903, 912, 917, 919, 941, 948, 953, 977, 981, 986, 990, 994, 998, 1007,
        1014, 1021, 1027, 1032, 1039, 1046, 1051, 1054, 1057, 1060, 1064, 1072, 1075, 1079, 1087,
        1092, 1099, 1102, 1107, 1113, 1120, 1131, 1133, 1143, 1153, 1156, 1161, 1165, 1170, 1177,
        1183, 1186, 1192, 1204, 1207, 1223, 1228, 1231, 1238, 1253, 1260, 1263, 1265, 1270, 1274,
        1278, 1284, 1288, 1293, 1295, 1299, 1305, 1308, 1317, 1322, 1325, 1331, 1347, 1353, 1359,
        1363, 1368, 1371, 1378, 1397, 1403, 1406, 1408, 1413, 1418, 1421, 1426, 1433, 1441, 1449,
        1451, 1456, 1463, 1468, 1480, 1495, 1500, 1506, 1510, 1514, 1523, 1530, 1540, 1544, 1547,
        1554, 1559, 1563, 1568, 1578, 1593, 1602, 1608, 1616, 1620, 1624, 1628, 1632, 1636, 1638,
        1651, 1669, 1672, 1677, 1688, 1693, 1697, 1701, 1705, 1712, 1718, 1730, 1737, 1741, 1746,
        1757, 1762, 1772, 1776, 1780, 1786, 1789, 1793, 1796, 1801, 1805, 1811, 1813, 1816, 1824,
        1828, 1830, 1840, 1844, 1846, 1854, 1861, 1865, 1874, 1881, 1885, 1889, 1893, 1900, 1904,
        1911, 1917, 1926, 1931, 1933, 1945, 1948, 1960, 1968, 1973, 1981, 1987, 1993, 2012, 2016,
        2020, 2029, 2036, 2047, 2049, 2056, 2066, 2079, 2106, 2110, 2112, 2123, 2131, 2136, 2140,
        2149, 2156, 2165, 2174, 2179, 2188, 2192, 2199, 2204, 2221, 2227, 2231, 2241, 2247, 2253,
    ]
}
