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
                guard let refIntention =
                    _extractIntention(
                        usage.definition,
                        isReadOnly: usage.isReadOnlyUsage,
                        collection,
                        typeSystem
                    ) 
                else {
                    continue
                }

                let next = graph.ensureNode(refIntention)

                if !graph.areConnected(start: node, end: next) {
                    graph.addEdge(from: node, to: next)
                }
            }
        }

        return graph
    }

    private static func _extractIntention(
        _ definition: CodeDefinition,
        isReadOnly: Bool,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> FunctionBodyCarryingIntention? {

        switch definition {
        case let def as KnownMemberCodeDefinition:
            return _extractIntention(def.knownMember, isReadOnly: isReadOnly, collection, typeSystem)

        case let def as GlobalIntentionCodeDefinition:
            return _extractIntention(def, isReadOnly: isReadOnly, collection, typeSystem)

        default:
            break
        }

        return nil
    }

    private static func _extractIntention(
        _ member: KnownMember,
        isReadOnly: Bool,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> FunctionBodyCarryingIntention? {
        
        switch member {
        case let member as InitGenerationIntention:
            return .initializer(member)
            
        case let member as MethodGenerationIntention:
            return .method(member)
        
        case let member as PropertyGenerationIntention:
            if isReadOnly, let getter = member.getter {
                return .propertyGetter(member, getter)
            }
            if !isReadOnly, let setter = member.setter {
                return .propertySetter(member, setter)
            }

            return nil
            
        case let member as SubscriptGenerationIntention:
            if isReadOnly {
                return .subscriptGetter(member, member.getter)
            }
            if !isReadOnly, let setter = member.setter {
                return .subscriptSetter(member, setter)
            }

            return nil

        default:
            return nil
        }
    }

    private static func _extractIntention(
        _ definition: GlobalIntentionCodeDefinition,
        isReadOnly: Bool,
        _ collection: IntentionCollection,
        _ typeSystem: TypeSystem
    ) -> FunctionBodyCarryingIntention? {

        switch definition.intention {
        case let def as GlobalFunctionGenerationIntention:
            return .global(def)

        default:
            return nil
        }
    }
}

extension CallGraph {

}
