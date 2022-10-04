import Intentions
import SwiftAST
import TypeSystem
import KnownType

extension CallGraph {
    static func _fromIntentions(
        _ collection: IntentionCollection,
        typeSystem: TypeSystem
    )  -> CallGraph {

        let graph = CallGraph(nodes: [], edges: [])

        let queue = FunctionBodyQueue<EmptyFunctionBodyQueueDelegate>.fromIntentionCollection(
            collection,
            delegate: .init(),
            numThreads: 1
        )

        let usageAnalyzer = IntentionCollectionUsageAnalyzer(
            intentions: collection,
            typeSystem: typeSystem,
            numThreads: 1
        )

        for item in queue.items {
            guard let intention = item.intention else {
                continue
            }
            guard let container = intention.statementContainer else {
                continue
            }

            let node = graph.ensureNode(intention)

            let usages = usageAnalyzer.findAllUsagesIn(
                container.syntaxNode,
                intention: intention
            )

            for usage in usages {
                let refIntentions =
                    _extractIntentions(
                        usage.definition,
                        usageKind: usage.usageKind,
                        collection,
                        typeSystem
                    )

                for ref in refIntentions {
                    let next = graph.ensureNode(ref)

                    if !graph.areConnected(start: node, end: next) {
                        graph.addEdge(from: node, to: next)
                    }
                }
            }
        }

        return graph
    }

    private static func _extractIntentions(
        _ definition: CodeDefinition,
        usageKind: DefinitionUsage.UsageKind,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> [FunctionBodyCarryingIntention] {

        switch definition {
        case let def as KnownMemberCodeDefinition:
            return _extractIntentions(def.knownMember, usageKind: usageKind, collection, typeSystem)

        case let def as GlobalIntentionCodeDefinition:
            return _extractIntentions(def, usageKind: usageKind, collection, typeSystem)

        default:
            break
        }

        return []
    }

    private static func _extractIntentions(
        _ member: KnownMember,
        usageKind: DefinitionUsage.UsageKind,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> [FunctionBodyCarryingIntention] {
        
        switch member {
        case let member as InitGenerationIntention:
            return [.initializer(member)]
            
        case let member as MethodGenerationIntention:
            return [.method(member)]
        
        case let member as PropertyGenerationIntention:
            var result: [FunctionBodyCarryingIntention] = []

            if usageKind.isRead, let getter = member.getter {
                result.append(.propertyGetter(member, getter))
            }
            if usageKind.isWrite, let setter = member.setter {
                result.append(.propertySetter(member, setter))
            }

            return result
            
        case let member as SubscriptGenerationIntention:
            var result: [FunctionBodyCarryingIntention] = []

            if usageKind.isRead {
                result.append(.subscriptGetter(member, member.getter))
            }
            if usageKind.isWrite, let setter = member.setter {
                result.append(.subscriptSetter(member, setter))
            }

            return result

        default:
            return []
        }
    }

    private static func _extractIntentions(
        _ definition: GlobalIntentionCodeDefinition,
        usageKind: DefinitionUsage.UsageKind,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> [FunctionBodyCarryingIntention] {

        switch definition.intention {
        case let def as GlobalFunctionGenerationIntention:
            return [.global(def)]

        default:
            return []
        }
    }
}

extension CallGraph {

}
