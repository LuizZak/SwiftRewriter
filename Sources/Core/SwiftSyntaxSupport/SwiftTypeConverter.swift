import SwiftSyntax
import SwiftAST

public class SwiftTypeConverter {
    /// Converts a given `SwiftType` into an equivalent SwiftSyntax `TypeSyntax`
    /// element.
    ///
    /// - parameter type: The type to convert.
    /// - parameter allowRootNullabilityUnspecified: If `false`, any root-level
    /// `SwiftType.nullabilityUnspecified` will be promoted to a regular
    /// `SwiftType.optional`, instead.
    /// - parameter startTokenHandler: A delegate that will be invoked for the
    /// first token on the syntax.
    public static func makeTypeSyntax(
        _ type: SwiftType,
        allowRootNullabilityUnspecified: Bool = true,
        startTokenHandler: StartTokenHandler
    ) -> TypeSyntax {

        let converter = SwiftTypeConverter()
        if allowRootNullabilityUnspecified {
            converter._typeDepth = -1
        } else {
            converter._typeDepth = 0
        }

        return converter.makeTypeSyntax(type, startTokenHandler: startTokenHandler)
    }
    
    private var _typeDepth = -1
    
    private init() {
        
    }

    func asNullabilityUnspecified(_ type: TypeSyntax) -> TypeSyntax {
        if _typeDepth > 0 {
            return SyntaxFactory.makeOptionalType(
                wrappedType: type,
                questionMark: SyntaxFactory.makePostfixQuestionMarkToken()
            ).asTypeSyntax
        } else {
            return SyntaxFactory.makeImplicitlyUnwrappedOptionalType(
                wrappedType: type,
                exclamationMark: SyntaxFactory.makeExclamationMarkToken()
            ).asTypeSyntax
        }
    }
    
    func makeTypeSyntax(_ type: SwiftType, startTokenHandler: StartTokenHandler) -> TypeSyntax {
        _typeDepth += 1
        defer { _typeDepth -= 1 }

        switch type {
        case .nominal(let nominal):
            return makeNominalTypeSyntax(nominal, startTokenHandler: startTokenHandler).asTypeSyntax
            
        case .implicitUnwrappedOptional(let type):
            return SyntaxFactory
                .makeImplicitlyUnwrappedOptionalType(
                    wrappedType: makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler),
                    exclamationMark: SyntaxFactory.makeExclamationMarkToken()
                ).asTypeSyntax
            
        case .nullabilityUnspecified(let type):
            let type = makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler)
            
            return asNullabilityUnspecified(type)
            
        case .optional(let type):
            return SyntaxFactory
                .makeOptionalType(
                    wrappedType: makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler),
                    questionMark: SyntaxFactory.makePostfixQuestionMarkToken()
                ).asTypeSyntax
            
        case .metatype(let type):
            return SyntaxFactory
                .makeMetatypeType(
                    baseType: makeTypeSyntax(type, startTokenHandler: startTokenHandler),
                    period: SyntaxFactory.makePeriodToken(),
                    typeOrProtocol: SyntaxFactory.makeTypeToken()
                ).asTypeSyntax
            
        case .nested(let nested):
            return makeNestedTypeSyntax(nested, startTokenHandler: startTokenHandler).asTypeSyntax
            
        case let .block(blockType):
            let returnType = blockType.returnType
            let parameters = blockType.parameters
            let attributes = blockType.attributes.sorted(by: { $0.description < $1.description })
            
            return AttributedTypeSyntax { builder in
                let functionType = FunctionTypeSyntax { builder in
                    builder.useArrow(
                        SyntaxFactory
                            .makeArrowToken()
                            .addingSurroundingSpaces()
                    )
                    builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                    builder.useRightParen(SyntaxFactory.makeRightParenToken())
                    builder.useReturnType(makeTypeSyntax(returnType, startTokenHandler: startTokenHandler))
                    
                    // Parameters
                    makeTupleTypeSyntax(parameters, startTokenHandler: startTokenHandler)
                        .elements
                        .forEach { builder.addArgument($0) }
                }.asTypeSyntax
                
                builder.useBaseType(functionType)
                
                for attribute in attributes {
                    let attrSyntax: AttributeSyntax
                    switch attribute {
                    case .autoclosure:
                        attrSyntax = SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("autoclosure"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: nil
                            )
                        
                    case .escaping:
                        attrSyntax = SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("escaping"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: nil
                            )
                        
                    case .convention(let convention):
                        attrSyntax = SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("convention"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: SyntaxFactory.makeTokenList([
                                    SyntaxFactory.makeLeftParenToken(),
                                    makeIdentifier(convention.rawValue),
                                    SyntaxFactory
                                        .makeRightParenToken()
                                        .withTrailingSpace()
                                ])
                            )
                    }
                    
                    builder.addAttribute(Syntax(attrSyntax))
                }
            }.asTypeSyntax
            
        case .tuple(let tuple):
            switch tuple {
            case .types(let types):
                return makeTupleTypeSyntax(types, startTokenHandler: startTokenHandler).asTypeSyntax
                
            case .empty:
                return SyntaxFactory.makeTypeIdentifier("Void")
            }
            
        case .protocolComposition(let composition):
            return CompositionTypeSyntax { builder in
                let count = composition.count
                
                for (i, type) in composition.enumerated() {
                    builder.addElement(CompositionTypeElementSyntax { builder in
                        
                        switch type {
                        case .nested(let nested):
                            builder.useType(makeNestedTypeSyntax(nested, startTokenHandler: startTokenHandler).asTypeSyntax)
                            
                        case .nominal(let nominal):
                            builder.useType(makeNominalTypeSyntax(nominal, startTokenHandler: startTokenHandler).asTypeSyntax)
                        }
                        
                        if i != count - 1 {
                            builder.useAmpersand(
                                SyntaxFactory
                                    .makePrefixAmpersandToken()
                                    .addingSurroundingSpaces()
                            )
                        }
                    })
                }
            }.asTypeSyntax
            
        case .array(let inner):
            return ArrayTypeSyntax { builder in
                builder.useLeftSquareBracket(
                    SyntaxFactory
                        .makeLeftSquareBracketToken()
                )
                builder.useRightSquareBracket(
                    SyntaxFactory
                        .makeRightSquareBracketToken()
                )
                
                builder.useElementType(makeTypeSyntax(inner, startTokenHandler: startTokenHandler))
            }.asTypeSyntax
            
        case let .dictionary(key, value):
            return DictionaryTypeSyntax { builder in
                builder.useLeftSquareBracket(
                    SyntaxFactory
                        .makeLeftSquareBracketToken()
                )
                builder.useColon(
                    SyntaxFactory
                        .makeColonToken()
                        .withTrailingSpace()
                )
                builder.useRightSquareBracket(
                    SyntaxFactory
                        .makeRightSquareBracketToken()
                )
                
                builder.useKeyType(makeTypeSyntax(key, startTokenHandler: startTokenHandler))
                builder.useValueType(makeTypeSyntax(value, startTokenHandler: startTokenHandler))
            }.asTypeSyntax
        }
    }
    
    func makeTupleTypeSyntax<C: Collection>(_ types: C, startTokenHandler: StartTokenHandler) -> TupleTypeSyntax where C.Element == SwiftType {
        TupleTypeSyntax { builder in
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            iterateWithComma(types) { (type, hasComma) in
                builder.addElement(TupleTypeElementSyntax { builder in
                    builder.useType(makeTypeSyntax(type, startTokenHandler: startTokenHandler))
                    
                    if hasComma {
                        builder.useTrailingComma(
                            SyntaxFactory
                                .makeCommaToken()
                                .withTrailingSpace()
                        )
                    }
                })
            }
        }
    }

    func makeNestedTypeSyntax(_ nestedType: NestedSwiftType, startTokenHandler: StartTokenHandler) -> MemberTypeIdentifierSyntax {
        let typeSyntax = makeNominalTypeSyntax(nestedType.second, startTokenHandler: startTokenHandler)
        
        let initial = SyntaxFactory
            .makeMemberTypeIdentifier(
                baseType: makeNominalTypeSyntax(nestedType.first, startTokenHandler: startTokenHandler).asTypeSyntax,
                period: SyntaxFactory.makePeriodToken(),
                name: typeSyntax.name,
                genericArgumentClause: typeSyntax.genericArgumentClause
            )
        
        return nestedType.reduce(initial) { (previous, type) in
            let typeSyntax = self.makeNominalTypeSyntax(type, startTokenHandler: startTokenHandler)
            
            return SyntaxFactory
                .makeMemberTypeIdentifier(
                    baseType: previous.asTypeSyntax,
                    period: SyntaxFactory.makePeriodToken(),
                    name: typeSyntax.name,
                    genericArgumentClause: typeSyntax.genericArgumentClause
                )
        }
    }
    
    func makeNominalTypeSyntax(_ nominal: NominalSwiftType, startTokenHandler: StartTokenHandler) -> SimpleTypeIdentifierSyntax {
        switch nominal {
        case .typeName(let name):
            return SyntaxFactory
                .makeSimpleTypeIdentifier(
                    name: startTokenHandler.prepareStartToken(SyntaxFactory.makeIdentifier(name)),
                    genericArgumentClause: nil
                )
            
        case let .generic(name, parameters):
            let nameSyntax = startTokenHandler.prepareStartToken(SyntaxFactory.makeIdentifier(name))
            
            let types = parameters.map { makeTypeSyntax($0, startTokenHandler: startTokenHandler) }
            
            let genericArgumentList =
                SyntaxFactory
                    .makeGenericArgumentList(
                        mapWithComma(types) { (type, hasComma) -> GenericArgumentSyntax in
                            SyntaxFactory
                                .makeGenericArgument(
                                    argumentType: type,
                                    trailingComma: hasComma
                                        ? SyntaxFactory
                                            .makeCommaToken()
                                            .withTrailingSpace()
                                        : nil)
                        })
            
            let genericArgumentClause = SyntaxFactory
                .makeGenericArgumentClause(
                    leftAngleBracket: SyntaxFactory.makeLeftAngleToken(),
                    arguments: genericArgumentList,
                    rightAngleBracket: SyntaxFactory.makeRightAngleToken()
                )
            
            return SyntaxFactory.makeSimpleTypeIdentifier(
                name: nameSyntax,
                genericArgumentClause: genericArgumentClause
            )
        }
    }
    
    func makeWrappedInParensIfRequired(_ type: SwiftType, startTokenHandler: StartTokenHandler) -> TypeSyntax {
        if type.requiresSurroundingParens {
            return TypeSyntax(makeTupleTypeSyntax([type], startTokenHandler: startTokenHandler))
        }
        
        return makeTypeSyntax(type, startTokenHandler: startTokenHandler)
    }
}
