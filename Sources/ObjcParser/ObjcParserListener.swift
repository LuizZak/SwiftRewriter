import GrammarModels
import Antlr4
import ObjcParserAntlr

internal class ObjcParserListener: ObjectiveCParserBaseListener {
    let context: NodeCreationContext
    let rootNode: GlobalContextNode
    
    override init() {
        context = NodeCreationContext()
        context.autoUpdatesSourceRange = false
        rootNode = GlobalContextNode()
        
        super.init()
    }
    
    private func parseObjcType(_ source: String) throws -> ObjcType {
        let parser = ObjcParser(source: StringCodeSource(source: source))
        return try parser.parseObjcType()
    }
    
    override func enterClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext) {
        let classNode = context.pushContext(nodeType: ObjcClassInterface.self)
        
        // Class name
        if let ident = ctx.identifier()?.getText() {
            classNode.identifier =
                .valid(Identifier(name: ident))
        }
        
        // Super class name
        if let sup = ctx.superclassName?.getText() {
            context.addChildNode(SuperclassName(name: sup))
        }
    }
    
    override func exitClassInterface(_ ctx: ObjectiveCParser.ClassInterfaceContext) {
        context.popContext() // ObjcClassInterface
    }
    
    override func enterPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        let node = context.pushContext(nodeType: PropertyDefinition.self)
        
        if let ident =
            ctx.fieldDeclaration()?
                .fieldDeclaratorList()?
                .fieldDeclarator(0)?
                .declarator()?
                .directDeclarator()?
                .identifier() {
            
            node.identifier =
                .valid(Identifier(name: ident.getText()))
        }
    }
    
    override func exitPropertyDeclaration(_ ctx: ObjectiveCParser.PropertyDeclarationContext) {
        context.popContext() // PropertyDefinition
    }
    
    override func enterPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        context.pushContext(nodeType: PropertyModifierList.self)
    }
    
    override func exitPropertyAttributesList(_ ctx: ObjectiveCParser.PropertyAttributesListContext) {
        context.popContext() // PropertyModifierList
    }
    
    override func enterPropertyAttribute(_ ctx: ObjectiveCParser.PropertyAttributeContext) {
        let modifier: PropertyModifier.Modifier
        
        if let ident = ctx.identifier()?.getText() {
            if ctx.GETTER() != nil {
                modifier = .getter(ident)
            } else if ctx.SETTER() != nil {
                modifier = .setter(ident)
            } else {
                modifier = .keyword(ident)
            }
        } else {
            modifier = .keyword(ctx.getText())
        }
        
        let node = PropertyModifier(modifier: modifier)
        
        context.addChildNode(node)
    }
}
