import XCTest

@testable import Utils

class ConcurrentOperationQueueTests: XCTestCase {
    func testRunAndWaitConcurrent() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")

        sut.addOperation {
            Thread.sleep(forTimeInterval: 0.1)
        }
        sut.addBarrierOperation {
            exp.fulfill()
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)
    }

    func testRunAndWaitConcurrent_runsOnDifferentThreads() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")
        let currentThread = Thread.current

        sut.addOperation {
            XCTAssertNotIdentical(currentThread, Thread.current)
        }
        sut.addBarrierOperation {
            XCTAssertNotIdentical(currentThread, Thread.current)
            exp.fulfill()
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)
    }
    
    func testAddOperation_awaitsForRunCommand() {
        let sut = ConcurrentOperationQueue()
        var didPerform = false

        sut.addOperation {
            didPerform = true
        }

        if didPerform {
            XCTFail("Expected \(ConcurrentOperationQueue.self) to not automatically execute blocks.")
        }
    }
    
    func testAddBarrierOperation_awaitsForRunCommand() {
        let sut = ConcurrentOperationQueue()
        var didPerform = false

        sut.addBarrierOperation {
            didPerform = true
        }

        if didPerform {
            XCTFail("Expected \(ConcurrentOperationQueue.self) to not automatically execute blocks.")
        }
    }

    func testAddOperation_withRunningAsynchronousState_runsAutomatically() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")

        sut.addOperation {
            sut.addBarrierOperation {
                exp.fulfill()
            }

            Thread.sleep(forTimeInterval: 0.1)
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)
    }

    func testAddBarrierOperation_withRunningAsynchronousState_awaitsForCurrentOperationsToFinish() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")
        var isRunning = false

        sut.addOperation {
            isRunning = true

            sut.addBarrierOperation {
                XCTAssertFalse(isRunning)
                exp.fulfill()
            }

            Thread.sleep(forTimeInterval: 0.1)

            isRunning = false
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)
    }

    func testAddOperation_blockThrows_remainingOperationsContinue() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")
        @ConcurrentValue var blockCounter: Int = 0
        
        sut.addOperation {
            _blockCounter.modifyingValue { $0 += 1 }

            throw TestError.error
        }
        sut.addOperation {
            _blockCounter.modifyingValue { $0 += 1 }
        }
        sut.addBarrierOperation {
            _blockCounter.modifyingValue { $0 += 1 }

            exp.fulfill()
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(blockCounter, 3)
    }

    func testAddOperation_blockThrows_errorIsRegistered() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")
        
        sut.addOperation {
            throw TestError.error
        }
        sut.addBarrierOperation {
            exp.fulfill()
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(sut.firstError as? TestError, TestError.error)
    }

    func testAddOperation_blockThrows_propagatesOnlyFirstError() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runAndWaitConcurrent")
        
        sut.addOperation {
            throw TestError.error
        }
        sut.addBarrierOperation {
            defer { exp.fulfill() }

            throw TestError.otherError
        }

        sut.runAndWaitConcurrent()

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(sut.firstError as? TestError, TestError.error)
    }
    
    // MARK: - Synchronous tests
    #if DEBUG

    func testRunSynchronously() throws {
        let sut = ConcurrentOperationQueue()
        var performedBlock1 = false
        var performedBlock2 = false

        sut.addOperation {
            performedBlock1 = true
        }
        sut.addBarrierOperation {
            performedBlock2 = true
        }

        try sut.runSynchronously()

        XCTAssertTrue(performedBlock1)
        XCTAssertTrue(performedBlock2)
    }

    func testRunSynchronously_runsOnCurrentThread() throws {
        let sut = ConcurrentOperationQueue()
        let currentThread = Thread.current
        
        sut.addOperation {
            XCTAssertIdentical(currentThread, Thread.current)
        }
        sut.addBarrierOperation {
            XCTAssertIdentical(currentThread, Thread.current)
        }

        try sut.runSynchronously()
    }

    func testRunSynchronously_blockThrows_remainingOperationsContinue() {
        let sut = ConcurrentOperationQueue()
        let exp = expectation(description: "runSynchronously")
        @ConcurrentValue var blockCounter: Int = 0
        
        sut.addOperation {
            _blockCounter.modifyingValue { $0 += 1 }

            throw TestError.error
        }
        sut.addOperation {
            _blockCounter.modifyingValue { $0 += 1 }
        }
        sut.addBarrierOperation {
            _blockCounter.modifyingValue { $0 += 1 }

            exp.fulfill()
        }

        try? sut.runSynchronously()

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(blockCounter, 3)
    }

    #endif

    private enum TestError: Swift.Error, Equatable {
        case error
        case otherError
    }
}
