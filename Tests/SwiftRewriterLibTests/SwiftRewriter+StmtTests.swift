import XCTest

class SwiftRewriter_StmtTests: XCTestCase {
    func testTranslateSingleSelectorMessage() throws {
        try assertSingleStatement(
            objc: "[self thing];",
            swift: "self.thing()")
    }
    
    func testTranslateTwoSelectorMessage() throws {
        try assertSingleStatement(
            objc: "[self thing:a b:c];",
            swift: "self.thing(a, b: c)")
    }
    
    func testTranslateBinaryExpression() throws {
        try assertSingleStatement(
            objc: "10 + 26;",
            swift: "10 + 26")
    }
    
    func testTranslateParenthesizedExpression() throws {
        try assertSingleStatement(
            objc: "((10 + 26) * (15 + 15));",
            swift: "((10 + 26) * (15 + 15))")
    }
    
    func testTernaryExpression() throws {
        try assertSingleStatement(
            objc: "aValue ? 123 : 456;",
            swift: "aValue ? 123 : 456")
        
        try assertSingleStatement(
            objc: "aNullableValue ?: anotherValue;",
            swift: "aNullableValue ?? anotherValue")
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
