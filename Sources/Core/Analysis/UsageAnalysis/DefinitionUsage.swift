import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Reports the usage of a type member or global declaration
public struct DefinitionUsage {
    /// Intention for function body or statement/expression which this member
    /// usage is contained within.
    ///
    /// Can be nil, if no contextual intention was provided during analysis.
    public var intention: FunctionBodyCarryingIntention?
    
    /// The definition that was effectively used
    public var definition: CodeDefinition
    
    /// The expression the usage is effectively used.
    public var expression: ExpressionKind
    
    /// The kind of access of this definition; either read, write, or simultaneous
    /// read/write.
    public var usageKind: UsageKind

    /// Whether, in the context of this usage, the referenced definition is being
    /// read or read-written into.
    public var isReadOnlyUsage: Bool {
        usageKind.isReadOnly
    }

    /// Specifies a recognized expression contexts for definition usages.
    public enum ExpressionKind {
        /// Usage is of an identifier.
        case identifier(IdentifierExpression)

        /// Usage is a member access, rooted on a given base expression.
        case memberAccess(Expression, MemberPostfix, in: PostfixExpression)

        /// Usage is a function, rooted on a given base expression.
        case functionCall(Expression, FunctionCallPostfix, in: PostfixExpression)

        /// Usage is a subscript, rooted on a given base expression.
        case `subscript`(Expression, SubscriptPostfix, in: PostfixExpression)

        /// Gets the context's expression, where the resolved type is the type
        /// of the definition.
        public var expression: Expression {
            switch self {
            case .identifier(let exp):
                return exp
                
            case .functionCall(let exp, _, _):
                return exp

            case .memberAccess(_, _, let exp):
                return exp
            
            case .subscript(_, _, let exp):
                return exp
            }
        }
    }

    /// Specifies the type of usage of a definition; either read-only, write-only,
    /// or read/write.
    public enum UsageKind {
        /// Read only. Value is retrieved but not written to.
        case readOnly

        /// Write only. Assignment operators are of this kind of usage.
        case writeOnly

        /// Read/write. inout assignment operators, mutating functions, and
        /// '&' prefix operators are of this kind of usage.
        case readWrite

        /// Returns `true` if this usage kind is read-only.
        public var isReadOnly: Bool {
            switch self {
            case .readOnly:
                return true
            case .writeOnly, .readWrite:
                return false
            }
        }

        /// Returns `true` if this usage kind is read or read/write.
        public var isRead: Bool {
            switch self {
            case .readOnly, .readWrite:
                return true
            case .writeOnly:
                return false
            }
        }

        /// Returns `true` if this usage kind is write only or read/write.
        public var isWrite: Bool {
            switch self {
            case .readOnly:
                return false
            case .writeOnly, .readWrite:
                return true
            }
        }
    }
}
