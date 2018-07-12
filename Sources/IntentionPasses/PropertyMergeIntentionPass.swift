import SwiftRewriterLib
import SwiftAST

public class PropertyMergeIntentionPass: IntentionPass {
    /// A number representing the unique index of an operation to aid in history
    /// checking by tag.
    /// Represents the number of operations applied by this intention pass while
    /// instantiated, +1.
    private var operationsNumber: Int = 1
    
    private var intentions: IntentionCollection!
    private var context: IntentionPassContext!
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        return "\(PropertyMergeIntentionPass.self):\(operationsNumber)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        self.intentions = intentionCollection
        self.context = context
        
        let typeSystem = context.typeSystem as? IntentionCollectionTypeSystem
        typeSystem?.makeCache()
        
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
        
        typeSystem?.tearDownCache()
        
        // Flatten properties now
        for match in matches {
            let acted = joinPropertySet(match, on: match.classIntention)
            
            // If no action was taken, look into synthesizing a backing field
            // anyway, due to usage of backing field in any method of the type
            if !acted {
                synthesizeBackingFieldIfUsing(in: match.classIntention, for: match.property)
                adjustPropertySetterAccessLevel(in: match.classIntention, for: match.property)
            }
        }
    }
    
    private func collectMatches(in classIntention: BaseClassIntention) -> [PropertySet] {
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
                    .filter { $0.isStatic == property.isStatic }
                    .filter {
                        context.typeSystem
                            .typesMatch($0.returnType,
                                        property.type,
                                        ignoreNullability: true)
                    }
                    .filter { $0.parameters.isEmpty }
            
            // Setters: All methods named `func set[Name](_ name: Type)` where
            // `[Name]` is the same as the property's name with the first letter
            // uppercased
            let potentialSetters =
                methods.filter { $0.returnType == .void }
                    .filter { $0.isStatic == property.isStatic }
                    .filter { $0.parameters.count == 1 }
                    .filter {
                        context.typeSystem
                            .typesMatch($0.parameters[0].type,
                                        property.type,
                                        ignoreNullability: true)
                    }
                    .filter { $0.name == expectedName }
            
            var propSet =
                PropertySet(classIntention: classIntention, property: property,
                            getter: nil, setter: nil)
            
            if potentialGetters.count == 1 {
                propSet.getter = potentialGetters[0]
            }
            if potentialSetters.count == 1 {
                propSet.setter = potentialSetters[0]
            }
            
            matches.append(propSet)
        }
        
        return matches
    }
    
    func collectProperties(fromClass classIntention: BaseClassIntention) -> [PropertyGenerationIntention] {
        var props: [PropertyGenerationIntention] = []
        
        for file in intentions.fileIntentions() {
            for type in file.typeIntentions where type.typeName == classIntention.typeName {
                props.append(contentsOf: type.properties)
            }
        }
        
        return props
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
    
    private func adjustPropertySetterAccessLevel(in type: BaseClassIntention,
                                                 for property: PropertyGenerationIntention) {
        
        let backingField = backingFieldName(for: property, in: type)
        guard backingField == property.name else {
            return
        }
        
        if let field = context.typeSystem.field(named: backingField, static: false, in: type) as? InstanceVariableGenerationIntention {
            property.setterAccessLevel = field.accessLevel
        } else {
            // Private by default, for get-only properties
            property.setterAccessLevel = property.isReadOnly ? .private : nil
        }
    }
    
    private func synthesizeBackingFieldIfUsing(in type: BaseClassIntention,
                                               for property: PropertyGenerationIntention) {
        
        let fieldName = backingFieldName(for: property, in: type)
        // Ignore backing fields that end up having the same name as the property
        // as this can be confusing later when looking for backing field usages
        if fieldName == property.name {
            return
        }
        
        func collectMethodBodies(fromClass classIntention: BaseClassIntention) -> [(FunctionBodyIntention, source: String)] {
            var bodies: [(FunctionBodyIntention, source: String)] = []
            
            for method in collectMethods(fromClass: classIntention) {
                if let body = method.functionBody {
                    let source =
                        TypeFormatter
                            .asString(method: method,
                                      ofType: classIntention)
                    
                    bodies.append((body, source))
                }
            }
            
            for prop in collectProperties(fromClass: classIntention) {
                if let getter = prop.getter {
                    let source =
                        TypeFormatter
                            .asString(property: prop, ofType: classIntention)
                            + ":getter"
                    
                    bodies.append((getter, source))
                }
                if let setter = prop.setter {
                    let source =
                        TypeFormatter
                            .asString(property: prop, ofType: classIntention)
                            + ":setter"
                    bodies.append((setter.body, source))
                }
            }
            
            return bodies
        }
        
        let bodies = collectMethodBodies(fromClass: type)
        
        for (body, source) in bodies {
            let matches =
                SyntaxNodeSequence(node: body.body, inspectBlocks: true)
                    .lazy
                    .compactMap { node in node as? Expression }
                    .contains { exp in
                        switch exp {
                        case let identifier as IdentifierExpression where identifier.identifier == fieldName:
                            // Match only if identifier matched to nothing yet
                            return identifier.definition == nil
                            
                        case let postfix as PostfixExpression where postfix.member?.name == fieldName:
                            // Direct `self` access
                            if postfix.exp.asIdentifier?.identifier == "self" {
                                return true
                            }
                            // Indirect type access
                            if postfix.exp.resolvedType?.unwrapped == .typeName(type.typeName) {
                                return true
                            }
                            
                            return false
                        default:
                            return false
                        }
                    }
            
            if matches {
                let field = synthesizeBackingField(for: property, in: type)
                
                let mode: PropertyGenerationIntention.Mode
                
                let getter =
                    FunctionBodyIntention(body: [
                        .return(.postfix(.identifier("self"), .member(fieldName)))
                    ])
                
                // If the property is marked read-only, synthesize the backing
                // field only.
                if property.isReadOnly {
                    mode = .computed(getter)
                } else {
                    let setter =
                        FunctionBodyIntention(body: [
                            .expression(
                                .assignment(lhs: .postfix(.identifier("self"), .member(fieldName)),
                                            op: .assign,
                                            rhs: .identifier("newValue"))
                            )
                        ])
                    
                    mode = .property(get: getter, set: .init(valueIdentifier: "newValue", body: setter))
                }
                
                property.mode = mode
                
                type.history
                    .recordChange(tag: historyTag,
                                  description: """
                        Created field \(TypeFormatter.asString(field: field, ofType: type)) \
                        as it was detected that the backing field of \
                        \(TypeFormatter.asString(property: property, ofType: type)) (\(fieldName)) \
                        was being used in \(source).
                        """)
                    .echoRecord(to: property)
                    .echoRecord(to: field)
                
                operationsNumber += 1
                
                context.notifyChange()
                
                return
            }
        }
    }
    
    /// From a given found joined set of @property definition and potential
    /// getter/setter definitions, reworks the intented signatures on the class
    /// definition such that properties are correctly flattened with their non-synthesized
    /// getter/setters into `var myVar { get set }` Swift computed properties.
    ///
    /// Returns `false` if the method ended up making no changes.
    // swiftlint:disable function_body_length
    private func joinPropertySet(_ propertySet: PropertySet, on classIntention: BaseClassIntention) -> Bool {
        guard let propertyOwner = propertySet.property.type else {
            return false
        }
        
        switch (propertySet.getter, propertySet.setter) {
        // Getter and setter: Create a property with `{ get { [...] } set { [...] }`
        case let (getter?, setter?):
            guard let getterOwner = getter.type, let setterOwner = setter.type else {
                return false
            }
            
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
            getterOwner.removeMethod(getter)
            setterOwner.removeMethod(setter)
            
            propertySet.property
                .history
                .recordChange(tag: historyTag,
                              description: """
                    Merged \(TypeFormatter.asString(method: getter, ofType: propertyOwner)) \
                    and \(TypeFormatter.asString(method: setter, ofType: propertyOwner)) \
                    into property \(TypeFormatter.asString(property: propertySet.property, ofType: propertyOwner))
                    """, relatedIntentions: [getter, setter, propertySet.property])
            
            getterOwner.history
                .recordChange(tag: historyTag,
                              description: """
                    Removed method \(TypeFormatter.asString(method: getter, ofType: getterOwner)) since deduced it \
                    is a getter for property \
                    \(TypeFormatter.asString(property: propertySet.property, ofType: getterOwner))
                    """)
            
            setterOwner.history
                .recordChange(tag: historyTag,
                              description: """
                    Removed method \(TypeFormatter.asString(method: setter, ofType: setterOwner)) since deduced it \
                    is a setter for property \
                    \(TypeFormatter.asString(property: propertySet.property, ofType: setterOwner))
                    """)
            
            operationsNumber += 1
            
            context.notifyChange()
            
            return true
            
        // Getter-only on readonly property: Create computed property.
        case let (getter?, nil) where propertySet.property.isReadOnly:
            guard let getterOwner = getter.type else {
                return false
            }
            
            let getterBody = getter.functionBody ?? FunctionBodyIntention(body: [])
            
            propertySet.property.mode = .computed(getterBody)
            
            // Remove the original method intention
            getterOwner.removeMethod(getter)
            
            getterOwner
                .history
                .recordChange(tag: historyTag,
                              description: """
                    Merged getter method \(TypeFormatter.asString(method: getter, ofType: getterOwner)) \
                    into the getter-only property \
                    \(TypeFormatter.asString(property: propertySet.property, ofType: getterOwner))
                    """, relatedIntentions: [propertySet.property, getterBody])
                .echoRecord(to: propertySet.property)
                .echoRecord(to: getterBody)
            
            operationsNumber += 1
            
            context.notifyChange()
            
            return true
            
        // Setter-only: Synthesize the backing field of the property and expose
        // a default getter `return _field` and the found setter.
        case let (nil, setter?):
            guard let setterOwner = setter.type else {
                return false
            }
            
            setterOwner.removeMethod(setter)
            
            guard let setterBody = setter.functionBody else {
                return true
            }
            
            let backingFieldName =
                self.backingFieldName(for: propertySet.property, in: classIntention)
            
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
            
            // Existing backing field
            if classIntention.hasInstanceVariable(named: backingFieldName) {
                setterOwner
                    .history
                    .recordChange(tag: historyTag,
                                  description: """
                        Merged found setter method \(TypeFormatter.asString(method: setter, ofType: setterOwner)) \
                        into property \(TypeFormatter.asString(property: propertySet.property, ofType: setterOwner)) \
                        and creating a getter body returning existing backing field \(backingFieldName)
                        """, relatedIntentions: [setter, propertySet.property])
                    .echoRecord(to: setter)
                    .echoRecord(to: propertySet.property)
            } else {
                let field = synthesizeBackingField(for: propertySet.property, in: classIntention)
                
                setterOwner
                    .history
                    .recordChange(tag: historyTag,
                                  description: """
                        Merged found setter method \(TypeFormatter.asString(method: setter, ofType: setterOwner)) \
                        into property \(TypeFormatter.asString(property: propertySet.property, ofType: setterOwner)) \
                        and creating a getter body + synthesized backing field \
                        \(TypeFormatter.asString(field: field, ofType: setterOwner))
                        """, relatedIntentions: [field, setter, propertySet.property])
                    .echoRecord(to: field)
                    .echoRecord(to: setter)
                    .echoRecord(to: propertySet.property)
            }
            
            operationsNumber += 1
            
            context.notifyChange()
            
            return true
        default:
            return false
        }
    }
    // swiftlint:enable function_body_length
    
    private func backingFieldName(for property: PropertyGenerationIntention,
                                  in type: BaseClassIntention) -> String {
        // Check presence of `@synthesize` to make sure we use the correct
        // backing field name for the property
        if let synth = type.synthesizations.first(where: { $0.propertyName == property.name }) {
            return synth.ivarName
        }
        
        return "_" + property.name
    }
    
    private func synthesizeBackingField(for property: PropertyGenerationIntention,
                                        in type: BaseClassIntention) -> InstanceVariableGenerationIntention {
        
        let name = backingFieldName(for: property, in: type)
        
        if let ivar = type.instanceVariables.first(where: { $0.name == name }) {
            return ivar
        }
        
        let field =
            InstanceVariableGenerationIntention(name: name,
                                                storage: property.storage,
                                                accessLevel: .private,
                                                source: property.source)
        
        type.addInstanceVariable(field)
        
        context.notifyChange()
        
        return field
    }
    
    private struct PropertySet {
        var classIntention: BaseClassIntention
        var property: PropertyGenerationIntention
        var getter: MethodGenerationIntention?
        var setter: MethodGenerationIntention?
    }
}
