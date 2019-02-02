import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Class responsible for building the intrinsics exposed to type resolvers during
/// resolution of member lookups.
///
/// Intrinsics builders are not thread-safe, and should be instantiated on a per-thread
/// basis to ensure no accidental thread racing occurs.
class TypeResolverIntrinsicsBuilder {
    private var pushedReturnType: Bool = false
    
    var typeResolver: ExpressionTypeResolver
    
    private var globals: DefinitionsSource
    private var typeSystem: TypeSystem
    private var miscellaneousDefinitions = DefaultCodeScope()
    private var intentionGlobals: IntentionCollectionGlobals
    private var knownTypeDefinitionsSource: KnownTypePropertiesDefinitionsSource?
    
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
    
    func makeCache() {
        knownTypeDefinitionsSource?.makeCache()
    }
    
    func tearDownCache() {
        knownTypeDefinitionsSource?.tearDownCache()
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
                CodeDefinition.forSetterValue(named: setter.valueIdentifier,
                                              type: type)
            )
    }
    
    func teardownIntrinsics() {
        if pushedReturnType {
            typeResolver.popContainingFunctionReturnType()
        }
        
        typeResolver.intrinsicVariables = EmptyCodeScope()
        miscellaneousDefinitions.removeAllDefinitions()
        knownTypeDefinitionsSource = nil
    }
    
    private func createIntrinsics(forFunction function: GlobalFunctionGenerationIntention,
                                  intentions: IntentionCollection) -> DefinitionsSource {
        
        let intrinsics = DefaultCodeScope()
        
        intrinsics.recordDefinitions(
            CodeDefinition.forParameters(inSignature: function.signature)
        )
        
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
        
        var propertyIntrinsics: DefinitionsSource?
        var functionArgumentsIntrinsics: DefinitionsSource?
        
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable, as well as all properties visible
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            
            intrinsics.recordDefinition(
                CodeDefinition.forSelf(type: selfType,
                                       isStatic: member.isStatic)
            )
            
            // Record 'super', if available
            if let supertype = type.supertype {
                let superType = SwiftType.typeName(supertype.asTypeName)
                
                intrinsics.recordDefinition(
                    CodeDefinition.forSuper(type: superType,
                                            isStatic: member.isStatic)
                )
            }
            
            // Record all known static properties visible
            if let knownType = typeSystem.knownTypeWithName(type.typeName) {
                
                let knownTypeSource =
                    KnownTypePropertiesDefinitionsSource(
                        type: knownType,
                        staticMembers: member.isStatic
                    )
                
                knownTypeDefinitionsSource = knownTypeSource
                propertyIntrinsics = knownTypeSource
            }
        }
        
        // Push function parameters as intrinsics, if member is a method type
        if let function = member as? FunctionIntention {
            let functionIntrinsics = DefaultCodeScope()
            
            functionIntrinsics.recordDefinitions(
                CodeDefinition.forParameters(function.parameters)
            )
            
            functionArgumentsIntrinsics = functionIntrinsics
        }
        
        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionGlobalsDefinitionsSource(globals: self.intentionGlobals,
                                                        symbol: member)
        
        let compoundIntrinsics = CompoundDefinitionsSource()
        
        if let functionArgumentsIntrinsics = functionArgumentsIntrinsics {
            compoundIntrinsics.addSource(functionArgumentsIntrinsics)
        }
        if let propertyIntrinsics = propertyIntrinsics {
            compoundIntrinsics.addSource(propertyIntrinsics)
        }
        
        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)
        
        return compoundIntrinsics
    }
}

class KnownTypePropertiesDefinitionsSource: DefinitionsSource {
    
    var usingCache = false
    var lookupCache: [String: CodeDefinition?] = [:]
    let type: KnownType
    let staticMembers: Bool
    
    init(type: KnownType, staticMembers: Bool) {
        self.type = type
        self.staticMembers = staticMembers
    }
    
    func makeCache() {
        usingCache = true
        lookupCache = [:]
    }
    
    func tearDownCache() {
        usingCache = false
        lookupCache = [:]
    }
    
    func firstDefinition(named name: String) -> CodeDefinition? {
        
        if usingCache {
            if let result = lookupCache[name] {
                return result
            }
        }
        
        var definition: CodeDefinition?
        
        for prop in type.knownProperties where prop.isStatic == staticMembers {
            if prop.name == name {
                definition = CodeDefinition.forKnownMember(prop)
                break
            }
        }
        
        if definition == nil {
            for field in type.knownFields where field.isStatic == staticMembers {
                if field.name == name {
                    definition = CodeDefinition.forKnownMember(field)
                    break
                }
            }
        }
        
        if usingCache {
            lookupCache[name] = definition
        }
        
        return definition
    }
    
    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        return []
    }
    
    func allDefinitions() -> [CodeDefinition] {
        return []
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
                    return CodeDefinition.forGlobalFunction(function)
                }
            }
        }
        if let variables = globals.varMap[name] {
            for variable in variables {
                if variable.isVisible(for: symbol) {
                    return CodeDefinition.forGlobalVariable(variable)
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
                    return CodeDefinition.forGlobalFunction(function)
                }
                
                return nil
            }
    }
    
    func allDefinitions() -> [CodeDefinition] {
        let variables: [CodeDefinition] =
            globals.varMap.flatMap { $0.value }
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition.forGlobalVariable(global)
                }
        
        let functions: [CodeDefinition] =
            globals.funcMap.flatMap { $0.value }
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition.forGlobalFunction(global)
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
