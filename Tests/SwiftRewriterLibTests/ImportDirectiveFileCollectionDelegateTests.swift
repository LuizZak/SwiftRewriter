import XCTest
import SwiftRewriterLib
import ObjcParser
import TestCommons

class ImportDirectiveFileCollectionDelegateTests: XCTestCase {
    var fileDisk: VirtualFileDisk!
    var parserPool: ParserPool!
    
    override func setUp() {
        super.setUp()

        fileDisk = VirtualFileDisk()
        parserPool = ParserPool(fileProvider: fileDisk,
                                parserStatePool: ObjcParserStatePool(),
                                antlrSettings: .default)
    }
    
    func testReferencedFilesForFile() throws {
        try fileDisk.createFile(atPath: "/a_file.h")
        let inputFile = InputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import "a_file.h"
            """)
        try parser.parse()
        parserPool.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserPool: parserPool, fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssertEqual(result.map { $0.path }, ["/a_file.h"])
    }
    
    func testReferencedFilesForFileIgnoresNonExistingFiles() throws {
        try fileDisk.createFile(atPath: "/a_file.h")
        let inputFile = InputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import "a_file.h"
            #import "a_non_existing_file.h"
            """)
        try parser.parse()
        parserPool.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserPool: parserPool, fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssertEqual(result.map { $0.path }, ["/a_file.h"])
    }
    
    func testReferencedFilesForFileIgnoresSystemImports() throws {
        let inputFile = InputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import <system_import.h>
            """)
        try parser.parse()
        parserPool.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserPool: parserPool, fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssert(result.isEmpty)
    }
}
