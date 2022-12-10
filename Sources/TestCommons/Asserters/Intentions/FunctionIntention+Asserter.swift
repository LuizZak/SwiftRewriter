import SwiftAST
import Intentions

public extension Asserter where Object: FunctionIntention {
    /// Opens an asserter context for the function body in the underlying
    /// `FunctionIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForFunctionBody<Result>(
        _ closure: (Asserter<FunctionBodyIntention?>) -> Result?
    ) -> Self? {
        
        return asserter(for: object.functionBody) { functionBody in
            functionBody.inClosure(closure)
        }.map(self)
    }

    /// Asserts that the underlying `FunctionIntention` being tested has a
    /// function body with a specified compound statement as its body statement.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        functionBody: CompoundStatement,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserterForFunctionBody { body in
            body.assertNotNil()?.assert(body: functionBody, file: file, line: line)
        }
    }
}

public extension Asserter where Object: ParameterizedFunctionIntention {
    /// Asserts that the underlying `ParameterizedFunctionIntention` being tested
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
    /// underlying `ParameterizedFunctionIntention` being tested.
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
        }.map(self)
    }
}

public extension Asserter where Object: SignatureFunctionIntention {
    /// Opens an asserter context for the function signature in the underlying
    /// `SignatureFunctionIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForSignature<Result>(
        _ closure: (Asserter<FunctionSignature>) -> Result?
    ) -> Self? {
        
        return asserter(for: object.signature) { signature in
            signature.inClosure(closure)
        }.map(self)
    }
    
    /// Asserts that the underlying `SignatureFunctionIntention` being tested
    /// has a specified signature value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        signature: FunctionSignature,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.signature) {
            $0.assert(equals: signature, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SignatureFunctionIntention` being tested
    /// has a signature name with a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.signature.name) {
            $0.assert(equals: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SignatureFunctionIntention` being tested has
    /// a specified `signature.returnType` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        returnType: SwiftType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.signature.returnType) {
            $0.assert(equals: returnType, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SignatureFunctionIntention` being tested has
    /// a specified `signature.isMutating` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isMutating: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.signature.isMutating) {
            $0.assert(equals: isMutating, file: file, line: line)
        }
    }

    /// Asserts that the underlying `SignatureFunctionIntention` being tested has
    /// a specified `signature.isStatic` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isStatic: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.signature.isStatic) {
            $0.assert(equals: isStatic, file: file, line: line)
        }
    }
}
