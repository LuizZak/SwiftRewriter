import SwiftAST
import WriterTargetOutput
import SwiftSyntax
import SwiftSyntaxParser
import XCTest
import Intentions
import KnownType
import TestCommons
import Graphviz

@testable import Analysis

internal func sanitize(
    _ graph: CallGraph,
    expectsUnreachable: Bool = false,
    expectsNonExitEndNodes: Bool = false,
    file: StaticString = #filePath,
    line: UInt = #line
) {

}

internal func assertGraphviz(
    graph: CallGraph,
    matches expected: String,
    syntaxNode: SwiftAST.SyntaxNode? = nil,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    let text = graphviz(graph: graph)

    if text == expected {
        return
    }

    let syntaxString: String?
    switch syntaxNode {
    case let node as Expression:
        syntaxString = ExpressionPrinter.toString(expression: node)

    case let node as Statement:
        syntaxString = StatementPrinter.toString(statement: node)
    
    default:
        syntaxString = nil
    }

    XCTFail(
        """
        \(syntaxString.map{ "\($0)\n\n" } ?? "")Expected produced graph to be

        \(expected)

        But found:

        \(text)

        Diff:

        \(text.makeDifferenceMarkString(against: expected))
        """,
        file: file,
        line: line
    )
}

internal func printGraphviz(graph: CallGraph) {
    let string = graphviz(graph: graph)
    print(string)
}

internal func graphviz(graph: CallGraph) -> String {

    let viz = GraphViz(rootGraphName: "calls")
    viz.rankDir = .topToBottom

    var nodeIds: [ObjectIdentifier: GraphViz.NodeId] = [:]
    var nodeDefinitions: [NodeDefinition<CallGraphNode>] = []
    
    // Prepare nodes
    for node in graph.nodes {
        let label = labelForNode(node, graph: graph)
        
        nodeDefinitions.append(
            .init(
                node: node,
                label: label
            )
        )
    }

    // Sort nodes so the result is more stable
    nodeDefinitions.sort { (n1, n2) -> Bool in
        // If rank data is available, use it to create a more linear list of
        // nodes on the output. Nodes with no rank should be added to the end
        // of the graph, after all ranked nodes.
        switch (n1.rankFromStart, n2.rankFromStart) {
        case (nil, _?):
            return false

        case (_?, nil):
            return true
        
        case (let r1?, let r2?) where r1 < r2:
            return true

        case (let r1?, let r2?) where r1 > r2:
            return false
        
        default:
            break
        }

        switch (n1.rankFromEnd, n2.rankFromEnd) {
        case (nil, _?):
            return true

        case (_?, nil):
            return false
        
        case (let r1?, let r2?) where r1 < r2:
            return false

        case (let r1?, let r2?) where r1 > r2:
            return true
        
        default:
            return n1.label < n2.label
        }
    }

    // Prepare nodes
    for definition in nodeDefinitions {
        nodeIds[ObjectIdentifier(definition.node)] = viz.createNode(label: definition.label)
    }

    // Output connections
    for definition in nodeDefinitions {
        let node = definition.node

        guard let nodeId = nodeIds[ObjectIdentifier(node)] else {
            continue
        }

        var edges: [CallGraphEdge] = graph.edges(from: node)

        // Sort edges by lexical ordering
        edges.sort {
            guard let lhs = nodeIds[ObjectIdentifier($0.end)] else {
                return false
            }
            guard let rhs = nodeIds[ObjectIdentifier($1.end)] else {
                return true
            }
            
            return lhs.description.compare(rhs.description, options: .numeric) == .orderedAscending
        }

        for edge in edges {
            let target = edge.end
            guard let targetId = nodeIds[ObjectIdentifier(target)] else {
                continue
            }

            var attributes: GraphViz.Attributes = GraphViz.Attributes()
            if let label = edge.debugLabel {
                attributes["label"] = .string(label)
            }

            viz.addConnection(from: nodeId, to: targetId, attributes: attributes)
        }
    }
    
    return viz.generateFile()
}

fileprivate func labelForNode(_ node: CallGraphNode, graph: CallGraph) -> String {
    return labelForDeclaration(node.declaration)
}

fileprivate func labelForDeclaration(_ declaration: FunctionBodyCarryingIntention) -> String {
    func prependType(_ type: KnownTypeReference?, _ suffix: String) -> String {
        if let typeName = type?.asTypeName {
            return "\(typeName).\(suffix)"
        }

        return suffix
    }

    func labelFor(intention: FunctionIntention) -> String {
        "<body>"
    }

    func labelFor(_ intention: ParameterizedFunctionIntention) -> String {
        intention.parameters.map {
            $0.description
        }.joined(separator: ", ")
    }

    func labelFor(_ intention: SignatureFunctionIntention) -> String {
        intention.signature.description
    }

    func labelFor(_ intention: DeinitGenerationIntention) -> String {
        "deinit"
    }

    func labelFor(_ intention: KnownProperty) -> String {
        "var \(intention.name): \(TypeFormatter.stringify(intention.storage.type))"
    }

    func labelFor(_ intention: KnownGlobalVariable) -> String {
        "var \(intention.name): \(TypeFormatter.stringify(intention.storage.type))"
    }

    func labelFor(_ intention: KnownProperty, getter: Bool) -> String {
        getter ? "\(labelFor(intention)) { get }" :  "\(labelFor(intention)) { set }"
    }

    func labelFor(_ intention: KnownSubscript, getter: Bool) -> String {
        let base = "subscript\(TypeFormatter.asString(parameters: intention.parameters)) -> \(TypeFormatter.stringify(intention.returnType))"

        return getter ? "\(base) { get }" :  "\(base) { set }"
    }

    func labelFor(_ property: KnownProperty, getter: Bool, ofType type: KnownTypeReferenceConvertible?) -> String {
        let base: String

        if let type = type?.asKnownTypeReference {
            base = TypeFormatter.asString(property: property, ofType: type, includeAccessors: false)
        } else {
            base = "var \(property.name): \(property.memberType)"
        }

        return getter ? "\(base) { get }" :  "\(base) { set }"
    }

    func labelFor(_ sub: KnownSubscript, getter: Bool, ofType type: KnownTypeReferenceConvertible?) -> String {
        let base: String

        if let type = type?.asKnownTypeReference {
            base = TypeFormatter.asString(subscript: sub, ofType: type, includeAccessors: false)
        } else {
            base = "subscript\(TypeFormatter.asString(parameters: sub.parameters)) -> \(sub.returnType)"
        }

        return getter ? "\(base) { get }" :  "\(base) { set }"
    }

    func labelFor(_ method: KnownMethod, ofType type: KnownTypeReferenceConvertible?) -> String {
        if let type = type?.asKnownTypeReference {
            return TypeFormatter.asString(method: method, ofType: type)
        }

        return method.signature.description
    }

    func labelFor(_ ctor: KnownConstructor, ofType type: KnownTypeReferenceConvertible?) -> String {
        if let type = type?.asKnownTypeReference {
            return TypeFormatter.asString(initializer: ctor, ofType: type)
        }

        return TypeFormatter.asString(initializer: ctor)
    }

    var label: String
    switch declaration {
    case .method(let intention):
        label = labelFor(intention, ofType: intention.ownerType)

    case .initializer(let intention):
        label = labelFor(intention, ofType: intention.ownerType)

    case .deinit(let intention):
        label = prependType(intention.ownerType, labelFor(intention))

    case .global(let intention):
        label = labelFor(intention)

    case .propertyGetter(let intention, _):
        label = labelFor(intention, getter: true, ofType: intention.ownerType)

    case .propertySetter(let intention, _):
        label = labelFor(intention, getter: false, ofType: intention.ownerType)

    case .subscriptGetter(let intention, _):
        label = labelFor(intention, getter: true, ofType: intention.ownerType)

    case .subscriptSetter(let intention, _):
        label = labelFor(intention, getter: false, ofType: intention.ownerType)

    case .propertyInitializer(let intention, _):
        label = prependType(intention.ownerType, labelFor(intention) + " = <initializer>")

    case .globalVariable(let intention, _):
        label = labelFor(intention) + " = <initializer>"
    }

    return label
}
