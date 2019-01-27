import Intentions
import SwiftAST
import SwiftSyntax

typealias ModifiersDecoratorResult = [(SwiftSyntaxProducer) -> DeclModifierSyntax]

protocol ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult
}

class ModifiersSyntaxDecoratorApplier {
    /// Creates and returns a modifiers decorator with all default modifier
    /// decorators setup.
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
    
    func modifiers(for intention: IntentionProtocol) -> ModifiersDecoratorResult {
        var list: ModifiersDecoratorResult = []
        
        for decorator in decorators {
            list.append(contentsOf: decorator.modifiers(for: .intention(intention)))
        }
        
        return list
    }
    
    func modifiers(for decl: StatementVariableDeclaration) -> ModifiersDecoratorResult {
        var list: ModifiersDecoratorResult = []
        
        for decorator in decorators {
            list.append(contentsOf: decorator.modifiers(for: .variableDecl(decl)))
        }
        
        return list
    }
}

/// Decorator for adding `mutating` modifiers to methods
class MutatingModifiersDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let method = element.intention as? MethodGenerationIntention else {
            return []
        }
        if method.type is BaseClassIntention {
            return []
        }
        
        if method.signature.isMutating {
            return [{
                SyntaxFactory
                    .makeDeclModifier(
                        name: makeIdentifier("mutating")
                            .addingTrailingSpace()
                            .withExtraLeading(from: $0),
                        detail: nil)
            }]
        }
        
        return []
    }
}

/// Decorator that applies `static` to static members of types
class StaticModifiersDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let intention = element.intention as? MemberGenerationIntention else {
            return []
        }
        
        if intention.isStatic {
            return [{
                SyntaxFactory
                    .makeDeclModifier(
                        name: SyntaxFactory
                            .makeStaticKeyword()
                            .addingTrailingSpace()
                            .withExtraLeading(from: $0),
                        detail: nil)
                }]
        }
        
        return []
    }
}

/// Decorator that appends access level to declarations
class AccessLevelModifiersDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let intention = element.intention as? FromSourceIntention else {
            return []
        }
        
        guard let token = _accessModifierFor(accessLevel: intention.accessLevel, omitInternal: true) else {
            return []
        }
        
        return [{
            SyntaxFactory
                .makeDeclModifier(
                    name: token
                        .addingTrailingSpace()
                        .withExtraLeading(from: $0),
                    detail: nil
            )
        }]
    }
}

/// Decorator that adds `public(set)`, `internal(set)`, `fileprivate(set)`, `private(set)`
/// setter modifiers to properties and instance variables
class PropertySetterAccessModifiersDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let prop = element.intention as? PropertyGenerationIntention else {
            return []
        }
        
        guard let setterLevel = prop.setterAccessLevel, prop.accessLevel.isMoreVisible(than: setterLevel) else {
            return []
        }
        guard let setterAccessLevel = _accessModifierFor(accessLevel: setterLevel, omitInternal: false) else {
            return []
        }
                
        return [
            { producer in
                DeclModifierSyntax { builder in
                    builder.useName(setterAccessLevel.withExtraLeading(from: producer))
                    builder.addToken(SyntaxFactory.makeLeftParenToken())
                    builder.addToken(makeIdentifier("set"))
                    builder.addToken(SyntaxFactory.makeRightParenToken().withTrailingSpace())
                }
            }
        ]
    }
}

/// Decorator that applies `weak`, `unowned(safe)`, and `unowned(unsafe)`
/// modifiers to variable declarations
class OwnershipModifierDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let ownership = ownership(for: element) else {
            return []
        }
        
        if ownership == .strong {
            return []
        }
        
        return [
            {
                let token: TokenSyntax
                let detail: TokenListSyntax?
                
                switch ownership {
                case .strong:
                    token = SyntaxFactory.makeToken(.identifier(""), presence: .present)
                    detail = nil
                    
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
        
                return SyntaxFactory
                    .makeDeclModifier(name: token.withExtraLeading(from: $0),
                                      detail: detail)
            }
        ]
    }
    
    private func ownership(for element: DecoratableElement) -> Ownership? {
        switch element {
        case let .intention(intention as ValueStorageIntention):
            return intention.ownership
            
        case let .variableDecl(decl):
            return decl.ownership
            
        default:
            return nil
        }
    }
}

/// Decorator that applies `override` modifiers to members of types
class OverrideModifierDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let intention = element.intention as? MemberGenerationIntention else {
            return []
        }
        
        if isOverridenMember(intention) {
            return [
                { producer in
                    DeclModifierSyntax { builder in
                        builder.useName(SyntaxFactory
                            .makeIdentifier("override")
                            .withExtraLeading(from: producer)
                            .withTrailingSpace())
                    }
                }
            ]
        }
        
        return []
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
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let intention = element.intention as? InitGenerationIntention else {
            return []
        }
        
        if intention.isConvenience {
            return [
                { producer in
                    DeclModifierSyntax { builder in
                        builder.useName(SyntaxFactory
                            .makeIdentifier("convenience")
                            .withExtraLeading(from: producer)
                            .withTrailingSpace()
                        )
                    }
                }
            ]
        }
        
        return []
    }
}

/// Decorator that applies 'optional' modifiers to protocol members
class ProtocolOptionalModifierDecorator: ModifiersSyntaxDecorator {
    func modifiers(for element: DecoratableElement) -> ModifiersDecoratorResult {
        
        guard let member = element.intention as? MemberGenerationIntention else {
            return []
        }
        
        if isOptionalMember(member) {
            return [
                { producer in
                    DeclModifierSyntax { builder in
                        builder.useName(SyntaxFactory
                            .makeIdentifier("optional")
                            .withExtraLeading(from: producer)
                            .withTrailingSpace()
                        )
                    }
                }
            ]
        }
        
        return []
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
        return omitInternal ? nil : SyntaxFactory.makeInternalKeyword()
        
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
