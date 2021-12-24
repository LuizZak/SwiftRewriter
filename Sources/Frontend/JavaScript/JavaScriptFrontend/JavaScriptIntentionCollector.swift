import GrammarModelBase
import JsGrammarModels
import JsParser
import SwiftAST
import KnownType
import Intentions
import TypeSystem

public protocol JavaScriptIntentionCollectorDelegate: AnyObject {
    func reportForLazyParsing(intention: Intention)
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
        
        @discardableResult
        public func popContext() -> Intention {
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
        startNodeVisit(node)
    }

    private func startNodeVisit(_ node: JsASTNode) {
        let visitor = AnyASTVisitor()
        let traverser = ASTTraverser(node: node, visitor: visitor)
        
        visitor.onEnterClosure = { node in
            switch node {
            case let n as JsClassNode:
                self.enterJsClassNode(n)

            case let n as JsFunctionDeclarationNode:
                self.enterJsFunctionDeclarationNode(n)

            default:
                return
            }
        }
        
        visitor.visitClosure = { node in
            switch node {
            case let n as JsMethodDefinitionNode:
                self.visitJsMethodDefinitionNode(n)
                
            case let n as JsVariableDeclarationNode:
                self.visitJsVariableDeclarationNode(n)
                
            default:
                return
            }
        }
        
        visitor.onExitClosure = { node in
            switch node {
            case let n as JsClassNode:
                self.exitJsClassNode(n)

            case let n as JsFunctionDeclarationNode:
                self.exitJsFunctionDeclarationNode(n)
                
            default:
                return
            }
        }
        
        traverser.traverse()
    }

    private func enterJsClassNode(_ node: JsClassNode) {
        guard let name = node.identifier?.name else {
            return
        }

        let intent = ClassGenerationIntention(typeName: name, source: node)
        
        configure(node: node, intention: intent)

        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addType(intent)
        
        context.pushContext(intent)
    }

    private func exitJsClassNode(_ node: JsClassNode) {
        if node.identifier?.name != nil {
            context.popContext() // ClassGenerationIntention
        }
    }

    private func enterJsFunctionDeclarationNode(_ node: JsFunctionDeclarationNode) {
        guard node.identifier != nil else {
            return
        }
        
        guard let signature = signatureConverter().generateDefinitionSignature(from: node) else {
            return
        }

        let globalFunc = GlobalFunctionGenerationIntention(signature: signature, source: node)

        configure(node: node, intention: globalFunc)

        context
            .findContext(ofType: FileGenerationIntention.self)?
            .addGlobalFunction(globalFunc)
        
        context.pushContext(globalFunc)

        if let body = node.body {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            globalFunc.functionBody = methodBodyIntention

            configure(node: body, intention: methodBodyIntention)

            delegate?.reportForLazyParsing(intention: methodBodyIntention)
        }
    }

    private func exitJsFunctionDeclarationNode(_ node: JsFunctionDeclarationNode) {
        if context.currentContext(as: GlobalFunctionGenerationIntention.self) != nil {
            context.popContext() // GlobalFunctionGenerationIntention
        }
    }

    private func visitJsMethodDefinitionNode(_ node: JsMethodDefinitionNode) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }

        guard let sign = signatureConverter().generateDefinitionSignature(from: node) else {
            return
        }

        let method = MethodGenerationIntention(signature: sign, source: node)

        configure(node: node, intention: method)

        if let body = node.body {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            method.functionBody = methodBodyIntention

            configure(node: body, intention: methodBodyIntention)

            delegate?.reportForLazyParsing(intention: methodBodyIntention)
        }

        ctx.addMethod(method)
    }

    private func visitJsVariableDeclarationNode(_ node: JsVariableDeclarationNode) {

    }

    // MARK: - Instance factories
    
    private func signatureConverter() -> JavaScriptMethodSignatureConverter {
        return JavaScriptMethodSignatureConverter()
    }
}

extension JavaScriptIntentionCollector {
    
}

extension JavaScriptIntentionCollector {
    private func configure(node: JsASTNode, intention: FromSourceIntention) {
        _recordSourceHistory(node, intention)
        _mapComments(node, intention)
    }

    private func _recordSourceHistory(_ node: JsASTNode, _ intention: FromSourceIntention) {
        intention.history.recordSourceHistory(node: node)
    }

    private func _mapComments(_ node: JsASTNode, _ intention: FromSourceIntention) {
        intention.precedingComments.append(contentsOf: convertComments(node.precedingComments))
    }
    
    private func convertComments(_ comments: [CodeComment]) -> [String] {
        return comments.map { $0.string.trimmingWhitespaces() }
    }
}
