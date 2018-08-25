import XCTest
import GlobalsProviders
import SwiftRewriterLib

class FoundationGlobalsProviderTests: BaseGlobalsProviderTestCase {

    override func setUp() {
        super.setUp()
        
        sut = FoundationGlobalsProvider()
        
        globals = sut.definitionsSource()
        types = sut.knownTypeProvider()
        typealiases = sut.typealiasProvider()
    }
    
    func testDefinedNSArray() {
        assertDefined(typeName: "NSArray")
    }
    
    func testDefinedNSMutableArray() {
        assertDefined(typeName: "NSMutableArray")
    }
    
    func testDefinedCalendar() {
        assertDefined(typeName: "Calendar")
    }
    
    func testDefinedDateFormatter() {
        assertDefined(typeName: "DateFormatter")
    }
    
    func testDefinedDate() {
        assertDefined(typeName: "Date")
    }
    
    func testDefinedLocale() {
        assertDefined(typeName: "Locale")
        assertDefined(canonicalTypeName: "Locale", forNonCanon: "NSLocale")
    }

}
