import Foundation

public protocol FileProvider {
    /// Gets the path to the current user's home directory
    var userHomeURL: URL { get }
    
    func allFilesRecursive(inPath path: String) -> [String]?
    func fileExists(atPath path: String) -> Bool
    func directoryExists(atPath path: String) -> Bool
    func contentsOfFile(atPath path: String) throws -> Data
    
    func createDirectory(atPath path: String) throws
    func deleteDirectory(atPath path: String) throws
    func save(data: Data, atPath path: String) throws
}

public class FileDiskProvider: FileProvider {
    var fileManager: FileManager
    
    public var userHomeURL: URL {
        if #available(OSX 10.12, *) {
            return fileManager.homeDirectoryForCurrentUser
        } else {
            return URL(fileURLWithPath: NSHomeDirectory())
        }
    }

    public init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }

    public func allFilesRecursive(inPath path: String) -> [String]? {
        return fileManager
            .enumerator(atPath: path)?
            .compactMap { $0 as? String }
            .map { URL(string: path)!.appendingPathComponent($0).path }
    }

    public func fileExists(atPath path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    public func directoryExists(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }

    public func contentsOfFile(atPath path: String) throws -> Data {
        guard let data = fileManager.contents(atPath: path) else {
            throw Error.invalidFileData
        }
        
        return data
    }
    
    public func createDirectory(atPath path: String) throws {
        try fileManager.createDirectory(at: URL(fileURLWithPath: path),
                                        withIntermediateDirectories: true,
                                        attributes: nil)
    }
    
    public func deleteDirectory(atPath path: String) throws {
        try fileManager.removeItem(atPath: path)
    }
    
    public func save(data: Data, atPath path: String) throws {
        try data.write(to: URL(fileURLWithPath: path))
    }

    public enum Error: Swift.Error {
        case invalidFileData
    }
}
