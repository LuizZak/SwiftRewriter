import Antlr4
import ObjcParserAntlr
import GrammarModels

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
        _ decl: DeclarationExtractor.Declaration,
        context: Context
    ) -> [ASTNodeDeclaration] {

        let nodeFactory = context.nodeFactory

        guard let baseType = baseType(from: decl.specifiers, pointer: decl.pointer, context: context) else {
            return []
        }
        guard let ctxNode = ctxNode(for: decl) else {
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
                guard let identifierNode = identifierNode(from: decl.declaration, context: context) else {
                    return nil
                }

                let typeNode = TypeNameNode(
                    type: baseType,
                    isInNonnullContext: nodeFactory.isInNonnullContext(identifier)
                )
                nodeFactory.updateSourceLocation(for: typeNode, with: identifier)

                result = .variable(
                    rule: decl.declarationNode.rule,
                    nullability: partialType.nullability,
                    identifier: identifierNode,
                    type: typeNode,
                    initialValue: nil
                )
            
            case .pointer(let base, _):
                guard let base = _applyDeclarator(base) else {
                    return nil
                }

                // TODO: Support other types of pointer declarators
                switch base {
                case .function(let rule, let identifier, let parameters, let returnType):
                    result = .functionPointer(
                        rule: rule,
                        nullability: nil,
                        identifier: identifier,
                        parameters: parameters,
                        returnType: returnType,
                        initialValue: nil
                    )

                default:
                    return nil
                }
            
            case .block(let nullabilitySpecifier, _, let parameters):
                guard let identifierNode = identifierNode(from: decl.declaration, context: context) else {
                    return nil
                }

                let parameterNodes = parameters.compactMap { argument in
                    self.functionArgument(from: argument, context: context)
                }
                let returnTypeNode = self.typeNameNode(
                    from: baseType,
                    ctxNode: ctxNode,
                    context: context
                )

                result = .block(
                    rule: decl.declarationNode.rule,
                    nullability: nullability(from: nullabilitySpecifier) ?? partialType.nullability,
                    identifier: identifierNode,
                    parameters: parameterNodes,
                    returnType: returnTypeNode,
                    initialValue: nil
                )
            
            case .function(_, let parameters):
                guard let identifierNode = identifierNode(from: decl.declaration, context: context) else {
                    return nil
                }
                
                let parameterNodes = parameters.compactMap { argument in
                    self.functionArgument(from: argument, context: context)
                }
                let returnTypeNode = self.typeNameNode(
                    from: baseType,
                    ctxNode: ctxNode,
                    context: context
                )

                result = .function(
                    rule: decl.declarationNode.rule,
                    identifier: identifierNode,
                    parameters: parameterNodes,
                    returnType: returnTypeNode
                )
            
            case .staticArray(_, _, let length):
                guard let identifierNode = identifierNode(from: decl.declaration, context: context) else {
                    return nil
                }
                let constant = length.flatMap(ConstantContextExtractor.extract(from:))

                var type: ObjcType? = baseType
                type = partialType.makePointer { 
                    translateObjectiveCType($0, context: context)
                }
                
                // Promote to fixed array, if it provides an appropriate size
                if let constant = constant, let int = Int(constant.getText()) {
                    type = partialType.makeFixedArray(length: int) {
                        translateObjectiveCType($0, context: context)
                    }
                }

                guard let type = type else {
                    return nil
                }

                let typeNameNode = typeNameNode(
                    from: type,
                    ctxNode: ctxNode,
                    context: context
                )

                result = .variable(
                    rule: decl.declarationNode.rule,
                    nullability: partialType.nullability,
                    identifier: identifierNode,
                    type: typeNameNode,
                    initialValue: nil
                )
            
            case .typedef(_, _, let baseTypeDecl):
                guard let identifierNode = identifierNode(from: decl.declaration, context: context) else {
                    return nil
                }

                let convertedBase = translate(baseTypeDecl, context: context)

                guard let firstDecl = convertedBase.first else {
                    return nil
                }
                guard let type = firstDecl.objcType else {
                    return nil
                }

                let finalType = PartialType.applyPointer(base: type, partialType.pointer)
                
                let typeNameNode = typeNameNode(
                    from: finalType,
                    ctxNode: ctxNode,
                    context: context
                )
                
                result = .typedef(
                    rule: baseTypeDecl.declarationNode.rule,
                    baseType: firstDecl,
                    typeNode: typeNameNode,
                    alias: identifierNode
                )
            }

            return result
        }

        result = _applyDeclarator(decl.declaration)
        result?.initializer = decl.initializer

        // TODO: Refactor the declaration translation code to avoid having to
        // hardcode checking for typedef this way instead of just using the
        // value returned by `_applyDecorator` as-is.
        //if result?.isTypedef == false {
            if
                let enumSpecifier = partialType.enumSpecifier,
                let identifierNode = identifierNode(from: decl.declaration, context: context)
            {
                let typeNameNode = typeNameNode(from: enumSpecifier.typeName, context: context)
                let enumerators = enumCases(enumSpecifier.enumerators, context: context)

                result = .enumDecl(
                    rule: decl.declarationNode.rule,
                    identifier: identifierNode,
                    typeName: typeNameNode,
                    enumSpecifier,
                    enumerators
                )
            } else if
                let structOrUnionSpecifier = partialType.structOrUnionSpecifier,
                let identifierNode = identifierNode(from: decl.declaration, context: context)
            {
                let fields = structFields(structOrUnionSpecifier.fields, context: context)

                result = .structOrUnionDecl(
                    rule: decl.declarationNode.rule,
                    identifier: identifierNode,
                    structOrUnionSpecifier,
                    fields
                )
            //}
        } else if
            partialType.isTypedef,
            let result = result,
            let identifierNode = identifierNode(from: decl.declaration, context: context),
            let baseType = result.objcType
        {
            let typeNode = typeNameNode(from: baseType, ctxNode: ctxNode, context: context)

            return [
                .typedef(
                    rule: decl.declarationNode.rule,
                    baseType: result,
                    typeNode: typeNode,
                    alias: identifierNode
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
        _ decls: [DeclarationExtractor.Declaration],
        context: Context
    ) -> [ASTNodeDeclaration] {

        return decls.flatMap({ self.translate($0, context: context) })
    }

    /// Translates the C type of a declaration into an appropriate `ObjcType`
    /// instance.
    public func translateObjectiveCType(
        _ decl: DeclarationExtractor.Declaration,
        context: Context
    ) -> ObjcType? {

        let partialType = PartialType(decl.specifiers, pointer: decl.pointer)
        guard let type = partialType.makeType({ translateObjectiveCType($0, context: context) }) else {
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

            case .function(let base, let params):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
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
            
            case .block(_, let base, let params):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
                    return nil
                }

                let partial: ObjcType = .functionPointer(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes
                )

                return _applyDeclarator(base, type: partial)
                
            case .typedef(_, _, baseType: let baseTypeDecl):
                guard let baseType = translateObjectiveCType(baseTypeDecl, context: context) else {
                    return nil
                }

                return _applyDeclarator(baseTypeDecl.declaration, type: baseType)
            }
        }

        return _applyDeclarator(decl.declaration, type: type)
    }

    /// Translates the type of a generic parameter into an appropriate `ObjcType`
    /// instance.
    func translateObjectiveCType(
        _ decl: DeclarationExtractor.GenericTypeParameter,
        context: Context
    ) -> ObjcType? {

        return translateObjectiveCType(decl.type, context: context)
    }

    /// Translates the type of a `TypeName` declaration into an appropriate
    /// `ObjcType` instance.
    public func translateObjectiveCType(
        _ decl: DeclarationExtractor.TypeName,
        context: Context
    ) -> ObjcType? {

        let partialType = PartialType(decl.specifiers, pointer: decl.pointer)
        guard let type = partialType.makeType({ translateObjectiveCType($0, context: context) }) else {
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
            case .function(let base, let params):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
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
            }
        }

        return _applyDeclarator(decl.declaration, type: type)
    }

    private func typeNameNode(
        from type: ObjcType,
        ctxNode: ParserRuleContext,
        context: Context
    ) -> TypeNameNode {

        let typeNameNode = TypeNameNode(
            type: type,
            isInNonnullContext: context.nodeFactory.isInNonnullContext(ctxNode)
        )
        context.nodeFactory.updateSourceLocation(for: typeNameNode, with: ctxNode)

        return typeNameNode
    }

    private func functionArgument(
        from blockParameter: DeclarationExtractor.BlockParameter,
        context: Context
    ) -> FunctionParameter? {

        let nodeFactory = context.nodeFactory
        
        switch blockParameter {
        case .declaration(let declaration):
            let decls = translate(declaration, context: context)
            guard decls.count == 1 else {
                return nil
            }

            let decl = decls.first

            guard let ctxNode = ctxNode(for: declaration) else {
                return nil
            }
            
            let paramNode = FunctionParameter(
                isInNonnullContext: nodeFactory.isInNonnullContext(ctxNode)
            )
            
            nodeFactory.updateSourceLocation(for: paramNode, with: ctxNode)

            if let identifier = decl?.identifierNode {
                paramNode.addChild(identifier)
            }
            if let typeNode = decl?.typeNode {
                paramNode.addChild(typeNode)
            }

            return paramNode

        case .typeName(let typeName):
            let paramNode = FunctionParameter(
                isInNonnullContext: nodeFactory.isInNonnullContext(
                    typeName.declarationNode.rule
                )
            )
            
            nodeFactory.updateSourceLocation(
                for: paramNode,
                with: typeName.declarationNode.rule
            )

            if let type = translateObjectiveCType(typeName, context: context) {
                let typeNameNode = TypeNameNode(
                    type: type,
                    isInNonnullContext: paramNode.isInNonnullContext
                )

                paramNode.addChild(typeNameNode)
            }

            return paramNode
        }
    }

    private func functionArgument(
        from functionParam: DeclarationExtractor.FuncParameter,
        context: Context
    ) -> FunctionParameter? {

        let nodeFactory = context.nodeFactory

        switch functionParam {
        case .declaration(let declaration):
            let decls = translate(declaration, context: context)

            guard decls.count == 1, let decl = decls.first else {
                return nil
            }
            guard let ctxNode = ctxNode(for: declaration) else {
                return nil
            }

            let paramNode = FunctionParameter(
                isInNonnullContext: nodeFactory.isInNonnullContext(ctxNode)
            )

            if let identifier = decl.identifierNode {
                paramNode.addChild(identifier)
            }
            if let typeNameNode = decl.typeNode {
                paramNode.addChild(typeNameNode)
            } else if let type = decl.objcType {
                let typeNameNode = typeNameNode(from: type, ctxNode: ctxNode, context: context)
                paramNode.addChild(typeNameNode)
            }

            return paramNode
        
        case .typeName(let typeName):
            let paramNode = FunctionParameter(
                isInNonnullContext: nodeFactory.isInNonnullContext(
                    typeName.declarationNode.rule
                )
            )
            
            nodeFactory.updateSourceLocation(
                for: paramNode,
                with: typeName.declarationNode.rule
            )

            if let type = translateObjectiveCType(typeName, context: context) {
                let typeNameNode = TypeNameNode(
                    type: type,
                    isInNonnullContext: paramNode.isInNonnullContext
                )

                paramNode.addChild(typeNameNode)
            }

            return paramNode
        }
    }

    private func functionArgumentTypes(
        from declarations: [DeclarationExtractor.FuncParameter],
        context: Context
    ) -> [ObjcType]? {

        let paramTypes = declarations.map {
            functionArgument(from: $0, context: context)?.type?.type
        }

        if paramTypes.contains(nil) {
            return nil
        }

        return paramTypes.compactMap({ $0 })
    }

    private func functionArgumentTypes(
        from blockParameters: [DeclarationExtractor.BlockParameter],
        context: Context
    ) -> [ObjcType]? {

        let paramTypes = blockParameters.map {
            functionArgument(from: $0, context: context)?.type?.type
        }

        if paramTypes.contains(nil) {
            return nil
        }

        return paramTypes.compactMap({ $0 })
    }

    /// Translates a list of C struct/union fields into AST node declarations.
    private func structFields(
        _ fields: [DeclarationExtractor.StructFieldDeclaration]?,
        context: Context
    ) -> [ObjcStructField] {

        guard let fields else {
            return []
        }

        return fields.compactMap({ self.structField($0, context: context) })
    }

    /// Translates a list of C enum enumerators into AST node declarations.
    private func enumCases(
        _ enumerators: [DeclarationExtractor.EnumeratorDeclaration]?,
        context: Context
    ) -> [ObjcEnumCase] {

        guard let enumerators else {
            return []
        }

        return enumerators.compactMap({ self.enumCase($0, context: context) })
    }

    /// Translates a C struct/union field into an `ObjcStructField`.
    private func structField(
        _ field: DeclarationExtractor.StructFieldDeclaration,
        context: Context
    ) -> ObjcStructField? {

        guard let type = translateObjectiveCType(field.declaration, context: context) else {
            return nil
        }
        guard let ident = identifierNode(from: field.declaration.declaration, context: context) else {
            return nil
        }

        let node = ObjcStructField(isInNonnullContext: ident.isInNonnullContext)

        node.addChild(ident)
        node.addChild(
            typeNameNode(
                from: type,
                ctxNode: field.declaration.declarationNode.rule,
                context: context
            )
        )

        node.updateSourceRange()

        return node
    }

    /// Translates a C struct/union enumerator into an `ObjcEnumCase`.
    private func enumCase(
        _ enumerator: DeclarationExtractor.EnumeratorDeclaration,
        context: Context
    ) -> ObjcEnumCase? {
        guard let identCtx = enumerator.identifier.identifier() else {
            return nil
        }

        let ident = context.nodeFactory.makeIdentifier(from: identCtx)

        let node = ObjcEnumCase(isInNonnullContext: ident.isInNonnullContext)
        node.addChild(ident)

        if let expression = enumerator.expression {
            node.addChild(
                context.nodeFactory.makeExpression(from: expression)
            )
        }

        node.updateSourceRange()

        return node
    }

    private func typeNameNode(
        from typeName: DeclarationExtractor.TypeName?,
        context: Context
    ) -> TypeNameNode? {

        guard let typeName = typeName, let type = translateObjectiveCType(typeName, context: context) else {
            return nil
        }
        let ruleCtx = typeName.declarationNode.rule

        let nonnull = context.nodeFactory.isInNonnullContext(ruleCtx)
        let typeNode = TypeNameNode(type: type, isInNonnullContext: nonnull)
        context.nodeFactory.updateSourceLocation(for: typeNode, with: ruleCtx)

        return typeNode
    }

    private func identifierNode(
        from declKind: DeclarationExtractor.DeclarationKind?,
        context: Context
    ) -> Identifier? {

        guard let declKind = declKind else {
            return nil
        }

        switch declKind {
        case .block(_, let base, _), .function(let base, _):
            return identifierNode(from: base, context: context)

        case .staticArray(let base, _, _), .pointer(let base, _):
            return identifierNode(from: base, context: context)

        case .typedef(_, let identifier, _):
            return context.nodeFactory.makeIdentifier(from: identifier)

        case .identifier(_, let node):
            let identifierNode = context.nodeFactory.makeIdentifier(from: node)

            return identifierNode
        }
    }

    /// Returns the inner-most context node for a given declaration.
    /// Is the direct declarator node if present, otherwise it is the identifier
    /// context for non-initialized declarations, or `nil`, if neither is present.
    private func ctxNode(for decl: DeclarationExtractor.Declaration) -> ParserRuleContext? {
        return decl.declarationNode.rule
    }

    private func baseType(
        from declSpecifiers: [DeclarationExtractor.DeclSpecifier],
        pointer: DeclarationExtractor.Pointer?,
        context: Context
    ) -> ObjcType? {
        guard !declSpecifiers.isEmpty else {
            return nil
        }

        let partialType = PartialType(declSpecifiers, pointer: pointer)
        return partialType.makeType {
            translateObjectiveCType($0, context: context)
        }
    }

    private func nullability(
        from nullabilitySpecifier: DeclarationExtractor.NullabilitySpecifier?
    ) -> Nullability? {

        guard let nullabilitySpecifier = nullabilitySpecifier else {
            return nil
        }

        switch nullabilitySpecifier {
        case .nonnull:
            return .nonnull
        case .nullResettable:
            return .nullResettable
        case .nullUnspecified:
            return .unspecified
        case .nullable:
            return .nullable
        }
    }

    private func _extractStaticLength(from rule: ObjectiveCParser.PrimaryExpressionContext?) -> Int? {
        guard let constant = rule.flatMap(ConstantContextExtractor.extract(from:)) else {
            return nil
        }

        return Int(constant.getText())
    }

    /// Context for creation of declarations
    public struct Context {
        /// Factory for creating AST nodes out of ANTLR parser rules.
        public var nodeFactory: ASTNodeFactory 

        public init(nodeFactory: ASTNodeFactory) {
            self.nodeFactory = nodeFactory
        }
    }

    /// A declaration that has been converted into a mode that is suitable to
    /// create `ASTNode` instances out of.
    // TODO: Collapse `functionPointer` and `block` into `variable` case.
    public enum ASTNodeDeclaration {
        case variable(
            rule: ParserRuleContext,
            nullability: Nullability?,
            identifier: Identifier,
            type: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        case enumDecl(
            rule: ParserRuleContext,
            identifier: Identifier?,
            typeName: TypeNameNode?,
            DeclarationExtractor.EnumSpecifier,
            [ObjcEnumCase]
        )
        case structOrUnionDecl(
            rule: ParserRuleContext,
            identifier: Identifier?,
            DeclarationExtractor.StructOrUnionSpecifier,
            [ObjcStructField]
        )
        case function(
            rule: ParserRuleContext,
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode
        )
        case functionPointer(
            rule: ParserRuleContext,
            nullability: Nullability?,
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        case block(
            rule: ParserRuleContext,
            nullability: Nullability?,
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        
        indirect case typedef(
            rule: ParserRuleContext,
            baseType: ASTNodeDeclaration,
            typeNode: TypeNameNode,
            alias: Identifier
        )

        /// Gets the identifier associated with this node, if any.
        public var identifierNode: Identifier? {
            switch self {
            case .block(_, _, let identifier, _, _, _),
                .functionPointer(_, _, let identifier, _, _, _),
                .function(_, let identifier, _, _),
                .variable(_, _, let identifier, _, _),
                .typedef(_, _, _, let identifier):
                return identifier

            case .enumDecl(_, let identifier, _, _, _),
                .structOrUnionDecl(_, let identifier, _, _):
                return identifier
            }
        }

        /// Gets the type node associated with this node, if any.
        public var typeNode: TypeNameNode? {
            switch self {
            case .variable(_, _, _, let type, _), .typedef(_, _, let type, _):
                return type
            
            case .block, .functionPointer, .function, .enumDecl, .structOrUnionDecl:
                return nil
            }
        }

        /// Gets or sets the initializer for this declaration.
        /// In case this is not a declaration that supports initializers, nothing
        /// is done.
        public var initializer: ObjectiveCParser.InitializerContext? {
            get {
                switch self {
                case .variable(_, _, _, _, let initialValue),
                    .functionPointer(_, _, _, _, _, let initialValue),
                    .block(_, _, _, _, _, let initialValue):

                    return initialValue

                case .enumDecl, .structOrUnionDecl, .typedef, .function:
                    return nil
                }
            }
            set {
                switch self {
                case .block(let rule, let nullability, let identifier, let parameters, let returnType, _):
                    self = .block(
                        rule: rule,
                        nullability: nullability,
                        identifier: identifier,
                        parameters: parameters,
                        returnType: returnType,
                        initialValue: newValue
                    )

                case .functionPointer(let rule, let nullability, let identifier, let parameters, let returnType, _):
                    self = .functionPointer(
                        rule: rule,
                        nullability: nullability,
                        identifier: identifier,
                        parameters: parameters,
                        returnType: returnType,
                        initialValue: newValue
                    )
                case .variable(let rule, let nullability, let identifier, let type, _):
                    self = .variable(
                        rule: rule,
                        nullability: nullability,
                        identifier: identifier,
                        type: type,
                        initialValue: newValue
                    )
                case .enumDecl, .structOrUnionDecl, .typedef, .function:
                    break
                }
            }
        }

        public var objcType: ObjcType? {
            switch self {
            case .variable(_, _, _, let type, _):
                return type.type
            
            case .typedef(_, _, _, let alias):
                return .struct(alias.name)
            
            case .function(_, let ident, let params, let retType), .functionPointer(_, _, let ident, let params, let retType, _):
                if params.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .functionPointer(name: ident.name, returnType: retType.type, parameters: params.compactMap {
                    $0.type?.type
                })

            case .block(_, _, let ident, let params, let retType, _):
                if params.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .blockType(name: ident.name, returnType: retType.type, parameters: params.compactMap {
                    $0.type?.type
                })
            
            case .enumDecl(_, let ident, _, _, _), .structOrUnionDecl(_, let ident, _, _):
                return (ident?.name).map { .struct($0) }
            }
        }

        /// Gets the parser rule associated with this definition.
        public var contextRule: ParserRuleContext {
            switch self {
            case .block(let rule, _, _, _, _, _),
                .enumDecl(let rule, _, _, _, _),
                .structOrUnionDecl(let rule, _, _, _),
                .function(let rule, _, _, _),
                .functionPointer(let rule, _, _, _, _, _),
                .typedef(let rule, _, _, _),
                .variable(let rule, _, _, _, _):

                return rule
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

    /// Specifies a nullability of a declaration.
    public enum Nullability {
        case unspecified
        case nonnull
        case nullable
        case nullResettable
    }

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
        var isStructOrUnion: Bool {
            declSpecifiers.typeSpecifiers().contains(where: { $0.isStructOrUnionSpecifier })
        }
        var isEnumSpecifier: Bool {
            declSpecifiers.typeSpecifiers().contains(where: { $0.isEnumSpecifier })
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

        var nullability: Nullability? {
            let specs = declSpecifiers.nullabilitySpecifiers()

            if let last = specs.last {
                switch last {
                case .nonnull:
                    return .nonnull
                case .nullResettable:
                    return .nullResettable
                case .nullUnspecified:
                    return .unspecified
                case .nullable:
                    return .nullable
                }
            }

            return nil
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

            if let pointer = pointer {
                for _ in pointer.pointers {
                    result = .pointer(result)
                }
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
                for _ in pointer.pointers {
                    result = .pointer(result)
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
        return .struct(name.description)

    case .typeName(let value):
        if let genericTypeList = value.genericTypes {
            let genericTypes = genericTypeList.types.map(genericTypeParsing)

            if genericTypes.contains(nil) {
                return nil
            }

            return .generic(value.name, parameters: genericTypes.compactMap({ $0 }))
        }

        return .struct(value.name)

    case .structOrUnionSpecifier(let ctx):
        if let ident = ctx.identifier {
            return .struct(ident.getText())
        }

        return .anonymousStruct
    
    case .enumSpecifier(let ctx):
        if let ident = ctx.identifier {
            return .struct(ident.getText())
        }

        return .anonymousEnum
    }
}
