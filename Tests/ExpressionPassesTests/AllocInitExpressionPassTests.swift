import XCTest
import SwiftRewriterLib
import ExpressionPasses

class AllocInitExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = AllocInitExpressionPass()
    }
    
    func testPlainInit() {
        assertTransformParsed(
            original: "[[ClassName alloc] init]",
            expected: .postfix(.identifier("ClassName"), .functionCall(arguments: []))
        )
    }
    
    func testInitWith() {
        assertTransformParsed(
            original: "[[ClassName alloc] initWithName:@\"abc\"]",
            expected: .postfix(.identifier("ClassName"), .functionCall(arguments: [.labeled("name", .constant("abc"))]))
        )
    }
    
    func testInitWithCompoundName() {
        assertTransformParsed(
            original: "[[ClassName alloc] initWithFirstName:@\"John\" secondName:@\"Doe\"]",
            expected: .postfix(.identifier("ClassName"),
                               .functionCall(arguments: [.labeled("firstName", .constant("John")),
                                                         .labeled("secondName", .constant("Doe"))]))
        )
        
        assertTransformParsed(
            original: "[[ClassName alloc] initWith:@\"John\" secondName:@\"Doe\"]",
            expected: .postfix(.identifier("ClassName"),
                               .functionCall(arguments: [.unlabeled(.constant("John")),
                                                         .labeled("secondName", .constant("Doe"))]))
        )
    }
    
    func testSuperInitWith() {
        assertTransformParsed(
            original: "[super initWithFrame:frame]",
            expected: .postfix(.postfix(.identifier("super"),
                                        .member("init")),
                               .functionCall(arguments: [
                                .labeled("frame", .identifier("frame"))
                                ]))
        )
        
        // Test we leave simple super.init() calls alone
        assertTransformParsed(
            original: "[super init]",
            expected: .postfix(.postfix(.identifier("super"), .member("init")),
                               .functionCall(arguments: []))
        )
    }
}
