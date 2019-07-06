import Dispatch

final class ConcurrentValue<T> {
    private var cacheBarrier =
        DispatchQueue(
            label: "com.swiftrewriter.concurrentvalue.valuebarrier_$\(T.self)",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil)
    
    var usingCache = false
    
    private var value: T
    
    init(value: T) {
        self.value = value
    }
    
    @inlinable
    func readingValue<U>(_ block: (T) -> U) -> U {
        return cacheBarrier.sync { block(value) }
    }
    
    @inlinable
    func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier) {
            block(&value)
        }
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
