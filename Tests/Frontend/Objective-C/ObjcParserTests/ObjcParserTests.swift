import ObjcGrammarModels
import XCTest
import TestCommons

@testable import ObjcParser

class ObjcParserTests: XCTestCase {
    func testInit() {
        _ = ObjcParser(string: "abc")
    }

    func testParseComments() {
        let source = """
            // Test comment
            /*
                Test multi-line comment
            */
            """
        _ = parserTest(source)
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
        _ = parserTest(source)
    }

    func testParseDirectives() {
        let source = """
            #error An error!
            #warning A warning!
            """
        _ = parserTest(source)
    }

    func testParseSpecialCharactersInComment() {
        let source = """
            // ©
            NSString *a;
            // ©©
            NSString *const b;
            """
        let sut = ObjcParser(string: source)
        let node = parseTestGlobalContextNode(source: source, parser: sut)

        XCTAssertEqual(sut.comments, [
            .init(
                string: "// ©\n",
                range: 0..<6,
                location: .init(line: 1, column: 1, utf8Offset: 0),
                length: .init(newlines: 1, columnsAtLastLine: 0, utf8Length: 6)
            ),
            .init(
                string: "// ©©\n",
                range: 19..<27,
                location: .init(line: 3, column: 1, utf8Offset: 19),
                length: .init(newlines: 1, columnsAtLastLine: 0, utf8Length: 8)
            )
        ])
        Asserter(object: node)
            .assertChildCount(2)?
            .asserter(forChildAt: 0) { a in
                a.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "a")?
                    .assert(type: .pointer("NSString"))
            }?
            .asserter(forChildAt: 1) { a in
                a.assert(isOfType: ObjcVariableDeclarationNode.self)?
                    .assert(name: "b")?
                    .assert(type: .pointer("NSString", qualifiers: [.const]))
            }
    }

    func testParse_detectsNonnullRegions_declarations() {
        let node = parserTest("""
            int a;
            NS_ASSUME_NONNULL_BEGIN
            int b;
            NS_ASSUME_NONNULL_END
            int c;
            """)
        
        Asserter(object: node).assertChildCount(3)?
            .asserter(forChildAt: 0) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: false)
            }?
            .asserter(forChildAt: 1) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: true)
            }?
            .asserter(forChildAt: 2) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: false)
            }
    }

    func testParse_detectsNonnullRegions_functionDefinitions() {
        let node = parserTest("""
            void a() { }
            NS_ASSUME_NONNULL_BEGIN
            void b() { }
            NS_ASSUME_NONNULL_END
            void c() { }
            """)
        
        Asserter(object: node).assertChildCount(3)?
            .asserter(forChildAt: 0) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: false)
            }?
            .asserter(forChildAt: 1) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: true)
            }?
            .asserter(forChildAt: 2) { node in
                node.assert(isOfType: ObjcASTNode.self)?
                    .assert(isInNonnullContext: false)
            }
    }
    
    func testParseGlobalVariables() {
        let node = parserTest("""
            int aGlobal;
            NSString *_Nonnull anotherGlobal;
            """)
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.assertChildCount(2)?
                .asserter(forChildAt: 0) { kMethodKey in
                    kMethodKey.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(name: "aGlobal")?
                        .assert(type: "signed int")
                }?
                .asserter(forChildAt: 1) { kMethodKey in
                    kMethodKey.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(name: "anotherGlobal")?
                        .assert(type: .pointer("NSString", nullabilitySpecifier: .nonnull))
                }
        }
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
        _ = parserTest(source)
    }

    func testConcreteSubclassOfGenericType() {
        let source = """
            @interface A: B<NSString*>
            @end
            """
        _ = parserTest(source)
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
        _ = parserTest(source)
    }

    func testParseInterfaceProtocolSpecification() {
        let source = """
        @interface MyClass <UITableViewDelegate>
        @end
        """
        let node = parserTest(source)

        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.assertChildCount(1)?
                .asserter(forChildAt: 0) { type in
                    type.assert(isOfType: ObjcClassInterfaceNode.self)?
                        .assert(protocolListString: ["UITableViewDelegate"])
                }
        }
    }
    
    func testParseInterfaceProtocolSpecification_withSuperclass() {
        let source = """
        @interface MyClass : UIView <UITableViewDelegate>
        @end
        """
        let node = parserTest(source)

        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                type.assert(isOfType: ObjcClassInterfaceNode.self)?
                    .assert(superclassName: "UIView")?
                    .assert(protocolListString: ["UITableViewDelegate"])
            }
        }
    }
    
    func testParseInterfaceProtocolSpecification_withGenericSuperclass() {
        let source = """
        @interface MyClass : NSArray<NSString*> <UITableViewDelegate>
        @end
        """
        let node = parserTest(source)

        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                type.assert(isOfType: ObjcClassInterfaceNode.self)?
                    .assert(superclassName: "NSArray")?
                    .assert(protocolListString: ["UITableViewDelegate"])
            }
        }
    }
    
    func testParsePropertyAttributes() throws {
        let source = """
            @interface Foo
            @property (class) BOOL property1;
            @property (getter=property2Getter, setter=property2Setter:) BOOL property2;
            @end
            """
        
        let node = parserTest(source)

        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassInterfaceNode.self)

                type?[\.properties].assertCount(2)
                type?[\.properties][0]?.assert(attributesList: [
                    .keyword("class"),
                ])
                type?[\.properties][1]?.assert(attributesList: [
                    .getter("property2Getter"),
                    .setter("property2Setter:"),
                ])
            }
        }
    }
    
    func testParseFunctionDefinition() {
        let node = parserTest(
            """
            void global(int a);
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType: .void)?
                    .assertParameterCount(1)?
                    .asserter(forParameterAt: 0) { param in
                        param.assert(type: "signed int")
                        param.assert(name: "a")
                    }
            }
        }
    }

    func testParseParameterlessFunctionDefinition() {
        let node = parserTest(
            """
            void global();
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType: .void)?
                    .assertParameterCount(0)
            }
        }
    }
    
    // TODO: Consider implementing return-less function definition for compatibility reasons later
    func x_testParseReturnlessFunctionDefinition() {
        let node = parserTest("""
            global(int a);
            """
        )

        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .asserter(forKeyPath: \.returnType) { returnType in
                        returnType.assertNil()
                    }?
                    .assertParameterCount(1)?
                    .asserter(forParameterAt: 0) { param in
                        param.assert(type: "signed int")
                        param.assert(name: "a")
                    }
            }
        }
    }

    func testParseComplexReturnTypeFunctionDefinition() {
        let node = parserTest(
            """
            NSArray<NSArray<NSString*>*> *_Nonnull global();
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType:
                        .pointer(
                            .genericTypeName(
                                "NSArray",
                                typeParameters: [
                                .genericTypeName("NSArray", typeParameters: [
                                    .typeName("NSString").wrapAsPointer
                                ]).wrapAsPointer
                            ]),
                            nullabilitySpecifier: .nonnull
                        )
                    )
            }
        }
    }
    
    func testParseComplexParameterTypeFunctionDefinition() {
        let node = parserTest(
            """
            void global(NSArray<NSArray<NSString*>*> *_Nonnull value);
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType: .void)?
                    .assertParameterCount(1)?
                    .asserter(forParameterAt: 0) { param in
                        param.assert(name: "value")?.assert(type:
                            .pointer(
                                .genericTypeName(
                                    "NSArray",
                                    typeParameters: [
                                    .genericTypeName("NSArray", typeParameters: [
                                        .typeName("NSString").wrapAsPointer
                                    ]).wrapAsPointer
                                ]),
                                nullabilitySpecifier: .nonnull
                            )
                        )
                    }
            }
        }
    }
    
    func testParseVariadicParameterInFunctionDefinition() {
        let node = parserTest(
            """
            void global(NSString *format, ...);
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType: .void)?
                    .assert(isVariadic: true)?
                    .assertParameterCount(1)?
                    .asserter(forParameterAt: 0) { param in
                        param.assert(name: "format")?
                            .assert(type:
                                .pointer("NSString")
                            )
                    }
            }
        }
    }

    func testParseFunctionDefinitionWithBody() {
        let node = parserTest(
            """
            void global() {
                stmt();
            }
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let function = type.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "global")?
                    .assert(returnType: .void)?
                    .assertHasBody()
            }
        }
    }

    func testParseClassMethodDeclaration() {
        let node = parserTest(
            """
            @interface A
            + (void)method;
            @end
            @implementation A
            + (void)method {
            }
            @end
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassInterfaceNode.self)
                type?[\.methods][0]?.assert(isClassMethod: true)
            }
            asserter.asserter(forChildAt: 1) { type in
                let type = type.assert(isOfType: ObjcClassImplementationNode.self)
                type?[\.methods][0]?.assert(isClassMethod: true)
            }
        }
    }

    func testParseProtocolReferenceListInProtocol() {
        let node = parserTest(
            """
            @protocol A <B>
            @end
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                type.assert(isOfType: ObjcProtocolDeclarationNode.self)?
                    .assert(name: "A")?
                    .assert(protocolListString: ["B"])
            }
        }
    }

    func testParseSynthesizeDeclaration() {
        let node = parserTest(
            """
            @implementation A
            @synthesize a, b = c;
            @end
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassImplementationNode.self)

                type?[\.propertyImplementations].assertCount(1)
                type?[\.propertyImplementations][0]?.assert(propertySynthesizeList: [
                    ("a", nil),
                    ("b", "c"),
                ])
            }
        }
    }

    func testParseStructDeclaration() {
        let node = parserTest("""
            struct A {
                int field;
            };
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let decl = type.assert(isOfType: ObjcStructDeclarationNode.self)

                decl?.assert(name: "A")?
                    .asserter(forFieldIndex: 0) { field in
                        field.assert(name: "field")?
                            .assert(type: "signed int")
                    }
            }
        }
    }
    
    func testParseStructDeclaration_typedef() {
        let node = parserTest("""
            typedef struct {
                int field;
            } A;
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let decl = type.assert(isOfType: ObjcStructDeclarationNode.self)

                decl?.assert(name: "A")?
                    .asserter(forFieldIndex: 0) { field in
                        field.assert(name: "field")?
                            .assert(type: "signed int")
                    }
            }
        }
    }

    func testParseIBOutletProperty() {
        let node = parserTest(
            """
            @interface Foo
            @property (weak, nonatomic) IBOutlet UILabel *label;
            @end
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassInterfaceNode.self)

                type?[\.properties][0]?
                    .assert(hasIbOutletSpecifier: true)
            }
        }
    }

    func testParseIBInspectableProperty() {
        let node = parserTest(
            """
            @interface Foo
            @property (weak, nonatomic) IBInspectable UILabel *label;
            @end
            """
        )
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassInterfaceNode.self)

                type?[\.properties][0]?
                    .assert(hasIbInspectableSpecifier: true)
            }
        }
    }

    func testParseNestedBlocks() {
        _ = parserTest(
            """
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
            """
        )
    }

    func testParseAnnotations() {
        _ = parserTest(
            """
            @interface A
            + (void)func __attribute__((no_return));
            @end
            @implementation A
            + (void)func __attribute__((annotate("oclint:suppress[high cyclomatic complexity]"), annotate("oclint:suppress[long line]"), annotate("oclint:suppress[collapsible if statements]"))) {
            }
            @end
            """
        )
    }

    func testParseSemicolonAfterMethodDefinition() {
        _ = parserTest(
            """
            @implementation A
            - (void)noSemicolon {
            }
            - (void)withSemicolon {
            };
            @end
            """
        )
    }
    
    func testParseStaticVariablesInClassInterface() {
        let node = parserTest("""
            @interface MyClass
            static NSString *const _Nonnull kMethodKey = @"method";
            static NSString *_Nonnull kCodeOperatorKey = @"codigo_operador";
            @end
            """)
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.assertChildCount(3)?
                .asserter(forChildAt: 0) { kMethodKey in
                    kMethodKey.assert(isOfType: ObjcClassInterfaceNode.self)
                }?
                .asserter(forChildAt: 1) { kMethodKey in
                    kMethodKey.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(name: "kMethodKey")
                }?
                .asserter(forChildAt: 2) { kMethodKey in
                    kMethodKey.assert(isOfType: ObjcVariableDeclarationNode.self)?
                        .assert(name: "kCodeOperatorKey")
                }
        }
    }
    
    func testParseGlobalFunctionPointer() {
        _ = parserTest(
            """
            void (*myFunc)(char *a, int);
            """
        )
    }

    func testParseArrayWithStructInit() {
        _ = parserTest(
            """
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
            """
        )
    }

    func testParseIfWithExpressionList() {
        _ = parserTest(
            """
            void main() {
                if (a[10] -= 20, true) {
                    
                }
            }
            """
        )
    }

    func testParseFunctionPointerTypes() {
        _ = parserTest(
            """
            typedef int (*cmpfn234)(void *, void *);
            typedef int (*cmpfn234_2)(void (*)(), void *);
            typedef int (*cmpfn234_2)(void (*)(void), void *);
            typedef int (*cmpfn234_2)(void (*v)(void), void *);
            typedef int (*cmpfn234_3)(void (^)(), void *);
            """
        )
    }
    
    func testParseTypedefBlock() {
        let node = parserTest("""
            typedef void(^callback)();
            """)
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcTypedefNode.self)

                type?.assert(name: "callback")?
                    .assert(type: .blockType(name: "callback", returnType: .void))
            }
        }
    }
    
    func testParseTypedefFunctionPointer() {
        let node = parserTest("""
            typedef void(*callback)();
            """)
        
        Asserter(object: node).inClosureUnconditional { asserter in
            asserter.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcTypedefNode.self)

                type?.assert(name: "callback")?
                    .assert(type: .functionPointer(name: "callback", returnType: .void))
            }
        }
    }
    
    func testParseAttributesInStructDeclaration() {
        _ = parserTest(
            """
            struct __attribute__((__packed__)) AStruct {
                UInt8  aField;
                UInt16 anotherField;
                UInt32 thirdField;
            };
            """
        )
    }

    func testParseGenericArgumentsInAtClassDeclaration() {
        _ = parserTest(
            """
            @class NSArray<__covariant ObjectType>;
            @class NSDictionary<KeyType, __contravariant ValueType>;
            """
        )
    }
    
    func testParseTypeofSpecifier() {
        _=parserTest("""
            __typeof__(0) a;
            __typeof__(0 + 1) *b;
            """)
    }
    
    func testParseVariableDeclarationOfPointerToFunction() {
        _ = parserTest(
            """
            void test() {
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
            }
            """
        )
    }

    func testParseCompoundStatementInExpression() {
        _ = parserTest(
            """
            void test() {
                self.value=({
                    1 + 1;
                });
            }
            """
        )
    }

    func testParseKeywordsInSelectors() {
        _ = parserTest(
            """
            @interface A
            - (void)switch:(NSInteger)a default:(NSInteger)b;
            - (void)if:(NSInteger)a else:(NSInteger)b;
            @end
            """
        )
    }

    func testParseAttributesInDirectDeclarators() {
        _ = parserTest(
            """
            void test() {
                __strong NSObject *object __attribute__((objc_precise_lifetime)) = (__bridge __strong id)objectPtr;
            }
            """
        )
    }

    func testParseHasIncludeDirective() {
        _ = parserTest(
            """
            #if (defined(USE_UIKIT_PUBLIC_HEADERS) && USE_UIKIT_PUBLIC_HEADERS) || !__has_include(<UIKitCore/UIDynamicBehavior.h>)
            #endif
            """
        )
    }

    func testParseImportDirectives() throws {
        let sut = ObjcParser(
            string: """
                #define aDefine
                #import <dir/file.h>
                #import "file.h"
                """
        )

        try sut.parse()

        Asserter(object: sut.importDirectives).inClosureUnconditional { imports in
            imports.assertCount(2)
            imports[0]?
                .assert(path: "dir/file.h")?
                .assert(isSystemImport: true)
            imports[1]?
                .assert(path: "file.h")?
                .assert(isSystemImport: false)
        }
    }

    func testParseCFunctionArrayArguments() throws {
        let node = parserTest("""
            void aFunction(unsigned n, int args[]) {

            }
            """)
        
        Asserter(object: node).inClosureUnconditional { decls in
            decls.assertChildCount(1)?.asserter(forChildAt: 0) { function in
                let function = function.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?
                    .assert(name: "aFunction")?
                    .assertParameterCount(2)?
                    .asserter(forParameterAt: 0) { param in
                        param.assert(name: "n")?
                            .assert(type: "unsigned int")
                    }?
                    .asserter(forParameterAt: 1) { param in
                        param.assert(name: "args")?
                            .assert(type: .pointer("signed int"))
                    }
            }
        }
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

        /*
        XCTAssertEqual(sut.comments.count, 2)
        // Single line
        XCTAssertEqual(sut.comments[0].string, "// A comment\n")
        XCTAssertEqual(sut.comments[0].range.lowerBound, 0)
        XCTAssertEqual(sut.comments[0].range.upperBound, 13)
        XCTAssertEqual(sut.comments[0].location.line, 1)
        XCTAssertEqual(sut.comments[0].location.column, 1)
        XCTAssertEqual(sut.comments[0].length.newlines, 1)
        XCTAssertEqual(sut.comments[0].length.columnsAtLastLine, 0)
        // Multi-line
        XCTAssertEqual(sut.comments[1].string, "/*\n    Another comment\n*/")
        XCTAssertEqual(sut.comments[1].range.lowerBound, (string as NSString).range(of: "/*").lowerBound)
        XCTAssertEqual(sut.comments[1].range.upperBound, (string as NSString).range(of: "*/").upperBound)
        XCTAssertEqual(sut.comments[1].location.line, 3)
        XCTAssertEqual(sut.comments[1].location.column, 1)
        XCTAssertEqual(sut.comments[1].length.newlines, 2)
        XCTAssertEqual(sut.comments[1].length.columnsAtLastLine, 2)
        */
        
        Asserter(object: sut.comments).inClosureUnconditional { comments in
            comments.assertCount(2)

            // Single line
            comments[0]?
                .assert(string: "// A comment\n")?
                .asserter(forKeyPath: \.range.lowerBound) { lowerBound in
                    lowerBound.assert(equals: 0)
                }?
                .asserter(forKeyPath: \.range.upperBound) { lowerBound in
                    lowerBound.assert(equals: 13)
                }?
                .assert(range: (string as NSString).range(of: "// A comment\n"))?
                .assert(location: .init(line: 1, column: 1))?
                .assert(length: .init(newlines: 1, columnsAtLastLine: 0))
            
            // Multi-line
            
            comments[1]?
                .assert(string: "/*\n    Another comment\n*/")?
                .assert(range: (string as NSString).range(of: "/*\n    Another comment\n*/"))?
                .assert(location: .init(line: 3, column: 1))?
                .assert(length: .init(newlines: 2, columnsAtLastLine: 2))
        }
    }

    func testCommentRangeInlinedMultiLineComment() throws {
        let string = """
            void /* A comment */ func() {
            }
            """
        let sut = ObjcParser(string: string)

        try sut.parse()
        
        Asserter(object: sut.comments).inClosureUnconditional { comments in
            comments.assertCount(1)

            // Multi-line
            comments[0]?
                .assert(string: "/* A comment */")?
                .assert(range: (string as NSString).range(of: "/* A comment */"))?
                .assert(location: .init(line: 1, column: 6))?
                .assert(length: .init(newlines: 0, columnsAtLastLine: 15))
        }
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
        let node = parserTest(string)
        
        Asserter(object: node).inClosureUnconditional { node in
            node.assertChildCount(1)?.asserter(forChildAt: 0) { function in
                let function = function.assert(isOfType: ObjcFunctionDefinitionNode.self)

                function?.asserter(forKeyPath: \.methodBody?.comments) { comments in
                    let comments = comments.assertNotNil()

                    comments?.assertCount(2)

                    // Single line
                    comments?[0]?
                        .assert(string: "// A Comment\n")?
                        .assert(range: (string as NSString).range(of: "// A Comment\n"))?
                        .assert(location: .init(line: 2, column: 5))?
                        .assert(length: .init(newlines: 1, columnsAtLastLine: 0))
                    
                    // Multi-line
                    comments?[1]?
                        .assert(string: "/* Another comment */")?
                        .assert(range: (string as NSString).range(of: "/* Another comment */"))?
                        .assert(location: .init(line: 5, column: 5))?
                        .assert(length: .init(newlines: 0, columnsAtLastLine: 21))
                }
            }
        }
    }

    func testCollectCommentsPrecedingFunction() {
        testParseComments(
            """
            void func() {
            }
            """,
            \.functionDefinitions[0]
        )
    }

    func testCollectCommentsPrecedingClassInterface() {
        testParseComments(
            """
            @interface A
            @end
            """,
            \.classInterfaces[0]
        )
    }

    func testCollectCommentsPrecedingClassImplementations() {
        testParseComments(
            """
            @implementation A
            @end
            """,
            \.classImplementations[0]
        )
    }

    func testCollectCommentsPrecedingCategoryInterface() {
        testParseComments(
            """
            @interface A ()
            @end
            """,
            \.categoryInterfaces[0]
        )
    }

    func testCollectCommentsPrecedingCategoryImplementation() {
        testParseComments(
            """
            @implementation A ()
            @end
            """,
            \.categoryImplementations[0]
        )
    }

    func testCollectCommentsPrecedingProtocolDeclaration() {
        testParseComments(
            """
            @protocol A
            @end
            """,
            \.protocolDeclarations[0]
        )
    }

    func testCollectCommentsPrecedingGlobalVariable() {
        testParseComments(
            """
            int global;
            """,
            \.variableDeclarations[0]
        )
    }

    func testCollectCommentsPrecedingTypedefNode() {
        testParseComments(
            """
            typedef struct {
                int a;
            } A;
            """, \.structDeclarations[0])
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
            """,
            \ObjcGlobalContextNode.classInterfaces[0].methods[0]
        )
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
            """,
            \ObjcGlobalContextNode.classInterfaces[0].properties[0]
        )
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
            """,
            \ObjcGlobalContextNode.classImplementations[0].methods[0]
        )
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
            """,
            \ObjcGlobalContextNode.enumDeclarations[0]
        )
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
            """,
            \ObjcGlobalContextNode.enumDeclarations[0].cases[0]
        )
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
            """,
            \ObjcGlobalContextNode.classInterfaces[0].ivarsList!.ivarDeclarations[0]
        )
    }

    func testCommentCollectionIgnoresMethodImplementationComments() throws {
        let sut = ObjcParser(
            string: """
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
                """
        )

        try sut.parse()

        Asserter(object: sut.rootNode).inClosureUnconditional { node in
            node.asserter(forChildAt: 0) { type in
                let type = type.assert(isOfType: ObjcClassImplementationNode.self)

                type?[\.methods][0]?
                    .asserter(
                        forKeyPath: \.body?.comments
                    ) {
                        $0.assertNotNil()?.assertCount(3)
                    }
                type?[\.methods][1]?
                    .asserter(
                        forKeyPath: \.body?.precedingComments
                    ) {
                        $0.assertNotNil()?.assertCount(0)
                    }
            }
        }
    }
}

extension ObjcParserTests {

    private func testParseComments<T: ObjcASTNode>(
        _ source: String,
        _ keyPath: KeyPath<ObjcGlobalContextNode, T>,
        line: UInt = #line
    ) {

        let string = """
            // Preceding comment
            // Another preceding comment
            \(source)
            // Trailing comment
            """

        testParseCommentsRaw(string, keyPath, line: line)
    }

    private func testParseCommentsRaw<T: ObjcASTNode>(
        _ source: String,
        _ keyPath: KeyPath<ObjcGlobalContextNode, T>,
        line: UInt = #line
    ) {

        do {
            let sut = ObjcParser(string: source)

            try sut.parse()

            if !sut.diagnostics.errors.isEmpty {
                XCTFail(
                    "Failed to parse sample: \(sut.diagnostics.diagnosticsSummary())"
                )
                return
            }

            let global = sut.rootNode
            let decl = global[keyPath: keyPath]
            var comments = decl.precedingComments.makeIterator()
            XCTAssertEqual(comments.next()?.string, "// Preceding comment\n", line: line)
            XCTAssertEqual(comments.next()?.string, "// Another preceding comment\n", line: line)
            XCTAssertNil(comments.next())
        }
        catch {
            XCTFail("Error while parsing test code: \(error)", line: line)
        }
    }

    private func parserTest(_ source: String, file: StaticString = #filePath, line: UInt = #line)
        -> ObjcGlobalContextNode
    {
        let sut = ObjcParser(string: source)

        return parseTestGlobalContextNode(source: source, parser: sut, file: file, line: line)
    }

    private func parseTestGlobalContextNode(
        source: String,
        parser: ObjcParser,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> ObjcGlobalContextNode {
        do {
            try parser.parse()

            if !parser.diagnostics.diagnostics.isEmpty {
                var diag = ""
                parser.diagnostics.printDiagnostics(to: &diag)

                XCTFail("Unexpected diagnostics while parsing:\n\(diag)", file: file, line: line)
            }

            return parser.rootNode
        }
        catch {
            XCTFail("Failed to parse test '\(source)': \(error)", file: file, line: line)
            fatalError()
        }
    }
}
