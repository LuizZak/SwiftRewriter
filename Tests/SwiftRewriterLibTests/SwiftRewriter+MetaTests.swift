import SwiftRewriterLib
import SwiftAST
import XCTest

/// Tests for some meta behavior of SwiftRewriter
class SwiftRewriter_MetaTests: XCTestCase {
    
    /// Tests that the `self` identifier is properly assigned when resolving the
    /// final types of statements in a class
    func testSelfTypeInMethodsPointsToSelfInstance() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)method {
                (self);
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func method() {
                    // type: MyClass
                    (self)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}
