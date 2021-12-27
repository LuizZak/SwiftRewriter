import Foundation

public protocol FileProvider {
    func enumerator(atUrl url: URL) -> [URL]?
    func fileExists(atUrl url: URL) -> Bool
    func fileExists(atUrl url: URL, isDirectory: inout Bool) -> Bool
    func directoryExists(atUrl url: URL) -> Bool 
    func contentsOfFile(atUrl url: URL) throws -> Data
    func contentsOfDirectory(atUrl url: URL, shallow: Bool) throws -> [URL]

    /// Requests the hard drive path for the current user's home directory.
    func homeDirectoryForCurrentUser() -> URL
}
