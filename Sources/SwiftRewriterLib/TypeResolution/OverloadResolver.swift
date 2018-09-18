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
        
        // All argument types are nil, or no argument types are available: no best
        // candidate can be decided.
        if argumentTypes.isEmpty || argumentTypes.allSatisfy({ $0 == nil }) {
            return 0
        }
        
        // Start with a linear search for the first fully matching method signature
        let allArgumentsPresent = argumentTypes.allSatisfy { $0 != nil }
        if allArgumentsPresent {
            outerLoop:
                for (i, signature) in signatures.enumerated() {
                    for (argIndex, argumentType) in argumentTypes.enumerated() {
                        guard let argumentType = argumentType else {
                            break outerLoop
                        }
                        
                        let parameterType = signature.parameters[argIndex].type
                        
                        if !typeSystem.typesMatch(argumentType, parameterType, ignoreNullability: false) {
                            break
                        }
                        
                        if argIndex == argumentTypes.count - 1 {
                            // Candidate matches fully
                            return i
                        }
                    }
            }
        }
        
        // Do a lookup ignoring type nullability to attempt to find best-matching
        // candidates, now
        var candidates = Array(signatures.enumerated())
        
        for (argIndex, argumentType) in argumentTypes.enumerated() {
            guard candidates.count > 1, let argumentType = argumentType else {
                continue
            }
            
            var doWork = true
            
            repeat {
                doWork = false
                
                for (i, signature) in candidates.enumerated() {
                    let parameterType =
                        signature.element.parameters[argIndex].type
                    
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
        return candidates.first?.offset
    }
}
