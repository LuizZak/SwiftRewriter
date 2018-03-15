import XCTest
import GlobalsProviders

class DefaultGlobalsProvidersSourceTests: XCTestCase {
    func testDefaultProviders() {
        let sut = DefaultGlobalsProvidersSource()
        var providers = sut.globalsProviders.makeIterator()
        
        XCTAssertEqual(sut.globalsProviders.count, 0)
        XCTAssertNil(providers.next())
    }
}
