import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriter_MultiFilesTests: XCTestCase {
    
    func testEmittingHeaderWhenMissingImplementation() {
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
            // End of file objc.swift
            """)
    }
    
    func testAvoidEmittingHeaderWhenImplementationExists() {
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
            // End of file objc.swift
            """)
    }
    
    func testProcessAssumeNonnullAcrossFiles() {
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
            // End of file objc.swift
            """)
    }
    
    func testClassCategory() {
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
            // End of file MyClass.swift
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
            // End of file MyClass+Ext.swift
            """)
    }
    
    /// When merging categories in .h/.m files, try to group them by matching
    /// category name on the resulting .swift file, such that `extension`s are
    /// declared for each combined category name.
    func testMergingCategoriesTakeCategoryNameInConsideration() {
        assertThat()
            .file(name: "Class.h",
            """
            @interface MyClass : NSObject
            @end
            """)
            .file(name: "Class.m",
            """
            @implementation MyClass
            @end
            """)
            .file(name: "Class+Ext.h",
            """
            @interface MyClass (Ext1)
            - (void)f1;
            @end
            @interface MyClass (Ext2)
            - (void)f2;
            @end
            """)
            .file(name: "Class+Ext.m",
            """
            @implementation MyClass (Ext1)
            - (void)f1 {
                stmt1();
            }
            @end
            @implementation MyClass (Ext2)
            - (void)f2 {
                stmt2();
            }
            @end
            """)
            .translatesToSwift("""
            @objc
            class MyClass: NSObject {
            }
            // End of file Class.swift
            // MARK: - Ext1
            @objc
            extension MyClass {
                @objc
                func f1() {
                    stmt1()
                }
            }
            // MARK: - Ext2
            @objc
            extension MyClass {
                @objc
                func f2() {
                    stmt2()
                }
            }
            // End of file Class+Ext.swift
            """)
    }
    
    func testRespectsOrderingOfImplementation() {
        // Tests that when coming up with the ordering of the method definitions
        // within a file, try to stick with the ordering of the methods as they
        // are on the @implementation for the class.
        assertThat()
            .file(name: "file.h",
            """
            @interface MyClass
            - (void)doThing;
            @end
            """)
            .file(name: "file.m",
            """
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
            }
            - (void)doThing {
            }
            @end
            """)
            .translatesToSwift("""
            @objc
            class MyClass: NSObject {
                @objc
                init(thing: AnyObject!) {
                }
                @objc
                func doThing() {
                }
            }
            // End of file file.swift
            """)
    }
    
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
