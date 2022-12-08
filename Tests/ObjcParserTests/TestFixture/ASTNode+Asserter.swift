import XCTest
import GrammarModels

extension Asserter where Object: ASTNode {
    /// Asserts that the underlying `ASTNode` being tested has a specified
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

        asserter(forKeyPath: \.name, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
            $0.assertNotNil(file: file, line: line)?
                .assert(type: type, file: file, line: line)
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
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

        asserter(
            forKeyPath: \.initialExpression,
            file: file,
            line: line
        ) {
            $0.assertNotNil(file: file, line: line)?
                .assert(expressionString: expressionString, file: file, line: line)
        }
    }

    /// Asserts that the underlying `VariableDeclaration` being tested has a
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(forKeyPath: \.body?.children, file: file, line: line) {
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(forKeyPath: \.cases, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
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

        asserter(forKeyPath: \.type, file: file, line: line) {
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

        asserter(forKeyPath: \.identifier, file: file, line: line) {
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

        asserter(
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

        asserter(
            forKeyPath: \.expression,
            file: file,
            line: line
        ) {
            $0.assertNil(file: file, line: line)
        }
    }
}

extension Asserter where Object == FunctionDefinition {
    /// Asserts that the underlying `FunctionDefinition` being tested has an
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

    /// Asserts that the underlying `FunctionDefinition` being tested has a
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

    /// Asserts that the underlying `FunctionDefinition` being tested is variadic
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

        return asserter(forKeyPath: \.parameterList, file: file, line: line) { parameterList -> Asserter<ParameterList>? in
            return parameterList
                .assertNotNil(message: "Expected function to have parameter list, found nil", file: file, line: line)?
                .asserter(forKeyPath: \.variadicParameter) { (vParam) -> Asserter<Bool>? in
                    Asserter<Bool>(object: vParam.object != nil)
                        .assert(equals: isVariadic, file: file, line: line)
                }
        }
    }

    /// Asserts that the underlying `FunctionDefinition` being tested has a
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
    /// underlying `FunctionDefinition` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<FunctionParameter>) -> Void
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

extension Asserter where Object == FunctionParameter {
    /// Asserts that the underlying `FunctionParameter` being tested has an
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

    /// Asserts that the underlying `FunctionParameter` being tested has no
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

    /// Asserts that the underlying `FunctionParameter` being tested has a
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
