import XCTest
import SwiftAST
import SwiftRewriterLib
import GlobalsProviders

class CLibGlobalsProvidersTests: BaseGlobalsProviderTestCase {
    
    override func setUp() {
        super.setUp()
        
        sut = CLibGlobalsProviders()
        
        globals = sut.definitionsSource()
        types = sut.knownTypeProvider()
        typealiases = sut.typealiasProvider()
    }
    
    func testDefinedMathLibFunctions() {
        assertDefined(function: "abs", paramTypes: [cInt], returnType: cInt)
        assertDefined(function: "fabsf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "fabs", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "asinf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "asin", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "acosf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "acos", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "atanf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "atan", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "tanf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "tan", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "sinf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "sin", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "cosf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "cos", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "atan2f", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "atan2", paramTypes: [cDouble, cDouble], returnType: cDouble)
        
        assertDefined(function: "sqrtf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "sqrt", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "ceilf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "ceil", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "floorf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "floor", paramTypes: [cDouble], returnType: cDouble)
        
        assertDefined(function: "fmodf", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "fmod", paramTypes: [cDouble, cDouble], returnType: cDouble)
    }
}
