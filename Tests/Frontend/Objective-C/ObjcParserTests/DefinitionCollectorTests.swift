import XCTest
import Antlr4
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import TestCommons
import Utils

@testable import ObjcParser

class DefinitionCollectorTests: XCTestCase {

    func testCollect_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: "signed short int")?
                    .assert(isStatic: false)?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_variable_static() {
        let tester = prepareTest(declaration: "static short int a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: "signed short int")?
                    .assert(isStatic: true)
            }
        }
    }

    func testCollect_singleDecl_variable_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: "signed short int")?
                    .assert(expressionString: "0")
            }
        }
    }

    func testCollect_singleDecl_variable_const() {
        let tester = prepareTest(declaration: "const char a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .qualified("char", qualifiers: [.const]))
            }
        }
    }

    func testCollect_singleDecl_variable_pointer() {
        let tester = prepareTest(declaration: "short int *a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .pointer("signed short int"))?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_variable_pointer_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "short int *_Nonnull a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .pointer("signed short int", nullabilitySpecifier: .nonnull))?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_variable_pointer_constQualifier() {
        let tester = prepareTest(declaration: "short int *const a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .pointer("signed short int", qualifiers: [.const]))?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_variable_typeName_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "_Nonnull callback a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .nullabilitySpecified(specifier: .nonnull, "callback"))?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_blockVariable() {
        let tester = prepareTest(declaration: "void (^a)(int, char *p2);")

        tester.assert { asserter in
            asserter.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(
                        type: .blockType(
                            name: "a",
                            returnType: .void,
                            parameters: [
                                "signed int",
                                .pointer("char")
                            ]
                        )
                    )
            }
        }
    }

    func testCollect_singleDecl_blockVariable_nullabilitySpecifier() {
        let tester = prepareTest(declaration: "void (^_Nonnull a)();")

        tester.assert { asserter in
            asserter.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(
                        type: .blockType(
                            name: "a",
                            returnType: .void,
                            nullabilitySpecifier: .nonnull
                        )
                    )
            }
        }
    }

    func testCollect_multiDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a, *b = NULL, c[5];")

        tester.assert { nodeList in
            nodeList.asserterForIterator()
                .asserterForNext { decl in
                    decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assertNoInitializer()
                }?
                .asserterForNext { decl in
                    decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(type: .pointer("signed short int"))?
                        .assert(name: "b")?
                        .assert(expressionString: "NULL")
                }?
                .asserterForNext { decl in
                    decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(type: .fixedArray("signed short int", length: 5))?
                        .assert(name: "c")?
                        .assertNoInitializer()
                }?
                .assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_function() {
        let tester = prepareTest(declaration: "void global(int p1, int*);")

        tester.assert { nodeList in
            nodeList.asserterForIterator().asserterForNext { decl in
                decl.assert(isOfType: ObjcFunctionDefinitionNode.self)?
                    .assert(returnType: "void")?
                    .assert(name: "global")?
                    .assertParameterCount(2)?
                    .asserter(forParameterAt: 0) { p1 in
                        p1.assert(name: "p1")?
                            .assert(type: "signed int")
                    }?
                    .asserter(forParameterAt: 1) { p2 in
                        p2.assertNoName()?
                            .assert(type: .pointer("signed int"))
                    }?
                    .assert(isVariadic: false)
            }?.assertIsAtEnd()
        }
    }
    
    func testCollect_singleDecl_function_returnsComplexType() {
        let tester = prepareTest(declaration: "NSArray<NSArray<NSString*>*> *_Nonnull global();")

        tester.assert { asserter in
            asserter.asserterForIterator().asserterForNext { decl in
                decl.assert(isOfType: ObjcFunctionDefinitionNode.self)?
                    .assert(
                        returnType: .pointer(
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
            }?.assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_function_variadicParameter() {
        let tester = prepareTest(declaration: "short int a(int p1, ...);")

        tester.assert { asserter in
            asserter.asserterForIterator().asserterForNext { decl in
                decl.assert(isOfType: ObjcFunctionDefinitionNode.self)?
                    .assertParameterCount(1)?
                    .assert(isVariadic: true)
            }?.assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_typedef() {
        let tester = prepareTest(declaration: "typedef short int A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(type: "signed short int")?
                    .assert(name: "A")
            }
        }
    }

    func testCollect_singleDecl_typedef_block() {
        let tester = prepareTest(declaration: "typedef void(^callback)();")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(type: .blockType(name: "callback", returnType: .void))?
                    .assert(name: "callback")
            }
        }
    }

    func testCollect_singleDecl_typedef_functionPointer_takingAnonymousBlockParameter() {
        let tester = prepareTest(declaration: "typedef int (*callback)(void (^)(), void *);")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(type: .functionPointer(
                        name: "callback",
                        returnType: "signed int",
                        parameters: [
                            .blockType(name: nil, returnType: .void),
                            .pointer(.void)
                        ]
                    ))?
                    .assert(name: "callback")
            }
        }
    }

    // TODO: Implement struct aliasing
    func _testCollect_declaration_singleDecl_typedef_namedStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct a { int b; } *c;")

        tester.assert { nodeList in
            nodeList.assertCount(2)?.asserter(forItemAt: 0) { aNode in
                aNode.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "A")?
                    .assert(type: .pointer(.void))
            }
        }
    }

    func testCollect_declaration_singleDecl_typedef_anonymousStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct { int field; } *A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { aNode in
                aNode.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "A")?
                    .assert(type: .pointer(.anonymousStruct))
            }
        }
    }

    func testCollect_declaration_singleDecl_typedef_opaqueStruct_pointerOnly() {
        let tester = prepareTest(declaration: "typedef struct _A *A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { aNode in
                aNode.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "A")?
                    .assert(type: .pointer(.incompleteStruct("_A")))
            }
        }
    }

    func testCollect_declaration_singleDecl_typedef_opaqueStruct_pointerToPointer() {
        let tester = prepareTest(declaration: "typedef struct _A **A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { aNode in
                aNode.assert(isOfType: ObjcTypedefNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "A")?
                    .assert(type: .pointer(.pointer(.incompleteStruct("_A"))))
            }
        }
    }

    func testCollect_declaration_multiDecl_typedef_opaqueStruct_pointerAndName() {
        let tester = prepareTest(declaration: "typedef struct _A A, *APtr;")

        tester.assert { nodeList in
            nodeList.assertCount(2)?
                .asserter(forItemAt: 0) { aNode in
                    aNode.assert(isOfType: ObjcTypedefNode.self)?
                        .assertChildCount(2)?
                        .assert(name: "A")?
                        .assert(type: .incompleteStruct("_A"))
                }?
                .asserter(forItemAt: 1) { aNode in
                    aNode.assert(isOfType: ObjcTypedefNode.self)?
                        .assertChildCount(2)?
                        .assert(name: "APtr")?
                        .assert(type: .pointer("A"))
                }
        }
    }

    func testCollect_singleDecl_struct() {
        let tester = prepareTest(declaration: "struct AStruct { int field0; };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { aStruct in
                aStruct
                    .assert(isOfType: ObjcStructDeclarationNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "AStruct")?
                    .assertFieldCount(1)?
                    .asserter(forFieldName: "field0") { field0 in
                        field0
                            .assert(name: "field0")?
                            .assert(type: "signed int")
                    }
            }
        }
    }
    func testCollect_singleDecl_struct_incomplete() {
        let tester = prepareTest(declaration: "struct a b;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "b")?
                    .assert(type: .incompleteStruct("a"))?
                    .assert(isStatic: false)?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field0; } AStruct;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { aStruct in
                aStruct
                    .assert(isOfType: ObjcStructDeclarationNode.self)?
                    .assertChildCount(2)?
                    .assert(name: "AStruct")?
                    .assertFieldCount(1)?
                    .asserter(forFieldName: "field0") { field0 in
                        field0
                            .assert(name: "field0")?
                            .assert(type: "signed int")
                    }
            }
        }
    }

    func testCollect_singleDecl_struct_typedef_pointerReference() {
        let tester = prepareTest(declaration: "typedef struct { int field0; } AStruct, *AStructPtr;")

        tester.assert { nodeList in
            nodeList.assertCount(2)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct
                        .assert(isOfType: ObjcStructDeclarationNode.self)?
                        .assert(name: "AStruct")?
                        .assertFieldCount(1)?
                        .asserter(forFieldName: "field0") { field0 in
                            field0
                                .assert(name: "field0")?
                                .assert(type: "signed int")
                        }
                }?
                .asserter(forItemAt: 1) { aStruct in
                    aStruct
                        .assert(isOfType: ObjcTypedefNode.self)?
                        .assertChildCount(2)?
                        .assert(name: "AStructPtr")?
                        .assert(type: .pointer("AStruct"))
                }
        }
    }

    func testCollect_singleDecl_struct_typedef_typeDeclaratorStressCases() {
        let tester = prepareTest(declaration: "typedef struct { int field; } A, *APtr, AArray[5], *AArrayPtr[5], (*AFuncRet)();")

        tester.assert { asserter in
            asserter.assertCount(5)?.asserterForIterator()
                .asserterForNext { a in
                    a.assert(isOfType: ObjcStructDeclarationNode.self)?
                        .assert(name: "A")
                }?
                .asserterForNext { ptr in
                    ptr.assert(isOfType: ObjcTypedefNode.self)?
                        .assert(name: "APtr")?
                        .assert(type: .pointer("A"))
                }?
                .asserterForNext { array in
                    array.assert(isOfType: ObjcTypedefNode.self)?
                        .assert(name: "AArray")?
                        .assert(type: .fixedArray("A", length: 5))
                }?
                .asserterForNext { arrayPtr in
                    arrayPtr.assert(isOfType: ObjcTypedefNode.self)?
                        .assert(name: "AArrayPtr")?
                        .assert(type: .fixedArray(.pointer("A"), length: 5))
                }?
                .asserterForNext { funcRet in
                    funcRet.assert(isOfType: ObjcTypedefNode.self)?
                        .assert(name: "AFuncRet")?
                        .assert(type: .functionPointer(name: "AFuncRet", returnType: "A"))
                }?.assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_enum() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 0, CASE1 = 1, CASE2 };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcEnumDeclarationNode.self)?
                    .assert(name: "AnEnum")?
                    .assertNoTypeName()?
                    .assertEnumeratorCount(3)?
                    .asserter(forEnumeratorName: "CASE0") { case0 in
                        case0
                            .assert(name: "CASE0")?
                            .assert(expressionString: "0")
                    }?
                    .asserter(forEnumeratorName: "CASE1") { case0 in
                        case0
                            .assert(name: "CASE1")?
                            .assert(expressionString: "1")
                    }?
                    .asserter(forEnumeratorName: "CASE2") { case0 in
                        case0
                            .assert(name: "CASE2")?
                            .assertNoExpression()
                    }
            }
        }
    }

    func testCollect_singleDecl_enum_nsEnum() {
        let tester = prepareTest(declaration: "typedef NS_ENUM(NSInteger, AnEnum) { CASE0 = 0, CASE1 = 1, CASE2 };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcEnumDeclarationNode.self)?
                    .assert(name: "AnEnum")?
                    .assert(typeName: "NSInteger")?
                    .assertEnumeratorCount(3)?
                    .asserter(forEnumeratorName: "CASE0") { case0 in
                        case0
                            .assert(name: "CASE0")?
                            .assert(expressionString: "0")
                    }?
                    .asserter(forEnumeratorName: "CASE1") { case0 in
                        case0
                            .assert(name: "CASE1")?
                            .assert(expressionString: "1")
                    }?
                    .asserter(forEnumeratorName: "CASE2") { case0 in
                        case0
                            .assert(name: "CASE2")?
                            .assertNoExpression()
                    }
            }
        }
    }

    func testCollect_singleDecl_enum_nsOptions() {
        let tester = prepareTest(declaration: "typedef NS_OPTIONS(NSInteger, AnEnum) { CASE0 = 0, CASE1 = 1, CASE2 };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcEnumDeclarationNode.self)?
                    .assert(name: "AnEnum")?
                    .assert(typeName: "NSInteger")?
                    .assertEnumeratorCount(3)?
                    .asserter(forEnumeratorName: "CASE0") { case0 in
                        case0
                            .assert(name: "CASE0")?
                            .assert(expressionString: "0")
                    }?
                    .asserter(forEnumeratorName: "CASE1") { case0 in
                        case0
                            .assert(name: "CASE1")?
                            .assert(expressionString: "1")
                    }?
                    .asserter(forEnumeratorName: "CASE2") { case0 in
                        case0
                            .assert(name: "CASE2")?
                            .assertNoExpression()
                    }
            }
        }
    }

    func testCollect_fieldDeclaration_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assertFieldDeclaration { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(type: "signed short int")?
                    .assert(name: "a")?
                    .assertNoInitializer()
            }
        }
    }

    func testCollect_fieldDeclaration_singleDecl_blockVariable() {
        let tester = prepareTest(declaration: "void (^a)(int, char *p2);")

        tester.assertFieldDeclaration { asserter in
            asserter.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(
                        type: .blockType(
                            name: "a",
                            returnType: .void,
                            parameters: [
                                "signed int",
                                .pointer("char")
                            ]
                        )
                    )
            }
        }
    }

    func testCollect_fieldDeclaration_singleDecl_variable_boolDecl() {
        let tester = prepareTest(declaration: "BOOL value;")

        tester.assertFieldDeclaration { nodeList in
            nodeList.assertCount(1)?.asserter(forItemAt: 0) { decl in
                decl.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(type: "BOOL")?
                    .assert(name: "value")?
                    .assertNoInitializer()
            }
        }
    }

    // MARK: - Delegate tests

    func testDelegate_noDeclarations() {
        let delegate = delegateTest(declaration: "typedef struct { int a; };")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_variable() {
        let delegate = delegateTest(declaration: "int a;")

        delegate.didDetectVariable_calls_asserter.assertCount(1)
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_function() {
        let delegate = delegateTest(declaration: "int a();")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertCount(1)
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_typedef() {
        let delegate = delegateTest(declaration: "typedef int A;")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertCount(1)
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_typedef_multiDecl() {
        let delegate = delegateTest(declaration: "typedef struct { int a; } A, *APtr, AArray[2], (*AFunc)();")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertCount(3)
        delegate.didDetectStruct_calls_asserter.assertCount(1)
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_struct() {
        let delegate = delegateTest(declaration: "struct A { int field; };")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertCount(1)
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_struct_typedef() {
        let delegate = delegateTest(declaration: "typedef struct { int field; } A;")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertCount(1)
        delegate.didDetectEnum_calls_asserter.assertIsEmpty()
    }

    func testDelegate_enum() {
        let delegate = delegateTest(declaration: "enum A { CASE0 = 0 };")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertCount(1)
    }

    func testDelegate_enum_typedef() {
        let delegate = delegateTest(declaration: "typedef enum { CASE0 = 0 } A;")

        delegate.didDetectVariable_calls_asserter.assertIsEmpty()
        delegate.didDetectFunction_calls_asserter.assertIsEmpty()
        delegate.didDetectTypedef_calls_asserter.assertIsEmpty()
        delegate.didDetectStruct_calls_asserter.assertIsEmpty()
        delegate.didDetectEnum_calls_asserter.assertCount(1)
    }
}

private extension DefinitionCollectorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(source: declaration)
    }

    func delegateTest(
        declaration: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> MockDelegate {

        let delegate = MockDelegate()
        let tester = prepareTest(declaration: declaration)

        tester.delegate = delegate

        tester.assert(file: file, line: line, { _ in })

        return delegate
    }

    class Tester: SingleRuleParserTestFixture<ObjectiveCParser.DeclarationContext> {
        var source: String
        var nodeFactory: ObjcASTNodeFactory
        var delegate: DefinitionCollectorDelegate?

        init(source: String, delegate: DefinitionCollectorDelegate? = nil) {
            self.source = source
            self.delegate = delegate

            nodeFactory = ObjcASTNodeFactory(
                source: StringCodeSource(source: source),
                nonnullContextQuerier: NonnullContextQuerier(
                    nonnullMacroRegionsTokenRange: [],
                    nonnullMacroRegionsRanges: []
                ),
                commentQuerier: CommentQuerier(allComments: [])
            )

            super.init(ruleDeriver: ObjectiveCParser.declaration)
        }

        func assert(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[ASTNode]>) throws -> Void
        ) rethrows {

            let sut = DefinitionCollector(
                nonnullContextQuerier: nodeFactory.nonnullContextQuerier,
                nodeFactory: nodeFactory
            )
            sut.delegate = delegate

            do {
                let parserRule = try parse(source, file: file, line: line)

                let result = sut.collect(from: parserRule)

                try closure(.init(object: result))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)\n\(error)",
                    file: file,
                    line: line
                )
            }
        }
        
        /// Opens an assertion context for collecting declaration nodes from a
        /// `ObjectiveCParser.FieldDeclarationContext` that is parsed from the
        /// current input source.
        func assertFieldDeclaration(
            file: StaticString = #file,
            line: UInt = #line,
            _ closure: (Asserter<[ASTNode]>) throws -> Void
        ) rethrows {

            let sut = DefinitionCollector(
                nonnullContextQuerier: nodeFactory.nonnullContextQuerier,
                nodeFactory: nodeFactory
            )
            sut.delegate = delegate

            do {
                let parserRule = try parse(
                    source,
                    file: file,
                    line: line,
                    ruleDeriver: ObjectiveCParser.fieldDeclaration
                )

                let result = sut.collect(from: parserRule)

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

private class MockDelegate: DefinitionCollectorDelegate {
    var didDetectVariable_calls: [(ObjcVariableDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectFunction_calls: [(ObjcFunctionDefinitionNode, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectTypedef_calls: [(ObjcTypedefNode, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectStruct_calls: [(ObjcStructDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectEnum_calls: [(ObjcEnumDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)] = []

    var didDetectVariable_calls_asserter: Asserter<[(ObjcVariableDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectVariable_calls)
    }
    var didDetectFunction_calls_asserter: Asserter<[(ObjcFunctionDefinitionNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectFunction_calls)
    }
    var didDetectTypedef_calls_asserter: Asserter<[(ObjcTypedefNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectTypedef_calls)
    }
    var didDetectStruct_calls_asserter: Asserter<[(ObjcStructDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectStruct_calls)
    }
    var didDetectEnum_calls_asserter: Asserter<[(ObjcEnumDeclarationNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectEnum_calls)
    }

    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: ObjcVariableDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectVariable_calls.append((variable, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: ObjcFunctionDefinitionNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectFunction_calls.append((function, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: ObjcTypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectTypedef_calls.append((typedefNode, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectStruct_calls.append((structDecl, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclarationNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectEnum_calls.append((enumDecl, declaration))
    }
}
