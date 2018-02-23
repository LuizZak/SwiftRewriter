public struct UnknownASTContext: CustomStringConvertible, Equatable, CustomReflectable {
    public var description: String {
        return context.description
    }
    
    public var context: CustomStringConvertible
    
    public var customMirror: Mirror {
        return Mirror(reflecting: "")
    }
    
    public init(context: CustomStringConvertible) {
        self.context = context
    }
    
    public static func ==(lhs: UnknownASTContext, rhs: UnknownASTContext) -> Bool {
        return true
    }
}

public class Statement: SyntaxNode, Equatable {
    /// Returns an array of sub-statements contained within this statement, in
    /// case it is an statement formed of other statements.
    public var subStatements: [Statement] {
        return []
    }
    
    /// Returns `true` if this statement resolve to an unconditional jump out
    /// of the current context.
    ///
    /// Returns true for `.break`, `.continue` and `.return` statements.
    public var isUnconditionalJump: Bool {
        return false
    }
    
    /// Accepts the given visitor instance, calling the appropriate visiting method
    /// according to this statement's type.
    ///
    /// - Parameter visitor: The visitor to accept
    /// - Returns: The result of the visitor's `visit-` call when applied to this
    /// statement
    public func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitStatement(self)
    }
    
    public func isEqual(to other: Statement) -> Bool {
        return false
    }
    
    public static func ==(lhs: Statement, rhs: Statement) -> Bool {
        return lhs.isEqual(to: rhs)
    }
    
    fileprivate func cast<T>() -> T? {
        return self as? T
    }
}

/// An empty semicolon statement with no semantic functionality.
public class SemicolonStatement: Statement {
    public override func isEqual(to other: Statement) -> Bool {
        return other is SemicolonStatement
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitSemicolon(self)
    }
}
public extension Statement {
    public var asSemicolon: SemicolonStatement? {
        return cast()
    }
}

/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public class CompoundStatement: Statement, ExpressibleByArrayLiteral {
    /// An empty compound statement.
    public static var empty = CompoundStatement()
    
    public var isEmpty: Bool {
        return statements.isEmpty
    }
    
    public var statements: [Statement] = []
    
    public override var subStatements: [Statement] {
        return statements
    }
    
    public init(statements: [Statement]) {
        self.statements = statements
    }
    
    public required init(arrayLiteral elements: Statement...) {
        self.statements = elements
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitCompound(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as CompoundStatement:
            return statements == rhs.statements
        default:
            return false
        }
    }
}

extension CompoundStatement: Sequence {
    public func makeIterator() -> IndexingIterator<[Statement]> {
        return statements.makeIterator()
    }
}

public extension Statement {
    public var asCompound: CompoundStatement? {
        return cast()
    }
}

public class IfStatement: Statement {
    public var exp: Expression
    public var body: CompoundStatement
    public var elseBody: CompoundStatement?
    
    public override var subStatements: [Statement] {
        if let elseBody = elseBody {
            return [body, elseBody]
        } else {
            return [body]
        }
    }
    
    public init(exp: Expression, body: CompoundStatement, elseBody: CompoundStatement?) {
        self.exp = exp
        self.body = body
        self.elseBody = elseBody
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitIf(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as IfStatement:
            return exp == rhs.exp && body == rhs.body && elseBody == rhs.elseBody
        default:
            return false
        }
    }
}
public extension Statement {
    public var asIf: IfStatement? {
        return cast()
    }
}

public class WhileStatement: Statement {
    public var exp: Expression
    public var body: CompoundStatement
    
    public override var subStatements: [Statement] {
        return [body]
    }
    
    public init(exp: Expression, body: CompoundStatement) {
        self.exp = exp
        self.body = body
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitWhile(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as WhileStatement:
            return exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asWhile: WhileStatement? {
        return cast()
    }
}

public class ForStatement: Statement {
    public var pattern: Pattern
    public var exp: Expression
    public var body: CompoundStatement
    
    public override var subStatements: [Statement] {
        return [body]
    }
    
    public init(pattern: Pattern, exp: Expression, body: CompoundStatement) {
        self.pattern = pattern
        self.exp = exp
        self.body = body
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitFor(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ForStatement:
            return pattern == rhs.pattern && exp == rhs.exp && body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asFor: ForStatement? {
        return cast()
    }
}

public class SwitchStatement: Statement {
    public var exp: Expression
    public var cases: [SwitchCase]
    public var defaultCase: [Statement]?
    
    public override var subStatements: [Statement] {
        return cases.flatMap { $0.statements } + (defaultCase ?? [])
    }
    
    public init(exp: Expression, cases: [SwitchCase], defaultCase: [Statement]?) {
        self.exp = exp
        self.cases = cases
        self.defaultCase = defaultCase
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

public class DoStatement: Statement {
    public var body: CompoundStatement
    
    public override var subStatements: [Statement] {
        return [body]
    }
    
    public init(body: CompoundStatement) {
        self.body = body
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitDo(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as DoStatement:
            return body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asDoStatement: DoStatement? {
        return cast()
    }
}

public class DeferStatement: Statement {
    public var body: CompoundStatement
    
    public override var subStatements: [Statement] {
        return [body]
    }
    
    public init(body: CompoundStatement) {
        self.body = body
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitDefer(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as DeferStatement:
            return body == rhs.body
        default:
            return false
        }
    }
}
public extension Statement {
    public var asDefer: DeferStatement? {
        return cast()
    }
}

public class ReturnStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public var exp: Expression?
    
    public init(exp: Expression? = nil) {
        self.exp = exp
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitReturn(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ReturnStatement:
            return exp == rhs.exp
        default:
            return false
        }
    }
}
public extension Statement {
    public var asReturn: ReturnStatement? {
        return cast()
    }
}

public class BreakStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitBreak(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is BreakStatement
    }
}
public extension Statement {
    public var asBreak: BreakStatement? {
        return cast()
    }
}

public class ContinueStatement: Statement {
    public override var isUnconditionalJump: Bool {
        return true
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitContinue(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is ContinueStatement
    }
}
public extension Statement {
    public var asContinue: ContinueStatement? {
        return cast()
    }
}

public class ExpressionsStatement: Statement {
    public var expressions: [Expression]
    
    public init(expressions: [Expression]) {
        self.expressions = expressions
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitExpressions(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as ExpressionsStatement:
            return expressions == rhs.expressions
        default:
            return false
        }
    }
}
public extension Statement {
    public var asExpressions: ExpressionsStatement? {
        return cast()
    }
}

public class VariableDeclarationsStatement: Statement {
    public var decl: [StatementVariableDeclaration]
    
    public init(decl: [StatementVariableDeclaration]) {
        self.decl = decl
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitVariableDeclarations(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        switch other {
        case let rhs as VariableDeclarationsStatement:
            return decl == rhs.decl
        default:
            return false
        }
    }
}
public extension Statement {
    public var asVariableDeclaration: VariableDeclarationsStatement? {
        return cast()
    }
}

public class UnknownStatement: Statement {
    public var context: UnknownASTContext
    
    public init(context: UnknownASTContext) {
        self.context = context
    }
    
    public override func accept<V: StatementVisitor>(_ visitor: V) -> V.StmtResult {
        return visitor.visitUnknown(self)
    }
    
    public override func isEqual(to other: Statement) -> Bool {
        return other is UnknownStatement
    }
}
public extension Statement {
    public var asUnknown: UnknownStatement? {
        return cast()
    }
}

public extension Statement {
    public static var semicolon: SemicolonStatement {
        return SemicolonStatement()
    }
    public static func compound(_ cpd: [Statement]) -> CompoundStatement {
        return CompoundStatement(statements: cpd)
    }
    public static func `if`(_ exp: Expression, body: CompoundStatement, else elseBody: CompoundStatement?) -> IfStatement {
        return IfStatement(exp: exp, body: body, elseBody: elseBody)
    }
    public static func `while`(_ exp: Expression, body: CompoundStatement) -> WhileStatement {
        return WhileStatement(exp: exp, body: body)
    }
    public static func `for`(_ pattern: Pattern, _ exp: Expression, body: CompoundStatement) -> ForStatement {
        return ForStatement(pattern: pattern, exp: exp, body: body)
    }
    public static func `switch`(_ exp: Expression, cases: [SwitchCase], default defaultCase: [Statement]?) -> SwitchStatement {
        return SwitchStatement(exp: exp, cases: cases, defaultCase: defaultCase)
    }
    public static func `do`(_ stmt: CompoundStatement) -> DoStatement {
        return DoStatement(body: stmt)
    }
    public static func `defer`(_ stmt: CompoundStatement) -> DeferStatement {
        return DeferStatement(body: stmt)
    }
    public static func `return`(_ exp: Expression?) -> ReturnStatement {
        return ReturnStatement(exp: exp)
    }
    public static var `break`: BreakStatement {
        return BreakStatement()
    }
    public static var `continue`: ContinueStatement {
        return ContinueStatement()
    }
    public static func expressions(_ exp: [Expression]) -> ExpressionsStatement {
        return ExpressionsStatement(expressions: exp)
    }
    public static func variableDeclarations(_ decl: [StatementVariableDeclaration]) -> VariableDeclarationsStatement {
        return VariableDeclarationsStatement(decl: decl)
    }
    public static func unknown(_ context: UnknownASTContext) -> UnknownStatement {
        return UnknownStatement(context: context)
    }
    public static func expression(_ expr: Expression) -> Statement {
        return .expressions([expr])
    }
    
    public static func variableDeclaration(identifier: String, type: SwiftType, ownership: Ownership = .strong, isConstant: Bool = false, initialization: Expression?) -> Statement {
        return .variableDeclarations([
            StatementVariableDeclaration(identifier: identifier, type: type,
                                         ownership: ownership, isConstant: isConstant,
                                         initialization: initialization)
            ])
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
}

/// A pattern for pattern-matching
public enum Pattern: Equatable {
    /// An identifier pattern
    case identifier(String)
    
    /// An expression pattern
    case expression(Expression)
    
    /// A tupple pattern
    indirect case tuple([Pattern])
    
    public var simplified: Pattern {
        switch self {
        case .tuple(let pt) where pt.count == 1:
            return pt[0]
        default:
            return self
        }
    }
    
    public static func fromExpressions(_ expr: [Expression]) -> Pattern {
        if expr.count == 1 {
            return .expression(expr[0])
        }
        
        return .tuple(expr.map { .expression($0) })
    }
}

/// A variable declaration statement
public struct StatementVariableDeclaration: Equatable {
    public var identifier: String
    public var type: SwiftType
    public var ownership: Ownership
    public var isConstant: Bool
    public var initialization: Expression?
    
    public init(identifier: String, type: SwiftType, ownership: Ownership, isConstant: Bool, initialization: Expression?) {
        self.identifier = identifier
        self.type = type
        self.ownership = ownership
        self.isConstant = isConstant
        self.initialization = initialization
    }
}

extension Pattern: CustomStringConvertible {
    public var description: String {
        switch self.simplified {
        case .tuple(let tups):
            return "(" + tups.map({ $0.description }).joined(separator: ", ") + ")"
        case .expression(let exp):
            return exp.description
        case .identifier(let ident):
            return ident
        }
    }
}
