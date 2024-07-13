import Foundation
import SwiftRewriterLib
import Utils

public class ObjectiveCFileCollectionStep {
    var fileProvider: FileProvider
    public private(set) var files: [DiskInputFile] = []
    public weak var delegate: ObjectiveCFileCollectionStepDelegate?
    public var listener: ObjectiveCFileCollectionStepListener?

    public init(fileProvider: FileProvider = FileDiskProvider()) {
        self.fileProvider = fileProvider
    }

    public func addFile(fromUrl url: URL, isPrimary: Bool) throws {
        // Promote non-primary files into primaries
        if let index = files.firstIndex(where: { $0.url == url }) {
            files[index].isPrimary = files[index].isPrimary || isPrimary
            
            return
        }
        
        if fileProvider.fileExists(atUrl: url) {
            let file = DiskInputFile(url: url, isPrimary: isPrimary)
            try addFile(file)
        } else {
            throw Error.fileDoesNotExist(path: url.path)
        }
    }

    public func addFile(_ file: DiskInputFile) throws {
        // Promote non-primary files into primaries
        if let index = files.firstIndex(where: { $0.url == file.url }) {
            files[index].isPrimary = files[index].isPrimary || file.isPrimary
            
            return
        }
        
        files.append(file)
        try resolveReferences(in: file)
    }

    public func addFromDirectory(
        _ directory: URL,
        recursive: Bool,
        includePattern: String? = nil,
        excludePattern: String? = nil
    ) throws {
        let allFiles = try fileProvider
        .contentsOfDirectory(
            atUrl: directory,
            shallow: !recursive
        )

        // Inclusions
        let objcFiles =
            allFiles.filter { path in
                fileMatchesFilter(
                    path: path,
                    includePattern: includePattern,
                    excludePattern: excludePattern
                )
            }
            // Sort files, for convenience of better conveying progress to user
            .sorted { (s1: URL, s2: URL) -> Bool in
                let name1 = s1.lastPathComponent
                let name2 = s2.lastPathComponent
                
                return name1.compare(name2, options: .numeric) == .orderedAscending
            }

        // Filter down to .h/.m files
        let objcFileUrls =
            objcFiles.filter { (path: URL) -> Bool in
                path.pathExtension == "m" || path.pathExtension == "h"
            }

        for fileUrl in objcFileUrls {
            let file = DiskInputFile(url: fileUrl, isPrimary: true)
            try addFile(file)
        }
    }

    func hasFile(_ url: URL) -> Bool {
        return files.contains { $0.url == url }
    }

    private func resolveReferences(in file: DiskInputFile) throws {
        guard let delegate = delegate else {
            return
        }

        let references = try delegate.objectiveCFileCollectionStep(self, referencedFilesForFile: file)

        for (url, range) in references {
            if !hasFile(url) && fileProvider.fileExists(atUrl: url) {
                listener?.objectiveCFileCollectionStep(
                    self,
                    didAddReferencedFile: url,
                    sourceRange: range,
                    forInputFile: file
                )
                
                try addFile(fromUrl: url, isPrimary: false)
            }
        }
    }
    
    public enum Error: Swift.Error, CustomStringConvertible {
        case fileDoesNotExist(path: String)
        
        public var description: String {
            switch self {
            case .fileDoesNotExist(let path):
                return "File does not exist at path '\(path)'"
            }
        }
    }
}

public extension ObjectiveCFileCollectionStep {
    func makeInputSourcesProvider() -> InputSourcesProvider {
        return InternalSourcesProvider(files: files)
    }
    
    private struct InternalSourcesProvider: InputSourcesProvider {
        let files: [DiskInputFile]
        
        func sources() -> [InputSource] {
            return files
        }
    }
}

// TODO: Maybe merge with ObjectiveCFileCollectionStepDelegate?
public protocol ObjectiveCFileCollectionStepListener {
    func objectiveCFileCollectionStep(
        _ collectionStep: ObjectiveCFileCollectionStep,
        didAddReferencedFile referencedUrl: URL,
        sourceRange: SourceRange?,
        forInputFile inputFile: DiskInputFile
    )
}
