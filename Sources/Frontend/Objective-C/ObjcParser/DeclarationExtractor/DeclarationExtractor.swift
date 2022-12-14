import ObjcGrammarModels

/// Provides APIs for extracting declarations from C/Objective-C syntax.
public class DeclarationExtractor {
    private var _context: Context

    public init() {
        _context = .empty
    }

    /// Creates an independent declaration extractor that can be used to collect
    /// nested declarations without affecting the current context state.
    private func makeSubExtractor() -> DeclarationExtractor {
        DeclarationExtractor()
    }

    /// Extracts one or more declarations from a given declaration syntax element.
    public func extract(from ctx: DeclarationSyntax) -> [Declaration] {
        let specifiers = ctx.declarationSpecifiers

        guard let initDeclaratorList = ctx.initDeclaratorList else {
            if let decl = extract(fromSpecifiers: specifiers) {
                return [decl]
            }

            return []
        }

        return extract(fromSpecifiers: specifiers, initDeclaratorList: initDeclaratorList)
    }

    /// Extracts one or more declarations from a given field declaration context.
    public func extract(
        from fieldDeclaration: FieldDeclarationSyntax
    ) -> [Declaration] {

        clearContext()

        collectSpecifiers(from: fieldDeclaration)

        return declarations(from: fieldDeclaration, context: _context) ?? []
    }

    /// Extracts a declaration from a given type variable context.
    public func extract(
        from ctx: TypeVariableDeclaratorSyntax
    ) -> Declaration? {

        clearContext()

        let declarationSpecifiers = ctx.declarationSpecifiers
        
        collectSpecifiers(from: declarationSpecifiers)

        return self.declaration(from: ctx)
    }

    /// Extracts one or more declarations from a given declaration specifier and
    /// init declarator syntax elements
    public func extract(
        fromSpecifiers ctx: DeclarationSpecifiersSyntax,
        initDeclaratorList: InitDeclaratorListSyntax
    ) -> [Declaration] {

        var result: [Declaration] = []

        clearContext()
        
        collectSpecifiers(from: ctx)

        let isTypeDef = _context.isTypeDef

        for (i, initDeclarator) in initDeclaratorList.initDeclarators.enumerated() {
            if let declaration = declaration(from: initDeclarator, context: _context) {
                result.append(declaration)

                // After first typedef declaration, the remaining declarators
                // use as a declaration specifier the aliased type name that was
                // just defined.
                if isTypeDef && i == 0, let typeNameCtx = declaration.identifierSyntax {

                    setDeclSpecifiers(
                        [
                            .storageSpecifier(.typedef),
                            .typeSpecifier(
                                .typeName(
                                    .init(
                                        name: typeNameCtx.identifier,
                                        identifier: typeNameCtx
                                    )
                                )
                            )
                        ],
                        syntax: ctx
                    )
                }
            }
        }

        return result
    }

    /// Extracts a declaration from a given declaration specifier list and
    /// declarator syntax elements.
    public func extract(
        fromSpecifiers ctx: DeclarationSpecifiersSyntax?,
        declarator: DeclaratorSyntax
    ) -> Declaration? {

        clearContext()
        
        collectSpecifiers(from: ctx)

        return declaration(from: declarator, context: _context)
    }

    /// Extracts an uninitialized declaration from a given declaration specifier
    /// list.
    ///
    /// The declaration specifiers context must contain at least one unqualified
    /// identifier at the end of the specifiers list for it to be considered a
    /// non-initialized declaration.
    public func extract(
        fromSpecifiers ctx: DeclarationSpecifiersSyntax
    ) -> Declaration? {

        clearContext()
        
        collectSpecifiers(from: ctx)

        return declaration(context: _context)
    }

    /// Extracts a type name from a given type name context.
    public func extract(
        fromTypeName ctx: TypeNameSyntax
    ) -> TypeName? {

        clearContext()

        let declarationSpecifiers = ctx.declarationSpecifiers
        
        collectSpecifiers(from: declarationSpecifiers)

        return typeName(from: ctx)
    }

    /// Extracts a type name from a given declaration specifier list and abstract
    /// declarator syntax elements.
    public func extract(
        fromSpecifiers ctx: DeclarationSpecifiersSyntax?,
        abstractDeclarator: AbstractDeclaratorSyntax
    ) -> TypeName? {

        clearContext()
        
        collectSpecifiers(from: ctx)

        return typeName(from: ctx, abstractDeclarator: abstractDeclarator)
    }

    /// Extracts one or more struct field declarations from a given struct
    /// declaration context.
    public func extract(
        fromStructDeclaration structDecl: StructDeclarationSyntax
    ) -> [StructFieldDeclaration]? {

        clearContext()

        collectSpecifiers(from: structDecl)

        return declarations(from: structDecl, context: _context)
    }

    /// Returns `true` if a direct declarator represents a named variable type.
    public func isVariableDeclaration(_ ctx: DirectDeclaratorSyntax) -> Bool {
        declaration(
            from: ctx,
            pointer: nil,
            context: .empty
        )?.isVariableDeclaration ?? false
    }

    // MARK: - Declaration generation

    /// Extracts a raw declaration with no initializer context.
    private func declaration(context: Context) -> Declaration? {
        guard let declarationKind = declarationKind(from: nil) else {
            return nil
        }
        guard let ctx = context.specifiersContext else {
            return nil
        }

        let declaration: DeclarationDeclNode

        // Drop last type specifier (the name of the declaration itself), in case
        // it is a .typeName case
        let specifiers: [DeclSpecifier]
        if let lastIdent = context.specifiers.last?.typeSpecifier?.asTypeNameSpecifier {
            specifiers = context.specifiers.dropLast()
            
            declaration = .identifier(lastIdent.identifier)
        } else {
            specifiers = context.specifiers

            declaration = .declSpecifiers(ctx)
        }

        return Declaration(
            typePrefix: context.typePrefixes.first,
            specifiers: Array(specifiers),
            pointer: nil,
            declaration: declarationKind,
            declarationNode: declaration,
            initializer: nil
        )
    }

    private func declaration(
        from ctx: InitDeclaratorSyntax?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }

        let declarator = ctx.declarator
        guard var declaration = self.declaration(from: declarator, context: _context) else {
            return nil
        }

        declaration.initializer = ctx.initializer

        return declaration
    }

    private func declaration(
        from ctx: DeclaratorSyntax?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }
        
        return declaration(
            from: ctx.directDeclarator,
            pointer: ctx.pointer,
            context: context
        )
    }

    private func declaration(
        from ctx: DirectDeclaratorSyntax?,
        pointer: PointerSyntax?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }
        guard let declarationKind = declarationKind(from: ctx) else {
            return nil
        }

        let pointer = pointer.map(self.pointer(from:))

        return Declaration(
            typePrefix: context.typePrefixes.first,
            specifiers: context.specifiers,
            pointer: pointer,
            declaration: declarationKind,
            declarationNode: .directDeclarator(ctx),
            initializer: nil
        )
    }

    private func declarations(
        from ctx: StructDeclarationSyntax?,
        context: Context
    ) -> [StructFieldDeclaration]? {

        guard let ctx = ctx else {
            return nil
        }

        guard !ctx.fieldDeclaratorList.isEmpty else {
            // Fallback to `specifierQualifierList SEMI` syntax case
            guard let decl = declaration(context: context) else {
                return nil
            }

            return [
                StructFieldDeclaration(
                    declaration: decl,
                    declarator: nil,
                    constantExpression: nil
                )
            ]
        }

        var result: [StructFieldDeclaration] = []

        for decl in ctx.fieldDeclaratorList {
            if let decl = structFieldDeclaration(from: decl, context: context) {
                result.append(decl)
            }
        }

        return result
    }

    private func structFieldDeclaration(
        from ctx: FieldDeclaratorSyntax?,
        context: Context
    ) -> StructFieldDeclaration? {

        guard let ctx = ctx else {
            return nil
        }

        var decl: Declaration?

        let declarator: DeclaratorSyntax?

        switch ctx {
        case .declarator(let d), .declaratorConstantExpression(let d?, _):
            // `declarator`
            // `declarator COLON constantExpression`
            decl = declaration(from: d, context: context)
            decl?.constant = nil

            declarator = d
        case .declaratorConstantExpression(nil, let exp):
            // `<none> COLON constantExpression` case
            decl = declaration(context: context)
            decl?.constant = exp

            declarator = nil
        }

        if let decl = decl {
            return StructFieldDeclaration(
                declaration: decl,
                declarator: declarator,
                constantExpression: decl.constant
            )
        }

        return nil
    }

    private func declarations(
        from ctx: FieldDeclarationSyntax?,
        context: Context
    ) -> [Declaration]? {
        
        guard let ctx = ctx else {
            return nil
        }
        let fieldDeclaratorList = ctx.fieldDeclaratorList

        return declarations(from: fieldDeclaratorList, context: context)
    }

    private func declarations(
        from ctx: [FieldDeclaratorSyntax],
        context: Context
    ) -> [Declaration]? {

        guard !ctx.isEmpty else {
            return nil
        }

        var result: [Declaration] = []

        for decl in ctx {
            if let decl = declaration(from: decl, context: context) {
                result.append(decl)
            }
        }

        return result
    }

    private func declaration(
        from ctx: FieldDeclaratorSyntax?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }

        var decl: Declaration?

        switch ctx {
        case .declarator(let d), .declaratorConstantExpression(let d?, _):
            // `declarator`
            // `declarator COLON constantExpression`
            decl = declaration(from: d, context: context)
            decl?.constant = nil
        case .declaratorConstantExpression(nil, let exp):
            // `<none> COLON constantExpression` case
            decl = declaration(context: context)
            decl?.constant = exp
        }

        return decl
    }

    private func declaration(
        from ctx: TypeVariableDeclaratorSyntax?
    ) -> Declaration? {
        guard let ctx = ctx else {
            return nil
        }

        let declarationSpecifiers = ctx.declarationSpecifiers
        let declarator = ctx.declarator

        let extractor = makeSubExtractor()

        return extractor.extract(
            fromSpecifiers: declarationSpecifiers,
            declarator: declarator
        )
    }

    private func typeName(
        from ctx: TypeNameSyntax
    ) -> TypeName {

        let specifiers = declSpecifiers(from: ctx.declarationSpecifiers)
        let pointer = ctx.abstractDeclarator?.pointer.map(self.pointer(from:))
        let declKind = abstractDeclarationKind(
            from: ctx.abstractDeclarator?.directAbstractDeclarator
        )

        return TypeName(
            specifiers: specifiers,
            declarationNode: .typeName(ctx),
            pointer: pointer,
            declaration: declKind
        )
    }

    private func typeName(
        from ctx: DeclarationSpecifiersSyntax?,
        abstractDeclarator: AbstractDeclaratorSyntax?
    ) -> TypeName? {

        guard let ctx = ctx else {
            return nil
        }
        
        let specifiers = declSpecifiers(from: ctx)

        let pointer = abstractDeclarator?.pointer.flatMap(self.pointer(from:))
        let declKind = abstractDeclarationKind(
            from: abstractDeclarator?.directAbstractDeclarator
        )

        return TypeName(
            specifiers: specifiers,
            declarationNode: .declSpecifiers(ctx, abstractDeclarator: abstractDeclarator),
            pointer: pointer,
            declaration: declKind
        )
    }

    // MARK: - Specifier/type prefix collecting

    private func collectSpecifiers(from ctx: DeclarationSyntax?) {
        collectSpecifiers(from: ctx?.declarationSpecifiers)
    }
    private func collectSpecifiers(from ctx: FieldDeclarationSyntax?) {
        collectSpecifiers(from: ctx?.declarationSpecifiers)
    }
    private func collectSpecifiers(from ctx: DeclarationSpecifiersSyntax?) {
        guard let ctx = ctx else {
            return
        }
        let declSpecifiers = declSpecifiers(from: ctx)

        setDeclSpecifiers(declSpecifiers, syntax: ctx)
    }
    private func collectSpecifiers(from ctx: StructDeclarationSyntax?) {
        guard let ctx = ctx else {
            return
        }
        let declSpecifiers = declSpecifiers(from: ctx.specifierQualifierList)

        setDeclSpecifiers(declSpecifiers, syntax: ctx)
    }

    private func collectTypePrefix(from ctx: TypePrefixSyntax?) {
        guard let ctx = ctx else {
            return
        }
        let typePrefix = typePrefix(from: ctx)

        setTypePrefix(typePrefix, syntax: ctx)
    }

    // MARK: - Context management

    private func clearContext() {
        _context = .empty
    }

    private func setDeclSpecifiers(
        _ declSpecifiers: [DeclSpecifier],
        syntax: DeclarationSpecifiersSyntax
    ) {
        _context.specifiers = declSpecifiers
        _context.specifiersContext = syntax
    }
    private func setDeclSpecifiers(
        _ declSpecifiers: [DeclSpecifier],
        syntax: StructDeclarationSyntax
    ) {
        _context.specifiers = declSpecifiers
        _context.structDeclarationContext = syntax
    }
    private func setTypePrefix(
        _ typePrefix: TypePrefix,
        syntax: TypePrefixSyntax
    ) {
        _context.typePrefixes = [typePrefix]
        _context.typePrefixContext = syntax
    }

    // MARK: - Parsing helpers

    private func declarationKind(
        from syntax: DirectDeclaratorSyntax?
    ) -> DeclarationKind? {

        guard let syntax = syntax else {
            // Non-initialized declaration
            let specifiers = _context.specifiers.typeSpecifiers()
            guard let lastSpec = specifiers.last else {
                return nil
            }
            guard let lastIdent = lastSpec.identifierSyntax else {
                return nil
            }

            return .identifier(lastIdent.identifier, lastIdent)
        }

        switch syntax {
        case .identifier(let ident):
            return .identifier(ident.identifier, ident)

        case .declarator(let decl):
            guard let base = declarationKind(from: decl.directDeclarator) else {
                return nil
            }

            if let pointer = decl.pointer {
                return .pointer(
                    base: base,
                    pointer: self.pointer(from: pointer)
                )
            }

            return base

        case .functionDeclarator(let decl):
            let parameters = decl.parameterTypeList.flatMap(self.parameterList(from:))
            let isVariadic = decl.parameterTypeList?.isVariadic == true

            if let base = declarationKind(from: decl.directDeclarator) {
                return .function(
                    base: base,
                    parameters: parameters ?? [],
                    isVariadic: isVariadic
                )
            }

        case .blockDeclarator(let decl):
            guard let base = declarationKind(from: decl.directDeclarator) else {
                return nil
            }

            let blockSpecifiers = blockSpecifiers(from: decl.blockDeclarationSpecifiers)

            if let params = parameterList(from: decl.parameterList) {
                return .block(
                    specifiers: blockSpecifiers,
                    base: base,
                    arguments: params
                )
            }

        case .arrayDeclarator(let decl):
            let typeQualifiers = decl.typeQualifiers.map(self.typeQualifierList(from:))
            let expression = decl.length

            if let base = declarationKind(from: syntax.directDeclarator) {
                return .staticArray(
                    base: base,
                    typeQualifiers: typeQualifiers,
                    length: expression
                )
            }
        }

        return nil
    }

    private func abstractDeclarationKind(from syntax: DirectAbstractDeclaratorSyntax?) -> AbstractDeclarationKind? {
        guard let syntax = syntax else {
            return nil
        }

        switch syntax {
        case .abstractDeclarator(let decl):
            return abstractDeclarationKind(from: decl.directAbstractDeclarator)

        case .functionDeclarator(let decl):
            let parameters = decl.parameterTypeList.flatMap(self.parameterList(from:))
            let isVariadic = decl.parameterTypeList?.isVariadic == true
            let base = abstractDeclarationKind(from: decl.directAbstractDeclarator)

            return .function(
                base: base,
                parameters: parameters ?? [],
                isVariadic: isVariadic
            )

        case .blockDeclarator(let decl):
            let base = abstractDeclarationKind(from: decl.directAbstractDeclarator)
            let blockSpecifiers = blockSpecifiers(from: decl.blockDeclarationSpecifiers)

            if let params = parameterList(from: decl.parameterList) {
                return .block(
                    base: base,
                    specifiers: blockSpecifiers,
                    parameters: params
                )
            }

        case .arrayDeclarator(let decl):
            let typeQualifiers = decl.typeQualifiers.map(self.typeQualifierList(from:))
            let expression = decl.length
            let base = abstractDeclarationKind(from: syntax.directAbstractDeclarator)

            return .staticArray(
                base: base,
                typeQualifiers: typeQualifiers,
                length: expression
            )
        }

        return nil
    }

    private func parameterList(from syntax: ParameterTypeListSyntax) -> [FuncParameter]? {
        return parameterList(from: syntax.parameterList)
    }

    private func parameterList(from syntax: ParameterListSyntax) -> [FuncParameter]? {
        let parameters = syntax.parameterDeclarations.compactMap(parameter(from:))

        // Handle '(void)' parameter list; should be equivalent to an empty parameter
        // list.
        if parameters.count == 1 {
            switch parameters[0] {
            case .typeName(let typeName) where typeName.pointer == nil && typeName.declaration == nil && typeName.specifiers.count == 1:
                if typeName.specifiers[0].typeSpecifier?.scalarType == "void" {
                    return []
                }
            default:
                break
            }
        }

        return parameters
    }

    private func parameterList(from elements: [ParameterDeclarationSyntax]) -> [FuncParameter] {
        return elements.compactMap(parameter(from:))
    }

    private func parameter(
        from syntax: ParameterDeclarationSyntax
    ) -> FuncParameter? {

        switch syntax {
        case .declarator(let declarationSpecifiers, let declarator):
            let extractor = makeSubExtractor()

            return extractor.extract(
                fromSpecifiers: declarationSpecifiers,
                declarator: declarator
            ).map { .declaration($0) }

        case .abstractDeclarator(let declarationSpecifiers, let abstractDeclarator):
            let typeName = typeName(
                from: declarationSpecifiers,
                abstractDeclarator: abstractDeclarator
            )

            return typeName.map { .typeName($0) }

        case .declarationSpecifiers(let declarationSpecifiers):
            let typeName = typeName(
                from: declarationSpecifiers,
                abstractDeclarator: nil
            )

            return typeName.map { .typeName($0) }
        }
    }

    private func typePrefix(from syntax: TypePrefixSyntax) -> TypePrefix {
        switch syntax {
        case .block:
            return .block
        case .bridge:
            return .bridge
        case .bridgeRetained:
            return .bridgeRetained
        case .bridgeTransfer:
            return .bridgeTransfer
        case .inline:
            return .inline
        case .kindof:
            return .kindof
        case .nsInline:
            return .nsInline
        }
    }

    private func pointer(from syntax: PointerSyntax) -> Pointer {
        let pointers = syntax.pointerEntries.map(self.pointerEntry(from:))

        return Pointer(pointers: pointers)
    }

    private func pointerEntry(from syntax: PointerSyntaxEntry) -> PointerEntry {
        return .pointer(
            syntax.typeQualifiers.map(self.typeQualifierList(from:)),
            syntax.nullabilitySpecifier.map(self.nullabilitySpecifier(from:))
        )
    }

    private func declSpecifiers(from syntax: DeclarationSpecifiersSyntax?) -> [DeclSpecifier]? {
        guard let syntax = syntax else {
            return nil
        }

        var result: [DeclSpecifier] = []

        for spec in syntax.declarationSpecifier {
            // For now, ignore alignment specifiers
            if case .alignment = spec {
                continue
            }

            result.append(declSpecifier(from: spec))
        }

        return result
    }

    private func declSpecifiers(from syntax: DeclarationSpecifiersSyntax) -> [DeclSpecifier] {
        var result: [DeclSpecifier] = []

        for spec in syntax.declarationSpecifier {
            result.append(declSpecifier(from: spec))
        }

        return result
    }

    private func declSpecifiers(from syntax: SpecifierQualifierListSyntax) -> [DeclSpecifier] {
        var result: [DeclSpecifier] = []

        for spec in syntax.specifierQualifiers {
            switch spec {
            case .typeSpecifier(let spec):
                result.append(.typeSpecifier(typeSpecifier(from: spec)))

            case .typeQualifier(let spec):
                result.append(.typeQualifier(typeQualifier(from: spec)))

            case .alignment(let spec):
                result.append(.alignmentSpecifier(alignmentSpecifier(from: spec)))
            }
        }

        return result
    }

    private func declSpecifier(from syntax: DeclarationSpecifierSyntax) -> DeclSpecifier {
        switch syntax {
        case .storage(let spec):
            return .storageSpecifier(storageSpecifier(from: spec))

        case .typeSpecifier(let spec):
            return .typeSpecifier(typeSpecifier(from: spec))
            
        case .typeQualifier(let spec):
            return .typeQualifier(typeQualifier(from: spec))
            
        case .functionSpecifier(let spec):
            return .functionSpecifier(functionSpecifier(from: spec))

        case .arcBehaviour(let spec):
            return .arcSpecifier(arcSpecifier(from: spec))
            
        case .nullability(let spec):
            return .nullabilitySpecifier(nullabilitySpecifier(from: spec))

        case .ibOutlet(let spec):
            return .ibOutletQualifier(ibOutletQualifier(from: spec))

        case .alignment(let spec):
            return .alignmentSpecifier(alignmentSpecifier(from: spec))
        
        case .typePrefix(let spec):
            return .typePrefix(typePrefix(from: spec))
        }
    }

    private func storageSpecifier(from syntax: StorageClassSpecifierSyntax) -> StorageSpecifier {
        switch syntax {
        case .auto:
            return .auto
        case .constexpr:
            return .constexpr
        case .extern:
            return .extern
        case .register:
            return .register
        case .static:
            return .static
        case .threadLocal:
            return .threadLocal
        case .typedef:
            return .typedef
        }
    }

    private func typeSpecifier(from syntax: TypeSpecifierSyntax) -> TypeSpecifier {
        switch syntax {
        case .scalar(let spec):
            return .scalar(
                scalarType(from: spec)
            )

        case .typeIdentifier(let spec):
            return .typeName(
                .init(name: spec.identifier.identifier, identifier: spec.identifier)
            )

        case .genericTypeIdentifier(let spec):
            let identifier = spec.identifier
            
            let genericTypeSpecifier = genericTypeList(
                from: spec.genericTypeParameters
            )

            return .typeName(
                .init(
                    name: identifier.identifier,
                    identifier: identifier,
                    genericTypes: genericTypeSpecifier
                )
            )

        case .id(let protocolList?):
            return .typeName(
                .init(
                    name: "id",
                    identifier: .init(sourceRange: syntax.sourceRange, identifier: "id"),
                    genericTypes: .init(types: protocolList.protocols.map { protName in
                        GenericTypeParameter(
                            type: typeName(from: .init(
                                stringLiteral: protName.identifier.identifier
                            ))
                        )
                    })
                )
            )

        case .id(nil):
            return .typeName(
                .init(
                    name: "id",
                    identifier: .init(sourceRange: syntax.sourceRange, identifier: "id")
                )
            )

        case .className(let identifier, let protocolList?):
            let name = identifier.identifier.identifier

            return .typeName(
                .init(
                    name: name,
                    identifier: identifier.identifier,
                    genericTypes: .init(types: protocolList.protocols.map { protName in
                        GenericTypeParameter(
                            type: typeName(from: .init(
                                stringLiteral: protName.identifier.identifier
                            ))
                        )
                    })
                )
            )

        case .className(let identifier, nil):
            let name = identifier.identifier.identifier

            return .typeName(
                .init(
                    name: name,
                    identifier: identifier.identifier
                )
            )

        case .structOrUnion(let specifier):
            return .structOrUnionSpecifier(
                structOrUnionSpecifier(from: specifier)
            )
        case .enum(let specifier):
            return .enumSpecifier(
                enumSpecifier(from: specifier)
            )

        case .typeof(let exp):
            return .typeof(exp)
        }
    }

    private func structOrUnionSpecifier(from syntax: StructOrUnionSpecifierSyntax) -> StructOrUnionSpecifier {
        switch syntax.declaration {
        case .declared(let identifier, let fields):
            return StructOrUnionSpecifier(
                syntax: syntax,
                identifier: identifier,
                fields: self.structFieldDeclarations(from: fields)
            )

        case .opaque(let identifier):
            return StructOrUnionSpecifier(
                syntax: syntax,
                identifier: identifier,
                fields: nil
            )
        }
    }

    private func structFieldDeclarations(
        from syntax: StructDeclarationListSyntax?
    ) -> [StructFieldDeclaration]? {
        
        guard let syntax = syntax else {
            return nil
        }

        return syntax
            .structDeclaration
            .compactMap(self.structFieldDeclarations(from:))
            .flatMap({ $0 })
    }

    private func structFieldDeclarations(
        from syntax: StructDeclarationSyntax?
    ) -> [StructFieldDeclaration]? {

        guard let syntax = syntax else {
            return nil
        }

        let extractor = makeSubExtractor()
        let result = extractor.extract(fromStructDeclaration: syntax)

        return result
    }

    private func enumSpecifier(from syntax: EnumSpecifierSyntax) -> EnumSpecifier {
        switch syntax {
        case .cEnum(let ident, let typeName, let decl):
            var fields: [EnumeratorDeclaration]?

            switch decl {
            case .opaque:
                break
            case .declared(_, let enumerators):
                fields = self.enumeratorDeclarations(from: enumerators)
            }

            return EnumSpecifier(
                syntax: syntax,
                typeName: typeName.map(self.typeName(from:)),
                identifier: ident,
                enumerators: fields
            )

        case .nsOptionsOrNSEnum(_, let typeName, let identifier, let enumerators):
            let declList = self.enumeratorDeclarations(from: enumerators)

            return EnumSpecifier(
                syntax: syntax,
                typeName: self.typeName(from: typeName),
                identifier: identifier,
                enumerators: declList
            )
        }
    }

    private func enumeratorDeclarations(from syntax: EnumeratorListSyntax) -> [EnumeratorDeclaration] {
        return syntax
            .enumerators
            .compactMap(self.enumeratorDeclaration(from:))
    }

    private func enumeratorDeclaration(from syntax: EnumeratorSyntax) -> EnumeratorDeclaration {
        let identifier = syntax.enumeratorIdentifier

        return EnumeratorDeclaration(
            identifier: identifier,
            expression: syntax.expression
        )
    }

    private func genericTypeList(from elements: [GenericTypeParameterSyntax]) -> GenericTypeList {
        return GenericTypeList(
            types: elements
                .compactMap(genericTypeParameter(from:))
        )
    }

    private func genericTypeParameter(from syntax: GenericTypeParameterSyntax?) -> GenericTypeParameter? {
        guard let syntax = syntax else {
            return nil
        }

        let typeName = syntax.typeName

        let extractor = makeSubExtractor()
        guard let type = extractor.extract(fromTypeName: typeName) else {
            return nil
        }

        var kind: GenericTypeKind?

        switch syntax.variance {
        case .covariant:
            kind = .covariant
        case .contravariant:
            kind = .contravariant
        case nil:
            break
        }

        return GenericTypeParameter(
            kind: kind,
            type: type
        )
    }

    private func scalarType(from syntax: ScalarTypeSpecifierSyntax) -> ScalarType {
        switch syntax {
        case .void:
            return .void
        case .char:
            return .char
        case .short:
            return .short
        case .int:
            return .int
        case .long:
            return .long
        case .float:
            return .float
        case .double:
            return .double
        case .signed:
            return .signed
        case .unsigned:
            return .unsigned
        case .complex:
            return .complex
        case ._bool, .bool:
            return .bool
        case .m128:
            return .m128
        case .m128d:
            return .m128d
        case .m128i:
            return .m128i
        }
    }

    private func typeQualifierList(from syntax: TypeQualifierListSyntax) -> [ObjcTypeQualifier] {
        return syntax.typeQualifiers.map(self.typeQualifier(from:))
    }

    private func typeQualifier(from syntax: TypeQualifierSyntax) -> ObjcTypeQualifier {
        switch syntax {
        case .const:
            return .const
        case .volatile:
            return .volatile
        case .restrict:
            return .restrict
        case .atomic:
            return .atomic
        case .protocolQualifier(let value):
            return .protocolQualifier(protocolQualifier(from: value))
        }
    }

    private func protocolQualifier(from syntax: ProtocolQualifierSyntax) -> ObjcProtocolQualifier {
        switch syntax {
        case .bycopy:
            return .bycopy
        case .byref:
            return .byref
        case .in:
            return .in
        case .inout:
            return .inout
        case .oneway:
            return .oneway
        case .out:
            return .out
        }
    }

    private func alignmentSpecifier(from syntax: AlignmentSpecifierSyntax) -> AlignmentSpecifier {
        switch syntax {
        case .expression(let exp):
            return .constant(exp)
        case .typeName(let type):
            return .typeName(typeName(from: type))
        }
    }

    private func functionSpecifier(from syntax: FunctionSpecifierSyntax) -> ObjcFunctionSpecifier {
        switch syntax {
        case .noreturn:
            return .noReturn
        case .inline, .gccInline:
            return .inline
        case .stdcall:
            return .stdCall
        case .declspec(_, let ident):
            return .declspec(ident.identifier)
        }
    }

    private func blockSpecifiers(from elements: [BlockDeclarationSpecifierSyntax]) -> [BlockDeclarationSpecifier] {
        elements.map(self.blockSpecifier(from:))
    }

    private func blockSpecifier(from syntax: BlockDeclarationSpecifierSyntax) -> BlockDeclarationSpecifier {
        switch syntax {
        case .nullability(let spec):
            return .nullabilitySpecifier(
                nullabilitySpecifier(from: spec)
            )
        case .arcBehaviour(let spec):
            return .arcBehaviourSpecifier(
                arcSpecifier(from: spec)
            )
        case .typeQualifier(let spec):
            return .typeQualifier(
                typeQualifier(from: spec)
            )
        case .typePrefix(let spec):
            return .typePrefix(
                typePrefix(from: spec)
            )
        }
    }

    private func arcSpecifier(from syntax: ArcBehaviourSpecifierSyntax) -> ObjcArcBehaviorSpecifier {
        switch syntax {
        case .autoreleasingQualifier:
            return .autoreleasing
        case .strongQualifier:
            return .strong
        case .unsafeUnretainedQualifier:
            return .unsafeUnretained
        case .weakQualifier:
            return .weak
        }
    }

    private func nullabilitySpecifier(from syntax: NullabilitySpecifierSyntax) -> ObjcNullabilitySpecifier {
        syntax.asObjcNullabilitySpecifier
    }

    private func ibOutletQualifier(from syntax: IBOutletQualifierSyntax) -> ObjcIBOutletQualifier {
        syntax.asObjcIBOutletQualifier
    }

    // MARK: - Internals

    /// Context for a declaration parsing invocation
    private struct Context {
        /// An empty context
        static let empty: Context = Context(
            typePrefixes: [],
            specifiers: []
        )

        /// A list of type prefixes for declarations
        var typePrefixes: [TypePrefix]

        /// The specifiers for declarations
        var specifiers: [DeclSpecifier]

        /// The syntax element where the current declaration specifiers where
        /// derived from.
        /// 
        /// Is mutually exclusive with `structDeclarationContext`, and defining
        /// both at the same time is an undefined state.
        var specifiersContext: DeclarationSpecifiersSyntax?
        
        /// The syntax element where the current type prefix was derived from.
        var typePrefixContext: TypePrefixSyntax?

        /// The syntax element where the current declaration specifiers where
        /// derived from.
        /// 
        /// Is mutually exclusive with `specifiersContext`, and defining both at
        /// the same time is an undefined state.
        var structDeclarationContext: StructDeclarationSyntax?

        /// Whether the current declaration is a typedef declaration context.
        var isTypeDef: Bool { specifiers.storageSpecifiers().contains { $0.isTypedef } }
        
        /// Gets the last type name specifier on the specifier list.
        var lastTypeNameSpecifier: TypeNameSpecifier? {
            specifiers.typeSpecifiers().last(where: { $0.isTypeName })?.asTypeNameSpecifier
        }
    }
}

public extension DeclarationExtractor {
    /// A declaration that was detected during construction
    struct Declaration: Hashable, CustomStringConvertible {
        /// The type prefix that precedes a declaration.
        var typePrefix: TypePrefix?

        /// A list of declaration specifiers for reference purposes.
        var specifiers: [DeclSpecifier]

        /// A list of pointers for this declaration.
        var pointer: Pointer?

        /// The declaration kind, containing extra information pertaining to the
        /// declarator part of the syntax, e.g. function parameters, pointer
        /// or array storage, etc.
        var declaration: DeclarationKind

        /// The syntax node containing this declaration.
        var declarationNode: DeclarationDeclNode

        /// An initializer that was collected alongside this declaration,
        /// if it was present.
        var initializer: InitializerSyntax?
        
        /// A constant syntax element that was collected alongside this
        /// declaration, if it was present.
        var constant: ConstantExpressionSyntax?

        /// Returns `true` if this declaration is of a variable declaration kind.
        var isVariableDeclaration: Bool {
            switch declaration {
            case .identifier:
                return true
            default:
                return false
            }
        }

        /// Extracts the root identifier syntax element for this declaration, if
        /// any is available.
        var identifierSyntax: IdentifierSyntax? {
            declaration.identifierSyntax
        }

        /// Extracts the root identifier string for this declaration, if any is
        /// available.
        var identifierString: String? {
            declaration.identifierString
        }

        public var description: String {
            var result = ""

            result.joinIfPresent(typePrefix)
            result.joinList(specifiers)
            result.joinIfPresent(pointer)

            return result
        }
    }

    /// The source for a `Declaration` value.
    enum DeclarationDeclNode: Hashable {
        /// A direct declarator syntax where the type was defined.
        case directDeclarator(DirectDeclaratorSyntax)

        /// An identifier syntax.
        case identifier(IdentifierSyntax)

        /// A list of declaration specifiers that contained the definition.
        case declSpecifiers(DeclarationSpecifiersSyntax)

        /// A struct or union field declaration.
        case structDeclaration(StructDeclarationSyntax)

        /// Returns a common base syntax element for this declaration node which
        /// is guaranteed to exist in the underlying AST.
        var syntaxElement: DeclarationSyntaxElementType {
            switch self {
            case
                .directDeclarator(let ctx as DeclarationSyntaxElementType),
                .identifier(let ctx as DeclarationSyntaxElementType),
                .declSpecifiers(let ctx as DeclarationSyntaxElementType),
                .structDeclaration(let ctx as DeclarationSyntaxElementType):

                return ctx
            }
        }

        /// Returns the associated value if this enum is a `.directDeclarator()`
        /// case.
        var asDirectDeclarator: DirectDeclaratorSyntax? {
            switch self {
            case .directDeclarator(let syntax):
                return syntax
            default:
                return nil
            }
        }

        /// Returns the associated value if this enum is a `.identifier()`
        /// case.
        var asIdentifier: IdentifierSyntax? {
            switch self {
            case .identifier(let syntax):
                return syntax
            default:
                return nil
            }
        }

        /// Returns the associated value if this enum is a `.declSpecifiers()`
        /// case.
        var asDeclSpecifiers: DeclarationSpecifiersSyntax? {
            switch self {
            case .declSpecifiers(let syntax):
                return syntax
            default:
                return nil
            }
        }

        /// Returns the associated value if this enum is a `.structDeclaration()`
        /// case.
        var asStructDeclaration: StructDeclarationSyntax? {
            switch self {
            case .structDeclaration(let syntax):
                return syntax
            default:
                return nil
            }
        }
    }

    /// An abstract type name declaration
    struct TypeName: Hashable, CustomStringConvertible {
        /// A list of declaration specifiers for reference purposes.
        var specifiers: [DeclSpecifier]

        /// The syntax node for this declaration.
        var declarationNode: TypeNameDeclNode

        /// A list of pointers for this declaration.
        var pointer: Pointer?

        /// The declaration kind, containing extra information pertaining to the
        /// declarator part of the syntax, e.g. function parameters, pointer
        /// or array storage, etc.
        var declaration: AbstractDeclarationKind?

        public var description: String {
            var result = ""

            result.joinList(specifiers)
            result.joinIfPresent(pointer, separator: "")
            result.joinIfPresent(declaration, separator: "")

            return result
        }
    }

    /// The source for a TypeName declaration
    enum TypeNameDeclNode: Hashable {
        /// Type name was derived from a `typeName` syntax element
        case typeName(TypeNameSyntax)
        
        /// Type name was derived from a combination of `declarationSpecifiers`
        /// and optionally a `abstractDeclarator`.
        case declSpecifiers(
            DeclarationSpecifiersSyntax,
            abstractDeclarator: AbstractDeclaratorSyntax?
        )

        /// Returns a common base syntax element for this declaration node which
        /// is guaranteed to exist in the underlying AST.
        var syntaxElement: DeclarationSyntaxElementType {
            switch self {
            case
                .typeName(let ctx as DeclarationSyntaxElementType),
                .declSpecifiers(let ctx as DeclarationSyntaxElementType, _):

                return ctx
            }
        }
    }

    /// The kind for a detected declaration
    enum DeclarationKind: Hashable, CustomStringConvertible {
        /// An identifier kind, e.g. for a variable.
        case identifier(
            String,
            IdentifierSyntax
        )

        /// A static pointer array.
        indirect case staticArray(
            base: DeclarationKind,
            typeQualifiers: [ObjcTypeQualifier]? = nil,
            length: ExpressionSyntax? = nil
        )
        
        /// A function declaration.
        indirect case function(
            base: DeclarationKind,
            parameters: [FuncParameter],
            isVariadic: Bool
        )

        /// A declaration for a pointer that points to a declaration.
        indirect case pointer(
            base: DeclarationKind,
            pointer: Pointer
        )

        /// A block declaration.
        indirect case block(
            specifiers: [BlockDeclarationSpecifier],
            base: DeclarationKind,
            arguments: [FuncParameter]
        )

        /// Extracts the root identifier syntax element for this declaration
        /// kind, if any is available.
        var identifierSyntax: IdentifierSyntax {
            switch self {
            case .identifier(_, let ctx):
                return ctx
            case .staticArray(let base, _, _), .pointer(let base, _):
                return base.identifierSyntax
            case .function(let base, _, _), .block(_, let base, _):
                return base.identifierSyntax
            }
        }

        /// Extracts the root identifier string for this declaration kind, if any
        /// is available.
        var identifierString: String {
            switch self {
            case .identifier(let ident, _):
                return ident
            case .staticArray(let base, _, _), .pointer(let base, _):
                return base.identifierString
            case .function(let base, _, _), .block(_, let base, _):
                return base.identifierString
            }
        }

        public var description: String {
            var result = ""

            switch self {
            case .identifier(let name, _):
                result = name

            case .block(let nullability, let base, let arguments):
                result.joinIfPresent(base)
                result += " "
                result += "(^"
                result.joinIfPresent(nullability)
                result += ")"
                result += "("
                result.joinList(arguments, separator: ", ")
                result += ")"
                
            case .function(let base, let parameters, let isVariadic):
                result.joinIfPresent(base)
                result += "("
                result.joinList(parameters, separator: ", ")
                if isVariadic {
                    result.join("...", separator: parameters.isEmpty ? "" : ", ")
                }
                result += ")"

            case .pointer(let base, let pointer):
                result.join(pointer)
                result.joinIfPresent(base, separator: "")

            case .staticArray(let base, let typeQualifiers, let length):
                result.join(base)
                result += "["
                result.joinListIfPresent(typeQualifiers, separator: "")
                result.joinIfPresent(length, separator: result.hasSuffix("[") ? "" : " ")
                result += "]"
            }

            return result
        }
    }

    /// A parameter for a function declaration.
    indirect enum FuncParameter: Hashable, CustomStringConvertible {
        /// A named declaration
        case declaration(Declaration)

        /// A type name
        case typeName(TypeName)

        public var description: String {
            switch self {
            case .declaration(let decl):
                return decl.description
            
            case .typeName(let typeName):
                return typeName.description
            }
        }
    }

    /// Declaration for abstract declarators, e.g. for generic type arguments
    /// of type specifiers.
    enum AbstractDeclarationKind: Hashable, CustomStringConvertible {
        /// A static pointer array.
        indirect case staticArray(
            base: AbstractDeclarationKind?,
            typeQualifiers: [ObjcTypeQualifier]? = nil,
            length: ExpressionSyntax? = nil
        )

        /// A function declaration.
        indirect case function(
            base: AbstractDeclarationKind?,
            parameters: [FuncParameter],
            isVariadic: Bool
        )

        /// A block declaration.
        indirect case block(
            base: AbstractDeclarationKind?,
            specifiers: [BlockDeclarationSpecifier] = [],
            parameters: [FuncParameter]
        )

        public var description: String {
            var result = ""

            switch self {
            case .function(let base, let parameters, let isVariadic):
                result.joinIfPresent(base)
                result += "("
                result += "*"
                result += ")"
                result += "("
                result.joinList(parameters, separator: ", ")
                if isVariadic {
                    result.join("...", separator: parameters.isEmpty ? "" : ", ")
                }
                result += ")"
            
            case .block(let base, let specifiers, let parameters):
                result.joinIfPresent(base)
                result += "("
                result += "^"
                result.joinList(specifiers)
                result += ")"
                result += "("
                result.joinList(parameters, separator: ", ")
                result += ")"

            case .staticArray(let base, let typeQualifiers, let length):
                result.joinIfPresent(base)
                result += "["
                result.joinListIfPresent(typeQualifiers, separator: "")
                result.joinIfPresent(length, separator: result.hasSuffix("[") ? "" : " ")
                result += "]"
            }

            return result
        }
    }

    /// An Objective-C type prefix
    enum TypePrefix: Hashable, CustomStringConvertible {
        case bridge
        case bridgeRetained
        case bridgeTransfer
        case block
        case inline
        case nsInline
        case kindof
        case other(String)

        public var description: String {
            switch self {
            case .bridge:
                return "__bridge"
            case .bridgeRetained:
                return "__bridge_retained"
            case .bridgeTransfer:
                return "__bridge_transfer"
            case .block:
                return "__block"
            case .inline:
                return "inline"
            case .nsInline:
                return "NS_INLINE"
            case .kindof:
                return "__kindof"
            case .other(let value):
                return value
            }
        }
    }

    /// A pointer context
    struct Pointer: Hashable, CustomStringConvertible {
        /// A list of pointers that where present
        var pointers: [PointerEntry]

        public var description: String {
            pointers.map(\.description).joined()
        }

        /// Prefix this list of pointers with another list of pointers.
        func prefix(with pointer: Self) -> Self {
            .init(pointers: pointer.pointers + self.pointers)
        }

        /// Suffix this list of pointers with another list of pointers.
        func suffix(with pointer: Self) -> Self {
            .init(pointers: self.pointers + pointer.pointers)
        }
    }
    /// A pointer entry for a pointer context
    enum PointerEntry: Hashable, CustomStringConvertible {
        case pointer([ObjcTypeQualifier]? = nil, ObjcNullabilitySpecifier? = nil)
        // case blocks([TypeQualifier]? = nil, NullabilitySpecifier? = nil)

        public var description: String {
            var result = "*"

            if let qualifiers = typeQualifiers {
                result.join(qualifiers.map(\.description).joined(separator: " "))
            }
            result.joinIfPresent(nullabilitySpecifier)

            return result
        }

        /// Returns the type qualifiers for this pointer, if any is present.
        public var typeQualifiers: [ObjcTypeQualifier]? {
            switch self {
            case .pointer(let qualifiers, _):
                return qualifiers
            }
        }

        /// Returns the nullability specifier for this pointer, if any is present.
        public var nullabilitySpecifier: ObjcNullabilitySpecifier? {
            switch self {
            case .pointer(_, let nullability):
                return nullability
            }
        }
    }

    /// A specifier for a C/Objective-C declaration
    enum DeclSpecifier: Hashable, CustomStringConvertible {
        case storageSpecifier(StorageSpecifier)
        case typeSpecifier(TypeSpecifier)
        case typeQualifier(ObjcTypeQualifier)
        case functionSpecifier(ObjcFunctionSpecifier)
        case arcSpecifier(ObjcArcBehaviorSpecifier)
        case nullabilitySpecifier(ObjcNullabilitySpecifier)
        case ibOutletQualifier(ObjcIBOutletQualifier)
        case alignmentSpecifier(AlignmentSpecifier)
        case typePrefix(TypePrefix)

        public var description: String {
            switch self {
            case .storageSpecifier(let value):
                return value.description
            case .typeSpecifier(let value):
                return value.description
            case .typeQualifier(let value):
                return value.description
            case .functionSpecifier(let value):
                return value.description
            case .arcSpecifier(let value):
                return value.description
            case .nullabilitySpecifier(let value):
                return value.description
            case .ibOutletQualifier(let value):
                return value.description
            case .alignmentSpecifier(let value):
                return value.description
            case .typePrefix(let value):
                return value.description
            }
        }

        public var storageSpecifier: StorageSpecifier? {
            switch self {
            case .storageSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var typeSpecifier: TypeSpecifier? {
            switch self {
            case .typeSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var typeQualifier: ObjcGrammarModels.ObjcTypeQualifier? {
            switch self {
            case .typeQualifier(let value):
                return value
            default:
                return nil
            }
        }
        public var functionSpecifier: ObjcFunctionSpecifier? {
            switch self {
            case .functionSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var arcSpecifier: ObjcArcBehaviorSpecifier? {
            switch self {
            case .arcSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var nullabilitySpecifier: ObjcNullabilitySpecifier? {
            switch self {
            case .nullabilitySpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var ibOutletQualifier: ObjcIBOutletQualifier? {
            switch self {
            case .ibOutletQualifier(let value):
                return value
            default:
                return nil
            }
        }
        public var alignmentSpecifier: AlignmentSpecifier? {
            switch self {
            case .alignmentSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var typePrefix: TypePrefix? {
            switch self {
            case .typePrefix(let value):
                return value
            default:
                return nil
            }
        }
    }

    /// A C alignment specifier
    enum AlignmentSpecifier: Hashable, CustomStringConvertible {
        case typeName(TypeName)
        case constant(ConstantExpressionSyntax)

        public var description: String {
            switch self {
            case .typeName(let typeName):
                return "_Alignas(\(typeName))"
            case .constant(let exp):
                return "_Alignas(\(exp))"
            }
        }
    }

    /// A C storage specifier
    enum StorageSpecifier: Hashable, CustomStringConvertible {
        case typedef
        case constexpr
        case register
        case `static`
        case extern
        case auto
        case threadLocal
        case other(String)

        public var description: String {
            switch self {
            case .typedef:
                return "typedef"
            case .register:
                return "register"
            case .constexpr:
                return "constexpr"
            case .static:
                return "static"
            case .extern:
                return "extern"
            case .auto:
                return "auto"
            case .threadLocal:
                return "_Thread_local"
            case .other(let value):
                return value
            }
        }

        public var isTypedef: Bool {
            switch self {
            case .typedef:
                return true
            default:
                return false
            }
        }
        public var isRegister: Bool {
            switch self {
            case .register:
                return true
            default:
                return false
            }
        }
        public var isConstexpr: Bool {
            switch self {
            case .constexpr:
                return true
            default:
                return false
            }
        }
        public var isStatic: Bool {
            switch self {
            case .static:
                return true
            default:
                return false
            }
        }
        public var isExtern: Bool {
            switch self {
            case .extern:
                return true
            default:
                return false
            }
        }
        public var isAuto: Bool {
            switch self {
            case .auto:
                return true
            default:
                return false
            }
        }
        public var isThreadLocal: Bool {
            switch self {
            case .threadLocal:
                return true
            default:
                return false
            }
        }
        public var isOther: Bool {
            switch self {
            case .other:
                return true
            default:
                return false
            }
        }
    }

    /// A C type specifier
    enum TypeSpecifier: Hashable, CustomStringConvertible {
        case scalar(ScalarType)
        case typeName(TypeNameSpecifier)
        case structOrUnionSpecifier(StructOrUnionSpecifier)
        case enumSpecifier(EnumSpecifier)
        case typeof(ExpressionSyntax)

        public var description: String {
            switch self {
            case .scalar(let value):
                return value.description

            case .typeName(let value):
                return value.description
            
            case .structOrUnionSpecifier(let value):
                return value.syntax.description
            
            case .enumSpecifier(let value):
                return value.syntax.description

            case .typeof(let exp):
                return "__typeof__(\(exp))"
            }
        }

        /// Returns the scalar type for this type specifier, in case it is one.
        public var scalarType: String? {
            switch self {
            case .scalar(let value):
                return value.description
            default:
                return nil
            }
        }

        /// Returns the associated struct/union specifier object, in case this
        /// type specifier is a struct/union type specifier.
        public var asStructOrUnionSpecifier: StructOrUnionSpecifier? {
            switch self {
            case .structOrUnionSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        /// Returns the associated enum specifier object, in case this type
        /// specifier is an enum type specifier.
        public var asEnumSpecifier: EnumSpecifier? {
            switch self {
            case .enumSpecifier(let value):
                return value
            default:
                return nil
            }
        }

        /// Returns an identifier syntax element associated with this type
        /// specifier, in case it features one.
        public var identifierSyntax: IdentifierSyntax? {
            switch self {
            case .typeName(let value):
                return value.identifier
            case .enumSpecifier(let ctx):
                return ctx.identifier
            case .structOrUnionSpecifier(let ctx):
                return ctx.identifier
            default:
                return nil
            }
        }

        /// Returns `true` if this type specifier is a `.scalar` case.
        public var isScalar: Bool {
            switch self {
            case .scalar:
                return true
            default:
                return false
            }
        }
        
        /// Returns `true` if this type specifier is a `.typeName` case.
        public var isTypeName: Bool {
            switch self {
            case .typeName:
                return true
            default:
                return false
            }
        }

        /// Returns `true` if this type specifier is a `.structOrUnionSpecifier` case.
        public var isStructOrUnionSpecifier: Bool {
            switch self {
            case .structOrUnionSpecifier:
                return true
            default:
                return false
            }
        }

        /// Returns `true` if this type specifier is a `.enumSpecifier` case.
        public var isEnumSpecifier: Bool {
            switch self {
            case .enumSpecifier:
                return true
            default:
                return false
            }
        }

        /// Returns `true` if this type specifier is a `.typeof` case.
        public var isTypeOf: Bool {
            switch self {
            case .typeof:
                return true
            default:
                return false
            }
        }

        /// Returns the value associated with this enum if this value is a
        /// `.typeName()` case.
        public var asTypeNameSpecifier: TypeNameSpecifier? {
            switch self {
            case .typeName(let value):
                return value
            default:
                return nil
            }
        }
    }

    /// A C scalar type
    enum ScalarType: Hashable, CustomStringConvertible {
        case void
        case char
        case short
        case int
        case long
        case float
        case double
        case signed
        case unsigned
        case bool
        case complex
        case m128
        case m128d
        case m128i
        case other(String)

        public var description: String {
            switch self {
                case .void:
                    return "void"
                case .char:
                    return "char"
                case .short:
                    return "short"
                case .int:
                    return "int"
                case .long:
                    return "long"
                case .float:
                    return "float"
                case .double:
                    return "double"
                case .signed:
                    return "signed"
                case .unsigned:
                    return "unsigned"
                case .bool:
                    return "_Bool"
                case .complex:
                    return "_Complex"
                case .m128:
                    return "m128"
                case .m128d:
                    return "m128d"
                case .m128i:
                    return "m128i"
                case .other(let value):
                    return value
            }
        }
    }

    /// A C type name specifier context
    struct TypeNameSpecifier: Hashable, CustomStringConvertible {
        var name: String
        var identifier: IdentifierSyntax
        var genericTypes: GenericTypeList? = nil

        public var description: String {
            var result = name

            result.joinIfPresent(genericTypes, separator: "")
            
            return result
        }
    }

    /// A generic type specifier for Objective-C
    struct GenericTypeList: Hashable, CustomStringConvertible {
        /// A list of concretized Objective-C types for the type arguments.
        var types: [GenericTypeParameter]

        public var description: String {
            "<\(types.map(\.description).joined(separator: ", "))>"
        }
    }

    /// A generic type specifier for Objective-C
    struct GenericTypeParameter: Hashable, CustomStringConvertible {
        var kind: GenericTypeKind?
        var type: TypeName

        public var description: String {
            var result = ""

            result.joinIfPresent(kind)
            result.join(type)

            return result
        }
    }

    /// A specifier for a generic type entry for whether the type is covariant
    /// or contravariant
    enum GenericTypeKind: String, Hashable, CustomStringConvertible {
        case covariant = "__covariant"
        case contravariant = "__contravariant"

        public var description: String {
            rawValue
        }
    }

    /// A C struct or union type specifier
    struct StructOrUnionSpecifier: Hashable {
        var syntax: StructOrUnionSpecifierSyntax
        /// The identifier that represents the type name for this enum.
        var identifier: IdentifierSyntax?

        /// List of struct field declarations. Is `nil` if the original struct
        /// did not feature a field declaration list, i.e. it's an anonymous
        /// struct specifier.
        var fields: [StructFieldDeclaration]?
    }

    /// A struct or union field declarator
    struct StructFieldDeclaration: Hashable {
        /// The computed declaration for this field.
        var declaration: Declaration

        var declarator: DeclaratorSyntax?
        var constantExpression: ConstantExpressionSyntax?
    }

    /// An enum type specifier
    struct EnumSpecifier: Hashable {
        var syntax: EnumSpecifierSyntax
        var typeName: TypeName?
        /// The identifier that represents the type name for this enum.
        var identifier: IdentifierSyntax?

        /// List of enumerator declarations. Is `nil` if the original enum did
        /// not feature an enumerator declaration list, i.e. it's an anonymous
        /// enum specifier.
        var enumerators: [EnumeratorDeclaration]?
    }

    /// An enumerator declaration inside an enum declaration
    struct EnumeratorDeclaration: Hashable {
        var identifier: IdentifierSyntax
        var expression: ExpressionSyntax?
    }

    // TODO: Promote this to a specifier in `ObjcType.blockType`.

    enum BlockDeclarationSpecifier: Hashable, CustomStringConvertible {
        case nullabilitySpecifier(ObjcNullabilitySpecifier)
        case arcBehaviourSpecifier(ObjcArcBehaviorSpecifier)
        case typeQualifier(ObjcTypeQualifier)
        case typePrefix(TypePrefix)

        public var nullabilitySpecifier: ObjcNullabilitySpecifier? {
            switch self {
            case .nullabilitySpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var arcBehaviourSpecifier: ObjcArcBehaviorSpecifier? {
            switch self {
            case .arcBehaviourSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var typeQualifier: ObjcTypeQualifier? {
            switch self {
            case .typeQualifier(let value):
                return value
            default:
                return nil
            }
        }
        public var typePrefix: TypePrefix? {
            switch self {
            case .typePrefix(let value):
                return value
            default:
                return nil
            }
        }

        public var description: String {
            switch self {
            case .arcBehaviourSpecifier(let value):
                return value.description
            case .nullabilitySpecifier(let value):
                return value.description
            case .typePrefix(let value):
                return value.description
            case .typeQualifier(let value):
                return value.description
            }
        }
    }
}

public extension Sequence where Element == DeclarationExtractor.DeclSpecifier {
    func storageSpecifiers() -> [DeclarationExtractor.StorageSpecifier] {
        compactMap { $0.storageSpecifier }
    }
    func typeSpecifiers() -> [DeclarationExtractor.TypeSpecifier] {
        compactMap { $0.typeSpecifier }
    }
    func typeQualifiers() -> [ObjcTypeQualifier] {
        compactMap { $0.typeQualifier }
    }
    func functionSpecifiers() -> [ObjcFunctionSpecifier] {
        compactMap { $0.functionSpecifier }
    }
    func arcSpecifiers() -> [ObjcArcBehaviorSpecifier] {
        compactMap { $0.arcSpecifier }
    }
    func nullabilitySpecifiers() -> [ObjcNullabilitySpecifier] {
        compactMap { $0.nullabilitySpecifier }
    }
    func ibOutletQualifiers() -> [ObjcIBOutletQualifier] {
        compactMap { $0.ibOutletQualifier }
    }
}

public extension Sequence where Element == DeclarationExtractor.BlockDeclarationSpecifier {
    func nullabilitySpecifier() -> [ObjcNullabilitySpecifier] {
        compactMap { $0.nullabilitySpecifier }
    }
    func arcBehaviourSpecifier() -> [ObjcArcBehaviorSpecifier] {
        compactMap { $0.arcBehaviourSpecifier }
    }
    func typeQualifier() -> [ObjcTypeQualifier] {
        compactMap { $0.typeQualifier }
    }
    func typePrefix() -> [DeclarationExtractor.TypePrefix] {
        compactMap { $0.typePrefix }
    }
}

private extension String {
    mutating func join<T: CustomStringConvertible>(_ value: T, separator: String = " ") {
        if !isEmpty && !hasSuffix(separator) {
            self += separator
        }

        self += "\(value)"
    }

    /// Equivalent to `values.map(\.description).joined(separator: separator)`
    mutating func joinList<T: CustomStringConvertible, S: Sequence>(_ values: S, separator: String = " ") where S.Element == T {
        for entry in values {
            join(entry, separator: separator)
        }
    }

    /// Equivalent to `values.map(\.description).joined(separator: separator) ?? ""`
    mutating func joinListIfPresent<T: CustomStringConvertible>(_ values: (any Sequence<T>)?, separator: String = " ") {
        guard let values = values else {
            return
        }
        
        joinList(values, separator: separator)
    }

    mutating func joinIfPresent<T: CustomStringConvertible>(_ value: T?, separator: String = " ") {
        guard let value = value else {
            return
        }

        join(value, separator: separator)
    }
}
