import GrammarModels

/// A helper class that can be used to generate a proper swift method signature
/// from an Objective-C method signature.
public class SwiftMethodSignatureGen {
    private let context: TypeContext
    private let typeMapper: TypeMapper
    
    public init(context: TypeContext, typeMapper: TypeMapper) {
        self.context = context
        self.typeMapper = typeMapper
    }
    
    /// Generates a function definition from an objective-c signature to use as
    /// a class-type function definition.
    public func generateDefinitionSignature(from objcMethod: MethodDefinition) -> MethodGenerationIntention.Signature {
        var sign =
            MethodGenerationIntention
                .Signature(name: "",
                           returnType: ObjcType.id(protocols: []),
                           parameters: [])
        
        if let sel = objcMethod.methodSelector.selector {
            switch sel {
            case .selector(let s):
                sign.name = s.name
            case .keywords(let kw):
                break
            }
        }
        
        if let type = objcMethod.returnType.type.type {
            sign.returnType = type
        }
        
        return sign
    }
}
