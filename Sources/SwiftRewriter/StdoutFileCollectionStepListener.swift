import Foundation
import SwiftRewriterLib
import Console

class StdoutFileCollectionStepListener: FileCollectionStepListener {
    func fileCollectionStep(_ collectionStep: FileCollectionStep,
                            didAddReferencedFile referencedUrl: URL,
                            forInputFile inputFile: DiskInputFile) {
        
        print("Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)")
    }
}
