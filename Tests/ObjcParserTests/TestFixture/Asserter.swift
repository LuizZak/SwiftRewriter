import XCTest

/// Scaffolding object used by test fixtures to create DSL testing utilities
/// for common testing procedures.
struct Asserter<Object> {
    /// The object that is being tested upon.
    var object: Object

    func dumpObject(maxDepth: Int = 3) {
        var buffer = ""
        dump(object, to: &buffer, maxDepth: maxDepth)

        print("Result state: \(buffer)")
    }
}

// MARK: - Standard library assertion extensions

extension Asserter {
    /// Asserts that the underlying object being tested can be casted to `T`.
    ///
    /// Returns `nil` if the test failed, otherwise returns an `Asserter<T>` for
    /// chaining further tests on the type-casted value.
    @discardableResult
    func assert<T>(
        isOfType type: T.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<T>? {

        guard let value = object as? T else {
            XCTFail(
                "Expected object to be type-castable to \(T.self).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return .init(object: value)
    }

    /// Asserts that the underlying `Optional<T>` object being tested is `nil`.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertNil<T>(
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? where Object == T? {

        guard object == nil else {
            XCTAssertNil(object, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }

    /// Asserts that the underlying `Optional<T>` object being tested is not
    /// `nil`.
    ///
    /// Returns `nil` if the test failed, otherwise returns an `Asserter<T>` for
    /// chaining further tests on the unwrapped value.
    @discardableResult
    func assertNotNil<T>(
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<T>? where Object == T? {

        guard let value = object else {
            XCTAssertNotNil(object, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return .init(object: value)
    }

    /// Opens an asserter context for a specified keypath into the underlying
    /// object being tested.
    ///
    /// Returns `self` for chaining.
    @discardableResult
    func asserter<Value>(
        forKeyPath keyPath: KeyPath<Object, Value>,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Value>) -> Void
    ) -> Self? {

        let value = object[keyPath: keyPath]

        closure(.init(object: value))

        return self
    }
}

extension Asserter where Object: Equatable {
    /// Asserts that the underlying `Equatable` object being tested tests true
    /// under equality against a given instance of the same type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        equals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object == expected else {
            XCTAssertEqual(object, expected, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }
    
    /// Asserts that the underlying `Equatable` object being tested tests false
    /// under equality against a given instance of the same type.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assert(
        notEquals expected: Object,
        message: @autoclosure () -> String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object != expected else {
            XCTAssertNotEqual(object, expected, message(), file: file, line: line)
            dumpObject()

            return nil
        }

        return self
    }
}

extension Asserter where Object: Collection, Object.Index == Int {
    /// Asserts that the underlying `Collection` being tested has a specified
    /// count of elements.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertCount(
        _ count: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.count == count else {
            XCTFail(
                "Expected collection to have \(count) item(s) but found \(object.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        return self
    }

    /// Opens an asserter context for a child node on the underlying `Collection`
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter(
        forItemAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Object.Element>) -> Void
    ) -> Self? {

        guard object.count > index else {
            XCTFail(
                "Expected collection to have at least \(index) item(s) but found \(object.count).",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }

        closure(.init(object: object[index]))

        return self
    }
}

extension Asserter where Object: Sequence {
    /// Creates a new leaf testing asserter for testing the iterator of the
    /// underlying `Sequence` being tested.
    ///
    /// Returns `Asserter<Object.Iterator>` for chaining further tests.
    @discardableResult
    func asserterForIterator(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Asserter<Object.Iterator> {

        let iterator = object.makeIterator()

        return .init(object: iterator)
    }
}

extension Asserter where Object: IteratorProtocol {
    /// Opens an asserter context for the next item emitted by the underlying
    /// `IteratorProtocol` being tested.
    ///
    /// Returns `nil` if the end of the iterator has been reached already,
    /// otherwise returns a `self` copy with the mutated iterator for chaining
    /// further tests.
    @discardableResult
    func asserterForNext(
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Object.Element>) -> Void
    ) -> Self? {

        var iterator = object
        let next = iterator.next()
        guard let next = next else {
            XCTAssertNotNil(next, file: file, line: line)
            dumpObject()

            return nil
        }

        closure(.init(object: next))

        return .init(object: iterator)
    }

    /// Asserts that the underlying `IteratorProtocol` being tested returns no
    /// further items.
    ///
    /// Returns `nil` if the end of the iterator has not been reached yet,
    /// otherwise returns `self` for chaining further tests.
    @discardableResult
    func assertIsAtEnd(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        var iterator = object
        if let next = iterator.next() {
            XCTAssertNil(
                next,
                "Expected iterator to be at end, but found more elements",
                file: file,
                line: line
            )
            dumpObject()

            return nil
        }
        
        return self
    }
}
