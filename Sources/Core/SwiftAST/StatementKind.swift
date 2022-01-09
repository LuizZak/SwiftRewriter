/// A deterministic container for all statement types provided by `SwiftAST`.
///
/// Useful for clients that perform different operations across all available
/// `Statement` subclasses.
public enum StatementKind: Codable {
    case `break`(BreakStatement)
    case compound(CompoundStatement)
    case `continue`(ContinueStatement)
    case `defer`(DeferStatement)
    case `do`(DoStatement)
    case repeatWhile(RepeatWhileStatement)
    case expressions(ExpressionsStatement)
    case `fallthrough`(FallthroughStatement)
    case `if`(IfStatement)
    case `for`(ForStatement)
    case localFunction(LocalFunctionStatement)
    case `return`(ReturnStatement)
    case `switch`(SwitchStatement)
    case `throw`(ThrowStatement)
    case unknown(UnknownStatement)
    case variableDeclarations(VariableDeclarationsStatement)
    case `while`(WhileStatement)

    /// Attempts to initialize this statement kind with a given statement.
    ///
    /// The method requires that the statement conform to `StatementKindType`
    /// at runtime.
    public init?(_ statement: Statement) {
        guard let kind = (statement as? StatementKindType)?.statementKind else {
            return nil
        }

        self = kind
    }

    /// Extracts the `Statement` within this `StatementKind`.
    public var statement: Statement {
        switch self {
        case .break(let s):
            return s
        case .compound(let s):
            return s
        case .continue(let s):
            return s
        case .defer(let s):
            return s
        case .do(let s):
            return s
        case .repeatWhile(let s):
            return s
        case .expressions(let s):
            return s
        case .fallthrough(let s):
            return s
        case .if(let s):
            return s
        case .for(let s):
            return s
        case .localFunction(let s):
            return s
        case .return(let s):
            return s
        case .switch(let s):
            return s
        case .throw(let s):
            return s
        case .unknown(let s):
            return s
        case .variableDeclarations(let s):
            return s
        case .while(let s):
            return s
        }
    }
}

/// Protocol for statement subclasses that expose their type wrapped in `StatementKind`
public protocol StatementKindType: Statement {
    var statementKind: StatementKind { get }
}
