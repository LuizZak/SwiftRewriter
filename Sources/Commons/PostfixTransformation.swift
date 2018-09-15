import SwiftRewriterLib
import SwiftAST

/// Represents a transformation of a postfix invocation for types or instances of
/// a type.
public enum PostfixTransformation {
    case method(MethodInvocationTransformerMatcher)
    case property(old: String, new: String)
    case propertyFromMethods(property: String,
                             getterName: String,
                             setterName: String?,
                             resultType: SwiftType,
                             isStatic: Bool)
    case initializer(old: [String?], new: [String?])
    case valueTransformer(ValueTransformer<PostfixExpression, Expression>)
}
