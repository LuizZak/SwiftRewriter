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
            @objc
            class MyClass: NSObject {
                @objc
                func method() {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class MyClass: NSObject {
                @objc static var a: Bool {
                    // type: MyClass.Type
                    self
                    // type: NSObject.Type
                    super
                }
                @objc var b: Bool {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
                
                @objc
                static func classMethod() {
                    // type: MyClass.Type
                    self
                    // type: NSObject.Type
                    super
                }
                @objc
                func instanceMethod() {
                    // type: MyClass
                    self
                    // type: NSObject
                    super
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class MyClass: NSObject {
                @objc var value: Bool {
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
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class MyClass: NSObject {
                @objc
                static func method() {
                    // type: MyClass
                    self.init()
                    // type: NSObject
                    super.init()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
                    value
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc
                func method(_ value: Int) {
                    // type: Int
                    value
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc var value: Bool {
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
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc var value: Bool {
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
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                private var field: Int = 0
                @objc var value: Bool = false
                
                @objc
                func f1() {
                    // type: Bool
                    self.value
                    // type: Int
                    self.field
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc
                func f1(_ value: A!) {
                    // type: A!
                    value
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testPropertyResolutionLooksThroughNullability() {
        // FIXME: Maybe it's desireable to infer as `Int!` instead?
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
            @objc
            class A: NSObject {
                @objc var prop: Int = 0
                
                @objc
                func f1(_ value: A!) {
                    // type: Int
                    value.prop
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                private var callback: (() -> Void)?
                
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
            @objc
            class A: NSObject {
                private var callback: (() -> Void)?
                
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
            @objc
            class A: NSObject {
                @objc var b: NSObject?
                
                @objc
                func method() {
                    // type: Bool?
                    b?.responds(to: Selector("abc:"))
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class B: NSObject {
                @objc
                func method() -> B {
                }
            }
            @objc
            class A: NSObject {
                @objc var b: B?
                
                @objc
                func method() {
                    // type: B?
                    self.b?.method().method()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class B: NSObject {
                @objc
                func method() -> B? {
                }
            }
            @objc
            class A: NSObject {
                @objc var b: B?
                
                @objc
                func method() {
                    // type: B?
                    self.b?.method()?.method()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            protocol B: NSObjectProtocol {
            }

            @objc
            class A: NSObject {
                @objc weak var b: B?
                
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
                @objc var composed: (A & B)!
                
                @objc
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
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    func testLocalVariableDeclarationInitializedTransmitsNullabilityFromRightHandSide() {
        assertObjcParse(
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
                    local1
                    // type: String
                    local2
                    // type: String?
                    local3
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

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
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
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
    
    /// Testa that local variables declared within blocks are scoped within
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

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
                func method() {
                    // type: Callback
                    self.callback = { () -> Void in
                        var local: Int
                        // type: Int
                        local
                    }
                    // type: <<error type>>
                    local
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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

            @objc
            class MyClass: NSObject {
                @objc var callback: Callback
                
                @objc
                func method() {
                    var local: Int
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
                @objc
                func takesBlock(_ block: (() -> Void)!) {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc
                func f1() {
                    var a = self.other()
                    // type: A?
                    a
                }
                @objc
                func other() -> A! {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: NSObject {
                @objc
                func f1() {
                    var a = self.other()
                    // type: A
                    a
                }
                @objc
                func other() -> A {
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            
            @objc
            class A: NSObject {
                @objc
                func f1() {
                    // type: Int
                    global
                    // type: Void
                    globalFunc()
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: UIView {
            }

            // MARK: - B
            @objc
            extension A {
                @objc
                func f1() {
                    // type: CGRect?
                    self.window?.bounds
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            
            @objc
            class A: UIView {
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: UIView {
                @objc
                func method() {
                    // type: UIWindow?
                    self.window
                }
            }

            // MARK: - Category
            @objc
            extension UIView {
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    for i in 0..<10 {
                        // type: Int
                        i
                    }
                }
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
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
            @objc
            class A: UIView {
                @objc var a: UIView?
                
                @objc
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
            options: ASTWriterOptions(outputExpressionTypes: true))
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
                var array = NSMutableArray()
                var object = array
                // type: Void
                array.add(object)
            }
            """,
            options: ASTWriterOptions(outputExpressionTypes: true))
    }
}
