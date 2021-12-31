import SwiftAST
import Intentions
import TypeSystem

public class ReachingDefinitionAnalyzer {
    let controlFlowGraph: ControlFlowGraph
    let container: StatementContainer
    let intention: FunctionBodyCarryingIntention?
    let typeSystem: TypeSystem
    private var inreaching: [ControlFlowGraphNode: Set<Definition>] = [:]
    private var outreaching: [ControlFlowGraphNode: Set<Definition>] = [:]
    
    private var didCalculate = false
    
    public init(
        controlFlowGraph: ControlFlowGraph,
        container: StatementContainer,
        intention: FunctionBodyCarryingIntention?,
        typeSystem: TypeSystem
    ) {
        
        self.controlFlowGraph = controlFlowGraph
        self.container = container
        self.intention = intention
        self.typeSystem = typeSystem
    }
    
    public func reachingDefinitions(for node: ControlFlowGraphNode) -> Set<Definition> {
        calculateIfNotReady()
        
        return inreaching[node] ?? []
    }
    
    private func calculateIfNotReady() {
        if !didCalculate {
            calculate()
            didCalculate = true
        }
    }
    
    private func calculate() {
        var inreaching: [ControlFlowGraphNode: Set<Definition>] = [:]
        var outreaching: [ControlFlowGraphNode: Set<Definition>] = [:]
        let gen = generated()
        let kill = killed()
        var changed: Set<ControlFlowGraphNode> = Set(controlFlowGraph.nodes)
        
        while !changed.isEmpty {
            let n = changed.removeFirst()
            
            inreaching[n] =
                controlFlowGraph
                    .nodesConnected(towards: n)
                    .compactMap {
                        outreaching[$0]
                    }.reduce(into: []) { $0.formUnion($1) }
            
            let oldOut = outreaching[n]
            
            let killed: Set<Definition> =
                Set(kill[n]!.compactMap { localDef -> Definition? in
                    return inreaching[n]!.first(where: { $0.definition == localDef })
                })
            
            let newOut =
                gen[n]!
                    .union(
                        inreaching[n]!
                            .subtracting(killed)
                    )
            
            outreaching[n] = newOut
            
            if newOut != oldOut {
                changed.formUnion(controlFlowGraph.nodesConnected(from: n))
            }
        }
        
        self.inreaching = inreaching
        self.outreaching = outreaching
    }
    
    private func killed() -> [ControlFlowGraphNode: [LocalCodeDefinition]] {
        var dict: [ControlFlowGraphNode: [LocalCodeDefinition]] = [:]
        
        for node in controlFlowGraph.nodes {
            dict[node] = definitionsKilled(node)
        }
        
        return dict
    }
    
    private func generated() -> [ControlFlowGraphNode: Set<Definition>] {
        var dict: [ControlFlowGraphNode: Set<Definition>] = [:]
        
        for node in controlFlowGraph.nodes {
            dict[node] = definitionsGenerated(node)
        }
        
        return dict
    }
    
    private func definitionsKilled(_ node: ControlFlowGraphNode) -> [LocalCodeDefinition] {
        switch node.node {
        case let stmt as ExpressionsStatement:
            var killed: [LocalCodeDefinition] = []
            
            for exp in stmt.expressions {
                let usages =
                    LocalUsageAnalyzer(typeSystem: typeSystem)
                        .findAllUsages(
                            in: exp,
                            container: container,
                            intention: intention
                        )
                
                let localsKilled =
                    usages.filter { usage in
                        !usage.isReadOnlyUsage
                    }.compactMap { usage in
                        usage.definition as? LocalCodeDefinition
                    }
                
                killed.append(contentsOf: localsKilled)
            }
            
            return killed
            
        default:
            break
        }
        
        return []
    }
    
    private func definitionsGenerated(_ node: ControlFlowGraphNode) -> Set<Definition> {
        switch node.node {
        case let stmt as VariableDeclarationsStatement:
            return Set(
                CodeDefinition
                    .forVarDeclStatement(stmt)
                    .compactMap { def in
                        
                        // Make sure we only record variable declarations that
                        // actually have an initial value
                        switch def.location {
                        case .variableDeclaration(_, let index)
                            where stmt.decl[index].initialization != nil:
                            
                            return Definition(
                                definitionSite: node.node,
                                definition: def
                            )
                        default:
                            return nil
                        }
                    }
                )
            
        case let stmt as ExpressionsStatement:
            var generated: Set<Definition> = []
            
            for exp in stmt.expressions {
                let usages =
                    LocalUsageAnalyzer(typeSystem: typeSystem)
                        .findAllUsages(
                            in: exp,
                            container: container,
                            intention: intention
                        )
                
                let localsGenerated =
                    usages.filter { usage in
                        !usage.isReadOnlyUsage
                    }.compactMap { usage in
                        usage.definition as? LocalCodeDefinition
                    }.map {
                        Definition(definitionSite: exp, definition: $0)
                    }
                
                generated.formUnion(localsGenerated)
            }
            
            return generated
            
        case let stmt as IfStatement:
            guard let pattern = stmt.pattern else {
                break
            }
            
            switch pattern {
            case .identifier(let ident):
                return [
                    Definition(
                        definitionSite: node.node,
                        definition: .forLocalIdentifier(
                            ident,
                            type: stmt.exp.resolvedType ?? .errorType,
                            isConstant: true,
                            location: .ifLet(stmt, .`self`)
                        )
                    )
                ]
            
            default:
                break
            }
            
        case let stmt as ForStatement:
            switch stmt.pattern {
            case .identifier(let ident):
                return [
                    Definition(
                        definitionSite: node.node,
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
    
    public struct Definition: Hashable {
        var definitionSite: SyntaxNode
        var definition: LocalCodeDefinition
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(definitionSite))
            hasher.combine(definition)
        }
        
        public static func == (lhs: Definition, rhs: Definition) -> Bool {
            lhs.definitionSite === rhs.definitionSite && lhs.definition == rhs.definition
        }
    }
}
