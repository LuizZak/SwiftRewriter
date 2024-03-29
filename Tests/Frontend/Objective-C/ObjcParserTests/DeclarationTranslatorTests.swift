import XCTest
import Antlr4
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import TestCommons
import Utils

@testable import ObjcParser

class DeclarationTranslatorTests: XCTestCase {
    
    func testTranslate_singleDecl_mixedTypePrefixAndSpecifiers() {
        let tester = prepareTest(declaration: "nullable __kindof NSString *a;")

        tester.assert { asserter in
            asserter.assertVariable(name: "a")
        }
    }

    func testTranslate_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: "signed short int")?
                .assert(isStatic: false)
        }
    }

    func testTranslate_singleDecl_variable_static() {
        let tester = prepareTest(declaration: "static short int a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: "signed short int")?
                .assert(isStatic: true)
        }
    }

    func testTranslate_singleDecl_variable_longLongInt() {
        let tester = prepareTest(declaration: "unsigned long long int a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: "unsigned long long int")
        }
    }

    func testTranslate_singleDecl_variable_const() {
        let tester = prepareTest(declaration: "const char a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assert(type: .qualified("char", qualifiers: [.const]))
        }
    }

    func testTranslate_singleDecl_variable_pointer() {
        let tester = prepareTest(declaration: "short int *a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_pointerToPointer() {
        let tester = prepareTest(declaration: "short int **a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer(.pointer("signed short int")))
        }
    }

    func testTranslate_singleDecl_variable_pointer_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "short int *_Nonnull a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int", nullabilitySpecifier: .nonnull))
        }
    }

    func testTranslate_singleDecl_variable_pointer_const() {
        let tester = prepareTest(declaration: "short int *const a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int", qualifiers: [.const]))
        }
    }

    func testTranslate_singleDecl_variable_pointer_weak() {
        let tester = prepareTest(declaration: "__weak NSString*_Nonnull a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("NSString", nullabilitySpecifier: .nonnull).specifiedAsWeak)
        }
    }

    func testTranslate_singleDecl_variable_pointer_mixedSpecifiers() {
        let tester = prepareTest(declaration: "NSString *const _Nonnull __autoreleasing a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type:
                    .specified(
                        specifiers: [.arcSpecifier(.autoreleasing)],
                        .pointer("NSString", qualifiers: [.const], nullabilitySpecifier: .nonnull)
                    )
                )
        }
    }

    func testTranslate_singleDecl_variable_typeName_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "_Nonnull callback a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .nullabilitySpecified(specifier: .nonnull, "callback"))
        }
    }

    func testTranslate_singleDecl_blockDecl_arcSpecifier() {
        let tester = prepareTest(declaration: "void (^__weak a)();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(hasArcSpecifier: .weak)
        }
    }

    func testTranslate_singleDecl_blockDecl_withInitializer() {
        let tester = prepareTest(declaration: "void (^a)() = ^{ };")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertHasInitializer()
        }
    }

    func testTranslate_singleDecl_blockDecl_nullabilitySpecifier_asBlockSpecifier() {
        let tester = prepareTest(declaration: "void (^_Nonnull a)();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(hasNullabilitySpecifier: nil)?
                .assert(type: .blockType(
                    name: "a",
                    returnType: .void,
                    parameters: [],
                    nullabilitySpecifier: .nonnull
                ))
        }
    }

    func testTranslate_singleDecl_blockDecl_nullabilitySpecifier_asTypeSpecifier() {
        let tester = prepareTest(declaration: "_Nonnull void (^a)();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(hasNullabilitySpecifier: .nonnull)?
                .assert(type:
                    .nullabilitySpecified(
                        specifier: .nonnull,
                        .blockType(
                            name: "a",
                            returnType: .void,
                            parameters: [],
                            nullabilitySpecifier: nil
                        )
                    )
                )
        }
    }

    func testTranslate_singleDecl_blockDecl_typeQualifier() {
        let tester = prepareTest(declaration: "void (^const a)();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(hasTypeQualifier: .const)
        }
    }

    func testTranslate_singleDecl_blockDecl_returnsPointer() {
        let tester = prepareTest(declaration: "int*(^returnsPointer)(void);")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "returnsPointer")?
                .assert(type:
                    .blockType(
                        name: "returnsPointer",
                        returnType: .pointer("signed int"),
                        parameters: [],
                        nullabilitySpecifier: nil
                    )
                )
        }
    }

    func testTranslate_singleDecl_variable_array_unsized() {
        let tester = prepareTest(declaration: "short int a[];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_unsized() {
        let tester = prepareTest(declaration: "short int *a[];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer(.pointer("signed short int")))
        }
    }

    func testTranslate_singleDecl_variable_array_sized() {
        let tester = prepareTest(declaration: "short int a[10];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_sized() {
        let tester = prepareTest(declaration: "short int *a[10];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .fixedArray(.pointer("signed short int"), length: 10))
        }
    }

    func testTranslate_singleDecl_variable_array_const() {
        let tester = prepareTest(declaration: "int const a[];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer(.qualified("signed int", qualifiers: [.const])))
        }
    }

    func testTranslate_multiDecl_variable() {
        let tester = prepareTest(declaration: "short int a, b, *c;")

        tester.assert { asserter in
            asserter.assertCount(3)
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: "signed short int")
            asserter
                .assertVariable(name: "b")?
                .assertNoInitializer()?
                .assert(type: "signed short int")
            asserter
                .assertVariable(name: "c")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assertHasInitializer()?
                .assert(type: "signed short int")
        }
    }

    func testTranslate_singleDecl_typedef() {
        let tester = prepareTest(declaration: "typedef unsigned long long int A;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: "unsigned long long int")
        }
    }

    func testTranslate_singleDecl_typedef_pointer() {
        let tester = prepareTest(declaration: "typedef void *A;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: .pointer(.void))
        }
    }

    func testTranslate_singleDecl_typedef_block() {
        let tester = prepareTest(declaration: "typedef void(^_Nonnull callback)();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "callback")?
                .assert(type: .blockType(name: "callback", returnType: .void, nullabilitySpecifier: .nonnull))
        }
    }

    func testTranslate_singleDecl_typedef_block_takingAnnotatedBlockParameter() {
        let tester = prepareTest(declaration: "typedef void(^callback)(void(^_Nonnull)(nonnull NSString*));")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "callback")?
                .assert(type: .blockType(
                    name: "callback",
                    returnType: .void,
                    parameters: [
                        .blockType(
                            name: nil,
                            returnType: .void,
                            parameters: [
                                .nullabilitySpecified(
                                    specifier: .nonnull,
                                    .pointer("NSString")
                                )
                            ],
                            nullabilitySpecifier: .nonnull
                        )
                    ]
                )
            )
        }
    }

    func testTranslate_singleDecl_typedef_array_sized() {
        let tester = prepareTest(declaration: "typedef short int A[10];")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: .fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDecl_typedef_functionPointer() {
        let tester = prepareTest(declaration: "typedef int (*f)(void *, void *);")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "f")?
                .assert(type: 
                    .functionPointer(
                        name: "f",
                        returnType: "signed int",
                        parameters: [.pointer("void"), .pointer("void")]
                    )
                )
        }
    }

    func testTranslate_singleDecl_typedef_functionPointer_takingAnonymousBlockParameter() {
        let tester = prepareTest(declaration: "typedef int (*callback)(void (^)(), void *);")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "callback")?
                .assert(type: 
                    .functionPointer(
                        name: "callback",
                        returnType: "signed int",
                        parameters: [
                            .blockType(name: nil, returnType: .void),
                            .pointer("void")
                        ]
                    )
                )
        }
    }

    func testTranslate_singleDecl_typedef_functionPointer_takingAnonymousFunctionParameter() {
        let tester = prepareTest(declaration: "typedef int (*callback)(void (*)(), void *);")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "callback")?
                .assert(type: 
                    .functionPointer(
                        name: "callback",
                        returnType: "signed int",
                        parameters: [
                            .functionPointer(name: nil, returnType: .void),
                            .pointer("void")
                        ]
                    )
                )?
                .asserter(forKeyPath: \.rule.sourceRange) { sourceRange in
                    sourceRange.assert(
                        start: .init(line: 1, column: 14)
                    )
                }
        }
    }

    func testTranslate_singleDecl_typedef_anonymousStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct { int field; } *A;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: .pointer(.anonymousStruct))
        }
    }

    // TODO: Implement struct aliasing
    func _testTranslate_singleDecl_typedef_namedStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct a { int b; } *c;")

        tester.assert { asserter in
            asserter.assertCount(2)
            
            asserter
                .assertTypedef(name: "c")?
                .assert(type: .pointer(.typeName("a")))
            asserter
                .assertStructOrUnion(name: "a")
        }
    }

    func testTranslate_singleDecl_typedef_opaqueStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct _A *A;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: .pointer(.incompleteStruct("_A")))
        }
    }

    func testTranslate_singleDecl_typedef_opaqueStruct_pointerToPointer() {
        let tester = prepareTest(declaration: "typedef struct _A **A;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertTypedef(name: "A")?
                .assert(type: .pointer(.pointer(.incompleteStruct("_A"))))
        }
    }

    func testTranslate_multiDecl_typedef_opaqueStruct_pointerAndName() {
        let tester = prepareTest(declaration: "typedef struct _A A, *APtr;")

        tester.assert { asserter in
            asserter.assertCount(2)
            asserter
                .assertTypedef(name: "A")?
                .assert(type: .incompleteStruct("_A"))
            asserter
                .assertTypedef(name: "APtr")?
                .assert(type: .pointer("A"))
        }
    }
    
    func testTranslate_singleDecl_function_noParameters() {
        let tester = prepareTest(declaration: "void global();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "global")?
                .assertParameterCount(0)?
                .asserter(forKeyPath: \.isVariadic) { isVariadic in
                    isVariadic.assertIsFalse()
                }
        }
    }
    
    func testTranslate_singleDecl_function_instancetypeReturnType() {
        let tester = prepareTest(declaration: "instancetype global();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "global")?
                .assertReturnType(.instancetype)
        }
    }
    
    func testTranslate_singleDecl_function_idReturnType() {
        let tester = prepareTest(declaration: "id global();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "global")?
                .assertReturnType(.id())
        }
    }
    
    func testTranslate_singleDecl_function_idWithProtocolListReturnType() {
        let tester = prepareTest(declaration: "id<AProtocol, BProtocol> global();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "global")?
                .assertReturnType(.id(protocols: ["AProtocol", "BProtocol"]))
        }
    }
    
    func testTranslate_singleDecl_function_takesBlock() {
        let tester = prepareTest(declaration: "NSString *takesBlockGlobal(void(^block)());")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "takesBlockGlobal")?
                .assertParameterCount(1)?
                .assertReturnType(.pointer("NSString"))?
                .assertParameterName(at: 0, "block")?
                .assertParameterType(at: 0, .blockType(name: "block", returnType: .void))
        }
    }
    
    func testTranslate_singleDecl_function_returnsComplexType() {
        let tester = prepareTest(declaration: "NSArray<NSArray<NSString*>*> *_Nonnull global();")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertFunction(name: "global")?
                .assertReturnType(
                    .pointer(
                        .genericTypeName(
                            "NSArray",
                            typeParameters: [
                                .genericTypeName(
                                    "NSArray",
                                    typeParameters: [
                                        .pointer("NSString")
                                    ]
                                ).wrapAsPointer
                            ]
                        ),
                        nullabilitySpecifier: .nonnull
                    )
                )
        }
    }

    func testTranslate_singleDecl_function_variadicParameter() {
        let tester = prepareTest(declaration: "short int a(int p1, ...);")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .asserter(forItemAt: 0) { aFunc in
                    aFunc.assertIsFunction()?
                        .assertParameterCount(1)?
                        .asserter(forKeyPath: \.isVariadic) { isVariadic in
                            isVariadic.assertIsTrue()
                        }
                }
        }
    }

    func testTranslate_singleDecl_incompleteStruct() {
        let tester = prepareTest(declaration: "struct a b;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "b")?
                .assert(type: .incompleteStruct("a"))
        }
    }

    func testTranslate_singleDecl_struct_named() {
        let tester = prepareTest(declaration: "struct AStruct { int field; };")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertStructOrUnion(name: "AStruct")
        }
    }

    func testTranslate_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertStructOrUnion(name: "AStruct")?
                .assertFieldCount(1)?
                .assertField(name: "field", type: "signed int")
        }
    }

    func testTranslate_singleDecl_struct_typedef_pointerReference() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct, *AStructPtr;")

        tester.assert { asserter in
            asserter.assertCount(2)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct.assertIsStructOrUnion()
                }?
                .asserter(forItemAt: 1) { typedef in
                    typedef.assertIsTypeDef()?
                        .assert(name: "AStructPtr")?
                        .assert(type: .pointer("AStruct"))
                }
        }
    }

    func testTranslate_singleDecl_struct_typedef_typeDeclaratorStressCases() {
        let tester = prepareTest(declaration: "typedef struct { int field; } A, *APtr, AArray[5], *AArrayPtr[5], (*AFuncRet)();")

        tester.assert { asserter in
            asserter.assertCount(5)?.asserterForIterator()
                .asserterForNext { a in
                    a.assertIsStructOrUnion()
                }?
                .asserterForNext { ptr in
                    ptr.assertIsTypeDef()?
                        .assert(name: "APtr")?
                        .assert(type: .pointer("A"))
                }?
                .asserterForNext { array in
                    array.assertIsTypeDef()?
                        .assert(name: "AArray")?
                        .assert(type: .fixedArray("A", length: 5))
                }?
                .asserterForNext { arrayPtr in
                    arrayPtr.assertIsTypeDef()?
                        .assert(name: "AArrayPtr")?
                        .assert(type: .fixedArray(.pointer("A"), length: 5))
                }?
                .asserterForNext { funcRet in
                    funcRet.assertIsTypeDef()?
                        .assert(name: "AFuncRet")?
                        .assert(type: .functionPointer(name: "AFuncRet", returnType: "A"))
                }?
                .assertIsAtEnd()
        }
    }

    func testTranslate_singleDecl_enum_named() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 1, CASE1 = 2 };")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertEnum(name: "AnEnum")
        }
    }

    func testTranslate_singleDecl_enum_typedef() {
        let tester = prepareTest(declaration: "typedef enum { CASE0 = 1, CASE1 = 2, CASE2 } AnEnum;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertEnum(name: "AnEnum")?
                .assertEnumeratorCount(3)?
                .assertEnumerator(name: "CASE0", expressionString: "1")?
                .assertEnumerator(name: "CASE1", expressionString: "2")?
                .assertEnumerator(name: "CASE2")
        }
    }

    func testTranslate_singleDecl_enum_nsEnum() {
        let tester = prepareTest(declaration: "typedef NS_ENUM(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertEnum(name: "AnEnum")?
                .assertTypeName("NSInteger")?
                .assertEnumeratorCount(3)?
                .assertEnumerator(name: "CASE0")?
                .assertEnumerator(name: "CASE1")?
                .assertEnumerator(name: "CASE2")
        }
    }

    func testTranslate_singleDecl_enum_nsOptions() {
        let tester = prepareTest(declaration: "typedef NS_OPTIONS(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertEnum(name: "AnEnum")?
                .assertTypeName("NSInteger")?
                .assertEnumeratorCount(3)?
                .assertEnumerator(name: "CASE0")?
                .assertEnumerator(name: "CASE1")?
                .assertEnumerator(name: "CASE2")
        }
    }

    func testTranslate_singleDecl_struct_anonymous_doesNotTranslate() {
        let tester = prepareTest(declaration: "struct { int field; };")

        tester.assert { asserter in
            asserter.assertNoDeclarations()
        }
    }
    
    func testTranslate_objcType_blockType_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "nullable void (^)(nonnull NSString*);")

        tester.assertObjcType { asserter in
            asserter.assert(equals:
                .nullabilitySpecified(
                    specifier: .nullable,
                    .blockType(
                        returnType: .void,
                        parameters: [
                            .nullabilitySpecified(
                                specifier: .nonnull,
                                .pointer("NSString")
                            ),
                        ]
                    )
                )
            )
        }
    }
}

private extension DeclarationTranslatorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(sourceString: declaration)
    }
    
    class Tester: SingleRuleParserTestFixture<ObjectiveCParser.DeclarationContext> {
        var sourceString: String
        var source: Source

        init(sourceString: String) {
            self.sourceString = sourceString
            self.source = StringCodeSource(source: sourceString)

            super.init(ruleDeriver: ObjectiveCParser.declaration)
        }

        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[DeclarationTranslator.ASTNodeDeclaration]>) throws -> Void
        ) rethrows {

            let extractor = DeclarationExtractor()
            let declParser = AntlrDeclarationParser(source: source)
            let sut = DeclarationTranslator()

            do {
                let parserRule = try parse(sourceString, file: file, line: line)

                guard let decl = declParser.declaration(parserRule) else {
                    XCTFail(
                        "Failed to parse from source string: \(AntlrDeclarationParser.self) returned nil for AntlrDeclarationParser.declaration(_:)",
                        file: file,
                        line: line
                    )

                    return
                }

                let declarations = extractor.extract(from: decl)

                let result = declarations.flatMap { decl in
                    sut.translate(decl)
                }

                try closure(.init(object: result))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)\n\(error)",
                    file: file,
                    line: line
                )
            }
        }

        func assertObjcType(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<ObjcType?>) throws -> Void
        ) rethrows {

            let extractor = DeclarationExtractor()
            let declParser = AntlrDeclarationParser(source: source)
            let sut = DeclarationTranslator()

            do {
                let parserRule = try parse(
                    sourceString,
                    file: file,
                    line: line,
                    ruleDeriver: ObjectiveCParser.typeName
                )

                guard let typeNameSyntax = declParser.typeName(parserRule) else {
                    XCTFail(
                        "Failed to parse from source string: \(AntlrDeclarationParser.self) returned nil for AntlrDeclarationParser.typeName(_:)",
                        file: file,
                        line: line
                    )
                    return
                }

                guard let typeName = extractor.extract(fromTypeName: typeNameSyntax) else {
                    try closure(.init(object: nil))
                    return
                }

                let type = sut.translateObjectiveCType(typeName)

                try closure(.init(object: type))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)\n\(error)",
                    file: file,
                    line: line
                )
            }
        }
    }
}
