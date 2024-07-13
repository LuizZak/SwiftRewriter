import Antlr4
import ObjcParserAntlr
import ObjcGrammarModels
import Utils

/// Class that can be used to parse a declaration from a parsed ANTLR context.
class AntlrDeclarationParser {
    let source: Source

    init(source: Source) {
        self.source = source
    }

    func typeName(_ ctx: ObjectiveCParser.TypeNameContext?) -> TypeNameSyntax? {
        guard let ctx else { return nil }
        guard let declarationSpecifiers = declarationSpecifiers(ctx.declarationSpecifiers()) else { return nil }

        if ctx.abstractDeclarator() != nil {
            guard let abstractDeclarator = abstractDeclarator(ctx.abstractDeclarator()) else { return nil }

            return .init(declarationSpecifiers: declarationSpecifiers, abstractDeclarator: abstractDeclarator)
        }

        return .init(declarationSpecifiers: declarationSpecifiers)
    }
    
    func typeVariable(_ ctx: ObjectiveCParser.TypeVariableDeclaratorContext?) -> TypeVariableDeclaratorSyntax? {
        guard let ctx else { return nil }
        guard let declarationSpecifiers = declarationSpecifiers(ctx.declarationSpecifiers()) else { return nil }
        guard let declarator = declarator(ctx.declarator()) else { return nil }

        return .init(declarationSpecifiers: declarationSpecifiers, declarator: declarator)
    }

    func declaration(_ ctx: ObjectiveCParser.DeclarationContext?) -> DeclarationSyntax? {
        guard let ctx else { return nil }
        guard let declarationSpecifiers = declarationSpecifiers(ctx.declarationSpecifiers()) else { return nil }

        if ctx.initDeclaratorList() != nil {
            guard let initDeclaratorList = initDeclaratorList(ctx.initDeclaratorList()) else {
                return nil
            }

            return .init(declarationSpecifiers: declarationSpecifiers, initDeclaratorList: initDeclaratorList)
        }

        return .init(declarationSpecifiers: declarationSpecifiers)
    }

    func fieldDeclaration(_ ctx: ObjectiveCParser.FieldDeclarationContext?) -> FieldDeclarationSyntax? {
        guard let ctx else { return nil }
        guard let declarationSpecifiers = declarationSpecifiers(ctx.declarationSpecifiers()) else {
            return nil
        }
        guard let fieldDeclaratorList = fieldDeclarators(ctx.fieldDeclaratorList()) else {
            return nil
        }

        return .init(
            declarationSpecifiers: declarationSpecifiers,
            fieldDeclaratorList: fieldDeclaratorList
        )
    }

    func initDeclaratorList(_ ctx: ObjectiveCParser.InitDeclaratorListContext?) -> InitDeclaratorListSyntax? {
        guard let ctx else { return nil }

        let result = ctx.initDeclarator().compactMap(self.initDeclarator(_:))

        return result.isEmpty ? nil : .init(initDeclarators: result)
    }

    func initDeclarator(_ ctx: ObjectiveCParser.InitDeclaratorContext?) -> InitDeclaratorSyntax? {
        guard let ctx else { return nil }
        guard let declarator = declarator(ctx.declarator()) else { return nil }

        return .init(
            declarator: declarator,
            initializer: initializer(ctx.initializer())
        )
    }

    func initializer(_ ctx: ObjectiveCParser.InitializerContext?) -> InitializerSyntax? {
        guard let ctx else { return nil }
        guard let expression = expression(ctx.expression()) else { return nil }

        return .expression(expression)
    }

    func declarator(_ ctx: ObjectiveCParser.DeclaratorContext?) -> DeclaratorSyntax? {
        guard let ctx else { return nil }
        guard let directDeclarator = directDeclarator(ctx.directDeclarator()) else { return nil }

        let pointer = pointer(ctx.pointer())

        return .init(pointer: pointer, directDeclarator: directDeclarator)
    }

    func directDeclarator(_ ctx: ObjectiveCParser.DirectDeclaratorContext?) -> DirectDeclaratorSyntax? {
        guard let ctx else { return nil }

        if let identifier = identifier(ctx.identifier()) {
            // TODO: Support this Visual C extension
            guard ctx.vcSpecificModifier() == nil else {
                return nil
            }
            // TODO: Support bit fields
            guard ctx.DIGITS() == nil else {
                return nil
            }

            return .identifier(identifier)
        } else if let declarator = declarator(ctx.declarator()) {
            // TODO: Support this Visual C extension
            guard ctx.vcSpecificModifier() == nil else {
                return nil
            }

            return .declarator(declarator)
        }

        // Remaining direct declarators require a base declarator.
        guard let directDeclarator = directDeclarator(ctx.directDeclarator()) else {
            return nil
        }

        let isArray = ctx.LBRACK() != nil
        let isFunction = ctx.LP() != nil && ctx.BITXOR() == nil
        let isBlock = ctx.LP() != nil && ctx.BITXOR() != nil

        if isArray {
            let typeQualifiers = typeQualifierList(ctx.typeQualifierList())
            let length = expression(ctx.expression())

            return .arrayDeclarator(
                .init(
                    directDeclarator: directDeclarator,
                    typeQualifiers: typeQualifiers,
                    length: length
                )
            )
        }
        if isFunction {
            if ctx.parameterTypeList() != nil {
                guard let parameterTypeList = parameterTypeList(ctx.parameterTypeList()) else {
                    return nil
                }

                return .functionDeclarator(
                    .init(directDeclarator: directDeclarator, parameterTypeList: parameterTypeList)
                )
            } else {
                return .functionDeclarator(
                    .init(directDeclarator: directDeclarator)
                )
            }
        }
        if isBlock {
            let blockDeclarationSpecifiers = ctx.blockDeclarationSpecifier().compactMap(blockDeclarationSpecifier(_:))

            guard let blockParameterList = blockParameterList(ctx.blockParameters()) else {
                return nil
            }

            return .blockDeclarator(
                .init(
                    blockDeclarationSpecifiers: blockDeclarationSpecifiers,
                    directDeclarator: directDeclarator,
                    parameterList: blockParameterList
                )
            )
        }

        return nil
    }

    func abstractDeclarator(_ ctx: ObjectiveCParser.AbstractDeclaratorContext?) -> AbstractDeclaratorSyntax? {
        guard let ctx else { return nil }

        let directAbstractDeclarator = directAbstractDeclarator(ctx.directAbstractDeclarator())
        let pointer = pointer(ctx.pointer())

        // Verify valid combination of parser rules
        switch (ctx.pointer(), ctx.directAbstractDeclarator()) {
        case (nil, _?):
            guard let directAbstractDeclarator else { return nil }

            return .directAbstractDeclarator(nil, directAbstractDeclarator)

        case (_?, _?):
            guard let pointer else { return nil }
            guard let directAbstractDeclarator else { return nil }

            return .directAbstractDeclarator(pointer, directAbstractDeclarator)

        case (_?, nil):
            guard let pointer else { return nil }

            return .pointer(pointer)

        default:
            return nil
        }
    }

    func directAbstractDeclarator(_ ctx: ObjectiveCParser.DirectAbstractDeclaratorContext?) -> DirectAbstractDeclaratorSyntax? {
        guard let ctx else { return nil }

        if let abstractDeclarator = abstractDeclarator(ctx.abstractDeclarator()) {
            return .abstractDeclarator(abstractDeclarator)
        }

        // Remaining direct declarators require a base declarator.
        let directAbstractDeclarator = directAbstractDeclarator(ctx.directAbstractDeclarator())

        let isArray = ctx.LBRACK() != nil
        let isFunction = ctx.LP() != nil && ctx.BITXOR() == nil
        let isBlock = ctx.LP() != nil && ctx.BITXOR() != nil

        if isArray {
            let typeQualifiers = typeQualifierList(ctx.typeQualifierList())
            let length = expression(ctx.expression())

            return .arrayDeclarator(
                .init(
                    directAbstractDeclarator: directAbstractDeclarator,
                    typeQualifiers: typeQualifiers,
                    length: length
                )
            )
        }
        if isFunction {
            if ctx.parameterTypeList() != nil {
                guard let parameterTypeList = parameterTypeList(ctx.parameterTypeList()) else {
                    return nil
                }

                return .functionDeclarator(
                    .init(directAbstractDeclarator: directAbstractDeclarator, parameterTypeList: parameterTypeList)
                )
            } else {
                return .functionDeclarator(
                    .init(directAbstractDeclarator: directAbstractDeclarator)
                )
            }
        }
        if isBlock {
            let blockDeclarationSpecifiers = ctx.blockDeclarationSpecifier().compactMap(blockDeclarationSpecifier(_:))

            guard let parameterList = blockParameterList(ctx.blockParameters()) else {
                return nil
            }

            return .blockDeclarator(
                .init(
                    blockDeclarationSpecifiers: blockDeclarationSpecifiers,
                    directAbstractDeclarator: directAbstractDeclarator,
                    parameterList: parameterList
                )
            )
        }

        return nil
    }

    func blockDeclarationSpecifier(_ ctx: ObjectiveCParser.BlockDeclarationSpecifierContext?) -> BlockDeclarationSpecifierSyntax? {
        guard let ctx else { return nil }

        if let typeQualifier = typeQualifier(ctx.typeQualifier()) {
            return .typeQualifier(typeQualifier)
        }
        if let typePrefix = typePrefix(ctx.typePrefix()) {
            return .typePrefix(typePrefix)
        }
        if let arcBehaviourSpecifier = arcBehaviourSpecifier(ctx.arcBehaviourSpecifier()) {
            return .arcBehaviour(arcBehaviourSpecifier)
        }
        if let nullabilitySpecifier = nullabilitySpecifier(ctx.nullabilitySpecifier()) {
            return .nullability(nullabilitySpecifier)
        }

        return nil
    }

    func declarationSpecifiers(_ ctx: ObjectiveCParser.DeclarationSpecifiersContext?) -> DeclarationSpecifiersSyntax? {
        guard let ctx else { return nil }
        
        let specifiers = ctx.declarationSpecifier().compactMap(declarationSpecifier(_:))
        if specifiers.isEmpty {
            return nil
        }

        return .init(
            declarationSpecifier: specifiers
        )
    }

    func declarationSpecifier(_ ctx: ObjectiveCParser.DeclarationSpecifierContext?) -> DeclarationSpecifierSyntax? {
        guard let ctx else { return nil }

        if let storageClassSpecifier = storageClassSpecifier(ctx.storageClassSpecifier()) {
            return .storage(storageClassSpecifier)
        }
        if let typeSpecifier = typeSpecifier(ctx.typeSpecifier()) {
            return .typeSpecifier(typeSpecifier)
        }
        if let typeQualifier = typeQualifier(ctx.typeQualifier()) {
            return .typeQualifier(typeQualifier)
        }
        if let functionSpecifier = functionSpecifier(ctx.functionSpecifier()) {
            return .functionSpecifier(functionSpecifier)
        }
        if let alignmentSpecifier = alignmentSpecifier(ctx.alignmentSpecifier()) {
            return .alignment(alignmentSpecifier)
        }
        if let arcBehaviourSpecifier = arcBehaviourSpecifier(ctx.arcBehaviourSpecifier()) {
            return .arcBehaviour(arcBehaviourSpecifier)
        }
        if let nullabilitySpecifier = nullabilitySpecifier(ctx.nullabilitySpecifier()) {
            return .nullability(nullabilitySpecifier)
        }
        if let ibOutletQualifier = ibOutletQualifier(ctx.ibOutletQualifier()) {
            return .ibOutlet(ibOutletQualifier)
        }
        if let typePrefix = typePrefix(ctx.typePrefix()) {
            return .typePrefix(typePrefix)
        }

        return nil
    }

    func typeSpecifier(_ ctx: ObjectiveCParser.TypeSpecifierContext?) -> TypeSpecifierSyntax? {
        guard let ctx else { return nil }

        if let scalarType = scalarTypeSpecifier(ctx.scalarTypeSpecifier()) {
            return .scalar(scalarType)
        }
        if let typeIdentifier = typeIdentifier(ctx.typedefName()) {
            return .typeIdentifier(typeIdentifier)
        }
        if let genericType = genericTypeSpecifier(ctx.genericTypeSpecifier()) {
            return .genericTypeIdentifier(genericType)
        }
        if let expression = expression(ctx.typeofTypeSpecifier()?.expression()) {
            return .typeof(expression: expression)
        }
        if let structOrUnion = structOrUnionSpecifier(ctx.structOrUnionSpecifier()) {
            return .structOrUnion(structOrUnion)
        }
        if let enumSpecifier = enumSpecifier(ctx.enumSpecifier()) {
            return .enum(enumSpecifier)
        }

        return nil
    }

    func typeIdentifier(_ ctx: ObjectiveCParser.TypedefNameContext?) -> TypeIdentifierSyntax? {
        guard let identifier = self.identifier(ctx?.identifier()) else { return nil }

        return .init(identifier: identifier)
    }

    func genericTypeSpecifier(_ ctx: ObjectiveCParser.GenericTypeSpecifierContext?) -> GenericTypeSpecifierSyntax? {
        guard let ctx else { return nil }
        guard let identifier = identifier(ctx.identifier()) else { return nil }
        guard let genericTypeList = ctx.genericTypeList() else { return nil }

        let genericTypes = genericTypeList.genericTypeParameter().compactMap(genericTypeParameter(_:))
        if genericTypes.isEmpty {
            return nil
        }

        return .init(identifier: identifier, genericTypeParameters: genericTypes)
    }

    func genericTypeParameter(_ ctx: ObjectiveCParser.GenericTypeParameterContext?) -> GenericTypeParameterSyntax? {
        guard let ctx else { return nil }
        guard let typeName = typeName(ctx.typeName()) else { return nil }

        let variance = genericTypeParameterVariance(ctx)

        return .init(variance: variance, typeName: typeName)
    }

    func pointer(_ ctx: ObjectiveCParser.PointerContext?) -> PointerSyntax? {
        guard let ctx else { return nil }

        return .init(
            pointerEntries: ctx.pointerEntry().compactMap(pointerEntry(_:))
        )
    }

    func pointerEntry(_ ctx: ObjectiveCParser.PointerEntryContext?) -> PointerSyntaxEntry? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        let specifiers = ctx.pointerSpecifier().compactMap(self.pointerSpecifier(_:))

        return .init(
            location: range.start ?? .invalid,
            pointerSpecifiers: specifiers
        )
    }

    func pointerSpecifier(_ ctx: ObjectiveCParser.PointerSpecifierContext?) -> PointerSpecifierSyntax? {
        guard let ctx else { return nil }

        if let syntax = ctx.nullabilitySpecifier(), let nullability = nullabilitySpecifier(syntax) {
            return .nullability(
                nullability
            )
        }
        if let syntax = ctx.typeQualifier(), let typeQualifiers = typeQualifier(syntax) {
            return .typeQualifier(
                typeQualifiers
            )
        }
        if let syntax = ctx.arcBehaviourSpecifier(), let arcBehaviour = arcBehaviourSpecifier(syntax) {
            return .arcBehaviour(
                arcBehaviour
            )
        }

        return nil
    }

    func typeQualifierList(_ ctx: ObjectiveCParser.TypeQualifierListContext?) -> TypeQualifierListSyntax? {
        guard let ctx else { return nil }

        let typeQualifiers = ctx.typeQualifier().compactMap(typeQualifier(_:))

        return typeQualifiers.isEmpty ? nil : .init(typeQualifiers: typeQualifiers)
    }

    func typeQualifier(_ ctx: ObjectiveCParser.TypeQualifierContext?) -> TypeQualifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.CONST() != nil {
            return .const(range)
        }
        if ctx.VOLATILE() != nil {
            return .volatile(range)
        }
        if ctx.RESTRICT() != nil {
            return .restrict(range)
        }
        if ctx.ATOMIC_() != nil {
            return .atomic(range)
        }
        if let protocolQualifier = protocolQualifier(ctx.protocolQualifier()) {
            return .protocolQualifier(protocolQualifier)
        }

        return nil
    }

    func specifierQualifierList(_ ctx: ObjectiveCParser.SpecifierQualifierListContext?) -> SpecifierQualifierListSyntax? {
        guard let ctx else { return nil }

        var result: [TypeSpecifierQualifierSyntax] = []

        var next: _? = ctx

        while next != nil {
            defer { next = next?.specifierQualifierList() }

            if let typeSpecifier = typeSpecifier(next?.typeSpecifier()) {
                result.append(.typeSpecifier(typeSpecifier))
            }
            if let typeQualifier = typeQualifier(next?.typeQualifier()) {
                result.append(.typeQualifier(typeQualifier))
            }
        }

        if result.isEmpty {
            return nil
        }

        return .init(specifierQualifiers: result)
    }

    func ibOutletQualifier(_ ctx: ObjectiveCParser.IbOutletQualifierContext?) -> IBOutletQualifierSyntax? {
        guard let ctx else { return nil }

        if let node = ctx.IB_OUTLET_COLLECTION(), let identifier = identifier(ctx.identifier()) {
            return .ibOutletCollection(location(node), identifier)
        }
        if ctx.IB_OUTLET() != nil {
            return .ibOutlet(range(ctx))
        }

        return nil
    }

    func functionSpecifier(_ ctx: ObjectiveCParser.FunctionSpecifierContext?) -> FunctionSpecifierSyntax? {
        guard let ctx else { return nil }
        let range = range(ctx)

        if ctx.INLINE() != nil {
            return .inline(range)
        }
        if ctx.NORETURN_() != nil {
            return .noreturn(range)
        }
        if ctx.INLINE__() != nil {
            return .gccInline(range)
        }
        if ctx.STDCALL() != nil {
            return .stdcall(range)
        }
        if let declspec = ctx.DECLSPEC(), let identifier = identifier(ctx.identifier()) {
            return .declspec(location(declspec), identifier)
        }

        return nil
    }

    func alignmentSpecifier(_ ctx: ObjectiveCParser.AlignmentSpecifierContext?) -> AlignmentSpecifierSyntax? {
        guard let ctx else { return nil }
        
        if let typeName = typeName(ctx.typeName()) {
            return .typeName(typeName)
        }
        if let constantExpression = constantExpression(ctx.constantExpression()) {
            return .expression(constantExpression: constantExpression)
        }

        return nil
    }

    func parameterTypeList(_ ctx: ObjectiveCParser.ParameterTypeListContext?) -> ParameterTypeListSyntax? {
        guard let ctx else { return nil }
        guard let parameterList = parameterList(ctx.parameterList()) else { return nil }

        let isVariadic = ctx.ELIPSIS() != nil

        return .init(parameterList: parameterList, isVariadic: isVariadic)
    }

    func blockParameterList(_ ctx: ObjectiveCParser.BlockParametersContext?) -> ParameterListSyntax? {
        guard let ctx else { return nil }

        let result = ctx.parameterDeclaration().compactMap(self.parameterDeclaration(_:))

        return .init(parameterDeclarations: result)
    }

    func parameterList(_ ctx: ObjectiveCParser.ParameterListContext?) -> ParameterListSyntax? {
        guard let ctx else { return nil }

        let result = ctx.parameterDeclaration().compactMap(self.parameterDeclaration(_:))

        return result.isEmpty ? nil : .init(parameterDeclarations: result)
    }

    func parameterDeclaration(_ ctx: ObjectiveCParser.ParameterDeclarationContext?) -> ParameterDeclarationSyntax? {
        guard let ctx else { return nil }
        guard let declarationSpecifiers = declarationSpecifiers(ctx.declarationSpecifiers()) else {
            return nil
        }

        let declarator = declarator(ctx.declarator())
        let abstractDeclarator = abstractDeclarator(ctx.abstractDeclarator())

        if ctx.declarator() != nil {
            guard let declarator else { return nil }

            return .declarator(declarationSpecifiers, declarator)
        } else if ctx.abstractDeclarator() != nil {
            guard let abstractDeclarator else { return nil }

            return .abstractDeclarator(declarationSpecifiers, abstractDeclarator)
        } else {
            return .declarationSpecifiers(declarationSpecifiers)
        }
    }
    
    func fieldDeclarators(_ ctx: ObjectiveCParser.FieldDeclaratorListContext?) -> [FieldDeclaratorSyntax]? {
        guard let ctx else { return nil }

        var result: [FieldDeclaratorSyntax] = []

        for decl in ctx.fieldDeclarator() {
            if let fieldDeclarator = fieldDeclarator(decl) {
                result.append(fieldDeclarator)
            }
        }

        return result.isEmpty ? nil : result
    }

    func fieldDeclarator(_ ctx: ObjectiveCParser.FieldDeclaratorContext?) -> FieldDeclaratorSyntax? {
        guard let ctx else { return nil }

        let declarator = self.declarator(ctx.declarator())
        let constantExpression = self.constantExpression(ctx.constantExpression())

        switch (ctx.declarator(), ctx.constantExpression()) {
        case (_?, nil):
            return declarator.map(FieldDeclaratorSyntax.declarator)

        case (_?, _?):
            if let declarator, let constantExpression {
                return .declaratorConstantExpression(declarator, constantExpression)
            }

        case (nil, _?):
            if let constantExpression {
                return .declaratorConstantExpression(nil, constantExpression)
            }

        default:
            break
        }

        return nil
    }

    // MARK: - Struct/union syntax

    func structOrUnionSpecifier(_ ctx: ObjectiveCParser.StructOrUnionSpecifierContext?) -> StructOrUnionSpecifierSyntax? {
        guard let ctx else { return nil }
        guard let structOrUnion = structOrUnion(ctx.structOrUnion()) else { return nil }

        let identifier = identifier(ctx.identifier())
        let declarations = structDeclarationList(ctx.structDeclarationList())

        let declaration: StructOrUnionSpecifierSyntax.Declaration

        switch (ctx.identifier(), ctx.structDeclarationList()) {
        case (_?, nil):
            guard let identifier else { return nil }

            declaration = .opaque(identifier)
        
        case (_?, _?):
            guard let identifier else { return nil }
            guard let declarations else { return nil }

            declaration = .declared(identifier, declarations)

        case (nil, _?):
            guard let declarations else { return nil }

            declaration = .declared(nil, declarations)
        default:
            return nil
        }

        return .init(structOrUnion: structOrUnion, declaration: declaration)
    }

    func structDeclarationList(_ ctx: ObjectiveCParser.StructDeclarationListContext?) -> StructDeclarationListSyntax? {
        guard let ctx else { return nil }

        var decls: [StructDeclarationSyntax] = []

        for decl in ctx.structDeclaration() {
            if let decl = structDeclaration(decl) {
                decls.append(decl)
            }
        }

        if decls.isEmpty {
            return nil
        }

        return .init(structDeclaration: decls)
    }

    func structDeclaration(_ ctx: ObjectiveCParser.StructDeclarationContext?) -> StructDeclarationSyntax? {
        guard let ctx else { return nil }

        let specifiers = specifierQualifierList(ctx.specifierQualifierList())
        let declaratorList = fieldDeclarators(ctx.fieldDeclaratorList())

        switch (ctx.specifierQualifierList(), ctx.fieldDeclaratorList()) {
        case (_?, nil):
            if let specifiers {
                return .init(specifierQualifierList: specifiers, fieldDeclaratorList: [])
            }
        case (_?, _?):
            if let specifiers, let declaratorList {
                return .init(specifierQualifierList: specifiers, fieldDeclaratorList: declaratorList)
            }
        default:
            break
        }

        return nil
    }

    func structOrUnion(_ ctx: ObjectiveCParser.StructOrUnionContext?) -> StructOrUnionSpecifierSyntax.StructOrUnion? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.STRUCT() != nil {
            return .struct(range)
        }
        if ctx.UNION() != nil {
            return .union(range)
        }

        return nil
    }

    // MARK: - Enum syntax

    func enumSpecifier(_ ctx: ObjectiveCParser.EnumSpecifierContext?) -> EnumSpecifierSyntax? {
        guard let ctx else { return nil }
        
        let enumeratorList = enumeratorList(ctx.enumeratorList())
        let typeName = typeName(ctx.typeName())
        let enumName = identifier(ctx.enumName) ?? ctx.identifier().compactMap(identifier(_:)).first
        
        if let nsOptionsOrNSEnum = nsOptionsOrNSEnum(ctx) {
            guard let enumName, let typeName, let enumeratorList else {
                return nil
            }

            return .nsOptionsOrNSEnum(nsOptionsOrNSEnum, typeName, enumName, enumeratorList)
        } else if ctx.ENUM() != nil {
            // Weed out invalid combinations of rules
            if enumName == nil && enumeratorList == nil { return nil }
            
            if ctx.enumeratorList() != nil {
                guard let enumeratorList else {
                    return nil
                }

                return .cEnum(
                    enumName,
                    typeName,
                    .declared(enumName, enumeratorList)
                )
            } else if ctx.identifier().count > 0 {
                guard let enumName else {
                    return nil
                }

                return .cEnum(
                    enumName,
                    typeName,
                    .opaque(enumName)
                )
            }
        }

        return nil
    }

    func nsOptionsOrNSEnum(_ ctx: ObjectiveCParser.EnumSpecifierContext?) -> EnumSpecifierSyntax.NSOptionsOrNSEnum? {
        guard let ctx else { return nil }

        if let nsOptions = ctx.NS_OPTIONS() {
            return .nsOptions(range(nsOptions))
        }
        if let nsEnum = ctx.NS_ENUM() {
            return .nsEnum(range(nsEnum))
        }

        return nil
    }

    func enumeratorList(_ ctx: ObjectiveCParser.EnumeratorListContext?) -> EnumeratorListSyntax? {
        guard let ctx else { return nil }

        var result: [EnumeratorSyntax] = []

        for enumerator in ctx.enumerator() {
            if let enumerator = self.enumerator(enumerator) {
                result.append(enumerator)
            }
        }

        return result.isEmpty ? nil : .init(enumerators: result)
    }

    func enumerator(_ ctx: ObjectiveCParser.EnumeratorContext?) -> EnumeratorSyntax? {
        guard let ctx else { return nil }
        guard let identifier = identifier(ctx.enumeratorIdentifier()?.identifier()) else { return nil }

        if ctx.expression() == nil {
            return .init(enumeratorIdentifier: identifier)
        }

        guard let expression = expression(ctx.expression()) else {
            return nil
        }

        return .init(enumeratorIdentifier: identifier, expression: expression)
    }

    // MARK: - Leaf syntax

    func scalarTypeSpecifier(_ ctx: ObjectiveCParser.ScalarTypeSpecifierContext?) -> ScalarTypeSpecifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.VOID() != nil {
            return .void(range)
        }
        if ctx.CHAR() != nil {
            return .char(range)
        }
        if ctx.SHORT() != nil {
            return .short(range)
        }
        if ctx.INT() != nil {
            return .int(range)
        }
        if ctx.LONG() != nil {
            return .long(range)
        }
        if ctx.FLOAT() != nil {
            return .float(range)
        }
        if ctx.DOUBLE() != nil {
            return .double(range)
        }
        if ctx.SIGNED() != nil {
            return .signed(range)
        }
        if ctx.UNSIGNED() != nil {
            return .unsigned(range)
        }
        if ctx.BOOL_() != nil {
            return ._bool(range)
        }
        if ctx.CBOOL() != nil {
            return .bool(range)
        }
        if ctx.COMPLEX() != nil {
            return .complex(range)
        }
        if ctx.M128() != nil {
            return .m128(range)
        }
        if ctx.M128D() != nil {
            return .m128d(range)
        }
        if ctx.M128I() != nil {
            return .m128i(range)
        }
        
        return nil
    }

    func protocolQualifier(_ ctx: ObjectiveCParser.ProtocolQualifierContext?) -> ProtocolQualifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.IN() != nil {
            return .in(range)
        }
        if ctx.OUT() != nil {
            return .out(range)
        }
        if ctx.INOUT() != nil {
            return .inout(range)
        }
        if ctx.BYCOPY() != nil {
            return .bycopy(range)
        }
        if ctx.BYREF() != nil {
            return .byref(range)
        }
        if ctx.ONEWAY() != nil {
            return .oneway(range)
        }

        return nil
    }

    func arcBehaviourSpecifier(_ ctx: ObjectiveCParser.ArcBehaviourSpecifierContext?) -> ArcBehaviourSpecifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.WEAK_QUALIFIER() != nil {
            return .weakQualifier(range)
        }
        if ctx.STRONG_QUALIFIER() != nil {
            return .strongQualifier(range)
        }
        if ctx.AUTORELEASING_QUALIFIER() != nil {
            return .autoreleasingQualifier(range)
        }
        if ctx.UNSAFE_UNRETAINED_QUALIFIER() != nil {
            return .unsafeUnretainedQualifier(range)
        }

        return nil
    }

    func storageClassSpecifier(_ ctx: ObjectiveCParser.StorageClassSpecifierContext?) -> StorageClassSpecifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.AUTO() != nil {
            return .auto(range)
        }
        if ctx.CONSTEXPR() != nil {
            return .constexpr(range)
        }
        if ctx.EXTERN() != nil {
            return .extern(range)
        }
        if ctx.REGISTER() != nil {
            return .register(range)
        }
        if ctx.STATIC() != nil {
            return .static(range)
        }
        if ctx.THREAD_LOCAL_() != nil {
            return .threadLocal(range)
        }
        if ctx.TYPEDEF() != nil {
            return .typedef(range)
        }

        return nil
    }

    func nullabilitySpecifier(_ ctx: ObjectiveCParser.NullabilitySpecifierContext?) -> NullabilitySpecifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.NONNULL() != nil {
            return .nonnull(range)
        }
        if ctx.NULLABLE() != nil {
            return .nullable(range)
        }
        if ctx.NULL_UNSPECIFIED() != nil {
            return .nullUnspecified(range)
        }
        if ctx.NULL_RESETTABLE() != nil {
            return .nullResettable(range)
        }

        return nil
    }

    func typePrefix(_ ctx: ObjectiveCParser.TypePrefixContext?) -> TypePrefixSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        if ctx.BRIDGE() != nil {
            return .bridge(range)
        }
        if ctx.BRIDGE_TRANSFER() != nil {
            return .bridgeTransfer(range)
        }
        if ctx.BRIDGE_RETAINED() != nil {
            return .bridgeRetained(range)
        }
        if ctx.BLOCK() != nil {
            return .block(range)
        }
        if ctx.INLINE() != nil {
            return .inline(range)
        }
        if ctx.NS_INLINE() != nil {
            return .nsInline(range)
        }
        if ctx.KINDOF() != nil {
            return .kindof(range)
        }

        return nil
    }

    func identifier(_ ctx: ObjectiveCParser.IdentifierContext?) -> IdentifierSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        return .init(sourceRange: range, identifier: sourceString(ctx))
    }

    func genericTypeParameterVariance(
        _ ctx: ObjectiveCParser.GenericTypeParameterContext?
    ) -> GenericTypeParameterSyntax.Variance? {
        guard let ctx else { return nil }

        if let covariant = ctx.COVARIANT() {
            return .covariant(range(covariant))
        }
        if let contravariant = ctx.CONTRAVARIANT() {
            return .contravariant(range(contravariant))
        }

        return nil
    }

    func expression(_ ctx: ObjectiveCParser.ExpressionContext?) -> ExpressionSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        return .init(sourceRange: range, expressionString: sourceString(ctx))
    }

    func constantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext?) -> ConstantExpressionSyntax? {
        guard let ctx else { return nil }
        let range = self.range(ctx)

        return .init(sourceRange: range, constantExpressionString: sourceString(ctx))
    }

    // MARK: - Internals

    func range(_ rule: ParserRuleContext) -> SourceRange {
        source.sourceRange(for: rule)
    }

    func range(_ node: TerminalNode) -> SourceRange {
        source.sourceRange(for: node)
    }

    func location(_ rule: ParserRuleContext) -> SourceLocation {
        source.sourceRange(for: rule).start ?? .invalid
    }

    func location(_ node: TerminalNode) -> SourceLocation {
        source.sourceRange(for: node).start ?? .invalid
    }

    func sourceString(_ rule: ParserRuleContext) -> String {
        let range = self.range(rule)

        if let substring = source.sourceSubstring(range) {
            return String(substring)
        }

        return rule.getText()
    }
}
