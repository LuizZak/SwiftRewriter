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
            
        case let exp as ConstantExpression:
            return generateConstant(exp)
            
        case let exp as PostfixExpression:
            return generatePostfix(exp)
            
        default:
            return SyntaxFactory.makeBlankAsExpr()
        }
    }
    
    private func generateIdentifier(_ identifier: IdentifierExpression) -> IdentifierExprSyntax {
        return IdentifierExprSyntax { builder in
            builder.useIdentifier(prepareStartToken(makeIdentifier(identifier.identifier)))
        }
    }
    
    private func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
        let lhs = generateExpression(exp.lhs)
        extraLeading = .spaces(1)
        let op = generateOperator(exp.op, mode: .infix)
        extraLeading = .spaces(1)
        let rhs = generateExpression(exp.rhs)
        
        return SequenceExprSyntax { builder in
            builder.addExpression(lhs)
            builder.addExpression(op)
            builder.addExpression(rhs)
        }
    }
    
    private func generatePostfix(_ exp: PostfixExpression) -> ExprSyntax {
        let subExp = generateExpression(exp.exp)
        
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
            return FunctionCallExprSyntax { builder in
                builder.useCalledExpression(subExp)
                
                iterateWithComma(call.arguments) { (arg, hasComma) in
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
                
                builder.useLeftParen(SyntaxFactory.makeLeftParenToken())
                builder.useRightParen(SyntaxFactory.makeRightParenToken())
            }
            
        default:
            return SyntaxFactory.makeBlankPostfixUnaryExpr()
        }
    }
    
    private func generateConstant(_ constant: ConstantExpression) -> ExprSyntax {
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
    
    private func generateOperator(_ op: SwiftOperator, mode: OperatorMode) -> ExprSyntax {
        let producer: (SwiftOperator) -> ExprSyntax
        
        switch mode {
        case .prefix(let exp):
            producer = { op in
                return PrefixOperatorExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makePrefixOperator(op.rawValue)))
                    builder.usePostfixExpression(exp)
                }
            }
        case .infix:
            producer = { op in
                return BinaryOperatorExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makePrefixOperator(op.rawValue)))
                }
            }
        case .postfix(let exp):
            producer = { op in
                return PostfixUnaryExprSyntax { builder in
                    builder.useOperatorToken(self.prepareStartToken(SyntaxFactory.makePrefixOperator(op.rawValue)))
                    builder.useExpression(exp)
                }
            }
        }
        
        return producer(op)
    }
    
    private enum OperatorMode {
        case prefix(ExprSyntax)
        case infix
        case postfix(ExprSyntax)
    }
}
