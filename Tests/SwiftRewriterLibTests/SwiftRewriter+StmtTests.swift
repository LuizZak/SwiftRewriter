import XCTest

class SwiftRewriter_StmtTests: XCTestCase {
    func testTranslateSingleSelectorMessage() {
        assertSingleStatement(
            objc: "[self thing];",
            swift: "self.thing()"
        )
    }
    
    func testTranslateTwoSelectorMessage() {
        assertSingleStatement(
            objc: "[self thing:a b:c];",
            swift: "self.thing(a, b: c)"
        )
    }
    
    func testTranslateBinaryExpression() {
        assertSingleStatement(
            objc: "10 + 26;",
            swift: "10 + 26"
        )
    }
    
    func testTranslateChainedBinaryExpression() {
        assertSingleStatement(
            objc: "10 + 26 + 42;",
            swift: "10 + 26 + 42"
        )
    }
    
    func testTranslateParenthesizedExpression() {
        assertSingleStatement(
            objc: "((10 + 26) * (15 + 15));",
            swift: "(10 + 26) * (15 + 15)"
        )
    }
    
    func testTernaryExpression() {
        assertSingleStatement(
            objc: "aValue ? 123 : 456;",
            swift: "aValue ? 123 : 456"
        )
        
        assertSingleStatement(
            objc: "aNullableValue ?: anotherValue;",
            swift: "aNullableValue ?? anotherValue"
        )
    }
    
    func testMemberAccess() {
        assertSingleStatement(
            objc: "self.member.subMember;",
            swift: "self.member.subMember"
        )
    }
    
    func testStringLiteral() {
        assertSingleStatement(
            objc: "@\"literal abc\";",
            swift: "\"literal abc\""
        )
        
        assertSingleStatement(
            objc: "@\"literal \\n abc\";",
            swift: "\"literal \\n abc\""
        )
    }
    
    func testFloatLiteral() {
        assertSingleStatement(
            objc: "123.456e+99f;",
            swift: "123.456e+99"
        )
    }
    
    func testFreeFunctionCall() {
        assertSingleStatement(
            objc: "aFunction();",
            swift: "aFunction()"
        )
        assertSingleStatement(
            objc: "aFunction(123);",
            swift: "aFunction(123)"
        )
        assertSingleStatement(
            objc: "aFunction(123, 456);",
            swift: "aFunction(123, 456)"
        )
    }
    
    func testSubscription() {
        assertSingleStatement(
            objc: "aSubscriptable[1];",
            swift: "aSubscriptable[1]"
        )
        assertSingleStatement(
            objc: "aDictionary[@\"key\"];",
            swift: "aDictionary[\"key\"]"
        )
    }
    
    func testPrefixAndPostfixIncrementAndDecrement() {
        assertSingleStatement(
            objc: "value++;",
            swift: "value += 1"
        )
        assertSingleStatement(
            objc: "value--;",
            swift: "value -= 1"
        )
        assertSingleStatement(
            objc: "++value;",
            swift: "value += 1"
        )
        assertSingleStatement(
            objc: "--value;",
            swift: "value -= 1"
        )
    }
    
    func testUnaryOperator() {
        assertSingleStatement(
            objc: "-value;",
            swift: "-value"
        )
        assertSingleStatement(
            objc: "+value;",
            swift: "+value"
        )
        assertSingleStatement(
            objc: "!value;",
            swift: "!value"
        )
        assertSingleStatement(
            objc: "!value;",
            swift: "!value"
        )
        assertSingleStatement(
            objc: "~value;",
            swift: "~value"
        )
        assertSingleStatement(
            objc: "&value;",
            swift: "&value"
        )
        assertSingleStatement(
            objc: "*value;",
            swift: "*value"
        )
    }
    
    func testVarDeclaration() {
        assertObjcParse(
            objc: "NSInteger myInt = 5;",
            swift: "var myInt: Int = 5"
        )
        assertObjcParse(
            objc: "const NSInteger myInt = 5;",
            swift: "let myInt: Int = 5"
        )
        assertSingleStatement(
            objc: "CGFloat x = [self offsetForDate:cell.startDate];",
            swift: "let x: CGFloat = self.offsetForDate(cell.startDate)"
        )
    }
    
    func testMultipleVarDeclarationInSameStatement() {
        assertObjcParse(
            objc: "NSInteger a = 5, b, c = 6;",
            swift: """
                var a: Int = 5
                var b: Int
                var c: Int = 6
                """)
    }
    
    func testWeakModifier() {
        assertSingleStatement(
            objc: """
            __weak id value;
            """,
            swift: """
            weak var value: AnyObject?
            """)
    }
    
    /// Tests __block specifier on local variable declaration
    func testParseBlockVarDeclaration() {
        assertSingleStatement(
            objc: "__block id value;",
            swift: "let value: AnyObject!"
        )
    }
    
    /// Tests __unused specifier on local variable declaration
    func testParseUnusedVarDeclaration() {
        assertSingleStatement(
            objc: "__unused id value;",
            swift: "let value: AnyObject!"
        )
    }
    
    /// Leaving Swift to infer the proper type of numeric types can be troublesome
    /// sometimes, as it may not get the correct Float/Integer types while inferring
    /// initial expressions.
    /// Aid the compiler by keeping the type patterns for int/float literals.
    func testKeepVarTypePatternsOnNumericTypes() {
        // Integer literals default to `Int` in Swift, so no need to repeat type
        // signatures
        assertSingleStatement(
            objc: "NSInteger x = 10;",
            swift: "let x = 10"
        )
        assertSingleStatement(
            objc: "NSUInteger x = 10;",
            swift: "let x: UInt = 10"
        )
        assertSingleStatement(
            objc: "CGFloat x = 10;",
            swift: "let x: CGFloat = 10"
        )
        assertSingleStatement(
            objc: "double x = 10;",
            swift: "let x: CDouble = 10"
        )
        // Should emit types for nil literals, as well
        assertSingleStatement(
            objc: "NSString *x = nil;",
            swift: "let x: String! = nil"
        )
        
        // Keep inferring on for literal-based expressions as well
        assertSingleStatement(
            objc: "NSInteger x = 10 + 5;",
            swift: "let x = 10 + 5"
        )
        assertSingleStatement(
            objc: "NSUInteger x = 10 + 5;",
            swift: "let x: UInt = 10 + 5"
        )
        assertSingleStatement(
            objc: "CGFloat x = 10 + 5.0;",
            swift: "let x: CGFloat = 10 + 5.0"
        )
        assertSingleStatement(
            objc: "double x = 10 + 5.0;",
            swift: "let x: CDouble = 10 + 5.0"
        )
        
        // Don't remove type signature from error-typed initializer expressions
        assertSingleStatement(
            objc: "NSInteger x = nonExistent;",
            swift: "let x: Int = nonExistent"
        )
        
        // Type expressions from non-literal sources are not needed as they can
        // be inferred
        assertSingleStatement(
            objc: "CGFloat x = self.frame.size.width;",
            swift: "let x = self.frame.size.width"
        )

        // Initializers from expressions with non-literal operands should also
        // omit type
        assertSingleStatement(
            objc: "CGFloat x = self.frame.size.width - 1;",
            swift: "let x = self.frame.size.width - 1"
        )

        // No need to keep inference for Boolean or String types
        assertSingleStatement(
            objc: "BOOL x = YES;",
            swift: "let x = true"
        )
        assertSingleStatement(
            objc: "NSString *x = @\"A string\";",
            swift: "let x = \"A string\""
        )
    }
    
    // An extension of the test above (testKeepVarTypePatternsOnNumericTypes)
    func testKeepVarTypePatternsOnUpcastings() {
        // Should emit types for upcasts
        assertSingleStatement(
            objc: "NSObject *x = self; x = self;",
            swift: "var x: NSObject = self\n\n        x = self"
        )
        // For literals, no need to emit type signature as the expression won't
        // change values, so there's no later potential re-assignments of other
        // values that are supertypes of the original assignment value.
        assertSingleStatement(
            objc: "NSObject *x = self;",
            swift: "let x = self"
        )
    }
    
    func testArrayLiterals() {
        assertSingleStatement(
            objc: "@[];",
            swift: "[]"
        )
        
        assertSingleStatement(
            objc: "@[@\"a\", @\"b\"];",
            swift: "[\"a\", \"b\"]"
        )
    }
    
    func testDictionaryLiterals() {
        assertSingleStatement(
            objc: "@{};",
            swift: "[:]"
        )
        
        assertSingleStatement(
            objc: "@{@\"a\": @\"b\", @\"c\": @\"d\"};",
            swift: "[\"a\": \"b\", \"c\": \"d\"]"
        )
    }
    
    func testEmitTypeCast() {
//        assertSingleStatement(
//            objc: "((UIButtonType)aThing);",
//            swift: "aThing as? UIButtonType"
//        )
        
        assertSingleStatement(
            objc: "(NSDictionary*)aThing;",
            swift: "aThing as? NSDictionary"
        )
    }
    
    func testEmitSizeOf() {
        assertSingleStatement(
            objc: "sizeof(int);",
            swift: "MemoryLayout<CInt>.size"
        )
        assertSingleStatement(
            objc: "sizeof(abc);",
            swift: "MemoryLayout.size(ofValue: abc)"
        )
    }
    
    func testEmitSizeOfForKnownTypes() {
        assertObjcParse(
            objc: """
            typedef struct {
                int field;
            } VertexObject;
            
            @implementation MyClass
            - (void)myMethod {
                sizeof(VertexObject);
            }
            @end
            """,
            swift: """
            struct VertexObject {
                var field: CInt

                init() {
                    field = 0
                }
                init(field: CInt) {
                    self.field = field
                }
            }

            class MyClass {
                func myMethod() {
                    MemoryLayout<VertexObject>.size
                }
            }
            """)
    }
    
    func testSingleBlockArgument() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                [self doThing:a b:^{
                }];
                [self doThing:^{
                }];
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    self.doThing(a) { () -> Void in
                    }
                    self.doThing { () -> Void in
                    }
                }
            }
            """)
    }
    
    func testBlockLiteral() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                ^{ };
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    { () -> Void in
                    }
                }
            }
            """)
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                const void(^myBlock)() = ^{ };
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let myBlock: () -> Void = {
                    }
                }
            }
            """)
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                const void(^myBlock)() = ^{
                    [self doThing];
                };
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let myBlock: () -> Void = {
                        self.doThing()
                    }
                }
            }
            """)
    }
    
    func testVarDeclarationOmitsTypeOnLocalWithInitialValueMatchingLiteralType() {
        assertObjcParse(
            objc: """
            NSInteger myInt;
            NSInteger myInt2 = 5;
            @implementation MyClass
            - (void)myMethod {
                NSInteger local = 5;
                const NSInteger constLocal = 5;
                NSInteger local2;
                NSInteger localS1 = 5, localS2;
            }
            @end
            """,
            swift: """
            var myInt: Int
            var myInt2: Int = 5
            
            class MyClass {
                func myMethod() {
                    let local = 5
                    let constLocal = 5
                    let local2: Int
                    let localS1 = 5, localS2: Int
                }
            }
            """)
    }
    
    func testAssignmentOperation() {
        assertSingleStatement(
            objc: "a = 5;", swift: "a = 5"
        )
        assertSingleStatement(
            objc: "a += 5;", swift: "a += 5"
        )
        assertSingleStatement(
            objc: "a -= 5;", swift: "a -= 5"
        )
        assertSingleStatement(
            objc: "a /= 5;", swift: "a /= 5"
        )
        assertSingleStatement(
            objc: "a *= 5;", swift: "a *= 5"
        )
    }
    
    func testIfStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if(true) {
                    stmt(abc);
                }
                if(true)
                    stmt();
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if true {
                        stmt(abc)
                    }
            
                    if true {
                        stmt()
                    }
                }
            }
            """)
    }
    
    func testElseStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if(true) {
                    stmt1();
                } else {
                    stmt2();
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if true {
                        stmt1()
                    } else {
                        stmt2()
                    }
                }
            }
            """)
    }
    
    func testIfElseStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if(true) {
                    stmt1();
                } else if(true) {
                    stmt2();
                } else {
                    stmt3();
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if true {
                        stmt1()
                    } else if true {
                        stmt2()
                    } else {
                        stmt3()
                    }
                }
            }
            """)
    }
    
    func testBracelessIfElseStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if(true)
                    stmt1();
                else if(true)
                    stmt2();
                else
                    stmt3();
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if true {
                        stmt1()
                    } else if true {
                        stmt2()
                    } else {
                        stmt3()
                    }
                }
            }
            """)
    }
    
    func testBracelessIfWithinIf() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if(true) {
                    if(true)
                        print(10);
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if true {
                        if true {
                            print(10)
                        }
                    }
                }
            }
            """)
    }
    
    func testIfStatementWithExpressions() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                if (a -= 10, true) {
                    print(10);
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    if ({
                        a -= 10

                        return true
                    })() {
                        print(10)
                    }
                }
            }
            """)
    }
    
    func testSwitchStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                switch(value) {
                case 0:
                    stmt();
                    break;
                case 1:
                    break;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    switch value {
                    case 0:
                        stmt()
                    case 1:
                        break
                    default:
                        break
                    }
                }
            }
            """)
    }
    
    func testSwitchStatementWithFallthroughCases() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                switch(value) {
                case 0:
                    stmt();
                case 1:
                    otherStmt();
                    break;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    switch value {
                    case 0:
                        stmt()

                        fallthrough
                    case 1:
                        otherStmt()
                    default:
                        break
                    }
                }
            }
            """)
    }
    
    func testSwitchStatementAvoidFallthroghIfLastStatementIsUnconditionalJump() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                switch(value) {
                case 0:
                    return stmt();
                case 1:
                    continue;
                case 2:
                    otherStmt();
                    break;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    switch value {
                    case 0:
                        return stmt()
                    case 1:
                        continue
                    case 2:
                        otherStmt()
                    default:
                        break
                    }
                }
            }
            """)
    }
    
    func testSwitchStatementWithCompoundStatementCases() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                switch(value) {
                case 0: {
                    stmt();
                    break;
                }
                case 1:
                    otherStmt();
                    break;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    switch value {
                    case 0:
                        stmt()
                    case 1:
                        otherStmt()
                    default:
                        break
                    }
                }
            }
            """)
    }
    
    func testWhileStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                while(true) {
                    stmt();
                }
                while(true)
                    stmt();
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    while true {
                        stmt()
                    }

                    while true {
                        stmt()
                    }
                }
            }
            """)
    }
    
    func testForStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                for(NSInteger i = 0; i < 10; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    for i in 0..<10 {
                    }
                }
            }
            """
        )
    }
    
    func testForStatementWithNonLiteralCount() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                const NSInteger count = 5;
                for(NSInteger i = 0; i < count; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let count = 5

                    for i in 0..<count {
                    }
                }
            }
            """
        )
    }
    
    func testForStatementWithNonConstantCount() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                NSInteger count = 5;
                for(NSInteger i = 0; i < count; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let count = 5

                    for i in 0..<count {
                    }
                }
            }
            """
        )
    }
    
    func testForStatementWithArrayCount() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                NSArray *array = @[];
                for(NSInteger i = 0; i < array.count; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let array = []

                    for i in 0..<array.count {
                    }
                }
            }
            """
        )
    }
    
    func testForStatementWithNonConstantCountModifiedWithinLoop() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                NSInteger count = 5;
                for(NSInteger i = 0; i < count; i++) {
                    count = 0;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    var count = 5
                    var i = 0

                    while i < count {
                        defer {
                            i += 1
                        }

                        count = 0
                    }
                }
            }
            """
        )
    }
    
    func testForStatementWithNonInitializerStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                NSInteger count = 5;
                for(i = 0; i < count; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let count = 5

                    i = 0

                    while i < count {
                        defer {
                            i += 1
                        }
                    }
                }
            }
            """
        )
    }
    
    func testDoWhileStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                do {
                    stmt();
                } while(true);
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    repeat {
                        stmt()
                    } while true
                }
            }
            """
        )
    }
    
    func testSynchronizedStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                @synchronized(self) {
                    stuff();
                }
                
                otherStuff();
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    do {
                        let _lockTarget = self
                        objc_sync_enter(_lockTarget)

                        defer {
                            objc_sync_exit(_lockTarget)
                        }

                        stuff()
                    }

                    otherStuff()
                }
            }
            """)
    }
    
    func testSingleSynchronizedStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                @synchronized(self) {
                    stuff();
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    let _lockTarget = self

                    objc_sync_enter(_lockTarget)

                    defer {
                        objc_sync_exit(_lockTarget)
                    }

                    stuff()
                }
            }
            """)
    }
    
    func testAutoreleasePoolStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                @autoreleasepool {
                    stuff();
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    autoreleasepool { () -> Void in
                        stuff()
                    }
                }
            }
            """)
    }
    
    func testForInStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                for(NSObject *obj in anArray) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    for obj in anArray {
                    }
                }
            }
            """)
    }
    
    func testReturnStatement() {
        assertSingleStatement(
            objc: "return;", swift: "return"
        )
        assertSingleStatement(
            objc: "return 10;", swift: "return 10"
        )
    }
    
    func testContinueBreakStatements() {
        assertSingleStatement(
            objc: "continue;", swift: "continue"
        )
        assertSingleStatement(
            objc: "break;", swift: "break"
        )
    }
    
    func testLabeledStatement() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                label:
                if (true) {
                }
                label2:
                if (true) {
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    label:
                    if true {
                    }

                    label2:
                    if true {
                    }
                }
            }
            """)
    }
    
    func testLabeledStatementNested() {
        assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                label:
                {
                    if (true) {
                    }
                    return;
                }
            }
            @end
            """,
            swift: """
            class MyClass {
                func myMethod() {
                    label:
                    if true {
                    }

                    return
                }
            }
            """)
    }
}

private extension SwiftRewriter_StmtTests {
    func assertSingleStatement(objc: String, swift: String, file: String = #file, line: Int = #line) {
        let objc = """
            @implementation MyClass: UIView
            - (void)myMethod {
                \(objc)
            }
            @end
            """
        let swift = """
            class MyClass: UIView {
                func myMethod() {
                    \(swift)
                }
            }
            """
        
        assertObjcParse(objc: objc, swift: swift, file: file, line: line)
    }
}
