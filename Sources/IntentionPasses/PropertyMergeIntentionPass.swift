import SwiftRewriterLib
import SwiftAST

public class PropertyMergeIntentionPass: IntentionPass {
    /// A number representing the unique index of an operation to aid in history
    /// checking by tag.
    /// Represents the number of operations applied by this intention pass while
    /// instantiated, +1.
    private var operationsNumber: Int = 1
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        return "\(PropertyMergeIntentionPass.self):\(operationsNumber)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        for file in intentionCollection.fileIntentions() {
            
            for cls in file.typeIntentions.compactMap({ $0 as? BaseClassIntention }) {
                apply(on: cls)
            }
        }
    }
    
    func apply(on classIntention: BaseClassIntention) {
        let properties = collectProperties(fromClass: classIntention)
        let methods = collectMethods(fromClass: classIntention)
        
        // Match property intentions with the appropriately named methods
        var matches: [PropertySet] = []
        
        for property in properties {
            let expectedName = "set" + property.name.uppercasedFirstLetter
            
            // Getters: Parameterless methods that match the property's name,
            // with the return type matching the property's type
            let potentialGetters =
                methods.filter { $0.name == property.name }
                    .filter { $0.returnType.deepUnwrapped == property.type.deepUnwrapped }
                    .filter { $0.parameters.count == 0 }
            
            // Setters: All methods named `func set[Name](_ name: Type)` where
            // `[Name]` is the same as the property's name with the first letter
            // uppercased
            let potentialSetters =
                methods.filter { $0.returnType == .void }
                    .filter { $0.parameters.count == 1 }
                    .filter { $0.parameters[0].type.deepUnwrapped == property.type.deepUnwrapped }
                    .filter { $0.name == expectedName }
            
            var propSet = PropertySet(property: property, getter: nil, setter: nil)
            
            if potentialGetters.count == 1 {
                propSet.getter = potentialGetters[0]
            }
            if potentialSetters.count == 1 {
                propSet.setter = potentialSetters[0]
            }
            
            if propSet.getter == nil && propSet.setter == nil {
                continue
            }
            
            matches.append(propSet)
        }
        
        // Flatten properties now
        for match in matches {
            joinPropertySet(match, on: classIntention)
        }
    }
    
    func collectProperties(fromClass classIntention: BaseClassIntention) -> [PropertyGenerationIntention] {
        return classIntention.properties
    }
    
    func collectMethods(fromClass classIntention: BaseClassIntention) -> [MethodGenerationIntention] {
        return classIntention.methods
    }
    
    /// From a given found joined set of @property definition and potential
    /// getter/setter definitions, reworks the intented signatures on the class
    /// definition such that properties are correctly flattened with their non-synthesized
    /// getter/setters into `var myVar { get set }` Swift computed properties.
    private func joinPropertySet(_ propertySet: PropertySet, on classIntention: BaseClassIntention) {
        switch (propertySet.getter, propertySet.setter) {
        // Getter and setter: Create a property with `{ get { [...] } set { [...] }`
        case let (getter?, setter?):
            let finalGetter: FunctionBodyIntention
            let finalSetter: PropertyGenerationIntention.Setter
            
            if let getterBody = getter.functionBody, let setterBody = setter.functionBody {
                finalGetter = getterBody
                
                finalSetter =
                    PropertyGenerationIntention
                        .Setter(valueIdentifier: setter.parameters[0].name,
                                body: setterBody)
            } else {
                finalGetter = FunctionBodyIntention(body: [])
                finalSetter =
                    PropertyGenerationIntention
                        .Setter(valueIdentifier: "value",
                                body: FunctionBodyIntention(body: []))
            }
            
            propertySet.property.mode = .property(get: finalGetter, set: finalSetter)
            
            // Remove the original method intentions
            classIntention.removeMethod(getter)
            classIntention.removeMethod(setter)
            
            propertySet.property
                .history
                .recordChange(tag: historyTag,
                              description: """
                    Merged \(TypeFormatter.asString(method: getter, ofType: classIntention)) \
                    and \(TypeFormatter.asString(method: setter, ofType: classIntention)) \
                    into property \(TypeFormatter.asString(property: propertySet.property, ofType: classIntention))
                    """, relatedIntentions: [getter, setter, propertySet.property])
            
            classIntention.history
                .recordChange(tag: historyTag,
                              description: """
                    Removed method \(TypeFormatter.asString(method: getter, ofType: classIntention)) since deduced it \
                    is a getter for property \(TypeFormatter.asString(property: propertySet.property, ofType: classIntention))
                    """)
            
            classIntention.history
                .recordChange(tag: historyTag,
                              description: """
                    Removed method \(TypeFormatter.asString(method: setter, ofType: classIntention)) since deduced it \
                    is a setter for property \(TypeFormatter.asString(property: propertySet.property, ofType: classIntention))
                    """)
            
            operationsNumber += 1
            
        // Getter-only on readonly property: Create computed property.
        case let (getter?, nil) where propertySet.property.isReadOnly:
            let getterBody = getter.functionBody ?? FunctionBodyIntention(body: [])
            
            propertySet.property.mode = .computed(getterBody)
            
            // Remove the original method intention
            classIntention.removeMethod(getter)
            
            classIntention
                .history
                .recordChange(tag: historyTag,
                              description: """
                    Merged getter method \(TypeFormatter.asString(method: getter, ofType: classIntention)) \
                    into the getter-only property \(TypeFormatter.asString(property: propertySet.property, ofType: classIntention))
                    """, relatedIntentions: [propertySet.property, getterBody])
                .echoRecord(to: propertySet.property)
                .echoRecord(to: getterBody)
            
            operationsNumber += 1
            
        // Setter-only: Synthesize the backing field of the property and expose
        // a default getter `return _field` and the found setter.
        case let (nil, setter?):
            classIntention.removeMethod(setter)
            
            guard let setterBody = setter.functionBody else {
                break
            }
            
            let backingFieldName = "_" + propertySet.property.name
            let newSetter =
                PropertyGenerationIntention
                    .Setter(valueIdentifier: setter.parameters[0].name,
                            body: setterBody)
            
            // Synthesize a simple getter that has the following statement within:
            // return self._backingField
            let getterIntention =
                FunctionBodyIntention(body: [.return(.identifier(backingFieldName))],
                                      source: propertySet.setter?.functionBody?.source)
            
            propertySet.property.mode = .property(get: getterIntention, set: newSetter)
            
            let field =
                InstanceVariableGenerationIntention(name: backingFieldName,
                                                    storage: propertySet.property.storage,
                                                    accessLevel: .private,
                                                    source: propertySet.property.source)
            
            classIntention.addInstanceVariable(field)
            
            classIntention
                .history
                .recordChange(tag: historyTag,
                              description: """
                    Merged found setter method \(TypeFormatter.asString(method: setter, ofType: classIntention)) \
                    into property \(TypeFormatter.asString(property: propertySet.property, ofType: classIntention)) \
                    and creating a getter body + synthesized backing field \(TypeFormatter.asString(field: field, ofType: classIntention))
                    """, relatedIntentions: [field, setter, propertySet.property])
                .echoRecord(to: field)
                .echoRecord(to: setter)
                .echoRecord(to: propertySet.property)
            
            operationsNumber += 1
        default:
            break
        }
    }
    
    private struct PropertySet {
        var property: PropertyGenerationIntention
        var getter: MethodGenerationIntention?
        var setter: MethodGenerationIntention?
    }
}
