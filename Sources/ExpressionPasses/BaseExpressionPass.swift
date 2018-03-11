import SwiftRewriterLib
import Utils
import SwiftAST

public class BaseExpressionPass: SyntaxNodeRewriterPass {
    var staticConstructorTransformers: [StaticConstructorTransformer] = []
    var transformers: [FunctionInvocationTransformer] = []
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
}

public extension BaseExpressionPass {
    func makeInit(typeName: String, property: String, convertInto: @autoclosure @escaping () -> Expression,
                  andTypeAs type: SwiftType? = nil) {
        let transformer
            = StaticConstructorTransformer(
                typeName: typeName,
                kind: .property(property),
                conversion: {
                    let exp = convertInto()
                    exp.resolvedType = type
                    return exp
            })
        
        staticConstructorTransformers.append(transformer)
    }
    
    func makeInit(typeName: String, method: String, convertInto: @autoclosure @escaping () -> Expression,
                  andCallWithArguments args: [FunctionInvocationTransformer.ArgumentStrategy],
                  andTypeAs type: SwiftType? = nil) {
        let transformer
            = StaticConstructorTransformer(
                typeName: typeName,
                kind: .method(method, args),
                conversion: {
                    let exp = convertInto()
                    exp.resolvedType = type
                    return exp
            })
        
        staticConstructorTransformers.append(transformer)
    }
    
    func makeFuncTransform(_ name: String, swiftName: String, arguments: [FunctionInvocationTransformer.ArgumentStrategy],
                           firstArgIsInstance: Bool = false) {
        let transformer =
            FunctionInvocationTransformer(name: name, swiftName: swiftName,
                                          firstArgumentBecomesInstance: firstArgIsInstance,
                                          arguments: arguments)
        transformers.append(transformer)
    }
}