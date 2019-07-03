import Foundation
import GrammarModels
import KnownType
import SwiftAST

/// An intention to create a .swift file
public final class FileGenerationIntention: Intention {
    /// Used to sort file generation intentions after multi-threaded parsing is
    /// finished.
    public var index: Int = 0
    
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
        isEmptyExceptDirectives && preprocessorDirectives.isEmpty
    }
    
    /// Returns `true` if there are no intentions registered for this file, not
    /// counting any recorded preprocessor directive.
    public var isEmptyExceptDirectives: Bool {
        typeIntentions.isEmpty
            && typealiasIntentions.isEmpty
            && globalFunctionIntentions.isEmpty
            && globalVariableIntentions.isEmpty
    }
    
    /// Gets the class extensions (but not main class declarations) to create
    /// on this file.
    public var extensionIntentions: [ClassExtensionGenerationIntention] {
        typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
    }
    
    /// Gets the classes (but not class extensions) to create on this file.
    public var classIntentions: [ClassGenerationIntention] {
        typeIntentions.compactMap { $0 as? ClassGenerationIntention }
    }
    
    /// Gets the classes and class extensions to create on this file.
    public var classTypeIntentions: [BaseClassIntention] {
        typeIntentions.compactMap { $0 as? BaseClassIntention }
    }
    
    /// Gets the protocols to create on this file.
    public var protocolIntentions: [ProtocolGenerationIntention] {
        typeIntentions.compactMap { $0 as? ProtocolGenerationIntention }
    }
    
    /// Gets the enums to create on this file.
    public var enumIntentions: [EnumGenerationIntention] {
        typeIntentions.compactMap { $0 as? EnumGenerationIntention }
    }
    
    /// Gets the structs to create on this file.
    public var structIntentions: [StructGenerationIntention] {
        typeIntentions.compactMap { $0 as? StructGenerationIntention }
    }
    
    /// Gets the typealias intentions to create on this file.
    public private(set) var typealiasIntentions: [TypealiasIntention] = []
    
    /// Gets the global functions to create on this file.
    public private(set) var globalFunctionIntentions: [GlobalFunctionGenerationIntention] = []
    
    /// Gets the global variables to create on this file.
    public private(set) var globalVariableIntentions: [GlobalVariableGenerationIntention] = []
    
    public init(sourcePath: String, targetPath: String) {
        self.sourcePath = sourcePath
        self.targetPath = targetPath
        
        super.init()
        
        self.history.recordCreation(description: "Created from file \(sourcePath) to file \(targetPath)")
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        index = try container.decode(Int.self, forKey: .index)
        
        sourcePath = try container.decode(String.self, forKey: .sourcePath)
        targetPath = try container.decode(String.self, forKey: .targetPath)
        
        preprocessorDirectives =
            try container.decode([String].self, forKey: .preprocessorDirectives)
        importDirectives =
            try container.decode([String].self, forKey: .importDirectives)
        
        typeIntentions = try container.decodeIntentions(forKey: .typeIntentions)
        typealiasIntentions = try container.decodeIntentions(forKey: .typealiasIntentions)
        globalFunctionIntentions = try container.decodeIntentions(forKey: .globalFunctionIntentions)
        globalVariableIntentions = try container.decodeIntentions(forKey: .globalVariableIntentions)
        
        try super.init(from: container.superDecoder())
        
        for intention in typeIntentions {
            intention.parent = self
        }
        for intention in typealiasIntentions {
            intention.parent = self
        }
        for intention in globalFunctionIntentions {
            intention.parent = self
        }
        for intention in globalVariableIntentions {
            intention.parent = self
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(index, forKey: .index)
        try container.encode(sourcePath, forKey: .sourcePath)
        try container.encode(targetPath, forKey: .targetPath)
        try container.encode(preprocessorDirectives, forKey: .preprocessorDirectives)
        try container.encode(importDirectives, forKey: .importDirectives)
        try container.encodeIntentions(typeIntentions, forKey: .typeIntentions)
        try container.encodeIntentions(typealiasIntentions, forKey: .typealiasIntentions)
        try container.encodeIntentions(globalFunctionIntentions,
                                       forKey: .globalFunctionIntentions)
        try container.encodeIntentions(globalVariableIntentions,
                                       forKey: .globalVariableIntentions)
        
        try super.encode(to: container.superEncoder())
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
    
    private enum CodingKeys: String, CodingKey {
        case index
        case sourcePath
        case targetPath
        case preprocessorDirectives
        case importDirectives
        case typeIntentions
        case typealiasIntentions
        case globalFunctionIntentions
        case globalVariableIntentions
    }
}

extension FileGenerationIntention: KnownObjectiveCFile {
    public var fileName: String {
        (sourcePath as NSString).lastPathComponent
    }
    
    public var types: [KnownType] {
        typeIntentions
    }
    
    public var globals: [KnownGlobal] {
        globalVariableIntentions
            + globalFunctionIntentions
    }
}
