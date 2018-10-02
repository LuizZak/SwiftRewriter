import ObjcParserAntlr
import Antlr4

public class VarDeclarationTypeExtractor: ObjectiveCParserBaseVisitor<String> {
    public typealias Parser = ObjectiveCParser
    
    public typealias TypeName = String
    
    public var declaratorIndex: Int = 0
    
    public static func extract(from typeDeclaratorOrName: Parser.TypeVariableDeclaratorOrNameContext) -> TypeName? {
        return _extract(from: typeDeclaratorOrName)
    }
    public static func extract(from typeSpecifier: Parser.TypeSpecifierContext) -> TypeName? {
        return _extract(from: typeSpecifier)
    }
    public static func extract(from typeName: Parser.TypeNameContext) -> TypeName? {
        return _extract(from: typeName)
    }
    public static func extract(from rule: Parser.TypeVariableDeclaratorContext) -> TypeName? {
        return _extract(from: rule)
    }
    public static func extract(from rule: Parser.SpecifierQualifierListContext) -> TypeName? {
        return _extract(from: rule)
    }
    public static func extract(from rule: Parser.DeclarationSpecifiersContext) -> TypeName? {
        return _extract(from: rule)
    }
    public static func extract(from rule: Parser.VarDeclarationContext, atIndex index: Int = 0) -> TypeName? {
        return _extract(from: rule, atIndex: index)
    }
    public static func extract(from rule: Parser.ForLoopInitializerContext, atIndex index: Int = 0) -> TypeName? {
        return _extract(from: rule, atIndex: index)
    }
    
    public static func extractAll(from rule: Parser.VarDeclarationContext) -> [TypeName] {
        return _extractAll(from: rule)
    }
    public static func extractAll(from rule: Parser.ForLoopInitializerContext) -> [TypeName] {
        return _extractAll(from: rule)
    }
    public static func extractAll(from rule: Parser.BlockParametersContext) -> [TypeName] {
        return _extractAll(from: rule)
    }
    public static func extractAll(from rule: Parser.FieldDeclarationContext) -> [TypeName] {
        return _extractAll(from: rule)
    }
    
    private static func _extract(from rule: ParserRuleContext, atIndex index: Int = 0) -> TypeName? {
        let ext = VarDeclarationTypeExtractor()
        ext.declaratorIndex = index
        
        return rule.accept(ext)
    }
    
    private static func _extractAll(from rule: ParserRuleContext) -> [TypeName] {
        let ext = VarDeclarationTypeExtractor()
        
        if let vdec = rule as? Parser.VarDeclarationContext {
            guard let count = vdec.initDeclaratorList()?.initDeclarator().count else {
                return []
            }
            
            return (0..<count).compactMap { i -> TypeName? in
                ext.declaratorIndex = i
                
                return vdec.accept(ext)
            }
        }
        if let loopInit = rule as? Parser.ForLoopInitializerContext {
            guard let count = loopInit.initDeclaratorList()?.initDeclarator().count else {
                return []
            }
            
            return (0..<count).compactMap { i -> TypeName? in
                ext.declaratorIndex = i
                
                return loopInit.accept(ext)
            }
        }
        if let blockParameters = rule as? Parser.BlockParametersContext {
            var parameterTypes: [TypeName] = []
            
            for param in blockParameters.typeVariableDeclaratorOrName() {
                guard let paramType = param.accept(ext) else {
                    continue
                }
                
                parameterTypes.append(paramType)
            }
            
            return parameterTypes
        }
        if let fieldDeclaration = rule as? Parser.FieldDeclarationContext {
            var typeNames: [TypeName] = []
            
            guard let fieldDeclaratorList = fieldDeclaration.fieldDeclaratorList() else {
                return []
            }
            guard let specifierQualifierList = fieldDeclaration.specifierQualifierList()?.accept(ext) else {
                return []
            }
            for declarator in fieldDeclaratorList.fieldDeclarator() {
                guard let directDeclarator = declarator.declarator()?.directDeclarator() else {
                    continue
                }
                
                if let blockParameters = directDeclarator.blockParameters() {
                    var blockType = ""
                    
                    let parameters = extractAll(from: blockParameters)
                    
                    blockType += specifierQualifierList
                    
                    blockType += "(^"
                    
                    if let nullabilitySpecifier = directDeclarator.nullabilitySpecifier() {
                        blockType += nullabilitySpecifier.getText()
                    }
                    
                    blockType += ")"
                    
                    blockType += "("
                    blockType += parameters.joined(separator: ", ")
                    blockType += ")"
                    
                    typeNames.append(blockType)
                } else {
                    if let pointer = declarator.declarator()?.pointer()?.accept(ext) {
                        typeNames.append(specifierQualifierList + " " + pointer)
                    } else {
                        typeNames.append(specifierQualifierList)
                    }
                }
            }
            
            return typeNames
        }
        
        return rule.accept(ext).map { [$0] } ?? []
    }
    
    public override func visitVarDeclaration(_ ctx: Parser.VarDeclarationContext) -> TypeName? {
        guard let initDeclarator = ctx.initDeclaratorList()?.initDeclarator(declaratorIndex) else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = initDeclarator.declarator()?.pointer()?.accept(self)
        
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString: String
        if let pointer = pointer {
            typeString = "\(specifiersString) \(pointer)"
        } else {
            typeString = specifiersString
        }
        
        return typeString
    }
    
    public override func visitForLoopInitializer(_ ctx: Parser.ForLoopInitializerContext) -> TypeName? {
        guard let initDeclarator = ctx.initDeclaratorList()?.initDeclarator(declaratorIndex) else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let pointer = initDeclarator.declarator()?.pointer()?.accept(self)
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString: String
        if let pointer = pointer {
            typeString = "\(specifiersString) \(pointer)"
        } else {
            typeString = specifiersString
        }
        
        return typeString
    }
    
    public override func visitTypeVariableDeclarator(_ ctx: Parser.TypeVariableDeclaratorContext) -> TypeName? {
        guard let declarator = ctx.declarator() else { return nil }
        
        // Get a type string to convert into a proper type
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else { return nil }
        let decl = declarator.accept(self) ?? ""
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        let typeString = "\(specifiersString) \(decl)"
        
        return typeString
    }
    
    public override func visitTypeSpecifier(_ ctx: Parser.TypeSpecifierContext) -> TypeName? {
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
    
    public override func visitTypeVariableDeclaratorOrName(
        _ ctx: Parser.TypeVariableDeclaratorOrNameContext) -> TypeName? {
        
        if let typeName = ctx.typeName() {
            return typeName.accept(self)
        }
        
        guard let typeVarDeclarator = ctx.typeVariableDeclarator() else {
            return nil
        }
        guard let declarationSpecifiers = typeVarDeclarator.declarationSpecifiers() else {
            return nil
        }
        guard let declarator = typeVarDeclarator.declarator() else {
            return nil
        }
        
        let pointer = declarator.pointer()?.accept(self)
        let specifiersString = declarationSpecifiers.accept(self) ?? ""
        
        var typeString = specifiersString
        if let pointer = pointer {
            typeString += " \(pointer)"
        }
        
        return typeString
    }
    
    public override func visitBlockType(_ ctx: Parser.BlockTypeContext) -> TypeName? {
        guard let returnTypeSpecifier = ctx.typeSpecifier(0) else {
            return nil
        }
        guard let returnType = returnTypeSpecifier.accept(self) else {
            return nil
        }
        
        var type = ""
        
        if let blockNullability = ctx.nullabilitySpecifier(0) {
            type += "\(blockNullability.getText()) "
        }
        
        type += "\(returnType) "
        
        if let returnNullability = ctx.nullabilitySpecifier(1) {
            type += "\(returnNullability.getText()) "
        }
        
        type += "(^"
        
        if let blockNullability = ctx.nullabilitySpecifier(2) {
            type += "\(blockNullability.getText()) "
        } else if let typeSpecifier = ctx.typeSpecifier(1)?.accept(self) {
            type += "\(typeSpecifier) "
        }
        
        type += ")"
        
        if let blockParameters = ctx.blockParameters() {
            let parameterTypes = VarDeclarationTypeExtractor.extractAll(from: blockParameters)
            
            type += "("
            type += parameterTypes.joined(separator: ", ")
            type += ")"
        }
        
        return type
    }
    
    public override func visitDeclarator(_ ctx: Parser.DeclaratorContext) -> TypeName? {
        guard let directDeclarator = ctx.directDeclarator()?.accept(self) else {
            return nil
        }
        
        if let pointer = ctx.pointer()?.accept(self) {
            return pointer + " " + directDeclarator
        }
        
        return directDeclarator
    }
    
    public override func visitDirectDeclarator(_ ctx: Parser.DirectDeclaratorContext) -> TypeName? {
        if let blockParameters = ctx.blockParameters() {
            let parameterTypes = VarDeclarationTypeExtractor.extractAll(from: blockParameters)
            
            var type = ""
            
            type += "(^"
            
            if let blockNullability = ctx.nullabilitySpecifier() {
                type += blockNullability.getText()
            }
            
            type += ")"
            
            type += "(" + parameterTypes.joined(separator: ", ") + ")"
            
            return type
        }
        if let declarator = ctx.declarator() {
            return declarator.accept(self)
        }
        if let identifier = ctx.identifier() {
            return identifier.getText()
        }
        
        return nil
    }
    
    public override func visitTypeName(_ ctx: Parser.TypeNameContext) -> TypeName? {
        // Block type
        if let blockType = ctx.blockType() {
            return blockType.accept(self)
        }
        
        guard let specifierQualifierList = ctx.specifierQualifierList() else {
            return nil
        }
        let specifierList = specifierQualifierList.accept(self) ?? ""
        
        if let abstractDeclarator = ctx.abstractDeclarator()?.getText() {
            return "\(specifierList) \(abstractDeclarator)"
        }
        
        return specifierList
    }
    
    public override func visitPointer(_ ctx: Parser.PointerContext) -> TypeName? {
        var pointerStr = "*"
        
        if let declSpecifier = ctx.declarationSpecifiers()?.accept(self) {
            pointerStr += "\(declSpecifier)"
        }
        if let subPointerStr = ctx.pointer()?.accept(self) {
            pointerStr += subPointerStr
        }
        
        return pointerStr
    }
    
    public override func visitSpecifierQualifierList(_ ctx: Parser.SpecifierQualifierListContext) -> TypeName? {
        guard let children = ctx.children else {
            return nil
        }
        
        return children.map {
            $0.getText()
        }.joined(separator: " ")
    }
    
    public override func visitDeclarationSpecifiers(_ ctx: Parser.DeclarationSpecifiersContext) -> TypeName? {
        guard let children = ctx.children else {
            return nil
        }
        
        var output = ""
        
        for (i, child) in children.enumerated() {
            if i > 0 {
                output += " "
            }
            
            if let typeSpecifier = child as? Parser.TypeSpecifierContext {
                if typeSpecifier.structOrUnionSpecifier() != nil {
                    continue
                }
                if typeSpecifier.enumSpecifier() != nil {
                    continue
                }
            }
            
            output += child.getText()
        }
        
        return output
    }
    
    public override func visitFunctionPointer(_ ctx: ObjectiveCParser.FunctionPointerContext) -> TypeName? {
        var output = ""
        
        if let specifiers = ctx.declarationSpecifiers()?.accept(self) {
            output += specifiers
        }
        
        output += "(*"
        
        if let identifier = ctx.identifier()?.getText() {
            output += identifier
        }
        
        output += ")("
        
        let parameterList =
            ctx.functionPointerParameterList()?
                .functionPointerParameterDeclarationList()?
                .functionPointerParameterDeclaration()
        
        if let parameterList = parameterList {
            for (i, param) in parameterList.enumerated() {
                if i > 0 {
                    output += ", "
                }
                
                if let declSpec = param.declarationSpecifiers()?.accept(self) {
                    output += declSpec
                } else if let functionPointer = param.functionPointer()?.accept(self) {
                    output += functionPointer
                }
            }
        }
        
        output += ")"
        
        return output
    }
}
