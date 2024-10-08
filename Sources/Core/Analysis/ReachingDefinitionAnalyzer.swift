import SwiftAST
import SwiftCFG
import Intentions
import TypeSystem

public class ReachingDefinitionAnalyzer {
    let controlFlowGraph: ControlFlowGraph
    let container: StatementContainer
    let typeSystem: TypeSystem
    private var inReaching: [ControlFlowGraphNode: Set<Definition>] = [:]
    private var outReaching: [ControlFlowGraphNode: Set<Definition>] = [:]

    private var didCalculate = false

    public init(
        controlFlowGraph: ControlFlowGraph,
        container: StatementContainer,
        typeSystem: TypeSystem
    ) {

        self.controlFlowGraph = controlFlowGraph
        self.container = container
        self.typeSystem = typeSystem
    }

    /// Returns a list of definitions that reach a given CFG graph node.
    public func reachingDefinitions(for node: ControlFlowGraphNode) -> Set<Definition> {
        calculateIfNotReady()

        return inReaching[node] ?? []
    }

    /// Returns all definitions found within the CFG, regardless of usage or
    /// reachability.
    public func allDefinitions() -> Set<Definition> {
        var result: Set<Definition> = []

        for node in controlFlowGraph.nodes {
            result.formUnion(Self.definitionsGenerated(node))
        }

        return result
    }

    private func calculateIfNotReady() {
        if !didCalculate {
            calculate()
            didCalculate = true
        }
    }

    private func calculate() {
        inReaching = [:]
        outReaching = [:]

        let gen = generated()
        let kill = killed()
        var changed: Set<ControlFlowGraphNode> = Set(controlFlowGraph.nodes)

        while !changed.isEmpty {
            let n = changed.removeFirst()

            inReaching[n] = controlFlowGraph
                .nodesConnected(towards: n)
                .compactMap {
                    outReaching[$0]
                }.reduce([]) {
                    $0.union($1)
                }

            let killed: Set<Definition> =
                if let kill = kill[n], let inReaching = inReaching[n] {
                    Set(kill.compactMap { localDef -> Definition? in
                        inReaching.first {
                            $0.definition == localDef
                        }
                    })
                } else {
                    []
                }

            let newOut: Set<Definition> =
                if let gen = gen[n], let inReaching = inReaching[n] {
                    gen.union(inReaching.subtracting(killed))
                } else {
                    []
                }

            let oldOut = outReaching[n]
            outReaching[n] = newOut

            if newOut != oldOut {
                changed.formUnion(controlFlowGraph.nodesConnected(from: n))
            }
        }
    }

    private func killed() -> [ControlFlowGraphNode: [LocalCodeDefinition]] {
        var dict: [ControlFlowGraphNode: [LocalCodeDefinition]] = [:]

        for node in controlFlowGraph.nodes {
            dict[node] = Self.definitionsKilled(node)
        }

        return dict
    }

    private func generated() -> [ControlFlowGraphNode: Set<Definition>] {
        var dict: [ControlFlowGraphNode: Set<Definition>] = [:]

        for node in controlFlowGraph.nodes {
            dict[node] = Self.definitionsGenerated(node)
        }

        return dict
    }

    private static func definitionsKilled(_ node: ControlFlowGraphNode) -> [LocalCodeDefinition] {
        if let endOfScope = node as? ControlFlowGraphEndScopeNode {
            return endOfScope.scope.codeScope.localDefinitions().compactMap { $0 as? LocalCodeDefinition }
        }

        switch node.node {
        case let defNode as DefinitionReferenceNode:
            guard let definition = defNode.definition as? LocalCodeDefinition else {
                break
            }

            if !defNode.isReadOnlyUsage {
                return [definition]
            }

        default:
            break
        }

        return []
    }

    // TODO: Use ExpressionTypeResolver to deduce definitions generated by syntax
    // TODO: nodes

    private static func expandBindingsInPattern(
        _ pattern: Pattern,
        bindingContext: PatternBindingContext
    ) -> [PatternBindingDefinition] {

        switch pattern {
        case .identifier(let ident):
            return [.init(identifier: ident, location: .self)]

        case .tuple(let patterns):
            let result = patterns.flatMap {
                expandBindingsInPattern($0, bindingContext: bindingContext)
            }

            return result.enumerated().map { (i, definition) in
                return definition.with(
                    \.location,
                    value: .tuple(index: i, pattern: definition.location)
                )
            }

        case .valueBindingPattern(let constant, let inner):
            let result = expandBindingsInPattern(
                inner,
                bindingContext: bindingContext
                    .withBinding(constant: constant)
            )

            return result.relocating(PatternLocation.valueBindingPattern)

        case .asType(let pattern, let type):
            // TODO: Handle 'exp as Type' patterns better; rewriting the type for
            // TODO: all definitions is likely the incorrect way to handle it
            let result = expandBindingsInPattern(pattern, bindingContext: bindingContext)

            return result.map { definition in
                if definition.location == .`self` {
                    definition.with(\.type, value: type)
                } else {
                    definition
                }
            }.relocating(PatternLocation.asType)

        case .optional(let inner):
            let result = expandBindingsInPattern(
                inner,
                bindingContext: bindingContext
            )

            return result.relocating(PatternLocation.optional)

        case .expression, .wildcard:
            return []
        }
    }

    private static func definitionsGenerated(_ node: ControlFlowGraphNode) -> Set<Definition> {
        if node is ControlFlowGraphEndScopeNode {
            return []
        }

        switch node.node {
        case let catchBlock as CatchBlock:
            return [
                Definition(
                    node: node,
                    definitionSite: node.node,
                    context: .catchBlock(catchBlock),
                    definition: .forCatchBlockPattern(catchBlock)
                )
            ]

        case let decl as StatementVariableDeclaration:
            let localDef = CodeDefinition.forVarDeclElement(decl)

            // Make sure we only record variable declarations that
            // actually have an initial value
            switch localDef.location {
            case .variableDeclaration(let decl):
                guard let initialization = decl.initialization else {
                    break
                }

                return [
                    Definition(
                        node: node,
                        definitionSite: node.node,
                        context: .initialValue(initialization),
                        definition: localDef
                    )
                ]
            default:
                break
            }

        case let defNode as DefinitionReferenceNode:
            guard let definition = defNode.definition as? LocalCodeDefinition else {
                break
            }
            guard !defNode.isReadOnlyUsage else {
                break
            }

            // TODO: Figure out how to get rid of this context hack to allow
            // TODO: algorithms downstream to make more complex analysis based on
            // TODO: values being assigned to usages.

            var context: Definition.Context? = nil
            if let assignment = defNode.firstAncestor(ofType: AssignmentExpression.self) {
                if defNode.isDescendent(of: assignment.lhs) {
                    context = .assignment(assignment)
                }
            }

            return [
                Definition(
                    node: node,
                    definitionSite: defNode,
                    context: context,
                    definition: definition
                )
            ]

        case let clause as ConditionalClauseElement:
            guard let pattern = clause.pattern else {
                break
            }

            let bindings = expandBindingsInPattern(
                pattern,
                bindingContext: .conditionalClauseContext
            )

            var result: Set<Definition> = []
            for binding in bindings {
                let definition: Definition

                if binding.location == .valueBindingPattern(pattern: .self) || binding.location == .self {
                    definition = Definition(
                        node: node,
                        definitionSite: node.node,
                        context: .conditionalClause(clause),
                        definition: .forLocalIdentifier(
                            binding.identifier,
                            type: clause.expression.resolvedType ?? .errorType,
                            isConstant: true,
                            location: .conditionalClause(clause, binding.location)
                        )
                    )
                } else {
                    definition = Definition(
                        node: node,
                        definitionSite: node.node,
                        context: .conditionalClause(clause),
                        definition: .forLocalIdentifier(
                            binding.identifier,
                            type: binding.type ?? .errorType,
                            isConstant: true,
                            location: .conditionalClause(clause, binding.location)
                        )
                    )
                }

                result.insert(definition)
            }

            return result

        case let stmt as ForStatement:
            switch stmt.pattern {
            case .identifier(let ident):
                return [
                    Definition(
                        node: node,
                        definitionSite: node.node,
                        context: .forBinding(stmt),
                        definition: .forLocalIdentifier(
                            ident,
                            type: stmt.exp.resolvedType ?? .errorType,
                            isConstant: true,
                            location: .forLoop(stmt, .`self`)
                        )
                    )
                ]

            default:
                break
            }

        default:
            break
        }

        return []
    }

    private struct PatternBindingContext {
        static let conditionalClauseContext = PatternBindingContext(isBinding: true, isConstant: true, location: .`self`)
        static let forContext = PatternBindingContext(isBinding: true, isConstant: true, location: .`self`)

        var isBinding: Bool
        var isConstant: Bool
        var location: PatternLocation

        func withBinding(constant: Bool) -> Self {
            var copy = self
            copy.isBinding = true
            copy.isConstant = constant
            return copy
        }
    }

    fileprivate struct PatternBindingDefinition {
        var identifier: String
        var type: SwiftType?
        var location: PatternLocation

        func with<V>(_ keyPath: WritableKeyPath<Self, V>, value: V) -> Self {
            var copy = self
            copy[keyPath: keyPath] = value
            return copy
        }
    }

    public struct Definition: Hashable {
        var node: ControlFlowGraphNode
        var definitionSite: SyntaxNode
        var context: Context?
        var definition: LocalCodeDefinition

        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(definitionSite))
            hasher.combine(definition)
        }

        public static func == (lhs: Definition, rhs: Definition) -> Bool {
            lhs.definitionSite === rhs.definitionSite && lhs.definition == rhs.definition
        }

        /// Describes the context for the value that is being assigned to a
        /// definition.
        public enum Context {
            case assignment(AssignmentExpression)
            case catchBlock(CatchBlock)
            //case ifLetBinding(IfStatement)
            case forBinding(ForStatement)
            //case whileBinding(WhileStatement)
            case conditionalClause(ConditionalClauseElement)
            case initialValue(Expression)
        }
    }
}

private extension Sequence where Element == ReachingDefinitionAnalyzer.PatternBindingDefinition {
    func relocating(_ locator: (PatternLocation) -> PatternLocation) -> [Element] {
        map { $0.with(\.location, value: locator($0.location)) }
    }
}
