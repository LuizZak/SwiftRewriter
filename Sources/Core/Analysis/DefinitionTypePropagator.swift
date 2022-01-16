import SwiftAST
import Intentions
import TypeSystem

/// Performs analysis on operations performed on values and suggests types for
/// definitions.
public class DefinitionTypePropagator {
    let options: Options
    let typeSystem: TypeSystem
    let typeResolver: LocalTypeResolverInvoker

    public init(
        options: Options,
        typeSystem: TypeSystem,
        typeResolver: LocalTypeResolverInvoker
    ) {

        self.options = options
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
    }

    /// Returns a list of Swift types, on for each parameter, deduced from the
    /// control flow of the given function.
    ///
    /// Parameters with unknown or ambiguous types are set to `nil`.
    public func computeParameterTypes(
        in functionIntention: ParameterizedFunctionIntention
    ) -> [SwiftType?] {

        var result: [SwiftType?] = functionIntention.parameters.map { _ in nil }

        guard let body = functionIntention.functionBody else {
            return result
        }

        body.body = toCompound(propagate(body.body))
        body.body = toCompound(typeResolver.resolveTypes(in: body.body, force: true))

        let graph = makeCFG(for: body.body)
        let analyzer = makeReachingDefinitionAnalyzer(
            graph,
            container: .function(body)
        )
        let allDefinitions =
            analyzer
            .allDefinitions()
            .filter {
                switch $0.definition.location {
                case .parameter(_):
                    return true
                default:
                    return false
                }
            }
        
        let grouped = allDefinitions.groupBy {
            $0.definition
        }

        for (localDef, definitions) in grouped {
            guard let types = computePossibleTypes(analyzer, definitions, in: graph) else {
                continue
            }
            guard types.count == 1 else {
                continue
            }

            let type = types[0]
            guard localDef.type != type, type != .errorType else {
                continue
            }

            switch localDef.location {
            case .parameter(let index):
                result[index] = type
            default:
                break
            }
        }

        return result
    }

    public func propagate(in intention: FunctionBodyCarryingIntention) {
        guard let container = intention.statementContainer else {
            return
        }

        _ = propagate(in: container)
    }

    public func propagate(in container: StatementContainer) -> StatementContainer {
        switch container {
        case .function(let body):
            propagate(body)
            return container

        case .statement(let stmt):
            return .statement(propagate(stmt))

        case .expression(let exp):
            return .expression(propagate(exp))
        }
    }

    public func propagate(_ body: FunctionBodyIntention) {
        var didModify: Bool

        repeat {
            didModify = false

            body.body = toCompound(propagate(body.body))
            body.body = toCompound(typeResolver.resolveTypes(in: body.body, force: true))

            let graph = makeCFG(for: body.body)
            let analyzer = makeReachingDefinitionAnalyzer(
                graph,
                container: .function(body)
            )
            let allDefinitions = analyzer.allDefinitions()
            let grouped = allDefinitions.groupBy {
                $0.definition
            }

            for (localDef, definitions) in grouped {
                guard let types = computePossibleTypes(analyzer, definitions, in: graph) else {
                    continue
                }
                guard types.count == 1, localDef.location.canModify else {
                    continue
                }

                var type = types[0]
                // Perform weak ownership changes
                if localDef.ownership == .weak && typeSystem.isClassInstanceType(type) {
                    type = .optional(type)
                }

                if localDef.type != type, type != .errorType {
                    
                    localDef.location.modifyType(type)
                    didModify = true
                    continue
                }
            }
            
        } while didModify
    }

    public func propagate(_ statement: Statement) -> Statement {
        var current: Statement = statement

        repeatPropagation {
            current = typeResolver.resolveTypes(in: current, force: true)
            current = $0.visitStatement(current)
        }

        return current
    }

    public func propagate(_ expression: Expression) -> Expression {
        var current: Expression = expression

        repeatPropagation {
            current = typeResolver.resolveType(current, force: true)
            current = $0.visitExpression(current)
        }

        return current
    }

    private func repeatPropagation(_ block: (VariableDeclarationTypePropagationRewriter) -> Void) {
        var didWork: Bool = false

        let propagator = makeVariableDeclarationPropagator {
            didWork = true
        }

        repeat {
            didWork = false
            
            block(propagator)
        } while didWork
    }

    private func computePossibleTypes(
        _ analyzer: ReachingDefinitionAnalyzer,
        _ definitions: Set<ReachingDefinitionAnalyzer.Definition>,
        in graph: ControlFlowGraph
    ) -> [SwiftType]? {
        
        var types: [SwiftType] = []
        for reachingDef in definitions {
            if let type = typeForDefinition(reachingDef) {
                types.append(type)
            }
        }

        // Attempt to reduce types by checking possible coercions

        // Perform special treatment for numeric literals
        if types.allSatisfy(typeSystem.isNumeric), let baseNumericType = options.baseNumericType {
            if checkCanCoerce(definitions, to: baseNumericType) {
                return [baseNumericType]
            }
        }

        types = types.filter {
            checkCanCoerce(definitions, to: $0)
        }

        return types
    }

    private func checkCanCoerce<S: Sequence>(
        _ definitions: S,
        to type: SwiftType
    ) -> Bool where S.Element == ReachingDefinitionAnalyzer.Definition {
        
        definitions.allSatisfy { checkCanCoerce(definition: $0, to: type) }
    }

    private func checkCanCoerce(
        definition: ReachingDefinitionAnalyzer.Definition,
        to type: SwiftType
    ) -> Bool {

        let verifier = makeCoercionVerifier()
        
        switch definition.context {
        case .assignment(let exp):
            if verifier.canCoerce(exp.rhs, toType: type) {
                return true
            }

        case .initialValue(let exp):
            if verifier.canCoerce(exp, toType: type) {
                return true
            }

        case .ifLetBinding(let stmt):
            if verifier.canCoerce(stmt.exp, toType: type) {
                return true
            }
        
        case .forBinding(let stmt):
            if verifier.canCoerce(stmt.exp, toType: type) {
                return true
            }
        
        case .catchBlock:
            return type == .swiftError

        case nil:
            return false
        }

        return false
    }

    private func makeCoercionVerifier() -> CoercionVerifier {
        CoercionVerifier(typeSystem: typeSystem)
    }

    private func makeCFG(for statement: CompoundStatement) -> ControlFlowGraph {
        .forCompoundStatement(
            statement,
            options: .init(
                generateEndScopes: true,
                pruneUnreachable: true
            )
        )
    }

    private func makeCFG(for expression: Expression) -> ControlFlowGraph {
        .forExpression(
            expression,
            options: .init(
                generateEndScopes: true,
                pruneUnreachable: true
            )
        )
    }

    private func makeReachingDefinitionAnalyzer(
        _ graph: ControlFlowGraph,
        container: StatementContainer
    ) -> ReachingDefinitionAnalyzer {

        return ReachingDefinitionAnalyzer(
            controlFlowGraph: graph,
            container: container,
            typeSystem: typeSystem
        )
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

    // MARK: - Utilities

    private func toCompound<S: Statement>(_ stmt: S) -> CompoundStatement {
        if let stmt = stmt.asCompound {
            return stmt
        }

        return .compound([stmt])
    }

    private func typeForDefinition(_ definition: ReachingDefinitionAnalyzer.Definition) -> SwiftType? {

        switch definition.context {
        case .assignment(let exp):
            return exp.rhs.resolvedType
        case .initialValue(let exp):
            return exp.resolvedType
        case .ifLetBinding, .forBinding, .catchBlock:
            return definition.definition.type
        case nil:
            return nil
        }
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
        let typeResolver: LocalTypeResolverInvoker
        let localUsageAnalyzer: LocalUsageAnalyzer
        let didWork: () -> Void

        init(
            options: Options,
            typeSystem: TypeSystem,
            typeResolver: LocalTypeResolverInvoker,
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

                guard let firstAssignment = self.firstAssignment(for: decl) else {
                    continue
                }

                let resolved = typeResolver.resolveType(firstAssignment, force: true)
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
            for decl: StatementVariableDeclaration
        ) -> Expression? {

            if let initialization = decl.initialization {
                return initialization
            }

            guard let scope = decl.nearestScope as? Statement else {
                return nil
            }
            
            let definition: LocalCodeDefinition = .forVarDeclElement(decl)
            let usages = localUsageAnalyzer.findUsagesOf(
                definition: definition,
                in: .statement(scope),
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
