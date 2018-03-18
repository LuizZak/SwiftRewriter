import XCTest
import GlobalsProviders

class DefaultGlobalsProvidersSourceTests: XCTestCase {
    func testDefaultProviders() {
        let sut = DefaultGlobalsProvidersSource()
        var providers = sut.globalsProviders.makeIterator()
        
        XCTAssertEqual(sut.globalsProviders.count, 3)
        XCTAssert(providers.next() is CLibGlobalsProviders)
        XCTAssert(providers.next() is CoreGraphicsGlobalsProvider)
        XCTAssert(providers.next() is UIKitGlobalsProvider)
    }
}
