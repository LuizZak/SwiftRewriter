import GrammarModels
import Antlr4
import ObjcParserAntlr

// TODO: Add tests for this class
public class TypeParsing {
    public typealias Parser = ObjectiveCParser
    
    public let state: ObjcParserState
    public let antlrSettings: AntlrSettings
    
    public init(state: ObjcParserState, antlrSettings: AntlrSettings = .default) {
        self.state = state
        self.antlrSettings = antlrSettings
    }
    
    // Helper for mapping Objective-C types from raw strings into a structured types
    public func parseObjcType(_ source: String) -> ObjcType? {
        let parser = ObjcParser(source: StringCodeSource(source: source), state: state)
        parser.antlrSettings = antlrSettings
        return try? parser.parseObjcType()
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcTypes(in decl: Parser.FieldDeclarationContext) -> [ObjcType] {
        var types: [ObjcType] = []
        
        guard let specQualifier = decl.specifierQualifierList() else {
            return []
        }
        guard let baseTypeString = specQualifier.typeSpecifier(0)?.getText() else {
            return []
        }
        
        guard let fieldDeclaratorList = decl.fieldDeclaratorList() else {
            return []
        }
        
        for fieldDeclarator in fieldDeclaratorList.fieldDeclarator() {
            guard let declarator = fieldDeclarator.declarator() else {
                continue
            }
            
            let pointer = declarator.pointer()?.accept(VarDeclarationTypeExtractor())
            
            var typeName = "\(baseTypeString) \(pointer ?? "")"
            
            if !specQualifier.arcBehaviourSpecifier().isEmpty {
                let arcSpecifiers =
                    specQualifier.arcBehaviourSpecifier().map {
                        $0.getText()
                    }
                
                typeName = "\(arcSpecifiers.joined(separator: " ")) \(typeName)"
            }
            
            if let type = parseObjcType(typeName) {
                types.append(handleFixedArray(type, declarator: declarator))
            }
        }
        
        return types
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcType(in decl: Parser.FieldDeclarationContext) -> ObjcType? {
        guard let specQualifier = decl.specifierQualifierList() else {
            return nil
        }
        guard let declarator = decl.fieldDeclaratorList()?.fieldDeclarator(0)?.declarator() else {
            return nil
        }
        
        return parseObjcType(in: specQualifier, declarator: declarator)
    }
    
    public func parseObjcType(in specQual: Parser.SpecifierQualifierListContext) -> ObjcType? {
        guard let typeName = VarDeclarationTypeExtractor.extract(from: specQual) else {
            return nil
        }
        
        return parseObjcType(typeName)
    }
    
    public func parseObjcType(in specifierQualifierList: Parser.SpecifierQualifierListContext,
                              declarator: Parser.DeclaratorContext) -> ObjcType? {
        
        guard let specifiersString = VarDeclarationTypeExtractor.extract(from: specifierQualifierList) else {
            return nil
        }
        
        let pointer = declarator.pointer()?.accept(VarDeclarationTypeExtractor())
        
        let typeString = "\(specifiersString) \(pointer ?? "")"
        
        guard let type = parseObjcType(typeString) else {
            return nil
        }
        
        // Block type
        if let blockType = manageBlock(baseType: type,
                                       qualifiers: TypeParsing.qualifiers(from: specifierQualifierList),
                                       declarator: declarator) {
            return blockType
        }
        
        return handleFixedArray(type, declarator: declarator)
    }
    
    public func parseObjcType(in declarationSpecifiers: Parser.DeclarationSpecifiersContext) -> ObjcType? {
        guard let specifiersString = VarDeclarationTypeExtractor.extract(from: declarationSpecifiers) else {
            return nil
        }
        
        return parseObjcType(specifiersString)
    }
    
    public func parseObjcType(in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
                              declarator: Parser.DeclaratorContext) -> ObjcType? {
        
        guard let specifiersString = VarDeclarationTypeExtractor.extract(from: declarationSpecifiers) else {
            return nil
        }
        
        let pointer = declarator.pointer()
        
        let typeString = "\(specifiersString) \(pointer?.getText() ?? "")"
        
        guard let type = parseObjcType(typeString) else {
            return nil
        }
        
        // Block type
        if let blockType = manageBlock(baseType: type,
                                       qualifiers: TypeParsing.qualifiers(from: declarationSpecifiers),
                                       declarator: declarator) {
            return blockType
        }
        
        return handleFixedArray(type, declarator: declarator)
    }
    
    private func manageBlock(baseType: ObjcType,
                             qualifiers: [Parser.TypeQualifierContext],
                             declarator: Parser.DeclaratorContext) -> ObjcType? {
        var type = baseType
        
        // Block type
        if let directDeclarator = declarator.directDeclarator(),
            let blockParameters = directDeclarator.blockParameters() {
            
            let isFunctionPointer = directDeclarator.MUL() != nil
            let blockParameterTypes = parseObjcTypes(from: blockParameters)
            let blockIdentifier = directDeclarator.identifier()
            
            if isFunctionPointer {
                type = .functionPointer(name: blockIdentifier?.getText(),
                                        returnType: type,
                                        parameters: blockParameterTypes)
            } else {
                type = .blockType(name: blockIdentifier?.getText(),
                                  returnType: type,
                                  parameters: blockParameterTypes)
            }
            
            // Verify qualifiers
            if !qualifiers.isEmpty {
                let qualifiers = qualifiers.map { $0.getText() }
                type = .specified(specifiers: qualifiers, type)
            }
            // Verify nullability specifiers
            if let nullabilitySpecifier = directDeclarator.nullabilitySpecifier() {
                type = .qualified(type, qualifiers: [nullabilitySpecifier.getText()])
            }
            
            return type
        }
        
        return nil
    }
    
    public func parseObjcTypes(from blockParameters: Parser.BlockParametersContext) -> [ObjcType] {
        let typeVariableDeclaratorOrNames = blockParameters.typeVariableDeclaratorOrName()
        
        var paramTypes: [ObjcType] = []
        
        for typeVariableDeclaratorOrName in typeVariableDeclaratorOrNames {
            guard let paramType = parseObjcType(from: typeVariableDeclaratorOrName) else {
                continue
            }
            
            paramTypes.append(paramType)
        }
        
        return paramTypes
    }
    
    public func parseObjcType(from typeContext: Parser.TypeVariableDeclaratorOrNameContext) -> ObjcType? {
        if let typeName = typeContext.typeName(),
            let type = parseObjcType(from: typeName) {
            return type
        } else if let typeVariableDecl = typeContext.typeVariableDeclarator() {
            if typeVariableDecl.declarator()?.directDeclarator()?.blockParameters() != nil {
                return parseObjcType(from: typeVariableDecl)
            }
            
            if let type = parseObjcType(from: typeVariableDecl) {
                return type
            } else {
                return nil
            }
        }
        
        guard let typeString = VarDeclarationTypeExtractor.extract(from: typeContext) else {
            return nil
        }
        
        return parseObjcType(typeString)
    }
    
    public func parseObjcType(from typeVariableDecl: Parser.TypeVariableDeclaratorContext) -> ObjcType? {
        if let blockParameters = typeVariableDecl.declarator()?.directDeclarator()?.blockParameters() {
            guard let declarationSpecifiers = typeVariableDecl.declarationSpecifiers() else {
                return nil
            }
            
            let parameters = parseObjcTypes(from: blockParameters)
            
            guard let returnTypeName = VarDeclarationTypeExtractor.extract(from: declarationSpecifiers) else {
                return nil
            }
            guard let returnType = parseObjcType(returnTypeName) else { return nil }
            
            let identifier = VarDeclarationIdentifierNameExtractor.extract(from: typeVariableDecl)
            
            var type: ObjcType = .blockType(name: identifier?.getText(),
                                            returnType: returnType,
                                            parameters: parameters)
            
            if let nullability = typeVariableDecl.declarator()?.directDeclarator()?.nullabilitySpecifier() {
                type = .qualified(type, qualifiers: [nullability.getText()])
            }
            
            return type
        }
        
        guard let typeString = VarDeclarationTypeExtractor.extract(from: typeVariableDecl) else {
            return nil
        }
        guard let type = parseObjcType(typeString) else {
            return nil
        }
        
        return type
    }
    
    public func parseObjcType(from typeSpecifier: Parser.TypeSpecifierContext) -> ObjcType? {
        guard let typeString = VarDeclarationTypeExtractor.extract(from: typeSpecifier) else {
            return nil
        }
        guard let type = parseObjcType(typeString) else {
            return nil
        }
        
        return type
    }
    
    public func parseObjcType(from blockType: Parser.BlockTypeContext) -> ObjcType? {
        guard let returnTypeSpecifier = blockType.typeSpecifier(0) else {
            return nil
        }
        guard let returnType = parseObjcType(from: returnTypeSpecifier) else {
            return nil
        }
        
        var parameterTypes: [ObjcType] = []
        
        if let blockParameters = blockType.blockParameters() {
            for param in blockParameters.typeVariableDeclaratorOrName() {
                guard let paramType = parseObjcType(from: param) else {
                    continue
                }
                
                parameterTypes.append(paramType)
            }
        }
        
        var type = ObjcType.blockType(name: nil, returnType: returnType, parameters: parameterTypes)
        
        if let nullability = blockType.nullabilitySpecifier().last {
            type = .qualified(type, qualifiers: [nullability.getText()])
        }
        
        return type
    }
    
    public func parseObjcType(from typeName: Parser.TypeNameContext) -> ObjcType? {
        // Block type
        if let blockType = typeName.blockType() {
            return parseObjcType(from: blockType)
        }
        
        guard let typeString = VarDeclarationTypeExtractor.extract(from: typeName) else {
            return nil
        }
        guard let type = parseObjcType(typeString) else {
            return nil
        }
        
        return type
    }
    
    public func parseObjcType(from ctx: Parser.FunctionPointerContext) -> ObjcType? {
        guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
            return nil
        }
        guard let returnType = parseObjcType(in: declarationSpecifiers) else {
            return nil
        }
        guard let identifier = ctx.identifier() else {
            return nil
        }
        guard let parameterList = ctx.functionPointerParameterList()?.functionPointerParameterDeclarationList() else {
            return nil
        }
        
        let parameterDeclarations = parameterList.functionPointerParameterDeclaration()
        
        var parameters: [ObjcType] = []
        
        for parameter in parameterDeclarations {
            if let declarationSpecifier = parameter.declarationSpecifiers() {
                let type: ObjcType?
                
                if let declarator = parameter.declarator() {
                    type = parseObjcType(in: declarationSpecifier,
                                         declarator: declarator)
                } else {
                    type = parseObjcType(in: declarationSpecifier)
                }
                
                if let type = type {
                    parameters.append(type)
                }
            } else if let functionPointer = parameter.functionPointer() {
                if let type = parseObjcType(from: functionPointer) {
                    parameters.append(type)
                }
            }
        }
        
        let functionPointerType: ObjcType =
            .functionPointer(name: identifier.getText(),
                             returnType: returnType,
                             parameters: parameters)
        
        return functionPointerType
    }
    
    private func handleFixedArray(_ type: ObjcType, declarator: Parser.DeclaratorContext) -> ObjcType {
        guard let directDeclarator = declarator.directDeclarator() else {
            return type
        }
        
        var type = type
        
        for suffix in directDeclarator.declaratorSuffix().reversed() {
            guard let constantExpression = suffix.constantExpression() else {
                continue
            }
            
            if let int = Int(constantExpression.getText()) {
                type = .fixedArray(type, length: int)
            }
        }
        
        return type
    }
}

extension TypeParsing {
    static func qualifiers(from spec: Parser.SpecifierQualifierListContext) -> [Parser.TypeQualifierContext] {
        spec.typeQualifier()
    }
    
    static func qualifiers(from spec: Parser.DeclarationSpecifiersContext) -> [Parser.TypeQualifierContext] {
        spec.typeQualifier()
    }
}
