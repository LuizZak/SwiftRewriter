import SwiftSyntax
import Intentions
import SwiftAST
import KnownType

class SwiftSyntaxProducer {
    private var indentationMode: TriviaPiece = .spaces(4)
    private var indentationLevel: Int = 0
    
    private var extraLeading: Trivia?
    
    init() {
        
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
    
    func generateFile(_ file: FileGenerationIntention) -> SourceFileSyntax {
        return SourceFileSyntax { builder in
            for cls in file.classIntentions {
                let syntax = generateClass(cls)
                
                let codeBlock = CodeBlockItemSyntax { $0.useItem(syntax) }
                
                builder.addCodeBlockItem(codeBlock)
                
                extraLeading = Trivia.newlines(1)
            }
        }
    }
    
    private func generateClass(_ type: ClassGenerationIntention) -> ClassDeclSyntax {
        return ClassDeclSyntax { builder in
            builder.useClassKeyword(
                SyntaxFactory
                    .makeClassKeyword()
                    .withExtraLeading(consuming: &extraLeading)
                    .withTrailingTrivia(.spaces(1)))
            
            let identifier = makeIdentifier(type.typeName)
            
            if let inheritanceClause = generateInheritanceClause(type) {
                builder.useIdentifier(identifier)
                
                builder.useInheritanceClause(inheritanceClause)
            } else {
                builder.useIdentifier(identifier.withTrailingSpace())
            }
            
            indent()
            
            let members = generateMembers(type)
            
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
    
    private func generateMembers(_ intention: TypeGenerationIntention) -> MemberDeclBlockSyntax {
        return MemberDeclBlockSyntax { builder in
            builder.useLeftBrace(SyntaxFactory.makeLeftBraceToken())
            builder.useRightBrace(SyntaxFactory.makeRightBraceToken().onNewline())
            
            // TODO: Probably shouldn't detect ivar containers like this.
            if let ivarHolder = intention as? InstanceVariableContainerIntention {
                iterateWriting(ivarHolder.instanceVariables) { ivar in
                    builder.addDecl(generateInstanceVariable(ivar))
                }
            }
            
            iterateWriting(intention.properties) { prop in
                builder.addDecl(generateProperty(prop))
            }
        }
    }
    
    private func iterateWriting<T>(_ elements: [T], do block: (T) -> Void) {
        for item in elements {
            block(item)
        }
        
        if !elements.isEmpty {
            extraLeading = Trivia.newlines(1)
        } else {
            extraLeading = nil
        }
    }
    
    private func generateInstanceVariable(_ intention: InstanceVariableGenerationIntention) -> DeclSyntax {
        return generateValueStorage(intention)
    }
    
    private func generateProperty(_ intention: PropertyGenerationIntention) -> DeclSyntax {
        return generateValueStorage(intention)
    }
    
    private func generateValueStorage(_ intention: ValueStorageIntention & MemberGenerationIntention) -> DeclSyntax {
        return VariableDeclSyntax { builder in
            let letOrVar =
                intention.isStatic
                    ? SyntaxFactory.makeLetKeyword()
                    : SyntaxFactory.makeVarKeyword()
            
            builder.useLetOrVarKeyword(
                letOrVar
                    .withLeadingTrivia(Trivia.newlines(1) + indentation())
                    .withExtraLeading(consuming: &extraLeading)
                    .withTrailingSpace()
            )
            
            for attribute in intention.knownAttributes {
                builder.addAttribute(makeAttributeSyntax(attribute))
            }
            
            builder.addPatternBinding(PatternBindingSyntax { builder in
                builder.usePattern(IdentifierPatternSyntax { builder in
                    builder.useIdentifier(makeIdentifier(intention.name))
                })
                
                return builder.useTypeAnnotation(TypeAnnotationSyntax { builder in
                    builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                    builder.useType(makeTypeSyntax(intention.type))
                })
            })
        }
    }
}


private func makeIdentifier(_ identifier: String) -> TokenSyntax {
    return SyntaxFactory.makeIdentifier(identifier)
}

private func makeAttributeListSyntax<S: Sequence>(_ attributes: S) -> AttributeListSyntax where S.Element == KnownAttribute {
    return SyntaxFactory.makeAttributeList(attributes.map(makeAttributeSyntax))
}

private func makeAttributeSyntax(_ attribute: KnownAttribute) -> AttributeSyntax {
    return SyntaxFactory
        .makeAttribute(
            atSignToken: SyntaxFactory.makeAtSignToken(),
            attributeName: makeIdentifier(attribute.name),
            balancedTokens: SyntaxFactory.makeTokenList(attribute.parameters.map { [SyntaxFactory.makeIdentifier($0)] } ?? [])
        )
}

private func makeTypeSyntax(_ type: SwiftType) -> TypeSyntax {
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
                builder.useArrow(SyntaxFactory.makeArrowToken())
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
                            balancedTokens: SyntaxFactory.makeTokenList([makeIdentifier(convention.rawValue)])
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
            return SyntaxFactory.makeVoidTupleType()
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

private func makeTupleTypeSyntax<C: Collection>(_ types: C) -> TupleTypeSyntax where C.Element == SwiftType {
    return TupleTypeSyntax { builder in
        for (i, type) in types.enumerated() {
            let syntax = TupleTypeElementSyntax { builder in
                builder.useType(makeTypeSyntax(type))
                
                if i == types.count - 1 {
                    builder.useTrailingComma(SyntaxFactory.makeCommaToken())
                }
            }
            
            builder.addTupleTypeElement(syntax)
        }
    }
}

private func makeNestedTypeSyntax(_ nestedType: NestedSwiftType) -> MemberTypeIdentifierSyntax {
    
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

private func makeNominalTypeSyntax(_ nominal: NominalSwiftType) -> SimpleTypeIdentifierSyntax {
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

private extension TokenSyntax {
    func withExtraLeading(consuming trivia: inout Trivia?) -> TokenSyntax {
        if let t = trivia {
            trivia = t
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
    
    func onNewline() -> TokenSyntax {
        return withLeadingTrivia(.newlines(1))
    }
}
