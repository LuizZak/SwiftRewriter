import Foundation
import SwiftRewriterLib
import SwiftAST
import Utils

public class CoreGraphicsExpressionPass: BaseExpressionPass {
    public required init() {
        super.init()
        
        createTransformers()
    }
    
    public override func visitExpressions(_ stmt: ExpressionsStatement) -> Statement {
        // Remove CGPathRelease(<path>)
        stmt.expressions = stmt.expressions.compactMap { (exp: Expression) -> Expression? in
            guard let call = exp.asPostfix?.functionCall, let ident = exp.asPostfix?.exp.asIdentifier else {
                return exp
            }
            
            if ident.identifier == "CGPathRelease" && call.arguments.count == 1
                && !call.arguments.hasLabeledArguments() {
                notifyChange()
                return nil
            }
            
            return exp
        }
        
        return super.visitExpressions(stmt)
    }
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        switch (exp.exp, exp.op) {
        // CGRectGetWidth(<exp>) -> <exp>.width
        case (.identifier("CGRectGetWidth"), _):
            convertMethodToField(field: "width", ifArgCountIs: 1, exp)
            
        // CGRectGetHeight(<exp>) -> <exp>.height
        case (.identifier("CGRectGetHeight"), _):
            convertMethodToField(field: "height", ifArgCountIs: 1, exp)
            
        // CGRectGet[Min/Max/Mid][X/Y](<exp>) -> <exp>.height
        case (.identifier("CGRectGetMinX"), _):
            convertMethodToField(field: "minX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMinY"), _):
            convertMethodToField(field: "minY", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMaxX"), _):
            convertMethodToField(field: "maxX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMaxY"), _):
            convertMethodToField(field: "maxY", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMidX"), _):
            convertMethodToField(field: "midX", ifArgCountIs: 1, exp)
        case (.identifier("CGRectGetMidY"), _):
            convertMethodToField(field: "midY", ifArgCountIs: 1, exp)
            
        // CGRectIsNull(<exp>) -> <exp>.isNull
        case (.identifier("CGRectIsNull"), _):
            convertMethodToField(field: "isNull", ifArgCountIs: 1, exp)
            
        // MARK: CGPath
            
        // CGPathCreateMutable() -> CGMutablePath()
        case (.identifier("CGPathCreateMutable"), .functionCall()):
            exp.exp.asIdentifier?.identifier = "CGMutablePath"
            
            notifyChange()
            
        // CGPathIsEmpty(<path>) -> <path>.isEmpty
        case (.identifier("CGPathIsEmpty"), _):
            convertMethodToField(field: "isEmpty", ifArgCountIs: 1, exp)
            
        // CGPathGetCurrentPoint(<path>) -> <path>.currentPoint
        case (.identifier("CGPathGetCurrentPoint"), _):
            convertMethodToField(field: "currentPoint", ifArgCountIs: 1, exp)
            
        // CGPathGetBoundingBox(<path>) -> <path>.boundingBox
        case (.identifier("CGPathGetBoundingBox"), _):
            convertMethodToField(field: "boundingBox", ifArgCountIs: 1, exp)
            
        // CGPathGetPathBoundingBox(<path>) -> <path>.boundingBoxOfPath
        case (.identifier("CGPathGetPathBoundingBox"), _):
            convertMethodToField(field: "boundingBoxOfPath", ifArgCountIs: 1, exp)
            
        default:
            break
        }
        
        return super.visitPostfix(exp)
    }
    
    /// Converts a method to a field access, e.g.: `CGRectGetWidth(<exp>)` -> `<exp>.width`.
    private func convertMethodToField(field: String, ifArgCountIs argCount: Int, _ exp: PostfixExpression) {
        switch (exp.exp, exp.op) {
        case (_ as IdentifierExpression, let functionCall as FunctionCallPostfix)
            where functionCall.arguments.count == argCount && !functionCall.arguments.hasLabeledArguments():
            
            exp.exp = functionCall.arguments[0].expression.accept(self)
            exp.op = .member(field)
            
            notifyChange()
        default:
            exp.exp = exp.exp.accept(self)
        }
    }
}

extension CoreGraphicsExpressionPass {
    
    func createTransformers() {
        createBasicTransformers()
        createCGPathTransformers()
        createCGContextTransformers()
    }
    
    func createBasicTransformers() {
        // UIEdgeInsetsMake(<top>, <left>, <bottom>, <right>)
        // -> UIEdgeInsets(top: <top>, left: <left>, bottom: <bottom>, right: <right>)
        makeFuncTransform("UIEdgeInsetsMake", swiftName: "UIEdgeInsets",
                          arguments: [
                            .labeled("top", .asIs), .labeled("left", .asIs),
                            .labeled("bottom", .asIs), .labeled("right", .asIs)
                          ])
        // CGointMake(<x>, <y>) -> CGPoint(x: <x>, y: <y>)
        makeFuncTransform("CGPointMake", swiftName: "CGPoint",
                          arguments: [
                            .labeled("x", .asIs), .labeled("y", .asIs)
                          ])
        // CGRectMake(<x>, <y>, <width>, <height>) -> CGRect(x: <x>, y: <y>, width: <width>, height: <height>)
        makeFuncTransform("CGRectMake", swiftName: "CGRect",
                          arguments: [
                            .labeled("x", .asIs), .labeled("y", .asIs),
                            .labeled("width", .asIs), .labeled("height", .asIs)
                          ])
        // CGSizeMake(<width>, <height>) -> CGSize(width: <width>, height: <height>)
        makeFuncTransform("CGSizeMake", swiftName: "CGSize",
                          arguments: [
                            .labeled("width", .asIs), .labeled("height", .asIs)
                          ])
        // CGRectIntersectsRect(<r1>, <r2>) -> <r1>.intersects(<r2>)
        makeFuncTransform("CGRectIntersectsRect", swiftName: "intersects",
                          arguments: [.asIs], firstArgIsInstance: true)
        // CGRectIntersection(<r1>, <r2>) -> <r1>.intersection(<r2>)
        makeFuncTransform("CGRectIntersection", swiftName: "intersection",
                          arguments: [.asIs], firstArgIsInstance: true)
        // CGRectContainsPoint(<r>, <p>) -> <r>.contains(<p>)
        makeFuncTransform("CGRectContainsPoint", swiftName: "contains", arguments: [.asIs],
                          firstArgIsInstance: true)
        // CGRectContainsRect(<r1>, <r2>) -> <r1>.contains(<r2>)
        makeFuncTransform("CGRectContainsRect", swiftName: "contains", arguments: [.asIs],
                          firstArgIsInstance: true)
        // CGRectOffset(<r>, <x>, <y>) -> <r>.offsetBy(dx: <x>, dy: <y>)
        makeFuncTransform("CGRectOffset", swiftName: "offsetBy",
                          arguments: [.labeled("dx", .asIs), .labeled("dy", .asIs)],
                          firstArgIsInstance: true)
        // CGRectInset(<r>, <x>, <y>) -> <r>.insetBy(dx: <x>, dy: <y>)
        makeFuncTransform("CGRectInset", swiftName: "insetBy",
                          arguments: [.labeled("dx", .asIs), .labeled("dy", .asIs)],
                          firstArgIsInstance: true)
    }
    
    private func makeInstanceCall(_ name: String,
                                  swiftName: String,
                                  arguments: [FunctionInvocationTransformer.ArgumentStrategy] = [.fromArgIndex(1)]) {
        /// Default `transform` parameter handler
        let transform: FunctionInvocationTransformer.ArgumentStrategy =
            .omitIf(matches: .constant(.nil), .labeled("transform", .fromArgIndex(0)))
        
        let transformer =
            FunctionInvocationTransformer(objcFunctionName: name,
                                          toSwiftFunction: swiftName,
                                          firstArgumentBecomesInstance: true,
                                          arguments: arguments + [transform])
        
        transformers.append(transformer)
    }
    
    private func makeCGContextCall(_ name: String,
                                   swiftName: String,
                                   arguments: [FunctionInvocationTransformer.ArgumentStrategy] = []) {
        let transformer =
            FunctionInvocationTransformer(objcFunctionName: name,
                                          toSwiftFunction: swiftName,
                                          firstArgumentBecomesInstance: true,
                                          arguments: arguments)
        
        transformers.append(transformer)
    }
    
    func createCGPathTransformers() {
        /// Converts two expressions into a CGPoint initializer
        let toCGPoint: (Expression, Expression) -> Expression = { x, y in
            Expression.identifier("CGPoint").call([.labeled("x", x), .labeled("y", y)])
        }
        
        makeInstanceCall("CGPathAddRoundedRect", swiftName: "addRoundedRect",
             arguments: [
                .labeled("in", .fromArgIndex(1)),
                .labeled("cornerWidth", .fromArgIndex(2)),
                .labeled("cornerHeight", .fromArgIndex(3))
            ]
        )
        
        makeInstanceCall("CGPathMoveToPoint", swiftName: "move",
                         arguments: [.labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint))])
        
        makeInstanceCall("CGPathAddLineToPoint", swiftName: "addLine",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddQuadCurveToPoint", swiftName: "addQuadCurve",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control", .mergingArguments(arg0: 3, arg1: 4, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddCurveToPoint", swiftName: "addCurve",
             arguments: [
                .labeled("to", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("control1", .mergingArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("control2", .mergingArguments(arg0: 5, arg1: 6, toCGPoint))
            ]
        )
        
        makeInstanceCall("CGPathAddRect", swiftName: "addRect", arguments: [.fromArgIndex(1)])
        
        makeInstanceCall("CGPathAddRects", swiftName: "addRects")
        
        // TODO: This considers a `count` value. We need to make sure in case the
        // count is passed lower than the array's actual count that we keep the
        // same behavior.
        makeInstanceCall("CGPathAddLines", swiftName: "addLines",
                         arguments: [.labeled("between", .fromArgIndex(1))])
        
        makeInstanceCall("CGPathAddEllipseInRect", swiftName: "addEllipse",
                         arguments: [.labeled("in", .fromArgIndex(1))])
        
        makeInstanceCall("CGPathAddRelativeArc", swiftName: "addRelativeArc",
             arguments: [
                .labeled("center", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("delta", .fromArgIndex(5))
            ]
        )
        
        makeInstanceCall("CGPathAddArc", swiftName: "addArc",
             arguments: [
                .labeled("center", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("radius", .fromArgIndex(3)),
                .labeled("startAngle", .fromArgIndex(4)),
                .labeled("endAngle", .fromArgIndex(5)),
                .labeled("clockwise", .fromArgIndex(6))
            ]
        )
        
        makeInstanceCall("CGPathAddArcToPoint", swiftName: "addArc",
             arguments: [
                .labeled("tangent1End", .mergingArguments(arg0: 1, arg1: 2, toCGPoint)),
                .labeled("tangent2End", .mergingArguments(arg0: 3, arg1: 4, toCGPoint)),
                .labeled("radius", .fromArgIndex(5))
            ]
        )
        
        makeInstanceCall("CGPathAddPath", swiftName: "addPath")
    }
    
    func createCGContextTransformers() {
        /// Converts two expressions into a CGPoint initializer
        let toCGPoint: (Expression, Expression) -> Expression = { x, y in
            Expression.identifier("CGPoint").call([.labeled("x", x), .labeled("y", y)])
        }
        
        // Methods
        
        makeCGContextCall("CGContextSaveGState", swiftName: "saveGState")

        makeCGContextCall("CGContextRestoreGState", swiftName: "restoreGState")

        makeCGContextCall("CGContextScaleCTM", swiftName: "scale",
            arguments: [.labeled("x", .asIs), .labeled("y", .asIs)]
        )

        makeCGContextCall("CGContextTranslateCTM", swiftName: "translateBe",
            arguments: [.labeled("x", .asIs), .labeled("y", .asIs)]
        )

        makeCGContextCall("CGContextRotateCTM", swiftName: "rotate",
            arguments: [.labeled("by", .asIs)]
        )

        makeCGContextCall("CGContextConcatCTM", swiftName: "concatenate",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextGetCTM", swiftName: "getCTM")

        makeCGContextCall("CGContextSetLineWidth", swiftName: "setLineWidth",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetLineCap", swiftName: "setLineCap",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetLineJoin", swiftName: "setLineJoin",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetMiterLimit", swiftName: "setMiterLimit",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetLineDash", swiftName: "setLineDash",
            arguments: [.labeled("phase", .asIs), .asIs]
        )

        makeCGContextCall("CGContextSetFlatness", swiftName: "setFlatness",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetAlpha", swiftName: "setAlpha",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetBlendMode", swiftName: "setBlendMode",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextBeginPath", swiftName: "beginPath")

        makeCGContextCall("CGContextMoveToPoint", swiftName: "move",
            arguments: [.labeled("to", .mergingArguments(arg0: 0, arg1: 1, toCGPoint))]
        )

        makeCGContextCall("CGContextAddLineToPoint", swiftName: "addLine",
            arguments: [.labeled("to", .mergingArguments(arg0: 0, arg1: 1, toCGPoint))]
        )

        makeCGContextCall("CGContextAddCurveToPoint", swiftName: "addCurve",
            arguments: [.labeled("to", .mergingArguments(arg0: 4, arg1: 5, toCGPoint)),
                        .labeled("control1", .mergingArguments(arg0: 0, arg1: 1, toCGPoint)),
                        .labeled("control2", .mergingArguments(arg0: 2, arg1: 3, toCGPoint))]
        )

        makeCGContextCall("CGContextAddQuadCurveToPoint", swiftName: "addQuadCurve",
            arguments: [.labeled("to", .mergingArguments(arg0: 2, arg1: 3, toCGPoint)),
                        .labeled("control", .mergingArguments(arg0: 0, arg1: 1, toCGPoint))]
        )

        makeCGContextCall("CGContextClosePath", swiftName: "closePath")

        makeCGContextCall("CGContextAddRect", swiftName: "addRect",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextAddRects", swiftName: "addRects",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextAddLines", swiftName: "addLines",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextAddEllipseInRect", swiftName: "addElipse",
            arguments: [.labeled("in", .mergingArguments(arg0: 0, arg1: 1, toCGPoint))]
        )

        makeCGContextCall("CGContextAddArc", swiftName: "addArc",
            arguments: [.labeled("center", .mergingArguments(arg0: 0, arg1: 1, toCGPoint)),
                        .labeled("radius", .asIs),
                        .labeled("startAngle", .asIs),
                        .labeled("endAngle", .asIs),
                        .labeled("clockwise",
                                 .transformed({ $0.binary(op: .equals, rhs: .constant(1)) },
                                              .asIs
                            ))]
        )

        makeCGContextCall("CGContextAddArcToPoint", swiftName: "addArc",
            arguments: [.labeled("tangent1End", .mergingArguments(arg0: 0, arg1: 1, toCGPoint)),
                        .labeled("tangent2End", .mergingArguments(arg0: 2, arg1: 3, toCGPoint)),
                        .labeled("radius", .asIs)]
        )

        makeCGContextCall("CGContextAddPath", swiftName: "addPath",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextReplacePathWithStrokedPath", swiftName: "replacePathWithStrokedPath")

        makeCGContextCall("CGContextIsPathEmpty", swiftName: "isPathEmpty")

        makeCGContextCall("CGContextGetPathCurrentPoint", swiftName: "getPathCurrentPoint")

        makeCGContextCall("CGContextGetPathBoundingBox", swiftName: "getPathBoundingBox")

        makeCGContextCall("CGContextCopyPath", swiftName: "copyPath")

        makeCGContextCall("CGContextPathContainsPoint", swiftName: "pathContains",
            arguments: [.asIs, .labeled("mode", .asIs)]
        )

        makeCGContextCall("CGContextDrawPath", swiftName: "drawPath",
            arguments: [.labeled("using", .asIs)]
        )

        makeCGContextCall("CGContextFillPath", swiftName: "fillPath")

        makeCGContextCall("CGContextEOFillPath", swiftName: "eOFillPath")

        makeCGContextCall("CGContextStrokePath", swiftName: "strokePath")

        makeCGContextCall("CGContextFillRect", swiftName: "fill",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextFillRects", swiftName: "fillRects",
            arguments: [.asIs] //"(const CGRect * rects, size_t count);"
        )

        makeCGContextCall("CGContextStrokeRect", swiftName: "stroke",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextStrokeRectWithWidth", swiftName: "stroke",
            arguments: [.asIs, .labeled("width", .asIs)]
        )

        makeCGContextCall("CGContextClearRect", swiftName: "clear",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextFillEllipseInRect", swiftName: "fillEllipse",
            arguments: [.labeled("in", .asIs)]
        )

        makeCGContextCall("CGContextStrokeEllipseInRect", swiftName: "strokeEllipse",
            arguments: [.labeled("in", .asIs)]
        )

        makeCGContextCall("CGContextStrokeLineSegments", swiftName: "strokeLineSegments",
            arguments: [.labeled("between", .asIs)]
        )

        makeCGContextCall("CGContextClip", swiftName: "clip")

        makeCGContextCall("CGContextEOClip", swiftName: "eOClip")

        makeCGContextCall("CGContextResetClip", swiftName: "resetClip")

        makeCGContextCall("CGContextClipToMask", swiftName: "clip",
            arguments: [.labeled("to", .asIs), .labeled("mask", .asIs)]
        )

        makeCGContextCall("CGContextGetClipBoundingBox", swiftName: "getClipBoundingBox")

        makeCGContextCall("CGContextClipToRect", swiftName: "clip",
            arguments: [.labeled("to", .asIs)]
        )

        makeCGContextCall("CGContextClipToRects", swiftName: "clip",
            arguments: [.labeled("to", .asIs)]
        )

        makeCGContextCall("CGContextSetFillColorWithColor", swiftName: "setFillColor",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetStrokeColorWithColor", swiftName: "setStrokeColor",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetFillColorSpace", swiftName: "setFillColorSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetStrokeColorSpace", swiftName: "setStrokeColorSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetFillColor", swiftName: "setFillColor",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetStrokeColor", swiftName: "setStrokeColor",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetFillPattern", swiftName: "setFillPattern",
            arguments: [.asIs, .labeled("colorComponents", .asIs)]
        )

        makeCGContextCall("CGContextSetStrokePattern", swiftName: "setStrokePattern",
            arguments: [.asIs, .labeled("colorComponents", .asIs)]
        )

        makeCGContextCall("CGContextSetPatternPhase", swiftName: "setPatternPhase",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetGrayFillColor", swiftName: "setFillColor",
            arguments: [.labeled("gray", .asIs), .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetGrayStrokeColor", swiftName: "setStrokeColor",
            arguments: [.labeled("gray", .asIs), .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetRGBFillColor", swiftName: "setFillColor",
            arguments: [.labeled("red", .asIs), .labeled("green", .asIs),
                        .labeled("blue", .asIs), .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetRGBStrokeColor", swiftName: "setStrokeColor",
            arguments: [.labeled("red", .asIs), .labeled("green", .asIs),
                        .labeled("blue", .asIs), .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetCMYKFillColor", swiftName: "setFillColor",
            arguments: [.labeled("cyan", .asIs), .labeled("magenta", .asIs),
                        .labeled("yellow", .asIs), .labeled("black", .asIs),
                        .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetCMYKStrokeColor", swiftName: "setStrokeColor",
            arguments: [.labeled("cyan", .asIs), .labeled("magenta", .asIs),
                        .labeled("yellow", .asIs), .labeled("black", .asIs),
                        .labeled("alpha", .asIs)]
        )

        makeCGContextCall("CGContextSetRenderingIntent", swiftName: "setRenderingIntent",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextDrawImage", swiftName: "draw",
            arguments: [.fromArgIndex(1), .labeled("in", .fromArgIndex(0))]
        )

        makeCGContextCall("CGContextDrawTiledImage", swiftName: "draw",
            arguments: [.fromArgIndex(1), .labeled("in", .fromArgIndex(0)), .labeled("byTiling", .fixed({ .constant(true) }))]
        )

        makeCGContextCall("CGContextGetInterpolationQuality", swiftName: "getInterpolationQuality")

        makeCGContextCall("CGContextSetInterpolationQuality", swiftName: "setInterpolationQuality",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetShadowWithColor", swiftName: "setShadow",
            arguments: [.labeled("offset", .asIs), .labeled("blur", .asIs), .labeled("color", .asIs)]
        )

        makeCGContextCall("CGContextSetShadow", swiftName: "setShadow",
            arguments: [.labeled("offset", .asIs), .labeled("blur", .asIs)]
        )

        makeCGContextCall("CGContextDrawLinearGradient", swiftName: "drawLinearGradient",
            arguments: [.asIs,
                        .labeled("start", .asIs),
                        .labeled("end", .asIs),
                        .labeled("options", .asIs)]
        )

        makeCGContextCall("CGContextDrawRadialGradient", swiftName: "drawRadialGradient",
            arguments: [.asIs,
                        .labeled("startCenter", .asIs),
                        .labeled("startRadius", .asIs),
                        .labeled("endCenter", .asIs),
                        .labeled("endRadius", .asIs),
                        .labeled("options", .asIs)]
        )

        makeCGContextCall("CGContextDrawShading", swiftName: "drawShading",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetCharacterSpacing", swiftName: "setCharacterSpacing",
            arguments: [.asIs]
        )
        
        makeCGContextCall("CGContextSetTextDrawingMode", swiftName: "setTextDrawingMode",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetFont", swiftName: "setFont",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetFontSize", swiftName: "setFontSize",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextShowGlyphsAtPositions", swiftName: "showGlyphsAtPositions",
            arguments: [.asIs, .asIs]
            //arguments: "(const CGGlyph * glyphs, const CGPoint * Lpositions, size_t count);"
        )

        makeCGContextCall("CGContextDrawPDFPage", swiftName: "drawPDFPage",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextBeginPage", swiftName: "beginPage",
            arguments: [.labeled("mediaBox", .asIs)]
        )

        makeCGContextCall("CGContextEndPage", swiftName: "endPage")

        makeCGContextCall("CGContextRetain", swiftName: "retain")

        makeCGContextCall("CGContextRelease", swiftName: "release")

        makeCGContextCall("CGContextFlush", swiftName: "flush")

        makeCGContextCall("CGContextSynchronize", swiftName: "synchronize")

        makeCGContextCall("CGContextSetShouldAntialias", swiftName: "setShouldAntialias",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetAllowsAntialiasing", swiftName: "setAllowsAntialiasing",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetShouldSmoothFonts", swiftName: "setShouldSmoothFonts",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetAllowsFontSmoothing", swiftName: "setAllowsFontSmoothing",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetShouldSubpixelPositionFonts", swiftName: "setShouldSubpixelPositionFonts",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetAllowsFontSubpixelPositioning", swiftName: "setAllowsFontSubpixelPositioning",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetShouldSubpixelQuantizeFonts", swiftName: "setShouldSubpixelQuantizeFonts",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextSetAllowsFontSubpixelQuantization", swiftName: "setAllowsFontSubpixelQuantization",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextBeginTransparencyLayer", swiftName: "beginTransparencyLayer",
            arguments: [.labeled("auxiliaryInfo", .asIs)]
        )

        makeCGContextCall("CGContextBeginTransparencyLayerWithRect", swiftName: "beginTransparencyLayerWithRect",
            arguments: [.labeled("in", .asIs), .labeled("auxiliaryInfo", .asIs)]
        )

        makeCGContextCall("CGContextEndTransparencyLayer", swiftName: "endTransparencyLayer")

        makeCGContextCall("CGContextGetUserSpaceToDeviceSpaceTransform", swiftName: "getUserSpaceToDeviceSpaceTransform")

        makeCGContextCall("CGContextConvertPointToDeviceSpace", swiftName: "convertToDeviceSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextConvertPointToUserSpace", swiftName: "convertToUserSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextConvertSizeToDeviceSpace", swiftName: "convertToDeviceSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextConvertSizeToUserSpace", swiftName: "convertToUserSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextConvertRectToDeviceSpace", swiftName: "convertToDeviceSpace",
            arguments: [.asIs]
        )

        makeCGContextCall("CGContextConvertRectToUserSpace", swiftName: "convertToUserSpace",
            arguments: [.asIs]
        )
        
        // Properties
        
        makeFuncTransform(
            getter: "CGContextGetTextPosition",
            setter: "CGContextSetTextPosition",
            intoPropertyNamed: "textPosition",
            setterTransformer: .mergingArguments(arg0: 0, arg1: 1, toCGPoint)
        )
        
        makeFuncTransform(
            getter: "CGContextGetTextMatrix",
            setter: "CGContextSetTextMatrix",
            intoPropertyNamed: "textMatrix"
        )
        
        makeFuncTransform(
            getter: "CGContextGetTextMatrix",
            setter: "CGContextSetTextMatrix",
            intoPropertyNamed: "textMatrix"
        )
        
        makeFuncTransform(
            getter: "CGContextGetInterpolationQuality",
            setter: "CGContextSetInterpolationQuality",
            intoPropertyNamed: "interpolationQuality"
        )
        
        // Read-only properties
        
        makeFuncTransform("CGContextGetCTM",                getterName: "ctm")
        makeFuncTransform("CGContextCopyPath",              getterName: "path")
        makeFuncTransform("CGContextIsPathEmpty",           getterName: "isPathEmpty")
        makeFuncTransform("CGContextGetPathCurrentPoint",   getterName: "currentPointOfPath")
        makeFuncTransform("CGContextGetClipBoundingBox",    getterName: "boundingBoxOfClipPath")
        makeFuncTransform("CGContextGetPathBoundingBox",    getterName: "boundingBoxOfPath")
        makeFuncTransform("CGContextGetUserSpaceToDeviceSpaceTransform",
                          getterName: "userSpaceToDeviceSpaceTransform")
        
        // TODO: Support these extra operations
        /*
        makeCGContextCall("CGContextSelectFont", swiftName: "selectFont",
            arguments: "(const char * name, CGFloat size, CGTextEncoding textEncoding);"
        )

        makeCGContextCall("CGContextShowText", swiftName: "showText",
            arguments: "(const char * string, size_t length);"
        )

        makeCGContextCall("CGContextShowTextAtPoint", swiftName: "showTextAtPoint",
            arguments: "(CGFloat x, CGFloat y, const char * string, size_t length);"
        )

        makeCGContextCall("CGContextShowGlyphs", swiftName: "showGlyphs",
            arguments: "(const CGGlyph * g, size_t count);"
        )

        makeCGContextCall("CGContextShowGlyphsAtPoint", swiftName: "showGlyphsAtPoint",
            arguments: "(CGFloat x, CGFloat y, const CGGlyph * glyphs, size_t count);"
        )

        makeCGContextCall("CGContextShowGlyphsWithAdvances", swiftName: "showGlyphsWithAdvances",
            arguments: "(const CGGlyph * glyphs, const CGSize * advances, size_t count);"
        )

        makeCGContextCall("CGContextDrawPDFDocument", swiftName: "drawPDFDocument",
            arguments: "(CGRect rect, CGPDFDocumentRef document, int page);"
        )
        */
    }
}

internal extension Sequence where Element == FunctionArgument {
    func hasLabeledArguments() -> Bool {
        return any { $0.isLabeled }
    }
}
