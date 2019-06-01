import XCTest
@testable import Utils

class PathTests: XCTestCase {
    func testLastPathComponent() {
        XCTAssertEqual(Path(fullPath: "/tmp/scratch.tiff").lastPathComponent, "scratch.tiff")
        XCTAssertEqual(Path(fullPath: "/tmp/scratch").lastPathComponent, "scratch")
        XCTAssertEqual(Path(fullPath: "/tmp/").lastPathComponent, "tmp")
        XCTAssertEqual(Path(fullPath: "scratch///").lastPathComponent, "scratch")
        XCTAssertEqual(Path(fullPath: "/").lastPathComponent, "/")
    }
}
