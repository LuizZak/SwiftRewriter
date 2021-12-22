import XCTest
import SwiftAST
import KnownType
import Intentions
import SwiftRewriterLib

@testable import ExpressionPasses

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
            expression: .identifier("a").typed("A").dot("property").call(),
            into: .identifier("a").typed("A").dot("property")
        ); assertNotifiedChange()
    }
    
    func testTransformStaticType() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "property", type: .int, isStatic: true, accessor: .getter)
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression: .identifier("A").typed(.metatype(for: "A")).dot("property").call(),
            into: .identifier("A").typed(.metatype(for: "A")).dot("property")
        ); assertNotifiedChange()
    }
    
    func testTransformChained() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "property", type: "A")
            .property(named: "otherProperty", type: .int)
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression:
                .identifier("a").typed("A")
                .dot("property").call()
                .dot("property").call()
                .dot("otherProperty"),
            into:
                .identifier("a").typed("A")
                .dot("property")
                .dot("property")
                .dot("otherProperty")
        ); assertNotifiedChange()
    }
    
    func testDontTransformClosureCalls() {
        // Make sure we ignore invocations to closure properties
        
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "aClosure", type: .swiftBlock(returnType: .void, parameters: []))
            .property(named: "anOptionalClosure",
                      type: .optional(.swiftBlock(returnType: .void, parameters: [])))
            .build()
        typeSystem.addType(type)
        
        assertTransform(
            expression:
                .identifier("a").typed("A")
                .dot("aClosure").call(),
            into:
                .identifier("a").typed("A")
                .dot("aClosure").call()
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression:
                .identifier("a").typed("A")
                .dot("anOptionalClosure").optional().call(),
            into:
                .identifier("a").typed("A")
                .dot("anOptionalClosure").optional().call()
        ); assertDidNotNotifyChange()
    }
    
    func testDontTransformClosureCallsLookingThroughTypeAliases() {
        // Make sure we traverse type aliases to detect block properties
        
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "aClosure", type: "BlockAlias")
            .property(named: "anOptionalClosure", type: .optional("BlockAlias"))
            .property(named: "aSecondOptionalClosure", type: "OptionalBlockAlias")
            .build()
        typeSystem.addType(type)
        typeSystem.addTypealias(aliasName: "BlockAlias",
                                originalType: .swiftBlock(returnType: .void, parameters: []))
        typeSystem.addTypealias(aliasName: "OptionalBlockAlias",
                                originalType: .optional(.swiftBlock(returnType: .void, parameters: [])))
        
        assertTransform(
            expression:
                .identifier("a").typed("A")
                .dot("aClosure").call(),
            into:
                .identifier("a").typed("A")
                .dot("aClosure").call()
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression:
                .identifier("a").typed("A")
                .dot("anOptionalClosure").optional().call(),
            into:
                .identifier("a").typed("A")
                .dot("anOptionalClosure").optional().call()
        ); assertDidNotNotifyChange()
    }
}
