public class SwitchStatement: Statement {
    /// Cache of children expression and statements stored into each case pattern
    private var _childrenNodes: [SyntaxNode] = []
    
    public var exp: Expression {
        didSet {
            oldValue.parent = nil
            exp.parent = self
            
            reloadChildrenNodes()
        }
    }
    public var cases: [SwitchCase] {
        didSet {
            oldValue.forEach {
                $0.patterns.forEach {
                    $0.setParent(self)
                }
                $0.statements.forEach {
                    $0.parent = self
                }
            }
            
            cases.forEach {
                $0.patterns.forEach {
                    $0.setParent(self)
                }
                $0.statements.forEach {
                    $0.parent = self
                }
            }
            
            reloadChildrenNodes()
        }
    }
    public var defaultCase: [Statement]? {
        didSet {
            oldValue?.forEach { $0.parent = nil }
            defaultCase?.forEach { $0.parent = nil }
            
            reloadChildrenNodes()
        }
    }
    
    public override var children: [SyntaxNode] {
        _childrenNodes
    }
    
    public override var isLabelableStatementType: Bool {
        return true
    }
    
    public init(exp: Expression, cases: [SwitchCase], defaultCase: [Statement]?) {
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
        defaultCase = try container.decodeStatementsIfPresent(forKey: .defaultCase)
        
        try super.init(from: container.superDecoder())
        
        adjustParent()
    }
    
    fileprivate func adjustParent() {
        exp.parent = self
        cases.forEach {
            $0.patterns.forEach {
                $0.setParent(self)
            }
            $0.statements.forEach {
                $0.parent = self
            }
        }
        defaultCase?.forEach { $0.parent = self }
        
        reloadChildrenNodes()
    }
    
    @inlinable
    public override func copy() -> SwitchStatement {
        SwitchStatement(exp: exp.copy(),
                        cases: cases.map { $0.copy() },
                        defaultCase: defaultCase?.map { $0.copy() }).copyMetadata(from: self)
    }
    
    private func reloadChildrenNodes() {
        _childrenNodes = [exp]
        
        cases.forEach {
            $0.patterns.forEach {
                $0.collect(expressions: &_childrenNodes)
            }
            _childrenNodes.append(contentsOf: $0.statements)
        }
        
        if let defaultCase = defaultCase {
            _childrenNodes.append(contentsOf: defaultCase)
        }
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
        
        if let defaultCase = defaultCase {
            try container.encodeStatements(defaultCase, forKey: .defaultCase)
        }
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case exp
        case cases
        case defaultCase
    }
}
public extension Statement {
    @inlinable
    var asSwitch: SwitchStatement? {
        cast()
    }
}

public struct SwitchCase: Codable, Equatable {
    /// Patterns for this switch case
    public var patterns: [Pattern]
    /// Statements for the switch case
    public var statements: [Statement]
    
    public init(patterns: [Pattern], statements: [Statement]) {
        self.patterns = patterns
        self.statements = statements
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.patterns = try container.decode([Pattern].self, forKey: .patterns)
        self.statements = try container.decodeStatements(forKey: .statements)
    }
    
    @inlinable
    public func copy() -> SwitchCase {
        SwitchCase(patterns: patterns.map { $0.copy() },
                          statements: statements.map { $0.copy() })
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(patterns, forKey: .patterns)
        try container.encodeStatements(statements, forKey: .statements)
    }
    
    private enum CodingKeys: String, CodingKey {
        case patterns
        case statements
    }
}
