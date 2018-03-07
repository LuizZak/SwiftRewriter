import XCTest
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class AllocInitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = AllocInitExpressionPass()
    }
    
    func testPlainInit() {
        assertTransformParsed(
            expression: "[[ClassName alloc] init]",
            into: Expression.identifier("ClassName").call()
        )
        
        assertNotifiedChange()
    }
    
    func testInitWith() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithName:@\"abc\"]",
            into: Expression.identifier("ClassName").call([.labeled("name", .constant("abc"))])
        )
        
        assertNotifiedChange()
    }
    
    func testInitWithCompoundName() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithFirstName:@\"John\" secondName:@\"Doe\"]",
            into: Expression
                .identifier("ClassName")
                .call([.labeled("firstName", .constant("John")),
                       .labeled("secondName", .constant("Doe"))
                ])
        )
        
        assertNotifiedChange()
        
        assertTransformParsed(
            expression: "[[ClassName alloc] initWith:@\"John\" secondName:@\"Doe\"]",
            into: Expression
                .identifier("ClassName")
                .call([.unlabeled(.constant("John")),
                       .labeled("secondName", .constant("Doe"))
                ])
        )
        
        assertNotifiedChange()
    }
    
    func testSuperInitWith() {
        assertTransformParsed(
            expression: "[super initWithFrame:frame]",
            into: Expression
                .identifier("super")
                .dot("init").call([.labeled("frame", .identifier("frame"))])
        )
        
        assertNotifiedChange()
        
        // Test we leave simple super.init() calls alone
        assertTransformParsed(
            expression: "[super init]",
            into: Expression
                .identifier("super")
                .dot("init").call()
        )
        
        assertDidNotNotifyChange()
    }
    
    /// Tests `[[self alloc] init]` where `self` is a metatype results in a
    /// `Type.init()` call
    func testInitSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))
        
        assertTransform(
            expression: Expression
                .identifier("self")
                .dot("alloc").call()
                .dot("init").call(),
            into: typeNameExp.call()
        )
        
        assertNotifiedChange()
    }
    
    /// Tests `[[[self alloc] initWithThing:[...]]` where `self` is a metatype
    /// results in a `Type.init(thing: [...])` call
    func testInitWithThingSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))
        
        assertTransform(
            expression: Expression
                .identifier("self")
                .dot("alloc").call()
                .dot("initWithThing")
                .call([.unlabeled(.constant(1))]),
            into: typeNameExp.call([.labeled("thing", .constant(1))])
        )
        
        assertNotifiedChange()
    }
}
