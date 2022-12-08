import XCTest
import SwiftAST
import Intentions
import SwiftRewriterLib
import TypeSystem
import ObjcParser
import GrammarModels

class IntentionCollectorTests: XCTestCase {
    private var file: FileGenerationIntention!
    private var delegate: TestCollectorDelegate!
    private var sut: IntentionCollector!
    
    override func setUp() {
        super.setUp()
        
        file = FileGenerationIntention(sourcePath: "A.m", targetPath: "A.swift")
        
        let context = IntentionBuildingContext()
        context.pushContext(file)
        
        delegate = TestCollectorDelegate(file: file)
        sut = IntentionCollector(delegate: delegate, context: context)
    }
    
    func testCollectFunctionDefinition() {
        // Arrange
        let root = GlobalContextNode(isInNonnullContext: false)
        
        let function = FunctionDefinition(isInNonnullContext: false)
        root.addChild(function)
        
        function.addChild(Identifier(name: "global", isInNonnullContext: false))
        function.addChild(TypeNameNode(type: .void, isInNonnullContext: false))
        
        let parameters = ParameterList(isInNonnullContext: false)
        function.addChild(parameters)
        
        let param1 = FunctionParameter(isInNonnullContext: false)
        param1.addChild(Identifier(name: "a", isInNonnullContext: false))
        param1.addChild(TypeNameNode(type: .typeName("NSInteger"), isInNonnullContext: false))
        parameters.addChild(param1)
        
        // Act
        sut.collectIntentions(root)
        
        // Assert
        XCTAssertEqual(file.globalFunctionIntentions.count, 1)
        XCTAssertEqual(file.globalFunctionIntentions.first?.signature,
                       FunctionSignature(name: "global",
                                         parameters: [
                                            ParameterSignature(label: nil, name: "a", type: .int)
                                         ],
                                         isStatic: false))
    }
    
    func testCollectFunctionDefinitionBody() throws {
        let parser = ObjcParser(string: "void global() { stmt(); }")
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalFunctionIntentions.count, 1)
        XCTAssertEqual(delegate.reportedForLazyParsing.count, 1)
        XCTAssert(delegate.reportedForLazyParsing.first === file.globalFunctionIntentions.first?.functionBody)
    }
    
    func testCollectGlobalConst() throws {
        let parser = ObjcParser(string: """
            const int global;
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalVariableIntentions.count, 1)
        XCTAssertEqual(file.globalVariableIntentions.first?.name, "global")
        XCTAssertEqual(file.globalVariableIntentions.first?.isConstant, true)
    }
    
    func testCollectPointerGlobalConst() throws {
        let parser = ObjcParser(string: """
            int *const global;
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalVariableIntentions.count, 1)
        XCTAssertEqual(file.globalVariableIntentions.first?.name, "global")
        XCTAssertEqual(file.globalVariableIntentions.first?.isConstant, true)
    }

    func testCollectTypedefBlock() throws {
        let parser = ObjcParser(string: """
            typedef void(^callback)();
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(delegate.reportedForLazyResolving.count, 1)
        XCTAssertEqual(file.globalVariableIntentions.count, 0)
        XCTAssertEqual(file.globalFunctionIntentions.count, 0)
        XCTAssertEqual(file.typealiasIntentions.count, 1)
        XCTAssertEqual(file.typealiasIntentions.first?.name, "callback")
        XCTAssertEqual(file.typealiasIntentions.first?.fromType, .void)
        XCTAssertEqual(
            file.typealiasIntentions.first?.originalObjcType,
            .blockType(name: "callback", returnType: .void)
        )
    }

    func testCollectTypedefFunctionPointer() throws {
        let parser = ObjcParser(string: """
            typedef void(*callback)();
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(delegate.reportedForLazyResolving.count, 1)
        XCTAssertEqual(file.globalVariableIntentions.count, 0)
        XCTAssertEqual(file.globalFunctionIntentions.count, 0)
        XCTAssertEqual(file.typealiasIntentions.count, 1)
        XCTAssertEqual(file.typealiasIntentions.first?.name, "callback")
        XCTAssertEqual(file.typealiasIntentions.first?.fromType, .void)
        XCTAssertEqual(
            file.typealiasIntentions.first?.originalObjcType,
            .functionPointer(name: "callback", returnType: .void)
        )
    }

    func testCollectSuperclass() throws {
        let parser = ObjcParser(string: """
            @interface MyClass : UIView
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].typeName, "MyClass")
        XCTAssertEqual(file.classIntentions[0].superclassName, "UIView")
    }

    func testCollectGenericSuperclass() throws {
        let parser = ObjcParser(string: """
            @interface MyClass : NSArray<NSString*>
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].typeName, "MyClass")
        XCTAssertEqual(file.classIntentions[0].superclassName, "NSArray")
    }

    func testCollectProtocolSpecification() throws {
        let parser = ObjcParser(string: """
            @interface MyClass <UITableViewDelegate>
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].typeName, "MyClass")
        XCTAssertNil(file.classIntentions[0].superclassName)
        XCTAssertEqual(file.classIntentions[0].protocols.count, 1)
        XCTAssertEqual(file.classIntentions[0].protocols.first?.protocolName, "UITableViewDelegate")
    }

    func testCollectProtocolSpecification_withSuperclass() throws {
        let parser = ObjcParser(string: """
            @interface MyClass : UIView <UITableViewDelegate>
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].typeName, "MyClass")
        XCTAssertEqual(file.classIntentions[0].superclassName, "UIView")
        XCTAssertEqual(file.classIntentions[0].protocols.count, 1)
        XCTAssertEqual(file.classIntentions[0].protocols.first?.protocolName, "UITableViewDelegate")
    }
    
    func testCollectProperty() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property BOOL property;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].properties.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.name, "property")
        XCTAssertEqual(file.classIntentions[0].properties.first?.isClassProperty, false)
        XCTAssertEqual(file.classIntentions[0].properties.first?.type, .anyObject) // Initially .anyObject, is processed afterwards by a delegate
    }
    
    func testCollectProperty_classProperty() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (class) BOOL property;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].properties.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.isClassProperty, true)
    }
    
    func testCollectProperty_weak() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (weak) NSString *property;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].properties.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.storage.ownership, .weak)
    }
    
    func testCollectProperty_getter() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (getter=propertyGetter) NSString *property;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].properties.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.objcAttributes.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.objcAttributes[0], .getterName("propertyGetter"))
    }
    
    func testCollectProperty_setter() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (setter=propertySetter:) NSString *property;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.classIntentions[0].properties.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.objcAttributes.count, 1)
        XCTAssertEqual(file.classIntentions[0].properties.first?.objcAttributes[0], .setterName("propertySetter:"))
    }
    
    func testCollectPropertyIBOutletAttribute() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (weak, nonatomic) IBOutlet UILabel *label;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssert(file.classIntentions[0].properties[0].knownAttributes.contains { $0.name == "IBOutlet" })
    }
    
    func testCollectPropertyIBInspectableAttribute() throws {
        let parser = ObjcParser(string: """
            @interface Foo
            @property (weak, nonatomic) IBInspectable UILabel *label;
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssert(file.classIntentions[0].properties[0].knownAttributes.contains { $0.name == "IBInspectable" })
    }

    func testCollectStaticDeclarationsInClassInterface() throws {
        let parser = ObjcParser(string: """
            @interface MyClass
            static NSString *const _Nonnull kMethodKey = @"method";
            static NSString *_Nonnull kCodeOperatorKey = @"codigo_operador";
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalVariableIntentions.count, 2)
        XCTAssertEqual(file.classIntentions.first?.properties.count, 0)
    }
    
    func testCollectStructDeclaration() throws {
        let parser = ObjcParser(string: """
            typedef struct {
                int a;
            } A;
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.structIntentions.count, 1)
        XCTAssertEqual(file.structIntentions.first?.typeName, "A")
    }
    
    func testCollectOpaqueStruct() throws {
        let parser = ObjcParser(string: """
            typedef struct _A *A;
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssert(file.structIntentions.isEmpty)
        XCTAssertEqual(file.typealiasIntentions.count, 1)
        XCTAssertEqual(file.typealiasIntentions.first?.name, "A")
        XCTAssertEqual(file.typealiasIntentions.first?.fromType, .void)
        XCTAssertEqual(file.typealiasIntentions.first?.originalObjcType, .pointer(.incompleteStruct("_A")))
    }
    
    func testQueryNonnullRegionsFromDelegate() throws {
        let parser = ObjcParser(string: """
            void *v1;
            void *v2;
            void *v3;
            """
        )
        try parser.parse()
        let rootNode = parser.rootNode
        delegate.isNodeInNonnullContext_stub = { node in
            node.location.line == 2 ? true : false
        }
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalVariableIntentions.count, 3)
        XCTAssertFalse(file.globalVariableIntentions[0].inNonnullContext)
        XCTAssertTrue(file.globalVariableIntentions[1].inNonnullContext)
        XCTAssertFalse(file.globalVariableIntentions[2].inNonnullContext)
    }
    
    func testCollectClassInterfaceComments() throws {
        testCommentCollection("""
            // A comment
            // Another comment
            @interface A
            @end
            """, \FileGenerationIntention.classIntentions[0])
    }
    
    func testCollectClassImplementationComments() throws {
        testCommentCollection("""
            // A comment
            // Another comment
            @implementation A
            @end
            """, \FileGenerationIntention.classIntentions[0])
    }
    
    func testCollectMethodComments() throws {
        testCommentCollection("""
            @interface A
            // A comment
            // Another comment
            - (void)test;
            @end
            """, \FileGenerationIntention.classIntentions[0].methods[0])
    }
    
    func testCollectDeinitComments() throws {
        testCommentCollection("""
            @implementation A
            // A comment
            // Another comment
            - (void)dealloc {
            }
            @end
            """, \FileGenerationIntention.classIntentions[0].deinitIntention!)
    }
    
    func testCollectPropertyComments() throws {
        testCommentCollection("""
            @interface A
            // A comment
            // Another comment
            @property NSInteger i;
            @end
            """, \FileGenerationIntention.classIntentions[0].properties[0])
    }
    
    func testCollectIVarComments() throws {
        testCommentCollection("""
            @interface A
            {
                // A comment
                // Another comment
                NSInteger i;
            }
            @end
            """, \FileGenerationIntention.classIntentions[0].instanceVariables[0])
    }
    
    func testCollectEnumComments() throws {
        testCommentCollection("""
            // A comment
            // Another comment
            typedef NS_ENUM(NSInteger, MyEnum) {
                MyEnumCase1 = 0,
                MyEnumCase2
            };
            """, \FileGenerationIntention.enumIntentions[0])
    }
    
    func testCollectEnumCaseComments() throws {
        testCommentCollection("""
            typedef NS_ENUM(NSInteger, MyEnum) {
                // A comment
                // Another comment
                MyEnumCase1 = 0,
                MyEnumCase2
            };
            """, \FileGenerationIntention.enumIntentions[0].cases[0])
    }
    
    func testCollectStructComments() throws {
        testCommentCollection("""
            // A comment
            // Another comment
            typedef struct {
                int a;
            } A;
            """, \FileGenerationIntention.structIntentions[0])
    }
    
    func testCollectDealloc() throws {
        let parser = ObjcParser(string: """
            @implementation A
            - (void)dealloc {
            }
            @end
            """)
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertNotNil(file.classTypeIntentions[0].deinitIntention)
        XCTAssertNotNil(file.classTypeIntentions[0].deinitIntention?.functionBody)
        XCTAssert(delegate.reportedForLazyParsing[0] === file.classTypeIntentions[0].deinitIntention?.functionBody)
    }
    
    private func testCommentCollection<T: FromSourceIntention>(
        _ code: String,
        _ keyPath: KeyPath<FileGenerationIntention, T>,
        line: UInt = #line) {
        
        do {
            let parser = ObjcParser(string: code)
            try parser.parse()
            let rootNode = parser.rootNode
            
            sut.collectIntentions(rootNode)
            
            XCTAssertEqual(file[keyPath: keyPath].precedingComments, [
                "// A comment",
                "// Another comment"
            ], line: line)
        } catch {
            XCTFail("Failed to parse Objective-C source: \(error)", line: line)
        }
    }
}

private class TestCollectorDelegate: IntentionCollectorDelegate {
    var context: IntentionBuildingContext
    var intentions: IntentionCollection
    var isNodeInNonnullContext_stub: ((ASTNode) -> Bool)?
    
    var reportedForLazyParsing: [Intention] = []
    var reportedForLazyResolving: [Intention] = []
    
    init(file: FileGenerationIntention) {
        context = IntentionBuildingContext()
        intentions = IntentionCollection()
        intentions.addIntention(file)
        
        context.pushContext(file)
    }
    
    // MARK: -
    
    func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
        return isNodeInNonnullContext_stub?(node) ?? false
    }
    
    func reportForLazyParsing(intention: Intention) {
        reportedForLazyParsing.append(intention)
    }
    
    func reportForLazyResolving(intention: Intention) {
        reportedForLazyResolving.append(intention)
    }
    
    func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
        return DefaultTypeMapper(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
    }
}
