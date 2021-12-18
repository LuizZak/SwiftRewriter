import SwiftAST

/// Method-to-method call transformation should allow:
///
/// 1. Renaming method member name
/// ```
/// \<exp>.method()
/// ```
/// to
/// ```
/// \<exp>.otherMethod()
/// ```
///
/// 2. Add or remove arguments in arbitrary position
///     2.1 Add a new argument to an arbitrary position
///     2.2 Remove an argument at an arbitrary position from the original call
///     2.3 Reorder arguments
///     2.4 Join two or more arguments into one argument, which is the result of
///         a transformation function that takes in all N arguments and produces
///         one resulting argument.
///
/// 3. Changing labels of arguments
///     3.1 Add/remove label
///     3.2 Change existing label
///
/// 4. Change the typing information of arguments and/or return type
///
/// It should be executed in the following order:
///
/// 1. Member renaming
/// 2. Argument list transformation
/// 3. Argument label changes
/// 4. Typing information changes
///
/// Phases are all optional; applying no phases is a no-op and returns the original
/// expression.
///
public class MethodInvocationRewriter {
    public let renaming: String?
    public let argumentRewriting: [(ArgumentRewritingStrategy, SwiftType?)]?
    public let returnType: SwiftType?
    public let requiredArgumentCount: Int
    
    var argumentRewritingStrategies: [ArgumentRewritingStrategy]? {
        argumentRewriting?.map(\.0)
    }
    
    public init(renaming: String?,
                argumentRewriting: [(ArgumentRewritingStrategy, SwiftType?)]?,
                returnType: SwiftType?) {
        
        self.renaming = renaming
        self.argumentRewriting = argumentRewriting
        self.returnType = returnType
        self.requiredArgumentCount = argumentRewriting?.map(\.0).requiredArgumentCount() ?? 0
    }
    
    public func rewriteName(_ name: String) -> String {
        renaming ?? name
    }
    
    public func rewriteIdentifier(_ identifier: FunctionIdentifier,
                                  forArguments arguments: [FunctionArgument]) -> FunctionIdentifier {
        
        var parameterNames: [String?] = []
        
        if let argStrategies = argumentRewritingStrategies {
            parameterNames =
                argStrategies
                    .rewrite(arguments: arguments)
                    .map(\.label)
        }
        
        let identifier =
            FunctionIdentifier(name: rewriteName(identifier.name),
                               argumentLabels: parameterNames)
        
        return identifier
    }
    
    public func rewriteSignature(_ signature: FunctionSignature) -> FunctionSignature {
        var result = signature
        
        result.name = rewriteName(result.name)
        result.returnType = replaceReturnType(signature.returnType)
        result.parameters = rewriteFunctionParameters(signature.parameters)
        
        return result
    }
    
    public func replaceReturnType(_ returnType: SwiftType) -> SwiftType {
        self.returnType ?? returnType
    }
    
    /// - precondition: If `argumentRewriting != nil`, `arguments.count >= requiredArgumentCount`
    public func rewriteFunctionArguments(_ arguments: [FunctionArgument]) -> [FunctionArgument] {
        guard let argRewriters = argumentRewritingStrategies else {
            return arguments
        }
        
        return argRewriters.rewrite(arguments: arguments)
    }
    
    /// - precondition: If `argumentRewriting != nil`, `parameters.count >= requiredArgumentCount`
    public func rewriteFunctionParameters(_ parameters: [ParameterSignature]) -> [ParameterSignature] {
        guard let argRewriters = argumentRewriting else {
            return parameters
        }
        
        var params = argRewriters.map(\.0).rewrite(parameters: parameters)
        
        for (i, (_, type)) in argRewriters.enumerated() {
            params[i].type = type ?? params[i].type
        }
        
        return params
    }
    
    /// - precondition: `functionCall.arguments.count >= requiredArgumentCount`
    public func rewriteFunctionCall(_ functionCall: FunctionCallPostfix) -> FunctionCallPostfix {
        let newArgs = rewriteFunctionArguments(functionCall.arguments)
        
        if let types = argumentRewriting?.map(\.1) {
            for (i, type) in types.enumerated() {
                newArgs[i].expression.expectedType = type
            }
        }
        
        let postfix = FunctionCallPostfix(arguments: newArgs)
        postfix.returnType = returnType ?? postfix.returnType
        
        return postfix
    }
}

public class MethodInvocationRewriterBuilder {
    var _renaming: String?
    var _argumentRewriting: [(ArgumentRewritingStrategy, SwiftType?)]?
    var _returnType: SwiftType?
    
    public init() {
        
    }
    
    public init(mappingTo signature: FunctionSignature) {
        renaming(to: signature.name)
        returnType(signature.returnType)
        
        for param in signature.parameters {
            var strat = ArgumentRewritingStrategy.asIs
            if let label = param.label {
                strat = .labeled(label, strat)
            }
            
            addingArgument(strategy: strat, type: param.type)
        }
    }
    
    @discardableResult
    public func renaming(to newName: String?) -> MethodInvocationRewriterBuilder {
        _renaming = newName
        
        return self
    }
    
    @discardableResult
    public func returnType(_ type: SwiftType?) -> MethodInvocationRewriterBuilder {
        _returnType = type
        
        return self
    }
    
    @discardableResult
    public func addingArgument(strategy: ArgumentRewritingStrategy) -> MethodInvocationRewriterBuilder {
        if _argumentRewriting == nil {
            _argumentRewriting = []
        }
        
        _argumentRewriting?.append((strategy, nil))
        
        return self
    }
    
    @discardableResult
    public func addingArgument(strategy: ArgumentRewritingStrategy,
                               type: SwiftType) -> MethodInvocationRewriterBuilder {
        
        if _argumentRewriting == nil {
            _argumentRewriting = []
        }
        
        _argumentRewriting?.append((strategy, type))
        
        return self
    }
    
    public func build() -> MethodInvocationRewriter {
        MethodInvocationRewriter(renaming: _renaming,
                                 argumentRewriting: _argumentRewriting,
                                 returnType: _returnType)
    }
}

public class MethodInvocationTransformerMatcher {
    public let identifier: FunctionIdentifier
    public let isStatic: Bool
    public let transformer: MethodInvocationRewriter
    
    public init(identifier: FunctionIdentifier,
                isStatic: Bool,
                transformer: MethodInvocationRewriter) {
        
        self.identifier = identifier
        self.isStatic = isStatic
        self.transformer = transformer
    }
}
