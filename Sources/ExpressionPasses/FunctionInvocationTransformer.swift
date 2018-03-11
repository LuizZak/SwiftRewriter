import SwiftAST

/// A function signature transformer allows changing the shape of a postfix function
/// call into equivalent calls with function name and parameters moved around,
/// labeled and transformed properly.
///
/// e.g:
///
/// ```
/// FunctionInvocationTransformer(
///     name: "CGPointMake",
///     swiftName: "CGPoint",
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
///     name: "CGPathMoveToPoint",
///     swiftName: "move",
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
/// call.
public final class FunctionInvocationTransformer {
    public let name: String
    public let swiftName: String
    
    /// Strategy to apply to each argument in the call.
    public let arguments: [ArgumentStrategy]
    
    /// The number of arguments this function signature transformer needs, exactly,
    /// in order to be fulfilled.
    public let requiredArgumentCount: Int
    
    /// Whether to convert the first argument of the call into a target instance,
    /// such that the free function call becomes a method call.
    public let firstArgIsInstance: Bool
    
    /// Initializes a new function transformer instance.
    ///
    /// - Parameters:
    ///   - name: Name of free function to match with this converter.
    ///   - swiftName: Name of resulting swift function to transform matching
    /// free-function calls into.
    ///   - firstArgumentBecomesInstance: Whether to convert the first argument
    /// of the call into a target instance, such that the free function call becomes
    /// a method call.
    ///   - arguments: Strategy to apply to each argument in the call.
    public init(name: String, swiftName: String, firstArgumentBecomesInstance: Bool, arguments: [ArgumentStrategy]) {
        self.name = name
        self.swiftName = swiftName
        self.arguments = arguments
        self.firstArgIsInstance = firstArgumentBecomesInstance
        
        requiredArgumentCount =
            arguments.requiredArgumentCount() + (firstArgIsInstance ? 1 : 0)
    }
    
    public func canApply(to postfix: PostfixExpression) -> Bool {
        guard postfix.exp.asIdentifier?.identifier == name else {
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
        guard postfix.exp.asIdentifier?.identifier == name else {
            return nil
        }
        guard let functionCall = postfix.functionCall else {
            return nil
        }
        guard !arguments.isEmpty, !functionCall.arguments.isEmpty else {
            return nil
        }
        
        guard let result = apply(on: functionCall) else {
            return nil
        }
        
        // Construct a new postfix operation with the result
        if firstArgIsInstance {
            let exp =
                functionCall
                    .arguments[0]
                    .expression
                    .dot(swiftName)
                    .call(result.arguments)
            exp.resolvedType = postfix.resolvedType
            
            return exp
        }
        
        let exp = Expression.identifier(swiftName).call(result.arguments)
        exp.resolvedType = postfix.resolvedType
        
        return exp
    }
    
    public func apply(on functionCall: FunctionCallPostfix) -> FunctionCallPostfix? {
        if functionCall.arguments.count != requiredArgumentCount {
            return nil
        }
        
        var arguments =
            firstArgIsInstance ? Array(functionCall.arguments.dropFirst()) : functionCall.arguments
        
        var result: [FunctionArgument] = []
        
        func handleArg(i: Int, argument: ArgumentStrategy) -> FunctionArgument? {
            switch argument {
            case .asIs:
                return arguments[i]
            case let .mergingArguments(arg0, arg1, merger):
                let arg =
                    FunctionArgument(
                        label: nil,
                        expression: merger(arguments[arg0].expression,
                                           arguments[arg1].expression)
                )
                
                return arg
                
            case let .transformed(transform, strat):
                if var arg = handleArg(i: i, argument: strat) {
                    arg.expression = transform(arg.expression)
                    return arg
                }
                
                return nil
                
            case .fromArgIndex(let index):
                return arguments[index]
                
            case let .omitIf(matches: exp, strat):
                guard let result = handleArg(i: i, argument: strat) else {
                    return nil
                }
                
                if result.expression == exp {
                    return nil
                }
                
                return result
            case let .labeled(label, strat):
                if let arg = handleArg(i: i, argument: strat) {
                    return .labeled(label, arg.expression)
                }
                
                return nil
            }
        }
        
        var i = 0
        while i < self.arguments.count {
            let arg = self.arguments[i]
            if let res = handleArg(i: i, argument: arg) {
                result.append(res)
                
                if case .mergingArguments = arg {
                    i += 1
                }
            }
            
            i += 1
        }
        
        return FunctionCallPostfix(arguments: result)
    }
    
    /// What to do with one or more arguments of a function call
    public enum ArgumentStrategy {
        /// Maps the target argument from the original argument at the nth index
        /// on the original call.
        case fromArgIndex(Int)
        
        /// Maps the current argument as-is, with no changes.
        case asIs
        
        /// Merges two argument indices into a single expression, using a given
        /// transformation closure.
        case mergingArguments(arg0: Int, arg1: Int, (Expression, Expression) -> Expression)
        
        /// Transforms an argument using a given transformation method
        indirect case transformed((Expression) -> Expression, ArgumentStrategy)
        
        /// Creates a rule that omits the argument in case it matches a given
        /// expression.
        indirect case omitIf(matches: Expression, ArgumentStrategy)
        
        /// Allows adding a label to the result of an argument strategy for the
        /// current parameter.
        indirect case labeled(String, ArgumentStrategy)
        
        /// Gets the number of arguments this argument strategy will consume when
        /// applied.
        var argumentConsumeCount: Int {
            switch self {
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
        /// Returns 0, for non-indexed arguments.
        var maxArgumentReferenced: Int {
            switch self {
            case .asIs:
                return 0
            case .fromArgIndex(let index):
                return index
            case let .mergingArguments(index1, index2, _):
                return max(index1, index2)
            case .labeled(_, let inner), .omitIf(_, let inner), .transformed(_, let inner):
                return inner.maxArgumentReferenced
            }
        }
    }
}

public extension Sequence where Element == FunctionInvocationTransformer.ArgumentStrategy {
    public func requiredArgumentCount() -> Int {
        var requiredArgs = reduce(0) { $0 + $1.argumentConsumeCount }
        
        // Verify max arg count inferred from indexes of arguments
        if let max = map({ $0.maxArgumentReferenced }).max(), max > requiredArgs {
            requiredArgs = max
        }
        
        return requiredArgs
    }
}
