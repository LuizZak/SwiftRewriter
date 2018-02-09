import ObjcParserAntlr

public class VarDeclarationTypeExtractor: ObjectiveCParserBaseVisitor<String> {
    public var declaratorIndex: Int = 0
    
    public override func visitVarDeclaration(_ ctx: ObjectiveCParser.VarDeclarationContext) -> String? {
        guard let initDeclarator = ctx.initDeclaratorList()?.initDeclarator(declaratorIndex) else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = initDeclarator.declarator()?.pointer()?.accept(self) ?? ""
        
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString = "\(specifiersString) \(pointer)"
        
        return typeString
    }
    
    public override func visitForLoopInitializer(_ ctx: ObjectiveCParser.ForLoopInitializerContext) -> String? {
        guard let initDeclarator = ctx.initDeclaratorList()?.initDeclarator(declaratorIndex) else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = initDeclarator.declarator()?.pointer()?.accept(self) ?? ""
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString = "\(specifiersString) \(pointer)"
        
        return typeString
    }
    
    public override func visitTypeVariableDeclarator(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext) -> String? {
        guard let declarator = ctx.declarator() else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = declarator.pointer()?.accept(self) ?? ""
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString = "\(specifiersString) \(pointer)"
        
        return typeString
    }
    
    public override func visitTypeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext) -> String? {
        // TODO: Support typeofExpression
        if ctx.typeofExpression() != nil {
            return nil
        }
        // TODO: Support enumSpecifier
        if ctx.enumSpecifier() != nil {
            return nil
        }
        // TODO: Support structOrUnionSpecifier
        if ctx.structOrUnionSpecifier() != nil {
            return nil
        }
        
        if let genericTypeSpecifier = ctx.genericTypeSpecifier() {
            return genericTypeSpecifier.getText()
        }
        
        return ctx.getText()
    }
    
    public override func visitTypeVariableDeclaratorOrName(_ ctx: ObjectiveCParser.TypeVariableDeclaratorOrNameContext) -> String? {
        if let typeName = ctx.typeName() {
            return typeName.accept(self)
        }
        
        guard let typeVarDeclarator = ctx.typeVariableDeclarator() else {
            return nil
        }
        guard let declarationSpecifiers = typeVarDeclarator.declarationSpecifiers() else {
            return nil
        }
        guard let typeDeclarator = typeVarDeclarator.declarator() else {
            return nil
        }
        
        let pointer = typeDeclarator.pointer()?.accept(self)
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString = "\(specifiersString) \(pointer ?? "")"
        
        return typeString
    }
    
    public override func visitBlockType(_ ctx: ObjectiveCParser.BlockTypeContext) -> String? {
        guard let returnTypeSpecifier = ctx.typeSpecifier(0) else {
            return nil
        }
        guard let returnType = returnTypeSpecifier.accept(self) else {
            return nil
        }
        
        var parameterTypes: [String] = []
        
        if let blockParameters = ctx.blockParameters() {
            for param in blockParameters.typeVariableDeclaratorOrName() {
                guard let paramType = param.accept(self) else {
                    continue
                }
                
                parameterTypes.append(paramType)
            }
        }
        
        return "(\(parameterTypes.joined(separator: ", "))) -> \(returnType)"
    }
    
    public override func visitTypeName(_ ctx: ObjectiveCParser.TypeNameContext) -> String? {
        // Block type
        if let blockType = ctx.blockType() {
            return blockType.accept(self)
        }
        
        guard let specifierQualifierList = ctx.specifierQualifierList() else {
            return nil
        }
        let specifierList = specifierQualifierList.accept(self) ?? ""
        
        let abstractDeclarator = ctx.abstractDeclarator()?.getText() ?? ""
        
        return "\(specifierList) \(abstractDeclarator)"
    }
    
    public override func visitPointer(_ ctx: ObjectiveCParser.PointerContext) -> String? {
        var pointerStr = "*"
        
        if let declSpecifier = ctx.declarationSpecifiers()?.accept(self) {
            pointerStr += "\(declSpecifier)"
        }
        if let subPointerStr = ctx.pointer()?.accept(self) {
            pointerStr += subPointerStr
        }
        
        return pointerStr
    }
    
    public override func visitSpecifierQualifierList(_ ctx: ObjectiveCParser.SpecifierQualifierListContext) -> String? {
        guard let children = ctx.children else {
            return nil
        }
        
        return children.map {
            $0.getText()
        }.joined(separator: " ")
    }
    
    public override func visitDeclarationSpecifiers(_ ctx: ObjectiveCParser.DeclarationSpecifiersContext) -> String? {
        guard let children = ctx.children else {
            return nil
        }
        
        return children.map {
            $0.getText()
        }.joined(separator: " ")
    }
}

