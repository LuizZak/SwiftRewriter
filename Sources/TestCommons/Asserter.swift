import XCTest

/// Scaffolding object used by test fixtures to create DSL testing utilities
/// for common testing procedures.
// @dynamicMemberLookup
public struct Asserter<Object> {
    /// The object that is being tested upon.
    public var object: Object

    /// Shortcut for creating an asserter for a specified keypath on the underlying
    /// object being tested.
    public subscript<Value>(member: KeyPath<Object, Value>) -> Asserter<Value> {
        .init(object: object[keyPath: member])
    }
    /*
    public subscript<Value>(dynamicMember dynamicMember: KeyPath<Object, Value>) -> Asserter<Value> {
        .init(object: object[keyPath: dynamicMember])
    }
    */

    public init(object: Object) {
        self.object = object
    }

    /// Dumps `object` to the stdout.
    public func dumpObject(maxDepth: Int = 3) {
        var buffer = ""
        dump(object, to: &buffer, maxDepth: maxDepth)

        print("Result state: \(buffer)")
    }

    /// Invokes a given closure with this asserter as an argument, using the
    /// optional return type of the closure to decide whether to return `self`
    /// for further test chaining.
    ///
    /// Returns `nil` if `closure` returns `nil`, otherwise returns `self` for
    /// chaining further tests.
    public func inClosure<Return>(_ closure: (Self) -> Return?) -> Self? {
        if closure(self) == nil {
            return nil
        }

        return self
    }

    /// Invokes a given closure with this asserter as an argument.
    ///
    /// Returns `self` for further chaining.
    @discardableResult
    public func inClosureUnconditional(_ closure: (Self) -> Void) -> Self {
        closure(self)

        return self
    }

    /// Raises an unconditional test assertion failure.
    /// Always returns `nil`.
    @discardableResult
    public func assertFailed<Result>(
        message: String = "",
        file: StaticString,
        line: UInt
    ) -> Result? {

        XCTFail(message.trimmingWhitespace(), file: file, line: line)
        dumpObject()

        return nil
    }

    /// Raises an unconditional test assertion failure.
    public func assertFailed(
        message: String = "",
        file: StaticString,
        line: UInt
    ) {
        // 'Int?' so an error is raised if the compiler picks this function as
        // the overload for this statement instead of the function above as
        // intended.
        let _: Int? = assertFailed(message: message, file: file, line: line)
    }

    /// Creates a new assertion context for another object, using a closure to
    /// perform the assertions.
    ///
    /// Returns the result of the closure for further chaining tests.
    @discardableResult
    public func asserter<T, Result>(
        for newObject: T,
        _ closure: (Asserter<T>) -> Result?
    ) -> Result? {

        closure(.init(object: newObject))
    }

    /// Asserts that a specified predicate returns `true` when applied to the
    /// current object being tested.
    ///
    /// Returns `nil` if `predicate` returns `false`, otherwise returns `self`
    /// for further chaining tests.
    @discardableResult
    public func assertTrue(
        file: StaticString = #file,
        line: UInt = #line,
        _ predicate: (Object) -> Bool
    ) -> Self? {

        guard predicate(object) else {
            return assertFailed(
                message: "assertTrue failed.",
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Optional {
    /// Maps the optional result of an asserter into a separate asserter,
    /// mirroring the optionality of the result into `newAsserter`.
    ///
    /// Can be used to replace result types of assertion calls with other asserters
    /// that are type-compatible with a certain object type.
    func map<TOld, TNew>(
        _ newAsserter: Asserter<TNew>
    ) -> Asserter<TNew>? where Wrapped == Asserter<TOld>? {

        switch self {
        case .some:
            return newAsserter
        case .none:
            return nil
        }
    }
}

// MARK: - Universal assertion extensions

public extension Asserter {
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

        assertFailed(file: file, line: line)

        guard let value = object as? T else {
            return assertFailed(
                message: "Expected object \(object) of type \(Swift.type(of: object)) to be type-castable to \(T.self).",
                file: file,
                line: line
            )
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

        if let object {
            return assertFailed(
                message: "assertNil failed: \(object) != nil. \(message())",
                file: file,
                line: line
            )
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
            return assertFailed(
                message: "assertNotNil failed. \(message())".trimmingWhitespace(),
                file: file,
                line: line
            )
        }

        return .init(object: value)
    }

    /// Opens an asserter context for a specified keypath into the underlying
    /// object being tested, with a closure with an optional return type that
    /// can stop propagation of further tests from this asserter's level.
    ///
    /// Returns `nil` if `closure` returns `nil`, otherwise returns `self` for
    /// chaining further tests.
    ///
    /// - seealso: `asserterUnconditional(forKeyPath:file:line:)`
    @discardableResult
    func asserter<Value, Return>(
        forKeyPath keyPath: KeyPath<Object, Value>,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Value>) -> Return?
    ) -> Self? {

        let value = object[keyPath: keyPath]

        if Asserter<Value>(object: value).inClosure(closure) == nil {
            return nil
        }

        return self
    }

    /// Opens an asserter context for a specified keypath into the underlying
    /// object being tested, with a closure that does not stop propagation of
    /// tests by way of the closure's return value.
    ///
    /// Returns `self` for chaining further tests.
    ///
    /// - seealso: `asserter(forKeyPath:file:line:)`
    @discardableResult
    func asserterUnconditional<Value>(
        forKeyPath keyPath: KeyPath<Object, Value>,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Value>) -> Void
    ) -> Self {

        let value = object[keyPath: keyPath]

        Asserter<Value>(object: value)
            .inClosureUnconditional(closure)

        return self
    }
}

// MARK: - Standard library assertion extensions

public extension Asserter where Object: Equatable {
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
            return assertFailed(
                message: #"assert(equals:) failed: ("\#(object)") != ("\#(expected)"). \#(message())"#,
                file: file,
                line: line
            )
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

public extension Asserter where Object == Bool {
    /// Asserts that the underlying `Bool` being tested is true.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsTrue(
        message: @autoclosure () -> String = "\(#function): Expected value to be true",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object else {
            return assertFailed(
                message: "assertIsTrue failed. \(message())",
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `Bool` being tested is false.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsFalse(
        message: @autoclosure () -> String = "\(#function): Expected value to be false",
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard !object else {
            return assertFailed(
                message: "assertIsFalse failed. \(message())",
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter where Object: Sequence {
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

    /// Creates a new leaf testing asserter for the first element within the
    /// underlying `Sequence` being tested that passes a given predicate.
    ///
    /// Returns `nil` if the test failed with no passing items, otherwise returns
    /// `Asserter<Object.Element>` for chaining further tests.
    @discardableResult
    func asserterForFirstElement(
        message: @autoclosure () -> String = "No element in sequence passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        where predicate: (Object.Element) -> Bool
    ) -> Asserter<Object.Element>? {

        for element in object {
            if predicate(element) {
                return .init(object: element)
            }
        }

        return assertFailed(
            message: "asserterForFirstElement failed. \(message())",
            file: file,
            line: line
        )
    }

    /// Asserts that the underlying `Sequence` being tested contains at least one
    /// element that passes the given predicate.
    ///
    /// Returns `nil` if the test failed with no passing items, otherwise returns
    /// `self` for chaining further tests.
    @discardableResult
    func assertContains(
        message: @autoclosure () -> String = "No element in sequence passed the provided predicate.",
        file: StaticString = #file,
        line: UInt = #line,
        where predicate: (Object.Element) -> Bool
    ) -> Self? {

        for element in object {
            if predicate(element) {
                return self
            }
        }

        return assertFailed(
            message: "assertContains failed. \(message())",
            file: file,
            line: line
        )
    }
}

public extension Asserter where Object: IteratorProtocol {
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
            return assertFailed(
                message: "asserterForNext failed: unexpected nil value.",
                file: file,
                line: line
            )
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
            return assertFailed(
                message: #"assertIsAtEnd failed: unexpected non-nil value: ("\#(next)")."#,
                file: file,
                line: line
            )
        }
        
        return self
    }
}

public extension Asserter where Object: Collection {
    /// Asserts that the underlying `Collection` being tested is empty.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsEmpty(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard object.isEmpty else {
            return assertFailed(
                message: #"assertIsEmpty failed: found \#(object.count) item(s)."#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Asserts that the underlying `Collection` being tested is not empty.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func assertIsNotEmpty(
        file: StaticString = #file,
        line: UInt = #line
    ) -> Self? {

        guard !object.isEmpty else {
            return assertFailed(
                message: #"assertIsNotEmpty failed."#,
                file: file,
                line: line
            )
        }

        return self
    }
}

public extension Asserter where Object: Collection, Object.Index == Int {
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
            return assertFailed(
                message: #"assertCount failed: expected \#(count) found \#(object.count)."#,
                file: file,
                line: line
            )
        }

        return self
    }

    /// Opens an asserter context for a child node on the underlying `Collection`
    /// being tested.
    ///
    /// Returns `nil` if the test failed, otherwise returns `self` for chaining
    /// further tests.
    @discardableResult
    func asserter<Result>(
        forItemAt index: Int,
        file: StaticString = #file,
        line: UInt = #line,
        _ closure: (Asserter<Object.Element>) -> Result?
    ) -> Self? {

        guard object.count > index else {
            return assertFailed(
                message: #"asserter(forItemAt: \#(index)) failed: collection has less than \#(index + 1) item(s)."#,
                file: file,
                line: line
            )
        }

        guard closure(.init(object: object[index])) != nil else {
            return nil
        }

        return self
    }
}
