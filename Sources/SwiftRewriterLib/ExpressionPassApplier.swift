public class ExpressionPassApplier {
    public var passes: [ExpressionPass]
    
    public init(passes: [ExpressionPass]) {
        self.passes = passes
//        let exp = expressionPasses.reduce(into: expression, { (exp, pass) in
//            exp = pass.applyPass(on: exp, context: )
//        })
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
        
    }
    
    private func applyOnFunction(_ f: FunctionIntention) {
        
    }
    
    private func applyOnMethodBody(_ methodBody: MethodBodyIntention) {
//        let pass = StatementIterator
//        
//        let exp = passes.reduce(into: expression, { (exp, pass) in
//            exp = pass.applyPass(on: exp, context: )
//        })
    }
}
