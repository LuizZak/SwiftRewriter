import Intentions
import JsGrammarModels

extension Intention {
    func _typedSource<T>() -> T? {
        source as? T
    }
}

extension GlobalVariableGenerationIntention {
    var variableSource: JsVariableDeclarationNode? { _typedSource() }
}

extension GlobalVariableInitialValueIntention {
    var typedSource: JsExpressionNode? { _typedSource() }
}

extension GlobalFunctionGenerationIntention {
    var typedSource: JsFunctionDeclarationNode? { _typedSource() }
}

extension FunctionBodyIntention {
    var typedSource: JsFunctionBodyNode? { _typedSource() }
}

extension MethodGenerationIntention {
    var typedSource: JsMethodDefinitionNode? { _typedSource() }
}
