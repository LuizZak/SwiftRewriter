import Foundation
import ObjcParser
import SourcePreprocessors

/// A parser cache that stores pre-parsed trees based on input file URLs
public class ParserCache {
    var cache: [URL: ObjcParser] = [:]
    let fileProvider: FileProvider
    let parserStatePool: ObjcParserStatePool
    let sourcePreprocessors: [SourcePreprocessor]
    let antlrSettings: AntlrSettings

    public init(fileProvider: FileProvider,
                parserStatePool: ObjcParserStatePool,
                sourcePreprocessors: [SourcePreprocessor] = [],
                antlrSettings: AntlrSettings = .default) {
        
        self.fileProvider = fileProvider
        self.parserStatePool = parserStatePool
        self.sourcePreprocessors = sourcePreprocessors
        self.antlrSettings = antlrSettings
    }
    
    public func replaceCachedParsedTree(file: URL, parser: ObjcParser) {
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
        
        let processedSource = applyPreprocessors(source: source, preprocessors: sourcePreprocessors)
        
        let state = parserStatePool.pull()
        let parser = ObjcParser(string: processedSource,
                                fileName: source.filePath,
                                state: state)
        parser.antlrSettings = antlrSettings
        try parser.parse()
        parserStatePool.repool(state)
        cache[file] = parser
        return parser
    }
    
    private func applyPreprocessors(source: CodeSource, preprocessors: [SourcePreprocessor]) -> String {
        let src = source.fetchSource()
        
        let context = _PreprocessingContext(filePath: source.filePath)
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
        }
    }

    public enum Error: Swift.Error {
        case invalidFile
    }
}
