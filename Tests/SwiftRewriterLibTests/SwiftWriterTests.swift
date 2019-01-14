import XCTest
import ObjcParser
import SwiftAST
@testable import SwiftRewriterLib

class SwiftWriterTests: XCTestCase {
    
    var intentions: IntentionCollection!
    var output: TestSingleFileWriterOutput!
    var typeMapper: TypeMapper!
    var diagnostics: Diagnostics!
    var options: ASTWriterOptions!
    var sut: InternalSwiftWriter!
    var typeSystem: TypeSystem!
    
    override func setUp() {
        super.setUp()
        
        intentions = IntentionCollection()
        output = TestSingleFileWriterOutput()
        typeSystem = TypeSystem()
        typeMapper = DefaultTypeMapper(typeSystem: typeSystem)
        options = .default
        sut =
            InternalSwiftWriter(
                intentions: intentions,
                options: options,
                diagnostics: Diagnostics(),
                output: output,
                typeMapper: typeMapper,
                typeSystem: typeSystem)
    }

    func testWriteFailableInit() {
        let type = KnownTypeBuilder(typeName: "A").build()
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isFailable = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        
        sut.outputInitMethod(initMethod, selfType: type, target: output.outputTarget())
        
        let expected = """
            init?() {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteConvenienceInit() {
        let type = KnownTypeBuilder(typeName: "A").build()
        let initMethod = InitGenerationIntention(parameters: [])
        initMethod.isConvenience = true
        initMethod.functionBody = FunctionBodyIntention(body: [])
        
        sut.outputInitMethod(initMethod, selfType: type, target: output.outputTarget())
        
        let expected = """
            convenience init() {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteClassAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .class)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        
        sut.outputClass(intent, target: output.outputTarget())
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            class A {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteStructAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .struct)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! StructGenerationIntention
        
        sut.outputStruct(intent, target: output.outputTarget())
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            struct A {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteEnumAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .enum)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! EnumGenerationIntention
        
        sut.outputEnum(intent, target: output.outputTarget())
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            enum A: Int {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteProtocolAttributes() {
        let type = KnownTypeBuilder(typeName: "A", kind: .protocol)
            .settingAttributes([
                KnownAttribute(name: "attr"),
                KnownAttribute(name: "otherAttr", parameters: ""),
                KnownAttribute(name: "otherAttr", parameters: "type: Bool")
            ])
            .buildIntention()
        let intent = type as! ProtocolGenerationIntention
        
        sut.outputProtocol(intent, target: output.outputTarget())
        
        let expected = """
            @attr
            @otherAttr()
            @otherAttr(type: Bool)
            protocol A {
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWritePropertyAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .property(
                named: "property",
                type: .int,
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool")
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        
        sut.outputClass(intent, target: output.outputTarget())
        
        let expected = """
            class A {
                @attr @otherAttr() @otherAttr(type: Bool) var property: Int = 0
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
    
    func testWriteMethodAttributes() {
        let type = KnownTypeBuilder(typeName: "A")
            .method(
                named: "method",
                parsingSignature: "()",
                attributes: [
                    KnownAttribute(name: "attr"),
                    KnownAttribute(name: "otherAttr", parameters: ""),
                    KnownAttribute(name: "otherAttr", parameters: "type: Bool")
                ]
            )
            .buildIntention()
        let intent = type as! ClassGenerationIntention
        
        sut.outputClass(intent, target: output.outputTarget())
        
        let expected = """
            class A {
                @attr
                @otherAttr()
                @otherAttr(type: Bool)
                func method() {
                }
            }
            """
        
        XCTAssertEqual(output.buffer.trimmingCharacters(in: .whitespacesAndNewlines), expected)
    }
}
