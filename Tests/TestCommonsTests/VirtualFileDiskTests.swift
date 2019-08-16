import XCTest
import TestCommons

class VirtualFileDiskTests: XCTestCase {
    func testInit() throws {
        let sut = VirtualFileDisk()
        let files = try sut.files(atPath: "/")

        XCTAssertEqual(files, [])
    }

    func testCreateFile() throws {
        let sut = VirtualFileDisk()

        try sut.createFile(atPath: "/directory/file.txt")

        let files = try sut.files(atPath: "/directory")
        XCTAssertEqual(files, ["/directory/file.txt"])
    }

    func testCreateFileFullPath() throws {
        let sut = VirtualFileDisk()

        try sut.createFile(atPath: "/directory/file1.txt")
        try sut.createFile(atPath: "/directory/file2.txt")

        let directories = try sut.contentsOfDirectory(atPath: "/")
        XCTAssertEqual(directories, ["/directory"])
    }

    func testDeleteFile() throws {
        let sut = VirtualFileDisk()

        try sut.createFile(atPath: "/directory/file.txt")
        try sut.deleteFile(atPath: "/directory/file.txt")

        let files = try sut.files(atPath: "/directory")
        XCTAssertEqual(files, [])
    }

    func testCreateDirectory() throws {
        let sut = VirtualFileDisk()
        try sut.createFile(atPath: "/file.txt")

        try sut.createDirectory(atPath: "/directory")

        let files = try sut.files(atPath: "/")
        let allContents = try sut.contentsOfDirectory(atPath: "/")
        XCTAssertEqual(files, ["/file.txt"])
        XCTAssertEqual(allContents, ["/directory", "/file.txt"])
    }

    func testDeleteDirectory() throws {
        let sut = VirtualFileDisk()
        try sut.createFile(atPath: "/file.txt")
        try sut.createDirectory(atPath: "/directory")

        try sut.deleteDirectory(atPath: "/directory")

        let files = try sut.files(atPath: "/")
        let allContents = try sut.contentsOfDirectory(atPath: "/")
        XCTAssertEqual(files, ["/file.txt"])
        XCTAssertEqual(allContents, ["/file.txt"])
    }

    func testContentsOfDirectory() throws {
        let sut = VirtualFileDisk()
        try sut.createFile(atPath: "/file.txt")
        try sut.createDirectory(atPath: "/directory")

        let contents = try sut.contentsOfDirectory(atPath: "/")

        XCTAssertEqual(contents, ["/directory", "/file.txt"])
    }

    func testContentsOfFile() throws {
        let sut = VirtualFileDisk()
        try sut.createFile(atPath: "/file.txt")

        let contents = try sut.contentsOfFile(atPath: "/file.txt")

        XCTAssert(contents.isEmpty)
    }

    func testFilesInDirectory() throws {
        let sut = VirtualFileDisk()
        try sut.createFile(atPath: "/file1.txt")
        try sut.createFile(atPath: "/file2.txt")
        try sut.createFile(atPath: "/directory/file1.txt")
        try sut.createFile(atPath: "/directory/file2.txt")

        let contents = try sut.filesInDirectory(atPath: "/", recursive: false)
        let contentsRecursive = try sut.filesInDirectory(atPath: "/", recursive: true)

        XCTAssertEqual(contents, ["/file1.txt", "/file2.txt"])
        XCTAssertEqual(contentsRecursive, ["/file1.txt", "/file2.txt", "/directory/file1.txt", "/directory/file2.txt"])
    }
}
