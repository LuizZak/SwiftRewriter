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
            @objc
            class MyClass: NSObject {
                @objc
                func originalMethod() {
                }
            }
            // End of file MyClass.swift
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
            @objc
            class MyClass: NSObject {
            }
            // End of file Class.swift
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
    
    func testTypeLookupsHappenAfterAllSourceCodeIsParsed() {
        assertThat()
            .file(name: "A.h",
            """
            typedef NS_ENUM(NSString*, AnEnum) {
                AnEnumCase1
            };
            
            B *globalB;
            @interface A: NSObject
            {
                B* ivarB;
            }
            @property (nonnull) B *b; // Should translate to 'B', and not 'UnsafeMutablePointer<B>!'
            - (B*)takesB:(B*)b;
            - (instancetype)initWithB:(B*)b;
            @end
            """)
            .file(name: "B.h",
            """
            @interface B: NSObject
            @end
            """)
            .translatesToSwift("""
            @objc enum AnEnum: String {
                case AnEnumCase1
            }
            
            var globalB: B!
            
            @objc
            class A: NSObject {
                private var ivarB: B!
                @objc var b: B
                
                @objc
                init(b: B!) {
                }
                @objc
                func takesB(_ b: B!) -> B! {
                }
            }
            // End of file A.swift
            @objc
            class B: NSObject {
            }
            // End of file B.swift
            """)
    }
    
    func testChainCallRespondsToSelectorWithReproCase() {
        assertThat()
            .file(name: "A.h",
            """
            #pragma mark - Delegate
            @class Class;
            @protocol Delegate <NSObject>
            - (void)delegateMethod:(nonnull Class*)cls;
            @end

            @interface Class : UIView
            @property (weak, nullable) id<Delegate> delegate;
            @end

            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @implementation Class
            #pragma mark - Calculation methods
            - (void)method
            {
                (self.delegate);
                [self.delegate respondsToSelector:@selector(delegateMethod:)];
                if([self.delegate respondsToSelector:@selector(delegateMethod:)])
                {
                    [self.delegate delegateMethod:self];
                }
            }
            @end
            """)
            .translatesToSwift("""
            // Preprocessor directives found in file:
            // #pragma mark - Delegate
            // #pragma mark - Calculation methods
            @objc
            protocol Delegate: NSObjectProtocol {
                @objc
                func delegateMethod(_ cls: Class)
            }

            @objc
            class Class: UIView {
                @objc weak var delegate: Delegate?
                
                @objc
                func method() {
                    // type: Delegate?
                    self.delegate
                    // type: Bool?
                    self.delegate?.responds(to: Selector("delegateMethod:"))
                    if self.delegate?.responds(to: Selector("delegateMethod:")) == true {
                        // type: Void?
                        self.delegate?.delegateMethod(self)
                    }
                }
            }
            // End of file A.swift
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testPreserversAssumesNonnullContextAfterMovingDeclarationsFromHeaderToImplementation() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            typedef void(^errorBlock)(NSString *param);
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @interface A
            @end
            """)
            .translatesToSwift("""
            typealias errorBlock = (String) -> Void

            @objc
            class A: NSObject {
            }
            // End of file A.swift
            """)
    }
    
    func testMergeNullabilityOfBlockTypes() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            @interface A
            - (void)method:(void(^)(NSString*))param;
            @end
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            @implementation A
            - (void)method:(void(^)(NSString*))param {
            }
            @end
            """)
            .translatesToSwift("""
            @objc
            class A: NSObject {
                @objc
                func method(_ param: (String) -> Void) {
                }
            }
            // End of file A.swift
            """)
    }
    
    func testMergeNullabilityOfExternGlobals() {
        assertThat()
            .file(name: "A.h", """
            NS_ASSUME_NONNULL_BEGIN
            extern NSString *const kCPTableMenuViewReuseIdentifier;
            NS_ASSUME_NONNULL_END
            """)
            .file(name: "A.m", """
            NSString *const kCPTableMenuViewReuseIdentifier = @"cell";
            """)
            .translatesToSwift("""
            let kCPTableMenuViewReuseIdentifier: String = "cell"
            // End of file A.swift
            """)
    }
    
    func testMergeAndKeepNullabilityDefinitions() {
        assertThat()
            .file(name: "A.h", """
            @interface A : NSObject
            @property CGFloat width;
            @end
            """)
            .file(name: "A.m", """
            @implementation A
            @end
            """)
            .file(name: "B.h", """
            @interface B : NSObject
            @property (nullable) A* a;
            - (void)takesCGFloat:(CGFloat)f;
            @end
            """)
            .file(name: "B.m", """
            @implementation B
            - (void)method {
                [self takesCGFloat:a.width];
            }
            - (void)takesCGFloat:(CGFloat)f {
            }
            @end
            """)
            .translatesToSwift("""
            @objc
            class A: NSObject {
                @objc var width: CGFloat = 0.0
            }
            // End of file A.swift
            @objc
            class B: NSObject {
                @objc var a: A?
                
                @objc
                func method() {
                    self.takesCGFloat(a?.width ?? 0.0)
                }
                @objc
                func takesCGFloat(_ f: CGFloat) {
                }
            }
            // End of file B.swift
            """)
    }
    
    func testHandleMultifileTypesInheritingFromTypesDefinedInGlobalProviders() {
        assertThat()
            .file(name: "A.h", """
            @interface A: UIView
            @property (nullable) B* b;
            @end
            """)
            .file(name: "A.m", """
            @implementation A
            - (void)test {
                (self.window.bounds);
                (self.b.bounds);
            }
            @end
            """)
            .file(name: "B.h", """
            @interface B: UIView
            @end
            """)
            .translatesToSwift(
            """
            @objc
            class A: UIView {
                @objc var b: B?
                
                @objc
                func test() {
                    // type: CGRect?
                    self.window?.bounds
                    // type: CGRect?
                    self.b?.bounds
                }
            }
            // End of file A.swift
            @objc
            class B: UIView {
            }
            // End of file B.swift
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}

extension SwiftRewriter_MultiFilesTests {
    private func assertThat() -> MultiFileTestBuilder {
        return MultiFileTestBuilder(test: self)
    }
}
