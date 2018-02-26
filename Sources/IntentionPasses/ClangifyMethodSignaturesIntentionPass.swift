import SwiftRewriterLib
import SwiftAST

// TODO: Move task of converting `init` methods to a separate intention pass.

/// Performs Clang-style alterations of method signatures to attempt to match
/// somewhat its behavior when coming up with Swift names for Objective-C methods.
///
/// Examples include [[Class alloc] initWithThing:thing] -> Class(thing: thing)
public class ClangifyMethodSignaturesIntentionPass: IntentionPass {
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection, context: IntentionPassContext) {
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
                
                type.addConstructor(initIntention)
            }
        }
    }
    
    private func apply(on method: MethodGenerationIntention) {
        if method.signature.name.contains("With") && method.signature.parameters.count > 0 {
            applyWithNameConversion(to: method)
        }
    }
    
    private func applyWithNameConversion(to method: MethodGenerationIntention) {
        let signature = method.signature
        
        let splitOnWith = signature.name.components(separatedBy: "With")
        if splitOnWith.count != 2 || splitOnWith.contains(where: { $0.count < 2 }) {
            return
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
            
            return
        }
        
        // Do a little Clang-like-magic here: If the method selector is in the
        // form `loremWithThing:thing...`, where after a `[...]With` prefix, a
        // noun is followed by a parameter that has the same name, we collapse
        // such selector in Swift as `lorem(with:)`.
        if splitOnWith[1].lowercased() != signature.parameters[0].name.lowercased() {
            return
        }
        
        // All good! Collapse the identifier into a more 'swifty' construct
        method.signature.name = splitOnWith[0]
        
        // Init works slightly different: We leave the first label as the
        // noun found after "With"
        if splitOnWith[0] == "init" {
            method.signature.parameters[0].label = splitOnWith[1].lowercased()
        } else {
            method.signature.parameters[0].label = "with"
        }
    }
}

