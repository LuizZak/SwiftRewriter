import Dispatch

@propertyDelegate
final class ConcurrentValue<T> {
    private var cacheBarrier =
        DispatchQueue(
            label: "com.swiftrewriter.concurrentvalue.valuebarrier_$\(T.self)",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil)
    
    private var _value: T
    
    var usingCache = false
    
    var value: T {
        get {
            return cacheBarrier.sync { _value }
        }
        set {
            cacheBarrier.sync(flags: .barrier, execute: { _value = newValue })
        }
    }
    
    init(value: T) {
        self._value = value
    }
    
    init(initialValue: T) {
        self._value = initialValue
    }
    
    @inlinable
    func readingValue<U>(_ block: (T) -> U) -> U {
        return cacheBarrier.sync { block(_value) }
    }
    
    @inlinable
    func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier, execute: { block(&_value) })
    }
    
    @inlinable
    func setAsCaching(value: T) {
        modifyingValue {
            $0 = value
            usingCache = true
        }
    }
    
    @inlinable
    func tearDownCaching(resetToValue value: T) {
        modifyingValue {
            $0 = value
            usingCache = false
        }
    }
}
