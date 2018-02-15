import GrammarModels

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

/// Encapsulates a compound statement, that is, a series of statements enclosed
/// within braces.
public struct CompoundStatement: Equatable {
    /// An empty compound statement.
    public static var empty = CompoundStatement()
    
    public var statements: [Statement]
    
    public init() {
        self.statements = []
    }
    
    public init(statements: [Statement]) {
        self.statements = statements
    }
}

extension CompoundStatement: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Statement...) {
        self.statements = elements
    }
}

extension CompoundStatement: Sequence {
    public func makeIterator() -> IndexingIterator<[Statement]> {
        return statements.makeIterator()
    }
}

extension CompoundStatement: RandomAccessCollection {
    public func index(after i: Int) -> Int {
        return statements.index(after: i)
    }
    
    public var startIndex: Int {
        return statements.startIndex
    }
    
    public var endIndex: Int {
        return statements.endIndex
    }
    
    public subscript(_ index: Int) -> Statement {
        return statements[index]
    }
}

/// A top-level statement
public indirect enum Statement: Equatable {
    case semicolon
    case compound(CompoundStatement)
    case `if`(Expression, body: CompoundStatement, `else`: CompoundStatement?)
    case `while`(Expression, body: CompoundStatement)
    case `for`(Pattern, Expression, body: CompoundStatement)
    // TODO: case `switch`(...)
    case `defer`(CompoundStatement)
    case `return`(Expression?)
    case `break`
    case `continue`
    case expressions([Expression])
    case variableDeclarations([StatementVariableDeclaration])
    case unknown(UnknownASTContext)
    
    public static func expression(_ expr: Expression) -> Statement {
        return .expressions([expr])
    }
    
    public static func variableDeclaration(identifier: String, type: ObjcType, initialization: Expression?) -> Statement {
        return .variableDeclarations([
            StatementVariableDeclaration(identifier: identifier, type: type, initialization: initialization)
        ])
    }
}

/// A pattern for pattern-matching
public enum Pattern: Equatable {
    case identifier(String)
    indirect case tuple([Pattern])
    
    public var simplified: Pattern {
        switch self {
        case .tuple(let pt) where pt.count == 1:
            return pt[0]
        default:
            return self
        }
    }
}

public struct StatementVariableDeclaration: Equatable {
    public var identifier: String
    public var type: ObjcType
    public var initialization: Expression?
    
    public init(identifier: String, type: ObjcType, initialization: Expression?) {
        self.identifier = identifier
        self.type = type
        self.initialization = initialization
    }
}

extension Pattern: CustomStringConvertible {
    public var description: String {
        switch self.simplified {
        case .tuple(let tups):
            return "(" + tups.map({ $0.description }).joined(separator: ", ") + ")"
        case .identifier(let ident):
            return ident
        }
    }
}
