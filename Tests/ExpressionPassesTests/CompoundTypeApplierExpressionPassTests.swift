import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class CompoundTypeApplierExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = CompoundTypeApplierExpressionPass.self
    }

    func testUIColorConversions() {
        assertTransform(
            expression: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orangeColor")
                .call()
                .typed("UIColor"),
            into: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("orange")
                .typed("UIColor")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("redColor")
                .call()
                .typed("UIColor"),
            into: Expression
                .identifier("UIColor")
                .typed(.metatype(for: "UIColor"))
                .dot("red")
                .typed("UIColor")
        ); assertNotifiedChange()
        
        // Test unrecognized cases are left alone
        assertTransformParsed(
            expression: "UIColor->redColor",
            into: "UIColor.redColor"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "[UIColor redColor:@1]",
            into: "UIColor.redColor(1)"
        ); assertDidNotNotifyChange()
        assertTransformParsed(
            expression: "[UIColor Color:@1]",
            into: "UIColor.Color(1)"
        ); assertDidNotNotifyChange()
    }
    
    func testConvertUIViewBooleanGetters() {
        let _exp = Expression.identifier("view")
        _exp.resolvedType = .typeName("UIView")
        
        var exp: Expression {
            return _exp.copy()
        }
        
        let makeGetter: (String) -> Expression = {
            return exp.dot($0)
        }
        
        assertTransform(
            expression: makeGetter("opaque"),
            into: exp.dot("isOpaque")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("hidden"),
            into: exp.dot("isHidden")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("userInteractionEnabled"),
            into: exp.dot("isUserInteractionEnabled")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: makeGetter("focused"),
            into: exp.dot("isFocused")
        ); assertNotifiedChange()
    }
    
    func testUIViewAnimateWithDuration() {
        assertTransform(
            expression: Expression
                .identifier("UIView")
                .typed(.metatype(for: .typeName("UIView")))
                .dot("animateWithDuration")
                .call([
                    .unlabeled(.constant(0.3)),
                    .labeled("animations", .block(body: []))
                    ]),
            into: Expression
                .identifier("UIView")
                .dot("animate")
                .call([
                    .labeled("withDuration", .constant(0.3)),
                    .labeled("animations", .block(body: []))
                    ])
        ); assertNotifiedChange()
    }
}
