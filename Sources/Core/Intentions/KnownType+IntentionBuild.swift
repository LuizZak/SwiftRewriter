import KnownType

extension KnownTypeBuilder {
    
    /// Returns a type generation intention built from this builder.
    /// Method and computed property bodies are left empty.
    internal func buildIntention() -> TypeGenerationIntention {
        let typeIntention: TypeGenerationIntention
        let type = self.build()
        
        switch type.kind {
        case .class:
            if type.isExtension {
                typeIntention = ClassExtensionGenerationIntention(typeName: type.typeName)
            } else {
                typeIntention = ClassGenerationIntention(typeName: type.typeName)
            }
            
        case .struct:
            typeIntention = StructGenerationIntention(typeName: type.typeName)
            
        case .enum:
            let rawValueType = type.knownTrait(KnownTypeTraits.enumRawValue)?.asSwiftType ?? .int
            typeIntention = EnumGenerationIntention(
                typeName: type.typeName,
                rawValueType: rawValueType
            )
            
        case .protocol:
            typeIntention = ProtocolGenerationIntention(typeName: type.typeName)
        }
        
        if let cls = typeIntention as? BaseClassIntention {
            for ivar in type.knownFields {
                let intent = InstanceVariableGenerationIntention(name: ivar.name,
                                                                 storage: ivar.storage)
                
                cls.addInstanceVariable(intent)
            }
        }
        if let cls = typeIntention as? ClassGenerationIntention {
            cls.superclassName = type.supertype?.asTypeName
        }
        for prop in type.knownProperties {
            let intent: PropertyGenerationIntention
            if type.kind == .protocol {
                intent = ProtocolPropertyGenerationIntention(name: prop.name,
                                                             type: prop.storage.type,
                                                             objcAttributes: prop.objcAttributes)
            } else {
                intent = PropertyGenerationIntention(name: prop.name,
                                                     type: prop.storage.type,
                                                     objcAttributes: prop.objcAttributes)
            }
            
            switch prop.accessor {
            case .getter:
                intent.mode = .computed(FunctionBodyIntention(body: []))
                
            case .getterAndSetter:
                intent.mode = .asField
            }
            
            intent.objcAttributes = prop.objcAttributes
            intent.knownAttributes = prop.knownAttributes
            
            typeIntention.addProperty(intent)
        }
        for method in type.knownMethods {
            let intent = MethodGenerationIntention(signature: method.signature)
            intent.knownAttributes = method.knownAttributes
            
            typeIntention.addMethod(intent)
        }
        for prot in type.knownProtocolConformances {
            let intent = ProtocolInheritanceIntention(protocolName: prot.protocolName)
            
            typeIntention.addProtocol(intent)
        }
        for ctor in type.knownConstructors {
            let intent = InitGenerationIntention(parameters: ctor.parameters)
            intent.isFallible = ctor.isFallible
            intent.isConvenience = ctor.isConvenience
        }
        
        typeIntention.knownTraits = type.knownTraits
        typeIntention.knownAttributes = type.knownAttributes
        
        return typeIntention
    }
    
}
