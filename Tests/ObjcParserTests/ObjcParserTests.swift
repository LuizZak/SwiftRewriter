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
            void global(NSString *format, ...);
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
        let implementation: ObjcClassImplementation? = node.firstChild()
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
        XCTAssertEqual(prot?.protocolList?.protocols.first?.name, "B")
    }
    
    func testParseSynthesizeDeclaration() {
        let node = parserTest("""
            @implementation A
            @synthesize a, b = c;
            @end
            """)
        
        let implementation: ObjcClassImplementation? = node.firstChild()
        let synth = implementation?.propertyImplementations.first?.list?.synthesizations
        XCTAssertNotNil(implementation?.propertyImplementations)
        XCTAssertNotNil(synth?.first)
        XCTAssertEqual(synth?.first?.propertyName?.name, "a")
        XCTAssertNil(synth?.first?.instanceVarName)
        XCTAssertEqual(synth?.last?.propertyName?.name, "b")
        XCTAssertEqual(synth?.last?.instanceVarName?.name, "c")
    }
    
    func testParseStructDeclaration() {
        let node = parserTest("""
            typedef struct {
                int field;
            } A;
            """)
        
        let defNode: TypedefNode? = node.firstChild()
        let structNode: ObjcStructDeclaration? = defNode?.firstChild()
        let fields = structNode?.childrenMatching(type: ObjcStructField.self)
        
        XCTAssertNotNil(structNode)
        XCTAssertNotNil(fields?[0])
        XCTAssertEqual(fields?[0].identifier?.name, "field")
        XCTAssertEqual(fields?[0].type?.type, ObjcType.struct("int"))
    }
    
    func testParseIBOutletProperty() {
        let node = parserTest("""
            @interface Foo
            @property (weak, nonatomic) IBOutlet UILabel *label;
            @end
            """)
        
        let implementation: ObjcClassInterface? = node.firstChild()
        XCTAssertEqual(implementation?.properties[0].hasIbOutletSpecifier, true)
    }
    
    func testParseIBInspectableProperty() {
        let node = parserTest("""
            @interface Foo
            @property (weak, nonatomic) IBInspectable UILabel *label;
            @end
            """)
        
        let implementation: ObjcClassInterface? = node.firstChild()
        XCTAssertEqual(implementation?.properties[0].hasIbInspectableSpecifier, true)
    }
    
    func testParseNestedBlocks() {
        _=parserTest("""
            @interface ViewController (Private)
            
            @property (strong, nonatomic) ViewControllerDataSource *dataSource;
            
            @end
            
            @interface ViewControllerSpec : QuickSpec
            @end
            @implementation ViewControllerSpec
            - (void)spec {
            
            describe(@"ViewControllerSpec", ^{
            
                __block ViewController *baseViewController;
                beforeEach(^{
                    baseViewController =
                    [ViewController controllerInstanceFromStoryboard];
                    [baseViewController view];
                });
            
                describe(@"Verifica comportamentos iniciais", ^{
            
                    it(@"title deve ser saldo detalhado", ^{
                        expect(baseViewController.title).equal(@"saldo detalhado");
                    });
                
                    it(@"propriedades não devem ser nulas", ^{
                        expect(baseViewController.dataSource).toNot.beNil();
                        expect(baseViewController.collectionView.dataSource).toNot.beNil();
                        expect(baseViewController.collectionView.delegate).toNot.beNil();
                    });
            
                });
            
                describe(@"Verifica carregamento do xib", ^{
                    expect([ViewController controllerInstanceFromStoryboard]).beAKindOf([ViewController class]);
                });
            
                describe(@"Verifica ação de alterar limite", ^{
                    #warning TODO
                });
            
            });
            }
            @end
            """)
    }
    
    func testParseAnnotations() {
        _=parserTest("""
            @interface A
            + (void)func __attribute__((no_return));
            @end
            @implementation A
            + (void)func __attribute__((annotate("oclint:suppress[high cyclomatic complexity]"), annotate("oclint:suppress[long line]"), annotate("oclint:suppress[collapsible if statements]"))) {
            }
            @end
            """)
    }
    
    func testParseSemicolonAfterMethodDefinition() {
        _=parserTest("""
            @implementation A
            - (void)noSemicolon {
            }
            - (void)withSemicolon {
            };
            @end
            """)
    }
    
    func testParseGlobalFunctionPointer() {
        _=parserTest("""
            void (*myFunc)(char *a, int);
            """)
    }
    
    func testParseArrayWithStructInit() {
        _=parserTest("""
            static const struct game_params mines_presets[] = {
              {9, 9, 10, TRUE},
              {9, 9, 35, TRUE},
              {16, 16, 40, TRUE},
              {16, 16, 99, TRUE},
            #ifndef SMALL_SCREEN
              {30, 16, 99, TRUE},
              {30, 16, 170, TRUE},
            #endif
            };
            """)
    }
    
    func testParseIfWithExpressionList() {
        _=parserTest("""
            void main() {
                if (a[10] -= 20, true) {
                    
                }
            }
            """)
    }
    
    func testParseFunctionPointerTypes() {
        _=parserTest("""
            typedef int (*cmpfn234)(void *, void *);
            typedef int (*cmpfn234_2)(void (*)(), void *);
            typedef int (*cmpfn234_2)(void (*)(void), void *);
            typedef int (*cmpfn234_2)(void (*v)(void), void *);
            typedef int (*cmpfn234_3)(void (^)(), void *);
            """)
    }
    
    func testParseAttributesInStructDeclaration() {
        _=parserTest("""
            struct __attribute__((__packed__)) AStruct {
                UInt8  aField;
                UInt16 anotherField;
                UInt32 thirdField;
            };
            """)
    }
    
    func testParseGenericArgumentsInAtClassDeclaration() {
        _=parserTest("""
            @class NSArray<__covariant ObjectType>;
            @class NSDictionary<KeyType, __contravariant ValueType>;
            """)
    }
    
    func testParseVariableDeclarationOfPointerToFunction() {
        _=parserTest("""
            void test() {
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
            }
            """)
    }
    
    func testParseCompoundStatementInExpression() {
        _=parserTest("""
            void test() {
                self.value=({
                    1 + 1;
                });
            }
            """)
    }
    
    func testParseKeywordsInSelectors() {
        _=parserTest(
            """
            @interface A
            - (void)switch:(NSInteger)a default:(NSInteger)b;
            - (void)if:(NSInteger)a else:(NSInteger)b;
            @end
            """)
    }
    
    func testParseAttributesInDirectDeclarators() {
        _=parserTest(
            """
            void test() {
                __strong NSObject *object __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objectPtr;
            }
            """)
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
