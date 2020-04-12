import GrammarModels
import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// An empty initializer used as default argument of initializer closure parameters
/// for `IntentionCollectionBuilder` and related classes.
///
/// Is effectively a no-op.
@inlinable
public func emptyInit<T>(_: T) {
    
}

public class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    public init() {
        
    }
    
    @discardableResult
    public func createFileWithClass(
        named name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit) -> IntentionCollectionBuilder {
        
        createFile(named: "\(name).swift") { builder in
            builder.createClass(withName: name, initializer: initializer)
        }
        
        return self
    }
    
    @discardableResult
    public func createFile(named name: String,
                           initializer: (FileIntentionBuilder) -> Void = emptyInit) -> IntentionCollectionBuilder {
        
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
    
    public static func makeFileIntention(fileName: String,
                                         _ builderBlock: (FileIntentionBuilder) -> Void) -> FileGenerationIntention {
        
        let builder = FileIntentionBuilder(fileNamed: fileName)
        
        builderBlock(builder)
        
        return builder.build()
    }
    
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
                              isStatic: false)
        
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
    public func createGlobalFunction(withName name: String,
                                     _ initialization: (FunctionBuilder<GlobalFunctionGenerationIntention>) -> Void) -> FileIntentionBuilder {
        
        var funcIntent = GlobalFunctionGenerationIntention(signature: FunctionSignature(name: name))
        funcIntent.inNonnullContext = inNonnullContext
        
        let builder = FunctionBuilder<GlobalFunctionGenerationIntention>(target: funcIntent)
        initialization(builder)
        
        funcIntent = builder.build()
        
        intention.addGlobalFunction(funcIntent)
        
        return self
    }
    
    @discardableResult
    public func createClass(
        withName name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
        initializer: (TypeBuilder<ClassExtensionGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
        let classIntention = ClassExtensionGenerationIntention(typeName: name)
        classIntention.categoryName = categoryName
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createProtocol(
        withName name: String,
        initializer: (TypeBuilder<ProtocolGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
        let prot = ProtocolGenerationIntention(typeName: name)
        prot.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: prot, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createEnum(withName name: String, rawValue: SwiftType,
                           initializer: (EnumTypeBuilder) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
        initializer: (TypeBuilder<StructGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
    public func isPrimary(_ isPrimary: Bool) -> FileIntentionBuilder {
        intention.isPrimary = isPrimary
        return self
    }
    
    @discardableResult
    public func addImportDirective(moduleName: String) -> FileIntentionBuilder {
        intention.importDirectives.append(moduleName)
        
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
        intention
    }
}

public protocol _FunctionBuilder {
    associatedtype FunctionType = FunctionIntention
    var target: FunctionType { get nonmutating set }
}

public extension _FunctionBuilder where FunctionType: MutableSignatureFunctionIntention {
    var signature: FunctionSignature { get { return target.signature } nonmutating set { target.signature = newValue } }
    
    @discardableResult
    func createSignature(_ builder: (FunctionSignatureBuilder) -> Void) -> Self {
        // Reset signature
        signature = FunctionSignature(name: signature.name)
        
        let b = FunctionSignatureBuilder(signature: signature)
        
        builder(b)
        
        target.signature = b.build()
        
        return self
    }
}

extension _FunctionBuilder where FunctionType: MutableFunctionIntention {
    @discardableResult
    public func setBody(_ body: CompoundStatement) -> Self {
        target.functionBody = FunctionBodyIntention(body: body)
        
        return self
    }
}

public class FunctionSignatureBuilder {
    var signature: FunctionSignature
    
    init(signature: FunctionSignature) {
        self.signature = signature
    }
    
    @discardableResult
    public func addParameter(name: String, type: SwiftType) -> FunctionSignatureBuilder {
        signature.parameters.append(
            ParameterSignature(label: nil, name: name, type: type)
        )
        
        return self
    }
    
    @discardableResult
    public func addParameter(label: String, name: String, type: SwiftType) -> FunctionSignatureBuilder {
        signature.parameters.append(
            ParameterSignature(label: label, name: name, type: type)
        )
        
        return self
    }
    
    @discardableResult
    public func setIsStatic(_ isStatic: Bool) -> FunctionSignatureBuilder {
        signature.isStatic = isStatic
        
        return self
    }
    
    @discardableResult
    public func setIsMutating(_ isMutating: Bool) -> FunctionSignatureBuilder {
        signature.isMutating = isMutating
        
        return self
    }
    
    @discardableResult
    public func setReturnType(_ type: SwiftType) -> FunctionSignatureBuilder {
        signature.returnType = type
        
        return self
    }
    
    func build() -> FunctionSignature {
        signature
    }
}

public class FunctionBuilder<T: FunctionIntention>: _FunctionBuilder {
    public var target: T
    
    init(target: T) {
        self.target = target
    }
    
    public func build() -> T {
        target
    }
}

public class MemberBuilder<T: MemberGenerationIntention> {
    var targetMember: T
    
    public init(targetMember: T) {
        self.targetMember = targetMember
    }
    
    @discardableResult
    public func addHistory(tag: String, description: String) -> MemberBuilder {
        targetMember.history.recordChange(tag: tag, description: description)
        
        return self
    }
    
    @discardableResult
    public func setAccessLevel(_ accessLevel: AccessLevel) -> MemberBuilder {
        targetMember.accessLevel = accessLevel
        return self
    }
    
    @discardableResult
    public func addSemantics<S: Sequence>(_ semantics: S) -> MemberBuilder where S.Element == Semantic {
        targetMember.semantics.formUnion(semantics)
        return self
    }
    
    @discardableResult
    public func addAnnotations(_ annotations: [String]) -> MemberBuilder {
        targetMember.annotations.append(contentsOf: annotations)
        return self
    }
    
    @discardableResult
    public func addAttributes(_ attributes: [KnownAttribute]) -> MemberBuilder {
        targetMember.knownAttributes.append(contentsOf: attributes)
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

public extension MemberBuilder where T: InitGenerationIntention {
    @discardableResult
    public func setIsConvenience(_ isConvenience: Bool) -> MemberBuilder {
        targetMember.isConvenience = isConvenience
        return self
    }
}

extension MemberBuilder: _FunctionBuilder where T: FunctionIntention {
    public typealias FunctionType = T
    
    public var target: FunctionType { get { return targetMember } set { targetMember = newValue }}
}

public extension MemberBuilder where T: MutableValueStorageIntention {
    @discardableResult
    public func setValueStorage(_ storage: ValueStorage) -> MemberBuilder {
        targetMember.storage = storage
        
        return self
    }
    
    @discardableResult
    public func setOwnership(_ ownership: Ownership) -> MemberBuilder {
        targetMember.storage.ownership = ownership
        
        return self
    }
    
    @discardableResult
    public func setStorageType(_ type: SwiftType) -> MemberBuilder {
        targetMember.storage.type = type
        
        return self
    }
    
    @discardableResult
    public func setIsConstant(_ isConstant: Bool) -> MemberBuilder {
        targetMember.storage.isConstant = isConstant
        
        return self
    }
    
    @discardableResult
    public func setInitialValue(_ expression: Expression?) -> MemberBuilder {
        targetMember.initialValue = expression
        
        return self
    }
}

public extension MemberBuilder where T: PropertyGenerationIntention {
    @discardableResult
    public func setAsField() -> MemberBuilder {
        targetMember.mode = .asField
        
        return self
    }
    
    @discardableResult
    public func setSetterAccessLevel(_ accessLevel: AccessLevel?) -> MemberBuilder {
        targetMember.setterAccessLevel = accessLevel
        
        return self
    }
    
    @discardableResult
    public func setAsComputedProperty(body: CompoundStatement) -> MemberBuilder {
        targetMember.mode = .computed(FunctionBodyIntention(body: body))
        
        return self
    }
    
    @discardableResult
    public func setAsGetterSetter(getter: CompoundStatement,
                                  setter: PropertyGenerationIntention.Setter) -> MemberBuilder {
        
        targetMember.mode = .property(get: FunctionBodyIntention(body: getter),
                                      set: setter)
        
        return self
    }
    
    @discardableResult
    public func setInitialValue(expression: Expression?) -> MemberBuilder {
        targetMember.mode = .computed(FunctionBodyIntention(body: []))
        
        return self
    }
    
    @discardableResult
    public func setIsStatic(_ isStatic: Bool) -> MemberBuilder {
        if isStatic {
            if !targetMember.attributes.contains(.attribute("class")) {
                targetMember.attributes.append(.attribute("class"))
            }
        } else {
            targetMember.attributes.removeAll(where: { $0 == .attribute("class") })
        }
        
        return self
    }
}

public class TypeBuilder<T: TypeGenerationIntention> {
    var targetType: T
    
    public init(targetType: T) {
        self.targetType = targetType
    }
    
    @discardableResult
    public func addHistory(tag: String, description: String) -> TypeBuilder {
        targetType.history.recordChange(tag: tag, description: description)
        
        return self
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
                               builder: (MemberBuilder<PropertyGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop: PropertyGenerationIntention
        
        if targetType is ProtocolGenerationIntention {
            prop = ProtocolPropertyGenerationIntention(name: name,
                                                       storage: storage,
                                                       attributes: attributes,
                                                       ownerTypeName: targetType.typeName)
        } else {
            prop = PropertyGenerationIntention(name: name,
                                               storage: storage,
                                               attributes: attributes,
                                               ownerTypeName: targetType.typeName)
        }
        
        prop.mode = mode
        
        let mbuilder = MemberBuilder(targetMember: prop)
        
        builder(mbuilder)
        
        targetType.addProperty(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    public func createConstructor(withParameters parameters: [ParameterSignature] = [],
                                  builder: (MemberBuilder<InitGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        let ctor = InitGenerationIntention(parameters: parameters, ownerTypeName: targetType.typeName)
        let mbuilder = MemberBuilder(targetMember: ctor)
        
        builder(mbuilder)
        
        targetType.addConstructor(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    public func createVoidMethod(
        named name: String, builder: (MemberBuilder<MethodGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(named name: String,
                             returnType: SwiftType = .void,
                             parameters: [ParameterSignature] = [],
                             isStatic: Bool = false,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name,
                                          parameters: parameters,
                                          returnType: returnType,
                                          isStatic: isStatic)
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(_ signatureString: String,
                             isStatic: Bool = false,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        var signature = try! FunctionSignatureParser.parseSignature(from: signatureString)
        signature.isStatic = isStatic
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(_ signature: FunctionSignature,
                             builder: (MemberBuilder<MethodGenerationIntention>) -> Void = emptyInit) -> TypeBuilder {
        
        let method: MethodGenerationIntention
        
        if targetType is ProtocolGenerationIntention {
            method = ProtocolMethodGenerationIntention(signature: signature, ownerTypeName: targetType.typeName)
        } else {
            method = MethodGenerationIntention(signature: signature, ownerTypeName: targetType.typeName)
        }
        
        if !(targetType is ProtocolGenerationIntention) {
            method.functionBody = FunctionBodyIntention(body: [])
        }
        
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
        targetType.categoryName = categoryName
        
        return self
    }
    
}

public extension TypeBuilder where T: InstanceVariableContainerIntention {
    @discardableResult
    public func createInstanceVariable(named name: String, type: SwiftType) -> TypeBuilder {
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let ivar = InstanceVariableGenerationIntention(name: name, storage: storage, ownerTypeName: targetType.typeName)
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
        let caseIntention = EnumCaseGenerationIntention(name: name, expression: expression, ownerTypeName: targetEnum.typeName)
        
        targetEnum.addCase(caseIntention)
        
        return self
    }
    
    public func build() -> EnumGenerationIntention {
        targetEnum
    }
}

// MARK: - Typealiases
public typealias PropertyBuilder = MemberBuilder<PropertyGenerationIntention>
public typealias InstanceVarBuilder = MemberBuilder<InstanceVariableGenerationIntention>
public typealias MethodBuilder = MemberBuilder<MethodGenerationIntention>
public typealias InitializerBuilder = MemberBuilder<InitGenerationIntention>

public extension MemberBuilder where T == PropertyGenerationIntention {
    public convenience init(name: String, type: SwiftType, ownerTypeName: String) {
        let prop = PropertyGenerationIntention(name: name, type: type, attributes: [],
                                               ownerTypeName: ownerTypeName)
        
        self.init(targetMember: prop)
    }
}

public extension PropertyGenerationIntention {
    public convenience init(name: String, type: SwiftType, ownerTypeName: String, builder: (PropertyBuilder) -> Void) {
        self.init(name: name, type: type, attributes: [], ownerTypeName: ownerTypeName)
        
        builder(PropertyBuilder(targetMember: self))
    }
}

public extension MethodGenerationIntention {
    public convenience init(name: String, ownerTypeName: String, builder: (MethodBuilder) -> Void) {
        self.init(signature: FunctionSignature(name: name), ownerTypeName: ownerTypeName)
        
        builder(MethodBuilder(targetMember: self))
    }
}

public extension InitGenerationIntention {
    public convenience init(ownerTypeName: String, builder: (InitializerBuilder) -> Void) {
        self.init(parameters: [], ownerTypeName: ownerTypeName)
        
        builder(InitializerBuilder(targetMember: self))
    }
}
