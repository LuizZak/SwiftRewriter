import Foundation
import Dispatch

/// An abstraction atop Foundation's `OperationQueue`.
public class ConcurrentOperationQueue {
    public typealias ConcurrentBlock = () throws -> Void
    
    private let _queue: OperationQueue

    @ConcurrentValue private var _blocks: [BlockMode] = []
    @ConcurrentValue private var _firstError: Error?
    @ConcurrentValue private var _runMode: RunMode = .stopped

    /// Gets or sets the maximum concurrent operations dispatched by this
    /// `ConcurrentOperationQueue`.
    ///
    /// Assigning a value of `0` enables the underlying operation queue to use
    /// the appropriate amount of concurrent operations based on system usage.
    public var maxConcurrentOperationCount: Int {
        get {
            _queue.maxConcurrentOperationCount
        }
        set {
            _queue.maxConcurrentOperationCount = newValue
        }
    }

    /// Gets the first error thrown by one of the operations.
    public var firstError: Error? {
        _firstError
    }

    public init() {
        _queue = OperationQueue()
    }

    /// Erases records of errors raised by concurrent operation blocks.
    public func clearErrors() {
        _firstError = nil
    }

    /// If `firstError` is not `nil`, throws that error.
    public func throwErrorIfAvailable() throws {
        if let firstError = firstError {
            throw firstError
        }
    }

    /// Adds an operation block to this queue.
    public func addOperation(_ block: @escaping ConcurrentBlock) {
        let blockMode: BlockMode = .default(block)

        switch _runMode {
        case .stopped, .sync:
            _blocks.append(blockMode)
        case .async:
            _submitBlockAsync(blockMode)
        }
    }

    /// Adds an operation to be performed in a blocking fashion on the queue, i.e.
    /// any other block currently on the queue finishes, before the barrier block
    /// is performed, and then subsequent non-barrier operations submitted to the
    /// queue run afterwards.
    public func addBarrierOperation(_ block: @escaping ConcurrentBlock) {
        let blockMode: BlockMode = .barrier(block)

        switch _runMode {
        case .stopped, .sync:
            _blocks.append(blockMode)
        case .async:
            _submitBlockAsync(blockMode)
        }
    }

    #if DEBUG

    /// Runs the currently enqueued blocks synchronously, in FIFO order.
    ///
    /// After exhausting the queue, throws the first error raised by a concurrent
    /// operation block.
    ///
    /// Note: Mainly used for debug purposes, should not be used in release mode.
    public func runSynchronously() throws {
        assert(!_isRunning(), "\(#function) called in an already running \(Self.self)")

        _runMode = .sync

        while !_blocks.isEmpty {
            let next = _blocks.removeFirst()

            do {
                try next.block()
            } catch {
                __firstError.setIfNil(error)
            }
        }

        _runMode = .stopped

        try throwErrorIfAvailable()
    }

    #endif

    /// Begins execution of the operations queued within this concurrent operation
    /// queue, and releases control back to the caller.
    public func runConcurrent() {
        switch _runMode {
        case .stopped:
            break
        case .async:
            return
        case .sync:
            fatalError("Called \(#function) while operation queue is running in synchronous context somewhere else.")
        }

        _runMode = .async(_queue)

        _submitBlocksAsync(_blocks)
        _blocks.removeAll()

        _submitBlockAsync(.barrier({
            self._runMode = .stopped
        }))
    }

    /// Executes the operations queued within this concurrent operation queue,
    /// and awaits for the operations to end.
    public func runAndWaitConcurrent() {
        runConcurrent()

        switch _runMode {
        case .stopped:
            break
        case .async(let queue):
            queue.waitUntilAllOperationsAreFinished()
            return
        case .sync:
            fatalError("Called \(#function) while operation queue is running in synchronous context somewhere else.")
        }
    }

    private func _isRunning() -> Bool {
        switch _runMode {
        case .stopped:
            return false
        case .sync, .async:
            return true
        }
    }

    private func _submitBlocksAsync(_ blocks: [BlockMode]) {
        for block in blocks {
            _submitBlockAsync(block)
        }
    }

    private func _submitBlockAsync(_ block: BlockMode) {
        let opBlock: (ConcurrentBlock) -> Void = { block in
            do {
                try block()
            } catch {
                self.__firstError.setIfNil(error)
            }
        }

        switch block {
        case .default(let block):
            _queue.addOperation {
                opBlock(block)
            }
        case .barrier(let block):
            if #available(macOS 10.15, *) {
                _queue.addBarrierBlock {
                    opBlock(block)
                }
            } else {
                // TODO: Improve support for fallback addBarrierBlock implementation
                _queue.addOperation {
                    let operation = BlockOperation(block: {
                        opBlock(block)
                    })
                    
                    self._queue.addOperations([operation], waitUntilFinished: true)
                }
            }
        }
    }

    private enum BlockMode {
        case `default`(ConcurrentBlock)
        case barrier(ConcurrentBlock)

        var block: ConcurrentBlock {
            switch self {
            case .default(let block), .barrier(let block):
                return block
            }
        }
    }

    /// Current run mode
    private enum RunMode {
        case stopped
        case async(OperationQueue)
        case sync
    }
}
