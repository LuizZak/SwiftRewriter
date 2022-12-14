public extension KeyedEncodingContainerProtocol {
    
    mutating func encodeIntention(_ intention: Intention, forKey key: Key) throws {
        let container = try IntentionSerializer.IntentionContainer(intention: intention)
        
        try self.encode(container, forKey: key)
    }
    
    mutating func encodeIntentions(_ intentions: [Intention], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for stmt in intentions {
            try nested.encodeIntention(stmt)
        }
    }
    
    mutating func encodeIntentionIfPresent(_ intention: Intention?, forKey key: Key) throws {
        guard let intention = intention else {
            return
        }
        
        let container = try IntentionSerializer.IntentionContainer(intention: intention)
        
        try self.encode(container, forKey: key)
    }
}
