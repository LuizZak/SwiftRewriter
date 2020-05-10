import SwiftSyntax
import Intentions
import SwiftAST

typealias ModifiersDecoratorResult = (SwiftSyntaxProducer) -> DeclModifierSyntax

protocol ModifiersSyntaxDecorator {
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult?
}

class ModifiersSyntaxDecoratorApplier {
    /// Creates and returns a modifiers decorator with all default modifier
    /// decorators setup.
    static func makeDefaultDecoratorApplier() -> ModifiersSyntaxDecoratorApplier {
        let decorator = ModifiersSyntaxDecoratorApplier()
        decorator.addDecorator(AccessLevelModifiersDecorator())
        decorator.addDecorator(PropertySetterAccessModifiersDecorator())
        decorator.addDecorator(ProtocolOptionalModifiersDecorator())
        decorator.addDecorator(StaticModifiersDecorator())
        decorator.addDecorator(OverrideModifiersDecorator())
        decorator.addDecorator(ConvenienceInitModifiersDecorator())
        decorator.addDecorator(MutatingModifiersDecorator())
        decorator.addDecorator(OwnershipModifiersDecorator())
        return decorator
    }
    
    private(set) var decorators: [ModifiersSyntaxDecorator] = []
    
    func addDecorator(_ decorator: ModifiersSyntaxDecorator) {
        decorators.append(decorator)
    }
    
    func modifiers(for intention: IntentionProtocol) -> [ModifiersDecoratorResult] {
        var list: [ModifiersDecoratorResult] = []
        
        for decorator in decorators {
            if let dec = decorator.modifier(for: .intention(intention)) {
                list.append(dec)
            }
        }
        
        return list
    }
    
    func modifiers(for decl: StatementVariableDeclaration) -> [ModifiersDecoratorResult] {
        var list: [ModifiersDecoratorResult] = []
        
        for decorator in decorators {
            if let dec = decorator.modifier(for: .variableDecl(decl)) {
                list.append(dec)
            }
        }
        
        return list
    }
}

/// Decorator for adding `mutating` modifier to methods
class MutatingModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let method = element.intention as? MethodGenerationIntention else {
            return nil
        }
        if method.type is BaseClassIntention {
            return nil
        }
        
        if method.signature.isMutating {
            return {
                SyntaxFactory
                    .makeDeclModifier(
                        name: makeIdentifier("mutating")
                            .addingTrailingSpace()
                            .withExtraLeading(from: $0),
                        detailLeftParen: nil,
                        detail: nil,
                        detailRightParen: nil)
            }
        }
        
        return nil
    }
    
}

/// Decorator that applies `static` to static members of types
class StaticModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if intention.isStatic {
            return {
                SyntaxFactory
                    .makeDeclModifier(
                        name: SyntaxFactory
                            .makeStaticKeyword()
                            .addingTrailingSpace()
                            .withExtraLeading(from: $0),
                        detailLeftParen: nil,
                        detail: nil,
                        detailRightParen: nil)
            }
        }
        
        return nil
    }
    
}

/// Decorator that appends access level to declarations
class AccessLevelModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? FromSourceIntention else {
            return nil
        }
        
        guard let token = _accessModifierFor(accessLevel: intention.accessLevel, omitInternal: true) else {
            return nil
        }
        
        return {
            SyntaxFactory
                .makeDeclModifier(
                    name: token
                        .addingTrailingSpace()
                        .withExtraLeading(from: $0),
                    detailLeftParen: nil,
                    detail: nil,
                    detailRightParen: nil)
        }
    }
    
}

/// Decorator that adds `public(set)`, `internal(set)`, `fileprivate(set)`, `private(set)`
/// setter modifiers to properties and instance variables
class PropertySetterAccessModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let prop = element.intention as? PropertyGenerationIntention else {
            return nil
        }
        
        guard let setterLevel = prop.setterAccessLevel, prop.accessLevel.isMoreAccessible(than: setterLevel) else {
            return nil
        }
        guard let setterAccessLevel = _accessModifierFor(accessLevel: setterLevel, omitInternal: false) else {
            return nil
        }
                
        return { producer in
            DeclModifierSyntax { builder in
                builder.useName(setterAccessLevel.withExtraLeading(from: producer))
                builder.useDetailLeftParen(SyntaxFactory.makeLeftParenToken())
                builder.useDetail(makeIdentifier("set"))
                builder.useDetailRightParen(
                    SyntaxFactory
                        .makeRightParenToken()
                        .withTrailingSpace()
                )
            }
        }
    }
    
}

/// Decorator that applies `weak`, `unowned(safe)`, and `unowned(unsafe)`
/// modifiers to variable declarations
class OwnershipModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let ownership = ownership(for: element) else {
            return nil
        }
        
        if ownership == .strong {
            return nil
        }
        
        return {
            let token: TokenSyntax
            let detail: TokenSyntax?
            
            switch ownership {
            case .strong:
                token = SyntaxFactory.makeToken(.identifier(""), presence: .present)
                detail = nil
                
            case .weak:
                token = makeIdentifier("weak").addingTrailingSpace()
                detail = nil
                
            case .unownedSafe:
                token = makeIdentifier("unowned")
                detail = makeIdentifier("safe")
                
            case .unownedUnsafe:
                token = makeIdentifier("unowned")
                detail = makeIdentifier("unsafe")
            }
            
            return SyntaxFactory
                .makeDeclModifier(name: token.withExtraLeading(from: $0),
                                  detailLeftParen: detail == nil
                                    ? nil
                                    : SyntaxFactory.makeLeftParenToken(),
                                  detail: detail,
                                  detailRightParen: detail == nil
                                    ? nil
                                    : SyntaxFactory
                                        .makeRightParenToken()
                                        .withTrailingSpace()
                )
        }
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

/// Decorator that applies `override` modifier to members of types
class OverrideModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if isOverridenMember(intention) {
            return { producer in
                DeclModifierSyntax { builder in
                    builder.useName(SyntaxFactory
                        .makeIdentifier("override")
                        .withExtraLeading(from: producer)
                        .withTrailingSpace())
                }
            }
        }
        
        return nil
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

/// Decorator that applies `convenience` modifier to initializers
class ConvenienceInitModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? InitGenerationIntention else {
            return nil
        }
        
        if intention.isConvenience {
            return { producer in
                DeclModifierSyntax { builder in
                    builder.useName(SyntaxFactory
                        .makeIdentifier("convenience")
                        .withExtraLeading(from: producer)
                        .withTrailingSpace()
                    )
                }
            }
        }
        
        return nil
    }
    
}

/// Decorator that applies 'optional' modifier to protocol members
class ProtocolOptionalModifiersDecorator: ModifiersSyntaxDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let member = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if isOptionalMember(member) {
            return { producer in
                DeclModifierSyntax { builder in
                    builder.useName(SyntaxFactory
                        .makeIdentifier("optional")
                        .withExtraLeading(from: producer)
                        .withTrailingSpace()
                    )
                }
            }
        }
        
        return nil
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
