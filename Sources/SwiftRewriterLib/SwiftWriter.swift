import GrammarModels

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
        let fileIntents = intentions.intentions(ofType: FileGenerationIntention.self)
        
        for file in fileIntents {
            outputFile(file)
        }
    }
    
    private func outputFile(_ fileIntent: FileGenerationIntention) {
        let file = output.createFile(path: fileIntent.filePath)
        let out = file.outputTarget()
        let classes = fileIntent.typeIntentions.compactMap { $0 as? ClassGenerationIntention }
        
        for cls in classes {
            outputClass(cls, target: out)
        }
        
        file.close()
    }
    
    private func outputClass(_ cls: ClassGenerationIntention, target: RewriterOutputTarget) {
        var classDecl: String = "class \(cls.typeName)"
        
        // Figure out inheritance clauses
        var inheritances: [String] = []
        if let sup = cls.superclassName {
            inheritances.append(sup)
        }
        inheritances.append(contentsOf: cls.protocols.map { p in p.protocolName })
        
        if inheritances.count > 0 {
            classDecl += ": \(inheritances.joined(separator: ", "))"
        }
        
        // Start outputting class now
        
        target.output(line: "\(classDecl) {")
        target.idented {
            for ivar in cls.instanceVariables {
                outputInstanceVar(ivar, target: target)
            }
            for prop in cls.properties {
                outputProperty(prop, target: target)
            }
            
            if (cls.instanceVariables.count > 0 || cls.properties.count > 0) && cls.methods.count > 0 {
                target.output(line: "")
            }
            
            for method in cls.methods {
                // Init methods are treated differently
                // TODO: Create a separate GenerationIntention entirely for init
                // methods and detect them during SwiftRewriter's parsing instead
                // of postponing to here.
                if method.signature.name == "init" {
                    outputInitMethod(method, target: target)
                } else {
                    outputMethod(method, target: target)
                }
            }
        }
        target.output(line: "}")
        target.onAfterOutput()
    }
    
    // TODO: See if we can reuse the PropertyGenerationIntention
    private func outputInstanceVar(_ ivar: InstanceVariableGenerationIntention, target: RewriterOutputTarget) {
        let type = ivar.type
        
        var decl = _prependOwnership(in: "var ", for: ivar.type)
        
        decl = _prependAccessModifier(in: decl, accessLevel: ivar.accessLevel)
        
        let ctx = TypeMapper.TypeMappingContext(explicitNullability: _typeNullability(inType: ivar.type) ?? .unspecified)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        decl += "\(ivar.name): \(typeName)"
        
        target.output(line: decl)
    }
    
    private func outputProperty(_ prop: PropertyGenerationIntention, target: RewriterOutputTarget) {
        let type = prop.type
        
        var decl = "var "
        
        /// Detect `weak` and `unowned` vars
        if let modifiers = prop.typedSource?.modifierList?.modifiers.map({ $0.name }) {
            if modifiers.contains("weak") {
                decl = "weak \(decl)"
            } else if modifiers.contains("unsafe_unretained") || modifiers.contains("assign") {
                decl = "unowned(unsafe) \(decl)"
            }
        }
        
        decl = _prependAccessModifier(in: decl, accessLevel: prop.accessLevel)
        
        let ctx = TypeMapper.TypeMappingContext(modifiers: prop.typedSource?.modifierList)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        decl += "\(prop.name): \(typeName)"
        
        target.output(line: decl)
    }
    
    private func outputInitMethod(_ initMethod: MethodGenerationIntention, target: RewriterOutputTarget) {
        var decl = _prependAccessModifier(in: "init", accessLevel: initMethod.accessLevel)
        
        decl += generateParameters(for: initMethod.signature)
        
        decl += " {"
        
        target.output(line: decl)
        
        target.idented {
            // TODO: Output method body here.
            outputMethodBody(initMethod, target: target)
        }
        
        target.output(line: "}")
    }
    
    private func outputMethod(_ method: MethodGenerationIntention, target: RewriterOutputTarget) {
        var decl = _prependAccessModifier(in: "func ", accessLevel: method.accessLevel)
        if method.accessLevel != .internal {
            
        }
        
        let sign = method.signature
        
        decl += sign.name
        
        decl += generateParameters(for: method.signature)
        
        switch sign.returnType {
        case .void: // `-> Void` can be omitted for void functions.
            break
        default:
            decl += " -> "
            decl += typeMapper.swiftType(forObjcType: sign.returnType,
                                         context: .init(explicitNullability: sign.returnTypeNullability))
        }
        
        decl += " {"
        
        target.output(line: decl)
        
        target.idented {
            // TODO: Output method body here.
            outputMethodBody(method, target: target)
        }
        
        target.output(line: "}")
    }
    
    private func outputMethodBody(_ method: MethodGenerationIntention, target: RewriterOutputTarget) {
        
    }
    
    private func generateParameters(for signature: MethodGenerationIntention.Signature) -> String {
        var decl = "("
        
        for (i, param) in signature.parameters.enumerated() {
            if i > 0 {
                decl += ", "
            }
            
            if param.label != param.name {
                decl += param.label
                decl += " "
            }
            
            decl += "\(param.name): "
            
            decl +=
                typeMapper.swiftType(forObjcType: param.type,
                                     context: .init(explicitNullability: param.nullability))
        }
        
        decl += ")"
        
        return decl
    }
    
    private func _prependOwnership(in decl: String, for type: ObjcType) -> String {
        let pref = _ownershipPrefix(inType: type)
        if pref.isEmpty {
            return decl
        }
        
        return "\(pref) \(decl)"
    }
    
    private func _typeNullability(inType type: ObjcType) -> TypeNullability? {
        switch type {
        case .specified(let specifiers, _):
            if specifiers.last == "__weak" {
                return .nullable
            } else if specifiers.last == "__unsafe_unretained" {
                return .nonnull
            }
            
            return nil
        default:
            return nil
        }
    }
    
    private func _ownershipPrefix(inType type: ObjcType) -> String {
        switch type {
        case .specified(let specifiers, _):
            if specifiers.last == "__weak" {
                return "weak"
            } else if specifiers.last == "__unsafe_unretained" {
                return "unowned(unsafe)"
            }
            
            return ""
        default:
            return ""
        }
    }
    
    private func _prependAccessModifier(in decl: String, accessLevel: AccessLevel, omitInternal: Bool = true) -> String {
        // In Swift, omitting the access level specifier infers 'internal', so we
        // allow the user to decide whether to omit the keyword here
        if omitInternal && accessLevel == .internal {
            return decl
        }
        
        return "\(_accessModifierFor(accessLevel: accessLevel)) \(decl)"
    }
    
    private func _accessModifierFor(accessLevel: AccessLevel) -> String {
        return accessLevel.rawValue
    }
}
