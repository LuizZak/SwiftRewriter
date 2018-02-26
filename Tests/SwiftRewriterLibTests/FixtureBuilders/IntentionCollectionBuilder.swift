import SwiftRewriterLib
import SwiftAST

class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    @discardableResult
    func createFile(named name: String, initializer: (FileIntentionBuilder) -> Void) -> IntentionCollectionBuilder {
        let builder = FileIntentionBuilder(fileNamed: name)
        
        initializer(builder)
        
        let file = builder.build()
        
        intentions.addIntention(file)
        
        return self
    }
    
    func build(typeChecked: Bool = false) -> IntentionCollection {
        if typeChecked {
            let system = IntentionCollectionTypeSystem(intentions: intentions)
            let resolver = ExpressionTypeResolver(typeSystem: system)
            
            let invoker = DefaultTypeResolverInvoker(typeResolver: resolver)
            
            invoker.resolveAllExpressionTypes(in: intentions)
        }
        
        return intentions
    }
}

class FileIntentionBuilder {
    var intention: FileGenerationIntention
    
    init(fileNamed name: String) {
        intention = FileGenerationIntention(sourcePath: name, filePath: name)
    }
    
    @discardableResult
    func createClass(withName name: String, initializer: (TypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        let classIntention = ClassGenerationIntention(typeName: name)
        let builder = TypeBuilder(targetType: classIntention)
        
        initializer(builder)
        
        let result = builder.build()
        
        intention.addType(result)
        
        return self
    }
    
    @discardableResult
    func createEnum(withName name: String, rawValue: SwiftType, initializer: (EnumTypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        let enumIntention = EnumGenerationIntention(typeName: name, rawValueType: rawValue)
        let builder = EnumTypeBuilder(targetEnum: enumIntention)
        
        initializer(builder)
        
        let result = builder.build()
        
        intention.addType(result)
        
        return self
    }
    
    func build() -> FileGenerationIntention {
        return intention
    }
}

class TypeBuilder {
    var targetType: TypeGenerationIntention
    
    init(targetType: TypeGenerationIntention) {
        self.targetType = targetType
    }
    
    @discardableResult
    func createProperty(named name: String, type: SwiftType) -> TypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop = PropertyGenerationIntention(name: name, storage: storage, attributes: [])
        
        targetType.addProperty(prop)
        
        return self
    }
    
    @discardableResult
    func createConstructor(withParameters parameters: [ParameterSignature] = []) -> TypeBuilder {
        let ctor = InitGenerationIntention(parameters: parameters)
        
        targetType.addConstructor(ctor)
        
        return self
    }
    
    @discardableResult
    func createVoidMethod(named name: String, bodyBuilder: () -> CompoundStatement = { () in [] }) -> TypeBuilder {
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createMethod(withSignature: signature, bodyBuilder: bodyBuilder)
    }
    
    @discardableResult
    func createMethod(withSignature signature: FunctionSignature, bodyBuilder: () -> CompoundStatement = { () in [] }) -> TypeBuilder {
        let body = bodyBuilder()
        
        let method = MethodGenerationIntention(signature: signature)
        method.functionBody = FunctionBodyIntention(body: body)
        
        targetType.addMethod(method)
        
        return self
    }
    
    func build() -> TypeGenerationIntention {
        return targetType
    }
}

class EnumTypeBuilder {
    var targetEnum: EnumGenerationIntention
    
    init(targetEnum: EnumGenerationIntention) {
        self.targetEnum = targetEnum
    }
    
    @discardableResult
    func createCase(name: String, expression: Expression? = nil) -> EnumTypeBuilder {
        let caseIntention = EnumCaseGenerationIntention(name: name, expression: expression)
        
        targetEnum.addCase(caseIntention)
        
        return self
    }
    
    func build() -> EnumGenerationIntention {
        return targetEnum
    }
}
