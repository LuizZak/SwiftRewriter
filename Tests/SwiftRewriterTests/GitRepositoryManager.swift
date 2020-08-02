import Foundation

class GitRepositoryManager {
    /// Creates a git repository at the default base project location
    static func makeDefault() throws -> GitRepositoryManager {
        return try GitRepositoryManager(basePath: baseProjectPath)
    }
    
    /// Returns the path to the currently installed git binary
    static var gitBinaryPath: URL? {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
        process.arguments = ["git"]
        
        do {
            let result = try runProcess(process, stdin: nil)
            if result.terminationStatus != 0 {
                return nil
            }
            
            return URL(fileURLWithPath: result.standardOutput.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            return nil
        }
    }
    
    let basePath: URL
    private let gitPath: URL
    
    init(basePath: URL) throws {
        guard let gitPath = GitRepositoryManager.gitBinaryPath else {
            throw Error.gitNotFound
        }
        
        self.basePath = basePath
        self.gitPath = gitPath
    }
    
    /// Returns true if a git repository exists at the current base path.
    /// Throws an error if git binary is not present.
    func exists() throws -> Bool {
        try execGitRaw(arguments: ["status"]).hasSuccessTerminationStatus
    }
    
    /// Executes `git status` at the current base path and returns the result
    /// of the operation.
    /// Throws an error if git's termination status is `!= 0`.
    func status() throws -> StatusResult {
        let result = try execGit(arguments: ["status", "--porcelain"])
        
        let lines = result.split(separator: "\n")
        let fileEntries = lines.map { line -> StatusResult.Entry in
            let split = line.split(separator: " ")
            
            return .init(status: String(split[0]), path: toAbsolutePath(String(split[1])))
        }
        
        return StatusResult(fileEntries: fileEntries)
    }
    
    /// Executes a git command, and returns the result of the invocation if the
    /// return status is `!= 0`, otherwise an error is thrown.
    private func execGit(arguments: [String]) throws -> String {
        let result = try execGitRaw(arguments: arguments)
        if !result.hasSuccessTerminationStatus {
            throw Error.commandFailed(status: Int(result.terminationStatus), arguments: arguments)
        }
        
        return result.standardOutput
    }
    
    private func toAbsolutePath(_ path: String) -> URL {
        return URL(fileURLWithPath: path, relativeTo: basePath)
    }
    
    /// Executes a git command, and returns the result of the invocation.
    private func execGitRaw(arguments: [String]) throws -> ProcessResult {
        let process = Process()
        process.currentDirectoryURL = baseProjectPath
        process.executableURL = gitPath
        process.arguments = arguments
        
        let result = try runProcess(process, stdin: nil)
        return result
    }
    
    enum Error: Swift.Error {
        case gitNotFound
        case commandFailed(status: Int, arguments: [String])
    }
}

extension GitRepositoryManager {
    struct StatusResult {
        var fileEntries: [Entry]
        
        struct Entry {
            var status: String
            var path: URL
        }
    }
}
