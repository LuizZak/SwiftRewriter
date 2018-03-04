import XCTest
import SwiftAST
import SwiftRewriterLib
import ExpressionPasses

class NumberCommonsExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = NumberCommonsExpressionPass()
    }
    
    func testConvertNumericCast() {
        let exp = Expression.constant(1).casted(to: .float)
        
        assertTransform(
            expression: exp,
            into: Expression
                .identifier("Float")
                .call(arguments: [
                    .unlabeled(.constant(1))
                    ])
        )
        
        assertNotifiedChange()
    }
    
    func testDoNotConvertNonNumericCasts() {
        let exp = Expression.constant(1).casted(to: .typeName("ffloaty"))
        
        assertTransform(
            expression: exp,
            into: Expression.constant(1).casted(to: .typeName("ffloaty"))
        )
        
        assertDidNotNotifyChange()
    }
    
    func testConvertFloatMethods() {
        assertTransform(
            expression: Expression.identifier("floorf").call(arguments: [.unlabeled(.constant(1))]),
            into: Expression.identifier("floor").call(arguments: [.unlabeled(.constant(1))])
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression.identifier("ceilf").call(arguments: [.unlabeled(.constant(1))]),
            into: Expression.identifier("ceil").call(arguments: [.unlabeled(.constant(1))])
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression.identifier("roundf").call(arguments: [.unlabeled(.constant(1))]),
            into: Expression.identifier("round").call(arguments: [.unlabeled(.constant(1))])
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression.identifier("fabs").call(arguments: [.unlabeled(.constant(1))]),
            into: Expression.identifier("abs").call(arguments: [.unlabeled(.constant(1))])
        ); assertNotifiedChange()
    }
}
