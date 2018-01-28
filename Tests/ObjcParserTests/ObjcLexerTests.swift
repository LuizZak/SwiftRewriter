import XCTest
@testable import ObjcParser

class ObjcLexerTests: XCTestCase {
    func testStartRange() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        
        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().range, .location(source.startIndex))
    }
    
    func testStartRangeAfterInvokingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        _=sut.token()
        let range = sut.startRange()
        
        XCTAssertEqual(range.makeString(), "")
        XCTAssertEqual(range.makeLocation().range, .location(source.startIndex))
    }
    
    func testStartRangeNextToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        _=sut.nextToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().range,
                       .range(source.startIndex..<source.index(source.startIndex, offsetBy: 4)))
    }
    
    func testStartRangeSkippingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        let range = sut.startRange()
        sut.skipToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().range,
                       .range(source.startIndex..<source.index(source.startIndex, offsetBy: 4)))
    }
    
    func testStartRangeSkippingTokenAfterConsumingToken() {
        let source = "@end abc def"
        let sut = makeLexer(source)
        
        _=sut.token() // Consume a token to force-parse it
        let range = sut.startRange()
        sut.skipToken()
        
        XCTAssertEqual(range.makeString(), "@end")
        XCTAssertEqual(range.makeLocation().range,
                       .range(source.startIndex..<source.index(source.startIndex, offsetBy: 4)))
    }
    
    private func makeLexer(_ str: String) -> ObjcLexer {
        let src = StringCodeSource(source: str)
        return ObjcLexer(source: src)
    }
}
