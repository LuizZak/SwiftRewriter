import XCTest
import SwiftRewriterLib
import SwiftAST
import ExpressionPasses

class AllocInitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = AllocInitExpressionPass()
    }
    
    func testPlainInit() {
        assertTransformParsed(
            expression: "[[ClassName alloc] init]",
            into: .postfix(.identifier("ClassName"), .functionCall(arguments: []))
        )
    }
    
    func testInitWith() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithName:@\"abc\"]",
            into: .postfix(.identifier("ClassName"), .functionCall(arguments: [.labeled("name", .constant("abc"))]))
        )
    }
    
    func testInitWithCompoundName() {
        assertTransformParsed(
            expression: "[[ClassName alloc] initWithFirstName:@\"John\" secondName:@\"Doe\"]",
            into: .postfix(.identifier("ClassName"),
                               .functionCall(arguments: [.labeled("firstName", .constant("John")),
                                                         .labeled("secondName", .constant("Doe"))]))
        )
        
        assertTransformParsed(
            expression: "[[ClassName alloc] initWith:@\"John\" secondName:@\"Doe\"]",
            into: .postfix(.identifier("ClassName"),
                               .functionCall(arguments: [.unlabeled(.constant("John")),
                                                         .labeled("secondName", .constant("Doe"))]))
        )
    }
    
    func testSuperInitWith() {
        assertTransformParsed(
            expression: "[super initWithFrame:frame]",
            into: .postfix(.postfix(.identifier("super"),
                                        .member("init")),
                               .functionCall(arguments: [
                                .labeled("frame", .identifier("frame"))
                                ]))
        )
        
        // Test we leave simple super.init() calls alone
        assertTransformParsed(
            expression: "[super init]",
            into: .postfix(.postfix(.identifier("super"), .member("init")),
                               .functionCall(arguments: []))
        )
    }
    
    /// Tests `[[self alloc] init]` where `self` is a metatype results in a
    /// `Type.init()` call
    func testInitSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))
        
        assertTransform(
            expression: .postfix(.postfix(.postfix(.postfix(typeNameExp,
                                                          .member("alloc")),
                                                 .functionCall(arguments: [])),
                                        .member("init")),
                               .functionCall(arguments: [])),
            into: .postfix(.postfix(typeNameExp,
                                        .member("init")),
                               .functionCall(arguments: []))
        )
    }
    
    /// Tests `[[[self alloc] initWithThing:[...]]` where `self` is a metatype
    /// results in a `Type.init(thing: [...])` call
    func testInitWithThingSelfClassType() {
        let typeNameExp = Expression.identifier("self")
        typeNameExp.resolvedType = .metatype(for: .typeName("ClassName"))
        
        let exp: Expression =
            .postfix(.postfix(.postfix(.postfix(typeNameExp,
                                                .member("alloc")),
                                       .functionCall(arguments: [])),
                              .member("initWithThing")),
                     .functionCall(arguments: [.unlabeled(.constant(1))]))
        
        assertTransform(
            expression: exp,
            into: .postfix(.postfix(typeNameExp,
                                        .member("init")),
                               .functionCall(arguments: [.labeled("thing", .constant(1))]))
        )
    }
}
