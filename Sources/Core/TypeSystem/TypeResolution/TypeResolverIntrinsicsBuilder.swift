import SwiftAST
import KnownType
import Intentions

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

    init(
        typeResolver: ExpressionTypeResolver,
        globals: DefinitionsSource,
        typeSystem: TypeSystem,
        intentionGlobals: IntentionCollectionGlobals
    ) {

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

    func setupIntrinsics(
        forFile file: FileGenerationIntention,
        intentions: IntentionCollection
    ) {

        let intrinsics = createIntrinsics(forFile: file, intentions: intentions)
        typeResolver.intrinsicVariables = intrinsics
    }

    func setupIntrinsics(
        forFunction function: GlobalFunctionGenerationIntention,
        intentions: IntentionCollection
    ) {

        let intrinsics = createIntrinsics(forFunction: function, intentions: intentions)
        typeResolver.pushContainingFunctionReturnType(function.signature.returnType)
        typeResolver.intrinsicVariables = intrinsics

        pushedReturnType = true
    }

    func setupIntrinsics(
        forVariable variable: GlobalVariableGenerationIntention,
        intentions: IntentionCollection
    ) {

        let intrinsics = createIntrinsics(forVariable: variable, intentions: intentions)
        typeResolver.pushContainingFunctionReturnType(variable.type)
        typeResolver.intrinsicVariables = intrinsics

        pushedReturnType = true
    }

    func setupIntrinsics(
        forMember member: MemberGenerationIntention,
        intentions: IntentionCollection
    ) {

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
                CodeDefinition.forSetterValue(
                    named: setter.valueIdentifier,
                    type: type
                ),
                overwrite: false
            )
    }

    func teardownIntrinsics() {
        if pushedReturnType {
            typeResolver.popContainingFunctionReturnType()
        }

        typeResolver.intrinsicVariables = EmptyCodeScope()
        miscellaneousDefinitions.removeLocalDefinitions()
        knownTypeDefinitionsSource = nil
    }

    private func createIntrinsics(
        forFile file: FileGenerationIntention,
        intentions: IntentionCollection
    ) -> DefinitionsSource {

        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionFileGlobalsDefinitionsSource(
                globals: self.intentionGlobals,
                file: file
            )

        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()

        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)

        return compoundIntrinsics
    }

    private func createIntrinsics(
        forFunction function: GlobalFunctionGenerationIntention,
        intentions: IntentionCollection
    ) -> DefinitionsSource {

        let intrinsics = DefaultCodeScope()

        intrinsics.recordDefinitions(
            CodeDefinition.forParameters(inSignature: function.signature),
            overwrite: false
        )

        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionGlobalsDefinitionsSource(
                globals: self.intentionGlobals,
                symbol: function
            )

        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()

        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)

        return compoundIntrinsics
    }

    private func createIntrinsics(
        forVariable variable: GlobalVariableGenerationIntention,
        intentions: IntentionCollection
    ) -> DefinitionsSource {

        let intrinsics = DefaultCodeScope()

        // Push file-level global definitions (variables and functions)
        let intentionGlobals =
            IntentionCollectionGlobalsDefinitionsSource(
                globals: self.intentionGlobals,
                symbol: variable
            )

        // Push global definitions
        let compoundIntrinsics = CompoundDefinitionsSource()

        compoundIntrinsics.addSource(intrinsics)
        compoundIntrinsics.addSource(intentionGlobals)
        compoundIntrinsics.addSource(miscellaneousDefinitions)
        compoundIntrinsics.addSource(globals)

        return compoundIntrinsics
    }

    private func createIntrinsics(
        forMember member: MemberGenerationIntention,
        intentions: IntentionCollection
    ) -> DefinitionsSource {

        var propertyIntrinsics: DefinitionsSource?
        var functionArgumentsIntrinsics: DefinitionsSource?

        let intrinsics = DefaultCodeScope()

        // Push `self` intrinsic member variable, as well as all properties visible
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)

            intrinsics.recordDefinition(
                CodeDefinition.forSelf(
                    type: selfType,
                    isStatic: member.isStatic
                ),
                overwrite: false
            )

            // Record 'super', if available
            if let supertype = type.supertype {
                let superType = SwiftType.typeName(supertype.asTypeName)

                intrinsics.recordDefinition(
                    CodeDefinition.forSuper(
                        type: superType,
                        isStatic: member.isStatic
                    ),
                    overwrite: false
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
        if let function = member as? ParameterizedFunctionIntention {
            let functionIntrinsics = DefaultCodeScope()

            functionIntrinsics.recordDefinitions(
                CodeDefinition.forParameters(function.parameters),
                overwrite: false
            )

            functionArgumentsIntrinsics = functionIntrinsics
        }

        if let sub = member as? SubscriptGenerationIntention {
            let subscriptIntrinsics = DefaultCodeScope()

            subscriptIntrinsics.recordDefinitions(
                CodeDefinition.forParameters(sub.parameters),
                overwrite: false
            )

            functionArgumentsIntrinsics = subscriptIntrinsics
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

        for prop in type.knownProperties where prop.isStatic == staticMembers && prop.name == name {
            definition = CodeDefinition.forKnownMember(prop)
            break
        }

        if definition == nil {
            for field in type.knownFields where field.isStatic == staticMembers && field.name == name {
                definition = CodeDefinition.forKnownMember(field)
                break
            }
        }

        if usingCache {
            lookupCache[name] = definition
        }

        return definition
    }

    func firstDefinition(where predicate: (CodeDefinition) -> Bool) -> CodeDefinition? {
        for prop in type.knownProperties where prop.isStatic == staticMembers {
            let definition = CodeDefinition.forKnownMember(prop)
            if predicate(definition) {
                return definition
            }
        }

        for field in type.knownFields where field.isStatic == staticMembers {
            let definition = CodeDefinition.forKnownMember(field)
            if predicate(definition) {
                return definition
            }
        }

        return nil
    }

    func functionDefinitions(matching identifier: FunctionIdentifier) -> [CodeDefinition] {
        []
    }

    func functionDefinitions(named name: String) -> [CodeDefinition] {
        []
    }

    func functionDefinitions(where predicate: (CodeDefinition) -> Bool) -> [CodeDefinition] {
        []
    }

    func localDefinitions() -> [CodeDefinition] {
        []
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

    func firstDefinition(where predicate: (CodeDefinition) -> Bool) -> CodeDefinition? {
        for values in globals.varMap.values {
            for value in values {
                guard value.isVisible(for: symbol) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalVariable(value)
                if predicate(definition) {
                    return definition
                }
            }
        }
        for values in globals.funcMap.values {
            for value in values {
                guard value.isVisible(for: symbol) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalFunction(value)
                if predicate(definition) {
                    return definition
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

    func functionDefinitions(named name: String) -> [CodeDefinition] {
        guard let functions = globals.funcMap[name] else {
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

    func functionDefinitions(where predicate: (CodeDefinition) -> Bool) -> [CodeDefinition] {
        var result: [CodeDefinition] = []
        for values in globals.funcMap.values {
            for value in values {
                guard value.isVisible(for: symbol) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalFunction(value)
                if predicate(definition) {
                    result.append(definition)
                }
            }
        }

        return result
    }

    func localDefinitions() -> [CodeDefinition] {
        let variables: [CodeDefinition] =
            globals.varMap.flatMap(\.value)
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition.forGlobalVariable(global)
                }

        let functions: [CodeDefinition] =
            globals.funcMap.flatMap(\.value)
                .filter { global in
                    global.isVisible(for: symbol)
                }.map { global in
                    CodeDefinition.forGlobalFunction(global)
                }

        return variables + functions
    }
}

class IntentionCollectionFileGlobalsDefinitionsSource: DefinitionsSource {
    var globals: IntentionCollectionGlobals
    var file: FileGenerationIntention

    init(globals: IntentionCollectionGlobals, file: FileGenerationIntention) {
        self.globals = globals
        self.file = file
    }

    func firstDefinition(named name: String) -> CodeDefinition? {
        if let functions = globals.funcMap[name] {
            for function in functions {
                if function.isVisible(in: file) {
                    return CodeDefinition.forGlobalFunction(function)
                }
            }
        }
        if let variables = globals.varMap[name] {
            for variable in variables {
                if variable.isVisible(in: file) {
                    return CodeDefinition.forGlobalVariable(variable)
                }
            }
        }

        return nil
    }

    func firstDefinition(where predicate: (CodeDefinition) -> Bool) -> CodeDefinition? {
        for values in globals.varMap.values {
            for value in values {
                guard value.isVisible(in: file) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalVariable(value)
                if predicate(definition) {
                    return definition
                }
            }
        }
        for values in globals.funcMap.values {
            for value in values {
                guard value.isVisible(in: file) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalFunction(value)
                if predicate(definition) {
                    return definition
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
                if function.isVisible(in: file) {
                    return CodeDefinition.forGlobalFunction(function)
                }

                return nil
            }
    }

    func functionDefinitions(named name: String) -> [CodeDefinition] {
        guard let functions = globals.funcMap[name] else {
            return []
        }

        return
            functions.compactMap { function in
                if function.isVisible(in: file) {
                    return CodeDefinition.forGlobalFunction(function)
                }

                return nil
            }
    }

    func functionDefinitions(where predicate: (CodeDefinition) -> Bool) -> [CodeDefinition] {
        var result: [CodeDefinition] = []
        for values in globals.funcMap.values {
            for value in values {
                guard value.isVisible(in: file) else {
                    continue
                }

                let definition = CodeDefinition.forGlobalFunction(value)
                if predicate(definition) {
                    result.append(definition)
                }
            }
        }

        return result
    }

    func localDefinitions() -> [CodeDefinition] {
        let variables: [CodeDefinition] =
            globals.varMap.flatMap(\.value)
                .filter { global in
                    global.isVisible(in: file)
                }.map { global in
                    CodeDefinition.forGlobalVariable(global)
                }

        let functions: [CodeDefinition] =
            globals.funcMap.flatMap(\.value)
                .filter { global in
                    global.isVisible(in: file)
                }.map { global in
                    CodeDefinition.forGlobalFunction(global)
                }

        return variables + functions
    }
}

public struct IntentionCollectionGlobals {
    public let funcMap: [String: [GlobalFunctionGenerationIntention]]
    public let funcIdentMap: [FunctionIdentifier: [GlobalFunctionGenerationIntention]]
    public let varMap: [String: [GlobalVariableGenerationIntention]]

    public init(intentions: IntentionCollection) {
        funcMap = Dictionary(grouping: intentions.globalFunctions(), by: \.name)
        funcIdentMap = Dictionary(grouping: intentions.globalFunctions(), by: \.signature.asIdentifier)
        varMap = Dictionary(grouping: intentions.globalVariables(), by: \.name)
    }
}
