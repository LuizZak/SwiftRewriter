import Antlr4
import ObjcParserAntlr
import ObjcGrammarModels
import Utils

/// Converts a declaration from `DeclarationExtractor` to a proper `ASTNode`
/// representing the declaration.
public class DeclarationTranslator {
    public init() {

    }

    /// Translates a single C declaration into an appropriate collection of AST
    /// node declarations.
    ///
    /// Return is empty if translation failed to produce a valid definition.
    ///
    /// Result can be more than one declaration, in case the declaration needs
    /// to be broken up into multiple separate declarations in order to be
    /// expressed more appropriately into AST nodes.
    public func translate(
        _ decl: DeclarationExtractor.Declaration
    ) -> [ASTNodeDeclaration] {

        guard let baseType = baseType(from: decl.specifiers, pointer: decl.pointer) else {
            return []
        }
        guard let ctxSyntax = ctxSyntax(for: decl) else {
            return []
        }

        var result: ASTNodeDeclaration?
        let partialType = PartialType(decl.specifiers, pointer: decl.pointer)

        /// Recursively unwraps nested declarators into root declaration kinds.
        func _applyDeclarator(
            _ declKind: DeclarationExtractor.DeclarationKind?
        ) -> ASTNodeDeclaration? {

            guard let declKind = declKind else {
                return nil
            }

            var result: ASTNodeDeclaration?

            switch declKind {
            case .identifier(_, let identifier):
                guard let identifierNode = identifierNode(from: decl.declaration) else {
                    return nil
                }

                let typeNode = self.typeNameNode(
                    from: baseType,
                    syntax: identifier
                )

                result = .variable(
                    .init(
                        rule: decl.declarationNode.syntaxElement,
                        nullability: partialType.nullability,
                        arcSpecifier: partialType.arcSpecifier,
                        typeQualifiers: partialType.declSpecifiers.typeQualifiers(),
                        identifier: identifierNode,
                        type: typeNode,
                        initialValue: nil,
                        isStatic: partialType.isStatic
                    )
                )
            
            case .pointer(let base, _):
                guard let base = _applyDeclarator(base) else {
                    return nil
                }

                // TODO: Support other types of pointer declarators
                switch base {
                case .function(let decl):
                    
                    let type: ObjcType = .functionPointer(
                        name: decl.identifier.name,
                        returnType: decl.returnType.type,
                        parameters: decl.parameters.map({ $0.type.type })
                    )
                    
                    let typeNode = typeNameNode(from: type, syntax: ctxSyntax)

                    result = .variable(
                        .init(
                            rule: decl.rule,
                            nullability: nil,
                            typeQualifiers: [],
                            identifier: decl.identifier,
                            type: typeNode,
                            initialValue: nil,
                            isStatic: partialType.isStatic
                        )
                    )

                default:
                    return nil
                }
            
            case .block(let blockSpecifiers, _, let parameters):
                guard let identifierNode = identifierNode(from: decl.declaration) else {
                    return nil
                }

                let parameterNodes = parameters.compactMap { argument in
                    self.functionArgument(from: argument)
                }

                let type = ObjcType.blockType(
                    name: identifierNode.name,
                    returnType: baseType,
                    parameters: parameterNodes.map({ $0.type.type }),
                    nullabilitySpecifier: blockSpecifiers.nullabilitySpecifier().first
                )
                let typeNode = typeNameNode(from: type, syntax: ctxSyntax)

                result = .variable(
                    .init(
                        rule: decl.declarationNode.syntaxElement,
                        nullability: partialType.nullability,
                        arcSpecifier: blockSpecifiers.arcBehaviourSpecifier().last ?? partialType.arcSpecifier,
                        typeQualifiers: blockSpecifiers.typeQualifier(),
                        typePrefix: blockSpecifiers.typePrefix().last,
                        identifier: identifierNode,
                        type: typeNode,
                        initialValue: nil,
                        isStatic: partialType.isStatic
                    )
                )
            
            case .function(_, let parameters, let isVariadic):
                guard let identifierNode = identifierNode(from: decl.declaration) else {
                    return nil
                }
                
                let parameterNodes = parameters.compactMap { argument in
                    self.functionArgument(from: argument)
                }
                let returnTypeNode = self.typeNameNode(
                    from: baseType,
                    syntax: ctxSyntax
                )

                result = .function(
                    .init(
                        rule: decl.declarationNode.syntaxElement,
                        identifier: identifierNode,
                        parameters: parameterNodes,
                        returnType: returnTypeNode,
                        isVariadic: isVariadic
                    )
                )
            
            case .staticArray(_, _, let length):
                guard let identifierNode = identifierNode(from: decl.declaration) else {
                    return nil
                }

                let constant = _extractStaticLength(from: length)

                var type: ObjcType? = baseType
                type = partialType.makePointer { 
                    translateObjectiveCType($0)
                }
                
                // Promote to fixed array, if it provides an appropriate size
                if let constant {
                    type = partialType.makeFixedArray(length: constant) {
                        translateObjectiveCType($0)
                    }
                }

                guard let type = type else {
                    return nil
                }

                let typeNameNode = typeNameNode(
                    from: type,
                    syntax: ctxSyntax
                )

                result = .variable(
                    .init(
                        rule: decl.declarationNode.syntaxElement,
                        nullability: partialType.nullability,
                        arcSpecifier: nil,
                        typeQualifiers: [],
                        typePrefix: nil,
                        identifier: identifierNode,
                        type: typeNameNode,
                        initialValue: nil,
                        isStatic: partialType.isStatic
                    )
                )
            }

            return result
        }

        result = _applyDeclarator(decl.declaration)
        result?.initializer = self.initializerInfo(from: decl.initializer)

        // Conversion into struct/enum/typedef
        if
            isStructConvertible(decl, partialType),
            let structOrUnionSpecifier = partialType.structOrUnionSpecifier,
            let identifierNode = identifierNode(from: decl.declaration)
        {
            let fields = structFields(structOrUnionSpecifier.fields)

            result = .structOrUnionDecl(
                .init(
                    rule: decl.declarationNode.syntaxElement,
                    identifier: identifierNode,
                    context: structOrUnionSpecifier,
                    fields: fields
                )
            )
        } else if
            isEnumConvertible(decl, partialType),
            let enumSpecifier = partialType.enumSpecifier,
            let identifierNode = identifierNode(from: decl.declaration)
        {
            let typeNameNode = typeNameNode(from: enumSpecifier.typeName)
            let enumerators = enumCases(enumSpecifier.enumerators)

            result = .enumDecl(
                .init(
                    rule: decl.declarationNode.syntaxElement,
                    identifier: identifierNode,
                    typeName: typeNameNode,
                    context: enumSpecifier,
                    enumerators: enumerators
                )
            )
        } else if
            isTypedefConvertible(decl, partialType),
            let result = result,
            let identifierNode = identifierNode(from: decl.declaration),
            var baseType = result.objcType
        {
            // Handle opaque/anonymous enum declarations
            if partialType.pointer != nil && (partialType.isAnonymousEnum || partialType.isOpaqueEnum) {
                baseType = PartialType.applyPointer(base: .void, partialType.pointer)
            }

            let typeNode = typeNameNode(from: baseType, syntax: ctxSyntax)

            return [
                .typedef(
                    .init(
                        rule: decl.declarationNode.syntaxElement,
                        baseType: result,
                        typeNode: typeNode,
                        alias: identifierNode
                    )
                )
            ]
        }

        if let result = result {
            return [result]
        }

        return []
    }

    /// Translates a list of C declarations into AST node declarations.
    public func translate(
        _ decls: [DeclarationExtractor.Declaration]
    ) -> [ASTNodeDeclaration] {

        return decls.flatMap({ self.translate($0) })
    }
    
    // TODO: Reduce duplication with translate() above.
    
    /// Translates the C type of a declaration into an appropriate `ObjcType`
    /// instance.
    public func translateObjectiveCType(
        _ decl: DeclarationExtractor.Declaration
    ) -> ObjcType? {

        let partialType = PartialType(decl.specifiers, pointer: decl.pointer)
        guard let type = partialType.makeType({ translateObjectiveCType($0) }) else {
            return nil
        }

        func _applyDeclarator(
            _ declKind: DeclarationExtractor.DeclarationKind?,
            type: ObjcType
        ) -> ObjcType? {

            guard let declKind = declKind else {
                return type
            }

            switch declKind {
            case .identifier:
                return type

            case .function(let base, let params, _):
                guard let paramTypes = functionArgumentTypes(from: params) else {
                    return nil
                }

                let partial: ObjcType = .functionPointer(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes
                )

                return _applyDeclarator(base, type: partial)
            
            case .staticArray(let base, _, let length):
                let partial: ObjcType

                if let length = _extractStaticLength(from: length) {
                    partial = .fixedArray(type, length: length)
                } else {
                    partial = .pointer(type)
                }

                return _applyDeclarator(base, type: partial)
            
            case .pointer(let base, _):
                let partial: ObjcType = .pointer(type)

                return _applyDeclarator(base, type: partial)
            
            case .block(let blockSpecifiers, let base, let params):
                guard let paramTypes = functionArgumentTypes(from: params) else {
                    return nil
                }

                var partial: ObjcType = .blockType(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes,
                    nullabilitySpecifier: blockSpecifiers.nullabilitySpecifier().last ?? partialType.nullability
                )

                if let lastArcSpecifier = blockSpecifiers.arcBehaviourSpecifier().last {
                    partial = .specified(specifiers: [.arcSpecifier(lastArcSpecifier)], partial)
                }
                if !blockSpecifiers.typeQualifier().isEmpty {
                    partial = .qualified(partial, qualifiers: blockSpecifiers.typeQualifier())
                }

                return _applyDeclarator(base, type: partial)
            }
        }

        return _applyDeclarator(decl.declaration, type: type)
    }

    /// Translates the type of a generic parameter into an appropriate `ObjcType`
    /// instance.
    func translateObjectiveCType(
        _ decl: DeclarationExtractor.GenericTypeParameter
    ) -> ObjcType? {

        return translateObjectiveCType(decl.type)
    }

    /// Translates the type of a `TypeName` declaration into an appropriate
    /// `ObjcType` instance.
    public func translateObjectiveCType(
        _ decl: DeclarationExtractor.TypeName
    ) -> ObjcType? {

        let partialType = PartialType(decl.specifiers, pointer: decl.pointer)
        guard let type = partialType.makeType({ translateObjectiveCType($0) }) else {
            return nil
        }

        func _applyDeclarator(
            _ declKind: DeclarationExtractor.AbstractDeclarationKind?,
            type: ObjcType
        ) -> ObjcType? {

            guard let declKind = declKind else {
                return type
            }

            switch declKind {
            case .function(let base, let params, _):
                guard let paramTypes = functionArgumentTypes(from: params) else {
                    return nil
                }

                let partial: ObjcType = .functionPointer(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes
                )

                return _applyDeclarator(base, type: partial)
            
            case .block(let base, let specifiers, let params):
                guard let paramTypes = functionArgumentTypes(from: params) else {
                    return nil
                }

                var partial: ObjcType = .blockType(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes,
                    nullabilitySpecifier: specifiers.nullabilitySpecifier().last
                )
                if let lastArcSpecifier = specifiers.arcBehaviourSpecifier().last {
                    partial = .specified(specifiers: [.arcSpecifier(lastArcSpecifier)], partial)
                }
                if !specifiers.typeQualifier().isEmpty {
                    partial = .qualified(partial, qualifiers: specifiers.typeQualifier())
                }

                return _applyDeclarator(base, type: partial)
            
            case .staticArray(let base, _, let length):
                let partial: ObjcType

                if let length = _extractStaticLength(from: length) {
                    partial = .fixedArray(type, length: length)
                } else {
                    partial = .pointer(type)
                }

                return _applyDeclarator(base, type: partial)
            }
        }

        return _applyDeclarator(decl.declaration, type: type)
    }

    /// Returns `true` if the contents of a declaration along with a partial type
    /// can be converted into a struct declaration.
    private func isStructConvertible(
        _ decl: DeclarationExtractor.Declaration,
        _ partialType: PartialType
    ) -> Bool {

        guard partialType.isStructOrUnionSpecifier else {
            return false
        }
        guard !partialType.isOpaqueStructOrUnion else {
            return false
        }
        guard !(partialType.pointer != nil && partialType.isOpaqueOrAnonymousDeclaration) else {
            return false
        }

        return true
    }

    /// Returns `true` if the contents of a declaration along with a partial type
    /// can be converted into an enum declaration.
    private func isEnumConvertible(
        _ decl: DeclarationExtractor.Declaration,
        _ partialType: PartialType
    ) -> Bool {

        guard partialType.isEnumSpecifier else {
            return false
        }
        guard !partialType.isOpaqueEnum else {
            return false
        }
        guard !(partialType.pointer != nil && partialType.isOpaqueOrAnonymousDeclaration) else {
            return false
        }

        return true
    }

    /// Returns `true` if the contents of a declaration along with a partial type
    /// can be converted into a typedef declaration.
    private func isTypedefConvertible(
        _ decl: DeclarationExtractor.Declaration,
        _ partialType: PartialType
    ) -> Bool {

        guard partialType.isTypedef else {
            return false
        }

        return true
    }

    private func functionArgument(
        from functionParam: DeclarationExtractor.FuncParameter
    ) -> FunctionParameterInfo? {

        switch functionParam {
        case .declaration(let declaration):
            let decls = translate(declaration)

            guard decls.count == 1, let decl = decls.first else {
                return nil
            }

            guard let type = decl.objcType else {
                return nil
            }
            guard let identifier = decl.identifierNode else {
                return nil
            }
            guard let ctxNode = ctxSyntax(for: declaration) else {
                return nil
            }

            return .init(
                type: .init(sourceRange: ctxNode.sourceRange, type: type),
                identifier: identifier
            )
        
        case .typeName(let typeName):
            guard let type = translateObjectiveCType(typeName) else {
                return nil
            }
            
            let typeNameNode = typeNameNode(
                from: type,
                syntax: typeName.declarationNode.syntaxElement
            )

            return .init(type: typeNameNode)
        }
    }

    private func functionArgumentTypes(
        from declarations: [DeclarationExtractor.FuncParameter]
    ) -> [ObjcType]? {

        let paramTypes = declarations.map {
            functionArgument(from: $0)?.type.type
        }

        if paramTypes.contains(nil) {
            return nil
        }

        return paramTypes.compactMap({ $0 })
    }

    /// Translates a list of C struct/union fields into AST node declarations.
    private func structFields(
        _ fields: [DeclarationExtractor.StructFieldDeclaration]?
    ) -> [ASTStructFieldDeclaration] {

        guard let fields else {
            return []
        }

        return fields.compactMap({ self.structField($0) })
    }

    /// Translates a list of C enum enumerators into AST node declarations.
    private func enumCases(
        _ enumerators: [DeclarationExtractor.EnumeratorDeclaration]?
    ) -> [ASTEnumeratorDeclaration] {

        guard let enumerators else {
            return []
        }

        return enumerators.compactMap({ self.enumCase($0) })
    }

    /// Translates a C struct/union field into an `ASTStructFieldDeclaration`.
    private func structField(
        _ field: DeclarationExtractor.StructFieldDeclaration
    ) -> ASTStructFieldDeclaration? {

        guard let type = translateObjectiveCType(field.declaration) else {
            return nil
        }
        guard let ident = identifierNode(from: field.declaration.declaration) else {
            return nil
        }
        guard let ctxSyntax: DeclarationSyntaxElementType = field.declarator ?? field.constantExpression else {
            return nil
        }

        return ASTStructFieldDeclaration(
            identifier: ident,
            type: typeNameNode(from: type, syntax: ctxSyntax),
            constantExpression: constantExpressionInfo(from: field.constantExpression),
            rule: ctxSyntax
        )
    }

    /// Translates a C struct/union enumerator into an `ASTEnumeratorDeclaration`.
    private func enumCase(
        _ enumerator: DeclarationExtractor.EnumeratorDeclaration
    ) -> ASTEnumeratorDeclaration? {

        let identCtx = enumerator.identifier

        return ASTEnumeratorDeclaration(
            identifier: identifierNode(from: enumerator.identifier),
            expression: expressionInfo(from: enumerator.expression),
            rule: identCtx
        )
    }

    private func typeNameNode(
        from type: ObjcType,
        syntax: DeclarationSyntaxElementType
    ) -> TypeNameInfo {

        return TypeNameInfo(
            sourceRange: syntax.sourceRange,
            type: type
        )
    }

    private func typeNameNode(
        from typeName: DeclarationExtractor.TypeName?
    ) -> TypeNameInfo? {

        guard let typeName = typeName, let type = translateObjectiveCType(typeName) else {
            return nil
        }

        let syntaxElement = typeName.declarationNode.syntaxElement

        return TypeNameInfo(sourceRange: syntaxElement.sourceRange, type: type)
    }

    private func identifierNode(
        from declKind: DeclarationExtractor.DeclarationKind?
    ) -> IdentifierInfo? {

        guard let declKind = declKind else {
            return nil
        }

        let identifierCtx = declKind.identifierSyntax

        return .init(sourceRange: identifierCtx.sourceRange, name: identifierCtx.identifier)
    }

    private func expressionInfo(
        from syntax: ExpressionSyntax?
    ) -> ExpressionInfo? {

        guard let syntax else {
            return nil
        }

        return ExpressionInfo.string(syntax.sourceRange, syntax.expressionString)
    }

    private func initializerInfo(
        from syntax: InitializerSyntax?
    ) -> InitializerInfo? {

        guard let syntax else {
            return nil
        }

        switch syntax {
        case .expression(let exp):
            return .string(exp.sourceRange, exp.expressionString)
        }
    }

    private func constantExpressionInfo(
        from syntax: ConstantExpressionSyntax?
    ) -> ConstantExpressionInfo? {
        
        guard let syntax else {
            return nil
        }

        return ConstantExpressionInfo.string(syntax.sourceRange, syntax.constantExpressionString)
    }

    private func identifierNode(from syntax: IdentifierSyntax?) -> IdentifierInfo? {

        guard let syntax = syntax else {
            return nil
        }

        return .init(sourceRange: syntax.sourceRange, name: syntax.identifier)
    }

    /// Returns the inner-most context syntax element for a given declaration.
    /// Is the direct declarator syntax element if present, otherwise it is the
    /// identifier context for non-initialized declarations, or `nil`, if neither
    /// is present.
    private func ctxSyntax(for decl: DeclarationExtractor.Declaration) -> DeclarationSyntaxElementType? {
        return decl.declarationNode.syntaxElement
    }

    private func baseType(
        from declSpecifiers: [DeclarationExtractor.DeclSpecifier],
        pointer: DeclarationExtractor.Pointer?
    ) -> ObjcType? {
        guard !declSpecifiers.isEmpty else {
            return nil
        }

        let partialType = PartialType(declSpecifiers, pointer: pointer)
        return partialType.makeType {
            translateObjectiveCType($0)
        }
    }

    private func _extractStaticLength(from syntax: ExpressionSyntax?) -> Int? {
        guard let string = syntax?.expressionString else {
            return nil
        }

        return Int(string)
    }

    private func _extractStaticLength(from rule: ObjectiveCParser.ExpressionContext?) -> Int? {
        guard let constant = rule.flatMap(ConstantContextExtractor.extract(from:)) else {
            return nil
        }

        return Int(constant.getText())
    }

    /// A declaration that has been converted into a mode that is suitable to
    /// create `ASTNode` instances out of.
    // TODO: Collapse `functionPointer` and `block` into `variable` case.
    public enum ASTNodeDeclaration {
        case variable(
            ASTVariableDeclaration
        )
        /*
        case block(
            ASTBlockDeclaration
        )
        case functionPointer(
            ASTFunctionPointerDeclaration
        )
        */
        case function(
            ASTFunctionDefinition
        )
        case structOrUnionDecl(
            ASTStructOrUnionDeclaration
        )
        case enumDecl(
            ASTEnumDeclaration
        )
        indirect case typedef(
            ASTTypedefDeclaration
        )

        /// Gets the identifier associated with this node, if any.
        public var identifierNode: IdentifierInfo? {
            switch self {
            case .variable(let decl):
                return decl.identifier
            case .function(let decl):
                return decl.identifier
            case .typedef(let decl):
                return decl.alias
            case .structOrUnionDecl(let decl):
                return decl.identifier
            case .enumDecl(let decl):
                return decl.identifier
            }
        }

        /// Gets the type node associated with this node, if any.
        public var typeNode: TypeNameInfo? {
            switch self {
            case .variable(let decl):
                return decl.type
            
            case .typedef(let decl):
                return decl.typeNode
            
            case .function, .enumDecl, .structOrUnionDecl:
                return nil
            }
        }

        /// Gets or sets the initializer for this declaration.
        /// In case this is not a declaration that supports initializers, nothing
        /// is done.
        public var initializer: InitializerInfo? {
            get {
                switch self {
                case .variable(let decl):
                    return decl.initialValue

                case .enumDecl, .structOrUnionDecl, .typedef, .function:
                    return nil
                }
            }
            set {
                switch self {
                case .variable(let decl):
                    self = .variable(
                        decl.withInitializer(newValue)
                    )

                case .enumDecl, .structOrUnionDecl, .typedef, .function:
                    break
                }
            }
        }

        public var objcType: ObjcType? {
            switch self {
            case .variable(let decl):
                var result = decl.type.type

                if let nullability = decl.nullability {
                    result = .nullabilitySpecified(specifier: nullability, result)
                }
                if let arcSpecifier = decl.arcSpecifier {
                    result = .specified(specifiers: [.arcSpecifier(arcSpecifier)], result)
                }

                return result
            
            case .typedef(let decl):
                return decl.typeNode.type
            
            case .function(let decl):
                return .functionPointer(name: decl.identifier.name, returnType: decl.returnType.type, parameters: decl.parameters.compactMap {
                    $0.type.type
                })

            case .structOrUnionDecl(let decl):
                return (decl.identifier?.name).map { .typeName($0) }

            case .enumDecl(let decl):
                return (decl.identifier?.name).map { .typeName($0) }
            }
        }

        /// Gets the parser rule associated with this definition.
        public var contextRule: DeclarationSyntaxElementType {
            switch self {
            case .variable(let decl):
                return decl.rule

            case .function(let decl):
                return decl.rule

            case .structOrUnionDecl(let decl):
                return decl.rule

            case .enumDecl(let decl):
                return decl.rule

            case .typedef(let decl):
                return decl.rule
            }
        }

        /// Returns `true` if this AST node declaration value is a `.typedef()`
        /// case.
        var isTypedef: Bool {
            switch self {
            case .typedef:
                return true
            default:
                return false
            }
        }
    }

    /// General specifiers for variable declarations.
    public struct ASTDeclarationSpecifiers {
        /// Nullability specifiers for pointer/object types.
        public var nullabilitySpecifier: ObjcNullabilitySpecifier?

        /// ARC specifiers for Objective-C object types.
        public var arcBehaviourSpecifier: ObjcArcBehaviorSpecifier?
    }

    /// Specifications for a variable declaration.
    public struct ASTVariableDeclaration {
        public var rule: DeclarationSyntaxElementType
        public var nullability: ObjcNullabilitySpecifier?
        public var arcSpecifier: ObjcArcBehaviorSpecifier?
        public var typeQualifiers: [ObjcTypeQualifier]
        public var typePrefix: DeclarationExtractor.TypePrefix?
        public var identifier: IdentifierInfo
        public var type: TypeNameInfo
        public var initialValue: InitializerInfo?
        public var isStatic: Bool

        public func withInitializer(_ value: InitializerInfo?) -> Self {
            var copy = self
            copy.initialValue = value
            return copy
        }
    }

    /// Specifications for a function definition.
    /// Does not include a function body.
    public struct ASTFunctionDefinition {
        public var rule: DeclarationSyntaxElementType
        public var identifier: IdentifierInfo
        public var parameters: [FunctionParameterInfo]
        public var returnType: TypeNameInfo
        public var isVariadic: Bool
    }

    /// Specifications for a struct or union definition.
    public struct ASTStructOrUnionDeclaration {
        public var rule: DeclarationSyntaxElementType
        public var identifier: IdentifierInfo?
        public var context: DeclarationExtractor.StructOrUnionSpecifier
        public var fields: [ASTStructFieldDeclaration]
    }

    /// Contains information for a generated struct or union field.
    public struct ASTStructFieldDeclaration {
        /// The node for the field itself.
        //public var node: StructDeclarationSyntax

        public var identifier: IdentifierInfo?
        public var type: TypeNameInfo
        public var constantExpression: ConstantExpressionInfo?

        /// The context rule for this field declaration.
        /// It is the innermost parser rule where queries against the source code
        /// range can be used accurately to collect surrounding comments and
        /// nonnull-contexts unambiguously.
        public var rule: DeclarationSyntaxElementType
    }

    /// Contains information for a generated enum field.
    public struct ASTEnumDeclaration {
        public var rule: DeclarationSyntaxElementType
        public var identifier: IdentifierInfo?
        public var typeName: TypeNameInfo?
        public var context: DeclarationExtractor.EnumSpecifier
        public var enumerators: [ASTEnumeratorDeclaration]
    }

    /// Contains information for a generated enumerator, or enum value.
    public struct ASTEnumeratorDeclaration {
        /// The node for the enumerator itself.
        //public var node: ObjcEnumCase
        
        public var identifier: IdentifierInfo?
        public var expression: ExpressionInfo?

        /// The context rule for this enumerator declaration.
        /// It is the innermost parser rule where queries against the source code
        /// range can be used accurately to collect surrounding comments and
        /// nonnull-contexts unambiguously.
        public var rule: DeclarationSyntaxElementType
    }

    /// Specification for a typedef declaration node.
    public struct ASTTypedefDeclaration {
        public var rule: DeclarationSyntaxElementType
        public var baseType: ASTNodeDeclaration
        public var typeNode: TypeNameInfo
        public var alias: IdentifierInfo
    }

    /// Final identifier produced by translating from a raw declaration.
    public struct IdentifierInfo {
        public var sourceRange: SourceRange
        public var name: String
    }

    /// Final type information produced by translating from a raw declaration.
    public struct TypeNameInfo {
        public var sourceRange: SourceRange
        public var type: ObjcType
    }

    /// Final function parameter information produced by translating from a raw
    /// declaration.
    public struct FunctionParameterInfo {
        public var type: TypeNameInfo
        public var identifier: IdentifierInfo?
    }

    /// Allows for switching between storing syntax as a raw ANTLR parser rule or
    /// as a string that when parsed into `T` has an equivalent AST representation.
    public enum SyntaxStorageMode<T: ParserRuleContext> {
        case antlr(SourceRange, T)
        case string(SourceRange, String)

        public var sourceRange: SourceRange {
            switch self {
            case .antlr(let sourceRange, _), .string(let sourceRange, _):
                return sourceRange
            }
        }
    }

    public typealias ExpressionInfo = SyntaxStorageMode<ObjectiveCParser.ExpressionContext>
    public typealias InitializerInfo = SyntaxStorageMode<ObjectiveCParser.ExpressionContext>
    public typealias ConstantExpressionInfo = SyntaxStorageMode<ObjectiveCParser.ConstantExpressionContext>

    private struct PartialType {
        var declSpecifiers: [DeclarationExtractor.DeclSpecifier]
        var pointer: DeclarationExtractor.Pointer?

        var isStatic: Bool {
            declSpecifiers.storageSpecifiers().contains(where: { $0.isStatic })
        }
        var isTypedef: Bool {
            declSpecifiers.storageSpecifiers().contains(where: { $0.isTypedef })
        }
        var isConst: Bool {
            declSpecifiers.typeQualifiers().contains(where: { $0.isConst })
        }
        var isStructOrUnionSpecifier: Bool {
            declSpecifiers.typeSpecifiers().contains(where: { $0.isStructOrUnionSpecifier })
        }
        var isEnumSpecifier: Bool {
            declSpecifiers.typeSpecifiers().contains(where: { $0.isEnumSpecifier })
        }

        /// Whether this type specifier specifies an opaque or anonymous struct/enum
        /// declaration.
        var isOpaqueOrAnonymousDeclaration: Bool {
            isOpaqueStructOrUnion || isAnonymousStruct || isOpaqueEnum || isAnonymousEnum
        }

        /// Returns `true` if this partial type declares an opaque struct or union
        /// (struct/union declaration that has no members list).
        var isOpaqueStructOrUnion: Bool {
            guard let structOrUnionSpecifier else {
                return false
            }

            return structOrUnionSpecifier.fields == nil
        }
        /// Returns `true` if this partial type declares a struct or union that
        /// has no associated identifier.
        var isAnonymousStruct: Bool {
            guard let structOrUnionSpecifier else {
                return false
            }

            return structOrUnionSpecifier.identifier == nil
        }

        /// Returns `true` if this partial type declares an opaque enum (enum
        /// declaration that has no members list).
        var isOpaqueEnum: Bool {
            guard let enumSpecifier else {
                return false
            }

            return enumSpecifier.enumerators == nil
        }
        /// Returns `true` if this partial type declares an enum that has no
        /// associated identifier.
        var isAnonymousEnum: Bool {
            guard let enumSpecifier else {
                return false
            }

            return enumSpecifier.identifier == nil
        }

        var structOrUnionSpecifier: DeclarationExtractor.StructOrUnionSpecifier? {
            declSpecifiers.typeSpecifiers().first(where: {
                $0.isStructOrUnionSpecifier
            })?.asStructOrUnionSpecifier
        }
        var enumSpecifier: DeclarationExtractor.EnumSpecifier? {
            declSpecifiers.typeSpecifiers().first(where: {
                $0.isEnumSpecifier
            })?.asEnumSpecifier
        }

        var nullability: ObjcNullabilitySpecifier? {
            declSpecifiers.nullabilitySpecifiers().last
        }
        var arcSpecifier: ObjcArcBehaviorSpecifier? {
            declSpecifiers.arcSpecifiers().last
        }

        internal init(
            _ declSpecifiers: [DeclarationExtractor.DeclSpecifier],
            pointer: DeclarationExtractor.Pointer?
        ) {
            self.declSpecifiers = declSpecifiers
            self.pointer = pointer
        }

        /// Creates a type out of the partial declaration specifiers only.
        func makeType(_ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?) -> ObjcType? {
            guard var result = objcTypeFromSpecifiers(
                declSpecifiers.typeSpecifiers(),
                genericTypeParsing: genericTypeParsing
            ) else {
                return nil
            }
            
            result = Self.applyPointer(base: result, pointer)

            if let lastNullSpecifier = declSpecifiers.nullabilitySpecifiers().last {
                result = .nullabilitySpecified(specifier: lastNullSpecifier, result)
            }
            if let lastArcSpecifier = declSpecifiers.arcSpecifiers().last {
                result = .specified(specifiers: [.arcSpecifier(lastArcSpecifier)], result)
            }
            if !declSpecifiers.typeQualifiers().isEmpty {
                result = .qualified(result, qualifiers: declSpecifiers.typeQualifiers())
            }

            return result
        }

        func makeBlockType(
            identifier: String?,
            parameters: [ObjcType],
            _ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
        ) -> ObjcType? {
            let baseType = makeType(genericTypeParsing)

            return baseType.map {
                .blockType(
                    name: identifier,
                    returnType: $0,
                    parameters: parameters
                )
            }
        }

        func makeFunctionPointerType(
            identifier: String?,
            parameters: [ObjcType],
            _ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
        ) -> ObjcType? {
            let baseType = makeType(genericTypeParsing)

            return baseType.map {
                .functionPointer(
                    name: identifier,
                    returnType: $0,
                    parameters: parameters
                )
            }
        }

        func makePointer(
            _ pointer: DeclarationExtractor.Pointer?,
            _ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
        ) -> ObjcType? {

            guard let result = makeType(genericTypeParsing) else {
                return nil
            }

            return Self.applyPointer(base: result, pointer)
        }

        func makePointer(_ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?) -> ObjcType? {
            let baseType = makeType(genericTypeParsing)

            return baseType.map { .pointer($0) }
        }

        func makeFixedArray(
            length: Int,
            _ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
        ) -> ObjcType? {
            
            let baseType = makeType(genericTypeParsing)

            return baseType.map { .fixedArray($0, length: length) }
        }
        
        /// Applies a given pointer declaration on top of a given Objective-C type.
        static func applyPointer(
            base: ObjcType,
            _ pointer: DeclarationExtractor.Pointer?
        ) -> ObjcType {

            var result = base

            if let pointer = pointer {
                for ptr in pointer.pointers {
                    result = .pointer(
                        result,
                        qualifiers: ptr.typeQualifiers ?? [],
                        nullabilitySpecifier: ptr.nullabilitySpecifier
                    )
                }
            }

            return result
        }
    }
}

// Reference for specifier combinations:
// https://www.open-std.org/JTC1/SC22/WG14/www/docs/n3054.pdf
func objcTypeFromSpecifiers(
    _ specifiers: [DeclarationExtractor.TypeSpecifier],
    genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
) -> ObjcType? {

    if specifiers.isEmpty {
        return nil
    }
    
    struct SpecifierCombination {
        var type: ObjcType
        var combinations: [[String]]

        init(type: ObjcType, combinations: [[String]]) {
            self.type = type
            self.combinations = combinations.map { $0.sorted() }
        }

        init(type: ObjcType, _ combinations: [String]...) {
            assert(!combinations.isEmpty)

            self.type = type
            self.combinations = combinations.map { $0.sorted() }
        }

        init(type: ObjcType, _ combinations: String...) {
            assert(!combinations.isEmpty)

            self.type = type
            self.combinations = [combinations.sorted()]
        }

        init(type: ObjcType, splitting combinations: String...) {
            assert(!combinations.isEmpty)

            let combinations = combinations.map { combination in
                return combination.split(separator: " ").map(String.init).sorted()
            }

            self.type = type
            self.combinations = combinations
        }

        init(type: ObjcType, _ combination: String) {
            self.type = type
            self.combinations = [[combination].sorted()]
        }

        func matches(_ specifiers: [DeclarationExtractor.DeclSpecifier]) -> Bool {
            let typeSpecifiers = specifiers.typeSpecifiers()

            return matches(typeSpecifiers)
        }

        func matches(_ typeSpecifiers: [DeclarationExtractor.TypeSpecifier]) -> Bool {
            // Must match exactly one of the available sets
            if typeSpecifiers.contains(where: { $0.scalarType == nil }) {
                return false
            }

            let scalarNames = typeSpecifiers.compactMap { $0.scalarType }.sorted()

            for combination in combinations {
                if combination == scalarNames {
                    return true
                }
            }

            return false
        }
    }

    let combinations: [SpecifierCombination] = [
        .init(type: .void, "void"),
        .init(type: "char", "char"),
        .init(
            type: "signed char",
            "signed", "char"
        ),
        .init(
            type: "unsigned char",
            "unsigned", "char"
        ),
        .init(
            type: "signed short int",
            splitting: "short", "signed short", "short int", "signed short int"
        ),
        .init(
            type: "unsigned short int",
            splitting: "unsigned short", "unsigned short int"
        ),
        .init(
            type: "signed int",
            splitting: "int", "signed int"
        ),
        .init(
            type: "unsigned int",
            splitting: "unsigned", "unsigned int"
        ),
        .init(
            type: "signed long int",
            splitting: "long", "signed long", "long int", "signed long int"
        ),
        .init(
            type: "unsigned long int",
            splitting: "unsigned long", "unsigned long int"
        ),
        .init(
            type: "signed long long int",
            splitting: "long long", "signed long long", "long long int", "signed long long int"
        ),
        .init(
            type: "unsigned long long int",
            splitting: "unsigned long long", "unsigned long long int"
        ),
        .init(type: "float", "float"),
        .init(type: "double", "double"),
        .init(type: "bool", "bool"),
    ]

    for entry in combinations {
        if entry.matches(specifiers) {
            return entry.type
        }
    }

    switch specifiers[0] {
    case .scalar(let name):
        return .typeName(name.description)
    
    case .typeName(let value):
        if let genericTypeList = value.genericTypes {
            var genericTypes: [ObjcType] = []

            for genericType in genericTypeList.types {
                guard let type = genericTypeParsing(genericType) else {
                    return nil
                }
                
                genericTypes.append(type)
            }

            if value.name == "id" {
                return .id(protocols: genericTypes.map(\.description))
            }

            return .genericTypeName(
                value.name,
                parameters: genericTypes.map({ ObjcGenericTypeParameter(type: $0) })
            )
        }

        if value.name == "id" {
            return .id()
        }
        if value.name == "instancetype" {
            return .instancetype
        }

        return .typeName(value.name)

    case .structOrUnionSpecifier(let ctx):
        guard let ident = ctx.identifier else {
            return .anonymousStruct
        }
        if ctx.fields == nil {
            return .incompleteStruct(ident.identifier)
        }

        return .typeName(ident.identifier)

    case .enumSpecifier(let ctx):
        if let ident = ctx.identifier {
            return .typeName(ident.identifier)
        }

        return .anonymousEnum
    
    case .typeof:
        return nil
    }
}
