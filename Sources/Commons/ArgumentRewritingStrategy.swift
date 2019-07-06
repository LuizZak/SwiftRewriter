import SwiftAST

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
    
    /// In case this argument strategy is a labeled argument rewrite, returns
    /// the new label, otherwise, returns `nil`.
    public var label: String? {
        switch self {
        case .labeled(let label, _):
            return label
            
        case .transformed(_, let inner), .omitIf(_, let inner):
            return inner.label
            
        default:
            return nil
        }
    }
    
    /// Gets the number of arguments this argument strategy will consume when
    /// applied.
    public var argumentConsumeCount: Int {
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
    public var maxArgumentReferenced: Int? {
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
    public func transform(argumentIndex index: Int, arguments: [FunctionArgument]) -> FunctionArgument? {
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
    
    /// Applies the transformation dictated by this argument transformer onto
    /// a given parameter index from an parameter list.
    ///
    /// Most transformers, apart from `.fromArgIndex` and `.labeled` behave as
    /// `.asIs` and simply return the incoming signature.
    ///
    /// - Parameters:
    ///   - index: Absolute index into `arguments` to apply this argument
    /// transformer to.
    ///   - arguments: Complete array of arguments to use when references to
    /// argument indices are needed.
    /// - Returns: Resulting function parameter.
    ///
    /// - precondition: `parameters.count >= (self.maxArgumentReferenced ?? index)`
    public func transform(argumentIndex index: Int, parameters: [ParameterSignature]) -> ParameterSignature {
        assert(parameters.count >= (self.maxArgumentReferenced ?? index))
        
        switch self {
        case .asIs:
            return parameters[index]
            
        case .mergingArguments:
            return parameters[index]
            
        case .fixed:
            return parameters[index]
            
        case .transformed:
            return parameters[index]
            
        case .fromArgIndex(let index):
            return parameters[index]
            
        case .omitIf:
            return parameters[index]
            
        case let .labeled(label, _):
            return ParameterSignature(label: label,
                                      name: parameters[index].name,
                                      type: parameters[index].type)
        }
    }
}

public extension Sequence where Element == ArgumentRewritingStrategy {
    
    func requiredArgumentCount() -> Int {
        var requiredArgs = reduce(0) { $0 + $1.argumentConsumeCount }
        
        // Verify max arg count inferred from indexes of arguments
        if let max = compactMap({ $0.maxArgumentReferenced }).max(), max > requiredArgs {
            requiredArgs = max
        }
        
        return requiredArgs
    }
    
    func argumentLabels() -> [String?] {
        return map { $0.label }
    }
    
    static func addingLabels(_ labels: String?...) -> [Element] {
        return labels.map { $0.map { .labeled($0, .asIs) } ?? .asIs }
    }
}

public extension Collection where Element == ArgumentRewritingStrategy, Index == Int {
    
    /// Rewrites a given list of arguments using this collection of argument
    /// rewriting strategies.
    ///
    /// - precondition: `arguments.count >= self.requiredArgumentCount()`
    func rewrite(arguments: [FunctionArgument]) -> [FunctionArgument] {
        precondition(arguments.count >= self.requiredArgumentCount())
        
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
    
    /// Rewrites a given list of parameters using this collection of argument
    /// rewriting strategies.
    ///
    /// - precondition: `parameters.count >= self.requiredArgumentCount()`
    func rewrite(parameters: [ParameterSignature]) -> [ParameterSignature] {
        precondition(parameters.count >= self.requiredArgumentCount())
        
        var result: [ParameterSignature] = []
        
        var i = 0
        while i < self.count {
            let arg = self[i]
            
            let res = arg.transform(argumentIndex: i, parameters: parameters)
            result.append(res)
            
            if case .mergingArguments = arg {
                i += 1
            }
            
            i += 1
        }
        
        return result
    }
    
}

public extension ValueTransformer where U == [FunctionArgument] {
    
    func rewritingArguments(_ transformers: [ArgumentRewritingStrategy],
                                   file: String = #file,
                                   line: Int = #line) -> ValueTransformer {
        
        let required = transformers.requiredArgumentCount()
        
        return transforming(file: file, line: line) { args in
            if args.count < required {
                return nil
            }
            
            return transformers.rewrite(arguments: args)
        }
    }
    
}
