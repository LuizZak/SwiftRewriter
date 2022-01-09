public class SwitchStatement: Statement, StatementKindType {
    /// Cache of children expression and statements stored into each case pattern
    private var _childrenNodes: [SyntaxNode] = []

    public var statementKind: StatementKind {
        .switch(self)
    }
    
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
        }
    }
    public var cases: [SwitchCase] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            cases.forEach { $0.parent = self }
        }
    }
    public var defaultCase: SwitchDefaultCase? {
        didSet {
            oldValue?.parent = nil
            defaultCase?.parent = self
        }
    }
    
    public override var children: [SyntaxNode] {
        var result = [exp] + cases
        if let defaultCase = defaultCase {
            result.append(defaultCase)
        }

        return result
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }
    
    public init(exp: Expression, cases: [SwitchCase], defaultCase: SwitchDefaultCase?) {
        self.exp = exp
        self.cases = cases
        self.defaultCase = defaultCase
        
        super.init()
        
        adjustParent()
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        exp = try container.decodeExpression(Expression.self, forKey: .exp)
        cases = try container.decode([SwitchCase].self, forKey: .cases)
        defaultCase = try container.decodeIfPresent(SwitchDefaultCase.self, forKey: .defaultCase)
        
        try super.init(from: container.superDecoder())
        
        adjustParent()
    }
    
    fileprivate func adjustParent() {
        exp.parent = self
        cases.forEach { $0.parent = self }
        defaultCase?.parent = self
    }
    
    @inlinable
    public override func copy() -> SwitchStatement {
        SwitchStatement(
            exp: exp.copy(),
            cases: cases.map { $0.copy() },
            defaultCase: defaultCase?.copy()
        ).copyMetadata(from: self)
    }
    
    @inlinable
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        visitor.visitSwitch(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as SwitchStatement:
            return exp == rhs.exp && cases == rhs.cases && defaultCase == rhs.defaultCase
        default:
            return false
        }
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeExpression(exp, forKey: .exp)
        try container.encode(cases, forKey: .cases)
        try container.encode(defaultCase, forKey: .defaultCase)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case cases
        case defaultCase
    }
}
public extension Statement {
    /// Returns `self as? SwitchStatement`.
    @inlinable
    var asSwitch: SwitchStatement? {
        cast()
    }

    /// Returns `true` if this `Statement` is an instance of `SwitchStatement`
    /// class.
    @inlinable
    var isSwitch: Bool? {
        asSwitch != nil
    }

    /// Creates a `SwitchStatement` instance using the given expression and list
    /// of cases, optionally specifying a default case as a list of statements.
    static func `switch`(
        _ exp: Expression,
        cases: [SwitchCase],
        defaultStatements defaultCase: [Statement]?
    ) -> SwitchStatement {

        SwitchStatement(
            exp: exp,
            cases: cases,
            defaultCase: defaultCase.map(SwitchDefaultCase.init)
        )
    }

    /// Creates a `SwitchStatement` instance using the given expression and list
    /// of cases, optionally specifying a default case as a list of statements.
    static func `switch`(
        _ exp: Expression,
        cases: [SwitchCase],
        default defaultCase: SwitchDefaultCase?
    ) -> SwitchStatement {

        SwitchStatement(
            exp: exp,
            cases: cases,
            defaultCase: defaultCase
        )
    }
}

public class SwitchCase: SyntaxNode, Codable, Equatable {
    /// Patterns for this switch case
    public var patterns: [Pattern] {
        didSet {
            oldValue.forEach { $0.setParent(nil) }
            patterns.forEach { $0.setParent(self) }
        }
    }

    /// Statements for the switch case
    public var statements: [Statement] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            statements.forEach { $0.parent = self }
        }
    }

    public override var children: [SyntaxNode] {
        patterns.flatMap(\.subExpressions) + statements
    }
    
    public init(patterns: [Pattern], statements: [Statement]) {
        self.patterns = patterns
        self.statements = statements
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.patterns = try container.decode([Pattern].self, forKey: .patterns)
        self.statements = try container.decodeStatements(forKey: .statements)
    }
    
    @inlinable
    public override func copy() -> SwitchCase {
        SwitchCase(
            patterns: patterns.map { $0.copy() },
            statements: statements.map { $0.copy() }
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(patterns, forKey: .patterns)
        try container.encodeStatements(statements, forKey: .statements)
    }

    public static func == (lhs: SwitchCase, rhs: SwitchCase) -> Bool {
        lhs === lhs || (lhs.patterns == rhs.patterns && lhs.statements == rhs.statements)
    }
    
    private enum CodingKeys: String, CodingKey {
        case patterns
        case statements
    }
}

public class SwitchDefaultCase: SyntaxNode, Codable, Equatable {
    /// Statements for the switch case
    public var statements: [Statement] {
        didSet {
            oldValue.forEach { $0.parent = nil }
            statements.forEach { $0.parent = self }
        }
    }

    public override var children: [SyntaxNode] {
        statements
    }
    
    public init(statements: [Statement]) {
        self.statements = statements
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.statements = try container.decodeStatements(forKey: .statements)
    }
    
    @inlinable
    public override func copy() -> SwitchDefaultCase {
        .init(
            statements: statements.map { $0.copy() }
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeStatements(statements, forKey: .statements)
    }

    public static func == (lhs: SwitchDefaultCase, rhs: SwitchDefaultCase) -> Bool {
        lhs === lhs || (lhs.statements == rhs.statements)
    }
    
    private enum CodingKeys: String, CodingKey {
        case statements
    }
}
