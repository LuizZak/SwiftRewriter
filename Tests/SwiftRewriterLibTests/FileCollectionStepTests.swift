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

    func testAddFileFromUrl() throws {
        try fileDisk.createFile(atPath: "/directory/file.h")

        try sut.addFile(fromUrl: URL(string: "/directory/file.h")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file.m")!, isPrimary: true)

        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.h"])
    }
    
    func testAddFileFromUrlIgnoresDuplicates() throws {
        try fileDisk.createFile(atPath: "/directory/file.h")
        
        try sut.addFile(fromUrl: URL(string: "/directory/file.h")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file.h")!, isPrimary: true)
        
        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.h"])
    }
    
    func testAddFileFromUrlPromotesNonPrimariesToPrimaries() throws {
        try fileDisk.createFile(atPath: "/directory/file1.h")
        try fileDisk.createFile(atPath: "/directory/file2.h")
        
        // Test both orders of 'isPrimary' flag: false -> true, true -> false
        try sut.addFile(fromUrl: URL(string: "/directory/file1.h")!, isPrimary: false)
        try sut.addFile(fromUrl: URL(string: "/directory/file1.h")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file2.h")!, isPrimary: true)
        try sut.addFile(fromUrl: URL(string: "/directory/file2.h")!, isPrimary: false)
        
        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file1.h", "/directory/file2.h"])
        XCTAssert(sut.files[0].isPrimary)
        XCTAssert(sut.files[1].isPrimary)
    }
    
    func testAddFileIgnoresDuplicates() throws {
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file.h")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file.h")!, isPrimary: true))
        
        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file.h"])
    }
    
    func testAddFilePromotesNonPrimariesToPrimaries() throws {
        // Test both orders of 'isPrimary' flag: false -> true, true -> false
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file1.h")!, isPrimary: false))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file1.h")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file2.h")!, isPrimary: true))
        try sut.addFile(DiskInputFile(url: URL(string: "/directory/file2.h")!, isPrimary: false))
        
        XCTAssertEqual(sut.files.map { $0.url.path }, ["/directory/file1.h", "/directory/file2.h"])
        XCTAssert(sut.files[0].isPrimary)
        XCTAssert(sut.files[1].isPrimary)
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

    func testDelegateFileCollectionStepReferencedFilesForFile() throws {
        let file = DiskInputFile(url: URL(string: "/file.h")!, isPrimary: false)
        let mockDelegate = MockFileCollectionStepDelegate()
        sut.delegate = mockDelegate

        try sut.addFile(file)

        let invocations = mockDelegate.fileCollectionStepReferencedFilesForFile
        XCTAssertEqual(invocations.count, 1)
        XCTAssert(invocations[0].fileCollectionStep === sut)
        XCTAssertEqual(invocations[0].file, file)
    }

    func testDelegateFileCollectionStepReferencedFilesForFile_CollectsFiles() throws {
        try fileDisk.createFile(atPath: "/import.h")
        let file = DiskInputFile(url: URL(string: "/file.h")!, isPrimary: true)
        let expected = DiskInputFile(url: URL(string: "/import.h")!, isPrimary: false)
        let mockDelegate = MockFileCollectionStepDelegate()
        mockDelegate.fileReferences = [URL(string: "/import.h")!]
        sut.delegate = mockDelegate

        try sut.addFile(file)

        XCTAssert(sut.files.contains(expected))
    }
}

private class MockFileCollectionStepDelegate: FileCollectionStepDelegate {
    var fileCollectionStepReferencedFilesForFile: [(fileCollectionStep: FileCollectionStep, file: DiskInputFile)] = []
    var fileReferences: [URL] = []
    func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                            referencedFilesForFile file: DiskInputFile) throws -> [URL] {
        fileCollectionStepReferencedFilesForFile.append((fileCollectionStep, file))
        return fileReferences
    }
}
