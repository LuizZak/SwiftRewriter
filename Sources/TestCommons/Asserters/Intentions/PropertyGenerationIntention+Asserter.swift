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
            $0.assert(statementEquals: getterBody, file: file, line: line)
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
            $0.assert(statementEquals: setterBody, file: file, line: line)
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// has a specified `valueIdentifier` in a `Mode.property` storage mode.
    ///
    /// Test fails if `setterValueIdentifier` is non-nil and the property is not
    /// a `Mode.property` property.
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

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// is configured to be a value storage property with no getters or setters.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsStoredFieldMode(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        assertTrue(
            message: "assertIsStoredFieldMode failed: Expected property \(object.name) to be a field.",
            file: file,
            line: line
        ) { prop in
            prop.mode.isField
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// is configured to be a computed property with just a getter.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsComputedMode(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        assertTrue(
            message: "assertIsComputedMode failed: Expected property \(object.name) to be a computed property.",
            file: file,
            line: line
        ) { prop in
            prop.mode.isComputed
        }
    }

    /// Asserts that the underlying `PropertyGenerationIntention` being tested
    /// is configured to be a computed property with getter and setter bodies.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsPropertyMode(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {
        
        assertTrue(
            message: "assertIsPropertyMode failed: Expected property \(object.name) to be a getter/setter property.",
            file: file,
            line: line
        ) { prop in
            prop.mode.isProperty
        }
    }
}
