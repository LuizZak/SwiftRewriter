import XCTest
import GrammarModels

extension Asserter where Object: ASTNode {
    /// Asserts that the underlying `ASTNode` being tested has a specified count
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

extension Asserter where Object == Identifier {
    /// Asserts that the underlying `Identifier` being tested has the specified
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

        asserterConditional(forKeyPath: \.name, file: file, line: line) {
            $0.assert(equals: name, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == TypeNameNode {
    /// Asserts that the underlying `TypeNameNode` being tested has the specified
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

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assert(equals: type, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == InitialExpression {
    /// Asserts that the underlying `InitialExpression` being tested has a parser
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

        asserterConditional(
            forKeyPath: \.constantExpression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ConstantExpressionNode {
    /// Asserts that the underlying `ConstantExpressionNode` being tested has a
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

        asserterConditional(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == ExpressionNode {
    /// Asserts that the underlying `ExpressionNode` being tested has a
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

        asserterConditional(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(textEquals: expressionString, message: message(), file: file, line: line)
        }
    }
}

extension Asserter where Object == TypedefNode {
    /// Asserts that the underlying `TypedefNode` being tested has an identifier
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `TypedefNode` being tested has a type node
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

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Opens an asserter context for `BlockParametersNode` object within the
    /// underlying `TypedefNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForBlockParameters(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<BlockParametersNode>) -> Void
    ) -> Self? {

        asserterConditional(forKeyPath: \.blockParameters, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .inClosure(closure)
        }
    }

    /// Opens an asserter context for `ObjcStructDeclaration` object within the
    /// underlying `TypedefNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForStructDeclaration(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcStructDeclaration>) -> Void
    ) -> Self? {

        asserterConditional(forKeyPath: \.structDeclaration, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .inClosure(closure)
        }
    }

    /// Opens an asserter context for `[TypeDeclaratorNode]` object within the
    /// underlying `TypedefNode` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForTypeDeclarators(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<[TypeDeclaratorNode]>) -> Void
    ) -> Self? {

        asserterConditional(forKeyPath: \.typeDeclarators, file: file, line: line) {
            $0.inClosure(closure)
        }
    }
}

extension Asserter where Object == VariableDeclaration {
    /// Asserts that the underlying `VariableDeclaration` being tested has an
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `VariableDeclaration` being tested has a
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

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `VariableDeclaration` being tested has an
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

        asserterConditional(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `VariableDeclaration` being tested has no
    /// initial value expression associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoInitializer(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserterConditional(
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

extension Asserter where Object == ObjcStructDeclaration {
    /// Asserts that the underlying `ObjcStructDeclaration` being tested has an
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructDeclaration` being tested has a
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

        asserterConditional(forKeyPath: \.body?.children, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcStructDeclaration` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forFieldName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcStructField>) -> Void
    ) -> Self? {

        return asserterConditional(forKeyPath: \.body?.fields, file: file, line: line) { fields in
            fields
                .assertNotNil(file: file, line: line)?
                .asserterForFirstElement(
                    message: "Expected to find a field with name \(name) in struct declaration \(object.identifier?.name ?? "<nil>").",
                    file: file,
                    line: line
                ) { field in
                    field.identifier?.name == name
                }?.inClosure(closure)
        }
    }
}

extension Asserter where Object == ObjcStructField {
    /// Asserts that the underlying `ObjcStructField` being tested has an identifier
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructField` being tested has a type node
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

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcStructField` being tested has an
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

        asserterConditional(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcEnumDeclaration {
    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has an
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has a
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

        asserterConditional(forKeyPath: \.cases, file: file, line: line) {
            $0.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for the first field on the underlying
    /// `ObjcEnumDeclaration` object that matches a given name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forEnumeratorName name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ObjcEnumCase>) -> Void
    ) -> Self? {

        guard let field = object.cases.first(where: { $0.identifier?.name == name }) else {
            XCTFail(
                "Expected to find an enumerator with name \(name) in enum declaration \(object.identifier?.name ?? "<nil>").",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: field))

        return self
    }

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has a
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

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: typeName, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumDeclaration` being tested has no
    /// type name node specified.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoTypeName(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserterConditional(forKeyPath: \.type, file: file, line: line) {
            $0.assertNil(file: file, line: line)
        }
    }
}

extension Asserter where Object == ObjcEnumCase {
    /// Asserts that the underlying `ObjcEnumCase` being tested has an identifier
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

        asserterConditional(forKeyPath: \.identifier, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(name: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumCase` being tested has an
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

        asserterConditional(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ObjcEnumCase` being tested has no expression
    /// node associated with it.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNoExpression(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserterConditional(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNil(file: file, line: line)
        }
    }
}
