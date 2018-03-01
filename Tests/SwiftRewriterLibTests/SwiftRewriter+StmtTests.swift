import XCTest

class SwiftRewriter_StmtTests: XCTestCase {
    func testTranslateSingleSelectorMessage() throws {
        try assertSingleStatement(
            objc: "[self thing];",
            swift: "self.thing()"
        )
    }
    
    func testTranslateTwoSelectorMessage() throws {
        try assertSingleStatement(
            objc: "[self thing:a b:c];",
            swift: "self.thing(a, b: c)"
        )
    }
    
    func testTranslateBinaryExpression() throws {
        try assertSingleStatement(
            objc: "10 + 26;",
            swift: "10 + 26"
        )
    }
    
    func testTranslateParenthesizedExpression() throws {
        try assertSingleStatement(
            objc: "((10 + 26) * (15 + 15));",
            swift: "((10 + 26) * (15 + 15))"
        )
    }
    
    func testTernaryExpression() throws {
        try assertSingleStatement(
            objc: "aValue ? 123 : 456;",
            swift: "aValue ? 123 : 456"
        )
        
        try assertSingleStatement(
            objc: "aNullableValue ?: anotherValue;",
            swift: "aNullableValue ?? anotherValue"
        )
    }
    
    func testMemberAccess() throws {
        try assertSingleStatement(
            objc: "self.member.subMember;",
            swift: "self.member.subMember"
        )
    }
    
    func testStringLiteral() throws {
        try assertSingleStatement(
            objc: "@\"literal abc\";",
            swift: "\"literal abc\""
        )
        
        try assertSingleStatement(
            objc: "@\"literal \\n abc\";",
            swift: "\"literal \\n abc\""
        )
    }
    
    func testFloatLiteral() throws {
        try assertSingleStatement(
            objc: "123.456e+99f;",
            swift: "123.456e+99"
        )
    }
    
    func testFreeFunctionCall() throws {
        try assertSingleStatement(
            objc: "aFunction();",
            swift: "aFunction()"
        )
        try assertSingleStatement(
            objc: "aFunction(123);",
            swift: "aFunction(123)"
        )
        try assertSingleStatement(
            objc: "aFunction(123, 456);",
            swift: "aFunction(123, 456)"
        )
    }
    
    func testSubscription() throws {
        try assertSingleStatement(
            objc: "aSubscriptable[1];",
            swift: "aSubscriptable[1]"
        )
        try assertSingleStatement(
            objc: "aDictionary[@\"key\"];",
            swift: "aDictionary[\"key\"]"
        )
    }
    
    func testPrefixAndPostfixIncrementAndDecrement() throws {
        try assertSingleStatement(
            objc: "value++;",
            swift: "value += 1"
        )
        try assertSingleStatement(
            objc: "value--;",
            swift: "value -= 1"
        )
        try assertSingleStatement(
            objc: "++value;",
            swift: "value += 1"
        )
        try assertSingleStatement(
            objc: "--value;",
            swift: "value -= 1"
        )
    }
    
    func testUnaryOperator() throws {
        try assertSingleStatement(
            objc: "-value;",
            swift: "-value"
        )
        try assertSingleStatement(
            objc: "+value;",
            swift: "+value"
        )
        try assertSingleStatement(
            objc: "!value;",
            swift: "!value"
        )
        try assertSingleStatement(
            objc: "!value;",
            swift: "!value"
        )
        try assertSingleStatement(
            objc: "~value;",
            swift: "~value"
        )
        try assertSingleStatement(
            objc: "&value;",
            swift: "&value"
        )
        try assertSingleStatement(
            objc: "*value;",
            swift: "*value"
        )
    }
    
    func testVarDeclaration() throws {
        try assertObjcParse(
            objc: "NSInteger myInt = 5;",
            swift: "var myInt: Int = 5"
        )
        try assertObjcParse(
            objc: "const NSInteger myInt = 5;",
            swift: "let myInt: Int = 5"
        )
        try assertObjcParse(
            objc: "NSInteger a = 5, b, c = 6;",
            swift: """
                var a: Int = 5
                var b: Int
                var c: Int = 6
                """
        )
        try assertSingleStatement(
            objc: "CGFloat x = [self offsetForDate:cell.startDate];",
            swift: "var x = self.offsetForDate(cell.startDate)"
        )
    }
    
    /// Tests __block specifier on local variable declaration
    func testParseBlockVarDeclaration() throws {
        try assertSingleStatement(
            objc: "__block id value;",
            swift: "var value: AnyObject!"
        )
    }
    
    /// Leaving Swift to infer the proper type of numeric types can be troublesome
    /// sometimes, as it may not get the correct Float/Integer types while inferring
    /// initial expressions.
    /// Aid the compiler by keeping the type patterns for int/float literals.
    func testKeepVarTypePatternsOnNumericTypes() throws {
        try assertSingleStatement(
            objc: "NSInteger x = 10;",
            swift: "var x: Int = 10"
        )
        try assertSingleStatement(
            objc: "NSUInteger x = 10;",
            swift: "var x: UInt = 10"
        )
        try assertSingleStatement(
            objc: "CGFloat x = 10;",
            swift: "var x: CGFloat = 10"
        )
        try assertSingleStatement(
            objc: "double x = 10;",
            swift: "var x: CDouble = 10"
        )
        // Should avoid omitting types for nil values, as well
        try assertSingleStatement(
            objc: "NSString *x = nil;",
            swift: "var x: String! = nil"
        )
        
        // Keep inferring on for literal-based expressions as well
        try assertSingleStatement(
            objc: "NSInteger x = 10 + 5;",
            swift: "var x: Int = 10 + 5"
        )
        try assertSingleStatement(
            objc: "NSUInteger x = 10 + 5;",
            swift: "var x: UInt = 10 + 5"
        )
        try assertSingleStatement(
            objc: "CGFloat x = 10 + 5.0;",
            swift: "var x: CGFloat = 10 + 5.0"
        )
        try assertSingleStatement(
            objc: "double x = 10 + 5.0;",
            swift: "var x: CDouble = 10 + 5.0"
        )
        
        // Type expressions from non-literal sources are not needed as they can
        // be inferred
        try assertSingleStatement(
            objc: "CGFloat x = self.frame.size.width;",
            swift: "var x = self.frame.size.width"
        )
        
        // No need to keep inferrence for Boolean or String types
        try assertSingleStatement(
            objc: "BOOL x = YES;",
            swift: "var x = true"
        )
        try assertSingleStatement(
            objc: "NSString *x = @\"A string\";",
            swift: "var x = \"A string\""
        )
    }
    
    func testArrayLiterals() throws {
        try assertSingleStatement(
            objc: "@[];",
            swift: "[]"
        )
        
        try assertSingleStatement(
            objc: "@[@\"a\", @\"b\"];",
            swift: "[\"a\", \"b\"]"
        )
    }
    
    func testDictionaryLiterals() throws {
        try assertSingleStatement(
            objc: "@{};",
            swift: "[:]"
        )
        
        try assertSingleStatement(
            objc: "@{@\"a\": @\"b\", @\"c\": @\"d\"};",
            swift: "[\"a\": \"b\", \"c\": \"d\"]"
        )
    }
    
    func testEmitTypeCast() throws {
        try assertSingleStatement(
            objc: "((NSInteger)aThing);",
            swift: "(aThing as? Int)"
        )
        
        try assertSingleStatement(
            objc: "(NSDictionary*)aThing;",
            swift: "aThing as? NSDictionary"
        )
    }
    
    func testEmitSizeOf() throws {
        try assertSingleStatement(
            objc: "sizeof(int)",
            swift: "MemoryLayout<CInt>.size"
        )
        try assertSingleStatement(
            objc: "sizeof(abc)",
            swift: "MemoryLayout.size(ofValue: abc)"
        )
    }
    
    func testSingleBlockArgument() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    self.doThing(a) { () -> Void in
                    }
                    self.doThing { () -> Void in
                    }
                }
            }
            """)
    }
    
    func testBlockLiteral() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                ^{ };
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    { () -> Void in
                    }
                }
            }
            """)
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                const void(^myBlock)() = ^{ };
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    let myBlock = { () -> Void in
                    }
                }
            }
            """)
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    let myBlock = { () -> Void in
                        self.doThing()
                    }
                }
            }
            """)
    }
    
    func testVarDeclarationOmitsTypeOnLocalWithInitialValue() throws {
        try assertObjcParse(
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
            
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    var local: Int = 5
                    let constLocal: Int = 5
                    var local2: Int
                    var localS1: Int = 5, localS2: Int
                }
            }
            """)
    }
    
    func testAssignmentOperation() throws {
        try assertSingleStatement(
            objc: "a = 5;", swift: "a = 5"
        )
        try assertSingleStatement(
            objc: "a += 5;", swift: "a += 5"
        )
        try assertSingleStatement(
            objc: "a -= 5;", swift: "a -= 5"
        )
        try assertSingleStatement(
            objc: "a /= 5;", swift: "a /= 5"
        )
        try assertSingleStatement(
            objc: "a *= 5;", swift: "a *= 5"
        )
    }
    
    func testIfStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testElseStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testIfElseStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testBracelessIfElseStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testBracelessIfWithinIf() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testSwitchStatement() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                switch(value) {
                case 0:
                    stmt();
                    break
                case 1:
                    break;
                }
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testSwitchStatementWithFallthroughCases() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testSwitchStatementAvoidFallthroghIfLastStatementIsUnconditionalJump() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testSwitchStatementWithCompoundStatementCases() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testWhileStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
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
    
    func testForStatement() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                for(NSInteger i = 0; i < 10; i++) {
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
                    }
                }
            }
            """
            )
    }
    
    func testSynchronizedStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    do {
                        let _lockTarget = self
                        objc_sync_enter(_lockTarget)
                        defer {
                            objc_sync_exit(_lockTarget)
                        }
                        stuff()
                    }
                }
            }
            """)
    }
    
    func testAutoreleasePoolStatement() throws {
        try assertObjcParse(
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
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    autoreleasepool { () -> Void in
                        stuff()
                    }
                }
            }
            """)
    }
    
    func testForInStatement() throws {
        try assertObjcParse(
            objc: """
            @implementation MyClass
            - (void)myMethod {
                for(NSObject *obj in anArray) {
                }
            }
            @end
            """,
            swift: """
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    for obj in anArray {
                    }
                }
            }
            """)
    }
    
    func testReturnStatement() throws {
        try assertSingleStatement(
            objc: "return;", swift: "return"
        )
        try assertSingleStatement(
            objc: "return 10;", swift: "return 10"
        )
    }
    
    func testContinueBreakStatements() throws {
        try assertSingleStatement(
            objc: "continue;", swift: "continue"
        )
        try assertSingleStatement(
            objc: "break;", swift: "break"
        )
    }
    
    private func assertSingleStatement(objc: String, swift: String, file: String = #file, line: Int = #line) throws {
        let objc = """
            @implementation MyClass
            - (void)myMethod {
                \(objc)
            }
            @end
            """
        let swift = """
            @objc
            class MyClass: NSObject {
                @objc
                func myMethod() {
                    \(swift)
                }
            }
            """
        
        try assertObjcParse(objc: objc, swift: swift, file: file, line: line)
    }
}
