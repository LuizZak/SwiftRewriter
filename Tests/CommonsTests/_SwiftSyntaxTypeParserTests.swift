import XCTest
import SwiftAST
import Commons

class _SwiftSyntaxTypeParserTests: XCTestCase {
    func testParseClass() {
        let result = parse("""
            class A {
            }
            """)
        
        result.assertDefined(classNamed: "A")
    }
    
    func testParseStruct() {
        let result = parse("""
            struct A {
            }
            """)
        
        result.assertDefined(structNamed: "A")
    }
    
    func testParseProtocol() {
        let result = parse("""
            protocol A {
            }
            """)
        
        result.assertDefined(protocolNamed: "A")
    }
    
    func testParseEnum() {
        let result = parse("""
            enum A {
            }
            """)
        
        result.assertDefined(enumNamed: "A")
    }
    
    func testParseProperty() {
        let result = parse("""
            class A {
                var a: Int
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.properties.count, 1)
        XCTAssertEqual(type.properties[0].name, "a")
        XCTAssertEqual(type.properties[0].storage.type, .int)
    }
    
    func testParseMethod() {
        let result = parse("""
            class A {
                func a(_ b: Int) -> String
                static func c(d: Int)
                mutating func e(f g: Int = 1)
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.methods.count, 3)
        XCTAssertEqual(type.methods[0].signature,
                       FunctionSignature(name: "a",
                                         parameters: [
                                            ParameterSignature(label: nil, name: "b", type: .int)],
                                         returnType: .string,
                                         isStatic: false,
                                         isMutating: false))
        XCTAssertEqual(type.methods[1].signature,
                       FunctionSignature(name: "c",
                                         parameters: [
                                            ParameterSignature(name: "d", type: .int)],
                                         returnType: .void,
                                         isStatic: true,
                                         isMutating: false))
        XCTAssertEqual(type.methods[2].signature,
                       FunctionSignature(name: "e",
                                         parameters: [
                                            ParameterSignature(label: "f", name: "g", type: .int, hasDefaultValue: true)],
                                         returnType: .void,
                                         isStatic: false,
                                         isMutating: true))
    }
    
    func testParseInitializer() {
        let result = parse("""
            class A {
                init()
                convenience init(a: Int)
                init?(b: String)
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.constructors.count, 3)
        XCTAssert(type.constructors[1].isConvenience)
        XCTAssertEqual(type.constructors[1].parameters, [
            ParameterSignature(name: "a", type: .int)
        ])
        XCTAssert(type.constructors[2].isFailable)
        XCTAssertEqual(type.constructors[2].parameters, [
            ParameterSignature(name: "b", type: .string)
        ])
    }
    
    func testParseEnumCases() {
        let result = parse("""
            enum A: Int {
                case a
                case b = 0
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.properties.filter({ $0.isEnumCase }).count, 2)
        XCTAssertEqual(type.properties.filter({ $0.expression == .constant(0) }).count, 1)
    }
}

private extension _SwiftSyntaxTypeParserTests {
    func parse(_ source: String) -> SwiftSyntaxTypeParserTestFixture {
        let parser = _SwiftSyntaxTypeParser(source: source)
        let result = parser.parseTypes()
        
        return SwiftSyntaxTypeParserTestFixture(types: result)
    }
}

private class SwiftSyntaxTypeParserTestFixture {
    let types: [IncompleteKnownType]
    
    init(types: [IncompleteKnownType]) {
        self.types = types
    }
    
    func type(named name: String) -> IncompleteKnownType? {
        return types.first(where: { $0.typeName == name })
    }
    
    func assertDefined(classNamed name: String, line: UInt = #line) {
        if !types.contains(where: { $0.kind == .class && $0.typeName == name }) {
            XCTFail("Expected class named \(name)", line: line)
        }
    }
    
    func assertDefined(structNamed name: String, line: UInt = #line) {
        if !types.contains(where: { $0.kind == .struct && $0.typeName == name }) {
            XCTFail("Expected struct named \(name)", line: line)
        }
    }
    
    func assertDefined(protocolNamed name: String, line: UInt = #line) {
        if !types.contains(where: { $0.kind == .protocol && $0.typeName == name }) {
            XCTFail("Expected protocol named \(name)", line: line)
        }
    }
    
    func assertDefined(enumNamed name: String, line: UInt = #line) {
        if !types.contains(where: { $0.kind == .enum && $0.typeName == name }) {
            XCTFail("Expected enum named \(name)", line: line)
        }
    }
}
