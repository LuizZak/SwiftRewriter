import Foundation

class FileDisk: FileIOType {
    func readData(from url: URL) throws -> Data {
        try Data(contentsOf: url)
    }

    func readText(from url: URL, encoding: String.Encoding) throws -> String {
        try String(contentsOf: url, encoding: encoding)
    }

    func writeData(to url: URL, data: Data, options: Data.WritingOptions) throws {
        try data.write(to: url, options: options)
    }

    func writeText(to url: URL, text: String, encoding: String.Encoding) throws {
        try text.write(to: url, atomically: true, encoding: encoding)
    }
}
