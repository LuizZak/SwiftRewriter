import Foundation

public protocol FileCollectionStepDelegate: class {
    func fileCollectionStep(_ fileCollectionStep: FileCollectionStep,
                            referencedFilesForFile file: DiskInputFile) throws -> [URL]
}
