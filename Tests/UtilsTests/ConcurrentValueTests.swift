import Dispatch
import Utils
import XCTest

class ConcurrentValueTests: XCTestCase {
    @ConcurrentValue var value: Set<Int> = []
    var valueNonWrapper: ConcurrentValue<Set<Int>> = ConcurrentValue(wrappedValue: [])

    override func setUp() {
        super.setUp()
        value = []
        valueNonWrapper.wrappedValue = []
    }

    func testPerformanceConcurrentReading() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    queue.addOperation {
                        _ = self.valueNonWrapper.wrappedValue.contains(i)
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformanceConcurrentModification() {
        #if os(macOS)
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
        #endif
    }

    func testPerformanceConcurrentReadingAndModification() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    if i % 100 == 0 {
                        queue.addOperation {
                            _ = self.valueNonWrapper.modifyingValue {
                                $0.insert(i)
                            }
                        }
                    }
                    else {
                        queue.addOperation {
                            _ = self.valueNonWrapper.wrappedValue.contains(i)
                        }
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformancePropertyWrapperConcurrentReading() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    queue.addOperation {
                        _ = self.value.contains(i)
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformancePropertyWrapperConcurrentModification() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    queue.addOperation {
                        self.value.insert(i)
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformancePropertyWrapperConcurrentModification_WrappedValue() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    queue.addOperation {
                        self._value.wrappedValue.insert(i)
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformancePropertyWrapperConcurrentModification_ProjectedValue() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    queue.addOperation {
                        self.$value.insert(i)
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func testPerformancePropertyWrapperConcurrentReadingAndModification() {
        #if os(macOS)
            let queue = makeTestOperationQueue()

            measure {
                for i in 0...10_000 {
                    if i % 100 == 0 {
                        queue.addOperation {
                            self.value.insert(i)
                        }
                    }
                    else {
                        queue.addOperation {
                            _ = self.value.contains(i)
                        }
                    }
                }

                queue.waitUntilAllOperationsAreFinished()
            }
        #endif
    }

    func makeTestOperationQueue() -> OperationQueue {
        return OperationQueue()
    }
}
