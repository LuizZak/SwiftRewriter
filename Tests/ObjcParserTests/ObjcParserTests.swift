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
        
        let prot: ObjcProtocolDeclaration? = node.firstChild()
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
        let fields = structNode?.body?.fields
        
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
    
    func testParseTypeofSpecifier() {
        _=parserTest("""
            __typeof__(0) a;
            __typeof__(0 + 1) *b;
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
    
    func testParseHasIncludeDirective() {
        _=parserTest(
            """
            #if (defined(USE_UIKIT_PUBLIC_HEADERS) && USE_UIKIT_PUBLIC_HEADERS) || !__has_include(<UIKitCore/UIDynamicBehavior.h>)
            #endif
            """)
    }

    func testParseImportDirectives() throws {
        let sut = ObjcParser(string: """
            #define aDefine
            #import <dir/file.h>
            #import "file.h"
            """)

        try sut.parse()

        XCTAssertEqual(sut.importDirectives.map { $0.path }, ["dir/file.h", "file.h"])
        XCTAssert(sut.importDirectives[0].isSystemImport)
        XCTAssertFalse(sut.importDirectives[1].isSystemImport)
    }

    func testParseCFunctionArrayArguments() throws {
        let sut = ObjcParser(string: """
            void aFunction(unsigned n, int args[]) {

            }
            """)

        try sut.parse()

        let funcDecl = try XCTUnwrap(sut.rootNode.functionDefinitions.first)
        let parameterList = try XCTUnwrap(funcDecl.parameterList)

        XCTAssertEqual(funcDecl.identifier?.name, "aFunction")
        XCTAssertEqual(parameterList.parameters.count, 2)
        XCTAssertEqual(parameterList.parameters[0].type?.type, .struct("unsigned int"))
        XCTAssertEqual(parameterList.parameters[0].identifier?.name, "n")
        XCTAssertEqual(parameterList.parameters[1].type?.type, .pointer("signed int"))
        XCTAssertEqual(parameterList.parameters[1].identifier?.name, "args")
    }
    
    func testCommentRanges() throws {
        let string = """
            // A comment
            #import "file.h"
            /*
                Another comment
            */
            """
        
        let sut = ObjcParser(string: string)
        
        try sut.parse()
        
        XCTAssertEqual(sut.comments.count, 2)
        // Single line
        XCTAssertEqual(sut.comments[0].string, "// A comment\n")
        XCTAssertEqual(sut.comments[0].range.lowerBound, "".startIndex)
        XCTAssertEqual(sut.comments[0].range.upperBound, "// A comment\n".endIndex)
        XCTAssertEqual(sut.comments[0].location.line, 1)
        XCTAssertEqual(sut.comments[0].location.column, 1)
        XCTAssertEqual(sut.comments[0].length.newlines, 1)
        XCTAssertEqual(sut.comments[0].length.columnsAtLastLine, 0)
        // Multi-line
        XCTAssertEqual(sut.comments[1].string, "/*\n    Another comment\n*/")
        XCTAssertEqual(sut.comments[1].range.lowerBound, string.range(of: "/*")?.lowerBound)
        XCTAssertEqual(sut.comments[1].range.upperBound, string.range(of: "*/")?.upperBound)
        XCTAssertEqual(sut.comments[1].location.line, 3)
        XCTAssertEqual(sut.comments[1].location.column, 1)
        XCTAssertEqual(sut.comments[1].length.newlines, 2)
        XCTAssertEqual(sut.comments[1].length.columnsAtLastLine, 2)
    }
    
    func testCommentRangeInlinedMultiLineComment() throws {
        let string = """
            void /* A comment */ func() {
            }
            """
        let sut = ObjcParser(string: string)
        
        try sut.parse()
        
        XCTAssertEqual(sut.comments.count, 1)
        XCTAssertEqual(sut.comments[0].string, "/* A comment */")
        XCTAssertEqual(sut.comments[0].range.lowerBound, string.range(of: "/*")?.lowerBound)
        XCTAssertEqual(sut.comments[0].range.upperBound, string.range(of: "*/")?.upperBound)
        XCTAssertEqual(sut.comments[0].location.line, 1)
        XCTAssertEqual(sut.comments[0].location.column, 6)
        XCTAssertEqual(sut.comments[0].length.newlines, 0)
        XCTAssertEqual(sut.comments[0].length.columnsAtLastLine, 15)
    }
    
    func testCollectCommentsInMethodBody() throws {
        let string = """
            void func() {
                // A Comment
                if (true) {
                }
                /* Another comment */
            }
            """
        let sut = ObjcParser(string: string)
        
        try sut.parse()
        
        let global = sut.rootNode
        let f = global.functionDefinitions[0]
        let body = f.methodBody!
        XCTAssertEqual(body.comments.count, 2)
    }
    
    func testCollectCommentsPrecedingFunction() {
        testParseComments(
            """
            void func() {
            }
            """, \.functionDefinitions[0])
    }
    
    func testCollectCommentsPrecedingClassInterface() {
        testParseComments(
            """
            @interface A
            @end
            """, \.classInterfaces[0])
    }
    
    func testCollectCommentsPrecedingClassImplementations() {
        testParseComments(
            """
            @implementation A
            @end
            """, \.classImplementations[0])
    }
    
    func testCollectCommentsPrecedingCategoryInterface() {
           testParseComments(
               """
               @interface A ()
               @end
               """, \.categoryInterfaces[0])
       }
       
       func testCollectCommentsPrecedingCategoryImplementation() {
           testParseComments(
               """
               @implementation A ()
               @end
               """, \.categoryImplementations[0])
       }
    
    func testCollectCommentsPrecedingProtocolDeclaration() {
        testParseComments(
            """
            @protocol A
            @end
            """, \.protocolDeclarations[0])
    }
    
    func testCollectCommentsPrecedingGlobalVariable() {
        testParseComments(
            """
            int global;
            """, \.variableDeclarations[0])
    }
    
    func testCollectCommentsPrecedingTypedefNode() {
        testParseComments(
            """
            typedef struct {
                int a;
            } A;
            """, \.typedefNodes[0])
    }
    
    func testCollectCommentsPrecedingMethodDefinition() {
        testParseCommentsRaw(
            """
            @interface A
            // Preceding comment
            // Another preceding comment
            - (void)method;
            // Trailing comment
            @end
            """, \GlobalContextNode.classInterfaces[0].methods[0])
    }
    
    func testCollectCommentsPrecedingPropertyDefinition() {
        testParseCommentsRaw(
            """
            @interface A
            // Preceding comment
            // Another preceding comment
            @property NSInteger a;
            // Trailing comment
            @end
            """, \GlobalContextNode.classInterfaces[0].properties[0])
    }
    
    func testCollectCommentsPrecedingMethodDeclaration() {
        testParseCommentsRaw(
            """
            @implementation A
            // Preceding comment
            // Another preceding comment
            - (void)method {
            }
            // Trailing comment
            @end
            """, \GlobalContextNode.classImplementations[0].methods[0])
    }
    
    func testCollectCommentsPrecedingEnumDeclaration() {
        testParseCommentsRaw(
            """
            // Preceding comment
            // Another preceding comment
            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumCase
            };
            // Trailing comment
            """, \GlobalContextNode.enumDeclarations[0])
    }
    
    func testCollectCommentsPrecedingEnumCase() {
        testParseCommentsRaw(
            """
            typedef NS_ENUM(NSInteger, MyEnum) {
                // Preceding comment
                // Another preceding comment
                MyEnumCase
                // Trailing comment
            };
            """, \GlobalContextNode.enumDeclarations[0].cases[0])
    }
    
    func testCollectCommentsPrecedingInstanceVariable() {
        testParseCommentsRaw(
            """
            @interface A
            {
                // Preceding comment
                // Another preceding comment
                NSInteger i;
                // Trailing comment
            }
            @end
            """, \GlobalContextNode.classInterfaces[0].ivarsList!.ivarDeclarations[0])
    }
    
    func testCommentCollectionIgnoresMethodImplementationComments() throws {
        let sut = ObjcParser(string: """
            @implementation A
            - (void)test {
                // Preceding comment
                // Another preceding comment
                NSInteger i;
                // Trailing comment
            }
            - (void)anotherMethod {
            }
            @end
            """)

        try sut.parse()

        let global = sut.rootNode
        let decl1 = global.classImplementations[0].methods[0]
        let decl2 = global.classImplementations[0].methods[1]
        XCTAssertEqual(decl1.body?.comments.count, 3)
        XCTAssert(decl2.precedingComments.isEmpty)
    }
}

extension ObjcParserTests {
    
    private func testParseComments<T: ASTNode>(
        _ source: String,
        _ keyPath: KeyPath<GlobalContextNode, T>,
        line: UInt = #line) {
        
        let string = """
            // Preceding comment
            // Another preceding comment
            \(source)
            // Trailing comment
            """
        
        testParseCommentsRaw(string, keyPath, line: line)
    }
    
    private func testParseCommentsRaw<T: ASTNode>(
        _ source: String,
        _ keyPath: KeyPath<GlobalContextNode, T>,
        line: UInt = #line) {
        
        do {
            let sut = ObjcParser(string: source)

            try sut.parse()

            let global = sut.rootNode
            let decl = global[keyPath: keyPath]
            var comments = decl.precedingComments.makeIterator()
            XCTAssertEqual(comments.next()?.string, "// Preceding comment\n", line: line)
            XCTAssertEqual(comments.next()?.string, "// Another preceding comment\n", line: line)
            XCTAssertNil(comments.next())
        } catch {
            XCTFail("Error while parsing test code: \(error)", line: line)
        }
    }
    
    private func parserTest(_ source: String, file: StaticString = #filePath, line: UInt = #line) -> GlobalContextNode {
        let sut = ObjcParser(string: source)
        
        return _parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }
    
    private func _parseTestGlobalContextNode(source: String, parser: ObjcParser, file: StaticString = #filePath, line: UInt = #line) -> GlobalContextNode {
        do {
            try parser.parse()
            
            if !parser.diagnostics.diagnostics.isEmpty {
                var diag = ""
                parser.diagnostics.printDiagnostics(to: &diag)
                
                XCTFail("Unexpected diagnostics while parsing:\n\(diag)", file: file, line: line)
            }
            
            return parser.rootNode
        } catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
