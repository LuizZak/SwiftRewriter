import SwiftRewriterLib
import SwiftAST
import XCTest

/// Tests for some meta behavior of SwiftRewriter when handling `self` and general
/// type resolving results.
class SwiftRewriter_TypingTests: XCTestCase {
    
    /// Tests that the `self`/`super` identifier is properly assigned when resolving
    /// the final types of statements in a class
    func testSelfSuperTypeInInstanceMethodsPointsToSelfInstance() {
        assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            @end
            @implementation MyClass
            - (void)method {
                (self);
                (super);
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func method() {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    /// Tests that the `self` identifier used in a method class context is properly
    /// assigned to the class' metatype
    func testSelfSuperTypeInClassMethodsPointsToMetatype() {
        assertObjcParse(
            objc: """
            @interface MyClass: NSObject
            @end
            @interface MyClass
            @property (class, readonly) BOOL a;
            @property (readonly) BOOL b;
            @end
            @implementation MyClass
            + (BOOL)a {
                (self);
                (super);
            }
            - (BOOL)b {
                (self);
                (super);
            }
            + (void)classMethod {
                (self);
                (super);
            }
            // Here just to check the transpiler correctly switches between metatype
            // and instance type while iterating over methods to output
            - (void)instanceMethod {
                (self);
                (super);
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                static var a: Bool {
                    // type: MyClass.Type
                    self
                    // type: NSObject.Type
                    super
                }
                var b: Bool {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
            
                static func classMethod() {
                    // type: MyClass.Type
                    self
                    // type: NSObject.Type
                    super
                }
                func instanceMethod() {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testSelfSuperTypeInPropertySynthesizedGetterAndSetterBody() {
        assertObjcParse(
            objc: """
            @interface MyClass : NSObject
            @property BOOL value;
            @end
            
            @implementation MyClass
            - (void)setValue:(BOOL)newValue {
                (self);
                (super);
            }
            - (BOOL)value {
                (self);
                (super);
                return NO;
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                var value: Bool {
                    get {
                        // type: MyClass
                        self
                        // type: NSObject
                        super

                        return false
                    }
                    set {
                        // type: MyClass
                        self
                        // type: NSObject
                        super
                    }
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testSelfSuperInitInClassMethod() {
        assertObjcParse(
            objc: """
            @interface MyClass: NSObject // To inherit [self init] constructor
            @end
            
            @implementation MyClass
            + (void)method {
                [[self alloc] init];
                [[super alloc] init];
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                static func method() {
                    // type: MyClass
                    self.init()
                    // type: NSObject
                    super.init()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testSelfPropertyFetch() {
        assertObjcParse(
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
            class MyClass: NSObject {
                var aValue: Int = 0
            
                func method() {
                    // type: Int
                    self.aValue
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testMessageSelf() {
        assertObjcParse(
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
            class MyClass: NSObject {
                func method1() {
                    // type: Int
                    self.method2()
                }
                func method2() -> Int {
                    return 0
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testMessageClassSelf() {
        assertObjcParse(
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
            class MyClass: NSObject {
                static func method1() {
                    // type: Int
                    self.method2()
                }
                static func method2() -> Int {
                    return 0
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testCustomInitClass() {
        assertObjcParse(
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
            class A: NSObject {
                func method() {
                    // type: B
                    B(value: 0)
                }
            }
            class B: NSObject {
                init(value: Int) {
                    // type: Int
                    value
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsFromMethodParameter() {
        assertObjcParse(
            objc: """
            @implementation A
            - (void)method:(NSInteger)value {
                (value);
            }
            @end
            """,
            swift: """
            class A {
                func method(_ value: Int) {
                    // type: Int
                    value
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    func testIntrinsicsForSetterCustomNewValueName() {
        assertObjcParse(
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
            class A: NSObject {
                var value: Bool {
                    get {
                        return false
                    }
                    set(value) {
                        // type: Bool
                        value
                    }
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsForSetterWithDefaultNewValueName() {
        assertObjcParse(
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
            class A: NSObject {
                var value: Bool {
                    get {
                        return false
                    }
                    set {
                        // type: Bool
                        newValue
                    }
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsExposeClassInstanceProperties() {
        assertObjcParse(
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
            class A: NSObject {
                private var field: Int = 0
                var value: Bool = false
            
                func f1() {
                    // type: Bool
                    self.value
                    // type: Int
                    self.field
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testIntrinsicsExposeMethodParameters() {
        assertObjcParse(
            objc: """
            @implementation A
            - (void)f1:(A*)value {
                (value);
            }
            @end
            """,
            swift: """
            class A {
                func f1(_ value: A!) {
                    // type: A!
                    value
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testPropertyResolutionLooksThroughNullability() {
        // FIXME: Maybe it's desirable to infer as `Int!` instead?
        assertObjcParse(
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
            class A: NSObject {
                var prop: Int = 0
            
                func f1(_ value: A!) {
                    // type: Int
                    value.prop
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testVariableDeclarationCascadesTypeOfInitialExpression() {
        assertObjcParse(
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
            class A: NSObject {
                private var callback: (() -> Void)?
            
                func f1() {
                    // decl type: (() -> Void)!
                    // init type: (() -> Void)?
                    let _callback = self.callback
                    // type: Void?
                    _callback?()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testExpressionWithinBracelessIfStatement() {
        assertObjcParse(
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
            class A: NSObject {
                private var callback: (() -> Void)?
            
                func f1() {
                    // decl type: (() -> Void)!
                    // init type: (() -> Void)?
                    let _callback = self.callback
                    // type: Void?
                    _callback?()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testLookThroughProtocolConformances() {
        assertObjcParse(
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
            class A: NSObject {
                var b: NSObject?
            
                func method() {
                    // type: Bool?
                    b?.responds(to: Selector("abc:"))
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testChainedOptionalAccessMethodCall() {
        // With a (nonnull B*)method;
        assertObjcParse(
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
            class B: NSObject {
                func method() -> B {
                }
            }
            class A: NSObject {
                var b: B?
            
                func method() {
                    // type: B?
                    self.b?.method().method()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testChainedOptionalAccessMethodCall2() {
        // With a (nullable B*)method;
        assertObjcParse(
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
            class B: NSObject {
                func method() -> B? {
                }
            }
            class A: NSObject {
                var b: B?
            
                func method() {
                    // type: B?
                    self.b?.method()?.method()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testChainCallRespondsToSelector() {
        assertObjcParse(
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
            protocol B {
            }

            class A: NSObject {
                weak var b: B?
            
                func method() {
                    // type: Bool?
                    self.b?.responds(to: Selector("abc:"))

                    if self.b?.responds(to: Selector("abc:")) == true {
                    }
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testTypeLookupIntoComposedProtocols() {
        assertObjcParse(
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
            protocol A {
                var a: Bool { get set }
            }
            protocol B {
                var b: Int { get set }
            }

            class C: NSObject {
                var composed: (A & B)!
            
                func method() {
                    // type: (A & B)!
                    self.composed
                    // type: Bool?
                    self.composed.a
                    // type: Int?
                    self.composed.b
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testLocalVariableDeclarationInitializedTransmitsNullabilityFromRightHandSide() {
        assertObjcParse(
            objc: """
            @interface MyClass
            - (nullable NSString*)optional;
            - (nonnull NSString*)nonOptional;
            - (null_unspecified NSString*)unspecifiedOptional;
            - (NSString*)unspecifiedOptional;
            @end
            @implementation MyClass
            - (void)method {
                NSString *local1 = [self optional];
                NSString *local2 = [self nonOptional];
                NSString *local3 = [self unspecifiedOptional];
                NSString *local4 = @"Literal";
                (local1);
                (local2);
                (local3);
                (local4);
            }
            @end
            """,
            swift: """
            class MyClass {
                func method() {
                    // decl type: String!
                    // init type: String?
                    let local1 = self.optional()
                    // decl type: String
                    // init type: String
                    let local2 = self.nonOptional()
                    // decl type: String!
                    // init type: String!
                    let local3 = self.unspecifiedOptional()
                    // decl type: String
                    // init type: String
                    let local4 = "Literal"
                    // type: String?
                    local1
                    // type: String
                    local2
                    // type: String?
                    local3
                    // type: String
                    local4
                }
                func optional() -> String? {
                }
                func nonOptional() -> String {
                }
                func unspecifiedOptional() -> String! {
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testLocalVariableDeclarationInitializedTransmitsNullabilityFromRightHandSideWithSubclassing() {
        assertObjcParse(
            objc: """
            @interface A
            @end
            @interface B: A
            @end
            @interface MyClass
            - (nullable B*)optional;
            - (nonnull B*)nonOptional;
            - (null_unspecified B*)unspecifiedOptional;
            - (B*)unspecifiedOptional;
            @end
            
            @implementation MyClass
            - (void)method {
                A *local1 = [self optional];
                A *local2 = [self nonOptional];
                A *local3 = [self unspecifiedOptional];
                (local1);
                (local2);
                (local3);
            }
            @end
            """,
            swift: """
            class A {
            }
            class B: A {
            }
            class MyClass {
                func method() {
                    // decl type: A!
                    // init type: B?
                    let local1 = self.optional()
                    // decl type: A
                    // init type: B
                    let local2 = self.nonOptional()
                    // decl type: A!
                    // init type: B!
                    let local3 = self.unspecifiedOptional()
                    // type: A?
                    local1
                    // type: A
                    local2
                    // type: A?
                    local3
                }
                func optional() -> B? {
                }
                func nonOptional() -> B {
                }
                func unspecifiedOptional() -> B! {
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    /// Tests that when resolving types of block expressions we expose the parameters
    /// for the block as intrinsics as well
    func testBlockInvocationArgumentIntrinsics() {
        assertObjcParse(
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

            class MyClass {
                var callback: Callback
            
                func method() {
                    // type: Callback
                    self.callback = { (arg: Int) -> Void in
                        // type: Int
                        arg
                    }
                    // type: <<error type>>
                    arg
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    /// Test that local variables declared within blocks are scoped within
    /// blocks only.
    func testBlockInvocationRetainsDefinedLocalsWithinScope() {
        assertObjcParse(
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

            class MyClass {
                var callback: Callback
            
                func method() {
                    // type: Callback
                    self.callback = { () -> Void in
                        // decl type: Int
                        let local: Int
                        // type: Int
                        local
                    }
                    // type: <<error type>>
                    local
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testCapturingLocalsInBlocksFromOuterScopes() {
        assertObjcParse(
            objc: """
            typedef void(^_Nonnull Callback)();
            NSString *takesBlock(void(^block)());
            
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

            func takesBlock(_ block: (() -> Void)!) -> String! {
            }

            class MyClass {
                var callback: Callback
            
                func method() {
                    // decl type: Int
                    let local: Int
                    // type: Callback
                    self.callback = { () -> Void in
                        // type: Int
                        local
                    }
                    // type: Void
                    self.takesBlock { () -> Void in
                        // type: Int
                        local
                    }
                    // type: String!
                    takesBlock { () -> Void in
                        // type: Int
                        local
                    }
                    // type: Int
                    local
                }
                func takesBlock(_ block: (() -> Void)!) {
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testAssignImplicitlyUnwrappedOptionalToLocalVariableEscalatesToOptional() {
        assertObjcParse(
            objc: """
            @interface A
            - (A*)other;
            @end
            @implementation A
            - (void)f1 {
                A *a = [self other];
                (a);
            }
            @end
            """,
            swift: """
            class A {
                func f1() {
                    // decl type: A!
                    // init type: A!
                    let a = self.other()
                    // type: A?
                    a
                }
                func other() -> A! {
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testCreateNonOptionalLocalsWhenRHSInitializerIsNonOptional() {
        assertObjcParse(
            objc: """
            @interface A
            - (nonnull A*)other;
            @end
            @implementation A
            - (void)f1 {
                A *a = [self other];
                (a);
            }
            @end
            """,
            swift: """
            class A {
                func f1() {
                    // decl type: A
                    // init type: A
                    let a = self.other()
                    // type: A
                    a
                }
                func other() -> A {
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testVisibilityOfGlobalElements() {
        assertObjcParse(
            objc: """
            NSInteger global;
            void globalFunc();
            
            @implementation A
            - (void)f1 {
                (global);
                globalFunc();
            }
            @end
            """,
            swift: """
            var global: Int
            
            func globalFunc() {
            }
            
            class A {
                func f1() {
                    // type: Int
                    global
                    // type: Void
                    globalFunc()
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testOutOfOrderTypeResolving() {
        assertObjcParse(
            objc: """
            @implementation A (B)
            - (void)f1 {
                (self.window.bounds);
            }
            @end
            
            @interface A : UIView
            @end
            """,
            swift: """
            class A: UIView {
            }

            // MARK: - B
            extension A {
                func f1() {
                    // type: CGRect?
                    self.window?.bounds
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testTypingInGlobalFunction() {
        assertObjcParse(
            objc: """
            void global() {
                [[A alloc] init];
            }
            
            @interface A : UIView
            @end
            """,
            swift: """
            func global() {
                // type: A
                A()
            }
            
            class A: UIView {
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testExtensionOfGlobalClass() {
        assertObjcParse(
            objc: """
            @interface A : UIView
            @end
            
            @implementation A
            - (void)method {
                (self.window);
            }
            @end
            
            @interface UIView (Category)
            @end
            """,
            swift: """
            class A: UIView {
                func method() {
                    // type: UIWindow?
                    self.window
                }
            }

            // MARK: - Category
            extension UIView {
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testForStatementIterator() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                for(NSInteger i = 0; i < 10; i++) {
                    (i);
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    for i in 0..<10 {
                        // type: Int
                        i
                    }
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testOverloadResolution() {
        assertObjcParse(
            objc: """
            @interface A : UIView
            @property (nullable) UIView *a;
            @end
            
            @implementation A
            - (void)method {
                ([self convertRect:CGRectZero toView:nil]);
                ([self convertPoint:CGPointZero toView:nil]);
                ([self convertRect:a.frame toView:nil]);
                ([self convertPoint:a.center toView:nil]);
                ([self convertRect:a.frame toView:a]);
                ([self convertPoint:a.center toView:a]);
            }
            @end
            """,
            swift: """
            class A: UIView {
                var a: UIView?
            
                func method() {
                    // type: CGRect
                    self.convert(CGRect.zero, to: nil)
                    // type: CGPoint
                    self.convert(CGPoint.zero, to: nil)
                    // type: CGRect
                    self.convert(a?.frame ?? CGRect(), to: nil)
                    // type: CGPoint
                    self.convert(a?.center ?? CGPoint(), to: nil)
                    // type: CGRect
                    self.convert(a?.frame ?? CGRect(), to: a)
                    // type: CGPoint
                    self.convert(a?.center ?? CGPoint(), to: a)
                }
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testTypeLookupInFoundationType() {
        assertObjcParse(
            objc: """
            void test() {
                NSMutableArray *array = [NSMutableArray array];
                NSObject *object = array;
                [array addObject:object];
            }
            """,
            swift: """
            func test() {
                // decl type: NSMutableArray
                // init type: NSMutableArray
                let array = NSMutableArray()
                // decl type: NSObject
                // init type: NSMutableArray
                let object = array
                // type: Void
                array.add(object)
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testCastTyping() {
        assertObjcParse(
            objc: """
            void test() {
                ((NSObject*)[[UIView alloc] init]).description;
            }
            """,
            swift: """
            func test() {
                // type: String
                (UIView() as NSObject).description
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testCLibOverloadResolution() {
        assertObjcParse(
            objc: """
            void test() {
                CGFloat f = 0;
                floorf(f);
            }
            """,
            swift: """
            func test() {
                // decl type: CGFloat
                // init type: Int
                let f: CGFloat = 0
                // type: CGFloat
                floor(f)
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    /// Verifies that deeply-nested transformations are properly executed and
    /// resulting expressions match expected type.
    func testRewriteDeepNestedTransformations() {
        // Here, [[UIColor lightGrayColor] colorWithAlphaComponent:0.2] features
        // two deep transformations:
        // [UIColor lightGrayColor] -> UIColor.lightGray
        // [<exp> colorWithAlphaComponent:] -> <exp>.withAlphaComponent()
        // These should be properly executed and the result be of the expected
        // UIColor type.
        assertObjcParse(
            objc: """
            void test() {
                [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
            }
            """,
            swift: """
            func test() {
                // type: UIColor
                UIColor.lightGray.withAlphaComponent(0.2)
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testOptionalProtocolInvocationOptionalAccess() {
        assertObjcParse(
            objc: """
            @protocol Protocol <NSObject>
            @optional
            - (BOOL)method;
            @end
            
            void test() {
                id<Protocol> prot;
                [prot method];
                if([prot method]) {
                }
            }
            """,
            swift: """
            func test() {
                // decl type: Protocol!
                let prot: Protocol!
                // type: Bool?
                prot.method?()
            
                if prot.method?() == true {
                }
            }
            
            @objc
            protocol Protocol: NSObjectProtocol {
                @objc
                optional func method() -> Bool
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
    
    func testBasicOverloadResolution() {
        assertObjcParse(
            objc: """
            void test() {
                CGFloat cgFloat = 0;
                int cInt = 0;
                NSInteger nsInteger = 0;
                max(0, cgFloat);
                max(0, cInt);
                max(0, nsInteger);
                max(0, 0);
                max(0.0, 0); // FIXME: Result is currently 'CGFloat', but should be 'Double'
            }
            """,
            swift: """
            func test() {
                // decl type: CGFloat
                // init type: Int
                let cgFloat: CGFloat = 0
                // decl type: CInt
                // init type: CInt
                let cInt: CInt = 0
                // decl type: Int
                // init type: Int
                let nsInteger = 0
                // type: CGFloat
                max(0, cgFloat)
                // type: CInt
                max(0, cInt)
                // type: Int
                max(0, nsInteger)
                // type: Int
                max(0, 0)
                // type: CGFloat
                max(0.0, 0)
            }
            """,
            options: SwiftSyntaxOptions(outputExpressionTypes: true))
    }
}
