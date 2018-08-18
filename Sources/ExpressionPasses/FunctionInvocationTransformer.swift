import SwiftAST

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
            
        case .propertySetter:
            requiredArgumentCount = 2
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
        
        return true
    }
    
    public func attemptApply(on postfix: PostfixExpression) -> Expression? {
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

/// Specifies rewriting strategies to apply to a function invocation argument.
public enum ArgumentRewritingStrategy {
    /// Maps the target argument from the original argument at the nth index
    /// on the original call.
    case fromArgIndex(Int)
    
    /// Maps the current argument as-is, with no changes.
    case asIs
    
    /// Merges two argument indices into a single expression, using a given
    /// transformation closure.
    case mergingArguments(arg0: Int, arg1: Int, (Expression, Expression) -> Expression)
    
    /// Puts out a fixed expression at the target argument position
    case fixed(() -> Expression)
    
    /// Transforms an argument using a given transformation method
    indirect case transformed((Expression) -> Expression, ArgumentRewritingStrategy)
    
    /// Creates a rule that omits the argument in case it matches a given
    /// expression.
    indirect case omitIf(matches: ValueMatcher<Expression>, ArgumentRewritingStrategy)
    
    /// Allows adding a label to the result of an argument strategy for the
    /// current parameter.
    indirect case labeled(String, ArgumentRewritingStrategy)
    
    /// Gets the number of arguments this argument strategy will consume when
    /// applied.
    var argumentConsumeCount: Int {
        switch self {
        case .fixed:
            return 0
        case .asIs, .fromArgIndex:
            return 1
        case .mergingArguments:
            return 2
        case .labeled(_, let inner), .omitIf(_, let inner), .transformed(_, let inner):
            return inner.argumentConsumeCount
        }
    }
    
    /// Gets the index of the maximal argument index referenced by this argument
    /// rule.
    /// Returns `nil`, for non-indexed arguments.
    var maxArgumentReferenced: Int? {
        switch self {
        case .asIs, .fixed:
            return 0
            
        case .fromArgIndex(let index):
            return index
            
        case let .mergingArguments(index1, index2, _):
            return max(index1, index2)
            
        case .labeled(_, let inner), .omitIf(_, let inner), .transformed(_, let inner):
            return inner.maxArgumentReferenced
        }
    }
    
    /// Applies the transformation dictated by this argument transformer onto
    /// a given argument index from an argument list.
    ///
    /// Result is nil, in case the argument strategy resulted in omitting the
    /// argument expression.
    ///
    /// - Parameters:
    ///   - index: Absolute index into `arguments` to apply this argument
    /// transformer to.
    ///   - arguments: Complete array of arguments to use when references to
    /// argument indices are needed.
    /// - Returns: Resulting function argument, or `nil`, in case the argument
    /// was omitted
    ///
    /// - precondition: `arguments.count >= (self.maxArgumentReferenced ?? index)`
    func transform(argumentIndex index: Int, arguments: [FunctionArgument]) -> FunctionArgument? {
        assert(arguments.count >= (self.maxArgumentReferenced ?? index))
        
        switch self {
        case .asIs:
            return arguments[index].copy()
            
        case let .mergingArguments(arg0, arg1, merger):
            let arg =
                FunctionArgument(
                    label: nil,
                    expression: merger(arguments[arg0].expression.copy(),
                                       arguments[arg1].expression.copy())
                )
            
            return arg
            
        case let .fixed(maker):
            return FunctionArgument(label: nil, expression: maker())
            
        case let .transformed(transform, strat):
            if var arg = strat.transform(argumentIndex: index, arguments: arguments) {
                arg.expression = transform(arg.expression.copy())
                return arg
            }
            
            return nil
            
        case .fromArgIndex(let index):
            return arguments[index].copy()
            
        case let .omitIf(matches: matcher, strat):
            guard let result = strat.transform(argumentIndex: index, arguments: arguments) else {
                return nil
            }
            
            if matcher.matches(result.expression) {
                return nil
            }
            
            return result
            
        case let .labeled(label, strat):
            if let arg = strat.transform(argumentIndex: index, arguments: arguments) {
                return .labeled(label, arg.expression.copy())
            }
            
            return nil
        }
    }
}

public extension Sequence where Element == ArgumentRewritingStrategy {
    
    public func requiredArgumentCount() -> Int {
        var requiredArgs = reduce(0) { $0 + $1.argumentConsumeCount }
        
        // Verify max arg count inferred from indexes of arguments
        if let max = compactMap({ $0.maxArgumentReferenced }).max(), max > requiredArgs {
            requiredArgs = max
        }
        
        return requiredArgs
    }
    
    public static func addingLabels(_ labels: String?...) -> [Element] {
        return labels.map { $0.map { .labeled($0, .asIs) } ?? .asIs }
    }
}

public extension Collection where Element == ArgumentRewritingStrategy, Index == Int {
    
    /// Rewrites a given list of arguments using this collection of argument
    /// rewriting strategies.
    ///
    /// - precondition: `arguments.count == self.requiredArgumentCount()`
    public func rewrite(arguments: [FunctionArgument]) -> [FunctionArgument] {
        assert(arguments.count == self.requiredArgumentCount())
        
        var result: [FunctionArgument] = []
        
        var i = 0
        while i < self.count {
            let arg = self[i]
            if let res = arg.transform(argumentIndex: i, arguments: arguments) {
                result.append(res)
                
                if case .mergingArguments = arg {
                    i += 1
                }
            }
            
            i += 1
        }
        
        return result
    }
    
}
