import XCTest

class SwiftRewriter_StmtTests: XCTestCase {
    func testTranslateSimpleMethod() throws {
        try assertObjcParse(objc: """
            @implementation MyClass
            - (void)myMethod {
                [self thing];
            }
            @end
            """, swift: """
            class MyClass: NSObject {
                func myMethod() {
                    self.thing()
                }
            }
            """)
    }
}
