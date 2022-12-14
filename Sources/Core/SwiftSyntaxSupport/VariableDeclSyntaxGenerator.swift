import SwiftSyntax
import Intentions
import SwiftAST
import KnownType

class VariableDeclSyntaxGenerator {
    
    let producer: SwiftSyntaxProducer
    
    init(producer: SwiftSyntaxProducer) {
        self.producer = producer
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
        
        return SubscriptDeclSyntax { builder in
            for attribute in producer.attributes(for: intention, inline: false) {
                builder.addAttribute(attribute().asSyntax)
            }
            for modifier in producer.modifiers(for: intention) {
                builder.addModifier(modifier(producer))
            }
            
            builder.useSubscriptKeyword(
                producer.makeStartToken(SyntaxFactory.makeSubscriptKeyword)
            )
            builder.useIndices(producer.generateParameterClause(intention.parameters))
            builder.useResult(producer.generateReturnType(intention.returnType))
            
            if let accessors = VariableDeclSyntaxGenerator.makeAccessorBlockCreator(intention, producer) {
                builder.useAccessor(accessors())
            }
        }.asDeclSyntax
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
        VariableDeclSyntax { builder in
            for attribute in variableDecl.attributes {
                builder.addAttribute(attribute().asSyntax)
            }
            for modifier in variableDecl.modifiers {
                builder.addModifier(modifier(producer))
            }
            
            let letOrVar =
                variableDecl.constant
                    ? SyntaxFactory.makeLetKeyword
                    : SyntaxFactory.makeVarKeyword
            
            builder.useLetOrVarKeyword(
                producer
                    .makeStartToken(letOrVar)
                    .addingTrailingSpace()
            )
            
            switch variableDecl.kind {
            case let .single(pattern, accessors):
                let patternSyntax =
                    generate(pattern, hasComma: false, accessors: accessors)
                
                builder.addBinding(patternSyntax)
                
            case let .multiple(patterns):
                iterateWithComma(patterns) { pattern, hasComma in
                    builder.addBinding(generate(pattern, hasComma: hasComma))
                }
            }
        }
    }
    
    private func generate(
        _ binding: PatternBindingElement,
        hasComma: Bool,
        accessors: (() -> Syntax)? = nil
    ) -> PatternBindingSyntax {
        
        PatternBindingSyntax { builder in
            builder.usePattern(IdentifierPatternSyntax { builder in
                builder.useIdentifier(makeIdentifier(binding.name))
            }.asPatternSyntax)
            
            if let bindingType = binding.type {
                builder.useTypeAnnotation(TypeAnnotationSyntax { builder in
                    builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                    builder.useType(SwiftTypeConverter.makeTypeSyntax(bindingType, startTokenHandler: producer))
                })
            }
            
            if hasComma {
                builder.useTrailingComma(
                    SyntaxFactory
                        .makeCommaToken()
                        .withTrailingSpace()
                )
            }
            
            if let accessor = accessors {
                builder.useAccessor(accessor())
            }
            
            if let initialization = binding.initialization {
                builder.useInitializer(InitializerClauseSyntax { builder in
                    builder.useEqual(
                        SyntaxFactory
                            .makeEqualToken()
                            .addingSurroundingSpaces()
                    )
                    builder.useValue(producer.generateExpression(initialization))
                })
            }
        }
    }
    
    private static func makeAccessorBlockCreator(
        _ property: PropertyGenerationIntention,
        _ producer: SwiftSyntaxProducer
    ) -> (() -> Syntax)? {
        
        // Emit { get } and { get set } accessor blocks for protocols
        if let property = property as? ProtocolPropertyGenerationIntention {
            return {
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(
                        producer.makeStartToken(SyntaxFactory.makeLeftBraceToken)
                            .addingSurroundingSpaces()
                    )
                    
                    builder.useRightBrace(SyntaxFactory.makeRightBraceToken())
                    
                    builder.addAccessor(AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            SyntaxFactory
                                .makeToken(
                                    .contextualKeyword("get"),
                                    presence: .present
                                )
                                .withTrailingSpace()
                        )
                    })
                    
                    if !property.isReadOnly {
                        builder.addAccessor(AccessorDeclSyntax { builder in
                            builder.useAccessorKind(
                                SyntaxFactory
                                    .makeToken(
                                        .contextualKeyword("set"),
                                        presence: .present
                                    )
                                    .withTrailingSpace()
                            )
                        })
                    }
                }.asSyntax
            }
        }
        
        switch property.mode {
        case .asField:
            return nil
            
        case .computed(let body):
            return generateGetterAccessor(body, producer)
            
        case let .property(get, set):
            return generateGetterSetterAccessor(get, set, producer)
        }
    }
    
    private static func makeAccessorBlockCreator(_ subcript: SubscriptGenerationIntention,
                                                 _ producer: SwiftSyntaxProducer) -> (() -> Syntax)? {
        
        switch subcript.mode {
        case .getter(let body):
            return generateGetterAccessor(body, producer)
            
        case let .getterAndSetter(getter, setter):
            return generateGetterSetterAccessor(getter, setter, producer)
        }
    }
    
    private static func generateGetterAccessor(_ getter: FunctionBodyIntention,
                                               _ producer: SwiftSyntaxProducer) -> () -> Syntax {
        
        return {
            return CodeBlockSyntax { builder in
                builder.useLeftBrace(
                    producer.makeStartToken(SyntaxFactory.makeLeftBraceToken)
                        .withLeadingSpace()
                )
                
                producer.indent()
                let blocks = producer._generateStatements(getter.body.statements)
                producer.deindent()
                
                let stmtList = SyntaxFactory.makeCodeBlockItemList(blocks)
                let codeBlock = 
                    SyntaxFactory
                    .makeCodeBlockItem(
                        item: stmtList.asSyntax,
                        semicolon: nil,
                        errorTokens: nil
                    )
                
                builder.addStatement(codeBlock)
                
                producer.addExtraLeading(.newlines(1) + producer.indentation())
                builder.useRightBrace(
                    producer.makeStartToken(SyntaxFactory.makeRightBraceToken)
                )
            }.asSyntax
        }
    }
    
    private static func generateGetterSetterAccessor(
        _ getter: FunctionBodyIntention,
        _ setter: PropertyGenerationIntention.Setter,
        _ producer: SwiftSyntaxProducer
    ) -> () -> Syntax {
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
    ) -> () -> Syntax {
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
    ) -> () -> Syntax {
        return {
            return AccessorBlockSyntax { builder in
                builder.useLeftBrace(
                    producer
                        .makeStartToken(SyntaxFactory.makeLeftBraceToken)
                        .withLeadingSpace()
                )
                
                producer.indent()
                
                producer.addExtraLeading(.newlines(1) + producer.indentation())
                
                let getter = AccessorDeclSyntax { builder in
                    builder.useAccessorKind(
                        producer.prepareStartToken(
                            SyntaxFactory
                                .makeToken(.contextualKeyword("get"), presence: .present)
                                .withTrailingSpace()
                        )
                    )
                    
                    builder.useBody(producer.generateFunctionBody(getter))
                }
                
                producer.addExtraLeading(.newlines(1) + producer.indentation())
                
                let setter = AccessorDeclSyntax { builder in
                    let setToken = producer.prepareStartToken(
                        SyntaxFactory
                            .makeToken(.contextualKeyword("set"), presence: .present)
                    )
                    
                    if setter.valueIdentifier != "newValue" {
                        builder.useAccessorKind(setToken)
                        builder.useParameter(AccessorParameterSyntax { builder in
                            builder.useLeftParen(
                                producer
                                    .makeStartToken(SyntaxFactory.makeLeftParenToken)
                            )
                            builder.useName(makeIdentifier(setter.valueIdentifier))
                            builder.useRightParen(SyntaxFactory.makeRightParenToken())
                        }.withTrailingSpace())
                    } else {
                        builder.useAccessorKind(setToken.withTrailingSpace())
                    }
                    
                    builder.useBody(producer.generateFunctionBody(setter.body))
                }
                
                producer.deindent()
                
                builder.addAccessor(getter)
                builder.addAccessor(setter)
                
                producer.addExtraLeading(.newlines(1) + producer.indentation())
                builder.useRightBrace(
                    producer.makeStartToken(SyntaxFactory.makeRightBraceToken)
                )
            }.asSyntax
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
        var accessors: (() -> Syntax)?
        if let intention = intention as? PropertyGenerationIntention {
            accessors = VariableDeclSyntaxGenerator.makeAccessorBlockCreator(intention, producer)
        }
        
        return makeDeclaration(
            name: intention.name,
            storage: intention.storage,
            attributes: producer
                .attributes(
                    for: intention,
                    inline: true
                ),
            intention: intention,
            modifiers: producer.modifiers(for: intention),
            accessors: accessors,
            initialization: _initialValue(for: intention)
        )
    }
    
    func makeDeclaration(name: String,
                         storage: ValueStorage,
                         attributes: [() -> AttributeSyntax],
                         intention: IntentionProtocol?,
                         modifiers: [ModifiersDecoratorResult],
                         accessors: (() -> Syntax)? = nil,
                         initialization: Expression? = nil) -> ObjcVariableDeclarationNode {
        
        var patternBinding = makePatternBinding(
            name: name,
            type: storage.type,
            initialization: initialization
        )
        
        if producer.delegate?.swiftSyntaxProducer(producer,
                                                  shouldEmitTypeFor: storage,
                                                  intention: intention,
                                                  initialValue: initialization) == false {
            patternBinding.type = nil
        }
        
        return
            ObjcVariableDeclarationNode(
                constant: storage.isConstant,
                attributes: attributes,
                modifiers: modifiers,
                kind: .single(
                    pattern: patternBinding,
                    accessors: accessors
                ))
    }
    
    private func makePatternBinding(name: String,
                                    type: SwiftType?,
                                    initialization: Expression?) -> PatternBindingElement {
        
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
