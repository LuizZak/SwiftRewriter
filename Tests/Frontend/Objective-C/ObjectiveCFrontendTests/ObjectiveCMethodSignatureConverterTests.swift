import XCTest
import SwiftAST
import SwiftRewriterLib
import TypeSystem
import ObjcParser
import ObjcGrammarModels

@testable import ObjectiveCFrontend

class ObjectiveCMethodSignatureConverterTests: XCTestCase {
    func testInitializer() throws {
        let sign = genSignature("""
            - (instancetype)initWithValue:(NSInteger)value;
            """)
        
        XCTAssertEqual(sign.name, "initWithValue")
        XCTAssertEqual(sign.returnType, .nullabilityUnspecified(.instancetype))
        XCTAssertEqual(sign.parameters.count, 1)
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].name, "value")
        XCTAssertEqual(sign.parameters[0].type, .int)
    }
    
    func testSimpleVoidDefinition() throws {
        let sign = genSignature("""
            - (void)abc;
            """)
        
        XCTAssertEqual(sign.name, "abc")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 0)
    }
    
    func testReturnType() throws {
        let sign = genSignature("""
            - (NSString*)abc;
            """)
        
        XCTAssertEqual(sign.name, "abc")
        XCTAssertEqual(sign.returnType, .nullabilityUnspecified(.string))
        XCTAssertEqual(sign.parameters.count, 0)
    }
    
    func testSimpleSingleArgument() throws {
        let sign = genSignature("""
            - (void)setInteger:(NSInteger)inty;
            """)
        
        XCTAssertEqual(sign.name, "setInteger")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 1)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .int)
        XCTAssertEqual(sign.parameters[0].name, "inty")
    }
    
    func testSimpleMultiArguments() throws {
        let sign = genSignature("""
            - (void)intAndString:(NSInteger)a b:(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "intAndString")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .int)
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "b")
        XCTAssertEqual(sign.parameters[1].type, .nullabilityUnspecified(.string))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testLabellessArgument() {
        let sign = genSignature("""
            - (void)intAndString:(NSInteger)a :(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "intAndString")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .int)
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, nil)
        XCTAssertEqual(sign.parameters[1].type, .nullabilityUnspecified(.string))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testSelectorLessArguments() {
        let sign = genSignature("""
            - (void):(NSInteger)a :(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .int)
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, nil)
        XCTAssertEqual(sign.parameters[1].type, .nullabilityUnspecified(.string))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testAbcdSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - (void):a:b:c:d;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 4)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, nil)
        XCTAssertEqual(sign.parameters[1].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[1].name, "b")
        
        XCTAssertEqual(sign.parameters[2].label, nil)
        XCTAssertEqual(sign.parameters[2].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[2].name, "c")
        
        XCTAssertEqual(sign.parameters[3].label, nil)
        XCTAssertEqual(sign.parameters[3].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[3].name, "d")
    }
    
    func testAbcdReturnlessSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - :a:b:c:d;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters.count, 4)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, nil)
        XCTAssertEqual(sign.parameters[1].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[1].name, "b")
        
        XCTAssertEqual(sign.parameters[2].label, nil)
        XCTAssertEqual(sign.parameters[2].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[2].name, "c")
        
        XCTAssertEqual(sign.parameters[3].label, nil)
        XCTAssertEqual(sign.parameters[3].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[3].name, "d")
    }
    
    func testCompactReturnlessSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - :a;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters.count, 1)
        
        XCTAssertEqual(sign.parameters[0].label, nil)
        XCTAssertEqual(sign.parameters[0].type, .nullabilityUnspecified(.anyObject))
        XCTAssertEqual(sign.parameters[0].name, "a")
    }
    
    private func genSignature(_ objc: String) -> FunctionSignature {
        let node = parseMethodSign(objc)
        let gen = createSwiftMethodSignatureGen()
        
        return gen.generateDefinitionSignature(from: node)
    }
    
    private func createSwiftMethodSignatureGen() -> ObjectiveCMethodSignatureConverter {
        let mapper = DefaultTypeMapper(typeSystem: TypeSystem())
        
        return ObjectiveCMethodSignatureConverter(typeMapper: mapper,
                                       inNonnullContext: false,
                                       instanceTypeAlias: nil)
    }
    
    private func parseMethodSign(_ source: String, file: StaticString = #filePath, line: UInt = #line) -> MethodDefinition {
        let finalSrc = """
            @interface myClass
            \(source)
            @end
            """
        
        let parser = ObjcParser(string: finalSrc)
        
        do {
            try parser.parse()
            
            let node =
                parser.rootNode
                    .firstChild(ofType: ObjcClassInterface.self)?
                    .firstChild(ofType: MethodDefinition.self)
            return node!
        } catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
