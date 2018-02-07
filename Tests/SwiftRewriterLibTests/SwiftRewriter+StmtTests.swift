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
            swift: "value++"
        )
        try assertSingleStatement(
            objc: "value--;",
            swift: "value--"
        )
        try assertSingleStatement(
            objc: "++value;",
            swift: "++value"
        )
        try assertSingleStatement(
            objc: "--value;",
            swift: "--value"
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
        try assertSingleStatement(
            objc: "NSInteger myInt = 5;",
            swift: "var myInt: Int = 5"
        )
        try assertSingleStatement(
            objc: "const NSInteger myInt = 5;",
            swift: "let myInt: Int = 5"
        )
        try assertSingleStatement(
            objc: "NSInteger a = 5, b, c = 6;",
            swift: "var a: Int = 5, b: Int, c: Int = 6"
        )
        try assertSingleStatement(
            objc: "CGFloat x = [self offsetForDate:cell.startDate];",
            swift: "var x: CGFloat = self.offsetForDate(cell.startDate)"
        )
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
                }
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func myMethod() {
                    if(true) {
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
                }
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func myMethod() {
                    while(true) {
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
                for(int i = 0; i < 10; i++) {
                }
            }
            @end
            """,
            swift: """
            class MyClass: NSObject {
                func myMethod() {
                    for i in 0..<10 {
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
    
    private func assertSingleStatement(objc: String, swift: String, file: String = #file, line: Int = #line) throws {
        let objc = """
            @implementation MyClass
            - (void)myMethod {
                \(objc)
            }
            @end
            """
        let swift = """
            class MyClass: NSObject {
                func myMethod() {
                    \(swift)
                }
            }
            """
        
        try assertObjcParse(objc: objc, swift: swift, file: file, line: line)
    }
}
