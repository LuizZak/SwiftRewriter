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
        return _childrenNodes
    }
    
    public init(exp: Expression, cases: [SwitchCase], defaultCase: [Statement]?) {
        self.exp = exp
        self.cases = cases
        self.defaultCase = defaultCase
        
        super.init()
        
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
    
    public override func copy() -> SwitchStatement {
        return
            SwitchStatement(exp: exp.copy(),
                            cases: cases.map { $0.copy() },
                            defaultCase: defaultCase?.map { $0.copy() }).copyMetadata(from: self)
    }
    
    private func reloadChildrenNodes() {
        _childrenNodes.removeAll()
        
        _childrenNodes.append(exp)
        
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
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitSwitch(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as SwitchStatement:
            return exp == rhs.exp && cases == rhs.cases && defaultCase == rhs.defaultCase
        default:
            return false
        }
    }
}
public extension Statement {
    public var asSwitch: SwitchStatement? {
        return cast()
    }
}

public struct SwitchCase: Equatable {
    /// Patterns for this switch case
    public var patterns: [Pattern]
    /// Statements for the switch case
    public var statements: [Statement]
    
    public init(patterns: [Pattern], statements: [Statement]) {
        self.patterns = patterns
        self.statements = statements
    }
    
    public func copy() -> SwitchCase {
        return SwitchCase(patterns: patterns.map { $0.copy() },
                          statements: statements.map { $0.copy() })
    }
}
