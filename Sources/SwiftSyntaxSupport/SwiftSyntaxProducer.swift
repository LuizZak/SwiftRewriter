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
    // in case a file with just import directive comments is encountered.
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
        public static let `default` = Settings()
        
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
        
        public init(outputExpressionTypes: Bool = false,
                    printIntentionHistory: Bool = false,
                    emitObjcCompatibility: Bool = false) {
            
            self.outputExpressionTypes = outputExpressionTypes
            self.printIntentionHistory = printIntentionHistory
            self.emitObjcCompatibility = emitObjcCompatibility
        }
    }
    
    func modifiers(for intention: IntentionProtocol) -> ModifiersDecoratorResult {
        modifiersDecorations.modifiers(for: intention)
    }
    
    func modifiers(for decl: StatementVariableDeclaration) -> ModifiersDecoratorResult {
        modifiersDecorations.modifiers(for: decl)
    }
    
    func attributes(for intention: IntentionProtocol,
                    inline: Bool) -> [() -> AttributeSyntax] {
        
        guard let attributable = intention as? AttributeTaggeableObject else {
            return []
        }
        
        var attributes = attributable.knownAttributes
        
        // TODO: This should not be done here, but in an IntentionPass
        if shouldEmitObjcAttribute(intention) {
            attributes.append(KnownAttribute(name: "objc"))
        }
        
        var attributeSyntaxes: [() -> AttributeSyntax] = []
        
        for attr in attributes {
            let attrSyntax: () -> AttributeSyntax = {
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
                if _protocol.methods.any({ $0.optional })
                    || _protocol.properties.any({ $0.optional }) {
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
        if let method = intention as? MethodGenerationIntention {
            if !isDeallocMethod(method) {
                return true
            }
        }
        if let type = intention as? TypeGenerationIntention,
            type.kind != .struct {
            return true
        }
        
        return false
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
    
    private func isDeallocMethod(_ intention: MethodGenerationIntention) -> Bool {
        intention.name == "dealloc" && intention.parameters.count == 0
    }
}

// MARK: - File generation
extension SwiftSyntaxProducer {
    
    /// Generates a source file syntax from a given file generation intention.
    public func generateFile(_ file: FileGenerationIntention) -> SourceFileSyntax {
        SourceFileSyntax { builder in
            
            // Imports come before any header #directive comments
            iterating(file.knownImportDirectives) { module in
                let syntax = generateImport(module)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            var hasHeaderTrivia: Bool = false
            if let headerTrivia = generatePreprocessorDirectivesTrivia(file) {
                hasHeaderTrivia = true
                addExtraLeading(headerTrivia)
                addExtraLeading(.newlines(1))
            }
            
            didModifyExtraLeading = false
            
            iterating(file.typealiasIntentions) { intention in
                let syntax = generateTypealias(intention)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.enumIntentions) { intention in
                let syntax = generateEnum(intention)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.structIntentions) { _struct in
                let syntax = generateStruct(_struct)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.globalVariableIntentions) { variable in
                let syntax = varDeclGenerator.generateGlobalVariable(variable)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.globalFunctionIntentions) { function in
                let syntax = generateFunction(function, alwaysEmitBody: true)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.protocolIntentions) { _protocol in
                let syntax = generateProtocol(_protocol)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.classIntentions) { _class in
                let syntax = generateClass(_class)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            iterating(file.extensionIntentions) { _class in
                let syntax = generateExtension(_class)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addStatement(codeBlock)
            }
            
            // Noone consumed the leading trivia - emit a dummy token just so we
            // can have a file with preprocessor directives in place
            if !didModifyExtraLeading && hasHeaderTrivia {
                let item = CodeBlockItemSyntax { builder in
                    builder.useItem(SyntaxFactory
                        .makeToken(TokenKind.identifier(""),
                                   presence: .present)
                        .withExtraLeading(consuming: &extraLeading)
                    )
                }
                
                builder.addStatement(item)
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

// MARK: - Import declarations
extension SwiftSyntaxProducer {
    func generateImport(_ module: String) -> ImportDeclSyntax {
        ImportDeclSyntax { builder in
            builder.useImportTok(makeStartToken(SyntaxFactory.makeImportKeyword).withTrailingSpace())
            builder.addPathComponent(AccessPathComponentSyntax { builder in
                builder.useName(makeIdentifier(module))
            })
        }
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
                builder.useValue(SwiftTypeConverter.makeTypeSyntax(intention.fromType))
            })
        }
    }
}

// MARK: - Enum Generation
extension SwiftSyntaxProducer {
    func generateEnum(_ intention: EnumGenerationIntention) -> EnumDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return EnumDeclSyntax { builder in
            addExtraLeading(indentation())
            
            let attributes = self.attributes(for: intention, inline: false)
            
            for attribute in attributes {
                builder.addAttribute(attribute())
            }
            
            builder.useEnumKeyword(makeStartToken(SyntaxFactory.makeEnumKeyword).withTrailingSpace())
            builder.useIdentifier(makeIdentifier(intention.typeName))
            
            addExtraLeading(.spaces(1))
            
            builder.useInheritanceClause(TypeInheritanceClauseSyntax { builder in
                builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                builder.addInheritedType(InheritedTypeSyntax { builder in
                    builder.useTypeName(SwiftTypeConverter.makeTypeSyntax(intention.rawValueType))
                })
            })
            
            indent()
            
            let members = generateMembers(intention)
            
            deindent()
            
            builder.useMembers(members)
        }
    }
    
    func generateEnumCase(_ _case: EnumCaseGenerationIntention) -> EnumCaseDeclSyntax {
        EnumCaseDeclSyntax { builder in
            builder.useCaseKeyword(makeStartToken(SyntaxFactory.makeCaseKeyword).withTrailingSpace())
            
            builder.addElement(EnumCaseElementSyntax { builder in
                builder.useIdentifier(makeIdentifier(_case.name))
                
                if let rawValue = _case.expression {
                    builder.useRawValue(InitializerClauseSyntax { builder in
                        builder.useEqual(SyntaxFactory.makeEqualToken().addingSurroundingSpaces())
                        builder.useValue(generateExpression(rawValue))
                    })
                }
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
            
            for attribute in attributes(for: intention, inline: false) {
                builder.addAttribute(attribute())
            }
            for modifier in modifiers(for: intention) {
                builder.addModifier(modifier(self))
            }
            
            builder.useExtensionKeyword(
                makeStartToken(SyntaxFactory.makeExtensionKeyword).addingTrailingSpace())
            
            builder.useExtendedType(
                SwiftTypeConverter.makeTypeSyntax(.typeName(intention.typeName))
            )
            
            if let inheritanceClause = generateInheritanceClause(intention) {
                builder.useInheritanceClause(inheritanceClause)
            } else {
                addExtraLeading(.spaces(1))
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
            
            for attribute in attributes(for: intention, inline: false) {
                builder.addAttribute(attribute())
            }
            
            builder.useClassKeyword(
                makeStartToken(SyntaxFactory.makeClassKeyword)
                    .addingTrailingSpace()
            )
            
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
        
        // TODO: This should be done in an intention pass before handing over the
        // types to this swift syntax producer
        var emitObjcAttribute = false
        if let prot = type as? ProtocolGenerationIntention {
            if prot.methods.contains(where: { $0.optional })
                || prot.properties.contains(where: { $0.optional }) {
            
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
            
            let attributes = self.attributes(for: intention, inline: false)
            for attribute in attributes {
                builder.addAttribute(attribute())
            }
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
            
            let attributes = self.attributes(for: intention, inline: false)
            for attribute in attributes {
                builder.addAttribute(attribute())
            }
            
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
        MemberDeclBlockSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline())
            
            addExtraLeading(.newlines(1))
            
            // TODO: Probably shouldn't detect ivar containers like this.
            if let ivarHolder = intention as? InstanceVariableContainerIntention {
                iterating(ivarHolder.instanceVariables) { ivar in
                    addExtraLeading(indentation())
                    
                    builder.addMember(
                        SyntaxFactory.makeMemberDeclListItem(
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
            iterating(intention.properties.compactMap { $0 as? EnumCaseGenerationIntention }) { prop in
                addExtraLeading(indentation())
                
                builder.addMember(
                    SyntaxFactory.makeMemberDeclListItem(
                        decl: generateEnumCase(prop),
                        semicolon: nil
                    )
                )
            }
            // TODO: ...and again...
            iterating(intention.properties.filter { !($0 is EnumCaseGenerationIntention) }) { prop in
                if prop is EnumCaseGenerationIntention {
                    return
                }
                
                addExtraLeading(indentation())
                
                builder.addMember(
                    SyntaxFactory.makeMemberDeclListItem(
                        decl: varDeclGenerator.generateProperty(prop),
                        semicolon: nil
                    )
                )
            }
            
            iterating(intention.constructors) { _init in
                addExtraLeading(indentation())
                
                builder.addMember(
                    SyntaxFactory.makeMemberDeclListItem(
                        decl: generateInitializer(
                            _init,
                            alwaysEmitBody: !(intention is ProtocolGenerationIntention)
                        ),
                        semicolon: nil
                    )
                )
            }
            
            // Dealloc methods are treated differently
            // TODO: Create a separate GenerationIntention entirely for dealloc
            // methods and detect them during SwiftRewriter's parsing with
            // IntentionPass's instead of postponing to here.
            var methods = intention.methods
            let _deinit = methods.first(where: isDeallocMethod)
            methods.removeAll(where: { $0 === _deinit })
            if let _deinit = _deinit {
                addExtraLeading(indentation())
                
                builder.addMember(
                    SyntaxFactory.makeMemberDeclListItem(
                        decl: generateDeinitializer(_deinit),
                        semicolon: nil
                    )
                )
                addExtraLeading(.newlines(2))
            }
            
            iterating(methods) { method in
                addExtraLeading(indentation())
                
                builder.addMember(
                    SyntaxFactory.makeMemberDeclListItem(
                        decl: generateFunction(
                            method,
                            alwaysEmitBody: !(intention is ProtocolGenerationIntention)
                        ),
                        semicolon: nil
                    )
                )
            }
        }
    }
}

// MARK: - Function syntax
extension SwiftSyntaxProducer {
    
    func generateInitializer(_ intention: InitGenerationIntention,
                             alwaysEmitBody: Bool) -> DeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return InitializerDeclSyntax { builder in
            for attribute in attributes(for: intention, inline: false) {
                builder.addAttribute(attribute())
            }
            for modifier in modifiers(for: intention) {
                builder.addModifier(modifier(self))
            }
            
            builder.useInitKeyword(makeStartToken(SyntaxFactory.makeInitKeyword))
            
            if intention.isFailable {
                builder.useOptionalMark(SyntaxFactory.makeInfixQuestionMarkToken())
            }
            
            builder.useParameters(generateParameterList(intention.parameters))
            
            if let body = intention.functionBody {
                builder.useBody(generateFunctionBody(body))
            } else if alwaysEmitBody {
                builder.useBody(generateEmptyFunctionBody())
            }
        }
    }
    
    func generateDeinitializer(_ intention: FunctionIntention) -> DeinitializerDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return DeinitializerDeclSyntax { builder in
            builder.useDeinitKeyword(makeStartToken(SyntaxFactory.makeDeinitKeyword))
            
            if let body = intention.functionBody {
                builder.useBody(generateFunctionBody(body))
            }
        }
    }
    
    func generateFunction(_ intention: SignatureFunctionIntention,
                          alwaysEmitBody: Bool) -> FunctionDeclSyntax {
        addHistoryTrackingLeadingIfEnabled(intention)
        
        return FunctionDeclSyntax { builder in
            for attribute in attributes(for: intention, inline: false) {
                builder.addAttribute(attribute())
            }
            for modifier in modifiers(for: intention) {
                builder.addModifier(modifier(self))
            }
            
            builder.useFuncKeyword(makeStartToken(SyntaxFactory.makeFuncKeyword).addingTrailingSpace())
            builder.useSignature(generateSignature(intention.signature))
            builder.useIdentifier(makeIdentifier(intention.signature.name))
            
            if let body = intention.functionBody {
                builder.useBody(generateFunctionBody(body))
            } else if alwaysEmitBody {
                builder.useBody(generateEmptyFunctionBody())
            }
        }
    }
    
    func generateSignature(_ signature: FunctionSignature) -> FunctionSignatureSyntax {
        FunctionSignatureSyntax { builder in
            builder.useInput(generateParameterList(signature.parameters))
            
            if signature.returnType != .void {
                builder.useOutput(generateReturn(signature.returnType))
            }
        }
    }
    
    func generateReturn(_ ret: SwiftType) -> ReturnClauseSyntax {
        ReturnClauseSyntax { builder in
            builder.useArrow(SyntaxFactory.makeArrowToken().addingLeadingSpace().addingTrailingSpace())
            builder.useReturnType(SwiftTypeConverter.makeTypeSyntax(ret))
        }
    }
    
    func generateParameterList(_ parameters: [ParameterSignature]) -> ParameterClauseSyntax {
        ParameterClauseSyntax { builder in
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            iterateWithComma(parameters) { (item, hasComma) in
                builder.addParameter(
                    generateParameter(item, withTrailingComma: hasComma)
                )
            }
        }
    }
    
    func generateParameter(_ parameter: ParameterSignature,
                           withTrailingComma: Bool) -> FunctionParameterSyntax {
        
        FunctionParameterSyntax { builder in
            if parameter.label == parameter.name {
                builder.useFirstName(prepareStartToken(makeIdentifier(parameter.name)))
            } else if let label = parameter.label {
                builder.useFirstName(prepareStartToken(makeIdentifier(label)).withTrailingSpace())
                builder.useSecondName(makeIdentifier(parameter.name))
            } else {
                builder.useFirstName(prepareStartToken(SyntaxFactory.makeWildcardKeyword()).withTrailingSpace())
                builder.useSecondName(makeIdentifier(parameter.name))
            }
            
            builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
            
            builder.useType(SwiftTypeConverter.makeTypeSyntax(parameter.type))
            
            if withTrailingComma {
                builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
            }
        }
    }
    
    func generateFunctionBody(_ body: FunctionBodyIntention) -> CodeBlockSyntax {
        generateCompound(body.body)
    }
    
    func generateEmptyFunctionBody() -> CodeBlockSyntax {
        CodeBlockSyntax { builder in
            builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken().withLeadingSpace())
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline().addingLeadingTrivia(indentation()))
        }
    }
    
    func generateAttributeListSyntax<S: Sequence>(_ attributes: S) -> AttributeListSyntax where S.Element == KnownAttribute {
        SyntaxFactory.makeAttributeList(attributes.map(generateAttributeSyntax))
    }
    
    func generateAttributeSyntax(_ attribute: KnownAttribute) -> AttributeSyntax {
        AttributeSyntax { builder in
            builder.useAtSignToken(makeStartToken(SyntaxFactory.makeAtSignToken))
            builder.useAttributeName(makeIdentifier(attribute.name))
            
            // TODO: Actually use balanced tokens to do attribute parameters
            if let parameters = attribute.parameters {
                builder.addToken(SyntaxFactory.makeLeftParenToken())
                builder.addToken(makeIdentifier(parameters))
                builder.addToken(SyntaxFactory.makeRightParenToken())
            }
        }
    }
}

// MARK: - General/commons
func makeIdentifier(_ identifier: String) -> TokenSyntax {
    SyntaxFactory.makeIdentifier(identifier)
}

func iterateWithComma<T>(_ elements: T, do block: (T.Element, Bool) -> Void) where T: Collection {
    for (i, item) in elements.enumerated() {
        block(item, i < elements.count - 1)
    }
}

func mapWithComma<T, U>(_ elements: T, do block: (T.Element, Bool) -> U) -> [U] where T: Collection {
    elements.enumerated().map { block($1, $0 < elements.count - 1) }
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
        withLeadingTrivia(.spaces(count))
    }
    
    func withTrailingSpace(count: Int = 1) -> TokenSyntax {
        withTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingSpace(count: Int = 1) -> TokenSyntax {
        addingLeadingTrivia(.spaces(count))
    }
    
    func addingTrailingSpace(count: Int = 1) -> TokenSyntax {
        addingTrailingTrivia(.spaces(count))
    }
    
    func addingLeadingTrivia(_ trivia: Trivia) -> TokenSyntax {
        withLeadingTrivia(leadingTrivia + trivia)
    }
    
    func addingTrailingTrivia(_ trivia: Trivia) -> TokenSyntax {
        withTrailingTrivia(trailingTrivia + trivia)
    }
    
    func addingSurroundingSpaces() -> TokenSyntax {
        addingLeadingSpace().addingTrailingSpace()
    }
    
    func onNewline() -> TokenSyntax {
        withLeadingTrivia(.newlines(1))
    }
}

extension TokenSyntax {
    func withExtraLeading(from producer: SwiftSyntaxProducer) -> TokenSyntax {
        withExtraLeading(consuming: &producer.extraLeading)
    }
}
