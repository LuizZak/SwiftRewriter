import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels

class SwiftMethodSignatureGenTests: XCTestCase {
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
        XCTAssertEqual(sign.returnType, .pointer(.struct("NSString")))
        XCTAssertEqual(sign.parameters.count, 0)
    }
    
    func testSimpleSingleArgument() throws {
        let sign = genSignature("""
            - (void)setInteger:(NSInteger)inty;
            """)
        
        XCTAssertEqual(sign.name, "setInteger")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 1)
        
        XCTAssertEqual(sign.parameters[0].label, "inty")
        XCTAssertEqual(sign.parameters[0].type, .struct("NSInteger"))
        XCTAssertEqual(sign.parameters[0].name, "inty")
    }
    
    func testSimpleMultiArguments() throws {
        let sign = genSignature("""
            - (void)intAndString:(NSInteger)a b:(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "intAndString")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .struct("NSInteger"))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "b")
        XCTAssertEqual(sign.parameters[1].type, .pointer(.struct("NSString")))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testLabellessArgument() {
        let sign = genSignature("""
            - (void)intAndString:(NSInteger)a :(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "intAndString")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .struct("NSInteger"))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "_")
        XCTAssertEqual(sign.parameters[1].type, .pointer(.struct("NSString")))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testSelectorLessArguments() {
        let sign = genSignature("""
            - (void):(NSInteger)a :(NSString*)b;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 2)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .struct("NSInteger"))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "_")
        XCTAssertEqual(sign.parameters[1].type, .pointer(.struct("NSString")))
        XCTAssertEqual(sign.parameters[1].name, "b")
    }
    
    func testAbcdSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - (void):a:b:c:d;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 4)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "_")
        XCTAssertEqual(sign.parameters[1].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[1].name, "b")
        
        XCTAssertEqual(sign.parameters[2].label, "_")
        XCTAssertEqual(sign.parameters[2].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[2].name, "c")
        
        XCTAssertEqual(sign.parameters[3].label, "_")
        XCTAssertEqual(sign.parameters[3].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[3].name, "d")
    }
    
    func testAbcdReturnlessSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - :a:b:c:d;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .id(protocols: []))
        XCTAssertEqual(sign.parameters.count, 4)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[0].name, "a")
        
        XCTAssertEqual(sign.parameters[1].label, "_")
        XCTAssertEqual(sign.parameters[1].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[1].name, "b")
        
        XCTAssertEqual(sign.parameters[2].label, "_")
        XCTAssertEqual(sign.parameters[2].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[2].name, "c")
        
        XCTAssertEqual(sign.parameters[3].label, "_")
        XCTAssertEqual(sign.parameters[3].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[3].name, "d")
    }
    
    func testCompactReturnlessSelectorlessTypelessSignature() {
        let sign = genSignature("""
            - :a;
            """)
        
        XCTAssertEqual(sign.name, "__")
        XCTAssertEqual(sign.returnType, .id(protocols: []))
        XCTAssertEqual(sign.parameters.count, 1)
        
        XCTAssertEqual(sign.parameters[0].label, "a")
        XCTAssertEqual(sign.parameters[0].type, .id(protocols: []))
        XCTAssertEqual(sign.parameters[0].name, "a")
    }
    
    func testSelectorWithCollapsing() {
        let sign = genSignature("""
            - (void)doSomethingWithColor:(CGColor)color;
            """)
        
        XCTAssertEqual(sign.name, "doSomething")
        XCTAssertEqual(sign.returnType, .void)
        XCTAssertEqual(sign.parameters.count, 1)
        
        XCTAssertEqual(sign.parameters[0].label, "with")
        XCTAssertEqual(sign.parameters[0].type, .struct("CGColor"))
        XCTAssertEqual(sign.parameters[0].name, "color")
    }
    
    private func genSignature(_ objc: String) -> MethodGenerationIntention.Signature {
        let node = parseMethodSign(objc)
        let gen = createSwiftMethodSignatureGen()
        
        return gen.generateDefinitionSignature(from: node)
    }
    
    private func createSwiftMethodSignatureGen() -> SwiftMethodSignatureGen {
        let ctx = TypeContext()
        let mapper = TypeMapper(context: ctx)
        
        return SwiftMethodSignatureGen(context: ctx, typeMapper: mapper)
    }
    
    private func parseMethodSign(_ source: String, file: String = #file, line: Int = #line) -> MethodDefinition {
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
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
