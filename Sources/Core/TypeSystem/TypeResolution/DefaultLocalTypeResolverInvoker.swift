import SwiftAST
import Intentions
import Utils

public class DefaultLocalTypeResolverInvoker: LocalTypeResolverInvoker {
    var intention: FunctionBodyCarryingIntention
    var globals: DefinitionsSource
    var typeSystem: IntentionCollectionTypeSystem
    var intentionGlobals: IntentionCollectionGlobals
    
    public init(
        intention: FunctionBodyCarryingIntention,
        globals: DefinitionsSource,
        typeSystem: IntentionCollectionTypeSystem
    ) {
        self.intention = intention
        self.globals = globals
        self.typeSystem = typeSystem
        
        intentionGlobals = IntentionCollectionGlobals(intentions: typeSystem.intentions)
    }

    public func resolveType(_ expression: Expression, force: Bool) -> Expression {
        resolve(force: force)

        return expression
    }

    public func resolveTypes(in statement: Statement, force: Bool) -> Statement {
        resolve(force: force)

        return statement
    }

    private func resolve(force: Bool) {
        let queue = FunctionBodyQueue.fromFunctionBodyCarryingIntention(
            intention,
            delegate: makeQueueDelegate()
        )

        resolveFromQueue(queue, force: force)
    }
    
    private func resolveFromQueue(
        _ queue: FunctionBodyQueue<TypeResolvingQueueDelegate>,
        force: Bool
    ) {

        for item in queue.items {
            item.context.typeResolver.ignoreResolvedExpressions = !force
            item.context.intrinsicsBuilder.makeCache()

            switch item.container {
            case .function(let body):
                _ = item.context.typeResolver.resolveTypes(in: body.body)
            case .statement(let stmt):
                _ = item.context.typeResolver.resolveTypes(in: stmt)
            case .expression(let exp):
                _ = item.context.typeResolver.resolveType(exp)
            }

            item.context.intrinsicsBuilder.tearDownCache()
        }
    }
    
    private func makeQueueDelegate() -> TypeResolvingQueueDelegate {
        TypeResolvingQueueDelegate(
            intentions: typeSystem.intentions,
            globals: globals,
            typeSystem: typeSystem,
            intentionGlobals: intentionGlobals
        )
    }
}
