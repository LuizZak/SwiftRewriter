import JsParser
import Utils

/// A class to aid in managing pooling of JsParserState instances
public final class JsParserStatePool {
    let mutex = Mutex()
    
    private var pool: [JsParserState] = []
    
    public init() {
        
    }
    
    /// Pulls a new instance of an `JsParserState` to parse with.
    ///
    /// - Returns: An `JsParserState` ready to parse data.
    public func pull() -> JsParserState {
        mutex.locking {
            if !pool.isEmpty {
                return pool.removeFirst()
            }
            
            return JsParserState()
        }
    }
    
    /// Repools and `JsParserState` instance for reusal.
    ///
    /// - Parameter parserState: Parser state to reuse.
    public func repool(_ parserState: JsParserState) {
        mutex.locking {
            pool.append(parserState)
        }
    }
}
