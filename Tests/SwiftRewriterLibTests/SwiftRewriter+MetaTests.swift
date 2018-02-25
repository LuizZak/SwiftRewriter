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
    
    func testSelfTypeInPropertySynthesizedGetterAndSetterBody() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : NSObject
            @property BOOL value;
            @end
            
            @implementation MyClass
            - (void)setValue:(BOOL)newValue {
                (self);
            }
            - (BOOL)value {
                (self);
                return NO;
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc var value: Bool {
                    get {
                        // type: MyClass
                        (self)
                        return false
                    }
                    set {
                        // type: MyClass
                        (self)
                    }
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}
