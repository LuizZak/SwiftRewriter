import Foundation
import SwiftRewriterLib
import Utils

public protocol ObjectiveCFileCollectionStepDelegate: AnyObject {
    func objectiveCFileCollectionStep(
        _ fileCollectionStep: ObjectiveCFileCollectionStep,
        referencedFilesForFile file: InputSource
    ) throws -> [(file: URL, range: SourceRange?)]
}
