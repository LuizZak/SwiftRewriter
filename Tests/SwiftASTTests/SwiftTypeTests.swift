import XCTest
import SwiftAST

class SwiftTypeTests: XCTestCase {
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
