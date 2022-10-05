import Foundation

/// Class for generating Graphviz visualizations of undirected or directed graphs.
public class GraphViz {
    public typealias NodeId = Int

    private var _nextId: Int = 1
    private var _rootGroup: Group

    /// The name for the root graph/digraph.
    /// If `nil`, no name is given to the root graph.
    public var rootGraphName: String?

    /// Rank direction for this graph.
    public var rankDir: RankDir = .leftToRight

    public init(rootGraphName: String? = nil) {
        self.rootGraphName = rootGraphName

        _rootGroup = Group(title: nil, isCluster: false)
    }

    private static func _defaultGraphAttributes() -> Attributes {
        return [
            "rankdir": .raw(RankDir.topToBottom.rawValue)
        ]
    }

    private func _graphAttributes() -> Attributes {
        return [
            "rankdir": .raw(rankDir.rawValue)
        ]
    }

    /// Generates a .dot file for visualization.
    public func generateFile(options: Options = .default) -> String {
        let simplified =
            options.simplifyGroups ? _rootGroup.simplify() : _rootGroup

        let out = StringOutput()

        var graphLabel = "digraph"
        if let rootGraphName {
            graphLabel += " \(rootGraphName)"
        }

        out(beginBlock: graphLabel) {
            let spacer = out.spacerToken(disabled: true)

            let attr =
                _graphAttributes()
                    .toDotFileString(
                        defaultValues: Self._defaultGraphAttributes()
                    )
            
            if !attr.isEmpty {
                out(line: "graph \(attr)")

                spacer.reset()
            }

            var clusterCounter = 0
            simplified.generateGraph(
                in: out,
                options: options,
                spacer: spacer,
                clusterCounter: &clusterCounter
            )
        }

        return out.buffer.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Returns the first node ID whose label matches the given textual label.
    public func nodeId(forLabel label: String) -> NodeId? {
        _rootGroup.findNodeId(label: label)
    }

    /// Creates a new node with a given label, nested within a given set of groups.
    @discardableResult
    public func createNode(label: String, groups: [String] = []) -> NodeId {
        defer { _nextId += 1 }

        let id = _nextId

        var node = Node(id: id)
        node.label = label
        
        _rootGroup.getOrCreateGroup(groups).addNode(node)

        return node.id
    }

    /// Returns the first node ID whose label matches the given textual label,
    /// or generates as new node ID with the given label, in case it does not exist.
    public func getOrCreate(label: String) -> NodeId {
        if let id = nodeId(forLabel: label) {
            return id
        }

        let id = createNode(label: label)

        return id
    }

    /// Adds a connection between two nodes whose labels match the given labels.
    /// If nodes with the given labels do not exist, they are created first on
    /// the root group.
    public func addConnection(
        fromLabel: String,
        toLabel: String,
        label: String? = nil,
        color: String? = nil
    ) {

        let from = getOrCreate(label: fromLabel)
        let to = getOrCreate(label: toLabel)

        addConnection(from: from, to: to, label: label, color: color)
    }

    /// Adds a connection between two node IDs.
    public func addConnection(
        from: NodeId,
        to: NodeId,
        label: String? = nil,
        color: String? = nil
    ) {

        var connection = Connection(
            idFrom: from,
            idTo: to
        )
        
        connection.label = label
        connection.color = color

        _rootGroup.addConnection(connection)
    }

    /// Adds a connection between two node IDs.
    public func addConnection(
        from: NodeId,
        to: NodeId,
        attributes: Attributes
    ) {
        
        let connection = Connection(
            idFrom: from,
            idTo: to,
            attributes: attributes
        )

        _rootGroup.addConnection(connection)
    }

    private struct Node: Comparable {
        var id: NodeId
        var attributes: Attributes = Attributes()

        var label: String {
            get {
                attributes["label"]?.rawValue ?? ""
            }
            set {
                attributes["label"] = .string(newValue)
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.label < rhs.label
        }
    }

    private struct Connection: Comparable {
        var idFrom: NodeId
        var idTo: NodeId
        var attributes: Attributes = Attributes()

        var label: String? {
            get {
                attributes["label"]?.rawValue
            }
            set {
                if let label = newValue {
                    attributes["label"] = .string(label)
                } else {
                    attributes.removeValue(forKey: "label")
                }
            }
        }

        var color: String? {
            get {
                attributes["color"]?.rawValue
            }
            set {
                if let label = newValue {
                    attributes["color"] = .string(label)
                } else {
                    attributes.removeValue(forKey: "color")
                }
            }
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            guard lhs.idTo == rhs.idTo else {
                return lhs.idTo < rhs.idTo
            }
            guard lhs.idFrom == rhs.idFrom else {
                return lhs.idFrom < rhs.idFrom
            }
            
            switch (lhs.label, rhs.label) {
            case (nil, nil):
                return false
            case (let a?, let b?):
                return a < b
            case (_?, _):
                return true
            case (_, _?):
                return false
            }
        }
    }

    /// A group of node definitions.
    private class Group {
        /// The string title for this group.
        var title: String?

        /// Whether this group is a cluster: A subgraph within a root graph.
        var isCluster: Bool

        /// List of subgroups within this group.
        var subgroups: [Group] = []

        /// List of nodes contained within this group.
        var nodes: [Node] = []

        /// List of connections contained within this group.
        var connections: [Connection] = []

        var isSingleGroup: Bool {
            subgroups.count == 1 && nodes.isEmpty && connections.isEmpty
        }
        var isSingleNode: Bool {
            subgroups.isEmpty && nodes.count == 1 && connections.isEmpty
        }

        weak var supergroup: Group?

        init(title: String?, isCluster: Bool) {
            self.title = title
            self.isCluster = isCluster
        }

        /// Recursively simplifies this group's hierarchy, returning the root of
        /// the new simplified hierarchy.
        func simplify() -> Group {
            if isSingleGroup {
                let group = subgroups[0].simplify()
                switch (title, group.title) {
                case (let t1?, let t2?):
                    group.title = "\(t1)/\(t2)"
                case (let t1?, nil):
                    group.title = t1
                default:
                    break
                }

                return group
            }

            let group = Group(title: title, isCluster: isCluster)
            group.nodes = nodes
            group.connections = connections

            for subgroup in subgroups {
                let newSubgroup = subgroup.simplify()

                if newSubgroup.isSingleNode {
                    group.nodes.append(newSubgroup.nodes[0])
                } else {
                    group.addSubgroup(newSubgroup)
                }
            }

            return group
        }

        func generateGraph(
            in out: StringOutput,
            options: Options,
            spacer: SpacerToken? = nil,
            clusterCounter: inout Int
        ) {

            // If this group contains only a single subgroup, forward printing
            // to that group transparently, instead.
            if options.simplifyGroups && isSingleGroup {
                subgroups[0].generateGraph(
                    in: out,
                    options: options,
                    spacer: spacer,
                    clusterCounter: &clusterCounter
                )

                return
            }

            let spacer = spacer ?? out.spacerToken()

            if let title = title {
                spacer.apply()

                out(line: #"label = "\#(title)""#)

                spacer.reset()
            }

            if !nodes.isEmpty {
                spacer.apply()

                for node in nodes {
                    let properties = node.attributes.toDotFileString()
                    let nodeString = dotFileNodeId(for: node.id)

                    if !properties.isEmpty {
                        out(line: nodeString + " \(properties)")
                    } else {
                        out(line: nodeString)
                    }
                }

                spacer.reset()
            }

            if !subgroups.isEmpty {
                // Populate subgroups
                for group in subgroups {
                    spacer.apply()

                    let name: String
                    if group.isCluster {
                        clusterCounter += 1
                        name = "cluster_\(clusterCounter)"
                    } else {
                        name = ""
                    }

                    out(beginBlock: "subgraph \(name)") {
                        group.generateGraph(
                            in: out,
                            options: options,
                            spacer: out.spacerToken(disabled: true),
                            clusterCounter: &clusterCounter
                        )
                    }

                    spacer.reset()
                }
            }

            if !connections.isEmpty {
                spacer.apply()

                for connection in connections.sorted() {
                    let conString =
                        "\(dotFileNodeId(for: connection.idFrom)) -> \(dotFileNodeId(for: connection.idTo))"
                    
                    let properties = connection.attributes.toDotFileString()

                    if !properties.isEmpty {
                        out(line: conString + " \(properties)")
                    } else {
                        out(line: conString)
                    }
                }

                spacer.reset()
            }
        }

        /// Returns the textual ID to use when emitting a given node ID on .dot
        /// files.
        func dotFileNodeId(for nodeId: NodeId) -> String {
            "n\(nodeId.description)"
        }

        func findNode(id: NodeId) -> Node? {
            if let node = nodes.first(where: { $0.id == id }) {
                return node
            }

            for group in subgroups {
                if let node = group.findNode(id: id) {
                    return node
                }
            }

            return nil
        }

        func findNodeId(label: String) -> NodeId? {
            if let node = nodes.first(where: { $0.label == label }) {
                return node.id
            }

            for group in subgroups {
                if let id = group.findNodeId(label: label) {
                    return id
                }
            }

            return nil
        }

        func findConnection(from: NodeId, to: NodeId) -> Connection? {
            if let connection = connections.first(where: { $0.idFrom == from && $0.idTo == to }) {
                return connection
            }

            for group in subgroups {
                if let connection = group.findConnection(from: from, to: to) {
                    return connection
                }
            }

            return nil
        }

        func findGroupForNode(id: NodeId) -> Group? {
            if nodes.contains(where: { $0.id == id }) {
                return self
            }

            for group in subgroups {
                if let g = group.findGroupForNode(id: id) {
                    return g
                }
            }

            return nil
        }

        func getOrCreateGroup(_ path: [String]) -> Group {
            if path.isEmpty {
                return self
            }

            let next = path[0]
            let remaining = Array(path.dropFirst())

            for group in subgroups {
                if group.title == next {
                    return group.getOrCreateGroup(remaining)
                }
            }

            let group = Group(title: next, isCluster: true)
            addSubgroup(group)
            return group.getOrCreateGroup(remaining)
        }
        
        func addSubgroup(_ group: Group) {
            group.supergroup = self
            subgroups.append(group)
        }

        func addNode(_ node: Node) {
            nodes.append(node)
        }

        func addConnection(_ connection: Connection) {
            let target: Group

            let g1 = findGroupForNode(id: connection.idFrom)
            let g2 = findGroupForNode(id: connection.idTo)

            if let g1 = g1, let g2 = g2, let ancestor = Self.firstCommonAncestor(between: g1, g2) {
                target = ancestor
            } else {
                target = self
            }

            target.connections.append(connection)
        }

        func isDescendant(of view: Group) -> Bool {
            var parent: Group? = self
            while let p = parent {
                if p === view {
                    return true
                }
                parent = p.supergroup
            }

            return false
        }

        static func firstCommonAncestor(between group1: Group, _ group2: Group) -> Group? {
            if group1 === group2 {
                return group1
            }

            var parent: Group? = group1
            while let p = parent {
                if group2.isDescendant(of: p) {
                    return p
                }

                parent = p.supergroup
            }

            return nil
        }
    }

    /// Options for graph generation
    public struct Options {
        /// Default generation options
        public static let `default`: Self = Self()

        /// Whether to simplify groups before emitting the final graph file.
        /// Simplification collapses subgraphs that only contain subgraphs with
        /// no nodes/connections.
        public var simplifyGroups: Bool

        public init(
            simplifyGroups: Bool = true
        ) {
            self.simplifyGroups = simplifyGroups
        }
    }

    fileprivate class SpacerToken {
        var out: StringOutput
        var didApply: Bool

        init(out: StringOutput, didApply: Bool = false) {
            self.out = out
            self.didApply = didApply
        }

        func apply() {
            guard !didApply else { return }
            didApply = true

            out()
        }

        func reset() {
            didApply = false
        }
    }
}

/// Outputs to a string buffer
private final class StringOutput {
    var indentDepth: Int = 0
    var ignoreCallChange = false
    private(set) public var buffer: String = ""
    
    init() {
        
    }

    func spacerToken(disabled: Bool = false) -> GraphViz.SpacerToken {
        .init(out: self, didApply: disabled)
    }

    func callAsFunction() {
        output(line: "")
    }

    func callAsFunction(line: String) {
        output(line: line)
    }

    func callAsFunction(lineAndIndent line: String, _ block: () -> Void) {
        output(line: line)
        indented(perform: block)
    }

    func callAsFunction(beginBlock line: String, _ block: () -> Void) {
        output(line: "\(line) {")
        indented(perform: block)
        output(line: "}")
    }
    
    func outputRaw(_ text: String) {
        buffer += text
    }
    
    func output(line: String) {
        if !line.isEmpty {
            outputIndentation()
            buffer += line
        }
        
        outputLineFeed()
    }
    
    func outputIndentation() {
        buffer += indentString()
    }
    
    func outputLineFeed() {
        buffer += "\n"
    }
    
    func outputInline(_ content: String) {
        buffer += content
    }
    
    func increaseIndentation() {
        indentDepth += 1
    }
    
    func decreaseIndentation() {
        guard indentDepth > 0 else { return }
        
        indentDepth -= 1
    }
    
    func outputInlineWithSpace(_ content: String) {
        outputInline(content)
        outputInline(" ")
    }
    
    func indented(perform block: () -> Void) {
        increaseIndentation()
        block()
        decreaseIndentation()
    }
    
    private func indentString() -> String {
        return String(repeating: " ", count: 4 * indentDepth)
    }
}
