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

    func testTranslate_singleDecl_struct_anonymous_doesNotTranslate() {
        let tester = prepareTest(declaration: "struct { int field; };")

        tester.assert { asserter in
            asserter
                .assertNoDeclarations()
        }
    }
}

// MARK: - Test Internals

private struct TranslatedVariableDeclWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var rule: ParserRuleContext
    var nullability: DeclarationTranslator.Nullability?
    var identifier: Identifier
    var type: TypeNameNode
    var initialValue: ObjectiveCParser.InitializerContext?

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .variable(let rule, let nullability, let identifier, let type, let initialValue):
            self.rule = rule
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
    var rule: ParserRuleContext
    var baseType: DeclarationTranslator.ASTNodeDeclaration
    var typeNode: TypeNameNode
    var alias: Identifier

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .typedef(let rule, let baseType, let typeNode, let alias):
            self.rule = rule
            self.baseType = baseType
            self.typeNode = typeNode
            self.alias = alias
        default:
            return nil
        }
    }
}

private struct TranslatedFunctionDeclWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var rule: ParserRuleContext
    var identifier: Identifier
    var parameters: [FunctionParameter]
    var returnType: TypeNameNode

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .function(let rule, let identifier, let parameters, let returnType):
            self.rule = rule
            self.identifier = identifier
            self.parameters = parameters
            self.returnType = returnType
        default:
            return nil
        }
    }
}

private struct TranslatedStructOrUnionWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var rule: ParserRuleContext
    var identifier: Identifier?
    var specifier: DeclarationExtractor.StructOrUnionSpecifier
    var fields: [ObjcStructField]

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .structOrUnionDecl(let rule, let identifier, let specifier, let fields):
            self.rule = rule
            self.identifier = identifier
            self.specifier = specifier
            self.fields = fields
            
        default:
            return nil
        }
    }
}

private struct TranslatedEnumWrapper {
    var object: DeclarationTranslator.ASTNodeDeclaration
    var rule: ParserRuleContext
    var identifier: Identifier?
    var typeName: TypeNameNode?
    var specifier: DeclarationExtractor.EnumSpecifier
    var enumerators: [ObjcEnumCase]

    init?(object: DeclarationTranslator.ASTNodeDeclaration) {
        self.object = object

        switch object {
        case .enumDecl(let rule, let identifier, let typeName, let specifier, let enumerators):
            self.rule = rule
            self.identifier = identifier
            self.typeName = typeName
            self.specifier = specifier
            self.enumerators = enumerators
            
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

                let result = declarations.flatMap { decl in sut.translate(decl, context: context) }

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
    /// Asserts that there are no translated declarations available.
    @discardableResult
    func assertNoDeclarations(file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.isEmpty else {
            XCTFail(
                "Expected no translated declarations, but found \(object.count) declaration(s)",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertVariable(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedVariableDeclWrapper>? {

        for value in object {
            switch value {
            case .variable(_, _, let identifier, _, _) where identifier.name == name:
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
            case .block(_, _, let identifier, _, _, _) where identifier.name == name:
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
            case .function(_, let identifier, _, _) where identifier.name == name:
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
            case .typedef(_, _, _, let ident) where ident.name == name:
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
    
    @discardableResult
    func assertStructOrUnion(
        name: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedStructOrUnionWrapper>? {

        for value in object {
            switch value {
            case .structOrUnionDecl(_, let identifier, _, _) where name == nil || identifier?.name == name:
                if let wrapper = TranslatedStructOrUnionWrapper(object: value) {
                    return .init(object: wrapper)
                }

            default:
                break
            }
        }

        XCTFail(
            "Expected to find struct or union named '\(name ?? "<nil>")' but found none.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertEnum(
        name: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<TranslatedEnumWrapper>? {

        for value in object {
            switch value {
            case .enumDecl(_, let identifier, _, _, _) where name == nil || identifier?.name == name:
                if let wrapper = TranslatedEnumWrapper(object: value) {
                    return .init(object: wrapper)
                }

            default:
                break
            }
        }

        XCTFail(
            "Expected to find enum named '\(name ?? "<nil>")' but found none.",
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
        case .variable(_, _, _, _, _?),
            .block(_, _, _, _, _, _?):
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
        case .variable(_, _, _, _, nil),
            .block(_, _, _, _, _, nil):
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

extension Asserter where Object == TranslatedStructOrUnionWrapper {
    @discardableResult
    func assertFieldCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.fields.count == count else {
            XCTAssertEqual(
                object.fields.count,
                count,
                "Unexpected count of fields in struct declaration \(object.identifier?.name ?? "<anonymous>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertField(
        name: String,
        type: ObjcType? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard let field = object.fields.first(where: { $0.identifier?.name == name }) else {
            XCTFail(
                "Expected to find a field named \(name) in struct declaration \(object.identifier?.name ?? "<anonymous>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let fieldType = field.type?.type
        if let type, type != fieldType {
            XCTFail(
                "Expected struct field \(name) in struct declaration \(object.identifier?.name ?? "<anonymous>") to have type \(type), but found \(fieldType ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()
        }

        return self
    }
}

extension Asserter where Object == TranslatedEnumWrapper {
    @discardableResult
    func assertEnumeratorCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.enumerators.count == count else {
            XCTAssertEqual(
                object.enumerators.count,
                count,
                "Unexpected count of enumerators in enum declaration \(object.identifier?.name ?? "<anonymous>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertEnumerator(
        name: String,
        expressionString: String? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard let enumerator = object.enumerators.first(where: { $0.identifier?.name == name }) else {
            XCTFail(
                "Expected to find an enumerator named \(name) in enum declaration \(object.identifier?.name ?? "<anonymous>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
        
        let enumExp = enumerator.expression?.expression?.getText()
        if let expressionString, enumExp != expressionString {
            XCTFail(
                "Expected enumerator \(name) in enum declaration \(object.identifier?.name ?? "<anonymous>") to have an expression \(expressionString), but found \(enumExp ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()
        }

        return self
    }
}
