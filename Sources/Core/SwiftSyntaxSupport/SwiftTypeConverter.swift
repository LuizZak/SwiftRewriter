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
            return OptionalTypeSyntax(wrappedType: type).asTypeSyntax
        } else {
            return ImplicitlyUnwrappedOptionalTypeSyntax(
                wrappedType: type
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
            return ImplicitlyUnwrappedOptionalTypeSyntax(
                    wrappedType: makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler)
                ).asTypeSyntax
            
        case .nullabilityUnspecified(let type):
            let type = makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler)
            
            return asNullabilityUnspecified(type)
            
        case .optional(let type):
            return OptionalTypeSyntax(
                    wrappedType: makeWrappedInParensIfRequired(type, startTokenHandler: startTokenHandler)
                ).asTypeSyntax
            
        case .metatype(let type):
            return MetatypeTypeSyntax(
                    baseType: makeTypeSyntax(type, startTokenHandler: startTokenHandler),
                    metatypeSpecifier: makeIdentifier("Type")
                ).asTypeSyntax
            
        case .nested(let nested):
            return makeNestedTypeSyntax(nested, startTokenHandler: startTokenHandler).asTypeSyntax
            
        case let .block(blockType):
            let returnType = blockType.returnType
            let parameters = blockType.parameters
            let attributes = blockType.attributes.sorted(by: { $0.description < $1.description })
            
            let functionTypeSyntax = makeFunctionTypeSyntax(
                parameters: parameters,
                returnType: returnType,
                startTokenHandler: startTokenHandler
            )
            
            var syntax = AttributedTypeSyntax(baseType: functionTypeSyntax)
            
            for attribute in attributes {
                let attrSyntax: AttributeSyntax
                switch attribute {
                case .autoclosure:
                    attrSyntax = AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: makeIdentifierType("autoclosure").withTrailingSpace(),
                        leftParen: nil,
                        arguments: nil,
                        rightParen: nil
                    )
                    
                case .escaping:
                    attrSyntax = AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: makeIdentifierType("escaping").withTrailingSpace(),
                        leftParen: nil,
                        arguments: nil,
                        rightParen: nil
                    )
                    
                case .convention(let convention):
                    attrSyntax = AttributeSyntax(
                        atSign: .atSignToken(),
                        attributeName: makeIdentifierType("convention"),
                        leftParen: .leftParenToken(),
                        arguments: .argumentList([.init(expression: makeIdentifierExpr(convention.rawValue))]),
                        rightParen: .rightParenToken().withTrailingSpace()
                    )
                }
                
                syntax.attributes.append(.attribute(attrSyntax))
            }

            return syntax.asTypeSyntax
            
        case .tuple(let tuple):
            switch tuple {
            case .types(let types):
                return makeTupleTypeSyntax(types, startTokenHandler: startTokenHandler).asTypeSyntax
                
            case .empty:
                return IdentifierTypeSyntax(name: makeIdentifier("Void")).asTypeSyntax
            }
            
        case .protocolComposition(let composition):
            var syntax = CompositionTypeSyntax(elements: [])
            let count = composition.count
                
            for (i, type) in composition.enumerated() {
                var elementSyntax: CompositionTypeElementSyntax
                
                switch type {
                case .nested(let nested):
                    elementSyntax = CompositionTypeElementSyntax(
                        type: makeNestedTypeSyntax(
                            nested,
                            startTokenHandler: startTokenHandler
                        ).asTypeSyntax
                    )
                    
                case .nominal(let nominal):
                    elementSyntax = CompositionTypeElementSyntax(
                        type: makeNominalTypeSyntax(
                            nominal,
                            startTokenHandler: startTokenHandler
                        ).asTypeSyntax
                    )
                }
                
                if i != count - 1 {
                    elementSyntax = elementSyntax.with(
                        \.ampersand,
                        .prefixAmpersandToken().addingSurroundingSpaces()
                    )
                }

                syntax.elements.append(elementSyntax)
            }

            return syntax.asTypeSyntax
            
        case .array(let inner):
            let syntax = ArrayTypeSyntax(
                element: makeTypeSyntax(inner, startTokenHandler: startTokenHandler)
            )

            return syntax.asTypeSyntax
            
        case let .dictionary(key, value):
            let syntax = DictionaryTypeSyntax(
                key: makeTypeSyntax(key, startTokenHandler: startTokenHandler),
                colon: .colonToken().withTrailingSpace(),
                value: makeTypeSyntax(value, startTokenHandler: startTokenHandler)
            )

            return syntax.asTypeSyntax
        }
    }

    func makeFunctionTypeSyntax(
        parameters: [SwiftType],
        returnType: SwiftType,
        startTokenHandler: StartTokenHandler
    ) -> FunctionTypeSyntax {

        let syntax = FunctionTypeSyntax(
            leftParen: .leftParenToken(),
            parameters: makeTupleTypeSyntax(parameters, startTokenHandler: startTokenHandler).elements,
            rightParen: .rightParenToken(),
            returnClause: makeReturnClauseSyntax(makeTypeSyntax(returnType, startTokenHandler: startTokenHandler))
        )

        return syntax
    }

    func makeReturnClauseSyntax(
        _ type: TypeSyntaxProtocol
    ) -> ReturnClauseSyntax {
        
        ReturnClauseSyntax(
            arrow: .arrowToken().addingSurroundingSpaces(),
            type: type
        )
    }
    
    func makeTupleTypeSyntax<C: Collection>(_ types: C, startTokenHandler: StartTokenHandler) -> TupleTypeSyntax where C.Element == SwiftType {
        var syntax = TupleTypeSyntax(elements: [])
        
        iterateWithComma(types) { (type, hasComma) in
            syntax.elements.append(
                makeTupleTypeElementSyntax(
                    type,
                    hasComma: hasComma,
                    startTokenHandler: startTokenHandler
                )
            )
        }

        return syntax
    }

    func makeTupleTypeElementSyntax(
        _ type: SwiftType,
        hasComma: Bool,
        startTokenHandler: StartTokenHandler
    ) -> TupleTypeElementSyntax {

        var syntax = TupleTypeElementSyntax(
            type: makeTypeSyntax(type, startTokenHandler: startTokenHandler)
        )

        if hasComma {
            syntax = syntax.with(
                \.trailingComma,
                .commaToken().withTrailingSpace()
            )
        }

        return syntax
    }

    func makeNestedTypeSyntax(_ nestedType: NestedSwiftType, startTokenHandler: StartTokenHandler) -> MemberTypeSyntax {
        let typeSyntax = makeNominalTypeSyntax(
            nestedType.second,
            startTokenHandler: startTokenHandler
        )
        
        let initial = MemberTypeSyntax(
            baseType: makeNominalTypeSyntax(
                nestedType.first,
                startTokenHandler: startTokenHandler
            ),
            period: .periodToken(),
            name: typeSyntax.name,
            genericArgumentClause: typeSyntax.genericArgumentClause
        )
        
        return nestedType.reduce(initial) { (previous, type) in
            let typeSyntax = self.makeNominalTypeSyntax(
                type,
                startTokenHandler: startTokenHandler
            )
            
            return MemberTypeSyntax(
                baseType: previous.asTypeSyntax,
                period: .periodToken(),
                name: typeSyntax.name,
                genericArgumentClause: typeSyntax.genericArgumentClause
            )
        }
    }
    
    func makeNominalTypeSyntax(_ nominal: NominalSwiftType, startTokenHandler: StartTokenHandler) -> IdentifierTypeSyntax {
        switch nominal {
        case .typeName(let name):
            return IdentifierTypeSyntax(
                name: startTokenHandler.prepareStartToken(.identifier(name)),
                genericArgumentClause: nil
            )
            
        case let .generic(name, parameters):
            let nameSyntax = startTokenHandler.prepareStartToken(.identifier(name))
            
            let types = parameters.map { makeTypeSyntax($0, startTokenHandler: startTokenHandler) }
            
            let genericArgumentList = GenericArgumentListSyntax(
                mapWithComma(types) { (type, hasComma) -> GenericArgumentSyntax in
                    GenericArgumentSyntax(
                        argument: type,
                        trailingComma: hasComma
                            ? .commaToken().withTrailingSpace()
                            : nil
                    )
                }
            )
            
            let genericArgumentClause = GenericArgumentClauseSyntax(
                arguments: genericArgumentList
            )
            
            return IdentifierTypeSyntax(
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
