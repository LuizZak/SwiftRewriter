import XCTest
import Commons
import SwiftRewriterLib
import Utils

class FoundationCompoundTypesTests: XCTestCase {

    func testCalendarDefinition() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        
        assertSignature(type: type, matches: """
            class Calendar: NSObject {
                // Convert from component(_ component: Calendar.Component, fromDate date: Date) -> Int
                func component(_ component: Calendar.Component, from date: Date) -> Int
            }
            """)
    }

}
