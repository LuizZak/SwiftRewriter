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
        return generateVariableDecl(intention)
    }
    
    func generateProperty(_ intention: PropertyGenerationIntention) -> DeclSyntax {
        return generateVariableDecl(intention)
    }
    
    func generateGlobalVariable(_ intention: GlobalVariableGenerationIntention) -> DeclSyntax {
        return generateVariableDecl(intention)
    }
    
    func generateVariableDecl(_ intention: ValueStorageIntention) -> DeclSyntax {
        producer.addHistoryTrackingLeadingIfEnabled(intention)
        
        let decl = makeDeclaration(intention)
        
        return generate(decl)
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
    
    func generate(_ variableDecl: VariableDeclaration) -> VariableDeclSyntax {
        return VariableDeclSyntax { builder in
            for attribute in variableDecl.attributes {
                builder.addAttribute(attribute())
            }
            for modifier in variableDecl.modifiers {
                builder.addModifier(modifier(&producer.extraLeading))
            }
            
            let letOrVar =
                variableDecl.constant
                    ? SyntaxFactory.makeLetKeyword
                    : SyntaxFactory.makeVarKeyword
            
            builder.useLetOrVarKeyword(producer.makeStartToken(letOrVar).addingTrailingSpace())
            
            switch variableDecl.kind {
            case let .single(pattern, accessors):
                let patternSyntax =
                    generate(pattern, hasComma: false, accessors: accessors)
                
                builder.addPatternBinding(patternSyntax)
                
            case let .multiple(patterns):
                iterateWithComma(patterns) { pattern, hasComma in
                    builder.addPatternBinding(generate(pattern, hasComma: hasComma))
                }
            }
        }
    }
    
    private func generate(_ binding: PatternBindingElement,
                          hasComma: Bool,
                          accessors: (() -> AccessorBlockSyntax)? = nil) -> PatternBindingSyntax {
        
        return PatternBindingSyntax { builder in
            builder.usePattern(IdentifierPatternSyntax { builder in
                builder.useIdentifier(makeIdentifier(binding.name))
            })
            
            if let bindingType = binding.type {
                builder.useTypeAnnotation(TypeAnnotationSyntax { builder in
                    builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                    builder.useType(SwiftTypeConverter.makeTypeSyntax(bindingType))
                })
            }
            
            if hasComma {
                builder.useTrailingComma(
                    SyntaxFactory
                        .makeCommaToken()
                        .withTrailingSpace())
            }
            
            if let accessor = accessors {
                builder.useAccessor(accessor())
            }
            
            if let initialization = binding.initialization {
                builder.useInitializer(InitializerClauseSyntax { builder in
                    builder.useEqual(SyntaxFactory.makeEqualToken().withLeadingSpace().withTrailingSpace())
                    builder.useValue(producer.generateExpression(initialization))
                })
            }
        }
    }
    
    private func makeAccessorBlockCreator(_ property: PropertyGenerationIntention) -> (() -> AccessorBlockSyntax)? {
        // Emit { get } and { get set } accessor blocks for protocols
        if let property = property as? ProtocolPropertyGenerationIntention {
            return { [producer] in
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(
                        producer.makeStartToken(SyntaxFactory.makeLeftBraceToken)
                            .addingSurroundingSpaces()
                    )
                    
                    builder.useRightBrace(SyntaxFactory.makeRightBraceToken())
                    var accessors: [AccessorDeclSyntax] = []
                    
                    accessors.append(AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            SyntaxFactory
                                .makeToken(.contextualKeyword("get"),
                                           presence: .present)
                                .withTrailingSpace()
                        )
                    })
                    
                    if !property.isReadOnly {
                        accessors.append(AccessorDeclSyntax { builder in
                            builder.useAccessorKind(
                                SyntaxFactory
                                    .makeToken(.contextualKeyword("set"),
                                               presence: .present)
                                    .withTrailingSpace()
                            )
                        })
                    }
                    
                    builder.useAccessorListOrStmtList(
                        SyntaxFactory.makeAccessorList(accessors)
                    )
                }
            }
        }
        
        switch property.mode {
        case .asField:
            return nil
            
        case .computed(let body):
            return { [producer] in
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(producer.makeStartToken(SyntaxFactory.makeLeftBraceToken).withLeadingSpace())
                    
                    producer.indent()
                    let blocks = producer._generateStatements(body.body.statements)
                    producer.deindent()
                    
                    let stmtList = SyntaxFactory.makeCodeBlockItemList(blocks)
                    
                    builder.useAccessorListOrStmtList(stmtList)
                    
                    producer.addExtraLeading(.newlines(1) + producer.indentation())
                    builder.useRightBrace(producer.makeStartToken(SyntaxFactory.makeRightBraceToken))
                }
            }
            
        case let .property(get, set):
            return { [producer] in
                return AccessorBlockSyntax { builder in
                    builder.useLeftBrace(producer.makeStartToken(SyntaxFactory.makeLeftBraceToken).withLeadingSpace())
                    
                    producer.indent()
                    
                    producer.addExtraLeading(.newlines(1) + producer.indentation())
                    
                    let getter = AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            producer.prepareStartToken(
                                SyntaxFactory
                                    .makeToken(.contextualKeyword("get"),
                                               presence: .present)
                            )
                        )
                        
                        builder.useBody(producer.generateFunctionBody(get))
                    }
                    
                    producer.addExtraLeading(.newlines(1) + producer.indentation())
                    
                    let setter = AccessorDeclSyntax { builder in
                        builder.useAccessorKind(
                            producer.prepareStartToken(
                                SyntaxFactory
                                    .makeToken(.contextualKeyword("set"),
                                               presence: .present)
                            )
                        )
                        
                        if set.valueIdentifier != "newValue" {
                            builder.useParameter(AccessorParameterSyntax { builder in
                                builder.useLeftParen(producer.makeStartToken(SyntaxFactory.makeLeftParenToken))
                                builder.useName(makeIdentifier(set.valueIdentifier))
                                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                            })
                        }
                        
                        builder.useBody(producer.generateFunctionBody(set.body))
                    }
                    
                    producer.deindent()
                    
                    let accessorList = SyntaxFactory.makeAccessorList([getter, setter])
                    
                    builder.useAccessorListOrStmtList(accessorList)
                    
                    producer.addExtraLeading(.newlines(1) + producer.indentation())
                    builder.useRightBrace(producer.makeStartToken(SyntaxFactory.makeRightBraceToken))
                }
            }
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
        
        return producer.delegate?.swiftSyntaxProducer(producer, initialValueFor: intention)
    }
}

private extension VariableDeclSyntaxGenerator {
    func makeDeclaration(_ stmtDecl: StatementVariableDeclaration) -> VariableDeclaration {
        let decl =
            makeDeclaration(name: stmtDecl.identifier,
                            storage: stmtDecl.storage,
                            attributes: [],
                            intention: nil,
                            modifiers: producer.modifiers(for: stmtDecl),
                            initialization: stmtDecl.initialization)
        
        return decl
    }
    
    func makeDeclaration(_ intention: ValueStorageIntention) -> VariableDeclaration {
        var accessors: (() -> AccessorBlockSyntax)?
        if let intention = intention as? PropertyGenerationIntention {
            accessors = makeAccessorBlockCreator(intention)
        }
        
        return makeDeclaration(name: intention.name,
                               storage: intention.storage,
                               attributes: producer.attributes(for: intention, inline: true),
                               intention: intention,
                               modifiers: producer.modifiers(for: intention),
                               accessors: accessors,
                               initialization: _initialValue(for: intention))
    }
    
    func makeDeclaration(name: String,
                         storage: ValueStorage,
                         attributes: [() -> AttributeSyntax],
                         intention: IntentionProtocol?,
                         modifiers: ModifierDecoratorResult,
                         accessors: (() -> AccessorBlockSyntax)? = nil,
                         initialization: Expression? = nil) -> VariableDeclaration {
        
        var patternBinding = makePatternBinding(name: name, type: storage.type, initialization: initialization)
        
        if producer.delegate?.swiftSyntaxProducer(producer,
                                                  shouldEmitTypeFor: storage,
                                                  intention: intention,
                                                  initialValue: initialization) == false {
            patternBinding.type = nil
        }
        
        return
            VariableDeclaration(
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
        
        return PatternBindingElement(name: name,
                                     type: type,
                                     intention: nil,
                                     initialization: initialization)
    }
    
    private func makePatternBinding(_ intention: ValueStorageIntention) -> PatternBindingElement {
        return PatternBindingElement(
            name: intention.name,
            type: intention.type,
            intention: intention,
            initialization: _initialValue(for: intention)
        )
    }
}

private func group(_ declarations: [VariableDeclaration]) -> [VariableDeclaration] {
    if declarations.isEmpty {
        return declarations
    }
    
    var result: [VariableDeclaration] = [declarations[0]]
    
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

private func groupDeclarations(_ decl1: VariableDeclaration, _ decl2: VariableDeclaration) -> VariableDeclaration? {
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
