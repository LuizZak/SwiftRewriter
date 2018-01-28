/// A token that the lexer has read
public struct Token: Equatable {
    /// Gets a value specifying whether this Token represents an end-of-file token.
    public var isEndOfFile: Bool {
        return type == .eof
    }
    
    public var type: TokenType
    public var string: String
    public var location: SourceLocation
    
    public init(type: TokenType, string: String, location: SourceLocation) {
        self.type = type
        self.string = string
        self.location = location
    }
}

extension Token: CustomStringConvertible {
    public var description: String {
        return "{ type: \(type), string: \"\(string)\", location: \(location) }"
    }
}
