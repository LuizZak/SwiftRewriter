import GrammarModels
import SwiftAST

/// Defines an object that features a history tracker instance
public protocol Historic {
    /// Gets the history tracker for this intention
    var history: IntentionHistory { get }
}

/// An intention represents the intent of the code transpiler to generate a
/// file/class/struct/property/etc. with Swift code.
public protocol Intention: class, Historic {
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
        if entries.isEmpty {
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
    public func recordChange(tag: String, description: String,
                             relatedIntentions: [Intention]) -> IntentionHistoryEntryEcho {
        return record(IntentionHistoryEntry(tag: tag, description: description, relatedIntentions: relatedIntentions))
    }
    
    @discardableResult
    public func recordMerge(with intentions: [Intention], tag: String,
                            description: String) -> IntentionHistoryEntryEcho {
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
