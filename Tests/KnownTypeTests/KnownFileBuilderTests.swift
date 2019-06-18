import XCTest
import SwiftAST
import KnownType

class KnownFileBuilderTests: XCTestCase {
    func testEphemeral() {
        let sut = KnownFileBuilder(fileName: "FileName.h")
        let file = sut.build()
        
        XCTAssertEqual(sut.fileName, "FileName.h")
        XCTAssertEqual(file.fileName, "FileName.h")
        XCTAssertEqual(file.knownTypes.count, 0)
    }
    
    func testClass() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .class(name: "AClass") {
                    $0.constructor()
                }
        
        let file = sut.build()
        
        XCTAssertEqual(file.knownTypes.count, 1)
        XCTAssertEqual(file.knownTypes.first?.kind, .class)
        XCTAssertEqual(file.knownTypes.first?.typeName, "AClass")
        XCTAssertEqual(file.knownTypes.first?.knownConstructors.count, 1)
    }
    
    func testStruct() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .struct(name: "AStruct") {
                    $0.constructor()
                }
        
        let file = sut.build()
        
        XCTAssertEqual(file.knownTypes.count, 1)
        XCTAssertEqual(file.knownTypes.first?.kind, .struct)
        XCTAssertEqual(file.knownTypes.first?.typeName, "AStruct")
        XCTAssertEqual(file.knownTypes.first?.knownConstructors.count, 1)
    }
    
    func testProtocol() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .protocol(name: "AProtocol") {
                    $0.constructor()
                }
        
        let file = sut.build()
        
        XCTAssertEqual(file.knownTypes.count, 1)
        XCTAssertEqual(file.knownTypes.first?.kind, .protocol)
        XCTAssertEqual(file.knownTypes.first?.typeName, "AProtocol")
        XCTAssertEqual(file.knownTypes.first?.knownConstructors.count, 1)
    }
    
    func testEnum() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .enum(name: "AnEnum") {
                    $0.constructor()
                }
        
        let file = sut.build()
        
        XCTAssertEqual(file.knownTypes.count, 1)
        XCTAssertEqual(file.knownTypes.first?.kind, .enum)
        XCTAssertEqual(file.knownTypes.first?.typeName, "AnEnum")
        XCTAssertEqual(file.knownTypes.first?.knownConstructors.count, 1)
    }
    
    func testAssignsKnownTypeFile() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .class(name: "AClass")
        
        let file = sut.build()
        
        XCTAssertNotNil(file.knownTypes[0].knownFile)
        XCTAssertNotNil(file.knownTypes[0].knownFile?.fileName, "FileName.h")
    }
}
