import XCTest
import Antlr4
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser
import TestCommons
import Utils

@testable import ObjcParser

// MARK: -

/// For generic assertions over both 'DeclarationExtractor.Declaration' and 'FunctionDeclWrapper'.
protocol DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration { get }
}

struct FunctionDeclWrapper: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration
    var base: DeclarationExtractor.DeclarationKind?
    var parameters: [DeclarationExtractor.FuncParameter]
    var isVariadic: Bool

    init?(object: DeclarationExtractor.Declaration) {
        self.decl = object

        switch object.declaration {
        case .function(let base, let parameters, let isVariadic):
            self.base = base
            self.parameters = parameters
            self.isVariadic = isVariadic

        default:
            return nil
        }
    }
}

struct BlockDeclWrapper: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration
    var specifiers: [DeclarationExtractor.BlockDeclarationSpecifier]
    var base: DeclarationExtractor.DeclarationKind?
    var parameters: [DeclarationExtractor.FuncParameter]

    init?(object: DeclarationExtractor.Declaration) {
        self.decl = object

        switch object.declaration {
        case .block(let specifiers, let base, let parameters):
            self.specifiers = specifiers
            self.base = base
            self.parameters = parameters

        default:
            return nil
        }
    }
}

struct TypedefDeclWrapper: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration
    var name: String

    init?(object: DeclarationExtractor.Declaration) {
        guard object.specifiers.storageSpecifiers().contains(where: { $0.isTypedef }) else {
            return nil
        }

        self.decl = object
        self.name = object.declaration.identifierString
    }
}

extension DeclarationExtractor.Declaration: DeclarationConvertible {
    var decl: DeclarationExtractor.Declaration { self }
}

extension Asserter where Object == [DeclarationExtractor.Declaration] {
    /// Asserts that there is at least one element on the underlying declaration
    /// array being tested that testes true for a given predicate.
    ///
    /// Returns `nil` if the test failed, or the first `Object.Element` that
    /// passed the predicate.
    @discardableResult
    func _assertOneOrMore(
        message: @autoclosure () -> String,
        file: StaticString = #file,
        line: UInt,
        _ predicate: (Object.Element) -> Bool
    ) -> Object.Element? {
        for obj in object {
            if predicate(obj) {
                return obj
            }
        }

        XCTFail(message(), file: file, line: line)
        dumpObject()

        return nil
    }

    /// Asserts that there are no elements on the underlying declaration array
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoDeclarations(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

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

    /// Asserts that there are exactly `count` of elements on the underlying
    /// declaration array being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertDefinedCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.count == count else {
            XCTAssertEqual(object.count, count, file: file, line: line)
            dumpObject()
            return nil
        }

        return self
    }

    /// Asserts that there is at least one variable with a specified name on the
    /// underlying declaration array being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns an `Asserter<Declaration>`
    /// for chaining further tests on the variable that was found.
    @discardableResult
    func assertVariable(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        for decl in object {
            switch decl.declaration {
            case .identifier, .staticArray, .block:
                if decl.identifierString == name {
                    return Asserter<DeclarationExtractor.Declaration>(object: decl)
                }
            default:
                break
            }
        }

        XCTFail(
            "Expected to define a variable with name \(name)",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    /// Asserts that there is at least one variable with a specified name and
    /// list of declaration specifiers on the underlying declaration array being
    /// tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns an `Asserter<Declaration>`
    /// for chaining further tests on the variable that was found.
    @discardableResult
    func assertVariable(
        name: String,
        specifiers: [DeclarationExtractor.DeclSpecifier],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        return assertVariable(name: name, file: file, line: line)?
            .assert(specifiers: specifiers, file: file, line: line)
    }

    /// Asserts that there is at least one variable with a specified name and
    /// list of declaration specifiers on the underlying declaration array being
    /// tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns an `Asserter<Declaration>`
    /// for chaining further tests on the variable that was found.
    @discardableResult
    func assertVariable(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationExtractor.Declaration>? {

        return assertVariable(name: name, file: file, line: line)?
            .assert(specifierStrings: specifierStrings, file: file, line: line)
    }

    @discardableResult
    func assertFunction(name: String, file: StaticString = #file, line: UInt = #line) -> Asserter<FunctionDeclWrapper>? {
        for decl in object {
            guard let wrapper = FunctionDeclWrapper(object: decl), wrapper.decl.identifierString == name else {
                continue
            }

            return Asserter<FunctionDeclWrapper>(object: wrapper)
        }

        XCTFail(
            "Expected to define a function with name \(name)",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertFunction(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<FunctionDeclWrapper>? {

        return assertFunction(name: name, file: file, line: line)?
            .assert(specifierStrings: specifierStrings, file: file, line: line)
    }

    @discardableResult
    func assertBlock(name: String, file: StaticString = #file, line: UInt = #line) -> Asserter<BlockDeclWrapper>? {
        for decl in object {
            guard let wrapper = BlockDeclWrapper(object: decl), wrapper.decl.identifierString == name else {
                continue
            }

            return Asserter<BlockDeclWrapper>(object: wrapper)
        }

        XCTFail(
            "Expected to define a block with name \(name)",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertBlock(
        name: String,
        specifierStrings: Set<String>,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<BlockDeclWrapper>? {

        return assertBlock(name: name, file: file, line: line)?
            .assert(specifierStrings: specifierStrings, file: file, line: line)
    }

    @discardableResult
    func asserter(
        forVariable name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Self? {

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
            case .block(_, let base, _) where base.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl {
            let asserter = Asserter<DeclarationExtractor.Declaration>(object: decl)

            closure(asserter)

            return self
        }

        return nil
    }

    @discardableResult
    func asserter(
        forFunction name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<FunctionDeclWrapper>) -> Void = { _ in }
    ) -> Self? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one function '\(name)'",
            file: file,
            line: line
        ) { decl in

            switch decl.declaration {
            case .function(let base, _, _) where base.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl, let wrapper = FunctionDeclWrapper(object: decl) {
            let asserter = Asserter<FunctionDeclWrapper>(object: wrapper)

            closure(asserter)

            return self
        }

        return nil
    }

    @discardableResult
    func asserter(
        forBlock name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<BlockDeclWrapper>) -> Void = { _ in }
    ) -> Self? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one block '\(name)'",
            file: file,
            line: line
        ) { decl in

            switch decl.declaration {
            case .block(_, let base, _) where base.identifierString == name:
                return true

            default:
                return false
            }
        }
        
        if let decl = decl, let wrapper = BlockDeclWrapper(object: decl) {
            let asserter = Asserter<BlockDeclWrapper>(object: wrapper)

            closure(asserter)

            return self
        }

        return nil
    }

    @discardableResult
    func asserter(
        forStruct name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.StructOrUnionSpecifier>) -> Void = { _ in }
    ) -> Self? {

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

            return self
        }

        return nil
    }

    @discardableResult
    func asserter(
        forEnum name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.EnumSpecifier>) -> Void = { _ in }
    ) -> Self? {

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

            return self
        }

        return nil
    }

    @discardableResult
    func asserter(
        forDecl name: String, 
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Self? {

        let decl = _assertOneOrMore(
            message: "Expected to define at least one declaration with identifier '\(name)'",
            file: file,
            line: line
        ) { decl in

            return decl.declaration.identifierString == name
        }
        
        if let decl = decl {
            closure(.init(object: decl))

            return self
        }

        return nil
    }
}

extension Asserter where Object: DeclarationConvertible {
    func assertNoInitializer(file: StaticString = #file, line: UInt = #line) {
        guard let initializer = object.decl.initializer else {
            return
        }

        XCTFail(
            "Expected declaration to feature no initializer, found '\(initializer)'",
            line: line
        )
        dumpObject()
    }

    @discardableResult
    func assertHasInitializer(file: StaticString = #file, line: UInt = #line) -> Asserter<InitializerSyntax>? {
        return assertInitializer(file: file, line: line, { _ in })
    }

    @discardableResult
    func assertInitializer(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<InitializerSyntax>) -> Void
    ) -> Asserter<InitializerSyntax>? {

        guard let initializer = object.decl.initializer else {
            XCTFail("Expected declaration to feature initializer", file: file, line: line)
            dumpObject()

            return nil
        }

        let asserter = Asserter<_>(object: initializer)

        closure(asserter)

        return asserter
    }

    @discardableResult
    func assertIsStaticArray(count: Int? = nil, file: StaticString = #file, line: UInt = #line) -> Self? {
        switch object.decl.declaration {
        case .staticArray(_, _, let length):
            if let count = count {
                if let length = length {
                    if length.expressionString != count.description {
                        XCTAssertEqual(
                            length.expressionString,
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
                "Expected declaration '\(object.decl.declaration.identifierString)' to not be a pointer type",
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
        case .function(base: .pointer(.identifier(name, _), _), _, _):
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
    func assertIsTypeDef(
        name: String? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard let typedef = TypedefDeclWrapper(object: object.decl) else {
            XCTFail(
                "Expected to define at least one typedef",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        guard name == nil || name == typedef.name else {
            XCTFail(
                "Expected to define a typedef with name '\(name ?? "<nil>")' but found '\(typedef.name)'",
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
    func asserterForSpecifiers(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<[DeclarationExtractor.DeclSpecifier]>) -> Void
    ) -> Self {

        let specifiers = object.decl.specifiers

        closure(.init(object: specifiers))

        return self
    }

    @discardableResult
    func asserterForPointer(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Pointer>) -> Void = { _ in }
    ) -> Asserter<DeclarationExtractor.Pointer>? {

        guard let pointer = object.decl.pointer else {
            XCTFail(
                "Expected declaration '\(object.decl.declaration.identifierString)' to be a pointer type",
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

    /// Opens an assertion context for the `SourceRange` of the underlying
    /// `DeclarationExtractor.Declaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSourceRange<Result>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<SourceRange>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.decl.declarationNode.syntaxElement.sourceRange) { sourceRange in
            sourceRange.inClosure(closure)
        }
    }
}

extension Asserter where Object == [DeclarationExtractor.DeclSpecifier] {
    /// Asserts that the underlying `[DeclSpecifier]` object being tested contains
    /// one or more declaration specifiers that when converted to a string matches
    /// a specified string value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertHasSpecifier(
        string: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        let result = asserterForFirstElement(
            message: "Expected to find one or more declaration specifiers matching raw string '\(string)'.",
            file: file,
            line: line
        ) { declSpecifier in
            declSpecifier.description == string
        }

        if result == nil {
            return nil
        }

        return self
    }
}

extension Asserter where Object == FunctionDeclWrapper {
    @discardableResult
    func assertParameterCount(_ count: Int, file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.parameters.count == count else {
            XCTAssertEqual(
                object.parameters.count,
                count,
                "Unexpected parameter count for function definition '\(object.decl.declaration.identifierString)'",
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

    /// Opens an assertion context for the `Declaration` that matches a given
    /// name in the parameter list of the underlying function definition being
    /// tested.
    ///
    /// Returns `nil` if no parameter was found with the provided name, otherwise
    /// returns `self` for chaining further tests.
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
            "Expected function definition '\(object.decl.declaration.identifierString)' to feature a parameter named '\(name)'",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    /// Opens an assertion context for the `FuncParameter` at a given index in
    /// the parameter list of the underlying function definition being tested.
    ///
    /// Returns `self` for chaining further tests.
    @discardableResult
    func asserterForParameter(
        atIndex index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.FuncParameter>) -> Void = { _ in }
    ) -> Self {

        return asserterUnconditional(forKeyPath: \.parameters, file: file, line: line) { parameters in
            parameters.asserter(forItemAt: index, file: file, line: line) { param in
                param.inClosureUnconditional(closure)
            }
        }
    }

    /// Opens an assertion context for the `SourceRange` of the underlying
    /// `DeclarationExtractor.Declaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSourceRange<Result>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<SourceRange>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.decl.declarationNode.syntaxElement.sourceRange) { sourceRange in
            sourceRange.inClosure(closure)
        }
    }
}

extension Asserter where Object == BlockDeclWrapper {
    @discardableResult
    func assertParameterCount(_ count: Int, file: StaticString = #file, line: UInt = #line) -> Self? {
        guard object.parameters.count == count else {
            XCTAssertEqual(
                object.parameters.count,
                count,
                "Unexpected parameter count for block definition '\(object.decl.declaration.identifierString)'",
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    /// Opens an assertion context for the `Declaration` that matches a given
    /// name in the parameter list of the underlying block declaration being
    /// tested.
    ///
    /// Returns `nil` if no parameter was found with the provided name, otherwise
    /// returns `self` for chaining further tests.
    @discardableResult
    func asserterForParameter(
        name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void = { _ in }
    ) -> Self? {

        for param in object.parameters {
            switch param {
            case .declaration(let decl) where decl.identifierString == name:
                let asserter = Asserter<DeclarationExtractor.Declaration>(object: decl)

                closure(asserter)

                return self
            default:
                break
            }
        }

        XCTFail(
            "Expected block declaration '\(object.decl.declaration.identifierString)' to feature a parameter named '\(name)'",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    /// Opens an assertion context for the `FuncParameter` at a given index in
    /// the parameter list of the underlying block declaration being tested.
    ///
    /// Returns `self` for chaining further tests.
    @discardableResult
    func asserterForParameter(
        atIndex index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.FuncParameter>) -> Void = { _ in }
    ) -> Self {

        return asserterUnconditional(forKeyPath: \.parameters, file: file, line: line) { parameters in
            parameters.asserter(forItemAt: index, file: file, line: line) { param in
                param.inClosureUnconditional(closure)
            }
        }
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

    /// Asserts that the underlying block declaration being tested has a given
    /// ARC behaviour specifier.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasArcSpecifier arcSpecifier: ObjcArcBehaviorSpecifier,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.specifiers, file: file, line: line) { specifiers in
            specifiers.assertContains(
                message: "Expected block to contain ARC specifier '\(arcSpecifier)'",
                file: file,
                line: line
            ) { element in
                element.arcBehaviourSpecifier == arcSpecifier
            }
        }
    }

    /// Asserts that the underlying block declaration being tested has a given
    /// type prefix.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasTypePrefix typePrefix: DeclarationExtractor.TypePrefix,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.specifiers, file: file, line: line) { specifiers in
            specifiers.assertContains(
                message: "Expected block to contain type prefix '\(typePrefix)'",
                file: file,
                line: line
            ) { element in
                element.typePrefix == typePrefix
            }
        }
    }

    /// Asserts that the underlying block declaration being tested has a given
    /// nullability specifier.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasNullabilitySpecifier nullabilitySpecifier: ObjcNullabilitySpecifier,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.specifiers, file: file, line: line) { specifiers in
            specifiers.assertContains(
                message: "Expected block to contain nullability specifier '\(nullabilitySpecifier)'",
                file: file,
                line: line
            ) { element in
                element.nullabilitySpecifier == nullabilitySpecifier
            }
        }
    }

    /// Asserts that the underlying block declaration being tested has a given
    /// type qualifier.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasTypeQualifier typeQualifier: ObjcTypeQualifier,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.specifiers, file: file, line: line) { specifiers in
            specifiers.assertContains(
                message: "Expected block to contain type qualifier '\(typeQualifier)'",
                file: file,
                line: line
            ) { element in
                element.typeQualifier == typeQualifier
            }
        }
    }

    /// Opens an assertion context for the `SourceRange` of the underlying
    /// `DeclarationExtractor.Declaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSourceRange<Result>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<SourceRange>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.decl.declarationNode.syntaxElement.sourceRange) { sourceRange in
            sourceRange.inClosure(closure)
        }
    }
}

extension Asserter where Object == DeclarationExtractor.FuncParameter {
    /// Asserts that the underlying `FuncParameter` being tested is a type name
    /// parameter kind.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .typeName:
            return self
        case .declaration:
            XCTFail(
                "Expected function parameter to be a type name, found a declaration instead.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
    }

    /// Asserts that the underlying `FuncParameter` being tested is a declaration
    /// parameter kind.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsDeclaration(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .declaration:
            return self
        case .typeName:
            XCTFail(
                "Expected function parameter to be a type name, found a declaration instead.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
    }
    
    /// Opens an assertion context for the `TypeName` associated with the underlying
    /// `FuncParameter` being tested.
    ///
    /// Returns `nil` if the underlying function parameter has no `TypeName`,
    /// otherwise returns `self` for chaining further tests.
    @discardableResult
    func asserterForTypeName(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.TypeName>) -> Void
    ) -> Self? {

        switch object {
        case .typeName(let value):
            Asserter<DeclarationExtractor.TypeName>(object: value)
                .inClosureUnconditional(closure)

            return self
        case .declaration:
            XCTFail(
                "Expected function parameter to be a type name, found a declaration instead.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
    }

    /// Opens an assertion context for the `Declaration` associated with the
    /// underlying `FuncParameter` being tested.
    ///
    /// Returns `nil` if the underlying function parameter has no `Declaration`,
    /// otherwise returns `self` for chaining further tests.
    @discardableResult
    func asserterForDeclaration(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.Declaration>) -> Void
    ) -> Self? {

        switch object {
        case .declaration(let value):
            Asserter<DeclarationExtractor.Declaration>(object: value)
                .inClosureUnconditional(closure)
            
            return self
        case .typeName:
            XCTFail(
                "Expected function parameter to be a declaration, found a type name instead.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
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
                "Unexpected field count for struct definition '\(object.identifier?.identifier ?? "<nil>")'",
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
                "Expected to find field named '\(name)' in struct definition '\(object.identifier?.identifier ?? "<nil>")'",
                file: file,
                line: line
            )

            dumpObject()

            return nil
        }

        return .init(object: field)
    }

    /// Opens an assertion context for the `SourceRange` of the underlying
    /// `DeclarationExtractor.Declaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSourceRange<Result>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<SourceRange>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.syntax.sourceRange) { sourceRange in
            sourceRange.inClosure(closure)
        }
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
                "Unexpected enumerator count for enum definition '\(object.identifier?.identifier ?? "<nil>")'",
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

        guard let enumerator = object.enumerators?.first(where: { $0.identifier.identifier == name }) else {
            XCTFail(
                "Expected to find enumerator named '\(name)' in enum definition '\(object.identifier?.identifier ?? "<nil>")'",
                line: line
            )

            dumpObject()

            return nil
        }

        return .init(object: enumerator)
    }

    @discardableResult
    func assertHasTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        guard object.typeName != nil else {
            XCTAssertNotNil(
                object.typeName,
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    @discardableResult
    func assertNoTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        guard object.typeName == nil else {
            XCTAssertNil(
                object.typeName,
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    /// Opens an assertion context for the `SourceRange` of the underlying
    /// `DeclarationExtractor.Declaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSourceRange<Result>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<SourceRange>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.syntax.sourceRange) { sourceRange in
            sourceRange.inClosure(closure)
        }
    }
}

extension Asserter where Object == DeclarationExtractor.Pointer {
    /// Asserts that the underlying `Pointer` being tested has a specified number
    /// of pointer references within it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertPointerCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.pointers, file: file, line: line) {
            $0.assertCount(count, file: file, line: line)
        }
    }

    /// Asserts that the underlying `Pointer` being tested has a specified number
    /// of pointer entries within it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForPointerEntry(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.pointers, file: file, line: line) {
            $0.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for a specified pointer entry index on the
    /// underlying `Pointer` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forPointerEntryAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationExtractor.PointerEntry>) -> Void
    ) -> Self? {

        guard object.pointers.count > index else {
            XCTFail(
                "Expected pointer list to have at least \(index) parameter(s) but found \(object.pointers.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: object.pointers[index]))

        return self
    }
}

extension Asserter where Object == DeclarationExtractor.PointerEntry {
    /// Asserts that the underlying `PointerEntry` being tested has a set of type
    /// qualifiers that when converted to strings matches a specified set of
    /// string values.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        typeQualifierStrings expected: Set<String>?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .pointer(let qualifiers, _):
            let qualifiersSet = qualifiers.map { Set($0.map(\.description)) }

            if expected != qualifiersSet {
                XCTAssertEqual(
                    qualifiersSet,
                    expected,
                    file: file,
                    line: line
                )
            }
        }

        return self
    }

    /// Asserts that the underlying `PointerEntry` being tested has a given
    /// nullability specifier.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        nullabilitySpecifier expected: ObjcNullabilitySpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.nullabilitySpecifier) {
            $0.assert(equals: expected, file: file, line: line)
        }
    }
}
