import XCTest
import SwiftRewriterLib
import SwiftAST
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
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.escaping])
                )
            ]
        )
        
        assert(
            string: "(_ arg0: @autoclosure () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.autoclosure])
                )
            ]
        )
        
        assert(
            string: "(_ arg0: @autoclosure @escaping () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.autoclosure, .escaping])
                )
            ]
        )
    }
    
    func testParseParameterAttributesBlockCallingConvention() {
        assert(
            string: "(_ arg0: @convention(c) () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.convention(.c)])
                )
            ]
        )
        
        assert(
            string: "(_ arg0: @convention(block) () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.convention(.block)])
                )
            ]
        )
        
        assert(
            string: "(_ arg0: @convention(swift) () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .swiftBlock(returnType: .void, parameters: [])
                )
            ]
        )
    }
    
    func testParseParameterAttributesAndInout() {
        assert(
            string: "(_ arg0: @escaping inout () -> Void)",
            parseInto: [
                ParameterSignature(
                    label: nil,
                    name: "arg0",
                    type: .block(returnType: .void,
                                 parameters: [],
                                 attributes: [.escaping])
                )
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
    
    func testParseDefaultValueDefault() {
        assert(string: "function(a: Int = default)",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [
                    ParameterSignature(name: "a", type: .int, hasDefaultValue: true)
                ],
                returnType: .void,
                isStatic: false
            )
        )
    }
    
    func testParseDefaultValueSquareBrackets() {
        assert(string: "function(a: Options = [])",
               parseInto: FunctionSignature(
                name: "function",
                parameters: [
                    ParameterSignature(name: "a", type: "Options", hasDefaultValue: true)
                ],
                returnType: .void,
                isStatic: false
            )
        )
    }
    
    func testParseFullSignature() {
        assert(string: "dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?",
               parseInto: FunctionSignature(
                name: "dateByAddingUnit",
                parameters: [
                    ParameterSignature(label: nil, name: "component", type: .nested(["Calendar", "Component"])),
                    ParameterSignature(name: "value", type: "Int"),
                    ParameterSignature(label: "toDate", name: "date", type: "Date"),
                    ParameterSignature(name: "options", type: "NSCalendarOptions")
                ],
                returnType: .optional("Date"),
                isStatic: false,
                isMutating: false
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
                           "Error at line 1 column 2: Expected token ')' but found '='")
        } catch {
            XCTFail("Wrong error type \(type(of: error))")
        }
    }
    
    func testInvalidDefaultArgument() {
        do {
            _=try FunctionSignatureParser.parseParameters(from: "(a: Int = a)")
            XCTFail("Expected to throw error")
        } catch let lexError as LexerError {
            XCTAssertEqual(lexError.description(withOffsetsIn: "(a: Int = a)"),
                           "Error at line 1 column 10: Default values for arguments must either be 'default' or '[]', found 'a'")
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
