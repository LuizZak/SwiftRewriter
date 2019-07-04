import XCTest
import Dispatch
import Utils

class ConcurrentValueTests: XCTestCase {
    @ConcurrentValue var value: Set<Int> = []
    var valueNonWrapper: ConcurrentValue<Set<Int>> = ConcurrentValue(initialValue: [])

    override func setUp() {
        super.setUp()
        value = []
        valueNonWrapper.wrappedValue = []
    }

    func testPerformanceConcurrentReading() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                queue.addOperation {
                    _ = self.valueNonWrapper.readingValue { $0.contains(i) }
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformanceConcurrentModification() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                queue.addOperation {
                    _ = self.valueNonWrapper.modifyingValue {
                        $0.insert(i)
                    }
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformanceConcurrentReadingAndModification() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                if i % 100 == 0 {
                    queue.addOperation {
                        _ = self.valueNonWrapper.modifyingValue {
                            $0.insert(i)
                        }
                    }
                } else {
                    queue.addOperation {
                        _ = self.valueNonWrapper.readingValue { $0.contains(i) }
                    }
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformancePropertyWrapperConcurrentReading() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                queue.addOperation {
                    _ = self.value.contains(i)
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformancePropertyWrapperConcurrentModification() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                queue.addOperation {
                    self.value.insert(i)
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformancePropertyWrapperConcurrentModification_WrappedValue() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                queue.addOperation {
                    self.$value.wrappedValue.insert(i)
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func testPerformancePropertyWrapperConcurrentReadingAndModification() {
        let queue = makeTestOperationQueue()

        measure {
            for i in 0...10_000 {
                if i % 100 == 0 {
                    queue.addOperation {
                        self.value.insert(i)
                    }
                } else {
                    queue.addOperation {
                        _ = self.value.contains(i)
                    }
                }
            }

            queue.waitUntilAllOperationsAreFinished()
        }
    }

    func makeTestOperationQueue() -> OperationQueue {
        return OperationQueue()
    }
}
