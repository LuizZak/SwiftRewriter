import XCTest
import SwiftRewriterLib
import GlobalsProviders

class CLibGlobalsProvidersTests: XCTestCase {
    var sut: CLibGlobalsProviders!
    var globals: GlobalDefinitions!
    
    override func setUp() {
        super.setUp()
        
        globals = GlobalDefinitions()
        sut = CLibGlobalsProviders()
        
        sut.registerDefinitions(on: globals)
    }
}
