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
    
    func testNSArrayDefinition() {
        let type = FoundationCompoundTypes.nsArray.create()
        
        assertSignature(type: type, matches: """
            class NSArray: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                
                // Convert from objectAtIndex(_ index: Int) -> Any
                func object(at index: Int) -> Any
                
                // Convert from containsObject(_ anObject: Any) -> Bool
                func contains(_ anObject: Any) -> Bool
            }
            """)
    }
    
    func testNSMutableArrayDefinition() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        
        assertSignature(type: type, matches: """
            class NSMutableArray: NSArray {
                // Convert from addObject(_ anObject: Any)
                func add(_ anObject: Any)
                
                // Convert from addObjectsFromArray(_ otherArray: [Any])
                func addObjects(from otherArray: [Any])
                
                // Convert from removeObject(_ anObject: Any)
                func remove(_ anObject: Any)
            }
            """)
    }
}
