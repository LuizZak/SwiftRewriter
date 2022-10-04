extension Expression {
    /// Assigns a given `SwiftType` as the `self.resolvedType` for this expression
    /// and returns `self` for chaining.
    public func typed(_ type: SwiftType?) -> Self {
        resolvedType = type
        
        return self
    }
    
    /// Assigns a given `SwiftType` as the `self.expectedType` for this expression
    /// and returns `self` for chaining.
    public func typed(expected: SwiftType?) -> Self {
        expectedType = expected
        
        return self
    }
}
