import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

@testable import ObjcParser

class DefinitionCollectorTests: XCTestCase {

    func testCollect_singleDecl_variable_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assert(expressionString: "0")
                }
        }
    }

    func testCollect_singleDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assertNoInitializer()
                }
        }
    }

    func testCollect_multiDecl_variable_noInitializer() {
        let tester = prepareTest(declaration: "short int a, *b = NULL, c[5];")

        tester.assert { nodeList in
            nodeList.asserterForIterator()
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "a")?
                        .assertNoInitializer()
                }?
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: .pointer("signed short int"))?
                        .assert(name: "b")?
                        .assert(expressionString: "NULL")
                }?
                .asserterForNext { intNode in
                    intNode.assert(isOfType: VariableDeclaration.self)?
                        .assert(type: .fixedArray("signed short int", length: 5))?
                        .assert(name: "c")?
                        .assertNoInitializer()
                }?
                .assertIsAtEnd()
        }
    }

    func testCollect_singleDecl_typedef() {
        let tester = prepareTest(declaration: "typedef short int A;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: TypedefNode.self)?
                        .assert(type: "signed short int")?
                        .assert(name: "A")
                }
        }
    }

    func testCollect_singleDecl_struct() {
        let tester = prepareTest(declaration: "struct AStruct { int field0; };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct.assert(isOfType: ObjcStructDeclaration.self)?
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

    func testCollect_singleDecl_struct_typedef() {
        let tester = prepareTest(declaration: "typedef struct { int field0; } AStruct;")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { aStruct in
                    aStruct.assert(isOfType: ObjcStructDeclaration.self)?
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
                    aStruct.assert(isOfType: ObjcStructDeclaration.self)?
                        .assert(name: "AStruct")?
                        .assertFieldCount(1)?
                        .asserter(forFieldName: "field0") { field0 in
                            field0
                                .assert(name: "field0")?
                                .assert(type: "signed int")
                        }
                }?
                .asserter(forItemAt: 1) { aStruct in
                    aStruct.assert(isOfType: TypedefNode.self)?
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
                    a.assert(isOfType: ObjcStructDeclaration.self)?
                        .assert(name: "A")
                }?
                .asserterForNext { ptr in
                    ptr.assert(isOfType: TypedefNode.self)?
                        .assert(name: "APtr")?
                        .assert(type: .pointer("A"))
                }?
                .asserterForNext { array in
                    array.assert(isOfType: TypedefNode.self)?
                        .assert(name: "AArray")?
                        .assert(type: .fixedArray("A", length: 5))
                }?
                .asserterForNext { arrayPtr in
                    arrayPtr.assert(isOfType: TypedefNode.self)?
                        .assert(name: "AArrayPtr")?
                        .assert(type: .fixedArray(.pointer("A"), length: 5))
                }?
                .asserterForNext { funcRet in
                    funcRet.assert(isOfType: TypedefNode.self)?
                        .assert(name: "AFuncRet")?
                        .assert(type: .functionPointer(name: "AFuncRet", returnType: "A"))
                }
        }
    }

    func testCollect_singleDecl_enum() {
        let tester = prepareTest(declaration: "enum AnEnum { CASE0 = 0, CASE1 = 1, CASE2 };")

        tester.assert { nodeList in
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: ObjcEnumDeclaration.self)?
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
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: ObjcEnumDeclaration.self)?
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
            nodeList.assertCount(1)?
                .asserter(forItemAt: 0) { intNode in
                    intNode.assert(isOfType: ObjcEnumDeclaration.self)?
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

    class Tester: BaseParserTestFixture<ObjectiveCParser.DeclarationContext> {
        var source: String
        var nodeFactory: ASTNodeFactory
        var delegate: DefinitionCollectorDelegate?

        init(source: String, delegate: DefinitionCollectorDelegate? = nil) {
            self.source = source
            self.delegate = delegate

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
            _ closure: (Asserter<[ASTNode]>) throws -> Void
        ) rethrows {

            let sut = DefinitionCollector(
                nonnullContextQuerier: nodeFactory.nonnullContextQuerier,
                commentQuerier: nodeFactory.commentQuerier,
                nodeFactory: nodeFactory
            )
            sut.delegate = delegate

            do {
                let parserRule = try parse(source)

                guard let result = sut.collect(from: parserRule) else {
                    XCTFail(
                        "Failed to collect definitions!",
                        file: file,
                        line: line
                    )
                    return
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
    }
}

private class MockDelegate: DefinitionCollectorDelegate {
    var didDetectVariable_calls: [(VariableDeclaration, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectFunction_calls: [(FunctionDefinition, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectTypedef_calls: [(TypedefNode, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectStruct_calls: [(ObjcStructDeclaration, DeclarationTranslator.ASTNodeDeclaration)] = []
    var didDetectEnum_calls: [(ObjcEnumDeclaration, DeclarationTranslator.ASTNodeDeclaration)] = []

    var didDetectVariable_calls_asserter: Asserter<[(VariableDeclaration, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectVariable_calls)
    }
    var didDetectFunction_calls_asserter: Asserter<[(FunctionDefinition, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectFunction_calls)
    }
    var didDetectTypedef_calls_asserter: Asserter<[(TypedefNode, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectTypedef_calls)
    }
    var didDetectStruct_calls_asserter: Asserter<[(ObjcStructDeclaration, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectStruct_calls)
    }
    var didDetectEnum_calls_asserter: Asserter<[(ObjcEnumDeclaration, DeclarationTranslator.ASTNodeDeclaration)]> {
        .init(object: didDetectEnum_calls)
    }

    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectVariable variable: VariableDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectVariable_calls.append((variable, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectFunction function: FunctionDefinition,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectFunction_calls.append((function, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectTypedef typedefNode: TypedefNode,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectTypedef_calls.append((typedefNode, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectStruct structDecl: ObjcStructDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectStruct_calls.append((structDecl, declaration))
    }
    
    func definitionCollector(
        _ collector: DefinitionCollector,
        didDetectEnum enumDecl: ObjcEnumDeclaration,
        from declaration: DeclarationTranslator.ASTNodeDeclaration
    ) {
        didDetectEnum_calls.append((enumDecl, declaration))
    }
}
