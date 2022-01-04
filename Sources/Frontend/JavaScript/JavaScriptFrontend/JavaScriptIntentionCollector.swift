import GrammarModelBase
import JsGrammarModels
import JsParser
import SwiftAST
import KnownType
import Intentions
import TypeSystem

// TODO: Move lazy parse object reporting to use a `JavaScriptLazyParseItem` like
// TODO: the Objective-C frontend does.
public protocol JavaScriptIntentionCollectorDelegate: AnyObject {
    func reportForLazyParsing(_ item: JavaScriptLazyParseItem)
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
            case let n as JsConstructorDefinitionNode:
                self.visitJsConstructorDefinitionNode(n)

            case let n as JsMethodDefinitionNode:
                self.visitJsMethodDefinitionNode(n)
                
            case let n as JsVariableDeclarationListNode:
                self.visitJsVariableDeclarationListNode(n)
            
            case let n as JsClassPropertyNode:
                self.visitJsClassPropertyNode(n)
                
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

            delegate?.reportForLazyParsing(.globalFunction(methodBodyIntention, globalFunc))
        }
    }

    private func exitJsFunctionDeclarationNode(_ node: JsFunctionDeclarationNode) {
        if context.currentContext(as: GlobalFunctionGenerationIntention.self) != nil {
            context.popContext() // GlobalFunctionGenerationIntention
        }
    }

    private func visitJsConstructorDefinitionNode(_ node: JsConstructorDefinitionNode) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }

        guard let sign = signatureConverter().generateDefinitionSignature(from: node) else {
            return
        }

        let intention = InitGenerationIntention(parameters: sign.parameters, source: node)

        configure(node: node, intention: intention)

        if let body = node.body {
            let methodBodyIntention = FunctionBodyIntention(body: [], source: body)
            intention.functionBody = methodBodyIntention

            configure(node: body, intention: methodBodyIntention)

            delegate?.reportForLazyParsing(.initializer(methodBodyIntention, intention))
        }

        ctx.addConstructor(intention)
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

            delegate?.reportForLazyParsing(.method(methodBodyIntention, method))
        }

        ctx.addMethod(method)
    }

    private func visitJsClassPropertyNode(_ node: JsClassPropertyNode) {
        guard let ctx = context.findContext(ofType: TypeGenerationIntention.self) else {
            return
        }
        guard let identifier = node.identifier else {
            return
        }

        let property = PropertyGenerationIntention(
            name: identifier.name,
            type: .any,
            objcAttributes: [],
            source: node
        )

        configure(node: node, intention: property)
        
        if let initialExpression = node.expression {
            let initialExpr =
                PropertyInitialValueGenerationIntention(
                    expression: .constant(0),
                    source: initialExpression
                )
            property.initialValueIntention = initialExpr
            
            configure(node: initialExpression, intention: initialExpr)
        
            delegate?.reportForLazyParsing(.classProperty(initialExpr, property))
        }

        ctx.addProperty(property)
    }

    private func visitJsVariableDeclarationListNode(_ node: JsVariableDeclarationListNode) {
        guard let ctx = context.currentContext(as: FileGenerationIntention.self) else {
            return
        }
        
        var attributedComments = false

        for variableNode in node.variableDeclarations {
            guard let identifier = variableNode.identifier else {
                continue
            }

            let intention = GlobalVariableGenerationIntention(
                name: identifier.name,
                type: .any,
                source: variableNode
            )

            if !attributedComments {
                attributedComments = true

                _mapComments(node, intention)
            }

            configure(node: variableNode, intention: intention)
            
            if let initialExpression = variableNode.expression {
                let initialExpr =
                    GlobalVariableInitialValueIntention(
                        expression: .constant(0),
                        source: initialExpression
                    )
                
                intention.initialValueIntention = initialExpr

                configure(node: initialExpression, intention: initialExpr)
            
                delegate?.reportForLazyParsing(.globalVar(initialExpr, intention))
            }

            ctx.addGlobalVariable(intention)
        }
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
        let comments = convertComments(node.precedingComments)

        intention.precedingComments.append(contentsOf: comments)
    }
    
    private func convertComments(_ comments: [RawCodeComment]) -> [String] {
        return comments.map { $0.string.trimmingWhitespaces() }
    }
}

public enum JavaScriptLazyParseItem {
    case globalFunction(FunctionBodyIntention, GlobalFunctionGenerationIntention)
    case method(FunctionBodyIntention, MethodGenerationIntention)
    case initializer(FunctionBodyIntention, InitGenerationIntention)
    case classProperty(PropertyInitialValueGenerationIntention, PropertyGenerationIntention)
    case globalVar(GlobalVariableInitialValueIntention, GlobalVariableGenerationIntention)
}
