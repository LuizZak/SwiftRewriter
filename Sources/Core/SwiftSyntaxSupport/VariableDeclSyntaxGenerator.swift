import SwiftSyntax
import Intentions
import SwiftAST
import KnownType

class VariableDeclSyntaxGenerator {
    
    let producer: SwiftSyntaxProducer
    
    init(producer: SwiftSyntaxProducer) {
        self.producer = producer
    }

    func generateAttributeList(_ attributeGenerators: [() -> AttributeListSyntax.Element]) -> AttributeListSyntax {
        let syntax = AttributeListSyntax(attributeGenerators.map({ $0() }))

        return syntax
    }

    func generateModifierList(_ modifierDecorators: [ModifiersDecoratorResult]) -> ModifierListSyntax {
        let syntax = ModifierListSyntax(modifierDecorators.map({ $0(producer) }))

        return syntax
    }
    
    func generateInstanceVariable(_ intention: InstanceVariableGenerationIntention) -> DeclSyntax {
        generateVariableDecl(intention)
    }
    
    func generateProperty(_ intention: PropertyGenerationIntention) -> DeclSyntax {
        generateVariableDecl(intention)
    }
    
    func generateSubscript(_ intention: SubscriptGenerationIntention) -> DeclSyntax {
        producer.addHistoryTrackingLeadingIfEnabled(intention)
        producer.addCommentsIfAvailable(intention)
        
        let attributeListSyntax = generateAttributeList(
            producer.attributes(for: intention, inline: false)
        )
        let modifierListSyntax = generateModifierList(
            producer.modifiers(for: intention)
        )
        
        var syntax = SubscriptDeclSyntax(
            attributes: attributeListSyntax,
            modifiers: modifierListSyntax,
            subscriptKeyword: producer.prepareStartToken(.subscript),
            indices: producer.generateParameterClause(intention.parameters),
            result: producer.generateReturnType(intention.returnType)
        )

        if let accessors = VariableDeclSyntaxGenerator.makeAccessorBlockCreator(intention, producer) {
            syntax = syntax.withAccessor(accessors()) // builder.useAccessor(accessors())
        }

        return syntax.asDeclSyntax
    }
    
    func generateGlobalVariable(_ intention: GlobalVariableGenerationIntention) -> DeclSyntax {
        generateVariableDecl(intention)
    }
    
    func generateVariableDecl(_ intention: ValueStorageIntention) -> DeclSyntax {
        producer.addHistoryTrackingLeadingIfEnabled(intention)
        
        if let fromSource = intention as? FromSourceIntention {
            producer.addCommentsIfAvailable(fromSource)
        }
        
        let decl = makeDeclaration(intention)
        
        return generate(decl).asDeclSyntax
    }
    
    func generateVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> [() -> VariableDeclSyntax] {
        // Group declarations before returning the producers
        let declarations = group(stmt.decl.map(makeDeclaration))
        
        return declarations.map { decl in
            return {
                self.generate(decl)
            }
        }
    }
    
    func generate(_ variableDecl: ObjcVariableDeclarationNode) -> VariableDeclSyntax {
        let attributeListSyntax = generateAttributeList(
            variableDecl.attributes
        )
        let modifierListSyntax = generateModifierList(
            variableDecl.modifiers
        )
        
        let letOrVar: TokenSyntax = variableDecl.constant ? .let : .var
        
        var syntax = VariableDeclSyntax(
            attributes: attributeListSyntax,
            modifiers: modifierListSyntax,
            letOrVarKeyword: producer
                .prepareStartToken(letOrVar)
                .addingTrailingSpace()
        )
        
        switch variableDecl.kind {
        case let .single(pattern, accessors):
            let patternSyntax =
                generate(pattern, hasComma: false, accessors: accessors)
            
            syntax = syntax.addBinding(patternSyntax) // syntax = syntax.withBinding(patternSyntax) // builder.useBinding(patternSyntax)
            
        case let .multiple(patterns):
            iterateWithComma(patterns) { pattern, hasComma in
                syntax = syntax.addBinding(generate(pattern, hasComma: hasComma)) // syntax = syntax.withBinding(generate(pattern, hasComma: hasComma)) // builder.useBinding(generate(pattern, hasComma: hasComma))
            }
        }

        return syntax
    }
    
    private func generate(
        _ binding: PatternBindingElement,
        hasComma: Bool,
        accessors: (() -> PatternBindingSyntax.Accessor)? = nil
    ) -> PatternBindingSyntax {
        
        var syntax = PatternBindingSyntax(
            pattern: IdentifierPatternSyntax(
                identifier: producer.prepareStartToken(makeIdentifier(binding.name))
            )
        )

        if let bindingType = binding.type {
            let typeSyntax = TypeAnnotationSyntax(
                colon: .colon.withTrailingSpace(),
                type: SwiftTypeConverter.makeTypeSyntax(bindingType, startTokenHandler: producer)
            )

            syntax = syntax.withTypeAnnotation(typeSyntax)
        }
        
        if hasComma {
            syntax = syntax.withTrailingComma(
                .comma.withTrailingSpace()
            )
        }
        
        if let accessor = accessors {
            syntax = syntax.withAccessor(accessor())
        }
        
        if let initialization = binding.initialization {
            let initializerSyntax = InitializerClauseSyntax(
                equal: .equal.addingSurroundingSpaces(),
                value: producer.generateExpression(initialization)
            )

            syntax = syntax.withInitializer(initializerSyntax)
        }

        return syntax
    }
    
    private static func makeAccessorBlockCreator(
        _ property: PropertyGenerationIntention,
        _ producer: SwiftSyntaxProducer
    ) -> (() -> PatternBindingSyntax.Accessor)? {
        
        // Emit { get } and { get set } accessor blocks for protocols
        if let property = property as? ProtocolPropertyGenerationIntention {
            return {
                var syntax = AccessorBlockSyntax(
                    leftBrace: producer.prepareStartToken(.leftBrace).addingSurroundingSpaces(),
                    accessors: [
                        AccessorDeclSyntax(
                            accessorKind: .contextualKeyword("get").withTrailingSpace()
                        )
                    ]
                )
                
                if !property.isReadOnly {
                    syntax = syntax.addAccessor(
                        AccessorDeclSyntax(
                            accessorKind: .contextualKeyword("set").withTrailingSpace()
                        )
                    )
                }

                return .accessors(syntax)
            }
        }
        
        switch property.mode {
        case .asField:
            return nil
            
        case .computed(let body):
            return {
                .getter(generateGetterAccessor(body, producer)())
            }
            
        case let .property(get, set):
            return {
                let leftBraceSyntax = producer.prepareStartToken(.leftBrace).withLeadingSpace()
                producer.addExtraLeading(.newlines(1))

                let result = generateGetterSetterAccessor(get, set, producer)()

                producer.addExtraLeading(.newlines(1) + producer.indentation())
                let rightBraceSyntax = producer.prepareStartToken(.rightBrace)

                return .accessors(
                    .init(
                        leftBrace: leftBraceSyntax,
                        accessors: [
                            result.getter,
                            result.setter
                        ],
                        rightBrace: rightBraceSyntax
                ))
            }
        }
    }
    
    private static func makeAccessorBlockCreator(
        _ subscriptIntention: SubscriptGenerationIntention,
        _ producer: SwiftSyntaxProducer
    ) -> (() -> SubscriptDeclSyntax.Accessor)? {
        
        switch subscriptIntention.mode {
        case .getter(let body):
            return {
                .getter(generateGetterAccessor(body, producer)())
            }
            
        case let .getterAndSetter(getter, setter):
            return {
                producer.addExtraLeading(.spaces(1))
                let leftBrace = producer.prepareStartToken(.leftBrace)
                
                producer.addExtraLeading(.newlines(1))

                let (getterSyntax, setterSyntax) = generateGetterSetterAccessor(getter, setter, producer)()
                
                producer.addExtraLeading(.newlines(1) + producer.indentation())
                let rightBrace = producer.prepareStartToken(.rightBrace)

                return .accessors(.init(
                    leftBrace: leftBrace,
                    accessors: [getterSyntax, setterSyntax],
                    rightBrace: rightBrace
                ))
            }
        }
    }
    
    private static func generateGetterAccessor(
        _ getter: FunctionBodyIntention,
        _ producer: SwiftSyntaxProducer
    ) -> () -> CodeBlockSyntax {
        
        return {
            var syntax = CodeBlockSyntax()
            syntax = syntax.withLeftBrace( // builder.useLeftBrace(
                producer.prepareStartToken(.leftBrace)
                    .withLeadingSpace()
            )
            
            producer.indent()
            let blocks = producer._generateStatements(getter.body.statements)
            producer.deindent()
            
            let stmtList = CodeBlockItemListSyntax(blocks)
            
            for item in stmtList {
                syntax = syntax.addStatement(item)
            }
            
            producer.addExtraLeading(.newlines(1) + producer.indentation())
            syntax = syntax.withRightBrace(
                producer.prepareStartToken(.rightBrace)
            )

            return syntax
        }
    }
    
    private static func generateGetterSetterAccessor(
        _ getter: FunctionBodyIntention,
        _ setter: PropertyGenerationIntention.Setter,
        _ producer: SwiftSyntaxProducer
    ) -> () -> (getter: AccessorDeclSyntax, setter: AccessorDeclSyntax) {

        return generateGetterSetterAccessor(
            getter,
            (setter.valueIdentifier, setter.body),
            producer
        )
    }
    
    private static func generateGetterSetterAccessor(
        _ getter: FunctionBodyIntention,
        _ setter: SubscriptGenerationIntention.Setter,
        _ producer: SwiftSyntaxProducer
    ) -> () -> (getter: AccessorDeclSyntax, setter: AccessorDeclSyntax) {

        return generateGetterSetterAccessor(
            getter,
            (setter.valueIdentifier, setter.body),
            producer
        )
    }
    
    private static func generateGetterSetterAccessor(
        _ getter: FunctionBodyIntention,
        _ setter: (valueIdentifier: String, body: FunctionBodyIntention),
        _ producer: SwiftSyntaxProducer
    ) -> () -> (getter: AccessorDeclSyntax, setter: AccessorDeclSyntax) {

        return {
            producer.indent()
            
            producer.addExtraLeading(producer.indentation())
            
            let getterSyntax = AccessorDeclSyntax(
                accessorKind: producer.prepareStartToken(.contextualKeyword("get")).withTrailingSpace(),
                body: producer.generateFunctionBody(getter)
            )
            
            producer.addExtraLeading(.newlines(1) + producer.indentation())
            
            let setterSyntax: AccessorDeclSyntax

            let setToken = producer.prepareStartToken(
                TokenSyntax.contextualKeyword("set")
            )

            if setter.valueIdentifier != "newValue" {
                setterSyntax = AccessorDeclSyntax(
                    accessorKind: setToken,
                    parameter: AccessorParameterSyntax(
                        leftParen: producer.prepareStartToken(.leftParen),
                        name: setter.valueIdentifier,
                        rightParen: .rightParen.withTrailingSpace()
                    ),
                    body: producer.generateFunctionBody(setter.body)
                )
            } else {
                setterSyntax = AccessorDeclSyntax(
                    accessorKind: setToken.withTrailingSpace(),
                    body: producer.generateFunctionBody(setter.body)
                )
            }
            
            producer.deindent()
            
            return (getterSyntax, setterSyntax)
        }
    }
}

private extension VariableDeclSyntaxGenerator {
    func _initialValue(for intention: ValueStorageIntention) -> Expression? {
        if let intention = intention.initialValue {
            return intention
        }
        if intention is GlobalVariableGenerationIntention {
            return nil
        }
        if let intention = intention as? MemberGenerationIntention {
            if intention.type?.kind != .class {
                return nil
            }
        }
        
        return producer
            .delegate?
            .swiftSyntaxProducer(producer, initialValueFor: intention)
    }
}

private extension VariableDeclSyntaxGenerator {
    func makeDeclaration(_ stmtDecl: StatementVariableDeclaration) -> ObjcVariableDeclarationNode {
        let decl =
            makeDeclaration(
                name: stmtDecl.identifier,
                storage: stmtDecl.storage,
                attributes: [],
                intention: nil,
                modifiers: producer.modifiers(for: stmtDecl),
                initialization: stmtDecl.initialization
            )
        
        return decl
    }
    
    func makeDeclaration(_ intention: ValueStorageIntention) -> ObjcVariableDeclarationNode {
        var accessors: (() -> PatternBindingSyntax.Accessor)?
        if let intention = intention as? PropertyGenerationIntention {
            accessors = VariableDeclSyntaxGenerator.makeAccessorBlockCreator(intention, producer)
        }
        
        return makeDeclaration(
            name: intention.name,
            storage: intention.storage,
            attributes: producer.attributes(
                for: intention,
                inline: true
            ),
            intention: intention,
            modifiers: producer.modifiers(for: intention),
            accessors: accessors,
            initialization: _initialValue(for: intention)
        )
    }
    
    func makeDeclaration(
        name: String,
        storage: ValueStorage,
        attributes: [() -> AttributeListSyntax.Element],
        intention: IntentionProtocol?,
        modifiers: [ModifiersDecoratorResult],
        accessors: (() -> PatternBindingSyntax.Accessor)? = nil,
        initialization: Expression? = nil
    ) -> ObjcVariableDeclarationNode {
        
        var patternBinding = makePatternBinding(
            name: name,
            type: storage.type,
            initialization: initialization
        )
        
        if
            producer.delegate?.swiftSyntaxProducer(
                producer,
                shouldEmitTypeFor: storage,
                intention: intention,
                initialValue: initialization
            ) == false
        {
            patternBinding.type = nil
        }
        
        return ObjcVariableDeclarationNode(
            constant: storage.isConstant,
            attributes: attributes,
            modifiers: modifiers,
            kind: .single(
                pattern: patternBinding,
                accessors: accessors
            )
        )
    }
    
    private func makePatternBinding(
        name: String,
        type: SwiftType?,
        initialization: Expression?
    ) -> PatternBindingElement {
        
        PatternBindingElement(
            name: name,
            type: type,
            intention: nil,
            initialization: initialization
        )
    }
    
    private func makePatternBinding(_ intention: ValueStorageIntention) -> PatternBindingElement {
        PatternBindingElement(
            name: intention.name,
            type: intention.type,
            intention: intention,
            initialization: _initialValue(for: intention)
        )
    }
}

private func group(_ declarations: [ObjcVariableDeclarationNode]) -> [ObjcVariableDeclarationNode] {
    guard let first = declarations.first else {
        return declarations
    }
    
    var result: [ObjcVariableDeclarationNode] = [first]
    
    for decl in declarations.dropFirst() {
        let last = result[result.count - 1]
        
        if let grouped = groupDeclarations(last, decl) {
            result[result.count - 1] = grouped
        } else {
            result.append(decl)
        }
    }
    
    return result
}

private func groupDeclarations(_ decl1: ObjcVariableDeclarationNode,
                               _ decl2: ObjcVariableDeclarationNode) -> ObjcVariableDeclarationNode? {
    
    // Attributed or modified declarations cannot be merged
    guard decl1.attributes.isEmpty && decl2.attributes.isEmpty else {
        return nil
    }
    guard decl1.modifiers.isEmpty && decl2.modifiers.isEmpty else {
        return nil
    }
    
    if decl1.constant != decl2.constant {
        return nil
    }
    
    switch (decl1.kind, decl2.kind) {
    case let (.single(l, nil), .single(r, nil)):
        var decl = decl1
        decl.kind = .multiple(patterns: [l, r])
        
        return decl
        
    case let (.single(l, nil), .multiple(r)):
        var decl = decl1
        decl.kind = .multiple(patterns: [l] + r)
        
        return decl
        
    case let (.multiple(l), .single(r, nil)):
        var decl = decl1
        decl.kind = .multiple(patterns: l + [r])
        
        return decl
        
    default:
        return nil
    }
}
