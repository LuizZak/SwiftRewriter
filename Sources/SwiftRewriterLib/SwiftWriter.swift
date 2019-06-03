#if canImport(ObjectiveC)
import ObjectiveC
#endif

import GrammarModels
import ObjcParser
import ObjcParserAntlr
import SwiftAST
import KnownType
import Intentions
import TypeSystem
import WriterTargetOutput
import SwiftSyntaxSupport
import Utils

/// Gets as inputs a series of intentions and outputs actual files and script
/// contents.
public final class SwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let typeMapper: TypeMapper
    var diagnostics: Diagnostics
    var options: SwiftSyntaxOptions
    let numThreads: Int
    let typeSystem: TypeSystem
    
    public init(intentions: IntentionCollection,
                options: SwiftSyntaxOptions,
                numThreads: Int,
                diagnostics: Diagnostics,
                output: WriterOutput,
                typeMapper: TypeMapper,
                typeSystem: TypeSystem) {
        
        self.intentions = intentions
        self.options = options
        self.numThreads = numThreads
        self.diagnostics = diagnostics
        self.output = output
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    public func execute() {
        typeSystem.makeCache()
        defer {
            typeSystem.tearDownCache()
        }
        
        var unique = Set<String>()
        let fileIntents = intentions.fileIntentions()
        
        var errors: [(String, Error)] = []
        
        let queue = SWOperationQueue(maxConcurrentOperationCount: numThreads)
        
        let mutex = Mutex()
        
        for file in fileIntents {
            if unique.contains(file.targetPath) {
                print("""
                    Found duplicated file intent to save to path \(file.targetPath).
                    This usually means an original .h/.m source pairs could not be \
                    properly reduced to a single .swift file.
                    """)
                continue
            }
            unique.insert(file.targetPath)
            
            let writer
                = SwiftSyntaxWriter(
                    intentions: intentions,
                    options: options,
                    diagnostics: Diagnostics(),
                    output: output,
                    typeMapper: typeMapper,
                    typeSystem: typeSystem)
            
            queue.addOperation {
                autoreleasepool {
                    do {
                        try writer.outputFile(file)
                        
                        mutex.locking {
                            self.diagnostics.merge(with: writer.diagnostics)
                        }
                    } catch {
                        mutex.locking {
                            errors.append((file.targetPath, error))
                        }
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        for error in errors {
            self.diagnostics.error("Error while saving file \(error.0): \(error.1)",
                                   origin: error.0,
                                   location: .invalid)
        }
    }
}

class SwiftSyntaxWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let typeMapper: TypeMapper
    var diagnostics: Diagnostics
    var options: SwiftSyntaxOptions
    let typeSystem: TypeSystem
    
    init(intentions: IntentionCollection,
         options: SwiftSyntaxOptions,
         diagnostics: Diagnostics,
         output: WriterOutput,
         typeMapper: TypeMapper,
         typeSystem: TypeSystem) {
        
        self.intentions = intentions
        self.options = options
        self.diagnostics = diagnostics
        self.output = output
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention) throws {
        let target = try output.createFile(path: fileIntent.targetPath)
        
        outputFile(fileIntent, targetFile: target)
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention, targetFile: FileOutput) {
        let out = targetFile.outputTarget()
        
        let settings = SwiftSyntaxProducer
            .Settings(outputExpressionTypes: options.outputExpressionTypes,
                      printIntentionHistory: options.printIntentionHistory,
                      emitObjcCompatibility: options.emitObjcCompatibility)
        
        let producer = SwiftSyntaxProducer(settings: settings, delegate: self)
        
        let fileSyntax = producer.generateFile(fileIntent)
        
        out.outputRaw(fileSyntax.description)
        
        targetFile.close()
    }
}

extension SwiftSyntaxWriter: SwiftSyntaxProducerDelegate {
    func swiftSyntaxProducer(_ producer: SwiftSyntaxProducer,
                             shouldEmitTypeFor storage: ValueStorage,
                             intention: IntentionProtocol?,
                             initialValue: Expression?) -> Bool {
        
        // Intentions (global variables, instance variables and properties) should
        // preferably always be emitted with type annotations.
        if intention != nil {
            return true
        }
        
        guard let initialValue = initialValue else {
            return true
        }
        
        return shouldEmitTypeSignature(forInitVal: initialValue,
                                       varType: storage.type,
                                       isConstant: storage.isConstant)
    }
    
    func swiftSyntaxProducer(_ producer: SwiftSyntaxProducer,
                             initialValueFor intention: ValueStorageIntention) -> Expression? {
        
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
    
    private func shouldEmitTypeSignature(forInitVal exp: Expression,
                                         varType: SwiftType,
                                         isConstant: Bool) -> Bool {
        
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
                return false
            }
            
            if isConstant {
                return false
            }
            
            if type.isOptional != varType.isOptional {
                return true
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

internal func _isConstant(fromType type: ObjcType) -> Bool {
    switch type {
    case .qualified(_, let qualifiers),
         .specified(_, .qualified(_, let qualifiers)):
        if qualifiers.contains("const") {
            return true
        }
    case .specified(let specifiers, _):
        if specifiers.contains("const") {
            return true
        }
    default:
        break
    }
    
    return false
}

internal func _accessModifierFor(accessLevel: AccessLevel, omitInternal: Bool = true) -> String {
    // In Swift, omitting the access level specifier infers 'internal', so we
    // allow the user to decide whether to omit the keyword here
    if omitInternal && accessLevel == .internal {
        return ""
    }
    
    return accessLevel.rawValue
}

internal func evaluateOwnershipPrefix(inType type: ObjcType,
                                      property: PropertyDefinition? = nil) -> Ownership {
    
    var ownership: Ownership = .strong
    if !type.isPointer {
        return .strong
    }
    
    switch type {
    case .specified(let specifiers, _):
        if specifiers.last == "__weak" {
            ownership = .weak
        } else if specifiers.last == "__unsafe_unretained" {
            ownership = .unownedUnsafe
        }
    default:
        break
    }
    
    // Search in property
    if let property = property {
        if let modifiers = property.attributesList?.keywordAttributes {
            if modifiers.contains("weak") {
                ownership = .weak
            } else if modifiers.contains("unsafe_unretained") {
                ownership = .unownedUnsafe
            } else if modifiers.contains("assign") {
                ownership = .unownedUnsafe
            }
        }
    }
    
    return ownership
}
