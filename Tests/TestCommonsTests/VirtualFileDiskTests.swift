import XCTest
import TestCommons

class VirtualFileDiskTests: XCTestCase {
    func testInit() throws {
        let sut = VirtualFileDisk()
        let files = try sut.files(atPath: "/")

        XCTAssert(files.isEmpty)
    }

    func testCreateFile() throws {
        let sut = VirtualFileDisk()

        try sut.createFile(atPath: "/directory/file.txt")

        let files = try sut.files(atPath: "/directory")
        XCTAssertEqual(files, ["/directory/file.txt"])
    }
}
