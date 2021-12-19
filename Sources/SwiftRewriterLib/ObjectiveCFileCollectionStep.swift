import Foundation

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
        
        if fileProvider.fileExists(atPath: url.path) {
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

    public func addFromDirectory(_ directory: URL,
                                 recursive: Bool,
                                 includePattern: String? = nil,
                                 excludePattern: String? = nil) throws {

        guard let allFiles = fileProvider.enumerator(atPath: directory.path) else {
            return
        }

        // Inclusions
        let objcFiles =
            allFiles.filter { path in
                fileMatchesFilter(path: path,
                                  includePattern: includePattern,
                                  excludePattern: excludePattern)
            }
            // Sort files, for convenience of better conveying progress to user
            .sorted { (s1: String, s2: String) -> Bool in
                let name1 = (s1 as NSString).lastPathComponent
                let name2 = (s2 as NSString).lastPathComponent
                
                return name1.compare(name2, options: .numeric) == .orderedAscending
            }
            .map(URL.init(fileURLWithPath:))

        let objcFileUrls: [URL] =
                // Filter down to .h/.m files
                objcFiles.filter { (path: URL) -> Bool in
                    ((path.path as NSString).pathExtension == "m"
                        || (path.path as NSString).pathExtension == "h")
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

        for url in references {
            if !hasFile(url) && fileProvider.fileExists(atPath: url.path) {
                listener?.objectiveCFileCollectionStep(self, didAddReferencedFile: url,
                                                       forInputFile: file)
                
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

public protocol FileProvider {
    func enumerator(atPath path: String) -> [String]?
    func fileExists(atPath path: String) -> Bool
    func contentsOfFile(atPath path: String) throws -> Data
}

public class FileDiskProvider: FileProvider {
    var fileManager: FileManager

    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    public func enumerator(atPath path: String) -> [String]? {
        return fileManager
            .enumerator(atPath: path)?
            .compactMap { $0 as? String }
            .map { URL(string: path)!.appendingPathComponent($0).path }
    }

    public func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }

    public func contentsOfFile(atPath path: String) throws -> Data {
        guard let data = fileManager.contents(atPath: path) else {
            throw Error.invalidFileData
        }
        
        return data
    }

    public enum Error: Swift.Error {
        case invalidFileData
    }
}

// TODO: Maybe merge with FileCollectionStepDelegate?
public protocol ObjectiveCFileCollectionStepListener {
    func objectiveCFileCollectionStep(_ collectionStep: ObjectiveCFileCollectionStep,
                                      didAddReferencedFile referencedUrl: URL,
                                      forInputFile inputFile: DiskInputFile)
}
