import Foundation
import ObjcParser
import SwiftRewriterLib
import Utils

public class ObjectiveCImportDirectiveFileCollectionDelegate {
    var parserCache: ObjectiveCParserCache
    let fileProvider: FileProvider
    
    public init(parserCache: ObjectiveCParserCache, fileProvider: FileProvider) {
        self.parserCache = parserCache
        self.fileProvider = fileProvider
    }
}

extension ObjectiveCImportDirectiveFileCollectionDelegate: ObjectiveCFileCollectionStepDelegate {
    public func objectiveCFileCollectionStep(
        _ fileCollectionStep: ObjectiveCFileCollectionStep,
        referencedFilesForFile file: InputSource
    ) throws -> [(file: URL, range: SourceRange?)] {

        let parserTree = try parserCache.loadParsedTree(input: file)
        let fileReferences =
            parserTree.importDirectives
                .filter { !$0.isSystemImport }
                .filter { $0.path.hasSuffix(".h") }

        let basePath = URL(fileURLWithPath: file.sourcePath()).deletingLastPathComponent()

        var results: [(URL, SourceRange)] = []

        for importDecl in fileReferences {
            let importPath = importDecl.path
            let fileName = importPath.lastPathComponent
            let path = basePath.appendingPathComponent(fileName)

            if fileProvider.fileExists(atUrl: path) {
                results.append((path, importDecl.sourceRange))
            }
        }

        return results
    }
}
