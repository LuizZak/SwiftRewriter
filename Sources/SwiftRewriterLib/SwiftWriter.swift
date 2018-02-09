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
        var addSeparator = false
        
        for typeali in fileIntent.typealiasIntentions {
            outputTypealias(typeali, target: out)
            addSeparator = true
        }
        
        if addSeparator {
            out.output(line: "")
        }
        
        for varDef in fileIntent.globalVariableIntentions {
            outputVariableDeclaration(varDef, target: out)
            addSeparator = true
        }
        
        if addSeparator {
            out.output(line: "")
            addSeparator = false
        }
        
        for cls in classes {
            outputClass(cls, target: out)
        }
        
        out.onAfterOutput()
        
        file.close()
    }
    
    private func outputTypealias(_ typeali: TypealiasIntention, target: RewriterOutputTarget) {
        let ctx =
            TypeMapper.TypeMappingContext(explicitNullability: SwiftWriter._typeNullability(inType: typeali.fromType),
                                          inNonnull: typeali.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: typeali.fromType, context: ctx)
        
        target.output(line: "typealias \(typeali.named) = \(typeName)")
    }
    
    private func outputVariableDeclaration(_ varDecl: GlobalVariableGenerationIntention, target: RewriterOutputTarget) {
        let name = varDecl.name
        let type = varDecl.type
        let initVal = varDecl.initialValueExpr
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        
        var decl = varOrLet + " "
        decl = SwiftWriter._prependAccessModifier(in: decl, accessLevel: varDecl.accessLevel)
        
        decl += name
        
        let ctx =
            TypeMapper.TypeMappingContext(explicitNullability: SwiftWriter._typeNullability(inType: type),
                                          inNonnull: varDecl.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        decl += ": \(typeName)"
        
        if let initVal = initVal {
            decl += " = \(initVal.trimmingCharacters(in: .whitespaces))"
        }
        
        target.output(line: decl)
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
    }
    
    // TODO: See if we can reuse the PropertyGenerationIntention
    private func outputInstanceVar(_ ivar: InstanceVariableGenerationIntention, target: RewriterOutputTarget) {
        let type = ivar.type
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        
        var decl = _prependOwnership(in: varOrLet + " ", for: ivar.type)
        
        decl = SwiftWriter._prependAccessModifier(in: decl, accessLevel: ivar.accessLevel)
        
        let ctx =
            TypeMapper.TypeMappingContext(explicitNullability: SwiftWriter._typeNullability(inType: ivar.type) ?? .unspecified,
                                          inNonnull: ivar.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        decl += "\(ivar.name): \(typeName)"
        
        target.output(line: decl)
    }
    
    private func outputProperty(_ prop: PropertyGenerationIntention, target: RewriterOutputTarget) {
        let type = prop.type
        
        var decl = "var "
        
        /// Detect `weak` and `unowned` vars
        if let modifiers = prop.propertySource?.modifierList?.keywordModifiers {
            if modifiers.contains("weak") {
                decl = "weak \(decl)"
            } else if modifiers.contains("unsafe_unretained") || modifiers.contains("assign") {
                decl = "unowned(unsafe) \(decl)"
            }
        }
        
        decl = SwiftWriter._prependAccessModifier(in: decl, accessLevel: prop.accessLevel)
        
        let ctx =
            TypeMapper.TypeMappingContext(modifiers: prop.propertySource?.modifierList,
                                          inNonnull: prop.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        decl += "\(prop.name): \(typeName)"
        
        switch prop.mode {
        case .asField:
            target.output(line: decl)
            break
        case .computed(let body):
            decl += " {"
            
            target.output(line: decl)
            
            target.idented {
                outputMethodBody(body, target: target)
            }
            
            target.output(line: "}")
        case let .property(getter, setter):
            decl += " {"
            
            target.output(line: decl)
            
            target.idented {
                target.output(line: "get {")
                target.idented {
                    outputMethodBody(getter, target: target)
                }
                target.output(line: "}")
                target.output(line: "set {")
                target.idented {
                    outputMethodBody(setter, target: target)
                }
                target.output(line: "}")
            }
            
            target.output(line: "}")
        }
    }
    
    private func outputInitMethod(_ initMethod: MethodGenerationIntention, target: RewriterOutputTarget) {
        var decl = SwiftWriter._prependAccessModifier(in: "init", accessLevel: initMethod.accessLevel)
        
        decl += generateParameters(for: initMethod.signature,
                                   inNonnullContext: initMethod.inNonnullContext)
        
        decl += " {"
        
        target.output(line: decl)
        
        target.idented {
            if let body = initMethod.body {
                outputMethodBody(body, target: target)
            }
        }
        
        target.output(line: "}")
    }
    
    private func outputMethod(_ method: MethodGenerationIntention, target: RewriterOutputTarget) {
        var decl = "func "
        
        if method.isClassMethod {
            decl = "static " + decl
        }
        
        decl = SwiftWriter._prependAccessModifier(in: decl, accessLevel: method.accessLevel)
        
        let sign = method.signature
        
        decl += sign.name
        
        decl += generateParameters(for: method.signature,
                                   inNonnullContext: method.inNonnullContext)
        
        switch sign.returnType {
        case .void: // `-> Void` can be omitted for void functions.
            break
        default:
            decl += " -> "
            decl += typeMapper.swiftType(forObjcType: sign.returnType,
                                         context: .init(explicitNullability: sign.returnTypeNullability,
                                                        inNonnull: method.inNonnullContext))
        }
        
        decl += " {"
        
        target.output(line: decl)
        
        target.idented {
            if let body = method.body {
                outputMethodBody(body, target: target)
            }
        }
        
        target.output(line: "}")
    }
    
    private func outputMethodBody(_ body: MethodBodyIntention, target: RewriterOutputTarget) {
        // TODO: Convert and output Swift method body here.
        guard let stmt = body.typedSource?.statements else {
            return
        }
        
        let rewriter = SwiftStmtRewriter()
        rewriter.rewrite(stmt, into: target)
    }
    
    private func generateParameters(for signature: MethodGenerationIntention.Signature,
                                    inNonnullContext: Bool = false) -> String {
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
                                     context: .init(explicitNullability: param.nullability,
                                                    inNonnull: inNonnullContext))
        }
        
        decl += ")"
        
        return decl
    }
    
    private func _prependOwnership(in decl: String, for type: ObjcType) -> String {
        let pref = SwiftWriter._ownershipPrefix(inType: type)
        if pref.isEmpty {
            return decl
        }
        
        return "\(pref) \(decl)"
    }
    
    public static func _varOrLet(fromType type: ObjcType) -> String {
        switch type {
        case .specified(let specifiers, _):
            if specifiers.contains("const") {
                return "let"
            }
        default:
            break
        }
        
        return "var"
    }
    
    public static func _typeNullability(inType type: ObjcType) -> TypeNullability? {
        switch type {
        case .specified(let specifiers, let type):
            // Struct types are never null.
            if case .struct = type {
                return .nonnull
            }
            
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
    
    public static func _ownershipPrefix(inType type: ObjcType) -> String {
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
    
    public static func _prependAccessModifier(in decl: String, accessLevel: AccessLevel, omitInternal: Bool = true) -> String {
        // In Swift, omitting the access level specifier infers 'internal', so we
        // allow the user to decide whether to omit the keyword here
        if omitInternal && accessLevel == .internal {
            return decl
        }
        
        return "\(_accessModifierFor(accessLevel: accessLevel)) \(decl)"
    }
    
    public static func _accessModifierFor(accessLevel: AccessLevel) -> String {
        return accessLevel.rawValue
    }
}
