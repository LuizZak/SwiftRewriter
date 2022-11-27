import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

@testable import ObjcParser

/// For generic assertions over both 'DeclarationExtractor.Declaration' and 'FunctionDeclWrapper'.
protocol DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration { get }
}
struct FunctionDeclWrapper: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration
    var base: DeclarationExtractor.DeclarationKind?
    var parameters: [DeclarationExtractor.FuncParameter]

    init?(object: DeclarationExtractor.Declaration) {
        self.decl = object

        switch object.declaration {
        case .function(let base, let parameters):
            self.base = base
            self.parameters = parameters

        default:
            return nil
        }
    }
}
struct BlockDeclWrapper: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration
    var nullability: DeclarationExtractor.NullabilitySpecifier?
    var base: DeclarationExtractor.DeclarationKind?
    var parameters: [DeclarationExtractor.BlockParameter]

    init?(object: DeclarationExtractor.Declaration) {
        self.decl = object

        switch object.declaration {
        case .block(let nullability, let base, let parameters):
            self.nullability = nullability
            self.base = base
            self.parameters = parameters

        default:
            return nil
        }
    }
}

extension DeclarationExtractor.Declaration: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration { self }
}

extension Asserter where Object == [DeclarationExtractor.Declaration] {
    @discardableResult
    func _assertOneOrMore(
        message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt,
        _ closure: (Object.Element) -> Bool
    ) -> Object.Element? {
        for obj in object {
            if closure(obj) {
                return obj
            }
        }

        XCTFail(message(), file: file, line: line)
        dumpObject()

        return nil
    }

    @discardableResult
    func assertNoDeclarations(file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.isEmpty else {
            XCTFail(
                "Expected no declarations, but found \(object.count) declaration(s)",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertDefinedCount(_ count: Int, file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.count == count else {
            XCTAssertEqual(object.count, count, file: file, line: line)
            dumpObject()
            return nil
        }

        return self
    }

    @discardableResult
    func assertVariable(name: String, file: StaticString = #file, line: UInt = #line) -> Asserter<DeclarationExtractor.Declaration>? {
        return asserter(forVariable: name, file: file, line: line) { _ in }
    }

    @discardableResult
    func assertVariable(
        name: String,
        specifiers: [DeclarationExtractor.DeclSpecifier],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        return asserter(forVariable: name, file: file, line: line) { assert in
            assert.assert(specifiers: specifiers, file: file, line: line)
        }
    }

    @discardableResult
    func assertVariable(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        return asserter(forVariable: name, file: file, line: line) { assert in
            assert.assert(specifierStrings: specifierStrings, file: file, line: line)
        }
    }

    @discardableResult
    func assertFunction(name: String, file: StaticString = #file, line: UInt = #line) -> Asserter<FunctionDeclWrapper>? {
        return asserter(forFunction: name, file: file, line: line)
    }

    @discardableResult
    func assertFunction(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<FunctionDeclWrapper>? {

        return asserter(forFunction: name, file: file, line: line) { assert in
            assert.assert(specifierStrings: specifierStrings, file: file, line: line)
        }
    }

    @discardableResult
    func assertBlock(name: String, file: StaticString = #file, line: UInt = #line) -> Asserter<BlockDeclWrapper>? {
        return asserter(forBlock: name, file: file, line: line)
    }

    @discardableResult
    func assertBlock(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<BlockDeclWrapper>? {

        return asserter(forBlock: name, file: file, line: line) { assert in
            assert.assert(specifierStrings: specifierStrings, file: file, line: line)
        }
    }

    @discardableResult
    func asserter(
        forVariable name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one variable '\(name)'",
            file: file,
            line: line
        ) { decl in

            switch decl.declaration {
            case .identifier(name, _):
                return true
            case .staticArray(let base, _, _) where base.identifierString == name:
                return true
            case .block(_, let base, _) where base?.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl {
            let asserter = Asserter<DeclarationExtractor.Declaration>(object: decl)

            closure(asserter)

            return asserter
        }

        return nil
    }

    @discardableResult
    func asserter(
        forFunction name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<FunctionDeclWrapper>) -> Void = { _ in }
    ) -> Asserter<FunctionDeclWrapper>? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one function '\(name)'",
            file: file,
            line: line
        ) { decl in

            switch decl.declaration {
            case .function(let base, _) where base?.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl, let wrapper = FunctionDeclWrapper(object: decl) {
            let asserter = Asserter<FunctionDeclWrapper>(object: wrapper)

            closure(asserter)

            return asserter
        }

        return nil
    }

    @discardableResult
    func asserter(
        forBlock name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<BlockDeclWrapper>) -> Void = { _ in }
    ) -> Asserter<BlockDeclWrapper>? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one block '\(name)'",
            file: file,
            line: line
        ) { decl in

            switch decl.declaration {
            case .block(_, let base, _) where base?.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl, let wrapper = BlockDeclWrapper(object: decl) {
            let asserter = Asserter<BlockDeclWrapper>(object: wrapper)

            closure(asserter)

            return asserter
        }

        return nil
    }

    @discardableResult
    func asserter(
        forStruct name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.StructOrUnionSpecifier>) -> Void = { _ in }
    ) -> DeclarationExtractor.StructOrUnionSpecifier? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one struct with identifier '\(name)'",
            file: file,
            line: line
        ) { decl in

            return decl.declaration.identifierString == name
                && decl.specifiers.typeSpecifiers().contains(where: { $0.isStructOrUnionSpecifier })
        }
        
        if let decl = decl?.specifiers.typeSpecifiers().first(where: { $0.isStructOrUnionSpecifier })?.asStructOrUnionSpecifier {
            closure(.init(object: decl))
        }

        return nil
    }

    @discardableResult
    func asserter(
        forEnum name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.EnumSpecifier>) -> Void = { _ in }
    ) -> DeclarationExtractor.EnumSpecifier? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one enum with identifier '\(name)'",
            file: file,
            line: line
        ) { decl in

            return decl.declaration.identifierString == name
                && decl.specifiers.typeSpecifiers().contains(where: { $0.isEnumSpecifier })
        }
        
        if let decl = decl?.specifiers.typeSpecifiers().first(where: { $0.isEnumSpecifier })?.asEnumSpecifier {
            closure(.init(object: decl))
        }

        return nil
    }

    @discardableResult
    func asserter(
        forDecl name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> DeclarationExtractor.Declaration? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one declaration with identifier '\(name)'",
            file: file,
            line: line
        ) { decl in

            return decl.declaration.identifierString == name
        }
        
        if let decl = decl {
            closure(.init(object: decl))
        }

        return decl
    }
}

extension Asserter where Object: DeclarationConvertible {
    func assertNoInitializer(file: StaticString = #file, line: UInt = #line) {
        guard let initializer = object.decl.initializer else {
            return
        }

        XCTFail(
            "Expected declaration to feature no initializer, found \(initializer)",
            line: line
        )
        dumpObject()
    }

    @discardableResult
    func assertHasInitializer(file: StaticString = #file, line: UInt = #line) -> Asserter<ObjectiveCParser.InitializerContext>? {
        return assertInitializer(file: file, line: line, { _ in })
    }

    @discardableResult
    func assertInitializer(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjectiveCParser.InitializerContext>) -> Void
    ) -> Asserter<ObjectiveCParser.InitializerContext>? {

        guard let initializer = object.decl.initializer else {
            XCTFail("Expected declaration to feature initializer", file: file, line: line)
            dumpObject()

            return nil
        }

        let asserter = Asserter<ObjectiveCParser.InitializerContext>(object: initializer)

        closure(asserter)

        return asserter
    }

    @discardableResult
    func assertIsStaticArray(count: Int? = nil, file: StaticString = #file, line: UInt = #line) -> Self? {
        switch object.decl.declaration {
        case .staticArray(_, _, let length):
            if let count = count {
                if let length = length {
                    if length.getText() != count.description {
                        XCTAssertEqual(
                            length.getText(),
                            count.description,
                            "Expected declaration to be a static array of length \(count).",
                            file: file,
                            line: line
                        )
                        dumpObject()
                    }
                    return self
                } else {
                    XCTFail("Expected declaration to be a static array of length \(count), but found no length.", file: file, line: line)
                    dumpObject()
                    return nil
                }
            }

            return self
        default:
            XCTFail("Expected declaration to be a static array", file: file, line: line)
            dumpObject()
            return nil
        }
    }

    @discardableResult
    func assertIsPointer(file: StaticString = #file, line: UInt = #line) -> Asserter<DeclarationExtractor.Pointer>? {
        return asserterForPointer(file: file, line: line)
    }

    @discardableResult
    func assertIsNotPointer(file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.decl.pointer == nil else {
            XCTFail(
                "Expected declaration '\(object.decl.declaration.identifierString ?? "<nil>")' to not be a pointer type",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertIsVariable(name: String, file: StaticString = #file, line: UInt = #line) -> Self? {
        switch object.decl.declaration {
        case .identifier(name, _):
            return self

        default:
            XCTFail(
                "Expected to define at least one variable '\(name)'",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }
    }

    @discardableResult
    func assertIsFunctionPointer(name: String, file: StaticString = #file, line: UInt = #line) -> Self? {
        switch object.decl.declaration {
        case .function(base: .pointer(.identifier(name, _), _), _):
            return self
        
        default:
            XCTFail(
                "Expected to define at least one pointer to a function with name '\(name)'",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }
    }

    @discardableResult
    func assertIsStructOrUnion(file: StaticString = #file, line: UInt = #line) -> Self? {
        let typeSpecifiers = object.decl.specifiers.typeSpecifiers()
        guard typeSpecifiers.contains(where: { $0.isStructOrUnionSpecifier }) else {
            XCTFail(
                "Expected to define at least one struct/union",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }

        return self
    }

    @discardableResult
    func assertIsEnum(file: StaticString = #file, line: UInt = #line) -> Self? {
        let typeSpecifiers = object.decl.specifiers.typeSpecifiers()
        guard typeSpecifiers.contains(where: { $0.isEnumSpecifier }) else {
            XCTFail(
                "Expected to define at least one enum",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }

        return self
    }

    @discardableResult
    func assert(
        specifiers: [DeclarationExtractor.DeclSpecifier],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        let specifierStrings = Set(specifiers.map(\.description))

        return assert(specifierStrings: specifierStrings, file: file, line: line)
    }

    @discardableResult
    func assert(
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        let actualSpecs = Set(object.decl.specifiers.map(\.description))

        if actualSpecs == specifierStrings {
            return self
        }

        XCTAssertEqual(
            actualSpecs,
            specifierStrings,
            "Expected to define declaration with specifiers '\(specifierStrings.joined(separator: " "))'",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func asserterForPointer(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Pointer>) -> Void = { _ in }
    ) -> Asserter<DeclarationExtractor.Pointer>? {

        guard let pointer = object.decl.pointer else {
            XCTFail(
                "Expected declaration '\(object.decl.declaration.identifierString ?? "<nil>")' to be a pointer type",
                file: file,
                line: line
            )
            dumpObject()
            return nil
        }

        let asserter = Asserter<DeclarationExtractor.Pointer>(object: pointer)

        closure(asserter)

        return asserter
    }
}

extension Asserter where Object == FunctionDeclWrapper {
    @discardableResult
    func assertParameterCount(_ count: Int, file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.parameters.count == count else {
            XCTAssertEqual(
                object.parameters.count,
                count,
                "Unexpected parameter count for function definition '\(object.decl.declaration.identifierString ?? "<nil>")'",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assert(
        returnTypeSpecifiers specifiers: [DeclarationExtractor.DeclSpecifier],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        assert(specifiers: specifiers, file: file, line: line)
    }

    @discardableResult
    func assert(
        returnTypeSpecifierStrings specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        assert(specifierStrings: specifierStrings, file: file, line: line)
    }

    @discardableResult
    func assertHasParameter(
        name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Self? {
        guard asserterForParameter(name: name, file: file, line: line, closure) != nil else {
            return nil
        }

        return self
    }

    @discardableResult
    func asserterForParameter(
        name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        for param in object.parameters {
            switch param {
            case .declaration(let decl):
                if decl.declaration.identifierString == name {
                    let asserter = Asserter<DeclarationExtractor.Declaration>(object: decl)

                    closure(asserter)

                    return asserter
                }
            case .typeName:
                break
            }
        }

        XCTFail(
            "Expected function definition '\(object.decl.declaration.identifierString ?? "<nil>")' to feature a parameter named '\(name)'",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }
}

extension Asserter where Object == BlockDeclWrapper {
    @discardableResult
    func assertParameterCount(_ count: Int, file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.parameters.count == count else {
            XCTAssertEqual(
                object.parameters.count,
                count,
                "Unexpected parameter count for block definition '\(object.decl.declaration.identifierString ?? "<nil>")'",
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assert(
        returnTypeSpecifiers specifiers: [DeclarationExtractor.DeclSpecifier],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        assert(specifiers: specifiers, file: file, line: line)
    }

    @discardableResult
    func assert(
        returnTypeSpecifierStrings specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        assert(specifierStrings: specifierStrings, file: file, line: line)
    }
}

extension Asserter where Object == DeclarationExtractor.StructOrUnionSpecifier {
    @discardableResult
    func assertFieldCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.fields?.count == count else {
            XCTAssertEqual(
                object.fields?.count,
                count,
                "Unexpected field count for struct definition '\(object.identifier?.getText() ?? "<nil>")'",
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
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.StructFieldDeclaration>? {

        guard let field = object.fields?.first(where: { $0.declaration.declaration.identifierString == name }) else {
            XCTFail(
                "Expected to find field named \(name) in struct definition '\(object.identifier?.getText() ?? "<nil>")'",
                line: line
            )

            dumpObject()

            return nil
        }

        return .init(object: field)
    }
}

extension Asserter where Object == DeclarationExtractor.EnumSpecifier {
    @discardableResult
    func assertEnumeratorCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.enumerators?.count == count else {
            XCTAssertEqual(
                object.enumerators?.count,
                count,
                "Unexpected enumerator count for enum definition '\(object.identifier?.getText() ?? "<nil>")'",
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
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.EnumeratorDeclaration>? {

        guard let enumerator = object.enumerators?.first(where: { $0.identifier.getText() == name }) else {
            XCTFail(
                "Expected to find enumerator named \(name) in enum definition '\(object.identifier?.getText() ?? "<nil>")'",
                line: line
            )

            dumpObject()

            return nil
        }

        return .init(object: enumerator)
    }
}

extension Asserter where Object: ParserRuleContext {
    func assertString(matches exp: String, file: StaticString = #file, line: UInt = #line) {
        let act = object.getText()
        if act == exp {
            return
        }

        XCTFail("Expected initializer to be '\(exp)' but found '\(act)'", file: file, line: line)
        dumpObject()
    }
}
