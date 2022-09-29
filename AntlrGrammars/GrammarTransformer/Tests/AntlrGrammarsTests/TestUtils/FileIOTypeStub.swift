import Foundation

@testable import AntlrGrammars

class FileIOTypeStub: FileIOType {
    var stubRead: StubReadData

    init(stubRead: StubReadData) {
        self.stubRead = stubRead
    }

    func readData(from url: URL) throws -> Data {
        stubRead.asData
    }

    func readText(from url: URL, encoding: String.Encoding) throws -> String {
        stubRead.asString
    }

    var writeData_calls: [(url: URL, data: Data, options: Data.WritingOptions)] = []
    func writeData(to url: URL, data: Data, options: Data.WritingOptions) throws {
        writeData_calls.append((url, data, options))
    }

    var writeText_calls: [(url: URL, text: String, encoding: String.Encoding)] = []
    func writeText(to url: URL, text: String, encoding: String.Encoding) throws {
        writeText_calls.append((url, text, encoding))
    }

    enum StubReadData {
        case data(Data)
        case string(String)

        var asData: Data {
            switch self {
            case .data(let data):
                return data
            case .string(let string):
                return string.data(using: .utf8)!
            }
        }

        var asString: String {
            switch self {
            case .data(let data):
                return String(data: data, encoding: .utf8)!
            case .string(let string):
                return string
            }
        }
    }
}
