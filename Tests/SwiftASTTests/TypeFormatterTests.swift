import XCTest
import SwiftAST

class TypeFormatterTests: XCTestCase {
    func testAsStringFunctionSignature() {
        let sig1 = FunctionSignature(name: "abc", parameters: [],
                                     returnType: .int, isStatic: false)
        
        let sig2 = FunctionSignature(name: "abc",
                                     parameters: [ParameterSignature(label: "a", name: "b", type: .float)],
                                     returnType: .void,
                                     isStatic: false)
        
        let sig3 = FunctionSignature(name: "abc",
                                     parameters: [ParameterSignature(label: "a", name: "b", type: .float),
                                                  ParameterSignature(label: "c", name: "c", type: .int)],
                                     returnType: .void,
                                     isStatic: true)
        
        XCTAssertEqual("abc() -> Int", TypeFormatter.asString(signature: sig1, includeName: true))
        XCTAssertEqual("() -> Int", TypeFormatter.asString(signature: sig1, includeName: false))
        
        XCTAssertEqual("abc(a b: Float)", TypeFormatter.asString(signature: sig2, includeName: true))
        XCTAssertEqual("(a b: Float)", TypeFormatter.asString(signature: sig2, includeName: false))
        
        XCTAssertEqual("static abc(a b: Float, c: Int)", TypeFormatter.asString(signature: sig3, includeName: true))
        XCTAssertEqual("static (a b: Float, c: Int)", TypeFormatter.asString(signature: sig3, includeName: false))
        XCTAssertEqual("(a b: Float, c: Int)", TypeFormatter.asString(signature: sig3, includeName: false, includeStatic: false))
        
        // Test default values for `includeName`
        XCTAssertEqual("() -> Int", TypeFormatter.asString(signature: sig1))
        XCTAssertEqual("(a b: Float)", TypeFormatter.asString(signature: sig2))
        XCTAssertEqual("static (a b: Float, c: Int)", TypeFormatter.asString(signature: sig3))
    }
    
    func testAsStringParameterDefaultValue() {
        let parameters = [
            ParameterSignature(label: "label", name: "name", type: .int, hasDefaultValue: true)
        ]
        XCTAssertEqual("(label name: Int = default)", TypeFormatter.asString(parameters: parameters))
    }
}
