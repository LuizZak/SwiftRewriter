import Foundation

/// Represents a virtual file disk with files and folders to use during testing.
public class VirtualFileDisk {
    private var root: Directory

    public init() {
        root = Directory(name: "")
    }

    public func createFile(atPath path: String) throws {
        let pathComponents = path.splitPathComponents()
        let directoryPath = pathComponents.dropLast()

        try root.createDirectory(atPath: directoryPath.joined(separator: "/"))

        let directory = try self.directory(atPath: directoryPath.joined(separator: "/"))
        try directory.createFile(fileName: pathComponents[pathComponents.count - 1])
    }

    public func deleteFile(atPath path: String) throws {
        let pathComponents = path.splitPathComponents()
        let directoryPath = pathComponents.dropLast()

        let directory = try self.directory(atPath: directoryPath.joined(separator: "/"))
        try directory.deleteFile(fileName: pathComponents[pathComponents.count - 1])
    }

    public func files(atPath path: String) throws -> [String] {
        let dir = try directory(atPath: path)
        return dir.files.map { $0.fullPath }
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

    init(name: String) {
        self.name = name
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

    func createFile<S: StringProtocol>(fileName: S) throws {
        let file = File(name: String(fileName))
        file.parent = self
        files.append(file)
    }

    func deleteFile<S: StringProtocol>(fileName: S) throws {
        guard let index = files.firstIndex(where: { $0.name == fileName }) else {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(fileName)")
        }
        files.remove(at: index)
    }

    func createDirectory<S: StringProtocol>(name: S) throws {
        directories.append(Directory(name: String(name)))
    }

    func createDirectory(atPath path: String) throws {
        let components = path.splitPathComponents()
        if components.isEmpty {
            throw VirtualFileDisk.Error.invalidPath("\(fullPath)/\(path)")
        }
        if components[0] != name {
            throw VirtualFileDisk.Error.nonexistingPath(String(components[0]))
        }

        let remaining = Array(components.dropFirst())
        let directory = Directory(name: String(remaining[0]))
        directory.parent = self
        directories.append(directory)
        if remaining.count > 1 {
            try directory.createDirectory(name: remaining.dropFirst().joined(separator: "/"))
        }
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
        let remaining = components.dropFirst().joined(separator: "/")
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
