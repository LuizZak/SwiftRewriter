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
            invoker.collectGlobals(from: typeSystem.intentions)
            
            queue.addOperation {
                invoker.applyOnFile(file)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        typeSystem.tearDownCache()
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        invoker.collectGlobals(from: typeSystem.intentions)
        
        invoker.applyOnMethod(method)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        invoker.collectGlobals(from: typeSystem.intentions)
        
        invoker.applyOnProperty(property)
    }
    
    // MARK: - Private methods
    
    private func makeResolverInvoker(forceResolve: Bool) -> InternalTypeResolverInvoker {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        typeResolver.ignoreResolvedExpressions = !forceResolve
        
        return InternalTypeResolverInvoker(globals: globals.definitions, typeResolver: typeResolver)
    }
}

private class InternalTypeResolverInvoker {
    var globals: [CodeDefinition] = []
    var globalVars: [GlobalVariableGenerationIntention]
    var typeResolver: ExpressionTypeResolver
    
    init(globals: [CodeDefinition], typeResolver: ExpressionTypeResolver) {
        self.globals = globals
        self.typeResolver = typeResolver
        
        globalVars = []
    }
    
    func collectGlobals(from intentions: IntentionCollection) {
        for file in intentions.fileIntentions() {
            globalVars.append(contentsOf: file.globalVariableIntentions)
        }
    }
    
    func apply(on intentions: IntentionCollection) {
        collectGlobals(from: intentions)
        
        let files = intentions.fileIntentions()
        
        for file in files {
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
        setupIntrinsics(forMember: method)
        defer {
            tearDownIntrinsics()
        }
        
        applyOnFunction(method)
    }
    
    func applyOnProperty(_ property: PropertyGenerationIntention) {
        setupIntrinsics(forMember: property)
        defer {
            tearDownIntrinsics()
        }
        
        switch property.mode {
        case .computed(let intent):
            applyOnFunctionBody(intent)
        case let .property(get, set):
            applyOnFunctionBody(get)
            applyOnFunctionBody(set.body)
        case .asField:
            break
        }
    }
    
    private func setupIntrinsics(forMember member: MemberGenerationIntention) {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            
            if member.isStatic {
                // Class `self` points to metatype of the class
                intrinsics.recordDefinition(
                    CodeDefinition(variableNamed: "self", type: .metatype(for: selfType),
                                   intention: member)
                )
            } else {
                // Instance `self` points to the actual instance
                intrinsics.recordDefinition(
                    CodeDefinition(variableNamed: "self", type: selfType,
                                   intention: member)
                )
            }
        }
        
        // Push file-level global variables
        for global in globalVars where global.isVisible(for: member) {
            intrinsics.recordDefinition(
                CodeDefinition(variableNamed: global.name,
                               storage: global.storage,
                               intention: global)
            )
        }
        
        // Push global definitions
        intrinsics.recordDefinitions(globals)
        
        typeResolver.intrinsicVariables = intrinsics
    }
    
    /// Always call this before returning from a method that calls
    /// `setupIntrinsics(forMember:)`
    private func tearDownIntrinsics() {
        typeResolver.intrinsicVariables = EmptyCodeScope()
    }
}
