import GrammarModels
import Antlr4
import ObjcParserAntlr

// TODO: Add tests for this class
public class TypeParsing {
    public typealias Parser = ObjectiveCParser

    // TODO: Should probably refactor the translator so it exposes context-free type translation methods
    /// Required for `DeclarationTranslator`
    private let _nodeFactory: ASTNodeFactory
    private let _translator: DeclarationTranslator
    
    public let state: ObjcParserState
    public let antlrSettings: AntlrSettings
    
    public init(
        state: ObjcParserState,
        source: Source,
        nonnullContextQuerier: NonnullContextQuerier,
        antlrSettings: AntlrSettings = .default
    ) {
        
        self.state = state
        self.antlrSettings = antlrSettings

        _nodeFactory = ASTNodeFactory(
            source: source,
            nonnullContextQuerier: nonnullContextQuerier,
            commentQuerier: CommentQuerier(allComments: [])
        )
        _translator = DeclarationTranslator()
    }

    private func makeExtractor() -> DeclarationExtractor {
        DeclarationExtractor()
    }
    private func toObjcType(_ decl: DeclarationExtractor.Declaration?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl, context: .init(nodeFactory: _nodeFactory))
        }

        return nil
    }
    private func toObjcType(_ decl: DeclarationExtractor.GenericTypeParameter?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl, context: .init(nodeFactory: _nodeFactory))
        }

        return nil
    }
    private func toObjcType(_ decl: DeclarationExtractor.TypeName?) -> ObjcType? {
        if let decl = decl {
            return _translator.translateObjectiveCType(decl, context: .init(nodeFactory: _nodeFactory))
        }

        return nil
    }
    private func toObjcTypes(_ decls: [DeclarationExtractor.Declaration]) -> [ObjcType] {
        decls.map { decl in
            _translator.translateObjectiveCType(decl, context: .init(nodeFactory: _nodeFactory)) ?? .void
        }
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcTypes(in decl: Parser.FieldDeclarationContext) -> [ObjcType] {
        let ext = makeExtractor()
        
        return toObjcTypes(ext.extract(from: decl))
    }
    
    // Helper for mapping Objective-C types from type declarations into structured
    // types.
    public func parseObjcType(in decl: Parser.FieldDeclarationContext) -> ObjcType? {
        parseObjcTypes(in: decl).first
    }
    
    public func parseObjcType(in declarationSpecifiers: Parser.DeclarationSpecifiersContext) -> ObjcType? {
        let ext = makeExtractor()

        return toObjcType(ext.extract(fromSpecifiers: declarationSpecifiers))
    }
    
    public func parseObjcType(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        declarator: Parser.DeclaratorContext
    ) -> ObjcType? {
        
        let ext = makeExtractor()
        
        return toObjcType(
            ext.extract(fromSpecifiers: declarationSpecifiers, declarator: declarator)
        )
    }
    
    public func parseObjcType(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        abstractDeclarator: Parser.AbstractDeclaratorContext
    ) -> ObjcType? {
        
        let ext = makeExtractor()
        
        return toObjcType(
            ext.extract(fromSpecifiers: declarationSpecifiers, abstractDeclarator: abstractDeclarator)
        )
    }
    
    public func parseObjcTypes(
        in declarationSpecifiers: Parser.DeclarationSpecifiersContext,
        initDeclaratorList: Parser.InitDeclaratorListContext
    ) -> [ObjcType] {
        
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
        let ext = makeExtractor()

        return toObjcType(ext.extract(from: typeVariableDecl))
    }
    
    public func parseObjcType(from typeName: Parser.TypeNameContext) -> ObjcType? {
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

extension TypeParsing {
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
