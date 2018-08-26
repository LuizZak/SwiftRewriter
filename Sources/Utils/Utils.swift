import Cocoa

/// Swift version of Objective-C's @synchronized statement.
/// Do note that differently from Obj-C's version, this closure-based version
/// consumes any 'return/continue/break' statements without affecting the parent
/// function it is enclosed in.
public func synchronized<T>(_ lock: AnyObject, closure: () throws -> T) rethrows -> T {
    objc_sync_enter(lock)
    defer {
        objc_sync_exit(lock)
    }
    
    return try closure()
}

extension Sequence {
    /// Returns a dictionary containing elements grouped by a specified key
    /// Note that the 'key' closure is required to always return the same T key
    /// for the same value passed in, so values can be grouped correctly
    public func groupBy<T: Hashable>(_ key: (Iterator.Element) -> T) -> [T: [Iterator.Element]] {
        return Dictionary(grouping: self, by: key)
    }
    
}

extension Sequence {
    /// Returns `true` iff any elements from this sequence pass a given predicate.
    /// Returns `false` if sequence is empty.
    public func any(_ predicate: (Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) {
                return true
            }
        }
        
        return false
    }
}
