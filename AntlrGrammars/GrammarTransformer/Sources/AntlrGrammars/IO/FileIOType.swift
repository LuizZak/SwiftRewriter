import Foundation

/// Abstraction over a file IO for loading/saving files.
protocol FileIOType {
    func readData(from url: URL) throws -> Data
    func readText(from url: URL, encoding: String.Encoding) throws -> String
    func writeData(to url: URL, data: Data, options: Data.WritingOptions) throws
    func writeText(to url: URL, text: String, encoding: String.Encoding) throws
}

extension FileIOType {
    func readText(from url: URL) throws -> String {
        try readText(from: url, encoding: .utf8)
    }

    func writeData(to url: URL, data: Data) throws {
        try writeData(to: url, data: data, options: [])
    }
    
    func writeText(to url: URL, text: String) throws {
        try writeText(to: url, text: text, encoding: .utf8)
    }
}
