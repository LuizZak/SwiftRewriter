import Intentions
import SwiftAST

/// Detects [objectAtIndexSubscript:] and [setObject:atIndexedSubscript:] methods
/// and converts them into proper subscript declarations.
public class SubscriptDeclarationPass: ClassVisitingIntentionPass {
    public override init() {
        
    }
    
    override func applyOnType(_ type: TypeGenerationIntention) {
        let getterSign
            = FunctionIdentifier(name: "objectAtIndexSubscript",
                                 parameterNames: [nil])
        let setterSign
            = FunctionIdentifier(name: "setObject",
                                 parameterNames: [nil, "atIndexedSubscript"])
        
        let getters = type.methods(matching: getterSign)
        let setters = type.methods(matching: setterSign)
        
        analyze(type, getters, setters)
    }
    
    func analyze(_ type: TypeGenerationIntention,
                 _ getters: [MethodGenerationIntention],
                 _ setters: [MethodGenerationIntention]) {
        
        // Pair getters/setters according to their index types and return types
        var matches: [Match] = []
        
        for getter in getters where getter.returnType != .void {
            matches.append(.getter(getter))
        }
        
        for setter in setters where setter.returnType == .void {
            for (i, match) in matches.enumerated() {
                switch match {
                case .getter(let getter):
                    if getterSetterMatch(getter, setter) {
                        matches[i] = .getterSetter(getter, setter)
                    }
                default:
                    break
                }
            }
        }
        
        for match in matches {
            apply(match, in: type)
        }
        
        if !matches.isEmpty {
            notifyChange()
        }
    }
    
    func apply(_ match: Match, in type: TypeGenerationIntention) {
        switch match {
        case .getter(let method):
            let sub = toGetter(method)
            type.addSubscript(sub)
            
            type.removeMethod(method)
            
        case let .getterSetter(getter, setter):
            let sub = toGetterSetter(getter, setter)
            type.addSubscript(sub)
            
            type.removeMethod(getter)
            type.removeMethod(setter)
        }
    }
    
    func toGetter(_ method: MethodGenerationIntention) -> SubscriptGenerationIntention {
        let parameters = [
            ParameterSignature(name: method.parameters[0].name,
                               type: method.parameters[0].type)
        ]
        let sub = SubscriptGenerationIntention(
            parameters: parameters,
            returnType: method.returnType,
            mode: .getter(method.functionBody ?? FunctionBodyIntention(body: [])),
            accessLevel: method.accessLevel,
            source: nil)
        
        sub.history.mergeHistories(method.history)
        sub.history.recordCreation(description: "Creating subscript declaration from objectAtIndexSubscript(_:) method")
        sub.precedingComments = method.precedingComments
        
        return sub
    }
    
    func toGetterSetter(_ getter: MethodGenerationIntention,
                        _ setter: MethodGenerationIntention) -> SubscriptGenerationIntention {
        
        let parameters = [
            ParameterSignature(name: getter.parameters[0].name, type: getter.parameters[0].type)
        ]
        let getterBody = getter.functionBody ?? FunctionBodyIntention(body: [])
        let setterMode: PropertyGenerationIntention.Setter =
            .init(valueIdentifier: setter.parameters[0].name,
                  body: setter.functionBody ?? FunctionBodyIntention(body: []))
        
        // TODO: Derive access levels when they differ between getter and setter
        let sub = SubscriptGenerationIntention(
            parameters: parameters,
            returnType: getter.returnType,
            mode: .getterAndSetter(get: getterBody, set: setterMode),
            accessLevel: getter.accessLevel,
            source: nil)
        
        sub.history.mergeHistories(getter.history)
        sub.history.mergeHistories(setter.history)
        sub.history.recordMerge(with: [getter, setter],
                                tag: "Creation",
                                description: "Creating subscript declaration from objectAtIndexSubscript(_:) and setObject(_:atIndexedSubscript:) pair")
        sub.precedingComments = getter.precedingComments + setter.precedingComments
        
        return sub
    }
    
    func getterSetterMatch(_ getter: MethodGenerationIntention,
                           _ setter: MethodGenerationIntention) -> Bool {
        
        let objectsMatch = context.typeSystem.typesMatch(getter.returnType,
                                                         setter.parameters[0].type,
                                                         ignoreNullability: true)
        
        let indexesMatch = context.typeSystem.typesMatch(getter.parameters[0].type,
                                                         setter.parameters[1].type,
                                                         ignoreNullability: true)
        
        return objectsMatch && indexesMatch
    }
    
    enum Match {
        case getter(MethodGenerationIntention)
        case getterSetter(MethodGenerationIntention, MethodGenerationIntention)
    }
}
