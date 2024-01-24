import SwiftAST
import Intentions
import KnownType

public class TypeBuilder<T: TypeGenerationIntention>: DeclarationBuilder<T> {
    var targetType: T {
        get {
            declaration
        }
        set {
            declaration = newValue
        }
    }
    
    public init(targetType: T) {
        super.init(declaration: targetType)
    }
    
    @discardableResult
    public func addHistory(tag: String, description: String) -> TypeBuilder {
        targetType.history.recordChange(tag: tag, description: description)
        return self
    }
    
    @discardableResult
    public func addComment(_ comment: SwiftComment) -> TypeBuilder {
        targetType.precedingComments.append(comment)
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [SwiftComment]) -> TypeBuilder {
        targetType.precedingComments.append(
            contentsOf: comments
        )
        return self
    }
    
    @discardableResult
    public func createConformance(protocolName: String) -> TypeBuilder {
        let prot = ProtocolInheritanceIntention(protocolName: protocolName)
        targetType.addProtocol(prot)
        
        return self
    }
    
    @discardableResult
    public func createProperty(
        named name: String,
        type: SwiftType,
        objcAttributes: [ObjcPropertyAttribute] = []
    ) -> TypeBuilder {
        
        createProperty(named: name, type: type, mode: .asField, objcAttributes: objcAttributes)
    }
    
    @discardableResult
    public func createProperty(
        named name: String,
        type: SwiftType,
        mode: PropertyGenerationIntention.Mode = .asField,
        objcAttributes: [ObjcPropertyAttribute] = [],
        builder: (PropertyBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop: PropertyGenerationIntention
        
        if targetType is ProtocolGenerationIntention {
            prop = ProtocolPropertyGenerationIntention(
                name: name,
                storage: storage,
                objcAttributes: objcAttributes
            )
        } else {
            prop = PropertyGenerationIntention(
                name: name,
                storage: storage,
                objcAttributes: objcAttributes
            )
        }
        
        prop.mode = mode
        
        let mbuilder = MemberBuilder(targetMember: prop)
        
        builder(mbuilder)
        
        targetType.addProperty(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    public func createConstructor(
        withParameters parameters: [ParameterSignature] = [],
        builder: (InitializerBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let ctor = InitGenerationIntention(
            parameters: parameters,
            builder: builder
        )
        
        targetType.addConstructor(ctor)
        
        return self
    }
    
    @discardableResult
    public func createVoidMethod(
        named name: String,
        builder: (MethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(
        named name: String,
        returnType: SwiftType = .void,
        parameters: [ParameterSignature] = [],
        isStatic: Bool = false,
        builder: (MethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let signature = FunctionSignature(
            name: name,
            parameters: parameters,
            returnType: returnType,
            isStatic: isStatic
        )
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(
        _ signatureString: String,
        isStatic: Bool = false,
        builder: (MethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        var signature = try! FunctionSignatureParser.parseSignature(from: signatureString)
        signature.isStatic = isStatic
        
        return createMethod(signature, builder: builder)
    }
    
    @discardableResult
    public func createMethod(
        _ signature: FunctionSignature,
        builder: (MethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let method: MethodGenerationIntention
        
        if targetType is ProtocolGenerationIntention {
            method = ProtocolMethodGenerationIntention(signature: signature)
        } else {
            method = MethodGenerationIntention(signature: signature) { bm in
                bm.setBody([])
                
                builder(bm)
            }
        }
        
        targetType.addMethod(method)
        
        return self
    }
    
    @discardableResult
    public func createSubscript(
        _ parameters: String,
        returnType: SwiftType,
        builder: (SubscriptBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let params = try! FunctionSignatureParser.parseParameters(from: parameters)
        
        return createSubscript(
            parameters: params,
            returnType: returnType,
            builder: builder
        )
    }
    
    @discardableResult
    public func createSubscript(
        parameters: [ParameterSignature],
        returnType: SwiftType,
        builder: (SubscriptBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let sub = SubscriptGenerationIntention(
            parameters: parameters,
            returnType: returnType,
            mode: .getter(FunctionBodyIntention(body: [])),
            builder: builder
        )
        
        targetType.addSubscript(sub)
        
        return self
    }
    
    public func build() -> T {
        targetType
    }
}

public extension TypeBuilder where T: ClassExtensionGenerationIntention {
    
    /// Marks the target type for this type builder as an implementation for a
    /// category extension interface declaration.
    @discardableResult
    func setAsCategoryImplementation(categoryName: String) -> TypeBuilder {
        targetType.categoryName = categoryName
        
        return self
    }
    
}

public extension TypeBuilder where T: InstanceVariableContainerIntention {
    @discardableResult
    func createInstanceVariable(named name: String, type: SwiftType) -> TypeBuilder {
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
    func setAsInterfaceSource() -> TypeBuilder {
        targetType.isInterfaceSource = true
        
        return self
    }
    
    @discardableResult
    func createSynthesize(propertyName: String, variableName: String? = nil) -> TypeBuilder {
        let intent =
            PropertySynthesizationIntention(
                propertyName: propertyName,
                ivarName: variableName ?? propertyName,
                isExplicit: false,
                type: .synthesize
            )
        
        targetType.addSynthesization(intent)
        
        return self
    }
    
    @discardableResult
    func createDeinit(builder: (DeinitBuilder) -> Void = emptyInit) -> TypeBuilder {
        
        let deinitIntention = DeinitGenerationIntention(builder: { bm in
            bm.setBody([])
            builder(bm)
        })
        
        targetType.deinitIntention = deinitIntention
        
        return self
    }
}

public extension TypeBuilder where T: ClassGenerationIntention {
    @discardableResult
    func inherit(from className: String) -> TypeBuilder {
        targetType.superclassName = className
        
        return self
    }

    @discardableResult
    func setIsFinal(_ isFinal: Bool) -> TypeBuilder {
        targetType.isFinal = isFinal

        return self
    }
}

public extension TypeBuilder where T: ClassExtensionGenerationIntention {
    /// Marks the target type for this type builder as coming from a category
    /// extension interface declaration.
    @discardableResult
    func setAsCategoryInterfaceSource() -> TypeBuilder {
        targetType.isInterfaceSource = true
        
        return self
    }
}

public extension TypeBuilder where T: ProtocolGenerationIntention {
    @discardableResult
    func createProtocolProperty(
        named name: String,
        type: SwiftType,
        mode: PropertyGenerationIntention.Mode = .asField,
        objcAttributes: [ObjcPropertyAttribute] = [],
        builder: (ProtocolPropertyBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let storage = ValueStorage(type: type, ownership: .strong, isConstant: false)
        
        let prop = ProtocolPropertyGenerationIntention(
            name: name,
            storage: storage,
            objcAttributes: objcAttributes
        )
        
        prop.mode = mode
        
        let mbuilder = MemberBuilder(targetMember: prop)
        
        builder(mbuilder)
        
        targetType.addProperty(mbuilder.build())
        
        return self
    }
    
    @discardableResult
    func createProtocolVoidMethod(
        named name: String,
        builder: (ProtocolMethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let signature = FunctionSignature(name: name, parameters: [])
        
        return createProtocolMethod(signature, builder: builder)
    }
    
    @discardableResult
    func createProtocolMethod(
        named name: String,
        returnType: SwiftType = .void,
        parameters: [ParameterSignature] = [],
        isStatic: Bool = false,
        builder: (ProtocolMethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let signature = FunctionSignature(
            name: name,
            parameters: parameters,
            returnType: returnType,
            isStatic: isStatic
        )
        
        return createProtocolMethod(signature, builder: builder)
    }
    
    @discardableResult
    func createProtocolMethod(
        _ signatureString: String,
        isStatic: Bool = false,
        builder: (ProtocolMethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        var signature = try! FunctionSignatureParser.parseSignature(from: signatureString)
        signature.isStatic = isStatic
        
        return createProtocolMethod(signature, builder: builder)
    }
    
    @discardableResult
    func createProtocolMethod(
        _ signature: FunctionSignature,
        builder: (ProtocolMethodBuilder) -> Void = emptyInit
    ) -> TypeBuilder {
        
        let method: MethodGenerationIntention
        
        method = ProtocolMethodGenerationIntention(signature: signature) { mb in
            builder(mb)
        }
        
        targetType.addMethod(method)
        
        return self
    }
}
