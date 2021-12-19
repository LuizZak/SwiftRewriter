import Foundation
import ObjcParser
import SourcePreprocessors
import Utils

/// A parser cache that stores pre-parsed trees based on input file URLs
public class ObjectiveCParserCache {
    @ConcurrentValue var cache: [URL: ObjcParser] = [:]
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

    public func loadParsedTree(input: InputSource) throws -> ObjcParser {
        let url = URL(fileURLWithPath: input.sourcePath())
        
        if let parser = cache[url] {
            try parser.parse()
            return parser
        }

        let processedSource = try applyPreprocessors(input: input, preprocessors: sourcePreprocessors)
        
        let state = parserStatePool.pull()
        let parser = ObjcParser(string: processedSource,
                                fileName: url.path,
                                state: state)
        parser.antlrSettings = antlrSettings
        try parser.parse()
        parserStatePool.repool(state)
        cache[url] = parser
        return parser
    }
    
    private func applyPreprocessors(input: InputSource, preprocessors: [SourcePreprocessor]) throws -> String {
        let src = try input.loadSource().fetchSource()
        
        let context = _PreprocessingContext(filePath: input.sourcePath())
        
        return preprocessors.reduce(src) {
            $1.preprocess(source: $0, context: context)
        }
    }

    public enum Error: Swift.Error {
        case invalidFile
    }
}
