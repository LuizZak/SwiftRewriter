import GrammarModels
import SwiftAST

/// Defines an object that features a history tracker instance
public protocol Historic {
    /// Gets the history tracker for this intention
    var history: IntentionHistory { get }
}

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol Intention: class, Context, Historic {
    /// Reference to an AST node that originated this source-code generation
    /// intention
    var source: ASTNode? { get }
    
    /// Parent for this intention
    var parent: Intention? { get }
}

/// Tracks changes made to an intention as it is read by AST readers and modified
/// by intention passes so it can be sourced
public protocol IntentionHistory {
    var entries: [IntentionHistoryEntry] { get }
    
    /// Gets a textual summary of this intention history's contents.
    var summary: String { get }
    
    /// Merges the history of another history tracker into this history tracker
    /// instance.
    func mergeHistories(_ other: IntentionHistory)
    
    /// Adds a record for this entry
    @discardableResult
    func record(_ entry: IntentionHistoryEntry) -> IntentionHistoryEntryEcho
    
    /// A shortcut method to record the creation of the intention this history is
    /// contained within.
    @discardableResult
    func recordCreation(description: String) -> IntentionHistoryEntryEcho
    
    /// A shortcut method to record a change to this intention history
    @discardableResult
    func recordChange(tag: String, description: String, relatedIntentions: [Intention]) -> IntentionHistoryEntryEcho
    
    /// Records a merge with one or more intentions, with a given description.
    @discardableResult
    func recordMerge(with intentions: [Intention], tag: String, description: String) -> IntentionHistoryEntryEcho
    
    /// Records a split form another intention, with a given description.
    @discardableResult
    func recordSplit(from intention: Intention, tag: String, description: String) -> IntentionHistoryEntryEcho
}


/// Allows 'echoing' the recording of a history entry into other history trackers.
///
/// e.g.:
///
/// ```
/// [...]
/// myClass.removeMethod(method[0])
/// myClass.addMethod(newMethod)
///
/// myClass.recordChange(tag: "MergePass", description: "Merging two methods into a single default method")
///     .echoRecord(to: newMethod.history)
/// ```
public struct IntentionHistoryEntryEcho {
    let entry: IntentionHistoryEntry
    
    @discardableResult
    public func echoRecord(to history: IntentionHistory) -> IntentionHistoryEntryEcho {
        return history.record(entry)
    }
    
    @discardableResult
    public func echoRecord(to intention: Intention) -> IntentionHistoryEntryEcho {
        return intention.history.record(entry)
    }
}

public extension IntentionHistory {
    public var summary: String {
        if entries.count == 0 {
            return "<empty>"
        }
        
        var result = ""
        
        for (i, entry) in entries.enumerated() {
            if i > 0 {
                result += "\n"
            }
            
            result += entry.summary
        }
        
        return result
    }
    
    @discardableResult
    public func recordCreation(description: String) -> IntentionHistoryEntryEcho {
        return record(IntentionHistoryEntry(tag: "Creation", description: description, relatedIntentions: []))
    }
    
    @discardableResult
    public func recordChange(tag: String, description: String) -> IntentionHistoryEntryEcho {
        return recordChange(tag: tag, description: description, relatedIntentions: [])
    }
    
    @discardableResult
    public func recordChange(tag: String, description: String, relatedIntentions: [Intention]) -> IntentionHistoryEntryEcho {
        return record(IntentionHistoryEntry(tag: tag, description: description, relatedIntentions: relatedIntentions))
    }
    
    @discardableResult
    public func recordMerge(with intentions: [Intention], tag: String, description: String) -> IntentionHistoryEntryEcho {
        return record(IntentionHistoryEntry(tag: tag, description: description, relatedIntentions: intentions))
    }
    
    @discardableResult
    public func recordSplit(from intention: Intention, tag: String, description: String) -> IntentionHistoryEntryEcho {
        return record(IntentionHistoryEntry(tag: tag, description: description, relatedIntentions: [intention]))
    }
}

/// An entry for an intention history
public struct IntentionHistoryEntry: CustomStringConvertible {
    /// A textual tag to help when scrolling through history entries
    public var tag: String
    
    /// The description for this history entry, describing a change to an intention.
    public var description: String
    
    /// Any one or more intentions that are related to this history entry.
    /// May be empty, in case this entry is e.g. an initial creation entry.
    public var relatedIntentions: [Intention]
    
    /// Returns a brief formatted summary string.
    public var summary: String {
        return "[\(tag)] \(description)"
    }
    
    public init(tag: String, description: String, relatedIntentions: [Intention] = []) {
        self.tag = tag
        self.description = description
        self.relatedIntentions = relatedIntentions
    }
}

class IntentionHistoryTracker: IntentionHistory {
    var entries: [IntentionHistoryEntry] = []
    
    init(entries: [IntentionHistoryEntry] = []) {
        self.entries = entries
    }
    
    func mergeHistories(_ other: IntentionHistory) {
        entries.append(contentsOf: other.entries)
    }
    
    @discardableResult
    func record(_ entry: IntentionHistoryEntry) -> IntentionHistoryEntryEcho {
        entries.append(entry)
        
        return IntentionHistoryEntryEcho(entry: entry)
    }
}

/// Helper functions for generating friendly textual representations of types,
/// methods and other constructs.
public enum TypeFormatter {
    /// Generates a string representation of a given method's signature
    public static func asString(method: KnownMethod, ofType type: KnownType) -> String {
        var result = ""
        
        result = type.typeName + "." + method.signature.name
        
        result += asString(parameters: method.signature.parameters)
        result += method.signature.returnType != .void ? " -> " + stringify(method.signature.returnType) : ""
        
        return result
    }
    
    /// Generates a string representation of a given property's signature, with
    /// type name, property name and property type.
    public static func asString(property: KnownProperty, ofType type: KnownType) -> String {
        var result = ""
        
        result += property.isStatic ? "static " : ""
        result += property.storage.ownership == .strong ? "" : "\(property.storage.ownership.rawValue) "
        result += type.typeName + "." + property.name + ": " + stringify(property.storage.type)
        
        return result
    }
    
    /// Generates a string representation of a given instance field's signature,
    /// with type name, property name and property type.
    public static func asString(field: InstanceVariableGenerationIntention, ofType type: KnownType) -> String {
        var result = ""
        
        result += field.isStatic ? "static " : ""
        result += field.storage.ownership == .strong ? "" : "\(field.storage.ownership.rawValue) "
        result += type.typeName + "." + field.name + ": " + stringify(field.storage.type)
        
        return result
    }
    
    /// Generates a string representation of a given extension's typename
    public static func asString(extension ext: ClassExtensionGenerationIntention) -> String {
        return
            "extension \(ext.typeName)"
                + (ext.categoryName.map { " (\($0))" } ?? "")
    }
    
    /// Generates a string representation of a given function signature.
    /// The signature's name can be optionally include during conversion.
    public static func asString(signature: FunctionSignature, includeName: Bool = false) -> String {
        var result = ""
        
        if includeName {
            result += signature.name
        }
        
        result += asString(parameters: signature.parameters)
        
        if signature.returnType != .void {
            result += " -> \(signature.returnType)"
        }
        
        return result
    }
    
    /// Generates a string representation of a given set of function parameters,
    /// with parenthesis enclosing the types.
    ///
    /// Returns an empty set of parenthesis if the parameters are empty.
    public static func asString(parameters: [ParameterSignature]) -> String {
        var result = "("
        
        for param in parameters {
            if param.label != param.name {
                result += "\(param.label) "
            }
            
            result += param.name
            result += ": "
            result += stringify(param.type)
        }
        
        return result + ")"
    }
    
    static func stringify(_ type: SwiftType) -> String {
        return type.description
    }
}
