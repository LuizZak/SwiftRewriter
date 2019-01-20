import SwiftSyntax

protocol AttributableGenerationBuilder {
    mutating func addAttribute(_ elt: AttributeSyntax)
}
protocol ModifiableGenerationBuilder {
    mutating func addModifier(_ elt: DeclModifierSyntax)
}

protocol MemberGenerationBuilder: AttributableGenerationBuilder & ModifiableGenerationBuilder { }

extension VariableDeclSyntaxBuilder: MemberGenerationBuilder { }
extension FunctionDeclSyntaxBuilder: MemberGenerationBuilder { }
