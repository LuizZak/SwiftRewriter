import XCTest
import SwiftAST

@testable import KnownType

class KnownFileBuilderTests: XCTestCase {
    func testEphemeral() {
        let sut = KnownFileBuilder(fileName: "FileName.h")
        let file = sut.build()
        
        XCTAssertEqual(sut.fileName, "FileName.h")
        XCTAssertEqual(file.fileName, "FileName.h")
        XCTAssert(file.types.isEmpty)
        XCTAssert(file.globals.isEmpty)
        XCTAssert(file.importDirectives.isEmpty)
    }
    
    func testImportDirective() {
        let sut =
            KnownFileBuilder(fileName: "FileName.swift")
                .importDirective("ModuleA")
        
        let file = sut.build()
        XCTAssertEqual(file.importDirectives, ["ModuleA"])
    }
    
    func testClass() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .class(name: "AClass") {
                    $0.constructor()
                }
        
        let file = sut.build()
        XCTAssertEqual(file.types.count, 1)
        XCTAssertEqual(file.types.first?.kind, .class)
        XCTAssertEqual(file.types.first?.typeName, "AClass")
        XCTAssertEqual(file.types.first?.knownConstructors.count, 1)
    }
    
    func testStruct() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .struct(name: "AStruct") {
                    $0.constructor()
                }
        
        let file = sut.build()
        XCTAssertEqual(file.types.count, 1)
        XCTAssertEqual(file.types.first?.kind, .struct)
        XCTAssertEqual(file.types.first?.typeName, "AStruct")
        XCTAssertEqual(file.types.first?.knownConstructors.count, 1)
    }
    
    func testProtocol() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .protocol(name: "AProtocol") {
                    $0.constructor()
                }
        
        let file = sut.build()
        XCTAssertEqual(file.types.count, 1)
        XCTAssertEqual(file.types.first?.kind, .protocol)
        XCTAssertEqual(file.types.first?.typeName, "AProtocol")
        XCTAssertEqual(file.types.first?.knownConstructors.count, 1)
    }
    
    func testEnum() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .enum(name: "AnEnum") {
                    $0.constructor()
                }
        
        let file = sut.build()
        XCTAssertEqual(file.types.count, 1)
        XCTAssertEqual(file.types.first?.kind, .enum)
        XCTAssertEqual(file.types.first?.typeName, "AnEnum")
        XCTAssertEqual(file.types.first?.knownConstructors.count, 1)
    }
    
    func testGlobalFunction() {
        let signature = FunctionSignature(name: "function")
        let semantics = Set<Semantic>([.init(name: "semantic")])
        
        let sut =
            KnownFileBuilder(fileName: "FileName.swift")
                .globalFunction(signature: signature, semantics: semantics)
        
        let file = sut.build()
        XCTAssertEqual(file.globals.count, 1)
        XCTAssert(file.globals.first is KnownGlobalFunction)
        XCTAssertEqual(file.globals.first?.semantics, semantics)
        XCTAssertEqual((file.globals.first as? KnownGlobalFunction)?.signature, signature)
    }
    
    func testGlobalVar() {
        let storage = ValueStorage(type: .int, ownership: .weak, isConstant: true)
        let semantics = Set<Semantic>([.init(name: "semantic")])
        
        let sut =
            KnownFileBuilder(fileName: "FileName.swift")
                .globalVar(name: "v", storage: storage, semantics: semantics)
        
        let file = sut.build()
        XCTAssertEqual(file.globals.count, 1)
        XCTAssert(file.globals.first is KnownGlobalVariable)
        XCTAssertEqual(file.globals.first?.semantics, semantics)
        XCTAssertEqual((file.globals.first as? KnownGlobalVariable)?.storage, storage)
    }
    
    func testAssignsKnownTypeFile() {
        let sut =
            KnownFileBuilder(fileName: "FileName.h")
                .class(name: "AClass")
                .globalFunction(signature: FunctionSignature(name: "f"))
                .globalVar(name: "v", storage: ValueStorage(type: .int, ownership: .strong, isConstant: false))
        
        let file = sut.build()
        
        XCTAssertNotNil(file.types[0].knownFile)
        XCTAssertNotNil(file.types[0].knownFile?.fileName, "FileName.h")
        XCTAssertNotNil(file.globals[0].knownFile)
        XCTAssertNotNil(file.globals[1].knownFile)
    }
    
    func testInitCopying() {
        let fileA =
            KnownFileBuilder(fileName: "FileName.h")
                .importDirective("ModuleA")
                .class(name: "AClass")
                .globalFunction(signature: FunctionSignature(name: "f"))
                .globalVar(name: "v", storage: ValueStorage(type: .int, ownership: .strong, isConstant: false))
                .build()
        
        let sut = KnownFileBuilder(from: fileA)
        
        XCTAssert(areEquivalent(fileA, sut.build()))
    }
}
