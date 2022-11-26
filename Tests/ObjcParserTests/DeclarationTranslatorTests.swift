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
                .assertType("signed short int")
        }
    }
    func testTranslate_singleDecl_variable_longLongInt() {
        let tester = prepareTest(declaration: "unsigned long long int a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType("unsigned long long int")
        }
    }

    func testTranslate_singleDecl_variable_pointer() {
        let tester = prepareTest(declaration: "short int *a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_pointerToPointer() {
        let tester = prepareTest(declaration: "short int **a;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.pointer(.pointer("signed short int")))
        }
    }

    func testTranslate_singleDecl_variable_array_unsized() {
        let tester = prepareTest(declaration: "short int a[];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_unsized() {
        let tester = prepareTest(declaration: "short int *a[];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.pointer(.pointer("signed short int")))
        }
    }

    func testTranslate_singleDecl_variable_array_sized() {
        let tester = prepareTest(declaration: "short int a[10];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDecl_variable_arrayOfPointer_sized() {
        let tester = prepareTest(declaration: "short int *a[10];")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType(.fixedArray(.pointer("signed short int"), length: 10))
        }
    }

    func testTranslate_multiDecl_variable() {
        let tester = prepareTest(declaration: "short int a, b, *c;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertNoInitializer()?
                .assertType("signed short int")
            asserter
                .assertVariable(name: "b")?
                .assertNoInitializer()?
                .assertType("signed short int")
            asserter
                .assertVariable(name: "c")?
                .assertNoInitializer()?
                .assertType(.pointer("signed short int"))
        }
    }

    func testTranslate_singleDecl_variable_withInitializer() {
        let tester = prepareTest(declaration: "short int a = 0;")

        tester.assert { asserter in
            asserter
                .assertVariable(name: "a")?
                .assertHasInitializer()?
                .assertType("signed short int")
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
                .assertType("unsigned long long int")
        }
    }

    func testTranslate_singleDecl_typedef_pointer() {
        let tester = prepareTest(declaration: "typedef void *A;")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "A")?
                .assertType(.pointer(.void))
        }
    }

    func testTranslate_singleDecl_typedef_block() {
        let tester = prepareTest(declaration: "typedef void(^_Nonnull Callback)();")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "Callback")?
                .assertType(.blockType(name: "Callback", returnType: .void))
        }
    }

    func testTranslate_singleDecl_typedef_array_sized() {
        let tester = prepareTest(declaration: "typedef short int A[10];")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "A")?
                .assertType(.fixedArray("signed short int", length: 10))
        }
    }

    func testTranslate_singleDec_typedef_functionPointer() {
        let tester = prepareTest(declaration: "typedef int (*f)(void *, void *);")

        tester.assert { asserter in
            asserter
                .assertTypedef(name: "f")?
                .assertType(
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
}

// MARK: - Test Internals

private struct TranslatedVariableDeclWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var nullability: DeclarationTranslator.Nullability?
    var identifier: Identifier
    var type: TypeNameNode
    var initialValue: ObjectiveCParser.InitializerContext?

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .variable(let nullability, let identifier, let type, let initialValue):
            self.nullability = nullability
            self.identifier = identifier
            self.type = type
            self.initialValue = initialValue
        default:
            return nil
        }
    }
}

private struct TranslatedTypedefDeclWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var baseType: DeclarationTranslator.ASTNodeDeclaration
    var alias: Identifier

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .typedef(let baseType, let alias):
            self.baseType = baseType
            self.alias = alias
        default:
            return nil
        }
    }
}

private struct TranslatedFunctionDeclWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var identifier: Identifier
    var parameters: [FunctionParameter]
    var returnType: TypeNameNode

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .function(let identifier, let parameters, let returnType):
            self.identifier = identifier
            self.parameters = parameters
            self.returnType = returnType
        default:
            return nil
        }
    }
}

private extension DeclarationTranslatorTests {
    func prepareTest(declaration: String) -> Tester {
        Tester(source: declaration)
    }

    class Tester {
        var parserObject: ObjectiveCParserAntlr?
        let parserState = ObjcParserState()
        var source: String
        var nodeFactory: ASTNodeFactory

        init(source: String) {
            self.source = source
            nodeFactory = ASTNodeFactory(
                source: StringCodeSource(source: source),
                nonnullContextQuerier: NonnullContextQuerier(nonnullMacroRegionsTokenRange: []),
                commentQuerier: CommentQuerier(allComments: [])
            )
        }

        func assert(file: StaticString = #file, line: UInt = #line, _ closure: (Asserter<[DeclarationTranslator.ASTNodeDeclaration]>) throws -> Void) rethrows {
            let extractor = DeclarationExtractor()
            let sut = DeclarationTranslator()
            let context = DeclarationTranslator.Context(nodeFactory: nodeFactory)

            do {
                let parser = try parserState.makeMainParser(input: source)
                parserObject = parser

                let errorListener = ErrorListener()
                parser.parser.addErrorListener(errorListener)

                let decl = try parser.parser.declaration()

                if errorListener.hasErrors {
                    XCTFail(
                        "Error while parsing declaration: \(errorListener.errorDescription)",
                        file: file,
                        line: line
                    )
                    return
                }

                let declarations = extractor.extract(from: decl)

                let result = declarations.compactMap { decl in sut.translate(decl, context: context) }

                try closure(.init(object: result))
            } catch {
                XCTFail(
                    "Failed to parse from source string: \(source)",
                    file: file,
                    line: line
                )
            }
        }
    }
}

fileprivate extension Asserter where Object == [DeclarationTranslator.ASTNodeDeclaration] {
    @discardableResult
    func assertVariable(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedVariableDeclWrapper>? {

        for value in object {
            switch value {
            case .variable(_, let identifier, _, _) where identifier.name == name:
                guard let wrapper = TranslatedVariableDeclWrapper(object: value) else {
                    break
                }

                return .init(object: wrapper)
            default:
                break
            }
        }

        XCTFail(
            "Expected to find variable named '\(name)' but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertBlock(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTNodeDeclaration>? {

        for value in object {
            switch value {
            case .block(_, let identifier, _, _, _) where identifier.name == name:
                return .init(object: value)

            default:
                break
            }
        }

        XCTFail(
            "Expected to find block named '\(name)' but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertFunction(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedFunctionDeclWrapper>? {

        for value in object {
            switch value {
            case .function(let identifier, _, _) where identifier.name == name:
                if let wrapper = TranslatedFunctionDeclWrapper(object: value) {
                    return .init(object: wrapper)
                }

            default:
                break
            }
        }

        XCTFail(
            "Expected to find function named '\(name)' but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertTypedef(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedTypedefDeclWrapper>? {

        for value in object {
            switch value {
            case .typedef(_, let ident) where ident.name == name:
                if let wrapper = TranslatedTypedefDeclWrapper(object: value) {
                    return .init(object: wrapper)
                }

            default:
                break
            }
        }

        XCTFail(
            "Expected to find typedef named '\(name)' but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }
}

extension Asserter where Object == DeclarationTranslator.ASTNodeDeclaration {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .variable(_, _, _, _?),
            .block(_, _, _, _, _?):
            return self

        default:
            break
        }

        XCTFail(
            "Expected declaration \(object.identifierNode?.name ?? "<anonymous>") to have initializer but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertNoInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .variable(_, _, _, nil),
            .block(_, _, _, _, nil):
            return self

        default:
            break
        }

        XCTFail(
            "Expected declaration \(object.identifierNode?.name ?? "<anonymous>") to have no initializer but found one.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }
}

extension Asserter where Object == TranslatedVariableDeclWrapper {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.initialValue != nil else {
            XCTFail(
                "Expected declaration \(object.identifier.name) to have initializer but found none.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertNoInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.initialValue == nil else {
            XCTFail(
                "Expected declaration \(object.identifier.name) to have no initializer but found one.",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }

        return self
    }

    @discardableResult
    func assertType(
        _ type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.type.type == type else {
            XCTFail(
                "Expected declaration \(object.identifier.name) to have type \(type) but found \(object.type.type).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object == TranslatedTypedefDeclWrapper {
    @discardableResult
    func assertType(
        _ type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        let typedefType = object.baseType.objcType
        
        guard typedefType == type else {
            XCTFail(
                "Expected typedef \(object.alias.name) to have type \(type) but found \(typedefType?.description ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object == TranslatedFunctionDeclWrapper {
    @discardableResult
    func assertReturnType(
        _ type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        let returnType = object.returnType.type
        guard returnType == type else {
            XCTFail(
                "Expected function \(object.identifier.name) to have return type \(type) but found \(returnType).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertParameterCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.parameters.count == count else {
            XCTFail(
                "Expected function \(object.identifier.name) to have \(count) parameter(s) but found \(object.parameters.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertParameterName(
        at index: Int,
        _ name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.parameters.count > index else {
            XCTFail(
                "Function \(object.identifier.name) does not have \(index) parameter(s) available (actual count: \(object.parameters.count)).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let parameter = object.parameters[index]
        guard parameter.identifier?.name == name else {
            XCTFail(
                "Expected parameter \(index) of function \(object.identifier.name) to have name \(name) but found \(parameter.identifier?.name ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertParameterType(
        at index: Int,
        _ type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.parameters.count > index else {
            XCTFail(
                "Function \(object.identifier.name) does not have \(index) parameter(s) available (actual count: \(object.parameters.count)).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let parameter = object.parameters[index]
        guard parameter.type?.type == type else {
            XCTFail(
                "Expected parameter \(index) of function \(object.identifier.name) to have type \(type) but found \(parameter.type?.type.description ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}
