import XCTest
import GrammarModelBase
import ObjcGrammarModels

extension Asserter where Object: ASTNode {
    /// Opens an asserter context for a child node on the underlying `ASTNode`
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forChildAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ASTNode>) -> Void
    ) -> Self? {

        guard object.children.count > index else {
            XCTFail(
                "Expected node '\(object.shortDescription)' to have at least \(index) child(ren) but found \(object.children.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: object.children[index]))

        return self
    }

    /// Opens an asserter context for the first child on the underlying `ASTNode`
    /// being tested that is of a given type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<T: ASTNode>(
        forFirstChildOfType type: T.Type,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<T>) -> Void = { _ in }
    ) -> Self? {

        guard let child: T = object.firstChild() else {
            XCTFail(
                "Expected node '\(object.shortDescription)' to have at least one \(T.self)-typed child.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: child))

        return self
    }
}

extension Asserter where Object: ObjcASTNode {
    /// Asserts that the underlying `ObjcASTNode` being tested has a specified
    /// `isInNonnullContext` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isInNonnullContext inNonnullContext: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isInNonnullContext, file: file, line: line) { prop in
            prop.assert(
                equals: inNonnullContext,
                message: "Expected node \(object.shortDescription) to have isInNonnullContext value of \(inNonnullContext)",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `ObjcASTNode` being tested has a specified count
    /// of children nodes.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertChildCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        guard object.children.count == count else {
            XCTFail(
                "Expected node '\(object.shortDescription)' to have \(count) child(ren) but found \(object.children.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object == ObjcIdentifierNode {
    /// Asserts that the underlying `ObjcIdentifierNode` being tested has the specified
    /// `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.name, file: file, line: line) {
            $0.assert(equals: name, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcTypeNameNode {
    /// Asserts that the underlying `ObjcTypeNameNode` being tested has the specified
    /// `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assert(equals: type, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcInitialExpressionNode {
    /// Asserts that the underlying `ObjcInitialExpressionNode` being tested has a parser
    /// rule expression that matches a specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcConstantExpressionNode {
    /// Asserts that the underlying `ObjcConstantExpressionNode` being tested has a
    /// parser rule expression that matches a specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) { asserter in

            asserter.assertNotNil(file: file, line: line)?.inClosure { asserter -> Any? in
                switch asserter.object {
                case .antlr(let ctx):
                    return Asserter<_>(object: ctx)
                        .assert(textEquals: expressionString, file: file, line: line)
                case .string(let str):
                    return Asserter<_>(object: str)
                        .assert(equals: expressionString, file: file, line: line)
                }
            }
        }
    }
}

extension Asserter where Object == ObjcExpressionNode {
    /// Asserts that the underlying `ObjcExpressionNode` being tested has a
    /// parser rule expression that matches a specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) { asserter in

            asserter.assertNotNil(file: file, line: line)?.inClosure { asserter -> Any? in
                switch asserter.object {
                case .antlr(let ctx):
                    return Asserter<_>(object: ctx)
                        .assert(textEquals: expressionString, file: file, line: line)
                case .string(let str):
                    return Asserter<_>(object: str)
                        .assert(equals: expressionString, file: file, line: line)
                }
            }
        }
    }
}

extension Asserter where Object == ObjcTypedefNode {
    /// Asserts that the underlying `ObjcTypedefNode` being tested has an identifier
    /// node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcTypedefNode` being tested has a type node
    /// with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcVariableDeclarationNode {
    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested has an
    /// identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested has a
    /// type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested has an
    /// initial expression node with a parser rule expression that matches a
    /// specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested has a
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
                message: "Expected variable '\(object.identifier?.name ?? "<nil>").isStatic' to be \(isStatic).",
                file: file,
                line: line
            )
        }
    }

    /// Asserts that the underlying `ObjcVariableDeclarationNode` being tested has no
    /// initial value expression associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNil(
                message: "Expected variable '\(object.identifier?.name ?? "<nil>")' to have no initializer.",
                file: file,
                line: line
            )
        }
    }
}

extension Asserter where Object == ObjcStructDeclarationNode {
    /// Asserts that the underlying `ObjcStructDeclarationNode` being tested has an
    /// identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructDeclarationNode` being tested has a
    /// specified count of children fields defined.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertFieldCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.body?.children, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcStructDeclarationNode` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forFieldName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcStructFieldNode>) -> Void
    ) -> Self? {

        return asserter(forKeyPath: \.body?.fields, file: file, line: line) { fields in
            fields
                .assertNotNil(file: file, line: line)?
                .asserterForFirstElement(
                    message: "Expected to find a field with name '\(name)' in struct declaration '\(object.identifier?.name ?? "<nil>")'.",
                    file: file,
                    line: line
                ) { field in
                    field.identifier?.name == name
                }?.inClosure(closure)
        }
    }
}

extension Asserter where Object == ObjcStructFieldNode {
    /// Asserts that the underlying `ObjcStructFieldNode` being tested has an identifier
    /// node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructFieldNode` being tested has a type node
    /// with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructFieldNode` being tested has an
    /// expression node with a parser rule expression that matches a
    /// specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcEnumDeclarationNode {
    /// Asserts that the underlying `ObjcEnumDeclarationNode` being tested has an
    /// identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumDeclarationNode` being tested has a
    /// specified count of children fields defined.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertEnumeratorCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.cases, file: file, line: line) {
            $0.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcEnumDeclarationNode` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forEnumeratorName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcEnumCaseNode>) -> Void
    ) -> Self? {

        guard let field = object.cases.first(where: { $0.identifier?.name == name }) else {
            XCTFail(
                "Expected to find an enumerator with name '\(name)' in enum declaration '\(object.identifier?.name ?? "<nil>")'.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: field))

        return self
    }

    /// Asserts that the underlying `ObjcEnumDeclarationNode` being tested has a
    /// type name node with a specified type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        typeName: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: typeName, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumDeclarationNode` being tested has no
    /// type name node specified.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNil(file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcEnumCaseNode {
    /// Asserts that the underlying `ObjcEnumCaseNode` being tested has an identifier
    /// node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumCaseNode` being tested has an
    /// expression node with a parser rule expression that matches a
    /// specified string value exactly.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        expressionString: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumCaseNode` being tested has no expression
    /// node associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoExpression(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNil(file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcFunctionDefinitionNode {
    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested has an
    /// identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have identifier '\(name)', found nil", file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested has a
    /// return type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.returnType, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have return type '\(type)', found nil", file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested is variadic
    /// or not, depending on the value of the provided `isVariadic`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isVariadic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        return asserter(forKeyPath: \.parameterList, file: file, line: line) { parameterList -> Asserter<ObjcParameterListNode>? in
            return parameterList
                .assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .asserter(forKeyPath: \.variadicParameter) { (vParam) -> Asserter<Bool>? in
                    Asserter<Bool>(object: vParam.object != nil)
                        .assert(equals: isVariadic, file: file, line: line)
                }
        }
    }

    /// Asserts that the underlying `ObjcFunctionDefinitionNode` being tested has a
    /// parameter list with a specified count of parameters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertParameterCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.parameterList, file: file, line: line) {
            $0.assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .asserter(forKeyPath: \.parameters) { parameters in
                    parameters.assertCount(count, file: file, line: line)
                }
        }
    }

    /// Opens an asserter context for a specified parameter node index on the
    /// underlying `ObjcFunctionDefinitionNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcFunctionParameterNode>) -> Void
    ) -> Self? {

        guard let parameterList = object.parameterList else {
            XCTFail(
                "Expected function node '\(object.identifier?.name ?? "<nil>")' to have a parameter list.",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
        guard parameterList.parameters.count > index else {
            XCTFail(
                "Expected function node '\(object.identifier?.name ?? "<nil>")' to have at least \(index) parameter(s) but found \(parameterList.parameters.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: parameterList.parameters[index]))

        return self
    }
}

extension Asserter where Object == ObjcFunctionParameterNode {
    /// Asserts that the underlying `ObjcFunctionParameterNode` being tested has an
    /// identifier node with a specified `name` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(message: "Expected parameter to have identifier '\(name)', found nil", file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcFunctionParameterNode` being tested has no
    /// identifier node associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNil(message: "Expected parameter to have no identifier", file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcFunctionParameterNode` being tested has a
    /// type node with a specified `type` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: ObjcType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(message: "Expected parameter to have type '\(type)', found nil", file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }
}
