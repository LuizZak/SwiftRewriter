import ObjcParser
import Utils

/// A class to aid in managing pooling of ObjcParserState instances
final class ObjcParserStatePool {
    private var pool: [ObjcParserState] = []
    
    /// Clears all states stored by this pool.
    func clear() {
        synchronized(self) {
            pool.removeAll()
        }
    }
    
    /// Pulls a new instance of an `ObjcParserState` to parse with.
    ///
    /// - Returns: An `ObjcParserState` ready to parse data.
    func pull() -> ObjcParserState {
        return synchronized(self) {
            if !pool.isEmpty {
                return pool.removeFirst()
            }
            
            return ObjcParserState()
        }
    }
    
    /// Repools and `ObjcParserState` instance for reusal.
    ///
    /// - Parameter parserState: Parser state to reuse.
    func repool(_ parserState: ObjcParserState) {
        return synchronized(self) {
            pool.append(parserState)
        }
    }
}
