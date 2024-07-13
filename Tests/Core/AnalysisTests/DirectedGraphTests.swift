import Analysis
import XCTest
import TestCommons

class DirectedGraphTests: XCTestCase {
    func testAreEdgesEqual() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        let e1 = sut.addEdge(from: n1, to: n2)
        let e2 = sut.addEdge(from: n1, to: n3)

        XCTAssertTrue(sut.areEdgesEqual(e1, e1))
        XCTAssertTrue(sut.areEdgesEqual(e2, e2))
        XCTAssertFalse(sut.areEdgesEqual(e1, e2))
        XCTAssertFalse(sut.areEdgesEqual(e2, e1))
    }

    func testAllEdgesForNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        let e1 = sut.addEdge(from: n1, to: n2)
        let e2 = sut.addEdge(from: n1, to: n3)

        let result = sut.allEdges(for: n1)

        XCTAssertEqual(result, [e1, e2])
    }

    func testNodesConnectedFromNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(from: n1, to: n2)
        sut.addEdge(from: n1, to: n3)

        let result = sut.nodesConnected(from: n1)

        XCTAssertEqual(result, [n2, n3])
    }

    func testNodesConnectedTowardsNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(from: n1, to: n2)
        sut.addEdge(from: n2, to: n3)

        let result = sut.nodesConnected(towards: n2)

        XCTAssertEqual(result, [n1])
    }

    func testAllNodesConnectedToNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(from: n1, to: n2)
        sut.addEdge(from: n2, to: n3)

        let result = sut.allNodesConnected(to: n2)

        XCTAssertEqual(result, [n1, n3])
    }

    func testDepthFirstVisit() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        let n6 = sut.addNode(6)
        let e0 = sut.addEdge(from: n1, to: n2)
        let e1 = sut.addEdge(from: n2, to: n3)
        let e2 = sut.addEdge(from: n2, to: n4)
        let e3 = sut.addEdge(from: n4, to: n5)
        let e4 = sut.addEdge(from: n1, to: n6)

        assertVisit(
            sut,
            start: n1,
            visitMethod: sut.depthFirstVisit,
            expected: [
                .start(n1),
                n1 => (e0, n2),
                n1 => (e0, n2) => (e1, n3),
                n1 => (e0, n2) => (e2, n4),
                n1 => (e0, n2) => (e2, n4) => (e3, n5),
                n1 => (e4, n6),
            ]
        )
    }

    func testBreadthFirstVisit() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        let n6 = sut.addNode(6)
        let e0 = sut.addEdge(from: n1, to: n2)
        let e1 = sut.addEdge(from: n2, to: n3)
        let e2 = sut.addEdge(from: n2, to: n4)
        let e3 = sut.addEdge(from: n4, to: n5)
        let e4 = sut.addEdge(from: n1, to: n6)

        assertVisit(
            sut,
            start: n1,
            visitMethod: sut.breadthFirstVisit,
            expected: [
                .start(n1),
                n1 => (e0, n2),
                n1 => (e4, n6),
                n1 => (e0, n2) => (e1, n3),
                n1 => (e0, n2) => (e2, n4),
                n1 => (e0, n2) => (e2, n4) => (e3, n5),
            ]
        )
    }

    func testTopologicalSorted() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(from: n1, to: n2)
        sut.addEdge(from: n2, to: n3)
        sut.addEdge(from: n2, to: n4)
        sut.addEdge(from: n4, to: n5)

        let result = sut.topologicalSorted()

        XCTAssertEqual(result, [
            n1, n2, n3, n4, n5
        ])
    }

    func testTopologicalSorted_returnsNilForCyclicGraph() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(from: n1, to: n2)
        sut.addEdge(from: n2, to: n3)
        sut.addEdge(from: n3, to: n1)

        let result = sut.topologicalSorted()

        XCTAssertNil(result)
    }

    func testStronglyConnectedComponents_emptyGraph() {
        let sut = makeSut()

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assertIsEmpty()
    }

    func testStronglyConnectedComponents_singleNode() {
        let sut = makeSut()
        let node = sut.addNode(1)

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assert(elementsEqualUnordered: [[node]])
    }

    func testStronglyConnectedComponents_twoNodes_notConnected() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assert(elementsEqualUnordered: [[node1], [node2]])
    }

    func testStronglyConnectedComponents_twoNodes_connectedWeakly() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        sut.addEdge(from: node1, to: node2)

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assert(elementsEqualUnordered: [[node1], [node2]])
    }

    func testStronglyConnectedComponents_twoNodes_connectedStrongly() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        sut.addMutualEdges(from: node1, to: node2)

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assert(elementsEqualUnordered: [[node1, node2]])
    }

    func testStronglyConnectedComponents_fourNodes() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        let node3 = sut.addNode(3)
        let node4 = sut.addNode(4)
        sut.addMutualEdges(from: node1, to: node2)
        sut.addEdge(from: node1, to: node3)
        sut.addMutualEdges(from: node3, to: node4)

        let result = sut.stronglyConnectedComponents()

        Asserter(object: result)
            .assert(elementsEqualUnordered: [[node1, node2], [node3, node4]])
    }

    // MARK: - Test internals

    private func makeSut() -> TestGraph {
        return TestGraph()
    }

    private func assertVisit(
        _ sut: TestGraph,
        start: TestGraph.Node,
        visitMethod: (TestGraph.Node, (TestGraph.VisitElement) -> Bool) -> Void,
        expected: [TestGraph.VisitElement],
        line: UInt = #line
    ) {
        var visits: [TestGraph.VisitElement] = []
        let _visit: (TestGraph.VisitElement) -> Bool = {
            visits.append($0)
            return true
        }

        visitMethod(start, _visit)

        func _formatNode(_ node: TestGraph.Node) -> String {
            "node #\(node.value.description)"
        }

        func _formatVisit(_ visit: TestGraph.VisitElement) -> String {
            switch visit {
            case .start(let node):
                return _formatNode(node)
            case .edge(let e, let from, let towards):
                return "\(_formatVisit(from)) -(edge index: \(e.index))> \(_formatNode(towards))"
            }
        }

        func _formatVisits(_ visits: [TestGraph.VisitElement]) -> String {
            if visits.isEmpty {
                return ""
            }

            return """
            [
              \(visits.enumerated().map { "\($0): \(_formatVisit($1))" }.joined(separator: "\n  "))
            ]
            """
        }

        if expected.count != visits.count {
            if visits.isEmpty {
                XCTFail(
                    "Expected \(expected.count) visits, found \(visits.count)",
                    line: line
                )
            } else {
                XCTFail(
                    """
                    Expected \(expected.count) visits, found \(visits.count):

                    \(_formatVisits(visits))
                    """,
                    line: line
                )
            }
            return
        }

        for (i, (exp, vis)) in zip(expected, visits).enumerated() {
            if exp == vis {
                continue
            }

            XCTFail(
                """
                Failed to match expected visits starting at index \(i).
                Expected visit order to be:
                
                \(_formatVisits(expected))

                but found

                \(_formatVisits(visits))
                """,
                line: line
            )
            return
        }
    }
}

// Convenience operators for generating visit elements
infix operator => : MultiplicationPrecedence

// Creates a visit from `lhs` to `rhs.node` through `rhs.edge`.
func => <E, N>(lhs: DirectedGraphVisitElement<E, N>, rhs: (edge: E, node: N)) -> DirectedGraphVisitElement<E, N> {
    .edge(rhs.edge, from: lhs, towards: rhs.node)
}

// Creates a visit from `.root(lhs)` to `rhs.node` through `rhs.edge`.
func => <E, N>(lhs: N, rhs: (edge: E, node: N)) -> DirectedGraphVisitElement<E, N> {
    .edge(rhs.edge, from: .start(lhs), towards: rhs.node)
}

private class TestGraph {
    private(set) var nodes: [Node] = []
    private(set) var edges: [Edge] = []

    func addNode(_ value: Int) -> Node {
        let node = Node(value: value)
        nodes.append(node)
        return node
    }

    @discardableResult
    func addEdge(from start: Node, to end: Node) -> Edge {
        let edge = Edge(start: start, end: end, index: edges.count)
        edges.append(edge)
        return edge
    }

    @discardableResult
    func addMutualEdges(from start: Node, to end: Node) -> [Edge] {
        return [
            addEdge(from: start, to: end),
            addEdge(from: end, to: start),
        ]
    }

    class Node: DirectedGraphNode, CustomDebugStringConvertible {
        var value: Int

        var debugDescription: String {
            "node #\(value)"
        }

        init(value: Int) {
            self.value = value
        }
    }

    class Edge: DirectedGraphEdge, CustomDebugStringConvertible {
        var start: Node
        var end: Node
        var index: Int
        
        var debugDescription: String {
            "(edge index: \(index))"
        }

        init(start: TestGraph.Node, end: TestGraph.Node, index: Int) {
            self.start = start
            self.end = end
            self.index = index
        }
    }
}

extension TestGraph: DirectedGraph {
    func subgraph<S>(of nodes: S) -> Self where S : Sequence, Node == S.Element {
        fatalError("Subgraph not implemented on TestGraph")
    }

    func areNodesEqual(_ node1: Node, _ node2: Node) -> Bool {
        node1 == node2
    }

    func startNode(for edge: Edge) -> Node {
        edge.start
    }

    func endNode(for edge: Edge) -> Node {
        edge.end
    }

    func edges(from node: Node) -> [Edge] {
        edges.filter { $0.start == node }
    }

    func edges(towards node: Node) -> [Edge] {
        edges.filter { $0.end == node }
    }

    func edge(from start: Node, to end: Node) -> Edge? {
        edges.first { $0.start == start && $0.end == end }
    }
}
