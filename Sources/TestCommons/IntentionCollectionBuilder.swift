import Foundation
import SwiftRewriterLib
import SwiftAST

public class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    public init() {
        
    }
    
    @discardableResult
    public func createFileWithClass(named name: String, initializer: (TypeBuilder) -> Void = { _ in }) -> IntentionCollectionBuilder {
        createFile(named: "\(name).swift") { builder in
            builder.createClass(withName: name, initializer: initializer)
        }
        
        return self
    }
    
    @discardableResult
    public func createFile(named name: String, initializer: (FileIntentionBuilder) -> Void) -> IntentionCollectionBuilder {
        let builder = FileIntentionBuilder(fileNamed: name)
        
        initializer(builder)
        
        let file = builder.build()
        
        intentions.addIntention(file)
        
        return self
    }
    
    public func build(typeChecked: Bool = false) -> IntentionCollection {
        if typeChecked {
            let system = IntentionCollectionTypeSystem(intentions: intentions)
            let resolver = ExpressionTypeResolver(typeSystem: system)
            
            let invoker = DefaultTypeResolverInvoker(typeResolver: resolver)
            
            invoker.resolveAllExpressionTypes(in: intentions)
        }
        
        return intentions
    }
}

public class FileIntentionBuilder {
    var intention: FileGenerationIntention
    
    public init(fileNamed name: String) {
        intention = FileGenerationIntention(sourcePath: name, targetPath: name)
    }
    
    @discardableResult
    public func createClass(withName name: String, initializer: (TypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        let classIntention = ClassGenerationIntention(typeName: name)
        let builder = TypeBuilder(targetType: classIntention)
        
        initializer(builder)
        
        intention.addType(builder.build())
        
        return self
    }
    
    @discardableResult
    public func createExtension(forClassNamed name: String, categoryName: String = "", initializer: (TypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        let classIntention = ClassExtensionGenerationIntention(typeName: name)
        let builder = TypeBuilder(targetType: classIntention)
        
        initializer(builder)
        
        intention.addType(builder.build())
        
        return self
    }
    
    @discardableResult
    public func createEnum(withName name: String, rawValue: SwiftType, initializer: (EnumTypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        let enumIntention = EnumGenerationIntention(typeName: name, rawValueType: rawValue)
        let builder = EnumTypeBuilder(targetEnum: enumIntention)
        
        initializer(builder)
        
        intention.addType(builder.build())
        
        return self
    }
    
    public func build() -> FileGenerationIntention {
        return intention
    }
}

public class TypeBuilder {
    var targetType: TypeGenerationIntention
    
    public init(targetType: TypeGenerationIntention) {
        self.targetType = targetType
    }
    
    @discardableResult
    public func createProperty(named name: String, type: SwiftType, attributes: [PropertyAttribute] = []) -> TypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop = PropertyGenerationIntention(name: name, storage: storage, attributes: attributes)
        
        targetType.addProperty(prop)
        
        return self
    }
    
    @discardableResult
    public func createConstructor(withParameters parameters: [ParameterSignature] = []) -> TypeBuilder {
        let ctor = InitGenerationIntention(parameters: parameters)
        
        targetType.addConstructor(ctor)
        
        return self
    }
    
    @discardableResult
    public func createVoidMethod(named name: String, bodyBuilder: () -> CompoundStatement = { () in [] }) -> TypeBuilder {
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createMethod(signature, bodyBuilder: bodyBuilder)
    }
    
    @discardableResult
    public func createMethod(named name: String,
                             returnType: SwiftType = .void,
                             parameters: [ParameterSignature] = [],
                             isStatic: Bool = false,
                             bodyBuilder: () -> CompoundStatement = { () in [] }) -> TypeBuilder {
        let signature = FunctionSignature(name: name, parameters: parameters, returnType: returnType, isStatic: isStatic)
        
        return createMethod(signature, bodyBuilder: bodyBuilder)
    }
    
    @discardableResult
    public func createMethod(_ signature: FunctionSignature, bodyBuilder: () -> CompoundStatement = { () in [] }) -> TypeBuilder {
        let body = bodyBuilder()
        
        let method = MethodGenerationIntention(signature: signature)
        method.functionBody = FunctionBodyIntention(body: body)
        
        targetType.addMethod(method)
        
        return self
    }
    
    public func build() -> TypeGenerationIntention {
        return targetType
    }
}

public class EnumTypeBuilder {
    var targetEnum: EnumGenerationIntention
    
    public init(targetEnum: EnumGenerationIntention) {
        self.targetEnum = targetEnum
    }
    
    @discardableResult
    public func createCase(name: String, expression: Expression? = nil) -> EnumTypeBuilder {
        let caseIntention = EnumCaseGenerationIntention(name: name, expression: expression)
        
        targetEnum.addCase(caseIntention)
        
        return self
    }
    
    public func build() -> EnumGenerationIntention {
        return targetEnum
    }
}
