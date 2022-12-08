import Antlr4
import Utils
import AntlrCommons
import GrammarModelBase
import ObjcParserAntlr
import ObjcGrammarModels

public class ObjcTypeParser {
    public typealias Parser = ObjectiveCParser

    let source: Source

    private let _translator: DeclarationTranslator
    
    public let state: ObjcParserState
    public let antlrSettings: AntlrSettings
    
    public init(
        state: ObjcParserState,
        source: Source,
        antlrSettings: AntlrSettings = .default
    ) {
        
        self.source = source
        self.state = state
        self.antlrSettings = antlrSettings

        _translator = DeclarationTranslator()
    }

    private func makeExtractor() -> DeclarationExtractor {
        DeclarationExtractor()
    }
    private func makeParser() -> AntlrDeclarationParser {
        return AntlrDeclarationParser(source: source)
    }

    private func toObjcType(_ decl: DeclarationExtractor.Declaration?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl)
        }

        return nil
    }
    private func toObjcType(_ decl: DeclarationExtractor.GenericTypeParameter?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl)
        }

        return nil
    }
    private func toObjcType(_ decl: DeclarationExtractor.TypeName?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl)
        }

        return nil
    }
    private func toObjcTypes(_ decls: [DeclarationExtractor.Declaration]) -> [ObjcType] {
        decls.map { decl in
            _translator.translateObjectiveCType(decl) ?? .void
        }
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcTypes(in decl: Parser.FieldDeclarationContext) -> [ObjcType] {
        guard let decl = makeParser().fieldDeclaration(decl) else {
            return []
        }
        
        let ext = makeExtractor()
        return toObjcTypes(ext.extract(from: decl))
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcType(in decl: Parser.FieldDeclarationContext) -> ObjcType? {
        parseObjcTypes(in: decl).first
    }
    
    public func parseObjcType(in declarationSpecifiers: Parser.DeclarationSpecifiersContext) -> ObjcType? {
        guard let declarationSpecifiers = makeParser().declarationSpecifiers(declarationSpecifiers) else {
            return nil
        }

        let ext = makeExtractor()
        return toObjcType(ext.extract(fromSpecifiers: declarationSpecifiers))
    }
    
    public func parseObjcType(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        declarator: Parser.DeclaratorContext
    ) -> ObjcType? {
        
        guard let declarationSpecifiers = makeParser().declarationSpecifiers(declarationSpecifiers) else {
            return nil
        }
        guard let declarator = makeParser().declarator(declarator) else {
            return nil
        }
        
        let ext = makeExtractor()
        
        return toObjcType(
            ext.extract(fromSpecifiers: declarationSpecifiers, declarator: declarator)
        )
    }
    
    public func parseObjcType(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        abstractDeclarator: Parser.AbstractDeclaratorContext
    ) -> ObjcType? {

        guard let declarationSpecifiers = makeParser().declarationSpecifiers(declarationSpecifiers) else {
            return nil
        }
        guard let abstractDeclarator = makeParser().abstractDeclarator(abstractDeclarator) else {
            return nil
        }
        
        let ext = makeExtractor()
        return toObjcType(
            ext.extract(fromSpecifiers: declarationSpecifiers, abstractDeclarator: abstractDeclarator)
        )
    }
    
    public func parseObjcTypes(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        initDeclaratorList: Parser.InitDeclaratorListContext
    ) -> [ObjcType] {
        
        guard let declarationSpecifiers = makeParser().declarationSpecifiers(declarationSpecifiers) else {
            return []
        }
        guard let initDeclaratorList = makeParser().initDeclaratorList(initDeclaratorList) else {
            return []
        }

        let ext = makeExtractor()
        return toObjcTypes(
            ext.extract(fromSpecifiers: declarationSpecifiers, initDeclaratorList: initDeclaratorList)
        )
    }
    
    public func parseObjcTypes(from blockParameters: Parser.BlockParametersContext) -> [ObjcType] {
        let parameterDeclarations = blockParameters.parameterDeclaration()
        
        var paramTypes: [ObjcType] = []
        
        for parameterDeclaration in parameterDeclarations {
            guard let paramType = parseObjcType(from: parameterDeclaration) else {
                continue
            }
            
            paramTypes.append(paramType)
        }
        
        return paramTypes
    }
    
    public func parseObjcType(from parameterContext: Parser.ParameterDeclarationContext) -> ObjcType? {
        guard let declarationSpecifiers = parameterContext.declarationSpecifiers() else {
            return nil
        }

        var type: ObjcType?
        
        if let declarator = parameterContext.declarator() {
            type = parseObjcType(in: declarationSpecifiers, declarator: declarator)
        } else if let abstractDeclarator = parameterContext.abstractDeclarator() {
            type = parseObjcType(in: declarationSpecifiers, abstractDeclarator: abstractDeclarator)
        } else {
            type = parseObjcType(in: declarationSpecifiers)
        }

        return type
    }
    
    public func parseObjcType(from typeVariableDecl: Parser.TypeVariableDeclaratorContext) -> ObjcType? {
        guard let typeVariableDecl = makeParser().typeVariable(typeVariableDecl) else {
            return nil
        }

        let ext = makeExtractor()

        return toObjcType(ext.extract(from: typeVariableDecl))
    }
    
    public func parseObjcType(from typeName: Parser.TypeNameContext) -> ObjcType? {
        guard let typeName = makeParser().typeName(typeName) else {
            return nil
        }

        let ext = makeExtractor()

        return toObjcType(ext.extract(fromTypeName: typeName))
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
                    type = parseObjcType(
                        in: declarationSpecifier,
                        declarator: declarator
                    )
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
            .functionPointer(
                name: identifier.getText(),
                returnType: returnType,
                parameters: parameters
            )
        
        return functionPointerType
    }
    
    public func parseObjcType(from blockExpression: Parser.BlockExpressionContext) -> ObjcType {
        let returnTypeCtx = blockExpression.typeName()
        let parametersCtx = blockExpression.blockParameters()

        let returnType = returnTypeCtx.flatMap { parseObjcType(from: $0) } ?? .void
        let parameters = parametersCtx.map { parseObjcTypes(from: $0) } ?? []
        
        return .blockType(
            name: nil,
            returnType: returnType,
            parameters: parameters
        )
    }

    private func extractConstant(from rule: Parser.PrimaryExpressionContext?) -> Parser.ConstantContext? {
        guard let rule = rule else {
            return nil
        }

        return ConstantContextExtractor.extract(from: rule) ?? nil
    }
}

extension ObjcTypeParser {
    static func qualifiers(from spec: Parser.DeclarationSpecifiersContext) -> [Parser.TypeQualifierContext] {
        spec.declarationSpecifier().compactMap {
            $0.typeQualifier()
        }
    }
    
    static func declarationSpecifiers(from spec: Parser.DeclarationContext) -> [Parser.DeclarationSpecifierContext] {
        spec.declarationSpecifiers().flatMap {
            declarationSpecifiers(from: $0)
        } ?? []
    }
    
    static func declarationSpecifiers(from spec: Parser.DeclarationSpecifiersContext) -> [Parser.DeclarationSpecifierContext] {
        spec.declarationSpecifier()
    }
    
    static func declarationSpecifiers(from varDecl: Parser.TypeVariableDeclaratorContext) -> [Parser.DeclarationSpecifierContext]? {
        if let spec = varDecl.declarationSpecifiers() {
            return declarationSpecifiers(from: spec)
        }

        return nil
    }
}
