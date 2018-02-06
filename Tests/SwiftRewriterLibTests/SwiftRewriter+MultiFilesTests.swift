import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriter_MultiFilesTests: XCTestCase {
    
    func testEmittingHeaderWhenMissingImplementation() throws {
        assertThat()
            .file(name: "objc.h",
            """
            @interface MyClass
            - (void)myMethod;
            @end
            """)
            .translatesToSwift(
            """
            class MyClass: NSObject {
                func myMethod() {
                }
            }
            // End of file objc.h
            """)
    }
    
    func testAvoidEmittingHeaderWhenImplementationExists() throws {
        assertThat()
            .file(name: "objc.h",
            """
            @interface MyClass
            - (void)myMethod;
            @end
            """)
            .file(name: "objc.m",
            """
            @implementation MyClass
            - (void)myMethod {
            }
            @end
            """)
            .translatesToSwift(
            """
            class MyClass: NSObject {
                func myMethod() {
                }
            }
            // End of file objc.m
            """)
    }
    
    func testProcessAssumeNonnullAcrossFiles() throws {
        assertThat()
            .file(name: "objc.h",
            """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass
            @property NSString *property;
            - (id)myMethod:(NSString*)parameter;
            @end
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "objc.m",
            """
            @implementation MyClass
            - (id)myMethod:(NSString*)parameter {
            }
            @end
            """)
            .translatesToSwift(
            """
            class MyClass: NSObject {
                var property: String
                
                func myMethod(parameter: String) -> AnyObject {
                }
            }
            // End of file objc.m
            """)
    }
    
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
