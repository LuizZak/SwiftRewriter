import XCTest
import SwiftAST
import KnownType
import Commons
import TypeSystem
import MiniLexer

class SwiftClassInterfaceParserTests: XCTestCase {
    
    var typeSystem: TypeSystem!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = TypeSystem()
    }
    
    func testParseEmptyClass() throws {
        let type = try parseType("""
            class Empty {
            }
            """)
        
        XCTAssertEqual(type.kind, .class)
        XCTAssertEqual(type.typeName, "Empty")
        XCTAssertEqual(type.knownProperties.count, 0)
        XCTAssertEqual(type.knownMethods.count, 0)
        XCTAssertEqual(type.knownConstructors.count, 0)
        XCTAssertEqual(type.knownFields.count, 0)
        XCTAssertEqual(type.knownProtocolConformances.count, 0)
    }
    
    func testParseEmptyExtension() throws {
        let type = try parseType("""
            extension Empty {
            }
            """)
        
        XCTAssertEqual(type.kind, .extension)
        XCTAssertEqual(type.typeName, "Empty")
        XCTAssertEqual(type.knownProperties.count, 0)
        XCTAssertEqual(type.knownMethods.count, 0)
        XCTAssertEqual(type.knownConstructors.count, 0)
        XCTAssertEqual(type.knownFields.count, 0)
        XCTAssertEqual(type.knownProtocolConformances.count, 0)
    }
    
    func testParseEmptyStruct() throws {
        let type = try parseType("""
            struct Empty {
            }
            """)
        
        XCTAssertEqual(type.kind, .struct)
        XCTAssertEqual(type.typeName, "Empty")
        XCTAssertEqual(type.knownProperties.count, 0)
        XCTAssertEqual(type.knownMethods.count, 0)
        XCTAssertEqual(type.knownConstructors.count, 0)
        XCTAssertEqual(type.knownFields.count, 0)
        XCTAssertEqual(type.knownProtocolConformances.count, 0)
    }
    
    func testParseWithSwiftSignatureMatching() throws {
        _=try parseType("""
            class Empty {
                func a()
                func a() -> Int
            }
            """)
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
    
    func testParseProtocolConformances() throws {
        let type = try parseType("""
            class MyClass: A, B {
            }
            """)
        
        XCTAssertEqual(type.knownProtocolConformances.count, 2)
        XCTAssertEqual(type.knownProtocolConformances[0].protocolName, "A")
        XCTAssertEqual(type.knownProtocolConformances[1].protocolName, "B")
    }
    
    func testParseConstantField() throws {
        let type = try parseType("""
            class MyClass {
                let v1: Int
            }
            """)
        
        XCTAssertEqual(type.knownFields.count, 1)
        XCTAssertEqual(type.knownFields[0].name, "v1")
        XCTAssertEqual(type.knownFields[0].storage.type, .int)
        XCTAssert(type.knownFields[0].storage.isConstant)
        XCTAssertEqual(type.knownFields[0].storage.ownership, .strong)
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
    
    func testParseStaticMembers() throws {
        let type = try parseType("""
            class MyClass {
                static var a: Int
                static let b: Int
                static func c()
            }
            """)
        
        XCTAssertEqual(type.knownProperties.count, 1)
        XCTAssertEqual(type.knownFields.count, 1)
        XCTAssertEqual(type.knownMethods.count, 1)
        XCTAssert(type.knownProperties[0].isStatic)
        XCTAssert(type.knownFields[0].isStatic)
        XCTAssert(type.knownMethods[0].isStatic)
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
    
    func testParseFailableInitializer() throws {
        let type = try parseType("""
            class MyClass {
                init?()
            }
            """)
        
        XCTAssertEqual(type.knownConstructors.count, 1)
        XCTAssert(type.knownConstructors[0].isFailable)
    }
    
    func testParseSubscription() throws {
        let type = try parseType("""
            class MyClass {
                subscript(index: Int) -> String
            }
            """)

        XCTAssertEqual(type.knownSubscripts.count, 1)
        XCTAssertEqual(type.knownSubscripts[0].parameters.count, 1)
        // TODO: Argument labels for subscriptions should support more states to
        // better represent the possible label states (none, '_', and labeled), which
        // normal function arguments cannot represent.
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].label, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].name, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].type, .int)
        XCTAssertFalse(type.knownSubscripts[0].parameters[0].hasDefaultValue)
        XCTAssertEqual(type.knownSubscripts[0].returnType, .string)
        XCTAssertFalse(type.knownSubscripts[0].isConstant)
        XCTAssertFalse(type.knownSubscripts[0].isStatic)
    }
    
    func testParseSubscriptionWithZeroArguments() throws {
        let type = try parseType("""
            class MyClass {
                subscript() -> String
            }
            """)

        XCTAssertEqual(type.knownSubscripts.count, 1)
        XCTAssertTrue(type.knownSubscripts[0].parameters.isEmpty)
        XCTAssertEqual(type.knownSubscripts[0].returnType, .string)
        XCTAssertFalse(type.knownSubscripts[0].isConstant)
        XCTAssertFalse(type.knownSubscripts[0].isStatic)
    }
    
    func testParseStaticSubscription() throws {
        let type = try parseType("""
            class MyClass {
                static subscript(index: Int) -> String
            }
            """)

        XCTAssertEqual(type.knownSubscripts.count, 1)
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].label, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].name, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].type, .int)
        XCTAssertFalse(type.knownSubscripts[0].parameters[0].hasDefaultValue)
        XCTAssertEqual(type.knownSubscripts[0].returnType, .string)
        XCTAssertFalse(type.knownSubscripts[0].isConstant)
        XCTAssert(type.knownSubscripts[0].isStatic)
    }

    func testParseSubscriptionWithGetterSetter() throws {
        let type = try parseType("""
            class MyClass {
                subscript(index: Int) -> String { get }
            }
            """)

        XCTAssertEqual(type.knownSubscripts.count, 1)
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].label, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].name, "index")
        XCTAssertEqual(type.knownSubscripts[0].parameters[0].type, .int)
        XCTAssertFalse(type.knownSubscripts[0].parameters[0].hasDefaultValue)
        XCTAssertEqual(type.knownSubscripts[0].returnType, .string)
        XCTAssert(type.knownSubscripts[0].isConstant)
    }
    
    func testParseExtensionDeclaration() throws {
        let type = try parseType("""
            extension MyClass {
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
    
    func testParseEscapedIdentifier() throws {
        let type = try parseType("""
            class MyClass {
                var `default`: Int { get }
            }
            """)
        
        XCTAssertEqual(type.knownProperties.count, 1)
        XCTAssertEqual(type.knownProperties[0].name, "default")
    }
    
    func testParseAttributes() throws {
        let type = try parseType("""
            @attribute1
            extension MyClass {
                @attribute2
                var a: Int
                @attribute3
                init()
                @attribute4(someTag:)
                func f()
                @attribute5
                subscript(index: Int) -> String
            }
            """)
        
        XCTAssertEqual(type.knownAttributes.count, 1)
        XCTAssertEqual(type.knownAttributes[0].name, "attribute1")
        XCTAssertEqual(type.knownProperties[0].knownAttributes.count, 1)
        XCTAssertEqual(type.knownProperties[0].knownAttributes[0].name, "attribute2")
        XCTAssertNil(type.knownProperties[0].knownAttributes[0].parameters)
        XCTAssertEqual(type.knownConstructors[0].knownAttributes.count, 1)
        XCTAssertEqual(type.knownConstructors[0].knownAttributes[0].name, "attribute3")
        XCTAssertNil(type.knownConstructors[0].knownAttributes[0].parameters)
        XCTAssertEqual(type.knownMethods[0].knownAttributes.count, 1)
        XCTAssertEqual(type.knownMethods[0].knownAttributes[0].name, "attribute4")
        XCTAssertEqual(type.knownMethods[0].knownAttributes[0].parameters, "someTag:")
        XCTAssertEqual(type.knownSubscripts[0].knownAttributes.count, 1)
        XCTAssertEqual(type.knownSubscripts[0].knownAttributes[0].name, "attribute5")
        XCTAssertNil(type.knownSubscripts[0].knownAttributes[0].parameters)
    }
    
    func testParseAttributesRoundtrip() throws {
        _=try parseType("""
            @attribute(a)
            @attribute(b[1])
            @_specialize(Int, T? == Array<Float>.Type)
            extension MyClass {
            }
            """)
    }
    
    func testParseSwiftAttributeInType() throws {
        let type = try parseType("""
            @_swiftrewriter(renameFrom: NSMyClass)
            class MyClass {
                @_swiftrewriter(mapFrom: b())
                func a()
                @inlinable
                @_swiftrewriter(mapFrom: c(x: Int))
                @_swiftrewriter(mapFrom: d(x:))
                func b(y: Int)
            }
            """)
        
        XCTAssertEqual(type.knownAttributes[0].name, "_swiftrewriter")
        XCTAssertEqual(type.knownAttributes[0].parameters, "renameFrom: NSMyClass")
        XCTAssertEqual(type.knownMethods[0].knownAttributes[0].name, "_swiftrewriter")
        XCTAssertEqual(type.knownMethods[0].knownAttributes[0].parameters, "mapFrom: b()")
        XCTAssertEqual(type.knownMethods[1].knownAttributes[0].name, "inlinable")
        XCTAssertNil(type.knownMethods[1].knownAttributes[0].parameters)
        XCTAssertEqual(type.knownMethods[1].knownAttributes[1].name, "_swiftrewriter")
        XCTAssertEqual(type.knownMethods[1].knownAttributes[1].parameters, "mapFrom: c(x: Int)")
    }
    
    func testParseSwiftAttribute() throws {
        let attribute = try parseAttribute("""
            @_swiftrewriter(mapFrom: dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?)
            """)
        
        XCTAssertEqual(attribute.content.asString, """
            mapFrom: dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?
            """)
    }
    
    func testParseSwiftAttributeRoundtrip() throws {
        _=try parseAttribute("""
            @_swiftrewriter(mapFrom: date() -> Date)
            """)
    }
    
    func testBackToBackTypeParse() throws {
        let type = try parseType("""
            class MyClass: UIView, UITableViewDelegate {
                var count: Int { get }
                var data: [String]
                subscript(index: Int, other: String) -> Bool
                
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
                subscript(index: Int, other: String) -> Bool
                
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
    
    func parseAttribute(_ string: String,
                        file: String = #file,
                        line: Int = #line) throws -> SwiftRewriterAttribute {
        
        do {
            let type =
                try SwiftClassInterfaceParser
                    .parseSwiftRewriterAttribute(from: Lexer(input: string))
            
            return type
        } catch {
            
            let description: String
            if let error = error as? LexerError {
                description = error.description(withOffsetsIn: string)
            } else {
                description = "\(error)"
            }
            
            recordFailure(withDescription: "Error while parsing attribute: \(description)",
                          inFile: file,
                          atLine: line,
                          expected: true)
            
            throw error
        }
    }
}
