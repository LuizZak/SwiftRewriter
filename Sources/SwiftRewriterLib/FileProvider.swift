import Foundation

public protocol FileProvider {
    func enumerator(atPath path: String) -> [String]?
    func fileExists(atPath path: String) -> Bool
    func contentsOfFile(atPath path: String) throws -> Data
}
