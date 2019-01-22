import SwiftSyntax
import Intentions
import SwiftAST

extension SwiftSyntaxProducer {
    func generateExpression(_ expression: Expression) -> ExprSyntax {
        switch expression {
        case let exp as IdentifierExpression:
            return generateIdentifier(exp)
            
        case let exp as BinaryExpression:
            return generateBinary(exp)
            
        case let exp as UnaryExpression:
            return generateUnary(exp)
            
        case let exp as PrefixExpression:
            return generatePrefix(exp)
            
        case let exp as SizeOfExpression:
            return generateSizeOf(exp)
            
        case let exp as AssignmentExpression:
            return generateAssignment(exp)
            
        case let exp as ConstantExpression:
            return generateConstant(exp)
            
        case let exp as ArrayLiteralExpression:
            return generateArrayLiteral(exp)
            
        case let exp as DictionaryLiteralExpression:
            return generateDictionaryLiteral(exp)
            
        case let exp as PostfixExpression:
            return generatePostfix(exp)
            
        case let exp as ParensExpression:
            return generateParens(exp)
            
        case let exp as CastExpression:
            return generateCast(exp)
            
        case let exp as TernaryExpression:
            return generateTernary(exp)
            
        case let exp as BlockLiteralExpression:
            return generateClosure(exp)
            
        case is UnknownExpression:
            return SyntaxFactory.makeBlankUnknownExpr()
            
        default:
            return SyntaxFactory.makeBlankAsExpr()
        }
    }
    
    func generateSizeOf(_ exp: SizeOfExpression) -> ExprSyntax {
        func _forType(_ type: SwiftType) -> ExprSyntax {
            return MemberAccessExprSyntax { builder in
                let base = SpecializeExprSyntax { builder in
                    let token = prepareStartToken(SyntaxFactory.makeIdentifier("MemoryLayout"))
                    
                    builder.useExpression(
                        SyntaxFactory
                            .makeIdentifierExpr(identifier: token,
                                                declNameArguments: nil)
                    )
                    
                    builder.useGenericArgumentClause(GenericArgumentClauseSyntax { builder in
                        builder.useLeftAngleBracket(SyntaxFactory.makeLeftAngleToken())
                        builder.useRightAngleBracket(SyntaxFactory.makeRightAngleToken())
                        builder.addGenericArgument(GenericArgumentSyntax { builder in
                            builder.useArgumentType(SwiftTypeConverter.makeTypeSyntax(type))
                        })
                    })
                }
                
                builder.useBase(base)
                builder.useDot(SyntaxFactory.makePeriodToken())
                builder.useName(makeIdentifier("size"))
            }
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
        return TupleExprSyntax { builder in
            builder.useLeftParen(makeStartToken(SyntaxFactory.makeLeftParenToken))
            builder.useRightParen(SyntaxFactory.makeRightParenToken())
            builder.addTupleElement(TupleElementSyntax { builder in
                builder.useExpression(generateExpression(exp.exp))
            })
        }
    }
    
    func generateIdentifier(_ exp: IdentifierExpression) -> IdentifierExprSyntax {
        return IdentifierExprSyntax { builder in
            builder.useIdentifier(prepareStartToken(makeIdentifier(exp.identifier)))
        }
    }
    
    func generateCast(_ exp: CastExpression) -> SequenceExprSyntax {
        return SequenceExprSyntax { builder in
            builder.addExpression(generateExpression(exp.exp))
            
            builder.addExpression(AsExprSyntax { builder in
                if exp.isOptionalCast {
                    builder.useAsTok(SyntaxFactory.makeAsKeyword().withLeadingSpace())
                    builder.useQuestionOrExclamationMark(SyntaxFactory.makePostfixQuestionMarkToken().withTrailingSpace())
                } else {
                    builder.useAsTok(SyntaxFactory.makeAsKeyword().addingSurroundingSpaces())
                }
                
                builder.useTypeName(SwiftTypeConverter.makeTypeSyntax(exp.type))
            })
        }
    }
    
    func generateClosure(_ exp: BlockLiteralExpression) -> ClosureExprSyntax {
        return ClosureExprSyntax { builder in
            builder.useLeftBrace(makeStartToken(SyntaxFactory.makeLeftBraceToken))
            
            if exp.resolvedType == nil || exp.resolvedType != exp.expectedType {
                let signature = ClosureSignatureSyntax { builder in
                    builder.useInTok(SyntaxFactory.makeInKeyword().addingLeadingSpace())
                    
                    addExtraLeading(.newlines(1))
                    
                    builder.useOutput(generateReturn(exp.returnType))
                    
                    let parameters = ParameterClauseSyntax { builder in
                        builder.useLeftParen(SyntaxFactory
                            .makeLeftParenToken()
                            .addingLeadingSpace()
                        )
                        builder.useRightParen(SyntaxFactory.makeRightParenToken())
                        
                        iterateWithComma(exp.parameters) { (arg, hasComma) in
                            builder.addFunctionParameter(FunctionParameterSyntax { builder in
                                builder.useFirstName(makeIdentifier(arg.name))
                                builder.useColon(SyntaxFactory
                                    .makeColonToken()
                                    .withTrailingSpace()
                                )
                                
                                builder.useType(SwiftTypeConverter.makeTypeSyntax(arg.type))
                                
                                if hasComma {
                                    builder.useTrailingComma(SyntaxFactory
                                        .makeCommaToken()
                                        .withTrailingSpace()
                                    )
                                }
                            })
                        }
                    }
                    
                    builder.useInput(parameters)
                }
                
                builder.useSignature(signature)
            }
            
            indent()
            
            extraLeading = nil
            
            let statements = _generateStatements(exp.body.statements)
            for stmt in statements {
                builder.addCodeBlockItem(stmt)
            }
            
            deindent()
            
            extraLeading = .newlines(1) + indentation()
            
            builder.useRightBrace(makeStartToken(SyntaxFactory.makeRightBraceToken))
        }
    }
    
    func generateArrayLiteral(_ exp: ArrayLiteralExpression) -> ArrayExprSyntax {
        return ArrayExprSyntax { builder in
            builder.useLeftSquare(makeStartToken(SyntaxFactory.makeLeftSquareBracketToken))
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
            
            iterateWithComma(exp.items) { (item, hasComma) in
                builder.addArrayElement(ArrayElementSyntax { builder in
                    builder.useExpression(generateExpression(item))
                    
                    if hasComma {
                        builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
                    }
                })
            }
        }
    }
    
    func generateDictionaryLiteral(_ exp: DictionaryLiteralExpression) -> DictionaryExprSyntax {
        return DictionaryExprSyntax { builder in
            builder.useLeftSquare(makeStartToken(SyntaxFactory.makeLeftSquareBracketToken))
            builder.useRightSquare(SyntaxFactory.makeRightSquareBracketToken())
            
            if exp.pairs.isEmpty {
                builder.useContent(SyntaxFactory.makeColonToken())
            } else {
                var elements: [DictionaryElementSyntax] = []
                
                iterateWithComma(exp.pairs) { (item, hasComma) in
                    elements.append(
                        DictionaryElementSyntax { builder in
                            builder.useKeyExpression(generateExpression(item.key))
                            builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                            builder.useValueExpression(generateExpression(item.value))
                            
                            if hasComma {
                                builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
                            }
                        }
                    )
                }
                
                builder.useContent(SyntaxFactory.makeDictionaryElementList(elements))
            }
        }
    }
    
    func generateAssignment(_ exp: AssignmentExpression) -> SequenceExprSyntax {
        return SequenceExprSyntax { builder in
            builder.addExpression(generateExpression(exp.lhs))
            
            addExtraLeading(.spaces(1))
            
            builder.addExpression(generateOperator(exp.op, mode: .assignment))
            
            addExtraLeading(.spaces(1))
            
            builder.addExpression(generateExpression(exp.rhs))
        }
    }
    
    func generateUnary(_ exp: UnaryExpression) -> ExprSyntax {
        return generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    func generatePrefix(_ exp: PrefixExpression) -> ExprSyntax {
        return generateOperator(exp.op, mode: .prefix({ self.generateWithinParensIfNeccessary(exp.exp) }))
    }
    
    func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
        return SequenceExprSyntax { builder in
            builder.addExpression(generateWithinParensIfNeccessary(exp.lhs))
            
            if exp.op.category != .range {
                addExtraLeading(.spaces(1))
            }
            
            builder.addExpression(generateOperator(exp.op, mode: .infix))
            
            if exp.op.category != .range {
                addExtraLeading(.spaces(1))
            }
            
            builder.addExpression(generateWithinParensIfNeccessary(exp.rhs))
        }
    }
    
    func generatePostfix(_ exp: PostfixExpression) -> ExprSyntax {
        func makeExprSyntax(_ exp: Expression, optionalAccessKind: Postfix.OptionalAccessKind) -> ExprSyntax {
            let base = generateWithinParensIfNeccessary(exp)
            
            switch optionalAccessKind {
            case .none:
                return base
                
            case .safeUnwrap:
                return OptionalChainingExprSyntax { builder in
                    builder.useExpression(base)
                    builder.useQuestionMark(SyntaxFactory.makePostfixQuestionMarkToken())
                }
                
            case .forceUnwrap:
                return ForcedValueExprSyntax { builder in
                    builder.useExpression(base)
                    builder.useExclamationMark(SyntaxFactory.makeExclamationMarkToken())
                }
            }
        }
        
        let subExp = makeExprSyntax(exp.exp, optionalAccessKind: exp.op.optionalAccessKind)
        
        switch exp.op {
        case let member as MemberPostfix:
            return MemberAccessExprSyntax { builder in
                builder.useBase(subExp)
                builder.useDot(SyntaxFactory.makePeriodToken())
                builder.useName(makeIdentifier(member.name))
            }
            
        case let subs as SubscriptPostfix:
            return SubscriptExprSyntax { builder in
                builder.useCalledExpression(subExp)
                builder.addFunctionCallArgument(FunctionCallArgumentSyntax { builder in
                    builder.useExpression(generateExpression(subs.expression))
                })
                builder.useLeftBracket(SyntaxFactory.makeLeftSquareBracketToken())
                builder.useRightBracket(SyntaxFactory.makeRightSquareBracketToken())
            }
            
        case let call as FunctionCallPostfix:
            var arguments = call.arguments
            
            var trailingClosure: BlockLiteralExpression?
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            if let block = arguments.last?.expression as? BlockLiteralExpression {
                trailingClosure = block
                arguments.removeLast()
            }
            
            return FunctionCallExprSyntax { builder in
                builder.useCalledExpression(subExp)
                
                iterateWithComma(arguments) { (arg, hasComma) in
                    builder.addFunctionCallArgument(FunctionCallArgumentSyntax { builder in
                        if let label = arg.label {
                            builder.useLabel(makeIdentifier(label))
                            builder.useColon(SyntaxFactory.makeColonToken().withTrailingSpace())
                        }
                        
                        let argExpSyntax = generateExpression(arg.expression)
                        
                        builder.useExpression(argExpSyntax)
                        
                        if hasComma {
                            builder.useTrailingComma(SyntaxFactory.makeCommaToken().withTrailingSpace())
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
            }
            
        default:
            return SyntaxFactory.makeBlankPostfixUnaryExpr()
        }
    }
    
    func generateTernary(_ exp: TernaryExpression) -> ExprSyntax {
        return TernaryExprSyntax { builder in
            builder.useConditionExpression(generateExpression(exp.exp))
            builder.useQuestionMark(SyntaxFactory.makeInfixQuestionMarkToken().addingSurroundingSpaces())
            builder.useFirstChoice(generateExpression(exp.ifTrue))
            builder.useColonMark(SyntaxFactory.makeColonToken().addingSurroundingSpaces())
            builder.useSecondChoice(generateExpression(exp.ifFalse))
        }
    }
    
    func generateConstant(_ constant: ConstantExpression) -> ExprSyntax {
        switch constant.constant {
        case .boolean(let bool):
            let tokenFactory = bool ? SyntaxFactory.makeTrueKeyword : SyntaxFactory.makeFalseKeyword
            let token = makeStartToken(tokenFactory)
            
            return SyntaxFactory.makeBooleanLiteralExpr(booleanLiteral: token)
            
        case .nil:
            return SyntaxFactory.makeNilLiteralExpr(nilKeyword: prepareStartToken(SyntaxFactory.makeNilKeyword()))
            
        case let .int(value, type):
            let digits: TokenSyntax
            
            switch type {
            case .binary:
                digits = SyntaxFactory.makeIntegerLiteral("0b" + String(value, radix: 2))
                
            case .decimal:
                digits = SyntaxFactory.makeIntegerLiteral(value.description)
                
            case .octal:
                digits = SyntaxFactory.makeIntegerLiteral("0o" + String(value, radix: 8))
                
            case .hexadecimal:
                digits = SyntaxFactory.makeIntegerLiteral("0x" + String(value, radix: 16))
            }
            
            return SyntaxFactory.makeIntegerLiteralExpr(digits: prepareStartToken(digits))
            
        case .float(let value):
            return SyntaxFactory.makeFloatLiteralExpr(floatingDigits: prepareStartToken(SyntaxFactory.makeFloatingLiteral(value.description)))
            
        case .string(let string):
            return StringLiteralExprSyntax { builder in
                builder.useStringLiteral(prepareStartToken(SyntaxFactory.makeStringLiteral("\"" + string + "\"")))
            }
            
        case .rawConstant(let constant):
            return IdentifierExprSyntax { builder in
                builder.useIdentifier(prepareStartToken(makeIdentifier(constant)))
            }
        }
    }
    
    func generateOperator(_ op: SwiftOperator, mode: OperatorMode) -> ExprSyntax {
        let producer: (SwiftOperator) -> ExprSyntax
        
        switch mode {
        case .assignment:
            producer = { op in
                return AssignmentExprSyntax { builder in
                    builder.useAssignToken(self.prepareStartToken(SyntaxFactory.makeSpacedBinaryOperator(op.rawValue)))
                }
            }
            
        case .prefix(let exp):
            producer = { op in
                return PrefixOperatorExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makePrefixOperator(op.rawValue)))
                    builder.usePostfixExpression(exp())
                }
            }
        case .infix:
            producer = { op in
                return BinaryOperatorExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makeSpacedBinaryOperator(op.rawValue)))
                }
            }
        case .postfix(let exp):
            producer = { op in
                return PostfixUnaryExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makePrefixOperator(op.rawValue)))
                    builder.useExpression(exp())
                }
            }
        }
        
        return producer(op)
    }
    
    func generateWithinParensIfNeccessary(_ exp: Expression) -> ExprSyntax {
        if exp.requiresParens {
            return TupleExprSyntax { builder in
                builder.useLeftParen(makeStartToken(SyntaxFactory.makeLeftParenToken))
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
                builder.addTupleElement(TupleElementSyntax { builder in
                    builder.useExpression(generateExpression(exp))
                })
            }
        }
        
        return generateExpression(exp)
    }
    
    enum OperatorMode {
        case assignment
        case prefix(() -> ExprSyntax)
        case infix
        case postfix(() -> ExprSyntax)
    }
}
