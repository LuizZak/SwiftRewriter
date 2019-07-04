import SwiftAST
import KnownType
import Utils

/// Implements basic function call overload selection.
public class OverloadResolver {
    let typeSystem: TypeSystem
    let state: OverloadResolverState
    
    init(typeSystem: TypeSystem, state: OverloadResolverState) {
        self.typeSystem = typeSystem
        self.state = state
    }
    
    /// Returns a matching resolution on a given array of methods.
    func findBestOverload(in methods: [KnownMethod],
                          argumentTypes: [SwiftType?]) -> KnownMethod? {
        
        let signatures = methods.map { $0.signature }
        if let index = findBestOverload(inSignatures: signatures,
                                        arguments: argumentTypes.asOverloadResolverArguments) {
            return methods[index]
        }
        
        return nil
    }
    
    /// Returns a matching resolution on a given array of methods.
    func findBestOverload(in methods: [KnownMethod],
                          arguments: [Argument]) -> KnownMethod? {
        
        let signatures = methods.map { $0.signature }
        if let index = findBestOverload(inSignatures: signatures,
                                        arguments: arguments) {
            return methods[index]
        }
        
        return nil
    }
    
    /// Returns a matching resolution by index on a given array of signatures.
    func findBestOverload(inSignatures signatures: [FunctionSignature],
                          argumentTypes: [SwiftType?]) -> Int? {
        
        findBestOverload(inSignatures: signatures,
                                arguments: argumentTypes.asOverloadResolverArguments)
    }
    
    /// Returns a matching resolution by index on a given array of signatures.
    public func findBestOverload(inSignatures signatures: [FunctionSignature],
                                 arguments: [Argument]) -> Int? {
        
        if signatures.isEmpty {
            return nil
        }
        
        if let entry = state.cachedEntry(forSignatures: signatures, arguments: arguments) {
            return entry
        }
        
        let signatureCandidates = produceCandidates(from: signatures)
        
        // All argument types are nil, or no signature matches the available type
        // count: no best candidate can be decided.
        if !signatureCandidates.contains(where: { $0.argumentCount == arguments.count })
            || (!arguments.isEmpty && arguments.allSatisfy({ $0.isMissingType })) {
            
            state.addCache(forSignatures: signatures,
                           arguments: arguments,
                           resolutionIndex: nil)
            
            return nil
        }
        
        // Start with a linear search for the first fully matching method signature
        let allArgumentsPresent = arguments.allSatisfy { !$0.isMissingType }
        if allArgumentsPresent {
            outerLoop:
                for candidate in signatureCandidates {
                    if arguments.isEmpty && candidate.argumentCount == 0 {
                        return candidate.inputIndex
                    }
                    guard arguments.count == candidate.argumentCount else {
                        continue
                    }
                    
                    for (argIndex, argumentType) in arguments.enumerated() {
                        guard let argumentType = argumentType.type else {
                            break outerLoop
                        }
                        
                        let parameterType =
                            candidate.signature.parameters[argIndex].type
                        
                        if !typeSystem.typesMatch(argumentType,
                                                  parameterType,
                                                  ignoreNullability: false) {
                            break
                        }
                        
                        if argIndex == arguments.count - 1 {
                            // Candidate matches fully
                            return candidate.inputIndex
                        }
                    }
            }
        }
        
        // Do a lookup ignoring type nullability to attempt to find best-matching
        // candidates, now
        var candidates = signatureCandidates
        
        for (argIndex, argument) in arguments.enumerated() {
            guard candidates.count > 1, let argumentType = argument.type, !argument.isMissingType else {
                continue
            }
            
            var doWork = true
            
            repeat {
                doWork = false
                
                for (i, signature) in candidates.enumerated() {
                    let parameterType =
                        signature.signature.parameters[argIndex].type
                    
                    let isAssignable =
                        typeSystem.isType(argumentType.deepUnwrapped,
                                          assignableTo: parameterType.deepUnwrapped)
                    
                    if isAssignable {
                        continue
                    }
                    
                    // Integer/float literals must be handled specially: they
                    // can be implicitly casted to other numeric types (except
                    // for float-to-integer casts)
                    if argument.isLiteral {
                        switch argument.literalKind {
                        case .integer? where typeSystem.isNumeric(parameterType.deepUnwrapped),
                             .float? where typeSystem.isFloat(parameterType.deepUnwrapped):
                            continue
                            
                        default:
                            break
                        }
                    }
                    
                    candidates.remove(at: i)
                    doWork = true
                    break
                }
            } while doWork && candidates.count > 1
        }
        
        // Return first candidate found
        let result = candidates.first?.inputIndex
        
        state.addCache(forSignatures: signatures,
                       arguments: arguments,
                       resolutionIndex: result)
        
        return result
    }
    
    private func stripIntegerLiterals(from arguments: [Argument]) -> [Argument] {
        arguments.map { (arg: Argument) -> Argument in
            arg.literalKind == .integer || arg.literalKind == .float
                ? Argument(type: nil, isLiteral: false, literalKind: nil)
                : arg
        }
    }
    
    private func produceCandidates(from signatures: [FunctionSignature]) -> [OverloadCandidate] {
        var overloads: [OverloadCandidate] = []
        
        for (i, signature) in signatures.enumerated() {
            for selector in signature.possibleSelectorSignatures() {
                let candidate =
                    OverloadCandidate(selector: selector,
                                      signature: signature,
                                      inputIndex: i,
                                      argumentCount: selector.keywords.count - 1)
                
                overloads.append(candidate)
            }
        }
        
        return overloads
    }
    
    public struct Argument: Hashable {
        public var isMissingType: Bool {
            type == nil || type == .errorType
        }
        
        public var type: SwiftType?
        public var isLiteral: Bool
        public var literalKind: LiteralExpressionKind?
        
        public init(type: SwiftType?, isLiteral: Bool, literalKind: LiteralExpressionKind?) {
            self.type = type
            self.isLiteral = isLiteral
            self.literalKind = literalKind
        }
    }
    
    private struct OverloadCandidate {
        var selector: SelectorSignature
        var signature: FunctionSignature
        var inputIndex: Int
        var argumentCount: Int
    }
}

class OverloadResolverState {
    @ConcurrentValue private var cache: [CacheEntry: Int?] = [:]
    
    public func makeCache() {
        $cache.setAsCaching(value: [:])
    }
    
    public func tearDownCache() {
        $cache.tearDownCaching(resetToValue: [:])
    }
    
    func cachedEntry(forSignatures signatures: [FunctionSignature],
                     arguments: [OverloadResolver.Argument]) -> Int?? {
        
        if !$cache.usingCache {
            return nil
        }
        
        let entry = CacheEntry(signatures: signatures, arguments: arguments)
        return cache[entry]
    }
    
    func addCache(forSignatures signatures: [FunctionSignature],
                  arguments: [OverloadResolver.Argument],
                  resolutionIndex: Int?) {
        
        if !$cache.usingCache {
            return
        }
        
        let entry = CacheEntry(signatures: signatures, arguments: arguments)
        $cache.wrappedValue[entry] = resolutionIndex
    }
    
    struct CacheEntry: Hashable {
        var signatures: [FunctionSignature]
        var arguments: [OverloadResolver.Argument]
    }
}

public extension Sequence where Element == FunctionArgument {
    var asOverloadResolverArguments: [OverloadResolver.Argument] {
        map {
            OverloadResolver.Argument(type: $0.expression.resolvedType,
                                      isLiteral: $0.expression.isLiteralExpression,
                                      literalKind: $0.expression.literalExpressionKind)
        }
    }
}

public extension Sequence where Element == SwiftType? {
    var asOverloadResolverArguments: [OverloadResolver.Argument] {
        map {
            OverloadResolver.Argument(type: $0, isLiteral: false, literalKind: nil)
        }
    }
}
