import XCTest
import ExpressionPasses

class DefaultExpressionPassesTests: XCTestCase {
    func testDefaultExpressionPasses() {
        let source = DefaultExpressionPasses()
        
        XCTAssertEqual(source.syntaxNodePasses.count, 9)
        
        XCTAssert(source.syntaxNodePasses[0] == ASTSimplifier.self)
        XCTAssert(source.syntaxNodePasses[1] == AllocInitExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[2] == CoreGraphicsExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[3] == FoundationExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[4] == UIKitExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[5] == NilValueTransformationsPass.self)
        XCTAssert(source.syntaxNodePasses[6] == NumberCommonsExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[7] == ASTCorrectorExpressionPass.self)
        XCTAssert(source.syntaxNodePasses[8] == EnumRewriterExpressionPass.self)
    }
}
