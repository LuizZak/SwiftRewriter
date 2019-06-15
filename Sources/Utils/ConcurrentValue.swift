import Dispatch

@propertyDelegate
public final class ConcurrentValue<T> {
    @usableFromInline
    var cacheBarrier =
        DispatchQueue(
            label: "com.swiftrewriter.concurrentvalue.valuebarrier_$\(T.self)",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil)
    
    @usableFromInline
    var _value: T
    
    public var usingCache = false
    
    @inlinable
    public var value: T {
        get {
            return cacheBarrier.sync { _value }
        }
    }
    
    @inlinable
    public init(value: T) {
        self._value = value
    }
    
    @inlinable
    public init(initialValue: T) {
        self._value = initialValue
    }
    
    @inlinable
    public func readingValue<U>(_ block: (T) -> U) -> U {
        return cacheBarrier.sync { block(_value) }
    }
    
    @inlinable
    public func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier, execute: { block(&_value) })
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
