public class IfStatement: Statement, StatementKindType {
    public var statementKind: StatementKind {
        .if(self)
    }

    public var exp: Expression {
        didSet { oldValue.parent = nil; exp.parent = self }
    }
    public var body: CompoundStatement {
        didSet { oldValue.parent = nil; body.parent = self }
    }
    public var elseBody: CompoundStatement? {
        didSet { oldValue?.parent = nil; elseBody?.parent = self }
    }
    
    /// If non-nil, the expression of this if statement must be resolved to a
    /// pattern match over a given pattern.
    ///
    /// This is used to create if-let statements.
    public var pattern: Pattern? {
        didSet {
            oldValue?.setParent(nil)
            pattern?.setParent(self)
        }
    }
    
    /// Returns whether this `IfExpression` represents an if-let statement.
    public var isIfLet: Bool {
        pattern != nil
    }
    
    public override var children: [SyntaxNode] {
        var result: [SyntaxNode] = []

        if let pattern = pattern {
            pattern.collect(expressions: &result)
        }

        result.append(exp)
        result.append(body)

        if let elseBody = elseBody {
            result.append(elseBody)
        }

        return result
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }
    
    public init(exp: Expression, body: CompoundStatement, elseBody: CompoundStatement?, pattern: Pattern?) {
        self.exp = exp
        self.body = body
        self.elseBody = elseBody
        self.pattern = pattern
        
        super.init()
        
        exp.parent = self
        body.parent = self
        elseBody?.parent = self
        pattern?.setParent(self)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(forKey: .exp)
        body = try container.decodeStatement(CompoundStatement.self, forKey: .body)
        elseBody = try container.decodeStatementIfPresent(CompoundStatement.self, forKey: .elseBody)
        pattern = try container.decodeIfPresent(Pattern.self, forKey: .pattern)
        
        try super.init(from: container.superDecoder())
        
        exp.parent = self
        body.parent = self
        elseBody?.parent = self
        pattern?.setParent(self)
    }
    
    @inlinable
    public override func copy() -> IfStatement {
        let copy =
            IfStatement(
                exp: exp.copy(),
                body: body.copy(),
                elseBody: elseBody?.copy(),
                pattern: pattern?.copy()
            )
            .copyMetadata(from: self)
        
        copy.pattern = pattern?.copy()
        
        return copy
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitIf(self)
    }
    
    @inlinable
    public override func accept<V: StatementStatefulVisitor>(_ visitor: V, state: V.State) -> V.StmtResult {
        visitor.visitIf(self, state: state)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as IfStatement:
            return exp == rhs.exp && pattern == rhs.pattern && body == rhs.body && elseBody == rhs.elseBody
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pattern, forKey: .pattern)
        try container.encodeExpression(exp, forKey: .exp)
        try container.encodeStatement(body, forKey: .body)
        try container.encodeStatementIfPresent(elseBody, forKey: .elseBody)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case pattern
        case exp
        case body
        case elseBody
    }
}
public extension Statement {
    /// Returns `self as? IfStatement`.
    @inlinable
    var asIf: IfStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `IfStatement`
    /// class.
    @inlinable
    var isIf: Bool {
        asIf != nil
    }
    
    /// Creates a `IfStatement` instance using the given condition expression
    /// and compound statement as its body, optionally specifying an else block.
    static func `if`(
        _ exp: Expression,
        body: CompoundStatement,
        else elseBody: CompoundStatement? = nil
    ) -> IfStatement {

        IfStatement(exp: exp, body: body, elseBody: elseBody, pattern: nil)
    }
    
    /// Creates a `IfStatement` instance for an if-let binding using the given
    /// pattern and condition expression and compound statement as its body,
    /// optionally specifying an else block.
    static func ifLet(
        _ pattern: Pattern,
        _ exp: Expression,
        body: CompoundStatement,
        else elseBody: CompoundStatement? = nil
    ) -> IfStatement {

        IfStatement(exp: exp, body: body, elseBody: elseBody, pattern: pattern)
    }
}
