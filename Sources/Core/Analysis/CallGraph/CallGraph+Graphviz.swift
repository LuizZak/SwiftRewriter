import Foundation
import Intentions
import SwiftAST
import TypeSystem
import KnownType
import Graphviz

extension CallGraph {
    /// Generates a GraphViz representation of this call graph.
    public func asGraphviz() -> GraphViz {
        let viz = GraphViz(rootGraphName: "calls")
        viz.rankDir = .topToBottom

        var nodeIds: [ObjectIdentifier: GraphViz.NodeId] = [:]
        var nodeDefinitions: [NodeDefinition<CallGraphNode>] = []
        
        // Prepare nodes
        for node in self.nodes {
            let label = labelForNode(node, graph: self)
            
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
            var group: [String] = []

            switch definition.node.ownerFile {
            case let intention as FileGenerationIntention:
                group.append((intention.targetPath as NSString).lastPathComponent)
                
            case let knownFile?:
                group.append(knownFile.fileName)

            case nil:
                break
            }

            switch definition.node.ownerType {
            case let ownerType as TypeGenerationIntention:
                let baseNames = ownerType.parentType?.asNestedTypeNames ?? []

                group.append(contentsOf: baseNames + [
                    "\(ownerType.kind.rawValue) \(ownerType.typeName)"
                ])
                
            case let ownerType?:
                group.append(contentsOf: ownerType.asKnownTypeReference.asNestedTypeNames)

            case nil:
                break
            }

            nodeIds[ObjectIdentifier(definition.node)] =
                viz.createNode(
                    label: definition.label,
                    groups: group
                )
        }

        // Output connections
        for definition in nodeDefinitions {
            let node = definition.node

            guard let nodeId = nodeIds[ObjectIdentifier(node)] else {
                continue
            }

            var edges: [CallGraphEdge] = self.edges(from: node)

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

        return viz
    }
}

private func labelForNode(_ node: CallGraphNode, graph: CallGraph) -> String {
    return labelForDeclaration(node.declaration)
}

private func labelForDeclaration(_ declaration: CallGraphNode.DeclarationKind) -> String {
    switch declaration {
    case .statement(let decl):
        return labelForDeclaration(decl)
    case .stored(let decl):
        return labelForDeclaration(decl)
    }
}

private func labelForDeclaration(_ declaration: FunctionBodyCarryingIntention) -> String {
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

private func labelForDeclaration(_ declaration: CallGraphValueStorageIntention) -> String {
    func prependType(_ type: KnownTypeReference?, _ suffix: String) -> String {
        if let typeName = type?.asTypeName {
            return "\(typeName).\(suffix)"
        }

        return suffix
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

    func labelFor(_ property: KnownProperty, ofType type: KnownTypeReferenceConvertible?) -> String {
        let base: String

        if let type = type?.asKnownTypeReference {
            base = TypeFormatter.asString(property: property, ofType: type, includeAccessors: false)
        } else {
            base = "var \(property.name): \(property.memberType)"
        }

        return base
    }

    var label: String
    switch declaration {
    case .property(let intention):
        label = labelFor(intention, ofType: intention.ownerType)

    case .instanceVariable(let intention):
        label = labelFor(intention, ofType: intention.ownerType)

    case .globalVariable(let intention):
        label = labelFor(intention)
    }

    return label
}
