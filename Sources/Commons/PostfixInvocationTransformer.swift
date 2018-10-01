import SwiftAST

/// Protocol for postfix invocation transformer classes which are used during AST
/// rewriting phase to allow selectively picking and rewriting certain postfix
/// AST constructs like free function and/or method calls.
public protocol PostfixInvocationTransformer {
    
    /// Returns whether this postfix transformer can do rewriting work on a given
    /// postfix expression.
    ///
    /// A return of `true` indicates this transformer _could_ return a non-nil
    /// transformed expression, but does not guarantee it.
    ///
    /// A return of `false` indicates this transformer will definitely return
    /// `nil`.
    ///
    /// - Parameter postfix: The postfix expression to analyze.
    /// - Returns: True if this postfix transformer can do useful work on the given
    /// expression, false otherwise.
    func canApply(to postfix: PostfixExpression) -> Bool
    
    /// Attempts to rewrite a given postfix expression, returning a new expression
    /// if any rewriting could be done, or `nil`, otherwise.
    ///
    /// If a previous call to `canApply(to:)` returns `false` for the same exact
    /// `postfix`, this method should also always return `nil`.
    ///
    /// - Parameter postfix: The postfix expression to convert.
    /// - Returns: A non-nil expression if a different replacement expression was
    /// created as a rewriten replacement, or `nil`, if the expression could not
    /// be rewritten.
    func attemptApply(on postfix: PostfixExpression) -> Expression?
}
