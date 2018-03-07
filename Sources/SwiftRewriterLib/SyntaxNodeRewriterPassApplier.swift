import Foundation
import SwiftAST

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public final class SyntaxNodeRewriterPassApplier {
    public var passes: [SyntaxNodeRewriterPass.Type]
    public var typeSystem: TypeSystem
    public var numThreds: Int
    
    public init(passes: [SyntaxNodeRewriterPass.Type], typeSystem: TypeSystem, numThreds: Int = 8) {
        self.passes = passes
        self.typeSystem = typeSystem
        self.numThreds = numThreds
    }
    
    public func apply(on intentions: IntentionCollection) {
        // Apply expression passes in a multi-threaded context.
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = numThreds
        
        for file in intentions.fileIntentions() {
            let invoker = makeResolverInvoker()
            queue.addOperation {
                invoker.applyOnFile(file)
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
    }
    
    private func makeResolverInvoker() -> InternalSyntaxNodeApplier {
        let typeResolver =
            ExpressionTypeResolver(typeSystem: typeSystem,
                                   intrinsicVariables: EmptyCodeScope())
        
        // Initializer the passes instances
        let passes = self.passes.map { $0.init() }
        
        return InternalSyntaxNodeApplier(passes: passes, typeSystem: typeSystem,
                                         typeResolver: typeResolver)
    }
}

// MARK: Invoker instance
private class InternalSyntaxNodeApplier {
    public var passes: [SyntaxNodeRewriterPass]
    public var typeSystem: TypeSystem
    public var typeResolver: ExpressionTypeResolver
    
    public init(passes: [SyntaxNodeRewriterPass], typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver) {
        self.passes = passes
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
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
        let intrinsics = setupIntrinsics(forMember: property)
        defer {
            tearDownIntrinsics()
        }
        
        switch property.mode {
        case .computed(let intent):
            applyOnFunctionBody(intent)
        case let .property(get, set):
            applyOnFunctionBody(get)
            
            // For setter, push intrinsic for the setter value
            intrinsics.recordDefinition(
                CodeDefinition(name: set.valueIdentifier, type: property.type, intention: nil)
            )
            
            applyOnFunctionBody(set.body)
        case .asField:
            break
        }
    }
    
    private func applyOnInitializer(_ ctor: InitGenerationIntention) {
        setupIntrinsics(forMember: ctor)
        defer {
            tearDownIntrinsics()
        }
        
        applyOnFunction(ctor)
    }
    
    private func applyOnMethod(_ method: MethodGenerationIntention) {
        setupIntrinsics(forMember: method)
        defer {
            tearDownIntrinsics()
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
            typeResolver.resolveTypes(in: functionBody.body)
            
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
                    typeResolver.resolveTypes(in: functionBody.body)
                }
            }
        }
    }
    
    @discardableResult
    private func setupIntrinsics(forMember member: MemberGenerationIntention) -> DefaultCodeScope {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable, as well as all properties visible
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            let selfStorage: ValueStorage
            
            if member.isStatic {
                // Class `self` points to metatype of the class
                selfStorage =
                    ValueStorage(type: .metatype(for: selfType),
                                 ownership: .strong,
                                 isConstant: true)
            } else {
                // Instance `self` points to the actual instance
                selfStorage =
                    ValueStorage(type: selfType,
                                 ownership: .strong,
                                 isConstant: true)
            }
            
            intrinsics.recordDefinition(CodeDefinition(name: "self", storage: selfStorage, intention: type))
            
            // Record all known static properties visible
            if let knownType = typeSystem.knownTypeWithName(type.typeName) {
                for prop in knownType.knownProperties where prop.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(name: prop.name, storage: prop.storage, intention: prop as? Intention)
                    )
                }
                
                for field in knownType.knownFields where field.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(name: field.name, storage: field.storage, intention: field as? Intention)
                    )
                }
            }
        }
        
        // Push function parameters as intrinsics, if member is a method type
        if let function = member as? FunctionIntention {
            for param in function.parameters {
                intrinsics.recordDefinition(
                    CodeDefinition(name: param.name, type: param.type, intention: function)
                )
            }
        }
        
        typeResolver.intrinsicVariables = intrinsics
        
        return intrinsics
    }
    
    /// Always call this before returning from a method that calls
    /// `setupIntrinsics(forMember:)`
    private func tearDownIntrinsics() {
        typeResolver.intrinsicVariables = EmptyCodeScope()
    }
}
