import XCTest
import SwiftRewriterLib
import ObjcParser
import GrammarModels
import SwiftAST

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
        // Arrange
        let parser = ObjcParser(string: "void global() { stmt(); }")
        try parser.parse()
        let rootNode = parser.rootNode
        
        sut.collectIntentions(rootNode)
        
        XCTAssertEqual(file.globalFunctionIntentions.count, 1)
        XCTAssertEqual(delegate.reportedForLazyParsing.count, 1)
        XCTAssert(delegate.reportedForLazyParsing.first === file.globalFunctionIntentions.first?.functionBody)
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
