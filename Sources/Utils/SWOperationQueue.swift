import Dispatch

/// A simple asynchronous operation queue based on Foundation's `OperationQueue`
/// class.
public final class SWOperationQueue {
    let ingressQueue = DispatchQueue(label: "com.swiftrewriter.operationqueue.ingress", attributes: [])
    let queue = DispatchQueue(label: "com.swiftrewriter.operationqueue", attributes: .concurrent)
    let group = DispatchGroup()
    let semaphore: DispatchSemaphore

    public let maxConcurrentOperationCount: Int

    public init(maxConcurrentOperationCount: Int) {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
        semaphore = DispatchSemaphore(value: maxConcurrentOperationCount)
    }

    public func addOperation(_ block: @escaping () -> Void) {
        self.group.enter()
        ingressQueue.async {
            self.semaphore.wait()
            self.queue.async {
                defer {
                    self.group.leave()
                    self.semaphore.signal()
                }
                
                block()
            }
        }
    }

    public func waitUntilAllOperationsAreFinished() {
        group.wait()
    }
}
