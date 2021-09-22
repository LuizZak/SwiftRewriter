@propertyWrapper
public final class ConcurrentValue<T> {
    @usableFromInline
    var _lock: ReadWriteLock

    @usableFromInline
    var _value: T

    public var usingCache = false

    @inlinable
    public var wrappedValue: T {
        get {
            _lock.lockingForRead { _value }
        }
        _modify {
            var l = _lock.lockForWrite()
            yield &_value
            l.unlock()
        }
    }
    
    @inlinable
    public var projectedValue: T {
        get {
            _lock.lockingForRead { _value }
        }
        _modify {
            var l = _lock.lockForWrite()
            yield &_value
            l.unlock()
        }
    }

    @inlinable
    public init(wrappedValue: T) {
        _lock = ReadWriteLock()

        self._value = wrappedValue
    }

    @inlinable
    public func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        return _lock.lockingForWrite {
            block(&_value)
        }
    }

    @inlinable
    public func setAsCaching(value: T) {
        _lock.lockingForWrite {
            _value = value
            usingCache = true
        }
    }

    @inlinable
    public func tearDownCaching(resetToValue value: T) {
        _lock.lockingForWrite {
            _value = value
            usingCache = false
        }
    }
}
