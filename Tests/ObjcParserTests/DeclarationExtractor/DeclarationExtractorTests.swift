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
    
    func testExtract_declaration_singleDecl_unusedPrefix() {
        let tester = prepareTest(declaration: "__unused int a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["int"])
        }
    }
    
    func testExtract_declaration_singleDecl_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .asserterForSourceRange { sourceRange in
                    sourceRange.assert(
                        start: .init(line: 1, column: 11)
                    )
                }?
                .assertInitializer { aInit in
                    aInit.assert(textEquals: "0")
                }
        }
    }
    
    func testExtract_declaration_singleDecl_mixedTypePrefixAndSpecifiers() {
        let tester = prepareTest(declaration: "nullable __kindof NSString *a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["__kindof", "_Nullable", "NSString"])
        }
    }

    func testExtract_declaration_singleDecl_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_singleDecl_static() {
        let tester = prepareTest(declaration: "static short int a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertVariable(name: "a", specifierStrings: ["static", "short", "int"])
        }
    }

    func testExtract_declaration_singleDecl_variable_typeName_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "_Nonnull callback a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["_Nonnull", "callback"])
        }
    }

    func testExtract_declaration_singleDecl_variable_typeName_weakSpecifier() {
        let tester = prepareTest(declaration: "_weak callback a;")

        tester.assert { asserter in
            asserter.assertCount(1)?
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["_weak", "callback"])
        }
    }

    func testExtract_declaration_multiDecl_noInitializer() {
        let tester = prepareTest(declaration: "short int a, b;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertVariable(name: "a", specifierStrings: ["short", "int"])
            asserter.assertVariable(name: "b", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_multiDecl_singlePointer() {
        let tester = prepareTest(declaration: "short int *a, b;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .asserterForPointer { ptr in
                    XCTAssertEqual(ptr.object.pointers.count, 1)
                }
            asserter.assertVariable(name: "b", specifierStrings: ["short", "int"])
        }
    }

    func testExtract_declaration_singleDecl_pointer_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "NSObject *_Nonnull a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["NSObject"])?
                .asserterForPointer { ptr in
                    ptr.assertPointerCount(1)?.asserter(forPointerEntryAt: 0) { ptr in
                        ptr.assert(typeQualifierStrings: nil)?
                            .assert(nullabilitySpecifier: .nonnull)
                    }
                }
        }
    }

    func testExtract_declaration_singleDecl_pointer_weakSpecifier() {
        let tester = prepareTest(declaration: "__weak NSObject *_Nonnull a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["__weak", "NSObject"])?
                .asserterForPointer { ptr in
                    ptr.assertPointerCount(1)?.asserter(forPointerEntryAt: 0) { ptr in
                        ptr.assert(typeQualifierStrings: nil)?
                            .assert(nullabilitySpecifier: .nonnull)
                    }
                }
        }
    }

    func testExtract_declaration_singleDecl_qualifiedObjcPointerType() {
        let tester = prepareTest(declaration: "NSArray<NSArray<NSString*>*> *_Nonnull a;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["NSArray<NSArray<NSString*>*>"])?
                .asserterForPointer { ptr in
                    XCTAssertEqual(ptr.object.pointers.count, 1)
                }
        }
    }

    func testExtract_declaration_multiDecl_singleInitializer() {
        let tester = prepareTest(declaration: "short int a = 0, b;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forVariable: "a")?
                .assert(specifierStrings: ["short", "int"])?
                .assertInitializer { aInit in
                    aInit.assert(textEquals: "0")
                }
            asserter
                .assertVariable(name: "b")?
                .assert(specifierStrings: ["short", "int"])?
                .assertNoInitializer()
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_noParameter() {
        let tester = prepareTest(declaration: "void a();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_voidParameterList() {
        let tester = prepareTest(declaration: "void a(void);")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_voidReturn_voidPointerParameterList() {
        let tester = prepareTest(declaration: "void a(void*);")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(1)
        }
    }

    func testExtract_declaration_singleDecl_function_complexReturnType() {
        let tester = prepareTest(declaration: "NSArray<NSArray<NSString*>*> *_Nonnull global();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "global")?
                .assert(returnTypeSpecifierStrings: ["NSArray<NSArray<NSString*>*>"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_declaration_singleDecl_function_noParameter() {
        let tester = prepareTest(declaration: "short int a();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertParameterCount(0)?
                .asserter(forKeyPath: \.isVariadic) { isVariadic in
                    isVariadic.assertIsFalse()
                }
        }
    }

    func testExtract_declaration_singleDecl_function_withParameters() {
        let tester = prepareTest(declaration: "short int a(int p1, int *p2);")

        tester.assert { (asserter: DeclarationsAsserter) in
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

    func testExtract_declaration_singleDecl_function_variadicParameter() {
        let tester = prepareTest(declaration: "short int a(int p1, ...);")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertParameterCount(1)?
                .assertHasParameter(name: "p1")?
                .asserter(forKeyPath: \.isVariadic) { isVariadic in
                    isVariadic.assertIsTrue()
                }
        }
    }

    func testExtract_declaration_singleDecl_function_pointer() {
        let tester = prepareTest(declaration: "short int *a();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertFunction(name: "a")?
                .assert(returnTypeSpecifierStrings: ["short", "int"])?
                .assertIsPointer()
        }
    }

    func testExtract_declaration_singleDecl_unsizedArray() {
        let tester = prepareTest(declaration: "int a[];")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: nil)?
                .assertIsNotPointer()?
                .asserterForSourceRange { sourceRange in
                    sourceRange.assert(
                        start: .init(line: 1, column: 5)
                    )
                }
        }
    }

    func testExtract_declaration_singleDecl_staticArray() {
        let tester = prepareTest(declaration: "int a[5];")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertVariable(name: "a")?
                .assert(specifierStrings: ["int"])?
                .assertIsStaticArray(count: 5)?
                .assertIsNotPointer()
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_noParameters() {
        let tester = prepareTest(declaration: "void (^a)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assert(returnTypeSpecifierStrings: ["void"])?
                .assertParameterCount(0)?
                .asserterForSourceRange { sourceRange in
                    sourceRange.assert(
                        start: .init(line: 1, column: 8)
                    )
                }
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_withParameters() {
        let tester = prepareTest(declaration: "void (^a)(int, int *p2) = ^{ };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assertParameterCount(2)?
                .asserterForParameter(atIndex: 0) { (param0: FuncParameterAsserter) in
                    param0.assertIsTypeName()
                }
                .asserterForParameter(atIndex: 1) { (param1: FuncParameterAsserter) in
                    param1.asserterForDeclaration { (p2Param: DeclarationAsserter) in
                        p2Param.assertIsVariable(name: "p2")
                        p2Param.assert(specifierStrings: ["int"])
                        p2Param.assertIsPointer()
                    }                        
                }
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_withInitializer() {
        let tester = prepareTest(declaration: "void (^a)() = ^{ };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assertHasInitializer()
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "void (^_Nonnull a)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assert(hasNullabilitySpecifier: .nonnull)
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_typePrefix() {
        let tester = prepareTest(declaration: "void (^__block a)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assert(hasTypePrefix: .block)
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_arcSpecifier() {
        let tester = prepareTest(declaration: "void (^__weak a)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assert(hasArcSpecifier: .weak)
        }
    }

    func testExtract_declaration_singleDecl_blockDecl_typeQualifier() {
        let tester = prepareTest(declaration: "void (^const a)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertBlock(name: "a")?
                .assert(hasTypeQualifier: .const)
        }
    }

    func testExtract_declaration_singleDecl_typedef_block() {
        let tester = prepareTest(declaration: "typedef void(^errorBlock)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forDecl: "errorBlock") { decl in
                    decl.assertIsTypeDef()?
                        .asserterForSourceRange { sourceRange in
                            sourceRange.assert(
                                start: .init(line: 1, column: 15)
                            )
                        }
                }
        }
    }

    func testExtract_declaration_singleDecl_typedef_functionPointer() {
        let tester = prepareTest(declaration: "typedef int (*f)(void *, void *);")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forDecl: "f") { fDecl in
                    fDecl.assertIsFunctionPointer(name: "f")
                }
        }
    }

    func testExtract_declaration_singleDecl_typedef_functionPointer_takingBlockParameter() {
        let tester = prepareTest(declaration: "typedef int (*callback)(void (^)(), void *);")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forDecl: "callback") { decl in
                    decl.assertIsTypeDef()
                }
        }
    }

    func testExtract_declaration_singleDecl_typedef_opaqueStruct() {
        let tester = prepareTest(declaration: "typedef struct _A A;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forDecl: "A") { aDecl in
                    aDecl.assertIsTypeDef()?
                        .asserterForSourceRange { sourceRange in
                            sourceRange.assert(
                                start: .init(line: 1, column: 19)
                            )
                        }
                }
        }
    }

    func testExtract_declaration_singleDecl_typedef_opaqueStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct _A *A;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forDecl: "A") { aDecl in
                    aDecl.assertIsTypeDef()?
                        .asserterForSourceRange { sourceRange in
                            sourceRange.assert(
                                start: .init(line: 1, column: 20)
                            )
                        }
                }
        }
    }

    func testExtract_declaration_singleDecl_struct_named() {
        let tester = prepareTest(declaration: "struct AStruct { int field; };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forStruct: "AStruct") { aStruct in
                    aStruct.assertFieldCount(1)?
                        .asserterForSourceRange { sourceRange in
                            sourceRange.assert(
                                start: .init(line: 1, column: 1)
                            )
                        }?
                        .assertField(name: "field")
                }
        }
    }

    func testExtract_declaration_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter.assertDefinedCount(1)?
                .asserter(forStruct: "AStruct") { aStruct in
                    aStruct
                        .assertField(name: "field")
                }
        }
    }

    func testExtract_declaration_singleDecl_struct_typedef_pointerReference() {
        let tester = prepareTest(declaration: "typedef struct { int field; } AStruct, *AStructPtr;")

        tester.assert { (asserter: DeclarationsAsserter) in
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

    func testExtract_declaration_singleDecl_struct_typedef_typeDeclaratorStressCases() {
        let tester = prepareTest(declaration: "typedef struct { int field; } A, *APtr, AArray[5], *AArrayPtr[5], (*AFuncRet)();")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertDefinedCount(5)?
                .asserter(forItemAt: 0) { (aStruct: DeclarationAsserter) in
                    aStruct
                        .assertIsStructOrUnion()?
                        .assertIsNotPointer()
                }?
                .asserter(forItemAt: 1) { (ptr: DeclarationAsserter) in
                    ptr
                        .assertIsTypeDef()?
                        .assertIsPointer()
                }?
                .asserter(forItemAt: 2) { (array: DeclarationAsserter) in
                    array.assertIsTypeDef()?
                        .assertIsStaticArray(count: 5)
                }?
                .asserter(forItemAt: 3) { (array: DeclarationAsserter) in
                    array.assertIsTypeDef()?
                        .assertIsStaticArray(count: 5)?
                        .assertIsPointer()
                }?
                .asserter(forItemAt: 4) { (array: DeclarationAsserter) in
                    array.assertIsFunctionPointer(name: "AFuncRet")
                }
        }
    }

    func testExtract_declaration_singleDecl_enum_named() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 1, CASE1 = 2 };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertNoTypeName()
                }
        }
    }

    func testExtract_declaration_singleDecl_enum_typedef() {
        let tester = prepareTest(declaration: "typedef enum { CASE0 = 1, CASE1 = 2, CASE2 } AnEnum;")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertNoTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_declaration_singleDecl_enum_nsEnum() {
        let tester = prepareTest(declaration: "typedef NS_ENUM(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertHasTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_declaration_singleDecl_enum_nsOptions() {
        let tester = prepareTest(declaration: "typedef NS_OPTIONS(NSInteger, AnEnum) { CASE0 = 1, CASE1 = 2, CASE2 };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .asserter(forEnum: "AnEnum") { anEnum in
                    anEnum.assertEnumeratorCount(3)?.assertHasTypeName()
                    anEnum.assertEnumerator(name: "CASE0")
                    anEnum.assertEnumerator(name: "CASE1")
                    anEnum.assertEnumerator(name: "CASE2")
                }
        }
    }

    func testExtract_declaration_singleDecl_struct_anonymous_doesNotExtract() {
        let tester = prepareTest(declaration: "struct { int field; };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertNoDeclarations()
        }
    }

    func testExtract_declaration_singleDecl_enum_anonymous_doesNotExtract() {
        let tester = prepareTest(declaration: "enum { CASE0 = 0 };")

        tester.assert { (asserter: DeclarationsAsserter) in
            asserter
                .assertNoDeclarations()
        }
    }

    func testExtract_fieldDeclaration_singleDecl_variable() {
        let tester = prepareTest(declaration: "int a;")

        tester.assertFieldDeclaration { asserter in
            asserter
                .assertVariable(name: "a")
        }
    }

    func testExtract_fieldDeclaration_singleDecl_block_noParameters() {
        let tester = prepareTest(declaration: "int (^a)();")

        tester.assertFieldDeclaration { asserter in
            asserter
                .assertBlock(name: "a")?
                .assert(returnTypeSpecifierStrings: ["int"])?
                .assertParameterCount(0)
        }
    }

    func testExtract_fieldDeclaration_singleDecl_block_withParameters() {
        let tester = prepareTest(declaration: "void (^a)(int, int *p2);")

        tester.assertFieldDeclaration { asserter in
            asserter
                .assertBlock(name: "a")?
                .assertParameterCount(2)?
                .asserterForParameter(atIndex: 0) { (param0: FuncParameterAsserter) in
                    param0.assertIsTypeName()
                }
                .asserterForParameter(atIndex: 1) { (param1: FuncParameterAsserter) in
                    param1.asserterForDeclaration { (p2Param: DeclarationAsserter) in
                        p2Param.assertIsVariable(name: "p2")
                        p2Param.assert(specifierStrings: ["int"])
                        p2Param.assertIsPointer()
                    }                        
                }
        }
    }
}

// MARK: - Test Internals

private extension DeclarationExtractorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(sourceString: declaration)
    }
    
    class Tester: BaseParserTestFixture {
        var sourceString: String
        var source: Source

        init(sourceString: String) {
            self.sourceString = sourceString
            self.source = StringCodeSource(source: sourceString)

            super.init()
        }

        /// Opens an assertion context for parsing declarations from a
        /// `ObjectiveCParser.Declaration` that is parsed from the current input
        /// source.
        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[DeclarationExtractor.Declaration]>) throws -> Void
        ) rethrows {

            let sut = DeclarationExtractor()
            let declParser = AntlrDeclarationParser(source: source)

            do {
                let parserRule = try parse(
                    sourceString,
                    file: file,
                    line: line,
                    ruleDeriver: ObjectiveCParser.declaration
                )

                guard let decl = declParser.declaration(parserRule) else {
                    XCTFail(
                        "Failed to parse from source string: \(AntlrDeclarationParser.self) returned nil for AntlrDeclarationParser.declaration(_:)",
                        file: file,
                        line: line
                    )

                    return
                }
                
                let result = sut.extract(from: decl)

                try closure(.init(object: result))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)\n\(error)",
                    file: file,
                    line: line
                )
            }
        }
        
        /// Opens an assertion context for parsing declarations from a
        /// `ObjectiveCParser.FieldDeclarationContext` that is parsed from the
        /// current input source.
        func assertFieldDeclaration(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[DeclarationExtractor.Declaration]>) throws -> Void
        ) rethrows {

            let sut = DeclarationExtractor()
            let declParser = AntlrDeclarationParser(source: source)

            do {
                let parserRule = try parse(
                    sourceString,
                    file: file,
                    line: line,
                    ruleDeriver: ObjectiveCParser.fieldDeclaration
                )

                guard let decl = declParser.fieldDeclaration(parserRule) else {
                    XCTFail(
                        "Failed to parse from source string: \(AntlrDeclarationParser.self) returned nil for AntlrDeclarationParser.declaration(_:)",
                        file: file,
                        line: line
                    )

                    return
                }

                let result = sut.extract(from: decl)

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

// MARK: - Typealiases

fileprivate typealias Declaration = DeclarationExtractor.Declaration
fileprivate typealias DeclarationDeclNode = DeclarationExtractor.DeclarationDeclNode
fileprivate typealias TypeName = DeclarationExtractor.TypeName
fileprivate typealias TypeNameDeclNode = DeclarationExtractor.TypeNameDeclNode
fileprivate typealias DeclarationKind = DeclarationExtractor.DeclarationKind
fileprivate typealias FuncParameter = DeclarationExtractor.FuncParameter
fileprivate typealias AbstractDeclarationKind = DeclarationExtractor.AbstractDeclarationKind
fileprivate typealias TypePrefix = DeclarationExtractor.TypePrefix
fileprivate typealias Pointer = DeclarationExtractor.Pointer
fileprivate typealias PointerEntry = DeclarationExtractor.PointerEntry
fileprivate typealias DeclSpecifier = DeclarationExtractor.DeclSpecifier
fileprivate typealias StorageSpecifier = DeclarationExtractor.StorageSpecifier
fileprivate typealias TypeSpecifier = DeclarationExtractor.TypeSpecifier
fileprivate typealias ScalarType = DeclarationExtractor.ScalarType
fileprivate typealias TypeNameSpecifier = DeclarationExtractor.TypeNameSpecifier
fileprivate typealias GenericTypeList = DeclarationExtractor.GenericTypeList
fileprivate typealias GenericTypeParameter = DeclarationExtractor.GenericTypeParameter
fileprivate typealias GenericTypeKind = DeclarationExtractor.GenericTypeKind
fileprivate typealias StructOrUnionSpecifier = DeclarationExtractor.StructOrUnionSpecifier
fileprivate typealias StructFieldDeclaration = DeclarationExtractor.StructFieldDeclaration
fileprivate typealias EnumSpecifier = DeclarationExtractor.EnumSpecifier
fileprivate typealias EnumeratorDeclaration = DeclarationExtractor.EnumeratorDeclaration

// MARK: Asserter typealiases

fileprivate typealias DeclarationAsserter = Asserter<Declaration>
fileprivate typealias DeclarationDeclNodeAsserter = Asserter<DeclarationDeclNode>
fileprivate typealias TypeNameAsserter = Asserter<TypeName>
fileprivate typealias TypeNameDeclNodeAsserter = Asserter<TypeNameDeclNode>
fileprivate typealias DeclarationKindAsserter = Asserter<DeclarationKind>
fileprivate typealias FuncParameterAsserter = Asserter<FuncParameter>
fileprivate typealias AbstractDeclarationKindAsserter = Asserter<AbstractDeclarationKind>
fileprivate typealias TypePrefixAsserter = Asserter<TypePrefix>
fileprivate typealias PointerAsserter = Asserter<Pointer>
fileprivate typealias PointerEntryAsserter = Asserter<PointerEntry>
fileprivate typealias DeclSpecifierAsserter = Asserter<DeclSpecifier>
fileprivate typealias StorageSpecifierAsserter = Asserter<StorageSpecifier>
fileprivate typealias TypeSpecifierAsserter = Asserter<TypeSpecifier>
fileprivate typealias ScalarTypeAsserter = Asserter<ScalarType>
fileprivate typealias TypeNameSpecifierAsserter = Asserter<TypeNameSpecifier>
fileprivate typealias GenericTypeListAsserter = Asserter<GenericTypeList>
fileprivate typealias GenericTypeParameterAsserter = Asserter<GenericTypeParameter>
fileprivate typealias GenericTypeKindAsserter = Asserter<GenericTypeKind>
fileprivate typealias StructOrUnionSpecifierAsserter = Asserter<StructOrUnionSpecifier>
fileprivate typealias StructFieldDeclarationAsserter = Asserter<StructFieldDeclaration>
fileprivate typealias EnumSpecifierAsserter = Asserter<EnumSpecifier>
fileprivate typealias EnumeratorDeclarationAsserter = Asserter<EnumeratorDeclaration>

fileprivate typealias DeclarationsAsserter = Asserter<[Declaration]>
fileprivate typealias DeclarationDeclNodesAsserter = Asserter<[DeclarationDeclNode]>
fileprivate typealias TypeNamesAsserter = Asserter<[TypeName]>
fileprivate typealias TypeNameDeclNodesAsserter = Asserter<[TypeNameDeclNode]>
fileprivate typealias DeclarationKindsAsserter = Asserter<[DeclarationKind]>
fileprivate typealias FuncParametersAsserter = Asserter<[FuncParameter]>
fileprivate typealias AbstractDeclarationKindsAsserter = Asserter<[AbstractDeclarationKind]>
fileprivate typealias TypePrefixesAsserter = Asserter<[TypePrefix]>
fileprivate typealias PointersAsserter = Asserter<[Pointer]>
fileprivate typealias PointerEntriesAsserter = Asserter<[PointerEntry]>
fileprivate typealias DeclSpecifiersAsserter = Asserter<[DeclSpecifier]>
fileprivate typealias StorageSpecifiersAsserter = Asserter<[StorageSpecifier]>
fileprivate typealias TypeSpecifiersAsserter = Asserter<[TypeSpecifier]>
fileprivate typealias ScalarTypesAsserter = Asserter<[ScalarType]>
fileprivate typealias TypeNameSpecifiersAsserter = Asserter<[TypeNameSpecifier]>
fileprivate typealias GenericTypeListsAsserter = Asserter<[GenericTypeList]>
fileprivate typealias GenericTypeParametersAsserter = Asserter<[GenericTypeParameter]>
fileprivate typealias GenericTypeKindsAsserter = Asserter<[GenericTypeKind]>
fileprivate typealias StructOrUnionSpecifiersAsserter = Asserter<[StructOrUnionSpecifier]>
fileprivate typealias StructFieldDeclarationsAsserter = Asserter<[StructFieldDeclaration]>
fileprivate typealias EnumSpecifiersAsserter = Asserter<[EnumSpecifier]>
fileprivate typealias EnumeratorDeclarationsAsserter = Asserter<[EnumeratorDeclaration]>
