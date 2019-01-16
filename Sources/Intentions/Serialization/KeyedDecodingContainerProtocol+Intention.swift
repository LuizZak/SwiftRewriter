public extension KeyedDecodingContainerProtocol {
    
    public func decodeIntention<I: Intention>(_ type: I.Type = I.self, forKey key: Key) throws -> I {
        let container = try self.decode(IntentionSerializer.IntentionContainer.self, forKey: key)
        
        if let intention = container.intention as? I {
            return intention
        }
        
        throw IntentionSerializer.Error.unexpectedIntentionType(Swift.type(of: container.intention))
    }
    
    public func decodeIntentions<T: Intention>(forKey key: Key) throws -> [T] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [T] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeIntention())
        }
        
        return stmts
    }
    
    public func decodeIntentionIfPresent<I: Intention>(_ type: I.Type = I.self, forKey key: Key) throws -> I? {
        guard let container = try self.decodeIfPresent(IntentionSerializer.IntentionContainer.self, forKey: key) else {
            return nil
        }
        
        if let intention = container.intention as? I {
            return intention
        }
        
        throw IntentionSerializer.Error.unexpectedIntentionType(Swift.type(of: container.intention))
    }
    
    public func decodeIntentionsIfPresent<T: Intention>(forKey key: Key) throws -> [T]? {
        if !self.contains(key) {
            return nil
        }
        
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [T] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeIntention())
        }
        
        return stmts
    }
}
