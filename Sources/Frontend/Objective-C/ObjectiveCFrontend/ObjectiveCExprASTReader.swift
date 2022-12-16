import Antlr4
import ObjcParserAntlr
import ObjcParser
import ObjcGrammarModels
import SwiftAST
import TypeSystem

/// A visitor that reads simple Objective-C expressions and emits as Expression
/// enum cases.
public final class ObjectiveCExprASTReader: ObjectiveCParserBaseVisitor<Expression> {
    public var typeMapper: TypeMapper
    public var typeParser: ObjcTypeParser
    public var context: ObjectiveCASTReaderContext
    public var delegate: ObjectiveCStatementASTReaderDelegate?
    
    public init(typeMapper: TypeMapper, typeParser: ObjcTypeParser, context: ObjectiveCASTReaderContext,
                delegate: ObjectiveCStatementASTReaderDelegate?) {

        self.typeMapper = typeMapper
        self.typeParser = typeParser
        self.context = context
        self.delegate = delegate
    }
    
    public override func visitRangeExpression(_ ctx: ObjectiveCParser.RangeExpressionContext) -> Expression? {
        let expressions = ctx.expression()
        guard !expressions.isEmpty else {
            return makeUnknownNode(ctx)
        }
        
        guard expressions.count > 1 else {
            return expressions[0].accept(self)
        }
        
        guard
            let exp1 = expressions[0].accept(self),
            let exp2 = expressions[1].accept(self)
        else {
            return makeUnknownNode(ctx)
        }

        return exp1.binary(op: .closedRange, rhs: exp2)
    }
    
    public override func visitExpression(_ ctx: ObjectiveCParser.ExpressionContext) -> Expression? {
        // Assignment expression
        if let assignmentExpression = ctx.assignmentExpression() {
            return assignmentExpression.accept(self)
        }
        // Nested statement
        if let compound = ctx.compoundStatement() {
            let visitor = compoundStatementVisitor()
            guard let statement = compound.accept(visitor) else {
                return makeUnknownNode(ctx)
            }
            
            return .block(body: statement).call()
        }
        
        return makeUnknownNode(ctx)
    }

    public override func visitAssignmentExpression(_ ctx: ObjectiveCParser.AssignmentExpressionContext) -> Expression? {
        if let conditional = ctx.conditionalExpression() {
            return conditional.accept(self)
        }

        guard let lhs = ctx.unaryExpression()?.accept(self) else {
            return makeUnknownNode(ctx)
        }
        guard let rhs = ctx.expression()?.accept(self) else {
            return makeUnknownNode(ctx)
        }
        guard let assignOp = ctx.assignmentOperator() else {
            return makeUnknownNode(ctx)
        }
        guard let op = swiftOperator(from: assignOp.getText()) else {
            return makeUnknownNode(ctx)
        }

        return lhs.assignment(op: op, rhs: rhs)
    }

    public override func visitConditionalExpression(_ ctx: ObjectiveCParser.ConditionalExpressionContext) -> Expression? {
        guard let logicalOrExpression = ctx.logicalOrExpression()?.accept(self) else {
            return makeUnknownNode(ctx)
        }

        guard ctx.QUESTION() != nil else {
            return logicalOrExpression
        }
        guard let falseExpression = ctx.falseExpression?.accept(self) else {
            return makeUnknownNode(ctx) 
        }

        if let trueExpression = ctx.trueExpression?.accept(self) {
            return .ternary(logicalOrExpression, true: trueExpression, false: falseExpression)
        }

        return logicalOrExpression.binary(op: .nullCoalesce, rhs: falseExpression)
    }

    public override func visitLogicalOrExpression(_ ctx: ObjectiveCParser.LogicalOrExpressionContext) -> Expression? {
        return reduceBinary(ctx.logicalAndExpression(), operator: .or) {
            $0.accept(self)
        }
    }

    public override func visitLogicalAndExpression(_ ctx: ObjectiveCParser.LogicalAndExpressionContext) -> Expression? {
        return reduceBinary(ctx.bitwiseOrExpression(), operator: .and) {
            $0.accept(self)
        }
    }

    public override func visitBitwiseOrExpression(_ ctx: ObjectiveCParser.BitwiseOrExpressionContext) -> Expression? {
        return reduceBinary(ctx.bitwiseXorExpression(), operator: .bitwiseOr) {
            $0.accept(self)
        }
    }

    public override func visitBitwiseXorExpression(_ ctx: ObjectiveCParser.BitwiseXorExpressionContext) -> Expression? {
        return reduceBinary(ctx.bitwiseAndExpression(), operator: .bitwiseXor) {
            $0.accept(self)
        }
    }

    public override func visitBitwiseAndExpression(_ ctx: ObjectiveCParser.BitwiseAndExpressionContext) -> Expression? {
        return reduceBinary(ctx.equalityExpression(), operator: .bitwiseAnd) {
            $0.accept(self)
        }
    }

    public override func visitEqualityExpression(_ ctx: ObjectiveCParser.EqualityExpressionContext) -> Expression? {
        return reduceBinary(ctx.comparisonExpression(), opRule: ctx.equalityOperator) {
            $0.accept(self)
        }
    }

    public override func visitComparisonExpression(_ ctx: ObjectiveCParser.ComparisonExpressionContext) -> Expression? {
        return reduceBinary(ctx.shiftExpression(), opRule: ctx.comparisonOperator) {
            $0.accept(self)
        }
    }

    public override func visitShiftExpression(_ ctx: ObjectiveCParser.ShiftExpressionContext) -> Expression? {
        return reduceBinary(ctx.additiveExpression(), opRule: ctx.shiftOperator) {
            $0.accept(self)
        }
    }

    public override func visitAdditiveExpression(_ ctx: ObjectiveCParser.AdditiveExpressionContext) -> Expression? {
        return reduceBinary(ctx.multiplicativeExpression(), opRule: ctx.additiveOperator) {
            $0.accept(self)
        }
    }

    public override func visitMultiplicativeExpression(_ ctx: ObjectiveCParser.MultiplicativeExpressionContext) -> Expression? {
        return reduceBinary(ctx.castExpression(), opRule: ctx.multiplicativeOperator) {
            $0.accept(self)
        }
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
        
        return makeUnknownNode(ctx)
    }
    
    public override func visitConstantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext) -> Expression? {
        if let identifier = ctx.identifier() {
            return identifier.accept(self)
        }
        if let constant = ctx.constant() {
            return constant.accept(self)
        }
        
        return makeUnknownNode(ctx)
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
                return makeUnknownNode(ctx)
            }
            
            return .unary(op: swiftOp, exp)
        }
        // sizeof(<expr>) / sizeof(<type>)
        if ctx.SIZEOF() != nil {
            // TODO: Re-implement sizeof type parsing using the new `TypeParsing` interface.
            if
                let typeSpecifier = ctx.typeSpecifier()//,
                //let type = typeParser.parseObjcType(from: typeSpecifier)
            {
                let type = ObjcType.typeName(typeSpecifier.getText())
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
                return makeUnknownNode(ctx)
            }
            
            result = prim
        } else if let postfixExpression = ctx.postfixExpression() {
            guard let postfix = postfixExpression.accept(self) else {
                return makeUnknownNode(ctx)
            }
            guard let identifier = ctx.identifier() else {
                return makeUnknownNode(ctx)
            }
            
            result = .postfix(postfix, .member(identifier.getText()))
        } else {
            return makeUnknownNode(ctx)
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
    
    public override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> Expression? {
        acceptFirst(from: ctx.expression)
    }
    
    public override func visitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) -> Expression? {
        if ctx.LP() != nil, let exp = ctx.expression()?.accept(self) {
            return .parens(exp)
        }
        
        return
            acceptFirst(
                from: ctx.constant,
                    ctx.stringLiteral,
                    ctx.identifier,
                    ctx.messageExpression,
                    ctx.arrayExpression,
                    ctx.dictionaryExpression,
                    ctx.boxExpression,
                    ctx.selectorExpression,
                    ctx.blockExpression
            ) ?? makeUnknownNode(ctx)
    }
    
    public override func visitMessageExpression(_ ctx: ObjectiveCParser.MessageExpressionContext) -> Expression? {
        guard let receiverExpression = ctx.receiver()?.expression() else {
            return makeUnknownNode(ctx)
        }
        guard let receiver = receiverExpression.accept(self) else {
            return makeUnknownNode(ctx)
        }
        
        if let identifier = ctx.messageSelector()?.selector()?.identifier()?.getText() {
            return receiver.dot(identifier).call()
        }
        guard let keywordArguments = ctx.messageSelector()?.keywordArgument() else {
            return makeUnknownNode(ctx)
        }
        
        var name: String = ""
        
        var arguments: [FunctionArgument] = []
        for (keywordIndex, keyword) in keywordArguments.enumerated() {
            let selectorText = keyword.selector()?.getText() ?? ""
            
            if keywordIndex == 0 {
                // First keyword is always the method's name, Swift doesn't support
                // 'nameless' methods!
                if keyword.selector() == nil {
                    return makeUnknownNode(ctx)
                }
                
                name = selectorText
            }
            
            for keywordArgumentType in keyword.keywordArgumentType() {
                guard let expressions = keywordArgumentType.expressions() else {
                    return makeUnknownNode(ctx)
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
        let returnType = ctx.typeName().flatMap { typeName -> ObjcType? in
            return typeParser.parseObjcType(from: typeName)
        } ?? .void

        let parameters: [BlockParameter]
        if let blockParameters = ctx.blockParameters() {
            let types = typeParser.parseObjcTypes(from: blockParameters)
            let parametersCtx = blockParameters.parameterDeclaration()
            
            parameters =
                zip(parametersCtx, types).map { (param, type) -> BlockParameter in
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
            return makeUnknownNode(ctx)
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
            return makeUnknownNode(ctx)
        }
        guard let sel = convertSelectorToIdentifier(selectorName) else {
            return makeUnknownNode(ctx)
        }
        
        return .selector(sel)
    }
    
    public override func visitSelectorName(_ ctx: ObjectiveCParser.SelectorNameContext) -> Expression? {
        .constant(.string(ctx.getText()))
    }
    
    public override func visitIdentifier(_ ctx: ObjectiveCParser.IdentifierContext) -> Expression? {
        .identifier(ctx.getText())
    }

    // MARK: - Internals

    private func makeUnknownNode(_ ctx: ParserRuleContext) -> UnknownExpression {
        return .unknown(UnknownASTContext(context: "/*\(ctx.getText())*/"))
    }
    
    private func acceptFirst(from rules: () -> ParserRuleContext?...) -> Expression? {
        for rule in rules {
            if let expr = rule()?.accept(self) {
                return expr
            }
        }
        
        return nil
    }

    /// Helper for reducing binary expressions expressed as one-or-more parser
    /// rules.
    /// Every subsequent expression past the first index on `fullList` is joined
    /// with the previous one as a binary expression.
    ///
    /// If `parser` fails to parse the first element of `fullList`, `nil` is
    /// returned, instead.
    ///
    /// Is a convenience over `reduceBinary(_:_:opDeriver:parser:)` where
    /// `opDeriver` is replaced with a constant operator instead of being derived
    /// based on iteration index.
    private func reduceBinary<T: ParserRuleContext>(
        _ fullList: [T],
        operator op: SwiftOperator,
        parser: (T) -> Expression?
    ) -> Expression {
        
        return reduceBinary(
            fullList,
            opDeriver: { _ in op },
            parser: parser
        )
    }

    /// Helper for reducing binary expressions expressed as one-or-more parser
    /// rules.
    /// Every subsequent expression past the first index on `fullList` is joined
    /// with the previous one as a binary expression.
    ///
    /// If `parser` fails to parse the first element of `fullList`, `nil` is
    /// returned, instead.
    ///
    /// Is a convenience over `reduceBinary(_:_:opDeriver:parser:)` where
    /// `opDeriver` is replaced with a closure that accepts an index and returns
    /// an optional parser rule context that represents an operator to parse.
    /// If `opRule` returns `nil` or a `SwiftOperator` fails to be parsed from
    /// its `.getText()` call, the binary reduction stops and the current
    /// accumulated result is returned.
    private func reduceBinary<T: ParserRuleContext>(
        _ fullList: [T],
        opRule: (Int) -> ParserRuleContext?,
        parser: (T) -> Expression?
    ) -> Expression {
        
        return reduceBinary(
            fullList,
            opDeriver: { index in opRule(index).flatMap({ swiftOperator(from: $0.getText()) }) },
            parser: parser
        )
    }

    /// Helper for reducing binary expressions expressed as one-or-more parser
    /// rules.
    /// Every subsequent expression past the first index on `fullList` is joined
    /// with the previous one as a binary expression.
    ///
    /// If `parser` fails to parse the first element of `fullList`, `nil` is
    /// returned, instead.
    ///
    /// `fullList` must contemplate `initial` as its first index.
    /// `opDeriver` passes a zero-based index for every sequential element past
    /// `initial` on `fullList`.
    private func reduceBinary<T: ParserRuleContext>(
        _ fullList: [T],
        opDeriver: (Int) -> SwiftOperator?,
        parser: (T) -> Expression?
    ) -> Expression {

        guard !fullList.isEmpty else {
            return .unknown(UnknownASTContext(context: "/*<invalid empty expression list>*/"))
        }

        guard var result = parser(fullList[0]) else {
            return makeUnknownNode(fullList[0])
        }
        
        guard fullList.count > 1 else {
            return result
        }

        for (index, rule) in fullList.dropFirst().enumerated() {
            guard let op = opDeriver(index) else {
                return result
            }
            guard let rhs = parser(rule) else {
                return result
            }

            result = result.binary(op: op, rhs: rhs)
        }

        return result
    }
    
    private func compoundStatementVisitor() -> ObjectiveCStatementASTReader.CompoundStatementVisitor {
        .init(
            expressionReader: self,
            context: context,
            delegate: delegate
        )
    }
    
    private class FunctionArgumentVisitor: ObjectiveCParserBaseVisitor<FunctionArgument> {
        var expressionReader: ObjectiveCExprASTReader
        
        init(expressionReader: ObjectiveCExprASTReader) {
            self.expressionReader = expressionReader
        }
        
        override func visitArgumentExpression(_ ctx: ObjectiveCParser.ArgumentExpressionContext) -> FunctionArgument? {
            if let exp = ctx.expression() {
                guard let expEnum = exp.accept(expressionReader) else {
                    return .unlabeled(.unknown(UnknownASTContext(context: exp.getText())))
                }
                
                return .unlabeled(expEnum)
            }
            
            return .unlabeled(
                expressionReader.makeUnknownNode(ctx)
            )
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
