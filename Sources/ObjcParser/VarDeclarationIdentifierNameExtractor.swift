import ObjcParserAntlr

public class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<ObjectiveCParser.IdentifierContext> {
    // MARK: Static shortcuts
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.DirectDeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.IdentifierContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    public static func extract(from ctx: ObjectiveCParser.FunctionPointerContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
    
    public static func extractAll(from ctx: ObjectiveCParser.FieldDeclarationContext) -> [ObjectiveCParser.IdentifierContext] {
        guard let fieldDeclarators = ctx.fieldDeclaratorList()?.fieldDeclarator() else {
            return []
        }
        
        return fieldDeclarators.compactMap { $0.declarator().flatMap(extract(from:)) }
    }
    
    // MARK: Members
    public override func visitTypeVariableDeclaratorOrName(
        _ ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> ObjectiveCParser.IdentifierContext? {
        
        return ctx.typeVariableDeclarator()?.accept(self)
    }
    public override func visitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.declarator()?.accept(self)
    }
    public override func visitDeclarator(_ ctx: ObjectiveCParser.DeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.directDeclarator()?.accept(self)
    }
    public override func visitDirectDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.identifier()
    }
    public override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx
    }
    public override func visitFunctionPointer(_ ctx: ObjectiveCParser.FunctionPointerContext) -> ObjectiveCParser.IdentifierContext? {
        return ctx.identifier()
    }
}
