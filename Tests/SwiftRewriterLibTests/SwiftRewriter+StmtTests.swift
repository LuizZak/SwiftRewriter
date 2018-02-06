import XCTest

class SwiftRewriter_StmtTests: XCTestCase {
    func testTranslateSingleSelectorMessage() throws {
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
    
    func testTranslateTwoSelectorMessage() throws {
        try assertObjcParse(objc: """
            @implementation MyClass
            - (void)myMethod {
                [self thing:a b:c];
            }
            @end
            """, swift: """
            class MyClass: NSObject {
                func myMethod() {
                    self.thing(a, b: c)
                }
            }
            """)
    }
}
