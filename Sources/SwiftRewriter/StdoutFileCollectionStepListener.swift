import Foundation
import Console
import ObjectiveCFrontend
import JavaScriptFrontend

class StdoutFileCollectionStepListener {
    
}

extension StdoutFileCollectionStepListener: ObjectiveCFileCollectionStepListener {
    func objectiveCFileCollectionStep(
        _ collectionStep: ObjectiveCFileCollectionStep,
        didAddReferencedFile referencedUrl: URL,
        forInputFile inputFile: DiskInputFile
    ) {
        
        print("Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)")
    }
}

extension StdoutFileCollectionStepListener: JavaScriptFileCollectionStepListener {
    func javaScriptFileCollectionStep(
        _ collectionStep: JavaScriptFileCollectionStep,
        didAddReferencedFile referencedUrl: URL,
        forInputFile inputFile: DiskInputFile
    ) {
        
        print("Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)")
    }
}
