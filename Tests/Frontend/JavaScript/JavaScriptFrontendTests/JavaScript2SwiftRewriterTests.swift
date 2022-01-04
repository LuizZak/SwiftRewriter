import XCTest

@testable import JavaScriptFrontend

class JavaScript2SwiftRewriterTests: XCTestCase {
    func testRewrite_function() {
        assertRewrite(
            js: """
            function test() {
                return 0;
            }
            """,
            swift: """
            func test() -> Any {
                return 0
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
                let a: Double = 0

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
            func test() {
                let a: Double = 0
                let b: Double = a
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

    func testRewrite_classStaticMethod() {
        assertRewrite(
            js: """
            class A {
                static method() {

                }
            }
            """,
            swift: """
            class A {
                static func method() {
                }
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
            func foo() {
                func bar() -> Any {
                    return 0
                }

                let baz: Any = bar()
            }
            """
        )
    }

    func testRewrite_sequentialAssignmentExpressions() {
        assertRewrite(
            js: """
            function foo() {
                var a, b, c = 1;

                a = b = c;
            }
            """,
            swift: """
            func foo() {
                var a: Double, b: Double, c: Double = 1

                b = c
                a = b
            }
            """
        )
    }

    func testRewrite_visitGlobalVariableExpression() {
        assertRewrite(
            js: """
            const utils = {
                foo: function () {
                    for (let p = 0, d = 0, c = d - 1; d > 1; d--, c--) {
                        const list = [];
                        for (let j = 0, dpt; j < c; j++) {
                            dpt = {
                                x: c * (p[j + 1].x - p[j].x),
                                y: c * (p[j + 1].y - p[j].y),
                            };
                            if (_3d) {
                                dpt.z = c * (p[j + 1].z - p[j].z);
                            }
                            list.push(dpt);
                        }
                        dpoints.push(list);
                        p = list;
                    }
                }
            }
            """,
            swift: """
            var utils: Any = [foo: { () -> Any in
                var p: Double = 0, d: Double = 0, c: Double = d - 1

                while d > 1 {
                    defer {
                        d -= 1
                        c -= 1
                    }

                    let list: NSArray = []
                    var j: Double = 0, dpt: Any

                    while j < c {
                        defer {
                            j += 1
                        }

                        dpt = [x: c * (p[j + 1].x - p[j].x), y: c * (p[j + 1].y - p[j].y)]

                        if _3d {
                            dpt.z = c * (p[j + 1].z - p[j].z)
                        }

                        list.push(dpt)
                    }

                    dpoints.push(list)
                    p = list
                }
            }]
            """
        )
    }

    func testRewrite_emitJavaScriptObject() {
        assertRewrite(
            js: """
            var object = {
                x: 1,
                y: 2
            }
            """,
            swift: """
            @dynamicMemberLookup
            final class JavaScriptObject: ExpressibleByDictionaryLiteral {
                private var values: [String: Any]

                subscript(dynamicMember member: String) -> Any? {
                    return values[member]
                }

                init() {
                    self.values = [:]
                }
                init(dictionaryLiteral elements: (String, Any)...) {
                    for (key, value) in elements {
                        self.values[key] = value
                    }
                }
            }
            // End of file JavaScriptObject.swift
            var object: Any = JavaScriptObject(["x": 1, "y": 2])
            // End of file test.swift
            """,
            rewriterSettings:
                .default
                .with(\.emitJavaScriptObject, true)
        )
    }

    func testRewrite_skipReturnOnNonReturningFunctions() {
        assertRewrite(
            js: """
            function f1() {
                if (true) {

                }
            }
            function f2() {
                if (true) {
                    return 0;
                }
            }
            """,
            swift: """
            func f1() {
                if true {
                }
            }
            func f2() -> Any {
                if true {
                    return 0
                }
            }
            """
        )
    }

    func testRewrite_propagateDelayedAssignmentType() {
        assertRewrite(
            js: """
            function f1() {
                var a;
                a = 0;
            }
            """,
            swift: """
            func f1() {
                var a: Double
            
                a = 0
            }
            """
        )
    }

    func testRewrite_parameterNullCoalesce() {
        assertRewrite(
            js: """
            function f1(a) {
                a = a || 100
            }
            """,
            swift: """
            func f1(_ a: Any) {
                a = a ?? 100
            }
            """
        )
    }

    func testRewrite_constructor() {
        assertRewrite(
            js: """
            class AClass {
                constructor(a, b) {
                    self.a = a
                    self.b = b
                }
            }
            """,
            swift: """
            class AClass {
                var a: Any
                var b: Any
            
                init(_ a: Any, _ b: Any) {
                    self.a = a
                    self.b = b
                }
            }
            """
        )
    }

    func testRewrite_createClassFields() {
        assertRewrite(
            js: """
            class AClass {
                constructor() {
                    self.field1 = 0
                }

                method() {
                    self.field2 = "value"
                }
            }
            """,
            swift: """
            class AClass {
                var field1: Int = 0
                var field2: String

                init() {
                    self.field1 = 0
                }

                func method() {
                    self.field2 = "value"
                }
            }
            """
        )
    }
}
