import SwiftAST
import KnownType
import Intentions

// TODO: Move task of converting `init` methods to a separate intention pass.

/// Performs Swift-importer-style alterations of method signatures to attempt to
/// match somewhat its behavior when coming up with Swift names for Objective-C
/// methods.
///
/// Examples include [[Class alloc] initWithThing:thing] -> Class(thing: thing)
public class SwiftifyMethodSignaturesIntentionPass: IntentionPass {
    /// A number representing the unique index of an operation to aid in history
    /// checking by tag.
    /// Represents the number of operations applied by this intention pass while
    /// instantiated, +1.
    private var operationsNumber: Int = 1
    
    var context: IntentionPassContext!
    
    /// Textual tag this intention pass applies to history tracking entries.
    private var historyTag: String {
        "\(SwiftifyMethodSignaturesIntentionPass.self):\(operationsNumber)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
        operationsNumber = 1
        
        self.context = context
        
        let types = intentionCollection.typeIntentions()
        
        for type in types {
            apply(on: type)
        }
    }
    
    private func apply(on type: TypeGenerationIntention) {
        let methods = type.methods
        
        for method in methods {
            apply(on: method)
            
            // Check methods that where turned into initializers
            if !method.signature.isStatic && method.signature.name == "init" &&
                method.returnType != .void {
                type.removeMethod(method)
                
                let initIntention =
                    InitGenerationIntention(parameters: method.signature.parameters,
                                            accessLevel: method.accessLevel)
                
                initIntention.isOverride = method.isOverride
                initIntention.inNonnullContext = method.inNonnullContext
                initIntention.functionBody = method.functionBody
                initIntention.isFallible =
                    method.returnType.isOptional
                        && !method.returnType.isNullabilityUnspecified
                
                initIntention.history
                    .recordCreation(description: """
                        Converted from original init-like method \
                        \(TypeFormatter.asString(signature: method.signature, includeName: true)) \
                        to init \
                        \(TypeFormatter.asString(parameters: initIntention.parameters))
                        """)
                
                operationsNumber += 1
                
                context.notifyChange()
                
                type.addConstructor(initIntention)
            }
        }
    }
    
    private func apply(on method: MethodGenerationIntention) {
        if !method.signature.name.contains("With") || method.signature.parameters.isEmpty {
            return
        }
        
        if applyInitConversion(to: method) {
            return
        }
        
        _=applyWithNameConversion(to: method)
    }
    
    private func applyInitConversion(to method: MethodGenerationIntention) -> Bool {
        let signature = method.signature
        
        guard !signature.isStatic else {
            return false
        }
        guard method.returnType != .void else {
            return false
        }
        
        // Check `initWith<...>` prefix
        let splitOnWith = signature.name.components(separatedBy: "With")
        if splitOnWith.count != 2 || splitOnWith.contains(where: \.isEmpty) {
            return false
        }
        if !splitOnWith[0].hasPrefix("init") {
            return false
        }
        
        method.signature.parameters[0].label = splitOnWith[1].lowercasedFirstLetter
        method.signature.name = "init"
        method.history
            .recordChange(tag: historyTag,
                          description: """
                Swiftified signature from \(TypeFormatter.asString(signature: signature, includeName: true)) \
                to \(TypeFormatter.asString(signature: method.signature, includeName: true))
                """, relatedIntentions: [])
        
        operationsNumber += 1
        
        context.notifyChange()
        
        return true
    }
    
    private func applyWithNameConversion(to method: MethodGenerationIntention) -> Bool {
        let signature = method.signature
        
        let splitOnWith = signature.name.components(separatedBy: "With")
        if splitOnWith.count != 2 || splitOnWith.contains(where: \.isEmpty) {
            return false
        }
        
        let lowercaseNoun = splitOnWith[1].lowercased()
        
        // Do a little Swift-importer-like-magic here: If the method selector is
        // in the form `loremWithThing:thing...`, where after a `[...]With` prefix,
        // a noun is followed by a parameter that has the same name, we collapse
        // such selector in Swift as `lorem(with:)`.
        if lowercaseNoun != signature.parameters[0].name.lowercased() {
            return false
        }
        
        // All good! Collapse the identifier into a more 'swifty' construct
        // Init works slightly different: We leave the first label as the
        // noun found after "With"
        if splitOnWith[0] == "init" {
            method.signature.parameters[0].label = splitOnWith[1].lowercased()
        } else {
            let mapper = context.typeMapper
            
            // Only match if the suffix also matches at least partially the typename
            let type = signature.parameters[0].type
            if !type.isNominal || !mapper.typeNameString(for: type).lowercased().hasSuffix(lowercaseNoun) {
                return false
            }
            
            method.signature.parameters[0].label = "with"
        }
        
        method.signature.name = splitOnWith[0]
        
        method.history
            .recordChange(tag: historyTag,
                          description: """
            Swiftified signature from \(TypeFormatter.asString(signature: signature, includeName: true)) \
            to \(TypeFormatter.asString(signature: method.signature, includeName: true))
            """, relatedIntentions: [])
        
        operationsNumber += 1
        
        context.notifyChange()
        
        return true
    }
}
