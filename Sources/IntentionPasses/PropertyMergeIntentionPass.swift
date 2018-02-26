import SwiftRewriterLib
import SwiftAST


public class PropertyMergeIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        for file in intentionCollection.fileIntentions() {
            
            for cls in file.typeIntentions.compactMap({ $0 as? ClassGenerationIntention }) {
                apply(on: cls)
            }
        }
    }
    
    func apply(on classIntention: ClassGenerationIntention) {
        let properties = collectProperties(fromClass: classIntention)
        let methods = collectMethods(fromClass: classIntention)
        
        // Match property intentions with the appropriately named methods
        var matches: [PropertySet] = []
        
        for property in properties where property.name.count > 1 {
            let expectedName = "set" + property.name.uppercasedFirstLetter
            
            // Getters
            let potentialGetters =
                methods.filter { $0.name == property.name }
                    .filter { $0.returnType.deepUnwrapped == property.type.deepUnwrapped }
                    .filter { $0.parameters.count == 0 }
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
    
    func collectProperties(fromClass classIntention: ClassGenerationIntention) -> [PropertyGenerationIntention] {
        return classIntention.properties
    }
    
    func collectMethods(fromClass classIntention: ClassGenerationIntention) -> [MethodGenerationIntention] {
        return classIntention.methods
    }
    
    /// From a given found joined set of @property definition and potential
    /// getter/setter definitions, reworks the intented signatures on the class
    /// definition such that properties are correctly flattened with their non-synthesized
    /// getter/setters into `var myVar { get set }` Swift computed properties.
    private func joinPropertySet(_ propertySet: PropertySet, on classIntention: ClassGenerationIntention) {
        switch (propertySet.getter, propertySet.setter) {
        case let (getter?, setter?):
            if let getterBody = getter.functionBody, let setterBody = setter.functionBody {
                let setter =
                    PropertyGenerationIntention
                        .Setter(valueIdentifier: setter.parameters[0].name,
                                body: setterBody)
                
                propertySet.property.mode =
                    .property(get: getterBody, set: setter)
            }
            
            // Remove the original method intentions
            classIntention.removeMethod(getter)
            classIntention.removeMethod(setter)
            
        case let (getter?, nil) where propertySet.property.isSourceReadOnly:
            if let body = getter.functionBody {
                propertySet.property.mode = .computed(body)
            }
            
            // Remove the original method intention
            classIntention.removeMethod(getter)
            
        case let (nil, setter?):
            classIntention.removeMethod(setter)
            
            guard let setterBody = setter.functionBody else {
                break
            }
            
            let backingFieldName = "_" + propertySet.property.name
            let setter =
                PropertyGenerationIntention
                    .Setter(valueIdentifier: setter.parameters[0].name,
                            body: setterBody)
            
            // Synthesize a simple getter that has the following statement within:
            // return self._backingField
            let getterIntention =
                FunctionBodyIntention(body: [.return(.identifier(backingFieldName))],
                                      source: propertySet.setter?.functionBody?.source)
            
            propertySet.property.mode = .property(get: getterIntention, set: setter)
            
            let field =
                InstanceVariableGenerationIntention(name: backingFieldName,
                                                    storage: propertySet.property.storage,
                                                    accessLevel: .private,
                                                    source: propertySet.property.source)
            
            classIntention.addInstanceVariable(field)
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
