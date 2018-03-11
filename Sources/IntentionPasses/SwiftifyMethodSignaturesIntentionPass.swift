import SwiftRewriterLib
import SwiftAST

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
        return "\(SwiftifyMethodSignaturesIntentionPass.self):\(operationsNumber)"
    }
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
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
                                            accessLevel: method.accessLevel,
                                            source: method.source)
                initIntention.inNonnullContext = method.inNonnullContext
                initIntention.functionBody = method.functionBody
                
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
        if splitOnWith.count != 2 || splitOnWith.contains(where: { $0.isEmpty }) {
            return false
        }
        if !splitOnWith[0].hasPrefix("init") {
            return false
        }
        
        method.signature.parameters[0].label = splitOnWith[1].lowercasedFirstLetter
        method.signature.name = "init"
        
        context.notifyChange()
        
        return true
    }
    
    private func applyWithNameConversion(to method: MethodGenerationIntention) -> Bool {
        let signature = method.signature
        
        let splitOnWith = signature.name.components(separatedBy: "With")
        if splitOnWith.count != 2 || splitOnWith.contains(where: { $0.isEmpty }) {
            return false
        }
        
        // If the prefix of a static method begins with the suffix of its type
        // name, and has a `-WithThing:[...]` suffix, create an initializer.
        staticHandler:
            if method.isStatic, let type = method.type {
            guard let rangeOfName = type.typeName.range(of: splitOnWith[0], options: .caseInsensitive) else {
                break staticHandler
            }
            
            // Check if the type's suffix is equal to the method's prefix up to
            // 'with':
            //
            // MyClass.classWithThing(<...>)
            //
            // matches the rule since 'class' is the common suffix/prefix:
            //
            // My | Class |
            //    | class | WithThing
            //
            // Camel casing is ignored (text is always compared lower-cased)
            guard rangeOfName.upperBound == type.typeName.endIndex else {
                break staticHandler
            }
            
            // Method's return type must match its containing type, or an
            // `instancetype`
            let returnType = method.signature.returnType.deepUnwrapped
            if case .typeName(type.typeName) = returnType {
                // All good!
            } else if returnType == .instancetype {
                // All good as well!
            } else {
                break staticHandler // Invalid return type :(
            }
            
            method.signature.isStatic = false
            method.signature.name = "init"
            method.signature.parameters[0].label = splitOnWith[1].lowercasedFirstLetter
            
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
