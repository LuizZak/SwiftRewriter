import Foundation
import SwiftRewriterLib
import ObjectiveCFrontend
import SwiftRewriterCLI

class ObjectiveCFrontendImpl: SwiftRewriterFrontend {
    private let rewriterService: ObjectiveCSwiftRewriterService

    let name: String = "Objective-C"

    init(rewriterService: ObjectiveCSwiftRewriterService) {
        self.rewriterService = rewriterService
    }

    func collectFiles(from directory: URL, fileProvider: FileProvider, options: SwiftRewriterFrontendFileCollectionOptions) throws -> [DiskInputFile] {
        let fileCollectionStep = ObjectiveCFileCollectionStep(fileProvider: fileProvider)
        let importFileDelegate = ObjectiveCImportDirectiveFileCollectionDelegate(
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
