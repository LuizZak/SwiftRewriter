import XCTest
@testable import ObjcParser
import GrammarModels

class ObjcParserTests: XCTestCase {
    func testInit() {
        _=ObjcParser(string: "abc")
    }
    
    static var allTests = [
        ("testInit", testInit),
    ]
}
