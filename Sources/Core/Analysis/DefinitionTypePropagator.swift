import SwiftAST
import Intentions
import TypeSystem

/// Performs analysis on operations performed on values and suggests types for
/// definitions.
public class DefinitionTypePropagator {
    let options: Options
    let typeSystem: TypeSystem
    let typeResolver: ExpressionTypeResolver

    public init(options: Options, typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver) {
        self.options = options
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
    }

    public func propagate(_ statement: CompoundStatement) -> CompoundStatement {
        typeResolver.ignoreResolvedExpressions = false

        var current: CompoundStatement = statement
        var didWork: Bool = false

        let rewriter = makeVariableDeclarationPropagator {
            didWork = true
        }

        repeat {
            current = toCompound(typeResolver.resolveTypes(in: current))

            didWork = false
            
            current = toCompound(rewriter.visitCompound(current))
        } while didWork

        return current
    }

    public func propagate(_ expression: Expression) -> Expression {
        typeResolver.ignoreResolvedExpressions = false

        var current: Expression = expression
        var didWork: Bool = false

        let rewriter = makeVariableDeclarationPropagator {
            didWork = true
        }

        repeat {
            current = typeResolver.resolveType(expression)

            didWork = false
            
            current = rewriter.visitExpression(expression)
        } while didWork

        return current
    }

    private func makeVariableDeclarationPropagator(_ didWork: @escaping () -> Void) -> VariableDeclarationTypePropagationRewriter {
        let localUsageAnalyzer = LocalUsageAnalyzer(typeSystem: typeSystem)

        return VariableDeclarationTypePropagationRewriter(
            options: options,
            typeSystem: typeSystem,
            typeResolver: typeResolver,
            localUsageAnalyzer: localUsageAnalyzer,
            didWork: didWork
        )
    }

    private func toCompound<S: Statement>(_ stmt: S) -> CompoundStatement {
        if let stmt = stmt.asCompound {
            return stmt
        }

        return .compound([stmt])
    }

    public struct Options {
        /// The base type that is recognized as a wildcard type that propagations
        /// are applied to.
        public var baseType: SwiftType

        /// The base numerical type that is used when deciding on types for numeric
        /// literals.
        ///
        /// If `nil`, numeric variables are resolved as their current numeric
        /// initialization types.
        public var baseNumericType: SwiftType?

        /// The base string type that is used when deciding on types for string
        /// literals.
        ///
        /// If `nil`, string variables are resolved as their current string
        /// initialization types.
        public var baseStringType: SwiftType?

        public init(
            baseType: SwiftType,
            baseNumericType: SwiftType?,
            baseStringType: SwiftType?
        ) {
            self.baseType = baseType
            self.baseNumericType = baseNumericType
            self.baseStringType = baseStringType
        }
    }

    private class VariableDeclarationTypePropagationRewriter: SyntaxNodeRewriter {
        let options: Options
        let typeSystem: TypeSystem
        let typeResolver: ExpressionTypeResolver
        let localUsageAnalyzer: LocalUsageAnalyzer
        let didWork: () -> Void

        init(
            options: Options,
            typeSystem: TypeSystem,
            typeResolver: ExpressionTypeResolver,
            localUsageAnalyzer: LocalUsageAnalyzer,
            didWork: @escaping () -> Void
        ) {
            self.options = options
            self.typeSystem = typeSystem
            self.typeResolver = typeResolver
            self.localUsageAnalyzer = localUsageAnalyzer
            self.didWork = didWork

            super.init()
        }

        override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
            for (i, decl) in stmt.decl.enumerated() {
                guard decl.type == options.baseType else {
                    continue
                }

                guard let firstAssignment = self.firstAssignment(for: decl, stmt, index: i) else {
                    continue
                }

                let resolved = typeResolver.resolveType(firstAssignment)
                guard !resolved.isErrorTyped, let resolvedType = resolved.resolvedType else {
                    continue
                }

                var changed = false
                func assign(type: SwiftType) {
                    if stmt.decl[i].type == type {
                        return
                    }

                    stmt.decl[i].type = type

                    changed = true
                    didWork()
                }

                if typeSystem.isNumeric(resolvedType) {
                    assign(type: options.baseNumericType ?? resolvedType)
                } else if resolvedType == .string {
                    assign(type: options.baseStringType ?? resolvedType)
                } else {
                    if decl.ownership == .weak && typeSystem.isClassInstanceType(resolvedType) {
                        assign(type: .optional(resolvedType))
                    } else {
                        assign(type: resolvedType)
                    }
                }

                // Quit early so type changes can be propagated before attempting
                // the next definition in this declaration
                if changed {
                    return stmt
                }
            }

            return stmt
        }

        private func firstAssignment(
            for decl: StatementVariableDeclaration,
            _ stmt: VariableDeclarationsStatement,
            index: Int
        ) -> Expression? {

            if let initialization = decl.initialization {
                return initialization
            }

            guard let parent = stmt.parent as? Statement else {
                return nil
            }

            let definition: LocalCodeDefinition = .forVarDeclElement(decl, stmt, index: index)
            let usages = localUsageAnalyzer.findUsagesOf(
                definition: definition,
                in: .statement(parent),
                intention: nil
            )

            guard let first = usages.first(where: { !$0.isReadOnlyUsage }) else {
                return nil
            }

            let expression = first.expression

            guard let parent = expression.parentExpression else {
                return nil
            }

            switch parent {
            case let exp as AssignmentExpression where exp.lhs == expression:
                return exp.rhs
            default:
                return nil
            }
        }
    }
}
