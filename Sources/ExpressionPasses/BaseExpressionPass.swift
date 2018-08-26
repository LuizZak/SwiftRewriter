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
    
    func convertEnumIdentifier(_ identifier: IdentifierExpression) -> Expression? {
        if let mapped = enumMappings[identifier.identifier] {
            return mapped()
        }
        
        return nil
    }
    
    func addCompoundedType(_ compoundedType: CompoundedMappingType) {
        let typeSystem = context.typeSystem
        
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
                case let .propertyFromMethods(property, getterName, setterName):
                    return
                        MethodsToPropertyTransformer(
                            baseExpressionMatcher: instanceExpressionMatcher,
                            getterName: getterName,
                            setterName: setterName,
                            propertyName: property
                        )
                    
                case let .initializer(_, new):
                    return
                        FunctionInvocationTransformer(
                            objcFunctionName: compoundedType.typeName,
                            toSwiftFunction: compoundedType.typeName,
                            firstArgumentBecomesInstance: false,
                            arguments: new.map { $0.argumentRewritingStrategy }
                        )
                    
                case let .valueTransformer(transformer):
                    return transformer
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

private extension ParameterSignature {
    var argumentRewritingStrategy: ArgumentRewritingStrategy {
        if let label = label {
            return .labeled(label, .asIs)
        }
        
        return .asIs
    }
}
