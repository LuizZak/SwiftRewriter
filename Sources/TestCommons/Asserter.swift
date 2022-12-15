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
        message: String = "assertFailed",
        file: StaticString,
        line: UInt
    ) -> Result? {

        XCTFail(message.trimmingWhitespace(), file: file, line: line)
        dumpObject()

        return nil
    }

    /// Raises an unconditional test assertion failure.
    public func assertFailed(
        message: String = "assertFailed",
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
        message: @autoclosure () -> String = "assertTrue failed.",
        file: StaticString = #file,
        line: UInt = #line,
        _ predicate: (Object) -> Bool
    ) -> Self? {

        guard predicate(object) else {
            return assertFailed(
                message: message(),
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
    /// that are type-compatible with a certain object type, allowing them to be
    /// used as a return value for a differently typed function or closure.
    func mapAsserter<TOld, TNew>(
        _ newAsserter: Asserter<TNew>
    ) -> Asserter<TNew>? where Wrapped == Asserter<TOld> {

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
