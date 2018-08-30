import XCTest
import SwiftRewriterLib
import MiniLexer

class FunctionSignatureParserTests: XCTestCase {
    func testParseEmptyParameters() {
        assert(
            string: "()",
            parseInto: []
        )
    }
    
    func testParseSingleParameter() {
        assert(
            string: "(arg0: Int)",
            parseInto: [ParameterSignature(name: "arg0", type: .int)]
        )
    }
    
    func testParseSingleParameterWithLabel() {
        assert(
            string: "(_ arg0: Int)",
            parseInto: [ParameterSignature(label: nil, name: "arg0", type: .int)]
        )
    }
    
    func testParseTwoParameters() {
        assert(
            string: "(_ arg0: Int, arg1: String)",
            parseInto: [
                ParameterSignature(label: nil, name: "arg0", type: .int),
                ParameterSignature(name: "arg1", type: .string)
            ]
        )
    }
    
    func testParseParameterInout() {
        assert(
            string: "(_ arg0: inout Int)",
            parseInto: [
                ParameterSignature(label: nil, name: "arg0", type: .int)
            ]
        )
    }
    
    func testParseParameterAttributes() {
        assert(
            string: "(_ arg0: @escaping () -> Void)",
            parseInto: [
                ParameterSignature(label: nil, name: "arg0", type: .block(returnType: .void, parameters: []))
            ]
        )
        
        assert(
            string: "(_ arg0: @autoclosure @escaping () -> Void)",
            parseInto: [
                ParameterSignature(label: nil, name: "arg0", type: .block(returnType: .void, parameters: []))
            ]
        )
    }
    
    func testParseParameterAttributesAndInout() {
        assert(
            string: "(_ arg0: @escaping inout () -> Void)",
            parseInto: [
                ParameterSignature(label: nil, name: "arg0", type: .block(returnType: .void, parameters: []))
            ]
        )
    }
    
    func testParseEmptyFunctionSignature() {
        assert(string: "function()",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .void,
                isStatic: false
            )
        )
    }
    
    func testFunctionSignatureWithReturn() {
        assert(string: "function() -> Int",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .int,
                isStatic: false
            )
        )
    }
    
    func testFunctionSignatureWithParameters() {
        assert(string: "function(_ int: Int)",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [
                    ParameterSignature(label: nil, name: "int", type: .int)
                ],
                returnType: .void,
                isStatic: false
            )
        )
        assert(string: "function(_ int: Int) -> Double",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [
                    ParameterSignature(label: nil, name: "int", type: .int)
                ],
                returnType: .double,
                isStatic: false
            )
        )
    }
    
    func testFunctionSignatureWithThrows() {
        assert(string: "function() throws",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .void,
                isStatic: false
            )
        )
        assert(string: "function() throws -> Int",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .int,
                isStatic: false
            )
        )
    }
    
    func testFunctionSignatureWithRethrows() {
        assert(string: "function() rethrows",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .void,
                isStatic: false
            )
        )
        assert(string: "function() rethrows -> Int",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .int,
                isStatic: false
            )
        )
    }
    
    func testMutatingFunction() {
        assert(string: "mutating function()",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [],
                returnType: .void,
                isStatic: false,
                isMutating: true
            )
        )
    }
    
    func testExtraneousInputError() {
        do {
            _=try FunctionSignatureParser.parseParameters(from: "())")
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual("\(error)", "Error: Extraneous input ')'")
        }
        
        do {
            _=try FunctionSignatureParser.parseSignature(from: "func())")
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual("\(error)", "Error: Extraneous input ')'")
        }
    }
    
    func testExpectedArgumentNameError() {
        do {
            _=try FunctionSignatureParser.parseParameters(from: "(_: Int)")
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual("\(error)", "Error: Expected argument name after '_'")
        }
    }
    
    func testExpectedArgumentAfterComma() {
        do {
            _=try FunctionSignatureParser.parseParameters(from: "(arg0: Int, )")
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual("\(error)", "Error: Expected argument after ','")
        }
    }
    
    func testUnexpectedCharacterInArgumentList() {
        do {
            _=try FunctionSignatureParser.parseParameters(from: "(=)")
            XCTFail("Expected to throw error")
        } catch let lexError as LexerError {
            XCTAssertEqual(lexError.description(withOffsetsIn: "(=)"),
                           "Error at line 1 column 2: Expected token ')' but found 'eof'")
        } catch {
            XCTFail("Wrong error type \(type(of: error))")
        }
    }
}

extension FunctionSignatureParserTests {
    func assert(string: String, parseInto expected: [ParameterSignature], line: Int = #line) {
        do {
            let parsed = try FunctionSignatureParser.parseParameters(from: string)
            
            if parsed != expected {
                recordFailure(withDescription: """
                    Expected to parse '\(string)' into parameter signature \
                    \(TypeFormatter.asString(parameters: expected)) but received \
                    \(TypeFormatter.asString(parameters: parsed))
                    """,
                    inFile: #file, atLine: line, expected: true)
            }
        } catch {
            recordFailure(withDescription: "Error parsing signature: \(error)",
                          inFile: #file, atLine: line, expected: true)
        }
    }
    
    func assert(string: String, parseInto expected: FunctionSignature, line: Int = #line) {
        do {
            let parsed = try FunctionSignatureParser.parseSignature(from: string)
            
            if parsed != expected {
                recordFailure(withDescription: """
                    Expected to parse '\(string)' into function signature \
                    \(TypeFormatter.asString(signature: expected)) but received \
                    \(TypeFormatter.asString(signature: parsed))
                    """,
                    inFile: #file, atLine: line, expected: true)
            }
        } catch {
            recordFailure(withDescription: "Error parsing signature: \(error)",
                          inFile: #file, atLine: line, expected: true)
        }
    }
}
