import Foundation

public class FileCollectionStep {
    var fileProvider: FileProvider
    public private(set) var files: [InputFile] = []

    public init(fileProvider: FileProvider = FileDiskProvider()) {
        self.fileProvider = fileProvider
    }

    public func addFile(fromUrl url: URL) throws {
        if fileProvider.fileExists(atPath: url.path) {
            files.append(InputFile(url: url, isPrimary: true))
        }
    }

    public func addFile(_ file: InputFile) throws {
        files.append(file)
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
