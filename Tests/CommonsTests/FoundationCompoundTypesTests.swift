import XCTest
import Commons
import SwiftRewriterLib
import Utils

class FoundationCompoundTypesTests: XCTestCase {

    func testCalendarDefinition() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        
        assertSignature(type: type, matches: """
            class Calendar: NSObject {
                @_swiftrewriter(mapFrom: component(_ component: Calendar.Component, fromDate date: Date) -> Int)
                func component(_ component: Calendar.Component, from date: Date) -> Int
                
                @_swiftrewriter(mapFrom: dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?)
                func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
            }
            """)
    }
    
    func testNSArrayDefinition() {
        let type = FoundationCompoundTypes.nsArray.create()
        
        assertSignature(type: type, matches: """
            class NSArray: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                // Convert from func firstObject()
                var firstObject: Any? { get }
                
                // Convert from func lastObject()
                var lastObject: Any? { get }
                
                
                @_swiftrewriter(mapFrom: objectAtIndex(_ index: Int) -> Any)
                func object(at index: Int) -> Any
                
                @_swiftrewriter(mapFrom: containsObject(_ anObject: Any) -> Bool)
                func contains(_ anObject: Any) -> Bool
            }
            """)
    }
    
    func testNSMutableArrayDefinition() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        
        assertSignature(type: type, matches: """
            class NSMutableArray: NSArray {
                @_swiftrewriter(mapFrom: addObject(_ anObject: Any))
                func add(_ anObject: Any)
                
                @_swiftrewriter(mapFrom: addObjectsFromArray(_ otherArray: [Any]))
                func addObjects(from otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObject(_ anObject: Any))
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
                
                
                @_swiftrewriter(mapFrom: stringFromDate(_ date: Date) -> String)
                func string(from date: Date) -> String
                
                @_swiftrewriter(mapFrom: dateFromString(_ date: Date) -> Date?)
                func date(from string: Date) -> Date?
            }
            """)
    }
    
    func testNSDateDefinition() {
        let type = FoundationCompoundTypes.nsDate.create()
        
        assertSignature(type: type, matches: """
            struct Date: Hashable, Equatable {
                var timeIntervalSince1970: TimeInterval
                
                // Convert from 'static date() -> Date'
                init()
                static func date() -> Date
                
                @_swiftrewriter(mapFrom: dateByAddingTimeInterval(_ timeInterval: TimeInterval) -> Date)
                func addingTimeInterval(_ timeInterval: TimeInterval) -> Date
                
                @_swiftrewriter(mapFrom: timeIntervalSinceDate(_ date: Date) -> TimeInterval)
                func timeIntervalSince(_ date: Date) -> TimeInterval
                
                // Convert to binary operator '=='
                func isEqual(_ other: AnyObject) -> Bool
                
                // Convert to binary operator '=='
                func isEqualToDate(_ other: Date) -> Bool
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
