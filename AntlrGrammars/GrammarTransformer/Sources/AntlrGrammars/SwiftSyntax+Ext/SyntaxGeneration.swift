import SwiftSyntax

internal func declModifier(_ identifier: String) -> DeclModifierSyntax {
    declModifier(identifierToken(identifier))
}

internal func declModifier(_ token: TokenSyntax) -> DeclModifierSyntax {
    DeclModifierSyntax(name: token)
}

internal func identifierPattern(_ identifier: String) -> PatternSyntax {
    IdentifierPatternSyntax(identifier: identifierToken(identifier)).asPatternSyntax
}

internal func identifierExpr(_ identifier: String) -> ExprSyntax {
    IdentifierExprSyntax(identifier: identifierToken(identifier)).asExprSyntax
}

internal func identifierToken(_ identifier: String) -> TokenSyntax {
    .identifier(identifier)
}

internal func typeName(_ identifier: String) -> TypeSyntax {
    SimpleTypeIdentifierSyntax(name: identifierToken(identifier)).asTypeSyntax
}

internal func arrayType(of elementType: TypeSyntax) -> TypeSyntax {
    ArrayTypeSyntax(elementType: elementType).asTypeSyntax
}

internal func memberAccessExpr(_ baseIdentifier: String, _ member: String) -> ExprSyntax {
    return MemberAccessExprSyntax(
        base: identifierExpr(baseIdentifier),
        dot: .periodToken(),
        name: identifierToken(member)
    ).asExprSyntax
}
