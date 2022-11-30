import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

@testable import ObjcParser

class DeclarationExtractorTests: XCTestCase {
    private var _retainedParser: ObjectiveCParserAntlr?

    override func tearDown() {
        _retainedParser = nil
    }
    
    func testExtract_declaration_singleDecl_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { asserter in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .assertInitializer { aInit in
                    aInit.assertString(matches: "0")
                }
        }
    }

    func testExtract_declaration_singleDecl_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { asserter in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_noInitializer() {
        let tester = prepareTest(declaration: "short int a, b;")

        tester.assert { asserter in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
            asserter.assertVariable(name: "b", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_singlePointer() {
        let tester = prepareTest(declaration: "short int *a, b;")

        tester.assert { asserter in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .asserterForPointer { ptr in
                    XCTAssertEqual(ptr.object.pointers.count, 1)
                }
            asserter.assertVariable(name: "b", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_singleInitializer() {
        let tester = prepareTest(declaration: "short int a = 0, b;")

        tester.assert { asserter in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .assertInitializer { aInit in
                    aInit.assertString(matches: "0")
                }
            asserter
                .assertVariable(name: "b")?
                .assert(specifierStrings: ["short", "int"])?
                .assertNoInitializer()
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_noParameter() {
        let tester = prepareTest(declaration: "void a();")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_voidParameterList() {
        let tester = prepareTest(declaration: "void a(void);")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_noParameter() {
        let tester = prepareTest(declaration: "short int a();")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_withParameters() {
        let tester = prepareTest(declaration: "short int a(int p1, int *p2);")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertHasParameter(name: "p1")?
                .assertHasParameter(name: "p2") { p2Param in
                    p2Param.assert(specifierStrings: ["int"])
                    p2Param.assertIsPointer()
                }
        }
    }

    func testExtract_declaration_singleDecl_function_pointer() {
        let tester = prepareTest(declaration: "short int *a();")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertIsPointer()
        }
    }

    func testExtract_declaration_singleDecl_unsizedArray() {
        let tester = prepareTest(declaration: "int a[];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: nil)?
                .assertIsNotPointer()
        }
    }

    func testExtract_declaration_singleDecl_staticArray() {
        let tester = prepareTest(declaration: "int a[5];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: 5)?
                .assertIsNotPointer()
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_noParameters() {
        let tester = prepareTest(declaration: "void (^a)();")

        tester.assert { asserter in
            asserter
                .assertBlock(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_withInitializer() {
        let tester = prepareTest(declaration: "void (^a)() = ^{ };")

        tester.assert { asserter in
            asserter
                .assertBlock(name: "a")?
                .assertHasInitializer()
        }
    }

    func testExtract_singleDec_typedef_functionPointer() {
        let tester = prepareTest(declaration: "typedef int (*f)(void *, void *);")

        tester.assert { asserter in
            asserter
                .asserter(forDecl: "f") { fDecl in
                    fDecl.assertIsFunctionPointer(name: "f")
                }
        }
    }

    func testExtract_singleDecl_struct_named() {
        let tester = prepareTest(declaration: "struct AStruct { int field; };")

        tester.assert { asserter in
            asserter
                .asserter(forStruct: "AStruct") { aStruct in
                    aStruct.assertFieldCount(1)?
                        .assertField(name: "field")
                }
        }
    }

    func testExtract_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct;")

        tester.assert { asserter in
            asserter
                .asserter(forStruct: "AStruct") { aStruct in
                    aStruct
                        .assertField(name: "field")
                }
        }
    }

    func testExtract_singleDecl_struct_typedef_pointerReference() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct, *AStructPtr;")

        tester.assert { asserter in
            asserter
                .assertDefinedCount(2)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct
                        .assertIsStructOrUnion()?
                        .assertIsNotPointer()
                }?
                .asserter(forItemAt: 1) { typedef in
                    typedef
                        .assertIsTypeDef()?
                        .assertIsPointer()
                }
        }
    }

    func testExtract_singleDecl_struct_typedef_typeDeclaratorStressCases() {
        let tester = prepareTest(declaration: "typedef struct { int field; } A, *APtr, AArray[5], *AArrayPtr[5], (*AFuncRet)();")

        tester.assert { asserter in
            asserter
                .assertDefinedCount(5)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct
                        .assertIsStructOrUnion()?
                        .assertIsNotPointer()
                }?
                .asserter(forItemAt: 1) { ptr in
                    ptr
                        .assertIsTypeDef()?
                        .assertIsPointer()
                }?
                .asserter(forItemAt: 2) { array in
                    array.assertIsTypeDef()?
                        .assertIsStaticArray(count: 5)
                }?
                .asserter(forItemAt: 3) { array in
                    array.assertIsTypeDef()?
                        .assertIsStaticArray(count: 5)?
                        .assertIsPointer()
                }?
                .asserter(forItemAt: 4) { array in
                    array.assertIsFunctionPointer(name: "AFuncRet")
                }
        }
    }

    func testExtract_singleDecl_enum_named() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 1, CASE1 = 2 };")

        tester.assert { asserter in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertNoTypeName()
                }
        }
    }

    func testExtract_singleDecl_enum_typedef() {
        let tester = prepareTest(declaration: "typedef enum { CASE0 = 1, CASE1 = 2, CASE2 } AnEnum;")

        tester.assert { asserter in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertNoTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_singleDecl_enum_nsEnum() {
        let tester = prepareTest(declaration: "typedef NS_ENUM(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { asserter in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertHasTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_singleDecl_enum_nsOptions() {
        let tester = prepareTest(declaration: "typedef NS_OPTIONS(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { asserter in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertHasTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_singleDecl_struct_anonymous_doesNotExtract() {
        let tester = prepareTest(declaration: "struct { int field; };")

        tester.assert { asserter in
            asserter
                .assertNoDeclarations()
        }
    }

    func testExtract_singleDecl_enum_anonymous_doesNotExtract() {
        let tester = prepareTest(declaration: "enum { CASE0 = 0 };")

        tester.assert { asserter in
            asserter
                .assertNoDeclarations()
        }
    }
}

// MARK: - Test Internals

private extension DeclarationExtractorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(source: declaration)
    }
    
    class Tester: BaseParserTestFixture<ObjectiveCParser.DeclarationContext> {
        var source: String

        init(source: String) {
            self.source = source

            super.init(ruleDeriver: ObjectiveCParser.declaration)
        }

        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[DeclarationExtractor.Declaration]>) throws -> Void
        ) rethrows {

            let sut = DeclarationExtractor()

            do {
                let parserRule = try parse(source)
                let result = sut.extract(from: parserRule)

                try closure(.init(object: result))
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
