import Foundation
import SwiftRewriterLib
import SwiftAST
import GrammarModels

public class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    public init() {
        
    }
    
    @discardableResult
    public func createFileWithClass(
        named name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = { _ in }) -> IntentionCollectionBuilder {
        
        createFile(named: "\(name).swift") { builder in
            builder.createClass(withName: name, initializer: initializer)
        }
        
        return self
    }
    
    @discardableResult
    public func createFile(named name: String,
                           initializer: (FileIntentionBuilder) -> Void = { _ in }) -> IntentionCollectionBuilder {
        
        let builder = FileIntentionBuilder(fileNamed: name)
        
        initializer(builder)
        
        let file = builder.build()
        
        intentions.addIntention(file)
        
        return self
    }
    
    public func build(typeChecked: Bool = false) -> IntentionCollection {
        if typeChecked {
            let system = IntentionCollectionTypeSystem(intentions: intentions)
            
            let invoker =
                DefaultTypeResolverInvoker(
                    globals: ArrayDefinitionsSource(),
                    typeSystem: system,
                    numThreads: 8
                )
            
            invoker.resolveAllExpressionTypes(in: intentions, force: true)
        }
        
        return intentions
    }
}

public class FileIntentionBuilder {
    var inNonnullContext = false
    var intention: FileGenerationIntention
    
    public init(fileNamed name: String) {
        intention = FileGenerationIntention(sourcePath: name, targetPath: name)
    }
    
    @discardableResult
    public func createGlobalVariable(withName name: String,
                                     type: SwiftType,
                                     ownership: Ownership = .strong,
                                     isConstant: Bool = false,
                                     accessLevel: AccessLevel = .internal,
                                     initialExpression: Expression? = nil) -> FileIntentionBuilder {
        let storage =
            ValueStorage(type: type, ownership: ownership, isConstant: isConstant)
        
        return createGlobalVariable(withName: name,
                                    storage: storage,
                                    accessLevel: accessLevel,
                                    initialExpression: initialExpression)
    }
    
    @discardableResult
    public func createGlobalVariable(withName name: String,
                                     storage: ValueStorage,
                                     accessLevel: AccessLevel = .internal,
                                     initialExpression: Expression? = nil) -> FileIntentionBuilder {
        let varIntention =
            GlobalVariableGenerationIntention(name: name,
                                              storage: storage,
                                              accessLevel: accessLevel)
        
        varIntention.inNonnullContext = inNonnullContext
        
        if let initialExpression = initialExpression {
            varIntention.initialValueExpr =
                GlobalVariableInitialValueIntention(expression: initialExpression,
                                                    source: nil)
        }
        
        intention.addGlobalVariable(varIntention)
        
        return self
    }
    
    @discardableResult
    public func createGlobalFunction(withName name: String,
                                     returnType: SwiftType = .void,
                                     parameters: [ParameterSignature] = [],
                                     body: CompoundStatement? = nil) -> FileIntentionBuilder {
        let signature =
            FunctionSignature(name: name,
                              parameters: parameters,
                              returnType: returnType,
                              isStatic: true)
        
        return createGlobalFunction(withSignature: signature, body: body)
    }
    
    @discardableResult
    public func createGlobalFunction(withSignature signature: FunctionSignature,
                                     body: CompoundStatement? = nil) -> FileIntentionBuilder {
        let funcIntent =
            GlobalFunctionGenerationIntention(signature: signature)
        funcIntent.inNonnullContext = inNonnullContext
        
        if let body = body {
            funcIntent.functionBody = FunctionBodyIntention(body: body)
        }
        
        intention.addGlobalFunction(funcIntent)
        
        return self
    }
    
    @discardableResult
    public func createClass(
        withName name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = { _ in }) -> FileIntentionBuilder {
        
        let classIntention = ClassGenerationIntention(typeName: name)
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createTypealias(withName name: String, type: ObjcType) -> FileIntentionBuilder {
        let swiftType = DefaultTypeMapper().swiftType(forObjcType: type, context: .empty)
        
        return self.createTypealias(withName: name, swiftType: swiftType, type: type)
    }
    
    @discardableResult
    public func createTypealias(withName name: String,
                                swiftType: SwiftType,
                                type: ObjcType) -> FileIntentionBuilder {
        
        let intent = TypealiasIntention(originalObjcType: type,
                                        fromType: swiftType,
                                        named: name)
        
        intent.inNonnullContext = inNonnullContext
        
        intention.addTypealias(intent)
        
        return self
    }
    
    @discardableResult
    public func createExtension(
        forClassNamed name: String,
        categoryName: String? = nil,
        initializer: (TypeBuilder<ClassExtensionGenerationIntention>) -> Void = { _ in }) -> FileIntentionBuilder {
        
        let classIntention = ClassExtensionGenerationIntention(typeName: name)
        classIntention.categoryName = categoryName
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createProtocol(
        withName name: String,
        initializer: (TypeBuilder<ProtocolGenerationIntention>) -> Void = { _ in }) -> FileIntentionBuilder {
        
        let prot = ProtocolGenerationIntention(typeName: name)
        prot.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: prot, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createEnum(withName name: String, rawValue: SwiftType,
                           initializer: (EnumTypeBuilder) -> Void = { _ in }) -> FileIntentionBuilder {
        
        let enumIntention = EnumGenerationIntention(typeName: name, rawValueType: rawValue)
        enumIntention.inNonnullContext = inNonnullContext
        let builder = EnumTypeBuilder(targetEnum: enumIntention)
        
        initializer(builder)
        
        intention.addType(builder.build())
        
        return self
    }
    
    @discardableResult
    public func createStruct(
        withName name: String,
        initializer: (TypeBuilder<StructGenerationIntention>) -> Void = { _ in }) -> FileIntentionBuilder {
        
        let structIntention = StructGenerationIntention(typeName: name)
        structIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: structIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func beginNonnulContext() -> FileIntentionBuilder {
        inNonnullContext = true
        return self
    }
    
    @discardableResult
    public func endNonnullContext() -> FileIntentionBuilder {
        inNonnullContext = false
        return self
    }
    
    @discardableResult
    public func addPreprocessorDirective(_ directive: String) -> FileIntentionBuilder {
        intention.preprocessorDirectives.append(directive)
        
        return self
    }
    
    private func innerBuildTypeWithClosure<T>(
        type: T,
        initializer: (TypeBuilder<T>) -> Void) where T: TypeGenerationIntention {
        
        let builder = TypeBuilder(targetType: type)
        initializer(builder)
        intention.addType(builder.build())
    }
    
    public func build() -> FileGenerationIntention {
        return intention
    }
}

public class MemberBuilder<T: MemberGenerationIntention> {
    var targetMember: T
    
    public init(targetMember: T) {
        self.targetMember = targetMember
    }
    
    @discardableResult
    public func setAccessLevel(_ accessLevel: AccessLevel) -> MemberBuilder {
        targetMember.accessLevel = accessLevel
        return self
    }
    
    public func build() -> T {
        return targetMember
    }
}

public extension MemberBuilder where T: OverridableMemberGenerationIntention {
    @discardableResult
    public func setIsOverride(_ isOverride: Bool) -> MemberBuilder {
        targetMember.isOverride = isOverride
        return self
    }
}

public extension MemberBuilder where T: MethodGenerationIntention {
    @discardableResult
    public func addParameter(name: String, type: SwiftType) -> MemberBuilder {
        targetMember.signature.parameters.append(
            ParameterSignature(label: name, name: name, type: type)
        )
        
        return self
    }
    
    @discardableResult
    public func setBody(_ body: CompoundStatement) -> MemberBuilder {
        targetMember.functionBody = FunctionBodyIntention(body: body)
        
        return self
    }
    
    @discardableResult
    public func setIsStatic(_ isStatic: Bool) -> MemberBuilder {
        targetMember.signature.isStatic = isStatic
        
        return self
    }
}

public extension MemberBuilder where T: InitGenerationIntention {
    @discardableResult
    public func setBody(_ body: CompoundStatement) -> MemberBuilder {
        targetMember.functionBody = FunctionBodyIntention(body: body)
        
        return self
    }
}

public extension MemberBuilder where T: PropertyGenerationIntention {
    @discardableResult
    public func setAsComputedProperty(body: CompoundStatement) -> MemberBuilder {
        targetMember.mode = .computed(FunctionBodyIntention(body: body))
        
        return self
    }
}

public class TypeBuilder<T: TypeGenerationIntention> {
    var targetType: T
    
    public init(targetType: T) {
        self.targetType = targetType
    }
    
    @discardableResult
    public func createProperty(named name: String,
                               type: SwiftType,
                               attributes: [PropertyAttribute] = []) -> TypeBuilder {
        
        return createProperty(named: name, type: type, mode: .asField, attributes: attributes)
    }
    
    @discardableResult
    public func createProperty(named name: String,
                               type: SwiftType,
                               mode: PropertyGenerationIntention.Mode = .asField,
                               attributes: [PropertyAttribute] = [],
                               builder: (MemberBuilder<PropertyGenerationIntention>) -> Void = { _ in })
            -> TypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop = PropertyGenerationIntention(name: name,
                                               storage: storage,
                                               attributes: attributes)
        prop.mode = mode
        
        let mbuilder = MemberBuilder(targetMember: prop)
        
        builder(mbuilder)
        
        targetType.addProperty(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    public func createConstructor(withParameters parameters: [ParameterSignature] = [],
                                  builder: (MemberBuilder<InitGenerationIntention>) -> Void = { _ in }) -> TypeBuilder {
        
        let ctor = InitGenerationIntention(parameters: parameters)
        let mbuilder = MemberBuilder(targetMember: ctor)
        
        builder(mbuilder)
        
        targetType.addConstructor(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    public func createVoidMethod(
        named name: String, builder: (MemberBuilder<MethodGenerationIntention>) -> Void = { _ in }) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(named name: String,
                             returnType: SwiftType = .void,
                             parameters: [ParameterSignature] = [],
                             isStatic: Bool = false,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = { _ in }) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name,
                                          parameters: parameters,
                                          returnType: returnType,
                                          isStatic: isStatic)
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(_ signatureString: String,
                             isStatic: Bool = false,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = { _ in }) -> TypeBuilder {
        
        var signature = try! FunctionSignatureParser.parseSignature(from: signatureString)
        signature.isStatic = isStatic
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(_ signature: FunctionSignature,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = { _ in }) -> TypeBuilder {
        
        let method = MethodGenerationIntention(signature: signature)
        method.functionBody = FunctionBodyIntention(body: [])
        
        let mbuilder = MemberBuilder(targetMember: method)
        builder(mbuilder)
        
        targetType.addMethod(mbuilder.build())
        
        return self
    }
    
    public func build() -> T {
        return targetType
    }
}

public extension TypeBuilder where T: ClassExtensionGenerationIntention {
    
    /// Marks the target type for this type builder as an implementation for a
    /// category extension interface declaration.
    @discardableResult
    public func setAsCategoryImplementation(categoryName: String) -> TypeBuilder {
        targetType.source = ObjcClassCategoryInterface(isInNonnullContext: false)
        
        return self
    }
    
}

public extension TypeBuilder where T: InstanceVariableContainerIntention {
    @discardableResult
    public func createInstanceVariable(named name: String, type: SwiftType) -> TypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let ivar = InstanceVariableGenerationIntention(name: name, storage: storage)
        targetType.addInstanceVariable(ivar)
        
        return self
    }
}

public extension TypeBuilder where T: BaseClassIntention {
    
    /// Marks the target type for this type builder as coming from an interface
    /// declaration.
    @discardableResult
    public func setAsInterfaceSource() -> TypeBuilder {
        targetType.isInterfaceSource = true
        
        return self
    }
    
    /// Marks the target type for this type builder as coming from a category
    /// extension interface declaration.
    @discardableResult
    public func setAsCategoryInterfaceSource() -> TypeBuilder {
        targetType.isInterfaceSource = true
        
        return self
    }
    
    @discardableResult
    public func createConformance(protocolName: String) -> TypeBuilder {
        let prot = ProtocolInheritanceIntention(protocolName: protocolName)
        targetType.addProtocol(prot)
        
        return self
    }
    
    @discardableResult
    public func createSynthesize(propertyName: String, variableName: String? = nil) -> TypeBuilder {
        let intent =
            PropertySynthesizationIntention(
                propertyName: propertyName,
                ivarName: variableName ?? propertyName,
                isExplicit: false,
                type: .synthesize)
        
        targetType.addSynthesization(intent)
        
        return self
    }
}

public extension TypeBuilder where T: ClassGenerationIntention {
    @discardableResult
    public func inherit(from className: String) -> TypeBuilder {
        targetType.superclassName = className
        
        return self
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
