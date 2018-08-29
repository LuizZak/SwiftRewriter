import XCTest
import ExpressionPasses

class DefaultExpressionPassesTests: XCTestCase {
    func testDefaultExpressionPasses() {
        let source = DefaultExpressionPasses()
        var passes = source.syntaxNodePasses.makeIterator()
        
        XCTAssertEqual(source.syntaxNodePasses.count, 14)
        
        XCTAssert(passes.next() == CanonicalNameExpressionPass.self)
        XCTAssert(passes.next() == AllocInitExpressionPass.self)
        XCTAssert(passes.next() == InitRewriterExpressionPass.self)
        XCTAssert(passes.next() == ASTSimplifier.self)
        XCTAssert(passes.next() == CoreGraphicsExpressionPass.self)
        XCTAssert(passes.next() == FoundationExpressionPass.self)
        XCTAssert(passes.next() == UIKitExpressionPass.self)
        XCTAssert(passes.next() == NilValueTransformationsPass.self)
        XCTAssert(passes.next() == NumberCommonsExpressionPass.self)
        XCTAssert(passes.next() == ASTCorrectorExpressionPass.self)
        XCTAssert(passes.next() == NumberCommonsExpressionPass.self)
        XCTAssert(passes.next() == EnumRewriterExpressionPass.self)
        XCTAssert(passes.next() == ConstantDetectionExpressionPass.self)
        XCTAssert(passes.next() == ASTSimplifier.self)
    }
}
