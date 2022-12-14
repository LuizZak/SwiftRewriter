import XCTest

@testable import Utils

class MutexTests: XCTestCase {
    func testMutex() {
        let expectation = self.expectation(description: "\(#function)\(#line)")

        let mutex = Mutex()
        var resource = Resource(value: 0)

        let queue = makeTestQueue()
        queue.suspend()

        for _ in 0..<100 {
            queue.async {
                mutex.lock()
                resource.value += 1
                if resource.value == 100 {
                    expectation.fulfill()
                }
                mutex.unlock()
            }
        }

        queue.resume()
        queue.sync(flags: .barrier, execute: {})

        XCTAssertEqual(resource.value, 100)

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testTryLock() {
        let expectation = self.expectation(description: "\(#function)\(#line)")

        let mutex = Mutex()
        let queue = makeTestQueue()
        let otherQueue = makeTestQueue()

        queue.suspend()

        queue.async {
            mutex.lock()
            otherQueue.async {
                XCTAssertFalse(mutex.tryLock())
                expectation.fulfill()
            }
            usleep(25000)
            mutex.unlock()
        }

        queue.resume()

        queue.sync(flags: .barrier, execute: {})

        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func makeTestQueue() -> DispatchQueue {
        return DispatchQueue(
            label: "com.swiftrewriter.utilstests.mutex.queue",
            attributes: .concurrent
        )
    }
}

private struct Resource {
    var value: Int
}
