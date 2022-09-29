import SwiftSyntax

internal func declModifier(_ identifier: String) -> DeclModifierSyntax {
    declModifier(identifierToken(identifier))
}

internal func declModifier(_ token: TokenSyntax) -> DeclModifierSyntax {
    DeclModifierSyntax { mod in
        mod.useName(token)
    }
}

internal func identifierPattern(_ identifier: String) -> PatternSyntax {
    IdentifierPatternSyntax { build in
        build.useIdentifier(identifierToken(identifier))
    }.asPatternSyntax
}

internal func identifierExpr(_ identifier: String) -> ExprSyntax {
    IdentifierExprSyntax { build in
        build.useIdentifier(identifierToken(identifier))
    }.asExprSyntax
}

internal func identifierToken(_ identifier: String) -> TokenSyntax {
    SyntaxFactory.makeIdentifier(identifier)
}

internal func typeName(_ identifier: String) -> TypeSyntax {
    SimpleTypeIdentifierSyntax {
        $0.useName(identifierToken(identifier))
    }.asTypeSyntax
}

internal func arrayType(of elementType: TypeSyntax) -> TypeSyntax {
    ArrayTypeSyntax { builder in
        builder.useLeftSquareBracket(
            SyntaxFactory.makeLeftSquareBracketToken()
        )

        builder.useElementType(elementType)

        builder.useRightSquareBracket(
            SyntaxFactory.makeRightSquareBracketToken()
        )
    }.asTypeSyntax
}

internal func memberAccessExpr(_ baseIdentifier: String, _ member: String) -> ExprSyntax {
    MemberAccessExprSyntax { builder in
        builder.useBase(identifierExpr(baseIdentifier))
        builder.useDot(SyntaxFactory.makePeriodToken())
        builder.useName(identifierToken(member))
    }.asExprSyntax
}
