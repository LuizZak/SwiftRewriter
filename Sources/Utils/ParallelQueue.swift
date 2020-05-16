import Dispatch
import Foundation

/// A class that manages a bus of parallelized producers which passes data into
/// a centralized queue for further processing.
public class ParallelQueue<T> {
    var processQueue: OperationQueue
    var queue: DispatchQueue
    
    var resultProcessor: ((T) -> Void)?
    
    public init(threadCount: Int) {
        processQueue = OperationQueue()
        processQueue.maxConcurrentOperationCount = threadCount
        
        queue = DispatchQueue(label: "swiftrewriter.parallelizedbus.queue")
    }
    
    public func addResultProcessor(_ processor: @escaping (T) -> Void) {
        resultProcessor = processor
    }
    
    public func enqueue(_ work: @escaping () -> T) {
        processQueue.addOperation { [queue, resultProcessor] in
            let result = work()
            
            queue.sync {
                resultProcessor?(result)
            }
        }
    }
    
    public func wait() {
        processQueue.waitUntilAllOperationsAreFinished()
    }
}
