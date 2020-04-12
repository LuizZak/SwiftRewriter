import SwiftSyntax
import Intentions
import SwiftAST

struct VariableDeclaration {
    var constant: Bool
    var attributes: [() -> AttributeSyntax]
    var modifiers: ModifiersDecoratorResult
    var kind: VariableDeclarationKind
}

struct PatternBindingElement {
    var name: String
    var type: SwiftType?
    var intention: IntentionProtocol?
    var initialization: Expression?
}

enum VariableDeclarationKind {
    case single(pattern: PatternBindingElement, accessors: (() -> Syntax)?)
    case multiple(patterns: [PatternBindingElement])
}
