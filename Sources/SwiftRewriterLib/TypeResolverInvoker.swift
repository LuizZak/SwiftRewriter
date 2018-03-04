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
    public var typeSystem: TypeSystem
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
    
    public func resolveAllExpressionTypes(in intentions: IntentionCollection, force: Bool) {
        // Make a file invoker for each file and execute resolving in parallel
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        
        for file in intentions.fileIntentions() {
            let invoker = makeResolverInvoker(forceResolve: force)
            
            queue.addOperation {
                invoker.applyOnFile(file)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        
        invoker.applyOnMethod(method)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention, force: Bool) {
        let invoker = makeResolverInvoker(forceResolve: force)
        
        invoker.applyOnProperty(property)
    }
    
    // MARK: - Private methods
    
    private func makeResolverInvoker(forceResolve: Bool) -> InternalTypeResolverInvoker {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        typeResolver.ignoreResolvedExpressions = !forceResolve
        
        return InternalTypeResolverInvoker(typeResolver: typeResolver)
    }
}

private class InternalTypeResolverInvoker {
    var typeResolver: ExpressionTypeResolver
    
    init(typeResolver: ExpressionTypeResolver) {
        self.typeResolver = typeResolver
    }
    
    func apply(on intentions: IntentionCollection) {
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
        typeResolver.resolveTypes(in: functionBody.body)
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
                    CodeDefinition(name: "self", type: .metatype(for: selfType), intention: member)
                )
            } else {
                // Instance `self` points to the actual instance
                intrinsics.recordDefinition(
                    CodeDefinition(name: "self", type: selfType, intention: member)
                )
            }
        }
        
        // Push file-level global variables
        if let intentionCollection = member.file?.intentionCollection {
            for global in intentionCollection.globalVariables() {
                if global.isVisible(for: member) {
                    intrinsics.recordDefinition(
                        CodeDefinition(name: global.name,
                                       storage: global.storage,
                                       intention: global)
                    )
                }
            }
        }
        
        typeResolver.intrinsicVariables = intrinsics
    }
    
    /// Always call this before returning from a method that calls
    /// `setupIntrinsics(forMember:)`
    private func tearDownIntrinsics() {
        typeResolver.intrinsicVariables = EmptyCodeScope()
    }
}
