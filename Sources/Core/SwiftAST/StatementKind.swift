/// A deterministic container for all statement types provided by `SwiftAST`.
///
/// Useful for clients that perform different operations across all available
/// `Statement` subclasses.
public enum StatementKind {
    case `break`(BreakStatement)
    case compound(CompoundStatement)
    case `continue`(ContinueStatement)
    case `defer`(DeferStatement)
    case `do`(DoStatement)
    case doWhile(DoWhileStatement)
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
}

/// Protocol for statement subclasses that expose their type wrapped in `StatementKind`
public protocol StatementKindType: Statement {
    var statementKind: StatementKind { get }
}

