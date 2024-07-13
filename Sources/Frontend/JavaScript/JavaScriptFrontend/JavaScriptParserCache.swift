import Foundation
import AntlrCommons
import JsParser
import SourcePreprocessors
import Utils
import SwiftRewriterLib

/// A parser cache that stores pre-parsed trees based on input file URLs
public class JavaScriptParserCache {
    @ConcurrentValue var cache: [URL: JsParser] = [:]
    let fileProvider: FileProvider
    let parserStatePool: JsParserStatePool
    let sourcePreprocessors: [SourcePreprocessor]
    let antlrSettings: AntlrSettings

    public init(
        fileProvider: FileProvider,
        parserStatePool: JsParserStatePool,
        sourcePreprocessors: [SourcePreprocessor] = [],
        antlrSettings: AntlrSettings = .default
    ) {

        self.fileProvider = fileProvider
        self.parserStatePool = parserStatePool
        self.sourcePreprocessors = sourcePreprocessors
        self.antlrSettings = antlrSettings
    }

    public func replaceCachedParsedTree(file: URL, parser: JsParser) {
        cache[file] = parser
    }

    public func loadParsedTree(input: InputSource) throws -> JsParser {
        return try _cache.modifyingValue { cache in
            let url = URL(fileURLWithPath: input.sourcePath())

            if let parser = cache[url] {
                try parser.parse()
                return parser
            }

            let src = try input.loadSource().fetchSource()

            let state = self.parserStatePool.pull()
            let parser = JsParser(
                string: src,
                fileName: url.path,
                state: state
            )
            parser.antlrSettings = antlrSettings
            try parser.parse()
            parserStatePool.repool(state)
            cache[url] = parser
            return parser
        }
    }

    public enum Error: Swift.Error {
        case invalidFile
    }
}
