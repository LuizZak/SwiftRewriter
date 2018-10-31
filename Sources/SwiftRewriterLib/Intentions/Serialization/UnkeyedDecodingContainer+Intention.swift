public extension UnkeyedDecodingContainer {
    
    public mutating func decodeIntention<I: Intention>(_ type: I.Type = I.self) throws -> I {
        let container = try self.decode(IntentionSerializer.IntentionContainer.self)
        
        if let intention = container.intention as? I {
            return intention
        }
        
        throw IntentionSerializer.Error.unexpectedIntentionType(Swift.type(of: container.intention))
    }
    
    public mutating func decodeIntentionIfPresent<I: Intention>(_ type: I.Type = I.self) throws -> I? {
        guard let container = try self.decodeIfPresent(IntentionSerializer.IntentionContainer.self) else {
            return nil
        }
        
        if let intention = container.intention as? I {
            return intention
        }
        
        throw IntentionSerializer.Error.unexpectedIntentionType(Swift.type(of: container.intention))
    }
}
