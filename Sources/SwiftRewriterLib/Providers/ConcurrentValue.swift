import Dispatch

class ConcurrentValue<T> {
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
    
    func readingValue<U>(_ block: (T?) -> U) -> U {
        return readingState { block($0.value) }
    }
    
    func readingState<U>(_ block: (CacheState) -> U) -> U {
        return cacheBarrier.sync {
            block(state)
        }
    }
    
    func modifyingValue<U>(_ block: (inout T?) -> U) -> U {
        return modifyingState { block(&$0.value) }
    }
    
    func modifyingState<U>(_ block: (inout CacheState) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier) {
            block(&state)
        }
    }
    
    func tearDown() {
        modifyingState { state in
            state.value = nil
            usingCache = false
        }
    }
}
