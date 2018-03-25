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
    var globals: GlobalDefinitions
    var typeSystem: IntentionCollectionTypeSystem
    var numThreads: Int
    
    public init(globals: GlobalDefinitions, typeSystem: IntentionCollectionTypeSystem, numThreads: Int) {
        self.globals = globals
        self.typeSystem = typeSystem
        self.numThreads = numThreads
    }
    
    public func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool) {
        typeSystem.makeCache()
        
        // Make a file invoker for each file and execute resolving in parallel
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreads
        
        for file in intentions.fileIntentions() {
            let invoker = makeResolverInvoker(forceResolve: force)
            invoker.collectGlobalVariables()
            
            queue.addOperation {
                invoker.applyOnFile(file)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        typeSystem.tearDownCache()
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        invoker.collectGlobalVariables()
        
        invoker.applyOnMethod(method)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        invoker.collectGlobalVariables()
        
        invoker.applyOnProperty(property)
    }
    
    // MARK: - Private methods
    
    private func makeResolverInvoker(forceResolve: Bool) -> InternalTypeResolverInvoker {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        typeResolver.ignoreResolvedExpressions = !forceResolve
        
        return InternalTypeResolverInvoker(globals: globals,
                                           intentions: typeSystem.intentions,
                                           typeResolver: typeResolver,
                                           typeSystem: typeSystem)
    }
}

private class InternalTypeResolverInvoker {
    var globals: DefinitionsSource
    var globalVariables: [GlobalVariableGenerationIntention] = []
    var intentions: IntentionCollection
    var typeResolver: ExpressionTypeResolver
    var intrinsicsBuilder: TypeResolverIntrinsicsBuilder
    
    init(globals: DefinitionsSource,
         intentions: IntentionCollection,
         typeResolver: ExpressionTypeResolver,
         typeSystem: TypeSystem) {
        
        intrinsicsBuilder =
            TypeResolverIntrinsicsBuilder(
                typeResolver: typeResolver,
                globals: globals,
                globalVariables: [],
                typeSystem: typeSystem)
        
        self.globals = globals
        self.intentions = intentions
        self.typeResolver = typeResolver
    }
    
    func collectGlobalVariables() {
        var globalVariables: [GlobalVariableGenerationIntention] = []
        
        for file in intentions.fileIntentions() {
            for global in file.globalVariableIntentions {
                globalVariables.append(global)
            }
        }
        
        intrinsicsBuilder.globalVariables = globalVariables
    }
    
    func apply(on intentions: IntentionCollection) {
        collectGlobalVariables()
        
        for file in intentions.fileIntentions() {
            applyOnFile(file)
        }
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for cls in file.classIntentions {
            applyOnClass(cls)
        }
        
        for cls in file.extensionIntentions {
            applyOnClass(cls)
        }
    }
    
    func applyOnClass(_ cls: BaseClassIntention) {
        for prop in cls.properties {
            applyOnProperty(prop)
        }
        
        for method in cls.methods {
            applyOnMethod(method)
        }
    }
    
    func applyOnFunction(_ f: FunctionIntention) {
        if let method = f.functionBody {
            applyOnFunctionBody(method)
        }
    }
    
    func applyOnFunctionBody(_ functionBody: FunctionBodyIntention) {
        // Resolve types before feeding into passes
        _=typeResolver.resolveTypes(in: functionBody.body)
    }
    
    func applyOnMethod(_ method: MethodGenerationIntention) {
        intrinsicsBuilder.setupIntrinsics(forMember: method)
        defer {
            intrinsicsBuilder.teardownIntrinsics()
        }
        
        applyOnFunction(method)
    }
    
    func applyOnProperty(_ property: PropertyGenerationIntention) {
        intrinsicsBuilder.setupIntrinsics(forMember: property)
        defer {
            intrinsicsBuilder.teardownIntrinsics()
        }
        
        switch property.mode {
        case .computed(let intent):
            applyOnFunctionBody(intent)
        case let .property(get, set):
            applyOnFunctionBody(get)
            
            intrinsicsBuilder.addSetterIntrinsics(setter: set, type: property.type)
            
            applyOnFunctionBody(set.body)
        case .asField:
            break
        }
    }
}
