import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateExpression(_ expression: Expression) -> ExprSyntax {
        switch expression {
        case let exp as IdentifierExpression:
            return generateIdentifier(exp).asExprSyntax
            
        case let exp as BinaryExpression:
            return generateBinary(exp).asExprSyntax
            
        case let exp as UnaryExpression:
            return generateUnary(exp)
            
        case let exp as PrefixExpression:
            return generatePrefix(exp)
            
        case let exp as SizeOfExpression:
            return generateSizeOf(exp)
            
        case let exp as AssignmentExpression:
            return generateAssignment(exp).asExprSyntax
            
        case let exp as ConstantExpression:
            return generateConstant(exp)
            
        case let exp as ArrayLiteralExpression:
            return generateArrayLiteral(exp).asExprSyntax
            
        case let exp as DictionaryLiteralExpression:
            return generateDictionaryLiteral(exp).asExprSyntax
            
        case let exp as PostfixExpression:
            return generatePostfix(exp)
            
        case let exp as ParensExpression:
            return generateParens(exp)
            
        case let exp as CastExpression:
            return generateCast(exp).asExprSyntax
            
        case let exp as TernaryExpression:
            return generateTernary(exp)
            
        case let exp as TupleExpression:
            return generateTuple(exp)
            
        case let exp as SelectorExpression:
            return generateSelector(exp)
            
        case let exp as BlockLiteralExpression:
            return generateClosure(exp).asExprSyntax
            
        case is UnknownExpression:
            return SyntaxFactory.makeBlankUnknownExpr().asExprSyntax
            
        default:
            assertionFailure("Found unknown expression syntax node type \(type(of: expression))")
            return SyntaxFactory.makeBlankAsExpr().asExprSyntax
        }
    }
    
    func generateSizeOf(_ exp: SizeOfExpression) -> ExprSyntax {
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
                                SwiftTypeConverter.makeTypeSyntax(type)
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
    
    func generateParens(_ exp: ParensExpression) -> ExprSyntax {
        TupleExprSyntax { builder in
            builder.useLeftParen(makeStartToken(SyntaxFactory.makeLeftParenToken))
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            builder.addElement(TupleExprElementSyntax { builder in
                builder.useExpression(generateExpression(exp.exp))
            })
        }.asExprSyntax
    }
    
    func generateIdentifier(_ exp: IdentifierExpression) -> IdentifierExprSyntax {
        IdentifierExprSyntax { builder in
            builder.useIdentifier(prepareStartToken(makeIdentifier(exp.identifier)))
        }
    }
    
    func generateCast(_ exp: CastExpression) -> SequenceExprSyntax {
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
                
                builder.useTypeName(SwiftTypeConverter.makeTypeSyntax(exp.type))
            }.asExprSyntax)
        }
    }
    
    func generateClosure(_ exp: BlockLiteralExpression) -> ClosureExprSyntax {
        ClosureExprSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            
            let hasParameters = !exp.parameters.isEmpty
            let requiresTypeSignatuer =
                exp.resolvedType == nil || exp.resolvedType != exp.expectedType
            
            let signature = ClosureSignatureSyntax { builder in
                if hasParameters || requiresTypeSignatuer {
                    builder.useInTok(
                        SyntaxFactory.makeInKeyword().addingLeadingSpace()
                    )
                }
                
                if requiresTypeSignatuer {
                    builder.useOutput(generateReturn(exp.returnType))
                }
                
                let parameters = ParameterClauseSyntax { builder in
                    addExtraLeading(.spaces(1))
                    
                    if requiresTypeSignatuer {
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
                            
                            if requiresTypeSignatuer {
                                builder.useColon(
                                    SyntaxFactory
                                        .makeColonToken()
                                        .withTrailingSpace()
                                )
                                
                                builder.useType(
                                    SwiftTypeConverter
                                        .makeTypeSyntax(arg.type)
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
    
    func generateArrayLiteral(_ exp: ArrayLiteralExpression) -> ArrayExprSyntax {
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
    
    func generateDictionaryLiteral(_ exp: DictionaryLiteralExpression) -> DictionaryExprSyntax {
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
    
    func generateAssignment(_ exp: AssignmentExpression) -> SequenceExprSyntax {
        SequenceExprSyntax { builder in
            builder.addElement(generateExpression(exp.lhs))
            
            addExtraLeading(.spaces(1))
            
            builder.addElement(generateOperator(exp.op, mode: .assignment))
            
            addExtraLeading(.spaces(1))
            
            builder.addElement(generateExpression(exp.rhs))
        }
    }
    
    func generateUnary(_ exp: UnaryExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    func generatePrefix(_ exp: PrefixExpression) -> ExprSyntax {
        generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
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
    
    func generatePostfix(_ exp: PostfixExpression) -> ExprSyntax {
        func makeExprSyntax(_ exp: Expression,
                            optionalAccessKind: Postfix.OptionalAccessKind) -> ExprSyntax {
            
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
    
    func generateTernary(_ exp: TernaryExpression) -> ExprSyntax {
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
    
    func generateTuple(_ exp: TupleExpression) -> ExprSyntax {
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
    
    func generateSelector(_ exp: SelectorExpression) -> ExprSyntax {
        return ObjcSelectorExprSyntax { builder in
            builder.usePoundSelector(makeStartToken(SyntaxFactory.makePoundSelectorKeyword))
            builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            
            func makePropReference(type: SwiftType?, property: String) -> ExprSyntax {
                if let type = type {
                    return MemberAccessExprSyntax { builder in
                        builder.useBase(
                            SyntaxFactory
                                .makeTypeExpr(type: SwiftTypeConverter.makeTypeSyntax(type))
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
    
    func generateConstant(_ constant: ConstantExpression) -> ExprSyntax {
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
            let typeSyntax = SwiftTypeConverter.makeTypeSyntax(type)
            
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
