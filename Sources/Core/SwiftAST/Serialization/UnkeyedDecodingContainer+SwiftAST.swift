public extension UnkeyedDecodingContainer {
    
    mutating func decodeStatement<S: Statement>(_ type: S.Type = S.self) throws -> S {
        let container = try self.decode(SwiftASTSerializer.StatementContainer.self)
        
        if let s = container.kind.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.kind.statement))
    }
    
    mutating func decodeStatementIfPresent<S: Statement>(_ type: S.Type = S.self) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.StatementContainer.self) else {
            return nil
        }
        
        if let s = container.kind.statement as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedStatementType(Swift.type(of: container.kind.statement))
    }
}

public extension UnkeyedDecodingContainer {
    
    mutating func decodeExpression<E: Expression>(_ type: E.Type = E.self) throws -> E {
        let container = try self.decode(SwiftASTSerializer.ExpressionContainer.self)
        
        if let s = container.kind.expression as? E {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.kind.expression))
    }
    
    mutating func decodeExpressionIfPresent<S: Expression>(_ type: S.Type = S.self) throws -> S? {
        guard let container = try self.decodeIfPresent(SwiftASTSerializer.ExpressionContainer.self) else {
            return nil
        }
        
        if let s = container.kind.expression as? S {
            return s
        }
        
        throw SwiftASTSerializer.Error.unexpectedExpressionType(Swift.type(of: container.kind.expression))
    }
}
