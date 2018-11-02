import XCTest
@testable import ObjcParser

// TODO: Refactor these tests; they don't make much sense since SourceLocation was
// refactored with a struct with just line/column indexes
class ObjcLexerTests: XCTestCase {
    func testStartRange() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        
        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }
    
    func testStartRangeAfterInvokingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        _=sut.token()
        let range = sut.startRange()
        
        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }
    
    func testStartRangeNextToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        _=sut.nextToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }
    
    func testStartRangeSkippingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        sut.skipToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }
    
    func testStartRangeSkippingTokenAfterConsumingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        _=sut.token() // Consume a token to force-parse it
        let range = sut.startRange()
        sut.skipToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().line, 1)
        XCTAssertEqual(range.makeLocation().column, 1)
    }
    
    private func makeLexer(_ str: String) -> ObjcLexer {
        let src = StringCodeSource(source: str)
        return ObjcLexer(source: src)
    }
}
