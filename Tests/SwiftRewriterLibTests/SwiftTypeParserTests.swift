import XCTest
import SwiftAST
import SwiftRewriterLib

class SwiftTypeParserTests: XCTestCase {
    func testParseIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type"),
                           SwiftType.typeName("Type"))
    }
    
    func testParseOptionalIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type?"),
                           SwiftType.optional("Type"))
    }
    
    func testParseOptionalImplicitlyUnwrappedOptionalIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type?!"),
                           SwiftType.implicitUnwrappedOptional(.optional(.typeName("Type"))))
    }
    
    func testParseTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(Type1, Type2)"),
                           SwiftType.tuple([.typeName("Type1"), .typeName("Type2")]))
    }
    
    func testParseTupleInTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "((Type1, Type2), (Type3, Type4))"),
                           SwiftType.tuple([.tuple([.typeName("Type1"), .typeName("Type2")]), .tuple([.typeName("Type3"), .typeName("Type4")])]))
    }
    
    func testParseTupleTypeWithLabels() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(label1: Type1, label2: Type2)"),
                           SwiftType.tuple([.typeName("Type1"), .typeName("Type2")]))
    }
    
    func testParseBlockType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(Type1) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"), parameters: [.typeName("Type1")]))
    }
    
    func testParseBlockWithSignatures() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(_ param: Type1, param2: Type2) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"), parameters: [.typeName("Type1"), .typeName("Type2")]))
    }
    
    func testParseArray() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "[Type1]"),
                           SwiftType.array(.typeName("Type1")))
    }
    
    func testParseDirectory() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "[Type1: Type2]"),
                           SwiftType.dictionary(key: "Type1", value: "Type2"))
    }
    
    func testParseOptionalBlock() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(() -> ())?"),
                           SwiftType.optional(.block(returnType: .void, parameters: [])))
    }
    
    func testParseGenericType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<A>"),
                           SwiftType.generic("Type", parameters: [.typeName("A")]))
    }
    
    func testParseGenericTypeWitihinGenericType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<A<B>>"),
                           SwiftType.generic("Type", parameters: [.generic("A", parameters: [.typeName("B")])]))
    }
    
    func testParseGenericTypeWithTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<(A, B)>"),
                           SwiftType.generic("Type", parameters: [.tuple(["A", "B"])]))
    }
    
    func testParseExtraCharacterMessage() throws {
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "Type<(A, B))>"))
    }
}
