import SwiftAST
import SwiftRewriterLib
import XCTest

@testable import ExpressionPasses

class AllocInitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = AllocInitExpressionPass.self
    }

    func testPlainInit() {
        assertTransformParsed(
            expression: "[[ClassName alloc] init]",
            into: .identifier("ClassName").call()
        )
    }

    func testInitWith() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithName:@\"abc\"]",
            into: .identifier("ClassName").call([.labeled("name", .constant("abc"))])
        )
    }

    func testInitWithCompoundName() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithFirstName:@\"John\" secondName:@\"Doe\"]",
            into:
                Expression
                .identifier("ClassName")
                .call([
                    .labeled("firstName", .constant("John")),
                    .labeled("secondName", .constant("Doe")),
                ])
        )

        assertTransformParsed(
            expression: "[[ClassName alloc] initWith:@\"John\" secondName:@\"Doe\"]",
            into:
                Expression
                .identifier("ClassName")
                .call([
                    .unlabeled(.constant("John")),
                    .labeled("secondName", .constant("Doe")),
                ])
        )
    }

    func testSuperInitWith() {
        assertTransformParsed(
            expression: "[super initWithFrame:frame]",
            into:
                Expression
                .identifier("super")
                .dot("init").call([.labeled("frame", .identifier("frame"))])
        )

        // Test we leave simple super.init() calls alone
        assertNoTransformParsed(
            expression: "[super init]"
        )
    }

    /// Tests `[[self alloc] init]` where `self` is a metatype results in a
    /// `Type.init()` call
    func testInitSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))

        assertTransform(
            expression: typeNameExp.copy()
                .dot("alloc").call()
                .dot("init").call(),
            into: typeNameExp.dot("init").call()
        )
    }

    /// Tests `[[super alloc] init]` where `super` is a metatype results in a
    /// `Type.init()` call
    func testInitSuperClassType() {
        let typeNameExp = Expression.identifier("super")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))

        assertTransform(
            expression: typeNameExp.copy()
                .dot("alloc").call()
                .dot("init").call(),
            into: typeNameExp.dot("init").call()
        )
    }

    /// Tests `[[[self alloc] initWithThing:[...]]` where `self` is a metatype
    /// results in a `Type.init(thing: [...])` call
    func testInitWithThingSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))

        assertTransform(
            expression: typeNameExp.copy()
                .dot("alloc").call()
                .dot("initWithThing")
                .call([.unlabeled(.constant(1))]),
            into: typeNameExp.dot("init").call([.labeled("thing", .constant(1))])
        )
    }

    /// Tests `[[[super alloc] initWithThing:[...]]` where `super` is a metatype
    /// results in a `Type.init(thing: [...])` call
    func testInitWithThingSuperClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))

        assertTransform(
            expression: typeNameExp.copy()
                .dot("alloc").call()
                .dot("initWithThing")
                .call([.unlabeled(.constant(1))]),
            into: typeNameExp.dot("init").call([.labeled("thing", .constant(1))])
        )
    }

    /// Tests `[<nullable-exp> initWithThing:[...]]` transforms properly into
    /// a still nullable-accessed `<nullable-exp>?.init(thing: [...])`
    func testOptionalInitWithThing() {
        let typeNameExp = Expression.identifier("className")
        typeNameExp.resolvedType = .optional(.typeName("ClassName"))

        assertTransform(
            expression: typeNameExp.copy()
                .optional()
                .dot("initWithThing")
                .call([.unlabeled(.constant(1))]),
            into: typeNameExp.optional().dot("init").call([.labeled("thing", .constant(1))])
        )
    }
}
