import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriterTests: XCTestCase {
    func testRewrite_function() {
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

    func testRewrite_functionBody() {
        assertRewrite(
            js: """
            function test() {
                var a = 0;
                return a + 10;
            }
            """,
            swift: """
            func test() -> Any {
                let a: Any = 0

                return a + 10
            }
            """
        )
    }

    func testRewrite_alwaysEmitTypeSignaturesByDefault() {
        assertRewrite(
            js: """
            function test() {
                var a = 0;
                var b = a;
            }
            """,
            swift: """
            func test() -> Any {
                let a: Any = 0
                let b: Any = a
            }
            """
        )
    }

    func testRewrite_classProperty() {
        assertRewrite(
            js: """
            class A {
                a = 0
            }
            """,
            swift: """
            class A {
                var a: Any = 0
            }
            """
        )
    }

    func testRewrite_multilineComments() {
        assertRewrite(
            js: """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            var a = 0;
            """,
            swift: """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            var a: Any = 0
            """
        )
    }

    func testRewrite_nestedFunctions() {
        assertRewrite(
            js: """
            function foo() {
                function bar() {
                    return 0
                }

                var baz = bar()
            }
            """,
            swift: """
            func foo() -> Any {
                func bar() -> Any {
                    return 0
                }

                let baz: Any = bar()
            }
            """
        )
    }
}
