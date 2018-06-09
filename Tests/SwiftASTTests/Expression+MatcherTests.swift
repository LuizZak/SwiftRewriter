import XCTest
import SwiftAST

class Expression_MatcherTests: XCTestCase {
    
    func testMatchCall() {
        let matchTypeNew = Expression.matcher(ident("Type").call("new"))
        
        XCTAssert(matchTypeNew.matches(Expression.identifier("Type").dot("new").call()))
        XCTAssertFalse(matchTypeNew.matches(Expression.identifier("Type").dot("new")))
        XCTAssertFalse(matchTypeNew.matches(Expression.identifier("Type").call()))
    }
    
}
