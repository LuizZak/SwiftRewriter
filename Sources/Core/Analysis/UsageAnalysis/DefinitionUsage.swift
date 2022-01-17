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
    
    /// Whether, in the context of this usage, the referenced definition is being
    /// used in a read-only context.
    public var isReadOnlyUsage: Bool

    /// Specifies a recognized expression contexts for definition usages.
    public enum ExpressionKind {
        /// Usage is of an identifier.
        case identifier(IdentifierExpression)

        /// Definition is a member access, rooted on a given base expression.
        case memberAccess(Expression, MemberPostfix, in: PostfixExpression)

        /// Definition is a function call, rooted on a given base expression.
        case functionCall(Expression, FunctionCallPostfix, in: PostfixExpression)

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
            }
        }
    }
}
