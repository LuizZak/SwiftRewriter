import Foundation
import Antlr4
import JsParserAntlr
import JsParser
import JsGrammarModels
import SwiftAST
import TypeSystem

/// A visitor that reads simple JavaScript expressions and emits as Expression
/// enum cases.
public final class JavaScriptExprASTReader: JavaScriptParserBaseVisitor<Expression> {
    public var context: JavaScriptASTReaderContext
    public var delegate: JavaScriptASTReaderDelegate?
    
    public init(
        context: JavaScriptASTReaderContext,
        delegate: JavaScriptASTReaderDelegate?
    ) {
        self.context = context
        self.delegate = delegate
    }

    public override func visitFunctionExpression(_ ctx: JavaScriptParser.FunctionExpressionContext) -> Expression? {
        guard let anonymousFunction = ctx.anonymousFunction() else {
            return nil
        }
        guard let function = JsParser.anonymousFunction(from: anonymousFunction) else {
            return nil
        }
        guard let blockExpression = self.blockLiteralExpression(from: function) else {
            return nil
        }

        // Function declaration - create variable assignment.
        if let identifier = function.identifier {
            return .assignment(lhs: .identifier(identifier), op: .equals, rhs: blockExpression)
        }

        return blockExpression
    }

    public override func visitClassExpression(_ ctx: JavaScriptParser.ClassExpressionContext) -> Expression? {
        // TODO: Handle inline class declaration expressions.
        unknown(ctx)
    }

    public override func visitMemberIndexExpression(_ ctx: JavaScriptParser.MemberIndexExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }
        guard let indexExpressions = ctx.expressionSequence().map(self.expressionSequence) else { return unknown(ctx) }

        return exp.sub(expressions: indexExpressions)
    }

    public override func visitMemberDotExpression(_ ctx: JavaScriptParser.MemberDotExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }
        guard let identifier = ctx.identifierName()?.getText() else { return unknown(ctx) }

        if ctx.QuestionMark() != nil {
            return exp.optional().dot(identifier)
        }

        return exp.dot(identifier)
    }

    public override func visitNewExpression(_ ctx: JavaScriptParser.NewExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        if let arguments = ctx.arguments() { 
            return exp.call(self.arguments(arguments))
        }

        return exp.call()
    }

    public override func visitArgumentsExpression(_ ctx: JavaScriptParser.ArgumentsExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }
        guard let arguments = ctx.arguments() else { return unknown(ctx) }

        return exp.call(self.arguments(arguments))
    }

    public override func visitPostIncrementExpression(_ ctx: JavaScriptParser.PostIncrementExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return exp.assignment(op: .addAssign, rhs: .constant(1))
    }

    public override func visitPostDecreaseExpression(_ ctx: JavaScriptParser.PostDecreaseExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return exp.assignment(op: .subtractAssign, rhs: .constant(1))
    }

    public override func visitDeleteExpression(_ ctx: JavaScriptParser.DeleteExpressionContext) -> Expression? {
        unknown(ctx)
    }

    public override func visitVoidExpression(_ ctx: JavaScriptParser.VoidExpressionContext) -> Expression? {
        ctx.singleExpression()?.accept(self)
    }

    public override func visitTypeofExpression(_ ctx: JavaScriptParser.TypeofExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return .identifier("String").call([.identifier("type").call([.labeled("of", exp)])])
    }

    public override func visitPreIncrementExpression(_ ctx: JavaScriptParser.PreIncrementExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return exp.assignment(op: .addAssign, rhs: .constant(1))
    }

    public override func visitPreDecreaseExpression(_ ctx: JavaScriptParser.PreDecreaseExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return exp.assignment(op: .subtractAssign, rhs: .constant(1))
    }

    public override func visitUnaryPlusExpression(_ ctx: JavaScriptParser.UnaryPlusExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return .unary(op: .add, exp)
    }

    public override func visitUnaryMinusExpression(_ ctx: JavaScriptParser.UnaryMinusExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return .unary(op: .subtract, exp)
    }

    public override func visitBitNotExpression(_ ctx: JavaScriptParser.BitNotExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return .unary(op: .bitwiseNot, exp)
    }

    public override func visitNotExpression(_ ctx: JavaScriptParser.NotExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression()?.accept(self) else { return unknown(ctx) }

        return .unary(op: .negate, exp)
    }

    public override func visitAwaitExpression(_ ctx: JavaScriptParser.AwaitExpressionContext) -> Expression? {
        return unknown(ctx)
    }

    public override func visitPowerExpression(_ ctx: JavaScriptParser.PowerExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return .identifier("pow").call([lhs, rhs])
    }

    public override func visitMultiplicativeExpression(_ ctx: JavaScriptParser.MultiplicativeExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        if ctx.Multiply() != nil {
            return lhs.binary(op: .multiply, rhs: rhs)
        }
        if ctx.Divide() != nil {
            return lhs.binary(op: .divide, rhs: rhs)
        }
        if ctx.Modulus() != nil {
            return lhs.binary(op: .mod, rhs: rhs)
        }

        return unknown(ctx)
    }

    public override func visitAdditiveExpression(_ ctx: JavaScriptParser.AdditiveExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        if ctx.Plus() != nil {
            return lhs.binary(op: .add, rhs: rhs)
        }
        if ctx.Minus() != nil {
            return lhs.binary(op: .subtract, rhs: rhs)
        }

        return unknown(ctx)
    }

    public override func visitCoalesceExpression(_ ctx: JavaScriptParser.CoalesceExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .nullCoalesce, rhs: rhs)
    }

    public override func visitBitShiftExpression(_ ctx: JavaScriptParser.BitShiftExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        if ctx.LeftShiftArithmetic() != nil {
            return lhs.binary(op: .bitwiseShiftLeft, rhs: rhs)
        }
        if ctx.RightShiftArithmetic() != nil {
            return lhs.binary(op: .bitwiseShiftRight, rhs: rhs)
        }
        /* TODO: Add support for right shift logical operator
        if ctx.RightShiftLogical() != nil {

        }
        */

        return unknown(ctx)
    }

    public override func visitRelationalExpression(_ ctx: JavaScriptParser.RelationalExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        if ctx.LessThan() != nil {
            return lhs.binary(op: .lessThan, rhs: rhs)
        }
        if ctx.LessThanEquals() != nil {
            return lhs.binary(op: .lessThanOrEqual, rhs: rhs)
        }
        if ctx.MoreThan() != nil {
            return lhs.binary(op: .greaterThan, rhs: rhs)
        }
        if ctx.GreaterThanEquals() != nil {
            return lhs.binary(op: .greaterThanOrEqual, rhs: rhs)
        }

        return unknown(ctx)
    }

    public override func visitInstanceofExpression(_ ctx: JavaScriptParser.InstanceofExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        switch rhs {
        case let exp as IdentifierExpression:
            return lhs.typeCheck(as: .typeName(exp.identifier))
        default:
            return unknown(ctx)
        }
    }

    public override func visitInExpression(_ ctx: JavaScriptParser.InExpressionContext) -> Expression? {
        fatalError("Not implemented")
    }

    public override func visitEqualityExpression(_ ctx: JavaScriptParser.EqualityExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        if ctx.Equals_() != nil || ctx.IdentityEquals() != nil {
            return lhs.binary(op: .equals, rhs: rhs)
        }
        if ctx.NotEquals() != nil || ctx.IdentityNotEquals() != nil {
            return lhs.binary(op: .unequals, rhs: rhs)
        }

        return unknown(ctx)
    }

    public override func visitBitAndExpression(_ ctx: JavaScriptParser.BitAndExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .bitwiseAnd, rhs: rhs)
    }

    public override func visitBitXOrExpression(_ ctx: JavaScriptParser.BitXOrExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .bitwiseXor, rhs: rhs)
    }

    public override func visitBitOrExpression(_ ctx: JavaScriptParser.BitOrExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .bitwiseOr, rhs: rhs)
    }

    public override func visitLogicalAndExpression(_ ctx: JavaScriptParser.LogicalAndExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .and, rhs: rhs)
    }

    public override func visitLogicalOrExpression(_ ctx: JavaScriptParser.LogicalOrExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.binary(op: .or, rhs: rhs)
    }

    public override func visitTernaryExpression(_ ctx: JavaScriptParser.TernaryExpressionContext) -> Expression? {
        guard let exp = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let lhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(2)?.accept(self) else { return unknown(ctx) }

        return .ternary(exp, true: lhs, false: rhs)
    }

    public override func visitAssignmentExpression(_ ctx: JavaScriptParser.AssignmentExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }

        return lhs.assignment(op: .assign, rhs: rhs)
    }

    public override func visitAssignmentOperatorExpression(_ ctx: JavaScriptParser.AssignmentOperatorExpressionContext) -> Expression? {
        guard let lhs = ctx.singleExpression(0)?.accept(self) else { return unknown(ctx) }
        guard let rhs = ctx.singleExpression(1)?.accept(self) else { return unknown(ctx) }
        guard let assignmentOperator = ctx.assignmentOperator() else { return unknown(ctx) }

        // Handle power-assign expressions as regular 'pow()' assignment expressions
        if assignmentOperator.PowerAssign() != nil {
            return lhs.assignment(op: .assign, rhs: .identifier("pow").call([lhs, rhs]))
        }

        guard let op = self.assignmentOperator(assignmentOperator) else { return unknown(ctx) }

        return lhs.assignment(op: op, rhs: rhs)
    }

    public override func visitYieldExpression(_ ctx: JavaScriptParser.YieldExpressionContext) -> Expression? {
        unknown(ctx)
    }

    public override func visitThisExpression(_ ctx: JavaScriptParser.ThisExpressionContext) -> Expression? {
        .identifier("self")
    }

    public override func visitIdentifierExpression(_ ctx: JavaScriptParser.IdentifierExpressionContext) -> Expression? {
        ctx.identifier()?.accept(self)
    }

    public override func visitIdentifier(_ ctx: JavaScriptParser.IdentifierContext) -> Expression? {
        .identifier(ctx.getText())
    }

    public override func visitIdentifierName(_ ctx: JavaScriptParser.IdentifierNameContext) -> Expression? {
        .identifier(ctx.getText())
    }

    public override func visitSuperExpression(_ ctx: JavaScriptParser.SuperExpressionContext) -> Expression? {
        .identifier("super")
    }

    public override func visitLiteralExpression(_ ctx: JavaScriptParser.LiteralExpressionContext) -> Expression? {
        ctx.literal()?.accept(self)
    }

    public override func visitLiteral(_ ctx: JavaScriptParser.LiteralContext) -> Expression? {
        if ctx.NullLiteral() != nil {
            return .constant(.nil)
        }
        if let booleanLiteral = ctx.BooleanLiteral()?.getText() {
            switch booleanLiteral {
            case "true":
                return .constant(true)
            case "false":
                return .constant(false)
            default:
                return unknown(ctx)
            }
        }
        if let stringLiteral = ctx.StringLiteral() {
            return self.stringLiteral(stringLiteral)
        }
        /* TODO: Support template strings
        if let templateString = ctx.templateStringLiteral() {
            
        }
        */
        /* TODO: Support regex expression literals
        if let regexExpression = ctx.RegularExpressionLiteral() {
            
        }
        */
        if let numericLiteral = ctx.numericLiteral() {
            return numericLiteral.accept(self)
        }
        /* TODO: Support big int expression literals
        if let bigIntLiteral = ctx.bigIntLiteral() {
            return bigIntLiteral.accept(self)
        }
        */

        return unknown(ctx)
    }

    public override func visitArrayLiteralExpression(_ ctx: JavaScriptParser.ArrayLiteralExpressionContext) -> Expression? {
        ctx.arrayLiteral()?.accept(self)
    }

    public override func visitArrayLiteral(_ ctx: JavaScriptParser.ArrayLiteralContext) -> Expression? {
        guard let elementList = ctx.elementList() else {
            return nil
        }

        return ArrayLiteralExpression(items: elementList.arrayElement().compactMap {
            $0.accept(self)
        })
    }

    public override func visitObjectLiteral(_ ctx: JavaScriptParser.ObjectLiteralContext) -> Expression? {
        let visitor = DictionaryPairVisitor(expReader: self)
        var pairs: [ExpressionDictionaryPair] = []

        for propertyAssignment in ctx.propertyAssignment() {
            if let pair = propertyAssignment.accept(visitor) {
                pairs.append(pair)
            }
        }

        let expression = DictionaryLiteralExpression(pairs: pairs)

        switch context.options.objectLiteralKind {
        case .rawDictionary:
            return expression
        case .javaScriptObject(let typeName):
            return .identifier(typeName).call([expression])
        }
    }

    public override func visitNumericLiteral(_ ctx: JavaScriptParser.NumericLiteralContext) -> Expression? {
        func toDouble<S: StringProtocol>(_ str: S) -> Double? {
            let str = str.replacingOccurrences(of: "_", with: "")

            return Double(str)
        }

        func toInt<S: StringProtocol>(_ str: S, radix: Int = 10) -> Int? {
            let str = str.replacingOccurrences(of: "_", with: "")

            return Int(str, radix: radix)
        }

        var constant: Constant?

        // Attempt integer coercion first
        if let decimal = ctx.DecimalLiteral(), let int = toInt(decimal.getText()) {
            constant = .int(int, .decimal)
        } else if let decimal = ctx.DecimalLiteral(), let double = toDouble(decimal.getText()) {
            constant = .double(double)
        } else if let hex = ctx.HexIntegerLiteral(), let int = toInt(hex.getText().dropFirst(2), radix: 16) {
            constant = .hexadecimal(int)
        } else if let octal = ctx.OctalIntegerLiteral(), let int = toInt(octal.getText(), radix: 8) {
            constant = .octal(int)
        } else if let octal = ctx.OctalIntegerLiteral2(), let int = toInt(octal.getText().dropFirst(2), radix: 8) {
            constant = .octal(int)
        } else if let binary = ctx.BinaryIntegerLiteral(), let int = toInt(binary.getText().dropFirst(2), radix: 2) {
            constant = .binary(int)
        }

        if let constant = constant {
            return .constant(constant)
        }

        return unknown(ctx)
    }

    public override func visitPropertyName(_ ctx: JavaScriptParser.PropertyNameContext) -> Expression? {
        if let identifierName = ctx.identifierName() {
            return identifierName.accept(self)
        }
        if let stringLiteral = ctx.StringLiteral() {
            return self.stringLiteral(stringLiteral)
        }
        if let numericalLiteral = ctx.numericLiteral() {
            return numericalLiteral.accept(self)
        }
        /* TODO: Support for square-bracket property name
        if let singleExpression = ctx.singleExpression() {
            
        }
        */

        return nil
    }

    public override func visitParenthesizedExpression(_ ctx: JavaScriptParser.ParenthesizedExpressionContext) -> Expression? {
        guard let expressionSequence = ctx.expressionSequence() else {
            return nil
        }

        let expressions = expressionSequence.singleExpression().compactMap {
            $0.accept(self)
        }

        if expressions.count == 1 {
            return .parens(expressions[0])
        }

        return .tuple(expressions)
    }

    public override func visitExpressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext) -> Expression? {
        let expressions = ctx.singleExpression().compactMap {
            $0.accept(self)
        }

        if expressions.count == 1 {
            return expressions[0]
        }

        return .tuple(expressions)
    }

    // MARK: - Internal conversion helpers

    private func blockLiteralExpression(from anonymousFunction: JsAnonymousFunction) -> BlockLiteralExpression? {
        let parameters = blockParameters(from: anonymousFunction.signature)
        let blockBody: CompoundStatement?

        let stmtReader = compoundStatementReader()
        switch anonymousFunction.body {
        case .functionBody(let body):
            blockBody = stmtReader.visitFunctionBody(body)

        case .singleExpression(let expression):
            guard let exp = expression.accept(self) else {
                return nil
            }

            blockBody = [
                .expression(exp)
            ]
        }

        guard let blockBody = blockBody else {
            return nil
        }

        return .block(
            parameters: parameters,
            return: .any,
            body: blockBody
        )
    }

    private func stringLiteral(_ ctx: TerminalNode) -> Expression? {
        let string = ctx.getText().trimmingCharacters(in: CharacterSet(charactersIn: "\"\'"))

        return .constant(.string(string))
    }

    private func assignmentOperator(_ ctx: JavaScriptParser.AssignmentOperatorContext) -> SwiftOperator? {
        if ctx.MultiplyAssign() != nil {
            return .multiplyAssign
        }
        if ctx.DivideAssign() != nil {
            return .divideAssign
        }
        if ctx.ModulusAssign() != nil {
            return .modAssign
        }
        if ctx.PlusAssign() != nil {
            return .addAssign
        }
        if ctx.MinusAssign() != nil {
            return .subtractAssign
        }
        if ctx.LeftShiftArithmeticAssign() != nil {
            return .bitwiseShiftLeftAssign
        }
        if ctx.RightShiftArithmeticAssign() != nil {
            return .bitwiseShiftRightAssign
        }
        /* TODO: Add support for right shift logical operator
        if ctx.RightShiftLogicalAssign() != nil {

        }
        */
        if ctx.BitAndAssign() != nil {
            return .bitwiseAndAssign
        }
        if ctx.BitXorAssign() != nil {
            return .bitwiseXorAssign
        }
        if ctx.BitOrAssign() != nil {
            return .bitwiseOrAssign
        }

        return nil
    }

    private func arguments(_ ctx: JavaScriptParser.ArgumentsContext) -> [FunctionArgument] {
        ctx.argument().compactMap { exp -> Expression? in
            // TODO: Support ellipsis on call site
            exp.singleExpression()?.accept(self) ?? exp.identifier()?.accept(self)
        }.map {
            FunctionArgument(label: nil, expression: $0)
        }
    }

    private func expressionSequence(_ ctx: JavaScriptParser.ExpressionSequenceContext) -> [Expression] {
        var exps: [Expression] = []

        for exp in ctx.singleExpression() {
            if let result = exp.accept(self) {
                exps.append(result)
            }
        }

        return exps
    }

    private func blockParameters(from signature: JsFunctionSignature) -> [BlockParameter] {
        signature.arguments.map {
            .init(name: $0.identifier, type: .any)
        }
    }

    fileprivate func unknown(_ ctx: ParserRuleContext) -> Expression {
        .unknown(UnknownASTContext(context: _sourceText(for: ctx)))
    }
    
    private func _sourceText(for ctx: ParserRuleContext) -> String {
        return self.context.sourceCode(for: ctx).map(String.init) ?? ""
    }

    // MARK: - AST reader factories

    private func statementASTReader() -> JavaScriptStatementASTReader {
        JavaScriptStatementASTReader(
            expressionReader: self,
            context: context,
            delegate: delegate
        )
    }

    private func compoundStatementReader() -> JavaScriptStatementASTReader.CompoundStatementVisitor {
        JavaScriptStatementASTReader.CompoundStatementVisitor(
            expressionReader: self,
            context: context,
            delegate: delegate
        )
    }

    private class DictionaryPairVisitor: JavaScriptParserBaseVisitor<ExpressionDictionaryPair> {
        unowned let expReader: JavaScriptExprASTReader

        init(expReader: JavaScriptExprASTReader) {
            self.expReader = expReader
        }

        override func visitPropertyExpressionAssignment(_ ctx: JavaScriptParser.PropertyExpressionAssignmentContext) -> ExpressionDictionaryPair? {
            guard let lhs = ctx.propertyName()?.accept(expReader) else { return nil }
            guard let rhs = ctx.singleExpression()?.accept(expReader) else { return nil }

            return .init(key: formatKeyName(lhs), value: rhs)
        }

        override func visitComputedPropertyExpressionAssignment(_ ctx: JavaScriptParser.ComputedPropertyExpressionAssignmentContext) -> ExpressionDictionaryPair? {
            guard let lhs = ctx.singleExpression(0)?.accept(expReader) else { return nil }
            guard let rhs = ctx.singleExpression(1)?.accept(expReader) else { return nil }

            return .init(key: formatKeyName(lhs), value: rhs)
        }

        override func visitFunctionProperty(_ ctx: JavaScriptParser.FunctionPropertyContext) -> ExpressionDictionaryPair? {
            let closureVisitor = functionBodyVisitor()

            guard let name = ctx.propertyName()?.identifierName()?.getText() else { return nil }
            guard let body = ctx.functionBody()?.accept(closureVisitor) else { return nil }
            
            let signature = JsParser.functionSignature(from: ctx.formalParameterList())

            return .init(
                key: formatKeyName(.identifier(name)),
                value: Expression.block(
                    parameters: expReader.blockParameters(from: signature),
                    return: .any,
                    body: body
                )
            )
        }

        override func visitPropertyShorthand(_ ctx: JavaScriptParser.PropertyShorthandContext) -> ExpressionDictionaryPair? {
            guard let exp = ctx.singleExpression()?.accept(expReader) else { return nil }

            return .init(key: formatKeyName(exp), value: exp)
        }
        
        // MARK: -

        private func formatKeyName(_ exp: Expression) -> Expression {
            switch expReader.context.options.objectLiteralKind {
            case .rawDictionary:
                return exp
            
            case .javaScriptObject:
                if let identifier = exp.asIdentifier {
                    return .constant(.string(identifier.identifier))
                }
            }

            return exp
        }

        private func functionBodyVisitor() -> JavaScriptStatementASTReader.CompoundStatementVisitor {
            JavaScriptStatementASTReader.CompoundStatementVisitor(
                expressionReader: expReader,
                context: expReader.context,
                delegate: expReader.delegate
            )
        }
    }
}
