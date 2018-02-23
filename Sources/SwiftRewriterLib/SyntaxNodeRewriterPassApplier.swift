/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public class SyntaxNodeRewriterPassApplier {
    public var passes: [SyntaxNodeRewriterPass]
    
    public init(passes: [SyntaxNodeRewriterPass]) {
        self.passes = passes
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
        for prop in cls.properties {
            applyOnProperty(prop)
        }
        
        for method in cls.methods {
            applyOnFunction(method)
        }
    }
    
    private func applyOnFunction(_ f: FunctionIntention) {
        if let method = f.methodBody {
            applyOnMethodBody(method)
        }
    }
    
    private func applyOnMethodBody(_ methodBody: MethodBodyIntention) {
        passes.forEach {
            _=methodBody.body.accept($0)
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
}
