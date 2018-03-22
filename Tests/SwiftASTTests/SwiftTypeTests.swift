import XCTest
import SwiftAST

class SwiftTypeTests: XCTestCase {
    func testDescriptionTypeName() {
        XCTAssertEqual(SwiftType.typeName("A").description,
                       "A")
    }
    
    func testDescriptionGeneric() {
        XCTAssertEqual(SwiftType.generic("A", parameters: []).description, // This is actually an invalid type state, but we test it for consistency purposes.
                       "A<>")
        XCTAssertEqual(SwiftType.generic("A", parameters: [.typeName("B")]).description,
                       "A<B>")
        XCTAssertEqual(SwiftType.generic("A", parameters: [.typeName("B"), .typeName("C")]).description,
                       "A<B, C>")
    }
    
    func testDescriptionProtocolComposition() {
        XCTAssertEqual(SwiftType.protocolComposition([]).description, // This is actually an invalid type state, but we test it for consistency purposes.
                       "")
        XCTAssertEqual(SwiftType.protocolComposition([.typeName("A")]).description,
                       "A")
        XCTAssertEqual(SwiftType.protocolComposition([.typeName("A"), .typeName("B")]).description,
                       "A & B")
        XCTAssertEqual(SwiftType.protocolComposition([.typeName("A"), .typeName("B"), .typeName("C")]).description,
                       "A & B & C")
    }
    
    func testDescriptionNestedType() {
        XCTAssertEqual(SwiftType.nested(.typeName("A"), .typeName("B")).description,
                       "A.B")
        XCTAssertEqual(SwiftType.nested(.generic("A", parameters: [.typeName("B")]), .typeName("C")).description,
                       "A<B>.C")
        XCTAssertEqual(SwiftType.nested(.nested(.typeName("A"), .typeName("B")), .typeName("C")).description,
                       "A.B.C")
    }
    
    func testDescriptionMetadata() {
        XCTAssertEqual(SwiftType.metatype(for: .typeName("A")).description,
                       "A.Type")
        XCTAssertEqual(SwiftType.metatype(for: SwiftType.metatype(for: .typeName("A"))).description,
                       "A.Type.Type")
    }
    
    func testDescriptionTupleType() {
        XCTAssertEqual(SwiftType.tuple([]).description,
                       "Void")
        XCTAssertEqual(SwiftType.tuple([.typeName("A")]).description,
                       "(A)")
        XCTAssertEqual(SwiftType.tuple([.typeName("A"), .typeName("B")]).description,
                       "(A, B)")
        XCTAssertEqual(SwiftType.tuple([.typeName("A"), .typeName("B"), .typeName("C")]).description,
                       "(A, B, C)")
    }
    
    func testDescriptionBlockType() {
        XCTAssertEqual(SwiftType.block(returnType: .void, parameters: []).description,
                       "() -> Void")
    }
    
    func testDescriptionBlockTypeWithReturnType() {
        XCTAssertEqual(SwiftType.block(returnType: .typeName("A"), parameters: []).description,
                       "() -> A")
    }
    
    func testDescriptionBlockTypeWithParameters() {
        XCTAssertEqual(SwiftType.block(returnType: .void, parameters: [.typeName("A")]).description,
                       "(A) -> Void")
        XCTAssertEqual(SwiftType.block(returnType: .void, parameters: [.typeName("A"), .typeName("B")]).description,
                       "(A, B) -> Void")
    }
    
    func testDescriptionBlockFull() {
        XCTAssertEqual(SwiftType.block(returnType: .typeName("A"), parameters: [.typeName("B"), .typeName("C")]).description,
                       "(B, C) -> A")
    }
    
    func testDescriptionOptionalWithTypeName() {
        XCTAssertEqual(SwiftType.optional(.typeName("A")).description,
                       "A?")
    }
    
    func testDescriptionOptionalWithProtocolCompositionType() {
        XCTAssertEqual(SwiftType.optional(.protocolComposition([.typeName("A"), .typeName("B")])).description,
                       "(A & B)?")
    }
    
    func testDescriptionOptionalWithTupleType() {
        XCTAssertEqual(SwiftType.optional(.tuple([.typeName("A"), .typeName("B")])).description,
                       "(A, B)?")
    }
    
    func testDescriptionOptionalWithBlockTupleType() {
        XCTAssertEqual(SwiftType.optional(.block(returnType: .void, parameters: [.typeName("A"), .typeName("B")])).description,
                       "((A, B) -> Void)?")
    }
    
    func testDescriptionOptionalWithGenericType() {
        XCTAssertEqual(SwiftType.optional(.generic("A", parameters: [.typeName("B"), .typeName("C")])).description,
                       "A<B, C>?")
    }
    
    func testDescriptionOptionalWithNestedType() {
        XCTAssertEqual(SwiftType.optional(.nested(.typeName("A"), .typeName("B"))).description,
                       "A.B?")
    }
    
    func testDescriptionOptionalWithProtocolComposition() {
        XCTAssertEqual(SwiftType.optional(.protocolComposition([.typeName("A"), .typeName("B")])).description,
                       "(A & B)?")
    }
    
    func testDescriptionOptionalWithOptionalType() {
        XCTAssertEqual(SwiftType.optional(.optional(.typeName("A"))).description,
                       "A??")
    }
    
    func testDescriptionImplicitOptionalWithOptionalType() {
        XCTAssertEqual(SwiftType.implicitUnwrappedOptional(.optional(.typeName("A"))).description,
                       "A?!")
    }
    
    func testDescriptionImplicitOptionalWithTypeName() {
        XCTAssertEqual(SwiftType.implicitUnwrappedOptional(.typeName("A")).description,
                       "A!")
    }
    
    func testDescriptionArrayType() {
        XCTAssertEqual(SwiftType.array(.typeName("A")).description,
                       "[A]")
    }
    
    func testDescriptionDictionaryType() {
        XCTAssertEqual(SwiftType.dictionary(key: .typeName("A"), value: .typeName("B")).description,
                       "[A: B]")
    }
    
    func testWithSameOptionalityAs() {
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.any)),
            .optional(.int)
        )
        XCTAssertEqual(
            SwiftType.int.withSameOptionalityAs(.optional(.implicitUnwrappedOptional(.any))),
            .optional(.implicitUnwrappedOptional(.int))
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(.any),
            .int
        )
        XCTAssertEqual(
            SwiftType.optional(.int).withSameOptionalityAs(.optional(.implicitUnwrappedOptional(.any))),
            .optional(.implicitUnwrappedOptional(.int))
        )
    }
    
    /// Normalizing a nested protocol composition within a protocol composition
    /// (i.e. `(Type1 & Type2) & Type3` should result in a single unnested protocol
    /// composition with all types (`Type1 & Type2 & Type3`)
    func testNormalizeProtocolCompositionWithinProtocolComposition() {
        let compositionWithinComposition =
            SwiftType
                .protocolComposition([
                    .protocolComposition([.typeName("A"), .typeName("B")]),
                    .typeName("C")
                ])
        
        XCTAssertEqual(
            compositionWithinComposition.normalized,
            SwiftType.protocolComposition([.typeName("A"), .typeName("B"), .typeName("C")])
        )
    }
    
    /// Normalization of protocol composition by flattening inner protocol compositions
    /// types must be done at any arbitrary depth
    func testNormalizeProtocolCompositionWithinProtocolCompositionAtArbitraryDepth() {
        let compositionWithinComposition =
            SwiftType
                .protocolComposition([
                    .protocolComposition([
                        .typeName("A"),
                        .protocolComposition([
                            .typeName("B"),
                            .typeName("C")
                            ])
                        ]),
                    .typeName("D")
                    ])
        
        XCTAssertEqual(
            compositionWithinComposition.normalized,
            SwiftType.protocolComposition([.typeName("A"), .typeName("B"), .typeName("C"), .typeName("D")])
        )
    }
    
    /// Normalizing a nested-nested SwiftType should result in a left-most rebase
    /// where the base types are completely to the left of the enumeration tree.
    func testNormalizeNestedSwiftTypesToRebaseAtLeft() {
        let nestedNestedType =
            SwiftType.nested(.typeName("A"),
                             .nested(.typeName("B"), .typeName("C")))
        
        let nestedNestedNormalizedType =
            SwiftType.nested(.nested(.typeName("A"), .typeName("B")),
                             .typeName("C"))
        
        XCTAssertEqual(nestedNestedType.normalized, nestedNestedNormalizedType)
    }
    
    /// Normalization of nested types by rotating left must occur at an arbitrary
    /// nesting depth
    func testNormalizeNestedSwiftTypesToRebaseAtLeftDeep() {
        let nestedNestedType =
            SwiftType.nested(.nested(.typeName("A"), .typeName("B")),
                             .nested(.typeName("C"), .typeName("D")))
        
        let nestedNestedNormalizedType =
            SwiftType.nested(.nested(.nested(.typeName("A"), .typeName("B")), .typeName("C")),
                             .typeName("D"))
        
        XCTAssertEqual(nestedNestedType.normalized, nestedNestedNormalizedType)
    }
    
    func testEncode() throws {
        let type = SwiftType.block(returnType: .void, parameters: [.array(.string)])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeEmptyTuple() throws {
        let type = SwiftType.tuple([])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeSingleTypeTuple() throws {
        let type = SwiftType.tuple([.int, .string])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeTwoTypedTuple() throws {
        let type = SwiftType.tuple([.int, .string])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeNAryTypedTuple() throws {
        let type = SwiftType.tuple([.int, .string, .float, .double, .any])
        
        let encoded = try JSONEncoder().encode(type)
        let decoded = try JSONDecoder().decode(SwiftType.self, from: encoded)
        
        XCTAssertEqual(type, decoded)
    }
    
    func testEncodeAsNested() throws {
        struct Test: Codable {
            var type: SwiftType
        }
        
        let test =
            Test(type:
                SwiftType.tuple([.block(returnType: .implicitUnwrappedOptional(.protocolComposition([.typeName("A"), .typeName("B")])),
                                        parameters: [.generic("C", parameters: [.optional(.nested(.typeName("D"), .generic("E", parameters: [.typeName("D")])))])])]).normalized)
        
        let encoded = try JSONEncoder().encode(test)
        let decoded = try JSONDecoder().decode(Test.self, from: encoded)
        
        XCTAssertEqual(test.type, decoded.type)
    }
}
