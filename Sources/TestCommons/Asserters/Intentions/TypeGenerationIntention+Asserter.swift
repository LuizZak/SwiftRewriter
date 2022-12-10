import XCTest
import SwiftAST
import Intentions
import KnownType

public extension Asserter where Object: TypeGenerationIntention {
    /// Asserts that the underlying `TypeGenerationIntention` object being tested
    /// has a type name of a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        typeName: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.typeName) {
            $0.assert(equals: typeName, file: file, line: line)
        }
    }

    /// Asserts that the underlying `TypeGenerationIntention` object being tested
    /// has its `isExtension` property be a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        isExtension: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.isExtension) {
            $0.assert(equals: isExtension, file: file, line: line)
        }
    }

    /// Asserts that the underlying `TypeGenerationIntention` object being tested
    /// has its `supertype` property be a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        supertype: KnownTypeReference?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.supertype) {
            $0.assert(equals: supertype, file: file, line: line)
        }
    }

    /// Opens an asserter context a method on a specified index in the `methods`
    /// property of the underlying `TypeGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forMethodAtIndex index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<MethodGenerationIntention>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.methods) {
            $0.asserter(forItemAt: index, file: file, line: line, closure)
        }
    }

    /// Opens an asserter context a property on a specified index in the `properties`
    /// property of the underlying `TypeGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forPropertyAtIndex index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<PropertyGenerationIntention>) -> Result?
    ) -> Self? {

        asserter(forKeyPath: \.properties) {
            $0.asserter(forItemAt: index, file: file, line: line, closure)
        }
    }
}
