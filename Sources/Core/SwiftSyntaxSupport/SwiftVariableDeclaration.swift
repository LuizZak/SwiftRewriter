import SwiftAST
import KnownType
import Intentions

struct SwiftVariableDeclaration {
    var constant: Bool
    var attributes: [KnownAttribute]
    var modifiers: [SwiftDeclarationModifier]
    var kind: Kind

    enum Kind {
        case single(pattern: PatternBindingElement, Accessor?)
        case multiple(patterns: [PatternBindingElement])

        var patterns: [PatternBindingElement] {
            switch self {
            case .single(let pattern, _):
                return [pattern]
            case .multiple(let patterns):
                return patterns
            }
        }
    }

    enum Accessor {
        case computed(CompoundStatement)
        case getter(CompoundStatement, setter: Setter)
    }

    struct Setter {
        var valueIdentifier: String
        var body: CompoundStatement
    }
    
    struct PatternBindingElement {
        var name: String
        var type: SwiftType?
        var intention: IntentionProtocol?
        var initialization: Expression?
    }
}

enum SwiftDeclarationModifier: CustomStringConvertible {
    case mutating
    case `static`
    case optional
    case convenience
    case final
    case override
    case accessLevel(AccessLevel)
    case setterAccessLevel(AccessLevel)
    case ownership(Ownership)

    var description: String {
        switch self {
        case .mutating:
            return "mutating"
        case .static:
            return "static"

        case .optional:
            return "optional"

        case .convenience:
            return "convenience"

        case .final:
            return "final"

        case .override:
            return "override"

        case .accessLevel(let value):
            return value.rawValue

        case .setterAccessLevel(let value):
            return "\(value.rawValue)(set)"

        case .ownership(let value):
            return value.rawValue
        }
    }
}
