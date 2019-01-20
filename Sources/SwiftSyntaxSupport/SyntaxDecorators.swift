import Intentions
import SwiftSyntax

class ModifiersSyntaxDecoratorApplier {
    /// Creates and returns a modifiers decorator with all default modifier decorators
    /// setup.
    static func makeDefaultDecoratorApplier() -> ModifiersSyntaxDecoratorApplier {
        let decorator = ModifiersSyntaxDecoratorApplier()
        decorator.addDecorator(AccessLevelModifiersDecorator())
        decorator.addDecorator(StaticModifiersDecorator())
        decorator.addDecorator(MutatingModifiersDecorator())
        return decorator
    }
    
    private var decorators: [ModifiersSyntaxDecorator] = []
    
    func addDecorator(_ decorator: ModifiersSyntaxDecorator) {
        decorators.append(decorator)
    }
    
    func modifiers(for intention: IntentionProtocol, extraLeading: inout Trivia?) -> [DeclModifierSyntax] {
        var list: [DeclModifierSyntax] = []
        
        for decorator in decorators {
            decorator.appendModifiers(for: intention, &list, extraLeading: &extraLeading)
        }
        
        return list
    }
}

protocol ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?)
}

/// Decorator for adding `mutating` modifiers to methods
class MutatingModifiersDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let method = intention as? MethodGenerationIntention else {
            return
        }
        if method.type is BaseClassIntention {
            return
        }
        
        if method.signature.isMutating {
            list.append(SyntaxFactory
                .makeDeclModifier(
                    name: makeIdentifier("mutating")
                        .addingTrailingSpace()
                        .withExtraLeading(consuming: &extraLeading),
                    detail: nil
                )
            )
        }
    }
}

/// Decorator that applies `static` to static members of types
class StaticModifiersDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let intention = intention as? MemberGenerationIntention else {
            return
        }
        
        if intention.isStatic {
            list.append(SyntaxFactory
                .makeDeclModifier(
                    name: SyntaxFactory
                        .makeStaticKeyword()
                        .addingTrailingSpace()
                        .withExtraLeading(consuming: &extraLeading),
                    detail: nil)
            )
        }
    }
}

/// Decorator that appends access level to declarations
class AccessLevelModifiersDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let intention = intention as? FromSourceIntention else {
            return
        }
        
        let token: TokenSyntax
        
        switch intention.accessLevel {
        case .internal:
            // We don't emit `internal` explicitly by default here
            return
            
        case .open:
            // TODO: There's no `open` keyword currently in the SwiftSyntax version
            // we're using;
            token = SyntaxFactory.makeIdentifier("open")
            
        case .private:
            token = SyntaxFactory.makePrivateKeyword()
            
        case .fileprivate:
            token = SyntaxFactory.makeFileprivateKeyword()
            
        case .public:
            token = SyntaxFactory.makePublicKeyword()
        }
        
        let modifier =
            SyntaxFactory
                .makeDeclModifier(
                    name: token
                        .addingTrailingSpace()
                        .withExtraLeading(consuming: &extraLeading),
                    detail: nil
                )
        
        list.append(modifier)
    }
}
