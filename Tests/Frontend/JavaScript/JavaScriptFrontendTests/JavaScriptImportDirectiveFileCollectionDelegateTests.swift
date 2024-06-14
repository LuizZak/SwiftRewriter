import JsParser
import TestCommons
import XCTest

@testable import JavaScriptFrontend

class JavaScriptImportDirectiveFileCollectionDelegateTests: XCTestCase {
    var fileDisk: VirtualFileDisk!
    var parserCache: JavaScriptParserCache!

    override func setUp() {
        super.setUp()

        fileDisk = VirtualFileDisk()
        parserCache = JavaScriptParserCache(
            fileProvider: fileDisk,
            parserStatePool: JsParserStatePool(),
            antlrSettings: .default
        )
    }

    func testReferencedFilesForFile() throws {
        try fileDisk.createFile(atPath: "/a_file.js")
        let url = URL(fileURLWithPath: "/input.js")
        let inputFile = SingleInputProvider(code: "", isPrimary: true, fileName: url.path)
        let parser = JsParser(
            string: """
                import { decl } from "./a_file.js";
                """
        )
        try parser.parse()
        parserCache.replaceCachedParsedTree(file: url, parser: parser)
        let sut = JavaScriptImportDirectiveFileCollectionDelegate(
            parserCache: parserCache,
            fileProvider: fileDisk
        )

        let result =
            try sut.javaScriptFileCollectionStep(
                JavaScriptFileCollectionStep(fileProvider: fileDisk),
                referencedFilesForFile: inputFile
            )

        XCTAssertEqual(result.map { $0.path }, ["/a_file.js"])
    }

    func testReferencedFilesForFileIgnoresNonExistingFiles() throws {
        try fileDisk.createFile(atPath: "/a_file.js")
        let url = URL(fileURLWithPath: "/input.js")
        let inputFile = SingleInputProvider(code: "", isPrimary: true, fileName: url.path)
        let parser = JsParser(
            string: """
                import { decl } from "./a_file.js";
                import { other_decl } from "./a_non_existing_file.js";
                """
        )
        try parser.parse()
        parserCache.replaceCachedParsedTree(file: url, parser: parser)
        let sut = JavaScriptImportDirectiveFileCollectionDelegate(
            parserCache: parserCache,
            fileProvider: fileDisk
        )

        let result =
            try sut.javaScriptFileCollectionStep(
                JavaScriptFileCollectionStep(fileProvider: fileDisk),
                referencedFilesForFile: inputFile
            )

        XCTAssertEqual(result.map { $0.path }, ["/a_file.js"])
    }
}
