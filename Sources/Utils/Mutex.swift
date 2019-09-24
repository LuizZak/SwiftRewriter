import Foundation

/// A simple, non-recursive mutex lock.
public final class Mutex {
    
    private var _lock: NSLock
    
    public init() {
        _lock = NSLock()
    }
    
    public func lock() {
        _lock.lock()
    }
    
    public func unlock() {
        _lock.unlock()
    }
    
    public func tryLock() -> Bool {
        _lock.try()
    }
    
    public func locking<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer {
            unlock()
        }
        
        return try closure()
    }
}
