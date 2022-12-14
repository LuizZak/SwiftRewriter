import XCTest
import TestCommons
import Antlr4
import ObjcParserAntlr
import GrammarModelBase
import ObjcGrammarModels
import ObjcParser

// MARK: - Test Internals

public extension Asserter where Object == [DeclarationTranslator.ASTNodeDeclaration] {
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
    ) -> Asserter<DeclarationTranslator.ASTVariableDeclaration>? {

        for value in object {
            switch value {
            case .variable(let decl) where decl.identifier.name == name:
                return .init(object: decl)
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
    ) -> Asserter<DeclarationTranslator.ASTBlockDeclaration>? {

        for value in object {
            switch value {
            case .block(let decl) where decl.identifier.name == name:
                return .init(object: decl)

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
    ) -> Asserter<DeclarationTranslator.ASTFunctionDefinition>? {

        for value in object {
            switch value {
            case .function(let decl) where decl.identifier.name == name:
                return .init(object: decl)

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
    ) -> Asserter<DeclarationTranslator.ASTTypedefDeclaration>? {

        for value in object {
            switch value {
            case .typedef(let decl) where decl.alias.name == name:
                return .init(object: decl)

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
    ) -> Asserter<DeclarationTranslator.ASTStructOrUnionDeclaration>? {

        for value in object {
            switch value {
            case .structOrUnionDecl(let decl) where name == nil || decl.identifier?.name == name:
                return .init(object: decl)

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
    ) -> Asserter<DeclarationTranslator.ASTEnumDeclaration>? {

        for value in object {
            switch value {
            case .enumDecl(let decl) where name == nil || decl.identifier?.name == name:
                return .init(object: decl)

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

public extension Asserter where Object == DeclarationTranslator.ASTNodeDeclaration {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        switch object {
        case .variable(let decl) where decl.initialValue != nil:
            return self
        case .block(let decl) where decl.initialValue != nil:
            return self
        case .functionPointer(let decl) where decl.initialValue != nil:
            return self

        default:
            break
        }

        XCTFail(
            "Expected declaration '\(object.identifierNode?.name ?? "<anonymous>")' to have initializer but found none.",
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
        case .variable(let decl) where decl.initialValue == nil:
            return self
        case .block(let decl) where decl.initialValue == nil:
            return self
        case .functionPointer(let decl) where decl.initialValue == nil:
            return self

        default:
            break
        }

        XCTFail(
            "Expected declaration '\(object.identifierNode?.name ?? "<anonymous>")' to have no initializer but found one.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertIsVariable(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTVariableDeclaration>? {

        switch object {
        case .variable(let decl):
            return .init(object: decl)
        default:
            break
        }

        XCTFail(
            "Expected object to be a variable declaration.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertIsStructOrUnion(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTStructOrUnionDeclaration>? {

        switch object {
        case .structOrUnionDecl(let decl):
            return .init(object: decl)
        default:
            break
        }

        XCTFail(
            "Expected object to be a struct or union declaration.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertIsEnum(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTEnumDeclaration>? {

        switch object {
        case .enumDecl(let decl):
            return .init(object: decl)
        default:
            break
        }

        XCTFail(
            "Expected object to be an enum declaration.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertIsFunction(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTFunctionDefinition>? {

        switch object {
        case .function(let decl):
            return .init(object: decl)
        default:
            break
        }

        XCTFail(
            "Expected object to be a function declaration.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    @discardableResult
    func assertIsTypeDef(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<DeclarationTranslator.ASTTypedefDeclaration>? {

        switch object {
        case .typedef(let decl):
            return .init(object: decl)
        default:
            break
        }

        XCTFail(
            "Expected object to be a typedef declaration.",
            file: file,
            line: line
        )
        dumpObject()

        return nil
    }

    /// Opens an assertion context for the context syntax element of the underlying
    /// `ASTNodeDeclaration` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForContext<Return>(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<DeclarationSyntaxElementType>) -> Return?
    ) -> Self? {
        
        inClosure { asserter in
            Asserter<_>(object: asserter.object.contextRule).inClosure(closure)
        }
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTVariableDeclaration {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.initialValue != nil else {
            XCTFail(
                "Expected declaration '\(object.identifier.name)' to have initializer but found none.",
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
                "Expected declaration '\(object.identifier.name)' to have no initializer but found one.",
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
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.type.type == type else {
            XCTFail(
                "Expected declaration '\(object.identifier.name)' to have type '\(type)' but found '\(object.type.type)'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    /// Asserts that the underlying variable declaration being tested has a given
    /// nullability specifier value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        nullabilitySpecifier: ObjcNullabilitySpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.nullability == nullabilitySpecifier else {
            XCTAssertEqual(
                object.nullability,
                nullabilitySpecifier,
                "Expected declaration '\(object.identifier.name)' to have nullability specifier '\(nullabilitySpecifier?.description ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying variable declaration being tested has a given
    /// arc behaviour specifier value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        arcSpecifier: ObjcArcBehaviorSpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.arcSpecifier == arcSpecifier else {
            XCTAssertEqual(
                object.arcSpecifier,
                arcSpecifier,
                "Expected declaration '\(object.identifier.name)' to have arc specifier '\(arcSpecifier?.description ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying variable declaration being tested has a
    /// specified `isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.isStatic,
            file: file,
            line: line
        ) {
            $0.assert(
                equals: isStatic,
                message: "Expected variable '\(object.identifier.name).isStatic' to be \(isStatic).",
                file: file,
                line: line
            )
        }
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTBlockDeclaration {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.initialValue != nil else {
            XCTFail(
                "Expected block '\(object.identifier.name)' to have initializer but found none.",
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
                "Expected block '\(object.identifier.name)' to have no initializer but found one.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying block declaration being tested has a given
    /// nullability specifier value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasNullabilitySpecifier nullabilitySpecifier: ObjcNullabilitySpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.nullability == nullabilitySpecifier else {
            XCTAssertEqual(
                object.nullability,
                nullabilitySpecifier,
                "Expected block '\(object.identifier.name)' to have nullability specifier '\(nullabilitySpecifier?.description ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying block declaration being tested has a given
    /// arc behaviour specifier value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasArcSpecifier arcSpecifier: ObjcArcBehaviorSpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.arcSpecifier == arcSpecifier else {
            XCTAssertEqual(
                object.arcSpecifier,
                arcSpecifier,
                "Expected block '\(object.identifier.name)' to have arc specifier '\(arcSpecifier?.description ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
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

        return asserter(forKeyPath: \.typeQualifiers, file: file, line: line) { typeQualifiers in
            typeQualifiers.assertContains(
                message: "Expected block to contain type qualifier '\(typeQualifier)'",
                file: file,
                line: line
            ) { element in
                element == typeQualifier
            }
        }
    }

    /// Asserts that the underlying block declaration being tested has a
    /// specified `isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.isStatic,
            file: file,
            line: line
        ) {
            $0.assert(
                equals: isStatic,
                message: "Expected block's '\(object.identifier.name).isStatic' to be \(isStatic).",
                file: file,
                line: line
            )
        }
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTFunctionPointerDeclaration {
    @discardableResult
    func assertHasInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.initialValue != nil else {
            XCTFail(
                "Expected function pointer '\(object.identifier.name)' to have initializer but found none.",
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
                "Expected function pointer '\(object.identifier.name)' to have no initializer but found one.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying function pointer declaration being tested
    /// has a given nullability specifier value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasNullabilitySpecifier nullabilitySpecifier: ObjcNullabilitySpecifier?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.nullability == nullabilitySpecifier else {
            XCTAssertEqual(
                object.nullability,
                nullabilitySpecifier,
                "Expected function pointer '\(object.identifier.name)' to have nullability specifier '\(nullabilitySpecifier?.description ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()
            
            return nil
        }

        return self
    }

    /// Asserts that the underlying function pointer declaration being tested has
    /// a specified `isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.isStatic,
            file: file,
            line: line
        ) {
            $0.assert(
                equals: isStatic,
                message: "Expected function pointer's '\(object.identifier.name).isStatic' to be \(isStatic).",
                file: file,
                line: line
            )
        }
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTTypedefDeclaration {
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        let identifier = object.alias.name
        
        guard identifier == name else {
            XCTFail(
                "Expected typedef to have identifier '\(name)' but found '\(identifier)'.",
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
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        let typedefType = object.typeNode.type
        
        guard typedefType == type else {
            XCTFail(
                "Expected typedef '\(object.alias.name)' to have type '\(type)' but found '\(typedefType.description)'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTFunctionDefinition {
    @discardableResult
    func assertReturnType(
        _ type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        let returnType = object.returnType.type
        guard returnType == type else {
            XCTFail(
                "Expected function '\(object.identifier.name)' to have return type '\(type)' but found '\(returnType)'.",
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
                "Expected function '\(object.identifier.name)' to have \(count) parameter(s) but found \(object.parameters.count).",
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
                "Function '\(object.identifier.name)' does not have \(index) parameter(s) available (actual count: \(object.parameters.count)).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let parameter = object.parameters[index]
        guard parameter.identifier?.name == name else {
            XCTFail(
                "Expected parameter \(index) of function '\(object.identifier.name)' to have name '\(name)' but found '\(parameter.identifier?.name ?? "<nil>")'.",
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
                "Function '\(object.identifier.name)' does not have \(index) parameter(s) available (actual count: \(object.parameters.count)).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let parameter = object.parameters[index]
        guard parameter.type.type == type else {
            XCTFail(
                "Expected parameter \(index) of function '\(object.identifier.name)' to have type '\(type)' but found '\(parameter.type.type.description)'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTStructOrUnionDeclaration {
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
                "Unexpected count of fields in struct declaration '\(object.identifier?.name ?? "<anonymous>")'.",
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
                "Expected to find a field named '\(name)' in struct declaration '\(object.identifier?.name ?? "<anonymous>")'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        let fieldType = field.type.type
        if let type, type != fieldType {
            XCTFail(
                "Expected struct field '\(name)' in struct declaration '\(object.identifier?.name ?? "<anonymous>")' to have type '\(type)', but found '\(fieldType)'.",
                file: file,
                line: line
            )
            dumpObject()
        }

        return self
    }
}

public extension Asserter where Object == DeclarationTranslator.ASTEnumDeclaration {
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
                "Unexpected count of enumerators in enum declaration '\(object.identifier?.name ?? "<anonymous>")'.",
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
                "Expected to find an enumerator named '\(name)' in enum declaration '\(object.identifier?.name ?? "<anonymous>")'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
        
        let enumExp = enumerator.expression
        if let expressionString {
            return inClosure { asserter in
                Asserter<_>(object: enumExp)
                    .assertNotNil(file: file, line: line)?
                    .assert(textEquals: expressionString, file: file, line: line)
            }
        }

        return self
    }

    @discardableResult
    func assertTypeName(
        _ name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        let typeName = object.typeName?.type.description
        guard typeName == name else {
            XCTAssertEqual(
                typeName,
                name,
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

public extension Asserter {
    /// Asserts that the underlying `DeclarationTranslator.SyntaxStorageMode<T>`
    /// object being tested has a textual value from the underlying source code
    /// that matches a given string.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert<T>(
        textEquals expected: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == DeclarationTranslator.SyntaxStorageMode<T> {
        
        inClosure { asserter -> Any? in
            switch asserter.object {
            case .antlr(_, let rule):
                return Asserter<_>(object: rule)
                    .assert(
                        textEquals: expected,
                        message: message(),
                        file: file,
                        line: line
                    )

            case .string(_, let source):
                return Asserter<_>(object: source)
                    .assert(equals: expected, file: file, line: line)
            }
        }
    }
}
