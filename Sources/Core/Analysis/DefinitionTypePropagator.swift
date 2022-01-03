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
        var current: CompoundStatement = statement
        var didWork: Bool

        repeat {
            let resolved = typeResolver.resolveTypes(in: current)
            if let resolved = resolved.asCompound {
                current = resolved
            } else {
                current = .compound([resolved])
            }

            didWork = false
            current = propagateDeclarations(current) { didWork = true }
        } while didWork

        return current
    }

    private func propagateDeclarations(_ compoundStatement: CompoundStatement, didWork: () -> Void) -> CompoundStatement {
        for (i, stmt) in compoundStatement.statements.enumerated() {
            switch stmt {
            case let stmt as VariableDeclarationsStatement:
                compoundStatement.statements[i] = propagateInDeclaration(stmt, didWork: didWork)
            default:
                break
            }
        }

        return compoundStatement
    }

    private func propagateInDeclaration(_ stmt: VariableDeclarationsStatement, didWork: () -> Void) -> VariableDeclarationsStatement {
        for (i, decl) in stmt.decl.enumerated() {
            guard decl.type == options.baseType else {
                continue
            }
            guard let initialization = decl.initialization else {
                continue
            }

            let resolved = typeResolver.resolveType(initialization)
            guard let resolvedType = resolved.resolvedType else {
                continue
            }

            if typeSystem.isNumeric(resolvedType) && decl.type != resolvedType && decl.type != options.baseNumericType {
                stmt.decl[i].type = options.baseNumericType ?? resolvedType
                stmt.decl[i].initialization = resolved

                didWork()
            } else if resolvedType == .string && decl.type != resolvedType && decl.type != options.baseStringType {
                stmt.decl[i].type = options.baseStringType ?? resolvedType
                stmt.decl[i].initialization = resolved

                didWork()
            } else {
                if decl.ownership == .weak && typeSystem.isClassInstanceType(resolvedType) {
                    stmt.decl[i].type = .optional(resolvedType)
                } else {
                    stmt.decl[i].type = resolvedType
                }
            }
        }

        return stmt
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
}
