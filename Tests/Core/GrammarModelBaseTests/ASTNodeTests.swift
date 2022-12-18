import XCTest
import Utils

@testable import GrammarModelBase

class ASTNodeTests: XCTestCase {
    func testUpdateSourceRange_emptyNode() {
        let source = makeMockSource()
        let sut = ASTNode()
        sut.originalSource = source

        sut.updateSourceRange()

        XCTAssertEqual(sut.location, .invalid)
        XCTAssertEqual(sut.length, .zero)
    }

    func testUpdateSourceRange_singleChild() {
        let source = makeMockSource()
        let sut = ASTNode()
        sut.originalSource = source
        let child = ASTNode(
            location: .init(line: 1, column: 1, utf8Offset: 0),
            length: .init(newlines: 2, columnsAtLastLine: 8, utf8Length: 19)
        )
        child.originalSource = source
        sut.addChild(child)

        sut.updateSourceRange()

        XCTAssertEqual(sut.location, .init(line: 1, column: 1, utf8Offset: 0))
        XCTAssertEqual(sut.length, .init(newlines: 2, columnsAtLastLine: 8, utf8Length: 19))
    }

    func testUpdateSourceRange_multiChildren() {
        let source = makeMockSource()
        let sut = ASTNode()
        sut.originalSource = source
        let child1 = ASTNode(
            location: .init(line: 1, column: 1, utf8Offset: 0),
            length: .init(newlines: 2, columnsAtLastLine: 8, utf8Length: 19)
        )
        child1.originalSource = source
        let child2 = ASTNode(
            location: .init(line: 3, column: 6, utf8Offset: 25),
            length: .init(newlines: 1, columnsAtLastLine: 9, utf8Length: 22)
        )
        child2.originalSource = source
        sut.addChild(child1)
        sut.addChild(child2)

        sut.updateSourceRange()

        XCTAssertEqual(sut.location, .init(line: 1, column: 1, utf8Offset: 0))
        XCTAssertEqual(sut.length, .init(newlines: 3, columnsAtLastLine: 9, utf8Length: 47))
    }

    func testUpdateSourceRange_multiChildren_withInvalidLocation() {
        let source = makeMockSource()
        let sut = ASTNode()
        sut.originalSource = source
        let child1 = ASTNode(
            location: .init(line: 1, column: 1, utf8Offset: 0),
            length: .init(newlines: 2, columnsAtLastLine: 8, utf8Length: 19)
        )
        child1.originalSource = source
        let child2 = ASTNode(
            location: .invalid,
            length: .init(newlines: 1, columnsAtLastLine: 9, utf8Length: 22)
        )
        child2.originalSource = source
        sut.addChild(child1)
        sut.addChild(child2)

        sut.updateSourceRange()

        XCTAssertEqual(sut.location, .init(line: 1, column: 1, utf8Offset: 0))
        XCTAssertEqual(sut.length, .init(newlines: 2, columnsAtLastLine: 8, utf8Length: 19))
    }

    // MARK: - Test internals

    private func makeMockSource() -> Source {
        let source = """
        A line here
        Another line

        A third line
        A final line here
        """

        return StringCodeSource(source: source)
    }
}
