import ObjcGrammarModels

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

public extension IntentionHistory {
    var summary: String {
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
    func recordCreation(description: String) -> IntentionHistoryEntryEcho {
        record(IntentionHistoryEntry(tag: "Creation",
                                     description: description))
    }
    
    @discardableResult
    func recordChange(tag: String,
                      description: String) -> IntentionHistoryEntryEcho {
        
        recordChange(tag: tag, description: description, relatedIntentions: [])
    }
    
    @discardableResult
    func recordChange(tag: String,
                      description: String,
                      relatedIntentions: [Intention]) -> IntentionHistoryEntryEcho {
        
        record(IntentionHistoryEntry(tag: tag,
                                     description: description))
    }
    
    @discardableResult
    func recordMerge(with intentions: [Intention],
                     tag: String,
                     description: String) -> IntentionHistoryEntryEcho {
        
        record(IntentionHistoryEntry(tag: tag,
                                     description: description))
    }
    
    @discardableResult
    func recordSplit(from intention: Intention,
                     tag: String,
                     description: String) -> IntentionHistoryEntryEcho {
        
        record(IntentionHistoryEntry(tag: tag,
                                     description: description))
    }
}

public extension IntentionHistory {
    
    @discardableResult
    func recordSourceHistory(node: ASTNode) -> IntentionHistoryEntryEcho {
        guard let file = node.originalSource?.filePath else {
            return recordCreation(description: "from non-file node \(type(of: node))")
        }
        
        return recordCreation(description: "\(file) line \(node.location.line) column \(node.location.column)")
    }
    
}
