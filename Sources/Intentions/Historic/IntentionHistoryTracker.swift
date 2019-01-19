final class IntentionHistoryTracker: IntentionHistory, Codable {
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
