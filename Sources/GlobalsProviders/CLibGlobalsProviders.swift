import Foundation
import SwiftAST
import SwiftRewriterLib

private let cInt = SwiftType.typeName("CInt")
private let cFloat = SwiftType.typeName("CFloat")
private let cDouble = SwiftType.typeName("CDouble")

public class CLibGlobalsProviders: GlobalsProvider {
    private static var provider = InnerCLibGlobalsProviders()
    
    public init() {
        
    }
    
    public func knownTypeProvider() -> KnownTypeProvider {
        return CollectionKnownTypeProvider(knownTypes: CLibGlobalsProviders.provider.types)
    }
    
    public func typealiasProvider() -> TypealiasProvider {
        return CollectionTypealiasProvider(aliases: CLibGlobalsProviders.provider.typealiases)
    }
    
    public func definitionsSource() -> DefinitionsSource {
        return CLibGlobalsProviders.provider.definitions
    }
}

private class InnerCLibGlobalsProviders: BaseGlobalsProvider {
    
    var definitions: ArrayDefinitionsSource = ArrayDefinitionsSource(definitions: [])
    
    public override init() {
        
    }
    
    public override func createDefinitions() {
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
        add(function(name: "ceilf", paramTypes: [.cgFloat], returnType: .cgFloat))
        add(function(name: "ceil", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "ceil", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "floorf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "floorf", paramTypes: [.cgFloat], returnType: .cgFloat))
        add(function(name: "floor", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "floor", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "roundf", paramTypes: [cFloat], returnType: cFloat))
        add(function(name: "roundf", paramTypes: [.cgFloat], returnType: .cgFloat))
        add(function(name: "round", paramTypes: [cDouble], returnType: cDouble))
        add(function(name: "round", paramTypes: [.cgFloat], returnType: .cgFloat))
        
        add(function(name: "fmodf", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "fmod", paramTypes: [cDouble, cDouble], returnType: cDouble))
        
        add(function(name: "max", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        add(function(name: "max", paramTypes: [.float, .float], returnType: .float))
        add(function(name: "max", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "max", paramTypes: [.double, .double], returnType: .double))
        
        add(function(name: "min", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat))
        add(function(name: "min", paramTypes: [.float, .float], returnType: .float))
        add(function(name: "min", paramTypes: [cFloat, cFloat], returnType: cFloat))
        add(function(name: "min", paramTypes: [.double, .double], returnType: .double))
        
        definitions = ArrayDefinitionsSource(definitions: globals)
    }
}
