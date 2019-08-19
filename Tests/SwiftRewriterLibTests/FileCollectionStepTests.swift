import XCTest
import TestCommons
import SwiftRewriterLib

class FileCollectionStepTests: XCTestCase {
    var sut: FileCollectionStep!
    var fileDisk: VirtualFileDisk!

    override func setUp() {
        super.setUp()

        fileDisk = VirtualFileDisk()
        sut = FileCollectionStep(fileProvider: fileDisk)
    }

    func testAddFileFromURL() throws {
        try fileDisk.createFile(atPath: "/directory/file.h")

        try sut.addFile(fromUrl: URL(string: "/directory/file.h")!)
        try sut.addFile(fromUrl: URL(string: "/directory/file.m")!)

        XCTAssertEqual(sut.files.map { $0.url.path },
                       ["/directory/file.h"])
    }

    func testAddFromDirectoryRecursive() throws {
        try fileDisk.createFile(atPath: "/directory/file.h")
        try fileDisk.createFile(atPath: "/directory/file.m")
        try fileDisk.createFile(atPath: "/directory/file.other")
        try fileDisk.createFile(atPath: "/directory/subPath/file.h")
        try fileDisk.createFile(atPath: "/directory/subPath/file.m")
        try fileDisk.createFile(atPath: "/directory/subPath/file.other")

        try sut.addFromDirectory(URL(string: "/directory")!, recursive: true)

        XCTAssertEqual(sut.files.map { $0.url.path },
                       ["/directory/file.h",
                        "/directory/file.m",
                        "/directory/subPath/file.h",
                        "/directory/subPath/file.m"])
    }
}
