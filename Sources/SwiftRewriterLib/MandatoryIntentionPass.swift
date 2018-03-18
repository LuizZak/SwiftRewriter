import SwiftAST

// TODO: Detect indirect super-type calling (i.e. `[aVarWithSuperAssociatedWithinIt method]`)
// on override detection code
/// Mandatory intention pass that applies some necessary code changes to compile,
/// like override detection and struct initialization step
class MandatoryIntentionPass: IntentionPass {
    var context: IntentionPassContext!
    
    func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.context = context
        
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
        if type.kind == .class {
            applyOverrideDetection(type)
        }
        if let type = type as? StructGenerationIntention {
            applyStructInitializer(type)
        }
    }
    
    private func applyStructInitializer(_ type: StructGenerationIntention) {
        guard type.constructors.isEmpty else {
            return
        }
        
        let fields = type.instanceVariables
        
        // Create empty constructor
        let plainInitBody
            = FunctionBodyIntention(body:
                CompoundStatement(statements:
                    fields.map { field in
                        let rhs: Expression
                        
                        if context.typeSystem.isNumeric(field.type) {
                            // <integer field> = 0
                            rhs = .constant(0)
                        } else {
                            // <field> = FieldType()
                            rhs =
                                Expression
                                    .identifier(
                                        context.typeMapper.typeNameString(for: field.type)
                                    )
                                    .call()
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
                let superMethod
                    = context.typeSystem.method(withObjcSelector: method.selector,
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
                SyntaxNodeSequence(statement: body.body, inspectBlocks: true)
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
}
