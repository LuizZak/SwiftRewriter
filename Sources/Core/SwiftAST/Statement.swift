public class Statement: SyntaxNode, Codable, Equatable {
    /// Returns `true` if this statement resolve to an unconditional jump out
    /// of the current context.
    ///
    /// Returns true for `.break`, `.continue`, `.return`, and `.throw` statements.
    public var isUnconditionalJump: Bool {
        false
    }
    
    /// Returns `true` if the type of the current statement instance supports
    /// labels.
    public var isLabelableStatementType: Bool {
        return false
    }
    
    /// This statement label's (parsed from C's goto labels), if any.
    public var label: String?
    
    /// A list of comments, including leading // or /*, which are printed before
    /// the statement.
    public var comments: [SwiftComment] = []
    
    /// A comment that trails the statement (i.e. it's placed after the statement,
    /// before the newline feed)
    public var trailingComment: SwiftComment?
    
    override internal init() {
        super.init()
    }
    
    public init(label: String) {
        self.label = label
        
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.label = try container.decodeIfPresent(String.self, forKey: .label)
        self.comments = try container.decode([SwiftComment].self, forKey: .comments)
        self.trailingComment = try container.decodeIfPresent(SwiftComment.self, forKey: .trailingComment)
        
        super.init()
    }
    
    @inlinable
    open override func copy() -> Statement {
        fatalError("Must be overridden by subclasses")
    }
    
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this statement's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// statement
    @inlinable
    public func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        fatalError("Must be overridden by subclasses")
    }
    
    /// Accepts the given stateful visitor instance, calling the appropriate
    /// visiting method according to this statement's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Parameter state: The state to pass to the visitor
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// statement
    @inlinable
    public func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        fatalError("Must be overridden by subclasses")
    }
    
    public func isEqual(to other: Statement) -> Bool {
        false
    }
    
    public static func == (lhs: Statement, rhs: Statement) -> Bool {
        if lhs === rhs {
            return true
        }
        if lhs.label != rhs.label || lhs.comments != rhs.comments || lhs.trailingComment != rhs.trailingComment {
            return false
        }
        
        return lhs.isEqual(to: rhs)
    }
    
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(label, forKey: .label)
        try container.encode(comments, forKey: .comments)
        try container.encodeIfPresent(trailingComment, forKey: .trailingComment)
    }
    
    @usableFromInline
    final func cast<T: Statement>() -> T? {
        self as? T
    }
    
    private enum CodingKeys: String, CodingKey {
        case label
        case comments
        case trailingComment
    }
}

public extension Statement {
    @inlinable
    func copyMetadata(from other: Statement) -> Self {
        self.label = other.label
        self.comments = other.comments
        self.trailingComment = other.trailingComment
        
        return self
    }
    
    /// Labels this statement with a given label and returns this instance.
    func labeled(_ label: String?) -> Self {
        self.label = label
        
        return self
    }
    
    /// Replaces the current list of leading comments and returns this instance.
    func withComments(_ comments: [String]) -> Self {
        return withSwiftComments(comments.map {
            SwiftComment.line($0)
        })
    }
    
    /// Replaces the current list of leading comments and returns this instance.
    func withSwiftComments(_ comments: [SwiftComment]) -> Self {
        self.comments = comments
        
        return self
    }
    
    /// Replaces the trailing comment from this statement with a new value and
    /// returns this instance.
    func withTrailingComment(_ comment: String?) -> Self {
        withTrailingSwiftComment(
            comment.map(SwiftComment.line(_:))
        )
    }
    
    /// Replaces the trailing comment from this statement with a new value and
    /// returns this instance.
    func withTrailingSwiftComment(_ comment: SwiftComment?) -> Self {
        self.trailingComment = comment
        
        return self
    }
}
