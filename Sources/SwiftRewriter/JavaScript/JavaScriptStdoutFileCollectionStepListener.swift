import Foundation
import Console
import JavaScriptFrontend

class JavaScriptStdoutFileCollectionStepListener: JavaScriptFileCollectionStepListener {
    func javaScriptFileCollectionStep(
        _ collectionStep: JavaScriptFileCollectionStep,
        didAddReferencedFile referencedUrl: URL,
        forInputFile inputFile: DiskInputFile
    ) {
        
        print("Found referenced file \(referencedUrl.lastPathComponent) from input file \(inputFile.url.lastPathComponent)")
    }
}
