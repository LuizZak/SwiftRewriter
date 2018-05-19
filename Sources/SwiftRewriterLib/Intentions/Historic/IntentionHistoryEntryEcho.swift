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
