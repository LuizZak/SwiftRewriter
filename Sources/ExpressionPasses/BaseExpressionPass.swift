import SwiftRewriterLib
import Utils
import SwiftAST
import Commons

public class BaseExpressionPass: ASTRewriterPass {
    
    var staticConstructorTransformers: [StaticConstructorTransformer] = []
    var transformers: [PostfixInvocationTransformer] = []
    var enumMappings: [String: () -> Expression] = [:]
    
    public override func visitPostfix(_ exp: PostfixExpression) -> Expression {
        if let new = applyTransformers(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        
        return super.visitPostfix(exp)
    }
    
    public override func visitIdentifier(_ exp: IdentifierExpression) -> Expression {
        if let new = convertEnumIdentifier(exp) {
            notifyChange()
            
            return super.visitExpression(new)
        }
        
        return super.visitIdentifier(exp)
    }
    
    func applyTransformers(_ exp: PostfixExpression) -> Expression? {
        func innerApplyTransformers(_ exp: PostfixExpression) -> Expression? {
            for transformer in staticConstructorTransformers {
                if let result = transformer.attemptApply(on: exp) {
                    return result
                }
            }
            for transformer in transformers {
                if let res = transformer.attemptApply(on: exp) {
                    return res
                }
            }
            
            return nil
        }
        
        // Try to transform as-is
        if let result = innerApplyTransformers(exp) {
            return result
        }
        // If transformation fails, check if inner expression is a postfix itself,
        // and try to solve that before trying one more time
        if let postfix = exp.exp.asPostfix, let result = applyTransformers(postfix) {
            let newPostfix = exp.copy()
            newPostfix.exp = result.copy()
            
            // If we succeeded in re-writing the inner expression, but not the
            // expression as a whole, just lift the inner expression rewriting
            // so outer scopes have a chance to interpret e.g. member access of
            // function calls as method invocations and attempt to properly
            // transform these expressions.
            return innerApplyTransformers(newPostfix) ?? newPostfix
        }
        
        return nil
    }
    
    func convertEnumIdentifier(_ identifier: IdentifierExpression) -> Expression? {
        if let mapped = enumMappings[identifier.identifier] {
            return mapped()
        }
        
        return nil
    }
    
    func addCompoundedType(_ compoundedType: CompoundedMappingType) {
        let typeSystem = self.typeSystem // To avoid capturing 'self' bellow
        
        let instanceExpressionMatcher =
                ValueMatcher()
                    .keyPath(\Expression.resolvedType) {
                        $0.match {
                            typeSystem.isType($0, subtypeOf: compoundedType.typeName)
                        }
                    }
        
        let staticTypeExpressionMatcher =
            ValueMatcher()
                .keyPath(\Expression.resolvedType) {
                    $0.match {
                        guard case .metatype(let type) = $0 else {
                            return false
                        }
                        
                        return typeSystem.isType(type, subtypeOf: compoundedType.typeName)
                    }
                }
        
        transformers.append(contentsOf:
            compoundedType.transformations.map { transform in
                switch transform {
                // Property rename from value.<old> -> value.<new>
                case let .property(old, new):
                    return
                        PropertyInvocationTransformer(
                            baseExpressionMatcher: instanceExpressionMatcher,
                            oldName: old,
                            newName: new
                        )
                
                // Method renaming/argument rearranging
                case .method(let mapping):
                    let baseExpressionMatcher: ValueMatcher<Expression>
                    
                    if mapping.isStatic {
                        baseExpressionMatcher = staticTypeExpressionMatcher
                    } else {
                        
                        baseExpressionMatcher = instanceExpressionMatcher
                    }
                    
                    return
                        MethodInvocationTransformer(
                            baseExpressionMatcher: baseExpressionMatcher,
                            invocationMatcher: mapping
                        )
                    
                // Getter or getter/setter pair conversion to property name
                case let .propertyFromMethods(property, getterName, setterName,
                                              resultType, isStatic):
                    let matcher =
                        isStatic ? staticTypeExpressionMatcher
                            : instanceExpressionMatcher
                    
                    return
                        MethodsToPropertyTransformer(
                            baseExpressionMatcher: matcher,
                            getterName: getterName,
                            setterName: setterName,
                            propertyName: property,
                            resultType: resultType
                        )
                    
                case let .initializer(_, new):
                    let args: [ArgumentRewritingStrategy] = new.map {
                        if let label = $0 {
                            return .labeled(label, .asIs)
                        }
                        
                        return .asIs
                    }
                    
                    return
                        FunctionInvocationTransformer(
                            objcFunctionName: compoundedType.typeName,
                            toSwiftFunction: compoundedType.typeName,
                            firstArgumentBecomesInstance: false,
                            arguments: args)
                    
                case let .valueTransformer(transformer):
                    return ValueTransformerWrapper(valueTransformer: transformer)
                }
            }
        )
    }
}

public extension BaseExpressionPass {
    func makeInit(typeName: String,
                  property: String,
                  convertInto: @autoclosure @escaping () -> Expression,
                  andTypeAs type: SwiftType? = nil) {
        
        let transformer
            = StaticConstructorTransformer(
                typeName: typeName,
                kind: .property(property),
                leading: {
                    let exp = convertInto()
                    exp.resolvedType = type
                    return exp
                })
        
        staticConstructorTransformers.append(transformer)
    }
    
    func makeInit(typeName: String,
                  method: String,
                  convertInto: @autoclosure @escaping () -> Expression,
                  andCallWithArguments args: [ArgumentRewritingStrategy],
                  andTypeAs type: SwiftType? = nil) {
        
        let transformer
            = StaticConstructorTransformer(
                typeName: typeName,
                kind: .method(method, args),
                leading: {
                    let exp = convertInto()
                    exp.resolvedType = type
                    return exp
                })
        
        staticConstructorTransformers.append(transformer)
    }
    
    func makeFuncTransform(_ name: String,
                           swiftName: String,
                           arguments: [ArgumentRewritingStrategy],
                           firstArgIsInstance: Bool = false) {
        
        let transformer =
            FunctionInvocationTransformer(objcFunctionName: name,
                                          toSwiftFunction: swiftName,
                                          firstArgumentBecomesInstance: firstArgIsInstance,
                                          arguments: arguments)
        
        transformers.append(transformer)
    }
    
    func makeFuncTransform(_ name: String, getterName: String) {
        let transformer =
            FunctionInvocationTransformer(objcFunctionName: name,
                                          toSwiftPropertyGetter: getterName)
        
        transformers.append(transformer)
    }
    
    func makeFuncTransform(_ name: String, setterName: String,
                           argumentTransformer: ArgumentRewritingStrategy) {
        let transformer =
            FunctionInvocationTransformer(objcFunctionName: name,
                                          toSwiftPropertyGetter: setterName)
        
        transformers.append(transformer)
    }
    
    func makeFuncTransform(getter: String, setter: String,
                           intoPropertyNamed swiftName: String,
                           setterTransformer: ArgumentRewritingStrategy = .asIs) {
        makeFuncTransform(getter, getterName: swiftName)
        makeFuncTransform(setter, setterName: swiftName, argumentTransformer: setterTransformer)
    }
}
