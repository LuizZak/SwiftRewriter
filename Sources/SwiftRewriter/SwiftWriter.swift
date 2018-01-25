/// Gets as inputs a series of intentions and outputs actual files and script
/// contents.
public class SwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let context = TypeContext()
    let typeMapper: TypeMapper
    
    public init(intentions: IntentionCollection, output: WriterOutput) {
        self.intentions = intentions
        self.output = output
        self.typeMapper = TypeMapper(context: context)
    }
    
    public func execute() {
        let out = output.createFile(path: "").outputTarget()
        let classes = intentions.intentions(ofType: ClassGenerationIntention.self)
        
        for cls in classes {
            outputClass(cls, target: out)
        }
    }
    
    private func outputClass(_ cls: ClassGenerationIntention, target: RewriterOutputTarget) {
        target.output(line: "class \(cls.typeName) {")
        target.idented {
            for prop in cls.properties {
                outputProperty(prop, target: target)
            }
            
            if cls.properties.count > 0 && cls.methods.count > 0 {
                target.output(line: "")
            }
            
            for method in cls.methods {
                outputMethod(method, target: target)
            }
        }
        target.output(line: "}")
        target.onAfterOutput()
    }
    
    private func outputProperty(_ prop: PropertyGenerationIntention, target: RewriterOutputTarget) {
        let type = prop.type
        
        let ctx = TypeMapper.TypeMappingContext(modifiers: prop.typedSource?.modifierList)
        
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        var decl: String = "var "
        decl += "\(prop.name): \(typeName)"
        
        target.output(line: decl)
    }
    
    private func outputMethod(_ method: MethodGenerationIntention, target: RewriterOutputTarget) {
        var decl: String = "func "
        
        let sign = method.signature
        
        decl += sign.name
        decl += "("
        decl += ")"
        
        if case .void = sign.returnType {
            
        }
        
        decl += " {"
        
        target.output(line: decl)
        
        target.idented {
            // TODO: Output method body here.
        }
        
        target.output(line: "}")
    }
}
