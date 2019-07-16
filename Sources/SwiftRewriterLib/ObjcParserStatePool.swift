import ObjcParser
import Utils

/// A class to aid in managing pooling of ObjcParserState instances
final class ObjcParserStatePool {
    let mutex = Mutex()
    
    private var pool: [ObjcParserState] = []
    
    /// Pulls a new instance of an `ObjcParserState` to parse with.
    ///
    /// - Returns: An `ObjcParserState` ready to parse data.
    func pull() -> ObjcParserState {
        return mutex.locking {
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
        return mutex.locking {
            pool.append(parserState)
        }
    }
}
