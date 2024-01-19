import SwiftSyntax
import Intentions
import SwiftAST
import KnownType

public class SwiftSyntaxProducer: BaseSwiftSyntaxProducer {
    var settings: Settings
    weak var delegate: SwiftSyntaxProducerDelegate?
    
    // TODO: Come up with a better way to keep track of changes to leading
    // indentation.
    // This is currently used to emit an empty, dummy token with this trailing,
    // in case a file with just compiler directive comments is encountered.
    var didModifyExtraLeading = false
    override var extraLeading: Trivia? {
        didSet {
            didModifyExtraLeading = true
        }
    }
    
    var varDeclGenerator: VariableDeclSyntaxGenerator {
        VariableDeclSyntaxGenerator(producer: self)
    }
    
    public override init() {
        settings = .default
        
        super.init()
    }
    
    public init(settings: Settings, delegate: SwiftSyntaxProducerDelegate? = nil) {
        self.settings = settings
        self.delegate = delegate
        
        super.init()
    }
    
    public struct Settings {
        /// Default settings instance
        public static let `default` = Settings(outputExpressionTypes: false,
                                               printIntentionHistory: false,
                                               emitObjcCompatibility: false)
        
        /// If `true`, when outputting expression statements, print the resulting
        /// type of the expression before the expression statement as a comment
        /// for inspection.
        public var outputExpressionTypes: Bool
        
        /// If `true`, when outputting final intentions, print any history
        /// information tracked on its `IntentionHistory` property before the
        /// intention's declaration as a comment for inspection.
        public var printIntentionHistory: Bool
        
        /// If `true`, `@objc` attributes and `: NSObject` are emitted for
        /// declarations during output.
        ///
        /// This may increase compatibility with previous Objective-C code when
        /// compiled and executed.
        public var emitObjcCompatibility: Bool
        
        public init(
            outputExpressionTypes: Bool,
            printIntentionHistory: Bool,
            emitObjcCompatibility: Bool
        ) {
            
            self.outputExpressionTypes = outputExpressionTypes
            self.printIntentionHistory = printIntentionHistory
            self.emitObjcCompatibility = emitObjcCompatibility
        }
        
        /// To ease modifications of single parameters from default settings
        /// without having to create a temporary variable first
        public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
            var copy = self
            copy[keyPath: keyPath] = value
            return copy
        }
    }
    
    func modifiers(for intention: IntentionProtocol) -> [ModifiersDecoratorResult] {
        modifiersDecorations.modifiers(for: intention)
    }
    
    func modifiers(for decl: StatementVariableDeclaration) -> [ModifiersDecoratorResult] {
        modifiersDecorations.modifiers(for: decl)
    }
    
    func attributes(
        for intention: IntentionProtocol,
        inline: Bool
    ) -> [() -> AttributeListSyntax.Element] {
        
        guard let attributable = intention as? AttributeTaggableObject else {
            return []
        }
        
        var attributes = attributable.knownAttributes
        
        // TODO: This should not be done here, but in an IntentionPass
        if shouldEmitObjcAttribute(intention) {
            attributes.append(KnownAttribute(name: "objc"))
        }
        
        var attributeSyntaxes: [() -> AttributeListSyntax.Element] = []
        
        for attr in attributes {
            let attrSyntax: () -> AttributeListSyntax.Element = {
                defer {
                    if inline {
                        self.addExtraLeading(.spaces(1))
                    } else {
                        self.addExtraLeading(.newlines(1) + self.indentation())
                    }
                }
                
                return self.generateAttributeSyntax(attr)
            }
            
            attributeSyntaxes.append(attrSyntax)
        }
        
        return attributeSyntaxes
    }
    
    func shouldEmitObjcAttribute(_ intention: IntentionProtocol) -> Bool {
        if !settings.emitObjcCompatibility {
            // Protocols which feature optional members must be emitted with @objc
            // to maintain compatibility; same for method/properties
            if let _protocol = intention as? ProtocolGenerationIntention {
                if _protocol.methods.any(\.optional)
                    || _protocol.properties.any(\.optional) {
                    return true
                }
            }
            if let property = intention as? ProtocolPropertyGenerationIntention {
                return property.isOptional
            }
            if let method = intention as? ProtocolMethodGenerationIntention {
                return method.isOptional
            }
            
            return false
        }
        
        if intention is PropertyGenerationIntention {
            return true
        }
        if intention is InitGenerationIntention {
            return true
        }
        if intention is MethodGenerationIntention {
            return true
        }
        if let type = intention as? TypeGenerationIntention,
            type.kind != .struct {
            return true
        }
        
        return false
    }

    func addComments(_ comments: [SwiftComment]) {
        let trivia = toCommentsTrivia(comments)
        addExtraLeading(trivia)
    }

    func toCommentsTrivia(_ comments: [SwiftComment], addNewLineAfter: Bool = true) -> Trivia {
        var trivia: Trivia = []

        for (i, comment) in comments.enumerated() {
            trivia = trivia + toCommentTrivia(comment)

            if addNewLineAfter || i < comments.count - 1 {
                trivia = trivia + .newlines(1) + indentation()
            }
        }

        return trivia
    }

    func toCommentTrivia(_ comment: SwiftComment) -> Trivia {
        let commentTrivia: Trivia

        switch comment {
        case .line(let comment):
            commentTrivia = .lineComment(comment)
        case .block(let comment):
            commentTrivia = .blockComment(comment)
        case .docLine(let comment):
            commentTrivia = .docLineComment(comment)
        case .docBlock(let comment):
            commentTrivia = .docBlockComment(comment)
        }

        return commentTrivia
    }
    
    func addCommentsIfAvailable(_ intention: FromSourceIntention) {
        addComments(intention.precedingComments)
    }
    
    func addHistoryTrackingLeadingIfEnabled(_ intention: IntentionProtocol) {
        if !settings.printIntentionHistory {
            return
        }
        
        for entry in intention.history.entries {
            addExtraLeading(.lineComment("// \(entry.summary)"))
            addExtraLeading(.newlines(1) + indentation())
        }
    }
}

// MARK: - File generation
extension SwiftSyntaxProducer {
    
    /// Generates a source file syntax from a given file generation intention.
    public func generateFile(_ file: FileGenerationIntention) -> SourceFileSyntax {
        var fileSyntax = SourceFileSyntax(statements: [])

        // Imports come before any header #directive comments
        iterating(file.importDirectives) { module in
            let syntax = generateImport(module)
            
            //let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax.asSyntax) }
            fileSyntax.statements.append(
                CodeBlockItemSyntax(item: .decl(syntax.asDeclSyntax))
            )
        }
        
        var hasHeaderTrivia = false
        if let headerTrivia = generateHeaderCommentsTrivia(file) {
            hasHeaderTrivia = true
            addExtraLeading(headerTrivia)
            addExtraLeading(.newlines(1))
        }
        
        didModifyExtraLeading = false
        
        iterating(file.typealiasIntentions) { intention in
            let syntax = generateTypealias(intention)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.enumIntentions) { intention in
            let syntax = generateEnum(intention)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.structIntentions) { _struct in
            let syntax = generateStruct(_struct)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.globalVariableIntentions) { variable in
            let syntax = varDeclGenerator.generateGlobalVariable(variable)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.globalFunctionIntentions) { function in
            let syntax = generateFunction(function, alwaysEmitBody: true)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.protocolIntentions) { _protocol in
            let syntax = generateProtocol(_protocol)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.classIntentions) { _class in
            let syntax = generateClass(_class)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        iterating(file.extensionIntentions) { _class in
            let syntax = generateExtension(_class)
            
            fileSyntax.statements.append(syntax.inCodeBlock())
        }
        
        // No one consumed the leading trivia - emit a dummy token just so we
        // can have a file with preprocessor directives in place
        if !didModifyExtraLeading && hasHeaderTrivia {
            extraLeading = extraLeading.map { Trivia(pieces: $0.dropLast()) }

            let item = CodeBlockItemSyntax(item: .expr(
                DeclReferenceExprSyntax(baseName: .identifier(""))
                .withExtraLeading(consuming: &extraLeading)
                .asExprSyntax
            ))

            fileSyntax = fileSyntax.addStatement(item)
        }

        return fileSyntax
    }
    
    func generateHeaderCommentsTrivia(_ file: FileGenerationIntention) -> Trivia? {
        if file.headerComments.isEmpty {
            return nil
        }
        
        var trivia: Trivia = .lineComment("// \(file.headerComments[0])")
        
        for comment in file.headerComments.dropFirst() {
            trivia = trivia + .newlines(1) + .lineComment("// \(comment)")
        }
        
        return trivia
    }
}

// MARK: - Import declarations
extension SwiftSyntaxProducer {
    func generateImport(_ module: String) -> ImportDeclSyntax {
        return ImportDeclSyntax(
            importTok: prepareStartToken(.keyword(.import)).withTrailingSpace(),
            path: [.init(name: makeIdentifier(module))]
        )
    }
}

// MARK: - Typealias Intention
extension SwiftSyntaxProducer {
    func generateTypealias(_ intention: TypealiasIntention) -> TypeAliasDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        return TypeAliasDeclSyntax(
            typealiasKeyword: prepareStartToken(.keyword(.typealias)).withTrailingSpace(),
            identifier: makeIdentifier(intention.name),
            initializer: .init(
                equal: .equalToken().addingSurroundingSpaces(),
                value:  SwiftTypeConverter
                    .makeTypeSyntax(intention.fromType, startTokenHandler: self)
            )
        )
    }
}

// MARK: - Enum Generation
extension SwiftSyntaxProducer {
    func generateEnum(_ intention: EnumGenerationIntention) -> EnumDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        addExtraLeading(indentation())

        let attributesSyntax = self.attributes(for: intention, inline: false).map { attribute in
            attribute()
        }
        
        var syntax = EnumDeclSyntax(
            attributes: AttributeListSyntax(attributesSyntax),
            enumKeyword: prepareStartToken(.keyword(.enum)).withTrailingSpace(),
            identifier: makeIdentifier(intention.typeName),
            memberBlock: .init()
        )
        
        syntax = syntax.with(\.inheritanceClause, TypeInheritanceClauseSyntax(
            colon: prepareStartToken(.colonToken()).withTrailingSpace(),
            inheritedTypeCollection: [
                .init(typeName: SwiftTypeConverter.makeTypeSyntax(intention.rawValueType, startTokenHandler: self))
            ]
        ))
        
        indent()
        
        addExtraLeading(.spaces(1))
        
        let members = generateMembers(intention)
        
        deindent()
        
        syntax = syntax.with(\.members, members)

        return syntax
    }
    
    func generateEnumCase(_ _case: EnumCaseGenerationIntention) -> EnumCaseDeclSyntax {
        addCommentsIfAvailable(_case)
        
        var syntax = EnumCaseDeclSyntax(
            caseKeyword: prepareStartToken(.keyword(.case)).withTrailingSpace(),
            elements: []
        )

        let initializerClause: InitializerClauseSyntax?
        if let rawValue = _case.expression {
            initializerClause = .init(
                equal: .equalToken().addingSurroundingSpaces(),
                value: generateExpression(rawValue)
            )
        } else {
            initializerClause = nil
        }

        syntax = syntax.addElement(.init(
            identifier: makeIdentifier(_case.name),
            rawValue: initializerClause
        ))

        return syntax
    }
}

// MARK: - Extension Generation
extension SwiftSyntaxProducer {
    
    func generateExtension(_ intention: ClassExtensionGenerationIntention) -> ExtensionDeclSyntax {
        addExtraLeading(indentation())
        
        if let categoryName = intention.categoryName,
            !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            
            addExtraLeading(.lineComment("// MARK: - \(categoryName)"))
        } else {
            addExtraLeading(.lineComment("// MARK: -"))
        }
        
        addExtraLeading(.newlines(1) + indentation())
        
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        var syntax = ExtensionDeclSyntax(extendedType: MissingTypeSyntax(), memberBlock: .init())

        for attribute in attributes(for: intention, inline: false) {
            syntax = syntax.addAttribute(attribute().asSyntax)
        }
        for modifier in modifiers(for: intention) {
            syntax = syntax.addModifier(modifier(self))
        }
        
        syntax = syntax.with(\.extensionKeyword, 
            prepareStartToken(.keyword(.extension))
                .addingTrailingSpace()
        )
        
        // TODO: Support nested type extension
        syntax = syntax.with(\.extendedType, 
            SwiftTypeConverter.makeTypeSyntax(.typeName(intention.typeName), startTokenHandler: self)
        )
        
        if let inheritanceClause = generateInheritanceClause(intention) {
            syntax = syntax.with(\.inheritanceClause, inheritanceClause)
        } else {
            addExtraLeading(.spaces(1))
        }
        
        indent()
        
        let members = generateMembers(intention)
        
        deindent()
        
        syntax = syntax.with(\.members, members)

        return syntax
    }
}

// MARK: - Class Generation
extension SwiftSyntaxProducer {
    func generateClass(_ intention: ClassGenerationIntention) -> ClassDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        addExtraLeading(indentation())

        let attributesSyntax = attributes(for: intention, inline: false).map { attribute in
            attribute()
        }
        let modifiersSyntax = modifiers(for: intention).map { modifier in
            modifier(self)
        }
        
        let identifier = makeIdentifier(intention.typeName)
        var syntax = ClassDeclSyntax(
            attributes: AttributeListSyntax(attributesSyntax),
            modifiers: ModifierListSyntax(modifiersSyntax),
            classKeyword: prepareStartToken(.keyword(.class)).addingTrailingSpace(),
            identifier: makeIdentifier(intention.typeName).withTrailingSpace(),
            memberBlock: .init()
        )
        
        if let inheritanceClause = generateInheritanceClause(intention) {
            syntax = syntax.with(\.identifier, identifier)
            syntax = syntax.with(\.inheritanceClause, inheritanceClause)
        }
        
        indent()
        
        let members = generateMembers(intention)
        
        deindent()
        
        syntax = syntax.with(\.members, members)

        return syntax
    }
    
    public func generateInheritanceClause(_ type: KnownType) -> InheritanceClauseSyntax? {
        var inheritances: [String] = []
        if let supertype = type.supertype?.asTypeName {
            inheritances.append(supertype)
        }
        inheritances.append(contentsOf:
            type.knownProtocolConformances.map(\.protocolName)
        )
        
        // TODO: This should be done in an intention pass before handing over the
        // types to this swift syntax producer
        var emitObjcAttribute = false
        if let prot = type as? ProtocolGenerationIntention {
            if prot.methods.contains(where: \.optional)
                || prot.properties.contains(where: \.optional) {
            
                emitObjcAttribute = true
            }
            
            if emitObjcAttribute || settings.emitObjcCompatibility {
                // Always inherit form NSObjectProtocol in Objective-C compatibility mode
                if !inheritances.contains("NSObjectProtocol") {
                    inheritances.insert("NSObjectProtocol", at: 0)
                }
                
                emitObjcAttribute = true
            } else {
                inheritances.removeAll(where: { $0 == "NSObjectProtocol" })
            }
        }
        
        if inheritances.isEmpty {
            return nil
        }

        var syntax = InheritanceClauseSyntax(inheritedTypes: [])

        syntax = syntax.with(\.colon, .colonToken().withTrailingSpace())
            
        for (i, inheritance) in inheritances.enumerated() {
            var typeSyntax = InheritedTypeSyntax(typeName: MissingTypeSyntax())

            var identifier = makeIdentifier(inheritance)
            
            if i != inheritances.count - 1 {
                typeSyntax = typeSyntax.with(
                    \.trailingComma,
                    .commaToken().withTrailingSpace()
                )
            } else {
                identifier = identifier.withTrailingSpace()
            }
            
            typeSyntax = typeSyntax.with(
                \.typeName,
                IdentifierTypeSyntax(name: identifier).asTypeSyntax
            )
            
            syntax = syntax.addInheritedType(typeSyntax)
        }

        return syntax
    }
}

// MARK: - Struct generation
extension SwiftSyntaxProducer {
    func generateStruct(_ intention: StructGenerationIntention) -> StructDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        addExtraLeading(indentation())

        var syntax = StructDeclSyntax(identifier: "", memberBlock: .init())
        
        let attributes = self.attributes(for: intention, inline: false)
        for attribute in attributes {
            syntax = syntax.addAttribute(attribute().asSyntax)
        }
        syntax = syntax.with(\.structKeyword, 
            prepareStartToken(.keyword(.struct))
                .addingTrailingSpace()
        )
        
        let identifier = makeIdentifier(intention.typeName)
        
        if let inheritanceClause = generateInheritanceClause(intention) {
            syntax = syntax.with(\.identifier, identifier)
            
            syntax = syntax.with(\.inheritanceClause, inheritanceClause)
        } else {
            syntax = syntax.with(\.identifier, identifier.withTrailingSpace())
        }
        
        indent()
        
        let members = generateMembers(intention)
        
        deindent()
        
        syntax = syntax.with(\.members, members)

        return syntax
    }
}

// MARK: - Protocol generation
extension SwiftSyntaxProducer {
    func generateProtocol(_ intention: ProtocolGenerationIntention) -> ProtocolDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)
        
        addExtraLeading(indentation())

        var syntax = ProtocolDeclSyntax(identifier: "", memberBlock: .init())
        
        let attributes = self.attributes(for: intention, inline: false)
        for attribute in attributes {
            syntax = syntax.addAttribute(attribute().asSyntax)
        }
        syntax = syntax.with(\.protocolKeyword, 
            prepareStartToken(.keyword(.protocol))
                .addingTrailingSpace()
        )
        
        let identifier = makeIdentifier(intention.typeName)
        
        if let inheritanceClause = generateInheritanceClause(intention) {
            syntax = syntax.with(\.identifier, identifier)
            
            syntax = syntax.with(\.inheritanceClause, inheritanceClause)
        } else {
            syntax = syntax.with(\.identifier, identifier.withTrailingSpace())
        }
        
        indent()
        
        let members = generateMembers(intention)
        
        deindent()
        
        syntax = syntax.with(\.members, members)

        return syntax
    }
}

// MARK: - Type member generation
extension SwiftSyntaxProducer {
    func generateMembers(_ intention: TypeGenerationIntention) -> MemberDeclBlockSyntax {
        var syntax = MemberDeclBlockSyntax()

        syntax = syntax.with(\.leftBrace, prepareStartToken(.leftBraceToken()))
        syntax = syntax.with(\.rightBrace, .rightBraceToken().onNewline())
        
        addExtraLeading(.newlines(1))
        
        // TODO: Probably shouldn't detect ivar containers like this.
        if let ivarHolder = intention as? InstanceVariableContainerIntention {
            iterating(ivarHolder.instanceVariables) { ivar in
                addExtraLeading(indentation())
                
                syntax = syntax.addMember(
                    MemberDeclListItemSyntax(
                        decl: varDeclGenerator.generateInstanceVariable(ivar),
                        semicolon: nil
                    )
                )
            }
            
            if !intention.properties.isEmpty {
                extraLeading = .newlines(1)
            }
        }
        // TODO: ...and neither enums
        let enumCases = intention
            .properties
            .compactMap { $0 as? EnumCaseGenerationIntention }
        
        iterating(enumCases) { prop in
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: generateEnumCase(prop).asDeclSyntax,
                    semicolon: nil
                )
            )
        }
        // TODO: ...and again...
        let properties = intention
            .properties
            .filter { !($0 is EnumCaseGenerationIntention) }
        
        iterating(properties) { prop in
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: varDeclGenerator.generateProperty(prop),
                    semicolon: nil
                )
            )
        }
        
        iterating(intention.subscripts) { sub in
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: varDeclGenerator.generateSubscript(sub),
                    semicolon: nil
                )
            )
        }
        
        iterating(intention.constructors) { _init in
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: generateInitializer(
                        _init,
                        emitBody: !(intention is ProtocolGenerationIntention),
                        alwaysEmitBody: !(intention is ProtocolGenerationIntention)
                    ).asDeclSyntax,
                    semicolon: nil
                )
            )
        }
        
        // TODO: ...and once more...
        if let deinitIntention = (intention as? BaseClassIntention)?.deinitIntention {
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: generateDeinitializer(deinitIntention).asDeclSyntax,
                    semicolon: nil
                )
            )
            addExtraLeading(.newlines(2))
        }
        
        iterating(intention.methods) { method in
            addExtraLeading(indentation())
            
            syntax = syntax.addMember(
                MemberDeclListItemSyntax(
                    decl: generateFunction(
                        method,
                        alwaysEmitBody: !(intention is ProtocolGenerationIntention)
                    ).asDeclSyntax,
                    semicolon: nil
                )
            )
        }

        return syntax
    }
}

// MARK: - Function syntax
extension SwiftSyntaxProducer {
    
    func generateInitializer(
        _ intention: InitGenerationIntention,
        emitBody: Bool,
        alwaysEmitBody: Bool
    ) -> InitializerDeclSyntax {
        
        addHistoryTrackingLeadingIfEnabled(intention)
        addCommentsIfAvailable(intention)

        let attributesSyntax = attributes(for: intention, inline: false).map { attribute in
            attribute()
        }
        let modifiersSyntax = modifiers(for: intention).map { modifier in
            modifier(self)
        }
        
        var syntax = InitializerDeclSyntax(
            attributes: AttributeListSyntax(attributesSyntax),
            modifiers: ModifierListSyntax(modifiersSyntax),
            initKeyword: prepareStartToken(.keyword(.`init`)),
            optionalMark: intention.isFallible ? .infixQuestionMarkToken() : nil,
            signature: .init(input: generateParameterClause(intention.parameters))
        )

        if emitBody {
            if let body = intention.functionBody {
                addExtraLeading(.spaces(1))
                syntax = syntax.with(\.body, generateFunctionBody(body))
            } else if alwaysEmitBody {
                addExtraLeading(.spaces(1))
                syntax = syntax.with(\.body, generateEmptyFunctionBody())
            }
        }

        return syntax
    }
    
    func generateDeinitializer(_ intention: DeinitGenerationIntention) -> DeinitializerDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)

        var syntax = DeinitializerDeclSyntax(
            deinitKeyword: prepareStartToken(.keyword(.deinit))
        )

        if let body = intention.functionBody {
            addExtraLeading(.spaces(1))
            syntax = syntax.with(\.body, generateFunctionBody(body))
        }

        return syntax
    }
    
    func generateFunction(
        _ intention: SignatureFunctionIntention,
        alwaysEmitBody: Bool
    ) -> FunctionDeclSyntax {

        addHistoryTrackingLeadingIfEnabled(intention)
        
        if let fromSource = intention as? FromSourceIntention {
            addCommentsIfAvailable(fromSource)
        }

        let attributesSyntax = attributes(for: intention, inline: false).map { attribute in
            attribute()
        }
        let modifiersSyntax = modifiers(for: intention).map { modifier in
            modifier(self)
        }
        
        var syntax = FunctionDeclSyntax(
            attributes: AttributeListSyntax(attributesSyntax),
            modifiers: ModifierListSyntax(modifiersSyntax),
            funcKeyword: prepareStartToken(.keyword(.func)).withTrailingSpace(),
            identifier: prepareStartToken(makeIdentifier(intention.signature.name)),
            signature: generateSignature(intention.signature)
        )

        if let body = intention.functionBody {
            addExtraLeading(.spaces(1))
            syntax = syntax.with(\.body, generateFunctionBody(body))
        } else if alwaysEmitBody {
            addExtraLeading(.spaces(1))
            syntax = syntax.with(\.body, generateEmptyFunctionBody())
        }

        return syntax
    }
    
    func generateSignature(_ signature: FunctionSignature) -> FunctionSignatureSyntax {
        var syntax = FunctionSignatureSyntax(
            input: generateParameterClause(signature.parameters)
        )

        if signature.returnType != .void {
            syntax = syntax.with(\.output, generateReturnType(signature.returnType))
        }

        return syntax
    }
    
    func generateReturnType(_ ret: SwiftType) -> ReturnClauseSyntax {
        let syntax = ReturnClauseSyntax(
            arrow: .arrowToken().addingSurroundingSpaces(),
            returnType: SwiftTypeConverter.makeTypeSyntax(
                ret,
                allowRootNullabilityUnspecified: false,
                startTokenHandler: self
            )
        )

        return syntax
    }
    
    func generateParameterClause(_ parameters: [ParameterSignature]) -> ParameterClauseSyntax {
        var syntax = ParameterClauseSyntax(parameters: [])

        iterateWithComma(parameters) { (item, hasComma) in
            syntax = syntax.addParameter(
                generateParameter(item, withTrailingComma: hasComma)
            )
        }

        return syntax
    }
    
    func generateParameter(
        _ parameter: ParameterSignature,
        withTrailingComma: Bool
    ) -> FunctionParameterSyntax {
        
        var syntax = FunctionParameterSyntax(stringLiteral: "")

        if parameter.label == parameter.name {
            syntax = syntax.with(\.firstName, 
                prepareStartToken(makeIdentifier(parameter.name))
            )
        } else if let label = parameter.label {
            syntax = syntax.with(\.firstName, 
                prepareStartToken(makeIdentifier(label))
                    .withTrailingSpace()
            )
            syntax = syntax.with(\.secondName, makeIdentifier(parameter.name))
        } else {
            syntax = syntax.with(\.firstName, 
                prepareStartToken(.wildcardToken())
                    .withTrailingSpace()
            )
            syntax = syntax.with(\.secondName, makeIdentifier(parameter.name))
        }
        
        syntax = syntax.with(\.colon, .colonToken().withTrailingSpace())
        
        syntax = syntax.with(\.type, SwiftTypeConverter.makeTypeSyntax(parameter.type, startTokenHandler: self))

        if parameter.isVariadic {
            syntax = syntax.with(\.ellipsis, .ellipsisToken())
        }
        
        if withTrailingComma {
            syntax = syntax.with(\.trailingComma, 
                .commaToken().withTrailingSpace()
            )
        }

        return syntax
    }
    
    func generateFunctionBody(_ body: FunctionBodyIntention) -> CodeBlockSyntax {
        generateCompound(body.body)
    }
    
    func generateEmptyFunctionBody() -> CodeBlockSyntax {
        let syntax = CodeBlockSyntax(
            leftBrace: prepareStartToken(.leftBraceToken()),
            statements: [],
            rightBrace: .rightBraceToken().onNewline().addingLeadingTrivia(indentation())
        )

        return syntax
    }
    
    func generateAttributeListSyntax<S: Sequence>(
        _ attributes: S
    ) -> AttributeListSyntax where S.Element == KnownAttribute {

        let items = attributes.map(generateAttributeSyntax)
        let syntax = AttributeListSyntax(items)

        return syntax
    }
    
    func generateAttributeSyntax(_ attribute: KnownAttribute) -> AttributeListSyntax.Element {
        let syntax: AttributeListSyntax.Element
        let atSignToken = prepareStartToken(TokenSyntax.atSignToken())
        let attributeNameSyntax = IdentifierTypeSyntax(name: makeIdentifier(attribute.name))

        // TODO: Actually use balanced tokens to do attribute parameters
        if let parameters = attribute.parameters {
            let expString = "(\(parameters))"

            let argumentList = LabeledExprListSyntax([
                //.init(expression: .init(stringLiteral: "(\(parameters))"))
            ])

            let _argList = ExprSyntax(stringLiteral: expString)

            let temp: AttributeSyntax = "@a\(raw: expString)"

            syntax = .attribute(AttributeSyntax(
                atSignToken: atSignToken,
                attributeName: attributeNameSyntax,
                leftParen: .leftParenToken(),
                argument: temp.arguments,
                rightParen: .rightParenToken()
            ))
        } else {
            syntax = .attribute(AttributeSyntax(
                atSignToken: atSignToken,
                attributeName: attributeNameSyntax
            ))
        }

        return syntax
    }
}

// MARK: - General/commons

// MARK: TokenSyntax

func makeIdentifier(_ identifier: String) -> TokenSyntax {
    .identifier(identifier)
}

func makeIdentifierExpr(_ identifier: String) -> DeclReferenceExprSyntax {
    .init(baseName: makeIdentifier(identifier))
}

func makeIdentifierType(_ identifier: String) -> IdentifierTypeSyntax {
    .init(name: makeIdentifier(identifier))
}

func iterateWithComma<T>(_ elements: T, do block: (T.Element, Bool) -> Void) where T: Collection {
    for (i, item) in elements.enumerated() {
        block(item, i < elements.count - 1)
    }
}

func mapWithComma<T, U>(_ elements: T, do block: (T.Element, Bool) -> U) -> [U] where T: Collection {
    elements.enumerated().map { block($1, $0 < elements.count - 1) }
}

extension SyntaxProtocol {
    func withExtraLeading(from producer: SwiftSyntaxProducer) -> Self {
        withExtraLeading(consuming: &producer.extraLeading)
    }
}
