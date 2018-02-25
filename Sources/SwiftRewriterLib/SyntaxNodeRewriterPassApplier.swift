/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public class SyntaxNodeRewriterPassApplier {
    public var passes: [SyntaxNodeRewriterPass]
    public var typeResolver: ExpressionTypeResolver
    
    public init(passes: [SyntaxNodeRewriterPass], typeResolver: ExpressionTypeResolver) {
        self.passes = passes
        self.typeResolver = typeResolver
    }
    
    public func apply(on intentions: IntentionCollection) {
        let files = intentions.fileIntentions()
        
        for file in files {
            applyOnFile(file)
        }
    }
    
    private func applyOnFile(_ file: FileGenerationIntention) {
        for cls in file.classIntentions {
            applyOnClass(cls)
        }
        
        for cls in file.extensionIntentions {
            applyOnClass(cls)
        }
    }
    
    private func applyOnClass(_ cls: BaseClassIntention) {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable
        intrinsics.recordDefinition(
            CodeDefinition(name: "self",
                           type: .typeName(cls.typeName))
        )
        
        typeResolver.intrinsicVariables = intrinsics
        
        defer {
            // Don't forget to remove intrinsics later!
            typeResolver.intrinsicVariables = EmptyCodeScope()
        }
        
        for prop in cls.properties {
            applyOnProperty(prop)
        }
        
        for method in cls.methods {
            applyOnFunction(method)
        }
    }
    
    private func applyOnFunction(_ f: FunctionIntention) {
        if let method = f.functionBody {
            applyOnMethodBody(method)
        }
    }
    
    private func applyOnProperty(_ property: PropertyGenerationIntention) {
        switch property.mode {
        case .computed(let intent):
            applyOnMethodBody(intent)
        case let .property(get, set):
            applyOnMethodBody(get)
            applyOnMethodBody(set.body)
        case .asField:
            break
        }
    }
    
    private func applyOnMethodBody(_ methodBody: FunctionBodyIntention) {
        // Resolve types before feeding into passes
        typeResolver.resolveTypes(in: methodBody.body)
        
        passes.forEach {
            _=methodBody.body.accept($0)
            
            // After each apply to the body, we must re-type check the result
            // before handing it off to the next pass.
            typeResolver.resolveTypes(in: methodBody.body)
        }
    }
}
