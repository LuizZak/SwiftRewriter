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
                
                // Convert from dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?
                func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
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
    
    func testNSDateFormatterDefinition() {
        let type = FoundationCompoundTypes.nsDateFormatter.create()
        
        assertSignature(type: type, matches: """
            class DateFormatter: Formatter {
                // Convert from func dateFormat() / func setDateFormat(String!)
                var dateFormat: String!
                
                
                // Convert from stringFromDate(_ date: Date) -> String
                func string(from date: Date) -> String
                
                // Convert from dateFromString(_ date: Date) -> Date?
                func date(from string: Date) -> Date?
            }
            """)
    }
    
    func testNSDateDefinition() {
        let type = FoundationCompoundTypes.nsDate.create()
        
        assertSignature(type: type, matches: """
            struct Date: Hashable, Equatable {
                var timeIntervalSince1970: TimeInterval
                
                init()
                // Convert from dateByAddingTimeInterval(_ timeInterval: TimeInterval) -> Date
                func addingTimeInterval(_ timeInterval: TimeInterval) -> Date
            }
            """)
    }
    
    func testNSLocaleDefinition() {
        let type = FoundationCompoundTypes.nsLocale.create()
        
        assertSignature(type: type, matches: """
            struct Locale: Hashable, Equatable {
                // Convert from 'init(localeIdentifier: String)'
                init(identifier: String)
            }
            """)
    }
}
