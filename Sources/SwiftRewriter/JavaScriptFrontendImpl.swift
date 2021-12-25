import Foundation
import SwiftRewriterLib
import JavaScriptFrontend

class JavaScriptFrontendImpl: SwiftRewriterFrontend {
    private let rewriterService: JavaScriptSwiftRewriterService

    let name: String = "JavaScript"

    init(rewriterService: JavaScriptSwiftRewriterService) {
        self.rewriterService = rewriterService
    }

    func collectFiles(from directory: URL, fileProvider: FileProvider, options: SwiftRewriterFrontendFileCollectionOptions) throws -> [DiskInputFile] {
        let fileCollectionStep = JavaScriptFileCollectionStep(fileProvider: fileProvider)
        let importFileDelegate
            = JavaScriptImportDirectiveFileCollectionDelegate(
                parserCache: rewriterService.parserCache,
                fileProvider: fileProvider
            )
        if options.followImports {
            fileCollectionStep.delegate = importFileDelegate
        }
        if options.verbose {
            fileCollectionStep.listener = StdoutFileCollectionStepListener()
        }

        try withExtendedLifetime(importFileDelegate) {
            try fileCollectionStep.addFromDirectory(
                directory,
                recursive: true,
                includePattern: options.includePattern,
                excludePattern: options.excludePattern
            )
        }

        return fileCollectionStep.files
    }

    func makeRewriterService() -> SwiftRewriterService {
        rewriterService
    }
}
