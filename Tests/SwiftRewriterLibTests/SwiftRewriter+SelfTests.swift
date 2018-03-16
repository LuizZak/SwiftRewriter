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
            @interface MyClass
            @property (class, readonly) BOOL a;
            @property (readonly) BOOL b;
            @end
            @implementation MyClass
            + (BOOL)a {
                (self);
            }
            - (BOOL)b {
                (self);
            }
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
                @objc static var a: Bool {
                    // type: MyClass.self
                    (self)
                }
                @objc var b: Bool {
                    // type: MyClass
                    (self)
                }
                
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
                @objc var aValue: Int = 0
                
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
                (value);
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
                    // type: Int
                    (value)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsForSetterCustomNewValueName() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            @property BOOL value;
            @end
            
            @implementation A
            - (BOOL)value {
                return NO;
            }
            - (void)setValue:(BOOL)value {
                (value);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc var value: Bool {
                    get {
                        return false
                    }
                    set(value) {
                        // type: Bool
                        (value)
                    }
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsForSetterWithDefaultNewValueName() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            @property BOOL value;
            @end
            
            @implementation A
            - (BOOL)value {
                return NO;
            }
            - (void)setValue:(BOOL)newValue {
                (newValue);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc var value: Bool {
                    get {
                        return false
                    }
                    set {
                        // type: Bool
                        (newValue)
                    }
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsExposeClassInstanceProperties() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            {
                NSInteger field;
            }
            @property BOOL value;
            @end
            
            @implementation A
            - (void)f1 {
                (self.value);
                (self->field);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                private var field: Int = 0
                @objc var value: Bool = false
                
                @objc
                func f1() {
                    // type: Bool
                    (self.value)
                    // type: Int
                    (self.field)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsExposeMethodParameters() throws {
        try assertObjcParse(
            objc: """
            @implementation A
            - (void)f1:(A*)value {
                (value);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc
                func f1(_ value: A!) {
                    // type: A!
                    (value)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testPropertyResolutionLooksThroughNullability() throws {
        // FIXME: Maybe it's desireable to infer as `Int!` instead?
        try assertObjcParse(
            objc: """
            @interface A : NSObject
            @property NSInteger prop;
            @end
            
            @implementation A
            - (void)f1:(A*)value {
                (value.prop);
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc var prop: Int = 0
                
                @objc
                func f1(_ value: A!) {
                    // type: Int
                    (value.prop)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testVariableDeclarationCascadesTypeOfInitialExpression() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            {
                void(^_Nullable callback)();
            }
            @end
            @implementation A
            - (void)f1 {
                void(^_callback)() = self->callback;
                _callback();
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                private var callback: (() -> Void)? = nil
                
                @objc
                func f1() {
                    var _callback = self.callback
                    // type: Void?
                    _callback?()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testExpressionWithinBracelessIfStatement() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            {
                void(^ _Nullable callback)();
            }
            @end
            @implementation A
            - (void)f1 {
                void(^_callback)() = self->callback;
                if(_callback != nil)
                    _callback();
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                private var callback: (() -> Void)? = nil
                
                @objc
                func f1() {
                    var _callback = self.callback
                    // type: Void?
                    _callback?()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testLookThroughProtocolConformances() throws {
        try assertObjcParse(
            objc: """
            @interface A: NSObject
            @property (nullable) NSObject *b;
            @end
            
            @implementation A
            - (void)method {
                [b respondsToSelector:@selector(abc:)];
            }
            @end
            """,
            swift: """
            @objc
            class A: NSObject {
                @objc var b: NSObject? = nil
                
                @objc
                func method() {
                    // type: Bool?
                    b?.responds(to: Selector("abc:"))
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testChainedOptionalAccessMethodCall() throws {
        // With a (nonnull B*)method;
        try assertObjcParse(
            objc: """
            @interface B: NSObject
            - (nonnull B*)method;
            @end
            @interface A: NSObject
            @property (nullable) B *b;
            @end
            
            @implementation A
            - (void)method {
                [[self.b method] method];
            }
            @end
            """,
            swift: """
            @objc
            class B: NSObject {
                @objc
                func method() -> B {
                }
            }
            @objc
            class A: NSObject {
                @objc var b: B? = nil
                
                @objc
                func method() {
                    // type: B?
                    self.b?.method().method()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testChainedOptionalAccessMethodCall2() throws {
        // With a (nullable B*)method;
        try assertObjcParse(
            objc: """
            @interface B: NSObject
            - (nullable B*)method;
            @end
            @interface A: NSObject
            @property (nullable) B *b;
            @end
            
            @implementation A
            - (void)method {
                [[self.b method] method];
            }
            @end
            """,
            swift: """
            @objc
            class B: NSObject {
                @objc
                func method() -> B? {
                }
            }
            @objc
            class A: NSObject {
                @objc var b: B? = nil
                
                @objc
                func method() {
                    // type: B?
                    self.b?.method().method()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testChainCallRespondsToSelector() throws {
        try assertObjcParse(
            objc: """
            @protocol B <NSObject>
            @end
            @interface A: NSObject
            @property (weak) B *b;
            @end
            
            @implementation A
            - (void)method {
                [self.b respondsToSelector:@selector(abc:)];

                if([self.b respondsToSelector:@selector(abc:)]) {
                    
                }
            }
            @end
            """,
            swift: """
            @objc
            protocol B: NSObjectProtocol {
            }

            @objc
            class A: NSObject {
                @objc weak var b: B? = nil
                
                @objc
                func method() {
                    // type: Bool?
                    self.b?.responds(to: Selector("abc:"))
                    if self.b?.responds(to: Selector("abc:")) == true {
                    }
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testTypeLookupIntoComposedProtocols() throws {
        try assertObjcParse(
            objc: """
            @protocol A <NSObject>
            @property BOOL a;
            @end
            @protocol B <NSObject>
            @property NSInteger b;
            @end
            
            @interface C: NSObject
            @property id<A, B> composed;
            @end
            @implementation C
            - (void)method {
                (self.composed);
                (self.composed.a);
                (self.composed.b);
            }
            @end
            """,
            swift: """
            @objc
            protocol A: NSObjectProtocol {
                @objc var a: Bool { get set }
            }
            @objc
            protocol B: NSObjectProtocol {
                @objc var b: Int { get set }
            }

            @objc
            class C: NSObject {
                @objc var composed: (A & B)! = nil
                
                @objc
                func method() {
                    // type: (A & B)!
                    (self.composed)
                    // type: Bool?
                    (self.composed.a)
                    // type: Int?
                    (self.composed.b)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testLocalVariableDeclarationInitializedTransmitsNullabilityFromRightHandSide() throws {
        try assertObjcParse(
            objc: """
            @interface MyClass
            - (nullable NSString*)optional;
            - (nonnull NSString*)nonOptional;
            - (NSString*)unspecifiedOptional;
            @end
            @implementation MyClass
            - (void)method {
                NSString *local1 = [self optional];
                NSString *local2 = [self nonOptional];
                NSString *local3 = [self unspecifiedOptional];
                (local1);
                (local2);
                (local3);
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func method() {
                    var local1 = self.optional()
                    var local2 = self.nonOptional()
                    var local3 = self.unspecifiedOptional()
                    // type: String?
                    (local1)
                    // type: String
                    (local2)
                    // type: String!
                    (local3)
                }
                @objc
                func optional() -> String? {
                }
                @objc
                func nonOptional() -> String {
                }
                @objc
                func unspecifiedOptional() -> String! {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    /// Tests that when resolving types of block expressions we expose the parameters
    /// for the block as intrinsics as well
    func testBlockInvocationArgumentIntrinsics() throws {
        try assertObjcParse(
            objc: """
            typedef void(^_Nonnull Callback)(NSInteger);
            
            @interface MyClass
            @property (nonnull) Callback callback;
            @end
            
            @implementation MyClass
            - (void)method {
                self.callback = ^(NSInteger arg) {
                    (arg);
                };
                // Test the intrinsic doesn't leak to outer scopes
                (arg);
            }
            @end
            """,
            swift: """
            typealias Callback = (Int) -> Void

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
                func method() {
                    // type: Callback
                    self.callback = { (arg: Int) -> Void in
                        // type: Int
                        (arg)
                    }
                    // type: <<error type>>
                    (arg)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    /// Testa that local variables declared within blocks are scoped within
    /// blocks only.
    func testBlockInvocationRetainsDefinedLocalsWithinScope() throws {
        try assertObjcParse(
            objc: """
            typedef void(^_Nonnull Callback)();
            
            @interface MyClass
            @property (nonnull) Callback callback;
            @end
            
            @implementation MyClass
            - (void)method {
                self.callback = ^() {
                    NSInteger local;
                    (local);
                };
                (local);
            }
            @end
            """,
            swift: """
            typealias Callback = () -> Void

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
                func method() {
                    // type: Callback
                    self.callback = { () -> Void in
                        var local: Int
                        // type: Int
                        (local)
                    }
                    // type: <<error type>>
                    (local)
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testCapturingLocalsInBlocksFromOuterScopes() throws {
        try assertObjcParse(
            objc: """
            typedef void(^_Nonnull Callback)();
            void takesBlock(void(^block)());
            
            @interface MyClass
            @property (nonnull) Callback callback;
            @end
            
            @implementation MyClass
            - (void)method {
                NSInteger local;
                self.callback = ^() {
                    (local);
                };
                [self takesBlock:^() {
                    (local);
                }];
                takesBlock(^{
                    (local);
                });
                (local);
            }
            - (void)takesBlock:(void(^)())block {
            }
            @end
            """,
            swift: """
            typealias Callback = () -> Void

            func takesBlock(_ block: (() -> Void)!) {
            }

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
                func method() {
                    var local: Int
                    // type: Callback
                    self.callback = { () -> Void in
                        // type: Int
                        (local)
                    }
                    // type: Void
                    self.takesBlock { () -> Void in
                        // type: Int
                        (local)
                    }
                    // type: <nil>
                    takesBlock { () -> Void in
                        // type: Int
                        (local)
                    }
                    // type: Int
                    (local)
                }
                @objc
                func takesBlock(_ block: (() -> Void)!) {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}
