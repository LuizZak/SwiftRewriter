import XCTest
import SwiftRewriterLib
import ObjcParser
import TestCommons

class ImportDirectiveFileCollectionDelegateTests: XCTestCase {
    var fileDisk: VirtualFileDisk!
    var parserCache: ParserCache!
    
    override func setUp() {
        super.setUp()

        fileDisk = VirtualFileDisk()
        parserCache = ParserCache(fileProvider: fileDisk,
                                  parserStatePool: ObjcParserStatePool(),
                                  antlrSettings: .default)
    }
    
    func testReferencedFilesForFile() throws {
        try fileDisk.createFile(atPath: "/a_file.h")
        let inputFile = DiskInputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import "a_file.h"
            """)
        try parser.parse()
        parserCache.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserCache: parserCache,
                                                        fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssertEqual(result.map { $0.path }, ["/a_file.h"])
    }
    
    func testReferencedFilesForFileIgnoresNonExistingFiles() throws {
        try fileDisk.createFile(atPath: "/a_file.h")
        let inputFile = DiskInputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import "a_file.h"
            #import "a_non_existing_file.h"
            """)
        try parser.parse()
        parserCache.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserCache: parserCache,
                                                        fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssertEqual(result.map { $0.path }, ["/a_file.h"])
    }
    
    func testReferencedFilesForFileIgnoresSystemImports() throws {
        let inputFile = DiskInputFile(url: URL(string: "/input.h")!, isPrimary: true)
        let parser = ObjcParser(string: """
            #import <system_import.h>
            """)
        try parser.parse()
        parserCache.storeParsedTree(file: inputFile.url, parser: parser)
        let sut = ImportDirectiveFileCollectionDelegate(parserCache: parserCache,
                                                        fileProvider: fileDisk)
        
        let result =
            try sut.fileCollectionStep(FileCollectionStep(fileProvider: fileDisk),
                                       referencedFilesForFile: inputFile)
        
        XCTAssert(result.isEmpty)
    }
}
