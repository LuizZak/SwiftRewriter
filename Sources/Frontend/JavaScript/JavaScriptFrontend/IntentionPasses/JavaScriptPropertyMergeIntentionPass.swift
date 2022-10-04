import SwiftAST
import KnownType
import Intentions

/// Merges properties with getter/setters in types
public class JavaScriptPropertyMergeIntentionPass: IntentionPass {
    /// A number representing the unique index of an operation to aid in history
    /// checking by tag.
    /// Represents the number of operations applied by this intention pass while
    /// instantiated, +1.
    private var operationsNumber: Int = 1
    
    private var intentions: IntentionCollection!
    private var context: IntentionPassContext!
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        "\(JavaScriptPropertyMergeIntentionPass.self):\(operationsNumber)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.intentions = intentionCollection
        self.context = context
        
        context.typeSystem.makeCache()
        
        var matches: [PropertySet] = []
        
        var classesSeen: Set<String> = []
        
        // Collect all (nominal, non-category types) and analyze them one-by-one.
        for file in intentionCollection.fileIntentions() {
            for cls in file.typeIntentions.compactMap({ $0 as? BaseClassIntention }) {
                // Extensions are handled separately.
                if cls is ClassExtensionGenerationIntention {
                    continue
                }
                
                if classesSeen.contains(cls.typeName) {
                    continue
                }
                
                classesSeen.insert(cls.typeName)
                
                matches.append(contentsOf: collectMatches(in: cls))
            }
        }
        
        // Do a second run, this time collecting extensions for which there is no
        // nominal primary declaration (i.e. categories for types imported from
        // external dependencies)
        for file in intentionCollection.fileIntentions() {
            for cls in file.extensionIntentions {
                if classesSeen.contains(cls.typeName) {
                    continue
                }
                
                classesSeen.insert(cls.typeName)
                
                matches.append(contentsOf: collectMatches(in: cls))
            }
        }
        
        context.typeSystem.tearDownCache()
        
        // Flatten properties now
        for match in matches {
            _ = joinPropertySet(match, on: match.classIntention)
        }
    }
    
    private func collectMatches(in classIntention: BaseClassIntention) -> [PropertySet] {
        let methods = collectMethods(fromClass: classIntention)
        
        // Match getters and setters
        var matches: [PropertySet] = []
        
        let getterPrefix = "get_"
        let setterPrefix = "set_"
        
        let getters: [MethodGenerationIntention] =
            methods
                .filter { $0.typedSource?.context == .isGetter }
        
        let setters: [MethodGenerationIntention] =
            methods
                .filter { $0.typedSource?.context == .isSetter }
        
        let settersByName = setters.groupBy({ $0.name })

        // Pair up each getter with a setter, or leave it as a getter-only
        for getter in getters {
            let propertyName = String(getter.name.dropFirst(getterPrefix.count))

            let potentialSetters = settersByName[setterPrefix + propertyName]

            var propSet =
                PropertySet(
                    classIntention: classIntention,
                    propertyName: propertyName,
                    propertyType: getter.returnType == .void ? .any : getter.returnType,
                    getter: getter,
                    setter: nil
                )
            
            if let potentialSetters, potentialSetters.count == 1 {
                propSet.setter = potentialSetters[0]
            }
            
            matches.append(propSet)
        }

        return matches
    }
    
    func collectMethods(fromClass classIntention: BaseClassIntention) -> [MethodGenerationIntention] {
        var methods: [MethodGenerationIntention] = []
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == classIntention.typeName {
                methods.append(contentsOf: type.methods)
            }
        }
        
        return methods
    }
    
    /// From a given found joined set of @property definition and potential
    /// getter/setter definitions, reworks the intended signatures on the class
    /// definition such that properties are correctly flattened with their non-synthesized
    /// getter/setters into `var myVar { get set }` Swift computed properties.
    ///
    /// Returns `false` if the method ended up making no changes.
    // swiftlint:disable function_body_length
    private func joinPropertySet(_ propertySet: PropertySet, on classIntention: BaseClassIntention) -> Bool {
        switch (propertySet.getter, propertySet.setter) {
        // Getter and setter: Create a property with `{ get { [...] } set { [...] }`
        case let (getter, setter?):
            guard let getterOwner = getter.type, let setterOwner = setter.type else {
                return false
            }
            
            let finalGetter: FunctionBodyIntention
            let finalSetter: PropertyGenerationIntention.Setter
            
            if let getterBody = getter.functionBody, let setterBody = setter.functionBody {
                finalGetter = getterBody
                
                finalSetter =
                    PropertyGenerationIntention
                        .Setter(
                            valueIdentifier: setter.parameters[0].name,
                            body: setterBody
                        )
            } else {
                finalGetter = FunctionBodyIntention(body: [])
                finalSetter =
                    PropertyGenerationIntention
                        .Setter(
                            valueIdentifier: "value",
                            body: FunctionBodyIntention(body: [])
                        )
            }
            
            // Remove the original method intentions
            getterOwner.removeMethod(getter)
            setterOwner.removeMethod(setter)
            
            getterOwner.history
                .recordChange(
                    tag: historyTag,
                    description: """
                        Removed method \(TypeFormatter.asString(method: getter, ofType: getterOwner)) since it is a getter.
                        """
                    )
            
            setterOwner.history
                .recordChange(
                    tag: historyTag,
                    description: """
                        Removed method \(TypeFormatter.asString(method: setter, ofType: setterOwner)) since it is a setter.
                        """
                    )

            // Synthesize property
            let property = PropertyGenerationIntention(
                name: propertySet.propertyName,
                type: propertySet.propertyType,
                objcAttributes: []
            )
            property.mode = .property(get: finalGetter, set: finalSetter)
            property.history.recordCreation(
                description: """
                Created getter/setter property by merging original getter \
                \(TypeFormatter.asString(method: getter, ofType: getterOwner)) \
                and setter \
                \(TypeFormatter.asString(method: setter, ofType: setterOwner))
                """
            )

            classIntention.addProperty(property)
            
            operationsNumber += 1
            context.notifyChange()
            
            return true
            
        // Getter-only: Create computed property.
        case let (getter, nil):
            guard let getterOwner = getter.type else {
                return false
            }
            
            let getterBody = getter.functionBody ?? FunctionBodyIntention(body: [])
            
            // Remove the original method intention
            getterOwner.removeMethod(getter)
            
            getterOwner
                .history
                .recordChange(
                    tag: historyTag,
                    description: """
                        Merged getter method \(TypeFormatter.asString(method: getter, ofType: getterOwner)) \
                        into the getter-only property \
                        \(propertySet.propertyName)
                        """,
                    relatedIntentions: [getterBody]
                )
                .echoRecord(to: getterBody)
            
            // Synthesize property
            let property = PropertyGenerationIntention(
                name: propertySet.propertyName,
                type: propertySet.propertyType,
                objcAttributes: []
            )
            property.mode = .computed(getterBody)
            property.history.recordCreation(
                description: """
                Created computed property by merging original getter \
                \(TypeFormatter.asString(method: getter, ofType: getterOwner))
                """
            )

            classIntention.addProperty(property)
            
            operationsNumber += 1
            
            context.notifyChange()
            
            return true
        }
    }
    
    private struct PropertySet {
        var classIntention: BaseClassIntention
        var propertyName: String
        var propertyType: SwiftType
        var getter: MethodGenerationIntention
        var setter: MethodGenerationIntention?
    }
}
