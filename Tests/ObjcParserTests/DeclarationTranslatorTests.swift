import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

@testable import ObjcParser

class DeclarationTranslatorTests: XCTestCase {
    func testTranslate_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: "signed short int")
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

    func testTranslate_singleDecl_variable_array_unsized() {
        let tester = prepareTest(declaration: "short int a[];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_unsized() {
        let tester = prepareTest(declaration: "short int *a[];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .pointer(.pointer("signed short int")))
        }
    }

    func testTranslate_singleDecl_variable_array_sized() {
        let tester = prepareTest(declaration: "short int a[10];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_sized() {
        let tester = prepareTest(declaration: "short int *a[10];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assert(type: .fixedArray(.pointer("signed short int"), length: 10))
        }
    }

    func testTranslate_multiDecl_variable() {
        let tester = prepareTest(declaration: "short int a, b, *c;")

        tester.assert { asserter in
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
            asserter
                .assertVariable(name: "a")?
                .assertHasInitializer()?
                .assert(type: "signed short int")
        }
    }

    func testTranslate_singleDecl_block_withInitializer() {
        let tester = prepareTest(declaration: "void (^a)() = ^{ };")

        tester.assert { asserter in
            asserter
                .assertBlock(name: "a")?
                .assertHasInitializer()
        }
    }

    func testTranslate_singleDecl_typedef() {
        let tester = prepareTest(declaration: "typedef unsigned long long int A;")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "A")?
                .assert(type: "unsigned long long int")
        }
    }

    func testTranslate_singleDecl_typedef_pointer() {
        let tester = prepareTest(declaration: "typedef void *A;")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "A")?
                .assert(type: .pointer(.void))
        }
    }

    func testTranslate_singleDecl_typedef_block() {
        let tester = prepareTest(declaration: "typedef void(^_Nonnull Callback)();")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "Callback")?
                .assert(type: .blockType(name: "Callback", returnType: .void))
        }
    }

    func testTranslate_singleDecl_typedef_array_sized() {
        let tester = prepareTest(declaration: "typedef short int A[10];")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "A")?
                .assert(type: .fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDec_typedef_functionPointer() {
        let tester = prepareTest(declaration: "typedef int (*f)(void *, void *);")

        tester.assert { asserter in
            asserter
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
    
    func testTranslate_singleDecl_function_takesBlock() {
        let tester = prepareTest(declaration: "NSString *takesBlockGlobal(void(^block)());")

        tester.assert { asserter in
            asserter
                .assertFunction(name: "takesBlockGlobal")?
                .assertParameterCount(1)?
                .assertReturnType(.pointer("NSString"))?
                .assertParameterName(at: 0, "block")?
                .assertParameterType(at: 0, .blockType(name: "block", returnType: .void))
        }
    }

    func testTranslate_singleDecl_struct_named() {
        let tester = prepareTest(declaration: "struct AStruct { int field; };")

        tester.assert { asserter in
            asserter
                .assertStructOrUnion(name: "AStruct")
        }
    }

    func testTranslate_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct;")

        tester.assert { asserter in
            asserter
                .assertStructOrUnion(name: "AStruct")?
                .assertFieldCount(1)?
                .assertField(name: "field", type: "signed int")
        }
    }

    func testTranslate_singleDecl_struct_typedef_pointerReference() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct, *AStructPtr;")

        tester.assert { asserter in
            asserter
                .assertCount(2)?
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
                }
        }
    }

    func testTranslate_singleDecl_enum_named() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 1, CASE1 = 2 };")

        tester.assert { asserter in
            asserter
                .assertEnum(name: "AnEnum")
        }
    }

    func testTranslate_singleDecl_enum_typedef() {
        let tester = prepareTest(declaration: "typedef enum { CASE0 = 1, CASE1 = 2, CASE2 } AnEnum;")

        tester.assert { asserter in
            asserter
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
            asserter
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
            asserter
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
            asserter
                .assertNoDeclarations()
        }
    }
}

private extension DeclarationTranslatorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(source: declaration)
    }
    
    class Tester: BaseParserTestFixture<ObjectiveCParser.DeclarationContext> {
        var source: String
        var nodeFactory: ASTNodeFactory

        init(source: String) {
            self.source = source

            nodeFactory = ASTNodeFactory(
                source: StringCodeSource(source: source),
                nonnullContextQuerier: NonnullContextQuerier(nonnullMacroRegionsTokenRange: []),
                commentQuerier: CommentQuerier(allComments: [])
            )

            super.init(ruleDeriver: ObjectiveCParser.declaration)
        }

        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[DeclarationTranslator.ASTNodeDeclaration]>) throws -> Void
        ) rethrows {

            let extractor = DeclarationExtractor()
            let sut = DeclarationTranslator()
            let context = DeclarationTranslator.Context(nodeFactory: nodeFactory)

            do {
                let parserRule = try parse(source)
                let declarations = extractor.extract(from: parserRule)

                let result = declarations.flatMap { decl in sut.translate(decl, context: context) }

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
