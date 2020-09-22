import Antlr4
import ObjcParserAntlr
import ObjcParser
import GrammarModels
import SwiftAST
import TypeSystem

/// A visitor that reads simple Objective-C expressions and emits as Expression
/// enum cases.
public final class SwiftExprASTReader: ObjectiveCParserBaseVisitor<Expression> {
    public var typeMapper: TypeMapper
    public var typeParser: TypeParsing
    public var context: SwiftASTReaderContext
    public var delegate: SwiftStatementASTReaderDelegate?
    
    public init(typeMapper: TypeMapper, typeParser: TypeParsing, context: SwiftASTReaderContext,
                delegate: SwiftStatementASTReaderDelegate?) {

        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.context = context
        self.delegate = delegate
    }
    
    public override func visitExpression(_ ctx: ObjectiveCParser.ExpressionContext) -> Expression? {
        if let cast = ctx.castExpression() {
            return cast.accept(self)
        }
        // Ternary expression
        if ctx.QUESTION() != nil {
            guard let predicate = ctx.expression(0)?.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            let ifTrue = ctx.trueExpression?.accept(self)
            
            guard let ifFalse = ctx.falseExpression?.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            if let ifTrue = ifTrue {
                return .ternary(predicate, true: ifTrue, false: ifFalse)
            } else {
                return predicate.binary(op: .nullCoalesce, rhs: ifFalse)
            }
        }
        // Assignment expression
        if let assignmentExpression = ctx.assignmentExpression {
            guard let unaryExpr = ctx.unaryExpression()?.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let assignExpr = assignmentExpression.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let assignOp = ctx.assignmentOperator() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let op = swiftOperator(from: assignOp.getText()) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            return unaryExpr.assignment(op: op, rhs: assignExpr)
        }
        // Binary expression
        if ctx.expression().count == 2 {
            guard let lhs = ctx.expression(0)?.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let rhs = ctx.expression(1)?.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            // << / >>
            if ctx.LT().count == 2 {
                return lhs.binary(op: .bitwiseShiftLeft, rhs: rhs)
            }
            if ctx.GT().count == 2 {
                return lhs.binary(op: .bitwiseShiftRight, rhs: rhs)
            }
            
            guard let op = ctx.op?.getText() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            if let op = SwiftOperator(rawValue: op) {
                return lhs.binary(op: op, rhs: rhs)
            }
        }
        // Nested expression
        if let compound = ctx.compoundStatement() {
            let visitor = compoundStatementVisitor()
            guard let statement = compound.accept(visitor) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            return Expression.block(body: statement).call()
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitRangeExpression(_ ctx: ObjectiveCParser.RangeExpressionContext) -> Expression? {
        let constantExpressions = ctx.expression()
        
        if constantExpressions.count == 1 {
            return constantExpressions[0].accept(self)
        }
        if constantExpressions.count == 2,
            let exp1 = constantExpressions[0].accept(self),
            let exp2 = constantExpressions[1].accept(self) {
            
            return exp1.binary(op: .closedRange, rhs: exp2)
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitConstantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext) -> Expression? {
        if let identifier = ctx.identifier() {
            return identifier.accept(self)
        }
        if let constant = ctx.constant() {
            return constant.accept(self)
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext) -> Expression? {
        if let unary = ctx.unaryExpression() {
            return unary.accept(self)
        }
        if let typeName = ctx.typeName(),
            let type = typeParser.parseObjcType(from: typeName),
            let exp = ctx.castExpression()?.accept(self) {
            
            let swiftType = typeMapper.swiftType(forObjcType: type, context: .alwaysNonnull)
            return exp.casted(to: swiftType)
        }
        
        return .unknown(UnknownASTContext(context: ctx.getText()))
    }
    
    public override func visitUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext) -> Expression? {
        if ctx.INC() != nil, let exp = ctx.unaryExpression()?.accept(self) {
            return exp.assignment(op: .addAssign, rhs: .constant(1))
        }
        if ctx.DEC() != nil, let exp = ctx.unaryExpression()?.accept(self) {
            return exp.assignment(op: .subtractAssign, rhs: .constant(1))
        }
        if let op = ctx.unaryOperator(), let exp = ctx.castExpression()?.accept(self) {
            guard let swiftOp = SwiftOperator(rawValue: op.getText()) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            return .unary(op: swiftOp, exp)
        }
        // sizeof(<expr>) / sizeof(<type>)
        if ctx.SIZEOF() != nil {
            if let typeSpecifier = ctx.typeSpecifier(),
                let type = typeParser.parseObjcType(from: typeSpecifier) {
                
                let swiftType = typeMapper.swiftType(forObjcType: type)
                
                return .sizeof(type: swiftType)
            } else if let unary = ctx.unaryExpression()?.accept(self) {
                return .sizeof(unary)
            }
        }
        
        return acceptFirst(from: ctx.postfixExpression)
    }
    
    public override func visitPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext) -> Expression? {
        var result: Expression
        
        if let primary = ctx.primaryExpression() {
            guard let prim = primary.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            result = prim
        } else if let postfixExpression = ctx.postfixExpression() {
            guard let postfix = postfixExpression.accept(self) else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            guard let identifier = ctx.identifier() else {
                return .unknown(UnknownASTContext(context: ctx.getText()))
            }
            
            result = .postfix(postfix, .member(identifier.getText()))
        } else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        for post in ctx.postfixExpr() {
            // Function call
            if post.LP() != nil {
                var arguments: [FunctionArgument] = []
                
                if let args = post.argumentExpressionList() {
                    let funcArgVisitor = FunctionArgumentVisitor(expressionReader: self)
                    
                    for arg in args.argumentExpression() {
                        if let funcArg = arg.accept(funcArgVisitor) {
                            arguments.append(funcArg)
                        }
                    }
                }
                
                result = result.call(arguments)
                
            } else if post.LBRACK() != nil, let expression = post.expression() {
                guard let expr = expression.accept(self) else {
                    continue
                }
                
                // Subscription
                result = result.sub(expr)
                
            } else if post.INC() != nil {
                result = result.assignment(op: .addAssign, rhs: .constant(1))
                
            } else if post.DEC() != nil {
                result = result.assignment(op: .subtractAssign, rhs: .constant(1))
            }
        }
        
        return result
    }
    
    public override func visitMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext) -> Expression? {
        guard let receiverExpression = ctx.receiver()?.expression() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let receiver = receiverExpression.accept(self) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        if let identifier = ctx.messageSelector()?.selector()?.identifier()?.getText() {
            return receiver.dot(identifier).call()
        }
        guard let keywordArguments = ctx.messageSelector()?.keywordArgument() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        var name: String = ""
        
        var arguments: [FunctionArgument] = []
        for (keywordIndex, keyword) in keywordArguments.enumerated() {
            let selectorText = keyword.selector()?.getText() ?? ""
            
            if keywordIndex == 0 {
                // First keyword is always the method's name, Swift doesn't support
                // 'nameless' methods!
                if keyword.selector() == nil {
                    return .unknown(UnknownASTContext(context: ctx.getText()))
                }
                
                name = selectorText
            }
            
            for keywordArgumentType in keyword.keywordArgumentType() {
                guard let expressions = keywordArgumentType.expressions() else {
                    return .unknown(UnknownASTContext(context: ctx.getText()))
                }
                
                for (expIndex, expression) in expressions.expression().enumerated() {
                    let exp = expression.accept(self) ?? .unknown(UnknownASTContext(context: expression.getText()))
                    
                    // Every argument after the first one on a comma-separated
                    // argument sequence is unlabeled.
                    // We also don't label empty keyword-arguments due to them
                    // not being representable in Swift.
                    if expIndex == 0 && keywordIndex > 0 && !selectorText.isEmpty {
                        arguments.append(.labeled(selectorText, exp))
                    } else {
                        arguments.append(.unlabeled(exp))
                    }
                }
            }
        }
        
        return receiver.dot(name).call(arguments)
    }
    
    public override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> Expression? {
        acceptFirst(from: ctx.expression)
    }
    
    public override func visitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) -> Expression? {
        if ctx.LP() != nil, let exp = ctx.expression()?.accept(self) {
            return .parens(exp)
        }
        
        return
            acceptFirst(from: ctx.constant,
                        ctx.stringLiteral,
                        ctx.identifier,
                        ctx.messageExpression,
                        ctx.arrayExpression,
                        ctx.dictionaryExpression,
                        ctx.boxExpression,
                        ctx.selectorExpression,
                        ctx.blockExpression
                ) ?? .unknown(UnknownASTContext(context: ctx.getText()))
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
                guard let castExpression = pair.castExpression() else {
                    return nil
                }
                guard let expression = pair.expression() else {
                    return nil
                }
                
                let key = castExpression.accept(self) ?? .unknown(UnknownASTContext(context: castExpression.getText()))
                let value = expression.accept(self) ?? .unknown(UnknownASTContext(context: expression.getText()))
                
                return ExpressionDictionaryPair(key: key, value: value)
            }
        
        return .dictionaryLiteral(pairs)
    }
    
    public override func visitBoxExpression(_ ctx: ObjectiveCParser.BoxExpressionContext) -> Expression? {
        acceptFirst(from: ctx.expression, ctx.constant, ctx.identifier)
    }
    
    public override func visitStringLiteral(_ ctx: ObjectiveCParser.StringLiteralContext) -> Expression? {
        let value = ctx.STRING_VALUE().map {
            // TODO: Support conversion of hexadecimal and octal digits properly.
            // Octal literals need to be converted before being proper to use.
            $0.getText()
        }.joined()
        
        return .constant(.string(value))
    }
    
    public override func visitBlockExpression(_ ctx: ObjectiveCParser.BlockExpressionContext) -> Expression? {
        let returnType = ctx.typeSpecifier().flatMap { typeSpecifier -> ObjcType? in
            return typeParser.parseObjcType(from: typeSpecifier)
        } ?? .void
        
        let parameters: [BlockParameter]
        if let blockParameters = ctx.blockParameters() {
            let types = typeParser.parseObjcTypes(from: blockParameters)
            let args = blockParameters.typeVariableDeclaratorOrName()
            
            parameters =
                zip(args, types).map { (param, type) -> BlockParameter in
                    guard let identifier = VarDeclarationIdentifierNameExtractor.extract(from: param) else {
                        return BlockParameter(name: "<unknown>", type: .void)
                    }
                    
                    let swiftType = typeMapper.swiftType(forObjcType: type)
                    
                    return BlockParameter(name: identifier.getText(), type: swiftType)
                }
        } else {
            parameters = []
        }
        
        let compoundVisitor = self.compoundStatementVisitor()
        
        guard let body = ctx.compoundStatement()?.accept(compoundVisitor) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        let swiftReturnType = typeMapper.swiftType(forObjcType: returnType)
        
        return .block(parameters: parameters, return: swiftReturnType, body: body)
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
            return .constant(.int(intV, .decimal))
        }
        if let oct = ctx.OCTAL_LITERAL(), let int = Int(dropIntSuffixes(from: oct.getText()), radix: 8) {
            return .constant(.int(int, .octal))
        }
        if let binary = ctx.BINARY_LITERAL(),
            let int = Int(dropIntSuffixes(from: binary.getText()).dropFirst(2), radix: 2) {
            return .constant(.int(int, .binary))
        }
        if let hex = ctx.HEX_LITERAL(), let int = Int(dropIntSuffixes(from: hex.getText()).dropFirst(2), radix: 16) {
            return .constant(.int(int, .hexadecimal))
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
            let suffixless = dropIntSuffixes(from: dropFloatSuffixes(from: float))
            
            if let value = Float(suffixless) {
                return .constant(.float(value))
            } else {
                return .constant(.rawConstant(suffixless))
            }
        }
        
        return .constant(.rawConstant(ctx.getText()))
    }
    
    public override func visitSelectorExpression(_ ctx: ObjectiveCParser.SelectorExpressionContext) -> Expression? {
        guard let selectorName = ctx.selectorName() else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        guard let sel = convertSelectorToIdentifier(selectorName) else {
            return .unknown(UnknownASTContext(context: ctx.getText()))
        }
        
        return Expression.selector(sel)
    }
    
    public override func visitSelectorName(_ ctx: ObjectiveCParser.SelectorNameContext) -> Expression? {
        .constant(.string(ctx.getText()))
    }
    
    public override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> Expression? {
        .identifier(ctx.getText())
    }
    
    private func acceptFirst(from rules: () -> ParserRuleContext?...) -> Expression? {
        for rule in rules {
            if let expr = rule()?.accept(self) {
                return expr
            }
        }
        
        return nil
    }
    
    private func compoundStatementVisitor() -> SwiftStatementASTReader.CompoundStatementVisitor {
        SwiftStatementASTReader
                .CompoundStatementVisitor(expressionReader: self,
                                          context: context,
                                          delegate: delegate)
    }
    
    private class FunctionArgumentVisitor: ObjectiveCParserBaseVisitor<FunctionArgument> {
        var expressionReader: SwiftExprASTReader
        
        init(expressionReader: SwiftExprASTReader) {
            self.expressionReader = expressionReader
        }
        
        override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> FunctionArgument? {
            if let exp = ctx.expression() {
                guard let expEnum = exp.accept(expressionReader) else {
                    return .unlabeled(.unknown(UnknownASTContext(context: exp.getText())))
                }
                
                return .unlabeled(expEnum)
            }
            
            return .unlabeled(.unknown(UnknownASTContext(context: ctx.getText())))
        }
    }
}

func convertSelectorToIdentifier(_ ctx: ObjectiveCParser.SelectorNameContext) -> FunctionIdentifier? {
    func selToLabel(_ sel: ObjectiveCParser.SelectorContext) -> String {
        return sel.getText()
    }
    
    guard let children = ctx.children else {
        return nil
    }
    
    let selectors = ctx.selector()
    if selectors.isEmpty {
        return nil
    }
    
    let name = selToLabel(selectors[0])
    var arguments: [String?] = []
    
    var previous: ParseTree? = nil
    for child in children.dropFirst() {
        // Flush selector name
        if child.getText() == ":" {
            if let previous = previous {
                arguments.append(previous.getText())
            } else {
                arguments.append(nil)
            }
            
            previous = nil
        } else {
            previous = child
        }
    }
    
    return FunctionIdentifier(name: name, argumentLabels: arguments)
}

private func swiftOperator(from string: String) -> SwiftOperator? {
    SwiftOperator(rawValue: string)
}
