import Dispatch

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
    public init(initialValue: T) {
        lock = pthread_rwlock_t()
        pthread_rwlock_init(&lock, nil)

        self._value = initialValue
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }

    @inlinable
    public func readingValue<U>(_ block: (T) -> U) -> U {
        block(wrappedValue)
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
        modifyingValue {
            $0 = value
            usingCache = true
        }
    }

    @inlinable
    public func tearDownCaching(resetToValue value: T) {
        modifyingValue {
            $0 = value
            usingCache = false
        }
    }
}
