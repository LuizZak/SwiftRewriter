import SwiftAST

/// Class responsible for building the intrinsics exposed to type resolvers during
/// resolution of member lookups.
class TypeResolverIntrinsicsBuilder {
    private var pushedReturnType: Bool = false
    
    var typeResolver: ExpressionTypeResolver
    
    private var globals: DefinitionsSource
    private var typeSystem: TypeSystem
    private var miscellaneousDefinitions: DefaultCodeScope = DefaultCodeScope()
    private var intentionGlobals: IntentionCollectionGlobals
    
    init(typeResolver: ExpressionTypeResolver,
         globals: DefinitionsSource,
         typeSystem: TypeSystem,
         intentionGlobals: IntentionCollectionGlobals) {
        
        self.typeResolver = typeResolver
        self.globals = globals
        self.typeResolver = typeResolver
        self.typeSystem = typeSystem
        self.intentionGlobals = intentionGlobals
    }
    
    func setForceResolveExpressions(_ force: Bool) {
        typeResolver.ignoreResolvedExpressions = !force
    }
    
    func setupIntrinsics(forFunction function: GlobalFunctionGenerationIntention,
                         intentions: IntentionCollection) {
        
        let intrinsics = createIntrinsics(forFunction: function, intentions: intentions)
        typeResolver.pushContainingFunctionReturnType(function.signature.returnType)
        typeResolver.intrinsicVariables = intrinsics
        
        pushedReturnType = true
    }
    
    func setupIntrinsics(forMember member: MemberGenerationIntention,
                         intentions: IntentionCollection) {
        
        let intrinsics = createIntrinsics(forMember: member, intentions: intentions)
        
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
    
    func setupGetterIntrinsics(getterType: SwiftType) {
        typeResolver.pushContainingFunctionReturnType(getterType)
    }
    
    func addSetterIntrinsics(setter: PropertyGenerationIntention.Setter, type: SwiftType) {
        miscellaneousDefinitions
            .recordDefinition(
                CodeDefinition(variableNamed: setter.valueIdentifier,
                               type: type
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
    
    private func createIntrinsics(forFunction function: GlobalFunctionGenerationIntention,
                                  intentions: IntentionCollection) -> DefinitionsSource {
        let intrinsics = DefaultCodeScope()
        
        // Push function parameters as intrinsics, if member is a method type
        for param in function.parameters {
            intrinsics.recordDefinition(
                CodeDefinition(variableNamed: param.name, type: param.type)
            )
        }
        
        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionGlobalsDefinitionsSource(globals: self.intentionGlobals,
                                                        symbol: function)
        
        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()
        
        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)
        
        return compoundIntrinsics
    }
    
    private func createIntrinsics(forMember member: MemberGenerationIntention,
                                  intentions: IntentionCollection) -> DefinitionsSource {
        
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
                               storage: selfStorage)
            )
            
            // Record 'super', if available
            if let supertype = type.supertype {
                let superType = SwiftType.typeName(supertype.asTypeName)
                let superStorage: ValueStorage
                
                if member.isStatic {
                    // Class `super` points to metatype of the class
                    superStorage =
                        ValueStorage(type: .metatype(for: superType),
                                     ownership: .strong,
                                     isConstant: true)
                } else {
                    // Instance `super` points to the actual instance's super type
                    superStorage =
                        ValueStorage(type: superType,
                                     ownership: .strong,
                                     isConstant: true)
                }
                
                intrinsics.recordDefinition(
                    CodeDefinition(variableNamed: "super",
                                   storage: superStorage)
                )
            }
            
            // Record all known static properties visible
            if let knownType = typeSystem.knownTypeWithName(type.typeName) {
                for prop in knownType.knownProperties where prop.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(variableNamed: prop.name, storage: prop.storage)
                    )
                }
                
                for field in knownType.knownFields where field.isStatic == member.isStatic {
                    intrinsics.recordDefinition(
                        CodeDefinition(variableNamed: field.name, storage: field.storage)
                    )
                }
            }
        }
        
        // Push function parameters as intrinsics, if member is a method type
        if let function = member as? FunctionIntention {
            for param in function.parameters {
                intrinsics.recordDefinition(
                    CodeDefinition(variableNamed: param.name, type: param.type)
                )
            }
        }
        
        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionGlobalsDefinitionsSource(globals: self.intentionGlobals,
                                                        symbol: member)
        
        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()
        
        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)
        
        return compoundIntrinsics
    }
}

class IntentionCollectionGlobalsDefinitionsSource: DefinitionsSource {
    var globals: IntentionCollectionGlobals
    var symbol: FromSourceIntention
    
    init(globals: IntentionCollectionGlobals, symbol: FromSourceIntention) {
        self.globals = globals
        self.symbol = symbol
    }
    
    func firstDefinition(named name: String) -> CodeDefinition? {
        if let functions = globals.funcMap[name] {
            for function in functions {
                if function.isVisible(for: symbol) {
                    let def = CodeDefinition(functionSignature: function.signature)
                    return def
                }
            }
        }
        if let variables = globals.varMap[name] {
            for variable in variables {
                if variable.isVisible(for: symbol) {
                    let def =
                        CodeDefinition(variableNamed: variable.name,
                                       storage: variable.storage)
                    
                    return def
                }
            }
        }
        
        return nil
    }
    
    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        guard let functions = globals.funcIdentMap[identifier] else {
            return []
        }
        
        return
            functions.compactMap { function in
                if function.isVisible(for: symbol) {
                    return CodeDefinition(functionSignature: function.signature)
                }
                
                return nil
            }
    }
    
    func allDefinitions() -> [CodeDefinition] {
        let variables =
            globals.varMap.flatMap { $0.value }
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition(variableNamed: global.name,
                                   storage: global.storage)
                }
        
        let functions =
            globals.funcMap.flatMap { $0.value }
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition(functionSignature: global.signature)
                }
        
        return variables + functions
    }
}

struct IntentionCollectionGlobals {
    let funcMap: [String: [GlobalFunctionGenerationIntention]]
    let funcIdentMap: [FunctionIdentifier: [GlobalFunctionGenerationIntention]]
    let varMap: [String: [GlobalVariableGenerationIntention]]
    
    init(intentions: IntentionCollection) {
        funcMap = Dictionary(grouping: intentions.globalFunctions(), by: { $0.name })
        funcIdentMap = Dictionary(grouping: intentions.globalFunctions(), by: { $0.signature.asIdentifier })
        varMap = Dictionary(grouping: intentions.globalVariables(), by: { $0.name })
    }
}
