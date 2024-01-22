import Intentions
import SwiftAST

/// Delegate for controlling some aspects of SwiftSyntax AST generation
public protocol SwiftProducerDelegate: AnyObject {
    /// Returns whether or not to emit the type annotation for a variable declaration
    /// with a given initial value.
    func swiftProducer(_ producer: SwiftProducer,
                       shouldEmitTypeFor storage: ValueStorage,
                       intention: IntentionProtocol?,
                       initialValue: Expression?) -> Bool
    
    /// Returns the initial value for a given value storage intention of a property,
    /// instance variable, or global variable.
    func swiftProducer(_ producer: SwiftProducer,
                       initialValueFor intention: ValueStorageIntention) -> Expression?
}
