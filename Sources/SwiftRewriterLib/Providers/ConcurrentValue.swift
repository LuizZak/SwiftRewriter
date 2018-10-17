import Dispatch

final class ConcurrentValue<T> {
    struct CacheState {
        var value: T?
    }
    
    private var cacheBarrier =
        DispatchQueue(
            label: "com.swiftrewriter.compoundtypeprovider.barriervalue_$\(T.self)",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil)
    
    var usingCache = false
    
    private var state = CacheState()
    
    @inlinable
    func readingValue<U>(_ block: (T?) -> U) -> U {
        return readingState { block($0.value) }
    }
    
    @inlinable
    func readingState<U>(_ block: (CacheState) -> U) -> U {
        return cacheBarrier.sync {
            block(state)
        }
    }
    
    @inlinable
    func modifyingValue<U>(_ block: (inout T?) -> U) -> U {
        return modifyingState { block(&$0.value) }
    }
    
    @inlinable
    func modifyingState<U>(_ block: (inout CacheState) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier) {
            block(&state)
        }
    }
    
    @inlinable
    func tearDown() {
        modifyingState { state in
            state.value = nil
            usingCache = false
        }
    }
}
