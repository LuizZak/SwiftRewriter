import GrammarModels
import ObjcParserAntlr
import Antlr4

/// A visitor that reads simple Objective-C expressions and emits as Expression
/// enum cases.
public class SwiftExprASTReader: ObjectiveCParserBaseVisitor<Expression> {
    public override func visitExpression(_ ctx: ObjectiveCParser.ExpressionContext) -> Expression? {
        if let cast = ctx.castExpression() {
            return cast.accept(self)
        }
        
        return nil
    }
    
    public override func visitCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext) -> Expression? {
        if let unary = ctx.unaryExpression() {
            return unary.accept(self)
        }
        
        return nil
    }
    
    public override func visitUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext) -> Expression? {
        if let postfix = ctx.postfixExpression() {
            return postfix.accept(self)
        }
        
        return nil
    }
    
    public override func visitPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext) -> Expression? {
        if let primary = ctx.primaryExpression() {
            guard let prim = primary.accept(self) else {
                return nil
            }
            
            var result = prim
            
            for post in ctx.postfixExpr() {
                // Function call
                if post.LP() != nil {
                    var arguments: [FunctionArgument] = []
                    
                    if let args = post.argumentExpressionList() {
                        let funcArgVisitor = FunctionArgumentVisitor()
                        
                        for arg in args.argumentExpression() {
                            if let funcArg = arg.accept(funcArgVisitor) {
                                arguments.append(funcArg)
                            }
                        }
                    }
                    
                    result = .postfix(result, .functionCall(arguments: arguments))
                }
            }
            
            return result
        }
        
        return nil
    }
    
    public override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> Expression? {
        if let exp = ctx.expression() {
            return exp.accept(self)
        }
        
        return nil
    }
    
    public override func visitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) -> Expression? {
        if let constant = ctx.constant() {
            return constant.accept(self)
        }
        if let string = ctx.stringLiteral() {
            return string.accept(self)
        }
        if let ident = ctx.identifier() {
            return .identifier(ident.getText())
        }
        
        return nil
    }
    
    public override func visitStringLiteral(_ ctx: ObjectiveCParser.StringLiteralContext) -> Expression? {
        let value = ctx.STRING_VALUE().map {
            // TODO: Support conversion of hexadecimal and octal digits properly.
            // Octal literals need to be converted before being proper to use.
            $0.getText()
        }.joined()
        
        return .constant(.string(value))
    }
    
    public override func visitConstant(_ ctx: ObjectiveCParser.ConstantContext) -> Expression? {
        if let int = ctx.DECIMAL_LITERAL(), let intV = Int(int.getText()) {
            return .constant(.int(intV))
        }
        if let oct = ctx.OCTAL_LITERAL(), let int = Int(oct.getText(), radix: 8) {
            return .constant(.octal(int))
        }
        if let binary = ctx.BINARY_LITERAL(), let int = Int(binary.getText().dropFirst(2), radix: 2) {
            return .constant(.binary(int))
        }
        if let hex = ctx.HEX_LITERAL(), let int = Int(hex.getText().dropFirst(2), radix: 16) {
            return .constant(.hexadecimal(int))
        }
        if ctx.YES() != nil || ctx.TRUE() != nil {
            return .constant(.boolean(true))
        }
        if ctx.NO() != nil || ctx.FALSE() != nil {
            return .constant(.boolean(false))
        }
        if ctx.NULL() != nil || ctx.NIL() != nil {
            return .constant(.nil)
        }
        if let float = ctx.FLOATING_POINT_LITERAL(), let value = Float(float.getText()) {
            return .constant(.float(value))
        }
        
        return nil
    }
    
    private class FunctionArgumentVisitor: ObjectiveCParserBaseVisitor<FunctionArgument> {
        override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> FunctionArgument? {
            if let exp = ctx.expression() {
                let astReader = SwiftExprASTReader()
                guard let expEnum = exp.accept(astReader) else {
                    return nil
                }
                
                return .unlabeled(expEnum)
            }
            
            return nil
        }
    }
}
