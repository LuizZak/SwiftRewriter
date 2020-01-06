import Foundation
import ObjcParser

class ParserPool {
    var cache: [URL: ObjcParser] = [:]
    let fileProvider: FileProvider
    let parserStatePool: ObjcParserStatePool

    init(fileProvider: FileProvider, parserStatePool: ObjcParserStatePool) {
        self.fileProvider = fileProvider
        self.parserStatePool = parserStatePool
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
        let state = parserStatePool.pull()
        let parser = ObjcParser(source: source, state: state)
        try parser.parse()
        parserStatePool.repool(state)
        return parser
    }

    enum Error: Swift.Error {
        case invalidFile
    }
}
