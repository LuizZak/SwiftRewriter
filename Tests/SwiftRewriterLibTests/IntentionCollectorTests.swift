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
        param1.addChild(TypeNameNode(type: .struct("NSInteger"), isInNonnullContext: false))
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
        XCTAssertEqual(file.typealiasIntentions.first?.originalObjcType, .struct("OpaquePointer"))
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
    
    var reportedForLazyParsing: [Intention] = []
    
    init(file: FileGenerationIntention) {
        context = IntentionBuildingContext()
        intentions = IntentionCollection()
        intentions.addIntention(file)
        
        context.pushContext(file)
    }
    
    // MARK: -
    
    func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
        return false
    }
    
    func reportForLazyParsing(intention: Intention) {
        reportedForLazyParsing.append(intention)
    }
    
    func reportForLazyResolving(intention: Intention) {
        
    }
    
    func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
        return DefaultTypeMapper(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
    }
    
    func typeParser(for intentionCollector: IntentionCollector) -> TypeParsing {
        return TypeParsing(state: ObjcParserState())
    }
}
