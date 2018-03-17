import XCTest
import SwiftAST
import SwiftRewriterLib

class DefaultTypeSystemTests: XCTestCase {
    var sut: DefaultTypeSystem!
    
    override func setUp() {
        sut = DefaultTypeSystem()
    }
    
    func testDefaultValueForNumerics() {
        XCTAssertEqual(sut.defaultValue(for: .int), .constant(0))
        XCTAssertEqual(sut.defaultValue(for: .uint), .constant(0))
        XCTAssertEqual(sut.defaultValue(for: .float), .constant(0.0))
        XCTAssertEqual(sut.defaultValue(for: .double), .constant(0.0))
    }
    
    func testDefaultValueForBool() {
        XCTAssertEqual(sut.defaultValue(for: .bool), .constant(false))
    }
    
    func testDefaultValueForOptionals() {
        XCTAssertEqual(sut.defaultValue(for: .optional(.int)), .constant(.nil))
        XCTAssertEqual(sut.defaultValue(for: .optional(.string)), .constant(.nil))
        XCTAssertEqual(sut.defaultValue(for: .optional(.double)), .constant(.nil))
        XCTAssertEqual(sut.defaultValue(for: .optional(.array(.int))), .constant(.nil))
    }
    
    func testIsNumeric() {
        // 64-bits
        XCTAssert(sut.isNumeric(.typeName("Int64")))
        XCTAssert(sut.isNumeric(.typeName("UInt64")))
        XCTAssert(sut.isNumeric(.typeName("CLongLong")))
        XCTAssert(sut.isNumeric(.typeName("CUnsignedLongLong")))
        
        // 32-bits
        XCTAssert(sut.isNumeric(.typeName("Int")))
        XCTAssert(sut.isNumeric(.typeName("UInt")))
        XCTAssert(sut.isNumeric(.typeName("Int32")))
        XCTAssert(sut.isNumeric(.typeName("UInt32")))
        XCTAssert(sut.isNumeric(.typeName("CInt")))
        XCTAssert(sut.isNumeric(.typeName("CUnsignedInt")))
        XCTAssert(sut.isNumeric(.typeName("CChar32")))
        
        // 16-bits
        XCTAssert(sut.isNumeric(.typeName("Int16")))
        XCTAssert(sut.isNumeric(.typeName("UInt16")))
        XCTAssert(sut.isNumeric(.typeName("CShort")))
        XCTAssert(sut.isNumeric(.typeName("CUnsignedShort")))
        XCTAssert(sut.isNumeric(.typeName("CChar16")))
        
        // 8-bits
        XCTAssert(sut.isNumeric(.typeName("Int8")))
        XCTAssert(sut.isNumeric(.typeName("UInt8")))
        XCTAssert(sut.isNumeric(.typeName("CChar")))
        XCTAssert(sut.isNumeric(.typeName("CUnsignedChar")))
        
        // Floating-point
        XCTAssert(sut.isNumeric(.typeName("Float")))
        XCTAssert(sut.isNumeric(.typeName("Float80")))
        XCTAssert(sut.isNumeric(.typeName("Double")))
        XCTAssert(sut.isNumeric(.typeName("CFloat")))
        XCTAssert(sut.isNumeric(.typeName("CDouble")))
        
        // Boolean (considered numeric due to semantics of C)
        XCTAssert(sut.isNumeric(.typeName("CBool")))
    }
    
    func testIsTypeSubtypeOf() {
        let typeA = KnownTypeBuilder(typeName: "A").build()
        let typeB = KnownTypeBuilder(typeName: "B", supertype: typeA).build()
        let typeC = KnownTypeBuilder(typeName: "C", supertype: typeB).build()
        
        sut.addType(typeA)
        sut.addType(typeB)
        sut.addType(typeC)
        
        XCTAssertTrue(sut.isType("A", subtypeOf: "A"))
        XCTAssertTrue(sut.isType("B", subtypeOf: "A"))
        XCTAssertTrue(sut.isType("C", subtypeOf: "A"))
        XCTAssertFalse(sut.isType("A", subtypeOf: "B"))
        XCTAssertFalse(sut.isType("A", subtypeOf: "C"))
    }
    
    func testNSObjectDefinition() {
        guard let type = sut.knownTypeWithName("NSObject") else {
            XCTFail("Expected NSObject to be present")
            return
        }
        
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSObject's default parameterless constructor")
        XCTAssertNotNil(sut.conformance(toProtocolName: "NSObjectProtocol", in: type))
        
        // NSObjectProtocol methods
        XCTAssertNotNil(
            sut.method(withObjcSelector: FunctionSignature(name: "responds",
                                                           parameters: [
                                                            ParameterSignature(label: "to",
                                                                               name: "selector",
                                                                               type: .selector)]),
                       static: false,
                       includeOptional: true,
                       in: type)
        )
    }
    
    func testNSArrayDefinition() {
        guard let type = sut.knownTypeWithName("NSArray") else {
            XCTFail("Expected NSArray to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSArray's default parameterless constructor")
    }
    
    func testNSMutableArrayDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableArray") else {
            XCTFail("Expected NSMutableArray to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSArray")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableArray's default parameterless constructor")
    }
    
    func testNSDictionaryDefinition() {
        guard let type = sut.knownTypeWithName("NSDictionary") else {
            XCTFail("Expected NSDictionary to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSDictionary's default parameterless constructor")
    }
    
    func testNSMutableDictionaryDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableDictionary") else {
            XCTFail("Expected NSMutableDictionary to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSDictionary")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableDictionary's default parameterless constructor")
    }
    
    func testNSDateDefinition() {
        guard let type = sut.knownTypeWithName("NSDate") else {
            XCTFail("Expected NSDate to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSDate's default parameterless constructor")
    }
    
    func testNSDataDefinition() {
        guard let type = sut.knownTypeWithName("NSData") else {
            XCTFail("Expected NSData to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSData's default parameterless constructor")
    }
    
    func testNSMutableDataDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableData") else {
            XCTFail("Expected NSMutableData to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asKnownType?.typeName, "NSData")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableData's default parameterless constructor")
    }
    
    func testNSMutableStringDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableString") else {
            XCTFail("Expected NSMutableString to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSString")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableString's default parameterless constructor")
    }
    
    func testNSObjectProtocolDefinition() {
        guard let type = sut.knownTypeWithName("NSObjectProtocol") else {
            XCTFail("Expected NSObjectProtocol to be present")
            return
        }
        
        XCTAssertEqual(type.kind, .protocol)
    }
    
    func testNSFormatterDefinition() {
        guard let type = sut.knownTypeWithName("NSFormatter") else {
            XCTFail("Expected NSFormatter to be present")
            return
        }
        
        XCTAssertEqual(type.kind, .class)
        XCTAssertEqual(type.supertype?.asTypeName, "NSObject")
    }
    func testNSDateFormatterDefinition() {
        guard let type = sut.knownTypeWithName("NSDateFormatter") else {
            XCTFail("Expected NSDateFormatter to be present")
            return
        }
        
        XCTAssertEqual(type.kind, .class)
        XCTAssertEqual(type.supertype?.asTypeName, "NSFormatter")
    }
    
    func testConstructorSearchesThroughSupertypes() {
        let type1 = KnownTypeBuilder(typeName: "A").constructor().build()
        let type2 = KnownTypeBuilder(typeName: "B", supertype: type1).build()
        let type3 = KnownTypeBuilder(typeName: "C", supertype: type2).build()
        
        sut.addType(type1)
        sut.addType(type2)
        sut.addType(type3)
        
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type1))
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type2))
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type3))
    }
    
    func testConstructorSearchesTypeNamedSupertypes() {
        let type1 = KnownTypeBuilder(typeName: "A").constructor().build()
        let type2 = KnownTypeBuilder(typeName: "B", supertype: type1).build()
        let type3 = KnownTypeBuilder(typeName: "C", supertype: "B").build()
        
        sut.addType(type1)
        sut.addType(type2)
        sut.addType(type3)
        
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type1))
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type2))
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type3))
    }
    
    func testMethodLookupIgnoresOptionalProtocolMethodsNotImplemented() {
        let prot =
            KnownTypeBuilder(typeName: "A", kind: .protocol)
                .method(named: "nonOptional", returning: .void)
                .method(named: "optional", returning: .void, optional: true)
                .method(named: "optionalImplemented", returning: .void, optional: true)
                .build()
        let cls =
            KnownTypeBuilder(typeName: "B")
                .protocolConformance(protocolName: "A")
                .method(named: "optionalImplemented", returning: .void)
                .build()
        sut.addType(prot)
        sut.addType(cls)
        
        XCTAssertNotNil(sut.method(withObjcSelector: FunctionSignature(name: "nonOptional"),
                                   static: false, includeOptional: false, in: cls))
        XCTAssertNil(sut.method(withObjcSelector: FunctionSignature(name: "optional"),
                                static: false, includeOptional: false, in: cls))
        XCTAssertNotNil(sut.method(withObjcSelector: FunctionSignature(name: "optional"),
                                static: false, includeOptional: true, in: cls))
        XCTAssertNotNil(sut.method(withObjcSelector: FunctionSignature(name: "optionalImplemented"),
                                   static: false, includeOptional: false, in: cls))
    }
    
    func testDefaultValueForClassTypeIsAlwaysNil() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .class)
                .constructor()
                .build()
        sut.addType(str)
        
        XCTAssertNil(sut.defaultValue(for: .typeName("A")))
    }
    
    func testDefaultValueForProtocolTypeIsAlwaysNil() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .protocol)
                .constructor()
                .build()
        sut.addType(str)
        
        XCTAssertNil(sut.defaultValue(for: .typeName("A")))
    }
    
    func testDefaultValueForStructWithNoEmptyConstructorEvaluatesToNil() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .build()
        sut.addType(str)
        
        XCTAssertNil(sut.defaultValue(for: .typeName("A")))
    }
    
    func testDefaultValueForStructWithEmptyConstructor() {
        let str =
            KnownTypeBuilder(typeName: "A", kind: .struct)
                .constructor()
                .build()
        sut.addType(str)
        
        XCTAssertEqual(sut.defaultValue(for: .typeName("A")), Expression.identifier("A").call())
    }
    
    func testAddTypeAlias() {
        sut.addTypeAlias(name: "A", target: .block(returnType: .void, parameters: []))
        
        XCTAssertEqual(sut.resolveAlias(in: "A"), .block(returnType: .void, parameters: []))
    }
    
    func testResolveAliasRecursive() {
        sut.addTypeAlias(name: "B", target: .int)
        sut.addTypeAlias(name: "A", target: .block(returnType: .void, parameters: [.typeName("B")]))
        
        XCTAssertEqual(sut.resolveAlias(in: "A"), .block(returnType: .void, parameters: [.int]))
    }
    
    func testResolveAliasSwiftType() {
        sut.addTypeAlias(name: "B", target: .int)
        sut.addTypeAlias(name: "A", target: .block(returnType: .void, parameters: [.typeName("B")]))
        
        XCTAssertEqual(sut.resolveAlias(in: .block(returnType: .void, parameters: [.typeName("A")])),
                       .block(returnType: .void, parameters: [.block(returnType: .void, parameters: [.int])]))
    }
}
