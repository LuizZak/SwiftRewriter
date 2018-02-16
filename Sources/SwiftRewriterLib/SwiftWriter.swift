import GrammarModels
import ObjcParser

/// Gets as inputs a series of intentions and outputs actual files and script
/// contents.
public class SwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let context = TypeContext()
    let typeMapper: TypeMapper
    var diagnostics: Diagnostics
    
    public var expressionPasses: [ExpressionPass] = []
    
    public init(intentions: IntentionCollection, diagnostics: Diagnostics, output: WriterOutput) {
        self.intentions = intentions
        self.diagnostics = diagnostics
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
        let protocols = fileIntent.protocolIntentions
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
        
        for prot in protocols {
            outputProtocol(prot, target: out)
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
        
        target.outputIdentation()
        target.outputInlineWithSpace("typealias", style: .keyword)
        target.outputInline(typeali.named, style: .keyword)
        target.outputInline(" = ")
        target.outputInline(typeName, style: .keyword)
    }
    
    private func outputVariableDeclaration(_ varDecl: GlobalVariableGenerationIntention, target: RewriterOutputTarget) {
        let name = varDecl.name
        let type = varDecl.type
        let initVal = varDecl.initialValueExpr
        let accessModifier = SwiftWriter._accessModifierFor(accessLevel: varDecl.accessLevel)
        let ownership = evaluateOwnershipPrefix(inType: type, global: varDecl)
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if !ownership.isEmpty {
            target.outputInlineWithSpace(ownership, style: .keyword)
        }
        
        target.outputInlineWithSpace(varOrLet, style: .keyword)
        
        target.outputInline(name, style: .plain)
        
        let ctx =
            TypeMapper.TypeMappingContext(explicitNullability: SwiftWriter._typeNullability(inType: type),
                                          inNonnull: varDecl.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        target.outputInline(": ")
        target.outputInline(typeName, style: .typeName)
        
        if let expression = initVal?.typedSource?.expression?.expression?.expression {
            target.outputInline(" = ")
            
            let rewriter = SwiftStmtRewriter(expressionPasses: expressionPasses)
            rewriter.rewrite(expression: expression, into: target)
        }
        
        target.outputLineFeed()
    }
    
    private func outputClass(_ cls: ClassGenerationIntention, target: RewriterOutputTarget) {
        target.outputIdentation()
        target.outputInlineWithSpace("class", style: .keyword)
        target.outputInline(cls.typeName, style: .typeName)
        
        // Figure out inheritance clauses
        var inheritances: [String] = []
        if let sup = cls.superclassName {
            inheritances.append(sup)
        }
        inheritances.append(contentsOf: cls.protocols.map { p in p.protocolName })
        
        if inheritances.count > 0 {
            target.outputInline(": ")
            
            for (i, inheritance) in inheritances.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                
                target.outputInline(inheritance, style: .typeName)
            }
        }
        
        // Start outputting class now
        target.outputInline(" ")
        target.outputInline("{")
        target.outputLineFeed()
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
    
    private func outputProtocol(_ prot: ProtocolGenerationIntention, target: RewriterOutputTarget) {
        target.outputIdentation()
        
        target.outputInlineWithSpace("@objc", style: .keyword)
        target.outputInlineWithSpace("protocol", style: .keyword)
        target.outputInlineWithSpace(prot.typeName, style: .typeName)
        target.outputInline("{")
        target.outputLineFeed()
        
        target.idented {
            for prop in prot.properties {
                outputProperty(prop, target: target)
            }
            
            if prot.properties.count > 0 && prot.methods.count > 0 {
                target.output(line: "")
            }
            
            for method in prot.methods {
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
        target.outputIdentation()
        
        let type = ivar.type
        
        let accessModifier = SwiftWriter._accessModifierFor(accessLevel: ivar.accessLevel)
        let ownership = evaluateOwnershipPrefix(inType: ivar.type, ivar: ivar)
        let varOrLet = SwiftWriter._varOrLet(fromType: type)
        
        let ctx =
            TypeMapper.TypeMappingContext(
                explicitNullability: SwiftWriter._typeNullability(inType: ivar.type) ?? .unspecified,
                inNonnull: ivar.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if !ownership.isEmpty {
            target.outputInlineWithSpace(ownership, style: .keyword)
        }
        target.outputInlineWithSpace(varOrLet, style: .keyword)
        target.outputInline(ivar.name)
        target.outputInline(": ")
        target.outputInline(typeName, style: .typeName)
        target.outputLineFeed()
    }
    
    private func outputProperty(_ prop: PropertyGenerationIntention, target: RewriterOutputTarget) {
        target.outputIdentation()
        
        let type = prop.type
        
        let accessModifier = SwiftWriter._accessModifierFor(accessLevel: prop.accessLevel)
        let ownership = evaluateOwnershipPrefix(inType: type, property: prop)
        let ctx =
            TypeMapper.TypeMappingContext(modifiers: prop.propertySource?.modifierList,
                                          inNonnull: prop.inNonnullContext)
        let typeName = typeMapper.swiftType(forObjcType: type, context: ctx)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if !ownership.isEmpty {
            target.outputInlineWithSpace(ownership, style: .keyword)
        }
        
        target.outputInlineWithSpace("var", style: .keyword)
        target.outputInline(prop.name, style: .plain)
        target.outputInline(": ")
        
        target.outputInline(typeName, style: .typeName)
        
        switch prop.mode {
        case .asField:
            target.outputLineFeed()
            break
        case .computed(let body):
            outputMethodBody(body, target: target)
        case let .property(getter, setter):
            target.outputInline(" ")
            target.outputInline("{")
            target.outputLineFeed()
            
            target.idented {
                target.outputIdentation()
                target.outputInline("get", style: .keyword)
                outputMethodBody(getter, target: target)
                
                target.outputIdentation()
                target.outputInline("set", style: .keyword)
                
                // Avoid emitting setter's default new value identifier
                if setter.valueIdentifier != "newValue" {
                    target.outputInline("(\(setter.valueIdentifier))")
                }
                
                outputMethodBody(setter.body, target: target)
            }
            
            target.output(line: "}")
        }
    }
    
    private func outputInitMethod(_ initMethod: MethodGenerationIntention, target: RewriterOutputTarget) {
        target.outputIdentation()
        
        let accessModifier = SwiftWriter._accessModifierFor(accessLevel: initMethod.accessLevel)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        
        target.outputInline("init", style: .keyword)
        
        generateParameters(for: initMethod.signature,
                           into: target,
                           inNonnullContext: initMethod.inNonnullContext)
        
        if let body = initMethod.body {
            outputMethodBody(body, target: target)
        } else if initMethod.parent is ClassGenerationIntention {
            // Class definitions _must_ have a method body, even if empty.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        } else {
            target.outputLineFeed()
        }
    }
    
    private func outputMethod(_ method: MethodGenerationIntention, target: RewriterOutputTarget) {
        target.outputIdentation()
        
        let accessModifier = SwiftWriter._accessModifierFor(accessLevel: method.accessLevel)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if method.isClassMethod {
            target.outputInlineWithSpace("static", style: .keyword)
        }
        
        target.outputInlineWithSpace("func", style: .keyword)
        
        let sign = method.signature
        
        target.outputInline(sign.name)
        
        generateParameters(for: method.signature,
                           into: target,
                           inNonnullContext: method.inNonnullContext)
        
        switch sign.returnType {
        case .void: // `-> Void` can be omitted for void functions.
            break
        default:
            target.outputInline(" -> ")
            let typeName =
                typeMapper.swiftType(forObjcType: sign.returnType,
                                     context: .init(explicitNullability: sign.returnTypeNullability,
                                                    inNonnull: method.inNonnullContext))
            
            target.outputInline(typeName, style: .typeName)
        }
        
        if let body = method.body {
            outputMethodBody(body, target: target)
        } else if method.parent is ClassGenerationIntention {
            // Class definitions _must_ have a method body, even if empty.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        } else {
            target.outputLineFeed()
        }
    }
    
    private func outputMethodBody(_ body: MethodBodyIntention, target: RewriterOutputTarget) {
        guard let stmt = body.typedSource?.statements else {
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
            
            return
        }
        
        let rewriter = SwiftStmtRewriter(expressionPasses: expressionPasses)
        rewriter.rewrite(compoundStatement: stmt, into: target)
    }
    
    private func generateParameters(for signature: MethodGenerationIntention.Signature,
                                    into target: RewriterOutputTarget,
                                    inNonnullContext: Bool = false) {
        
        target.outputInline("(")
        
        for (i, param) in signature.parameters.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            let typeName =
                typeMapper.swiftType(forObjcType: param.type,
                                     context: .init(explicitNullability: param.nullability,
                                                    inNonnull: inNonnullContext))
            
            if param.label != param.name {
                target.outputInlineWithSpace(param.label, style: .plain)
            }
            
            target.outputInline(param.name)
            target.outputInline(": ")
            target.outputInline(typeName, style: .typeName)
        }
        
        target.outputInline(")")
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
        case .qualified(_, let qualifiers),
             .specified(_, .qualified(_, let qualifiers)):
            if qualifiers.contains("const") {
                return "let"
            }
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
    
    public func evaluateOwnershipPrefix(inType type: ObjcType,
                                        property: PropertyGenerationIntention? = nil,
                                        global: GlobalVariableGenerationIntention? = nil,
                                        ivar: InstanceVariableGenerationIntention? = nil) -> String {
        var ownershipPrefix = ""
        var specifierContext = ""
        var specifierContextName = "specifier"
        
        switch type {
        case .specified(let specifiers, _):
            if specifiers.last == "__weak" {
                specifierContext = specifiers.last!
                ownershipPrefix = "weak"
            } else if specifiers.last == "__unsafe_unretained" {
                specifierContext = specifiers.last!
                ownershipPrefix = "unowned(unsafe)"
            } else {
                ownershipPrefix = ""
            }
        default:
            ownershipPrefix = ""
        }
        
        // Search in property
        if let property = property {
            if let modifiers = property.propertySource?.modifierList?.keywordModifiers {
                if modifiers.contains("weak") {
                    ownershipPrefix = "weak"
                    specifierContext = "weak"
                    specifierContextName = "ownership attribute"
                } else if modifiers.contains("unsafe_unretained") {
                    ownershipPrefix = "unowned(unsafe)"
                    specifierContext = "unsafe_unretained"
                    specifierContextName = "ownership attribute"
                } else if modifiers.contains("assign") {
                    ownershipPrefix = "unowned(unsafe)"
                    specifierContext = "assign"
                    specifierContextName = "ownership attribute"
                }
            }
        }
        
        if !ownershipPrefix.isEmpty && !type.isPointer {
            let name: String
            let location: SourceLocation?
            
            if let property = property {
                name = "Property '\(property.name)'"
                location = property.source?.location
            } else if let global = global {
                name = "Global variable '\(global.name)'"
                location = global.source?.location
            } else if let ivar = ivar {
                name = "Instance variable '\(ivar.name)'"
                location = ivar.source?.location
            } else {
                name = "Variable"
                location = nil
            }
            
            diagnostics.warning(
                "\(name) has \(specifierContextName) '\(specifierContext)' but is not a pointer type",
                location: location ?? .invalid)
            
            return ""
        }
        
        return ownershipPrefix
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
    
    public static func _accessModifierFor(accessLevel: AccessLevel, omitInternal: Bool = true) -> String {
        // In Swift, omitting the access level specifier infers 'internal', so we
        // allow the user to decide whether to omit the keyword here
        if omitInternal && accessLevel == .internal {
            return ""
        }
        
        return accessLevel.rawValue
    }
}
