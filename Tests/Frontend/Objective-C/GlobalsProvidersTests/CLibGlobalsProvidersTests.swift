import GlobalsProviders
import SwiftAST
import SwiftRewriterLib
import XCTest

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
        assertDefined(function: "abs", paramTypes: [.int], returnType: .int)

        assertDefined(function: "fabsf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "fabs", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "fabs", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "asinf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "asin", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "asin", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "acosf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "acos", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "acos", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "atanf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "atan", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "atan", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "tanf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "tan", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "tan", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "sinf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "sin", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "sin", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "cosf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "cos", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "cos", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "atan2f", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "atan2", paramTypes: [cDouble, cDouble], returnType: cDouble)
        assertDefined(function: "atan2", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat)

        assertDefined(function: "sqrtf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "sqrt", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "sqrt", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "ceilf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "ceil", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "ceil", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "floorf", paramTypes: [cFloat], returnType: cFloat)
        assertDefined(function: "floor", paramTypes: [cDouble], returnType: cDouble)
        assertDefined(function: "floor", paramTypes: [.cgFloat], returnType: .cgFloat)

        assertDefined(function: "fmodf", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "fmod", paramTypes: [cDouble, cDouble], returnType: cDouble)
        assertDefined(function: "fmod", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat)

        assertDefined(function: "max", paramTypes: [.int, .int], returnType: .int)
        assertDefined(function: "max", paramTypes: [cInt, cInt], returnType: cInt)
        assertDefined(function: "max", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat)
        assertDefined(function: "max", paramTypes: [.float, .float], returnType: .float)
        assertDefined(function: "max", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "max", paramTypes: [.double, .double], returnType: .double)

        assertDefined(function: "min", paramTypes: [.int, .int], returnType: .int)
        assertDefined(function: "min", paramTypes: [cInt, cInt], returnType: cInt)
        assertDefined(function: "min", paramTypes: [.cgFloat, .cgFloat], returnType: .cgFloat)
        assertDefined(function: "min", paramTypes: [.float, .float], returnType: .float)
        assertDefined(function: "min", paramTypes: [cFloat, cFloat], returnType: cFloat)
        assertDefined(function: "min", paramTypes: [.double, .double], returnType: .double)
    }
}
