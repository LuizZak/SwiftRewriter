/// Specifies a swift comment block with different delimiters.
public enum SwiftComment: Hashable, Codable {
    /// A line comment that terminates in a newline.
    case line(String)
    
    /// A block comment with multi-line delimiters.
    case block(String)

    /// A documentation line comment that terminates in a newline.
    case docLine(String)

    /// A documentation block comment with multi-line delimiters.
    case docBlock(String)

    /// Gets the raw comment string value for this `SwiftComment`.
    public var string: String {
        switch self {
        case .block(let value):
            return value
        case .docBlock(let value):
            return value
        case .docLine(let value):
            return value
        case .line(let value):
            return value
        }
    }
}

extension SwiftComment: ExpressibleByStringLiteral {
    /// Initializes a `SwiftComment.line()` case.
    public init(stringLiteral value: String) {
        self = .line(value)
    }
}
