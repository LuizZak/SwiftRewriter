import Foundation
import ObjcParser
import SwiftRewriterLib

public class JavaScriptImportDirectiveFileCollectionDelegate {
    var parserCache: JavaScriptParserCache
    let fileProvider: FileProvider
    
    public init(parserCache: JavaScriptParserCache, fileProvider: FileProvider) {
        self.parserCache = parserCache
        self.fileProvider = fileProvider
    }
}

extension JavaScriptImportDirectiveFileCollectionDelegate: JavaScriptFileCollectionStepDelegate {
    public func javaScriptFileCollectionStep(_ fileCollectionStep: JavaScriptFileCollectionStep,
                                             referencedFilesForFile file: InputSource) throws -> [URL] {

        let parserTree = try parserCache.loadParsedTree(input: file)
        let fileReferences =
            parserTree.importDirectives
                .filter { !$0.isSystemImport }
                .map { $0.path }
                .filter { $0.hasSuffix(".js") }

        let basePath = URL(fileURLWithPath: file.sourcePath()).deletingLastPathComponent()

        var urls: [URL] = []

        for reference in fileReferences {
            let fileName = (reference as NSString).lastPathComponent
            let path = basePath.appendingPathComponent(fileName)

            if fileProvider.fileExists(atPath: path.path) {
                urls.append(path)
            }
        }

        return urls
    }
}
