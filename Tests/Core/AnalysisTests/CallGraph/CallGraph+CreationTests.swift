import Intentions
import KnownType
import SwiftAST
import TestCommons
import TypeSystem
import XCTest

@testable import Analysis

class CallGraph_CreationTests: XCTestCase {
    func testEmptyCallGraph() {
        let builder = IntentionCollectionBuilder()
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                }
                """
        )
    }

    func testDirectCall() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // B().b()
            .expression(
                Expression
                    .identifier("B").call()
                    .dot("b").call()
            )
        ]
        builder
            .createFile(named: "A.m") { file in
                file
                    .createClass(withName: "A") { builder in
                        builder.createVoidMethod(named: "f1") { method in
                            method.setBody(body)
                        }
                    }
                    .createClass(withName: "B") { builder in
                        builder
                            .createConstructor()
                            .createVoidMethod(named: "b")
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                    n1 [label="A.f1()"]
                    n2 [label="B.b()"]
                    n3 [label="B.init()"]
                    n1 -> n2
                    n1 -> n3
                }
                """
        )
    }

    func testRecursiveCall() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // a()
            .expression(
                Expression
                    .identifier("a").call()
            ),
            .expression(
                Expression
                    .identifier("a").call()
            )
        ]
        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "a") { method in
                        method.setBody(body)
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                    n1 [label="func a()"]
                    n1 -> n1
                }
                """
        )
    }

    func testInitializerCall() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // B()
            .expression(
                Expression
                    .identifier("B").call()
            )
        ]
        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "a") { method in
                        method.setBody(body)
                    }
                    .createClass(withName: "B") { builder in
                        builder.createConstructor()
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                    n1 [label="B.init()"]
                    n2 [label="func a()"]
                    n2 -> n1
                }
                """
        )
    }

    func testSubscriptGetter() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // b[0]
            .expression(
                Expression
                    .identifier("b")
                    .sub(.constant(0))
            )
        ]
        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "a") { method in
                        method
                            .createSignature { sign in
                                sign.addParameter(name: "b", type: "B")
                            }.setBody(body)
                    }
                    .createClass(withName: "B") { builder in
                        builder.createSubscript(parameters: [.init(name: "v", type: .int)], returnType: .string)
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                    n1 [label="B.subscript(v: Int) -> String { get }"]
                    n2 [label="func a(b: B)"]
                    n2 -> n1
                }
                """
        )
    }

    func testSubscriptSetter() {
        let builder = IntentionCollectionBuilder()
        let body: CompoundStatement = [
            // b[0] = ""
            .expression(
                Expression
                    .identifier("b")
                    .sub(.constant(0))
                    .assignment(op: .equals, rhs: .constant(""))
            )
        ]
        builder
            .createFile(named: "A.m") { file in
                file
                    .createGlobalFunction(withName: "a") { method in
                        method
                            .createSignature { sign in
                                sign.addParameter(name: "b", type: "B")
                            }.setBody(body)
                    }
                    .createClass(withName: "B") { builder in
                        builder.createSubscript(parameters: [.init(name: "v", type: .int)], returnType: .string) { builder in
                            builder.setAsGetterSetter(
                                getter: [],
                                setter: .init(valueIdentifier: "v", body: [])
                            )
                        }
                    }
            }
        let intentions = builder.build(typeChecked: true)
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)

        let graph = CallGraph.fromIntentions(intentions, typeSystem: typeSystem)

        sanitize(graph)
        assertGraphviz(
            graph: graph,
            matches: """
                digraph calls {
                    n1 [label="B.subscript(v: Int) -> String { get }"]
                    n2 [label="B.subscript(v: Int) -> String { set }"]
                    n3 [label="func a(b: B)"]
                    n3 -> n2
                }
                """
        )
    }
}
