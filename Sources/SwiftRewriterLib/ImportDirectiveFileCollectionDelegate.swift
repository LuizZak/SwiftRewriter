import Foundation
import ObjcParser

public class ImportDirectiveFileCollectionDelegate {
    var parserCache: ParserCache
    let fileProvider: FileProvider
    
    public init(parserCache: ParserCache, fileProvider: FileProvider) {
        self.parserCache = parserCache
        self.fileProvider = fileProvider
    }
}

extension ImportDirectiveFileCollectionDelegate: FileCollectionStepDelegate {
    public func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                                   referencedFilesForFile file: DiskInputFile) throws -> [URL] {

        let parserTree = try parserCache.loadParsedTree(file: file.url)
        let fileReferences =
            parserTree.importDirectives
                .filter { !$0.isSystemImport }
                .map { $0.path }
                .filter { $0.hasSuffix(".h") }

        let basePath = file.url.deletingLastPathComponent()

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
