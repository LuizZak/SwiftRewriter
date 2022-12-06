import ObjcParserAntlr

public class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<ObjectiveCParser.IdentifierContext> {
    public typealias O = ObjectiveCParser
    
    // MARK: Static shortcuts
    public static func extract(from ctx: O.TypeVariableDeclaratorContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.DeclaratorContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.DirectDeclaratorContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.IdentifierContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.FunctionPointerContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.ParameterDeclarationContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: O.DeclarationSpecifiersContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    
    public static func extractAll(from ctx: O.FieldDeclarationContext) -> [O.IdentifierContext] {
        guard let fieldDeclarators = ctx.fieldDeclaratorList()?.fieldDeclarator() else {
            return []
        }
        
        return fieldDeclarators.compactMap { $0.declarator().flatMap(extract(from:)) }
    }
    
    // MARK: Members
    public override func visitDeclarator(_ ctx: O.DeclaratorContext) -> O.IdentifierContext? {
        ctx.directDeclarator()?.accept(self)
    }
    public override func visitDirectDeclarator(_ ctx: O.DirectDeclaratorContext) -> O.IdentifierContext? {
        ctx.identifier()?.accept(self) ?? ctx.declarator()?.accept(self) ?? ctx.directDeclarator()?.accept(self)
    }
    public override func visitIdentifier(_ ctx: O.IdentifierContext) -> O.IdentifierContext? {
        ctx
    }
    public override func visitFunctionSignature(_ ctx: O.FunctionSignatureContext) -> O.IdentifierContext? {
        ctx.declarator()?.accept(self)
    }
    public override func visitFunctionPointer(_ ctx: O.FunctionPointerContext) -> O.IdentifierContext? {
        ctx.identifier()
    }
    public override func visitParameterDeclaration(_ ctx: ObjectiveCParser.ParameterDeclarationContext) -> ObjectiveCParser.IdentifierContext? {
        ctx.declarator()?.accept(self)
    }
    public override func visitDeclarationSpecifiers(_ ctx: ObjectiveCParser.DeclarationSpecifiersContext) -> ObjectiveCParser.IdentifierContext? {
        for declSpecifier in ctx.declarationSpecifier().reversed() {
            if let identifier = declSpecifier.accept(self) {
                return identifier
            }
        }

        return nil
    }
    public override func visitDeclarationSpecifier(_ ctx: ObjectiveCParser.DeclarationSpecifierContext) -> ObjectiveCParser.IdentifierContext? {
        ctx.typeSpecifier()?.accept(self)
    }
    public override func visitTypeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext) -> ObjectiveCParser.IdentifierContext? {
        ctx.typedefName()?.accept(self) ?? ctx.genericTypeSpecifier()?.accept(self)
    }
    public override func visitTypedefName(_ ctx: ObjectiveCParser.TypedefNameContext) -> ObjectiveCParser.IdentifierContext? {
        ctx.identifier()?.accept(self)
    }
    public override func visitGenericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext) -> ObjectiveCParser.IdentifierContext? {
        ctx.identifier()?.accept(self)
    }
}
