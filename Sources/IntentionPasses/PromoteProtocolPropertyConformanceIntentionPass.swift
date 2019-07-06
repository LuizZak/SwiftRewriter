import SwiftAST
import KnownType
import Intentions

/// Searches for matching property protocol conformance implementations in types
/// and promotes them into getter or getter/setter property pairs.
public class PromoteProtocolPropertyConformanceIntentionPass: IntentionPass {
    private var intentions: IntentionCollection!
    private var context: IntentionPassContext!
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        "\(PromoteProtocolPropertyConformanceIntentionPass.self)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection,
                      context: IntentionPassContext) {
        
        self.intentions = intentionCollection
        self.context = context
        
        let types =
            intentionCollection
                .typeIntentions()
                .compactMap { $0 as? BaseClassIntention }
        
        context.typeSystem.makeCache()
        
        for type in types where !type.isInterfaceSource {
            guard let knownType = context.typeSystem.knownTypeWithName(type.typeName) else {
                continue
            }
            
            let protocols = knownType.knownProtocolConformances
            
            for prot in protocols {
                guard let protType = context.typeSystem.knownTypeWithName(prot.protocolName) else {
                    continue
                }
                guard protType.kind == .protocol else {
                    continue
                }
                
                let interfaces = types.filter {
                    $0 !== type && $0.typeName == $0.typeName && $0.isInterfaceSource
                }
                
                apply(to: type, interfaces: interfaces, protocol: protType)
            }
        }
        
        context.typeSystem.tearDownCache()
    }
    
    private func apply(to type: BaseClassIntention,
                       interfaces: [BaseClassIntention],
                       protocol prot: KnownType) {
        
        for prop in prot.knownProperties {
            if interfaces.contains(where: { $0.hasProperty(named: prop.name) }) {
                continue
            }
            if type.hasProperty(named: prop.name) {
                continue
            }
            
            let ident = FunctionIdentifier(name: prop.name, parameterNames: [])
            let methods = type.methods(matching: ident)
            guard methods.count == 1 else {
                continue
            }
            
            if methods[0].returnType.deepUnwrapped == prop.memberType.deepUnwrapped {
                type.removeMethod(methods[0])
                
                let property =
                    PropertyGenerationIntention(name: prop.name,
                                                type: prop.memberType,
                                                attributes: prop.attributes)
                property
                    .history
                    .recordCreation(description: """
                        Transformed from method implementation \
                        \(TypeFormatter.asString(method: methods[0], ofType: type)) \
                        into a property due to a matching property requirement \
                        from protocol: \(TypeFormatter.asString(property: prop, ofType: prot))
                        """)
                
                if let body = methods[0].functionBody {
                    property.history.mergeHistories(methods[0].history)
                    property.mode = .computed(body)
                }
                
                type.addProperty(property)
            }
        }
    }
}
