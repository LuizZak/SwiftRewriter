import Foundation

public class FileCollectionStep {
    var fileProvider: FileProvider
    var files: [InputFile] = []

    public init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
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
                // Check a matching .swift file doesn't already exist for the
                // paths (if `overwrite` is not on)
                .filter { (url: URL) -> Bool in
                    let swiftFile =
                        ((url.path as NSString)
                            .deletingPathExtension as NSString)
                            .appendingPathExtension("swift")!

                    if !fileProvider.fileExists(atPath: swiftFile) {
                        return true
                    }

                    return false
                }

        for fileUrl in objcFileUrls {
            let file = InputFile(url: fileUrl, isPrimary: true)
            try addFile(file)
        }
    }

    public func addFile(_ file: InputFile) throws {
        files.append(file)
    }
}

public protocol FileProvider {
    func enumerator(atPath: String) -> [String]?
    func fileExists(atPath: String) -> Bool
}
