import SwiftAST
import SwiftRewriterLib

/// A function invocation transformer allows changing the shape of a postfix
/// function call into equivalent calls with function name and parameters moved
/// around, re-labeled, and/or transformed.
///
/// e.g:
///
/// ```
/// FunctionInvocationTransformer(
///     objcFunctionName: "CGPointMake",
///     toSwiftFunction: "CGPoint",
///     firstArgumentBecomesInstance: false,
///     arguments: [
///         .labeled("x", .asIs),
///         .labeled("y", .asIs)
///     ])
/// ```
///
/// Would allow matching and converting:
/// ```
/// CGPointMake(<x>, <y>)
/// // becomes
/// CGPoint(x: <x>, y: <y>)
/// ```
///
/// The method also allows taking in two arguments and merging them, as well as
/// moving arguments around:
/// ```
/// FunctionInvocationTransformer(
///     objcFunctionName: "CGPathMoveToPoint",
///     toSwiftFunction: "move",
///     firstArgumentBecomesInstance: true,
///     arguments: [
///         .labeled("to",
///                  .mergingArguments(arg0: 1, arg1: 2, { x, y in
///                                       Expression.identifier("CGPoint")
///                                       .call([.labeled("x", x), .labeled("y", y)])
///                                    }))
///     ])
/// ```
///
/// Would allow detecting and converting:
///
/// ```
/// CGPathMoveToPoint(<path>, <transform>, <x>, <y>)
/// // becomes
/// <path>.move(to: CGPoint(x: <x>, y: <y>))
/// ```
///
/// Note that the `<transform>` parameter from the original call was discarded:
/// it is not neccessary to map all arguments of the original call into the target
/// call, as long as the number of arguments needed to match exactly can be inferred
/// from the supplied argument transformers.
public final class FunctionInvocationTransformer: PostfixInvocationTransformer {
    public let objcFunctionName: String
    public let destinationMember: Target
    
    /// The number of arguments this function invocation transformer needs, exactly,
    /// in order to be fulfilled.
    public let requiredArgumentCount: Int
    
    public init(fromObjcFunctionName: String, destinationMember: Target) {
        self.objcFunctionName = fromObjcFunctionName
        self.destinationMember = destinationMember
        
        switch destinationMember {
        case let .method(_, firstArgumentBecomesInstance, arguments):
            requiredArgumentCount =
                arguments.requiredArgumentCount()
                    + (firstArgumentBecomesInstance ? 1 : 0)
            
        case .propertyGetter:
            requiredArgumentCount = 1
            
        case .propertySetter(_, let argument):
            requiredArgumentCount = 2 + (argument.maxArgumentReferenced ?? 0)
        }
    }
    
    /// Initializes a new function transformer instance.
    ///
    /// - Parameters:
    ///   - objcFunctionName: Name of free function to match with this converter.
    ///   - swiftName: Name of resulting swift function to transform matching
    /// free-function calls into.
    ///   - firstArgumentBecomesInstance: Whether to convert the first argument
    /// of the call into a target instance, such that the free function call becomes
    /// a method call.
    ///   - arguments: Strategy to apply to each argument in the call.
    public convenience init(objcFunctionName: String,
                            toSwiftFunction swiftName: String,
                            firstArgumentBecomesInstance: Bool,
                            arguments: [ArgumentRewritingStrategy]) {
        
        let target =
            Target.method(swiftName,
                          firstArgumentBecomesInstance: firstArgumentBecomesInstance,
                          arguments)
        
        self.init(fromObjcFunctionName: objcFunctionName, destinationMember: target)
    }
    
    /// Initializes a new function transformer instance that can modify Foundation
    /// style getter global functions into property getters.
    ///
    /// - Parameters:
    ///   - objcFunctionName: The function name to look for to transform.
    ///   - swiftProperty: The target swift property name to transform the getter
    /// into.
    public convenience init(objcFunctionName: String,
                            toSwiftPropertyGetter swiftProperty: String) {
        
        self.init(fromObjcFunctionName: objcFunctionName,
                  destinationMember: .propertyGetter(swiftProperty))
    }
    
    /// Initializes a new function transformer instance that can modify Foundation
    /// style setter global functions into property assignments.
    ///
    /// - Parameters:
    ///   - objcFunctionName: The function name to look for to transform.
    ///   - swiftProperty: The target swift property name to transform the setter
    /// into.
    ///   - argumentTransformer: An argument strategy that can be used to transform
    /// the remaining arguments from the function into the final value on the right
    /// side of the assignment expression.
    public convenience init(objcFunctionName: String,
                            toSwiftPropertySetter swiftProperty: String,
                            argumentTransformer: ArgumentRewritingStrategy) {
        
        let target =
            Target.propertySetter(swiftProperty,
                                  argumentTransformer: argumentTransformer)
        
        self.init(fromObjcFunctionName: objcFunctionName, destinationMember: target)
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        guard postfix.exp.asIdentifier?.identifier == objcFunctionName else {
            return false
        }
        guard let functionCall = postfix.functionCall else {
            return false
        }
        
        if functionCall.arguments.count != requiredArgumentCount {
            return false
        }
        
        // If a function transformation matches the same exact labels, quit early
        // as the transformation is already done.
        switch destinationMember {
        case .method(let name, _, let args) where objcFunctionName == name:
            let args = args.argumentLabels()
            
            if args == functionCall.arguments.argumentLabels() {
                return false
            }
            
        default:
            break
        }
        
        return true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
        if !canApply(to: postfix) {
            return nil
        }
        
        guard postfix.exp.asIdentifier?.identifier == objcFunctionName else {
            return nil
        }
        guard let functionCall = postfix.functionCall else {
            return nil
        }
        guard !functionCall.arguments.isEmpty else {
            return nil
        }
        
        switch destinationMember {
        case .propertyGetter(let name):
            if functionCall.arguments.count != 1 {
                return nil
            }
            
            return functionCall.arguments[0].expression.copy().dot(name).typed(postfix.resolvedType)
            
        case let .propertySetter(name, transformer):
            if functionCall.arguments.count != 1 + transformer.argumentConsumeCount {
                return nil
            }
            
            let arguments = Array(functionCall.arguments.dropFirst())
            
            guard let rhs = transformer.transform(argumentIndex: 0, arguments: arguments) else {
                return nil
            }
            
            let exp = functionCall.arguments[0].expression.copy().dot(name)
            exp.resolvedType = postfix.resolvedType
            
            return exp.assignment(op: .assign, rhs: rhs.expression.copy())
            
        case let .method(name, firstArgIsInstance, args):
            guard let result = attemptApply(on: functionCall,
                                            name: name,
                                            firstArgIsInstance: firstArgIsInstance,
                                            args: args) else {
                return nil
            }
            
            // Construct a new postfix operation with the function's first
            // argument
            if firstArgIsInstance {
                let exp =
                    functionCall.arguments[0]
                        .expression.copy().dot(name).call(result.arguments)
                exp.resolvedType = postfix.resolvedType
                
                return exp
            }
            
            let exp = Expression.identifier(destinationMember.memberName).call(result.arguments)
            exp.resolvedType = postfix.resolvedType
            
            return exp
        }
    }
    
    public func attemptApply(on functionCall: FunctionCallPostfix,
                             name: String,
                             firstArgIsInstance: Bool,
                             args: [ArgumentRewritingStrategy]) -> FunctionCallPostfix? {
        
        if functionCall.arguments.count != requiredArgumentCount {
            return nil
        }
        
        let arguments = firstArgIsInstance
            ? Array(functionCall.copy().arguments.dropFirst())
            : functionCall.copy().arguments
        
        var result: [FunctionArgument] = []
        
        var i = 0
        while i < args.count {
            let arg = args[i]
            if let res = arg.transform(argumentIndex: i, arguments: arguments) {
                result.append(res)
                
                if case .mergingArguments = arg {
                    i += 1
                }
            }
            
            i += 1
        }
        
        return FunctionCallPostfix(arguments: result)
    }
    
    public enum Target {
        case propertyGetter(String)
        
        case propertySetter(String, argumentTransformer: ArgumentRewritingStrategy)
        
        ///   - firstArgumentBecomesInstance: Whether to convert the first argument
        /// of the call into a target instance, such that the free function call
        /// becomes a method call.
        ///   - arguments: Strategy to apply to each argument in the call.
        case method(String, firstArgumentBecomesInstance: Bool, [ArgumentRewritingStrategy])
        
        public var memberName: String {
            switch self {
            case .propertyGetter(let name),
                 .propertySetter(let name, _),
                 .method(let name, _, _):
                return name
            }
        }
    }
}

extension Sequence where Element == FunctionArgument {
    public func hasLabeledArguments() -> Bool {
        return any { $0.isLabeled }
    }
    
    public func argumentLabels() -> [String?] {
        return map { $0.label }
    }
}
