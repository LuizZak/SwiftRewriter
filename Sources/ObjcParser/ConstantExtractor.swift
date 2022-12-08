import Antlr4
import ObjcParserAntlr

/// Extracts constants from parser contexts
final class ConstantContextExtractor {
    static func extract(from expression: ObjectiveCParser.ExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: expression)
    }
    static func extract(from ctx: ObjectiveCParser.CastExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    static func extract(from ctx: ObjectiveCParser.UnaryExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    static func extract(from ctx: ObjectiveCParser.PostfixExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    static func extract(from ctx: ObjectiveCParser.PrimaryExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    static func extract(from ctx: ObjectiveCParser.ConstantExpressionContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    static func extract(from ctx: ObjectiveCParser.ConstantContext) -> ObjectiveCParser.ConstantContext? {
        _extract(from: ctx)
    }

    private static func _extract(from rule: ParserRuleContext) -> ObjectiveCParser.ConstantContext? {
        let visitor = _ConstantContextExtractorVisitor()
        return rule.accept(visitor) ?? nil
    }
}

private class _ConstantContextExtractorVisitor: ObjectiveCParserVisitor<ObjectiveCParser.ConstantContext?> {
    override func visitExpression(_ ctx: ObjectiveCParser.ExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return ctx.assignmentExpression()?.accept(self) ?? nil
    }

    override func visitAssignmentExpression(_ ctx: ObjectiveCParser.AssignmentExpressionContext) -> ObjectiveCParser.ConstantContext? {
        ctx.conditionalExpression()?.accept(self) ?? nil
    }

    override func visitConditionalExpression(_ ctx: ObjectiveCParser.ConditionalExpressionContext) -> ObjectiveCParser.ConstantContext? {
        ctx.trueExpression != nil ? nil : (ctx.logicalOrExpression()?.accept(self) ?? nil)
    }

    override func visitLogicalOrExpression(_ ctx: ObjectiveCParser.LogicalOrExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.logicalAndExpression()) { $0.accept(self) }
    }

    override func visitLogicalAndExpression(_ ctx: ObjectiveCParser.LogicalAndExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.bitwiseOrExpression()) { $0.accept(self) }
    }

    override func visitBitwiseOrExpression(_ ctx: ObjectiveCParser.BitwiseOrExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.bitwiseXorExpression()) { $0.accept(self) }
    }

    override func visitBitwiseXorExpression(_ ctx: ObjectiveCParser.BitwiseXorExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.bitwiseAndExpression()) { $0.accept(self) }
    }

    override func visitBitwiseAndExpression(_ ctx: ObjectiveCParser.BitwiseAndExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.equalityExpression()) { $0.accept(self) }
    }

    override func visitEqualityExpression(_ ctx: ObjectiveCParser.EqualityExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.comparisonExpression()) { $0.accept(self) }
    }

    override func visitComparisonExpression(_ ctx: ObjectiveCParser.ComparisonExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.shiftExpression()) { $0.accept(self) }
    }

    override func visitAdditiveExpression(_ ctx: ObjectiveCParser.AdditiveExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.multiplicativeExpression()) { $0.accept(self) }
    }

    override func visitMultiplicativeExpression(_ ctx: ObjectiveCParser.MultiplicativeExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return _visitIfOneItem(ctx.castExpression()) { $0.accept(self) }
    }

    override func visitCastExpression(_ ctx: ObjectiveCParser.CastExpressionContext) -> ObjectiveCParser.ConstantContext? {
        ctx.unaryExpression()?.accept(self) ?? nil
    }

    override func visitUnaryExpression(_ ctx: ObjectiveCParser.UnaryExpressionContext) -> ObjectiveCParser.ConstantContext? {
        ctx.postfixExpression()?.accept(self) ?? nil
    }

    override func visitPostfixExpression(_ ctx: ObjectiveCParser.PostfixExpressionContext) -> ObjectiveCParser.ConstantContext? {
        guard ctx.postfixExpr().isEmpty else {
            return nil
        }

        return ctx.primaryExpression()?.accept(self) ?? nil 
    }

    override func visitPrimaryExpression(_ ctx: ObjectiveCParser.PrimaryExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return ctx.constant()
    }

    override func visitConstantExpression(_ ctx: ObjectiveCParser.ConstantExpressionContext) -> ObjectiveCParser.ConstantContext? {
        return ctx.constant()
    }

    override func visitConstant(_ ctx: ObjectiveCParser.ConstantContext) -> ObjectiveCParser.ConstantContext? {
        return ctx
    }

    private func _visitIfOneItem<T>(
        _ ctx: [T],
        _ visit: (T) -> ObjectiveCParser.ConstantContext??
    ) -> ObjectiveCParser.ConstantContext? {
        guard ctx.count == 1 else {
            return nil
        }

        return visit(ctx[0]) ?? nil
    }
}
