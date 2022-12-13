import SwiftAST
import KnownType

/// Provides facilities for querying `@dynamicMemberLookup`-decorated type
/// declarations.
class DynamicMemberLookup {
    private let type: KnownType
    private let context: TypeMemberLookupContext

    init(type: KnownType, context: TypeMemberLookupContext) {
        self.type = type
        self.context = context
    }

    func member(named name: String, static isStatic: Bool) -> Result? {
        guard type.hasAttribute(named: KnownAttribute.dynamicMemberLookup.name) else {
            return nil
        }

        let typeLookup = context.makeKnownTypeLookup(type)
        guard let dynamicMemberSubscript = typeLookup.subscription(
            withParameterLabels: ["dynamicMember"],
            invocationTypeHints: [.string],
            static: isStatic
        ) else {
            return nil
        }
        guard isDynamicMemberSubscript(dynamicMemberSubscript) else {
            return nil
        }

        return .dynamicMember(dynamicMemberSubscript)
    }

    private func isDynamicMemberSubscript(_ member: KnownSubscript) -> Bool {
        guard member.parameters.count == 1 else {
            return false
        }
        guard member.parameters[0].label == "dynamicMember" else {
            return false
        }
        guard context.typeSystem.typesMatch(
            member.parameters[0].type,
            .string,
            ignoreNullability: false
        ) else {
            return false
        }

        return true
    }

    /// Represents the result of a member lookup.
    enum Result {
        /// Specifies that a member access references a member that was declared
        /// in the code.
        case declared(KnownMember)

        /// Specifies that a member access references a dynamic lookup member,
        /// with a specified matching `KnownSubscript` that abstracts over the
        /// lookup.
        case dynamicMember(KnownSubscript)

        /// Returns the member associated with this result object.
        var member: KnownMember {
            switch self {
            case .declared(let decl):
                return decl

            case .dynamicMember(let decl):
                return decl
            }
        }

        /// Returns a reference to the type associated with this result object's
        /// member value.
        var ownerType: KnownTypeReference? {
            switch self {
            case .declared(let decl):
                return decl.ownerType

            case .dynamicMember(let decl):
                return decl.ownerType
            }
        }
    }
}
