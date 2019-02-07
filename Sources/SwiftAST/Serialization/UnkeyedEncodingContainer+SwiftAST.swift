public extension UnkeyedEncodingContainer {
    
    mutating func encodeStatement(_ stmt: Statement) throws {
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container)
    }
    
    mutating func encodeStatementIfPresent(_ stmt: Statement?) throws {
        guard let stmt = stmt else {
            return
        }
        
        let container = try SwiftASTSerializer.StatementContainer(statement: stmt)
        
        try self.encode(container)
    }
}

public extension UnkeyedEncodingContainer {
    
    mutating func encodeExpression(_ exp: Expression) throws {
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container)
    }
    
    mutating func encodeExpressionIfPresent(_ exp: Expression?) throws {
        guard let exp = exp else {
            return
        }
        
        let container = try SwiftASTSerializer.ExpressionContainer(expression: exp)
        
        try self.encode(container)
    }
}
