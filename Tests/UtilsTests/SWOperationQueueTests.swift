import XCTest
import Utils

class SWOperationQueueTests: XCTestCase {
    func testAddOperation() {
        let sut = SWOperationQueue(maxConcurrentOperationCount: 3)
        var total = 0
        let totalBarrier = DispatchQueue(label: "com.swiftrewriter.test.barrier",
                                         attributes: .concurrent)
        var count = 0
        let countBarrier = DispatchQueue(label: "com.swiftrewriter.test.barrier",
                                         attributes: .concurrent)
        var hasFailed = false
        let hasFailedBarrier = DispatchQueue(label: "com.swiftrewriter.test.barrier",
                                             attributes: .concurrent)
        
        for _ in 0..<100 {
            sut.addOperation {
                countBarrier.sync(flags: .barrier, execute: { count += 1 })
                
                let current = countBarrier.sync(execute: { count })
                if current > sut.maxConcurrentOperationCount {
                    if hasFailedBarrier.sync(execute: { !hasFailed }) {
                        XCTFail("Simultaneous operation count \(current) exceeds maximum allowed concurrent operations of \(sut.maxConcurrentOperationCount)")
                        hasFailedBarrier.sync(flags: .barrier, execute: { hasFailed = true })
                    }
                }
                
                usleep(3000)
                
                countBarrier.sync(flags: .barrier, execute: { count -= 1 })
                totalBarrier.sync(flags: .barrier, execute: { total += 1 })
            }
        }
        
        sut.waitUntilAllOperationsAreFinished()
        
        XCTAssertEqual(totalBarrier.sync(execute: { total }), 100)
    }
}
