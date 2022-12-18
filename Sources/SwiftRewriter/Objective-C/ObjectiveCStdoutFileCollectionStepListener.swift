import Foundation
import Console
import ObjectiveCFrontend
import Utils

class ObjectiveCStdoutFileCollectionStepListener: ObjectiveCFileCollectionStepListener {
    func objectiveCFileCollectionStep(
        _ collectionStep: ObjectiveCFileCollectionStep,
        didAddReferencedFile referencedUrl: URL,
        sourceRange: SourceRange?,
        forInputFile inputFile: DiskInputFile
    ) {
        
        var message = "Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)"
        if let location = sourceRange?.start {
            message += ":\(location.line)"
            if location.column != 1 {
                message += ":\(location.column)"
            }
        }

        print(message)
    }
}
