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
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a = 0;") { asserter in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .assertInitializer { aInit in
                    aInit.assertString(matches: "0")
                }
        }
    }

    func testExtract_declaration_singleDecl_noInitializer() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a;") { asserter in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_noInitializer() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a, b;") { asserter in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
            asserter.assertVariable(name: "b", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_singlePointer() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int *a, b;") { asserter in
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
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a = 0, b;") { asserter in
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
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("void a();") { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_voidParameterList() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("void a(void);") { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_noParameter() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a();") { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_withParameters() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int a(int p1, int *p2);") { asserter in
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
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("short int *a();") { asserter in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertIsPointer()
        }
    }

    func testExtract_declaration_singleDecl_unsizedArray() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("int a[];") { asserter in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: nil)?
                .assertIsNotPointer()
        }
    }

    func testExtract_declaration_singleDecl_staticArray() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("int a[5];") { asserter in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: 5)?
                .assertIsNotPointer()
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_noParameters() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("void (^a)();") { asserter in
            asserter
                .assertBlock(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_withInitializer() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("void (^a)() = ^{ };") { asserter in
            asserter
                .assertBlock(name: "a")?
                .assertHasInitializer()
        }
    }

    func testExtract_singleDec_typedef_functionPointer() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("typedef int (*f)(void *, void *);") { asserter in
            asserter
                .asserter(forDecl: "f") { fDecl in
                    fDecl.assertIsFunctionPointer(name: "f")
                }
        }
    }

    func testExtract_singleDecl_struct_named() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("struct AStruct { int field; };") { asserter in
            asserter
                .asserter(forDecl: "AStruct") { aStruct in
                    aStruct.assertIsStructOrUnion()
                }
        }
    }

    func testExtract_singleDecl_struct_typedef() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("typedef struct { int field; } AStruct;") { asserter in
            asserter
                .asserter(forStruct: "AStruct") { aStruct in
                    aStruct
                        .assertField(name: "field")
                }
        }
    }

    func testExtract_singleDecl_enum_named() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("enum AnEnum { CASE0 = 1, CASE1 = 2 };") { asserter in
            asserter
                .asserter(forDecl: "AnEnum") { aStruct in
                    aStruct.assertIsEnum()
                }
        }
    }

    func testExtract_singleDecl_enum_typedef() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("typedef enum { CASE0 = 1, CASE1 = 2, CASE2 } AnEnum;") { asserter in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_singleDecl_struct_anonymous_doesNotExtract() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("struct { int field; };") { asserter in
            asserter
                .assertNoDeclarations()
        }
    }

    func testExtract_singleDecl_enum_anonymous_doesNotExtract() {
        let tester = prepareTester(ObjectiveCParser.declaration, { $0.extract(from: $1) })

        tester.assert("enum { CASE0 = 0 };") { asserter in
            asserter
                .assertNoDeclarations()
        }
    }
}

// MARK: - Test Internals

private extension DeclarationExtractorTests {
    func prepareTester<T: ParserRuleContext>(
        _ ruleDeriver: @escaping (ObjectiveCParser) -> () throws -> T,
        _ parseMethod: @escaping (DeclarationExtractor, T) -> [DeclarationExtractor.Declaration]
    ) -> Tester<T> {
        
        let tester = Tester<T>(
            ruleDeriver: ruleDeriver,
            parseMethod: parseMethod,
            declarationExtractor: self.makeSut()
        )

        _retainedParser = tester.parserObject
        
        return tester
    }
    
    func makeSut() -> DeclarationExtractor {
        return DeclarationExtractor()
    }
    
    class Tester<T: ParserRuleContext> {
        var parserObject: ObjectiveCParserAntlr?
        let parserState = ObjcParserState()
        let ruleDeriver: (ObjectiveCParser) -> () throws -> T
        let parseMethod: (DeclarationExtractor, T) -> [DeclarationExtractor.Declaration]
        let declarationExtractor: DeclarationExtractor
        
        init(
            ruleDeriver: @escaping (ObjectiveCParser) -> () throws -> T,
            parseMethod: @escaping (DeclarationExtractor, T) -> [DeclarationExtractor.Declaration],
            declarationExtractor: DeclarationExtractor
        ) {
            
            self.ruleDeriver = ruleDeriver
            self.parseMethod = parseMethod
            self.declarationExtractor = declarationExtractor
        }

        func assert(
            _ string: String,
            line: UInt = #line,
            closure: (Asserter<[DeclarationExtractor.Declaration]>) throws -> Void
        ) rethrows {
            
            let parserObject = try! parserState.makeMainParser(input: string)
            self.parserObject = parserObject

            let parser = parserObject.parser
            let errorListener = ErrorListener()
            parser.removeErrorListeners()
            parser.addErrorListener(errorListener)
            
            let rule = try! ruleDeriver(parser)()
            
            if errorListener.hasErrors {
                XCTFail("Parser errors while parsing '\(string)': \(errorListener.errorDescription)", line: line)
                return
            }
            
            let result = parseMethod(declarationExtractor, rule)
            
            try closure(Asserter(object: result))
        }
    }
}
