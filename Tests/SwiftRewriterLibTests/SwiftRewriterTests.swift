import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
    func testParseNonnullMacros() {
        assertRewrite(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            NS_ASSUME_NONNULL_END
            """,
            swift: """
            """)
    }
    
    func testRewriteEmptyClass() {
        assertRewrite(
            objc: """
            @interface MyClass: NSObject
            @end
            """,
            swift: """
            class MyClass: NSObject {
            }
            """)
    }
    
    func testRewriteInfersNSObjectSuperclass() {
        assertRewrite(
            objc: """
            @interface MyClass
            @end
            """,
            swift: """
            class MyClass {
            }
            """)
    }
    
    func testRewriteInheritance() {
        assertRewrite(
            objc: """
            @interface MyClass : UIView
            @end
            """,
            swift: """
            class MyClass: UIView {
            }
            """)
    }
    
    func testRewriteSubclassInInterface() {
        assertRewrite(
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
    
    func testRewriteProtocolSpecification() {
        assertRewrite(
            objc: """
            @interface MyClass : UIView <UITableViewDelegate>
            @end
            """,
            swift: """
            class MyClass: UIView, UITableViewDelegate {
            }
            """)
    }
    
    func testRewriteEnumDeclaration() {
        assertRewrite(
            objc: """
            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumCase1 = 0,
                MyEnumCase2
            };
            """,
            swift: """
            enum MyEnum: Int {
                case MyEnumCase1 = 0
                case MyEnumCase2
            }
            """)
    }
    
    func testRewriteWeakProperty() {
        assertRewrite(
            objc: """
            @interface MyClass
            @property (weak) MyClass *myClass;
            @end
            """,
            swift: """
            class MyClass {
                weak var myClass: MyClass?
            }
            """)
    }
    
    func testRewriteClassProperty() {
        assertRewrite(
            objc: """
            @interface MyClass
            @property (class) MyClass *myClass;
            @end
            """,
            swift: """
            class MyClass {
                static var myClass: MyClass!
            }
            """)
    }
    
    func testRewriteClassProperties() {
        assertRewrite(
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
            class MyClass {
                var someField: Bool = false
                var someOtherField: Int = 0
                var aRatherStringlyField: String
                var specifiedNull: String?
                var nonNullWithQualifier: String
                var nonSpecifiedNull: String!
                var idType: AnyObject!
                weak var delegate: (MyDelegate & MyDataSource)?
                var tableWithDataSource: UITableView & UITableViewDataSource
                weak var weakViewWithDelegate: (UIView & UIDelegate)?
                unowned(unsafe) var assignProp: MyClass
            }
            """)
    }
    
    func testRewriteNSArray() {
        assertRewrite(
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
            class SomeType: NSObject {
            }
            class MyClass {
                var nontypedArray: NSArray
                var nontypedArrayNull: NSArray?
                var stringArray: [String]!
                var clsArray: [SomeType]
                var clsArrayNull: [SomeType]?
                var delegateable: SomeType & SomeDelegate
            }
            """)
    }
    
    func testRewriteInstanceVariables() {
        assertRewrite(
            objc: """
            @interface MyClass
            {
                NSString *_myString;
                __weak id _delegate;
            }
            @end
            """,
            swift: """
            class MyClass {
                private var _myString: String!
                private weak var _delegate: AnyObject?
            }
            """)
    }
    
    func testRewriteEmptyMethod() {
        assertRewrite(
            objc: """
            @interface MyClass
            - (void)myMethod;
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteEmptyClassMethod() {
        assertRewrite(
            objc: """
            @interface MyClass
            + (void)myMethod;
            @end
            """,
            swift: """
            class MyClass {
                static func myMethod() {
                }
            }
            """)
    }
    
    func testRewriteMethodSignatures() {
        assertRewrite(
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
            class MyClass {
                func myMethod() {
                }
                func myOtherMethod(_ abc: Int, aString str: String) -> Int {
                }
                func myAnonParamMethod(_ abc: Int, _ str: String) -> Int {
                }
                func someNullArray() -> NSArray? {
                }
                func __(_ a: AnyObject!) {
                }
                func __(_ a: AnyObject!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriteInitMethods() {
        assertRewrite(
            objc: """
            @interface MyClass
            - (instancetype)init;
            - (instancetype)initWithThing:(id)thing;
            - (instancetype)initWithNumber:(nonnull NSNumber*)number;
            @end
            """,
            swift: """
            class MyClass {
                override init() {
                }
                init(thing: AnyObject!) {
                }
                init(number: NSNumber) {
                }
            }
            """)
    }
    
    func testRewriteDeallocMethod() {
        assertRewrite(
            objc: """
            @implementation MyClass
            - (void)dealloc {
                thing();
            }
            @end
            """,
            swift: """
            class MyClass {
                deinit {
                    thing()
                }
            }
            """)
    }
    
    func testRewriteIVarsWithAccessControls() {
        assertRewrite(objc: """
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
            class MyClass {
                private var _myString: String!
                weak var _delegate: AnyObject?
                public var _myInt: Int = 0
            }
            """)
    }
    
    func testRewriteIVarBetweenAssumeNonNulls() {
        assertRewrite(
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
            class MyClass {
                private var _myString: String
            }
            """)
    }
    
    func testRewriteInterfaceWithImplementation() {
        assertRewrite(
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
            class MyClass {
                init(thing: AnyObject!) {
                    self.thing()
                }

                func myMethod() {
                    self.thing()
                }
            }
            """)
    }
    
    func testRewriteInterfaceWithCategoryWithImplementation() {
        assertRewrite(
            objc: """
            @interface MyClass
            - (instancetype)initWithThing:(id)thing;
            - (void)myMethod;
            @end

            @interface MyClass () <MyDelegate>
            {
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
            class MyClass {
                private var anIVar: Int = 0

                init(thing: AnyObject!) {
                    self.thing()
                }

                func myMethod() {
                    self.thing()
                }
            }
            
            // MARK: -
            extension MyClass: MyDelegate {
                func methodFromCategory() {
                }
            }
            """)
    }
    
    func testWhenRewritingMethodsSignaturesWithNullabilityOverrideSignaturesWithout() {
        assertRewrite(
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
            class MyClass {
                init(thing: AnyObject) {
                    self.thing()
                }

                func myMethod() {
                    self.thing()
                }
            }
            """)
    }
    
    func testRewriteClassThatImplementsProtocolOverridesSignatureNullabilityOnImplementation() {
        assertRewrite(
            objc: """
            @protocol MyProtocol
            - (nonnull NSString*)myMethod:(nullable NSObject*)object;
            @end
            
            @interface MyClass : NSObject <MyProtocol>
            - (NSString*)myMethod:(NSObject*)object;
            @end
            """, swift: """
            protocol MyProtocol {
                func myMethod(_ object: NSObject?) -> String
            }
            
            class MyClass: NSObject, MyProtocol {
                func myMethod(_ object: NSObject?) -> String {
                }
            }
            """)
    }
    
    func testRewriteInterfaceWithImplementationPerformsSelectorMatchingIgnoringArgumentNames() {
        assertRewrite(
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
            class MyClass {
                func myMethod(_ aParamy: Bool) {
                    thing()
                }
            }
            """)
    }
    
    func testRewriteSignatureContainingWithKeyword() {
        assertRewrite(
            objc: """
            @implementation MyClass
            - (void)doSomethingWithColor:(CGColor)color {
            }
            @end
            """,
            swift: """
            class MyClass {
                func doSomething(with color: CGColor) {
                }
            }
            """)
    }
    
    func testRewriteGlobalVariableDeclaration() {
        assertRewrite(
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
    
    func testRewriteGlobalVariableDeclarationWithInitialValue() {
        assertRewrite(
            objc: """
            const CGFloat kMyConstantValue = 45;
            NSString *_Nonnull kMyNotConstantValue;
            """,
            swift: """
            let kMyConstantValue: CGFloat = 45
            var kMyNotConstantValue: String
            """)
    }
    
    func testRewriteBlockTypeDef() {
        assertRewrite(
            objc: """
            typedef void(^errorBlock)();
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteBlockTypeDefWithVoidParameterList() {
        assertRewrite(
            objc: """
            typedef void(^errorBlock)(void);
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteCFunctionPointerTypeDef() {
        assertRewrite(
            objc: """
            typedef int (*cmpfn234)(void *, void *);
            typedef int (*cmpfn234_3)(void (^)(), void *);
            """,
            swift: """
            typealias cmpfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> CInt
            typealias cmpfn234_3 = @convention(c) ((() -> Void)?, UnsafeMutableRawPointer?) -> CInt
            """)
    }
    
    func testRewriteCFunctionWithCFunctionParameter() {
        assertRewrite(
            objc: """
            typedef int (*cmpfn234_2)(void (*)(), void *);
            """,
            swift: """
            typealias cmpfn234_2 = @convention(c) ((@convention(c) () -> Void)?, UnsafeMutableRawPointer?) -> CInt
            """)
    }
    
    func testRewriteLocalFunctionPointerDeclaration() {
        assertRewrite(
            objc: """
            void test() {
                void (*msgSend)(struct objc_super *, SEL) = ^{
                };
            }
            """,
            swift: """
            func test() {
                let msgSend: @convention(c) (UnsafeMutablePointer<structobjc_super>?, SEL) -> Void = { () -> Void in
                }
            }
            """)
    }
    
    func testNSAssumeNonnullContextCollectionWorksWithCompilerDirectivesInFile() {
        assertRewrite(
            objc: """
            //
            // Text for padding
            #import "A.h"
            #import "B.h"
            NS_ASSUME_NONNULL_BEGIN
            typedef void(^errorBlock)(NSString *param);
            NS_ASSUME_NONNULL_END
            """,
            swift: """
            // Preprocessor directives found in file:
            // #import "A.h"
            // #import "B.h"
            typealias errorBlock = (String) -> Void
            """)
    }
    
    func testBlockTypeDefinitionsDefaultToOptionalReferenceTypes() {
        assertRewrite(
            objc: """
            typedef void(^takesPointer)(int*);
            typedef void(^takesObject)(NSObject*);
            typedef int*(^returnsPointer)(void);
            typedef NSObject*(^returnsObject)(void);
            typedef void(^takesBlock)(void(^takesObject)(NSObject*));
            """,
            swift: """
            typealias takesPointer = (UnsafeMutablePointer<CInt>?) -> Void
            typealias takesObject = (NSObject?) -> Void
            typealias returnsPointer = () -> UnsafeMutablePointer<CInt>?
            typealias returnsObject = () -> NSObject?
            typealias takesBlock = (((NSObject?) -> Void)?) -> Void
            """)
    }
    
    func testRewriteManyTypeliasSequentially() {
        assertRewrite(
            objc: """
            typedef NSInteger MyInteger;
            typedef NSInteger OtherInt;
            """,
            swift: """
            typealias MyInteger = Int
            typealias OtherInt = Int
            """)
    }
    
    func testRewriteBlockParameters() {
        assertRewrite(
            objc: """
            @interface AClass
            - (void)aBlocky:(void(^)())blocky;
            - (void)aBlockyWithString:(void(^_Nonnull)(nonnull NSString*))blocky;
            @end
            """,
            swift: """
            class AClass {
                func aBlocky(_ blocky: (() -> Void)!) {
                }
                func aBlockyWithString(_ blocky: (String) -> Void) {
                }
            }
            """)
    }
    
    func testRewriteBlockIvars() {
        assertRewrite(
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
            class MyClass {
                private var callback: (NSObject?) -> Void
                private var anotherCallback: ((String) -> Void)!
                private var yetAnotherCallback: ((String) -> NSObject?)?
            }
            """)
    }
    
    func testRewriteBlockWithinBlocksIvars() {
        assertRewrite(
            objc: """
            @interface MyClass
            {
                void(^callback)(id(^_Nullable)());
            }
            @end
            """,
            swift: """
            class MyClass {
                private var callback: (((() -> AnyObject?)?) -> Void)!
            }
            """)
    }
    
    func testRewriterUsesNonnullMacrosForNullabilityInferring() {
        assertRewrite(
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
            class MyClass1 {
                func aMethod(_ param: String) -> AnyObject {
                }
            }
            class MyClass2 {
                func aMethod(_ param: String!) -> AnyObject! {
                }
            }
            """)
    }
    
    func testRewriterMergesNonnullMacrosForNullabilityInferring() {
        assertRewrite(
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
            class MyClass {
                func aMethod(_ param: String) -> AnyObject {
                }
            }
            """)
    }
    
    func testRewriteStaticConstantValuesInClass() {
        assertRewrite(
            objc: """
            @interface MyClass
            static NSString *const _Nonnull kMethodKey = @"method";
            static NSString *_Nonnull kCodeOperatorKey = @"codigo_operador";
            @end
            """,
            swift: """
            let kMethodKey: String = "method"
            var kCodeOperatorKey: String = "codigo_operador"
            
            class MyClass {
            }
            """)
    }
    
    func testRewriteSelectorExpression() {
        assertRewrite(
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
            class MyClass {
                func myMethod() {
                    if self.responds(to: Selector("abc:")) {
                        thing()
                    }
                }
            }
            """)
    }
    
    func testRewriteProtocol() {
        assertRewrite(
            objc: """
            @protocol MyProtocol
            - (void)myMethod;
            @end
            """,
            swift: """
            protocol MyProtocol {
                func myMethod()
            }
            """)
    }
    
    func testDontOmitObjcAttributeOnNSObjectProtocolInheritingProtocols() {
        assertRewrite(
            objc: """
            @protocol MyProtocol <NSObject>
            - (void)myMethod;
            @end
            """,
            swift: """
            @objc
            protocol MyProtocol: NSObjectProtocol {
                @objc
                func myMethod()
            }
            """,
            options: SwiftSyntaxOptions.default.with(\.emitObjcCompatibility, true))
    }
    
    func testRewriteProtocolConformance() {
        assertRewrite(
            objc: """
            @protocol MyProtocol
            @optional
            // Result should not contain this optional method...
            - (void)myMethod;
            // ...but should contain this one, which is implemented
            // by the conforming class.
            - (void)myMethod2;
            @end
            @interface A : NSObject <MyProtocol>
            - (void)myMethod2;
            @end
            """,
            swift: """
            @objc
            protocol MyProtocol: NSObjectProtocol {
                // Result should not contain this optional method...
                @objc
                optional func myMethod()
                // ...but should contain this one, which is implemented
                // by the conforming class.
                @objc
                optional func myMethod2()
            }

            class A: NSObject, MyProtocol {
                func myMethod2() {
                }
            }
            """)
    }
    
    func testRewriteProtocolOptionalRequiredSections() {
        assertRewrite(
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
                func f1()
                @objc
                optional func f2()
                @objc
                optional func f3()
                func f4()
            }
            """)
    }
    
    func testRewriteProtocolPropertiesWithGetSetSpecifiers() {
        assertRewrite(
            objc: """
            @protocol MyProtocol
            @property BOOL value1;
            @property (readonly) BOOL value2;
            @end
            """, swift: """
            protocol MyProtocol {
                var value1: Bool { get set }
                var value2: Bool { get }
            }
            """)
    }
    
    func testConvertAssignProperty() {
        assertRewrite(
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
            
            class AClass: NSObject {
            }
            class MyClass {
                unowned(unsafe) var aClass: AClass!
                var anInt: Int = 0
                var aProperInt: Int = 0
            }
            """)
    }
    
    func testKeepPreprocessorDirectives() {
        assertRewrite(
            objc: """
            #import "File.h"
            #import <File.h>
            #if 0
            #endif
            #define MACRO(A) 123 * A
            """,
            swift: """
            import File

            // Preprocessor directives found in file:
            // #import "File.h"
            // #import <File.h>
            // #if 0
            // #endif
            // #define MACRO(A) 123 * A
            """)
    }
    
    func testIfFalseDirectivesHideCodeWithin() {
        assertRewrite(
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
    
    func testPostfixAfterCastOnSubscriptionUsesOptionalPostfix() {
        assertRewrite(
            objc: """
            @implementation MyClass
            - (void)method {
                NSObject *aValue;
                ((NSString*)aValue)[123];
            }
            @end
            """,
            swift: """
            class MyClass {
                func method() {
                    let aValue: NSObject!

                    (aValue as? String)?[123]
                }
            }
            """)
    }
    
    func testPostfixAfterCastUsesOptionalPostfix() {
        assertRewrite(
            objc: """
            @implementation MyClass
            - (void)method {
                NSObject *aValue;
                [(NSString*)aValue someMethod];
                ((NSString*)aValue).property;
                ((NSString*)aValue)[123];
            }
            @end
            """,
            swift: """
            class MyClass {
                func method() {
                    let aValue: NSObject!

                    (aValue as? String)?.someMethod()
                    (aValue as? String)?.property
                    (aValue as? String)?[123]
                }
            }
            """)
    }
    
    func testRewriteGenericsWithinGenerics() {
        assertRewrite(
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
            class B: NSObject {
            }
            class A: NSObject {
                private var _u: RACSubject<[B]>!
            }
            """)
    }
    
    func testRewriteStructTypedefs() {
        assertRewrite(
            objc: """
            typedef struct {
                float x;
                float y;
                float z;
            } vector_float3;
            typedef struct {
                float x;
                float y;
                float z;
                float w;
            } packed_float4;
            
            typedef struct {
                vector_float3 position;
                packed_float4 color;
                int offset;
                BOOL booly;
            } VertexObject;
            """
            , swift: """
            struct vector_float3 {
                var x: CFloat
                var y: CFloat
                var z: CFloat
            
                init() {
                    x = 0.0
                    y = 0.0
                    z = 0.0
                }
                init(x: CFloat, y: CFloat, z: CFloat) {
                    self.x = x
                    self.y = y
                    self.z = z
                }
            }
            struct packed_float4 {
                var x: CFloat
                var y: CFloat
                var z: CFloat
                var w: CFloat
            
                init() {
                    x = 0.0

                    y = 0.0

                    z = 0.0

                    w = 0.0
                }
                init(x: CFloat, y: CFloat, z: CFloat, w: CFloat) {
                    self.x = x

                    self.y = y

                    self.z = z

                    self.w = w
                }
            }
            struct VertexObject {
                var position: vector_float3
                var color: packed_float4
                var offset: CInt
                var booly: Bool
            
                init() {
                    position = vector_float3()

                    color = packed_float4()

                    offset = 0

                    booly = false
                }
                init(position: vector_float3, color: packed_float4, offset: CInt, booly: Bool) {
                    self.position = position

                    self.color = color

                    self.offset = offset

                    self.booly = booly
                }
            }
            """)
    }
    
    func testRewriterPointerToStructTypeDef() {
        assertRewrite(
            objc: """
            typedef struct {
                float x;
                float y;
                float z;
            } vector_float3;
            typedef struct {
                float x;
                float y;
                float z;
                float w;
            } packed_float4;
            
            typedef struct {
                vector_float3 position;
                packed_float4 color;
            } VertexObject;

            VertexObject *vertedObject;
            """
            , swift: """
            struct vector_float3 {
                var x: CFloat
                var y: CFloat
                var z: CFloat

                init() {
                    x = 0.0
                    y = 0.0
                    z = 0.0
                }
                init(x: CFloat, y: CFloat, z: CFloat) {
                    self.x = x
                    self.y = y
                    self.z = z
                }
            }
            struct packed_float4 {
                var x: CFloat
                var y: CFloat
                var z: CFloat
                var w: CFloat

                init() {
                    x = 0.0

                    y = 0.0

                    z = 0.0

                    w = 0.0
                }
                init(x: CFloat, y: CFloat, z: CFloat, w: CFloat) {
                    self.x = x

                    self.y = y

                    self.z = z

                    self.w = w
                }
            }
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
    
    func testRewriteAliasedTypedefStruct() {
        assertRewrite(
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
    
    func testRewriteAliasedTypedefStructWithPointers() {
        assertRewrite(
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
    
    func testRewriteOpaqueTypealias() {
        assertRewrite(
            objc: """
            typedef struct {
                int a;
            } *b;
            """,
            swift: """
            typealias b = OpaquePointer
            """)
    }
    
    func testRewriteOpaqueTypealias2() {
        assertRewrite(
            objc: """
            typedef struct _b *b;
            """,
            swift: """
            typealias b = OpaquePointer
            """)
    }
    
    // TODO: Support pointer to opaque pointers
    func xtestRewritePointerToOpaqueTypealias() {
        assertRewrite(
            objc: """
            typedef struct _b **b;
            """,
            swift: """
            typealias b = UnsafeMutablePointer<OpaquePointer>
            """)
    }
    
    func testRewriteFuncDeclaration() {
        assertRewrite(
            objc: """
            void global();
            """,
            swift: """
            func global() {
            }
            """)
    }
    
    func testLazyTypeResolveFuncDeclaration() {
        assertRewrite(
            objc: """
            A* global();
            
            @interface A
            @end
            """,
            swift: """
            func global() -> A! {
            }
            
            class A {
            }
            """)
    }
    
    func testAddNullCoalesceToCompletionBlockInvocationsDeepIntoBlockExpressions() {
        assertRewrite(
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
            class A {
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
    
    func testApplyNilCoalesceInDeeplyNestedExpressionsProperly() {
        assertRewrite(
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
            class A {
                func loadDataWithCallback(_ callback: ((NSArray?, Error?) -> Void)!) {
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
    func testParsingKeepsOrderingOfStatementsAndDeclarations() {
        assertRewrite(
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
            class A {
                func recreatePath() {
                    let top: CGFloat = startsAtTop ? 0 : circle.center.y
                    let bottom = max(self.bounds.size.height, top)

                    if top == bottom {
                        shapeLayer.path = nil

                        return
                    }

                    let path = CGMutablePath()

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
    
    func testEnumAccessRewriting() {
        assertRewrite(
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
            enum MyEnum: Int {
                case MyEnumCase
            }

            class A {
                func method() {
                    MyEnum.MyEnumCase
                }
            }
            """)
    }
    
    func testAppliesTypenameConversionToCategories() {
        // Make sure we have members on each extension so that the resulting
        // empty extensions are not removed
        assertRewrite(
            objc: """
            @interface NSString (Extension)
            - (void)test;
            @end
            @implementation NSDate (Extension)
            - (void)test {
            }
            @end
            """,
            swift: """
            // MARK: - Extension
            extension String {
                func test() {
                }
            }
            // MARK: - Extension
            extension Date {
                func test() {
                }
            }
            """)
    }
    
    /// Make sure scalar stored properties always initialize with zero, so the
    /// class mimics more closely the behavior of the original Objective-C class
    /// (which initializes all fields to zero on `init`)
    func testScalarTypeStoredPropertiesAlwaysInitializeAtZero() {
        assertRewrite(
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
                const NSString *_i;
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
            enum E: Int {
                case E_1
            }

            class A {
                private var _a: Bool = false
                private var _b: Int = 0
                private var _c: UInt = 0
                private var _d: CFloat = 0.0
                private var _e: CDouble = 0.0
                private var _e: CGFloat = 0.0
                private var _f: String!
                private var _g: E = E.E_1
                private var _h: String
                private let _i: String! = nil
                var a: Bool = false
                var b: Int = 0
                var c: UInt = 0
                var d: CFloat = 0.0
                var e: CDouble = 0.0
                var e: CGFloat = 0.0
                var f: String!
                var g: E = E.E_1
                var h: String
            }
            """)
    }
    
    func testRewritesNew() {
        assertRewrite(
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
            class A {
                func method() {
                    A()
                    A()
                }
                static func method2() {
                    self.init()
                    self.init()
                }
            }
            """)
    }
    
    func testEmitObjcAttribute() {
        assertRewrite(
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
            - (instancetype)initWithValue:(NSInteger)value {
            }
            - (void)method {
            }
            @end
            """,
            swift: """
            @objc
            enum Enum: Int {
                case Enum_A
            }
            
            @objc
            protocol A: NSObjectProtocol {
                @objc var b: Bool { get set }
            
                @objc
                func method()
            }
            
            @objc
            class B: A {
                @objc var b: Bool = false

                @objc
                init(value: Int) {
                }

                @objc
                func method() {
                }
            }
            """,
            options: SwiftSyntaxOptions.default.with(\.emitObjcCompatibility, true))
    }
    
    /// Tests calls that override a super call by detection of a `super` call on
    /// a super method with the same signature as the method being analyzed.
    func testMarkOverrideIfSuperCallIsDetected() {
        assertRewrite(
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
            class A {
                override init(thing: A!) {
                    super.init(thing: thing)
                }
                init(otherThing thing: A!) {
                    super.init(thing: thing)
                }

                override func a() {
                    super.a()
                }
                override func b(_ a: Int) {
                    super.b(a)
                }
                func c(_ a: Int) {
                    super.c() // Make sure we don't create unnecessary overrides
                }
            }
            """)
    }
    
    /// Test methods are marked as overrideusing type lookup of supertypes as well
    func testMarksOverrideBasedOnTypeLookup() {
        assertRewrite(
            objc: """
            @interface A
            - (void)method;
            @end
            @interface B: A
            - (void)method;
            @end
            """,
            swift: """
            class A {
                func method() {
                }
            }
            class B: A {
                override func method() {
                }
            }
            """)
    }
    
    /// Test the override detection doesn't confuse protocol implementations with
    /// overrides
    func testDontMarkProtocolImplementationsAsOverride() {
        assertRewrite(
            objc: """
            @protocol A
            - (void)method;
            @end
            @interface B: NSObject <A>
            - (void)method;
            @end
            """,
            swift: """
            protocol A {
                func method()
            }
            
            class B: NSObject, A {
                func method() {
                }
            }
            """)
    }

    func testCorrectsNullabilityOfMethodParameters() {
        assertRewrite(
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
            class A {
                var a: A?
                var b: Int = 0
            
                func method() {
                    self.takesInt(a?.b ?? 0)
                    self.takesInt(a?.returnsInt() ?? 0)
                    self.takesInt((a?.b ?? 0) + 0)
                    self.takesInt((a?.returnsInt() ?? 0) + 0)
                }
                func takesInt(_ a: Int) {
                }
                func returnsInt() -> Int {
                }
            }
            """)
    }
    
    func testOptionalCoalesceNullableStructAccess() {
        assertRewrite(
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

            class B {
                func a() -> A {
                }
                func takesA(_ a: A) {
                }
                func method() {
                    let b: B?

                    self.takesA(b?.a() ?? A())
                }
            }
            """)
    }
    
    func testOptionalInAssignmentLeftHandSide() {
        assertRewrite(
            objc: """
            @interface A
            @property (weak) B* b;
            @end
            @interface B
            @property NSInteger c;
            @end

            @implementation A
            - (void)method {
                A *a;
                self.b.c = 0;
                a.b.c = 0;
                [self takesExpression:a.b.c];
            }
            - (void)takesExpression:(NSInteger)a {
            }
            @end
            """,
            swift: """
            class B {
                var c: Int = 0
            }
            class A {
                weak var b: B?
            
                func method() {
                    let a: A!

                    self.b?.c = 0
                    a.b?.c = 0
                    self.takesExpression(a.b?.c ?? 0)
                }
                func takesExpression(_ a: Int) {
                }
            }
            """)
    }
    
    func testAutomaticIfLetPatternSimple() {
        assertRewrite(
            objc: """
            @interface B
            @end
            
            @interface A
            @property (nullable) B *b;
            - (void)takesB:(nonnull B*)b;
            @end

            @implementation A
            - (void)method {
                [self takesB:self.b];
            }
            @end
            """,
            swift: """
            class B {
            }
            class A {
                var b: B?
            
                func method() {
                    if let b = self.b {
                        self.takesB(b)
                    }
                }
                func takesB(_ b: B) {
                }
            }
            """)
    }
    
    func testInstanceTypeOnStaticConstructor() {
        assertRewrite(
            objc: """
            @interface A
            + (instancetype)makeA;
            @end
            """,
            swift: """
            class A {
                static func makeA() -> A! {
                }
            }
            """)
    }
    
    func testPropagateNullabilityOfBlockArgumentsInTypealiasedBlock() {
        assertRewrite(
            objc: """
            NS_ASSUME_NONNULL_BEGIN
            typedef void(^block)(NSString*);
            NS_ASSUME_NONNULL_END
            
            @implementation A
            - (void)method {
                [self takesBlock:^(NSString* a){
                }];
            }
            - (void)takesBlock:(nonnull block)a {
            }
            @end
            """,
            swift: """
            typealias block = (String) -> Void

            class A {
                func method() {
                    self.takesBlock { (a: String) -> Void in
                    }
                }
                func takesBlock(_ a: block) {
                }
            }
            """)
    }
    
    func testNullCoalesceInChainedValueTypePostfix() {
        assertRewrite(
            objc: """
            @interface A
            @property CGRect bounds;
            @property (weak) A *parent;
            @end
            @implementation A
            - (void)method {
                CGRectInset(self.bounds, 1, 2);
                self.bounds = CGRectInset(self.parent.bounds, 1, 2);
            }
            @end
            """,
            swift: """
            class A {
                var bounds: CGRect = CGRect()
                weak var parent: A?
            
                func method() {
                    self.bounds.insetBy(dx: 1, dy: 2)
                    self.bounds = (self.parent?.bounds ?? CGRect()).insetBy(dx: 1, dy: 2)
                }
            }
            """)
    }
    
    func testApplyCastOnNumericalVariableDeclarationInits() {
        assertRewrite(
            objc: """
            @interface B
            @property CGFloat value;
            @end
            
            @interface A
            @property (nullable) B *b;
            @end
            
            @implementation A
            - (void)method {
                NSInteger local = self.b.value / self.b.value;
            }
            @end
            """,
            swift: """
            class B {
                var value: CGFloat = 0.0
            }
            class A {
                var b: B?
            
                func method() {
                    let local = Int((self.b?.value ?? 0.0) / (self.b?.value ?? 0.0))
                }
            }
            """)
    }
    
    func testFunctionParameterTakesPrecedenceOverPropertyDuringDefinitionLookup() {
        assertRewrite(
            objc: """
            @interface B
            @property CGFloat value;
            @end
            
            @interface A
            @property (nullable) B *b;
            - (void)takesF:(CGFloat)value;
            @end
            
            @implementation A
            - (void)method:(nonnull B*)b {
                [self takesF:b.value];
            }
            - (void)takesF:(CGFloat)value {
            }
            @end
            """,
            swift: """
            class B {
                var value: CGFloat = 0.0
            }
            class A {
                var b: B?
            
                func method(_ b: B) {
                    self.takesF(b.value)
                }
                func takesF(_ value: CGFloat) {
                }
            }
            """)
    }
    
    func testFloorMethodRecastingIssue() {
        assertRewrite(
            objc: """
            static const CGFloat FLT_EPSILON = 1e-10;
            
            @interface A : NSObject
            @property CGFloat b;
            @end
            
            @implementation A
            - (void)method {
                BOOL changedY = fabs(self.b - self.b) > FLT_EPSILON;
            }
            @end
            """,
            swift: """
            let FLT_EPSILON: CGFloat = 1e-10
            
            class A: NSObject {
                var b: CGFloat = 0.0
            
                func method() {
                    let changedY = fabs(self.b - self.b) > FLT_EPSILON
                }
            }
            """)
    }
    
    func testRewriterSynthesizesBackingFieldOnReadonlyPropertyIfAnUsageIsDetected() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            @property (readonly) NSInteger a;
            @end
            
            @implementation A
            - (void)method {
                self->_a = 0;
            }
            @end
            """,
            swift: """
            class A: NSObject {
                private var _a: Int = 0
                var a: Int {
                    return self._a
                }
            
                func method() {
                    self._a = 0
                }
            }
            """)
    }
    
    func testSynthesizePropertyBackingField() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            @property NSInteger a;
            @end
            
            @implementation A
            @synthesize a = b;
            @end
            """,
            swift: """
            class A: NSObject {
                private var b: Int = 0
                var a: Int {
                    get {
                        return b
                    }
                    set {
                        b = newValue
                    }
                }
            }
            """)
    }
    
    func testSynthesizeReadonlyPropertyBackingField() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            @property (readonly) NSInteger a;
            @end
            
            @implementation A
            @synthesize a = b;
            @end
            """,
            swift: """
            class A: NSObject {
                private var b: Int = 0
                var a: Int {
                    return b
                }
            }
            """)
    }
    
    func testDontSynthesizeDynamicDeclaration() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            @property NSInteger a;
            @end
            
            @implementation A
            @dynamic a = b;
            @end
            """,
            swift: """
            class A: NSObject {
                var a: Int = 0
            }
            """)
    }
    
    func testSynthesizeReadonlyPropertyOnExistingIVar() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            {
                NSInteger b;
            }
            @property NSInteger a;
            @end
            
            @implementation A
            @synthesize a = b;
            @end
            """,
            swift: """
            class A: NSObject {
                private var b: Int = 0
                var a: Int {
                    get {
                        return b
                    }
                    set {
                        b = newValue
                    }
                }
            }
            """)
    }
    
    func testCollapsePropertySynthesisWhenPropertyAndBackingFieldMatchTypesAndName() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            @property NSInteger a;
            @end
            
            @implementation A
            @synthesize a;
            @end
            """,
            swift: """
            class A: NSObject {
                var a: Int = 0
            }
            """)
    }
    
    func testReadOnlyPropertyWithBackingFieldWithSameNameGetsCollapedAsPrivateSetProperty() {
        assertRewrite(
            objc: """
            @interface A : NSObject
            {
                @private
                NSMutableString *a;
                @protected
                NSMutableString *b;
                @package
                NSMutableString *c;
                @public
                NSMutableString *d;
            }
            @property (readonly) NSString *a;
            @property (readonly) NSString *b;
            @property (readonly) NSString *c;
            @property (readonly) NSString *d;
            @end
            
            @implementation A
            @synthesize a, b, c, d;
            @end
            """,
            swift: """
            class A: NSObject {
                private(set) var a: NSMutableString!
                var b: NSMutableString!
                var c: NSMutableString!
                var d: NSMutableString!
            }
            """)
    }
    
    func testBackingFieldUsageAnalysisWithSynthesizedBackingFieldIsOrderIndependent() {
        assertRewrite(
            objc: """
            @implementation A (category)
            - (void)setA:(NSInteger)a {
                self->_b = a;
            }
            @end
            
            @interface A: NSObject
            @property NSInteger a;
            @end
            
            @implementation A
            @synthesize a = b;
            @end
            """,
            swift: """
            class A: NSObject {
                private var b: Int = 0
                var a: Int {
                    get {
                        return b
                    }
                    set(a) {
                        self._b = a
                    }
                }
            }
            """)
    }
    
    /// Tests that we ignore lookup for explicit usages of backing fields on types
    /// when the backing field name matches the property's: This is ambiguous on
    /// Swift and we should just collapse the property/ivar into a single property.
    func testBackingFieldAnalysisForSynthesizedPropertyIsIgnoredIfSynthesizedNameMatchesPropertyName() {
        assertRewrite(
            objc: """
            @interface A: NSObject
            {
                NSInteger a;
            }
            @property (readonly) NSInteger a;
            @end
            
            @implementation A
            @synthesize a = a;
            
            - (void)method {
                self->a = 0;
            }
            @end
            """,
            swift: """
            class A: NSObject {
                private(set) var a: Int = 0
            
                func method() {
                    self.a = 0
                }
            }
            """)
    }
    
    func testApplyIntegerCastOnTypealiasedPropertyInVariableDeclaration() {
        assertRewrite(
            objc: """
            typedef UInt32 GLenum;

            @interface A
            @property CGFloat prop;
            @end

            @implementation A
            - (void)method {
                GLenum local = prop;
            }
            @end
            """,
            swift: """
            typealias GLenum = UInt32
            
            class A {
                var prop: CGFloat = 0.0

                func method() {
                    let local = GLenum(prop)
                }
            }
            """)
    }
    
    func testParseAliasedTypealias() {
        assertRewrite(
            objc: """
            typedef UInt32 GLenum;
            typedef GLenum Alias;

            @interface A
            @property CGFloat prop;
            @end

            @implementation A
            - (void)method {
                Alias local = (GLenum)prop;
            }
            @end
            """,
            swift: """
            typealias GLenum = UInt32
            typealias Alias = GLenum

            class A {
                var prop: CGFloat = 0.0

                func method() {
                    let local = GLenum(prop)
                }
            }
            """)
    }
    
    func testRewriteChainedSubscriptAccess() {
        assertRewrite(
            objc: """
            @implementation A
            - (void)method {
                NSDictionary* dict = @{};
                NSLog(dict[@"abc"][@"def"].value);
            }
            @end
            """,
            swift: """
            class A {
                func method() {
                    let dict = [:]

                    NSLog(dict["abc"]?["def"].value)
                }
            }
            """)
    }
    
    func testDetectBooleanGettersInUIViewSubclasses() {
        assertRewrite(
            objc: """
            @interface A: UITableViewCell
            @end
            @implementation A
            - (void)method {
                (self.hidden);
            }
            @end
            """,
            swift: """
            class A: UITableViewCell {
                func method() {
                    self.isHidden
                }
            }
            """)
    }
    
    func testRewriteInitBody() {
        assertRewrite(
            objc: """
            @interface A
            @property NSInteger a;
            @end
            @implementation A
            - (instancetype)init {
                self = [super init];
                if(self) {
                    self.a = 0;
                }
                return self;
            }
            @end
            """,
            swift: """
            class A {
                var a: Int = 0

                override init() {
                    self.a = 0
                    super.init()
                }
            }
            """)
    }
    
    func testRewriteExplicitFailableInit() {
        assertRewrite(
            objc: """
            @interface A
            @end

            @implementation A
            - (nullable instancetype)initWithThing:(NSInteger)thing {
                return self;
            }
            @end
            """,
            swift: """
            class A {
                init?(thing: Int) {
                    return self
                }
            }
            """)
    }
    
    func testRewriteDetectedFailableInit() {
        assertRewrite(
            objc: """
            @interface A
            @end

            @implementation A
            - (instancetype)initWithThing:(NSInteger)thing {
                return nil;
            }
            @end
            """,
            swift: """
            class A {
                init?(thing: Int) {
                    return nil
                }
            }
            """)
    }
    
    func testRewriteDelegatedInitializer() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @interface B : A
            @end
            
            @implementation B
            - (instancetype)initWithA:(nonnull A*)a {
                self = [super initWithA:a];
                return self;
            }
            - (instancetype)initWithB:(nonnull B*)b {
                self = [self initWithA:a];
                if (self) {
                    
                }
                return self;
            }
            @end
            """,
            swift: """
            class A {
            }
            class B: A {
                override init(a: A) {
                    self = super.init(a: a)

                    return self
                }
                convenience init(b: B) {
                    self.init(a: a)
                }
            }
            """)
    }
    
    func testConvertImplementationAndCallSiteUsingKnownTypeInformation() {
        assertRewrite(
            objc: """
            @interface A : UIView
            @end
            
            @implementation A
            - (CGPoint)convertPoint:(CGPoint)point toView:(UIView*)view {
                return [self convertPoint:CGPointMake(0, 0) toView:nil];
            }
            @end
            """,
            swift: """
            class A: UIView {
                override func convert(_ point: CGPoint, to view: UIView?) -> CGPoint {
                    return self.convert(CGPoint(x: 0, y: 0), to: nil)
                }
            }
            """)
    }
    
    func testCorrectsNullableArgumentInFoundationTypeFunctionCall() {
        assertRewrite(
            objc: """
            void test() {
                NSMutableArray *array = [NSMutableArray array];
                NSObject *_Nullable object;
                [array addObject:object];
            }
            """,
            swift: """
            func test() {
                let array = NSMutableArray()
                let object: NSObject?

                if let object = object {
                    array.add(object)
                }
            }
            """)
    }
    
    func testCorrectsDateIsEqualIntoBinaryExpression() {
        assertRewrite(
            objc: """
            void test() {
                [[NSDate date] isEqual:[NSDate date]];
                NSDate *_Nullable date;
                [date isEqualToDate:[NSDate date]];
            }
            """,
            swift: """
            func test() {
                Date() == Date()

                let date: Date?

                date == Date()
            }
            """
        )
    }
    
    func testMergeNullabilityOfTypealiasedBlockType() {
        assertRewrite(
            objc: """
            typedef void(^callback)();
            
            @interface A
            - (void)doWork:(nullable callback)call;
            @end
            @implementation A
            - (void)doWork:(callback)call {
                call();
            }
            @end
            """,
            swift: """
            typealias callback = () -> Void
            
            class A {
                func doWork(_ call: callback?) {
                    call?()
                }
            }
            """
        )
    }
    
    func testMergeNullabilityOfAliasedBlockFromNonAliasedDeclaration() {
        assertRewrite(
            objc: """
            typedef void(^callback)();
            typedef BOOL(^predicate)(NSString*_Nullable);
            typedef BOOL(^other_predicate)(NSString*_Nullable);
            
            @interface A
            - (void)doWork:(nullable callback)call;
            - (void)doMoreWork:(nullable predicate)predicate;
            - (void)doOtherWork:(nonnull other_predicate)predicate;
            NS_ASSUME_NONNULL_BEGIN
            + (void)rawQuery:(NSString*)query handler:(void(^)(id _Nullable results, NSError*_Nullable error))handler;
            NS_ASSUME_NONNULL_END
            @end
            @implementation A
            - (void)doWork:(void(^callback)())call {
                call();
            }
            - (void)doMoreWork:(BOOL(^predicate)(NSString*))predicate {
                predicate();
            }
            - (void)doOtherWork:(BOOL(^predicate)(NSString*_Nonnull))predicate {
                predicate();
            }
            + (void)rawQuery:(NSString *)query handler:(void (^)(id _Nullable, NSError * _Nullable))handler {
                handler(nil, nil);
            }
            @end
            """,
            swift: """
            typealias callback = () -> Void
            typealias predicate = (String?) -> Bool
            typealias other_predicate = (String?) -> Bool
            
            class A {
                func doWork(_ call: callback?) {
                    call?()
                }
                func doMoreWork(_ predicate: predicate?) {
                    predicate?()
                }
                func doOtherWork(_ predicate: ((String) -> Bool)!) {
                    predicate?()
                }
                static func rawQuery(_ query: String, handler: (AnyObject?, Error?) -> Void) {
                    handler(nil, nil)
                }
            }
            """
        )
    }
    
    func testRewriteFreeStruct() {
        assertRewrite(
            objc: """
            typedef int (*cmpfn234)(void *, void *);
            
            struct tree234_Tag {
                node234 *root;
                cmpfn234 cmp;
            };
            """,
            swift: """
            typealias cmpfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> CInt
            
            struct tree234_Tag {
                var root: UnsafeMutablePointer<node234>!
                var cmp: cmpfn234!
            
                init() {
                    root = nil
                    cmp = nil
                }
                init(root: UnsafeMutablePointer<node234>!, cmp: cmpfn234!) {
                    self.root = root
                    self.cmp = cmp
                }
            }
            """)
    }
    
    func testDateClassGetterCase() {
        assertRewrite(
            objc: """
            void test() {
                id obj = [Date date];
                [objc isKindOfClass:[Date class]];
            }
            """,
            swift: """
            func test() {
                let obj = Date()

                objc.isKindOfClass(Date.self)
            }
            """)
    }
    
    func testRewriteGenericSuperclass() {
        assertRewrite(
            objc: """
            @interface Sub : Base<NSString*>
            @end
            """,
            swift: """
            class Sub: Base {
            }
            """)
    }
    
    func testRewriteIBOutlet() {
        assertRewrite(
            objc: """
            @interface Foo : NSObject
            @property (weak, nonatomic) IBOutlet UILabel *label;
            @end
            """,
            swift: """
            class Foo: NSObject {
                @IBOutlet weak var label: UILabel?
            }
            """)
    }
    
    func testRewriteIBInspectable() {
        assertRewrite(
            objc: """
            @interface Foo : NSObject
            @property (weak, nonatomic) IBInspectable UILabel *label;
            @end
            """,
            swift: """
            class Foo: NSObject {
                @IBInspectable weak var label: UILabel?
            }
            """)
    }
    
    func testRewriteIfElseIfElse() {
        assertRewrite(
            objc: """
            void f() {
                if (true) {
                } else if (true) {
                    @throw error;
                } else {
                }
            }
            """,
            swift: """
            func f() {
                if true {
                } else if true {
                    /*
                    @throwerror;
                    */
                } else {
                }
            }
            """)
    }

    func testRewriteAutotypeDeclaration() {
        assertRewrite(
            objc: """
            void f() {
                __auto_type value = 1;
            }
            """,
            swift: """
            func f() {
                // decl type: Int
                // init type: Int
                let value = 1
            }
            """,
            options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true))
    }

    func testRewriteAutotypeDeclarationDependent() {
        assertRewrite(
            objc: """
            void f() {
                __auto_type value = 1;
                __auto_type valueDep = value;
            }
            """,
            swift: """
            func f() {
                // decl type: Int
                // init type: Int
                let value = 1
                // decl type: Int
                // init type: Int
                let valueDep = value
            }
            """,
            options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true))
    }
    
    func testRewriteWeakAutotypeDeclaration() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @implementation A
            - (void)foo {
                __weak __auto_type weakSelf = self;
            }
            @end
            """,
            swift: """
            class A {
                func foo() {
                    // decl type: A?
                    // init type: A
                    weak var weakSelf = self
                }
            }
            """,
            options: SwiftSyntaxOptions.default.with(\.outputExpressionTypes, true))
    }
    
    func testRewriteFixedArray() {
        assertRewrite(
            objc: """
            typedef struct {
                int a[3];
            } A;
            """,
            swift: """
            struct A {
                var a: (CInt, CInt, CInt)

                init() {
                    a = (0, 0, 0)
                }
                init(a: (CInt, CInt, CInt)) {
                    self.a = a
                }
            }
            """)
    }
    
    func testRewriteEmptyFixedArray() {
        assertRewrite(
            objc: """
            typedef struct {
                int a[0];
            } A;
            """,
            swift: """
            struct A {
                var a: Void

                init() {
                    a = ()
                }
                init(a: Void) {
                    self.a = a
                }
            }
            """)
    }
    
    func testRewriteFixedArrayOfFixedArray() {
        assertRewrite(
            objc: """
            typedef struct {
                int a[3][2];
            } A;
            """,
            swift: """
            struct A {
                var a: ((CInt, CInt), (CInt, CInt), (CInt, CInt))

                init() {
                    a = ((0, 0), (0, 0), (0, 0))
                }
                init(a: ((CInt, CInt), (CInt, CInt), (CInt, CInt))) {
                    self.a = a
                }
            }
            """)
    }
    
    func testRewriteAccessIntoOptionalWeakType() {
        assertRewrite(
            objc: """
            @interface A
            @property NSInteger a;
            @end
            @implementation A
            - (void)test {
                __weak __auto_type weakSelf = self;
                weakSelf.a = 10;
            }
            @end
            """,
            swift: """
            class A {
                var a: Int = 0
            
                func test() {
                    weak var weakSelf = self

                    weakSelf?.a = 10
                }
            }
            """)
    }
    
    func testConvertSubscriptDeclaration() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @implementation A
            - (NSObject*)objectAtIndexSubscript:(NSUInteger)index {
                return self;
            }
            @end
            """,
            swift: """
            class A {
                subscript(index: UInt) -> NSObject! {
                    return self
                }
            }
            """)
    }
    
    func testConvertSubscriptDeclarationGetterAndSetter() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @implementation A
            - (NSObject*)objectAtIndexSubscript:(NSUInteger)index {
                return self;
            }
            - (void)setObject:(NSObject*)object atIndexedSubscript:(NSUInteger)index {
                (object);
            }
            @end
            """,
            swift: """
            class A {
                subscript(index: UInt) -> NSObject! {
                    get {
                        return self
                    }
                    set(object) {
                        (object)
                    }
                }
            }
            """)
    }
    
    func testCommentTransposing() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @implementation A
            - (NSObject*)getObject {
                // A comment
                test();

                // Double line
                // Comment
                return nil;
            }
            @end
            """,
            swift: """
            class A {
                func getObject() -> NSObject! {
                    // A comment
                    test()

                    // Double line
                    // Comment
                    return nil
                }
            }
            """)
    }
    
    // TODO: Fix multi-lined comments to adjust indentation
    func testBlockCommentTransposing() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @implementation A
            - (void)test {
                /*
                    Block comment
                */
                test2();
            }
            @end
            """,
            swift: """
            class A {
                func test() {
                    /*
                    Block comment
                */
                    test2()
                }
            }
            """)
    }
    
    func testDeclarationCommentTransposing() {
        assertRewrite(
            objc: """
            // A comment
            @interface A
            // Method declaration comment
            - (void)test;
            @end
            // Another comment
            @implementation A
            // Method definition comment
            - (void)test {
            }
            @end
            """,
            swift: """
            // A comment
            // Another comment
            class A {
                // Method declaration comment
                // Method definition comment
                func test() {
                }
            }
            """)
    }
    
    func testDeclarationCommentIgnoresMethodBodyComments() {
        assertRewrite(
            objc: """
            @implementation A
            // Method definition comment
            - (void)test {
                // Method body comment
                stmt();
            }
            // Another comment
            - (void)test2 {
            }
            @end
            """,
            swift: """
            class A {
                // Method definition comment
                func test() {
                    // Method body comment
                    stmt()
                }
                // Another comment
                func test2() {
                }
            }
            """)
    }
    
    func testDontMergeCommentsFromProtocolToClass() {
        assertRewrite(
            objc: """
            @protocol MyProtocol
            // Comment
            - (void)myMethod2;
            @end
            @interface A : NSObject <MyProtocol>
            // Method comment
            - (void)myMethod2;
            @end
            """,
            swift: """
            protocol MyProtocol {
                // Comment
                func myMethod2()
            }

            class A: NSObject, MyProtocol {
                // Method comment
                func myMethod2() {
                }
            }
            """)
    }
    
    func testBlockPropertyDeclaration() {
        assertRewrite(
            objc: """
            @interface A
            @property void (^show)(UIView *view, UIViewController *controller);
            @end
            """,
            swift: """
            class A {
                var show: ((UIView?, UIViewController?) -> Void)!
            }
            """)
    }
    
    func testOmitEmptyExtensions() {
        assertRewrite(
            objc: """
            @interface A
            @end
            @interface A ()
            // Create a property on an extension to force the property to be moved
            // and thus de-populate this interface
            @property NSInteger a;
            @end
            """,
            swift: """
            class A {
                // Create a property on an extension to force the property to be moved
                // and thus de-populate this interface
                var a: Int = 0
            }
            """)
    }
    
    func testRewriteConstantFromMacroInHeader() {
        assertRewrite(
            objc: """
            #define CONSTANT 1
            #define CONSTANT2 1 + 1
            """,
            swift: """
            // Preprocessor directives found in file:
            // #define CONSTANT 1
            // #define CONSTANT2 1 + 1
            let CONSTANT: Int = 1
            let CONSTANT2: Int = 1 + 1
            """,
            inputFileName: "test.h")
    }
    
    func testRewriteConstantFromMacroInImplementation() {
        assertRewrite(
            objc: """
            #define CONSTANT 1
            #define CONSTANT2 1 + 1
            """,
            swift: """
            // Preprocessor directives found in file:
            // #define CONSTANT 1
            // #define CONSTANT2 1 + 1
            private let CONSTANT: Int = 1
            private let CONSTANT2: Int = 1 + 1
            """,
            inputFileName: "test.m")
    }
    
    func testRewriteIgnoresInvalidConstantFromMacro() {
        assertRewrite(
            objc: """
            #define CONSTANT (1
            #define CONSTANT2 unknown + identifiers
            """,
            swift: """
            // Preprocessor directives found in file:
            // #define CONSTANT (1
            // #define CONSTANT2 unknown + identifiers
            """)
    }
}
