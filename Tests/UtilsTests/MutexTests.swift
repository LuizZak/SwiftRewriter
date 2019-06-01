import XCTest
import Dispatch
import Utils

class MutexTests: XCTestCase {
    func testMutex() {
        let mutex = Mutex()
        var resource = Resource(value: 0)
        
        let queue = makeTestQueue()
        queue.suspend()
        
        for _ in 0..<100 {
            queue.async {
                mutex.lock()
                resource.value += 1
                mutex.unlock()
            }
        }
        
        queue.resume()
        queue.sync(flags: .barrier, execute: { })
        
        XCTAssertEqual(resource.value, 100)
    }
    
    func testTryLock() {
        let mutex = Mutex()
        let queue = makeTestQueue()
        
        queue.suspend()
        
        queue.async {
            mutex.lock()
            queue.async {
                XCTAssertFalse(mutex.tryLock())
            }
            usleep(25000)
            mutex.unlock()
        }
        
        queue.resume()
        
        queue.sync(flags: .barrier, execute: { })
    }
    
    func makeTestQueue() -> DispatchQueue {
        return DispatchQueue(label: "com.swiftrewriter.utilstests.mutex.queue",
                             attributes: .concurrent)
    }
}

private struct Resource {
    var value: Int
}
