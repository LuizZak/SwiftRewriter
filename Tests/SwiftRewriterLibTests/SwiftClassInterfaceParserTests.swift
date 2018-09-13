import XCTest
import SwiftRewriterLib
import SwiftAST
import MiniLexer

class SwiftClassInterfaceParserTests: XCTestCase {
    
    var typeSystem: DefaultTypeSystem!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = DefaultTypeSystem()
    }
    
    func testParseEmptyClass() throws {
        
        let type = try parseType("""
            class Empty {
            }
            """)
        
        XCTAssertEqual(type.typeName, "Empty")
        XCTAssertEqual(type.knownProperties.count, 0)
        XCTAssertEqual(type.knownMethods.count, 0)
        XCTAssertEqual(type.knownConstructors.count, 0)
        XCTAssertEqual(type.knownFields.count, 0)
        XCTAssertEqual(type.knownProtocolConformances.count, 0)
        XCTAssertFalse(type.isExtension)
    }
    
    func testParseSupertypes() throws {
        
        let type = try parseType("""
            class MyClass: UIView, B {
            }
            """)
        
        XCTAssertEqual(type.knownProtocolConformances.count, 1)
        XCTAssertEqual(type.knownProtocolConformances[0].protocolName, "B")
        XCTAssertEqual(type.supertype?.asTypeName, "UIView")
    }
    
    func testParseProperty() throws {
        
        let type = try parseType("""
            class MyClass {
                var v1: Int
                var v2: Int { get }
                weak var v3: MyClass?
            }
            """)
        
        XCTAssertEqual(type.knownProperties.count, 3)
        XCTAssertEqual(type.knownProperties[0].name, "v1")
        XCTAssertEqual(type.knownProperties[0].storage.type, .int)
        XCTAssertEqual(type.knownProperties[0].accessor, .getterAndSetter)
        XCTAssertEqual(type.knownProperties[0].storage.ownership, .strong)
        XCTAssertEqual(type.knownProperties[1].name, "v2")
        XCTAssertEqual(type.knownProperties[1].storage.type, .int)
        XCTAssertEqual(type.knownProperties[1].accessor, .getter)
        XCTAssertEqual(type.knownProperties[1].storage.ownership, .strong)
        XCTAssertEqual(type.knownProperties[2].name, "v3")
        XCTAssertEqual(type.knownProperties[2].storage.type, .optional("MyClass"))
        XCTAssertEqual(type.knownProperties[2].accessor, .getterAndSetter)
        XCTAssertEqual(type.knownProperties[2].storage.ownership, .weak)
    }
    
    func testParseFunction() throws {
        
        let type = try parseType("""
            class MyClass {
                func a()
                func b(_ a: Int)
                func c(a: String, b: Int?) -> MyClass
            }
            """)
        
        XCTAssertEqual(type.knownMethods.count, 3)
        XCTAssertEqual(type.knownMethods[0].signature.name, "a")
        XCTAssertEqual(type.knownMethods[0].signature.parameters.count, 0)
        XCTAssertEqual(type.knownMethods[0].signature.returnType, .void)
        
        XCTAssertEqual(type.knownMethods[1].signature.name, "b")
        XCTAssertEqual(type.knownMethods[1].signature.parameters.count, 1)
        XCTAssertNil(type.knownMethods[1].signature.parameters[0].label)
        XCTAssertEqual(type.knownMethods[1].signature.parameters[0].name, "a")
        XCTAssertEqual(type.knownMethods[1].signature.parameters[0].type, .int)
        XCTAssertEqual(type.knownMethods[1].signature.returnType, .void)
        
        XCTAssertEqual(type.knownMethods[2].signature.name, "c")
        XCTAssertEqual(type.knownMethods[2].signature.parameters.count, 2)
        XCTAssertEqual(type.knownMethods[2].signature.parameters[0].label, "a")
        XCTAssertEqual(type.knownMethods[2].signature.parameters[0].name, "a")
        XCTAssertEqual(type.knownMethods[2].signature.parameters[0].type, .string)
        XCTAssertEqual(type.knownMethods[2].signature.parameters[1].label, "b")
        XCTAssertEqual(type.knownMethods[2].signature.parameters[1].name, "b")
        XCTAssertEqual(type.knownMethods[2].signature.parameters[1].type, .optional(.int))
        XCTAssertEqual(type.knownMethods[2].signature.returnType, "MyClass")
    }
    
    func testParseInitializer() throws {
        
        let type = try parseType("""
            class MyClass {
                init()
            }
            """)
        
        XCTAssertEqual(type.knownConstructors.count, 1)
        XCTAssertEqual(type.knownConstructors[0].parameters.count, 0)
    }
    
    func testBackToBackTypeParse() throws {
        
        let type = try parseType("""
            class MyClass: UIView, UITableViewDelegate {
                var count: Int { get }
                var data: [String]
                
                init()
                init(coder aDecoder: NSCoding)
                
                func a()
                func b(_ a: Int)
                func c(a: String, b: Int?) -> MyClass
            }
            """)
        
        let expected = """
            class MyClass: UIView, UITableViewDelegate {
                var count: Int { get }
                var data: [String]
                
                init()
                init(coder aDecoder: NSCoding)
                func a()
                func b(_ a: Int)
                func c(a: String, b: Int?) -> MyClass
            }
            """
        
        let string = TypeFormatter.asString(knownType: type)
        
        XCTAssertEqual(
            expected, string,
            """
            Expected to re-encode type as:
            
            \(expected)
            
            But re-encoded as:
            
            \(string)
            
            Diff:
            
            \(expected.makeDifferenceMarkString(against: string))
            """
        )
    }
}

extension SwiftClassInterfaceParserTests {
    
    func parseType(_ string: String, file: String = #file, line: Int = #line) throws -> KnownType {
        
        do {
            let type =
                try SwiftClassInterfaceParser
                    .parseDeclaration(from: string)
            
            return type.complete(typeSystem: typeSystem)
        } catch {
            
            let description: String
            if let error = error as? LexerError {
                description = error.description(withOffsetsIn: string)
            } else {
                description = "\(error)"
            }
            
            recordFailure(withDescription: "Error while parsing type: \(description)",
                          inFile: file,
                          atLine: line,
                          expected: true)
            
            throw error
        }
        
    }
    
}
