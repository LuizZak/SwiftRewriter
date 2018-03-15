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
            @objc
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
            @objc
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
            @objc
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
            @objc
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
            @objc
            class MyClass: UIView, UITableViewDelegate {
            }
            """)
    }
    
    func testRewriteEnumDeclaration() throws {
        try assertObjcParse(
            objc: """
            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumCase1 = 0,
                MyEnumCase2
            };
            """,
            swift: """
            @objc enum MyEnum: Int {
                case MyEnumCase1 = 0
                case MyEnumCase2
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
            @objc
            class MyClass: NSObject {
                @objc weak var myClass: MyClass? = nil
            }
            """)
    }
    
    func testRewriteClassProperty() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            @property (class) MyClass *myClass;
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc static var myClass: MyClass! = nil
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
            @objc
            class MyClass: NSObject {
                @objc var someField: Bool = false
                @objc var someOtherField: Int = 0
                @objc var aRatherStringlyField: String
                @objc var specifiedNull: String? = nil
                @objc var nonNullWithQualifier: String
                @objc var nonSpecifiedNull: String! = nil
                @objc var idType: AnyObject! = nil
                @objc weak var delegate: (MyDelegate & MyDataSource)? = nil
                @objc var tableWithDataSource: UITableView & UITableViewDataSource
                @objc weak var weakViewWithDelegate: (UIView & UIDelegate)? = nil
                @objc unowned(unsafe) var assignProp: MyClass
            }
            """)
    }
    
    func testRewriteNSArray() throws {
        try assertObjcParse(
            objc: """
            @interface SomeType : NSObject
            @end
            
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
            @objc
            class SomeType: NSObject {
            }
            @objc
            class MyClass: NSObject {
                @objc var nontypedArray: NSArray
                @objc var nontypedArrayNull: NSArray? = nil
                @objc var stringArray: [String]! = nil
                @objc var clsArray: [SomeType]
                @objc var clsArrayNull: [SomeType]? = nil
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
            @objc
            class MyClass: NSObject {
                private var _myString: String! = nil
                private weak var _delegate: AnyObject? = nil
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
            @objc
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
            @objc
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
            @objc
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
            @objc
            class MyClass: NSObject {
                @objc
                override init() {
                }
                @objc
                init(thing: AnyObject!) {
                }
                @objc
                init(number: NSNumber) {
                }
            }
            """)
    }
    
    func testRewriteDeallocMethod() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)dealloc {
                thing();
            }
            @end
            """,
            swift: """
            @objc
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
            @objc
            class MyClass: NSObject {
                private var _myString: String! = nil
                weak var _delegate: AnyObject? = nil
                public var _myInt: Int = 0
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
            @objc
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
            @objc
            class MyClass: NSObject {
                @objc
                init(thing: AnyObject!) {
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
            @objc
            class MyClass: NSObject {
                private var anIVar: Int = 0
                
                @objc
                init(thing: AnyObject!) {
                    self.thing()
                }
                @objc
                func myMethod() {
                    self.thing()
                }
            }
            
            // MARK: -
            @objc
            extension MyClass: MyDelegate {
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
            @objc
            class MyClass: NSObject {
                @objc
                init(thing: AnyObject) {
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
            protocol MyProtocol: NSObjectProtocol {
                @objc
                func myMethod(_ object: NSObject?) -> String
            }
            
            @objc
            class MyClass: NSObject, MyProtocol {
                @objc
                func myMethod(_ object: NSObject?) -> String {
                }
            }
            """)
    }
    
    func testRewriteInterfaceWithImplementationPerformsSelectorMatchingIgnoringArgumentNames() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (void)myMethod:(BOOL)aParam;
            @end
            
            @implementation MyClass
            - (void)myMethod:(BOOL)aParamy {
                thing();
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod(_ aParamy: Bool) {
                    thing()
                }
            }
            """)
    }
    
    func testRewriteSignatureContainingWithKeyword() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)doSomethingWithColor:(CGColor)color {
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func doSomething(with color: CGColor) {
                }
            }
            """)
    }
    
    func testRewriteGlobalVariableDeclaration() throws {
        try assertObjcParse(
            objc: """
            const NSInteger myGlobal;
            NSInteger myOtherGlobal;
            NSInteger const myThirdGlobal;
            """,
            swift: """
            let myGlobal: Int
            var myOtherGlobal: Int
            let myThirdGlobal: Int
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
            typedef void(^_Nonnull errorBlock)();
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteManyTypeliasSequentially() throws {
        try assertObjcParse(
            objc: """
            typedef NSInteger MyInteger;
            typedef NSInteger OtherInt;
            """,
            swift: """
            typealias MyInteger = Int
            typealias OtherInt = Int
            """)
    }
    
    func testRewriteBlockParameters() throws {
        try assertObjcParse(
            objc: """
            @interface AClass
            - (void)aBlocky:(void(^)())blocky;
            - (void)aBlockyWithString:(void(^_Nonnull)(nonnull NSString*))blocky;
            @end
            """,
            swift: """
            @objc
            class AClass: NSObject {
                @objc
                func aBlocky(_ blocky: (() -> Void)!) {
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
                void(^_Nonnull callback)(NSObject*o);
                void(^anotherCallback)(NSString*_Nonnull);
                NSObject*_Nullable(^_Nullable yetAnotherCallback)(NSString*_Nonnull);
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                private var callback: (NSObject!) -> Void
                private var anotherCallback: ((String) -> Void)! = nil
                private var yetAnotherCallback: ((String) -> NSObject?)? = nil
            }
            """)
    }
    
    func testRewriteBlockWithinBlocksIvars() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            {
                void(^callback)(id(^_Nullable)());
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                private var callback: (((() -> AnyObject!)?) -> Void)! = nil
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
            @objc
            class MyClass1: NSObject {
                @objc
                func aMethod(_ param: String) -> AnyObject {
                }
            }
            @objc
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
            @objc
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
            
            @objc
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    if self.responds(to: Selector("abc:")) {
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
            protocol MyProtocol: NSObjectProtocol {
                @objc
                func myMethod()
            }
            """)
    }
    
    func testRewriteProtocolConformance() throws {
        try assertObjcParse(
            objc: """
            @protocol MyProtocol
            @optional
            - (void)myMethod;  // Result should not contain this optional method...
            - (void)myMethod2; // ...but should contain this one, which is implemented
                               // by the conforming class.
            @end
            @interface A : NSObject <MyProtocol>
            - (void)myMethod2;
            @end
            """,
            swift: """
            @objc
            protocol MyProtocol: NSObjectProtocol {
                @objc
                optional func myMethod()
                @objc
                optional func myMethod2()
            }

            @objc
            class A: NSObject, MyProtocol {
                @objc
                func myMethod2() {
                }
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
            protocol MyProtocol: NSObjectProtocol {
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
    
    func testRewriteProtocolPropertiesWithGetSetSpecifiers() throws {
        try assertObjcParse(
            objc: """
            @protocol MyProtocol
            @property BOOL value1;
            @property (readonly) BOOL value2;
            @end
            """, swift: """
            @objc
            protocol MyProtocol: NSObjectProtocol {
                @objc var value1: Bool { get set }
                @objc var value2: Bool { get }
            }
            """)
    }
    
    func testConvertAssignProperty() throws {
        try assertObjcParse(
            objc: """
            @interface AClass : NSObject
            @end
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
            
            @objc
            class AClass: NSObject {
            }
            @objc
            class MyClass: NSObject {
                @objc unowned(unsafe) var aClass: AClass! = nil
                @objc var anInt: Int = 0
                @objc var aProperInt: Int = 0
            }
            """)
    }
    
    func testKeepPreprocessorDirectives() throws {
        try assertObjcParse(
            objc: """
            #import "File.h"
            #import <File.h>
            #if 0
            #endif
            #define MACRO 123
            """,
            swift: """
            import File
            // Preprocessor directives found in file:
            // #import "File.h"
            // #import <File.h>
            // #if 0
            // #endif
            // #define MACRO 123
            """)
    }
    
    func testIfFalseDirectivesHideCodeWithin() throws {
        try assertObjcParse(
            objc: """
            #if 0
            @interface MyClass
            @end
            #endif
            """,
            swift: """
            // Preprocessor directives found in file:
            // #if 0
            // #endif
            """)
    }
    
    func testPostfixAfterCastOnSubscriptionUsesOptionalPostfix() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)method {
                ((NSString*)aValue)[123];
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func method() {
                    (aValue as? String)?[123]
                }
            }
            """)
    }
    
    func testPostfixAfterCastUsesOptionalPostfix() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)method {
                [(NSString*)aValue someMethod];
                ((NSString*)aValue).property;
                ((NSString*)aValue)[123];
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func method() {
                    (aValue as? String)?.someMethod()
                    (aValue as? String)?.property
                    (aValue as? String)?[123]
                }
            }
            """)
    }
    
    func testParseGenericsWithinGenerics() throws {
        try assertObjcParse(
            objc: """
            @interface B: NSObject
            @end
            @interface A: NSObject
            {
                RACSubject<NSArray<B*>*> *_u;
            }
            @end
            """,
            swift: """
            @objc
            class B: NSObject {
            }
            @objc
            class A: NSObject {
                private var _u: RACSubject<[B]>! = nil
            }
            """)
    }
    
    func testRewriteStructTypedefs() throws {
        try assertObjcParse(
            objc: """
            typedef struct {
                vector_float3 position;
                packed_float4 color;
                int offset;
            } VertexObject;
            """
            , swift: """
            struct VertexObject {
                var position: vector_float3
                var color: packed_float4
                var offset: CInt
                
                init() {
                    position = vector_float3()
                    color = packed_float4()
                    offset = 0
                }
                init(position: vector_float3, color: packed_float4, offset: CInt) {
                    self.position = position
                    self.color = color
                    self.offset = offset
                }
            }
            """)
    }
    
    func testRewriterPointerToStructTypeDef() throws {
        try assertObjcParse(
            objc: """
            typedef struct {
                vector_float3 position;
                packed_float4 color;
            } VertexObject;

            VertexObject *vertedObject;
            """
            , swift: """
            struct VertexObject {
                var position: vector_float3
                var color: packed_float4
                
                init() {
                    position = vector_float3()
                    color = packed_float4()
                }
                init(position: vector_float3, color: packed_float4) {
                    self.position = position
                    self.color = color
                }
            }

            var vertedObject: UnsafeMutablePointer<VertexObject>!
            """)
    }
    
    func testRewriteAliasedTypedefStruct() throws {
        try assertObjcParse(
            objc: """
            typedef struct a {
                int b;
            } c;
            """,
            swift: """
            typealias c = a
            
            struct a {
                var b: CInt
                
                init() {
                    b = 0
                }
                init(b: CInt) {
                    self.b = b
                }
            }
            """)
    }
    
    func testRewriteAliasedTypedefStructWithPointers() throws {
        try assertObjcParse(
            objc: """
            typedef struct a {
                int b;
            } *c;
            """,
            swift: """
            typealias c = UnsafeMutablePointer<a>
            
            struct a {
                var b: CInt
                
                init() {
                    b = 0
                }
                init(b: CInt) {
                    self.b = b
                }
            }
            """)
    }
    
    func testRewriteFuncDeclaration() throws {
        try assertObjcParse(
            objc: """
            void global();
            """,
            swift: """
            func global() {
            }
            """)
    }
    
    func testLazyTypeResolveFuncDeclaration() throws {
        try assertObjcParse(
            objc: """
            A* global();
            
            @interface A
            @end
            """,
            swift: """
            func global() -> A! {
            }
            
            @objc
            class A: NSObject {
            }
            """)
    }
    
    func testAddNullCoallesceToCompletionBlockInvocationsDeepIntoBlockExpressions() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (void)finishRequested:(void (^)())completion
            {
                [super finishRequested:^{
                    [_updateLink invalidate];
             
                    [_rootController hideContentController:_logViewController
                                                 animation:ViewControllerAnimationNone
                                                completion:^(BOOL success) {
                                                    completion();
                                                }];
                }];
            }
            @end
            """, swift: """
            @objc
            class A: NSObject {
                @objc
                override func finishRequested(_ completion: (() -> Void)!) {
                    super.finishRequested { () -> Void in
                        _updateLink.invalidate()
                        _rootController.hideContentController(_logViewController, animation: ViewControllerAnimationNone) { (success: Bool) -> Void in
                            completion?()
                        }
                    }
                }
            }
            """)
    }
    
    func testApplyNilCoallesceInDeeplyNestedExpressionsProperly() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (void)loadDataWithCallback:(void(^)(NSArray *data, NSError *error))callback
            {
                [self doThing].then(^(NSArray *results){
                    callback(results, nil);
                }).catch(^(NSError *error){
                    callback(nil, error);
                }).always(^{
                    lastSync = CFAbsoluteTimeGetCurrent();
                });
            }
            @end
            """, swift: """
            @objc
            class A: NSObject {
                @objc
                func loadDataWithCallback(_ callback: ((NSArray!, Error!) -> Void)!) {
                    self.doThing().then { (results: NSArray!) -> Void in
                        callback?(results, nil)
                    }.catch { (error: Error!) -> Void in
                        callback?(nil, error)
                    }.always { () -> Void in
                        lastSync = CFAbsoluteTimeGetCurrent()
                    }
                }
            }
            """)
    }
    
    /// Regression test for a very shameful oversight related to ordering the parser
    /// read the statements and variable declarations within a compound statement.
    func testParsingKeepsOrderingOfStatementsAndDeclarations() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (void)recreatePath
            {
                CGFloat top = startsAtTop ? 0 : circle.center.y;
                CGFloat bottom = MAX(self.bounds.size.height, top);
                
                if(top == bottom)
                {
                    shapeLayer.path = nil;
                    return;
                }
                
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, nil, 0, top);
                CGPathAddLineToPoint(path, nil, 0, bottom);
                
                shapeLayer.strokeColor = self.dateLabel.textColor.CGColor;
                shapeLayer.lineWidth = 1;
                shapeLayer.lineCap = kCALineCapSquare;
                shapeLayer.lineJoin = kCALineJoinRound;
                
                if (dashType == CPTimeSeparatorDash_Dash)
                {
                    shapeLayer.lineDashPattern = @[@3, @5];
                }
                else
                {
                    shapeLayer.lineDashPattern = nil;
                }
                
                shapeLayer.path = path;
                
                CGPathRelease(path);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc
                func recreatePath() {
                    var top = startsAtTop ? 0 : circle.center.y
                    var bottom = max(self.bounds.size.height, top)
                    if top == bottom {
                        shapeLayer.path = nil
                        return
                    }
                    var path = CGMutablePath()
                    path.move(to: CGPoint(x: 0, y: top))
                    path.addLine(to: CGPoint(x: 0, y: bottom))
                    shapeLayer.strokeColor = self.dateLabel.textColor.CGColor
                    shapeLayer.lineWidth = 1
                    shapeLayer.lineCap = kCALineCapSquare
                    shapeLayer.lineJoin = kCALineJoinRound
                    if dashType == CPTimeSeparatorDash_Dash {
                        shapeLayer.lineDashPattern = [3, 5]
                    } else {
                        shapeLayer.lineDashPattern = nil
                    }
                    shapeLayer.path = path
                }
            }
            """)
    }
    
    func testEnumAccessRewriting() throws {
        try assertObjcParse(
            objc: """
            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumCase
            };
            @implementation A
            - (void)method {
                (MyEnumCase);
            }
            @end
            """,
            swift: """
            @objc enum MyEnum: Int {
                case MyEnumCase
            }

            @objc
            class A: NSObject {
                @objc
                func method() {
                    (MyEnum.MyEnumCase)
                }
            }
            """)
    }
    
    func testAppliesTypenameConversionToCategories() throws {
        try assertObjcParse(
            objc: """
            @interface NSString (Extension)
            @end
            @implementation NSDate (Extension)
            @end
            """,
            swift: """
            // MARK: - Extension
            @objc
            extension String {
            }
            // MARK: - Extension
            @objc
            extension Date {
            }
            """)
    }
    
    /// Make sure scalar stored properties always initialize with zero, so the
    /// class mimics more closely the behavior of the original Objective-C class
    /// (which initializes all fields to zero on `init`)
    func testScalarTypeStoredPropertiesAlwaysInitializeAtZero() throws {
        try assertObjcParse(
            objc: """
            typedef NS_ENUM(NSInteger, E) {
                E_1
            };
            @interface A
            {
                BOOL _a;
                NSInteger _b;
                NSUInteger _c;
                float _d;
                double _e;
                CGFloat _e;
                NSString *_f;
                E _g;
                NSString *_Nonnull _h;
            }
            @property BOOL a;
            @property NSInteger b;
            @property NSUInteger c;
            @property float d;
            @property double e;
            @property CGFloat e;
            @property NSString *f;
            @property E g;
            @property (nonnull) NSString *h;
            @end
            """,
            swift: """
            @objc enum E: Int {
                case E_1
            }

            @objc
            class A: NSObject {
                private var _a: Bool = false
                private var _b: Int = 0
                private var _c: UInt = 0
                private var _d: CFloat = 0.0
                private var _e: CDouble = 0.0
                private var _e: CGFloat = 0.0
                private var _f: String! = nil
                private var _g: E
                private var _h: String
                @objc var a: Bool = false
                @objc var b: Int = 0
                @objc var c: UInt = 0
                @objc var d: CFloat = 0.0
                @objc var e: CDouble = 0.0
                @objc var e: CGFloat = 0.0
                @objc var f: String! = nil
                @objc var g: E
                @objc var h: String
            }
            """)
    }
    
    func testRewritesNew() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (void)method {
                [A new];
                A.new;
            }
            + (void)method2 {
                [self new];
                self.new;
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc
                func method() {
                    A()
                    A()
                }
                @objc
                static func method2() {
                    self.init()
                    self.init()
                }
            }
            """)
    }
    
    func testOmitObjcAttribute() throws {
        try assertObjcParse(
            objc: """
            typedef NS_ENUM(NSInteger, Enum) {
                Enum_A
            };
            
            @protocol A
            @property BOOL b;
            - (void)method;
            @end
            
            @interface B: A
            @property BOOL b;
            @end
            
            @implementation B
            - (void)method {
            }
            @end
            """,
            swift: """
            enum Enum: Int {
                case Enum_A
            }
            
            protocol A {
                var b: Bool { get set }
                
                func method()
            }
            
            class B: A {
                var b: Bool = false
                
                func method() {
                }
            }
            """,
            options: ASTWriterOptions(omitObjcCompatibility: true))
    }
    
    /// Tests calls that override a super call by detection of a `super` call on
    /// a super method with the same signature as the method being analyzed.
    func testMarkOverrideIfSuperCallIsDetected() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (instancetype)initWithThing:(A*)thing {
                [super initWithThing:thing];
            }
            - (instancetype)initWithOtherThing:(A*)thing {
                [super initWithThing:thing];
            }
            - (void)a {
                [super a];
            }
            - (void)b:(NSInteger)a {
                [super b:a];
            }
            - (void)c:(NSInteger)a {
                [super c]; // Make sure we don't create unnecessary overrides
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc
                override init(thing: A!) {
                    super.init(thing: thing)
                }
                @objc
                init(otherThing thing: A!) {
                    super.init(thing: thing)
                }
                @objc
                override func a() {
                    super.a()
                }
                @objc
                override func b(_ a: Int) {
                    super.b(a)
                }
                @objc
                func c(_ a: Int) {
                    super.c()
                }
            }
            """)
    }

    func testCorrectsNullabilityOfMethodParameters() throws {
        try assertObjcParse(
            objc: """
            @interface A
            @property (nullable) A *a;
            @property NSInteger b;
            - (void)takesInt:(NSInteger)a;
            - (NSInteger)returnsInt;
            @end
            @implementation A
            - (void)method {
                [self takesInt:a.b];
                [self takesInt:[a returnsInt]];
                [self takesInt:a.b + 0];
                [self takesInt:[a returnsInt] + 0];
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc var a: A? = nil
                @objc var b: Int = 0
                
                @objc
                func method() {
                    self.takesInt((a?.b ?? 0))
                    self.takesInt((a?.returnsInt() ?? 0))
                    self.takesInt((a?.b ?? 0) + 0)
                    self.takesInt((a?.returnsInt() ?? 0) + 0)
                }
                @objc
                func takesInt(_ a: Int) {
                }
                @objc
                func returnsInt() -> Int {
                }
            }
            """)
    }
    
    func testOptionalCoallesceNullableStructAccess() throws {
        try assertObjcParse(
            objc: """
            typedef struct {
                int a;
            } A;
            
            @implementation B
            - (A)a {
            }
            - (void)takesA:(A)a {
            }
            - (void)method {
                B *_Nullable b;
                
                [self takesA:[b a]];
            }
            @end
            """,
            swift: """
            struct A {
                var a: CInt
                
                init() {
                    a = 0
                }
                init(a: CInt) {
                    self.a = a
                }
            }

            @objc
            class B: NSObject {
                @objc
                func a() -> A {
                }
                @objc
                func takesA(_ a: A) {
                }
                @objc
                func method() {
                    var b: B?
                    self.takesA(b.a())
                }
            }
            """)
    }
}
