import XCTest
import SwiftAST
import SwiftRewriterLib
import GlobalsProviders

private let cInt = SwiftType.typeName("CInt")
private let cFloat = SwiftType.typeName("CFloat")
private let cDouble = SwiftType.typeName("CDouble")

class CLibGlobalsProvidersTests: XCTestCase {
    var sut: CLibGlobalsProviders!
    var globals: GlobalDefinitions!
    
    override func setUp() {
        super.setUp()
        
        globals = GlobalDefinitions()
        sut = CLibGlobalsProviders()
        
        sut.registerDefinitions(on: globals)
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

extension CLibGlobalsProvidersTests {
    func assertDefined(variable: String, type: SwiftType, line: Int = #line) {
        guard let definition = globals.definition(named: variable) else {
            recordFailure(withDescription: "Expected to find definition \(variable)",
                          inFile: #file, atLine: line, expected: true)
            
            return
        }
        
        guard case let .variable(_, storage) = definition.kind else {
            recordFailure(
                withDescription: "Expected to find a variable defined, but found \(definition.kind) instead",
                inFile: #file, atLine: line, expected: true)
            return
        }
        
        if storage.type != type {
            recordFailure(
                withDescription: "Expected variable to be of type \(type), but found \(storage.type) instead.",
                inFile: #file, atLine: line, expected: true)
        }
    }
    
    func assertDefined(function: String, paramTypes: [SwiftType], returnType: SwiftType,
                       line: Int = #line) {
        guard let definition = globals.definition(named: function) else {
            recordFailure(withDescription: "Expected to find definition \(function)",
                inFile: #file, atLine: line, expected: true)
            
            return
        }
        
        guard case let .function(signature) = definition.kind else {
            recordFailure(
                withDescription: "Expected to find a function defined, but found \(definition.kind) instead",
                inFile: #file, atLine: line, expected: true)
            return
        }
        
        let actualParamTypes = signature.parameters.map { $0.type }
        
        if actualParamTypes != paramTypes {
            let expectedParamsString =
                "(" + paramTypes.map { $0.description }.joined(separator: ", ") + ")"
            
            let actualParamsString =
                "(" + actualParamTypes.map { $0.description }.joined(separator: ", ") + ")"
            
            recordFailure(
                withDescription: """
                Expected function to accept \(expectedParamsString), but it \
                accepts \(actualParamsString) instead.
                """,
                inFile: #file, atLine: line, expected: true)
        }
        
        if signature.returnType != returnType {
            recordFailure(
                withDescription: """
                Expected function to return \(returnType), but it returns \
                \(signature.returnType) instead.
                """,
                inFile: #file, atLine: line, expected: true)
        }
    }
}
