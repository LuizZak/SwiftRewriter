import Antlr4
import Utils
import AntlrCommons
import JsParserAntlr
import GrammarModelBase
import JsGrammarModels

internal class JsParserListener: JavaScriptParserBaseListener {

    let context: NodeCreationContext

    let rootNode: JsGlobalContextNode = JsGlobalContextNode()

    private let mapper: GenericParseTreeContextMapper
    private let sourceString: String
    private let source: Source
    private let nodeFactory: JsASTNodeFactory
    
    init(sourceString: String, source: Source) {
        
        self.sourceString = sourceString
        self.source = source
        self.nodeFactory = JsASTNodeFactory(source: source)
        
        context = NodeCreationContext()
        mapper = GenericParseTreeContextMapper(
            source: source,
            nodeFactory: nodeFactory
        )
        
        super.init()
        
        configureMappers()
    }
    
    /// Configures mappers in `self.mapper` so they are automatically pushed and
    /// popped whenever the rules are entered and exited during visit.
    ///
    /// Used as a convenience over manually pushing and popping contexts every
    /// time a node of significance is entered.
    private func configureMappers() {
        typealias P = JavaScriptParser
        
        mapper.addRuleMap(
            rule: P.ProgramContext.self,
            node: rootNode
        )
        mapper.addRuleMap(
            rule: P.ClassDeclarationContext.self,
            nodeType: JsClassNode.self
        )
        mapper.addRuleMap(
            rule: P.MethodDefinitionContext.self,
            nodeType: JsMethodDefinitionNode.self
        )
        mapper.addRuleMap(
            rule: P.FunctionDeclarationContext.self,
            nodeType: JsFunctionDeclarationNode.self
        )
        mapper.addRuleMap(
            rule: P.FunctionBodyContext.self,
            nodeType: JsFunctionBodyNode.self
        )
    }
    
    override func enterEveryRule(_ ctx: ParserRuleContext) throws {
        print("Enter: \(type(of: ctx)) - \(ctx.getText())")

        mapper.matchEnter(rule: ctx, context: context)
    }
    
    override func exitEveryRule(_ ctx: ParserRuleContext) throws {
        mapper.matchExit(rule: ctx, context: context)

        print("Exit: \(type(of: ctx)) - \(ctx.getText())")
    }

    override func enterClassDeclaration(_ ctx: JavaScriptParser.ClassDeclarationContext) {
        guard let classNode = context.currentContextNode(as: JsClassNode.self) else {
            return
        }
        guard let className = ctx.identifier() else {
            return
        }
        
        // Class name
        let identifierNode = nodeFactory.makeIdentifier(from: className)
        classNode.addChild(identifierNode)
    }

    override func enterMethodDefinition(_ ctx: JavaScriptParser.MethodDefinitionContext) {
        guard let methodNode = context.currentContextNode(as: JsMethodDefinitionNode.self) else {
            return
        }
        guard let methodName = ctx.propertyName()?.identifierName()?.identifier() else {
            return
        }
        
        let identifierNode = nodeFactory.makeIdentifier(from: methodName)
        methodNode.addChild(identifierNode)
        methodNode.signature = functionSignature(from: ctx.formalParameterList())
    }

    override func enterFunctionDeclaration(_ ctx: JavaScriptParser.FunctionDeclarationContext) {
        guard let functionNode = context.currentContextNode(as: JsFunctionDeclarationNode.self) else {
            return
        }
        guard let functionName = ctx.identifier() else {
            return
        }
        
        let identifierNode = nodeFactory.makeIdentifier(from: functionName)
        functionNode.addChild(identifierNode)
        functionNode.signature = functionSignature(from: ctx.formalParameterList())
    }

    override func enterFunctionBody(_ ctx: JavaScriptParser.FunctionBodyContext) {
        guard let node = context.currentContextNode(as: JsFunctionBodyNode.self) else {
            return
        }

        node.body = ctx
    }

    override func enterVariableStatement(_ ctx: JavaScriptParser.VariableStatementContext) {
        guard let contextNode = context.currentContextNode() else {
            return
        }
        guard let variableDeclarationList = ctx.variableDeclarationList() else {
            return
        }
        guard let varModifier = variableDeclarationList.varModifier() else {
            return
        }

        let variableDeclarationListNode =
            nodeFactory.makeVariableDeclarationList(
                from: variableDeclarationList, 
                varModifier: varModifier
            )
        
        for variableDeclaration in variableDeclarationList.variableDeclaration() {
            // TODO: Support different assignable types?
            guard let identifier = variableDeclaration.assignable()?.identifier() else {
                continue
            }

            let variableDeclNode = nodeFactory.makeVariableDeclaration(
                from: variableDeclaration,
                identifier: identifier,
                initialExpression: variableDeclaration.singleExpression()
            )

            variableDeclarationListNode.addChild(variableDeclNode)
        }

        switch contextNode {
        case is JsGlobalContextNode:
            contextNode.addChild(variableDeclarationListNode)
            break
        default:
            break
        }
    }

    func functionSignature(from ctx: JavaScriptParser.FormalParameterListContext?) -> JsFunctionSignature {
        func _argument(from ctx: JavaScriptParser.FormalParameterArgContext) -> JsFunctionArgument? {
            guard let identifier = ctx.assignable()?.identifier()?.getText() else {
                return nil
            }

            return .init(identifier: identifier, isVariadic: false)
        }
        func _argument(from ctx: JavaScriptParser.LastFormalParameterArgContext) -> JsFunctionArgument? {
            guard let identifier = _identifier(from: ctx.singleExpression())?.getText() else {
                return nil
            }

            return .init(identifier: identifier, isVariadic: ctx.Ellipsis() != nil)
        }

        var arguments: [JsFunctionArgument] = []

        if let ctx = ctx {
            arguments = ctx.formalParameterArg().compactMap(_argument(from:))
            
            if let last = ctx.lastFormalParameterArg(), let argument = _argument(from: last) {
                arguments.append(argument)
            }
        }

        return JsFunctionSignature(arguments: arguments)
    }

    private func _identifier(from singleExpression: JavaScriptParser.SingleExpressionContext?) -> JavaScriptParser.IdentifierContext? {
        singleExpression.flatMap(_identifier(from:))
    }

    private func _identifier(from singleExpression: JavaScriptParser.SingleExpressionContext) -> JavaScriptParser.IdentifierContext? {
        if let result = singleExpression as? JavaScriptParser.IdentifierExpressionContext {
            return result.identifier()
        }

        return nil
    }
}

private class GenericParseTreeContextMapper {
    private var pairs: [Pair] = []
    private var exceptions: [ParserRuleContext.Type] = []
    
    private var source: Source
    
    private var nodeFactory: JsASTNodeFactory
    
    init(source: Source,
         nodeFactory: JsASTNodeFactory) {
        
        self.source = source
        self.nodeFactory = nodeFactory
    }
    
    func addRuleMap<T: ParserRuleContext, U: JsInitializableNode>(
        rule: T.Type,
        nodeType: U.Type) {
        
        assert(match(ruleType: rule) == nil, "Duplicated mapping rule for parser rule context \(rule)")
        
        pairs.append(.type(rule: rule, nodeType: nodeType, nil))
    }
    
    func addRuleMapClosure<T: ParserRuleContext, U: JsInitializableNode>(
        _ closure: @escaping (T, U) -> Void) {
        
        assert(match(ruleType: T.self) == nil, "Duplicated mapping rule for parser rule context \(T.self)")
        
        pairs.append(.type(rule: T.self, nodeType: U.self, { rule, node in
            guard let rule = rule as? T else {
                return
            }
            guard let node = node as? U else {
                return
            }

            closure(rule, node)
        }))
    }
    
    func addRuleMap<T: ParserRuleContext, U: JsInitializableNode>(rule: T.Type, node: U) {
        assert(match(ruleType: rule) == nil, "Duplicated mapping rule for parser rule context \(rule)")
        
        pairs.append(.instance(rule: rule, node: node))
    }
    
    func pushTemporaryException(forRuleType ruleType: ParserRuleContext.Type) {
        exceptions.append(ruleType)
    }
    
    func popTemporaryException() {
        exceptions.removeLast()
    }
    
    func matchEnter(rule: ParserRuleContext, context: NodeCreationContext) {
        let ruleType = type(of: rule)
        guard let nodeType = match(ruleType: ruleType) else {
            return
        }
        
        switch nodeType {
        case .type(_, let nodeType, let initializer):
            let node = nodeType.init()
            
            nodeFactory.updateSourceLocation(for: node, with: rule)
            
            /* TODO: Implement JavaScript comment parsing
            if collectComments {
                node.precedingComments = commentQuerier.popClosestCommentsBefore(node: rule)
            }
            */
            
            context.pushContext(node: node)

            if let initializer = initializer {
                initializer(rule, node)
            }
            
        case .instance(_, let node):
            context.pushContext(node: node)
        }
    }
    
    func matchExit(rule: ParserRuleContext, context: NodeCreationContext) {
        let ruleType = type(of: rule)
        guard let pair = match(ruleType: ruleType) else {
            return
        }
        
        if let popped = context.popContext() {
            switch pair {
            case .type(_, let nodeType, _):
                assert(type(of: popped) == nodeType, "matchExit() did not match context from popContext: \(nodeType) vs \(type(of: popped))")
            case .instance(_, let node):
                assert(popped === node, "matchExit() did not match context from pop: \(node) vs \(node)")
            }
        }
    }
    
    private func match(ruleType: ParserRuleContext.Type) -> Pair? {
        if exceptions.contains(where: { $0 == ruleType }) {
            return nil
        }
        
        return pairs.first { $0.ruleType == ruleType }
    }
    
    private enum Pair {
        case type(rule: ParserRuleContext.Type, nodeType: JsInitializableNode.Type, ((ParserRuleContext, JsInitializableNode) -> Void)?)
        case instance(rule: ParserRuleContext.Type, node: JsInitializableNode)
        
        var ruleType: ParserRuleContext.Type {
            switch self {
            case .type(let rule, _, _):
                return rule
            case .instance(let rule, _):
                return rule
            }
        }
    }
}
