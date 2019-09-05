import XCTest
import SwiftAST
import KnownType
import Intentions
import SwiftRewriterLib

class TypeFormatterTests: XCTestCase {
    func testAsStringMethodFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .method(withSignature:
                    FunctionSignature(name: "a",
                                      parameters: [ParameterSignature(label: nil, name: "a", type: .int)],
                                      returnType: .void,
                                      isStatic: false)
                ).build()
        
        XCTAssertEqual(
            "A.a(_ a: Int)",
            TypeFormatter.asString(method: type.knownMethods[0], ofType: type)
        )
    }
    
    func testAsStringPropertyFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .property(named: "a", type: .int)
                .build()
        
        XCTAssertEqual(
            "A.a: Int",
            TypeFormatter.asString(property: type.knownProperties[0], ofType: type)
        )
    }
    
    func testAsStringPropertyFromTypeWithTypeNameAndVarKeywordAndAccessors() {
        let storage = ValueStorage(type: .int, ownership: .weak, isConstant: true)
        let type =
            KnownTypeBuilder(typeName: "A")
                .property(named: "a", storage: storage, isStatic: false, optional: false)
                .build()
        
        XCTAssertEqual(
            "weak var A.a: Int { get set }",
            TypeFormatter.asString(property: type.knownProperties[0], ofType: type,
                                   withTypeName: true, includeVarKeyword: true,
                                   includeAccessors: true)
        )
    }
    
    func testAsStringPropertyFromTypeWithArrayType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .property(named: "a", type: .array(.int))
                .build()
        
        XCTAssertEqual(
            "A.a: [Int]",
            TypeFormatter.asString(property: type.knownProperties[0], ofType: type)
        )
    }
    
    func testAsStringPropertyFromTypeWithOptionalArrayType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .property(named: "a", type: .optional(.array(.int)))
                .build()
        
        XCTAssertEqual(
            "A.a: [Int]?",
            TypeFormatter.asString(property: type.knownProperties[0], ofType: type)
        )
    }
    
    func testAsStringFieldFromType() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .build()
        
        let field =
            InstanceVariableGenerationIntention(
                name: "a",
                storage: ValueStorage(type: .int,
                                      ownership: .strong,
                                      isConstant: false)
            )
        
        XCTAssertEqual(
            "A.a: Int",
            TypeFormatter.asString(field: field, ofType: type)
        )
    }
    
    func testAsStringSubscript() {
        let type =
            KnownTypeBuilder(typeName: "A")
                .subscription(indexType: .int, type: .string)
                .build()
        
        XCTAssertEqual(
            "A.subscript(index: Int) -> String",
            TypeFormatter.asString(subscript: type.knownSubscripts[0], ofType: type)
        )
    }
    
    func testAsStringExtension() {
        let extA = ClassExtensionGenerationIntention(typeName: "A")
        let extB = ClassExtensionGenerationIntention(typeName: "B")
        extB.categoryName = "Category"
        
        XCTAssertEqual("extension A", TypeFormatter.asString(extension: extA))
        XCTAssertEqual("extension B (Category)", TypeFormatter.asString(extension: extB))
    }
    
    func testAsStringKnownType() {
        let type = KnownTypeBuilder(typeName: "A", kind: .struct)
            .settingAttributes([KnownAttribute(name: "attr", parameters: nil)])
            .constructor()
            .constructor(shortParameters: [("a", .int), ("b", .int)],
                         annotations: ["Annotation"])
            .field(named: "readOnlyField",
                   type: .string,
                   isConstant: true,
                   annotations: ["Annotation"])
            .field(named: "field",
                   type: .string,
                   attributes: [KnownAttribute(name: "attr", parameters: nil)])
            .property(named: "prop",
                      type: .optional(.nsArray),
                      attributes: [KnownAttribute(name: "attr", parameters: nil)],
                      annotations: ["Annotation"])
            .property(named: "readOnlyProp",
                      type: "A",
                      accessor: .getter,
                      attributes: [KnownAttribute(name: "attr", parameters: nil)],
                      annotations: ["Annotation"])
            .subscription(indexType: .int,
                          type: .string,
                          isConstant: true,
                          attributes: [KnownAttribute(name: "attr", parameters: nil)],
                          annotations: ["Annotation"])
            .protocolConformance(protocolName: "Protocol")
            .method(withSignature: FunctionSignature(
                name: "methodA",
                parameters: [
                    ParameterSignature(label: nil, name: "c", type: .int)
                ],
                returnType: .string),
                    attributes: [KnownAttribute(name: "_attribute", parameters: nil),
                                 KnownAttribute(name: "_attribute2", parameters: "param")],
                    annotations: ["Annotation"]
            )
            .build()
        
        let result = TypeFormatter.asString(knownType: type)
        let expected = """
            @attr
            struct A: Protocol {
                // Annotation
                let readOnlyField: String
                @attr var field: String
                
                // Annotation
                @attr var prop: NSArray?
                
                // Annotation
                @attr var readOnlyProp: A { get }
                
                // Annotation
                @attr subscript(index: Int) -> String { get }
                
                init()
                
                // Annotation
                init(a: Int, b: Int)
                
                // Annotation
                @_attribute
                @_attribute2(param)
                func methodA(_ c: Int) -> String
            }
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testLongAttributeProperty() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(named: "prop1", type: "A",
                      attributes: [KnownAttribute(name: "attr", parameters: nil)])
            .property(named: "prop2", type: "A",
                      attributes: [KnownAttribute(name: "attributeWithVeryLongName",
                                                  parameters: nil)])
            .property(named: "prop3", type: "A",
                      attributes: [KnownAttribute(name: "attr1", parameters: nil),
                                   KnownAttribute(name: "attr2", parameters: nil),
                                   KnownAttribute(name: "attr3", parameters: nil)])
            .build()
        
        let result = TypeFormatter.asString(knownType: type)
        let expected = """
            class A {
                @attr var prop1: A
                
                @attributeWithVeryLongName
                var prop2: A
                
                @attr1
                @attr2
                @attr3
                var prop3: A
            }
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringKnownTypeExtension() {
        let type = KnownTypeBuilder(typeName: "A", kind: .class)
            .settingIsExtension(true)
            .property(named: "a", type: .int)
            .build()
        
        let result = TypeFormatter.asString(knownType: type)
        let expected = """
            extension A {
                var a: Int
            }
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringKnownTypeEnum() {
        let type = KnownTypeBuilder(typeName: "A", kind: .enum)
            .enumRawValue(type: .int)
            .enumCase(named: "a")
            .enumCase(named: "b", rawValue: .constant(1))
            .build()
        
        let result = TypeFormatter.asString(knownType: type)
        let expected = """
            enum A: Int {
                case a
                case b
            }
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringEmptyInitializer() {
        let initializer = InitGenerationIntention(parameters: [])
        
        let result = TypeFormatter.asString(initializer: initializer)
        let expected = """
            init()
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringFailableInitializer() {
        let initializer = InitGenerationIntention(parameters: [])
        initializer.isFailable = true
        
        let result = TypeFormatter.asString(initializer: initializer)
        let expected = """
            init?()
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringConvenienceInitializer() {
        let initializer = InitGenerationIntention(parameters: [])
        initializer.isConvenience = true
        
        let result = TypeFormatter.asString(initializer: initializer)
        let expected = """
            convenience init()
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
    
    func testAsStringParameterizedInitializer() {
        let initializer =
            InitGenerationIntention(
                parameters: [
                    ParameterSignature(label: "label", name: "name", type: .int)
                ])
        
        let result = TypeFormatter.asString(initializer: initializer)
        let expected = """
            init(label name: Int)
            """
        
        XCTAssertEqual(result, expected, "\n" + result.makeDifferenceMarkString(against: expected))
    }
}
