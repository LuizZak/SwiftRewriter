import XCTest
import SwiftRewriterLib
import GrammarModels
import SwiftAST

class IntentionCollectorTests: XCTestCase {
    private var file: FileGenerationIntention!
    private var delegate: TestCollectorDelegate!
    private var sut: IntentionCollector!
    
    override func setUp() {
        super.setUp()
        
        file = FileGenerationIntention(sourcePath: "A.m", targetPath: "A.swift")
        
        let context = TypeConstructionContext(typeSystem: DefaultTypeSystem.defaultTypeSystem)
        context.pushContext(file)
        
        delegate = TestCollectorDelegate(file: file)
        sut = IntentionCollector(delegate: delegate, context: context)
    }
    
    func testCollectFunctionDefinition() {
        // Arrange
        let root = GlobalContextNode()
        
        let function = FunctionDefinition()
        root.addChild(function)
        
        function.addChild(Identifier(name: "global"))
        function.addChild(TypeNameNode(type: .void))
        
        let parameters = ParameterList()
        function.addChild(parameters)
        
        let param1 = FunctionParameter()
        param1.addChild(Identifier(name: "a"))
        param1.addChild(TypeNameNode(type: .struct("NSInteger")))
        parameters.addChild(param1)
        
        // Act
        sut.collectIntentions(root)
        
        // Assert
        XCTAssertEqual(file.globalFunctionIntentions.count, 1)
        XCTAssertEqual(file.globalFunctionIntentions.first?.signature,
                       FunctionSignature(name: "global",
                                         parameters: [
                                            ParameterSignature(label: "_", name: "a", type: .int)
                                         ],
                                         isStatic: false))
    }
}

private class TestCollectorDelegate: IntentionCollectorDelegate {
    var context: TypeConstructionContext
    var intentions: IntentionCollection
    
    init(file: FileGenerationIntention) {
        context = TypeConstructionContext(typeSystem: DefaultTypeSystem.defaultTypeSystem)
        intentions = IntentionCollection()
        intentions.addIntention(file)
        
        context.pushContext(file)
    }
    
    // MARK: -
    
    func isNodeInNonnullContext(_ node: ASTNode) -> Bool {
        return false
    }
    
    func reportForLazyResolving(intention: Intention) {
        
    }
    
    func typeConstructionContext(for intentionCollector: IntentionCollector) -> TypeConstructionContext {
        return context
    }
    
    func typeMapper(for intentionCollector: IntentionCollector) -> TypeMapper {
        return DefaultTypeMapper(context: typeConstructionContext(for: intentionCollector))
    }
}
