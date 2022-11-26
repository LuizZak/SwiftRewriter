import Antlr4
import ObjcParserAntlr
import GrammarModels

/// Converts a declaration from `DeclarationExtractor` to a proper `ASTNode`
/// representing the declaration.
public class DeclarationTranslator {

    public func translate(
        _ decl: DeclarationExtractor.Declaration,
        context: Context
    ) -> ASTNodeDeclaration? {

        let nodeFactory = context.nodeFactory

        guard let baseType = baseType(from: decl.specifiers, pointer: decl.pointer, context: context) else {
            return nil
        }
        guard let ctxNode = ctxNode(for: decl) else {
            return nil
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
                case .function(let identifier, let parameters, let returnType):
                    result = .functionPointer(
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
                    nullability: partialType.nullability,
                    identifier: identifierNode,
                    type: typeNameNode,
                    initialValue: nil
                )
            }

            return result
        }

        result = _applyDeclarator(decl.declaration)
        result?.initializer = decl.initializer

        if
            partialType.isTypedef,
            let result = result,
            let identifierNode = identifierNode(from: decl.declaration, context: context)
        {
            return .typedef(
                baseType: result,
                alias: identifierNode
            )
        }

        return result
    }

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
            }
        }

        return _applyDeclarator(decl.declaration, type: type)
    }

    func translateObjectiveCType(
        _ decl: DeclarationExtractor.GenericTypeParameter,
        context: Context
    ) -> ObjcType? {

        return translateObjectiveCType(decl.type, context: context)
    }

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
            let decl = translate(declaration, context: context)

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
            guard let decl = translate(declaration, context: context) else {
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

        case .identifier(_, let node):
            let identifierNode = context.nodeFactory.makeIdentifier(from: node)

            return identifierNode
        }
    }

    /// Returns the inner-most context node for a given declaration.
    /// Is the direct declarator node if present, otherwise it is the identifier
    /// context for non-initialized declarations, or `nil`, if neither is present.
    private func ctxNode(for decl: DeclarationExtractor.Declaration) -> ParserRuleContext? {
        return decl.declarationNode ?? decl.declaration.identifierContext
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
            nullability: Nullability?,
            identifier: Identifier,
            type: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        case enumDecl(
            ObjectiveCParser.EnumSpecifierContext
        )
        case structDecl(
            ObjectiveCParser.StructOrUnionSpecifierContext
        )
        case function(
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode
        )
        case functionPointer(
            nullability: Nullability?,
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        case block(
            nullability: Nullability?,
            identifier: Identifier,
            parameters: [FunctionParameter],
            returnType: TypeNameNode,
            initialValue: ObjectiveCParser.InitializerContext?
        )
        
        indirect case typedef(
            baseType: ASTNodeDeclaration,
            alias: Identifier
        )

        /// Gets the identifier associated with this node, if any.
        public var identifierNode: Identifier? {
            switch self {
            case .block(_, let identifier, _, _, _),
                .functionPointer(_, let identifier, _, _, _),
                .function(let identifier, _, _),
                .variable(_, let identifier, _, _),
                .typedef(_, let identifier):
                return identifier

            case .enumDecl, .structDecl:
                return nil
            }
        }

        /// Gets the type node associated with this node, if any.
        public var typeNode: TypeNameNode? {
            switch self {
            case .variable(_, _, let type, _):
                return type
            
            case .typedef(let baseType, _):
                return baseType.typeNode
            
            case .block, .functionPointer, .function, .enumDecl, .structDecl:
                return nil
            }
        }

        /// Gets or sets the initializer for this declaration.
        /// In case this is not a declaration that supports initializers, nothing
        /// is done.
        public var initializer: ObjectiveCParser.InitializerContext? {
            get {
                switch self {
                case .variable(_, _, _, let initialValue),
                    .functionPointer(_, _, _, _, let initialValue),
                    .block(_, _, _, _, let initialValue):

                    return initialValue

                case .enumDecl, .structDecl, .typedef, .function:
                    return nil
                }
            }
            set {
                switch self {
                case .block(let nullability, let identifier, let parameters, let returnType, _):
                    self = .block(
                        nullability: nullability,
                        identifier: identifier,
                        parameters: parameters,
                        returnType: returnType,
                        initialValue: newValue
                    )

                case .functionPointer(let nullability, let identifier, let parameters, let returnType, _):
                    self = .functionPointer(
                        nullability: nullability,
                        identifier: identifier,
                        parameters: parameters,
                        returnType: returnType,
                        initialValue: newValue
                    )
                case .variable(let nullability, let identifier, let type, _):
                    self = .variable(
                        nullability: nullability,
                        identifier: identifier,
                        type: type,
                        initialValue: newValue
                    )
                case .enumDecl, .structDecl, .typedef, .function:
                    break
                }
            }
        }

        public var objcType: ObjcType? {
            switch self {
            case .variable(_, _, let type, _):
                return type.type
            
            case .typedef(_, let alias):
                return .struct(alias.name)
            
            case .function(let ident, let params, let retType), .functionPointer(_, let ident, let params, let retType, _):
                if params.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .functionPointer(name: ident.name, returnType: retType.type, parameters: params.compactMap {
                    $0.type?.type
                })

            case .block(_, let ident, let params, let retType, _):
                if params.contains(where: { $0.type == nil }) {
                    return nil
                }

                return .blockType(name: ident.name, returnType: retType.type, parameters: params.compactMap {
                    $0.type?.type
                })
            
            case .enumDecl, .structDecl:
                return nil
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
            _ ptr: DeclarationExtractor.Pointer?,
            _ genericTypeParsing: (DeclarationExtractor.GenericTypeParameter) -> ObjcType?
        ) -> ObjcType? {

            guard var result = makeType(genericTypeParsing) else {
                return nil
            }

            if let pointer = pointer {
                for _ in pointer.pointers {
                    result = .pointer(result)
                }
            }

            return result
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

    // TODO: Consider relaxing requirements of specifiers to allow for aliased
    // expansion down the transpiler pipeline.
    guard specifiers.count == 1 else {
        return nil
    }

    switch specifiers[0] {
    case .scalar(let name):
        return .struct(name.description)

    case .typeName(let base, _, nil):
        return .struct(base)

    case .typeName(let base, _, let genericTypes?):
        let genericTypes = genericTypes.types.map(genericTypeParsing)

        if genericTypes.contains(nil) {
            return nil
        }

        return .generic(base, parameters: genericTypes.compactMap({ $0 }))
    
    case .enumSpecifier, .structOrUnionSpecifier:
        return nil
    }
}
