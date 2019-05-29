import Dispatch

final class ConcurrentValue<T> {
    struct CacheState {
        var value: T
    }
    
    private var cacheBarrier =
        DispatchQueue(
            label: "com.swiftrewriter.concurrentvalue.valuebarrier_$\(T.self)",
            qos: .default,
            attributes: .concurrent,
            autoreleaseFrequency: .inherit,
            target: nil)
    
    var usingCache = false
    
    private var state: CacheState
    
    init(value: T) {
        state = CacheState(value: value)
    }
    
    @inlinable
    func readingValue<U>(_ block: (T) -> U) -> U {
        return readingState { block($0.value) }
    }
    
    @inlinable
    func readingState<U>(_ block: (CacheState) -> U) -> U {
        return cacheBarrier.sync {
            block(state)
        }
    }
    
    @inlinable
    func modifyingValue<U>(_ block: (inout T) -> U) -> U {
        return modifyingState { block(&$0.value) }
    }
    
    @inlinable
    func modifyingValueAsync(_ block: @escaping (inout T) -> Void) -> Void {
        modifyingState { block(&$0.value) }
    }
    
    @inlinable
    func modifyingState<U>(_ block: (inout CacheState) -> U) -> U {
        return cacheBarrier.sync(flags: .barrier) {
            block(&state)
        }
    }
    
    @inlinable
    func modifyingStateAsync(_ block: @escaping (inout CacheState) -> Void) -> Void {
        cacheBarrier.async(flags: .barrier) {
            block(&self.state)
        }
    }
    
    @inlinable
    func setup(value: T) {
        modifyingState { state in
            state.value = value
            usingCache = true
        }
    }
    
    @inlinable
    func tearDown(value: T) {
        modifyingState { state in
            state.value = value
            usingCache = false
        }
    }
}
