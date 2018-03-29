import Foundation
import SwiftAST

/// A basic protocol with two front-end methods for requesting resolving of types
/// of expression and statements on intention collections.
public protocol TypeResolverInvoker {
    /// Invocates the resolution of types for all expressions from all method bodies
    /// contained within an intention collection.
    func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool)
    
    /// Resolves all types within a given method intention.
    func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool)
    
    /// Resolves all types from all expressions that may be contained within
    /// computed accessors of a given property
    func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool)
}

public class DefaultTypeResolverInvoker: TypeResolverInvoker {
    var globals: DefinitionsSource
    var typeSystem: IntentionCollectionTypeSystem
    var numThreads: Int
    
    public init(globals: DefinitionsSource, typeSystem: IntentionCollectionTypeSystem, numThreads: Int) {
        self.globals = globals
        self.typeSystem = typeSystem
        self.numThreads = numThreads
    }
    
    public func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool) {
        typeSystem.makeCache()
        
        let queue = FunctionBodyQueue.fromIntentionCollection(intentions, delegate: makeDelegate())
        
        resolveFromQueue(queue)
        
        typeSystem.tearDownCache()
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool) {
        let queue =
            FunctionBodyQueue.fromMethod(typeSystem.intentions, method: method,
                                         delegate: makeDelegate())
        
        resolveFromQueue(queue)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool) {
        let queue =
            FunctionBodyQueue.fromProperty(typeSystem.intentions, property: property,
                                           delegate: makeDelegate())
        
        resolveFromQueue(queue)
    }
    
    private func resolveFromQueue(_ queue: FunctionBodyQueue<TypeResolvingQueueDelegate>) {
        // Make a file invoker for each file and execute resolving in parallel
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = numThreads
        
        for item in queue.items {
            opQueue.addOperation {
                autoreleasepool {
                    _=item.context.typeResolver.resolveTypes(in: item.body.body)
                }
            }
        }
        
        opQueue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: - Private methods
    
    private func makeDelegate() -> TypeResolvingQueueDelegate {
        return TypeResolvingQueueDelegate(intentions: typeSystem.intentions,
                                         globals: globals, typeSystem: typeSystem)
    }
}

class TypeResolvingQueueDelegate: FunctionBodyQueueDelegate {
    var intentions: IntentionCollection
    var globals: DefinitionsSource
    var typeSystem: TypeSystem
    
    init(intentions: IntentionCollection, globals: DefinitionsSource, typeSystem: TypeSystem) {
        self.intentions = intentions
        self.globals = globals
        self.typeSystem = typeSystem
    }
    
    func makeContext(forFunction function: GlobalFunctionGenerationIntention) -> TypeResolvingQueueDelegate.Context {
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: function.signature.returnType)
        
        let intrinsics =
            TypeResolverIntrinsicsBuilder(typeResolver: resolver, globals: globals,
                                          typeSystem: typeSystem)
        
        intrinsics.setupIntrinsics(forFunction: function, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    func makeContext(forInit ctor: InitGenerationIntention) -> TypeResolvingQueueDelegate.Context {
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        let intrinsics =
            TypeResolverIntrinsicsBuilder(typeResolver: resolver, globals: globals,
                                          typeSystem: typeSystem)
        
        intrinsics.setupIntrinsics(forMember: ctor, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    func makeContext(forMethod method: MethodGenerationIntention) -> Context {
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: method.returnType)
        
        let intrinsics =
            TypeResolverIntrinsicsBuilder(typeResolver: resolver, globals: globals,
                                          typeSystem: typeSystem)
        
        intrinsics.setupIntrinsics(forMember: method, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    func makeContext(forPropertyGetter property: PropertyGenerationIntention,
                     getter: FunctionBodyIntention) -> Context {
        
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: property.type)
        
        let intrinsics =
            TypeResolverIntrinsicsBuilder(typeResolver: resolver, globals: globals,
                                          typeSystem: typeSystem)
        
        intrinsics.setupIntrinsics(forMember: property, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    func makeContext(forPropertySetter property: PropertyGenerationIntention,
                     setter: PropertyGenerationIntention.Setter) -> Context {
        
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        let intrinsics =
            TypeResolverIntrinsicsBuilder(typeResolver: resolver, globals: globals,
                                          typeSystem: typeSystem)
        
        intrinsics.setupIntrinsics(forMember: property, intentions: intentions)
        intrinsics.addSetterIntrinsics(setter: setter, type: property.type)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    struct Context {
        var typeResolver: ExpressionTypeResolver
        var intrinsicsBuilder: TypeResolverIntrinsicsBuilder
    }
}
