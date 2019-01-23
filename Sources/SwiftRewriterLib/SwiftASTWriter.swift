import class Foundation.OperationQueue
import SwiftAST
import Antlr4
import GrammarModels
import ObjcParserAntlr
import ObjcParser
import WriterTargetOutput
import SwiftSyntaxSupport

/// Options for an AST writer invocation
public struct ASTWriterOptions {
    /// Default settings instance
    public static let `default` = ASTWriterOptions()
    
    /// If `true`, when outputting expression statements, print the resulting type
    /// of the expression before the expression statement as a comment for inspection.
    public var outputExpressionTypes: Bool
    
    /// If `true`, when outputting final intentions, print any history information
    /// tracked on its `IntentionHistory` property before the intention's declaration
    /// as a comment for inspection.
    public var printIntentionHistory: Bool
    
    /// If `true`, `@objc` attributes and `: NSObject` are emitted for declarations
    /// during output.
    ///
    /// This may increase compatibility with previous Objective-C code when compiled
    /// and executed.
    public var emitObjcCompatibility: Bool
    
    /// Number of concurrent threads to use when saving files.
    public var numThreads: Int
    
    public init(outputExpressionTypes: Bool = false,
                printIntentionHistory: Bool = false,
                emitObjcCompatibility: Bool = false,
                numThreads: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        
        self.outputExpressionTypes = outputExpressionTypes
        self.printIntentionHistory = printIntentionHistory
        self.emitObjcCompatibility = emitObjcCompatibility
        self.numThreads = numThreads
    }
    
    public func toSwiftSyntaxProducerSettings() -> SwiftSyntaxProducer.Settings {
        return .init(outputExpressionTypes: outputExpressionTypes,
                     printIntentionHistory: printIntentionHistory,
                     emitObjcCompatibility: emitObjcCompatibility)
    }
}
