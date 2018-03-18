import SwiftAST
import GrammarModels

/// An intention to create a .swift file
public class FileGenerationIntention: Intention {
    /// Used to sort file generation intentions after multi-threaded parsing is
    /// finished.
    var _index: Int = 0
    
    /// The source path for this file
    public var sourcePath: String
    
    /// The intended output file path
    public var targetPath: String
    
    /// Gets the types to create on this file.
    public private(set) var typeIntentions: [TypeGenerationIntention] = []
    
    /// All preprocessor directives found on this file.
    public var preprocessorDirectives: [String] = []
    
    /// Gets the (Swift) import directives should be printed at this file's top
    /// header section.
    public var importDirectives: [String] = []
    
    /// Gets the intention collection that contains this file generation intention
    public internal(set) var intentionCollection: IntentionCollection?
    
    /// Returns `true` if there are no intentions and no preprocessor directives
    /// registered for this file.
    public var isEmpty: Bool {
        return isEmptyExceptDirectives && preprocessorDirectives.isEmpty
    }
    
    /// Returns `true` if there are no intentions registered for this file, not
    /// counting any recorded preprocessor directive.
    public var isEmptyExceptDirectives: Bool {
        return
            typeIntentions.isEmpty &&
                typealiasIntentions.isEmpty &&
                globalFunctionIntentions.isEmpty &&
                globalVariableIntentions.isEmpty
    }
    
    /// Gets the class extensions (but not main class declarations) to create
    /// on this file.
    public var extensionIntentions: [ClassExtensionGenerationIntention] {
        return typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
    }
    
    /// Gets the classes (but not class extensions) to create on this file.
    public var classIntentions: [ClassGenerationIntention] {
        return typeIntentions.compactMap { $0 as? ClassGenerationIntention }
    }
    
    /// Gets the classes and class extensions to create on this file.
    public var classTypeIntentions: [BaseClassIntention] {
        return typeIntentions.compactMap { $0 as? BaseClassIntention }
    }
    
    /// Gets the protocols to create on this file.
    public var protocolIntentions: [ProtocolGenerationIntention] {
        return typeIntentions.compactMap { $0 as? ProtocolGenerationIntention }
    }
    
    /// Gets the enums to create on this file.
    public var enumIntentions: [EnumGenerationIntention] {
        return typeIntentions.compactMap { $0 as? EnumGenerationIntention }
    }
    
    /// Gets the structs to create on this file.
    public var structIntentions: [StructGenerationIntention] {
        return typeIntentions.compactMap { $0 as? StructGenerationIntention }
    }
    
    /// Gets the typealias intentions to create on this file.
    public private(set) var typealiasIntentions: [TypealiasIntention] = []
    
    /// Gets the global functions to create on this file.
    public private(set) var globalFunctionIntentions: [GlobalFunctionGenerationIntention] = []
    
    /// Gets the global variables to create on this file.
    public private(set) var globalVariableIntentions: [GlobalVariableGenerationIntention] = []
    
    public let history: IntentionHistory = IntentionHistoryTracker()
    
    public var source: ASTNode?
    
    weak public var parent: Intention?
    
    public init(sourcePath: String, targetPath: String) {
        self.sourcePath = sourcePath
        self.targetPath = targetPath
        
        self.history.recordCreation(description: "Created from file \(sourcePath) to file \(targetPath)")
    }
    
    public func addType(_ intention: TypeGenerationIntention) {
        typeIntentions.append(intention)
        intention.parent = self
    }
    
    public func addTypealias(_ intention: TypealiasIntention) {
        typealiasIntentions.append(intention)
        intention.parent = self
    }
    
    public func removeTypes(where predicate: (TypeGenerationIntention) -> Bool) {
        for (i, intent) in typeIntentions.enumerated().reversed() {
            if predicate(intent) {
                intent.parent = nil
                typeIntentions.remove(at: i)
            }
        }
    }
    
    public func removeFunctions(where predicate: (GlobalFunctionGenerationIntention) -> Bool) {
        for (i, intent) in globalFunctionIntentions.enumerated().reversed() {
            if predicate(intent) {
                intent.parent = nil
                globalFunctionIntentions.remove(at: i)
            }
        }
    }
    
    public func removeClassTypes(where predicate: (BaseClassIntention) -> Bool) {
        for (i, intent) in typeIntentions.enumerated().reversed() {
            if let classType = intent as? BaseClassIntention, predicate(classType) {
                intent.parent = nil
                typeIntentions.remove(at: i)
            }
        }
    }
    
    public func removeGlobalVariables(where predicate: (GlobalVariableGenerationIntention) -> Bool) {
        for (i, intent) in globalVariableIntentions.enumerated().reversed() {
            if predicate(intent) {
                intent.parent = nil
                globalVariableIntentions.remove(at: i)
            }
        }
    }
    
    public func removeGlobalFunctions(where predicate: (GlobalFunctionGenerationIntention) -> Bool) {
        for (i, intent) in globalFunctionIntentions.enumerated().reversed() {
            if predicate(intent) {
                intent.parent = nil
                globalFunctionIntentions.remove(at: i)
            }
        }
    }
    
    public func removeTypealiases(where predicate: (TypealiasIntention) -> Bool) {
        for (i, intent) in typealiasIntentions.enumerated().reversed() {
            if predicate(intent) {
                intent.parent = nil
                typealiasIntentions.remove(at: i)
            }
        }
    }
    
    public func addProtocol(_ intention: ProtocolGenerationIntention) {
        typeIntentions.append(intention)
        intention.parent = self
    }
    
    public func addGlobalFunction(_ intention: GlobalFunctionGenerationIntention) {
        globalFunctionIntentions.append(intention)
        intention.parent = self
    }
    
    public func addGlobalVariable(_ intention: GlobalVariableGenerationIntention) {
        globalVariableIntentions.append(intention)
        intention.parent = self
    }
}

/// An intention that is to be declared at the file-level, not contained within any
/// types.
public protocol FileLevelIntention: Intention {
    /// The file this intention is contained within
    var file: FileGenerationIntention? { get }
}

/// An intention to generate a global function.
public class GlobalFunctionGenerationIntention: FromSourceIntention, FileLevelIntention, FunctionIntention {
    public var typedSource: FunctionDefinition? {
        return source as? FunctionDefinition
    }
    
    public var signature: FunctionSignature
    
    /// Gets the name of this global function definition by looking into its'
    /// signatures' name
    public var name: String {
        return signature.name
    }
    
    public var parameters: [ParameterSignature] {
        return signature.parameters
    }
    
    /// Returns `true` if this global function intention is a declaration, but not
    /// an implementation, of a global function signature.
    public var isDeclaration: Bool {
        return functionBody == nil
    }
    
    public var functionBody: FunctionBodyIntention?
    
    public init(signature: FunctionSignature, accessLevel: AccessLevel = .internal, source: ASTNode? = nil) {
        self.signature = signature
        super.init(accessLevel: accessLevel, source: source)
    }
}

/// An intention to generate a global variable.
public class GlobalVariableGenerationIntention: FromSourceIntention, FileLevelIntention, ValueStorageIntention {
    public var variableSource: VariableDeclaration? {
        return source as? VariableDeclaration
    }
    
    public var name: String
    public var storage: ValueStorage
    public var initialValueExpr: GlobalVariableInitialValueIntention?
    
    public init(name: String, storage: ValueStorage, accessLevel: AccessLevel = .internal,
                source: ASTNode? = nil) {
        self.name = name
        self.storage = storage
        super.init(accessLevel: accessLevel, source: source)
    }
}

/// An intention to generate the initial value for a global variable.
public class GlobalVariableInitialValueIntention: FromSourceIntention {
    public var typedSource: InitialExpression? {
        return source as? InitialExpression
    }
    
    public var expression: Expression
    
    public init(expression: Expression, source: ASTNode?) {
        self.expression = expression
        
        super.init(accessLevel: .public, source: source)
    }
}

/// Represents an intention that has a value associated that indicates whether it
/// was defined within NS_ASSUME_NONNULL contexts
public protocol NonNullScopedIntention: Intention {
    /// Gets a value indicating whether this intention was defined within
    /// NS_ASSUME_NONNULL contexts
    var inNonnullContext: Bool { get }
}

/// Defines a protocol for function-generating intentions
public protocol FunctionIntention: Intention {
    var parameters: [ParameterSignature] { get }
    
    var functionBody: FunctionBodyIntention? { get }
}

/// Represents an Objective-C selector signature.
public struct SelectorSignature: Equatable {
    public var isStatic: Bool
    public var keywords: [String?]
    
    public init(isStatic: Bool, keywords: [String?]) {
        self.isStatic = isStatic
        self.keywords = keywords
    }
}

/// Signature for a function intention
public struct FunctionSignature: Equatable {
    public var isStatic: Bool
    public var name: String
    public var returnType: SwiftType
    public var parameters: [ParameterSignature]
    
    public var asSelector: SelectorSignature {
        return
            SelectorSignature(
                isStatic: isStatic,
                keywords: [name] + parameters.map { $0.label == "_" ? nil : $0.label }
            )
    }
    
    public init(name: String, parameters: [ParameterSignature] = [],
                returnType: SwiftType = .void, isStatic: Bool = false) {
        self.isStatic = isStatic
        self.name = name
        self.returnType = returnType
        self.parameters = parameters
    }
    
    /// Returns a `SwiftType.block`-equivalent type for this function signature
    public var swiftClosureType: SwiftType {
        return .block(returnType: returnType, parameters: parameters.map { $0.type })
    }
    
    public var droppingNullability: FunctionSignature {
        let parameters = self.parameters.map {
            ParameterSignature(label: $0.label, name: $0.name, type: $0.type.deepUnwrapped)
        }
        
        return FunctionSignature(name: name,
                                 parameters: parameters,
                                 returnType: returnType.deepUnwrapped,
                                 isStatic: isStatic)
    }
    
    /// Returns `true` iff `self` and `other` match using Objective-C signature
    /// matching rules.
    public func matchesAsSelector(_ other: FunctionSignature) -> Bool {
        return asSelector == other.asSelector
    }
    
    /// Returns `true` iff `self` and `other` match using C signature matching
    /// rules.
    ///
    /// In C, function signatures match if they have the same name, and the same
    /// number of parameters.
    public func matchesAsCFunction(_ other: FunctionSignature) -> Bool {
        return name == other.name && parameters.count == other.parameters.count
    }
}

public extension FunctionCallPostfix {
    /// Generates an Objective-C selector from this function call united with
    /// a given method name.
    public func selectorWith(methodName: String) -> SelectorSignature {
        let selectors: [String?]
            = [methodName] + arguments.map { $0.label }
        
        return SelectorSignature(isStatic: false, keywords: selectors)
    }
}

public struct ParameterSignature: Equatable {
    public var label: String
    public var name: String
    public var type: SwiftType
    
    public init(name: String, type: SwiftType) {
        self.label = name
        self.name = name
        self.type = type
    }
    
    public init(label: String, name: String, type: SwiftType) {
        self.label = label
        self.name = name
        self.type = type
    }
}

/// Defines a protocol for a value storage intention.
public protocol ValueStorageIntention: Intention {
    var name: String { get }
    var storage: ValueStorage { get }
}

public extension ValueStorageIntention {
    public var type: SwiftType {
        return storage.type
    }
    
    public var ownership: Ownership {
        return storage.ownership
    }
    
    public var isConstant: Bool {
        return storage.isConstant
    }
}
