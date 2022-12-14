import Foundation
import ObjcGrammarModels
import ObjcParser
import ObjcParserAntlr
import SwiftAST
import KnownType
import Intentions
import TypeSystem
import WriterTargetOutput
import SwiftSyntax
import SwiftFormat
import SwiftSyntaxParser
import SwiftSyntaxSupport
import Utils

public protocol SwiftWriterProgressListener: AnyObject {
    func swiftWriterReportProgress(_ writer: SwiftWriter,
                                   filesEmitted: Int,
                                   totalFiles: Int,
                                   latestFile: FileGenerationIntention)
}

/// Gets as inputs a series of intentions and outputs actual files and script
/// contents.
public final class SwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    var diagnostics: Diagnostics
    var options: SwiftSyntaxOptions
    let numThreads: Int
    let typeSystem: TypeSystem
    let syntaxRewriterApplier: SwiftSyntaxRewriterPassApplier
    
    public weak var progressListener: SwiftWriterProgressListener?
    
    public init(
        intentions: IntentionCollection,
        options: SwiftSyntaxOptions,
        numThreads: Int,
        diagnostics: Diagnostics,
        output: WriterOutput,
        typeSystem: TypeSystem,
        syntaxRewriterApplier: SwiftSyntaxRewriterPassApplier
    ) {
        self.intentions = intentions
        self.options = options
        self.numThreads = numThreads
        self.diagnostics = diagnostics
        self.output = output
        self.typeSystem = typeSystem
        self.syntaxRewriterApplier = syntaxRewriterApplier
    }
    
    public func execute() {
        typeSystem.makeCache()
        defer {
            typeSystem.tearDownCache()
        }
        
        var unique = Set<String>()
        let fileIntents = intentions.fileIntentions()
        
        let errors = ConcurrentValue<[(String, Error)]>(wrappedValue: [])
        let filesEmitted = ConcurrentValue<Int>(wrappedValue: 0)
        
        let listenerQueue = DispatchQueue(label: "com.swiftrewriter.swiftwriter.listener")
        let queue = ConcurrentOperationQueue()
        queue.maxConcurrentOperationCount = numThreads
        
        let mutex = Mutex()
        let filesToEmit = fileIntents.filter(shouldOutputFile(_:))
        
        for file in filesToEmit {
            if !unique.insert(file.targetPath).inserted {
                mutex.locking {
                    diagnostics.warning("""
                        Found duplicated file intent to save to path \(file.targetPath).
                        This usually means an original .h/.m source pairs could not be \
                        properly reduced to a single .swift file.
                        """,
                        location: .invalid
                    )
                }
                continue
            }
            
            let writer
                = SwiftSyntaxWriter(
                    options: options,
                    diagnostics: Diagnostics(),
                    output: output,
                    typeSystem: typeSystem,
                    syntaxRewriterApplier: syntaxRewriterApplier)
            
            queue.addOperation {
                autoreleasepool {
                    do {
                        if let listener = self.progressListener {
                            let fe: Int = filesEmitted.modifyingValue({ $0 += 1; return $0 })
                            
                            listenerQueue.async {
                                listener.swiftWriterReportProgress(
                                    self,
                                    filesEmitted: fe,
                                    totalFiles: filesToEmit.count,
                                    latestFile: file)
                            }
                        }
                        
                        try writer.outputFile(file)
                        
                        mutex.locking {
                            self.diagnostics.merge(with: writer.diagnostics)
                        }
                    } catch {
                        errors.wrappedValue.append((file.targetPath, error))
                    }
                }
            }
        }
        
        queue.runAndWaitConcurrent()
        
        for error in errors.wrappedValue {
            diagnostics.error("Error while saving file \(error.0): \(error.1)",
                              origin: error.0,
                              location: .invalid)
        }
    }
    
    func shouldOutputFile(_ file: FileGenerationIntention) -> Bool {
        return file.isPrimary
    }
}

class SwiftSyntaxWriter {
    var output: WriterOutput
    var diagnostics: Diagnostics
    var options: SwiftSyntaxOptions
    let typeSystem: TypeSystem
    let syntaxRewriterApplier: SwiftSyntaxRewriterPassApplier
    
    init(options: SwiftSyntaxOptions,
         diagnostics: Diagnostics,
         output: WriterOutput,
         typeSystem: TypeSystem,
         syntaxRewriterApplier: SwiftSyntaxRewriterPassApplier) {
        
        self.options = options
        self.diagnostics = diagnostics
        self.output = output
        self.typeSystem = typeSystem
        self.syntaxRewriterApplier = syntaxRewriterApplier
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention) throws {
        let target = try output.createFile(path: fileIntent.targetPath)
        
        try outputFile(fileIntent, targetFile: target)
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention, targetFile: FileOutput) throws {
        let out = targetFile.outputTarget()
        
        let settings = SwiftSyntaxProducer
            .Settings(outputExpressionTypes: options.outputExpressionTypes,
                      printIntentionHistory: options.printIntentionHistory,
                      emitObjcCompatibility: options.emitObjcCompatibility)
        
        let producer = SwiftSyntaxProducer(settings: settings, delegate: self)
        
        var fileSyntax = producer.generateFile(fileIntent)

        fileSyntax = try formatSyntax(fileSyntax, fileUrl: URL(fileURLWithPath: fileIntent.targetPath), format: options.format)
        fileSyntax = applySyntaxPasses(fileSyntax)
        
        out.outputFile(fileSyntax)
        
        targetFile.close()
    }

    func formatSyntax(_ file: SourceFileSyntax, fileUrl: URL, format: SwiftSyntaxOptions.FormatOption) throws -> SourceFileSyntax {
        switch format {
        case .noFormatting:
            return file
            
        case .swiftFormat(let configuration):
            // Turn the syntax back into a string and pass that string as an
            // input in order to normalize abnormal syntax trees that may have
            // been generated by `SwiftSyntaxProducer`.
            let string = file.description

            let formatter = SwiftFormatter(configuration: configuration ?? .init())

            var intermediary: String = ""
            try formatter.format(source: string, assumingFileURL: fileUrl, to: &intermediary)

            return try SyntaxParser.parse(source: intermediary)
        }
    }

    func applySyntaxPasses(_ file: SourceFileSyntax) -> SourceFileSyntax {
        syntaxRewriterApplier.apply(to: file)
    }
}

extension SwiftSyntaxWriter: SwiftSyntaxProducerDelegate {
    func swiftSyntaxProducer(
        _ producer: SwiftSyntaxProducer,
        shouldEmitTypeFor storage: ValueStorage,
        intention: IntentionProtocol?,
        initialValue: Expression?
    ) -> Bool {
        // Intentions (global variables, instance variables and properties) should
        // preferably always be emitted with type annotations.
        if intention != nil {
            return true
        }
        
        guard let initialValue = initialValue else {
            return true
        }
        
        return shouldEmitTypeSignature(
            forInitVal: initialValue,
            varType: storage.type,
            ownership: storage.ownership,
            isConstant: storage.isConstant
        )
    }
    
    func swiftSyntaxProducer(
        _ producer: SwiftSyntaxProducer,
        initialValueFor intention: ValueStorageIntention
    ) -> Expression? {
        if let intention = intention as? PropertyGenerationIntention {
            switch intention.mode {
            case .asField:
                break
            case .computed, .property:
                return nil
            }
        }
        
        // Don't emit `nil` values for non-constant fields, since Swift assumes
        // the initial value of these values to be nil already.
        // We need to emit `nil` in case of constants since 'let's don't do that
        // implicit initialization
        if intention.type.isOptional && !intention.storage.isConstant {
            return nil
        }
        
        return typeSystem.defaultValue(for: intention.type)
    }
    
    func shouldEmitTypeSignature(
        forInitVal exp: Expression,
        varType: SwiftType,
        ownership: Ownership,
        isConstant: Bool
    ) -> Bool {
        if options.alwaysEmitVariableTypes {
            return true
        }

        if exp.isErrorTyped {
            return true
        }
        
        if case .block? = exp.resolvedType {
            return true
        }
        
        if exp.isLiteralExpression {
            if let type = exp.resolvedType {
                switch type {
                case .int:
                    return varType != .int
                    
                case .float:
                    return varType != .double
                    
                case .optional, .implicitUnwrappedOptional, .nullabilityUnspecified:
                    return true
                    
                default:
                    break
                }
            }
            
            switch deduceType(from: exp) {
            case .int, .float, .nil:
                return true
                
            default:
                return false
            }
        } else if let type = exp.resolvedType {
            guard typeSystem.isClassInstanceType(type) else {
                return !typeSystem.typesMatch(type, varType, ignoreNullability: true)
            }
            
            if isConstant {
                return false
            }
            
            if type.isOptional != varType.isOptional {
                let isSame = type.deepUnwrapped == varType.deepUnwrapped
                let isWeak = ownership == .weak
                
                if !isSame || !isWeak {
                    return true
                }
            }
            
            return !typeSystem.typesMatch(type, varType, ignoreNullability: true)
        }
        
        return false
    }
    
    /// Attempts to make basic deductions about an expression's resulting type.
    /// Used only for deciding whether to infer types for variable definitions
    /// with initial values.
    private func deduceType(from exp: Expression) -> DeducedType {
        if let constant = exp.asConstant?.constant {
            if constant.isInteger {
                return .int
            }
            
            switch constant {
            case .float:
                return .float
            case .boolean:
                return .bool
            case .string:
                return .string
            case .nil:
                return .nil
            default:
                break
            }
            
            return .other
        } else if let binary = exp.asBinary {
            return deduceType(binary)
            
        } else if let assignment = exp.asAssignment {
            return deduceType(from: assignment.rhs)
            
        } else if let parens = exp.asParens {
            return deduceType(from: parens.exp)
            
        } else if exp is PrefixExpression || exp is UnaryExpression {
            let op = exp.asPrefix?.op ?? exp.asUnary?.op
            
            switch op {
            case .some(.negate):
                return .bool
            case .some(.bitwiseNot):
                return .int
                
            // Pointer types
            case .some(.multiply), .some(.bitwiseAnd):
                return .other
                
            default:
                return .other
            }
        } else if let ternary = exp.asTernary {
            let lhsType = deduceType(from: ternary.ifTrue)
            if lhsType == deduceType(from: ternary.ifFalse) {
                return lhsType
            }
            
            return .other
        }
        
        return .other
    }
    
    private func deduceType(_ binary: BinaryExpression) -> DeducedType {
        let lhs = binary.lhs
        let op = binary.op
        let rhs = binary.rhs
        
        switch op.category {
        case .arithmetic, .bitwise:
            let lhsType = deduceType(from: lhs)
            let rhsType = deduceType(from: rhs)
            
            // Arithmetic and bitwise operators keep operand types, if they
            // are the same.
            if lhsType == rhsType {
                return lhsType
            }
            
            // Float takes precedence over ints on arithmetic operators
            if op.category == .arithmetic {
                switch (lhsType, rhsType) {
                case (.float, .int), (.int, .float):
                    return .float
                default:
                    break
                }
            } else if op.category == .bitwise {
                // Bitwise operators always cast the result to integers, if
                // one of the operands is an integer
                switch (lhsType, rhsType) {
                case (_, .int), (.int, _):
                    return .int
                default:
                    break
                }
            }
            
            return .other
            
        case .assignment:
            return deduceType(from: rhs)
            
        case .comparison:
            return .bool
            
        case .logical:
            return .bool
            
        case .nullCoalesce, .range:
            return .other
        }
    }
    
    private enum DeducedType {
        case int
        case float
        case bool
        case string
        case `nil`
        case other
    }
}
