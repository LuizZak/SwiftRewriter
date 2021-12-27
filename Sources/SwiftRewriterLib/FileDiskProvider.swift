import Foundation

public class FileDiskProvider: FileProvider {
    var fileManager: FileManager

    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    public func enumerator(atUrl url: URL) -> [URL]? {
        return fileManager
            .enumerator(atPath: url.path)?
            .compactMap { $0 as? String }
            .map { url.appendingPathComponent($0) }
    }

    public func fileExists(atUrl url: URL) -> Bool {
        return fileManager.fileExists(atPath: url.path)
    }

    public func fileExists(atUrl url: URL, isDirectory: inout Bool) -> Bool {
        var isDirectoryObjc: ObjCBool = false
        defer {
            isDirectory = isDirectoryObjc.boolValue
        }

        return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectoryObjc)
    }

    public func directoryExists(atUrl url: URL) -> Bool {
        var isDirectory: ObjCBool = false

        return fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    public func contentsOfFile(atUrl url: URL) throws -> Data {
        guard let data = fileManager.contents(atPath: url.path) else {
            throw Error.invalidFileData
        }
        
        return data
    }

    public func contentsOfDirectory(atUrl url: URL, shallow: Bool) throws -> [URL] {
        var options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
        ]
        if shallow {
            options.insert(.skipsSubdirectoryDescendants)
        }

        return try fileManager.contentsOfDirectory(at:
            url,
            includingPropertiesForKeys: nil,
            options: options
        )
    }

    public func homeDirectoryForCurrentUser() -> URL {
        fileManager.homeDirectoryForCurrentUser
    }

    public enum Error: Swift.Error {
        case invalidFileData
    }
}
