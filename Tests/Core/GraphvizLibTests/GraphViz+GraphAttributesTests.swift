import XCTest

@testable import GraphvizLib

class GraphViz_GraphAttributesTests: XCTestCase {
    func testRankDir_rawValue() {
        XCTAssertEqual(GraphViz.RankDir.topToBottom.rawValue, "TB")
        XCTAssertEqual(GraphViz.RankDir.bottomToTop.rawValue, "BT")
        XCTAssertEqual(GraphViz.RankDir.leftToRight.rawValue, "LR")
        XCTAssertEqual(GraphViz.RankDir.rightToLeft.rawValue, "RL")
    }
}
