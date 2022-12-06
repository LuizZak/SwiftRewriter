import Antlr4
import ObjcParserAntlr
import GrammarModels

// TODO: Refactor to remove `ASTNode` creation from this translation level and
// TODO: leave that to `DefinitionCollector`, as this is causing problems down
// TODO: the pipeline in the Swift AST/Expression generation layer.

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
                    .init(
                        rule: decl.declarationNode.rule,
                        nullability: partialType.nullability,
                        arcSpecifier: partialType.arcSpecifier,
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
                    result = .functionPointer(
                        .init(
                            rule: decl.rule,
                            nullability: nil,
                            identifier: decl.identifier,
                            parameters: decl.parameters,
                            returnType: decl.returnType,
                            initialValue: nil,
                            isStatic: partialType.isStatic
                        )
                    )

                default:
                    return nil
                }
            
            case .block(let blockSpecifiers, _, let parameters):
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
                    .init(
                        rule: decl.declarationNode.rule,
                        nullability: blockSpecifiers.nullabilitySpecifier().last ?? partialType.nullability,
                        arcSpecifier: blockSpecifiers.arcBehaviourSpecifier().last ?? partialType.arcSpecifier,
                        typeQualifiers: blockSpecifiers.typeQualifier(),
                        typePrefix: blockSpecifiers.typePrefix().last,
                        identifier: identifierNode,
                        parameters: parameterNodes,
                        returnType: returnTypeNode,
                        initialValue: nil,
                        isStatic: partialType.isStatic
                    )
                )
            
            case .function(_, let parameters, let isVariadic):
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
                    .init(
                        rule: decl.declarationNode.rule,
                        identifier: identifierNode,
                        parameters: parameterNodes,
                        returnType: returnTypeNode,
                        isVariadic: isVariadic
                    )
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
                    .init(
                        rule: decl.declarationNode.rule,
                        nullability: partialType.nullability,
                        arcSpecifier: nil,
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
        result?.initializer = decl.initializer

        // Conversion into struct/enum/typedef
        if
            isStructConvertible(decl, partialType),
            let structOrUnionSpecifier = partialType.structOrUnionSpecifier,
            let identifierNode = identifierNode(from: decl.declaration, context: context)
        {
            let fields = structFields(structOrUnionSpecifier.fields, context: context)

            result = .structOrUnionDecl(
                .init(
                    rule: decl.declarationNode.rule,
                    identifier: identifierNode,
                    context: structOrUnionSpecifier,
                    fields: fields
                )
            )
        } else if
            isEnumConvertible(decl, partialType),
            let enumSpecifier = partialType.enumSpecifier,
            let identifierNode = identifierNode(from: decl.declaration, context: context)
        {
            let typeNameNode = typeNameNode(from: enumSpecifier.typeName, context: context)
            let enumerators = enumCases(enumSpecifier.enumerators, context: context)

            result = .enumDecl(
                .init(
                    rule: decl.declarationNode.rule,
                    identifier: identifierNode,
                    typeName: typeNameNode,
                    context: enumSpecifier,
                    enumerators: enumerators
                )
            )
        } else if
            isTypedefConvertible(decl, partialType),
            let result = result,
            let identifierNode = identifierNode(from: decl.declaration, context: context),
            var baseType = result.objcType
        {
            // Handle opaque/anonymous struct/enum declarations
            if partialType.pointer != nil && partialType.isOpaqueOrAnonymousDeclaration {
                baseType = PartialType.applyPointer(base: .void, partialType.pointer)
            }

            let typeNode = typeNameNode(from: baseType, ctxNode: ctxNode, context: context)

            return [
                .typedef(
                    .init(
                        rule: decl.declarationNode.rule,
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
        _ decls: [DeclarationExtractor.Declaration],
        context: Context
    ) -> [ASTNodeDeclaration] {

        return decls.flatMap({ self.translate($0, context: context) })
    }
    
    // TODO: Reduce duplication with translate() above.
    
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

            case .function(let base, let params, _):
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
            
            case .block(let blockSpecifiers, let base, let params):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
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
            case .function(let base, let params, _):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
                    return nil
                }

                let partial: ObjcType = .functionPointer(
                    name: nil,
                    returnType: type,
                    parameters: paramTypes
                )

                return _applyDeclarator(base, type: partial)
            
            case .block(let base, let specifiers, let params):
                guard let paramTypes = functionArgumentTypes(from: params, context: context) else {
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
        guard decl.declaration.identifierContext != nil else {
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
        guard decl.declaration.identifierContext != nil else {
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

    /// Translates a list of C struct/union fields into AST node declarations.
    private func structFields(
        _ fields: [DeclarationExtractor.StructFieldDeclaration]?,
        context: Context
    ) -> [ASTStructFieldDeclaration] {

        guard let fields else {
            return []
        }

        return fields.compactMap({ self.structField($0, context: context) })
    }

    /// Translates a list of C enum enumerators into AST node declarations.
    private func enumCases(
        _ enumerators: [DeclarationExtractor.EnumeratorDeclaration]?,
        context: Context
    ) -> [ASTEnumeratorDeclaration] {

        guard let enumerators else {
            return []
        }

        return enumerators.compactMap({ self.enumCase($0, context: context) })
    }

    /// Translates a C struct/union field into an `ASTStructFieldDeclaration`.
    private func structField(
        _ field: DeclarationExtractor.StructFieldDeclaration,
        context: Context
    ) -> ASTStructFieldDeclaration? {

        guard let type = translateObjectiveCType(field.declaration, context: context) else {
            return nil
        }
        guard let ident = identifierNode(from: field.declaration.declaration, context: context) else {
            return nil
        }
        guard let ctxNode = field.declarator ?? field.constantExpression else {
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
        
        return ASTStructFieldDeclaration(node: node, rule: ctxNode)
    }

    /// Translates a C struct/union enumerator into an `ASTEnumeratorDeclaration`.
    private func enumCase(
        _ enumerator: DeclarationExtractor.EnumeratorDeclaration,
        context: Context
    ) -> ASTEnumeratorDeclaration? {

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

        return ASTEnumeratorDeclaration(node: node, rule: identCtx)
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
        guard let identifierCtx = declKind.identifierContext else {
            return nil
        }

        return context.nodeFactory.makeIdentifier(from: identifierCtx)
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

    private func _extractStaticLength(from rule: ObjectiveCParser.ExpressionContext?) -> Int? {
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
            ASTVariableDeclaration
        )
        case block(
            ASTBlockDeclaration
        )
        case functionPointer(
            ASTFunctionPointerDeclaration
        )
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
        public var identifierNode: Identifier? {
            switch self {
            case .variable(let decl):
                return decl.identifier
            case .block(let decl):
                return decl.identifier
            case .functionPointer(let decl):
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
        public var typeNode: TypeNameNode? {
            switch self {
            case .variable(let decl):
                return decl.type
            
            case .typedef(let decl):
                return decl.typeNode
            
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
                case .variable(let decl):
                    return decl.initialValue
                case .block(let decl):
                    return decl.initialValue
                case .functionPointer(let decl):
                    return decl.initialValue

                case .enumDecl, .structOrUnionDecl, .typedef, .function:
                    return nil
                }
            }
            set {
                switch self {
                case .block(let decl):
                    self = .block(
                        decl.withInitializer(newValue)
                    )

                case .functionPointer(let decl):
                    self = .functionPointer(
                        decl.withInitializer(newValue)
                    )
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
                if decl.parameters.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .functionPointer(name: decl.identifier.name, returnType: decl.returnType.type, parameters: decl.parameters.compactMap {
                    $0.type?.type
                })

            case .functionPointer(let decl):
                if decl.parameters.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .functionPointer(name: decl.identifier.name, returnType: decl.returnType.type, parameters: decl.parameters.compactMap {
                    $0.type?.type
                })

            case .block(let decl):
                if decl.parameters.contains(where: { $0.type == nil }) {
                    return nil
                }

                var partial: ObjcType = .blockType(name: decl.identifier.name, returnType: decl.returnType.type, parameters: decl.parameters.compactMap {
                    $0.type?.type
                }, nullabilitySpecifier: decl.nullability)

                if let arcSpecifier = decl.arcSpecifier {
                    partial = .specified(specifiers: [.arcSpecifier(arcSpecifier)], partial)
                }
                if decl.typeQualifiers.count > 0 {
                    partial = .qualified(partial, qualifiers: decl.typeQualifiers)
                }

                return partial
            
            case .structOrUnionDecl(let decl):
                return (decl.identifier?.name).map { .typeName($0) }

            case .enumDecl(let decl):
                return (decl.identifier?.name).map { .typeName($0) }
            }
        }

        /// Gets the parser rule associated with this definition.
        public var contextRule: ParserRuleContext {
            switch self {
            case .variable(let decl):
                return decl.rule

            case .block(let decl):
                return decl.rule

            case .functionPointer(let decl):
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
        public var rule: ParserRuleContext
        public var nullability: ObjcNullabilitySpecifier?
        public var arcSpecifier: ObjcArcBehaviorSpecifier?
        public var identifier: Identifier
        public var type: TypeNameNode
        public var initialValue: ObjectiveCParser.InitializerContext?
        public var isStatic: Bool

        public func withInitializer(_ value: ObjectiveCParser.InitializerContext?) -> Self {
            var copy = self
            copy.initialValue = value
            return copy
        }
    }

    // TODO: Consider collapsing into `ASTVariableDeclaration`
    /// Specifications for a block declaration.
    public struct ASTBlockDeclaration {
        public var rule: ParserRuleContext
        public var nullability: ObjcNullabilitySpecifier?
        public var arcSpecifier: ObjcArcBehaviorSpecifier?
        public var typeQualifiers: [ObjcTypeQualifier]
        public var typePrefix: DeclarationExtractor.TypePrefix?
        public var identifier: Identifier
        public var parameters: [FunctionParameter]
        public var returnType: TypeNameNode
        public var initialValue: ObjectiveCParser.InitializerContext?
        public var isStatic: Bool

        public func withInitializer(_ value: ObjectiveCParser.InitializerContext?) -> Self {
            var copy = self
            copy.initialValue = value
            return copy
        }
    }

    // TODO: Collapse into `ASTVariableDeclaration`
    /// Specifications for a function pointer declaration.
    public struct ASTFunctionPointerDeclaration {
        public var rule: ParserRuleContext
        public var nullability: ObjcNullabilitySpecifier?
        public var identifier: Identifier
        public var parameters: [FunctionParameter]
        public var returnType: TypeNameNode
        public var initialValue: ObjectiveCParser.InitializerContext?
        public var isStatic: Bool

        public func withInitializer(_ value: ObjectiveCParser.InitializerContext?) -> Self {
            var copy = self
            copy.initialValue = value
            return copy
        }
    }

    /// Specifications for a function definition.
    /// Does not include a function body.
    public struct ASTFunctionDefinition {
        public var rule: ParserRuleContext
        public var identifier: Identifier
        public var parameters: [FunctionParameter]
        public var returnType: TypeNameNode
        public var isVariadic: Bool
    }

    /// Specifications for a struct or union definition.
    public struct ASTStructOrUnionDeclaration {
        public var rule: ParserRuleContext
        public var identifier: Identifier?
        public var context: DeclarationExtractor.StructOrUnionSpecifier
        public var fields: [ASTStructFieldDeclaration]
    }

    /// Contains information for a generated struct or union field.
    public struct ASTStructFieldDeclaration {
        /// The node for the field itself.
        public var node: ObjcStructField

        /// The context rule for this field declaration.
        /// It is the innermost parser rule where queries against the source code
        /// range can be used accurately to collect surrounding comments and
        /// nonnull-contexts unambiguously.
        public var rule: ParserRuleContext
    }

    /// Contains information for a generated enum field.
    public struct ASTEnumDeclaration {
        public var rule: ParserRuleContext
        public var identifier: Identifier?
        public var typeName: TypeNameNode?
        public var context: DeclarationExtractor.EnumSpecifier
        public var enumerators: [ASTEnumeratorDeclaration]
    }

    /// Contains information for a generated enumerator, or enum value.
    public struct ASTEnumeratorDeclaration {
        /// The node for the enumerator itself.
        public var node: ObjcEnumCase

        /// The context rule for this enumerator declaration.
        /// It is the innermost parser rule where queries against the source code
        /// range can be used accurately to collect surrounding comments and
        /// nonnull-contexts unambiguously.
        public var rule: ParserRuleContext
    }

    /// Specification for a typedef declaration node.
    public struct ASTTypedefDeclaration {
        public var rule: ParserRuleContext
        public var baseType: ASTNodeDeclaration
        public var typeNode: TypeNameNode
        public var alias: Identifier
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
        if let ident = ctx.identifier {
            return .typeName(ident.getText())
        }

        return .anonymousStruct
    
    case .enumSpecifier(let ctx):
        if let ident = ctx.identifier {
            return .typeName(ident.getText())
        }

        return .anonymousEnum
    }
}
