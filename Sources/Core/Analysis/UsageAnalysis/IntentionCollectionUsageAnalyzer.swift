import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Default implementation of UsageAnalyzer which searches for definitions in all
/// function bodies, top-level statements and expressions.
public class IntentionCollectionUsageAnalyzer: BaseUsageAnalyzer {
    public var intentions: IntentionCollection
    private let numThreads: Int
    
    // TODO: Passing `numThreads` here seems arbitrary (it is passed to
    // TODO: `FunctionBodyQueue` when collecting function bodies). Consider
    // TODO: wrapping it into an options struct that is passed to its initializer,
    // TODO: instead.
    
    public init(intentions: IntentionCollection, typeSystem: TypeSystem, numThreads: Int) {
        self.intentions = intentions
        self.numThreads = numThreads
        
        super.init(typeSystem: typeSystem)
    }

    override func statementContainers() -> [(StatementContainer, FunctionBodyCarryingIntention)] {
        let queue =
            FunctionBodyQueue.fromIntentionCollection(
                intentions, delegate: EmptyFunctionBodyQueueDelegate(),
                numThreads: numThreads
            )

        return queue.items.compactMap { item in
            if let intention = item.intention {
                return (item.container, intention)
            }

            return nil
        }
    }
}
