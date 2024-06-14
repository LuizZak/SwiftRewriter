import Foundation
import SwiftRewriterLib

public protocol JavaScriptFileCollectionStepDelegate: AnyObject {
    func javaScriptFileCollectionStep(
        _ fileCollectionStep: JavaScriptFileCollectionStep,
        referencedFilesForFile file: InputSource
    ) throws -> [URL]
}
