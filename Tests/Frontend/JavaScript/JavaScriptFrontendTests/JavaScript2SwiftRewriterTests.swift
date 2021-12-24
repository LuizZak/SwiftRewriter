import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriterTests: XCTestCase {
    func xtestRewrite_function() {
        assertRewrite(
            js: """
            function test() {

            }
            """,
            swift: """
            func test() -> Any {
                
            }
            """
        )
    }

    func xtestRewrite_functionBody() {
        assertRewrite(
            js: """
            function test() {
                var a = 0;
                return a + 10;
            }
            """,
            swift: """
            func test() -> Any {
                var a = 0
                return a + 10
            }
            """
        )
    }
}
