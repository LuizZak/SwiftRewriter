import Foundation
import ObjcParser

class ParserPool {
    var cache: [URL: ObjcParser] = [:]
    let fileProvider: FileProvider

    init(fileProvider: FileProvider) {
        self.fileProvider = fileProvider
    }

    func loadParsedTree(file: URL) throws -> ObjcParser {
        if let parser = cache[file] {
            try parser.parse()
            return parser
        }

        let data = try fileProvider.contentsOfFile(atPath: file.path)
        guard let string = String(bytes: data, encoding: .utf8) else {
            throw Error.invalidFile
        }

        let source = StringCodeSource(source: string, fileName: file.lastPathComponent)
        let parser = ObjcParser(source: source)
        try parser.parse()
        return parser
    }

    enum Error: Swift.Error {
        case invalidFile
    }
}
