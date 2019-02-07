public extension UnkeyedEncodingContainer {
    
    mutating func encodeIntention(_ intention: Intention) throws {
        let container = try IntentionSerializer.IntentionContainer(intention: intention)
        
        try self.encode(container)
    }
    
    mutating func encodeIntentionIfPresent(_ intention: Intention?) throws {
        guard let intention = intention else {
            return
        }
        
        let container = try IntentionSerializer.IntentionContainer(intention: intention)
        
        try self.encode(container)
    }
}
