import Foundation
import Dispatch
import SPMUtility
import Console
import SwiftRewriterLib

class SwiftRewriterCommand {
    let args = SwiftRewriterArgumentsParser()
    
    func run() {
        do {
            try main()
        } catch {
            print("Error: \(error)")
        }
    }
    
    func main() throws {
        let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
        
        let result = try args.parser.parse(arguments)
        
        switch result.subparser(args.parser) {
        case "files":
            try filesMode(result)
            
        case "path":
            try pathMode(result)
            
        default:
            interactiveMode(result)
        }
    }
    
    // MARK: - File list mode
    func filesMode(_ result: ArgumentParser.Result) throws {
        let rewriter = makeRewriterService(result)
        
        guard let files = result.get(args.filesParser.filesArg) else {
            throw ArgumentParserError.expectedValue(option: "<files...>")
        }
        
        try rewriter.rewrite(files: files.map { URL(fileURLWithPath: $0) })
    }
    
    // MARK: - Path mode
    func pathMode(_ result: ArgumentParser.Result) throws {
        let rewriter = makeRewriterService(result)
        
        guard let path = result.get(args.pathParser.pathArg) else {
            throw ArgumentParserError.expectedValue(option: "<path>")
        }
        
        let skipConfirm = result.get(args.pathParser.skipConfirmArg) ?? false
        let excludePattern = result.get(args.pathParser.excludePatternArg)
        let includePattern = result.get(args.pathParser.includePatternArg)
        let overwrite = result.get(args.pathParser.overwriteArg) ?? false
        
        let console = Console()
        let menu = Menu(rewriterService: rewriter, console: console)
        
        let options: SuggestConversionInterface.Options
            = .init(overwrite: overwrite, skipConfirm: skipConfirm,
                    excludePattern: excludePattern, includePattern: includePattern)
        
        let interface = SuggestConversionInterface(rewriterService: rewriter)
        interface.searchAndShowConfirm(in: menu,
                                       path: (path as NSString).standardizingPath,
                                       options: options)
    }
    
    // MARK: - Interactive
    func interactiveMode(_ result: ArgumentParser.Result) {
        let colorize = result.get(args.colorArg) ?? false
        let settings = makeSettings(result)
        
        let output = StdoutWriterOutput(colorize: colorize)
        let service = SwiftRewriterServiceImpl(output: output, settings: settings)
        let console = Console()
        let menu = Menu(rewriterService: service, console: console)
        
        menu.main()
    }
    
    // MARK: - Utils
    func makeRewriterService(_ result: ArgumentParser.Result) -> SwiftRewriterService {
        let colorize = result.get(args.colorArg) ?? false
        let target = result.get(args.targetArg) ?? .filedisk
        let settings = makeSettings(result)
        
        let rewriter: SwiftRewriterService
        
        switch target {
        case .filedisk:
            rewriter = SwiftRewriterServiceImpl.fileDisk(settings: settings)
        case .stdout:
            rewriter = SwiftRewriterServiceImpl.terminal(settings: settings,
                                                         colorize: colorize)
        }
        
        return rewriter
    }
    
    func makeSettings(_ result: ArgumentParser.Result) -> Settings {
        var settings = Settings()
        
        settings.rewriter.verbose = result.get(args.verboseArg) ?? false
        settings.rewriter.diagnoseFiles = result.get(args.diagnoseFileArg).map({ [$0] }) ?? []
        settings.rewriter.numThreads = result.get(args.numThreadsArg) ?? OperationQueue.defaultMaxConcurrentOperationCount
        settings.astWriter.outputExpressionTypes = result.get(args.outputExpressionTypesArg) ?? false
        settings.astWriter.printIntentionHistory = result.get(args.outputIntentionHistoryArg) ?? false
        settings.astWriter.emitObjcCompatibility = result.get(args.emitObjcCompatibilityArg) ?? false
        settings.rewriter.forceUseLLPrediction = result.get(args.forceUseLLPredictionArg) ?? false
        
        return settings
    }
}
