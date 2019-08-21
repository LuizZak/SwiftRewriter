import Foundation

public class FileCollectionStep {
    var fileProvider: FileProvider
    public private(set) var files: [InputFile] = []
    public weak var delegate: FileCollectionStepDelegate?

    public init(fileProvider: FileProvider = FileDiskProvider()) {
        self.fileProvider = fileProvider
    }

    public func addFile(fromUrl url: URL, isPrimary: Bool) throws {
        if fileProvider.fileExists(atPath: url.path) {
            let file = InputFile(url: url, isPrimary: isPrimary)
            try addFile(file)
        }
    }

    public func addFile(_ file: InputFile) throws {
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
            }.map(URL.init(fileURLWithPath:))

        let objcFileUrls: [URL] =
                // Filter down to .h/.m files
                objcFiles.filter { (path: URL) -> Bool in
                    ((path.path as NSString).pathExtension == "m"
                        || (path.path as NSString).pathExtension == "h")
                }

        for fileUrl in objcFileUrls {
            let file = InputFile(url: fileUrl, isPrimary: true)
            try addFile(file)
        }
    }

    func hasFile(_ url: URL) -> Bool {
        return files.contains { $0.url == url }
    }

    private func resolveReferences(in file: InputFile) throws {
        guard let delegate = delegate else {
            return
        }

        let references = try delegate.fileCollectionStep(self, referencedFilesForFile: file)

        for url in references {
            if !hasFile(url) {
                try addFile(fromUrl: url, isPrimary: false)
            }
        }
    }
}

public protocol FileProvider {
    func enumerator(atPath path: String) -> [String]?
    func fileExists(atPath path: String) -> Bool
}

public class FileDiskProvider: FileProvider {
    var fileManager: FileManager

    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    public func enumerator(atPath path: String) -> [String]? {
        return fileManager.enumerator(atPath: path)?.compactMap { $0 as? String }
    }

    public func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
}
