import SwiftAST
import Intentions
import TypeSystem

/// Performs analysis on operations performed on values and suggests types for
/// definitions.
public class DefinitionTypePropagator {
    let cache: DefinitionTypeCache
    let options: Options
    let typeSystem: TypeSystem
    let typeResolver: LocalTypeResolverInvoker

    /// Delegate to be invoked during type resolution to allow for external
    /// type suggestions according to definition usages.
    public weak var delegate: DefinitionTypePropagatorDelegate?

    public init(
        cache: DefinitionTypeCache,
        options: Options,
        typeSystem: TypeSystem,
        typeResolver: LocalTypeResolverInvoker
    ) {

        self.cache = cache
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

        // TODO: Reduce duplication with propagate(_ functionBody: FunctionBodyIntention)
        // TODO: bellow

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
        let allDefinitions = analyzer.allDefinitions()
        
        let groupedDefinitions = allDefinitions.groupBy {
            $0.definition
        }

        let localAnalyzer = makeLocalUsageAnalyzer()
        let allUsages = localAnalyzer.findAllUsages(in: body.body, intention: nil)
        let groupedUsages = allUsages.groupBy {
            $0.definition as? LocalCodeDefinition
        }

        let definitionsToCheck =
            groupedDefinitions.keys
            + groupedUsages.keys.compactMap({ $0 })

        for localDef in definitionsToCheck {
            guard localDef.type == options.baseType else {
                continue
            }
            guard case .parameter(let index) = localDef.location else {
                continue
            }

            let usages = groupedUsages[localDef] ?? []
            let definitions = groupedDefinitions[localDef] ?? []

            guard usages.count > 0 || definitions.count > 0 else {
                continue
            }

            guard let types = computePossibleTypes(localDef, analyzer, definitions, usages, in: graph) else {
                continue
            }
            guard types.count == 1 else {
                continue
            }

            let type = types[0]
            guard localDef.type != type, type != .errorType, !cache[localDef].contains(type) else {
                continue
            }

            cache[localDef].append(type)
            result[index] = type
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

            //body.body = toCompound(propagate(body.body))
            body.body = toCompound(typeResolver.resolveTypes(in: body.body, force: true))

            let graph = makeCFG(for: body.body)
            let analyzer = makeReachingDefinitionAnalyzer(
                graph,
                container: .function(body)
            )
            let allDefinitions = analyzer.allDefinitions()
            let groupedDefinitions = allDefinitions.groupBy {
                $0.definition
            }

            let localAnalyzer = makeLocalUsageAnalyzer()
            let allUsages = localAnalyzer.findAllUsages(in: body.body, intention: nil)
            let groupedUsages = allUsages.groupBy {
               $0.definition as? LocalCodeDefinition
            }

            let definitionsToCheck =
                groupedDefinitions.keys
                + groupedUsages.keys.compactMap({ $0 })

            for localDef in definitionsToCheck {
                guard localDef.type == options.baseType else {
                    continue
                }

                let usages = groupedUsages[localDef] ?? []
                let definitions = groupedDefinitions[localDef] ?? []

                guard usages.count > 0 || definitions.count > 0 else {
                    continue
                }

                guard let types = computePossibleTypes(localDef, analyzer, definitions, usages, in: graph) else {
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

                if localDef.type != type, type != .errorType, !cache[localDef].contains(type) {
                    cache[localDef].append(type)
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
        _ definition: LocalCodeDefinition,
        _ analyzer: ReachingDefinitionAnalyzer,
        _ definitions: Set<ReachingDefinitionAnalyzer.Definition>,
        _ usages: [DefinitionUsage],
        in graph: ControlFlowGraph
    ) -> [SwiftType]? {
        
        var types: [SwiftType] = []
        var typesFromDelegate: DefinitionTypePropagator.TypeSuggestion = .none
        
        // Query delegate
        if let delegate = delegate {
            let contexts = usages.compactMap(usageContext(for:))
            
            typesFromDelegate = delegate.suggestTypeForDefinitionUsages(
                self,
                definition: definition,
                usages: contexts
            )
            
            if case .certain(let type) = typesFromDelegate {
                return [type]
            }
        }

        let mutatingDefinitions = definitions.filter {
            isDirectlyMutatingDefinition($0)
        }

        for reachingDef in mutatingDefinitions {
            if let type = typeForDefinition(reachingDef) {
                types.append(type)
            }
        }

        // Attempt to reduce types by checking possible coercions

        // Perform special treatment for numeric literals
        if !types.isEmpty && types.allSatisfy(typeSystem.isNumeric), let baseNumericType = options.baseNumericType {
            if checkCanCoerce(mutatingDefinitions, to: baseNumericType) {
                let result = [baseNumericType]

                switch typesFromDelegate {
                case .none, .oneOfPossibly, .certain:
                    return result

                case .oneOfCertain(let subset):
                    return Array(Set(subset).intersection(result))
                }
            }
        }

        types = types.filter {
            checkCanCoerce(mutatingDefinitions, to: $0)
        }

        switch typesFromDelegate {
        case .none, .certain:
            return types
        
        case .oneOfPossibly(let suggested):
            if types.isEmpty {
                return suggested
            }

            return types
            
        case .oneOfCertain(let subset):
            return Array(Set(subset).intersection(types))
        }
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

    private func usageContext(for usage: DefinitionUsage) -> UsageContext? {
        guard case .identifier(let exp) = usage.expression else {
            return nil
        }
        guard let postfixExp = exp.parentExpression?.asPostfix else {
            return nil
        }

        switch postfixExp.op {
        case let op as MemberPostfix:
            // Detect member accesses that are immediately called as a function
            if
            let nextPostfix = postfixExp.parentExpression?.asPostfix,
            let functionCall = nextPostfix.op.asFunctionCall,
            nextPostfix.exp == postfixExp {
                return .memberFunctionCall(exp, op, functionCall, in: nextPostfix)
            }
            
            return .memberAccess(exp, op, in: postfixExp)
        
        case let op as SubscriptPostfix:
            return .subscriptAccess(exp, op, in: postfixExp)
        
        case let op as FunctionCallPostfix:
            return .functionCall(exp, op, in: postfixExp)

        default:
            return nil
        }
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

        ReachingDefinitionAnalyzer(
            controlFlowGraph: graph,
            container: container,
            typeSystem: typeSystem
        )
    }

    private func makeLocalUsageAnalyzer() -> LocalUsageAnalyzer {
        LocalUsageAnalyzer(typeSystem: typeSystem)
    }

    private func makeVariableDeclarationPropagator(_ didWork: @escaping () -> Void) -> VariableDeclarationTypePropagationRewriter {
        let localUsageAnalyzer = LocalUsageAnalyzer(typeSystem: typeSystem)

        return VariableDeclarationTypePropagationRewriter(
            cache: cache,
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
            if !isDirectlyMutatingDefinition(definition) {
                return nil
            }

            return exp.rhs.resolvedType
            
        case .initialValue(let exp):
            return exp.resolvedType

        case .ifLetBinding, .forBinding, .catchBlock:
            return definition.definition.type

        case nil:
            return nil
        }
    }

    /// Returns `true` if a given definition mutates the underlying code definition
    /// directly, instead of a member within the definition.
    private func isDirectlyMutatingDefinition(_ definition: ReachingDefinitionAnalyzer.Definition) -> Bool {
        switch definition.context {
        case .assignment(let exp):
            guard let defNode = exp.lhs as? DefinitionReferenceNode else {
                return false
            }
            guard defNode.definition as? LocalCodeDefinition == definition.definition else {
                return false
            }

            return true
            
        case .initialValue:
            return true

        case .ifLetBinding, .forBinding, .catchBlock:
            return false

        case nil:
            return false
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

    /// Provides `DefinitionTypeCache` on a per-function basis.
    public class PerIntentionTypeCache {
        private var _cache: [FunctionBodyCarryingIntention: DefinitionTypeCache] = [:]

        public init() {

        }

        public func cache(for intention: FunctionBodyCarryingIntention) -> DefinitionTypeCache {
            if let existing = _cache[intention] {
                return existing
            }

            let cache = DefinitionTypeCache()
            _cache[intention] = cache
            
            return cache
        }
    }

    /// State that can be passed around different type propagators to enable
    /// infinite loop detection.
    public class DefinitionTypeCache {
        var cache: [LocalCodeDefinition: [SwiftType]] = [:]

        subscript(definition: LocalCodeDefinition) -> [SwiftType] {
            get {
                cache[definition, default: []]
            }
            set {
                cache[definition] = newValue
            }
        }
    }

    /// Defines the context for an unknown member access of a definition.
    ///
    /// The expression that resolves to the definition's type is stored as the
    /// first value of each enumeration case.
    public enum UsageContext: Equatable {
        /// Definition has a member access that resolves to an unknown member.
        case memberAccess(Expression, MemberPostfix, in: PostfixExpression)

        /// Definition has a function call to the definition.
        case functionCall(Expression, FunctionCallPostfix, in: PostfixExpression)

        /// Definition has a function call to an unknown member access.
        ///
        /// The associated `PostfixExpression` associated is the postfix for the
        /// function call postfix access.
        case memberFunctionCall(Expression, MemberPostfix, FunctionCallPostfix, in: PostfixExpression)

        /// Definition has a subscription to an unknown subscript member.
        case subscriptAccess(Expression, SubscriptPostfix, in: PostfixExpression)
    }

    /// Defines the result of a type suggestion by a `DefinitionTypePropagatorDelegate`.
    public enum TypeSuggestion {
        /// Specifies no suggestion.
        case none

        /// States that the type for the definition be set as a given type.
        case certain(SwiftType)

        /// States that the definition is of one of the given types, and no more.
        ///
        /// The type propagator uses the information to trim down the possible
        /// type of a definition.
        ///
        /// Note: Returning an empty array implies the definition has no proper
        /// type.
        case oneOfCertain([SwiftType])

        /// States that the definition is possibly of one of the given types.
        ///
        /// The type propagator takes the types and appends them to its internal
        /// type deduction phase.
        case oneOfPossibly([SwiftType])
    }
}

public protocol DefinitionTypePropagatorDelegate: AnyObject {
    /// Requests type suggestions from the delegate for a given definition, used
    /// in a given set of contexts.
    ///
    /// The resulting type suggestion is used internally by `DefinitionTypePropagator`
    /// during analysis of a syntax tree.
    func suggestTypeForDefinitionUsages(
        _ typePropagator: DefinitionTypePropagator,
        definition: LocalCodeDefinition,
        usages: [DefinitionTypePropagator.UsageContext]
    ) -> DefinitionTypePropagator.TypeSuggestion
}

private extension DefinitionTypePropagator {
    private class VariableDeclarationTypePropagationRewriter: SyntaxNodeRewriter {
        let cache: DefinitionTypeCache
        let options: Options
        let typeSystem: TypeSystem
        let typeResolver: LocalTypeResolverInvoker
        let localUsageAnalyzer: LocalUsageAnalyzer
        let didWork: () -> Void

        init(
            cache: DefinitionTypeCache,
            options: Options,
            typeSystem: TypeSystem,
            typeResolver: LocalTypeResolverInvoker,
            localUsageAnalyzer: LocalUsageAnalyzer,
            didWork: @escaping () -> Void
        ) {
            self.cache = cache
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

                    // Avoid cycles
                    let def = LocalCodeDefinition.forVarDeclElement(decl)
                    if cache[def].contains(type) {
                        return
                    }

                    cache[def].append(type)

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

            let expression = first.expression.expression

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
