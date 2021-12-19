import Foundation
import SwiftRewriterLib
import Console

class StdoutFileCollectionStepListener: ObjectiveCFileCollectionStepListener {
    func objectiveCFileCollectionStep(_ collectionStep: ObjectiveCFileCollectionStep,
                                      didAddReferencedFile referencedUrl: URL,
                                      forInputFile inputFile: DiskInputFile) {
        
        print("Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)")
    }
}
