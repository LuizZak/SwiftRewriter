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
        let mappings = compoundedType.signatureMappings
        
        let typeSystem = context.typeSystem
        
        transformers.append(contentsOf:
            mappings.map { mapping -> PostfixInvocationTransformer in
                
                let baseExpressionMatcher: ValueMatcher<Expression>
                
                if mapping.from.isStatic {
                    
                    baseExpressionMatcher =
                        ValueMatcher()
                            .keyPath(\Expression.resolvedType) {
                                $0.match {
                                    guard case .metatype(let type) = $0 else {
                                        return false
                                    }
                                    
                                    return typeSystem.isType(type, subtypeOf: compoundedType.typeName)
                                }
                            }
                    
                } else {
                    
                    baseExpressionMatcher =
                        ValueMatcher()
                            .keyPath(\Expression.resolvedType) {
                                $0.match {
                                    typeSystem.isType($0, subtypeOf: compoundedType.typeName)
                                }
                            }
                    
                }
                
                return
                    MethodInvocationTransformer(
                        baseExpressionMatcher: baseExpressionMatcher,
                        methodSignature: mapping.from,
                        newMethodName: mapping.to.name,
                        argumentRewriters: mapping.to.parameters.map { arg in
                            if let label = arg.label {
                                return .labeled(label, .asIs)
                            } else {
                                return .asIs
                            }
                        },
                        argumentTypes: mapping.to.parameters.map { $0.type })
                
            })
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
