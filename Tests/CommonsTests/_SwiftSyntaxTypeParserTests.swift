import XCTest
import SwiftAST
import KnownType
import TypeSystem
import Commons

class _SwiftSyntaxTypeParserTests: XCTestCase {
    var typeSystem: TypeSystem!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = TypeSystem()
    }
    
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
    
    func testParseExtension() {
        let result = parse("""
            extension A {
            }
            """)
        
        result.assertDefined(extensionNamed: "A")
    }
    
    func testParseWithSwiftSignatureMatching() {
        _=parseType("""
            class Empty {
                func a()
                func a() -> Int
            }
            """)
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
    
    func testParsePropertyAccessors() {
        let result = parse("""
            class A {
                var a: Int { get }
                var b: Int { get {} set {} }
                var c: Int {
                    return 0
                }
                var d: Int
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.properties.count, 4)
        XCTAssertEqual(type.properties[0].accessor, .getter)
        XCTAssertEqual(type.properties[1].accessor, .getterAndSetter)
        XCTAssertEqual(type.properties[2].accessor, .getter)
        XCTAssertEqual(type.properties[3].accessor, .getterAndSetter)
    }
    
    func testParseConstant() {
        let result = parse("""
            class A {
                let a: Int
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.fields.count, 1)
        XCTAssert(type.fields[0].storage.isConstant)
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
    
    func testParseSubscript() {
        let result = parse("""
            class A {
                subscript(index: Int) -> String
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts[0].parameters, [
            ParameterSignature(name: "index", type: .int)
        ])
        XCTAssertEqual(type.subscripts[0].returnType, .string)
        XCTAssertFalse(type.subscripts[0].isConstant)
    }
    
    func testParseSubscriptGetterOnly() {
        let result = parse("""
            class A {
                subscript(index: Int) -> String { get }
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.subscripts.count, 1)
        XCTAssertEqual(type.subscripts[0].parameters, [
            ParameterSignature(name: "index", type: .int)
        ])
        XCTAssertEqual(type.subscripts[0].returnType, .string)
        XCTAssert(type.subscripts[0].isConstant)
    }
    
    func testParseEnumCases() {
        let result = parse("""
            enum A: Int {
                case a
                case b = 0
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.traits[KnownTypeTraits.enumRawValue]?.asSwiftType, .int)
        XCTAssertEqual(type.properties.filter({ $0.isEnumCase }).count, 2)
        XCTAssertEqual(type.properties.filter({ $0.expression == .constant(0) }).count, 1)
    }
    
    func testParseInheritance() {
        let result = parse("""
            class A: B, C {
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.conformances.map(\.protocolName), ["B", "C"])
    }
    
    func testParseAttributes() {
        let result = parse("""
            @available(*, deprecated)
            class A {
                @available(*, deprecated) var a: Int
                @available(*, deprecated)
                init()
                
                @available(*, deprecated)
                func a()
            }
            """)
        
        let type = result.type(named: "A")!
        let expectedAttributes = [
            KnownAttribute(name: "available", parameters: "*, deprecated")
        ]
        XCTAssertEqual(type.attributes, expectedAttributes)
        XCTAssertEqual(type.properties[0].knownAttributes, expectedAttributes)
        XCTAssertEqual(type.constructors[0].knownAttributes, expectedAttributes)
        XCTAssertEqual(type.methods[0].knownAttributes, expectedAttributes)
    }
    
    func testParseSwiftAttributeInType() {
        let result = parse("""
            @_swiftrewriter(renameFrom: "NSMyClass")
            class MyClass {
                @_swiftrewriter(mapFrom: "b()")
                func a()
                @inlinable
                @_swiftrewriter(mapFrom: "c(x: Int)")
                @_swiftrewriter(mapFrom: "d(x:)")
                func b(y: Int)
            }
            """)
        
        let type = result.type(named: "MyClass")!
        XCTAssertEqual(type.attributes[0].name, "_swiftrewriter")
        XCTAssertEqual(type.attributes[0].parameters, #"renameFrom: "NSMyClass""#)
        XCTAssertEqual(type.methods[0].knownAttributes[0].name, "_swiftrewriter")
        XCTAssertEqual(type.methods[0].knownAttributes[0].parameters, #"mapFrom: "b()""#)
        XCTAssertEqual(type.methods[1].knownAttributes[0].name, "inlinable")
        XCTAssertNil(type.methods[1].knownAttributes[0].parameters)
        XCTAssertEqual(type.methods[1].knownAttributes[1].name, "_swiftrewriter")
        XCTAssertEqual(type.methods[1].knownAttributes[1].parameters, #"mapFrom: "c(x: Int)""#)
    }
    
    func testParseNestedType() {
        let result = parse("""
            class A {
                enum B {
                }
            }
            """)
        
        let type = result.type(named: "A")!
        XCTAssertEqual(type.nestedTypes.count, 1)
        XCTAssertEqual(type.nestedTypes[0].typeName, "B")
    }
    
    
    func testParseSupertypes() {
        let type = parseType("""
            class MyClass: UIView, B {
            }
            """)
        
        XCTAssertEqual(type.knownProtocolConformances.count, 1)
        XCTAssertEqual(type.knownProtocolConformances[0].protocolName, "B")
        XCTAssertEqual(type.supertype?.asTypeName, "UIView")
    }
    
    func testParseProtocolConformances() {
        let type = parseType("""
            class MyClass: A, B {
            }
            """)
        
        XCTAssertEqual(type.knownProtocolConformances.count, 2)
        XCTAssertEqual(type.knownProtocolConformances[0].protocolName, "A")
        XCTAssertEqual(type.knownProtocolConformances[1].protocolName, "B")
    }
    
    func testParseFunction() {
        let type = parseType("""
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
    
    func testParseStaticMembers() {
        let type = parseType("""
            class MyClass {
                static var a: Int
                static func c()
            }
            """)
        
        XCTAssertEqual(type.knownProperties.count, 1)
        XCTAssertEqual(type.knownMethods.count, 1)
        XCTAssert(type.knownProperties[0].isStatic)
        XCTAssert(type.knownMethods[0].isStatic)
    }
    
    func testParseSubscription() {
        let type = parseType("""
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
    
    func testParseSubscriptionWithZeroArguments() {
        let type = parseType("""
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
    
    func testParseStaticSubscription() {
        let type = parseType("""
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

    func testParseSubscriptionWithGetter() {
        let type = parseType("""
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
    
    func testParseExtensionDeclaration() {
        let type = parseType("""
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
    
    func testParseEscapedIdentifier() {
        let type = parseType("""
            class MyClass {
                var `default`: Int { get }
            }
            """)
        
        XCTAssertEqual(type.knownProperties.count, 1)
        XCTAssertEqual(type.knownProperties[0].name, "default")
    }
    
    func testBackToBackTypeParse() {
        let type = parseType("""
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

private extension _SwiftSyntaxTypeParserTests {
    func parse(_ source: String) -> SwiftSyntaxTypeParserTestFixture {
        let parser = _SwiftSyntaxTypeParser(source: source)
        let result = parser.parseTypes()
        
        return SwiftSyntaxTypeParserTestFixture(types: result)
    }
    
    func parseType(_ source: String) -> KnownType {
        let parser = _SwiftSyntaxTypeParser(source: source)
        let result = parser.parseTypes()
        let type = result[0]
        
        return type.complete(typeSystem: typeSystem)
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
    
    func assertDefined(extensionNamed name: String, line: UInt = #line) {
        if !types.contains(where: { $0.kind == .extension && $0.typeName == name }) {
            XCTFail("Expected extension named \(name)", line: line)
        }
    }
}
