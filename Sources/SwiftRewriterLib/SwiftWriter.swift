import Foundation
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import SwiftAST
import Utils

/// Gets as inputs a series of intentions and outputs actual files and script
/// contents.
public final class SwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let typeMapper: TypeMapper
    var diagnostics: Diagnostics
    var options: ASTWriterOptions
    let typeSystem: TypeSystem
    
    public init(intentions: IntentionCollection,
                options: ASTWriterOptions,
                diagnostics: Diagnostics,
                output: WriterOutput,
                typeMapper: TypeMapper,
                typeSystem: TypeSystem) {
        
        self.intentions = intentions
        self.options = options
        self.diagnostics = diagnostics
        self.output = output
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
    }
    
    public func execute() {
        let cacheableTypeSystem = typeSystem as? DefaultTypeSystem
        cacheableTypeSystem?.makeCache()
        defer {
            cacheableTypeSystem?.tearDownCache()
        }
        
        var unique = Set<String>()
        let fileIntents = intentions.fileIntentions()
        
        var errors: [(String, Error)] = []
        
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = options.numThreads
        
        for file in fileIntents {
            if unique.contains(file.targetPath) {
                print("""
                    Found duplicated file intent to save to path \(file.targetPath).
                    This usually means an original .h/.m source pairs could not be \
                    properly reduced to a single .swift file.
                    """)
                continue
            }
            unique.insert(file.targetPath)
            
            let writer
                = InternalSwiftWriter(
                    intentions: intentions,
                    options: options,
                    diagnostics: Diagnostics(),
                    output: output,
                    typeMapper: typeMapper,
                    typeSystem: typeSystem)
            
            queue.addOperation {
                autoreleasepool {
                    do {
                        try writer.outputFile(file)
                        
                        synchronized(self) {
                            self.diagnostics.merge(with: writer.diagnostics)
                        }
                    } catch {
                        synchronized(self) {
                            errors.append((file.targetPath, error))
                        }
                    }
                }
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
        for error in errors {
            self.diagnostics.error("Error while saving file \(error.0): \(error.1)",
                                   location: .invalid)
        }
    }
}

class InternalSwiftWriter {
    var intentions: IntentionCollection
    var output: WriterOutput
    let typeMapper: TypeMapper
    var diagnostics: Diagnostics
    var options: ASTWriterOptions
    let astWriter: SwiftASTWriter
    let typeSystem: TypeSystem
    
    init(intentions: IntentionCollection,
         options: ASTWriterOptions,
         diagnostics: Diagnostics,
         output: WriterOutput,
         typeMapper: TypeMapper,
         typeSystem: TypeSystem) {
        
        self.intentions = intentions
        self.options = options
        self.diagnostics = diagnostics
        self.output = output
        self.typeMapper = typeMapper
        self.typeSystem = typeSystem
        astWriter =
            SwiftASTWriter(options: options, typeMapper: typeMapper,
                           typeSystem: typeSystem)
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention) throws {
        let target = try output.createFile(path: fileIntent.targetPath)
        
        outputFile(fileIntent, targetFile: target)
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention, targetFile: FileOutput) {
        let out = targetFile.outputTarget()
        
        outputFile(fileIntent, out: out)
        
        targetFile.close()
    }
    
    func outputFile(_ fileIntent: FileGenerationIntention, out: RewriterOutputTarget) {
        let classes = fileIntent.typeIntentions.compactMap { $0 as? ClassGenerationIntention }
        let classExtensions = fileIntent.typeIntentions.compactMap { $0 as? ClassExtensionGenerationIntention }
        let structs = fileIntent.typeIntentions.compactMap { $0 as? StructGenerationIntention }
        let protocols = fileIntent.protocolIntentions
        
        /// Iterates a given list of items on a given block, appending an extra
        /// empty line if the element count of the list of `> 0`.
        func iterateWriting<T>(_ elements: [T], do block: (T) -> Void) {
            for item in elements {
                block(item)
            }
            
            if !elements.isEmpty {
                out.output(line: "")
            }
        }
        
        // Output imports
        outputImports(fileIntent.importDirectives, target: out)
        
        outputPreprocessorDirectives(fileIntent.preprocessorDirectives, target: out)
        
        iterateWriting(fileIntent.typealiasIntentions) { typeali in
            outputTypealias(typeali, target: out)
        }
        
        iterateWriting(fileIntent.enumIntentions) { en in
            outputEnum(en, target: out)
        }
        
        iterateWriting(structs) { str in
            outputStruct(str, target: out)
        }
        
        iterateWriting(fileIntent.globalVariableIntentions) { varDef in
            outputVariableDeclaration(varDef, target: out)
        }
        
        iterateWriting(fileIntent.globalFunctionIntentions) { funcDef in
            outputFunctionDeclaration(funcDef, target: out)
        }
        
        iterateWriting(protocols) { prot in
            outputProtocol(prot, target: out)
        }
        
        iterateWriting(classes) { cls in
            outputClass(cls, target: out)
        }
        
        iterateWriting(classExtensions) { cls in
            outputClassExtension(cls, target: out)
        }
        
        out.onAfterOutput()
    }
    
    func outputImports(_ imports: [String], target: RewriterOutputTarget) {
        if imports.isEmpty {
            return
        }
        
        for lib in imports {
            target.outputIdentation()
            target.outputInlineWithSpace("import", style: .keyword)
            target.outputInline(lib)
            target.outputLineFeed()
        }
    }
    
    func outputPreprocessorDirectives(_ preproc: [String], target: RewriterOutputTarget) {
        if preproc.isEmpty {
            return
        }
        
        target.output(line: "// Preprocessor directives found in file:", style: .comment)
        for pre in preproc {
            target.output(line: "// \(pre)", style: .comment)
        }
    }
    
    func outputTypealias(_ typeali: TypealiasIntention, target: RewriterOutputTarget) {
        let typeName = typeMapper.typeNameString(for: typeali.fromType)
        
        // typealias <Type1> = <Type2>
        target.outputIdentation()
        target.outputInlineWithSpace("typealias", style: .keyword)
        target.outputInline(typeali.name, style: .keyword)
        target.outputInline(" = ")
        target.outputInline(typeName, style: .keyword)
        target.outputLineFeed()
    }
    
    func outputEnum(_ intention: EnumGenerationIntention, target: RewriterOutputTarget) {
        let rawTypeName = typeMapper.typeNameString(for: intention.rawValueType)
        
        // [@objc] enum <Name>: <RawValue> {
        target.outputIdentation()
        if options.emitObjcCompatibility {
            target.outputInlineWithSpace("@objc", style: .keyword)
        }
        target.outputInlineWithSpace("enum", style: .keyword)
        target.outputInline(intention.typeName, style: .typeName)
        target.outputInline(": ")
        target.outputInlineWithSpace(rawTypeName, style: .typeName)
        target.outputInline("{")
        target.outputLineFeed()
        
        target.idented {
            for cs in intention.cases {
                // case <case> [= <value>]
                target.outputIdentation()
                target.outputInlineWithSpace("case", style: .keyword)
                target.outputInline(cs.name)
                
                if let exp = cs.expression {
                    target.outputInline(" = ")
                    astWriter.write(expression: exp, into: target)
                }
                target.outputLineFeed()
            }
        }
        
        target.output(line: "}")
    }
    
    func outputStruct(_ str: StructGenerationIntention, target: RewriterOutputTarget) {
        target.outputInlineWithSpace("struct", style: .keyword)
        target.outputInline(str.typeName, style: .typeName)
        
        outputTypeBodyCommon(str, target: target)
    }
    
    func outputVariableDeclaration(_ varDecl: GlobalVariableGenerationIntention,
                                   target: RewriterOutputTarget) {
        let name = varDecl.name
        let type = varDecl.type
        let initVal = varDecl.initialValueExpr
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: varDecl.accessLevel)
        let ownership = varDecl.ownership
        let varOrLet = varDecl.isConstant ? "let" : "var"
        let typeName = typeMapper.typeNameString(for: type)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if ownership != .strong {
            // Check for non-pointers
            if let original = varDecl.variableSource?.type?.type, !original.isPointer {
                diagnostics.warning("""
                    Variable '\(name)' specified as '\(ownership.rawValue)' \
                    but original type '\(original)' is not a pointer type.
                    """, location: varDecl.variableSource?.location ?? .invalid)
            } else {
                target.outputInlineWithSpace(ownership.rawValue, style: .keyword)
            }
        }
        
        target.outputInlineWithSpace(varOrLet, style: .keyword)
        target.outputInline(name, style: .plain)
        target.outputInline(": ")
        target.outputInline(typeName, style: .typeName)
        
        if let expression = initVal?.expression {
            target.outputInline(" = ")
            
            let rewriter =
                SwiftASTWriter(options: options, typeMapper: typeMapper,
                               typeSystem: typeSystem)
            
            rewriter.write(expression: expression, into: target)
        }
        
        target.outputLineFeed()
    }
    
    func outputFunctionDeclaration(_ funcDef: GlobalFunctionGenerationIntention, target: RewriterOutputTarget) {
        let accessModifier =
            InternalSwiftWriter._accessModifierFor(accessLevel: funcDef.accessLevel)
        
        // '<access modifier> func' ...
        target.outputIdentation()
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        target.outputInlineWithSpace("func", style: .keyword)
        
        // ... '<name>(<params>)' ...
        target.outputInline(funcDef.name)
        
        outputParameters(funcDef.signature.parameters, into: target,
                         inNonnullContext: funcDef.inNonnullContext)
        
        // ... ' -> <return type>' (only if not void) ...
        if funcDef.signature.returnType != .void {
            let returnTypeName =
                typeMapper.typeNameString(for: funcDef.signature.returnType)
            target.outputInline(" -> ")
            target.outputInline(returnTypeName, style: .typeName)
        }
        
        // ... '{ <function body> }'
        if let body = funcDef.functionBody {
            outputMethodBody(body, target: target)
        } else {
            // Global functions _must_ have a body.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        }
    }
    
    func outputClassExtension(_ cls: ClassExtensionGenerationIntention, target: RewriterOutputTarget) {
        outputHistory(for: cls, target: target)
        
        if let categoryName = cls.categoryName, !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            target.output(line: "// MARK: - \(categoryName)", style: .comment)
        } else {
            target.output(line: "// MARK: -", style: .comment)
        }
        if options.emitObjcCompatibility {
            target.output(line: "@objc", style: .keyword)
        }
        target.outputIdentation()
        target.outputInlineWithSpace("extension", style: .keyword)
        target.outputInline(cls.typeName, style: .typeName)
        
        outputTypeBodyCommon(cls, target: target)
    }
    
    func outputClass(_ cls: ClassGenerationIntention, target: RewriterOutputTarget) {
        outputHistory(cls.history, target: target)
        
        if options.emitObjcCompatibility {
            target.output(line: "@objc", style: .keyword)
        }
        target.outputIdentation()
        target.outputInlineWithSpace("class", style: .keyword)
        target.outputInline(cls.typeName, style: .typeName)
        
        outputTypeBodyCommon(cls, target: target)
    }
    
    func outputTypeBodyCommon(_ type: TypeGenerationIntention, target: RewriterOutputTarget) {
        // Figure out inheritance clauses
        var inheritances: [String] = []
        if let cls = type as? ClassGenerationIntention {
            if let sup = cls.superclassName {
                inheritances.append(sup)
            } else if options.emitObjcCompatibility {
                // Always inherit from NSObject, at least, in Objective-C
                // compatibility mode.
                inheritances.append("NSObject")
            }
        }
        
        inheritances.append(contentsOf: type.protocols.map { p in p.protocolName })
        
        if !inheritances.isEmpty {
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
            var hasFieldsOrProperties = false
            if let ivarContainer = type as? InstanceVariableContainerIntention {
                for ivar in ivarContainer.instanceVariables {
                    outputInstanceVar(ivar, target: target)
                    hasFieldsOrProperties = true
                }
            }
            for prop in type.properties {
                outputProperty(prop, selfType: type, target: target)
                hasFieldsOrProperties = true
            }
            
            if hasFieldsOrProperties && (!type.constructors.isEmpty || !type.methods.isEmpty) {
                target.output(line: "")
            }
            
            // Output initializers
            for ctor in type.constructors {
                outputInitMethod(ctor, selfType: type, target: target)
            }
            
            for method in type.methods {
                // Dealloc methods are treated differently
                // TODO: Create a separate GenerationIntention entirely for dealloc
                // methods and detect them during SwiftRewriter's parsing with
                // IntentionPass's instead of postponing to here.
                if method.signature.name == "dealloc" && method.signature.parameters.isEmpty {
                    outputDeinit(method, selfType: type, target: target)
                } else {
                    outputMethod(method, selfType: type, target: target)
                }
            }
        }
        
        target.output(line: "}")
    }
    
    func outputProtocol(_ prot: ProtocolGenerationIntention, target: RewriterOutputTarget) {
        // Figure out inheritance clauses
        var inheritances: [String] = []
        inheritances.append(contentsOf: prot.protocols.map { p in p.protocolName })
        
        var emitObjcAttribute = false
        
        if prot.methods.contains(where: { $0.optional })
            || prot.properties.contains(where: { $0.optional }) {
            
            emitObjcAttribute = true
        }
        
        if emitObjcAttribute || options.emitObjcCompatibility {
            // Always inherit form NSObjectProtocol in Objective-C compatibility mode
            if !inheritances.contains("NSObjectProtocol") {
                inheritances.insert("NSObjectProtocol", at: 0)
            }
            
            emitObjcAttribute = true
        } else {
            inheritances.removeAll(where: { $0 == "NSObjectProtocol" })
        }
        
        if emitObjcAttribute {
            target.output(line: "@objc", style: .keyword)
        }
        
        target.outputIdentation()
        target.outputInlineWithSpace("protocol", style: .keyword)
        target.outputInline(prot.typeName, style: .typeName)
        
        if !inheritances.isEmpty {
            target.outputInline(": ")
            
            for (i, inheritance) in inheritances.enumerated() {
                if i > 0 {
                    target.outputInline(", ")
                }
                
                target.outputInline(inheritance, style: .typeName)
            }
        }
        
        target.outputInline(" ")
        target.outputInline("{")
        target.outputLineFeed()
        
        target.idented {
            for prop in prot.properties {
                outputProperty(prop, selfType: prot, target: target)
            }
            
            if !prot.properties.isEmpty && !prot.methods.isEmpty {
                target.output(line: "")
            }
            
            for ctor in prot.constructors {
                outputInitMethod(ctor, selfType: prot, target: target)
            }
            
            for method in prot.methods {
                outputMethod(method, selfType: prot, target: target)
            }
        }
        
        target.output(line: "}")
    }
    
    // TODO: See if we can reuse outputVariableDeclaration
    func outputInstanceVar(_ ivar: InstanceVariableGenerationIntention, target: RewriterOutputTarget) {
        outputHistory(for: ivar, target: target)
        
        target.outputIdentation()
        
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: ivar.accessLevel)
        let varOrLet = ivar.isConstant ? "let" : "var"
        
        let typeName = typeMapper.typeNameString(for: ivar.type)
        
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if ivar.ownership != .strong {
            // Check for non-pointers
            if let original = ivar.typedSource?.type?.type, !original.isPointer {
                diagnostics.warning("""
                    Ivar '\(ivar.name)' specified as '\(ivar.ownership.rawValue)' \
                    but original type '\(original)' is not a pointer type.
                    """, location: ivar.typedSource?.location ?? .invalid)
            } else {
                target.outputInlineWithSpace(ivar.ownership.rawValue, style: .keyword)
            }
        }
        
        target.outputInlineWithSpace(varOrLet, style: .keyword)
        target.outputInline(ivar.name)
        target.outputInline(": ")
        target.outputInline(typeName, style: .typeName)
        
        // Structs don't require init-to-zero
        if ivar.type?.kind != .struct {
            outputInitialZeroValueForType(ivar.type, isConstant: ivar.isConstant,
                                          target: target)
        }
        
        target.outputLineFeed()
    }
    
    func outputProperty(_ prop: PropertyGenerationIntention,
                        selfType: KnownType,
                        target: RewriterOutputTarget) {
        
        outputHistory(for: prop, target: target)
        
        target.outputIdentation()
        
        if options.emitObjcCompatibility {
            target.outputInlineWithSpace("@objc", style: .keyword)
        }
        
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: prop.accessLevel)
        let typeName = typeMapper.typeNameString(for: prop.type)
        
        // Emit setter visibility level (only if setter is less visible than property)
        if let setterLevel = prop.setterAccessLevel, prop.accessLevel.isMoreVisible(than: setterLevel) {
            let setter =
                InternalSwiftWriter._accessModifierFor(accessLevel: setterLevel,
                                                       omitInternal: false)
            
            target.outputInlineWithSpace("\(setter)(set)", style: .keyword)
        }
        
        // Visibility level
        if !accessModifier.isEmpty {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        
        if prop.ownership != .strong {
            // Check for non-pointers
            if let original = prop.propertySource?.type?.type, !original.isPointer {
                diagnostics.warning("""
                    Property '\(prop.name)' specified as '\(prop.ownership.rawValue)' \
                    but original type '\(original)' is not a pointer type.
                    """, location: prop.propertySource?.location ?? .invalid)
            } else {
                target.outputInlineWithSpace(prop.ownership.rawValue, style: .keyword)
            }
        }
        if prop.isClassProperty {
            target.outputInlineWithSpace("static", style: .keyword)
        }
        
        if prop.isOverride {
            target.outputInlineWithSpace("override", style: .keyword)
        }
        
        target.outputInlineWithSpace("var", style: .keyword)
        target.outputInline(prop.name, style: .plain)
        target.outputInline(": ")
        
        target.outputInline(typeName, style: .typeName)
        
        // Protocol variables require get/set specifiers
        if prop.type is ProtocolGenerationIntention {
            target.outputInline(" ") // Space after type
            target.outputInline("{ ")
            if prop.isReadOnly {
                target.outputInlineWithSpace("get", style: .keyword)
            } else {
                target.outputInlineWithSpace("get", style: .keyword)
                target.outputInlineWithSpace("set", style: .keyword)
            }
            
            target.outputInline("}")
            target.outputLineFeed()
            
            return
        }
        
        switch prop.mode {
        case .asField:
            outputInitialZeroValueForType(prop.type, isConstant: prop.isConstant,
                                          target: target)
            target.outputLineFeed()
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
    
    // TODO: Maybe this should be extracted to an external `IntentionPass`?
    func outputInitialZeroValueForType(_ type: SwiftType,
                                       isConstant: Bool,
                                       target: RewriterOutputTarget) {
        
        // Don't emit `nil` values for non-constant fields, since Swift assumes
        // the initial value of these values to be nil already.
        // We need to emit `nil` in case of constants since 'let's don't do that
        // implicit initialization
        if type.isOptional && !isConstant {
            return
        }
        
        guard let defaultValue = typeSystem.defaultValue(for: type) else {
            return
        }
        
        target.outputInline(" = ")
        
        let writer =
            SwiftASTWriter(options: options, typeMapper: typeMapper,
                           typeSystem: typeSystem)
        writer.write(expression: defaultValue, into: target)
    }
    
    func outputInitMethod(_ initMethod: InitGenerationIntention,
                          selfType: KnownType,
                          target: RewriterOutputTarget) {
        
        outputHistory(for: initMethod, target: target)
        
        if options.emitObjcCompatibility && (selfType.kind == .class || selfType.kind == .protocol) {
            target.output(line: "@objc", style: .keyword)
        }
        target.outputIdentation()
        
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: initMethod.accessLevel)
        
        if !accessModifier.isEmpty && !(initMethod.parent is ProtocolGenerationIntention) {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        
        if initMethod.isOverride {
            target.outputInlineWithSpace("override", style: .keyword)
        }
        
        if initMethod.isConvenience {
            target.outputInlineWithSpace("convenience", style: .keyword)
        }
        
        // TODO: Support protocol's '@optional' keyword on protocol initializers
        
        target.outputInline("init", style: .keyword)
        
        if initMethod.isFailable {
            target.outputInline("?")
        }
        
        outputParameters(initMethod.parameters,
                         into: target,
                         inNonnullContext: initMethod.inNonnullContext)
        
        if let body = initMethod.functionBody {
            outputMethodBody(body, target: target)
        } else if initMethod.parent is BaseClassIntention {
            // Class definitions _must_ have a method body, even if empty.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        } else {
            target.outputLineFeed()
        }
    }
    
    func outputDeinit(_ method: MethodGenerationIntention,
                      selfType: KnownType,
                      target: RewriterOutputTarget) {
        
        outputHistory(for: method, target: target)
        
        if options.emitObjcCompatibility {
            target.output(line: "@objc", style: .keyword)
        }
        target.outputIdentation()
        
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: method.accessLevel)
        
        if !accessModifier.isEmpty && !(method.parent is ProtocolGenerationIntention) {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        
        target.outputInline("deinit", style: .keyword)
        
        if let body = method.functionBody {
            outputMethodBody(body, target: target)
        } else if method.parent is BaseClassIntention {
            // Class definitions _must_ have a method body, even if empty.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        } else {
            target.outputLineFeed()
        }
    }
    
    func outputMethod(_ method: MethodGenerationIntention,
                      selfType: KnownType,
                      target: RewriterOutputTarget) {
        
        outputHistory(for: method, target: target)
        
        if options.emitObjcCompatibility {
            target.output(line: "@objc", style: .keyword)
        }
        
        target.outputIdentation()
        
        let accessModifier = InternalSwiftWriter._accessModifierFor(accessLevel: method.accessLevel)
        
        if !accessModifier.isEmpty && !(method.parent is ProtocolGenerationIntention) {
            target.outputInlineWithSpace(accessModifier, style: .keyword)
        }
        if method.isStatic {
            target.outputInlineWithSpace("static", style: .keyword)
        }
        
        // Protocol 'optional' keyword
        if let protocolMethod = method as? ProtocolMethodGenerationIntention, protocolMethod.isOptional {
            target.outputInlineWithSpace("@objc", style: .keyword)
            target.outputInlineWithSpace("optional", style: .keyword)
        }
        
        if method.isOverride {
            target.outputInlineWithSpace("override", style: .keyword)
        }
        
        target.outputInlineWithSpace("func", style: .keyword)
        
        let sign = method.signature
        
        target.outputInline(sign.name)
        
        outputParameters(method.signature.parameters, into: target,
                         inNonnullContext: method.inNonnullContext)
        
        switch sign.returnType {
        case .void: // `-> Void` can be omitted for void functions.
            break
        default:
            target.outputInline(" -> ")
            let typeName = typeMapper.typeNameString(for: sign.returnType)
            
            target.outputInline(typeName, style: .typeName)
        }
        
        if let body = method.functionBody {
            outputMethodBody(body, target: target)
        } else if method.parent is BaseClassIntention {
            // Class definitions _must_ have a method body, even if empty.
            target.outputInline(" {")
            target.outputLineFeed()
            target.output(line: "}")
        } else {
            target.outputLineFeed()
        }
    }
    
    func outputMethodBody(_ body: FunctionBodyIntention, target: RewriterOutputTarget) {
        astWriter.write(compoundStatement: body.body, into: target)
    }
    
    func outputParameters(_ parameters: [ParameterSignature],
                          into target: RewriterOutputTarget,
                          inNonnullContext: Bool = false) {
        
        target.outputInline("(")
        
        for (i, param) in parameters.enumerated() {
            if i > 0 {
                target.outputInline(", ")
            }
            
            let typeName = typeMapper.typeNameString(for: param.type)
            
            if param.label != param.name {
                target.outputInlineWithSpace(param.label ?? "_", style: .plain)
            }
            
            target.outputInline(param.name)
            target.outputInline(": ")
            target.outputInline(typeName, style: .typeName)
        }
        
        target.outputInline(")")
    }
    
    func outputHistory(for intention: Intention, target: RewriterOutputTarget) {
        outputHistory(intention.history, target: target)
    }
    
    func outputHistory(_ history: IntentionHistory, target: RewriterOutputTarget) {
        if !options.printIntentionHistory {
            return
        }
        
        if history.entries.isEmpty {
            return
        }
        
        for entry in history.entries {
            target.output(line: "// \(entry.summary)", style: .comment)
        }
    }
    
    internal static func _isConstant(fromType type: ObjcType) -> Bool {
        switch type {
        case .qualified(_, let qualifiers),
             .specified(_, .qualified(_, let qualifiers)):
            if qualifiers.contains("const") {
                return true
            }
        case .specified(let specifiers, _):
            if specifiers.contains("const") {
                return true
            }
        default:
            break
        }
        
        return false
    }
    
    internal static func _accessModifierFor(accessLevel: AccessLevel, omitInternal: Bool = true) -> String {
        // In Swift, omitting the access level specifier infers 'internal', so we
        // allow the user to decide whether to omit the keyword here
        if omitInternal && accessLevel == .internal {
            return ""
        }
        
        return accessLevel.rawValue
    }
}

internal func evaluateOwnershipPrefix(inType type: ObjcType,
                                      property: PropertyDefinition? = nil) -> Ownership {
    var ownership: Ownership = .strong
    if !type.isPointer {
        return .strong
    }
    
    switch type {
    case .specified(let specifiers, _):
        if specifiers.last == "__weak" {
            ownership = .weak
        } else if specifiers.last == "__unsafe_unretained" {
            ownership = .unownedUnsafe
        }
    default:
        break
    }
    
    // Search in property
    if let property = property {
        if let modifiers = property.attributesList?.keywordAttributes {
            if modifiers.contains("weak") {
                ownership = .weak
            } else if modifiers.contains("unsafe_unretained") {
                ownership = .unownedUnsafe
            } else if modifiers.contains("assign") {
                ownership = .unownedUnsafe
            }
        }
    }
    
    return ownership
}
