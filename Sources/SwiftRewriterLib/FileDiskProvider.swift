import Foundation

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
