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
    
    func testDeletingPathExtension() {
        XCTAssertEqual(Path(fullPath: "/tmp/scratch.tiff").deletingPathExtension, "/tmp/scratch")
        XCTAssertEqual(Path(fullPath: "/tmp/").deletingPathExtension, "/tmp")
        XCTAssertEqual(Path(fullPath: "scratch.bundle/").deletingPathExtension, "scratch")
        XCTAssertEqual(Path(fullPath: "scratch..tiff").deletingPathExtension, "scratch.")
        XCTAssertEqual(Path(fullPath: ".tiff").deletingPathExtension, ".tiff")
        XCTAssertEqual(Path(fullPath: "/").deletingPathExtension, "/")
    }
    
    func testAppendingPathComponent() {
        XCTAssertEqual(Path(fullPath: "/tmp").appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual(Path(fullPath: "/tmp/").appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual(Path(fullPath: "/").appendingPathComponent("scratch.tiff"), "/scratch.tiff")
        XCTAssertEqual(Path(fullPath: "").appendingPathComponent("scratch.tiff"), "scratch.tiff")
    }
    
    func testDeletingLastPathComponent() {
        XCTAssertEqual(Path(fullPath: "").deletingLastPathComponent, "")
        XCTAssertEqual(Path(fullPath: "/").deletingLastPathComponent, "/")
        XCTAssertEqual(Path(fullPath: "/tmp").deletingLastPathComponent, "/")
        XCTAssertEqual(Path(fullPath: "/tmp/").deletingLastPathComponent, "/")
        XCTAssertEqual(Path(fullPath: "//tmp/").deletingLastPathComponent, "/")
        XCTAssertEqual(Path(fullPath: "/tmp/scratch.tiff").deletingLastPathComponent, "/tmp")
        XCTAssertEqual(Path(fullPath: "/tmp/scratch.tiff//").deletingLastPathComponent, "/tmp")
    }
}
