import Foundation
import SwiftRewriterLib

/// Represents a virtual file disk with files and folders to use during testing.
public class VirtualFileDisk {
    private var root: Directory

    public init() {
        root = Directory(name: "")
    }

    public func createFile(atPath path: String, data: Data? = nil) throws {
        let pathComponents = path.splitPathComponents()
        let directoryPath = pathComponents.dropLast()

        let directory = try root.createDirectory(atPath: directoryPath.joinedFullPath())
        let file = try directory.createFile(fileName: pathComponents[pathComponents.count - 1])
        if let data = data {
            file.data = data
        }
    }

    public func createDirectory(atPath path: String) throws {
       let pathComponents = path.splitPathComponents()
       let directoryPath = pathComponents.dropLast()

       let directory = try root.createDirectory(atPath: directoryPath.joinedFullPath())
       try directory.createDirectory(name: pathComponents[pathComponents.count - 1])
   }

    public func deleteFile(atPath path: String) throws {
        let pathComponents = path.splitPathComponents()
        let directoryPath = pathComponents.dropLast()

        let directory = try self.directory(atPath: directoryPath.joinedFullPath())
        try directory.deleteFile(named: pathComponents[pathComponents.count - 1])
    }

    public func deleteDirectory(atPath path: String) throws {
        let pathComponents = path.splitPathComponents()
        let directoryPath = pathComponents.dropLast()

        let directory = try self.directory(atPath: directoryPath.joinedFullPath())
        try directory.deleteDirectory(named: pathComponents[pathComponents.count - 1])
    }

    public func contentsOfFile(atPath path: String) throws -> Data {
        let file = try self.file(atPath: path)
        return file.data
    }

    public func writeContentsOfFile(atPath path: String, data: Data) throws {
        let file = try self.file(atPath: path)
        file.data = data
    }

    public func files(atPath path: String) throws -> [String] {
        let dir = try directory(atPath: path)
        return dir.files.map { $0.fullPath }
    }

    public func contentsOfDirectory(atPath path: String) throws -> [String] {
        let dir = try directory(atPath: path)
        return dir.directories.map { $0.fullPath } + dir.files.map { $0.fullPath }
    }

    public func filesInDirectory(atPath path: String, recursive: Bool) throws -> [String] {
        if !recursive {
            return try directory(atPath: path).files.map { $0.fullPath }
        }
        
        var files: [String] = []
        var stack: [String] = [path]

        while let nextPath = stack.popLast() {
            let dir = try directory(atPath: nextPath)
            
            files.append(contentsOf: dir.files.map { $0.fullPath })
            stack.append(contentsOf: dir.directories.map { $0.fullPath })
        }

        return files
    }

    private func file(atPath path: String) throws -> File {
        return try root.file(atPath: path)
    }

    private func directory(atPath path: String) throws -> Directory {
        return try root.directory(atPath: path)
    }

    public enum Error: Swift.Error {
        case invalidPath(String)
        case nonexistingPath(String)
        case notDirectory(String)
    }
}

fileprivate protocol DirectoryEntry: class {
    var parent: DirectoryEntry? { get }
    var name: String { get }
    var fullPath: String { get }
}

extension DirectoryEntry {
    var fullPath: String {
        if let parent = parent?.fullPath {
            return "\(parent)/\(name)"
        }
        return name
    }
}

fileprivate class File: DirectoryEntry {
    weak var parent: DirectoryEntry?
    var name: String
    var data: Data

    init(name: String) {
        self.name = name
        data = Data()
    }
}

fileprivate class Directory: DirectoryEntry {
    weak var parent: DirectoryEntry?

    var name: String
    var files: [File]
    var directories: [Directory]

    init(name: String) {
        self.name = name
        files = []
        directories = []
    }

    @discardableResult
    func createFile<S: StringProtocol>(fileName: S) throws -> File {
        let file = File(name: String(fileName))
        file.parent = self
        files.append(file)
        return file
    }

    func deleteFile<S: StringProtocol>(named fileName: S) throws {
        guard let index = files.firstIndex(where: { $0.name == fileName }) else {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(fileName)")
        }
        files.remove(at: index)
    }

    @discardableResult
    func createDirectory<S: StringProtocol>(name: S) throws -> Directory {
        let directory = Directory(name: String(name))
        directory.parent = self
        directories.append(directory)
        return directory
    }

    func deleteDirectory<S: StringProtocol>(named directoryName: S) throws {
        guard let index = directories.firstIndex(where: { $0.name == directoryName }) else {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(directoryName)")
        }
        directories.remove(at: index)
    }

    @discardableResult
    func createDirectory(atPath path: String) throws -> Directory {
        let directory: Directory
        let components = path.splitPathComponents()
        if components.isEmpty {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(path)")
        }

        if components[0] != name {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(path)")
        }
        if components.count == 1 {
            return self
        }

        let remaining = Array(components.dropFirst())

        if let dir = directories.first(where: { $0.name == remaining[0] }) {
            directory = dir
        } else {
            directory = try createDirectory(name: String(remaining[0]))
        }

        if remaining.count > 1 {
            return try directory.createDirectory(atPath: remaining.joinedFullPath())
        }

        return directory
    }

    func file(atPath path: String) throws -> File {
        let components = path.splitPathComponents()
        if components.isEmpty {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(path)")
        }
        if components[0] != name {
            throw VirtualFileDisk.Error.nonexistingPath(String(components[0]))
        }
        if components.count == 2 {
            guard let file = files.first(where: { $0.name == components[1] }) else {
                throw VirtualFileDisk.Error.nonexistingPath(String(components[1]))
            }
            return file
        }
        guard let directory = directories.first(where: { $0.name == components[1] }) else {
            throw VirtualFileDisk.Error.invalidPath(path)
        }
        let remaining = components.dropFirst().joinedFullPath()
        return try directory.file(atPath: remaining)
    }

    func directory(atPath path: String) throws -> Directory {
        let components = path.splitPathComponents()
        if components.isEmpty {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(path)")
        }
        if components[0] != name {
            throw VirtualFileDisk.Error.nonexistingPath(String(components[0]))
        }
        if components.count == 1 {
            return self
        }
        guard let directory = directories.first(where: { $0.name == components[1] }) else {
            throw VirtualFileDisk.Error.invalidPath(path)
        }
        let remaining = components.dropFirst().joinedFullPath()
        return try directory.directory(atPath: remaining)
    }
}

private extension StringProtocol {
    func splitPathComponents() -> [SubSequence] {
        let components = split(separator: "/", omittingEmptySubsequences: false)
        if components.last == "" {
            return components.dropLast()
        }
        return components
    }
}

private extension Sequence where Element: StringProtocol {
    func joinedFullPath() -> String {
        let result = joined(separator: "/")
        if result.isEmpty {
            return "/"
        }
        return result
    }
}

extension VirtualFileDisk: FileProvider {
    public func enumerator(atPath path: String) -> [String]? {
        do {
            return try filesInDirectory(atPath: path, recursive: true)
        } catch {
            return nil
        }
    }
    public func fileExists(atPath path: String) -> Bool {
        do {
            _ = try file(atPath: path)
            return true
        } catch {
            return false
        }
    }
}
