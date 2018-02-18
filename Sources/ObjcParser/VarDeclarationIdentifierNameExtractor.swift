import ObjcParserAntlr

public class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<String> {
    // MARK: Static shortcuts
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.TypeDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DirectDeclaratorContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.IdentifierContext) -> String? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    
    public static func extractAll(from ctx: ObjectiveCParser.FieldDeclarationContext) -> [String] {
        guard let fieldDeclarators = ctx.fieldDeclaratorList()?.fieldDeclarator() else {
            return []
        }
        
        return fieldDeclarators.compactMap { $0.declarator().flatMap(extract(from:)) }
    }
    
    // MARK: Members
    public override func visitTypeVariableDeclaratorOrName(_ ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> String? {
        return ctx.typeVariableDeclarator()?.accept(self)
    }
    public override func visitTypeDeclarator(_ ctx: ObjectiveCParser.TypeDeclaratorContext) -> String? {
        return ctx.directDeclarator()?.accept(self)
    }
    public override func visitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        return ctx.declarator()?.accept(self)
    }
    public override func visitDeclarator(_ ctx: ObjectiveCParser.DeclaratorContext) -> String? {
        return ctx.directDeclarator()?.accept(self)
    }
    public override func visitDirectDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext) -> String? {
        return ctx.identifier()?.accept(self)
    }
    public override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> String? {
        return ctx.getText()
    }
}
