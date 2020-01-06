import Foundation
import ObjcParser

public class ParserPool {
    var cache: [URL: ObjcParser] = [:]
    let fileProvider: FileProvider
    let parserStatePool: ObjcParserStatePool
    let antlrSettings: AntlrSettings

    public init(fileProvider: FileProvider,
                parserStatePool: ObjcParserStatePool,
                antlrSettings: AntlrSettings) {
        
        self.fileProvider = fileProvider
        self.parserStatePool = parserStatePool
        self.antlrSettings = antlrSettings
    }
    
    public func storeParsedTree(file: URL, parser: ObjcParser) {
        cache[file] = parser
    }

    public func loadParsedTree(file: URL) throws -> ObjcParser {
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
        parser.antlrSettings = antlrSettings
        try parser.parse()
        parserStatePool.repool(state)
        return parser
    }

    public enum Error: Swift.Error {
        case invalidFile
    }
}
