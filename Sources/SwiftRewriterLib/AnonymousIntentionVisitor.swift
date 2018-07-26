public class AnonymousIntentionVisitor {
    public var onVisitFile: ((FileGenerationIntention) -> Void)?
    public var onVisitGlobalVariable: ((GlobalVariableGenerationIntention) -> Void)?
    public var onVisitGlobalFunction: ((GlobalFunctionGenerationIntention) -> Void)?
    public var onVisitType: ((TypeGenerationIntention) -> Void)?
    public var onVisitInstanceVar: ((InstanceVariableGenerationIntention) -> Void)?
    public var onVisitMethod: ((MethodGenerationIntention) -> Void)?
    public var onVisitInitializer: ((InitGenerationIntention) -> Void)?
    public var onVisitProperty: ((PropertyGenerationIntention) -> Void)?
    
    public init() {
        
    }
    
    public func visit(intentions: IntentionCollection) {
        for file in intentions.fileIntentions() {
            visitFile(file)
        }
    }
    
    func visitFile(_ file: FileGenerationIntention) {
        onVisitFile?(file)
        
        for globalVar in file.globalVariableIntentions {
            visitGlobalVariable(globalVar)
        }
        for globalFunc in file.globalFunctionIntentions {
            visitGlobalFunction(globalFunc)
        }
        
        for type in file.typeIntentions {
            visitType(type)
        }
    }
    
    func visitGlobalVariable(_ global: GlobalVariableGenerationIntention) {
        onVisitGlobalVariable?(global)
    }
    
    func visitGlobalFunction(_ global: GlobalFunctionGenerationIntention) {
        onVisitGlobalFunction?(global)
    }
    
    func visitType(_ type: TypeGenerationIntention) {
        onVisitType?(type)
        
        if let cls = type as? BaseClassIntention {
            for ivar in cls.instanceVariables {
                visitInstanceVar(ivar)
            }
        }
        
        for property in type.properties {
            visitProperty(property)
        }
        
        for ctor in type.constructors {
            visitInitializer(ctor)
        }
        
        for method in type.methods {
            visitMethod(method)
        }
    }
    
    func visitInstanceVar(_ ivar: InstanceVariableGenerationIntention) {
        onVisitInstanceVar?(ivar)
    }
    
    func visitMethod(_ method: MethodGenerationIntention) {
        onVisitMethod?(method)
    }
    
    func visitInitializer(_ initializer: InitGenerationIntention) {
        onVisitInitializer?(initializer)
    }
    
    func visitProperty(_ property: PropertyGenerationIntention) {
        onVisitProperty?(property)
    }
}
