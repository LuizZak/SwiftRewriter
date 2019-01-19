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
            
        default:
            return SyntaxFactory.makeBlankAsExpr()
        }
    }
    
    private func generateBinary(_ exp: BinaryExpression) -> SequenceExprSyntax {
        let lhs = generateExpression(exp.lhs)
        let rhs = generateExpression(exp.rhs)
        
        return SequenceExprSyntax { builder in
            builder.addExpression(lhs)
            builder.addExpression(generateOperator(exp.op, mode: .infix))
            builder.addExpression(rhs)
        }
    }
    
    private func generateOperator(_ op: SwiftOperator, mode: OperatorMode) -> ExprSyntax {
        let producer: (SwiftOperator) -> ExprSyntax
        
        switch mode {
        case .prefix(let exp):
            producer = { op in
                return PrefixOperatorExprSyntax { builder in
                    builder.useOperatorToken(SyntaxFactory.makePrefixOperator(op.rawValue))
                    builder.usePostfixExpression(exp)
                }
            }
        case .infix:
            producer = { op in
                return BinaryOperatorExprSyntax { builder in
                    builder.useOperatorToken(SyntaxFactory.makePrefixOperator(op.rawValue))
                }
            }
        case .postfix(let exp):
            producer = { op in
                return PostfixUnaryExprSyntax { builder in
                    builder.useOperatorToken(SyntaxFactory.makePrefixOperator(op.rawValue))
                    builder.useExpression(exp)
                }
            }
        }
        
        return producer(op)
    }
    
    private func generateIdentifier(_ identifier: IdentifierExpression) -> IdentifierExprSyntax {
        return IdentifierExprSyntax { builder in
            builder.useIdentifier(makeIdentifier(identifier.identifier))
        }
    }
    
    private enum OperatorMode {
        case prefix(ExprSyntax)
        case infix
        case postfix(ExprSyntax)
    }
}
