import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
    func testParseNonnullMacros() throws {
        try assertObjcParse(objc: """
            NS_ASSUME_NONNULL_BEGIN
            NS_ASSUME_NONNULL_END
            """, swift: """
            """)
    }
    
    func testRewriteEmptyClass() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            @end
            """,
            swift: """
            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteInfersNSObjectSuperclass() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @end
            """,
            swift: """
            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteInheritance() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : UIView
            @end
            """,
            swift: """
            class MyClass: UIView {
            }
            """)
    }
    
    func testRewriteSubclassInInterface() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : MyBaseClass
            @end

            @implementation MyClass
            @end
            """,
            swift: """
            class MyClass: MyBaseClass {
            }
            """)
    }
    
    func testRewriteProtocolSpecification() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass : UIView <UITableViewDelegate>
            @end
            """,
            swift: """
            class MyClass: UIView, UITableViewDelegate {
            }
            """)
    }
    
    func testRewriteWeakProperty() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property (weak) MyClass *myClass;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc weak var myClass: MyClass?
            }
            """)
    }
    
    func testRewriteClassProperties() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property BOOL someField;
            @property NSInteger someOtherField;
            @property (nonnull) NSString *aRatherStringlyField;
            @property (nullable) NSString *specifiedNull;
            @property NSString *_Nonnull nonNullWithQualifier;
            @property NSString *nonSpecifiedNull;
            @property id idType;
            @property (weak) id<MyDelegate, MyDataSource> delegate;
            @property (nonnull) UITableView<UITableViewDataSource> *tableWithDataSource;
            @property (weak) UIView<UIDelegate> *weakViewWithDelegate;
            @property (assign, nonnull) MyClass *assignProp;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc var someField: Bool
                @objc var someOtherField: Int
                @objc var aRatherStringlyField: String
                @objc var specifiedNull: String?
                @objc var nonNullWithQualifier: String
                @objc var nonSpecifiedNull: String!
                @objc var idType: AnyObject!
                @objc weak var delegate: (MyDelegate & MyDataSource)?
                @objc var tableWithDataSource: UITableView & UITableViewDataSource
                @objc weak var weakViewWithDelegate: (UIView & UIDelegate)?
                @objc unowned(unsafe) var assignProp: MyClass
            }
            """)
    }
    
    func testRewriteNSArray() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property (nonnull) NSArray* nontypedArray;
            @property (nullable) NSArray* nontypedArrayNull;
            @property NSArray<NSString*>* stringArray;
            @property (nonnull) NSArray<SomeType*>* clsArray;
            @property (nullable) NSArray<SomeType*>* clsArrayNull;
            @property (nonnull) SomeType<SomeDelegate> *delegateable;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc var nontypedArray: NSArray
                @objc var nontypedArrayNull: NSArray?
                @objc var stringArray: [String]!
                @objc var clsArray: [SomeType]
                @objc var clsArrayNull: [SomeType]?
                @objc var delegateable: SomeType & SomeDelegate
            }
            """)
    }
    
    func testRewriteInstanceVariables() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            {
                NSString *_myString;
                __weak id _delegate;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _myString: String!
                private weak var _delegate: AnyObject?
            }
            """)
    }
    
    func testRewriteEmptyMethod() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (void)myMethod;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteEmptyClassMethod() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            + (void)myMethod;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                static func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteMethodSignatures() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (void)myMethod;
            - (NSInteger)myOtherMethod:(NSInteger)abc aString:(nonnull NSString*)str;
            - (NSInteger)myAnonParamMethod:(NSInteger)abc :(nonnull NSString*)str;
            - (nullable NSArray*)someNullArray;
            - (void):a;
            - :a;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                func myMethod() {
                }
                @objc
                func myOtherMethod(_ abc: Int, aString str: String) -> Int {
                }
                @objc
                func myAnonParamMethod(_ abc: Int, _ str: String) -> Int {
                }
                @objc
                func someNullArray() -> NSArray? {
                }
                @objc
                func __(_ a: AnyObject!) {
                }
                @objc
                func __(_ a: AnyObject!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriteInitMethods() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)init;
            - (instancetype)initWithThing:(id)thing;
            - (instancetype)initWithNumber:(nonnull NSNumber*)number;
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                override init() {
                }
                @objc
                init(with thing: AnyObject!) {
                }
                @objc
                init(with number: NSNumber) {
                }
            }
            """)
    }
    
    func testRewriteDeallocMethod() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)dealloc {
                thing()
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                deinit {
                    thing()
                }
            }
            """)
    }
    
    func testRewriteIVarsWithAccessControls() throws {
        try assertObjcParse(objc: """
            @interface MyClass
            {
                NSString *_myString;
            @package
                __weak id _delegate;
            @public
                NSInteger _myInt;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var _myString: String!
                weak var _delegate: AnyObject?
                public var _myInt: Int
            }
            """)
    }
    
    func testRewriteIVarBetweenAssumeNonNulls() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass
            {
                NSString *_myString;
            }
            @end
            NS_ASSUME_NONNULL_END
            """,
            swift: """
            class MyClass: NSObject {
                private var _myString: String
            }
            """)
    }
    
    func testRewriteInterfaceWithImplementation() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(id)thing;
            - (void)myMethod;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                [self thing];
            }
            - (void)myMethod {
                [self thing];
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                init(with thing: AnyObject!) {
                    self.thing()
                }
                @objc
                func myMethod() {
                    self.thing()
                }
            }
            """)
    }
    
    func testRewriteInterfaceWithCategoryWithImplementation() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(id)thing;
            - (void)myMethod;
            @end

            @interface MyClass () <MyDelegate>
            {
                /// Coments that are meant to be ignored.
                /// None of these should affect parsing
                NSInteger anIVar;
            }
            - (void)methodFromCategory;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                [self thing];
            }
            - (void)myMethod {
                [self thing];
            }
            @end
            """,
            swift: """
            class MyClass: NSObject, MyDelegate {
                private var anIVar: Int
                
                @objc
                init(with thing: AnyObject!) {
                    self.thing()
                }
                @objc
                func myMethod() {
                    self.thing()
                }
                @objc
                func methodFromCategory() {
                }
            }
            """)
    }
    
    func testWhenRewritingMethodsSignaturesWithNullabilityOverrideSignaturesWithout() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(nonnull id)thing;
            - (void)myMethod;
            @end
            
            @implementation MyClass
            - (instancetype)initWithThing:(id)thing {
                [self thing];
            }
            - (void)myMethod {
                [self thing];
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                init(with thing: AnyObject) {
                    self.thing()
                }
                @objc
                func myMethod() {
                    self.thing()
                }
            }
            """)
    }
    
    func testRewriteClassThatImplementsProtocolOverridesSignatureNullabilityOnImplementation() throws {
        try assertObjcParse(
            objc: """
            @protocol MyProtocol
            - (nonnull NSString*)myMethod:(nullable NSObject*)object;
            @end
            
            @interface MyClass : NSObject <MyProtocol>
            - (NSString*)myMethod:(NSObject*)object;
            @end
            """, swift: """
            @objc
            protocol MyProtocol {
                @objc
                func myMethod(_ object: NSObject?) -> String
            }
            
            class MyClass: NSObject, MyProtocol {
                @objc
                func myMethod(_ object: NSObject?) -> String {
                }
            }
            """)
    }
    
    func testRewriteGlobalVariableDeclaration() throws {
        try assertObjcParse(
            objc: """
            const NSInteger myGlobal;
            NSInteger myOtherGlobal;
            """,
            swift: """
            let myGlobal: Int
            var myOtherGlobal: Int
            """)
    }
    
    func testRewriteGlobalVariableDeclarationWithInitialValue() throws {
        try assertObjcParse(
            objc: """
            const CGFloat kMyConstantValue = 45;
            NSString *_Nonnull kMyNotConstantValue;
            """,
            swift: """
            let kMyConstantValue: CGFloat = 45
            var kMyNotConstantValue: String
            """)
    }
    
    func testRewriteBlockTypeDef() throws {
        try assertObjcParse(
            objc: """
            typedef void(^errorBlock)();
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteBlockParameters() throws {
        try assertObjcParse(
            objc: """
            @interface AClass
            - (void)aBlocky:(void(^)())blocky;
            - (void)aBlockyWithString:(void(^)(nonnull NSString*))blocky;
            @end
            """,
            swift: """
            class AClass: NSObject {
                @objc
                func aBlocky(_ blocky: () -> Void) {
                }
                @objc
                func aBlockyWithString(_ blocky: (String) -> Void) {
                }
            }
            """)
    }
    
    func testRewriteBlockIvars() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            {
                void(^_Nullable callback)();
                void(^anotherCallback)(NSString*_Nonnull);
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                private var callback: (() -> Void)?
                private var anotherCallback: (String) -> Void
            }
            """)
    }
    
    func testRewriterUsesNonnullMacrosForNullabilityInferring() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass1
            - (id)aMethod:(NSString*)param;
            @end
            NS_ASSUME_NONNULL_END
            @interface MyClass2
            - (id)aMethod:(NSString*)param;
            @end
            """,
            swift: """
            class MyClass1: NSObject {
                @objc
                func aMethod(_ param: String) -> AnyObject {
                }
            }
            class MyClass2: NSObject {
                @objc
                func aMethod(_ param: String!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriterMergesNonnullMacrosForNullabilityInferring() throws {
        try assertObjcParse(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            @interface MyClass
            - (id)aMethod:(NSString*)param;
            @end
            NS_ASSUME_NONNULL_END
            @implementation MyClass
            - (id)aMethod:(NSString*)param {
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                func aMethod(_ param: String) -> AnyObject {
                }
            }
            """)
    }
    
    func testRewriteStaticConstantValuesInClass() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            static NSString *const _Nonnull kMethodKey = @"method";
            static NSString *_Nonnull kCodeOperatorKey = @"codigo_operador";
            @end
            """,
            swift: """
            let kMethodKey: String = "method"
            var kCodeOperatorKey: String = "codigo_operador"

            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteSelectorExpression() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if([self respondsToSelector:@selector(abc:)]) {
                    thing();
                }
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    if self.respondsToSelector(Selector("abc:")) {
                        thing()
                    }
                }
            }
            """)
    }
    
    func testRewriteProtocol() throws {
        try assertObjcParse(
            objc: """
            @protocol MyProtocol
            - (void)myMethod;
            @end
            """,
            swift: """
            @objc
            protocol MyProtocol {
                @objc
                func myMethod()
            }
            """)
    }
    
    func testRewriteProtocolOptionalRequiredSections() throws {
        try assertObjcParse(
            objc: """
            @protocol MyProtocol
            - (void)f1;
            @optional
            - (void)f2;
            - (void)f3;
            @required
            - (void)f4;
            @end
            """, swift: """
            @objc
            protocol MyProtocol {
                @objc
                func f1()
                @objc
                optional func f2()
                @objc
                optional func f3()
                @objc
                func f4()
            }
            """)
    }
    
    func testConvertAssignProperty() throws {
        try assertObjcParse(
            objc: """
            __weak NSObject *aWeakGlobal;
            __weak NSInteger anIntGlobal;
            @interface MyClass
            @property (assign) AClass *aClass;
            @property (assign) NSInteger anInt;
            @property NSInteger aProperInt;
            @end
            """,
            swift: """
            weak var aWeakGlobal: NSObject?
            var anIntGlobal: Int

            class MyClass: NSObject {
                @objc unowned(unsafe) var aClass: AClass!
                @objc var anInt: Int
                @objc var aProperInt: Int
            }
            """).assertDiagnostics("""
            Warning: Variable 'anIntGlobal' specified as 'weak' but original type '__weak NSInteger' is not a pointer type. at line 0 column 0
            Warning: Property 'anInt' specified as 'unowned(unsafe)' but original type 'NSInteger' is not a pointer type. at line 0 column 0
            """)
    }
}
