import SwiftAST

/// Class responsible for building the intrinsics exposed to type resolvers during
/// resolution of member lookups.
class TypeResolverIntrinsicsBuilder {
    private var pushedReturnType: Bool = false
    
    private var typeResolver: ExpressionTypeResolver
    private var globals: DefinitionsSource
    private var typeSystem: TypeSystem
    private var miscellaneousDefinitions: DefaultCodeScope = DefaultCodeScope()
    
    var globalVariables: [GlobalVariableGenerationIntention] = []
    
    init(typeResolver: ExpressionTypeResolver,
         globals: DefinitionsSource,
         globalVariables: [GlobalVariableGenerationIntention],
         typeSystem: TypeSystem) {
        
        self.typeResolver = typeResolver
        self.globals = globals
        self.globalVariables = globalVariables
        self.typeResolver = typeResolver
        self.typeSystem = typeSystem
    }
    
    func setupIntrinsics(forMember member: MemberGenerationIntention) {
        let intrinsics = createIntrinsics(forMember: member)
        
        typeResolver.intrinsicVariables = intrinsics
        
        if let method = member as? MethodGenerationIntention {
            typeResolver.pushContainingFunctionReturnType(method.returnType)
            pushedReturnType = true
        } else if let prop = member as? PropertyGenerationIntention {
            // Return type of property (getter) is the property's type itself
            typeResolver.pushContainingFunctionReturnType(prop.type)
            pushedReturnType = true
        } else {
            pushedReturnType = false
        }
    }
    
    func addSetterIntrinsics(setter: PropertyGenerationIntention.Setter, type: SwiftType) {
        miscellaneousDefinitions
            .recordDefinition(
                CodeDefinition(variableNamed: setter.valueIdentifier,
                               type: type,
                               intention: nil
                )
            )
    }
    
    func teardownIntrinsics() {
        if pushedReturnType {
            typeResolver.popContainingFunctionReturnType()
        }
        
        typeResolver.intrinsicVariables = EmptyCodeScope()
        miscellaneousDefinitions.removeAllDefinitions()
    }
    
    func createIntrinsics(forMember member: MemberGenerationIntention) -> DefinitionsSource {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable, as well as all properties visible
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            let selfStorage: ValueStorage
            
            if member.isStatic {
                // Class `self` points to metatype of the class
                selfStorage =
                    ValueStorage(type: .metatype(for: selfType),
                                 ownership: .strong,
                                 isConstant: true)
            } else {
                // Instance `self` points to the actual instance
                selfStorage =
                    ValueStorage(type: selfType,
                                 ownership: .strong,
                                 isConstant: true)
            }
            
            intrinsics.recordDefinition(
                CodeDefinition(variableNamed: "self",
                               storage: selfStorage,
                               intention: type)
            )
            
            // Record all known static properties visible
            if let knownType = typeSystem.knownTypeWithName(type.typeName) {
                for prop in knownType.knownProperties where prop.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(variableNamed: prop.name, storage: prop.storage,
                                       intention: prop as? Intention)
                    )
                }
                
                for field in knownType.knownFields where field.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(variableNamed: field.name, storage: field.storage,
                                       intention: field as? Intention)
                    )
                }
            }
        }
        
        // Push function parameters as intrinsics, if member is a method type
        if let function = member as? FunctionIntention {
            for param in function.parameters {
                intrinsics.recordDefinition(
                    CodeDefinition(variableNamed: param.name, type: param.type,
                                   intention: function)
                )
            }
        }
        
        // Push file-level global variables
        let globalVars =
            GlobalVariablesSource(variables: globalVariables, symbol: member)
        
        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()
        
        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(globalVars)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)
        
        return compoundIntrinsics
    }
    
    private class GlobalVariablesSource: DefinitionsSource {
        var variables: [GlobalVariableGenerationIntention]
        var symbol: FromSourceIntention
        
        init(variables: [GlobalVariableGenerationIntention], symbol: FromSourceIntention) {
            self.variables = variables
            self.symbol = symbol
        }
        
        func definition(named name: String) -> CodeDefinition? {
            for global in variables {
                if global.name == name && global.isVisible(for: symbol) {
                    return
                        CodeDefinition(variableNamed: global.name,
                                       storage: global.storage,
                                       intention: global)
                }
            }
            
            return nil
        }
        
        func allDefinitions() -> [CodeDefinition] {
            return
                variables
                    .filter { global in
                        global.isVisible(for: symbol)
                    }.map {
                        CodeDefinition(variableNamed: $0.name,
                                       storage: $0.storage,
                                       intention: $0)
            }
        }
    }
}
