import Intentions
import ObjcGrammarModels

extension Intention {
    func _typedSource<T>() -> T? {
        source as? T
    }
}

extension GlobalVariableGenerationIntention {
    var variableSource: ObjcVariableDeclarationNode? { _typedSource() }
}

extension GlobalVariableInitialValueIntention {
    var typedSource: ObjcInitialExpressionNode? { _typedSource() }
}

extension GlobalFunctionGenerationIntention {
    var typedSource: ObjcFunctionDefinitionNode? { _typedSource() }
}

extension FunctionBodyIntention {
    var typedSource: ObjcMethodBodyNode? { _typedSource() }
}

extension PropertyGenerationIntention {
    var propertySource: ObjcPropertyDefinitionNode? { _typedSource() }
}

extension MethodGenerationIntention {
    var typedSource: ObjcMethodDefinitionNode? { _typedSource() }
}

extension InstanceVariableGenerationIntention {
    var typedSource: ObjcIVarDeclarationNode? { _typedSource() }
}

extension EnumGenerationIntention {
    var typedSource: ObjcEnumDeclarationNode? { _typedSource() }
}

extension EnumCaseGenerationIntention {
    var typedSource: ObjcEnumCaseNode? { _typedSource() }
}
