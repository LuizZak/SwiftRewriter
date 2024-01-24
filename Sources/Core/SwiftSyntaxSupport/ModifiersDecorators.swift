import SwiftSyntax
import SwiftSyntaxBuilder
import Intentions
import SwiftAST

typealias ModifiersDecoratorResult = SwiftDeclarationModifier

protocol ModifiersDecorator {
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult?
}

class ModifiersDecoratorApplier {
    /// Creates and returns a modifiers decorator with all default modifier
    /// decorators setup.
    static func makeDefaultDecoratorApplier() -> ModifiersDecoratorApplier {
        let decorator = ModifiersDecoratorApplier()
        decorator.addDecorator(AccessLevelModifiersDecorator())
        decorator.addDecorator(FinalClassModifiersDecorator())
        decorator.addDecorator(PropertySetterAccessModifiersDecorator())
        decorator.addDecorator(ProtocolOptionalModifiersDecorator())
        decorator.addDecorator(StaticModifiersDecorator())
        decorator.addDecorator(OverrideModifiersDecorator())
        decorator.addDecorator(ConvenienceInitModifiersDecorator())
        decorator.addDecorator(MutatingModifiersDecorator())
        decorator.addDecorator(OwnershipModifiersDecorator())
        return decorator
    }
    
    private(set) var decorators: [ModifiersDecorator] = []
    
    func addDecorator(_ decorator: ModifiersDecorator) {
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
class MutatingModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let method = element.intention as? MethodGenerationIntention else {
            return nil
        }
        if method.type is BaseClassIntention {
            return nil
        }
        
        if method.signature.isMutating {
            return .mutating
        }
        
        return nil
    }
    
}

/// Decorator that applies `static` to static members of types
class StaticModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if intention is EnumCaseGenerationIntention {
            return nil
        }
        if intention.isStatic {
            return .static
        }
        
        return nil
    }
    
}

/// Decorator that appends access level to declarations
class AccessLevelModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? FromSourceIntention else {
            return nil
        }

        if intention.accessLevel != .internal {
            return .accessLevel(intention.accessLevel)
        }

        return nil
    }
    
}

/// Decorator that adds `public(set)`, `internal(set)`, `fileprivate(set)`, `private(set)`
/// setter modifiers to properties and instance variables
class PropertySetterAccessModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let prop = element.intention as? PropertyGenerationIntention else {
            return nil
        }
        
        guard let setterLevel = prop.setterAccessLevel, prop.accessLevel.isMoreAccessible(than: setterLevel) else {
            return nil
        }

        return .setterAccessLevel(setterLevel)
    }
    
}

/// Decorator that applies `weak`, `unowned(safe)`, and `unowned(unsafe)`
/// modifiers to variable declarations
class OwnershipModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let ownership = ownership(for: element) else {
            return nil
        }
        
        if ownership == .strong {
            return nil
        }
        
        return .ownership(ownership)
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
class OverrideModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if isOverridenMember(intention) {
            return .override
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
class ConvenienceInitModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? InitGenerationIntention else {
            return nil
        }
        
        if intention.isConvenience {
            return .convenience
        }
        
        return nil
    }
    
}

/// Decorator that applies 'optional' modifier to protocol members
class ProtocolOptionalModifiersDecorator: ModifiersDecorator {
    
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let member = element.intention as? MemberGenerationIntention else {
            return nil
        }
        
        if isOptionalMember(member) {
            return .optional
        }
        
        return nil
    }
    
    func isOptionalMember(_ member: MemberGenerationIntention) -> Bool {
        guard member.type is ProtocolGenerationIntention else {
            return false
        }

        if let member = member as? ProtocolMethodGenerationIntention {
            return member.isOptional
        }
        if let member = member as? ProtocolPropertyGenerationIntention {
            return member.isOptional
        }
        
        return false
    }
}

/// Modifier that appends `final` declarations to class intentions.
class FinalClassModifiersDecorator: ModifiersDecorator {
    func modifier(for element: DecoratableElement) -> ModifiersDecoratorResult? {
        guard let intention = element.intention as? ClassGenerationIntention else {
            return nil
        }

        if intention.isFinal {
            return .final
        }

        return nil
    }
}
