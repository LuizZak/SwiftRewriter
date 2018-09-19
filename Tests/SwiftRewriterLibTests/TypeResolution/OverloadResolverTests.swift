import XCTest
@testable import SwiftRewriterLib
import SwiftAST

class OverloadResolverTests: XCTestCase {
    var typeSystem: DefaultTypeSystem!
    var sut: OverloadResolver!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = DefaultTypeSystem()
        sut = OverloadResolver(typeSystem: typeSystem)
    }
    
    func testOverloadResolver() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            .bool
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testOverloadResolverWithEmptyFunction() throws {
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo()")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: [])
        
        XCTAssertEqual(index, 1)
    }
    
    func testResolveWithIncompleteArgumentTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            nil
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testReturnFirstMatchOnAmbiguousCases() throws {
        let argumentTypes: [SwiftType?] = [
            nil,
            .bool
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 0)
    }
    
    func testMatchLooksThroughOptionalArgumentTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .optional(.int),
            .bool
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testMatchLooksThroughOptionalParameterTypes() throws {
        let argumentTypes: [SwiftType?] = [
            .int,
            .bool
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String?, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int?, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testMatchFavoringSameOptionality() throws {
        let argumentTypes: [SwiftType?] = [
            .optional(.int),
            .bool
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: Int, b: Bool)"),
            try FunctionSignature(signatureString: "foo(a: Int?, b: Bool)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testPolymorphicResolving() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build())
        let argumentTypes: [SwiftType?] = [
            "B"
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String)"),
            try FunctionSignature(signatureString: "foo(a: A)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testPolymorphicResolvingFavorsExactMatching() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build())
        let argumentTypes: [SwiftType?] = [
            "B"
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: B)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testPolymorphicResolvingLooksThroughOptionalArgumentTypes() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build())
        let argumentTypes: [SwiftType?] = [
            .optional("B")
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: String)"),
            try FunctionSignature(signatureString: "foo(a: A)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testOverloadResolveWithDefaultArgument() throws {
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int, c: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int = default)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: [])
        
        XCTAssertEqual(index, 1)
    }
    
    func testOverloadResolveWithDefaultArgumentNonEmptyArgumentCount() throws {
        let argumentTypes: [SwiftType?] = [
            .int, .int, .int
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int, c: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testResolveWithOverloadWithDefaultArgumentValueAtEnd() throws {
        let argumentTypes: [SwiftType?] = [
            .int, .int
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(b: Int)"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
    
    func testOverloadsWithDefaultArgumentsNoResolution() throws {
        let argumentTypes: [SwiftType?] = [
            .int
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo()"),
            try FunctionSignature(signatureString: "foo(a: Int, c: Int, d: Int = default)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertNil(index)
    }
    
    // FIXME: Making this pass would not be vital, but would also be nice for
    // completeness sake.
    func xtestMatchFavoringSameOptionalityWithPolymorphism() throws {
        typeSystem.addType(KnownTypeBuilder(typeName: "A").build())
        typeSystem.addType(
            KnownTypeBuilder(typeName: "B")
                .settingSupertype(KnownTypeReference.typeName("A"))
                .build())
        let argumentTypes: [SwiftType?] = [
            .optional("B")
        ]
        let signatures: [FunctionSignature] = [
            try FunctionSignature(signatureString: "foo(a: A)"),
            try FunctionSignature(signatureString: "foo(a: A?)")
        ]
        
        let index = sut.findBestOverload(inSignatures: signatures, argumentTypes: argumentTypes)
        
        XCTAssertEqual(index, 1)
    }
}
