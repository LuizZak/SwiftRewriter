import SwiftAST

public class ExpressionTypeResolver: SyntaxNodeRewriter {
    public override init() {
        super.init()
    }
    
    public override func visitConstant(_ exp: ConstantExpression) -> Expression {
        switch exp.constant {
        case .int, .hexadecimal, .octal, .binary:
            exp.resolvedType = .int
        case .string:
            exp.resolvedType = .string
        case .float:
            exp.resolvedType = .float
        case .boolean:
            exp.resolvedType = .bool
        case .nil:
            exp.resolvedType = .optional(.anyObject)
        case .rawConstant:
            exp.resolvedType = .any
        default:
            break
        }
        
        return super.visitConstant(exp)
    }
}
