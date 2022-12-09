import XCTest
import SwiftAST
import Intentions

public extension Asserter where Object: PropertyGenerationIntention {

    /// Opens an asserter context for the `initialValue` in the underlying
    /// `PropertyGenerationIntention` object being tested.
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
    
    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// has a specified `isOverride` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isOverride: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.isOverride) {
            $0.assert(equals: isOverride, file: file, line: line)
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// has a specified compound statement as its computed or property-based
    /// getter `FunctionBodyIntention`.
    ///
    /// Test fails if `getterBody` is non-nil and the property is not a
    /// `Mode.computed` or `Mode.property` property.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        getterBody: CompoundStatement?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.getter?.body) {
            $0.assert(equals: getterBody, file: file, line: line)
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// has a specified compound statement as its property-based setter
    /// `FunctionBodyIntention`.
    ///
    /// Test fails if `setterBody` is non-nil and the property is not a
    /// `Mode.property` property.
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
            $0.assert(equals: setterBody, file: file, line: line)
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// has a specified `setterAccessLevel` value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        setterAccessLevel: AccessLevel?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        asserter(forKeyPath: \.setterAccessLevel) {
            $0.assert(equals: setterAccessLevel, file: file, line: line)
        }
    }
}
