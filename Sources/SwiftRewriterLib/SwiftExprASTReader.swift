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
        // Ternary expression
        if ctx.QUESTION() != nil {
            guard let exp = ctx.expression(0)?.accept(self) else {
                return nil
            }
            
            let ifTrue = ctx.trueExpression?.accept(self)
            
            guard let ifFalse = ctx.falseExpression?.accept(self) else {
                return nil
            }
            
            if let ifTrue = ifTrue {
                return .ternary(exp, true: ifTrue, false: ifFalse)
            } else {
                return .binary(lhs: exp, op: .nullCoallesce, rhs: ifFalse)
            }
        }
        // Assignment expression
        if let assignmentExpression = ctx.assignmentExpression {
            guard let unaryExpr = ctx.unaryExpression()?.accept(self) else {
                return nil
            }
            guard let assignExpr = assignmentExpression.accept(self) else {
                return nil
            }
            guard let assignOp = ctx.assignmentOperator() else {
                return nil
            }
            guard let op = swiftOperator(from: assignOp.getText()) else {
                return nil
            }
            
            return
                Expression.assignment(lhs: unaryExpr, op: op, rhs: assignExpr)
        }
        // Binary expression
        if ctx.expression().count == 2 {
            guard let lhs = ctx.expression(0)?.accept(self) else {
                return nil
            }
            guard let rhs = ctx.expression(1)?.accept(self) else {
                return nil
            }
            guard let op = ctx.op?.getText() else {
                return nil
            }
            
            // << / >>
            if ctx.LT().count == 2 {
                return Expression.binary(lhs: lhs, op: .bitwiseShiftLeft, rhs: rhs)
            }
            if ctx.GT().count == 2 {
                return Expression.binary(lhs: lhs, op: .bitwiseShiftRight, rhs: rhs)
            }
            
            if let op = SwiftOperator(rawValue: op) {
                return Expression.binary(lhs: lhs, op: op, rhs: rhs)
            }
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
        if ctx.INC() != nil, let exp = ctx.unaryExpression()?.accept(self) {
            return Expression.assignment(lhs: exp, op: .addAssign, rhs: .constant(1))
        }
        if ctx.DEC() != nil, let exp = ctx.unaryExpression()?.accept(self) {
            return Expression.assignment(lhs: exp, op: .subtractAssign, rhs: .constant(1))
        }
        if let op = ctx.unaryOperator(), let exp = ctx.castExpression()?.accept(self) {
            guard let swiftOp = SwiftOperator(rawValue: op.getText()) else {
                return nil
            }
            
            return Expression.unary(op: swiftOp, exp)
        }
        
        return acceptFirst(from: ctx.postfixExpression())
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
            } else if post.INC() != nil {
                result = .assignment(lhs: result, op: .addAssign, rhs: .constant(1))
            } else if post.DEC() != nil {
                result = .assignment(lhs: result, op: .subtractAssign, rhs: .constant(1))
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
        
        return .postfix(.postfix(receiver, .member(name)), .functionCall(arguments: arguments))
    }
    
    public override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> Expression? {
        return acceptFirst(from: ctx.expression())
    }
    
    public override func visitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) -> Expression? {
        if ctx.LP() != nil, let exp = ctx.expression()?.accept(self) {
            return Expression.parens(exp)
        }
        
        return
            acceptFirst(from: ctx.constant(),
                        ctx.stringLiteral(),
                        ctx.identifier(),
                        ctx.messageExpression(),
                        ctx.arrayExpression(),
                        ctx.dictionaryExpression(),
                        ctx.boxExpression()
        )
    }
    
    public override func visitArrayExpression(_ ctx: ObjectiveCParser.ArrayExpressionContext) -> Expression? {
        guard let expressions = ctx.expressions() else {
            return .arrayLiteral([])
        }
        
        let exps = expressions.expression().compactMap { $0.accept(self) }
        
        return .arrayLiteral(exps)
    }
    
    public override func visitDictionaryExpression(_ ctx: ObjectiveCParser.DictionaryExpressionContext) -> Expression? {
        let dictionaryPairs = ctx.dictionaryPair()
        
        let pairs =
            dictionaryPairs.compactMap { pair -> ExpressionDictionaryPair? in
                guard let key = pair.castExpression()?.accept(self) else {
                    return nil
                }
                guard let value = pair.expression()?.accept(self) else {
                    return nil
                }
                
                return ExpressionDictionaryPair(key: key, value: value)
            }
        
        return .dictionaryLiteral(pairs)
    }
    
    public override func visitBoxExpression(_ ctx: ObjectiveCParser.BoxExpressionContext) -> Expression? {
        return acceptFirst(from: ctx.expression(), ctx.constant(), ctx.identifier())
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
        func dropIntSuffixes(from string: String) -> String {
            var string = string
            while string.hasSuffix("u") || string.hasSuffix("U") ||
                string.hasSuffix("l") || string.hasSuffix("L") {
                string = String(string.dropLast())
            }
            
            return string
        }
        
        func dropFloatSuffixes(from string: String) -> String {
            var string = string
            
            while string.hasSuffix("f") || string.hasSuffix("F") ||
                string.hasSuffix("d") || string.hasSuffix("D") {
                string = String(string.dropLast())
            }
            
            return string
        }
        
        if let int = ctx.DECIMAL_LITERAL(), let intV = Int(dropIntSuffixes(from: int.getText())) {
            return .constant(.int(intV))
        }
        if let oct = ctx.OCTAL_LITERAL(), let int = Int(dropIntSuffixes(from: oct.getText()), radix: 8) {
            return .constant(.octal(int))
        }
        if let binary = ctx.BINARY_LITERAL(), let int = Int(dropIntSuffixes(from: binary.getText()).dropFirst(2), radix: 2) {
            return .constant(.binary(int))
        }
        if let hex = ctx.HEX_LITERAL(), let int = Int(dropIntSuffixes(from: hex.getText()).dropFirst(2), radix: 16) {
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
        if let float = ctx.FLOATING_POINT_LITERAL()?.getText() {
            let suffixless = dropFloatSuffixes(from: float)
            
            if let value = Float(suffixless) {
                return .constant(.float(value))
            } else {
                return .constant(.rawConstant(suffixless))
            }
        }
        
        return .constant(.rawConstant(ctx.getText()))
    }
    
    public override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> Expression? {
        return .identifier(ctx.getText())
    }
    
    private func acceptFirst(from rules: ParserRuleContext?...) -> Expression? {
        for rule in rules {
            if let expr = rule?.accept(self) {
                return expr
            }
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

private func swiftOperator(from string: String) -> SwiftOperator? {
    return SwiftOperator(rawValue: string)
}
