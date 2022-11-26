import ObjcParserAntlr

public class VarDeclarationIdentifierNameExtractor: ObjectiveCParserBaseVisitor<ObjectiveCParser.IdentifierContext> {
    public typealias O = ObjectiveCParser
    
    // MARK: Static shortcuts
    public static func extract(from ctx: O.TypeVariableDeclaratorOrNameContext) -> O.IdentifierContext? {
        ctx.accept(VarDeclarationIdentifierNameExtractor())
    }
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
    
    public static func extractAll(from ctx: O.FieldDeclarationContext) -> [O.IdentifierContext] {
        guard let fieldDeclarators = ctx.fieldDeclaratorList()?.fieldDeclarator() else {
            return []
        }
        
        return fieldDeclarators.compactMap { $0.declarator().flatMap(extract(from:)) }
    }
    
    // MARK: Members
    public override func visitTypeVariableDeclaratorOrName(
        _ ctx: O.TypeVariableDeclaratorOrNameContext) -> O.IdentifierContext? {
        
        ctx.typeVariableDeclarator()?.accept(self)
    }
    public override func visitTypeVariableDeclarator(
        _ ctx: O.TypeVariableDeclaratorContext) -> O.IdentifierContext? {
        
        ctx.declarator()?.accept(self)
    }
    public override func visitDeclarator(_ ctx: O.DeclaratorContext) -> O.IdentifierContext? {
        ctx.directDeclarator()?.accept(self)
    }
    public override func visitDirectDeclarator(_ ctx: O.DirectDeclaratorContext) -> O.IdentifierContext? {
        ctx.identifier()
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
}
