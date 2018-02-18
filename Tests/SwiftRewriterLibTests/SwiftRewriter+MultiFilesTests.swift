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
            @objc
            class MyClass: NSObject {
                @objc
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
            @objc
            class MyClass: NSObject {
                @objc
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
            @objc
            class MyClass: NSObject {
                @objc var property: String
                
                @objc
                func myMethod(_ parameter: String) -> AnyObject {
                }
            }
            // End of file objc.m
            """)
    }
    
    func testClassCategory() throws {
        assertThat()
            .file(name: "MyClass.h",
            """
            @interface MyClass
            - (void)originalMethod;
            @end
            """)
            .file(name: "MyClass.m",
            """
            @implementation MyClass
            - (void)originalMethod {
            }
            @end
            """)
            .file(name: "MyClass+Ext.h",
            """
            @interface MyClass (Extension)
            - (void)fromExtension;
            - (void)fromExtensionInterfaceOnly;
            @end
            """)
            .file(name: "MyClass+Ext.m",
            """
            @implementation MyClass (Extension)
            - (void)fromExtension {
            }
            @end
            """)
            .translatesToSwift(
            """
            @objc
            class MyClass: NSObject {
                @objc
                func originalMethod() {
                }
            }
            // End of file MyClass.m
            // MARK: - Extension
            @objc
            extension MyClass {
                @objc
                func fromExtension() {
                }
                @objc
                func fromExtensionInterfaceOnly() {
                }
            }
            // End of file MyClass+Ext.m
            """)
    }
    
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
