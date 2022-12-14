import SwiftAST
import TypeSystem

private let cInt = SwiftType.typeName("CInt")
private let cFloat = SwiftType.typeName("CFloat")
private let cDouble = SwiftType.typeName("CDouble")

public class CLibGlobalsProviders: GlobalsProvider {
    private static var provider = InnerCLibGlobalsProviders()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        CollectionKnownTypeProvider(knownTypes: CLibGlobalsProviders.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        CollectionTypealiasProvider(aliases: CLibGlobalsProviders.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        CLibGlobalsProviders.provider.definitions
    }
}

private class InnerCLibGlobalsProviders: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    public override init() {
        
    }
    
    // FIXME: Extract these repetitive lines into functions that iterate over all
    // integer/float types for each new method definition automatically
    public override func createDefinitions() {
        add(function(name: "abs", paramTypes: [cInt], returnType: cInt))
        add(function(name: "abs", paramTypes: [.int], returnType: .int))
        
        add(function(name: "fabsf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "fabs", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "fabs", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "asinf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "asin", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "asin", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "acosf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "acos", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "acos", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "atanf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "atan", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "atan", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "tanf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "tan", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "tan", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "sinf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "sin", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "sin", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "cosf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "cos", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "cos", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "atan2f", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "atan2", paramTypes: [cDouble, cDouble], returnType: cDouble))
        add(function(name: "atan2", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        
        add(function(name: "sqrtf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "sqrt", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "sqrt", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "ceilf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "ceil", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "ceil", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "floorf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "floor", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "floor", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "fmodf", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "fmod", paramTypes: [cDouble, cDouble], returnType: cDouble))
        add(function(name: "fmod", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        
        add(function(name: "max", paramTypes: [.int, .int], returnType: .int))
        add(function(name: "max", paramTypes: [cInt, cInt], returnType: cInt))
        add(function(name: "max", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        add(function(name: "max", paramTypes: [.float, .float], returnType: .float))
        add(function(name: "max", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "max", paramTypes: [.double, .double], returnType: .double))
        
        add(function(name: "min", paramTypes: [.int, .int], returnType: .int))
        add(function(name: "min", paramTypes: [cInt, cInt], returnType: cInt))
        add(function(name: "min", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        add(function(name: "min", paramTypes: [.float, .float], returnType: .float))
        add(function(name: "min", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "min", paramTypes: [.double, .double], returnType: .double))
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
}
