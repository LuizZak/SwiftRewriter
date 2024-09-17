import TestCommons
import XCTest

@testable import JavaScriptFrontend

class JavaScriptFileCollectionStepTests: XCTestCase {
    var sut: JavaScriptFileCollectionStep!
    var fileDisk: VirtualFileDisk!

    override func setUp() {
        super.setUp()

        fileDisk = VirtualFileDisk()
        sut = JavaScriptFileCollectionStep(fileProvider: fileDisk)
    }

    func testAddFileFromUrl() throws {
        try fileDisk.createFile(atPath: "/directory/file.js")

        try sut.addFile(fromUrl: URL(string: "/directory/file.js")!, isPrimary: true)

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.js"])
    }

    func testAddFileFromUrlThrowsErrorOnInvalidFile() throws {
        XCTAssertThrowsError(
            try sut.addFile(fromUrl: URL(string: "/directory/file.js")!, isPrimary: true)
        )
    }

    func testAddFileFromUrlIgnoresDuplicates() throws {
        try fileDisk.createFile(atPath: "/directory/file.js")

        try sut.addFile(fromUrl: URL(string: "/directory/file.js")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file.js")!, isPrimary: true)

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.js"])
    }

    func testAddFileFromUrlPromotesNonPrimariesToPrimaries() throws {
        try fileDisk.createFile(atPath: "/directory/file1.js")
        try fileDisk.createFile(atPath: "/directory/file2.js")

        // Test both orders of 'isPrimary' flag: false -> true, true -> false
        try sut.addFile(fromUrl: URL(string: "/directory/file1.js")!, isPrimary: false)
        try sut.addFile(fromUrl: URL(string: "/directory/file1.js")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file2.js")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file2.js")!, isPrimary: false)

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file1.js", "/directory/file2.js"])
        XCTAssert(sut.files[0].isPrimary)
        XCTAssert(sut.files[1].isPrimary)
    }

    func testAddFileIgnoresDuplicates() throws {
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file.js")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file.js")!, isPrimary: true))

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.js"])
    }

    func testAddFilePromotesNonPrimariesToPrimaries() throws {
        // Test both orders of 'isPrimary' flag: false -> true, true -> false
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file1.js")!, isPrimary: false))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file1.js")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file2.js")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file2.js")!, isPrimary: false))

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file1.js", "/directory/file2.js"])
        XCTAssert(sut.files[0].isPrimary)
        XCTAssert(sut.files[1].isPrimary)
    }

    func testAddFromDirectoryRecursive() throws {
        try fileDisk.createFile(atPath: "/directory/file.js")
        try fileDisk.createFile(atPath: "/directory/file.other")
        try fileDisk.createFile(atPath: "/directory/subPath/file.js")
        try fileDisk.createFile(atPath: "/directory/subPath/file.other")

        try sut.addFromDirectory(URL(string: "/directory")!, recursive: true)

        XCTAssertEqual(
            Set(sut.files.map { $0.url.path }),
            [
                "/directory/file.js",
                "/directory/subPath/file.js",
            ]
        )
    }

    func testDelegateFileCollectionStepReferencedFilesForFile() throws {
        let file = DiskInputFile(url: URL(string: "/file.js")!, isPrimary: false)
        let mockDelegate = MockFileCollectionStepDelegate()
        sut.delegate = mockDelegate

        try sut.addFile(file)

        let invocations = mockDelegate.fileCollectionStepReferencedFilesForFile
        XCTAssertEqual(invocations.count, 1)
        XCTAssert(invocations[0].fileCollectionStep === sut)
        XCTAssertEqual(invocations[0].file as? DiskInputFile, file)
    }

    func testDelegateFileCollectionStepReferencedFilesForFile_CollectsFiles() throws {
        try fileDisk.createFile(atPath: "/import.js")
        let file = DiskInputFile(url: URL(string: "/file.js")!, isPrimary: true)
        let expected = DiskInputFile(url: URL(string: "/import.js")!, isPrimary: false)
        let mockDelegate = MockFileCollectionStepDelegate()
        mockDelegate.fileReferences = [URL(string: "/import.js")!]
        sut.delegate = mockDelegate

        try sut.addFile(file)

        XCTAssert(sut.files.contains(expected))
    }
}

private class MockFileCollectionStepDelegate: JavaScriptFileCollectionStepDelegate {
    var fileCollectionStepReferencedFilesForFile:
        [(fileCollectionStep: JavaScriptFileCollectionStep, file: InputSource)] = []
    var fileReferences: [URL] = []

    func javaScriptFileCollectionStep(
        _ fileCollectionStep: JavaScriptFileCollectionStep,
        referencedFilesForFile file: InputSource
    ) throws -> [URL] {
        fileCollectionStepReferencedFilesForFile.append((fileCollectionStep, file))
        return fileReferences
    }
}
