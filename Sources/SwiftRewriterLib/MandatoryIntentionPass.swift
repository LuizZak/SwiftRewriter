import SwiftAST

// TODO: Detect indirect super-type calling (i.e. `[aVarWithSuperAssociatedWithinIt method]`)
// on override detection code
/// Mandatory intention pass that applies some necessary code changes to compile,
/// like override detection and struct initialization step
class MandatoryIntentionPass: IntentionPass {
    var context: IntentionPassContext!
    
    /// Signals whether this mandatory intention pass is being applied before or
    /// after other intention passes supplied.
    ///
    /// It is required to run a starting and ending mandatory pass to make sure
    /// all required work has been done to generate proper valid intentions for
    /// things such as method overrides and property backing field synthesization.
    var phase: IntentionPassPhase
    
    init(phase: IntentionPassPhase) {
        self.phase = phase
    }
    
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
        // Override detection pass
        applyOverrideDetection(intentionCollection)
        
        for file in intentionCollection.fileIntentions() {
            applyOnFile(file)
        }
    }
    
    func applyOnFile(_ file: FileGenerationIntention) {
        for type in file.typeIntentions {
            applyOnType(type)
        }
    }
    
    func applyOnType(_ type: TypeGenerationIntention) {
        // Override detection
        if let type = type as? BaseClassIntention {
            applySynthesizatonExpansion(on: type)
        }
        if let type = type as? StructGenerationIntention {
            applyStructInitializer(type)
        }
    }
    
    private func applyOverrideDetection(_ intentions: IntentionCollection) {
        (context.typeSystem as? DefaultTypeSystem)?.makeCache()
        defer {
            (context.typeSystem as? DefaultTypeSystem)?.tearDownCache()
        }
        
        let visitor = AnonymousIntentionVisitor()
        visitor.onVisitType = { type in
            guard type.kind == .class else { return }
            
            self.applyOverrideDetection(type)
        }
        
        visitor.visit(intentions: intentions)
    }
    
    private func applyStructInitializer(_ type: StructGenerationIntention) {
        guard phase == .beforeOtherIntentions else {
            return
        }
        
        guard type.constructors.isEmpty else {
            return
        }
        
        let fields = type.instanceVariables
        
        // Create empty constructor
        let plainInitBody
            = FunctionBodyIntention(body:
                CompoundStatement(statements:
                    fields.compactMap { field in
                        guard let rhs = context.typeSystem.defaultValue(for: field.type) else {
                            return nil
                        }
                        
                        return .expression(
                            .assignment(
                                lhs: .identifier(field.name),
                                op: .assign,
                                rhs: rhs
                            )
                        )
                    }
                ))
        
        let plainInit = InitGenerationIntention(parameters: [])
        plainInit.functionBody = plainInitBody
        plainInit
            .history
            .recordCreation(
                description: """
                Synthesizing parameterless constructor for struct
                """)
            .echoRecord(to: plainInitBody)
        
        type.addConstructor(plainInit)
        
        // Create fields constructor
        let parameters =
            fields.map { param in
                ParameterSignature(label: param.name, name: param.name, type: param.type)
            }
        
        let parameteredInitBody
            = FunctionBodyIntention(body:
                CompoundStatement(statements:
                    fields.map { field in
                        .expression(
                            .assignment(
                                lhs: Expression.identifier("self").dot(field.name),
                                op: .assign,
                                rhs: .identifier(field.name)
                            )
                        )
                    }
                ))
        
        let parameteredInit = InitGenerationIntention(parameters: parameters)
        parameteredInit.functionBody = parameteredInitBody
        parameteredInit
            .history
            .recordCreation(
                description: """
                Synthesizing parameterized constructor for struct
                """)
            .echoRecord(to: parameteredInitBody)
        
        type.addConstructor(parameteredInit)
    }
    
    private func applyOverrideDetection(_ type: TypeGenerationIntention) {
        guard phase == .beforeOtherIntentions else {
            return
        }
        
        // Init method override (always an override in case of plain `init`)
        if let initMethod
            = type.constructors.first(where: { $0.parameters.isEmpty })
                ?? type.methods.first(where: { $0.name == "init" && $0.parameters.isEmpty }) {
            
            if let initMethod = initMethod as? OverridableMemberGenerationIntention {
                initMethod.isOverride = true
            }
        }
        
        // Check supertypes for overrides
        if let supertype = context.typeSystem.supertype(of: type) {
            for method in type.methods {
                // TODO: Pass `invocationTypeHints`
                let superMethod
                    = context.typeSystem.method(withObjcSelector: method.selector,
                                                invocationTypeHints: nil,
                                                static: method.isStatic,
                                                includeOptional: false,
                                                in: supertype)
                
                if superMethod != nil {
                    method.isOverride = true
                }
            }
        }
        
        // Other overrides
        for method in type.methods {
            guard let body = method.body else {
                continue
            }
            
            let selector = method.selector
            
            let sequence =
                SyntaxNodeSequence(node: body.body, inspectBlocks: true)
                    .lazy.compactMap { $0 as? Expression }
            
            for expression in sequence {
                guard let postfix = expression.asPostfix else {
                    continue
                }
                guard let memberPostfix = postfix.exp.asPostfix else {
                    continue
                }
                guard memberPostfix.exp == .identifier("super") else {
                    continue
                }
                guard let member = memberPostfix.member else {
                    continue
                }
                guard let methodCall = postfix.functionCall else {
                    continue
                }
                
                if methodCall.selectorWith(methodName: member.name) == selector {
                    method.isOverride = true
                    break
                }
            }
        }
    }
    
    private func applySynthesizatonExpansion(on type: BaseClassIntention) {
        guard phase == .afterOtherIntentions else {
            return
        }
        
        // TODO: Apply history tracking to these changes
        
        for synth in type.synthesizations {
            guard let prop = type.properties.first(where: { $0.name == synth.propertyName }) else {
                continue
            }
            
            // Ignore generating backing fields if the backing field is actually
            // just a copy of the property.
            if synth.propertyName == synth.ivarName {
                guard let ivar = type.instanceVariable(named: synth.ivarName) else {
                    continue
                }
                
                // Collapse backing field into property
                applyBackingFieldPropertyCollapse(prop, ivar, type)
                continue
            }
            
            // Synthesize ivar
            if !type.hasInstanceVariable(named: synth.ivarName) {
                let storage = ValueStorage(type: prop.type,
                                           ownership: prop.ownership,
                                           isConstant: false)
                
                let intent =
                    InstanceVariableGenerationIntention(name: synth.ivarName,
                                                        storage: storage,
                                                        accessLevel: .private)
                
                type.addInstanceVariable(intent)
            }
            
            // Apply computed property field getter and setter
            let getterBody = FunctionBodyIntention(body: [
                .return(Expression.identifier(synth.ivarName).typed(prop.type))
            ])
            
            if prop.isReadOnly && prop.getter == nil {
                prop.mode = .computed(getterBody)
            } else if prop.getter == nil && prop.setter == nil {
                let setterBody = FunctionBodyIntention(body: [
                    .expression(
                        Expression
                            .identifier(synth.ivarName).typed(prop.type)
                            .assignment(op: .assign, rhs: Expression.identifier("newValue").typed(prop.type)))
                ])
                
                prop.mode =
                    .property(get: getterBody,
                              set: .init(valueIdentifier: "newValue",
                                         body: setterBody))
            }
        }
    }
    
    private func applyBackingFieldPropertyCollapse(
        _ property: PropertyGenerationIntention,
        _ field: InstanceVariableGenerationIntention,
        _ type: BaseClassIntention) {
        
        property.setterAccessLevel = field.accessLevel
        property.storage.type = field.storage.type
        
        type.removeInstanceVariable(named: field.name)
    }
    
    enum IntentionPassPhase {
        case beforeOtherIntentions
        case afterOtherIntentions
    }
}
