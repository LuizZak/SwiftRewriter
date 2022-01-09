import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    
    /// Generates an expression syntax for the given expression.
    public func generateExpression(_ expression: Expression) -> ExprSyntax {
        switch expression {
        case let exp as ExpressionKindType:
            return generateExpressionKind(exp.expressionKind)
            
        default:
            assertionFailure("Found unknown expression syntax node type \(type(of: expression))")
            return SyntaxFactory.makeBlankAsExpr().asExprSyntax
        }
    }

    func generateExpressionKind(_ expressionKind: ExpressionKind) -> ExprSyntax {
        switch expressionKind {
        case .identifier(let exp):
            return generateIdentifier(exp).asExprSyntax
            
        case .binary(let exp):
            return generateBinary(exp).asExprSyntax
            
        case .unary(let exp):
            return generateUnary(exp)
            
        case .prefix(let exp):
            return generatePrefix(exp)
            
        case .sizeOf(let exp):
            return generateSizeOf(exp)
            
        case .assignment(let exp):
            return generateAssignment(exp).asExprSyntax
            
        case .constant(let exp):
            return generateConstant(exp)
            
        case .arrayLiteral(let exp):
            return generateArrayLiteral(exp).asExprSyntax
            
        case .dictionaryLiteral(let exp):
            return generateDictionaryLiteral(exp).asExprSyntax
            
        case .postfix(let exp):
            return generatePostfix(exp)
            
        case .parens(let exp):
            return generateParens(exp)
            
        case .cast(let exp):
            return generateCast(exp).asExprSyntax
        
        case .typeCheck(let exp):
            return generateTypeCheck(exp).asExprSyntax
            
        case .ternary(let exp):
            return generateTernary(exp)
            
        case .tuple(let exp):
            return generateTuple(exp)
            
        case .selector(let exp):
            return generateSelector(exp)
            
        case .blockLiteral(let exp):
            return generateClosure(exp).asExprSyntax

        case .unknown:
            return SyntaxFactory.makeBlankUnknownExpr().asExprSyntax
        }
    }
    
    public func generateSizeOf(_ exp: SizeOfExpression) -> ExprSyntax {
        func _forType(_ type: SwiftType) -> ExprSyntax {
            MemberAccessExprSyntax { builder in
                let base = SpecializeExprSyntax { builder in
                    let token = prepareStartToken(
                        SyntaxFactory.makeIdentifier("MemoryLayout")
                    )
                    
                    builder.useExpression(
                        SyntaxFactory
                            .makeIdentifierExpr(identifier: token,
                                                declNameArguments: nil)
                            .asExprSyntax
                    )
                    
                    builder.useGenericArgumentClause(GenericArgumentClauseSyntax { builder in
                        builder.useLeftAngleBracket(
                            SyntaxFactory.makeLeftAngleToken()
                        )
                        
                        builder.useRightAngleBracket(
                            SyntaxFactory.makeRightAngleToken()
                        )
                        
                        builder.addArgument(GenericArgumentSyntax { builder in
                            builder.useArgumentType(
                                SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self)
                            )
                        })
                    })
                }
                
                builder.useBase(base.asExprSyntax)
                builder.useDot(SyntaxFactory.makePeriodToken())
                builder.useName(makeIdentifier("size"))
            }.asExprSyntax
        }
        
        switch exp.value {
        case .expression(let exp):
            if case let .metatype(innerType)? = exp.resolvedType {
                return _forType(innerType)
            }
            
            return generateExpression(
                Expression
                    .identifier("MemoryLayout")
                    .dot("size")
                    .call([.labeled("ofValue", exp.copy())])
            )
        
        case .type(let type):
            return _forType(type)
        }
    }
    
    public func generateParens(_ exp: ParensExpression) -> ExprSyntax {
        TupleExprSyntax { builder in
            builder.useLeftParen(makeStartToken(SyntaxFactory.makeLeftParenToken))
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            builder.addElement(TupleExprElementSyntax { builder in
                builder.useExpression(generateExpression(exp.exp))
            })
        }.asExprSyntax
    }
    
    public func generateIdentifier(_ exp: IdentifierExpression) -> IdentifierExprSyntax {
        IdentifierExprSyntax { builder in
            builder.useIdentifier(prepareStartToken(makeIdentifier(exp.identifier)))
        }
    }
    
    public func generateCast(_ exp: CastExpression) -> SequenceExprSyntax {
        SequenceExprSyntax { builder in
            builder.addElement(generateExpression(exp.exp))
            
            builder.addElement(AsExprSyntax { builder in
                if exp.isOptionalCast {
                    builder.useAsTok(
                        SyntaxFactory
                            .makeAsKeyword()
                            .withLeadingSpace()
                    )
                    
                    builder.useQuestionOrExclamationMark(
                        SyntaxFactory
                            .makePostfixQuestionMarkToken()
                            .withTrailingSpace()
                    )
                } else {
                    builder.useAsTok(
                        SyntaxFactory
                            .makeAsKeyword()
                            .addingSurroundingSpaces()
                    )
                }
                
                builder.useTypeName(SwiftTypeConverter.makeTypeSyntax(exp.type, startTokenHandler: self))
            }.asExprSyntax)
        }
    }
    
    public func generateTypeCheck(_ exp: TypeCheckExpression) -> SequenceExprSyntax {
        SequenceExprSyntax { builder in
            builder.addElement(generateExpression(exp.exp))
            
            builder.addElement(IsExprSyntax { builder in
                builder.useIsTok(
                    SyntaxFactory
                        .makeIsKeyword()
                        .addingSurroundingSpaces()
                )
                
                builder.useTypeName(SwiftTypeConverter.makeTypeSyntax(exp.type, startTokenHandler: self))
            }.asExprSyntax)
        }
    }
    
    public func generateClosure(_ exp: BlockLiteralExpression) -> ClosureExprSyntax {
        ClosureExprSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            
            let hasParameters = !exp.parameters.isEmpty
            let requiresTypeSignature =
                exp.resolvedType == nil || exp.resolvedType != exp.expectedType
            
            let signature = ClosureSignatureSyntax { builder in
                if hasParameters || requiresTypeSignature {
                    builder.useInTok(
                        SyntaxFactory.makeInKeyword().addingLeadingSpace()
                    )
                }
                
                if requiresTypeSignature {
                    builder.useOutput(generateReturnType(exp.returnType))
                }
                
                let parameters = ParameterClauseSyntax { builder in
                    addExtraLeading(.spaces(1))
                    
                    if requiresTypeSignature {
                        builder.useLeftParen(
                            SyntaxFactory
                                .makeLeftParenToken()
                                .withExtraLeading(from: self)
                        )
                        
                        builder.useRightParen(SyntaxFactory.makeRightParenToken())
                    }
                    
                    iterateWithComma(exp.parameters) { (arg, hasComma) in
                        builder.addParameter(FunctionParameterSyntax { builder in
                            builder.useFirstName(
                                makeIdentifier(arg.name)
                                    .withExtraLeading(from: self))
                            
                            if requiresTypeSignature {
                                builder.useColon(
                                    SyntaxFactory
                                        .makeColonToken()
                                        .withTrailingSpace()
                                )
                                
                                builder.useType(
                                    SwiftTypeConverter
                                        .makeTypeSyntax(arg.type, startTokenHandler: self)
                                )
                            }
                            
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
                
                builder.useInput(parameters.asSyntax)
            }
            
            builder.useSignature(signature)
            
            indent()
            
            extraLeading = nil
            
            let statements = _generateStatements(exp.body.statements)
            for stmt in statements {
                builder.addStatement(stmt)
            }
            
            deindent()
            
            extraLeading = .newlines(1) + indentation()
            
            builder.useRightBrace(makeStartToken(SyntaxFactory.makeRightBraceToken))
        }
    }
    
    public func generateArrayLiteral(_ exp: ArrayLiteralExpression) -> ArrayExprSyntax {
        ArrayExprSyntax { builder in
            builder.useLeftSquare(
                makeStartToken(SyntaxFactory.makeLeftSquareBracketToken)
            )
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
            
            iterateWithComma(exp.items) { (item, hasComma) in
                builder.addElement(ArrayElementSyntax { builder in
                    builder.useExpression(generateExpression(item))
                    
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
    
    public func generateDictionaryLiteral(_ exp: DictionaryLiteralExpression) -> DictionaryExprSyntax {
        DictionaryExprSyntax { builder in
            builder.useLeftSquare(
                makeStartToken(SyntaxFactory.makeLeftSquareBracketToken)
            )
            
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
            
            if exp.pairs.isEmpty {
                builder.useContent(SyntaxFactory.makeColonToken().asSyntax)
            } else {
                var elements: [DictionaryElementSyntax] = []
                
                iterateWithComma(exp.pairs) { (item, hasComma) in
                    elements.append(
                        DictionaryElementSyntax { builder in
                            builder.useKeyExpression(generateExpression(item.key))
                            builder.useColon(
                                SyntaxFactory
                                    .makeColonToken()
                                    .withTrailingSpace()
                            )
                            builder.useValueExpression(generateExpression(item.value))
                            
                            if hasComma {
                                builder.useTrailingComma(
                                    SyntaxFactory
                                        .makeCommaToken()
                                        .withTrailingSpace()
                                )
                            }
                        }
                    )
                }
                
                builder.useContent(
                    SyntaxFactory
                        .makeDictionaryElementList(elements)
                        .asSyntax
                )
            }
        }
    }
    
    public func generateAssignment(_ exp: AssignmentExpression) -> SequenceExprSyntax {
        SequenceExprSyntax { builder in
            builder.addElement(generateExpression(exp.lhs))
            
            addExtraLeading(.spaces(1))
            
            builder.addElement(generateOperator(exp.op, mode: .assignment))
            
            addExtraLeading(.spaces(1))
            
            builder.addElement(generateExpression(exp.rhs))
        }
    }
    
    public func generateUnary(_ exp: UnaryExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    public func generatePrefix(_ exp: PrefixExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    public func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
        SequenceExprSyntax { builder in
            builder.addElement(generateExpression(exp.lhs))
            
            if exp.op.category != .range {
                addExtraLeading(.spaces(1))
            }
            
            builder.addElement(generateOperator(exp.op, mode: .infix))
            
            if exp.op.category != .range {
                addExtraLeading(.spaces(1))
            }
            
            builder.addElement(generateExpression(exp.rhs))
        }
    }
    
    public func generatePostfix(_ exp: PostfixExpression) -> ExprSyntax {
        func makeExprSyntax(
            _ exp: Expression,
            optionalAccessKind: Postfix.OptionalAccessKind
        ) -> ExprSyntax {
            
            let base = generateWithinParensIfNeccessary(exp)
            
            switch optionalAccessKind {
            case .none:
                return base
                
            case .safeUnwrap:
                return OptionalChainingExprSyntax { builder in
                    builder.useExpression(base)
                    builder.useQuestionMark(
                        SyntaxFactory
                            .makePostfixQuestionMarkToken()
                    )
                }.asExprSyntax
                
            case .forceUnwrap:
                return ForcedValueExprSyntax { builder in
                    builder.useExpression(base)
                    builder.useExclamationMark(
                        SyntaxFactory
                            .makeExclamationMarkToken()
                    )
                }.asExprSyntax
            }
        }
        
        let subExp = makeExprSyntax(exp.exp, optionalAccessKind: exp.op.optionalAccessKind)
        
        switch exp.op {
        case let member as MemberPostfix:
            return MemberAccessExprSyntax { builder in
                builder.useBase(subExp)
                builder.useDot(SyntaxFactory.makePeriodToken())
                builder.useName(makeIdentifier(member.name))
            }.asExprSyntax
            
        case let subs as SubscriptPostfix:
            return SubscriptExprSyntax { builder in
                builder.useCalledExpression(subExp)
                iterateWithComma(subs.arguments) { (arg, hasComma) in
                    builder.addArgument(TupleExprElementSyntax { builder in
                        if let label = arg.label {
                            builder.useLabel(makeIdentifier(label))
                            builder.useColon(
                                SyntaxFactory
                                    .makeColonToken()
                                    .withTrailingSpace()
                            )
                        }
                        
                        let argExpSyntax = generateExpression(arg.expression)
                        
                        builder.useExpression(argExpSyntax)
                        
                        if hasComma {
                            builder.useTrailingComma(
                                SyntaxFactory
                                    .makeCommaToken()
                                    .withTrailingSpace()
                            )
                        }
                    })
                }
                builder.useLeftBracket(SyntaxFactory.makeLeftSquareBracketToken())
                builder.useRightBracket(SyntaxFactory.makeRightSquareBracketToken())
            }.asExprSyntax
            
        case let call as FunctionCallPostfix:
            var arguments = call.arguments
            
            var trailingClosure: BlockLiteralExpression?
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            // Exception: If the second-to-last argument is also a closure argument,
            // don't use trailing closure syntax, since it results in confusing-looking
            // code.
            if let block = arguments.last?.expression as? BlockLiteralExpression,
                !(arguments.dropLast().last?.expression is BlockLiteralExpression) {
                
                trailingClosure = block
                arguments.removeLast()
            }
            
            return FunctionCallExprSyntax { builder in
                builder.useCalledExpression(subExp)
                
                iterateWithComma(arguments) { (arg, hasComma) in
                    builder.addArgument(TupleExprElementSyntax { builder in
                        if let label = arg.label {
                            builder.useLabel(makeIdentifier(label))
                            builder.useColon(
                                SyntaxFactory
                                    .makeColonToken()
                                    .withTrailingSpace()
                            )
                        }
                        
                        let argExpSyntax = generateExpression(arg.expression)
                        
                        builder.useExpression(argExpSyntax)
                        
                        if hasComma {
                            builder.useTrailingComma(
                                SyntaxFactory
                                    .makeCommaToken()
                                    .withTrailingSpace()
                            )
                        }
                    })
                }
                
                if let trailingClosure = trailingClosure {
                    addExtraLeading(.spaces(1))
                    builder.useTrailingClosure(
                        generateClosure(trailingClosure)
                    )
                }
                
                // No need to emit parenthesis if a trailing closure
                // is present as the only argument of the function
                if !arguments.isEmpty || trailingClosure == nil {
                    builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                    builder.useRightParen(SyntaxFactory.makeRightParenToken())
                }
            }.asExprSyntax
            
        default:
            return SyntaxFactory.makeBlankPostfixUnaryExpr().asExprSyntax
        }
    }
    
    public func generateTernary(_ exp: TernaryExpression) -> ExprSyntax {
        TernaryExprSyntax { builder in
            builder.useConditionExpression(generateExpression(exp.exp))
            builder.useQuestionMark(
                SyntaxFactory
                    .makeInfixQuestionMarkToken()
                    .addingSurroundingSpaces()
            )
            builder.useFirstChoice(generateExpression(exp.ifTrue))
            builder.useColonMark(
                SyntaxFactory
                    .makeColonToken()
                    .addingSurroundingSpaces()
            )
            builder.useSecondChoice(generateExpression(exp.ifFalse))
        }.asExprSyntax
    }
    
    public func generateTuple(_ exp: TupleExpression) -> ExprSyntax {
        TupleExprSyntax { builder in
            builder.useLeftParen(makeStartToken(SyntaxFactory.makeLeftParenToken))
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            iterateWithComma(exp.elements) { (item, hasComma) in
                builder.addElement(TupleExprElementSyntax { builder in
                    builder.useExpression(generateExpression(item))
                    
                    if hasComma {
                        builder.useTrailingComma(
                            SyntaxFactory
                                .makeCommaToken()
                                .withTrailingSpace()
                        )
                    }
                })
            }
        }.asExprSyntax
    }
    
    public func generateSelector(_ exp: SelectorExpression) -> ExprSyntax {
        return ObjcSelectorExprSyntax { builder in
            builder.usePoundSelector(makeStartToken(SyntaxFactory.makePoundSelectorKeyword))
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            func makePropReference(type: SwiftType?, property: String) -> ExprSyntax {
                if let type = type {
                    return MemberAccessExprSyntax { builder in
                        builder.useBase(
                            SyntaxFactory
                                .makeTypeExpr(type: SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self))
                                .asExprSyntax
                        )
                        builder.useDot(SyntaxFactory.makePeriodToken())
                        builder.useName(makeIdentifier(property))
                    }.asExprSyntax
                }

                return SyntaxFactory
                    .makeIdentifierExpr(
                        identifier: makeIdentifier(property),
                        declNameArguments: nil
                    ).asExprSyntax
            }

            switch exp.kind {
            case let .function(type, identifier):
                builder.useName(generateFunctionIdentifier(type: type, identifier))

            case let .getter(type, property):
                builder.useKind(makeIdentifier("getter"))
                builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                builder.useName(makePropReference(type: type, property: property))

            case let .setter(type, property):
                builder.useKind(makeIdentifier("setter"))
                builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                builder.useName(makePropReference(type: type, property: property))
            }
        }.asExprSyntax
    }
    
    public func generateConstant(_ constant: ConstantExpression) -> ExprSyntax {
        switch constant.constant {
        case .boolean(let bool):
            let tokenFactory = bool ? SyntaxFactory.makeTrueKeyword : SyntaxFactory.makeFalseKeyword
            let token = makeStartToken(tokenFactory)
            
            return SyntaxFactory
                .makeBooleanLiteralExpr(booleanLiteral: token)
                .asExprSyntax
            
        case .nil:
            return SyntaxFactory
                .makeNilLiteralExpr(nilKeyword: prepareStartToken(SyntaxFactory.makeNilKeyword()))
                .asExprSyntax
            
        case let .int(value, type):
            let digits: TokenSyntax
            
            switch type {
            case .binary:
                digits = SyntaxFactory
                    .makeIntegerLiteral("0b" + String(value, radix: 2))
                
            case .decimal:
                digits = SyntaxFactory.makeIntegerLiteral(value.description)
                
            case .octal:
                digits = SyntaxFactory
                    .makeIntegerLiteral("0o" + String(value, radix: 8))
                
            case .hexadecimal:
                digits = SyntaxFactory
                    .makeIntegerLiteral("0x" + String(value, radix: 16))
            }
            
            return SyntaxFactory
                .makeIntegerLiteralExpr(digits: prepareStartToken(digits))
                .asExprSyntax
            
        case .float(let value):
            let digits = prepareStartToken(
                SyntaxFactory
                    .makeFloatingLiteral(value.description)
            )
            
            return SyntaxFactory
                .makeFloatLiteralExpr(floatingDigits: digits)
                .asExprSyntax
            
        case .double(let value):
            let digits = prepareStartToken(
                SyntaxFactory
                    .makeFloatingLiteral(value.description)
            )
            
            return SyntaxFactory
                .makeFloatLiteralExpr(floatingDigits: digits)
                .asExprSyntax
            
        case .string(let string):
            return StringLiteralExprSyntax { builder in
                builder.useOpenQuote(
                    prepareStartToken(SyntaxFactory.makeStringQuoteToken()))
                
                builder.addSegment(SyntaxFactory.makeStringLiteral(string).asSyntax)
                builder.useCloseQuote(SyntaxFactory.makeStringQuoteToken())
            }.asExprSyntax
            
        case .rawConstant(let constant):
            return IdentifierExprSyntax { builder in
                builder.useIdentifier(prepareStartToken(makeIdentifier(constant)))
            }.asExprSyntax
        }
    }
    
    func generateOperator(_ op: SwiftOperator, mode: OperatorMode) -> ExprSyntax {
        let producer: (SwiftOperator) -> ExprSyntax
        
        switch mode {
        case .assignment:
            producer = { op in
                return AssignmentExprSyntax { builder in
                    builder.useAssignToken(
                        self.prepareStartToken(
                            SyntaxFactory.makeSpacedBinaryOperator(op.rawValue)
                        )
                    )
                }.asExprSyntax
            }
            
        case .prefix(let exp):
            producer = { op in
                return PrefixOperatorExprSyntax { builder in
                    builder.useOperatorToken(
                        self.prepareStartToken(
                            SyntaxFactory.makePrefixOperator(op.rawValue)
                        )
                    )
                    builder.usePostfixExpression(exp())
                }.asExprSyntax
            }
        case .infix:
            producer = { op in
                return BinaryOperatorExprSyntax { builder in
                    let token = self.prepareStartToken(
                        SyntaxFactory.makeSpacedBinaryOperator(op.rawValue)
                    )
                    
                    builder.useOperatorToken(token)
                }.asExprSyntax
            }
        case .postfix(let exp):
            producer = { op in
                return PostfixUnaryExprSyntax { builder in
                    builder.useOperatorToken(
                        self.prepareStartToken(
                            SyntaxFactory.makePrefixOperator(op.rawValue)
                        )
                    )
                    builder.useExpression(exp())
                }.asExprSyntax
            }
        }
        
        return producer(op)
    }
    
    func generateWithinParensIfNeccessary(_ exp: Expression) -> ExprSyntax {
        if exp.requiresParens {
            return TupleExprSyntax { builder in
                builder.useLeftParen(
                    makeStartToken(SyntaxFactory.makeLeftParenToken))
                
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                builder.addElement(TupleExprElementSyntax { builder in
                    builder.useExpression(generateExpression(exp))
                })
            }.asExprSyntax
        }
        
        return generateExpression(exp)
    }
    
    func generateFunctionIdentifier(type: SwiftType?, _ ident: FunctionIdentifier) -> ExprSyntax {
        let declArgs = DeclNameArgumentsSyntax { builder in
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            for arg in ident.argumentLabels {
                builder.addArgument(DeclNameArgumentSyntax { builder in
                    if let arg = arg {
                        builder.useName(makeIdentifier(arg))
                    } else {
                        builder.useName(SyntaxFactory.makeWildcardKeyword())
                    }
                    
                    builder.useColon(SyntaxFactory.makeColonToken())
                })
            }
        }
        
        if let type = type {
            let typeSyntax = SwiftTypeConverter.makeTypeSyntax(type, startTokenHandler: self)
            
            return MemberAccessExprSyntax { builder in
                builder.useBase(
                    SyntaxFactory
                        .makeTypeExpr(type: typeSyntax)
                        .asExprSyntax
                )
                
                builder.useDot(SyntaxFactory.makePeriodToken())
                
                builder.useName(makeIdentifier(ident.name))
                builder.useDeclNameArguments(declArgs)
            }.asExprSyntax
        } else {
            return IdentifierExprSyntax { builder in
                builder.useIdentifier(prepareStartToken(makeIdentifier(ident.name)))
                builder.useDeclNameArguments(declArgs)
            }.asExprSyntax
        }
    }
    
    enum OperatorMode {
        case assignment
        case prefix(() -> ExprSyntax)
        case infix
        case postfix(() -> ExprSyntax)
    }
}
