import XCTest
import GlobalsProviders

class DefaultGlobalsProvidersSourceTests: XCTestCase {
    
    func testDefaultProviders() {
        let sut = DefaultGlobalsProvidersSource()
        var providers = sut.globalsProviders.makeIterator()
        
        XCTAssert(providers.next() is CLibGlobalsProviders)
        XCTAssert(providers.next() is UIKitGlobalsProvider)
        XCTAssert(providers.next() is OpenGLESGlobalsProvider)
        XCTAssert(providers.next() is CompoundedMappingTypesGlobalsProvider)
        XCTAssertNil(providers.next())
    }
}
