import SwiftAST
import Intentions

public extension Asserter where Object: ValueStorageIntention {
    /// Opens an asserter context for the `initialValue` in the underlying
    /// `ValueStorageIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForInitialValue<Result>(
        _ closure: (Asserter<Expression?>) -> Result?
    ) -> Self? {
        
        return asserter(for: object.initialValue) { signature in
            signature.inClosure(closure)
        }.map(self)
    }
    
    /// Asserts that the underlying `ValueStorageIntention` being tested has a 
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

    /// Asserts that the underlying `ValueStorageIntention` being tested has a 
    /// specified storage value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        storage: ValueStorage,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.storage) {
            $0.assert(equals: storage, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ValueStorageIntention` being tested has a
    /// specified `initialValue` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        initialValue: Expression?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.initialValue) {
            $0.assert(equals: initialValue, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ValueStorageIntention` being tested has a
    /// specified `storage.type` value.
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

    /// Asserts that the underlying `ValueStorageIntention` being tested has a
    /// specified `storage.ownership` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        ownership: Ownership,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.ownership) {
            $0.assert(equals: ownership, file: file, line: line)
        }
    }

    /// Asserts that the underlying `ValueStorageIntention` being tested has a
    /// specified `storage.isConstant` value.
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
}
