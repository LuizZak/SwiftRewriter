#if os(Linux)
import Glibc
#elseif os(macOS)
import Darwin
#endif

@propertyWrapper
public final class ConcurrentValue<T> {
    @usableFromInline
    var lock: pthread_rwlock_t

    @usableFromInline
    var _value: T

    public var usingCache = false

    @inlinable
    public var wrappedValue: T {
        get {
            pthread_rwlock_rdlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            return _value
        }
        _modify {
            pthread_rwlock_wrlock(&lock)
            yield &_value
            pthread_rwlock_unlock(&lock)
        }
    }
    
    @inlinable
    public var projectedValue: T {
        get {
            pthread_rwlock_rdlock(&lock)
            defer {
                pthread_rwlock_unlock(&lock)
            }
            return _value
        }
        _modify {
            pthread_rwlock_wrlock(&lock)
            yield &_value
            pthread_rwlock_unlock(&lock)
        }
    }

    @inlinable
    public init(wrappedValue: T) {
        lock = pthread_rwlock_t()
        pthread_rwlock_init(&lock, nil)

        self._value = wrappedValue
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }

    /// Performs a given block with exclusive access to the underlying value,
    /// awaiting for current read operations to end, and blocking the access of
    /// the value until the access ends.
    @inlinable
    public func withExclusiveAccess<U>(_ block: (T) -> U) -> U {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }

        return block(_value)
    }

    @inlinable
    public func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        pthread_rwlock_wrlock(&lock)
        defer {
            pthread_rwlock_unlock(&lock)
        }

        return block(&_value)
    }

    @inlinable
    public func setAsCaching(value: T) {
        pthread_rwlock_wrlock(&lock)
        _value = value
        usingCache = true
        pthread_rwlock_unlock(&lock)
    }

    @inlinable
    public func tearDownCaching(resetToValue value: T) {
        pthread_rwlock_wrlock(&lock)
        _value = value
        usingCache = false
        pthread_rwlock_unlock(&lock)
    }
}

public extension ConcurrentValue where T == Int {
    /// Performs an increment of the underlying concurrent value, returning it's
    /// value after it was incremented, similar to C's `++i`.
    @inlinable
    func prefixIncrement() -> Int {
        modifyingValue({ $0 += 1; return $0 })
    }

    /// Performs an increment of the underlying concurrent value, returning it's
    /// value before it was incremented, similar to C's `i++`.
    @inlinable
    func postfixIncrement() -> Int {
        modifyingValue({ v in defer { v += 1 }; return v })
    }
}

public extension ConcurrentValue {
    /// Sets the underlying concurrent value to be a given value, but only if
    /// it's storage is currently `nil`.
    func setIfNil<Wrapped>(_ value: Wrapped) where T == Optional<Wrapped> {
        modifyingValue {
            if $0 == nil {
                $0 = value
            }
        }
    }
}
