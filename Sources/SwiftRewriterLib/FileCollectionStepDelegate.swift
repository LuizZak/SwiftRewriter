import Foundation

public protocol FileCollectionStepDelegate: AnyObject {
    func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                            referencedFilesForFile file: InputSource) throws -> [URL]
}
