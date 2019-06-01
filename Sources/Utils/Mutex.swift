#if os(macOS)
import Darwin.C
#elseif os(Linux)
import Glibc
#endif

/// A simple, non-recursive mutex lock.
public final class Mutex {
    
    private var mutex: pthread_mutex_t
    
    public init() {
        mutex = pthread_mutex_t()
        
        pthread_mutex_init(&mutex, nil)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
    
    public func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    public func unlock() {
        pthread_mutex_unlock(&mutex)
    }
    
    public func tryLock() -> Bool {
        return pthread_mutex_trylock(&mutex) == 0
    }
    
    public func locking<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer {
            unlock()
        }
        
        return try closure()
    }
}
