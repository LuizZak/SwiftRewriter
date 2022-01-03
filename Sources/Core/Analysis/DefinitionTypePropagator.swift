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
        VariableDeclarationTypePropagationRewriter(
            options: options,
            typeSystem: typeSystem,
            typeResolver: typeResolver,
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
        let didWork: () -> Void

        init(
            options: Options,
            typeSystem: TypeSystem,
            typeResolver: ExpressionTypeResolver,
            didWork: @escaping () -> Void
        ) {
            self.options = options
            self.typeSystem = typeSystem
            self.typeResolver = typeResolver
            self.didWork = didWork

            super.init()
        }

        override func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) -> Statement {
            for (i, decl) in stmt.decl.enumerated() {
                guard decl.type == options.baseType else {
                    continue
                }
                guard let initialization = decl.initialization else {
                    continue
                }

                let resolved = typeResolver.resolveType(initialization)
                guard !resolved.isErrorTyped, let resolvedType = resolved.resolvedType else {
                    continue
                }

                func assign(exp: Expression, type: SwiftType) {
                    if stmt.decl[i].type == type {
                        return
                    }

                    stmt.decl[i].initialization = exp.typed(type).typed(expected: type)
                    stmt.decl[i].type = type

                    didWork()
                }

                if typeSystem.isNumeric(resolvedType) {
                    assign(exp: resolved, type: options.baseNumericType ?? resolvedType)
                } else if resolvedType == .string {
                    assign(exp: resolved, type: options.baseStringType ?? resolvedType)
                } else {
                    if decl.ownership == .weak && typeSystem.isClassInstanceType(resolvedType) {
                        assign(exp: resolved, type: .optional(resolvedType))
                    } else {
                        assign(exp: resolved, type: resolvedType)
                    }
                }

                // Quit early so type changes can be propagated before attempting
                // the next definition in this declaration
                return stmt
            }

            return stmt
        }
    }
}
