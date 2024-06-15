import SwiftAST

extension ExpressionTypeResolver {
    func pushScopeContext(_ context: ScopeContext) {
        self.scopeContextStack.append(context)
    }

    func popScopeContext() {
        self.scopeContextStack.removeLast()
    }

    /// Whether the current scope context contains elements that may result in
    /// one or more definitions reachable for the current scope to be ignored.
    ///
    /// Checks for ignored definitions should be then done with
    /// `shouldIgnoreDefinition(_:)`, where this function returning `false`
    /// indicates that no definition passed to `shouldIgnoreDefinition(_:)` will
    /// return `true`.
    func hasIgnorableContext() -> Bool {
        for scopeContext in scopeContextStack {
            switch scopeContext {
            case .guardStatement:
                return true
            }
        }

        return false
    }

    /// Returns `true` if the given definition should not be considered available
    /// at the current code context.
    func shouldIgnoreDefinition(_ definition: CodeDefinition) -> Bool {
        if let definition = definition as? LocalCodeDefinition {
            return isCurrentGuardClauseDefinition(definition)
        }

        return false
    }

    /// Returns `true` if the given definition resolves as a clause of an enclosed
    /// guard statement that is currently pushed in the scope context.
    func isCurrentGuardClauseDefinition(_ definition: LocalCodeDefinition) -> Bool {
        switch definition.location {
        case .conditionalClause(let element, _):
            guard let guardStmt = element.parent?.parent as? GuardStatement else {
                return false
            }

            return scopeContextStack.contains { ctx in
                if case .guardStatement(guardStmt) = ctx {
                    true
                } else {
                    false
                }
            }

        default:
            return false
        }
    }

    /// Additional code scope context pushed and popped while resolving types
    /// and collecting definitions.
    enum ScopeContext {
        /// A body of a guard statement, where declarations made by the guard's
        /// pattern cannot be visible to `GuardStatement.elseBody`.
        case guardStatement(GuardStatement)
    }
}
