public extension KeyedDecodingContainerProtocol {
    
    func decodeStatement<S: Statement>(_ type: S.Type = S.self, forKey key: Key) throws -> S {
        let container = try self.decode(SwiftASTSerializer.StatementContainer.self, forKey: key)
        
        if let s = container.kind.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.kind.statement))
    }
    
    func decodeStatements(forKey key: Key) throws -> [Statement] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Statement] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeStatement(Statement.self))
        }
        
        return stmts
    }
    
    func decodeStatementIfPresent<S: Statement>(_ type: S.Type = S.self, forKey key: Key) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.StatementContainer.self, forKey: key) else {
            return nil
        }
        
        if let s = container.kind.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.kind.statement))
    }
    
    func decodeStatementsIfPresent(forKey key: Key) throws -> [Statement]? {
        if !self.contains(key) {
            return nil
        }
        
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Statement] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeStatement(Statement.self))
        }
        
        return stmts
    }
}

public extension KeyedDecodingContainerProtocol {
    
    func decodeExpression<E: Expression>(_ type: E.Type = E.self, forKey key: Key) throws -> E {
        let container = try self.decode(SwiftASTSerializer.ExpressionContainer.self, forKey: key)
        
        if let s = container.kind.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.kind.expression))
    }
    
    func decodeExpressions(forKey key: Key) throws -> [Expression] {
        var nested = try self.nestedUnkeyedContainer(forKey: key)
        
        var stmts: [Expression] = []
        
        while !nested.isAtEnd {
            stmts.append(try nested.decodeExpression(Expression.self))
        }
        
        return stmts
    }
    
    func decodeExpressionIfPresent<E: Expression>(_ type: E.Type = E.self, forKey key: Key) throws -> E? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.ExpressionContainer.self, forKey: key) else {
            return nil
        }
        
        if let s = container.kind.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.kind.expression))
    }
}
