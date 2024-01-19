import SwiftSyntax
import Intentions
import SwiftAST

struct ObjcVariableDeclarationNode {
    var constant: Bool
    var attributes: [() -> AttributeListSyntax.Element]
    var modifiers: [ModifiersDecoratorResult]
    var kind: VariableDeclarationKind
}

struct PatternBindingElement {
    var name: String
    var type: SwiftType?
    var intention: IntentionProtocol?
    var initialization: Expression?
}

enum VariableDeclarationKind {
    case single(pattern: PatternBindingElement, accessors: (() -> AccessorBlockSyntax)?)
    case multiple(patterns: [PatternBindingElement])
}
