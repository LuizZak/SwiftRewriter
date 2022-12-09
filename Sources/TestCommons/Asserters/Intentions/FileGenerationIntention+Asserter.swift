import XCTest
import Intentions

public extension Asserter where Object == FileGenerationIntention {
    /// Opens an asserter context for the list of type intentions in the
    /// underlying `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForTypes<Result>(
        _ closure: (Asserter<[TypeGenerationIntention]>) -> Result?
    ) -> Self? {
        
        asserter(forKeyPath: \.typeIntentions) {
            $0.inClosure(closure)
        }
    }

    /// Opens an asserter context for the list of type alias generation intentions
    /// in the underlying `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForTypealiases<Result>(
        _ closure: (Asserter<[TypealiasIntention]>) -> Result?
    ) -> Self? {
        
        asserter(forKeyPath: \.typealiasIntentions) {
            $0.inClosure(closure)
        }
    }

    /// Opens an asserter context for the list of global function generation
    /// intentions in the underlying `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForGlobalFunctions<Result>(
        _ closure: (Asserter<[GlobalFunctionGenerationIntention]>) -> Result?
    ) -> Self? {
        
        asserter(forKeyPath: \.globalFunctionIntentions) {
            $0.inClosure(closure)
        }
    }

    /// Opens an asserter context for the list of global variable generation
    /// intentions in the underlying `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserterForGlobalVariables<Result>(
        _ closure: (Asserter<[GlobalVariableGenerationIntention]>) -> Result?
    ) -> Self? {
        
        asserter(forKeyPath: \.globalVariableIntentions) {
            $0.inClosure(closure)
        }
    }

    /// Asserts that the underlying `FileGenerationIntention` object being tested
    /// has a source path property of a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        sourcePath: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.sourcePath, file: file, line: line) {
            $0.assert(equals: sourcePath, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FileGenerationIntention` object being tested
    /// has a target path property of a specified value.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        targetPath: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.targetPath, file: file, line: line) {
            $0.assert(equals: targetPath, file: file, line: line)
        }
    }

    /// Asserts that the underlying `FileGenerationIntention` object being tested
    /// has a `preprocessorDirectives` with `string` values that match a specified
    /// array of strings, in order.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        preprocessorDirectives: [String],
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        asserter(forKeyPath: \.preprocessorDirectives, file: file, line: line) {
            asserter(for: $0.object.map(\.string)) { actual in
                actual.assert(
                    equals: preprocessorDirectives,
                    file: file,
                    line: line
                )
            }
        }
    }

    /// Opens an asserter context for a type with a given name in the underlying
    /// `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forTypeNamed typeName: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<TypeGenerationIntention>) -> Result?
    ) -> Self? {
        
        asserterForTypes { types in
            types.asserterForFirstElement(
                message: #"Could not find type with name "\#(typeName)""#,
                file: file,
                line: line
            ) {
                $0.typeName == typeName
            }?.inClosure(closure)
        }
    }

    /// Opens an asserter context for a class with a given name in the underlying
    /// `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forClassNamed typeName: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<ClassGenerationIntention>) -> Result?
    ) -> Self? {
        
        asserter(for: object.classIntentions) { types in
            types.asserterForFirstElement(
                message: #"Could not find class with name "\#(typeName)""#,
                file: file,
                line: line
            ) {
                $0.typeName == typeName
            }?.inClosure(closure)
        }.map(self)
    }

    /// Opens an asserter context for a global function with a given name in the
    /// underlying `FileGenerationIntention` object being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forGlobalFunctionNamed name: String,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<GlobalFunctionGenerationIntention>) -> Result?
    ) -> Self? {

        asserter(for: object.globalFunctionIntentions) { types in
            types.asserterForFirstElement(
                message: #"Could not find class with name "\#(name)""#,
                file: file,
                line: line
            ) {
                $0.name == name
            }?.inClosure(closure)
        }.map(self)
    }
}
