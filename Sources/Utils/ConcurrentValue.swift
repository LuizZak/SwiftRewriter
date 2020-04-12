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
