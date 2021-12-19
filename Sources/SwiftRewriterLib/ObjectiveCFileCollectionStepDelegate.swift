import Foundation

public protocol ObjectiveCFileCollectionStepDelegate: AnyObject {
    func objectiveCFileCollectionStep(_ fileCollectionStep: ObjectiveCFileCollectionStep,
                                      referencedFilesForFile file: InputSource) throws -> [URL]
}
