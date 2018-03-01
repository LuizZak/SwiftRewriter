import SwiftAST

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public class SyntaxNodeRewriterPassApplier {
    public var passes: [SyntaxNodeRewriterPass]
    public var typeSystem: TypeSystem
    public var typeResolver: ExpressionTypeResolver
    
    public init(passes: [SyntaxNodeRewriterPass], typeSystem: TypeSystem, typeResolver: ExpressionTypeResolver) {
        self.passes = passes
        self.typeSystem = typeSystem
        self.typeResolver = typeResolver
    }
    
    public func apply(on intentions: IntentionCollection) {
        let files = intentions.fileIntentions()
        
        for file in files {
            applyOnFile(file)
        }
    }
    
    // MARK: - Private members
    
    private func applyOnFile(_ file: FileGenerationIntention) {
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
                CodeDefinition(name: set.valueIdentifier, type: property.type)
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
        // Resolve types before feeding into passes
        typeResolver.resolveTypes(in: functionBody.body)
        
        let expContext = SyntaxNodeRewriterPassContext(typeSystem: typeSystem)
        
        passes.forEach {
            $0.apply(on: functionBody.body, context: expContext)
            
            // After each apply to the body, we must re-type check the result
            // before handing it off to the next pass.
            typeResolver.resolveTypes(in: functionBody.body)
        }
    }
    
    @discardableResult
    private func setupIntrinsics(forMember member: MemberGenerationIntention) -> DefaultCodeScope {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            
            if member.isStatic {
                // Class `self` points to metatype of the class
                intrinsics.recordDefinition(
                    CodeDefinition(name: "self", type: .metatype(for: selfType))
                )
            } else {
                // Instance `self` points to the actual instance
                intrinsics.recordDefinition(
                    CodeDefinition(name: "self", type: selfType)
                )
            }
        }
        
        // Push function parameters as intrinsics, if member is a method type
        if let function = member as? FunctionIntention {
            for param in function.parameters {
                intrinsics.recordDefinition(
                    CodeDefinition(name: param.name, type: param.type)
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
