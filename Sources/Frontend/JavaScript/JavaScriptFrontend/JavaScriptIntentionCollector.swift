import GrammarModelBase
import JsGrammarModels
import JsParser
import SwiftAST
import KnownType
import Intentions
import TypeSystem

public protocol JavaScriptIntentionCollectorDelegate: AnyObject {
    
}

/// Traverses a provided AST node, and produces intentions that are recorded by
/// pushing and popping them as contexts on a delegate's context object.
public class JavaScriptIntentionCollector {
    /// Represents a local context for constructing types with.
    public class Context {
        var contexts: [Intention] = []
        var ivarAccessLevel: AccessLevel = .private
        
        public init() {
            
        }
        
        public func pushContext(_ intention: Intention) {
            contexts.append(intention)
        }
        
        /// Returns the latest context on the contexts stack that matches a given type.
        ///
        /// Searches from top-to-bottom, so the last context `T` that was pushed is
        /// returned first.
        public func findContext<T: Intention>(ofType type: T.Type = T.self) -> T? {
            contexts.reversed().first { $0 is T } as? T
        }
        
        /// Returns the topmost context on the contexts stack casted to a specific type.
        ///
        /// If the topmost context is not T, nil is returned instead.
        public func currentContext<T: Intention>(as type: T.Type = T.self) -> T? {
            contexts.last as? T
        }
        
        public func popContext() {
            contexts.removeLast()
        }
    }

    public weak var delegate: JavaScriptIntentionCollectorDelegate?
    
    var context: Context
    
    public init(delegate: JavaScriptIntentionCollectorDelegate, context: Context) {
        self.delegate = delegate
        self.context = context
    }
    
    public func collectIntentions(_ node: JsASTNode) {
        fatalError("Not implemented")
    }
}

extension JavaScriptIntentionCollector {
    private func recordSourceHistory(intention: FromSourceIntention, node: JsASTNode) {
        intention.history.recordSourceHistory(node: node)
    }
}

extension JavaScriptIntentionCollector {
    private func mapComments(_ node: JsASTNode, _ intention: FromSourceIntention) {
        intention.precedingComments.append(contentsOf: convertComments(node.precedingComments))
    }
    
    private func convertComments(_ comments: [CodeComment]) -> [String] {
        return comments.map { $0.string.trimmingWhitespaces() }
    }
}
