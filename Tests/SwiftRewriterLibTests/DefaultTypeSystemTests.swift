import XCTest
import SwiftAST
import SwiftRewriterLib

class DefaultTypeSystemTests: XCTestCase {
    var sut: DefaultTypeSystem!
    
    override func setUp() {
        sut = DefaultTypeSystem()
    }
    
    // MARK: - typesMatch
    
    func testTypesMatchSameStructure() {
        XCTAssert(sut.typesMatch(.typeName("A"),
                                 .typeName("A"),
                                 ignoreNullability: false))
        
        XCTAssert(sut.typesMatch(.nested([.typeName("A"), .typeName("B")]),
                                 .nested([.typeName("A"), .typeName("B")]),
                                 ignoreNullability: false))
    }
    
    func testTypesMatchSameStructureDifferentTypes() {
        XCTAssertFalse(sut.typesMatch(.typeName("A"),
                                      .typeName("DIFFER"),
                                      ignoreNullability: false))
        
        XCTAssertFalse(sut.typesMatch(.nested([.typeName("A"), .typeName("B")]),
                                      .nested([.typeName("A"), .typeName("DIFFER")]),
                                      ignoreNullability: false))
    }
    
    func testTypesMatchIgnoringNullability() {
        XCTAssert(sut.typesMatch(.optional(.typeName("A")),
                                 .typeName("A"),
                                 ignoreNullability: true))
        
        XCTAssert(sut.typesMatch(.optional(.nested([.typeName("A"), .typeName("B")])),
                                 .nested([.typeName("A"), .typeName("B")]),
                                 ignoreNullability: true))
    }
    
    func testTypesMatchExpandingTypeAliases() {
        sut.addTypealias(aliasName: "A", originalType: "B")
        
        XCTAssert(sut.typesMatch(.typeName("A"),
                                 .typeName("B"),
                                 ignoreNullability: false))
    }
    
    func testTypesMatchExpandingTypeAliasesDeep() {
        sut.addTypealias(aliasName: "A", originalType: "B")
        sut.addTypealias(aliasName: "C", originalType: .generic("D", parameters: .one(.typeName("A"))))
        
        XCTAssert(sut.typesMatch(.typeName("C"),
                                 .generic("D", parameters: .one(.typeName("A"))),
                                 ignoreNullability: false))
        XCTAssert(sut.typesMatch(.typeName("C"),
                                 .generic("D", parameters: .one(.typeName("B"))),
                                 ignoreNullability: false))
    }
    
    func testTypesMatchExpandingAliasesInBlockType() {
        sut.addTypealias(aliasName: "A", originalType: "B")
        
        XCTAssert(sut.typesMatch(.block(returnType: "A", parameters: []),
                                 .block(returnType: "B", parameters: []),
                                 ignoreNullability: false))
    }
    
    func testExpandBlockTypeAliases() {
        sut.addTypealias(
            aliasName: "A",
            originalType: .block(returnType: .void, parameters: []))
        
        XCTAssert(sut.typesMatch(.typeName("A"),
                                 .block(returnType: .void, parameters: []),
                                 ignoreNullability: false))
    }
    
    func testExpandBlockTypeAliasesDeep() {
        sut.addTypealias(aliasName: "A",
                         originalType: .block(returnType: "B", parameters: []))
        
        sut.addTypealias(aliasName: "B",
                         originalType: .typeName("C"))
        
        XCTAssert(sut.typesMatch(.typeName("A"),
                                 .block(returnType: .typeName("C"), parameters: []),
                                 ignoreNullability: false))
    }
    
    // MARK: - defaultValue
    
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
    }
    
    func testDefaultValueForOptionalOfArrayOfIntegers() {
        XCTAssertEqual(sut.defaultValue(for: .optional(.array(.int))), .constant(.nil))
    }
    
    func testResolveTypeAliasesInOptionalArrayOfInts() {
        XCTAssertEqual(sut.resolveAlias(in: .optional(.array(.int))),
                       .optional(.array(.int)))
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
    }
    
    func testIsIntegerTypealiased() {
        sut.addTypealias(aliasName: "Alias", originalType: .int)
        sut.addTypealias(aliasName: "NonIntegerAlias", originalType: .float)
        
        XCTAssert(sut.isInteger("Alias"))
        XCTAssertFalse(sut.isInteger("NonIntegerAlias"))
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
    
    func testIsTypeSubtypeOf_SwiftType() {
        let typeA = KnownTypeBuilder(typeName: "A").build()
        let typeB = KnownTypeBuilder(typeName: "B", supertype: typeA).build()
        let typeC = KnownTypeBuilder(typeName: "C", supertype: typeB).build()
        
        sut.addType(typeA)
        sut.addType(typeB)
        sut.addType(typeC)
        
        XCTAssertTrue(sut.isType("A" as SwiftType, subtypeOf: "A"))
        XCTAssertTrue(sut.isType("B" as SwiftType, subtypeOf: "A"))
        XCTAssertTrue(sut.isType("C" as SwiftType, subtypeOf: "A"))
        XCTAssertFalse(sut.isType("A" as SwiftType, subtypeOf: "B"))
        XCTAssertFalse(sut.isType("A" as SwiftType, subtypeOf: "C"))
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
            sut.method(withObjcSelector: SelectorSignature(isStatic: false,
                                                           keywords: ["responds", "to"]),
                       invocationTypeHints: nil,
                       static: false,
                       includeOptional: true,
                       in: type)
        )
        XCTAssertNotNil(
            sut.method(withObjcSelector:
                SelectorSignature(isStatic: false,
                                  keywords: ["isEqual", nil]),
                       invocationTypeHints: nil,
                       static: false,
                       includeOptional: true,
                       in: type)
        )
    }
    
    func testNSDictionaryDefinition() {
        guard let type = sut.knownTypeWithName("NSDictionary") else {
            XCTFail("Expected NSDictionary to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSDictionary's default parameterless constructor")
    }
    
    func testNSMutableDictionaryDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableDictionary") else {
            XCTFail("Expected NSMutableDictionary to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSDictionary")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableDictionary's default parameterless constructor")
    }
    
    func testNSSetDefinition() {
        guard let type = sut.knownTypeWithName("NSSet") else {
            XCTFail("Expected NSSet to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSSet's default parameterless constructor")
    }
    
    func testNSMutableSetDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableSet") else {
            XCTFail("Expected NSMutableSet to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSSet")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSMutableSet's default parameterless constructor")
    }
    
    func testNSDateDefinition() {
        guard let type = sut.knownTypeWithName("NSDate") else {
            XCTFail("Expected NSDate to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSDate's default parameterless constructor")
    }
    
    func testNSDataDefinition() {
        guard let type = sut.knownTypeWithName("NSData") else {
            XCTFail("Expected NSData to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSObject")
        XCTAssertNotNil(sut.constructor(withArgumentLabels: [], in: type),
                        "Missing NSData's default parameterless constructor")
    }
    
    func testNSMutableDataDefinition() {
        guard let type = sut.knownTypeWithName("NSMutableData") else {
            XCTFail("Expected NSMutableData to be present")
            return
        }
        
        XCTAssertEqual(type.supertype?.asTypeName, "NSData")
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
        
        XCTAssertNotNil(sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["nonOptional"]),
                                   invocationTypeHints: nil,
                                   static: false,
                                   includeOptional: false,
                                   in: cls))
        
        XCTAssertNil(sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["optional"]),
                                invocationTypeHints: nil,
                                static: false,
                                includeOptional: false,
                                in: cls))
        
        XCTAssertNotNil(sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["optional"]),
                                   invocationTypeHints: nil,
                                   static: false,
                                   includeOptional: true,
                                   in: cls))
        
        XCTAssertNotNil(sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["optionalImplemented"]),
                                   invocationTypeHints: nil,
                                   static: false,
                                   includeOptional: false,
                                   in: cls))
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
        sut.addTypealias(aliasName: "A", originalType: .block(returnType: .void, parameters: []))
        
        XCTAssertEqual(sut.resolveAlias(in: "A"), .block(returnType: .void, parameters: []))
    }
    
    func testResolveAliasRecursive() {
        sut.addTypealias(aliasName: "B", originalType: .int)
        sut.addTypealias(aliasName: "A", originalType: .block(returnType: .void, parameters: [.typeName("B")]))
        
        XCTAssertEqual(sut.resolveAlias(in: "A"), .block(returnType: .void, parameters: [.int]))
    }
    
    func testResolveAliasSwiftType() {
        sut.addTypealias(aliasName: "B", originalType: .int)
        sut.addTypealias(aliasName: "A", originalType: .block(returnType: .void, parameters: [.typeName("B")]))
        
        XCTAssertEqual(sut.resolveAlias(in: .block(returnType: .void, parameters: [.typeName("A")])),
                       .block(returnType: .void, parameters: [.block(returnType: .void, parameters: [.int])]))
    }
    
    func testIsTypeConformingToProtocol() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q").protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Q", conformingTo: "P"))
        XCTAssertFalse(sut.isType("Z", conformingTo: "P"))
    }
    
    func testIsTypeConformingToProtocolSupertypeLookup() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q").protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z", supertype: "Q").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Z", conformingTo: "P"))
    }
    
    func testIsTypeConformingToProtocolIndirectProtocolLookup() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q", kind: .protocol).protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z").protocolConformance(protocolName: "Q").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Z", conformingTo: "P"))
    }
    
    func testIsTypeConformingToProtocol_SwiftType() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q").protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Q" as SwiftType, conformingTo: "P"))
        XCTAssertFalse(sut.isType("Z" as SwiftType, conformingTo: "P"))
    }
    
    func testIsTypeConformingToProtocolSupertypeLookup_SwiftType() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q").protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z", supertype: "Q").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Z" as SwiftType, conformingTo: "P"))
    }
    
    func testIsTypeConformingToProtocolIndirectProtocolLookup_SwiftType() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q", kind: .protocol).protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z").protocolConformance(protocolName: "Q").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Z" as SwiftType, conformingTo: "P"))
    }
    
    func testIsTypeAssignableToChecksSubclassTyping() {
        let a = KnownTypeBuilder(typeName: "A").build()
        let b = KnownTypeBuilder(typeName: "B", supertype: "A").build()
        let c = KnownTypeBuilder(typeName: "C", supertype: "B").build()
        let d = KnownTypeBuilder(typeName: "D", supertype: "A").build()
        sut.addType(a)
        sut.addType(b)
        sut.addType(c)
        sut.addType(d)
        
        XCTAssert(sut.isType("B", assignableTo: "A"))
        XCTAssert(sut.isType("C", assignableTo: "A"))
        XCTAssert(sut.isType("C", assignableTo: "B"))
        XCTAssert(sut.isType("D", assignableTo: "A"))
        XCTAssertFalse(sut.isType("A", assignableTo: "B"))
        XCTAssertFalse(sut.isType("D", assignableTo: "B"))
        XCTAssertFalse(sut.isType("D", assignableTo: "C"))
    }
    
    func testIsTypeAssignableToChecksProtocolConformance() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q", kind: .protocol).build()
        let a = KnownTypeBuilder(typeName: "A").protocolConformance(protocolName: "P").build()
        sut.addType(p)
        sut.addType(a)
        sut.addType(q)
        
        XCTAssert(sut.isType("A", assignableTo: "P"))
        XCTAssertFalse(sut.isType("A", assignableTo: "Q"))
    }
    
    func testIsTypeAssignableToChecksProtocolConformanceChain() {
        let p = KnownTypeBuilder(typeName: "P", kind: .protocol).build()
        let q = KnownTypeBuilder(typeName: "Q", kind: .protocol).protocolConformance(protocolName: "P").build()
        let z = KnownTypeBuilder(typeName: "Z").protocolConformance(protocolName: "Q").build()
        sut.addType(p)
        sut.addType(q)
        sut.addType(z)
        
        XCTAssert(sut.isType("Z", assignableTo: "Z"))
        XCTAssert(sut.isType("Z", assignableTo: "P"))
        XCTAssert(sut.isType("Z", assignableTo: "Q"))
        XCTAssert(sut.isType("Q", assignableTo: "P"))
        XCTAssertFalse(sut.isType("P", assignableTo: "Q"))
        XCTAssertFalse(sut.isType("Q", assignableTo: "Z"))
    }
    
    func testTypeCategoryPrimitives() {
        XCTAssertEqual(sut.category(forType: "Bool"), .boolean)
        XCTAssertEqual(sut.category(forType: "ObjCBool"), .boolean)
        XCTAssertEqual(sut.category(forType: "CBool"), .boolean)
        
        XCTAssertEqual(sut.category(forType: "Float"), .float)
        XCTAssertEqual(sut.category(forType: "CFloat"), .float)
        XCTAssertEqual(sut.category(forType: "Double"), .float)
        XCTAssertEqual(sut.category(forType: "CDouble"), .float)
        XCTAssertEqual(sut.category(forType: "CGFloat"), .float)
        XCTAssertEqual(sut.category(forType: "Float80"), .float)
        
        XCTAssertEqual(sut.category(forType: "Int64"), .integer)
        XCTAssertEqual(sut.category(forType: "UInt64"), .integer)
        XCTAssertEqual(sut.category(forType: "CLongLong"), .integer)
        XCTAssertEqual(sut.category(forType: "CUnsignedLongLong"), .integer)
        XCTAssertEqual(sut.category(forType: "Int"), .integer)
        XCTAssertEqual(sut.category(forType: "UInt"), .integer)
        XCTAssertEqual(sut.category(forType: "Int32"), .integer)
        XCTAssertEqual(sut.category(forType: "UInt32"), .integer)
        XCTAssertEqual(sut.category(forType: "CInt"), .integer)
        XCTAssertEqual(sut.category(forType: "CUnsignedInt"), .integer)
        XCTAssertEqual(sut.category(forType: "CChar32"), .integer)
        XCTAssertEqual(sut.category(forType: "Int16"), .integer)
        XCTAssertEqual(sut.category(forType: "UInt16"), .integer)
        XCTAssertEqual(sut.category(forType: "CShort"), .integer)
        XCTAssertEqual(sut.category(forType: "CUnsignedShort"), .integer)
        XCTAssertEqual(sut.category(forType: "CChar16"), .integer)
        XCTAssertEqual(sut.category(forType: "Int8"), .integer)
        XCTAssertEqual(sut.category(forType: "UInt8"), .integer)
        XCTAssertEqual(sut.category(forType: "CChar"), .integer)
        XCTAssertEqual(sut.category(forType: "CUnsignedChar"), .integer)
    }
    
    func testTypeCategoryNonPrimitives() {
        let structType = KnownTypeBuilder(typeName: "A", kind: .struct).build()
        let classType = KnownTypeBuilder(typeName: "B", kind: .class).build()
        let protocolType = KnownTypeBuilder(typeName: "C", kind: .protocol).build()
        let enumType = KnownTypeBuilder(typeName: "D", kind: .enum).build()
        sut.addType(structType)
        sut.addType(classType)
        sut.addType(protocolType)
        sut.addType(enumType)
        
        XCTAssertEqual(sut.category(forType: structType.typeName), .struct)
        XCTAssertEqual(sut.category(forType: classType.typeName), .class)
        XCTAssertEqual(sut.category(forType: protocolType.typeName), .protocol)
        XCTAssertEqual(sut.category(forType: enumType.typeName), .enum)
    }
    
    func testIsClassInstanceType() {
        let classType = KnownTypeBuilder(typeName: "A", kind: .class).build()
        let protocolType = KnownTypeBuilder(typeName: "B", kind: .protocol).build()
        let structType = KnownTypeBuilder(typeName: "C", kind: .struct).build()
        let enumType = KnownTypeBuilder(typeName: "D", kind: .enum).build()
        sut.addType(classType)
        sut.addType(protocolType)
        sut.addType(structType)
        sut.addType(enumType)
        
        XCTAssert(sut.isClassInstanceType(.typeName("NSObject")))
        XCTAssert(sut.isClassInstanceType(.typeName("NSSet")))
        XCTAssert(sut.isClassInstanceType(classType.typeName))
        XCTAssert(sut.isClassInstanceType(protocolType.typeName))
        XCTAssertFalse(sut.isClassInstanceType(structType.typeName))
        XCTAssertFalse(sut.isClassInstanceType(enumType.typeName))
    }
    
    func testCategoryForTypeWithTypealias() {
        sut.addTypealias(aliasName: "GLenum", originalType: "UInt32")
        
        XCTAssertEqual(sut.category(forType: "GLenum"), .integer)
    }
    
    func testTypeExists() {
        let type = KnownTypeBuilder(typeName: "A").build()
        sut.addType(type)
        
        XCTAssert(sut.typeExists("A"))
        XCTAssertFalse(sut.typeExists("Unknown"))
    }
    
    func testTypeExistsQueriesTypeProviders() {
        let type = KnownTypeBuilder(typeName: "A").build()
        let provider = CollectionKnownTypeProvider(knownTypes: [type])
        sut.addKnownTypeProvider(provider)
        
        XCTAssert(sut.typeExists("A"))
        XCTAssertFalse(sut.typeExists("Unknown"))
    }
    
    func testExtensionTypesDontOvershadowOriginalImplementation() {
        let ext =
            KnownTypeBuilder(typeName: "UIView")
                .settingIsExtension(true)
                .method(named: "fromExtension")
                .build()
        let viewType =
            KnownTypeBuilder(typeName: "UIView")
                .property(named: "window", type: .optional("UIWindow"))
                .build()
        let source = CollectionKnownTypeProvider(knownTypes: [viewType])
        sut.addType(ext)
        sut.addKnownTypeProvider(source)
        
        let type = sut.knownTypeWithName("UIView")!
        
        XCTAssert(type.knownMethods.contains(where: { $0.signature.name == "fromExtension" }))
        XCTAssertNotNil(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["fromExtension"]),
                       invocationTypeHints: nil,
                       static: false,
                       includeOptional: false,
                       in: .typeName("UIView")
            )
        )
        
        XCTAssert(type.knownProperties.contains(where: { $0.name == "window" }))
        XCTAssertNotNil(sut.property(named: "window", static: false,
                                     includeOptional: false, in: .typeName("UIView")))
    }
    
    func testDeepLookupProtocolConformanceInTypeDefinitions() {
        // These protocols are defined within TypeDefinitions
        let type =
            KnownTypeBuilder(typeName: "Test", kind: .class)
                .protocolConformance(protocolName: "UIViewControllerTransitionCoordinator")
                .build()
        sut.addType(type)
        
        XCTAssert(sut.isType("Test", conformingTo: "UIViewControllerTransitionCoordinatorContext"))
    }
    
    func testTypeLookupInClassesList() {
        // This type is defined within TypeDefinitions.classesList
        XCTAssert(sut.isType("UILabel", subtypeOf: "UIView"))
    }
    
    func testMethodArgumentTypeBasedOverloadResolution() {
        let type =
            KnownTypeBuilder(typeName: "Test")
                .settingUseSwiftSignatureMatching(true)
                .method(named: "method", parsingSignature: "(value: Int)")
                .method(named: "method", parsingSignature: "(value: String)")
                .build()
        sut.addType(type)
        
        // No type hinting: Return first method found
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: nil,
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.int
        )
        
        // With type hinting
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: [.int],
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.int
        )
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: [.string],
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.string
        )
    }
    
    func testMethodArgumentTypeBasedOverloadResolutionWithOptionalArgumentType() {
        let type =
            KnownTypeBuilder(typeName: "Test")
                .settingUseSwiftSignatureMatching(true)
                .method(named: "method", parsingSignature: "(value: Int)")
                .method(named: "method", parsingSignature: "(value: String)")
                .build()
        sut.addType(type)
        
        // No type hinting: Return first method found
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: nil,
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.int
        )
        
        // With type hinting
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: [.optional(.int)],
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.int
        )
        XCTAssertEqual(
            sut.method(withObjcSelector: SelectorSignature(isStatic: false, keywords: ["method", "value"]),
                       invocationTypeHints: [.optional(.string)],
                       static: false,
                       includeOptional: false,
                       in: type)?.signature.parameters[0].type,
            
            SwiftType.string
        )
    }
    
    func testCanonicalTypeName() {
        let provider = CollectionKnownTypeProvider()
        provider.addCanonicalMapping(nonCanonical: "NSLocale", canonical: "Locale")
        sut.addKnownTypeProvider(provider)
        
        XCTAssertEqual(sut.canonicalName(forTypeName: "NSLocale"), "Locale")
        XCTAssertNil(sut.canonicalName(forTypeName: "Locale"))
        XCTAssertNil(sut.canonicalName(forTypeName: "SomeOtherUnexistingTypeName"))
    }
    
    func testCanonicalTypeNameIsResolvedAfterTypealiasExpansion() {
        let knownTypeProvider = CollectionKnownTypeProvider()
        let typealiasProvider = CollectionTypealiasProvider()
        knownTypeProvider.addCanonicalMapping(nonCanonical: "NonCanon", canonical: "Canon")
        typealiasProvider.addTypealias("NonCanonAlias", "NonCanon")
        sut.addKnownTypeProvider(knownTypeProvider)
        sut.addTypealiasProvider(typealiasProvider)
        
        XCTAssertEqual(sut.canonicalName(forTypeName: "NonCanonAlias"), "Canon")
    }
}
