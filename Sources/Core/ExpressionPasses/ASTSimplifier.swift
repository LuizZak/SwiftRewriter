import SwiftAST

/// Simplifies AST structures that may be unnecessarily complex.
public class ASTSimplifier: ASTRewriterPass {
    public override func visitBaseExpression(_ exp: Expression) -> Expression {
        // Drop parens from base expressions
        if let parens = exp.asParens {
            notifyChange()

            return visitBaseExpression(parens.exp.copy())
        }

        return super.visitBaseExpression(exp)
    }

    public override func visitCompound(_ stmt: CompoundStatement) -> Statement {
        /// Simplify `do` statements that are the only statement within a compound
        /// statement context.
        if stmt.statements.count == 1, let doStmt = stmt.statements[0].asDoStatement, doStmt.catchBlocks.isEmpty {
            let body = doStmt.body.statements
            doStmt.body.statements = []
            stmt.statements = body

            for def in doStmt.body.localDefinitions() {
                stmt.definitions.recordDefinition(def, overwrite: false)
            }

            notifyChange()
        }

        // Flatten tuple base expressions into separate expression statements.
        var toSplit: [(Int, [Expression])] = []
        for (i, innerStmt) in stmt.statements.enumerated() {
            guard let expressions = innerStmt.asExpressions else {
                continue
            }

            var split: [Expression] = []
            for expression in expressions.expressions {
                if let tuple = expression.asTuple {
                    split.append(contentsOf: tuple.elements)
                } else {
                    split.append(expression)
                }
            }

            if expressions.expressions != split {
                toSplit.append((i, split))
            }
        }

        if !toSplit.isEmpty {
            var newStatements: [Statement] = stmt.statements.map { $0.copy() }

            for (index, exps) in toSplit.reversed() where !exps.isEmpty {
                let original = stmt.statements[index]

                let label = original.label
                let leadingComments = original.comments
                let trailingComments = original.trailingComment

                let expStatements: [Statement] = exps.map {
                    ExpressionsStatement(expressions: [$0.copy()])
                }

                expStatements.first?.label = label
                expStatements.first?.comments = leadingComments
                expStatements.last?.trailingComment = trailingComments

                newStatements.remove(at: index)
                newStatements.insert(contentsOf: expStatements, at: index)
            }

            stmt.statements = newStatements

            notifyChange()
        }

        return super.visitCompound(stmt)
    }

    /// Simplify check before invoking nullable closure
    public override func visitIf(_ stmt: IfStatement) -> Statement {
        let nullCheckM = ValueMatcherExtractor<IdentifierExpression?>()
        let postfix = ValueMatcherExtractor<PostfixExpression?>()

        let matcher =
            ValueMatcher<IfStatement>()
                .match(if: !hasElse())
                .keyPath(\.nullCheckMember?.asIdentifier,
                            .differentThan(nil) ->> nullCheckM)
                .keyPath(\.body.statements, hasCount(1))
                .keyPath(\.body.statements[0].asExpressions,
                         ValueMatcher<ExpressionsStatement>()
                            .keyPath(\.expressions, hasCount(1))
                            .keyPath(\.expressions[0].asPostfix,
                                     ValueMatcher<PostfixExpression>()
                                        .keyPath(\.exp, lazyEquals(nullCheckM.value))
                                        ->> postfix
                            ))

        if matcher.matches(stmt), let postfix = postfix.value?.copy() {
            postfix.op.optionalAccessKind = .safeUnwrap

            let statement = Statement.expression(postfix)

            notifyChange()

            return visitStatement(statement)
        }

        return super.visitIf(stmt)
    }

    /// Simplify switch statements by removing spurious `break` statements from
    /// cases
    public override func visitSwitch(_ stmt: SwitchStatement) -> Statement {
        for (i, cs) in stmt.cases.enumerated() {
            if cs.statements.count > 1 && cs.statements.last is BreakStatement {
                stmt.cases[i].body.statements.removeLast()
                notifyChange()
            }
        }

        if let def = stmt.defaultCase {
            if def.statements.count > 1 && def.statements.last is BreakStatement {
                def.body.statements.removeLast()
                notifyChange()
            }
        }

        return super.visitSwitch(stmt)
    }
}

extension IfStatement {
    var isNullCheck: Bool {
        // `if (nullablePointer) { ... }`-style checking:
        // An if-statement over a nullable value is also considered a null-check
        // in Objective-C.
        if exp.resolvedType?.isOptional == true {
            return true
        }

        guard let binary = exp.asBinary else {
            return false
        }

        return binary.op == .unequals && binary.rhs == .constant(.nil)
    }

    var nullCheckMember: Expression? {
        guard isNullCheck else {
            return nil
        }

        // `if (nullablePointer) { ... }`-style checking
        if exp.resolvedType?.isOptional == true {
            return exp
        }

        if let binary = exp.asBinary {
            return binary.rhs == .constant(.nil) ? binary.lhs : binary.rhs
        }

        return nil
    }
}
