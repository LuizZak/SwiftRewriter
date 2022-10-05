import XCTest
import TestCommons

@testable import Graphviz

class GraphVizTests: XCTestCase {
    func testGenerateFile_emptyGraph_nilRootGraphName() {
        let sut = makeSut()

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_emptyGraph_nonNilRootGraphName() {
        let sut = makeSut(rootGraphName: "testGraph")

        diffTest(expected: """
        digraph testGraph {
            graph [rankdir=LR]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_singleNode() {
        let sut = makeSut()
        sut.createNode(label: "node")

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_singleConnection() {
        let sut = makeSut()
        let n1 = sut.createNode(label: "node1")
        let n2 = sut.createNode(label: "node2")
        sut.addConnection(from: n1, to: n2)

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node1"]
            1 [label="node2"]

            1 -> 0
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_singleConnection_withLabel() {
        let sut = makeSut()
        let n1 = sut.createNode(label: "node1")
        let n2 = sut.createNode(label: "node2")
        sut.addConnection(from: n1, to: n2, label: "connection label")

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node1"]
            1 [label="node2"]

            1 -> 0 [label="connection label"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_singleConnection_withColor() {
        let sut = makeSut()
        let n1 = sut.createNode(label: "node1")
        let n2 = sut.createNode(label: "node2")
        sut.addConnection(from: n1, to: n2, color: "red")

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node1"]
            1 [label="node2"]

            1 -> 0 [color="red"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_singleConnection_withLabel_withColor() {
        let sut = makeSut()
        let n1 = sut.createNode(label: "node1")
        let n2 = sut.createNode(label: "node2")
        sut.addConnection(from: n1, to: n2, label: "connection label", color: "red")

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node1"]
            1 [label="node2"]

            1 -> 0 [label="connection label", color="red"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGenerateFile_twoGroups_withNodeConnections() {
        let sut = makeSut()
        sut.createNode(label: "node1", groups: ["Subgroup"])
        sut.createNode(label: "node2", groups: ["Subgroup", "Inner Subgroup"])
        sut.createNode(label: "node3", groups: ["Subgroup", "Inner Subgroup"])
        sut.addConnection(fromLabel: "node2", toLabel: "node3")

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            label = "Subgroup"

            0 [label="node1"]

            subgraph cluster_1 {
                label = "Inner Subgroup"

                1 [label="node2"]
                2 [label="node3"]

                2 -> 1
            }
        }
        """)
        .diff(sut.generateFile())
    }

    func testCreateNodeWithLabel_duplicatesNodes() {
        let sut = makeSut()
        let n1 = sut.createNode(label: "node")
        let n2 = sut.createNode(label: "node")

        XCTAssertNotEqual(n1, n2)
        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node"]
            1 [label="node"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testGetOrCreateLabel_doesNotDuplicateNodes() {
        let sut = makeSut()
        let n1 = sut.getOrCreate(label: "node")
        let n2 = sut.getOrCreate(label: "node")

        XCTAssertEqual(n1, n2)
        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            0 [label="node"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testCreateNodeWithLabel_withSingleGroup() {
        let sut = makeSut()
        sut.createNode(label: "node", groups: ["Subgroup"])

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            label = "Subgroup"

            0 [label="node"]
        }
        """)
        .diff(sut.generateFile())
    }

    func testCreateNodeWithLabel_withSingleGroup_simplifyGroups_false() {
        let sut = makeSut()
        sut.createNode(label: "node", groups: ["Subgroup"])

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            subgraph cluster_1 {
                label = "Subgroup"

                0 [label="node"]
            }
        }
        """)
        .diff(sut.generateFile(
            options: .init(
                simplifyGroups: false
            )
        ))
    }

    func testCreateNodeWithLabel_twoGroups() {
        let sut = makeSut()
        sut.createNode(label: "node1", groups: ["Subgroup"])
        sut.createNode(label: "node2", groups: ["Subgroup", "Inner Subgroup"])
        sut.createNode(label: "node3", groups: ["Subgroup", "Inner Subgroup"])

        diffTest(expected: """
        digraph {
            graph [rankdir=LR]

            label = "Subgroup"

            0 [label="node1"]

            subgraph cluster_1 {
                label = "Inner Subgroup"

                1 [label="node2"]
                2 [label="node3"]
            }
        }
        """)
        .diff(sut.generateFile())
    }

    // MARK: - Test utils

    private func makeSut(rootGraphName: String? = nil) -> GraphViz {
        GraphViz(rootGraphName: rootGraphName)
    }
}
