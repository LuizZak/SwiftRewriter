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
        if let result = ctx.castExpression()?.accept(self) {
            return result
        }

        return nil
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
}
