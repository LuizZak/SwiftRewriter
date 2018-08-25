import SwiftRewriterLib
import SwiftAST

/// Represents a transformation of a postfix invocation for types or instances of
/// a type.
public enum PostfixTransformation {
    case method(MethodInvocationTransformerMatcher)
    case property(old: String, new: String)
    case propertyFromMethods(property: String, getterName: String, setterName: String?)
    case initializer(old: [ParameterSignature], new: [ParameterSignature])
}
