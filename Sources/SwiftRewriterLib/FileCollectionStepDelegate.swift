import Foundation

public protocol FileCollectionStepDelegate: class {
    func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                            referencedFilesForFile file: InputFile) throws -> [URL]
}
