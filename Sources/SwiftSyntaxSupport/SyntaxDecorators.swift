import Intentions
import SwiftAST
import SwiftSyntax

class ModifiersSyntaxDecoratorApplier {
    /// Creates and returns a modifiers decorator with all default modifier decorators
    /// setup.
    static func makeDefaultDecoratorApplier() -> ModifiersSyntaxDecoratorApplier {
        let decorator = ModifiersSyntaxDecoratorApplier()
        decorator.addDecorator(AccessLevelModifiersDecorator())
        decorator.addDecorator(PropertySetterAccessModifiersDecorator())
        decorator.addDecorator(ProtocolOptionalModifierDecorator())
        decorator.addDecorator(StaticModifiersDecorator())
        decorator.addDecorator(OverrideModifierDecorator())
        decorator.addDecorator(ConvenienceInitModifierDecorator())
        decorator.addDecorator(MutatingModifiersDecorator())
        decorator.addDecorator(OwnershipModifierDecorator())
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
        
        guard let token = _accessModifierFor(accessLevel: intention.accessLevel, omitInternal: true) else {
            return
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

/// Decorator that adds `public(set)`, `internal(set)`, `fileprivate(set)`, `private(set)`
/// setter modifiers to properties and instance variables
class PropertySetterAccessModifiersDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let prop = intention as? PropertyGenerationIntention else {
            return
        }
        
        guard let setterLevel = prop.setterAccessLevel, prop.accessLevel.isMoreVisible(than: setterLevel) else {
            return
        }
        guard let setterAccessLevel = _accessModifierFor(accessLevel: setterLevel, omitInternal: true) else {
            return
        }
                
        let decl = DeclModifierSyntax { builder in
            builder.useName(setterAccessLevel.withExtraLeading(consuming: &extraLeading))
            builder.addToken(SyntaxFactory.makeLeftParenToken())
            builder.addToken(makeIdentifier("set"))
            builder.addToken(SyntaxFactory.makeRightParenToken().withTrailingSpace())
        }
        
        list.append(decl)
    }
}

/// Decorator that applies `weak`, `unowned(safe)`, and `unowned(unsafe)`
/// modifiers to variable declarations
class OwnershipModifierDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let intention = intention as? ValueStorageIntention else {
            return
        }
        
        let token: TokenSyntax
        let detail: TokenListSyntax?
        
        switch intention.ownership {
        case .strong:
            return
            
        case .weak:
            token = makeIdentifier("weak").addingTrailingSpace()
            detail = nil
            
        case .unownedSafe:
            token = makeIdentifier("unowned")
            detail = SyntaxFactory
                .makeTokenList([
                    SyntaxFactory.makeLeftParenToken(),
                    makeIdentifier("safe"),
                    SyntaxFactory.makeRightParenToken().withTrailingSpace()
                    ])
            
        case .unownedUnsafe:
            token = makeIdentifier("unowned")
            detail = SyntaxFactory
                .makeTokenList([
                    SyntaxFactory.makeLeftParenToken(),
                    makeIdentifier("unsafe"),
                    SyntaxFactory.makeRightParenToken().withTrailingSpace()
                    ])
        }
        
        let modifier =
            SyntaxFactory
                .makeDeclModifier(
                    name: token
                        .withExtraLeading(consuming: &extraLeading),
                    detail: detail
                )
        
        list.append(modifier)
    }
}

/// Decorator that applies `override` modifiers to members of types
class OverrideModifierDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let intention = intention as? MemberGenerationIntention else {
            return
        }
        
        if isOverridenMember(intention) {
            let modifier = DeclModifierSyntax { builder in
                builder.useName(SyntaxFactory
                    .makeIdentifier("override")
                    .withExtraLeading(consuming: &extraLeading)
                    .withTrailingSpace()
                )
            }
            
            list.append(modifier)
        }
    }
    
    func isOverridenMember(_ member: MemberGenerationIntention) -> Bool {
        if let _init = member as? InitGenerationIntention {
            return _init.isOverride
        }
        if let method = member as? MethodGenerationIntention {
            return method.isOverride
        }
        
        return false
    }
}

/// Decorator that applies `convenience` modifiers to initializers
class ConvenienceInitModifierDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let intention = intention as? InitGenerationIntention else {
            return
        }
        
        if intention.isConvenience {
            let modifier = DeclModifierSyntax { builder in
                builder.useName(SyntaxFactory
                    .makeIdentifier("convenience")
                    .withExtraLeading(consuming: &extraLeading)
                    .withTrailingSpace()
                )
            }
            
            list.append(modifier)
        }
    }
}

/// Decorator that applies 'optional' modifiers to protocol members
class ProtocolOptionalModifierDecorator: ModifiersSyntaxDecorator {
    func appendModifiers(for intention: IntentionProtocol,
                         _ list: inout [DeclModifierSyntax],
                         extraLeading: inout Trivia?) {
        
        guard let member = intention as? MemberGenerationIntention else {
            return
        }
        
        if isOptionalMember(member) {
            let modifier = DeclModifierSyntax { builder in
                builder.useName(SyntaxFactory
                    .makeIdentifier("optional")
                    .withExtraLeading(consuming: &extraLeading)
                    .withTrailingSpace()
                )
            }
            
            list.append(modifier)
        }
    }
    
    func isOptionalMember(_ member: MemberGenerationIntention) -> Bool {
        guard member.type is ProtocolGenerationIntention else {
            return false
        }
        
        if let method = member as? MethodGenerationIntention {
            return method.optional
        }
        if let property = member as? PropertyGenerationIntention {
            return property.optional
        }
        
        return false
    }
}

func _accessModifierFor(accessLevel: AccessLevel, omitInternal: Bool) -> TokenSyntax? {
    let token: TokenSyntax
    
    switch accessLevel {
    case .internal:
        // We don't emit `internal` explicitly by default here
        return nil
        
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
    
    return token
}
