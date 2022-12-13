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
            func test() {
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

    func testRewrite_collectBodyComments() {
        assertRewrite(
            js: """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            function a() {
                // Body comment
            }
            function b() {
                let local;
            }
            """,
            swift: """
            /**
             * Bezier curve constructor.
             *
             * ...docs pending...
             */
            func a() {
                // Body comment
            }
            func b() {
                let local: Any
            }
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
                var a: Any, b: Any, c: Any = 1

                b = c
                a = b
            }
            """
        )
    }

    func testRewrite_emitJavaScriptObject() {
        assertRewrite(
            js: """
            var object = {
                x: 1,
                y: 2,
                z
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
                init(_ values: [String: Any]) {
                    self.values = values
                }
            }
            // End of file JavaScriptObject.swift
            var object: Any = JavaScriptObject(["x": 1, "y": 2, "z": z])
            // End of file test.swift
            """,
            rewriterSettings:
                .default
                .with(\.emitJavaScriptObject, true)
        )
    }

    func testRewrite_emitJavaScriptObject_detectsDynamicMemberLookups() {
        assertRewrite(
            js: """
            function f() {
                var object = {
                    x: 1,
                    y: 2,
                    z
                }

                var x = object.x;
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
                    // type: [String: Any]
                    self.values = [:]
                }
                init(dictionaryLiteral elements: (String, Any)...) {
                    for (key, value) in elements {
                        // type: Any?
                        self.values[key] = value
                    }
                }
                init(_ values: [String: Any]) {
                    // type: [String: Any]
                    self.values = values
                }
            }
            // End of file JavaScriptObject.swift
            func f() {
                // decl type: JavaScriptObject
                // init type: JavaScriptObject
                let object = JavaScriptObject(["x": 1, "y": 2, "z": z])
                // decl type: Any?
                // init type: Any?
                let x = object.x
            }
            // End of file test.swift
            """,
            options:
                .default
                .with(\.outputExpressionTypes, true),
            rewriterSettings:
                .default
                .with(\.deduceTypes, true)
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
                var a: Any
            
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
                    this.a = a
                    this.b = b
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
                    this.field1 = 0
                }

                method() {
                    this.field2 = "value"
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

    func testRewrite_detectJavaScriptObjectType() {
        assertRewrite(
            js: """
            function f() {
                var object = {
                    x: 1,
                    y: 2
                }
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
                    // type: [String: Any]
                    self.values = [:]
                }
                init(dictionaryLiteral elements: (String, Any)...) {
                    for (key, value) in elements {
                        // type: Any?
                        self.values[key] = value
                    }
                }
                init(_ values: [String: Any]) {
                    // type: [String: Any]
                    self.values = values
                }
            }
            // End of file JavaScriptObject.swift
            func f() {
                // decl type: Any
                // init type: JavaScriptObject
                let object = JavaScriptObject(["x": 1, "y": 2])
            }
            // End of file test.swift
            """,
            options: 
                .default
                .with(\.outputExpressionTypes, true),
            rewriterSettings:
                .default
                .with(\.emitJavaScriptObject, true)
        )
    }

    func testRewrite_propertyShorthandObjectLiterals() {
        assertRewrite(
            js: """
            function f() {
                var a = 0;
                var b = {
                    a,
                    c: 10
                };
            }
            """,
            swift: """
            func f() {
                let a: Any = 0
                let b: Any = [a: a, c: 10]
            }
            """
        )
    }

    func testRewrite_detectPropertyBySelfAssignment() {
        assertRewrite(
            js: """
            class A {
                computedirection() {
                    let clockwise = false;
                    clockwise = this.clockwise;
                }
            }
            """,
            swift: """
            class A {
                var clockwise: Any

                func computedirection() {
                    var clockwise: Any = false

                    clockwise = self.clockwise
                }
            }
            """
        )
    }

    func testRewrite_detectPropertyBySelfAssignment_preferWriteUsages() {
        assertRewrite(
            js: """
            class A {
                computedirection() {
                    const clockwise = this.clockwise;
                    const angle = utils.angle;

                    this.clockwise = angle > 0;
                }
            }
            """,
            swift: """
            class A {
                var clockwise: Bool = false

                func computedirection() {
                    let clockwise: Any = self.clockwise
                    let angle: Any = utils.angle

                    self.clockwise = angle > 0
                }
            }
            """
        )
    }

    func testRewrite_detectPropertyBySelfAssignment_ignoreMethodReferences() {
        assertRewrite(
            js: """
            class A {
                constructor() {
                    const local = this.aMethod;
                }
                aMethod() {

                }
            }
            """,
            swift: """
            class A {
                init() {
                    let local: Any = self.aMethod
                }

                func aMethod() {
                }
            }
            """
        )
    }

    func testRewrite_deduceTypes_deducesLocalVariableType() {
        assertRewrite(
            js: """
            function foo() {
                var a = 0;
                var b = a;
                var c;
                c = a > b;
            }
            """,
            swift: """
            func foo() {
                let a: Double = 0
                let b: Double = a
                var c: Bool

                c = a > b
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_visitGlobalVariableExpression() {
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
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_useLocalTypeInformation() {
        assertRewrite(
            js: """
            class A {
                constructor() {
                    const local = this.aMethod;
                }
                aMethod() {

                }
            }
            """,
            swift: """
            class A {
                init() {
                    let local: () -> Any = self.aMethod
                }

                func aMethod() {
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_detectArrayByNumericSubscript() {
        assertRewrite(
            js: """
            function foo() {
                var a = b;
                a[0] = "c";
            }
            """,
            swift: """
            func foo() {
                var a: NSArray = b

                a[0] = "c"
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes() {
        assertRewrite(
            js: """
            function f(a, b) {
                if (b == false) {
                    b = 0
                }

                a = b + 10

                return a
            }
            """,
            swift: """
            func f(_ a: Double, _ b: Double) -> Any {
                if b == false {
                    b = 0
                }

                a = b + 10

                return a
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_repeatedArgumentNames() {
        assertRewrite(
            js: """
            function foo(a) {
                a = 10
            }
            function bar(a) {
                a = 10
            }
            function baz(b) {
                b = 10
            }
            """,
            swift: """
            func foo(_ a: Double) {
                a = 10
            }
            func bar(_ a: Double) {
                a = 10
            }
            func baz(_ b: Double) {
                b = 10
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_staticMethod() {
        assertRewrite(
            js: """
            class A {
                static quadraticFromPoints(p1, p2, p3, t) {
                    p3 = 0.0;
                    
                    if (typeof t === "undefined") {
                        t = 0.5;
                    }
                    // shortcuts, although they're really dumb
                    if (t === 0) {
                        return new Bezier(p2, p2);
                    }
                    if (t === 1) {
                        return new Bezier(p1, p2);
                    }
                    // real fitting.
                    const abc = Bezier.getABC(2, p1, p2, t);
                    return new Bezier(p1, abc.A);
                }
            }
            """,
            swift: """
            class A {
                static func quadraticFromPoints(_ p1: Any, _ p2: Any, _ p3: Double, _ t: Double) -> Any {
                    p3 = 0.0

                    if String(type(of: t)) == "undefined" {
                        t = 0.5
                    }

                    // shortcuts, although they're really dumb
                    if t == 0 {
                        return Bezier(p2, p2)
                    }

                    if t == 1 {
                        return Bezier(p1, p2)
                    }

                    // real fitting.
                    let abc: Any = Bezier.getABC(2, p1, p2, t)

                    return Bezier(p1, abc.A)
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_detectArrayByPushCall() {
        assertRewrite(
            js: """
            function foo(a) {
                a.push(0);
            }
            """,
            swift: """
            func foo(_ a: NSArray) {
                a.push(0)
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_detectArrayByLengthGetter() {
        assertRewrite(
            js: """
            function foo(a) {
                if (a.length > 0) {
                }
            }
            """,
            swift: """
            func foo(_ a: NSArray) {
                if a.length > 0 {
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_detectArrayByNumericSubscript() {
        assertRewrite(
            js: """
            function foo(a) {
                var b = 0;
                a[b] = 0;
            }
            """,
            swift: """
            func foo(_ a: NSArray) {
                let b: Double = 0

                a[b] = 0
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_deduceTypes_deduceArgumentTypes_doNotReportNonNumericSubscriptsAsArray() {
        assertRewrite(
            js: """
            function foo(a) {
                var b = "p";
                a[b] = 0;
            }
            """,
            swift: """
            func foo(_ a: Any) {
                let b: String = "p"

                a[b] = 0
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_detectGetters() {
        assertRewrite(
            js: """
            class Example {
                constructor (id) {
                    this._id = id
                }
                get id() {
                    return this._id
                }
            }
            """,
            swift: """
            class Example {
                var _id: Any
                var id: Any {
                    return self._id
                }

                init(_ id: Any) {
                    self._id = id
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_detectGettersSetters() {
        assertRewrite(
            js: """
            class Example {
                constructor (id) {
                    this._id = id
                }
                set id(v) {
                    this._id = v
                }
                get id() {
                    return this._id
                }
            }
            """,
            swift: """
            class Example {
                var _id: Any
                var id: Any {
                    get {
                        return self._id
                    }
                    set(v) {
                        self._id = v
                    }
                }

                init(_ id: Any) {
                    self._id = id
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }

    func testRewrite_privateField() {
        assertRewrite(
            js: """
            class Example {
                #_var = 0;

                constructor () {
                    this.#_var = this.#_method()
                }

                #_method() {

                }
            }
            """,
            swift: """
            class Example {
                var _var: Any = 0

                init() {
                    self._var = self._method()
                }

                func _method() {
                }
            }
            """,
            rewriterSettings: .default.with(\.deduceTypes, true)
        )
    }
}
