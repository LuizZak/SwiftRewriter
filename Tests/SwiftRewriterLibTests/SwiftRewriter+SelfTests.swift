import SwiftRewriterLib
import SwiftAST
import XCTest

/// Tests for some meta behavior of SwiftRewriter when handling `self`
class SwiftRewriter_SelfTests: XCTestCase {
    
    /// Tests that the `self` identifier is properly assigned when resolving the
    /// final types of statements in a class
    func testSelfTypeInInstanceMethodsPointsToSelfInstance() throws {
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
    
    /// Tests that the `self` identifier used in a method class context is properly
    /// assigned to the class' metatype
    func testSelfTypeInClassMethodsPointsToMetatype() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            + (void)classMethod {
                (self);
            }
            // Here just to check the transpiler correctly switches between metatype
            // and instance type while iterating over methods to output
            - (void)instanceMethod {
                (self);
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                static func classMethod() {
                    // type: MyClass.self
                    (self)
                }
                @objc
                func instanceMethod() {
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
    
    func testSelfInitInClassMethod() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject // To inherit [self init] constructor
            @end
            
            @implementation MyClass
            + (void)method {
                [[self alloc] init];
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                static func method() {
                    // type: MyClass
                    self.init()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testSelfPropertyFetch() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            @property NSInteger aValue;
            @end
            
            @implementation MyClass
            - (void)method {
                self.aValue;
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc var aValue: Int
                
                @objc
                func method() {
                    // type: Int
                    self.aValue
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testMessageSelf() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            - (void)method1;
            - (NSInteger)method2;
            @end
            
            @implementation MyClass
            - (void)method1 {
                [self method2];
            }
            - (NSInteger)method2 {
                return 0;
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func method1() {
                    // type: Int
                    self.method2()
                }
                @objc
                func method2() -> Int {
                    return 0
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testMessageClassSelf() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            + (void)method1;
            + (NSInteger)method2;
            @end
            
            @implementation MyClass
            + (void)method1 {
                [self method2];
            }
            + (NSInteger)method2 {
                return 0;
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                static func method1() {
                    // type: Int
                    self.method2()
                }
                @objc
                static func method2() -> Int {
                    return 0
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testCustomInitClass() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            @end
            
            @interface B: NSObject
            - (instancetype)initWithValue:(NSInteger)value;
            @end
            
            @implementation A
            - (void)method {
                [[B alloc] initWithValue:0];
            }
            @end

            @implementation B
            - (instancetype)initWithValue:(NSInteger)value {
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc
                func method() {
                    // type: B
                    B(value: 0)
                }
            }
            @objc
            class B: NSObject {
                @objc
                init(value: Int) {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}
