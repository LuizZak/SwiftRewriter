import Foundation
import SwiftAST
import SwiftRewriterLib

private let cInt = SwiftType.typeName("CInt")
private let cFloat = SwiftType.typeName("CFloat")
private let cDouble = SwiftType.typeName("CDouble")

public class CLibGlobalsProviders: GlobalsProvider {
    public init() {
        
    }
    
    public func registerDefinitions(on globals: GlobalDefinitions) {
        let add: (CodeDefinition) -> Void = {
            globals.recordDefinition($0)
        }
        
        add(function(name: "abs", paramTypes: [cInt], returnType: cInt))
        add(function(name: "fabsf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "fabs", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "asinf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "asin", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "acosf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "acos", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "atanf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "atan", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "tanf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "tan", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "sinf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "sin", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "cosf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "cos", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "atan2f", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "atan2", paramTypes: [cDouble, cDouble], returnType: cDouble))
        
        add(function(name: "sqrtf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "sqrt", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "ceilf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "ceil", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "floorf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "floor", paramTypes: [cDouble], returnType: cDouble))
        
        add(function(name: "fmodf", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "fmod", paramTypes: [cDouble, cDouble], returnType: cDouble))
    }
    
    func function(name: String, paramTypes: [SwiftType], returnType: SwiftType) -> CodeDefinition {
        let paramSignatures = paramTypes.enumerated().map { (arg) -> ParameterSignature in
            let (i, type) = arg
            return ParameterSignature(label: "_", name: "p\(i)", type: type)
        }
        
        let signature =
            FunctionSignature(name: name, parameters: paramSignatures,
                              returnType: returnType, isStatic: false)
        
        let definition = CodeDefinition(functionSignature: signature, intention: nil)
        
        return definition
    }
}
