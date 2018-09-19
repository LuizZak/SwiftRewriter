import SwiftAST

/// Implements basic function call overload selection.
class OverloadResolver {
    let typeSystem: TypeSystem
    
    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
    
    /// Returns a matching resolution by index on a given array of methods.
    ///
    /// - precondition:
    ///     for all methods `M` in `methods`,
    ///     `M.signature.parameters.count == argumentTypes.count`
    ///
    func findBestOverload(in methods: [KnownMethod],
                          argumentTypes: [SwiftType?]) -> KnownMethod? {
        
        let signatures = methods.map { $0.signature }
        if let index = findBestOverload(inSignatures: signatures,
                                        argumentTypes: argumentTypes) {
            return methods[index]
        }
        
        return nil
    }
    
    /// Returns a matching resolution by index on a given array of signatures.
    ///
    /// - precondition:
    ///     for all methods `M` in `methods`,
    ///     `M.signature.parameters.count == argumentTypes.count`
    ///
    func findBestOverload(inSignatures signatures: [FunctionSignature],
                          argumentTypes: [SwiftType?]) -> Int? {
        
        if signatures.isEmpty {
            return nil
        }
        
        let signatureCandidates = produceCandidates(from: signatures)
        
        // All argument types are nil, or no signature matches the available type
        // count: no best candidate can be decided.
        if !signatureCandidates.contains(where: { $0.argumentCount == argumentTypes.count })
            || (!argumentTypes.isEmpty && argumentTypes.allSatisfy({ $0 == nil })) {
            return nil
        }
        
        // Start with a linear search for the first fully matching method signature
        let allArgumentsPresent = argumentTypes.allSatisfy { $0 != nil }
        if allArgumentsPresent {
            outerLoop:
                for candidate in signatureCandidates {
                    if argumentTypes.isEmpty && candidate.argumentCount == 0 {
                        return candidate.inputIndex
                    }
                    guard argumentTypes.count == candidate.argumentCount else {
                        continue
                    }
                    
                    for (argIndex, argumentType) in argumentTypes.enumerated() {
                        guard let argumentType = argumentType else {
                            break outerLoop
                        }
                        
                        let parameterType =
                            candidate.signature.parameters[argIndex].type
                        
                        if !typeSystem.typesMatch(argumentType,
                                                  parameterType,
                                                  ignoreNullability: false) {
                            break
                        }
                        
                        if argIndex == argumentTypes.count - 1 {
                            // Candidate matches fully
                            return candidate.inputIndex
                        }
                    }
            }
        }
        
        // Do a lookup ignoring type nullability to attempt to find best-matching
        // candidates, now
        var candidates = signatureCandidates
        
        for (argIndex, argumentType) in argumentTypes.enumerated() {
            guard candidates.count > 1, let argumentType = argumentType else {
                continue
            }
            
            var doWork = true
            
            repeat {
                doWork = false
                
                for (i, signature) in candidates.enumerated() {
                    let parameterType =
                        signature.signature.parameters[argIndex].type
                    
                    if !typeSystem.isType(argumentType.deepUnwrapped,
                                          assignableTo: parameterType.deepUnwrapped) {
                        
                        candidates.remove(at: i)
                        doWork = true
                        break
                    }
                }
            } while doWork && candidates.count > 1
        }
        
        // Return first candidate found
        return candidates.first?.inputIndex
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
    
    private struct OverloadCandidate {
        var selector: SelectorSignature
        var signature: FunctionSignature
        var inputIndex: Int
        var argumentCount: Int
    }
}
