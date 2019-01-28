import SwiftRewriterLib
import SwiftAST

/// Represents a transformation of a postfix invocation for types or instances of
/// a type.
public enum PostfixTransformation {
    case method(MethodInvocationTransformerMatcher)
    case function(FunctionInvocationTransformer)
    case property(old: String, new: String)
    case propertyFromMethods(property: String,
                             getterName: String,
                             setterName: String?,
                             resultType: SwiftType,
                             isStatic: Bool)
    case propertyFromFreeFunctions(property: String,
                                   getterName: String,
                                   setterName: String?)
    case initializer(old: [String?], new: [String?])
    case valueTransformer(ValueTransformer<PostfixExpression, Expression>)
}

public func convertToPostfixInvocationTransformations(
    _ transform: PostfixTransformation,
    compoundedType: CompoundedMappingType,
    instanceMatcher: ValueMatcher<Expression>,
    staticMatcher: ValueMatcher<Expression>) -> [PostfixInvocationTransformer] {
    
    switch transform {
    // Property rename from value.<old> -> value.<new>
    case let .property(old, new):
        return [
            PropertyInvocationTransformer(
                baseExpressionMatcher: instanceMatcher,
                oldName: old,
                newName: new
            )
        ]
        
    // Method renaming/argument rearranging
    case .method(let mapping):
        
        let baseExpressionMatcher: ValueMatcher<Expression>
        
        if mapping.isStatic {
            baseExpressionMatcher = staticMatcher
        } else {
            
            baseExpressionMatcher = instanceMatcher
        }
        
        return methodRemapping(mapping, baseExpressionMatcher)
        
    // Free function rewriting
    case .function(let mapping):
        return [mapping]
        
    // Getter or getter/setter pair conversion to property name
    case let .propertyFromMethods(property, getterName, setterName,
                                  resultType, isStatic):
        
        let matcher = isStatic ? staticMatcher : instanceMatcher
        
        return propertyFromMethods(isStatic,
                                   matcher,
                                   getterName,
                                   setterName,
                                   property,
                                   resultType)
        
    case let .propertyFromFreeFunctions(property, getterName, setterName):
        return propertyFromFreeFunctions(getterName, property, setterName)
        
    case let .initializer(_, new):
        return initializerRename(new, compoundedType)
        
    case let .valueTransformer(transformer):
        return [ValueTransformerWrapper(valueTransformer: transformer)]
    }
}

func methodRemapping(_ mapping: (MethodInvocationTransformerMatcher),
                     _ baseMatcher: ValueMatcher<Expression>) -> [PostfixInvocationTransformer] {
    
    return [
        MethodInvocationTransformer(
            baseExpressionMatcher: baseMatcher,
            invocationMatcher: mapping
        )
    ]
}

func propertyFromFreeFunctions(_ getterName: String,
                               _ property: String,
                               _ setterName: String?) -> [PostfixInvocationTransformer] {
    
    var transformers: [PostfixInvocationTransformer] = []
    
    transformers.append(FunctionInvocationTransformer(
        objcFunctionName: getterName,
        toSwiftPropertyGetter: property
    ))
    
    if let setterName = setterName {
        transformers.append(
            FunctionInvocationTransformer(
                objcFunctionName: setterName,
                toSwiftPropertySetter: property,
                argumentTransformer: .asIs
            )
        )
    }
    
    return transformers
}

func initializerRename(_ new: [String?],
                       _ compoundedType: CompoundedMappingType) -> [PostfixInvocationTransformer] {
    
    let args: [ArgumentRewritingStrategy] = new.map {
        if let label = $0 {
            return .labeled(label, .asIs)
        }
        
        return .asIs
    }
    
    return [
        FunctionInvocationTransformer(
            objcFunctionName: compoundedType.typeName,
            toSwiftFunction: compoundedType.typeName,
            firstArgumentBecomesInstance: false,
            arguments: args
        )
    ]
}

func propertyFromMethods(_ isStatic: Bool,
                         _ matcher: ValueMatcher<Expression>,
                         _ getterName: String,
                         _ setterName: String?,
                         _ property: String,
                         _ resultType: SwiftType) -> [PostfixInvocationTransformer] {
    
    return [
        MethodsToPropertyTransformer(
            baseExpressionMatcher: matcher,
            getterName: getterName,
            setterName: setterName,
            propertyName: property,
            resultType: resultType
        )
    ]
}
