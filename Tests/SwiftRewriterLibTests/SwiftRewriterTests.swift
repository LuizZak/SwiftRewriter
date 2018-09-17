import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftRewriterTests: XCTestCase {
    
    func testParseNonnullMacros() {
        assertObjcParse(objc: """
            NS_ASSUME_NONNULL_BEGIN
            NS_ASSUME_NONNULL_END
            """, swift: """
            """)
    }
    
    func testRewriteEmptyClass() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(objc: """
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
            objc: """
            typedef void(^errorBlock)();
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteBlockTypeDefWithVoidParameterList() {
        assertObjcParse(
            objc: """
            typedef void(^errorBlock)(void);
            """,
            swift: """
            typealias errorBlock = () -> Void
            """)
    }
    
    func testRewriteCFunctionPointerTypeDef() {
        assertObjcParse(
            objc: """
            typedef int (*cmpfn234)(void *, void *);
            typedef int (*cmpfn234_3)(void (^)(), void *);
            """,
            swift: """
            typealias cmpfn234 = @convention(c) (UnsafeMutableRawPointer?, UnsafeMutableRawPointer?) -> CInt
            typealias cmpfn234_3 = @convention(c) ((() -> Void)?, UnsafeMutableRawPointer?) -> CInt
            """)
    }
    
    // TODO: Fix this test
    func _testRewriteCFunctionWithCFunctionParameter() {
        assertObjcParse(
            objc: """
            typedef int (*cmpfn234_2)(void (*)(), void *);
            """,
            swift: """
            typealias cmpfn234_2 = @convention(c) ((@convention(c) () -> Void)?, UnsafeMutableRawPointer?) -> CInt
            """)
    }
    
    func testNSAssumeNonnullContextCollectionWorksWithCompilerDirectivesInFile() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
            options: ASTWriterOptions(emitObjcCompatibility: true))
    }
    
    func testRewriteProtocolConformance() {
        assertObjcParse(
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
                @objc optional func myMethod()
                @objc optional func myMethod2()
            }

            class A: NSObject, MyProtocol {
                func myMethod2() {
                }
            }
            """)
    }
    
    func testRewriteProtocolOptionalRequiredSections() {
        assertObjcParse(
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
                @objc optional func f2()
                @objc optional func f3()
                func f4()
            }
            """)
    }
    
    func testRewriteProtocolPropertiesWithGetSetSpecifiers() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
    
    func testIfFalseDirectivesHideCodeWithin() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
            objc: """
            typedef struct {
                int a;
            } *b;
            """,
            swift: """
            typealias b = OpaquePointer
            """)
    }
    
    func testRewriteFuncDeclaration() {
        assertObjcParse(
            objc: """
            void global();
            """,
            swift: """
            func global() {
            }
            """)
    }
    
    func testLazyTypeResolveFuncDeclaration() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
            objc: """
            @interface NSString (Extension)
            @end
            @implementation NSDate (Extension)
            @end
            """,
            swift: """
            // MARK: - Extension
            extension String {
            }
            // MARK: - Extension
            extension Date {
            }
            """)
    }
    
    /// Make sure scalar stored properties always initialize with zero, so the
    /// class mimics more closely the behavior of the original Objective-C class
    /// (which initializes all fields to zero on `init`)
    func testScalarTypeStoredPropertiesAlwaysInitializeAtZero() {
        assertObjcParse(
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
                private var _g: E
                private var _h: String
                private let _i: String! = nil
                var a: Bool = false
                var b: Int = 0
                var c: UInt = 0
                var d: CFloat = 0.0
                var e: CDouble = 0.0
                var e: CGFloat = 0.0
                var f: String!
                var g: E
                var h: String
            }
            """)
    }
    
    func testRewritesNew() {
        assertObjcParse(
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
        assertObjcParse(
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
            @objc enum Enum: Int {
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
                func method() {
                }
            }
            """,
            options: ASTWriterOptions(emitObjcCompatibility: true))
    }
    
    /// Tests calls that override a super call by detection of a `super` call on
    /// a super method with the same signature as the method being analyzed.
    func testMarkOverrideIfSuperCallIsDetected() {
        assertObjcParse(
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
                    super.c()
                }
            }
            """)
    }
    
    /// Test methods are marked as overrideusing type lookup of supertypes as well
    func testMarksOverrideBasedOnTypeLookup() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
            objc: """
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
            class A: NSObject {
                var b: CGFloat = 0.0
                
                func method() {
                    let changedY = fabs(self.b - self.b) > FLT_EPSILON
                }
            }
            """)
    }
    
    func testRewriterSynthesizesBackingFieldOnReadonlyPropertyIfAnUsageIsDetected() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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

            // MARK: - category
            extension A {
            }
            """)
    }
    
    /// Tests that we ignore lookup for explicit usages of backing fields on types
    /// when the backing field name matches the property's: This is ambiguous on
    /// Swift and we should just collapse the property/ivar into a single property.
    func testBackingFieldAnalysisForSynthesizedPropertyIsIgnoredIfSynthesizedNameMatchesPropertyName() {
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
        assertObjcParse(
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
}
