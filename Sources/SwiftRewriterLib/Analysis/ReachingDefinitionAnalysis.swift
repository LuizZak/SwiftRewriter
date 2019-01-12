import SwiftAST

public class ReachingDefinitionAnalysis {
    let controlFlowGraph: ControlFlowGraph
    
    public init(controlFlowGraph: ControlFlowGraph) {
        self.controlFlowGraph = controlFlowGraph
    }
    
    private func calculate() {
        var inreaching: [ControlFlowGraphNode: Set<LocalCodeDefinition>] = [:]
        var outreaching: [ControlFlowGraphNode: Set<LocalCodeDefinition>] = [:]
        var gen: [ControlFlowGraphNode: Set<LocalCodeDefinition>] = [:]
        var kill: [ControlFlowGraphNode: Set<LocalCodeDefinition>] = [:]
        var changed: Set<ControlFlowGraphNode> = Set(controlFlowGraph.nodes)
        
        while !changed.isEmpty {
            let n = changed.removeFirst()
            
            inreaching[n] = []
            
            for p in controlFlowGraph.nodesConnected(towards: n) {
                inreaching[n] =
                    inreaching[n, default: []]
                        .union(inreaching[p] ?? [])
            }
            
            let oldOut = outreaching[n] ?? []
            
            let newOut =
                outreaching[n, default: []]
                    .union(
                        inreaching[n, default: []]
                            .subtracting(kill[n] ?? [])
                    )
        }
    }
}
