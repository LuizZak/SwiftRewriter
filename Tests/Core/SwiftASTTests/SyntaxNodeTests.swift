import XCTest

@testable import SwiftAST

class SyntaxNodeTests: XCTestCase {
    func testIsDescendent() {
        let root = TestSyntaxNode()
        let child = TestSyntaxNode()
        let unrelatedChild = TestSyntaxNode()
        let grandchild = TestSyntaxNode()
        root.addChild(child)
        child.addChild(grandchild)
        root.addChild(unrelatedChild)

        XCTAssert(root.isDescendent(of: root))
        XCTAssert(grandchild.isDescendent(of: root))
        XCTAssert(grandchild.isDescendent(of: child))
        XCTAssert(unrelatedChild.isDescendent(of: root))
        XCTAssertFalse(grandchild.isDescendent(of: unrelatedChild))
    }

    func testFirstAncestor() {
        let root = TestSyntaxNode()
        let child = OtherTestSyntaxNode()
        let grandChild = TestSyntaxNode()
        let grandGrandChild = SyntaxNode()
        root.addChild(child)
        child.addChild(grandChild)
        grandChild.addChild(grandGrandChild)

        XCTAssert(grandGrandChild.firstAncestor(ofType: SyntaxNode.self) === grandChild)
        XCTAssert(grandGrandChild.firstAncestor(ofType: OtherTestSyntaxNode.self) === child)
        XCTAssert(grandGrandChild.firstAncestor(ofType: TestSyntaxNode.self) === grandChild)
        XCTAssertNil(root.firstAncestor(ofType: OtherTestSyntaxNode.self))
        XCTAssertNil(root.firstAncestor(ofType: SyntaxNode.self))
    }
}

class TestSyntaxNode: SyntaxNode {
    private var _children: [SyntaxNode] = []

    override var children: [SyntaxNode] {
        return _children
    }

    func addChild(_ child: SyntaxNode) {
        child.parent = self
        _children.append(child)
    }
}

class OtherTestSyntaxNode: SyntaxNode {
    private var _children: [SyntaxNode] = []

    override var children: [SyntaxNode] {
        return _children
    }

    func addChild(_ child: SyntaxNode) {
        child.parent = self
        _children.append(child)
    }
}
