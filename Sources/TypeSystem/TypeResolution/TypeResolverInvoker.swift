import Foundation
import SwiftAST
import Intentions
import Utils

/// A basic protocol with two front-end methods for requesting resolving of types
/// of expression and statements on intention collections.
public protocol TypeResolverInvoker {
    /// Invocates the resolution of types for all expressions from all method bodies
    /// contained within an intention collection.
    func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool)
    
    /// Resolves all types within a given method intention.
    func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool)
    
    /// Resolves all types from all expressions that may be contained within
    /// computed accessors of a given property.
    func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool)
    
    /// Resolves the type of a given expression as if it was a global expression
    /// located at a given file.
    func resolveGlobalExpressionType(in expression: Expression,
                                     inFile file: FileGenerationIntention,
                                     force: Bool)
}

public class DefaultTypeResolverInvoker: TypeResolverInvoker {
    var globals: DefinitionsSource
    var typeSystem: IntentionCollectionTypeSystem
    var intentionGlobals: IntentionCollectionGlobals
    var numThreads: Int
    
    public init(globals: DefinitionsSource, typeSystem: IntentionCollectionTypeSystem, numThreads: Int) {
        self.globals = globals
        self.typeSystem = typeSystem
        self.numThreads = numThreads
        
        intentionGlobals = IntentionCollectionGlobals(intentions: typeSystem.intentions)
    }
    
    public func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool) {
        typeSystem.makeCache()
        
        let queue =
            FunctionBodyQueue
                .fromIntentionCollection(intentions, delegate: makeQueueDelegate(),
                                         numThreads: numThreads)
        
        resolveFromQueue(queue)
        
        typeSystem.tearDownCache()
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool) {
        let queue =
            FunctionBodyQueue.fromMethod(typeSystem.intentions,
                                         method: method,
                                         delegate: makeQueueDelegate())
        
        resolveFromQueue(queue)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool) {
        let queue =
            FunctionBodyQueue.fromProperty(typeSystem.intentions,
                                           property: property,
                                           delegate: makeQueueDelegate())
        
        resolveFromQueue(queue)
    }
    
    public func resolveGlobalExpressionType(in expression: Expression,
                                            inFile file: FileGenerationIntention,
                                            force: Bool) {
        
        let context = makeQueueDelegate().makeContext(forFile: file)
        
        context.intrinsicsBuilder.makeCache()
        context.typeResolver.ignoreResolvedExpressions = !force
        _=context.typeResolver.resolveType(expression)
        context.intrinsicsBuilder.tearDownCache()
    }
    
    public func refreshIntentionGlobals() {
        intentionGlobals = IntentionCollectionGlobals(intentions: typeSystem.intentions)
    }
    
    private func resolveFromQueue(_ queue: FunctionBodyQueue<TypeResolvingQueueDelegate>) {
        // Make a file invoker for each file and execute resolving in parallel
        let opQueue = OperationQueue()
        opQueue.maxConcurrentOperationCount = numThreads
        
        for item in queue.items {
            opQueue.addOperation {
                autoreleasepool {
                    item.context.intrinsicsBuilder.makeCache()
                    _=item.context.typeResolver.resolveTypes(in: item.body.body)
                    item.context.intrinsicsBuilder.tearDownCache()
                }
            }
        }
        
        opQueue.waitUntilAllOperationsAreFinished()
    }
    
    // MARK: - Private methods
    
    private func makeQueueDelegate() -> TypeResolvingQueueDelegate {
        TypeResolvingQueueDelegate(
            intentions: typeSystem.intentions,
            globals: globals,
            typeSystem: typeSystem,
            intentionGlobals: intentionGlobals)
    }
}

public class TypeResolvingQueueDelegate: FunctionBodyQueueDelegate {
    var intentions: IntentionCollection
    var globals: DefinitionsSource
    var typeSystem: TypeSystem
    var intentionGlobals: IntentionCollectionGlobals
    
    public init(intentions: IntentionCollection,
                globals: DefinitionsSource,
                typeSystem: TypeSystem,
                intentionGlobals: IntentionCollectionGlobals) {
        
        self.intentions = intentions
        self.globals = globals
        self.typeSystem = typeSystem
        self.intentionGlobals = intentionGlobals
    }
    
    public func makeContext(forFile file: FileGenerationIntention)
        -> TypeResolvingQueueDelegate.Context {
        
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forFile: file, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forFunction function: GlobalFunctionGenerationIntention)
        -> TypeResolvingQueueDelegate.Context {
        
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: function.signature.returnType)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forFunction: function, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forInit ctor: InitGenerationIntention) -> TypeResolvingQueueDelegate.Context {
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forMember: ctor, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forDeinit deinitIntent: DeinitGenerationIntention) -> Context {
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forMember: deinitIntent, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forMethod method: MethodGenerationIntention) -> Context {
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: method.returnType)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forMember: method, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forPropertyGetter property: PropertyGenerationIntention,
                            getter: FunctionBodyIntention) -> Context {
        
        let resolver = ExpressionTypeResolver(
            typeSystem: typeSystem, contextFunctionReturnType: property.type)
        
        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forMember: property, intentions: intentions)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    public func makeContext(forPropertySetter property: PropertyGenerationIntention,
                            setter: PropertyGenerationIntention.Setter) -> Context {
        
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)

        let intrinsics = makeIntrinsics(typeResolver: resolver)
        intrinsics.setupIntrinsics(forMember: property, intentions: intentions)
        intrinsics.addSetterIntrinsics(setter: setter, type: property.type)
        
        return Context(typeResolver: resolver, intrinsicsBuilder: intrinsics)
    }
    
    private func makeIntrinsics(typeResolver: ExpressionTypeResolver) -> TypeResolverIntrinsicsBuilder {
        let intrinsics =
            TypeResolverIntrinsicsBuilder(
                typeResolver: typeResolver,
                globals: globals,
                typeSystem: typeSystem,
                intentionGlobals: intentionGlobals)
        
        return intrinsics
    }
    
    public struct Context {
        public var typeResolver: ExpressionTypeResolver
        var intrinsicsBuilder: TypeResolverIntrinsicsBuilder
    }
}
