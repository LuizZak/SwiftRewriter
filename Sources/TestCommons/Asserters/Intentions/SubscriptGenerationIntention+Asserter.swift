import XCTest
import SwiftAST
import Intentions

public extension Asserter where Object: SubscriptGenerationIntention {
    /// Asserts that the underlying `SubscriptGenerationIntention` object being
    /// tested has a given list of parameters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        parameters: [ParameterSignature],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.parameters) {
            $0.assert(equals: parameters, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` object being
    /// tested has a given return type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType: SwiftType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.returnType) {
            $0.assert(equals: returnType, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` object being
    /// tested has a given `isConstant` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isConstant: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isConstant) {
            $0.assert(equals: isConstant, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// has a parameter list with a specified count of parameters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertParameterCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.parameters) { parameters in
            parameters.assertCount(count, file: file, line: line)
        }
    }

    /// Opens an asserter context for a specified parameter node index on the
    /// underlying `SubscriptGenerationIntention` being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forParameterAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ParameterSignature>) -> Result?
    ) -> Self? {

        guard object.parameters.count > index else {
            return assertFailed(
                message: #"asserter(forParameterAt: \#(index)) failed: parameter list has less than \#(index + 1) parameter(s)."#,
                file: file,
                line: line
            )
        }

        return asserter(for: object.parameters[index]) { param in
            param.inClosure(closure)
        }.mapAsserter(self)
    }
    
    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// has a specified compound statement as its getter `FunctionBodyIntention`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        getterBody: CompoundStatement,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.getter.body) {
            $0.assert(statementEquals: getterBody, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// has a setter with a specified compound statement as its body.
    ///
    /// Test fails if `setterBody` is non-nil and the subscript is not a
    /// `Mode.getterAndSetter`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        setterBody: CompoundStatement?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.setter?.body.body) {
            $0.assert(statementEquals: setterBody, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// has a specified `valueIdentifier` in a `Mode.getterAndSetter` storage mode.
    ///
    /// Test fails if `setterValueIdentifier` is non-nil and the subscript is not
    /// a `Mode.getterAndSetter`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        setterValueIdentifier: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.setter?.valueIdentifier) {
            $0.assert(equals: setterValueIdentifier, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// is configured with a getter only.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsGetterOnly(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        assertTrue(
            message: "assertIsGetterOnly failed: Expected subscript to be getter-only.",
            file: file,
            line: line
        ) { sub in
            sub.mode.isGetterOnly
        }
    }

    /// Asserts that the underlying `SubscriptGenerationIntention` being tested
    /// is configured with a getter and a setter.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsGetterAndSetter(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        assertTrue(
            message: "assertIsGetterAndSetter failed: Expected subscript to feature a getter and a setter.",
            file: file,
            line: line
        ) { prop in
            prop.mode.isGetterAndSetter
        }
    }
}
