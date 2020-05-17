import XCTest
import SwiftAST
import KnownType

class KnownTypeSerializerTests: XCTestCase {
    func testSerialization() throws {
        let type =
            KnownTypeBuilder(typeName: "A", supertype: "B", kind: .class)
                .constructor()
                .constructor(shortParameters: [("child", .optional(.typeName("A")))])
                .method(named: "a")
                .method(named: "b", shortParams: [("param", .int)], returning: .array(.int),
                        isStatic: false, optional: false)
                .method(named: "c", shortParams: [("param", .string), ("param2", .string)],
                        returning: .array(.int),
                        isStatic: true, optional: false)
                .property(named: "prop", type: .optional(.typeName("A")))
                .subscription(indexType: .int, type: .string)
                .field(named: "field", type: .string)
                .protocolConformance(protocolName: "P")
                .build()
        let expected = TypeFormatter.asString(knownType: type)
        
        let data = try KnownTypeSerializer.serialize(type: type)
        let resultType = try KnownTypeSerializer.deserialize(from: data)
        
        let result = TypeFormatter.asString(knownType: resultType)
        
        XCTAssertEqual(
            expected, result,
            """
            Failed to re-generate expected type signature:
            Expected:
            
            \(expected)
            
            Result:
            
            \(result.makeDifferenceMarkString(against: expected))
            """)
    }
    
    func testSerializeEnumType() throws {
        let type =
            KnownTypeBuilder(typeName: "A", kind: .enum)
                .settingEnumRawValue(type: .int)
                .enumCase(named: "a")
                .build()
        let expected = TypeFormatter.asString(knownType: type)
        
        let data = try KnownTypeSerializer.serialize(type: type)
        let resultType = try KnownTypeSerializer.deserialize(from: data)
        
        let result = TypeFormatter.asString(knownType: resultType)
        
        XCTAssertEqual(
            expected, result,
            """
            Failed to re-generate expected type signature:
            Expected:
            
            \(expected)
            
            Result:
            
            \(result.makeDifferenceMarkString(against: expected))
            """)
    }
    
    func testSerializeTraitTypeWithSwiftType() throws {
        let trait = TraitType.swiftType(.typeName("TypeA"))
        
        let data = try JSONEncoder().encode(trait)
        let unserialized = try JSONDecoder().decode(TraitType.self, from: data)
        
        XCTAssertEqual(trait, unserialized)
    }
    
    func testSerializeTraitTypeWithSemantics() throws {
        let trait = TraitType.semantics([Semantic(name: "S1"), Semantic(name: "S2")])
        
        let data = try JSONEncoder().encode(trait)
        let unserialized = try JSONDecoder().decode(TraitType.self, from: data)
        
        XCTAssertEqual(trait, unserialized)
    }
}
