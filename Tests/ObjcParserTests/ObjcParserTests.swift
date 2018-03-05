import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParserTests: XCTestCase {
    static var allTests = [
        ("testInit", testInit),
    ]
    
    func testInit() {
        _=ObjcParser(string: "abc")
    }
    
    func testParseComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            """
        _=parserTest(source)
    }
    
    func testParseDeclarationAfterComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            @interface MyClass
            @end
            """
        _=parserTest(source)
    }
    
    func testParseDirectives() {
        let source = """
        #error An error!
        #warning A warning!
        """
        _=parserTest(source)
    }
    
    func testParseReturnTypeAnnotationInBlock() {
        let source = """
        @implementation A
        - (void)method {
            [self block:^__kindof NSArray*{
                return 0;
            }];
            [self block:^__kindof NSArray<NSString*>* {
            }];
        }
        @end
        """
        _=parserTest(source)
    }
    
    func testParserMaintainsOriginalRuleContext() {
        let source = """
            #import "abc.h"
            NS_ASSUME_NONNULL_BEGIN

            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumValue1 = 0,
                MyEnumValue1
            };

            void aFunc(int a, int b, ...);

            void anotherFunc(int a, int b, ...) {
                stmt();
            }
            
            @protocol P
            @property BOOL p;
            - (void)m;
            @end
            
            @interface MyClass : Superclass <Prot1, Prot2>
            {
                NSInteger myInt;
            }
            @property (nonatomic, getter=isValue) BOOL value;
            - (void)myMethod:(NSString*)param1;
            @end
            
            @interface MyClass (MyCategory)
            + (void)classMethod:(NSArray<NSObject*>*)anyArray;
            @end

            @implementation MyClass
            - (void)myMethod:(NSString*)param1 {
                for(int i = 0; i < 10; i++) {
                    NSLog(@"%@", i);
                }
            }
            + (void)classMethod:(NSArray<NSObject*>*)anyArray {
            }
            @end
            """
        
        let node = parserTest(source)
        
        let visitor = AnyASTVisitor(visit: { node in
            if node is InvalidNode {
                return
            }
            
            XCTAssertNotNil(node.sourceRuleContext, "\(node)")
        })
        
        let traverser = ASTTraverser(node: node, visitor: visitor)
        traverser.traverse()
    }
    
    func testConcreteSubclassOfGenericType() {
        let source = """
        @interface A: B<NSString*>
        @end
        """
        _=parserTest(source)
    }
    
    func testParseNestedGenericTypes() {
        let source = """
        @interface B: NSObject
        @end
        @interface A: NSObject
        {
            RACSubject<NSArray<B*>*> *_u; // Should not produce errors here!
        }
        @end
        """
        _=parserTest(source)
    }
    
    func testParseFunctionDefinition() {
        let node = parserTest("""
            void global(int a);
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type, .void)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 1)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.first?.type?.type, .struct("int"))
        XCTAssertEqual(funcDecl?.parameterList?.parameters.first?.identifier?.name, "a")
    }
    
    func testParseParameterlessFunctionDefinition() {
        let node = parserTest("""
            void global();
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type, .void)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 0)
    }
    
    func testParseReturnlessFunctionDefinition() {
        let node = parserTest("""
            global(int a);
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 1)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.first?.type?.type, .struct("int"))
        XCTAssertEqual(funcDecl?.parameterList?.parameters.first?.identifier?.name, "a")
    }
    
    func testParseComplexReturnTypeFunctionDefinition() {
        let node = parserTest("""
            NSArray<NSArray<NSString*>*> *_Nonnull global();
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type,
                       .qualified(
                        .pointer(
                            .generic("NSArray",
                                     parameters: [
                                        .pointer(.generic("NSArray", parameters: [
                                            .pointer(.struct("NSString"))
                                            ]))
                                ])),
                        qualifiers: ["_Nonnull"])
        )
    }
    
    func testParseComplexParameterTypeFunctionDefinition() {
        let node = parserTest("""
            void global(NSArray<NSArray<NSString*>*> *_Nonnull value);
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type, .void)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 1)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.first?.type?.type,
                       .qualified(
                        .pointer(
                            .generic("NSArray",
                                     parameters: [
                                        .pointer(.generic("NSArray", parameters: [
                                            .pointer(.struct("NSString"))
                                            ]))
                                ])),
                        qualifiers: ["_Nonnull"])
        )
    }
    
    func testParseVariadicParameterInFunctionDefinition() {
        let node = parserTest("""
            void global(NSSring *format, ...);
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        XCTAssertNotNil(funcDecl?.parameterList?.variadicParameter)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type, .void)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 1)
    }
    
    func testParseFunctionDefinitionWithBody() {
        let node = parserTest("""
            void global() {
                stmt();
            }
            """)
        
        let funcDecl: FunctionDefinition? = node.firstChild()
        
        XCTAssertNotNil(funcDecl)
        XCTAssertNotNil(funcDecl?.returnType)
        XCTAssertNotNil(funcDecl?.identifier)
        XCTAssertNotNil(funcDecl?.parameterList)
        
        XCTAssertEqual(funcDecl?.identifier?.name, "global")
        XCTAssertEqual(funcDecl?.returnType?.type, .void)
        XCTAssertEqual(funcDecl?.parameterList?.parameters.count, 0)
        XCTAssertNotNil(funcDecl?.methodBody)
        XCTAssertNotNil(funcDecl?.methodBody?.statements)
    }
    
    func testParseClassMethodDeclaration() {
        let node = parserTest("""
            @interface A
            + (void)method;
            @end
            @implementation A
            + (void)method {
            }
            @end
            """)
        
        let interface: ObjcClassInterface? = node.firstChild()
        let implementation: ObjcClassInterface? = node.firstChild()
        XCTAssert(interface!.methods[0].isClassMethod)
        XCTAssert(implementation!.methods[0].isClassMethod)
    }
    
    func testParseProtocolReferenceListInProtocol() {
        let node = parserTest("""
            @protocol A <B>
            @end
            """)
        
        let prot: ProtocolDeclaration? = node.firstChild()
        XCTAssertNotNil(prot?.protocolList)
        XCTAssertNotNil(prot?.protocolList?.protocols.first?.name, "B")
    }
}

extension ObjcParserTests {
    
    private func parserTest(_ source: String, file: String = #file, line: Int = #line) -> GlobalContextNode {
        let sut = ObjcParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: ObjcParser, file: String = #file, line: Int = #line) -> GlobalContextNode {
        do {
            try parser.parse()
            
            if !parser.diagnostics.diagnostics.isEmpty {
                var diag = ""
                parser.diagnostics.printDiagnostics(to: &diag)
                
                recordFailure(withDescription: "Unexpected diagnostics while parsing:\n\(diag)", inFile: file, atLine: line, expected: true)
            }
            
            return parser.rootNode
        } catch {
            recordFailure(withDescription: "Failed to parse test '\(source)': \(error)", inFile: #file, atLine: line, expected: false)
            fatalError()
        }
    }
}
