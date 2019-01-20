import SwiftSyntax
import Intentions
import SwiftAST
import KnownType

public class SwiftSyntaxProducer {
    var indentationMode: TriviaPiece = .spaces(4)
    var indentationLevel: Int = 0
    
    var didModifyExtraLeading = false
    var extraLeading: Trivia? {
        didSet {
            didModifyExtraLeading = true
        }
    }
    
    var settings: Settings
    weak var delegate: SwiftSyntaxProducerDelegate?
    
    let modifiersDecorations =
        ModifiersSyntaxDecoratorApplier
            .makeDefaultDecoratorApplier()
    
    public init() {
        settings = .default
    }
    
    public init(settings: Settings, delegate: SwiftSyntaxProducerDelegate? = nil) {
        self.settings = settings
        self.delegate = delegate
    }
    
    func indentation() -> Trivia {
        return Trivia(pieces: Array(repeating: indentationMode, count: indentationLevel))
    }
    
    func indent() {
        indentationLevel += 1
    }
    func deindent() {
        indentationLevel -= 1
    }
    
    func addExtraLeading(_ trivia: Trivia) {
        if let lead = extraLeading {
            extraLeading = lead + trivia
        } else {
            extraLeading = trivia
        }
    }
    
    public struct Settings {
        /// Default settings instance
        public static let `default` = Settings()
        
        /// If `true`, when outputting expression statements, print the resulting type
        /// of the expression before the expression statement as a comment for inspection.
        public var outputExpressionTypes: Bool
        
        /// If `true`, when outputting final intentions, print any history information
        /// tracked on its `IntentionHistory` property before the intention's declaration
        /// as a comment for inspection.
        public var printIntentionHistory: Bool
        
        /// If `true`, `@objc` attributes and `: NSObject` are emitted for declarations
        /// during output.
        ///
        /// This may increase compatibility with previous Objective-C code when compiled
        /// and executed.
        public var emitObjcCompatibility: Bool
        
        public init(outputExpressionTypes: Bool = false,
                    printIntentionHistory: Bool = false,
                    emitObjcCompatibility: Bool = false) {
            
            self.outputExpressionTypes = outputExpressionTypes
            self.printIntentionHistory = printIntentionHistory
            self.emitObjcCompatibility = emitObjcCompatibility
        }
    }
}

// MARK: - Identation
extension SwiftSyntaxProducer {
    func addHistoryTrackingLeadingIfEnabled(_ intention: IntentionProtocol) {
        if !settings.printIntentionHistory {
            return
        }
        
        for entry in intention.history.entries {
            addExtraLeading(.lineComment("// \(entry.summary)"))
            addExtraLeading(.newlines(1) + indentation())
        }
    }
    
    public func generateFile(_ file: FileGenerationIntention) -> SourceFileSyntax {
        return SourceFileSyntax { builder in
            
            if let headerTrivia = generatePreprocessorDirectivesTrivia(file) {
                addExtraLeading(headerTrivia)
                addExtraLeading(.newlines(1))
            }
            
            didModifyExtraLeading = false
            
            iterateWithBlankLineAfter(file.typealiasIntentions) { intention in
                let syntax = generateTypealias(intention)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
                
                addExtraLeading(.newlines(1))
            }
            
            iterateWithBlankLineAfter(file.globalVariableIntentions) { variable in
                let syntax = generateGlobalVariable(variable)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
                
                addExtraLeading(.newlines(1))
            }
            
            iterateWithBlankLineAfter(file.globalFunctionIntentions) { function in
                let syntax = generateFunction(function)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
            }
            
            iterateWithBlankLineAfter(file.protocolIntentions) { _protocol in
                let syntax = generateProtocol(_protocol)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
            }
            
            iterateWithBlankLineAfter(file.structIntentions) { _struct in
                let syntax = generateStruct(_struct)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
            }
            
            iterateWithBlankLineAfter(file.classIntentions) { _class in
                let syntax = generateClass(_class)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
            }
            
            iterateWithBlankLineAfter(file.extensionIntentions) { _class in
                let syntax = generateExtension(_class)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
            }
            
            // Noone consumed the leading trivia - emit a dummy token just so we
            // can have a file with preprocessor directives in place
            if !didModifyExtraLeading {
                let item = CodeBlockItemSyntax { builder in
                    builder.useItem(SyntaxFactory
                        .makeToken(TokenKind.identifier(""),
                                   presence: .present)
                        .withExtraLeading(consuming: &extraLeading)
                    )
                }
                
                builder.addCodeBlockItem(item)
            }
        }
    }
    
    func generatePreprocessorDirectivesTrivia(_ file: FileGenerationIntention) -> Trivia? {
        if file.preprocessorDirectives.isEmpty {
            return nil
        }
        
        var trivia: Trivia = .lineComment("// Preprocessor directives found in file:")
        
        for directive in file.preprocessorDirectives {
            trivia = trivia + .newlines(1) + .lineComment("// \(directive)")
        }
        
        return trivia
    }
}

// MARK: - Typealias Intention
extension SwiftSyntaxProducer {
    func generateTypealias(_ intention: TypealiasIntention) -> TypealiasDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return TypealiasDeclSyntax { builder in
            builder.useTypealiasKeyword(makeStartToken(SyntaxFactory.makeTypealiasKeyword).withTrailingSpace())
            builder.useIdentifier(makeIdentifier(intention.name))
            builder.useInitializer(TypeInitializerClauseSyntax { builder in
                builder.useEqual(SyntaxFactory.makeEqualToken().addingSurroundingSpaces())
                builder.useValue(makeTypeSyntax(intention.fromType))
            })
        }
    }
}

// MARK: - Extension Generation
extension SwiftSyntaxProducer {
    
    func generateExtension(_ intention: ClassExtensionGenerationIntention) -> ExtensionDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return ExtensionDeclSyntax { builder in
            addExtraLeading(indentation())
            
            if let categoryName = intention.categoryName, !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                addExtraLeading(.lineComment("// MARK: - \(categoryName)"))
            } else {
                addExtraLeading(.lineComment("// MARK: -"))
            }
            
            addExtraLeading(.newlines(1) + indentation())
            
            builder.useExtensionKeyword(
                makeStartToken(SyntaxFactory.makeExtensionKeyword).addingTrailingSpace())
            
            builder.useExtendedType(
                makeTypeSyntax(.typeName(intention.typeName))
            )
            
            addExtraLeading(.spaces(1))
            
            if let inheritanceClause = generateInheritanceClause(intention) {
                builder.useInheritanceClause(inheritanceClause)
            }
            
            indent()
            
            let members = generateMembers(intention)
            
            deindent()
            
            builder.useMembers(members)
        }
    }
}

// MARK: - Class Generation
extension SwiftSyntaxProducer {
    func generateClass(_ intention: ClassGenerationIntention) -> ClassDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return ClassDeclSyntax { builder in
            addExtraLeading(indentation())
            
            builder.useClassKeyword(
                makeStartToken(SyntaxFactory.makeClassKeyword).addingTrailingSpace())
            
            let identifier = makeIdentifier(intention.typeName)
            
            if let inheritanceClause = generateInheritanceClause(intention) {
                builder.useIdentifier(identifier)
                
                builder.useInheritanceClause(inheritanceClause)
            } else {
                builder.useIdentifier(identifier.withTrailingSpace())
            }
            
            indent()
            
            let members = generateMembers(intention)
            
            deindent()
            
            builder.useMembers(members)
        }
    }
    
    public func generateInheritanceClause(_ type: KnownType) -> TypeInheritanceClauseSyntax? {
        var inheritances: [String] = []
        if let supertype = type.supertype?.asTypeName {
            inheritances.append(supertype)
        }
        inheritances.append(contentsOf:
            type.knownProtocolConformances.map { $0.protocolName }
        )
        
        if inheritances.isEmpty {
            return nil
        }
        
        return TypeInheritanceClauseSyntax { builder in
            builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
            
            for (i, inheritance) in inheritances.enumerated() {
                let type = InheritedTypeSyntax { builder in
                    var identifier = makeIdentifier(inheritance)
                    
                    if i != inheritances.count - 1 {
                        builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
                    } else {
                        identifier = identifier.withTrailingSpace()
                    }
                    
                    builder.useTypeName(SyntaxFactory
                        .makeSimpleTypeIdentifier(
                            name: identifier,
                            genericArgumentClause: nil
                        )
                    )
                }
                
                builder.addInheritedType(type)
            }
        }
    }
}

// MARK: - Struct generation
extension SwiftSyntaxProducer {
    func generateStruct(_ intention: StructGenerationIntention) -> StructDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return StructDeclSyntax { builder in
            addExtraLeading(indentation())
            
            builder.useStructKeyword(
                makeStartToken(SyntaxFactory.makeStructKeyword)
                    .addingTrailingSpace())
            
            let identifier = makeIdentifier(intention.typeName)
            
            if let inheritanceClause = generateInheritanceClause(intention) {
                builder.useIdentifier(identifier)
                
                builder.useInheritanceClause(inheritanceClause)
            } else {
                builder.useIdentifier(identifier.withTrailingSpace())
            }
            
            indent()
            
            let members = generateMembers(intention)
            
            deindent()
            
            builder.useMembers(members)
        }
    }
}

// MARK: - Protocol generation
extension SwiftSyntaxProducer {
    func generateProtocol(_ intention: ProtocolGenerationIntention) -> ProtocolDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return ProtocolDeclSyntax.init { builder in
            addExtraLeading(indentation())
            
            builder.useProtocolKeyword(
                makeStartToken(SyntaxFactory.makeProtocolKeyword).addingTrailingSpace())
            
            let identifier = makeIdentifier(intention.typeName)
            
            if let inheritanceClause = generateInheritanceClause(intention) {
                builder.useIdentifier(identifier)
                
                builder.useInheritanceClause(inheritanceClause)
            } else {
                builder.useIdentifier(identifier.withTrailingSpace())
            }
            
            indent()
            defer {
                deindent()
            }
            
            builder.useMembers(generateMembers(intention))
        }
    }
}

// MARK: - Type member generation
extension SwiftSyntaxProducer {
    func generateMembers(_ intention: TypeGenerationIntention) -> MemberDeclBlockSyntax {
        return MemberDeclBlockSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline())
            
            addExtraLeading(.newlines(1))
            
            // TODO: Probably shouldn't detect ivar containers like this.
            if let ivarHolder = intention as? InstanceVariableContainerIntention {
                iterateWithBlankLineAfter(ivarHolder.instanceVariables) { ivar in
                    addExtraLeading(indentation())
                    
                    builder.addDecl(generateInstanceVariable(ivar))
                    
                    addExtraLeading(.newlines(1))
                }
                
                if !intention.properties.isEmpty {
                    extraLeading = .newlines(1)
                }
            }
            
            iterateWithBlankLineAfter(intention.properties) { prop in
                addExtraLeading(indentation())
                
                builder.addDecl(generateProperty(prop))
                
                addExtraLeading(.newlines(1))
            }
            
            iterateWithBlankLineAfter(intention.constructors) { _init in
                addExtraLeading(indentation())
                
                builder.addDecl(generateInitializer(_init))
                
                addExtraLeading(.newlines(1))
            }
            
            iterateWithBlankLineAfter(intention.methods) { method in
                addExtraLeading(indentation())
                
                builder.addDecl(generateFunction(method))
                
                addExtraLeading(.newlines(1))
            }
        }
    }
    
    private func modifiers(for intention: IntentionProtocol) -> [DeclModifierSyntax] {
        return modifiersDecorations.modifiers(for: intention, extraLeading: &extraLeading)
    }
}

// MARK: - Variable/property syntax
extension SwiftSyntaxProducer {
    
    private func _initialValue(for intention: ValueStorageIntention) -> Expression? {
        if let intention = intention.initialValue {
            return intention
        }
        
        return delegate?.swiftSyntaxProducer(self, initialValueFor: intention)
    }
    
    func generateInstanceVariable(_ intention: InstanceVariableGenerationIntention) -> DeclSyntax {
        return generateVariableDecl(intention)
    }
    
    func generateProperty(_ intention: PropertyGenerationIntention) -> DeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return generateVariableDecl(name: intention.name,
                                    storage: intention.storage,
                                    attributes: intention.knownAttributes,
                                    intention: intention,
                                    modifiers: modifiers(for: intention),
                                    accessor: makeAccessorBlockCreator(intention),
                                    initialization: _initialValue(for: intention))
    }
    
    func generateVariableDecl(_ intention: ValueStorageIntention & MemberGenerationIntention) -> DeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return generateVariableDecl(name: intention.name,
                                    storage: intention.storage,
                                    attributes: intention.knownAttributes,
                                    intention: intention,
                                    modifiers: modifiers(for: intention),
                                    initialization: _initialValue(for: intention))
    }
    
    func generateGlobalVariable(_ intention: GlobalVariableGenerationIntention) -> DeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return generateVariableDecl(name: intention.name,
                                    storage: intention.storage,
                                    attributes: [],
                                    intention: intention,
                                    modifiers: modifiers(for: intention),
                                    initialization: _initialValue(for: intention))
    }
    
    func generateVariableDecl(name: String,
                              storage: ValueStorage,
                              attributes: [KnownAttribute],
                              intention: Intention?,
                              modifiers: [DeclModifierSyntax],
                              accessor: (() -> AccessorBlockSyntax)? = nil,
                              initialization: Expression? = nil) -> VariableDeclSyntax {
        
        return VariableDeclSyntax { builder in
            for attribute in attributes {
                builder.addAttribute(generateAttributeSyntax(attribute))
            }
            
            for modifier in modifiers {
                builder.addModifier(modifier)
            }
            
            let letOrVar =
                storage.isConstant
                    ? SyntaxFactory.makeLetKeyword
                    : SyntaxFactory.makeVarKeyword
            
            builder.useLetOrVarKeyword(makeStartToken(letOrVar).addingTrailingSpace())
            
            builder.addPatternBinding(PatternBindingSyntax { builder in
                builder.usePattern(IdentifierPatternSyntax { builder in
                    builder.useIdentifier(makeIdentifier(name))
                })
                
                if delegate?.swiftSyntaxProducer(self,
                                                 shouldEmitTypeFor: storage,
                                                 intention: intention,
                                                 initialValue: initialization) != false {
                    
                    builder.useTypeAnnotation(TypeAnnotationSyntax { builder in
                        builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                        builder.useType(makeTypeSyntax(storage.type))
                    })
                }
                
                if let accessor = accessor {
                    builder.useAccessor(accessor())
                }
                
                if let initialization = initialization {
                    builder.useInitializer(InitializerClauseSyntax { builder in
                        builder.useEqual(SyntaxFactory.makeEqualToken().withLeadingSpace().withTrailingSpace())
                        builder.useValue(generateExpression(initialization))
                    })
                }
            })
        }
    }
    
    private func makeAccessorBlockCreator(_ property: PropertyGenerationIntention) -> (() -> AccessorBlockSyntax)? {
        switch property.mode {
        case .asField:
            return nil
            
        case .computed(let body):
            return {
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(self.makeStartToken(SyntaxFactory.makeLeftBraceToken).withLeadingSpace())
                    
                    self.indent()
                    let blocks = self._generateStatements(body.body.statements)
                    self.deindent()
                    
                    let stmtList = SyntaxFactory.makeCodeBlockItemList(blocks)
                    
                    builder.useAccessorListOrStmtList(stmtList)
                    
                    self.addExtraLeading(.newlines(1) + self.indentation())
                    builder.useRightBrace(self.makeStartToken(SyntaxFactory.makeRightBraceToken))
                }
            }
            
        case let .property(get, set):
            return {
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(self.makeStartToken(SyntaxFactory.makeLeftBraceToken).withLeadingSpace())
                    
                    self.indent()
                    
                    self.addExtraLeading(.newlines(1) + self.indentation())
                    
                    let getter = AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            self.prepareStartToken(
                                SyntaxFactory
                                    .makeToken(.contextualKeyword("get"),
                                               presence: .present)
                            )
                        )
                        
                        builder.useBody(self.generateFunctionBody(get))
                    }
                    
                    self.addExtraLeading(.newlines(1) + self.indentation())
                    
                    let setter = AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            self.prepareStartToken(
                                SyntaxFactory
                                    .makeToken(.contextualKeyword("set"),
                                               presence: .present)
                            )
                        )
                        
                        if set.valueIdentifier != "newValue" {
                            builder.useParameter(AccessorParameterSyntax { builder in
                                builder.useLeftParen(self.makeStartToken(SyntaxFactory.makeLeftParenToken))
                                builder.useName(makeIdentifier(set.valueIdentifier))
                                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                            })
                        }
                        
                        builder.useBody(self.generateFunctionBody(set.body))
                    }
                    
                    self.deindent()
                    
                    let accessorList = SyntaxFactory.makeAccessorList([getter, setter])
                    
                    builder.useAccessorListOrStmtList(accessorList)
                    
                    self.addExtraLeading(.newlines(1) + self.indentation())
                    builder.useRightBrace(self.makeStartToken(SyntaxFactory.makeRightBraceToken))
                }
            }
        }
    }
}

// MARK: - Function syntax
extension SwiftSyntaxProducer {
    
    func generateInitializer(_ intention: InitGenerationIntention) -> DeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return InitializerDeclSyntax { builder in
            let modifiers = self.modifiers(for: intention)
            
            for modifier in modifiers {
                builder.addModifier(modifier)
            }
            
            builder.useInitKeyword(makeStartToken(SyntaxFactory.makeInitKeyword))
            
            if intention.isFailable {
                builder.useOptionalMark(SyntaxFactory.makeInfixQuestionMarkToken())
            }
            
            builder.useParameters(generateParameterList(intention.parameters))
            
            if let body = intention.functionBody {
                builder.useBody(generateFunctionBody(body))
            }
        }
    }
    
    func generateFunction(_ intention: SignatureFunctionIntention) -> FunctionDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return FunctionDeclSyntax { builder in
            let modifiers = self.modifiers(for: intention)
            
            for modifier in modifiers {
                builder.addModifier(modifier)
            }
            
            builder.useFuncKeyword(makeStartToken(SyntaxFactory.makeFuncKeyword).addingTrailingSpace())
            builder.useSignature(generateSignature(intention.signature))
            builder.useIdentifier(makeIdentifier(intention.signature.name))
            
            if let body = intention.functionBody {
                builder.useBody(generateFunctionBody(body))
            } else {
                builder.useBody(generateEmptyFunctionBody())
            }
        }
    }
    
    func generateSignature(_ signature: FunctionSignature) -> FunctionSignatureSyntax {
        return FunctionSignatureSyntax { builder in
            builder.useInput(generateParameterList(signature.parameters))
            
            if signature.returnType != .void {
                builder.useOutput(generateReturn(signature.returnType))
            }
        }
    }
    
    func generateReturn(_ ret: SwiftType) -> ReturnClauseSyntax {
        return ReturnClauseSyntax { builder in
            builder.useArrow(SyntaxFactory.makeArrowToken().addingLeadingSpace().addingTrailingSpace())
            builder.useReturnType(makeTypeSyntax(ret))
        }
    }
    
    func generateParameterList(_ parameters: [ParameterSignature]) -> ParameterClauseSyntax {
        return ParameterClauseSyntax { builder in
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            iterateWithComma(parameters) { (item, hasComma) in
                builder.addFunctionParameter(
                    generateParameter(item, withTrailingComma: hasComma)
                )
            }
        }
    }
    
    func generateParameter(_ parameter: ParameterSignature,
                           withTrailingComma: Bool) -> FunctionParameterSyntax {
        
        return FunctionParameterSyntax { builder in
            if parameter.label == parameter.name {
                builder.useFirstName(prepareStartToken(makeIdentifier(parameter.name)))
            } else if parameter.label == nil {
                builder.useFirstName(prepareStartToken(SyntaxFactory.makeWildcardKeyword()).withTrailingSpace())
                builder.useSecondName(makeIdentifier(parameter.name))
            }
            
            builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
            
            builder.useType(makeTypeSyntax(parameter.type))
            
            if withTrailingComma {
                builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
            }
        }
    }
    
    func generateFunctionBody(_ body: FunctionBodyIntention) -> CodeBlockSyntax {
        return generateCompound(body.body)
    }
    
    func generateEmptyFunctionBody() -> CodeBlockSyntax {
        return CodeBlockSyntax { builder in
            builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken().withLeadingSpace())
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline().addingLeadingTrivia(indentation()))
        }
    }
    
    func generateAttributeListSyntax<S: Sequence>(_ attributes: S) -> AttributeListSyntax where S.Element == KnownAttribute {
        return SyntaxFactory.makeAttributeList(attributes.map(generateAttributeSyntax))
    }
    
    func generateAttributeSyntax(_ attribute: KnownAttribute) -> AttributeSyntax {
        return SyntaxFactory
            .makeAttribute(
                atSignToken: prepareStartToken(SyntaxFactory.makeAtSignToken()),
                attributeName: makeIdentifier(attribute.name),
                balancedTokens: SyntaxFactory.makeTokenList(attribute.parameters.map { [SyntaxFactory.makeIdentifier($0)] } ?? [])
        )
    }
}

// MARK: - Utilities
extension SwiftSyntaxProducer {
    
    func makeStartToken(_ builder: (_ leading: Trivia, _ trailing: Trivia) -> TokenSyntax) -> TokenSyntax {
        return prepareStartToken(builder([], []))
    }
    
    func prepareStartToken(_ token: TokenSyntax) -> TokenSyntax {
        return token.withExtraLeading(consuming: &extraLeading)
    }
    
    func iterateWithBlankLineAfter<T>(_ elements: [T],
                                      postSeparator: Trivia = .newlines(2),
                                      do block: (T) -> Void) {
        
        for item in elements {
            block(item)
        }
        
        if !elements.isEmpty {
            extraLeading = postSeparator
        }
    }
}

// MARK: - General/commons
func makeIdentifier(_ identifier: String) -> TokenSyntax {
    return SyntaxFactory.makeIdentifier(identifier)
}

func makeTypeSyntax(_ type: SwiftType) -> TypeSyntax {
    switch type {
    case .nominal(let nominal):
        return makeNominalTypeSyntax(nominal)
        
    case .implicitUnwrappedOptional(let type),
         .nullabilityUnspecified(let type):
        return SyntaxFactory
            .makeImplicitlyUnwrappedOptionalType(
                wrappedType: makeTypeSyntax(type),
                exclamationMark: SyntaxFactory.makeExclamationMarkToken()
            )
        
    case .optional(let type):
        return SyntaxFactory
            .makeOptionalType(
                wrappedType: makeTypeSyntax(type),
                questionMark: SyntaxFactory.makePostfixQuestionMarkToken()
            )
        
    case .metatype(let type):
        return SyntaxFactory
            .makeMetatypeType(
                baseType: makeTypeSyntax(type),
                period: SyntaxFactory.makePeriodToken(),
                typeOrProtocol: SyntaxFactory.makeTypeToken()
            )
        
    case .nested(let nested):
        
        return makeNestedTypeSyntax(nested)
        
    case let .block(returnType, parameters, attributes):
        let attributes = attributes.sorted(by: { $0.description < $1.description })
        
        return AttributedTypeSyntax { builder in
            let functionType = FunctionTypeSyntax { builder in
                builder.useArrow(SyntaxFactory.makeArrowToken().addingSurroundingSpaces())
                builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                builder.useReturnType(makeTypeSyntax(returnType))
                
                // Parameters
                makeTupleTypeSyntax(parameters)
                    .elements
                    .forEach { builder.addTupleTypeElement($0) }
            }
            
            builder.useBaseType(functionType)
            
            for attribute in attributes {
                switch attribute {
                case .autoclosure:
                    builder.addAttribute(SyntaxFactory
                        .makeAttribute(
                            atSignToken: SyntaxFactory.makeAtSignToken(),
                            attributeName: makeIdentifier("autoclosure"),
                            balancedTokens: SyntaxFactory.makeBlankTokenList()
                        )
                    )
                    
                case .escaping:
                    builder.addAttribute(SyntaxFactory
                        .makeAttribute(
                            atSignToken: SyntaxFactory.makeAtSignToken(),
                            attributeName: makeIdentifier("escaping"),
                            balancedTokens: SyntaxFactory.makeBlankTokenList()
                        )
                    )
                    
                case .convention(let convention):
                    builder.addAttribute(SyntaxFactory
                        .makeAttribute(
                            atSignToken: SyntaxFactory.makeAtSignToken(),
                            attributeName: makeIdentifier("convention"),
                            balancedTokens: SyntaxFactory.makeTokenList([
                                SyntaxFactory.makeLeftParenToken(),
                                makeIdentifier(convention.rawValue),
                                SyntaxFactory.makeRightParenToken().withTrailingSpace()
                            ])
                        )
                    )
                }
            }
        }
        
    case .tuple(let tuple):
        switch tuple {
        case .types(let types):
            return makeTupleTypeSyntax(types)
            
        case .empty:
            return SyntaxFactory.makeTypeIdentifier("Void")
        }
        
    case .protocolComposition(let composition):
        return CompositionTypeSyntax { builder in
            let count = composition.count
            
            for (i, type) in composition.enumerated() {
                builder.addCompositionTypeElement(CompositionTypeElementSyntax { builder in
                    
                    switch type {
                    case .nested(let nested):
                        builder.useType(makeNestedTypeSyntax(nested))
                        
                    case .nominal(let nominal):
                        builder.useType(makeNominalTypeSyntax(nominal))
                    }
                    
                    if i != count - 1 {
                        builder.useAmpersand(SyntaxFactory.makePrefixAmpersandToken())
                    }
                })
            }
        }
    }
}

func makeTupleTypeSyntax<C: Collection>(_ types: C) -> TupleTypeSyntax where C.Element == SwiftType {
    return TupleTypeSyntax { builder in
        iterateWithComma(types) { (type, hasComma) in
            builder.addTupleTypeElement(TupleTypeElementSyntax { builder in
                builder.useType(makeTypeSyntax(type))
                
                if hasComma {
                    builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
                }
            })
        }
    }
}

func makeNestedTypeSyntax(_ nestedType: NestedSwiftType) -> MemberTypeIdentifierSyntax {
    
    let produce: (MemberTypeIdentifierSyntax, NominalSwiftType) -> MemberTypeIdentifierSyntax = { (previous, type) in
        let typeSyntax = makeNominalTypeSyntax(type)
        
        return SyntaxFactory
            .makeMemberTypeIdentifier(
                baseType: previous,
                period: SyntaxFactory.makePeriodToken(),
                name: typeSyntax.name,
                genericArgumentClause: typeSyntax.genericArgumentClause
        )
    }
    
    let typeSyntax = makeNominalTypeSyntax(nestedType.second)
    
    let initial = SyntaxFactory
        .makeMemberTypeIdentifier(
            baseType: makeNominalTypeSyntax(nestedType.first),
            period: SyntaxFactory.makePeriodToken(),
            name: typeSyntax.name,
            genericArgumentClause: typeSyntax.genericArgumentClause
        )
    
    return nestedType.reduce(initial, produce)
}

func makeNominalTypeSyntax(_ nominal: NominalSwiftType) -> SimpleTypeIdentifierSyntax {
    switch nominal {
    case .typeName(let name):
        return SyntaxFactory
            .makeSimpleTypeIdentifier(
                name: SyntaxFactory.makeIdentifier(name),
                genericArgumentClause: nil
            )
        
    case let .generic(name, parameters):
        let types = parameters.map(makeTypeSyntax)
        
        let genericArgumentList =
            SyntaxFactory
                .makeGenericArgumentList(types.enumerated().map {
                    let (index, type) = $0
                    
                    return SyntaxFactory
                        .makeGenericArgument(
                            argumentType: type,
                            trailingComma: index == types.count - 1 ? nil : SyntaxFactory.makeCommaToken()
                        )
                })
        
        let genericArgumentClause = SyntaxFactory
            .makeGenericArgumentClause(
                leftAngleBracket: SyntaxFactory.makeLeftAngleToken(),
                arguments: genericArgumentList,
                rightAngleBracket: SyntaxFactory.makeRightAngleToken()
            )
        
        return SyntaxFactory.makeSimpleTypeIdentifier(
            name: SyntaxFactory.makeIdentifier(name),
            genericArgumentClause: genericArgumentClause
        )
    }
}

func iterateWithComma<T>(_ elements: T,
                         postSeparator: Trivia = .newlines(1),
                         do block: (T.Element, Bool) -> Void) where T: Collection {
    
    for (i, item) in elements.enumerated() {
        block(item, i < elements.count - 1)
    }
}

extension TokenSyntax {
    func withExtraLeading(consuming trivia: inout Trivia?) -> TokenSyntax {
        if let t = trivia {
            trivia = nil
            return withLeadingTrivia(t + leadingTrivia)
        }
        
        return self
    }
    func withLeadingSpace(count: Int = 1) -> TokenSyntax {
        return withLeadingTrivia(.spaces(count))
    }
    
    func withTrailingSpace(count: Int = 1) -> TokenSyntax {
        return withTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingSpace(count: Int = 1) -> TokenSyntax {
        return addingLeadingTrivia(.spaces(count))
    }
    
    func addingTrailingSpace(count: Int = 1) -> TokenSyntax {
        return addingTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingTrivia(_ trivia: Trivia) -> TokenSyntax {
        return withLeadingTrivia(leadingTrivia + trivia)
    }
    
    func addingTrailingTrivia(_ trivia: Trivia) -> TokenSyntax {
        return withTrailingTrivia(trailingTrivia + trivia)
    }
    
    func addingSurroundingSpaces() -> TokenSyntax {
        return addingLeadingSpace().addingTrailingSpace()
    }
    
    func onNewline() -> TokenSyntax {
        return withLeadingTrivia(.newlines(1))
    }
}
