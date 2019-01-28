import XCTest
import SwiftAST
import SwiftRewriterLib
import Commons

class CompoundedMappingTypeListTests: XCTestCase {
    func testTypeDefinitions() {
        let types = CompoundedMappingTypeList.typeList()
        var iterator = types.makeIterator()
        
        XCTAssertEqual(iterator.next()?.typeName, "Calendar")
        XCTAssertEqual(iterator.next()?.typeName, "NSArray")
        XCTAssertEqual(iterator.next()?.typeName, "NSMutableArray")
        XCTAssertEqual(iterator.next()?.typeName, "DateFormatter")
        XCTAssertEqual(iterator.next()?.typeName, "Date")
        XCTAssertEqual(iterator.next()?.typeName, "Locale")
        XCTAssertEqual(iterator.next()?.typeName, "NSString")
        XCTAssertEqual(iterator.next()?.typeName, "NSMutableString")
        XCTAssertEqual(iterator.next()?.typeName, "CGSize")
        XCTAssertEqual(iterator.next()?.typeName, "CGPoint")
        XCTAssertEqual(iterator.next()?.typeName, "CGRect")
        XCTAssertEqual(iterator.next()?.typeName, "UIResponder")
        XCTAssertEqual(iterator.next()?.typeName, "UIView")
        XCTAssertEqual(iterator.next()?.typeName, "UIColor")
        XCTAssertEqual(iterator.next()?.typeName, "UIGestureRecognizer")
        XCTAssertEqual(iterator.next()?.typeName, "UILabel")
        XCTAssertEqual(iterator.next()?.typeName, "UIViewController")
        XCTAssertEqual(iterator.next()?.typeName, "Array")
        XCTAssertNil(iterator.next())
    }
}
