import ObjcParserAntlr
import GrammarModels
import Antlr4

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

    /// Extracts one or more declarations from a given declaration parser context.
    public func extract(from ctx: ObjectiveCParser.DeclarationContext) -> [Declaration] {
        guard let specifiers = ctx.declarationSpecifiers() else {
            return []
        }
        guard let initDeclaratorList = ctx.initDeclaratorList() else {
            if let decl = extract(fromSpecifiers: specifiers) {
                return [decl]
            }

            return []
        }

        var result: [Declaration] = []

        clearContext()
        
        collectSpecifiers(from: ctx)
        collectTypePrefix(from: ctx)

        let isTypeDef = _context.isTypeDef

        for (i, initDeclarator) in initDeclaratorList.initDeclarator().enumerated() {
            if let declaration = declaration(from: initDeclarator, context: _context) {
                result.append(declaration)

                // After first typedef declaration, the remaining declarators
                // use as a declaration specifier the aliased type name that was
                // just defined.
                if isTypeDef && i == 0, let typeNameCtx = declaration.identifierContext {

                    setDeclSpecifiers(
                        [
                            .storageSpecifier(.typedef),
                            .typeSpecifier(
                                .typeName(
                                    .init(
                                        name: typeNameCtx.getText(),
                                        identifier: typeNameCtx
                                    )
                                )
                            )
                        ],
                        rule: specifiers
                    )
                }
            }
        }

        return result
    }

    /// Extracts an uninitialized declaration from a given declaration specifier.
    ///
    /// The declaration specifiers context must contain at least one unqualified
    /// identifier at the end of the specifiers list for it to be considered a
    /// non-initialized declaration.
    public func extract(
        fromSpecifiers ctx: ObjectiveCParser.DeclarationSpecifiersContext
    ) -> Declaration? {

        clearContext()
        
        collectSpecifiers(from: ctx)
        collectTypePrefix(from: ctx)

        return declaration(context: _context)
    }

    /// Extracts a declaration from a given declaration specifier and declarator
    /// parser contexts.
    public func extract(
        fromSpecifiers ctx: ObjectiveCParser.DeclarationSpecifiersContext,
        declarator: ObjectiveCParser.DeclaratorContext
    ) -> Declaration? {

        clearContext()
        
        collectSpecifiers(from: ctx)
        collectTypePrefix(from: ctx)

        return declaration(from: declarator, context: _context)
    }

    /// Extracts a type name from a given type name context.
    public func extract(
        fromTypeName ctx: ObjectiveCParser.TypeNameContext
    ) -> TypeName? {

        clearContext()

        guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
            return nil
        }
        
        collectSpecifiers(from: declarationSpecifiers)
        collectTypePrefix(from: declarationSpecifiers)

        return typeName(from: ctx)
    }

    /// Extracts one or more struct field declarations from a given struct
    /// declaration context.
    public func extract(
        fromStructDeclaration structDecl: ObjectiveCParser.StructDeclarationContext
    ) -> [StructFieldDeclaration]? {

        clearContext()

        collectSpecifiers(from: structDecl)

        return declarations(from: structDecl, context: _context)
    }

    /// Returns `true` if a direct declarator represents a named variable type.
    public func isVariableDeclaration(_ ctx: ObjectiveCParser.DirectDeclaratorContext) -> Bool {
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

        // Drop last type specifier (the name of the declaration itself), in case
        // it is a .typeName case
        let specifiers: [DeclSpecifier]
        if context.specifiers.last?.typeSpecifier?.isTypeName == true {
            specifiers = context.specifiers.dropLast()
        } else {
            specifiers = context.specifiers
        }

        return Declaration(
            typePrefix: context.typePrefixes.first,
            specifiers: Array(specifiers),
            pointer: nil,
            declaration: declarationKind,
            declarationNode: .declSpecifiers(ctx),
            initializer: nil
        )
    }

    private func declaration(
        from ctx: ObjectiveCParser.InitDeclaratorContext?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }
        guard let declarator = ctx.declarator() else {
            return nil
        }
        guard var declaration = self.declaration(from: declarator, context: _context) else {
            return nil
        }

        declaration.initializer = ctx.initializer()

        return declaration
    }

    private func declaration(
        from ctx: ObjectiveCParser.DeclaratorContext?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }
        
        return declaration(
            from: ctx.directDeclarator(),
            pointer: ctx.pointer(),
            context: context
        )
    }

    private func declaration(
        from ctx: ObjectiveCParser.DirectDeclaratorContext?,
        pointer: ObjectiveCParser.PointerContext?,
        context: Context
    ) -> Declaration? {

        guard let ctx = ctx else {
            return nil
        }
        guard let declarationKind = declarationKind(from: ctx) else {
            return nil
        }

        let pointer = self.pointer(from: pointer)

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
        from ctx: ObjectiveCParser.StructDeclarationContext?,
        context: Context
    ) -> [StructFieldDeclaration]? {

        guard let ctx = ctx else {
            return nil
        }

        guard let declList = ctx.structDeclaratorList() else {
            // Fallback to `specifierQualifierList SEMI` parser rule case
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

        for decl in declList.structDeclarator() {
            if let decl = declaration(from: decl, context: context) {
                result.append(decl)
            }
        }

        return result
    }

    private func declaration(
        from ctx: ObjectiveCParser.StructDeclaratorContext?,
        context: Context
    ) -> StructFieldDeclaration? {

        guard let ctx = ctx else {
            return nil
        }

        let declarator = ctx.declarator()
        let constantExpression = ctx.constantExpression()

        var decl: Declaration?

        switch (declarator, constantExpression) {
        case (let declarator?, nil):
            // `declarator` case
            decl = declaration(from: declarator, context: context)
        
        case (let declarator?, _?):
            // `declarator COLON constantExpression` case
            decl = declaration(from: declarator, context: context)

        case (nil, _?):
            // `<none> COLON constantExpression` case
            decl = declaration(context: context)
            
        case (nil, nil):
            // Invalid case
            return nil
        }

        if let decl = decl {
            return StructFieldDeclaration(
                declaration: decl,
                declarator: declarator,
                constantExpression: constantExpression
            )
        }

        return nil
    }

    private func declaration(
        from ctx: ObjectiveCParser.TypeVariableDeclaratorContext?
    ) -> Declaration? {
        guard let ctx = ctx else {
            return nil
        }

        guard let declarationSpecifiers = ctx.declarationSpecifiers() else {
            return nil
        }
        guard let declarator = ctx.declarator() else {
            return nil
        }

        let extractor = makeSubExtractor()

        return extractor.extract(
            fromSpecifiers: declarationSpecifiers,
            declarator: declarator
        )
    }

    private func typeName(
        from ctx: ObjectiveCParser.TypeNameContext?
    ) -> TypeName? {

        guard let ctx = ctx else {
            return nil
        }

        guard let specifiers = declSpecifiers(from: ctx.declarationSpecifiers()) else {
            return nil
        }

        let pointer = self.pointer(from: ctx.abstractDeclarator()?.pointer())
        let declKind = abstractDeclarationKind(
            from: ctx.abstractDeclarator()?.directAbstractDeclarator()
        )

        return TypeName(
            specifiers: specifiers,
            declarationNode: .typeName(ctx),
            pointer: pointer,
            declaration: declKind
        )
    }

    private func typeName(
        from ctx: ObjectiveCParser.DeclarationSpecifiersContext?,
        abstractDeclarator: ObjectiveCParser.AbstractDeclaratorContext?
    ) -> TypeName? {

        guard let ctx = ctx else {
            return nil
        }
        
        guard let specifiers = declSpecifiers(from: ctx) else {
            return nil
        }

        let pointer = self.pointer(from: abstractDeclarator?.pointer())
        let declKind = abstractDeclarationKind(
            from: abstractDeclarator?.directAbstractDeclarator()
        )
        if pointer == nil && declKind == nil {
            return nil
        }

        return TypeName(
            specifiers: specifiers,
            declarationNode: .declSpecifiers(ctx, abstractDeclarator: abstractDeclarator),
            pointer: pointer,
            declaration: declKind
        )
    }

    // MARK: - Specifier/type prefix collecting

    private func collectSpecifiers(from ctx: ObjectiveCParser.DeclarationContext?) {
        collectSpecifiers(from: ctx?.declarationSpecifiers())
    }
    private func collectSpecifiers(from ctx: ObjectiveCParser.DeclarationSpecifiersContext?) {
        guard let ctx = ctx else {
            return
        }
        guard let declSpecifiers = declSpecifiers(from: ctx) else {
            return
        }

        setDeclSpecifiers(declSpecifiers, rule: ctx)
    }
    private func collectSpecifiers(from ctx: ObjectiveCParser.StructDeclarationContext?) {
        guard let ctx = ctx else {
            return
        }
        guard let declSpecifiers = declSpecifiers(from: ctx.specifierQualifierList()) else {
            return
        }

        setDeclSpecifiers(declSpecifiers, rule: ctx)
    }

    private func collectTypePrefix(from ctx: ObjectiveCParser.DeclarationContext?) {
        collectTypePrefix(from: ctx?.declarationSpecifiers())
    }
    private func collectTypePrefix(from ctx: ObjectiveCParser.DeclarationSpecifiersContext?) {
        collectTypePrefix(from: ctx?.typePrefix())
    }
    private func collectTypePrefix(from ctx: ObjectiveCParser.TypePrefixContext?) {
        guard let ctx = ctx else {
            return
        }
        guard let typePrefix = typePrefix(from: ctx) else {
            return
        }

        setTypePrefix(typePrefix, rule: ctx)
    }

    // MARK: - Context management

    private func clearContext() {
        _context = .empty
    }

    private func setDeclSpecifiers(
        _ declSpecifiers: [DeclSpecifier],
        rule: ObjectiveCParser.DeclarationSpecifiersContext
    ) {
        _context.specifiers = declSpecifiers
        _context.specifiersContext = rule
    }
    private func setDeclSpecifiers(
        _ declSpecifiers: [DeclSpecifier],
        rule: ObjectiveCParser.StructDeclarationContext
    ) {
        _context.specifiers = declSpecifiers
        _context.structDeclarationContext = rule
    }
    private func setTypePrefix(
        _ typePrefix: TypePrefix,
        rule: ObjectiveCParser.TypePrefixContext
    ) {
        _context.typePrefixes = [typePrefix]
        _context.typePrefixContext = rule
    }

    // MARK: - Parsing helpers

    private func declarationKind(
        from rule: ObjectiveCParser.DirectDeclaratorContext?
    ) -> DeclarationKind? {

        guard let rule = rule else {
            // Non-initialized declaration
            let specifiers = _context.specifiers.typeSpecifiers()
            guard let lastSpec = specifiers.last else {
                return nil
            }
            guard let lastIdent = lastSpec.identifierContext else {
                return nil
            }

            return .identifier(lastIdent.getText(), lastIdent)
        }

        if let declarator = rule.declarator() {
            guard let base = declarationKind(from: declarator.directDeclarator()) else {
                return nil
            }

            if let pointer = self.pointer(from: declarator.pointer()) {
                return .pointer(base: base, pointer: pointer)
            }

            return base
        }
        if let identifier = rule.identifier() {
            // TODO: Support bit fields
            if rule.DIGITS() != nil {
                return nil
            }

            return .identifier(identifier.getText(), identifier)
        }
        if
            rule.BITXOR() != nil,
            let parameters = rule.blockParameters()
        {
            let base = declarationKind(from: rule.directDeclarator())
            let nullability = nullabilitySpecifier(from: rule.nullabilitySpecifier())

            if let params = blockParameterList(from: parameters) {
                return .block(
                    nullability: nullability,
                    base: base,
                    arguments: params
                )
            }
        }
        if rule.LP() != nil, rule.BITXOR() == nil, let baseDeclarator = rule.directDeclarator() {
            let parameters = parameterList(from: rule.parameterTypeList())

            if let base = declarationKind(from: baseDeclarator) {
                return .function(base: base, parameters: parameters ?? [])
            }
        }
        if rule.LBRACK() != nil {
            let typeQualifiers = typeQualifierList(from: rule.typeQualifierList())
            let primaryExpression = rule.primaryExpression()

            if let base = declarationKind(from: rule.directDeclarator()) {
                return .staticArray(
                    base: base,
                    typeQualifiers: typeQualifiers,
                    length: primaryExpression
                )
            }
        }

        return nil
    }

    private func abstractDeclarationKind(from rule: ObjectiveCParser.DirectAbstractDeclaratorContext?) -> AbstractDeclarationKind? {
        guard let rule = rule else {
            return nil
        }

        if rule.LP() != nil {
            let parameters = parameterList(from: rule.parameterTypeList())
            let base = abstractDeclarationKind(from: rule.directAbstractDeclarator())

            return .function(base: base, parameters: parameters ?? [])
        }
        if rule.LBRACK() != nil {
            let typeQualifiers = typeQualifierList(from: rule.typeQualifierList())
            let primaryExpression = rule.primaryExpression()

            if let base = abstractDeclarationKind(from: rule.directAbstractDeclarator()) {
                return .staticArray(
                    base: base,
                    typeQualifiers: typeQualifiers,
                    length: primaryExpression
                )
            }
        }

        return nil
    }

    private func parameterList(from rule: ObjectiveCParser.ParameterTypeListContext?) -> [FuncParameter]? {
        guard let rule = rule else {
            return nil
        }

        return parameterList(from: rule.parameterList())
    }

    private func parameterList(from rule: ObjectiveCParser.ParameterListContext?) -> [FuncParameter]? {
        guard let rule = rule else {
            return nil
        }

        return rule.parameterDeclaration().compactMap(parameter(from:))
    }

    private func blockParameterList(from rule: ObjectiveCParser.BlockParametersContext?) -> [BlockParameter]? {
        guard let rule = rule else {
            return nil
        }

        var params: [BlockParameter] = []

        for param in rule.typeVariableDeclaratorOrName() {
            if let param = blockParameter(from: param) {
                params.append(param)
            } else {
                return nil
            }
        }

        return params
    }

    private func blockParameter(
        from rule: ObjectiveCParser.TypeVariableDeclaratorOrNameContext?
    ) -> BlockParameter? {

        guard let rule = rule else {
            return nil
        }
        
        if let typeDecl = rule.typeVariableDeclarator() {
            return self.declaration(from: typeDecl).map { .declaration($0) }
        }
        if let typeName = rule.typeName() {
            return self.typeName(from: typeName).map { .typeName($0) }
        }

        return nil
    }

    private func parameter(
        from rule: ObjectiveCParser.ParameterDeclarationContext?
    ) -> FuncParameter? {

        guard let rule = rule else {
            return nil
        }
        guard let declarationSpecifiers = rule.declarationSpecifiers() else {
            return nil
        }

        if let declarator = rule.declarator() {
            let extractor = makeSubExtractor()

            return extractor.extract(
                fromSpecifiers: declarationSpecifiers,
                declarator: declarator
            ).map { .declaration($0) }
        } else {
            let typeName = typeName(
                from: declarationSpecifiers,
                abstractDeclarator: rule.abstractDeclarator()
            )

            return typeName.map { .typeName($0) }
        }
    }

    private func typePrefix(from rule: ObjectiveCParser.TypePrefixContext?) -> TypePrefix? {
        guard let rule = rule else {
            return nil
        }

        if rule.BRIDGE() != nil {
            return .bridge
        }
        if rule.BRIDGE_RETAINED() != nil {
            return .bridgeRetained
        }
        if rule.BRIDGE_TRANSFER() != nil {
            return .bridgeTransfer
        }
        if rule.BLOCK() != nil {
            return .block
        }
        if rule.INLINE() != nil {
            return .inline
        }
        if rule.NS_INLINE() != nil {
            return .nsInline
        }
        if rule.KINDOF() != nil {
            return .kindof
        }

        return .other(rule.getText())
    }

    private func pointer(from rule: ObjectiveCParser.PointerContext?) -> Pointer? {
        guard let rule = rule else {
            return nil
        }

        let pointers = rule.pointerEntry().compactMap(self.pointerEntry(from:))

        return Pointer(pointers: pointers)
    }

    private func pointerEntry(from rule: ObjectiveCParser.PointerEntryContext?) -> PointerEntry? {
        guard let rule = rule else {
            return nil
        }

        if rule.MUL() != nil {
            return .pointer(typeQualifierList(from: rule.typeQualifierList()))
        }
        /*
        if rule.BITXOR() != nil {
            return .blocks(typeQualifierList(from: rule.typeQualifierList()))
        }
        */

        return nil
    }

    private func declSpecifiers(from rule: ObjectiveCParser.DeclarationSpecifiersContext?) -> [DeclSpecifier]? {
        guard let rule = rule else {
            return nil
        }

        var result: [DeclSpecifier] = []

        for spec in rule.declarationSpecifier() {
            if let spec = declSpecifier(from: spec) {
                result.append(spec)
            } else {
                return nil
            }
        }

        return result
    }

    private func declSpecifiers(from rule: ObjectiveCParser.SpecifierQualifierListContext?) -> [DeclSpecifier]? {
        guard let rule = rule else {
            return nil
        }

        var result: [DeclSpecifier] = []

        if let typeSpecifier = typeSpecifier(from: rule.typeSpecifier()) {
            result.append(.typeSpecifier(typeSpecifier))
        }
        if let typeQualifier = typeQualifier(from: rule.typeQualifier()) {
            result.append(.typeQualifier(typeQualifier))
        }
        if let tail = declSpecifiers(from: rule.specifierQualifierList()) {
            result.append(contentsOf: tail)
        }

        return result
    }

    private func declSpecifier(from rule: ObjectiveCParser.DeclarationSpecifierContext?) -> DeclSpecifier? {
        guard let rule = rule else {
            return nil
        }

        if let storageSpecifier = storageSpecifier(from: rule.storageClassSpecifier()) {
            return .storageSpecifier(storageSpecifier)
        }
        if let typeSpecifier = typeSpecifier(from: rule.typeSpecifier()) {
            return .typeSpecifier(typeSpecifier)
        }
        if let typeQualifier = typeQualifier(from: rule.typeQualifier()) {
            return .typeQualifier(typeQualifier)
        }
        if let functionSpecifier = functionSpecifier(from: rule.functionSpecifier()) {
            return .functionSpecifier(functionSpecifier)
        }
        if let arcSpecifier = arcSpecifier(from: rule.arcBehaviourSpecifier()) {
            return .arcSpecifier(arcSpecifier)
        }
        if let nullabilitySpecifier = nullabilitySpecifier(from: rule.nullabilitySpecifier()) {
            return .nullabilitySpecifier(nullabilitySpecifier)
        }
        if let ibOutletQualifier = ibOutletQualifier(from: rule.ibOutletQualifier()) {
            return .ibOutletQualifier(ibOutletQualifier)
        }

        return nil
    }

    private func storageSpecifier(from rule: ObjectiveCParser.StorageClassSpecifierContext?) -> StorageSpecifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.TYPEDEF() != nil {
            return .typedef
        }
        if rule.REGISTER() != nil {
            return .register
        }
        if rule.STATIC() != nil {
            return .static
        }
        if rule.EXTERN() != nil {
            return .extern
        }
        if rule.THREAD_LOCAL_() != nil {
            return .threadLocal
        }
        if rule.AUTO() != nil {
            return .auto
        }

        return nil
    }

    private func typeSpecifier(from rule: ObjectiveCParser.TypeSpecifierContext?) -> TypeSpecifier? {
        guard let rule = rule else {
            return nil
        }

        if let scalarType = scalarType(from: rule.scalarTypeSpecifier()) {
            return .scalar(
                scalarType
            )
        }
        if let identifier = rule.typedefName()?.identifier() {
            return .typeName(
                .init(name: identifier.getText(), identifier: identifier)
            )
        }
        if
            let genericTypeSpecifier = rule.genericTypeSpecifier(),
            let identifier = genericTypeSpecifier.identifier(),
            let genericTypeSpecifier = genericTypeList(
                from: genericTypeSpecifier.genericTypeList()
            )
        {
            return .typeName(
                .init(
                    name: identifier.getText(),
                    identifier: identifier,
                    genericTypes: genericTypeSpecifier
                )
            )
        }
        if let structOrUnionSpecifier = structOrUnionSpecifier(from: rule.structOrUnionSpecifier()) {
            return .structOrUnionSpecifier(structOrUnionSpecifier)
        }
        if let enumSpecifier = enumSpecifier(from: rule.enumSpecifier()) {
            return .enumSpecifier(enumSpecifier)
        }

        return nil
    }

    private func structOrUnionSpecifier(from rule: ObjectiveCParser.StructOrUnionSpecifierContext?) -> StructOrUnionSpecifier? {
        guard let rule = rule else {
            return nil
        }

        let fields: [StructFieldDeclaration]?
        if rule.LBRACE() != nil {
            if let declList = self.structFieldDeclarations(from: rule.structDeclarationList()) {
                fields = declList
            } else {
                // Malformed struct body
                return nil
            }
        } else {
            fields = nil
        }

        return StructOrUnionSpecifier(
            rule: rule,
            identifier: rule.identifier(),
            fields: fields
        )
    }

    private func structFieldDeclarations(
        from rule: ObjectiveCParser.StructDeclarationListContext?
    ) -> [StructFieldDeclaration]? {
        
        guard let rule = rule else {
            return nil
        }

        return rule
            .structDeclaration()
            .compactMap(self.structFieldDeclarations(from:))
            .flatMap({ $0 })
    }

    private func structFieldDeclarations(
        from rule: ObjectiveCParser.StructDeclarationContext?
    ) -> [StructFieldDeclaration]? {

        guard let rule = rule else {
            return nil
        }

        let extractor = makeSubExtractor()
        let result = extractor.extract(fromStructDeclaration: rule)

        return result
    }

    private func enumSpecifier(from rule: ObjectiveCParser.EnumSpecifierContext?) -> EnumSpecifier? {
        guard let rule = rule else {
            return nil
        }

        let fields: [EnumeratorDeclaration]?
        if rule.LBRACE() != nil {
            if let declList = self.enumeratorDeclarations(from: rule.enumeratorList()) {
                fields = declList
            } else {
                // Malformed enum body
                return nil
            }
        } else {
            fields = nil
        }

        return EnumSpecifier(
            rule: rule,
            typeName: typeName(from: rule.typeName()),
            identifier: rule.identifier().first,
            enumerators: fields
        )
    }

    private func enumeratorDeclarations(from rule: ObjectiveCParser.EnumeratorListContext?) -> [EnumeratorDeclaration]? {
        guard let rule = rule else {
            return nil
        }

        return rule
            .enumerator()
            .compactMap(self.enumeratorDeclaration(from:))
    }

    private func enumeratorDeclaration(from rule: ObjectiveCParser.EnumeratorContext?) -> EnumeratorDeclaration? {
        guard let rule = rule else {
            return nil
        }
        guard let identifier = rule.enumeratorIdentifier() else {
            return nil
        }

        return EnumeratorDeclaration(
            identifier: identifier,
            expression: rule.expression()
        )
    }

    private func genericTypeList(from rule: ObjectiveCParser.GenericTypeListContext?) -> GenericTypeList? {
        guard let rule = rule else {
            return nil
        }

        return GenericTypeList(
            types: rule
                .genericTypeParameter()
                .compactMap(genericTypeParameter(from:))
        )
    }

    private func genericTypeParameter(from rule: ObjectiveCParser.GenericTypeParameterContext?) -> GenericTypeParameter? {
        guard let rule = rule else {
            return nil
        }

        guard let typeName = rule.typeName() else {
            return nil
        }

        let extractor = makeSubExtractor()
        guard let type = extractor.extract(fromTypeName: typeName) else {
            return nil
        }

        var kind: GenericTypeKind?

        if rule.COVARIANT() != nil {
            kind = .covariant
        } else if rule.CONTRAVARIANT() != nil {
            kind = .contravariant
        }

        return GenericTypeParameter(
            kind: kind,
            type: type
        )
    }

    private func scalarType(from rule: ObjectiveCParser.ScalarTypeSpecifierContext?) -> ScalarType? {
        guard let rule = rule else {
            return nil
        }

        if rule.VOID() != nil {
            return .void
        }
        if rule.CHAR() != nil {
            return .char
        }
        if rule.SHORT() != nil {
            return .short
        }
        if rule.INT() != nil {
            return .int
        }
        if rule.LONG() != nil {
            return .long
        }
        if rule.FLOAT() != nil {
            return .float
        }
        if rule.DOUBLE() != nil {
            return .double
        }
        if rule.SIGNED() != nil {
            return .signed
        }
        if rule.UNSIGNED() != nil {
            return .unsigned
        }
        if rule.BOOL_() != nil {
            return .bool
        }
        if rule.COMPLEX() != nil {
            return .complex
        }
        if rule.M128() != nil {
            return .m128
        }
        if rule.M128D() != nil {
            return .m128d
        }
        if rule.M128I() != nil {
            return .m128i
        }

        return .other(rule.getText())
    }

    private func typeQualifierList(from rule: ObjectiveCParser.TypeQualifierListContext?) -> [TypeQualifier]? {
        guard let rule = rule else {
            return nil
        }

        return rule.typeQualifier().compactMap(self.typeQualifier(from:))
    }

    private func typeQualifier(from rule: ObjectiveCParser.TypeQualifierContext?) -> TypeQualifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.CONST() != nil {
            return .const
        }
        if rule.VOLATILE() != nil {
            return .volatile
        }
        if rule.RESTRICT() != nil {
            return .restrict
        }
        if rule.ATOMIC_() != nil {
            return .atomic
        }
        if let protocolQualifier = protocolQualifier(from: rule.protocolQualifier()) {
            return .protocolQualifier(
                protocolQualifier
            )
        }

        return .other(rule.getText())
    }

    private func protocolQualifier(from rule: ObjectiveCParser.ProtocolQualifierContext?) -> ProtocolQualifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.IN() != nil {
            return .in
        }
        if rule.OUT() != nil {
            return .out
        }
        if rule.INOUT() != nil {
            return .inout
        }
        if rule.BYCOPY() != nil {
            return .bycopy
        }
        if rule.BYREF() != nil {
            return .byref
        }
        if rule.ONEWAY() != nil {
            return .oneway
        }

        return nil
    }

    private func functionSpecifier(from rule: ObjectiveCParser.FunctionSpecifierContext?) -> FunctionSpecifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.INLINE() != nil || rule.INLINE__() != nil {
            return .inline
        }
        if rule.NORETURN_() != nil {
            return .noReturn
        }
        if rule.STDCALL() != nil {
            return .stdCall
        }

        return .other(rule.getText())
    }

    private func arcSpecifier(from rule: ObjectiveCParser.ArcBehaviourSpecifierContext?) -> ArcSpecifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.WEAK_QUALIFIER() != nil {
            return .weak
        }
        if rule.STRONG_QUALIFIER() != nil {
            return .strong
        }
        if rule.AUTORELEASING_QUALIFIER() != nil {
            return .autoreleasing
        }
        if rule.UNSAFE_UNRETAINED_QUALIFIER() != nil {
            return .unsafeUnretained
        }

        return nil
    }

    private func nullabilitySpecifier(from rule: ObjectiveCParser.NullabilitySpecifierContext?) -> NullabilitySpecifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.NULL_UNSPECIFIED() != nil {
            return .nullUnspecified
        }
        if rule.NULLABLE() != nil {
            return .nullable
        }
        if rule.NONNULL() != nil {
            return .nonnull
        }
        if rule.NULL_RESETTABLE() != nil {
            return .nullResettable
        }

        return nil
    }

    private func ibOutletQualifier(from rule: ObjectiveCParser.IbOutletQualifierContext?) -> IBOutletQualifier? {
        guard let rule = rule else {
            return nil
        }

        if rule.IB_OUTLET_COLLECTION() != nil, let identifier = rule.identifier()?.getText() {
            return .ibCollection(identifier)
        }
        if rule.IB_OUTLET() != nil {
            return .ibOutlet
        }

        return nil
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

        /// The parser rule context where the current declaration specifiers where
        /// derived from.
        /// 
        /// Is mutually exclusive with `structDeclarationContext`, and defining
        /// both at the same time is an undefined state.
        var specifiersContext: ObjectiveCParser.DeclarationSpecifiersContext?
        
        /// The parser rule context where the current type prefix was derived
        /// from.
        var typePrefixContext: ObjectiveCParser.TypePrefixContext?

        /// The parser rule context where the current declaration specifiers where
        /// derived from.
        /// 
        /// Is mutually exclusive with `specifiersContext`, and defining both at
        /// the same time is an undefined state.
        var structDeclarationContext: ObjectiveCParser.StructDeclarationContext?

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
    struct Declaration {
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

        /// An initializer that was collected alongside this declaration.
        var initializer: ObjectiveCParser.InitializerContext?

        /// Returns `true` if this declaration is of a variable declaration kind.
        var isVariableDeclaration: Bool {
            switch declaration {
            case .identifier:
                return true
            default:
                return false
            }
        }

        /// Extracts the root identifier parser rule context for this declaration,
        /// if any is available.
        var identifierContext: ObjectiveCParser.IdentifierContext? {
            declaration.identifierContext
        }

        /// Extracts the root identifier string for this declaration, if any is
        /// available.
        var identifierString: String? {
            declaration.identifierString
        }
    }

    /// The source for a `Declaration` value
    enum DeclarationDeclNode {
        /// A direct declarator context where the type was defined.
        case directDeclarator(ObjectiveCParser.DirectDeclaratorContext)

        /// A list of declaration specifiers that contained the definition.
        case declSpecifiers(ObjectiveCParser.DeclarationSpecifiersContext)

        /// A struct or union field declaration.
        case structDeclaration(ObjectiveCParser.StructDeclarationContext)

        /// Returns a common base rule context for this declaration node which is
        /// guaranteed to exist in the underlying AST.
        var rule: ParserRuleContext {
            switch self {
            case
                .directDeclarator(let ctx as ParserRuleContext),
                .declSpecifiers(let ctx as ParserRuleContext),
                .structDeclaration(let ctx as ParserRuleContext):

                return ctx
            }
        }

        /// Returns the associated value if this enum is a `.directDeclarator()`
        /// case.
        var asDirectDeclarator: ObjectiveCParser.DirectDeclaratorContext? {
            switch self {
            case .directDeclarator(let rule):
                return rule
            default:
                return nil
            }
        }

        /// Returns the associated value if this enum is a `.declSpecifiers()`
        /// case.
        var asDeclSpecifiers: ObjectiveCParser.DeclarationSpecifiersContext? {
            switch self {
            case .declSpecifiers(let rule):
                return rule
            default:
                return nil
            }
        }

        /// Returns the associated value if this enum is a `.structDeclaration()`
        /// case.
        var asStructDeclaration: ObjectiveCParser.StructDeclarationContext? {
            switch self {
            case .structDeclaration(let rule):
                return rule
            default:
                return nil
            }
        }
    }

    /// An abstract type name declaration
    struct TypeName {
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
    }

    /// The source for a TypeName declaration
    enum TypeNameDeclNode {
        /// Type name was derived from a `typeName` parser rule
        case typeName(ObjectiveCParser.TypeNameContext)
        
        /// Type name was derived from a combination of `declarationSpecifiers`
        /// and optionally a `abstractDeclarator`.
        case declSpecifiers(
            ObjectiveCParser.DeclarationSpecifiersContext,
            abstractDeclarator: ObjectiveCParser.AbstractDeclaratorContext?
        )

        /// Returns a common base rule context for this declaration node which is
        /// guaranteed to exist in the underlying AST.
        var rule: ParserRuleContext {
            switch self {
            case
                .typeName(let ctx as ParserRuleContext),
                .declSpecifiers(let ctx as ParserRuleContext, _):

                return ctx
            }
        }
    }

    /// The kind for a detected declaration
    enum DeclarationKind {
        /// An identifier kind, e.g. for a variable.
        case identifier(String, ObjectiveCParser.IdentifierContext)

        /// A static pointer array.
        indirect case staticArray(
            base: DeclarationKind,
            typeQualifiers: [TypeQualifier]? = nil,
            length: ObjectiveCParser.PrimaryExpressionContext? = nil
        )
        
        /// A function declaration.
        indirect case function(
            base: DeclarationKind?,
            parameters: [FuncParameter]
        )

        /// A declaration for a pointer that points to a declaration.
        indirect case pointer(
            base: DeclarationKind,
            pointer: Pointer
        )

        /// A block declaration.
        indirect case block(
            nullability: NullabilitySpecifier? = nil,
            base: DeclarationKind? = nil,
            arguments: [BlockParameter]
        )

        /// A type definition declaration.
        indirect case typedef(
            String,
            ObjectiveCParser.IdentifierContext,
            baseType: Declaration
        )

        /// Extracts the root identifier parser rule context for this declaration
        /// kind, if any is available.
        var identifierContext: ObjectiveCParser.IdentifierContext? {
            switch self {
            case .identifier(_, let ctx):
                return ctx
            case .staticArray(let base, _, _), .pointer(let base, _):
                return base.identifierContext
            case .function(let base, _), .block(_, let base, _):
                return base?.identifierContext
            case .typedef(_, let identifier, _):
                return identifier
            }
        }

        /// Extracts the root identifier string for this declaration kind, if any
        /// is available.
        var identifierString: String? {
            switch self {
            case .identifier(let ident, _):
                return ident
            case .staticArray(let base, _, _), .pointer(let base, _):
                return base.identifierString
            case .function(let base, _), .block(_, let base, _):
                return base?.identifierString
            case .typedef(_, let identifier, _):
                return identifier.getText()
            }
        }
    }

    // TODO: Use the same enum for both function and block arguments.

    /// A parameter for a function declaration.
    indirect enum FuncParameter {
        /// A named declaration
        case declaration(Declaration)

        /// A type name
        case typeName(TypeName)
    }

    /// A parameter for a block declaration.
    indirect enum BlockParameter {
        /// A named declaration
        case declaration(Declaration)

        /// A type name
        case typeName(TypeName)
    }

    /// Declaration for abstract declarators, e.g. for generic type arguments
    /// of type specifiers.
    enum AbstractDeclarationKind {
        /// A static pointer array.
        indirect case staticArray(
            base: AbstractDeclarationKind?,
            typeQualifiers: [TypeQualifier]? = nil,
            length: ObjectiveCParser.PrimaryExpressionContext? = nil
        )

        /// A function declaration.
        indirect case function(
            base: AbstractDeclarationKind?,
            parameters: [FuncParameter]
        )
    }

    /// An Objective-C type prefix
    enum TypePrefix: CustomStringConvertible {
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
    struct Pointer {
        /// A list of pointers that where present
        var pointers: [PointerEntry]

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
    enum PointerEntry {
        case pointer([TypeQualifier]? = nil)
        // case blocks([TypeQualifier]? = nil)
    }

    /// A specifier for a C/Objective-C declaration
    enum DeclSpecifier: CustomStringConvertible {
        case storageSpecifier(StorageSpecifier)
        case typeSpecifier(TypeSpecifier)
        case typeQualifier(TypeQualifier)
        case functionSpecifier(FunctionSpecifier)
        case arcSpecifier(ArcSpecifier)
        case nullabilitySpecifier(NullabilitySpecifier)
        case ibOutletQualifier(IBOutletQualifier)

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
        public var typeQualifier: TypeQualifier? {
            switch self {
            case .typeQualifier(let value):
                return value
            default:
                return nil
            }
        }
        public var functionSpecifier: FunctionSpecifier? {
            switch self {
            case .functionSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var arcSpecifier: ArcSpecifier? {
            switch self {
            case .arcSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var nullabilitySpecifier: NullabilitySpecifier? {
            switch self {
            case .nullabilitySpecifier(let value):
                return value
            default:
                return nil
            }
        }
        public var ibOutletQualifier: IBOutletQualifier? {
            switch self {
            case .ibOutletQualifier(let value):
                return value
            default:
                return nil
            }
        }
    }

    /// A C storage specifier
    enum StorageSpecifier: Hashable, CustomStringConvertible {
        case typedef
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
    enum TypeSpecifier: CustomStringConvertible {
        case scalar(ScalarType)
        case typeName(TypeNameSpecifier)
        case structOrUnionSpecifier(StructOrUnionSpecifier)
        case enumSpecifier(EnumSpecifier)

        public var description: String {
            switch self {
            case .scalar(let value):
                return value.description

            case .typeName(let value):
                return value.description
            
            case .structOrUnionSpecifier(let value):
                return value.rule.getText()
            
            case .enumSpecifier(let value):
                return value.rule.getText()
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

        /// Returns the associated struct/union specifier parser context, in case
        /// this type specifier is a struct/union type specifier.
        public var asStructOrUnionSpecifier: StructOrUnionSpecifier? {
            switch self {
            case .structOrUnionSpecifier(let value):
                return value
            default:
                return nil
            }
        }
        /// Returns the associated enum specifier parser context, in case this
        /// type specifier is an enum type specifier.
        public var asEnumSpecifier: EnumSpecifier? {
            switch self {
            case .enumSpecifier(let value):
                return value
            default:
                return nil
            }
        }

        /// Returns an identifier parser rule context associated with this type
        /// specifier, in case it features one.
        public var identifierContext: ObjectiveCParser.IdentifierContext? {
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

    /// A C type name specifier context
    struct TypeNameSpecifier: CustomStringConvertible {
        var name: String
        var identifier: ObjectiveCParser.IdentifierContext
        var genericTypes: GenericTypeList? = nil

        public var description: String {
            var result = name

            if let genericTypes = genericTypes {
                result += "\(genericTypes)"
            }
            
            return result
        }
    }

    /// A C struct or union type specifier
    struct StructOrUnionSpecifier {
        var rule: ObjectiveCParser.StructOrUnionSpecifierContext
        /// The identifier that represents the type name for this enum.
        var identifier: ObjectiveCParser.IdentifierContext?

        /// List of struct field declarations. Is `nil` if the original struct
        /// did not feature a field declaration list, i.e. it's an anonymous
        /// struct specifier.
        var fields: [StructFieldDeclaration]?
    }

    /// A struct or union field declarator
    struct StructFieldDeclaration {
        /// The computed declaration for this field.
        var declaration: Declaration

        var declarator: ObjectiveCParser.DeclaratorContext?
        var constantExpression: ObjectiveCParser.ConstantExpressionContext?
    }

    /// An enum type specifier
    struct EnumSpecifier {
        var rule: ObjectiveCParser.EnumSpecifierContext
        var typeName: TypeName?
        /// The identifier that represents the type name for this enum.
        var identifier: ObjectiveCParser.IdentifierContext?

        /// List of enumerator declarations. Is `nil` if the original enum did
        /// not feature an enumerator declaration list, i.e. it's an anonymous
        /// enum specifier.
        var enumerators: [EnumeratorDeclaration]?
    }

    /// An enumerator declaration inside an enum declaration
    struct EnumeratorDeclaration {
        var identifier: ObjectiveCParser.EnumeratorIdentifierContext
        var expression: ObjectiveCParser.ExpressionContext?
    }

    /// A C type qualifier
    enum TypeQualifier: Hashable, CustomStringConvertible {
        case const
        case volatile
        case restrict
        case atomic
        case protocolQualifier(ProtocolQualifier)
        case other(String)

        public var description: String {
            switch self {
            case .const:
                return "const"
            case .volatile:
                return "volatile"
            case .restrict:
                return "restrict"
            case .atomic:
                return "_Atomic"
            case .protocolQualifier(let value):
                return value.description
            case .other(let value):
                return value
            }
        }

        var isConst: Bool {
            switch self {
            case .const:
                return true
            default:
                return false
            }
        }
        var isVolatile: Bool {
            switch self {
            case .volatile:
                return true
            default:
                return false
            }
        }
        var isRestrict: Bool {
            switch self {
            case .restrict:
                return true
            default:
                return false
            }
        }
        var isAtomic: Bool {
            switch self {
            case .atomic:
                return true
            default:
                return false
            }
        }
        var isProtocolQualifier: Bool {
            switch self {
            case .protocolQualifier:
                return true
            default:
                return false
            }
        }
        var isOther: Bool {
            switch self {
            case .other:
                return true
            default:
                return false
            }
        }
    }

    /// An Objective-C protocol type qualifier
    enum ProtocolQualifier: Hashable, CustomStringConvertible {
        case `in`
        case out
        case `inout`
        case bycopy
        case byref
        case oneway
        case other(String)

        public var description: String {
            switch self {
                case .`in`:
                    return "in"
                case .out:
                    return "out"
                case .`inout`:
                    return "inout"
                case .bycopy:
                    return "bycopy"
                case .byref:
                    return "byref"
                case .oneway:
                    return "oneway"
                case .other(let value):
                    return value
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

    /// A C function specifier
    enum FunctionSpecifier: Hashable, CustomStringConvertible {
        case inline
        case noReturn
        case stdCall
        case other(String)

        public var description: String {
            switch self {
                case .inline:
                    return "inline"
                case .noReturn:
                    return "_Noreturn"
                case .stdCall:
                    return "__stdcall"
                case .other(let value):
                    return value
            }
        }
    }

    /// An Objective-C ARC specifier
    enum ArcSpecifier: String, Hashable, CustomStringConvertible {
        case `weak` = "__weak"
        case strong = "__string"
        case autoreleasing = "__autoreleasing"
        case unsafeUnretained = "__unsafe_unretained"

        public var description: String {
            rawValue
        }
    }

    /// An Objective-C nullability specifier
    enum NullabilitySpecifier: String, Hashable, CustomStringConvertible {
        case nullUnspecified = "null_unspecified"
        case nullResettable = "null_resettable"
        case nullable
        case nonnull = "nonnull"

        public var description: String {
            rawValue
        }
    }

    /// An Objective-C Interface Builder outlet qualifier
    enum IBOutletQualifier: Hashable, CustomStringConvertible {
        case ibCollection(String)
        case ibOutlet

        public var description: String {
            switch self {
            case .ibCollection(let value):
                return "IBOutletCollection(\(value))"
            case .ibOutlet:
                return "IBOutlet"
            }
        }
    }

    /// A generic type specifier for Objective-C
    struct GenericTypeList {
        /// A list of concretized Objective-C types for the type arguments.
        var types: [GenericTypeParameter]
    }

    /// A generic type specifier for Objective-C
    struct GenericTypeParameter {
        var kind: GenericTypeKind?
        var type: TypeName
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
}

public extension Sequence where Element == DeclarationExtractor.DeclSpecifier {
    func storageSpecifiers() -> [DeclarationExtractor.StorageSpecifier] {
        compactMap { $0.storageSpecifier }
    }
    func typeSpecifiers() -> [DeclarationExtractor.TypeSpecifier] {
        compactMap { $0.typeSpecifier }
    }
    func typeQualifiers() -> [DeclarationExtractor.TypeQualifier] {
        compactMap { $0.typeQualifier }
    }
    func functionSpecifiers() -> [DeclarationExtractor.FunctionSpecifier] {
        compactMap { $0.functionSpecifier }
    }
    func arcSpecifiers() -> [DeclarationExtractor.ArcSpecifier] {
        compactMap { $0.arcSpecifier }
    }
    func nullabilitySpecifiers() -> [DeclarationExtractor.NullabilitySpecifier] {
        compactMap { $0.nullabilitySpecifier }
    }
    func ibOutletQualifiers() -> [DeclarationExtractor.IBOutletQualifier] {
        compactMap { $0.ibOutletQualifier }
    }
}

private extension RuleContext {
    /// Returns `true` if this rule context is a descendant of another rule context.
    /// Comparison of nodes is made by reference.
    ///
    /// Returns `true` if `other === self`.
    func isDescendantOf(_ other: RuleContext) -> Bool {
        var current: RuleContext? = self

        repeat {
            if other === current {
                return true
            }

            current = current?.parent
        } while current != nil

        return false
    }
}
