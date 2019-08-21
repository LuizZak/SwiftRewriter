import Foundation
import ObjcParser

public class ImportDirectiveFileCollectionDelegate {
    var parserPool: ParserPool
    let fileProvider: FileProvider

    init(parserPool: ParserPool, fileProvider: FileProvider) {
        self.parserPool = parserPool
        self.fileProvider = fileProvider
    }
}

extension ImportDirectiveFileCollectionDelegate: FileCollectionStepDelegate {
    public func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                                   referencedFilesForFile file: InputFile) throws -> [URL] {

        let parserTree = try parserPool.loadParsedTree(file: file.url)
        let fileReferences = parserTree.importDirectives.map { $0.path }.filter { $0.hasSuffix(".h") }

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
