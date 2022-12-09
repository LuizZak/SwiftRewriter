import SwiftAST

public extension Asserter where Object == ParameterSignature {
    /// Asserts that the underlying `ParameterSignature` being tested has a
    /// specified label.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        label: String?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.label) {
            $0.assert(equals: label, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ParameterSignature` being tested has a
    /// specified name.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        name: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.name) {
            $0.assert(equals: name, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ParameterSignature` being tested has a
    /// specified type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        type: SwiftType,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.type) {
            $0.assert(equals: type, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ParameterSignature` being tested has a
    /// specified `hasDefaultValue` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        hasDefaultValue: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.hasDefaultValue) {
            $0.assert(equals: hasDefaultValue, file: file, line: line)
        }
    }
}
