import XCTest
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class PropertyAsMethodAccessCorrectingExpressionPassTests: ExpressionPassTestCase {

    override func setUp() {
        super.setUp()
        
        sutType = PropertyAsMethodAccessCorrectingExpressionPass.self
    }
    
    func testTransform() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "property", type: .int)
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression: Expression.identifier("a").typed("A").dot("property").call(),
            into: Expression.identifier("a").typed("A").dot("property")
        ); assertNotifiedChange()
    }
    
    func testTransformStaticType() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "property", type: .int, isStatic: true, accessor: .getter)
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression: Expression.identifier("A").typed(.metatype(for: "A")).dot("property").call(),
            into: Expression.identifier("A").typed(.metatype(for: "A")).dot("property")
        ); assertNotifiedChange()
    }
    
    func testTransformChained() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "property", type: "A")
            .property(named: "otherProperty", type: .int)
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression: Expression
                .identifier("a").typed("A")
                .dot("property").call()
                .dot("property").call()
                .dot("otherProperty"),
            into: Expression
                .identifier("a").typed("A")
                .dot("property")
                .dot("property")
                .dot("otherProperty")
        ); assertNotifiedChange()
    }
}
