import Foundation
import SwiftAST

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public final class SyntaxNodeRewriterPassApplier {
    var afterFile: ((String) -> Void)?
    
    public var passes: [SyntaxNodeRewriterPass.Type]
    public var typeSystem: TypeSystem
    public var numThreds: Int
    public var globals: DefinitionsSource
    
    public init(passes: [SyntaxNodeRewriterPass.Type],
                typeSystem: TypeSystem,
                globals: DefinitionsSource,
                numThreds: Int = 8) {
        
        self.passes = passes
        self.typeSystem = typeSystem
        self.numThreds = numThreds
        self.globals = globals
    }
    
    public func apply(on intentions: IntentionCollection) {
        let intentionTypeSystem = typeSystem as? IntentionCollectionTypeSystem
        intentionTypeSystem?.makeCache()
        
        // Apply expression passes in a multi-threaded context.
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        for file in intentions.fileIntentions() {
            let invoker = makeResolverInvoker(intentions: intentions)
            queue.addOperation {
                invoker.applyOnFile(file)
                self.afterFile?(file.targetPath)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        intentionTypeSystem?.tearDownCache()
    }
    
    private func makeResolverInvoker(intentions: IntentionCollection) -> InternalSyntaxNodeApplier {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        
        // Initializer the passes instances
        let passes = self.passes.map { $0.init() }
        
        return InternalSyntaxNodeApplier(passes: passes, typeSystem: typeSystem,
                                         typeResolver: typeResolver,
                                         globals: globals,
                                         intentions: intentions)
    }
}

// MARK: Invoker instance
private class InternalSyntaxNodeApplier {
    var passes: [SyntaxNodeRewriterPass]
    var typeSystem: TypeSystem
    var typeResolver: ExpressionTypeResolver
    var intrinsicsBuilder: TypeResolverIntrinsicsBuilder
    var intentions: IntentionCollection
    
    init(passes: [SyntaxNodeRewriterPass],
         typeSystem: TypeSystem,
         typeResolver: ExpressionTypeResolver,
         globals: DefinitionsSource,
         intentions: IntentionCollection) {
        
        intrinsicsBuilder =
            TypeResolverIntrinsicsBuilder(
                typeResolver: typeResolver,
                globals: globals,
                typeSystem: typeSystem)
        
        self.passes = passes
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
        self.intentions = intentions
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for cls in file.classIntentions {
            applyOnClass(cls)
        }
        
        for cls in file.extensionIntentions {
            applyOnClass(cls)
        }
    }
    
    private func applyOnClass(_ cls: BaseClassIntention) {
        for prop in cls.properties {
            applyOnProperty(prop)
        }
        
        for initializer in cls.constructors {
            applyOnInitializer(initializer)
        }
        
        for method in cls.methods {
            applyOnMethod(method)
        }
    }
    
    private func applyOnProperty(_ property: PropertyGenerationIntention) {
        intrinsicsBuilder.setupIntrinsics(forMember: property, intentions: intentions)
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
    
    private func applyOnInitializer(_ ctor: InitGenerationIntention) {
        intrinsicsBuilder.setupIntrinsics(forMember: ctor, intentions: intentions)
        defer {
            intrinsicsBuilder.teardownIntrinsics()
        }
        
        applyOnFunction(ctor)
    }
    
    private func applyOnMethod(_ method: MethodGenerationIntention) {
        intrinsicsBuilder.setupIntrinsics(forMember: method, intentions: intentions)
        defer {
            intrinsicsBuilder.teardownIntrinsics()
        }
        
        applyOnFunction(method)
    }
    
    private func applyOnFunction(_ f: FunctionIntention) {
        if let method = f.functionBody {
            applyOnFunctionBody(method)
        }
    }
    
    private func applyOnFunctionBody(_ functionBody: FunctionBodyIntention) {
        autoreleasepool {
            // Resolve types before feeding into passes
            _=typeResolver.resolveTypes(in: functionBody.body)
            
            var didChangeTree = false
            let notifyChangedTree: () -> Void = {
                didChangeTree = true
            }
            
            let expContext =
                SyntaxNodeRewriterPassContext(typeSystem: typeSystem,
                                              typeResolver: typeResolver,
                                              notifyChangedTree: notifyChangedTree)
            
            passes.forEach {
                didChangeTree = false
                
                _=$0.apply(on: functionBody.body, context: expContext)
                
                if didChangeTree {
                    // After each apply to the body, we must re-type check the result
                    // before handing it off to the next pass.
                    _=typeResolver.resolveTypes(in: functionBody.body)
                }
            }
        }
    }
}
