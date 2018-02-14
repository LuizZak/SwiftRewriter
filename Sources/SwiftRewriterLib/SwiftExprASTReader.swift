import GrammarModels
import ObjcParserAntlr
import ObjcParser
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
        if let typeName = ctx.typeName(), let typeNameString = VarDeclarationTypeExtractor.extract(from: typeName),
            let cast = ctx.castExpression()?.accept(self), let type = try? ObjcParser(string: typeNameString).parseObjcType() {
            return Expression.cast(cast, type: type)
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
        var result: Expression
        
        if let primary = ctx.primaryExpression() {
            guard let prim = primary.accept(self) else {
                return nil
            }
            
            result = prim
        } else if let postfixExpression = ctx.postfixExpression() {
            guard let postfix = postfixExpression.accept(self) else {
                return nil
            }
            guard let identifier = ctx.identifier() else {
                return nil
            }
            
            result = .postfix(postfix, .member(identifier.getText()))
        } else {
            return nil
        }
        
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
            } else if post.LBRACK() != nil, let expression = post.expression() {
                guard let expr = expression.accept(self) else {
                    continue
                }
                
                // Subscription
                result = .postfix(result, .subscript(expr))
            }
        }
        
        return result
    }
    
    public override func visitMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext) -> Expression? {
        guard let receiverExpression = ctx.receiver()?.expression() else {
            return nil
        }
        guard let receiver = receiverExpression.accept(self) else {
            return nil
        }
        
        if let identifier = ctx.messageSelector()?.selector()?.identifier()?.getText() {
            return Expression.postfix(Expression.postfix(receiver, .member(identifier)), .functionCall(arguments: []))
        }
        guard let keywordArguments = ctx.messageSelector()?.keywordArgument() else {
            return nil
        }
        
        var name: String = ""
        
        var arguments: [FunctionArgument] = []
        for (i, keyword) in keywordArguments.enumerated() {
            let selectorText = keyword.selector()?.getText() ?? ""
            
            if i == 0 {
                // First keyword is always the method's name, Swift doesn't support
                // 'nameless' methods!
                if keyword.selector() == nil {
                    return nil
                }
                
                name = selectorText
            }
            
            for keywordArgumentType in keyword.keywordArgumentType() {
                guard let expressions = keywordArgumentType.expressions() else {
                    return nil
                }
                
                for (j, expression) in expressions.expression().enumerated() {
                    guard let exp = expression.accept(self) else {
                        return nil
                    }
                    
                    // Every argument after the first one is unlabeled
                    if j == 0 && i > 0 {
                        arguments.append(.labeled(selectorText, exp))
                    } else {
                        arguments.append(.unlabeled(exp))
                    }
                }
            }
        }
        
        return Expression.postfix(.postfix(receiver, .member(name)), .functionCall(arguments: arguments))
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
        if let messageExpression = ctx.messageExpression() {
            return messageExpression.accept(self)
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
