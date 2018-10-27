public extension KeyedEncodingContainerProtocol {
    
    public mutating func encodeStatement(_ stmt: Statement, forKey key: Key) throws {
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container, forKey: key)
    }
    
    public mutating func encodeStatements(_ stmts: [Statement], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for stmt in stmts {
            try nested.encodeStatement(stmt)
        }
    }
    
    public mutating func encodeStatementIfPresent(_ stmt: Statement?, forKey key: Key) throws {
        guard let stmt = stmt else {
            return
        }
        
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container, forKey: key)
    }
}

public extension KeyedEncodingContainerProtocol {
    
    public mutating func encodeExpression(_ exp: Expression, forKey key: Key) throws {
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container, forKey: key)
    }
    
    public mutating func encodeExpressions(_ exps: [Expression], forKey key: Key) throws {
        var nested = self.nestedUnkeyedContainer(forKey: key)
        
        for exp in exps {
            try nested.encodeExpression(exp)
        }
    }
    
    public mutating func encodeExpressionIfPresent(_ exp: Expression?, forKey key: Key) throws {
        guard let exp = exp else {
            return
        }
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container, forKey: key)
    }
}
