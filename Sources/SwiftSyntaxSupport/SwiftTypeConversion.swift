import SwiftSyntax
import SwiftAST

public class SwiftTypeConverter {
    public static func makeTypeSyntax(_ type: SwiftType) -> TypeSyntax {
        return SwiftTypeConverter().makeTypeSyntax(type)
    }
    
    private var _blockStackLevel = 0
    
    private init() {
        
    }
    
    func makeWrappedInParensIfRequired(_ type: SwiftType) -> TypeSyntax {
        if type.requiresSurroundingParens {
            return makeTupleTypeSyntax([type])
        }
        
        return makeTypeSyntax(type)
    }
    
    func makeTypeSyntax(_ type: SwiftType) -> TypeSyntax {
        switch type {
        case .nominal(let nominal):
            return makeNominalTypeSyntax(nominal)
            
        case .implicitUnwrappedOptional(let type):
            return SyntaxFactory
                .makeImplicitlyUnwrappedOptionalType(
                    wrappedType: makeWrappedInParensIfRequired(type),
                    exclamationMark: SyntaxFactory.makeExclamationMarkToken()
                )
            
        case .nullabilityUnspecified(let type):
            let type = makeWrappedInParensIfRequired(type)
            
            if _blockStackLevel > 0 {
                return SyntaxFactory
                    .makeOptionalType(
                        wrappedType: type,
                        questionMark: SyntaxFactory.makePostfixQuestionMarkToken()
                    )
            } else {
                return SyntaxFactory
                    .makeImplicitlyUnwrappedOptionalType(
                        wrappedType: type,
                        exclamationMark: SyntaxFactory.makeExclamationMarkToken()
                    )
            }
            
        case .optional(let type):
            return SyntaxFactory
                .makeOptionalType(
                    wrappedType: makeWrappedInParensIfRequired(type),
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
            _blockStackLevel += 1
            defer {
                _blockStackLevel -= 1
            }
            
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
                        .forEach { builder.addArgument($0) }
                }
                
                builder.useBaseType(functionType)
                
                for attribute in attributes {
                    switch attribute {
                    case .autoclosure:
                        builder.addAttribute(SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("autoclosure"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: nil
                            )
                        )
                        
                    case .escaping:
                        builder.addAttribute(SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("escaping"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: nil
                            )
                        )
                        
                    case .convention(let convention):
                        builder.addAttribute(SyntaxFactory
                            .makeAttribute(
                                atSignToken: SyntaxFactory.makeAtSignToken(),
                                attributeName: makeIdentifier("convention"),
                                leftParen: nil,
                                argument: nil,
                                rightParen: nil,
                                tokenList: SyntaxFactory.makeTokenList([
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
                    builder.addElement(CompositionTypeElementSyntax { builder in
                        
                        switch type {
                        case .nested(let nested):
                            builder.useType(makeNestedTypeSyntax(nested))
                            
                        case .nominal(let nominal):
                            builder.useType(makeNominalTypeSyntax(nominal))
                        }
                        
                        if i != count - 1 {
                            builder.useAmpersand(SyntaxFactory.makePrefixAmpersandToken().addingSurroundingSpaces())
                        }
                    })
                }
            }
            
        case .array(let inner):
            return ArrayTypeSyntax { builder in
                builder.useLeftSquareBracket(SyntaxFactory.makeLeftSquareBracketToken())
                builder.useRightSquareBracket(SyntaxFactory.makeRightSquareBracketToken())
                
                builder.useElementType(makeTypeSyntax(inner))
            }
            
        case let .dictionary(key, value):
            return DictionaryTypeSyntax { builder in
                builder.useLeftSquareBracket(SyntaxFactory.makeLeftSquareBracketToken())
                builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                builder.useRightSquareBracket(SyntaxFactory.makeRightSquareBracketToken())
                
                builder.useKeyType(makeTypeSyntax(key))
                builder.useValueType(makeTypeSyntax(value))
            }
        }
    }
    
    func makeTupleTypeSyntax<C: Collection>(_ types: C) -> TupleTypeSyntax where C.Element == SwiftType {
        return TupleTypeSyntax { builder in
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            iterateWithComma(types) { (type, hasComma) in
                builder.addElement(TupleTypeElementSyntax { builder in
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
            let typeSyntax = self.makeNominalTypeSyntax(type)
            
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
                    .makeGenericArgumentList(
                        mapWithComma(types) { (type, hasComma) -> GenericArgumentSyntax in
                            SyntaxFactory
                                .makeGenericArgument(
                                    argumentType: type,
                                    trailingComma: hasComma ? SyntaxFactory.makeCommaToken().withTrailingSpace() : nil)
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
}
