import Antlr4
import Utils
import GrammarModelBase
import JsParserAntlr
import JsGrammarModels

class JsASTNodeFactory {
    typealias Parser = JavaScriptParser
    
    let source: Source
    
    init(source: Source) {
        self.source = source
    }
    
    func makeIdentifier(from context: Parser.IdentifierContext) -> JsIdentifierNode {
        let node = JsIdentifierNode(name: context.getText())
        updateSourceLocation(for: node, with: context)
        return node
    }

    func makeVariableDeclarationList(from context: Parser.VariableDeclarationListContext,
                                     varModifier: Parser.VarModifierContext) -> JsVariableDeclarationListNode {
        
        let varModifier = makeVarModifier(from: varModifier)
        let node = JsVariableDeclarationListNode(varModifier: varModifier)

        return node
    }

    func makeVariableDeclaration(from context: Parser.VariableDeclarationContext,
                                 identifier: Parser.IdentifierContext,
                                 initialExpression: Parser.SingleExpressionContext?) -> JsVariableDeclarationNode {
        
        let node = JsVariableDeclarationNode()
        node.addChild(makeIdentifier(from: identifier))

        if let initialExpression = initialExpression {
            node.addChild(makeExpressionNode(from: initialExpression))
        }

        updateSourceLocation(for: node, with: context)
        return node
    }

    func makeExpressionNode(from context: Parser.SingleExpressionContext) -> JsExpressionNode {
        let node = JsExpressionNode()
        node.expression = context
        updateSourceLocation(for: node, with: context)
        return node
    }

    func makeFunctionBodyNode(from context: Parser.FunctionBodyContext) -> JsFunctionBodyNode {
        let node = JsFunctionBodyNode()
        node.body = context
        updateSourceLocation(for: node, with: context)
        return node
    }

    func makeClassPropertyNode(
        from context: Parser.ClassElementContext,
        identifier: Parser.IdentifierContext,
        expression: Parser.SingleExpressionContext
    ) -> JsClassPropertyNode {
        let node = JsClassPropertyNode()
        node.addChild(makeIdentifier(from: identifier))
        node.addChild(makeExpressionNode(from: expression))
        updateSourceLocation(for: node, with: context)
        return node
    }

    func makeVarModifier(from context: Parser.VarModifierContext) -> JsVariableDeclarationListNode.VarModifier {
        Self.makeVarModifier(from: context)
    }

    static func makeVarModifier(from context: Parser.VarModifierContext) -> JsVariableDeclarationListNode.VarModifier {
        if context.Var() != nil {
            return .var
        }
        if context.let_() != nil {
            return .let
        }
        if context.Const() != nil {
            return .const
        }

        return .var
    }

    // MARK: - Source location update
    
    func updateSourceLocation(for node: JsASTNode, with rule: ParserRuleContext) {
        (node.location, node.length) = sourceLocationAndLength(for: rule)
    }
    
    func sourceLocationAndLength(for rule: ParserRuleContext) -> (SourceLocation, SourceLength) {
        guard let startIndex = rule.start?.getStartIndex(), let endIndex = rule.stop?.getStopIndex() else {
            return (.invalid, .zero)
        }
        
        let sourceStartIndex = source.stringIndex(forCharOffset: startIndex)
        let sourceEndIndex = source.stringIndex(forCharOffset: endIndex)
        
        let startLine = source.lineNumber(at: sourceStartIndex)
        let startColumn = source.columnNumber(at: sourceStartIndex)
        let endLine = source.lineNumber(at: sourceEndIndex)
        let endColumn = source.columnNumber(at: sourceEndIndex)
        
        let location =
            SourceLocation(line: startLine,
                           column: startColumn,
                           utf8Offset: startIndex)
        
        let length =
            SourceLength(newlines: endLine - startLine,
                         columnsAtLastLine: endColumn,
                         utf8Length: endIndex - startIndex)
        
        return (location, length)
    }
}
